/*
 * database.c - Functions for dealing with the device database.
 *
 * This file is a part of Minipro.
 *
 * Minipro is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * Minipro is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 */
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <ctype.h>
#include <errno.h>
#include <zlib.h>
#include "b64/cencode.h"
#include "b64/cdecode.h"
#include "xml.h"
#include "database.h"

#ifdef _WIN32
#include <Shlobj.h>
#include <shlwapi.h>
#define STRCASESTR StrStrIA
#else
#define STRCASESTR strcasestr
#endif

/* flags */
#define MP_REVERSED_PACKAGE	 0x00000002
#define MP_ERASE_MASK		 0x00000010
#define MP_ID_MASK		 0x00000020
#define MP_DATA_MEMORY_ADDRESS	 0x00001000
#define MP_DATA_BUS_WIDTH	 0x00002000
#define MP_OFF_PROTECT_BEFORE	 0x00004000
#define MP_PROTECT_AFTER	 0x00008000
#define MP_LOCK_BIT_WRITE_ONLY	 0x00040000
#define MP_CALIBRATION		 0x00080000
#define MP_SUPPORTED_PROGRAMMING 0x00300000
#define MP_DATA_ORG		 0x03000000

/* Opts chip_info */
#define MP_VOLTAGES1		 0x0006
#define MP_VOLTAGES2		 0x0007

/* Package mask */
#define PLCC_MASK		 0xFF000000
#define ADAPTER_MASK		 0x000000FF
#define ICSP_MASK		 0x0000FF00
#define PIN_COUNT_MASK		 0X7F000000
#define SMD_MASK		 0X80000000
#define PLCC32_ADAPTER		 0xFF000000
#define PLCC44_ADAPTER		 0xFD000000

/* Supported programmers flags */
#define T56_FLAG		 0x10000000
#define TL866II_FLAG		 0x20000000
#define T48_FLAG		 0x40000000
#define DEVICE_MASK		 (T56_FLAG | T48_FLAG | TL866II_FLAG)

#define ALGO_CRC_OFFSET		 0x04
#define ALGO_DATA_OFFSET	 0x08

/* infoic.xml name and tag names */
#define INFOIC_NAME		 "infoic.xml"
#define LOGICIC_NAME		 "logicic.xml"
#define ALGO_NAME		 "algorithm.xml"
#define DB_TAG			 "database"
#define TYPE_ATTR		 "type"
#define MANUF_TAG		 "manufacturer"
#define CUSTOM_TAG		 "custom"
#define IC_TAG			 "ic"
#define VECTOR_TAG		 "vector"
#define NAME_ATTR		 "name"
#define FUSE_ATTR		 "config"
#define VOLTAGE_ATTR		 "voltage"
#define INFOIC_ATTR_NAME	 "INFOIC"
#define INFOIC2PLUS_ATTR_NAME	 "INFOIC2PLUS"
#define LOGIC_ATTR_NAME		 "LOGIC"
#define ALGO_ATTR_NAME		 "ALGORITHMS"
#define ALGOS_TAG		 "algorithms_t56"
#define ALGO_TAG		 "algorithm"
#define CFGS_TAG		 "configurations"
#define MAPS_TAG		 "maps"
#define MAP_TAG			 "map"
#define GND_TAG			 "gnd"
#define MASK_TAG		 "mask"
#define CFG_TAG			 "config"
#define FUSES_TAG		 "fuses"
#define LOCKS_TAG		 "locks"
#define ACW_BITS		 "acw_bits"
#define COUNT_ATTR		 "count"

#define INFOIC_DATABASE		 0x01
#define INFOIC2PLUS_DATABASE	 0x02
#define LOGIC_DATABASE		 0x03
#define ALGORITHM_DATABASE	 0x04

#define CUSTOM_PROTOCOL_MASK	 0x80000000
#define MCU_CHIP		 0
#define PLD_CHIP		 1

#define CONFIG			 ((fuse_decl_t *)(device->config))

/* State machine structure used by sax device parser callback function
 * for persistent data between calls.
 */
typedef struct state_machine_d {
	device_t *device;
	int db_version;
	int custom;
	int print_name;
	int count_only;
	int found;
	int found_count;
	int match_id;
	int skip;
	db_data_t *db_data;
	uint32_t infoic_count;
	uint32_t infoic_custom_count;
	uint32_t infoic2_count;
	uint32_t infoic2_custom_count;
	uint32_t tl866ii_count;
	uint32_t tl866ii_custom_count;
	uint32_t t48_count;
	uint32_t t48_custom_count;
	uint32_t t56_count;
	uint32_t t56_custom_count;
	uint32_t logic_count;
	uint32_t logic_custom_count;
	uint8_t load_vectors;
} state_machine_d_t;

/* State machine structure used by sax profile parser callback function
 * for persistent data between calls.
 */
typedef struct state_machine_p {
	int has_profile;
	int found;
	int skip;
	uint8_t type;
	size_t cur_fuse;
	size_t cur_lock;
	char name[40];
	void *config;
	db_data_t *db_data;
} state_machine_p_t;

/* State machine structure used by sax pin map parser callback function
 * for persistent data between calls.
 */
typedef struct state_machine_m {
	int has_map;
	int found;
	int skip;
	pin_map_t *map;
	db_data_t *db_data;
} state_machine_m_t;

/* State machine structure used by sax algorithm parser callback function
 * for persistent data between calls.
 */
typedef struct state_machine_a {
	int has_algo;
	int found;
	int skip;
	char *base64_data;
	db_data_t *db_data;
} state_machine_a_t;

/* T56 algorithm prefixes table mapped to protocol_id.
 * The final name is computed at runtime.
 */
static const char t56_algo_table[][16] = {
/*	 0x01		 0x02	   	0x03	  0x04 		  0x05       0x06		*/
	"IIC24C",	"MW93ALG", "SPI25F", "AT45D",	 "F29EE",   "W29F32P",

/*	 0x07		 0x08	   	0x09	  0x0A 		  0x0B       0x0C		*/
	"ROM28P",	"ROM32P",  "ROM40P", "R28TO32P", "ROM24P",  "ROM44",

/*	 0x0D		 0x0E	   	0x0F	  0x10 		  0x11       0x12		*/
	"EE28C32P", "RAM32",   "SPI25F", "28F32P",	 "FWH",	    "T48",

/*	 0x13		 0x14	   	0x15	  0x16 		  0x17       0x18		*/
	"T40A",		"T40B",    "T88V",   "PIC32X",	 "P18F87J", "P16F",

/*	 0x19		 0x1A	   	0x1B	  0x1C 		  0x1D       0x1E		*/
	"P18F2",	"P16F5X",  "P16CX",  "", 		 "ATMGA_",  "ATTINY_",

/*	 0x1F		 0x20	   	0x21	  0x22 		  0x23       0x24		*/
	"AT89P20_", "",	       "AT89C_", "P87C_",	 "SST89_",  "W78E_",

/*	 0x25		 0x26	   	0x27	  0x28 		  0x29       0x2A		*/
	"",	  	  	"",	       "ROM24P", "ROM28P",	 "RAM32",   "GAL16",

/*	 0x2B		 0x2C	   	0x2D	  0x2E 		  0x2F       0x30		*/
	"GAL20",	"GAL22",   "NAND_",  "PIC32X", 	 "RAM36",   "KB90",

/*	 0x31		 0x32	   	0x33	  0x34 		  0x35 					*/
	"EMMC_",	"VGA_",    "CPLD_",  "GEN_", 	 "ITE_"
};

