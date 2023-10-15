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
#include "xml.h"
#include "database.h"

#ifdef _WIN32
#include <Shlobj.h>
#include <shlwapi.h>
#define STRCASESTR StrStrIA
#else
#define STRCASESTR strcasestr
#endif

// flags
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

// Opts chip_info
#define MP_VOLTAGES1		 0x0006
#define MP_VOLTAGES2		 0x0007

// Package mask
#define PLCC_MASK		 0xFF000000
#define ADAPTER_MASK		 0x000000FF
#define ICSP_MASK		 0x0000FF00
#define PIN_COUNT_MASK		 0X7F000000
#define SMD_MASK		 0X80000000
#define PLCC32_ADAPTER		 0xFF000000
#define PLCC44_ADAPTER		 0xFD000000

// infoic.xml name and tag names
#define INFOIC_NAME		 "infoic.xml"
#define LOGICIC_NAME		 "logicic.xml"
#define DB_TAG			 "database"
#define DEVICE_ATTR		 "device"
#define MANUF_TAG		 "manufacturer"
#define CUSTOM_TAG		 "custom"
#define IC_TAG			 "ic"
#define VECTOR_TAG		 "vector"
#define NAME_ATTR		 "name"
#define FUSE_ATTR		 "config"
#define VOLTAGE_ATTR		 "voltage"
#define TL866II_ATTR_NAME	 "TL866II"
#define TL866A_ATTR_NAME	 "TL866A"
#define LOGIC_ATTR_NAME		 "LOGIC"
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
#define LOGIC_DATABASE		 0x80

#define CUSTOM_PROTOCOL_MASK	 0x80000000

// State machine structure used by sax database parser callback function
// for persistent data between calls.
typedef struct state_machine_d {
	device_t *device;
	int version;
	int custom;
	int print_name;
	int count_only;
	int found;
	int match_id;
	db_data_t *db_data;
	uint32_t tl866a_count;
	uint32_t tl866a_custom_count;
	uint32_t tl866ii_count;
	uint32_t tl866ii_custom_count;
	uint32_t logic_count;
	uint32_t logic_custom_count;
	uint8_t load_vectors;
	int skip;
} state_machine_d_t;

// State machine structure used by sax profile parser callback function
// for persistent data between calls.
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

// State machine structure used by sax pin map parser callback function
// for persistent data between calls.
typedef struct state_machine_m {
	int has_map;
	int found;
	int skip;
	pin_map_t *map;
	db_data_t *db_data;
} state_machine_m_t;

static int parse_profiles(state_machine_p_t *);

// return pin count from package_details
static uint32_t get_pin_count(uint32_t package_details)
{
	if ((package_details & PLCC_MASK) == PLCC32_ADAPTER)
		return 32;
	else if ((package_details & PLCC_MASK) == PLCC44_ADAPTER)
		return 44;
	return ((package_details & PIN_COUNT_MASK) >> 24);
}

// Parse a numeric value from an attribute
static uint32_t get_attr_value(const uint8_t *xml, size_t size, char *attr_name,
			       int *err)
{
	Memblock memblock = get_attribute(xml, size, attr_name);
	errno = 0;
	if (!memblock.b || !memblock.z) {
		errno = ERREND;
		return 0;
	}
	char *attr = calloc(1, memblock.z + 1);
	if (attr) {
		memcpy(attr, memblock.b, memblock.z);
		errno = 0;
		uint32_t value = strtoul(attr, NULL, 0);
		free(attr);
		return value;
	}
	(*err) = 1;
	return 0;
}

// Match the whole 'str' string in a 'tag' text stream.
// For ex. if 'tag' = "configurations>\n" or "<configurations"
// and if we compare with 'str' =  "configurations" the result is
// true in both cases. Strings like "conf", "config" and so on will return
// false. The comparison is case insensitive.
static int tagcmpn(const uint8_t *tag, size_t taglen, const char *str)
{
	if (!tag || !str || !taglen)
		return 1;

	// Find the start of substring
	for (; taglen; taglen--, tag++) {
		if (isprint(*tag) && !isspace(*tag))
			break;
	}

	// Find the end of substring
	size_t len = 0;
	for (; taglen; taglen--, len++) {
		if (iscntrl(tag[len]) || isspace(tag[len]))
			break;
	}

	if (!len || len < strlen(str))
		return 1;
	return strncasecmp((char *)tag, str, len);
}

// Parse comma separated values from an element tag
// There should be at least 'size' values otherwise
// an error is returned.
static int get_elem_value(const uint8_t *tag, size_t taglen, char *elem_name,
			  uint16_t *value, size_t size)
{
	if (tagcmpn(tag, taglen, elem_name))
		return EXIT_FAILURE;

	//Find start and end of the element data
	size_t len = 0;
	while (*tag != '>')
		tag++;
	;
	while (tag[len + 1] != '<')
		len++;

	// Duplicate data for strtok
	char *b = calloc(1, len + 1);
	memcpy(b, (char *)tag + 1, len);
	if (!b)
		return ERRMEM;
	char *token = strtok(b, ",");

	// Parse each token
	int i;
	for (i = 0; i < size && token; i++) {
		errno = 0;
		value[i] = strtoul(token, NULL, 0);
		if (errno) {
			free(b);
			return EXIT_FAILURE;
		}
		token = strtok(NULL, ",");
	}
	free(b);
	if (size != i)
		return EXIT_FAILURE;
	return EXIT_SUCCESS;
}

#define CONFIG ((fuse_decl_t *)(device->config))

// Calculate chip ID bytes count from chip ID
static uint8_t get_id_bytes_count(uint32_t chip_id)
{
	if (!chip_id)
		return 0;
	int count = 4;
	uint32_t mask[] = { 0xff, 0xff00, 0xff0000, 0xff000000 };
	while (count--) {
		if (chip_id & mask[count])
			break;
	}
	return (uint8_t)count + 1;
}