/*
 * T56  utility algorithms name table used for various tasks.
 */
static const char t56_util_table[][16] = {
	"TTL1",	       "TTL2",	       "Pindect100M",  "STGND",
	"StPVGI",      "uart_vga",     "vga_11",       "vga_21",
	"vga1024x768", "vga1152x864",  "vga1280x1024", "vga1280x800",
	"vga1440x900", "vga1920x1080", "vga640x480",   "vga800x600",
	"vga_hdmi"
};

#define ALGO_COUNT (sizeof((t56_algo_table))/(sizeof(t56_algo_table[0])))
#define UTIL_COUNT (sizeof((t56_util_table))/(sizeof(t56_util_table[0])))


static int parse_profiles(state_machine_p_t *);

/* return pin count from package_details */
static uint32_t get_pin_count(uint32_t package_details)
{
	if ((package_details & PLCC_MASK) == PLCC32_ADAPTER)
		return 32;
	else if ((package_details & PLCC_MASK) == PLCC44_ADAPTER)
		return 44;
	return ((package_details & PIN_COUNT_MASK) >> 24);
}

/* Parse a numeric 32 bit value from an attribute */
static int get_attr_value(const char *xml, size_t size, char *attr_name,
			  uint32_t *value)
{
	Memblock memblock = get_attribute(xml, size, attr_name);
	if (!memblock.b || !memblock.z) {
		return ERREND;
	}

	errno = EXIT_SUCCESS;
	char *attr = strndup(memblock.b, memblock.z);
	*value = strtoul(attr, NULL, 0);
	free(attr);
	return errno;
}

/* Match the whole 'str' string in a 'tag' text stream.
 * For ex. if 'tag' = "configurations>\n" or "<configurations"
 * and if we compare with 'str' =  "configurations" the result is
 * true in both cases. Strings like "conf", "config" and so on will return
 * false. The comparison is case insensitive.
 */
static int tagcmpn(const char *tag, size_t taglen, const char *str)
{
	if (!tag || !str || !taglen)
		return 1;

	/* Find the start of substring */
	for (; taglen; taglen--, tag++) {
		if (isprint(*tag) && !isspace(*tag))
			break;
	}

	/* Find the end of substring */
	size_t len = 0;
	for (; taglen; taglen--, len++) {
		if (iscntrl(tag[len]) || isspace(tag[len]))
			break;
	}

	if (!len || len < strlen(str))
		return 1;
	return strncasecmp(tag, str, len);
}

/* Parse comma separated values from an element tag
 * There should be at least 'size' values otherwise
 * an error is returned.
 */
static int get_csv(const char *tag, size_t taglen, char *elem_name,
		   uint16_t *out, size_t size)
{
	if (tagcmpn(tag, taglen, elem_name))
		return EXIT_FAILURE;

	/* Find start of the element data */
	char *list = strchr(tag, '>') + 1;
	char *endtag = strchr(tag, '<');
	*endtag = '\0';
	char *endptr;

	/* Parse each token */
	int i = 0;
	char *token = strchr(list, ',');
	while (i < size && list < endtag) {
		if (token)
			*token = '\0';
		errno = 0;
		uint32_t value = strtoul(list, &endptr, 0);
		if (errno || value > UINT16_MAX) {
			return EXIT_FAILURE;
		}
		out[i] = (uint16_t)value;
		list = endptr + 1;
		token = strchr(list, ',');
		i++;
	}

	/* restore end tag */
	*endtag = '<';

	if (size != i)
		return EXIT_FAILURE;
	return EXIT_SUCCESS;
}

/* Print comma separated names  */
static size_t print_chip_names(Memblock *memblock, const char *filter,
			       int custom)
{
	size_t count = 0;
	char *list = strndup((char *)memblock->b, memblock->z);
	char *token = strtok(list, ",");
	while (token) {
		if (!filter || STRCASESTR(token, filter))
			fprintf(stdout, "%s%s\n", token,
				custom == 1 ? "(custom)" : "");
		token = strtok(NULL, ",");
		count++;
	}
	free(list);
	return count;
}

/* Get the count of comma separated names  */
static size_t get_chip_count(Memblock *memblock)
{
	size_t count = 1;
	const char *list = memblock->b;
	const char *end = memblock->b + memblock->z;
	if (list == end)
		return 0;
	for (; list < end; list++) {
		if (*list == ',')
			count++;
	}
	return count;
}

/* Search the chip name in a comma separated names */
static char *search_chip_name(Memblock *memblock, const char *name)
{
	char *list = strndup((char *)memblock->b, memblock->z);
	char *token = strtok(list, ",");
	while (token) {
		if (!strcasecmp(token, name)){
		  char *name = strdup(token);
		  free(list);
		  return name;
		}
		token = strtok(NULL, ",");
	}
	free(list);
	return NULL;
}

/* Calculate chip ID bytes count from chip ID */
static uint8_t get_id_bytes_count(uint32_t chip_id)
{
	if (!chip_id)
		return 0;
	uint8_t count = 4;
	uint32_t mask[] = { 0xff, 0xff00, 0xff0000, 0xff000000 };
	while (count--) {
		if (chip_id & mask[count])
			break;
	}
	return count + 1;
}

/* Load a device from an xml 'ic' tag */
static int load_mem_device(db_data_t *db_data, const char *xml_device,
			   size_t size, device_t *device, uint8_t version)
{
	int err = 0;
	uint32_t voltages, protocol_id, flags, opts, read_bufer_size,
		write_buffer_size;
	Memblock memblock;

	err += get_attr_value(xml_device, size, "type", &device->chip_type);
	err += get_attr_value(xml_device, size, "protocol_id", &protocol_id);
	err += get_attr_value(xml_device, size, "variant", &device->variant);
	err += get_attr_value(xml_device, size, "read_buffer_size",
			      &read_bufer_size);
	err += get_attr_value(xml_device, size, "write_buffer_size",
			      &write_buffer_size);
	device->read_buffer_size = (uint16_t)read_bufer_size;
	device->write_buffer_size = (uint16_t)write_buffer_size;
	err += get_attr_value(xml_device, size, "code_memory_size",
			      &device->code_memory_size);
	err += get_attr_value(xml_device, size, "data_memory_size",
			      &device->data_memory_size);
	err += get_attr_value(xml_device, size, "data_memory2_size",
			      &device->data_memory2_size);
	err += get_attr_value(xml_device, size, "page_size",
			      &device->page_size);
	err += get_attr_value(xml_device, size, "chip_id", &device->chip_id);
	err += get_attr_value(xml_device, size, "voltages", &voltages);
	err += get_attr_value(xml_device, size, "pulse_delay",
			      &device->pulse_delay);
	err += get_attr_value(xml_device, size, "flags", &flags);
	err += get_attr_value(xml_device, size, "chip_info",
			      &device->chip_info);
	if (version == INFOIC2PLUS_DATABASE) {
		err += get_attr_value(xml_device, size, "pin_map", &opts);
		err += get_attr_value(xml_device, size, "pages_per_block",
				      &device->pages_per_block);
		device->tl866_only = (opts & TL866II_FLAG) ? 1 : 0;
		device->t48_only = (opts & T48_FLAG) ? 1 : 0;
		device->t56_only = (opts & T56_FLAG) ? 1 : 0;
		device->pin_map = (uint8_t)opts;
	}
	err += get_attr_value(xml_device, size, "package_details",
			      &device->package_details.packed_package);

	if (err)
		return EXIT_FAILURE;

	/* get blank value if present */
	uint32_t blank_value;
	device->blank_value = get_attr_value(xml_device, size, "blank_value",
					     &blank_value) == EXIT_SUCCESS ?
				      (uint8_t)blank_value :
				      0xff;

	/* Get chip_ID bytes count */
	device->chip_id_bytes_count = get_id_bytes_count(device->chip_id);

	/* Parse configuration name */
	memblock = get_attribute(xml_device, size, FUSE_ATTR);
	if (!memblock.b)
		return EXIT_FAILURE;

	/* Check if there's a configuration name */
	if (tagcmpn(memblock.b, memblock.z, "null")) {
		/* Initialize parser state machine */
		state_machine_p_t sm;
		memset(&sm, 0, sizeof(sm));
		memcpy(sm.name, memblock.b, memblock.z);
		sm.db_data = db_data;

		err = parse_profiles(&sm);
		if (err)
			return EXIT_FAILURE;
		if (!sm.config) {
			fprintf(stderr, "No %s configuration was found.\n",
				sm.name);
			return EXIT_FAILURE;
		}
		device->config = sm.config;
	}

	/* Unpack flags */
	device->flags.raw_flags = flags;
	device->flags.can_erase = (flags & MP_ERASE_MASK) ? 1 : 0;
	device->flags.has_chip_id = (flags & MP_ID_MASK) ? 1 : 0;
	device->flags.has_data_offset = (flags & MP_DATA_MEMORY_ADDRESS) ? 1 :
									   0;
	device->flags.has_word = (flags & MP_DATA_BUS_WIDTH) ? 1 : 0;
	device->flags.off_protect_before = (flags & MP_OFF_PROTECT_BEFORE) ? 1 :
									     0;
	device->flags.protect_after = (flags & MP_PROTECT_AFTER) ? 1 : 0;
	device->flags.lock_bit_write_only =
		(flags & MP_LOCK_BIT_WRITE_ONLY) ? 1 : 0;
	device->flags.has_calibration = (flags & MP_CALIBRATION) ? 1 : 0;
	device->flags.prog_support = (flags & MP_SUPPORTED_PROGRAMMING) >> 20;
	device->flags.data_org = (flags & MP_DATA_ORG) >> 24;
	device->flags.word_size = (flags & MP_DATA_ORG) == 0x01000000 ? 2 : 1;
	device->flags.can_adjust_vcc = device->chip_info == MP_VOLTAGES1 ? 1 :
									   0;
	device->flags.can_adjust_vpp = device->chip_info == MP_VOLTAGES2 ? 1 :
									   0;
	device->flags.has_power_down =
		(voltages & LAST_JEDEC_BIT_IS_POWERDOWN_ENABLE) != 0;
	device->flags.is_powerdown_disabled =
		(voltages & POWERDOWN_MODE_DISABLE) != 0;
	device->flags.reversed_package = (flags & MP_REVERSED_PACKAGE) ? 1 : 0;

	/* Check for custom defined protocol */
	device->protocol_id = (uint8_t)protocol_id;
	if (protocol_id & CUSTOM_PROTOCOL_MASK) {
		device->flags.custom_protocol = 1;
	}

	if (device->flags.custom_protocol && device->protocol_id == CP_PROM)
		device->flags.prog_support = MP_READ_ONLY;

	/* Unpack voltages */
	device->voltages.raw_voltages = voltages;
	device->voltages.vdd = (voltages >> 12) & 0x0f;
	device->voltages.vcc = (voltages >> 8) & 0x0f;
	device->voltages.vpp = voltages & 0xff;

	/* Unpacking package details */
	device->package_details.pin_count =
		get_pin_count(device->package_details.packed_package);
	device->package_details.adapter =
		device->package_details.packed_package & ADAPTER_MASK;
	device->package_details.icsp =
		(device->package_details.packed_package & ICSP_MASK) >> 8;

	/* Fill some device parameters */
	device->compare_mask = 0xff;
	switch (device->chip_info) {
	/* PIC baseline devices */
	case PIC_INSTR_WORD_WIDTH_12:
		device->compare_mask = 0x0fff;
		break;

	/* PIC midrange/standard devices */
	case PIC_INSTR_WORD_WIDTH_14:
		device->compare_mask = 0x3fff;
		if (CONFIG) {
			CONFIG->rev_bits = 5;
		}
		break;

	/* PIC 18F/18F_J devices */
	case PIC_INSTR_WORD_WIDTH_16_PIC18F:
	case PIC_INSTR_WORD_WIDTH_16_PIC18J:
		device->compare_mask = 0xffff;
		device->flags.word_size = 2;
		device->flags.has_word = 1;

		/* This will tell us if PIC user id is 8bit or more */
		device->flags.data_org = 0; /* User ID is 8 bit */
		if (CONFIG) {
			CONFIG->rev_bits =
				device->chip_info ==
						PIC_INSTR_WORD_WIDTH_16_PIC18F ?
					4 :
					5;
		}
		break;
	}
	return EXIT_SUCCESS;
}

/* Load a device from an xml 'ic' tag */
static int load_logic_device(const char *xml_device, size_t size,
			     device_t *device)
{
	Memblock voltage = get_attribute(xml_device, size, VOLTAGE_ATTR);
	if (!voltage.b)
		return EXIT_FAILURE;

	if (!tagcmpn(voltage.b, voltage.z, "5V"))
		device->voltages.vcc = 0;
	else if (!tagcmpn(voltage.b, voltage.z, "3V3"))
		device->voltages.vcc = 1;
	else if (!tagcmpn(voltage.b, voltage.z, "2V5"))
		device->voltages.vcc = 2;
	else if (!tagcmpn(voltage.b, voltage.z, "1V8"))
		device->voltages.vcc = 3;
	else
		return EXIT_FAILURE;

	uint32_t pin_count;
	if (get_attr_value(xml_device, size, "pins", &pin_count))
		return EXIT_FAILURE;
	device->package_details.pin_count = pin_count;
	return EXIT_SUCCESS;
}

/* Load a device from an xml 'ic' tag */
static int load_device(db_data_t *db_data, const char *xml_device, size_t size,
		       device_t *device, uint8_t version)
{
	if (get_attr_value(xml_device, size, "type", &device->chip_type))
		return EXIT_FAILURE;
	int ret;
	if (device->chip_type == MP_LOGIC) {
		ret = load_logic_device(xml_device, size, device);
	} else {
		ret = load_mem_device(db_data, xml_device, size, device,
				      version);
	}
	return ret;
}

/* Compare a device by protocol ID/device ID or protocol ID/package
 */
static int compare_device(const char *xml_device, size_t size,
			  state_machine_d_t *sm)
{
	/* Exit if we search through logic.xml */
	if (sm->db_version == LOGIC_DATABASE)
		return EXIT_SUCCESS;

	uint32_t protocol_id, package_details;
	uint32_t chip_id;
	int err = get_attr_value(xml_device, size, "protocol_id", &protocol_id);
	if (err && err != ERREND)
		return EXIT_FAILURE;
	err = get_attr_value(xml_device, size, "chip_id", &chip_id);
	if (err && err != ERREND)
		return EXIT_FAILURE;
	err = get_attr_value(xml_device, size, "package_details",
			     &package_details);
	if (err && err != ERREND)
		return EXIT_FAILURE;

	uint8_t chip_id_bytes_count = get_id_bytes_count(chip_id);

	uint32_t pin_count = get_pin_count(package_details);
	uint8_t match_package =
		sm->device->package_details.pin_count ?
			(sm->device->package_details.pin_count == pin_count) :
			1;

	if (chip_id && chip_id_bytes_count && match_package &&
	    sm->device->chip_id && sm->device->chip_id == chip_id &&
	    (match_package ||
	     sm->device->protocol_id == (uint8_t)protocol_id)) {
		sm->found = 1;
	}
	return EXIT_SUCCESS;
}