// Load a device from an xml 'ic' tag
static int load_mem_device(db_data_t *db_data, const uint8_t *xml_device,
			   size_t size, device_t *device, uint8_t version)
{
	int err = 0;
	uint32_t voltages, protocol_id;

	Memblock memblock = get_attribute(xml_device, size, NAME_ATTR);
	if (!memblock.b || memblock.z > sizeof(device->name))
		return EXIT_FAILURE;
	memcpy(device->name, memblock.b, memblock.z);
	device->chip_type = get_attr_value(xml_device, size, "type", &err);
	protocol_id = get_attr_value(xml_device, size, "protocol_id", &err);
	device->variant = get_attr_value(xml_device, size, "variant", &err);
	device->read_buffer_size =
		get_attr_value(xml_device, size, "read_buffer_size", &err);
	device->write_buffer_size =
		get_attr_value(xml_device, size, "write_buffer_size", &err);
	device->code_memory_size =
		get_attr_value(xml_device, size, "code_memory_size", &err);
	device->data_memory_size =
		get_attr_value(xml_device, size, "data_memory_size", &err);
	device->data_memory2_size =
		get_attr_value(xml_device, size, "data_memory2_size", &err);
	device->page_size = get_attr_value(xml_device, size, "page_size", &err);
	device->chip_id = get_attr_value(xml_device, size, "chip_id", &err);
	voltages = get_attr_value(xml_device, size, "voltages", &err);
	device->pulse_delay =
		get_attr_value(xml_device, size, "pulse_delay", &err);
	uint32_t flags = get_attr_value(xml_device, size, "flags", &err);
	device->chip_info = get_attr_value(xml_device, size, "chip_info", &err);
	if (version == MP_TL866IIPLUS) {
		device->pin_map =
			get_attr_value(xml_device, size, "pin_map", &err);
		device->pages_per_block = get_attr_value(
			xml_device, size, "pages_per_block", &err);
	}
	device->package_details.packed_package =
		get_attr_value(xml_device, size, "package_details", &err);

	if (err)
		return EXIT_FAILURE;

	// get blank value if present
	device->blank_value =
		get_attr_value(xml_device, size, "blank_value", &err);
	if (err || errno)
		device->blank_value = 0xff;

	// Get chip_ID bytes count
	device->chip_id_bytes_count = get_id_bytes_count(device->chip_id);

	// Parse configuration name
	memblock = get_attribute(xml_device, size, FUSE_ATTR);
	if (!memblock.b)
		return EXIT_FAILURE;

	// Check if there's a configuration name
	if (strncasecmp((char *)memblock.b, "null", memblock.z)) {
		// Initialize parser state machine
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

	// Unpack flags
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
	device->flags.has_power_down = (voltages & LAST_JEDEC_BIT_IS_POWERDOWN_ENABLE)!= 0;
	device->flags.is_powerdown_disabled = (voltages & POWERDOWN_MODE_DISABLE) != 0;

	// Check for custom defined protocol
	device->protocol_id = (uint8_t)protocol_id;
	if (protocol_id & CUSTOM_PROTOCOL_MASK) {
		device->flags.custom_protocol = 1;
	}

	if (device->flags.custom_protocol && device->protocol_id == CP_PROM)
		device->flags.prog_support = MP_READ_ONLY;

	// Unpack voltages
	device->voltages.raw_voltages = voltages;
	device->voltages.vdd = (voltages >> 12) & 0x0f;
	device->voltages.vcc = (voltages >> 8) & 0x0f;
	device->voltages.vpp = (voltages >> 4) & 0x0f;

	// Unpacking package details
	device->package_details.pin_count =
		get_pin_count(device->package_details.packed_package);
	device->package_details.adapter =
		device->package_details.packed_package & ADAPTER_MASK;
	device->package_details.icsp =
		(device->package_details.packed_package & ICSP_MASK) >> 8;

	// Fill some device parameters
	device->compare_mask = 0xff;
	switch (device->chip_info) {
	// PIC baseline devices
	case PIC_INSTR_WORD_WIDTH_12:
		device->compare_mask = 0x0fff;
		break;

	// PIC midrange/standard devices
	case PIC_INSTR_WORD_WIDTH_14:
		device->compare_mask = 0x3fff;
		if (CONFIG) {
			CONFIG->rev_bits = 5;
		}
		break;

	// PIC 18F/18F_J devices
	case PIC_INSTR_WORD_WIDTH_16_PIC18F:
	case PIC_INSTR_WORD_WIDTH_16_PIC18J:
		device->compare_mask = 0xffff;
		device->flags.word_size = 2;
		device->flags.has_word = 1;

		// This will tell us if PIC user id is 8bit or more
		device->flags.data_org = 0; // User ID is 8 bit
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

// Load a device from an xml 'ic' tag
static int load_logic_device(const uint8_t *xml_device, size_t size,
			     device_t *device)
{
	Memblock voltage = get_attribute(xml_device, size, VOLTAGE_ATTR);
	if (!voltage.b)
		return EXIT_FAILURE;

	if (!strncasecmp((char *)voltage.b, "5V", voltage.z))
		device->voltages.vcc = 0;
	else if (!strncasecmp((char *)voltage.b, "3V3", voltage.z))
		device->voltages.vcc = 1;
	else if (!strncasecmp((char *)voltage.b, "2V5", voltage.z))
		device->voltages.vcc = 2;
	else if (!strncasecmp((char *)voltage.b, "1V8", voltage.z))
		device->voltages.vcc = 3;
	else
		return EXIT_FAILURE;

	int err = 0;
	device->package_details.pin_count =
		get_attr_value(xml_device, size, "pins", &err);
	if (err)
		return EXIT_FAILURE;

	return EXIT_SUCCESS;
}

// Load a device from an xml 'ic' tag
static int load_device(db_data_t *db_data, const uint8_t *xml_device,
		       size_t size, device_t *device, uint8_t version)
{
	int err = 0;

	Memblock memblock = get_attribute(xml_device, size, NAME_ATTR);
	if (!memblock.b || memblock.z > sizeof(device->name))
		return EXIT_FAILURE;
	memcpy(device->name, memblock.b, memblock.z);

	device->chip_type = get_attr_value(xml_device, size, "type", &err);
	if (err)
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

// Compare a device by protocol ID/device ID or protocol ID/package
// If the device match then the device name is returned in device->name
static int compare_device(const uint8_t *xml_device, size_t size,
			  device_t *device, uint8_t version)
{
	int err = 0;

	uint8_t protocol_id =
		get_attr_value(xml_device, size, "protocol_id", &err);
	uint32_t chip_id = get_attr_value(xml_device, size, "chip_id", &err);
	uint32_t package_details =
		get_attr_value(xml_device, size, "package_details", &err);

	if (err)
		return EXIT_FAILURE;
	uint8_t chip_id_bytes_count = get_id_bytes_count(chip_id);

	uint32_t pin_count = get_pin_count(package_details);
	uint8_t match_package =
		device->package_details.pin_count ?
			(device->package_details.pin_count == pin_count) :
			1;

	if (chip_id && chip_id_bytes_count && match_package &&
	    device->chip_id && device->chip_id == chip_id &&
	    (match_package || device->protocol_id == protocol_id)) {
		Memblock memblock = get_attribute(xml_device, size, NAME_ATTR);
		if (!memblock.b || memblock.z > sizeof(device->name))
			return EXIT_FAILURE;
		memcpy(device->name, memblock.b, memblock.z);
	}
	return EXIT_SUCCESS;
}

// XML pin map SAX parser handler. Each xml tag pair is dispatched here.
// The persistent state machine data are kept in parser->userdata structure
static int map_callback(int type, const uint8_t *tag, size_t taglen,
			Parser *parser)
{
	state_machine_m_t *sm = parser->userdata;
	int err;

	// If needed pin map is found and parsed or we reached the end of
	// section skip until EOF
	if (sm->skip || sm->found == 3)
		return XML_OK;
	switch (type) {
	case OPENTAG_:
		// Search for 'maps' tag
		if (!tagcmpn(tag, taglen, MAPS_TAG))
			sm->has_map = 1;
		if (!sm->has_map)
			return XML_OK;

		// If map was allocated search for gnd/mask tag
		if (sm->map) {
			// get gnd count
			if ((!sm->found || sm->found == 2) &&
			    !tagcmpn(tag, taglen, GND_TAG)) {
				// grab the 'count' attribute
				err = XML_OK;

				sm->map->gnd_count = get_attr_value(
					tag, taglen, COUNT_ATTR, &err);
				if (sm->map->gnd_count >
				    sizeof(sm->map->gnd_table))
					sm->map->gnd_count =
						sizeof(sm->map->gnd_table);
				if (err)
					return EXIT_FAILURE;
				if (!sm->map->gnd_count)
					return XML_OK;

				if (sm->map->gnd_count >
				    sizeof(sm->map->gnd_table) /
					    sizeof(sm->map->gnd_table[0]))
					sm->map->gnd_count =
						sizeof(sm->map->gnd_table) /
						sizeof(sm->map->gnd_table[0]);

				// parse comma separated gnds
				err = get_elem_value(tag, taglen, GND_TAG,
						     sm->map->gnd_table,
						     sm->map->gnd_count);
				if (err)
					return EXIT_FAILURE;

				sm->found |= 1; // Mark 'gnd was parsed' flag
				return XML_OK;
			}

			// get mask count
			if ((!sm->found || sm->found == 1) &&
			    !tagcmpn(tag, taglen, MASK_TAG)) {
				// grab the 'count' attribute
				err = XML_OK;
				sm->map->mask_count = get_attr_value(
					tag, taglen, COUNT_ATTR, &err);
				if (sm->map->mask_count > sizeof(sm->map->mask))
					sm->map->mask_count =
						sizeof(sm->map->mask);
				if (err)
					return EXIT_FAILURE;
				if (!sm->map->mask_count)
					return XML_OK;
				if (sm->map->mask_count >
				    sizeof(sm->map->mask) /
					    sizeof(sm->map->mask[0]))
					sm->map->mask_count =
						sizeof(sm->map->mask) /
						sizeof(sm->map->mask[0]);

				// parse comma separated masks
				err = get_elem_value(tag, taglen, MASK_TAG,
						     sm->map->mask,
						     sm->map->mask_count);
				if (err)
					return EXIT_FAILURE;

				sm->found |= 2; // Mark 'mask was parsed' flag
				return XML_OK;
			}
		}

		// search for 'map' tag. Skip if map is already allocated
		if (sm->map)
			return XML_OK;
		if (tagcmpn(tag, taglen, MAP_TAG))
			return XML_OK;

		// map tag found, compare with needed name
		err = 0;
		errno = 0;
		size_t value = get_attr_value(tag, taglen, "index", &err);
		if (err || errno)
			return EXIT_FAILURE;
		if (value != sm->db_data->index)
			return XML_OK;

		// Allocate pin map
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

#define MCU_CHIP 0
#define PLD_CHIP 1

// XML profile SAX parser handler. Each xml tag pair is dispatched here.
// The persistent state machine data are kept in parser->userdata structure
static int profile_callback(int type, const uint8_t *tag, size_t taglen,
			    Parser *parser)
{
	state_machine_p_t *sm = parser->userdata;
	Memblock memblock;
	int err;

	// If needed configuration is found and parsed or we reached the end of
	// section skip until EOF
	if (sm->skip || sm->found)
		return XML_OK;
	switch (type) {
	case OPENTAG_:
		// Search for 'configurations' tag
		if (!tagcmpn(tag, taglen, CFGS_TAG))
			sm->has_profile = 1;
		if (!sm->has_profile)
			return XML_OK;

		// If config was allocated search for fuses/acw_bits tag
		if (sm->config && sm->type == MCU_CHIP) {
			// MCU configuration handling
			fuse_decl_t *config = (fuse_decl_t *)sm->config;

			// parse fuses
			if (config->num_fuses &&
			    sm->cur_fuse < config->num_fuses) {
				// Get fuse name
				memblock =
					get_attribute(tag, taglen, NAME_ATTR);
				if (!memblock.b)
					return EXIT_FAILURE;
				if (memblock.z > NAME_LEN)
					return EXIT_FAILURE;
				memcpy(config->fuse[sm->cur_fuse].name,
				       memblock.b, memblock.z);

				// get fuse comma separated values
				uint16_t value[2];
				err = get_elem_value(tag, taglen, "fuse", value,
						     2);
				if (err)
					return EXIT_FAILURE;
				config->fuse[sm->cur_fuse].mask = value[0];
				config->fuse[sm->cur_fuse].def = value[1];
				sm->cur_fuse++;
				return XML_OK;
			}

			// parse locks
			if (config->num_locks &&
			    sm->cur_lock < config->num_locks) {
				// Get lock name
				memblock =
					get_attribute(tag, taglen, NAME_ATTR);
				if (!memblock.b)
					return EXIT_FAILURE;
				if (memblock.z > NAME_LEN)
					return EXIT_FAILURE;
				memcpy(config->lock[sm->cur_lock].name,
				       memblock.b, memblock.z);

				// get lock comma separated values
				uint16_t value[2];
				err = get_elem_value(tag, taglen, "lock", value,
						     2);
				if (err)
					return EXIT_FAILURE;
				config->lock[sm->cur_lock].mask = value[0];
				config->lock[sm->cur_lock].def = value[1];
				sm->cur_lock++;
				return XML_OK;
			}

			// get fuse count
			if (sm->config && !tagcmpn(tag, taglen, FUSES_TAG)) {
				// grab the 'count' attribute
				err = XML_OK;
				config->num_fuses = get_attr_value(
					tag, taglen, COUNT_ATTR, &err);
				if (config->num_fuses >
				    sizeof(config->fuse) /
					    sizeof(config->fuse[0]))
					config->num_fuses =
						sizeof(config->fuse) /
						sizeof(config->fuse[0]);
				return err;
			}

			// get lock count
			if (sm->config && !tagcmpn(tag, taglen, LOCKS_TAG)) {
				// grab the 'count' attribute
				err = XML_OK;
				config->num_locks = get_attr_value(
					tag, taglen, COUNT_ATTR, &err);
				if (config->num_locks >
				    sizeof(config->lock) /
					    sizeof(config->lock[0]))
					config->num_locks =
						sizeof(config->lock) /
						sizeof(config->lock[0]);
				return err;
			}

			// PLD configuration handling
		} else if (sm->config && sm->type == PLD_CHIP) {
			gal_config_t *config = (gal_config_t *)sm->config;

			// parse fuses
			if (config->acw_size &&
			    sm->cur_fuse < config->acw_size) {
				// get fuse values
				uint16_t value;
				err = get_elem_value(tag, taglen, "fuse",
						     &value, 1);
				if (err)
					return EXIT_FAILURE;
				config->acw_bits[sm->cur_fuse] = value;
				sm->cur_fuse++;
				return XML_OK;
			}

			// get acw_bits count
			if (sm->config && !tagcmpn(tag, taglen, ACW_BITS)) {
				// grab the 'count' attribute
				int err = XML_OK;
				config->acw_size = get_attr_value(
					tag, taglen, COUNT_ATTR, &err);
				if (err)
					return EXIT_FAILURE;
				config->acw_bits =
					malloc(config->acw_size *
					       sizeof(*config->acw_bits));
				if (!config->acw_bits)
					return ERRMEM;
				return XML_OK;
			}
		}

		// search for 'config' tag. Skip if config is already allocated
		if (sm->config)
			return XML_OK;
		if (tagcmpn(tag, taglen, CFG_TAG))
			return XML_OK;

		// config tag found, compare with needed name
		memblock = get_attribute(tag, taglen, NAME_ATTR);
		if (memblock.b &&
		    strncasecmp((char *)memblock.b, sm->name, strlen(sm->name)))
			return XML_OK;

		// Allocate configuration
		memblock = get_attribute(tag, taglen, "row_width");
		if (memblock.b) {
			sm->config = calloc(1, sizeof(gal_config_t));
			if (!sm->config)
				return ERRMEM;
			sm->type = PLD_CHIP;
			gal_config_t *config = (gal_config_t *)sm->config;

			// All parameters required
			err = 0;
			errno = 0;
			config->fuses_size =
				get_attr_value(tag, taglen, "fuses_size", &err);
			if (err || errno)
				return EXIT_FAILURE;
			config->row_width =
				get_attr_value(tag, taglen, "row_width", &err);
			if (err || errno)
				return EXIT_FAILURE;
			config->ues_address =
				get_attr_value(tag, taglen, "ues_addr", &err);
			if (err || errno)
				return EXIT_FAILURE;
			config->ues_size =
				get_attr_value(tag, taglen, "ues_size", &err);
			if (err || errno)
				return EXIT_FAILURE;
			config->powerdown_row = get_attr_value(
				tag, taglen, "pwrdown_row", &err);
			if (err || errno)
				return EXIT_FAILURE;
			config->acw_address =
				get_attr_value(tag, taglen, "acw_addr", &err);
			if (err || errno)
				return EXIT_FAILURE;
		} else {
			sm->config = calloc(1, sizeof(fuse_decl_t));
			if (!sm->config)
				return ERRMEM;
			sm->type = MCU_CHIP;
			fuse_decl_t *config = (fuse_decl_t *)sm->config;

			// Unused parameters can be omitted
			err = 0;
			errno = 0;
			config->num_calibytes = get_attr_value(
				tag, taglen, "num_calibytes", &err);
			if (!err && errno && errno && errno != ERREND)
				return EXIT_FAILURE;
			config->num_uids =
				get_attr_value(tag, taglen, "num_uids", &err);
			if (!err && errno && errno && errno != ERREND)
				return EXIT_FAILURE;
			config->config_addr = get_attr_value(
				tag, taglen, "config_addr", &err);
			if (!err && errno && errno && errno != ERREND)
				return EXIT_FAILURE;
			config->osccal_save = get_attr_value(
				tag, taglen, "osccal_save", &err);
			if (!err && errno && errno && errno != ERREND)
				return EXIT_FAILURE;
			config->eep_addr =
				get_attr_value(tag, taglen, "eep_addr", &err);
			if (!err && errno && errno && errno != ERREND)
				return EXIT_FAILURE;
			config->bg_mask =
				get_attr_value(tag, taglen, "bg_mask", &err);
			if (!err && errno && errno && errno != ERREND)
				return EXIT_FAILURE;
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

// XML database SAX parser handler. Each xml tag pair is dispatched here.
// The persistent state machine data are kept in parser->userdata structure
static int sax_callback(int type, const uint8_t *tag, size_t taglen,
			Parser *parser)
{
	state_machine_d_t *sm = parser->userdata;
	Memblock memblock;

	// If end of section is reached skip until EOF
	if (sm->skip)
		return XML_OK;
	switch (type) {
		// Handle both old style and self-closing tags
	case OPENTAG_:
	case SELFCLOSE_:
		// Get manufacturer/custom item
		if (!tagcmpn(tag, taglen, MANUF_TAG))
			sm->custom = 0;
		else if (!tagcmpn(tag, taglen, CUSTOM_TAG))
			sm->custom = 1;
		// Filter by "IC tag"
		if (!tagcmpn(tag, taglen, IC_TAG)) {
			if (sm->version == MP_TL866IIPLUS) {
				sm->custom ? sm->tl866ii_custom_count++ :
					     sm->tl866ii_count++;
			} else if (sm->version == MP_TL866A) {
				sm->custom ? sm->tl866a_custom_count++ :
					     sm->tl866a_count++;
			} else if (sm->version == LOGIC_DATABASE) {
				sm->custom ? sm->logic_custom_count++ :
					     sm->logic_count++;
			}
			/*
         * Filter only devices from the desired database.
         * We pass 1 to sm->count_only to just traverse the entire xml
         * and count all chips.
         */
			if (sm->count_only ||
			    sm->db_data->version != sm->version)
				return XML_OK;

			// Grab the device name
			memblock = get_attribute(tag, taglen, NAME_ATTR);
			if (!memblock.b)
				return EXIT_FAILURE;
			char name[NAME_LEN];
			if (memblock.z > sizeof(name))
				return EXIT_FAILURE;
			memset(name, 0, sizeof(name));
			memcpy(name, memblock.b, memblock.z);

			// Only print device name
			if (sm->print_name) {
				// Print only devices that match the chip ID (SPI autodetect -a)
				if (sm->match_id) {
					if (compare_device(
						    tag, taglen, sm->device,
						    sm->db_data->version))
						return EXIT_FAILURE;
					if (strlen(sm->device->name)) {
						fprintf(stdout, "%s%s\n",
							sm->device->name,
							sm->custom == 1 ?
								"(custom)" :
								"");
						fflush(stdout);
						sm->found++;
						memset(sm->device->name, 0,
						       sizeof(sm->device->name));
					}
					return XML_OK;
				}

				// Print all devices that match the name (-l and -L)
				if (!sm->db_data->device_name ||
				    STRCASESTR(name,
					       sm->db_data->device_name)) {
					fprintf(stdout, "%s%s\n", name,
						sm->custom == 1 ? "(custom)" :
								  "");
					fflush(stdout);
				}
				return XML_OK;
			}

			// Search by chip ID (get_device_from_id)
			if (!sm->db_data->device_name) {
				if (sm->found && !sm->custom)
					return XML_OK;
				if (compare_device(tag, taglen, sm->device,
						   sm->db_data->version))
					return EXIT_FAILURE;
				if (strlen(sm->device->name))
					sm->found = 1;
				return XML_OK;
			}

			// Search and load device (-p and -d)
			if (strcasecmp(sm->db_data->device_name, name))
				return XML_OK;
			if (sm->found && !sm->custom)
				return XML_OK;
			if (load_device(sm->db_data, tag, taglen, sm->device,
					sm->db_data->version))
				return EXIT_FAILURE;
			sm->found = 1;
			sm->load_vectors = 1;

			// Clear the previous logic device (if any)
			if (sm->device->vectors) {
				free(sm->device->vectors);
				sm->device->vectors = NULL;
				sm->device->vector_count = 0;
			}
		}
		// Get database version
		if (tagcmpn(tag, taglen, DB_TAG))
			return XML_OK;
		memblock = get_attribute(tag, taglen, DEVICE_ATTR);
		if (memblock.b && !strncasecmp((char *)memblock.b,
					       TL866II_ATTR_NAME, memblock.z))
			sm->version = MP_TL866IIPLUS;
		else if (memblock.b &&
			 !strncasecmp((char *)memblock.b, TL866A_ATTR_NAME,
				      memblock.z))
			sm->version = MP_TL866A;
		else if (memblock.b &&
			 !strncasecmp((char *)memblock.b, LOGIC_ATTR_NAME,
				      memblock.z))
			sm->version = LOGIC_DATABASE;
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
			sm->device->vectors =
				realloc(sm->device->vectors,
					sm->device->package_details.pin_count *
						(sm->device->vector_count + 1));
			uint8_t *vector =
				sm->device->vectors +
				sm->device->package_details.pin_count *
					sm->device->vector_count;
			int n = 0;
			int i;
			for (i = 0; i < parser->contentlen; i++) {
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
				if (n > sm->device->package_details.pin_count)
					return EXIT_FAILURE;
			}
			if (n < sm->device->package_details.pin_count)
				return EXIT_FAILURE;
			sm->device->vector_count++;
		}
	}
	return XML_OK;
}

// Search and return database xml file
static FILE *get_database_file(const char *name, const char *cli_name)
{
	// Has the filename been overridden? If so, open it or fail now.
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

	// Avoid buffer overruns and keep to maximum lengths
	SHGetSpecialFolderPathA(NULL, appdata, CSIDL_COMMON_APPDATA, 0);
	int count =
		snprintf(path, sizeof(path), "%s\\minipro\\%s", appdata, name);

	// C99 and Windows (before Windows 10) differ in semantics. Check
	// both cases.
	if (count < 0 || count >= sizeof(path)) {
		fprintf(stderr, "Path %s\\minipro\\%s is too long.\n", appdata,
			name);
		return NULL;
	}
	path[sizeof(path) - 1] = '\0'; // Not needed now, but it can't hurt!

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

	// Open database xml file using current directory
	FILE *file = fopen(name, "rb");
	if (file)
		return file;

	// Format an error message for later, just in case
	char err[sizeof(path) + 1024];
	snprintf(err, sizeof(err), "%s: %s\n", path, strerror(errno));
	err[sizeof(err) - 1] = '\0';

	// No luck. Try the full path .
	file = fopen(path, "rb");
	if (file)
		return file;

	fputs(err, stderr); // Print previous error message too.
	perror(name);
	return NULL;
}

// Parse xml pin maps
static int parse_maps(state_machine_m_t *sm)
{
	// Open database xml file
	FILE *file = get_database_file(INFOIC_NAME, sm->db_data->infoic_path);
	if (!file)
		return EXIT_FAILURE;

	// Begin xml parse
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

// Parse xml profiles
static int parse_profiles(state_machine_p_t *sm)
{
	// Open database xml file
	FILE *file = get_database_file(INFOIC_NAME, sm->db_data->infoic_path);
	if (!file)
		return EXIT_FAILURE;

	// Begin xml parse
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

// Parse given xml file
static int parse_xml_file(void *sm, const char *name, const char *cli_name)
{
	// Open database xml file
	FILE *file = get_database_file(name, cli_name);
	if (!file)
		return EXIT_FAILURE;

	// Begin xml parse
	Parser parser = { .inputcbdata = file,
			  .worker = sax_callback,
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

// Parse xml database
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

// XML based device search
device_t *get_device_by_name(db_data_t *db_data)
{
	if (!db_data->device_name)
		return NULL;
	device_t *device = device = calloc(1, sizeof(device_t));
	if (!device) {
		fprintf(stderr, "Out of memory\n");
		return NULL;
	}
	if (db_data->version == MP_TL866CS)
		db_data->version = MP_TL866A;

	// Initialize state machine structure
	state_machine_d_t sm;
	memset(&sm, 0, sizeof(sm));
	sm.device = device;
	sm.version = -1;
	sm.custom = -1;
	sm.db_data = db_data;

	int ret = parse_xml(&sm);

	if (ret || !sm.found) {
		free(device);
		device = NULL;
	}
	return device;
}

// Get first device name found in the database from a device ID
const char *get_device_from_id(db_data_t *db_data)
{
	device_t device;
	device.chip_id = db_data->chip_id;
	device.protocol_id = db_data->protocol;
	device.package_details.pin_count = 0;
	memset(device.name, 0, sizeof(device.name));
	if (db_data->version == MP_TL866CS)
		db_data->version = MP_TL866A;

	// Initialize state machine structure
	state_machine_d_t sm;
	memset(&sm, 0, sizeof(sm));
	sm.device = &device;
	sm.version = -1;
	sm.custom = -1;
	sm.match_id = 1;
	sm.db_data = db_data;

	if (parse_xml(&sm))
		return NULL;
	return sm.found ? strdup(device.name) : NULL;
}

// List all devices from XML
// If name == NULL list all devices
int list_devices(db_data_t *db_data)
{
	device_t device;
	device.chip_id = db_data->chip_id;
	device.package_details.pin_count = db_data->pin_count;
	memset(device.name, 0, sizeof(device.name));
	if (db_data->version == MP_TL866CS)
		db_data->version = MP_TL866A;
	int flag = (db_data->chip_id || db_data->pin_count) ? 1 : 0;

	// Initialize state machine structure
	state_machine_d_t sm;
	memset(&sm, 0, sizeof(sm));
	sm.device = &device;
	sm.version = -1;
	sm.custom = -1;
	sm.print_name = 1;
	sm.match_id = flag;
	sm.db_data = db_data;

	if (parse_xml(&sm))
		return EXIT_FAILURE;
	if (db_data->count)
		*(db_data->count) = sm.found;
	return EXIT_SUCCESS;
}

// Print database chip count
int print_chip_count(db_data_t *db_data)
{
	// Initialize state machine structure
	state_machine_d_t sm;
	memset(&sm, 0, sizeof(sm));
	sm.version = -1;
	sm.custom = -1;
	sm.count_only = 1;
	sm.db_data = db_data;

	if (parse_xml(&sm))
		return EXIT_FAILURE;

	fprintf(stderr,
		"TL866A/CS:\t%5u devices, %u custom\nTL866II+:\t%5u devices, %u custom\n"
		"Logic:\t\t%5u devices, %u custom\n",
		sm.tl866a_count, sm.tl866a_custom_count, sm.tl866ii_count,
		sm.tl866ii_custom_count, sm.logic_count, sm.logic_custom_count);
	return EXIT_SUCCESS;
}

// Get a pointer to the pin_map_t structure specified by index
pin_map_t *get_pin_map(db_data_t *db_data)
{
	if (!db_data->index) {
		fprintf(stderr, "Pin test is not available for this chip.\n");
		return NULL;
	}
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