/* XML algorithm SAX parser handler. Each xml tag pair is dispatched here.
 * The persistent state machine data are kept in parser->userdata structure
 */
static int algo_callback(int type, const char *tag, size_t taglen,
			 Parser *parser)
{
	state_machine_a_t *sm = parser->userdata;
	Memblock mb;

	/* If needed algorithm is found and parsed or we reached the end of
	 * section skip until EOF
	 */
	if (sm->found)
		return XML_OK;

	switch (type) {
	case OPENTAG_:
	case SELFCLOSE_:
		/* Search for 'database' tag */
		if (!tagcmpn(tag, taglen, DB_TAG)) {
			/* Grab the device name */
			mb = get_attribute(tag, taglen, TYPE_ATTR);
			if (!mb.b)
				return EXIT_FAILURE;

			/* skip if 'ALGORITHMS' attribute is not found */
			if (!tagcmpn(mb.b, mb.z, ALGO_ATTR_NAME))
				return XML_OK;
		}

		/* skip until an 'algorithm' tag is found */
		if (!tagcmpn(tag, taglen, ALGOS_TAG)) {
			sm->has_algo = 1;
			return XML_OK;
		}

		/* Found an algorithm entry */
		if (sm->has_algo && !sm->found &&
		    !tagcmpn(tag, taglen, ALGO_TAG)) {
			/* Grab the device name */
			mb = get_attribute(tag, taglen, NAME_ATTR);
			if (!mb.b)
				return EXIT_FAILURE;
			if (!tagcmpn(mb.b, mb.z, sm->db_data->device_name)) {
				/* get the bitstream entry*/
				mb = get_attribute(tag, taglen, "bitstream");
				if (!mb.b || !mb.z)
					return EXIT_FAILURE;

				/* Copy base64 string */
				sm->base64_data = strndup(mb.b, mb.z);
				if (!sm->base64_data)
					return ERRMEM;
				sm->found = 1;
				return XML_OK;
			}
		}
	}
	return XML_OK;
}

/* XML pin map SAX parser handler. Each xml tag pair is dispatched here.
 * The persistent state machine data are kept in parser->userdata structure
 */
static int map_callback(int type, const char *tag, size_t taglen,
			Parser *parser)
{
	state_machine_m_t *sm = parser->userdata;
	uint32_t gnd_count, mask_count;

	/* If needed pin map is found and parsed or we reached the end of
	 * section skip until EOF
	 */
	if (sm->skip || sm->found == 3)
		return XML_OK;
	switch (type) {
	case OPENTAG_:
		/* Search for 'maps' tag */
		if (!tagcmpn(tag, taglen, MAPS_TAG))
			sm->has_map = 1;
		if (!sm->has_map)
			return XML_OK;

		/* If map was allocated search for gnd/mask tag */
		if (sm->map) {
			/* get gnd count */
			if ((!sm->found || sm->found == 2) &&
			    !tagcmpn(tag, taglen, GND_TAG)) {
				/* grab the 'count' attribute */

				if (get_attr_value(tag, taglen, COUNT_ATTR,
						   &gnd_count))
					return EXIT_FAILURE;
				sm->map->gnd_count = gnd_count;

				if (sm->map->gnd_count >
				    sizeof(sm->map->gnd_table))
					sm->map->gnd_count =
						sizeof(sm->map->gnd_table);

				if (!sm->map->gnd_count)
					return XML_OK;

				if (sm->map->gnd_count >
				    sizeof(sm->map->gnd_table) /
					    sizeof(sm->map->gnd_table[0]))
					sm->map->gnd_count =
						sizeof(sm->map->gnd_table) /
						sizeof(sm->map->gnd_table[0]);

				/* parse comma separated gnds */
				if (get_csv(tag, taglen, GND_TAG,
					    sm->map->gnd_table,
					    sm->map->gnd_count))
					return EXIT_FAILURE;

				sm->found |= 1; /* Mark 'gnd was parsed' flag */
				return XML_OK;
			}

			/* get mask count */
			if ((!sm->found || sm->found == 1) &&
			    !tagcmpn(tag, taglen, MASK_TAG)) {
				/* grab the 'count' attribute */

				if (get_attr_value(tag, taglen, COUNT_ATTR,
						   &mask_count))
					return EXIT_FAILURE;
				sm->map->mask_count = mask_count;

				if (sm->map->mask_count > sizeof(sm->map->mask))
					sm->map->mask_count =
						sizeof(sm->map->mask);

				if (!sm->map->mask_count)
					return XML_OK;
				if (sm->map->mask_count >
				    sizeof(sm->map->mask) /
					    sizeof(sm->map->mask[0]))
					sm->map->mask_count =
						sizeof(sm->map->mask) /
						sizeof(sm->map->mask[0]);

				/* parse comma separated masks */
				if (get_csv(tag, taglen, MASK_TAG,
					    sm->map->mask, sm->map->mask_count))
					return EXIT_FAILURE;

				sm->found |= 2; /* Mark 'mask was parsed' flag */
				return XML_OK;
			}
		}

		/* search for 'map' tag. Skip if map is already allocated */
		if (sm->map)
			return XML_OK;
		if (tagcmpn(tag, taglen, MAP_TAG))
			return XML_OK;

		/* map tag found, compare with needed name */
		uint32_t value;
		if (get_attr_value(tag, taglen, "index", &value))
			return EXIT_FAILURE;

		if (value != sm->db_data->index)
			return XML_OK;

		/* Allocate pin map */
		sm->map = calloc(1, sizeof(pin_map_t));
		if (!sm->map)
			return ERRMEM;
		break;
	case FRAMECLOSE_:
		if (sm->found == 3 && !tagcmpn(tag, taglen, CFGS_TAG))
			sm->skip = 1;
		break;
	}
	return XML_OK;
}

/* XML profile SAX parser handler. Each xml tag pair is dispatched here.
 * The persistent state machine data are kept in parser->userdata structure
 */
static int profile_callback(int type, const char *tag, size_t taglen,
			    Parser *parser)
{
	state_machine_p_t *sm = parser->userdata;
	Memblock memblock;

	/* If needed configuration is found and parsed or we reached the end of
	 * section skip until EOF
	 */
	if (sm->skip || sm->found)
		return XML_OK;
	switch (type) {
	case OPENTAG_:
		/* Search for 'configurations' tag */
		if (!tagcmpn(tag, taglen, CFGS_TAG))
			sm->has_profile = 1;
		if (!sm->has_profile)
			return XML_OK;

		/* If config was allocated search for fuses/acw_bits tag */
		if (sm->config && sm->type == MCU_CHIP) {
			/* MCU configuration handling */
			fuse_decl_t *config = (fuse_decl_t *)sm->config;

			/* parse fuses */
			if (config->num_fuses &&
			    sm->cur_fuse < config->num_fuses) {
				/* Get fuse name */
				memblock =
					get_attribute(tag, taglen, NAME_ATTR);
				if (!memblock.b)
					return EXIT_FAILURE;
				if (memblock.z > NAME_LEN)
					return EXIT_FAILURE;
				memcpy(config->fuse[sm->cur_fuse].name,
				       memblock.b, memblock.z);

				/* get fuse comma separated values */
				uint16_t value[2];
				if (get_csv(tag, taglen, "fuse", value, 2))
					return EXIT_FAILURE;

				config->fuse[sm->cur_fuse].mask = value[0];
				config->fuse[sm->cur_fuse].def = value[1];
				sm->cur_fuse++;
				return XML_OK;
			}

			/* parse locks */
			if (config->num_locks &&
			    sm->cur_lock < config->num_locks) {
				/* Get lock name */
				memblock =
					get_attribute(tag, taglen, NAME_ATTR);
				if (!memblock.b)
					return EXIT_FAILURE;
				if (memblock.z > NAME_LEN)
					return EXIT_FAILURE;
				memcpy(config->lock[sm->cur_lock].name,
				       memblock.b, memblock.z);

				/* get lock comma separated values */
				uint16_t value[2];
				if (get_csv(tag, taglen, "lock", value, 2))
					return EXIT_FAILURE;
				config->lock[sm->cur_lock].mask = value[0];
				config->lock[sm->cur_lock].def = value[1];
				sm->cur_lock++;
				return XML_OK;
			}

			/* get fuse count */
			if (sm->config && !tagcmpn(tag, taglen, FUSES_TAG)) {
				/* grab the 'num_fuses' attribute */
				uint32_t num_fuses;
				if (get_attr_value(tag, taglen, COUNT_ATTR,
						   &num_fuses))
					return EXIT_FAILURE;
				config->num_fuses = num_fuses;

				if (config->num_fuses >
				    sizeof(config->fuse) /
					    sizeof(config->fuse[0]))
					config->num_fuses =
						sizeof(config->fuse) /
						sizeof(config->fuse[0]);
				return XML_OK;
			}

			/* get lock count */
			if (sm->config && !tagcmpn(tag, taglen, LOCKS_TAG)) {
				/* grab the 'num_locks' attribute */
				uint32_t num_locks;
				if (get_attr_value(tag, taglen, COUNT_ATTR,
						   &num_locks))
					return EXIT_FAILURE;
				config->num_locks = num_locks;

				if (config->num_locks >
				    sizeof(config->lock) /
					    sizeof(config->lock[0]))
					config->num_locks =
						sizeof(config->lock) /
						sizeof(config->lock[0]);
				return XML_OK;
			}

			/* PLD configuration handling */
		} else if (sm->config && sm->type == PLD_CHIP) {
			gal_config_t *config = (gal_config_t *)sm->config;

			/* parse fuses */
			if (config->acw_size &&
			    sm->cur_fuse < config->acw_size) {
				/* get fuse values */
				uint16_t value;

				if (get_csv(tag, taglen, "fuse", &value, 1))
					return EXIT_FAILURE;

				config->acw_bits[sm->cur_fuse] = value;
				sm->cur_fuse++;
				return XML_OK;
			}

			/* get acw_bits count */
			if (sm->config && !tagcmpn(tag, taglen, ACW_BITS)) {
				/* grab the 'acw_size' attribute */
				uint32_t acw_size;
				if (get_attr_value(tag, taglen, COUNT_ATTR,
						   &acw_size))
					return EXIT_FAILURE;
				config->acw_size = acw_size;

				config->acw_bits =
					malloc(config->acw_size *
					       sizeof(*config->acw_bits));
				if (!config->acw_bits)
					return ERRMEM;
				return XML_OK;
			}
		}

		/* search for 'config' tag. Skip if config is already allocated */
		if (sm->config)
			return XML_OK;
		if (tagcmpn(tag, taglen, CFG_TAG))
			return XML_OK;

		/* config tag found, compare with needed name */
		memblock = get_attribute(tag, taglen, NAME_ATTR);
		if (memblock.b &&
		    tagcmpn(memblock.b, strlen(sm->name), sm->name))
			return XML_OK;

		/* Allocate configuration */
		int err;
		memblock = get_attribute(tag, taglen, "row_width");
		if (memblock.b) {
			sm->config = calloc(1, sizeof(gal_config_t));
			if (!sm->config)
				return ERRMEM;
			sm->type = PLD_CHIP;
			gal_config_t *config = (gal_config_t *)sm->config;

			/* All parameters required */
			uint32_t fuses_size, row_width, ues_address, ues_size,
				powerdown_row, acw_address;
			err = get_attr_value(tag, taglen, "fuses_size",
					     &fuses_size);
			err += get_attr_value(tag, taglen, "row_width",
					      &row_width);
			err += get_attr_value(tag, taglen, "ues_addr",
					      &ues_address);
			err += get_attr_value(tag, taglen, "ues_size",
					      &ues_size);
			err += get_attr_value(tag, taglen, "pwrdown_row",
					      &powerdown_row);
			err += get_attr_value(tag, taglen, "acw_addr",
					      &acw_address);
			if (err)
				return EXIT_FAILURE;
			config->fuses_size = fuses_size;
			config->row_width = row_width;
			config->ues_address = ues_address;
			config->ues_size = ues_size;
			config->powerdown_row = powerdown_row;
			config->acw_address = acw_address;
		} else {
			sm->config = calloc(1, sizeof(fuse_decl_t));
			if (!sm->config)
				return ERRMEM;
			sm->type = MCU_CHIP;
			fuse_decl_t *config = (fuse_decl_t *)sm->config;

			/* Unused parameters can be omitted */
			uint32_t num_calibytes, num_uids, config_addr,
				osccal_save, eep_addr, bg_mask;
			err = get_attr_value(tag, taglen, "num_calibytes",
					     &num_calibytes);
			if (err && err != ERREND)
				return EXIT_FAILURE;
			err = get_attr_value(tag, taglen, "num_uids",
					     &num_uids);
			if (err && err != ERREND)
				return EXIT_FAILURE;
			err = get_attr_value(tag, taglen, "config_addr",
					     &config_addr);
			if (err && err != ERREND)
				return EXIT_FAILURE;
			err = get_attr_value(tag, taglen, "osccal_save",
					     &osccal_save);
			if (err && err != ERREND)
				return EXIT_FAILURE;
			err = get_attr_value(tag, taglen, "eep_addr",
					     &eep_addr);
			if (err && err != ERREND)
				return EXIT_FAILURE;
			err = get_attr_value(tag, taglen, "bg_mask", &bg_mask);
			if (err && err != ERREND)
				return EXIT_FAILURE;

			config->num_calibytes = num_calibytes;
			config->num_uids = num_uids;
			config->config_addr = config_addr;
			config->osccal_save = osccal_save;
			config->eep_addr = eep_addr;
			config->bg_mask = bg_mask;

			if (config->num_uids > 8)
				config->num_uids = 8;
		}
		break;
	case FRAMECLOSE_:
		if (sm->config && !tagcmpn(tag, taglen, CFG_TAG))
			sm->found = 1;
		if (!tagcmpn(tag, taglen, CFGS_TAG))
			sm->skip = 1;
		break;
	}
	return XML_OK;
}

/* XML database SAX parser handler. Each xml tag pair is dispatched here.
 * The persistent state machine data are kept in parser->userdata structure
 */

static int device_callback(int type, const char *tag, size_t taglen,
			   Parser *parser)
{
	state_machine_d_t *sm = parser->userdata;
	Memblock mb_name;
	uint32_t pin_map = 0;
	int count;

	/* If end of section is reached, skip until EOF */
	if (sm->skip)
		return XML_OK;

	switch (type) {
	/* Handle both old style and self-closing tags */
	case OPENTAG_:
	case SELFCLOSE_:

		/* Get manufacturer/custom item */
		if (!tagcmpn(tag, taglen, MANUF_TAG))
			sm->custom = 0;
		else if (!tagcmpn(tag, taglen, CUSTOM_TAG))
			sm->custom = 1;

		/* Filter by "IC tag" */
		if (!tagcmpn(tag, taglen, IC_TAG)) {
			/* Grab the device name */
			mb_name = get_attribute(tag, taglen, NAME_ATTR);
			if (!mb_name.b)
				return EXIT_FAILURE;

			/* Get the device count in the 'name' list */
			count = get_chip_count(&mb_name);

			/* Count all devices and add them to the desired target */
			switch (sm->db_version) {
			case INFOIC2PLUS_DATABASE:

				/* Grab the pin_map field  */
				if (get_attr_value(tag, taglen, "pin_map",
						   &pin_map))
					return EXIT_FAILURE;

				/* First count all devices in INFOIC2PLUS database */
				sm->custom ?
					(sm->infoic2_custom_count += count) :
					(sm->infoic2_count += count);

				/* Now count devices individually by supported programmer */
				switch (pin_map & DEVICE_MASK) {
				case TL866II_FLAG:
					sm->custom ?
						(sm->tl866ii_custom_count +=
						 count) :
						(sm->tl866ii_count += count);
					break;
				case T48_FLAG:
					sm->custom ? (sm->t48_custom_count +=
						      count) :
						     (sm->t48_count += count);
					break;
				case T56_FLAG:
					sm->custom ? (sm->t56_custom_count +=
						      count) :
						     (sm->t56_count += count);
				}
				break;
			case INFOIC_DATABASE:
				sm->custom ?
					(sm->infoic_custom_count += count) :
					(sm->infoic_count += count);
				break;
			case LOGIC_DATABASE:
				sm->custom ? (sm->logic_custom_count += count) :
					     (sm->logic_count += count);
				break;
			}

			/* Filter only devices from the desired database */
			if (sm->count_only ||
			    sm->db_data->version != sm->db_version)
				return XML_OK;

			/* Only print device name */
			if (sm->print_name) {
				/* Print only devices that match the chip ID (SPI autodetect -a) */
				if (sm->match_id) {
					if (compare_device(tag, taglen, sm))
						return EXIT_FAILURE;
					if (sm->found) {
						sm->found_count +=
							print_chip_names(
								&mb_name, NULL,
								sm->custom);
						fflush(stdout);
						sm->found = 0;
					}
					return XML_OK;
				}

				/* Print all devices that match the name (-l and -L) */
				print_chip_names(&mb_name,
						 sm->db_data->device_name,
						 sm->custom);
				fflush(stdout);
				return XML_OK;
			}

			/* Search by chip ID (get_device_from_id) */
			if (!sm->db_data->device_name) {
				if (sm->found && !sm->custom)
					return XML_OK;

				if (compare_device(tag, taglen, sm) ==
				    EXIT_FAILURE)
					return EXIT_FAILURE;

				/* Copy first chip name from the list */
				if (sm->found && !strlen(sm->device->name)) {
					char *end = memchr(mb_name.b, ',',
							   mb_name.z);
					/* If only one chip name, use it */
					if (!end) end = (char*)mb_name.b + mb_name.z;
					strncpy(sm->device->name, mb_name.b,
						end - mb_name.b);
					sm->found_count++;
				}
				return XML_OK;
			}

			/* Search and load device (-p and -d) */
			char *name = search_chip_name(
				&mb_name, sm->db_data->device_name);
			if (name) {
				if (sm->found_count && !sm->custom)
					return XML_OK;
				strcpy(sm->device->name, name);
				free(name);
				if (load_device(sm->db_data, tag, taglen,
						sm->device,
						sm->db_data->version))
					return EXIT_FAILURE;
				sm->found_count++;

				/* Clear the previous logic device (if any) */
				sm->load_vectors = 1;
				if (sm->device->vectors) {
					free(sm->device->vectors);
					sm->device->vectors = NULL;
					sm->device->vector_count = 0;
				}
			}
		}

		/* Get database version */
		if (tagcmpn(tag, taglen, DB_TAG))
			return XML_OK;
		mb_name = get_attribute(tag, taglen, TYPE_ATTR);
		if (!tagcmpn(mb_name.b, mb_name.z, INFOIC2PLUS_ATTR_NAME))
			sm->db_version = INFOIC2PLUS_DATABASE;
		else if (!tagcmpn(mb_name.b, mb_name.z, INFOIC_ATTR_NAME))
			sm->db_version = INFOIC_DATABASE;
		else if (!tagcmpn(mb_name.b, mb_name.z, LOGIC_ATTR_NAME))
			sm->db_version = LOGIC_DATABASE;
		break;

	case FRAMECLOSE_:
		if (!tagcmpn(tag, taglen, CFGS_TAG))
			sm->skip = 1;
		break;
	}

	if (type == SELFCLOSE_ || type == NORMALCLOSE_ || type == FRAMECLOSE_) {
		if (taglen < 1)
			return XML_OK;
		if (!tagcmpn(tag, taglen, IC_TAG))
			sm->load_vectors = 0;
		if (sm->load_vectors && !tagcmpn(tag, taglen, VECTOR_TAG)) {
			size_t pin_count =
				sm->device->package_details.pin_count;
			size_t vector_count = sm->device->vector_count;
			sm->device->vectors =
				realloc(sm->device->vectors,
					pin_count * (vector_count + 1));
			uint8_t *vector =
				sm->device->vectors + pin_count * vector_count;
			int n = 0;
			for (int i = 0; i < parser->contentlen; i++) {
				switch (parser->content[i]) {
				case ' ':
				case '\r':
				case '\n':
				case '\t':
					break;
				case '0':
					vector[n++] = LOGIC_0;
					break;
				case '1':
					vector[n++] = LOGIC_1;
					break;
				case 'L':
					vector[n++] = LOGIC_L;
					break;
				case 'H':
					vector[n++] = LOGIC_H;
					break;
				case 'C':
					vector[n++] = LOGIC_C;
					break;
				case 'Z':
					vector[n++] = LOGIC_Z;
					break;
				case 'X':
					vector[n++] = LOGIC_X;
					break;
				case 'G':
					vector[n++] = LOGIC_G;
					break;
				case 'V':
					vector[n++] = LOGIC_V;
					break;
				default:
					return EXIT_FAILURE;
				}
				if (n >= pin_count)
					break;
			}
			if (n < pin_count)
				return EXIT_FAILURE;
			sm->device->vector_count++;
		}
	}

	return XML_OK;
}

/* Search and return database xml file */
static FILE *get_database_file(const char *name, const char *cli_name)
{
	/* Has the filename been overridden? If so, open it or fail now. */
	if (cli_name != NULL) {
		FILE *file = fopen(cli_name, "rb");
		if (file) {
			fprintf(stderr, "Using overridden database file %s\n",
				cli_name);
			return file;
		} else {
			perror(cli_name);
			return NULL;
		}
	}

#ifdef _WIN32

	char path[MAX_PATH];
	char appdata[MAX_PATH];

	/* Avoid buffer overruns and keep to maximum lengths */
	SHGetSpecialFolderPathA(NULL, appdata, CSIDL_COMMON_APPDATA, 0);
	int count =
		snprintf(path, sizeof(path), "%s\\minipro\\%s", appdata, name);

	/* C99 and Windows (before Windows 10) differ in semantics.
	 * Check both cases.
	 */
	if (count < 0 || count >= sizeof(path)) {
		fprintf(stderr, "Path %s\\minipro\\%s is too long.\n", appdata,
			name);
		return NULL;
	}
	path[sizeof(path) - 1] = '\0'; /* Not needed now, but it can't hurt! */

#else

	char path[PATH_MAX];
	char *env_path = getenv("MINIPRO_HOME");
	int count;
	if (env_path != NULL) {
		count = snprintf(path, sizeof(path), "%s/%s", env_path, name);
	} else {
		count = snprintf(path, sizeof(path), "%s/%s", SHARE_INSTDIR,
				 name);
	}
	path[sizeof(path) - 1] = '\0';
	if (count >= sizeof(path)) {
		fprintf(stderr, "Path %s... is too long.\n", path);
		return NULL;
	}

#endif

	/* Open database xml file using current directory */
	FILE *file = fopen(name, "rb");
	if (file)
		return file;

	/* Format an error message for later, just in case */
	char err[sizeof(path) + 1024];
	snprintf(err, sizeof(err), "%s: %s\n", path, strerror(errno));
	err[sizeof(err) - 1] = '\0';

	/* No luck. Try the full path. */
	file = fopen(path, "rb");
	if (file)
		return file;

	fputs(err, stderr); /* Print previous error message too. */
	perror(name);
	return NULL;
}

/* Parse xml pin maps */
static int parse_maps(state_machine_m_t *sm)
{
	/* Open database xml file */
	FILE *file = get_database_file(INFOIC_NAME, sm->db_data->infoic_path);
	if (!file)
		return EXIT_FAILURE;

	/* Begin xml parse */
	Parser parser = { .inputcbdata = file,
			  .worker = map_callback,
			  .userdata = sm };

	int ret = parse(&parser);
	done(&parser);
	fclose(file);
	if (ret) {
		fprintf(stderr,
			"An error occurred while parsing XML pin map.\n");
		return EXIT_FAILURE;
	}
	return EXIT_SUCCESS;
}

/* Parse xml profiles */
static int parse_profiles(state_machine_p_t *sm)
{
	/* Open database xml file */
	FILE *file = get_database_file(INFOIC_NAME, sm->db_data->infoic_path);
	if (!file)
		return EXIT_FAILURE;

	/* Begin xml parse */
	Parser parser = { .inputcbdata = file,
			  .worker = profile_callback,
			  .userdata = sm };

	int ret = parse(&parser);
	done(&parser);
	fclose(file);
	if (ret) {
		fprintf(stderr,
			"An error occurred while parsing XML profiles.\n");
		return EXIT_FAILURE;
	}
	return EXIT_SUCCESS;
}

/* Parse xml algorithms */
static int parse_algorithms(state_machine_a_t *sm)
{
	/* Open database xml file */
	FILE *file = get_database_file(ALGO_NAME, sm->db_data->algo_path);
	if (!file)
		return EXIT_FAILURE;

	/* Begin xml parse */
	Parser parser = { .inputcbdata = file,
			  .worker = algo_callback,
			  .userdata = sm };

	int ret = parse(&parser);
	done(&parser);
	fclose(file);
	if (ret) {
		fprintf(stderr,
			"An error occurred while parsing XML algorithms.\n");
		return EXIT_FAILURE;
	}
	return EXIT_SUCCESS;
}

/* Parse given xml file */
static int parse_xml_file(void *sm, const char *name, const char *cli_name)
{
	/* Open database xml file */
	FILE *file = get_database_file(name, cli_name);
	if (!file)
		return EXIT_FAILURE;

	/* Begin xml parse */
	Parser parser = { .inputcbdata = file,
			  .worker = device_callback,
			  .userdata = sm };

	int ret = parse(&parser);
	done(&parser);
	fclose(file);
	if (ret) {
		fprintf(stderr,
			"An error occurred while parsing XML database.\n");
		return EXIT_FAILURE;
	}
	return EXIT_SUCCESS;
}

/* Parse xml database */
static int parse_xml(state_machine_d_t *sm)
{
	int version = sm->db_data->version;
	sm->db_data->version = LOGIC_DATABASE;
	int ret = parse_xml_file(sm, LOGICIC_NAME, sm->db_data->logicic_path);
	if (ret)
		return ret;
	if (!sm->count_only && sm->device->chip_type == MP_LOGIC)
		return ret;
	sm->db_data->version = version;
	return parse_xml_file(sm, INFOIC_NAME, sm->db_data->infoic_path);
}

/* Translate programmer version to internal database version */
static void translate_db(db_data_t *db_data)
{
	switch (db_data->version) {
	case MP_TL866A:
	case MP_TL866CS:
		db_data->version = INFOIC_DATABASE;
		break;
	case MP_TL866IIPLUS:
	case MP_T48:
	case MP_T56:
		db_data->version = INFOIC2PLUS_DATABASE;
	}
}

/* XML based device search */
device_t *get_device_by_name(db_data_t *db_data)
{
	if (!db_data->device_name)
		return NULL;
	device_t *device = device = calloc(1, sizeof(device_t));
	if (!device) {
		fprintf(stderr, "Out of memory\n");
		return NULL;
	}

	/* Initialize state machine structure */
	translate_db(db_data);
	state_machine_d_t sm;
	memset(&sm, 0, sizeof(sm));
	sm.device = device;
	sm.db_version = -1;
	sm.custom = -1;
	sm.db_data = db_data;

	int ret = parse_xml(&sm);

	if (ret || !sm.found_count) {
		free(device);
		device = NULL;
	}
	return device;
}

/* Get first device name found in the database from a device ID */
const char *get_device_from_id(db_data_t *db_data)
{
	device_t device;
	device.chip_id = db_data->chip_id;
	device.protocol_id = db_data->protocol;
	device.package_details.pin_count = 0;
	memset(device.name, 0, sizeof(device.name));

	/* Initialize state machine structure  */
	translate_db(db_data);
	state_machine_d_t sm;
	memset(&sm, 0, sizeof(sm));
	sm.device = &device;
	sm.db_version = -1;
	sm.custom = -1;
	sm.match_id = 1;
	sm.db_data = db_data;

	if (parse_xml(&sm))
		return NULL;
	return sm.found_count ? strdup(device.name) : NULL;
}

/* List all devices from XML
 * If name == NULL list all devices
 */
int list_devices(db_data_t *db_data)
{
	device_t device;
	device.chip_id = db_data->chip_id;
	device.package_details.pin_count = db_data->pin_count;
	memset(device.name, 0, sizeof(device.name));
	int flag = (db_data->chip_id || db_data->pin_count) ? 1 : 0;

	/* Initialize state machine structure */
	translate_db(db_data);
	state_machine_d_t sm;
	memset(&sm, 0, sizeof(sm));
	sm.device = &device;
	sm.db_version = -1;
	sm.custom = -1;
	sm.print_name = 1;
	sm.match_id = flag;
	sm.db_data = db_data;
	if (parse_xml(&sm))
		return EXIT_FAILURE;
	if (db_data->count)
		*(db_data->count) = sm.found_count;
	return EXIT_SUCCESS;
}

/* Print database chip count */
int print_chip_count(db_data_t *db_data)
{
	/* Initialize state machine structure */
	translate_db(db_data);
	state_machine_d_t sm;
	memset(&sm, 0, sizeof(sm));
	sm.db_version = -1;
	sm.custom = -1;
	sm.count_only = 1;
	sm.db_data = db_data;

	if (parse_xml(&sm))
		return EXIT_FAILURE;

	fprintf(stderr,
		"TL866A/CS:\t%5u devices, %u custom\nTL866II+:\t%5u devices, %u custom\n"
		"T48:\t\t%5u devices, %u custom\nT56:\t\t%5u devices, %u custom\n"
		"Logic:\t\t%5u devices, %u custom\n",
		sm.infoic_count, sm.infoic_custom_count,
		sm.infoic2_count - sm.t48_count - sm.t56_count,
		sm.infoic2_custom_count,
		sm.infoic2_count - sm.t56_count - sm.tl866ii_count,
		sm.t48_custom_count,
		sm.infoic2_count - sm.t48_count - sm.tl866ii_count,
		sm.t56_custom_count, sm.logic_count, sm.logic_custom_count);
	return EXIT_SUCCESS;
}

/* Get a pointer to the pin_map_t structure specified by index */
pin_map_t *get_pin_map(db_data_t *db_data)
{
	if (!db_data->index) {
		fprintf(stderr, "Pin test is not available for this chip.\n");
		return NULL;
	}

	/* Set the Infoic2Plus database for pin map search */
	db_data->version = INFOIC2PLUS_DATABASE;
	state_machine_m_t sm;
	memset(&sm, 0, sizeof(sm));
	sm.db_data = db_data;
	if (parse_maps(&sm))
		return NULL;
	if (!sm.map) {
		fprintf(stderr, "No pin map %u was found.\n", db_data->index);
		return NULL;
	}
	return sm.map;
}

/* Return an algorithm_t structure */
int get_algorithm(device_t *device, const char *algo_path, uint8_t icsp,
		  uint8_t vopt, size_t offset)
{
	algorithm_t *algorithm = &device->algorithm;
	uint8_t algo_number = (uint8_t)(device->variant >> 8);
	uint8_t error = 0;
	const char *entry;

	/* Check if the arguments are in valid range */
	if (device->protocol_id != IC2_ALG_NONE) {
		int isProtocolValid = device->protocol_id > ALGO_COUNT;
		entry = t56_algo_table[device->protocol_id - 1];
		if (isProtocolValid || (entry == NULL))
			error = 1;
	} else {
		if (algo_number > UTIL_COUNT)
			error = 1;
	}

	if (error) {
		fprintf(stderr, "Invalid algorithm number found.\n");
		return EXIT_FAILURE;
	}

	/* If not a logic chip grab the prefix name using the protocol_id-1 */
	if (device->protocol_id != IC2_ALG_NONE) {

		char algo_str[8];
		snprintf(algo_str, sizeof(algo_str), "%02X", algo_number);
		char *name = stpcpy(algorithm->name, entry);

		switch (device->protocol_id) {
		/* Choose icsp algorithm for Atmel ATmega, ATtiny and AT90 */
		case IC2_ALG_ATMGA:
				strcat(name, icsp ? "11S" : algo_str);
			break;

		/* Choose ICSP option for AT89C*/
		case IC2_ALG_AT89C:
			strcat(name, icsp ? "2S" : algo_str);
			break;

		/* Choose algorithm variant and 1.8V/3.3V for EMMC */
		case IC2_ALG_EMMC:
			sprintf(name, "%02x", (device->variant>>8));
			strcat(name, V_1V8 ? "_18" : "_33");
		break;

			/* Default case. Handle reversed package devices */
		default:
			strcat(name, algo_str);
			if (device->flags.reversed_package)
				strcat(algorithm->name, "R");
		}
		/* For Logic chips/utils copy only the algorithm name */
	} else {
		strncpy(algorithm->name, t56_util_table[algo_number], NAME_LEN);
	}

	/* Set the database for algorithm search */
	db_data_t db_data;
	const char *algo_name = algorithm->name;
	db_data.version = ALGORITHM_DATABASE;
	db_data.algo_path = algo_path;
	db_data.device_name = algo_name;

	state_machine_a_t sm;
	memset(&sm, 0, sizeof(sm));
	sm.db_data = &db_data;

	/* Search the desired algorithm */
	if (parse_algorithms(&sm))
		return EXIT_FAILURE;
	if (!sm.base64_data) {
		fprintf(stderr, "No algorithm %s was found.\n", algo_name);
		return EXIT_FAILURE;
	}

	/* We have the base64 string let's decode it */
	unsigned int out_size = strlen(sm.base64_data);
	char *gzip = malloc(out_size * 4 / 3 + 8);
	if (!gzip) {
		free(sm.base64_data);
		fprintf(stderr, "Out of memory!\n");
		return EXIT_FAILURE;
	}

	base64_decodestate ds;
	base64_init_decodestate(&ds);
	out_size = base64_decode_block(sm.base64_data, out_size, gzip, &ds);
	free(sm.base64_data);
	if (!out_size) {
		fprintf(stderr, "Algorithm %s base64 decoding error!\n",
			algo_name);
		return EXIT_FAILURE;
	}

	/* Get the gzip uncompressed size and add the offset length */
	uint32_t usize =
		load_int((uint8_t *)(gzip + out_size - 4), 4, MP_LITTLE_ENDIAN);

	/* Round up to the nearest 512 byte multiple  */
	algorithm->length = usize + (0x200 - (usize % 0x200));

	algorithm->bitstream = calloc(1, algorithm->length + offset);
	if (!algorithm->bitstream) {
		fprintf(stderr, "Out of memory!\n");
		return EXIT_FAILURE;
	}

	/* Uncompress data using zlib */
	z_stream stream = { .next_in = (Bytef *)gzip,
			    .avail_in = (uInt)out_size,
			    .next_out = (Bytef *)algorithm->bitstream + offset,
			    .avail_out = algorithm->length };

	int inf_init_err = inflateInit2(&stream, MAX_WBITS + 16);
	int inf_err = inflate(&stream, Z_FINISH);
	int inf_end_err = inflateEnd(&stream);
	if (inf_init_err != Z_OK ||
	    (inf_err != Z_OK && inf_err != Z_STREAM_END) ||
	    inf_end_err != Z_OK) {
		free(algorithm->bitstream);
		fprintf(stderr, "Algorithm %s uncompression error.\n",
			algo_name);
		return EXIT_FAILURE;
	}

	/* Check if gzip inflate was ok */
	if (stream.total_out != usize) {
		free(algorithm->bitstream);
		return EXIT_FAILURE;
	}

	/* Check for algorithm integrity */
	uint32_t file_crc =
		load_int(algorithm->bitstream + offset + ALGO_CRC_OFFSET, 4,
			 MP_LITTLE_ENDIAN);
	uint32_t data_crc =
		crc_32(algorithm->bitstream + offset + ALGO_DATA_OFFSET,
		       usize - ALGO_DATA_OFFSET, 0xFFFFFFFF);

	if (file_crc != data_crc) {
		fprintf(stderr, "Corrupted %s algorithm. Bad CRC.\n",
			algo_name);
		free(algorithm->bitstream);
		return EXIT_FAILURE;
	}
	return EXIT_SUCCESS;
}
