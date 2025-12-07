/*
 * main.c - User interface and high-level operations.
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

#include <ctype.h>
#include <errno.h>
#include <libgen.h>
#include <signal.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <getopt.h>
#include <unistd.h>

#include "database.h"
#include "jedec.h"
#include "ihex.h"
#include "srec.h"
#include "minipro.h"
#include "version.h"

#ifdef _WIN32
#include <shlwapi.h>
#include <fcntl.h>
#define STRCASESTR StrStrIA
#else
#define STRCASESTR strcasestr
#endif

#define VPP_VOLTAGE	 0
#define VCC_VOLTAGE	 1

#define READ_BUFFER_SIZE 65536
#define MIN(a, b)	 (((a) < (b)) ? (a) : (b))

static const char *user_id[] = {
	"user_id0", "user_id1", "user_id2", "user_id3",
	"user_id4", "user_id5", "user_id6", "user_id7"
};

static struct voltage_s {
	const char *name;
	uint8_t value;
} tl866a_vpp_voltages[] = { { "10", 0x04 }, { "12.5", 0x00 }, { "13.5", 0x03 },
			    { "14", 0x05 }, { "16", 0x01 },   { "17", 0x07 },
			    { "18", 0x06 }, { "21", 0x02 },   { NULL, 0x00 } },
  tl866a_vcc_voltages[] = { { "3.3", 0x02 }, { "4", 0x01 },   { "4.5", 0x05 },
			    { "5", 0x00 },   { "5.5", 0x04 }, { "6.5", 0x03 },
			    { NULL, 0x00 } },
  tl866ii_vpp_voltages[] = { { "9", 0x01 },    { "9.5", 0x02 },
			     { "10", 0x03 },   { "11", 0x04 },
			     { "11.5", 0x05 }, { "12", 0x00 },
			     { "12.5", 0x06 }, { "13", 0x07 },
			     { "13.5", 0x08 }, { "14", 0x09 },
			     { "14.5", 0x0a }, { "15.5", 0x0b },
			     { "16", 0x0c },   { "16.5", 0x0d },
			     { "17", 0x0e },   { "18", 0x0f },
			     { NULL, 0x00 } },
  tl866ii_vcc_voltages[] = { { "3.3", 0x01 }, { "4", 0x02 },   { "4.5", 0x03 },
			     { "5", 0x00 },   { "5.5", 0x04 }, { "6.5", 0x05 },
			     { NULL, 0x00 } },
  logic_voltages[] = { { "5", 0x00 },
		       { "3.3", 0x01 },
		       { "2.5", 0x02 },
		       { "1.8", 0x03 },
		       { NULL, 0x00 } };

static struct option long_options[] = {
	{ "pulse", required_argument, NULL, 2 },
	{ "vpp", required_argument, NULL, 2 },
	{ "vdd", required_argument, NULL, 2 },
	{ "vcc", required_argument, NULL, 2 },
	{ "fuses", no_argument, NULL, 1 },
	{ "uid", no_argument, NULL, 1 },
	{ "lock", no_argument, NULL, 1 },
	{ "infoic", required_argument, NULL, 3 },
	{ "logicic", required_argument, NULL, 4 },
	{ "list", no_argument, NULL, 'l' },
	{ "search", required_argument, NULL, 'L' },
	{ "get_info", required_argument, NULL, 'd' },
	{ "device", required_argument, NULL, 'p' },
	{ "programmer", required_argument, NULL, 'q' },
	{ "presence_check", no_argument, NULL, 'k' },
	{ "query_supported", no_argument, NULL, 'Q' },
	{ "auto_detect", required_argument, NULL, 'a' },
	{ "write", required_argument, NULL, 'w' },
	{ "read", required_argument, NULL, 'r' },
	{ "verify", required_argument, NULL, 'm' },
	{ "blank_check", no_argument, NULL, 'b' },
	{ "erase", no_argument, NULL, 'E' },
	{ "read_id", no_argument, NULL, 'D' },
	{ "page", required_argument, NULL, 'c' },
	{ "skip_erase", no_argument, NULL, 'e' },
	{ "skip_verify", no_argument, NULL, 'v' },
	{ "skip_id", no_argument, NULL, 'x' },
	{ "no_size_error", no_argument, NULL, 's' },
	{ "no_size_warning", no_argument, NULL, 'S' },
	{ "no_id_error", no_argument, NULL, 'y' },
	{ "format", required_argument, NULL, 'f' },
	{ "version", no_argument, NULL, 'V' },
	{ "pin_check", no_argument, NULL, 'z' },
	{ "logic_test", no_argument, NULL, 'T' },
	{ "icsp_vcc", no_argument, NULL, 'i' },
	{ "icsp_no_vcc", no_argument, NULL, 'I' },
	{ "protect", no_argument, NULL, 'P' },
	{ "unprotect", no_argument, NULL, 'u' },
	{ "hardware_check", no_argument, NULL, 't' },
	{ "update", required_argument, NULL, 'F' },
	{ "help", no_argument, NULL, 'h' },
	{ NULL, 0, NULL, 0 }
};

void print_version_and_exit(cmdopts_t *cmdopts)
{
	fprintf(stderr, "Supported programmers: TL866A/CS, TL866II+\n");
	minipro_handle_t *handle = minipro_open(VERBOSE);
	if (handle) {
		minipro_print_system_info(handle);
		fprintf(stderr, "Device code: %s\nSerial code: %s\n",
			handle->device_code, handle->serial_number);
		if (handle->status == MP_STATUS_BOOTLOADER) {
			fprintf(stderr, "in bootloader mode!\n");
		}
		minipro_close(handle);
	}

	char output[] =
		"minipro version %s     A free and open TL866XX programmer\n"
		"Commit date:\t%s\n"
		"Git commit:\t%s\n"
		"Git branch:\t%s\n";
	fprintf(stderr, output, VERSION, GIT_DATE, GIT_HASH, GIT_BRANCH);
	db_data_t db_data;
	memset(&db_data, 0, sizeof(db_data));
	db_data.logicic_path = cmdopts->logicic_path;
	db_data.infoic_path = cmdopts->infoic_path;
	exit(print_chip_count(&db_data));
}

/* Add usage information to the manpage in man/minipro.1, not here. */
void print_help_and_exit(char *progname)
{
	char usage[] =
		"minipro version %s     A free and open TL866XX programmer\n"
		"Usage: %s [options]\n"
		"See the manual page (type \"man minipro\" for documentation)\n\n";
	fprintf(stderr, usage, VERSION, basename(progname));
	exit(EXIT_FAILURE);
}

int get_programmer_version(uint8_t *version)
{
	if (!(minipro_get_devices_count(MP_TL866A) +
	      minipro_get_devices_count(MP_TL866IIPLUS))) {
		if (!(*version)) {
			fprintf(stderr,
				"No TL866 device found. Which database do you want to display?\n1) "
				"TL866A\n2) TL866II+\n3) Abort\n");
			fflush(stderr);
			char c = getchar();
			switch (c) {
			case '1':
				*version = MP_TL866A;
				break;
			case '2':
				*version = MP_TL866IIPLUS;
				break;
			default:
				fprintf(stderr, "Aborted.\n");
				return EXIT_FAILURE;
			}
		}
	} else if (!(*version)) {
		minipro_handle_t *tmp = minipro_open(VERBOSE);
		if (!tmp) {
			return EXIT_FAILURE;
		}
		minipro_print_system_info(tmp);
		fflush(stderr);
		*version = tmp->version;
		minipro_close(tmp);
	}
	return EXIT_SUCCESS;
}

void print_supported_programmers_and_exit()
{
	fprintf(stderr, "tl866a: TL866CS/A\ntl866ii: TL866II+\n");
	exit(EXIT_SUCCESS);
}

void print_connected_programmer_and_exit()
{
	minipro_handle_t *handle = minipro_open(NO_VERBOSE);
	if (!handle) {
		fprintf(stderr, "[No programmer found]\n");
	} else {
		switch (handle->version) {
		case MP_TL866A:
			fprintf(stderr, "tl866a: TL866A\n");
			break;
		case MP_TL866CS:
			fprintf(stderr, "tl866a: TL866CS\n");
			break;
		case MP_TL866IIPLUS:
			fprintf(stderr, "tl866ii: TL866II+\n");
			break;
		default:
			fprintf(stderr, "[Unknown programmer version]\n");
		}
		free(handle);
	}
	exit(EXIT_SUCCESS);
}

void print_devices_and_exit(cmdopts_t *cmdopts)
{
	db_data_t db_data;
	memset(&db_data, 0, sizeof(db_data));
	db_data.device_name = cmdopts->device_name;
	db_data.logicic_path = cmdopts->logicic_path;
	db_data.infoic_path = cmdopts->infoic_path;
	db_data.version = cmdopts->version;
	if (get_programmer_version(&db_data.version))
		exit(EXIT_FAILURE);

	// If less is available under windows use it, otherwise just use more.
	char *PAGER = "less";
	FILE *pager = NULL;
#ifdef _WIN32
	if (system("where less >nul 2>&1"))
		PAGER = "more";
#endif

	// Detecting the mintty in windows
	// The default isatty always return false
	if (
#ifdef _WIN32
		_fileno(stdout)
#else
		isatty(STDOUT_FILENO)
#endif
		&& !cmdopts->device_name) {
		// stdout is a terminal, opening pager
		signal(SIGINT, SIG_IGN);
		char *pager_program = getenv("PAGER");
		if (!pager_program)
			pager_program = PAGER;
		pager = popen(pager_program, "w");
		dup2(fileno(pager), STDOUT_FILENO);
	}

	list_devices(&db_data);

	if (pager) {
		close(STDOUT_FILENO);
		pclose(pager);
	}

	exit(EXIT_SUCCESS);
}

// Get a voltage string from an integer
const char *get_voltage(minipro_handle_t *handle, uint8_t value, uint8_t type)
{
	struct voltage_s *vpp_voltages = (handle->version == MP_TL866IIPLUS ?
						  tl866ii_vpp_voltages :
						  tl866a_vpp_voltages);
	struct voltage_s *vcc_voltages = (handle->version == MP_TL866IIPLUS ?
						  tl866ii_vcc_voltages :
						  tl866a_vcc_voltages);
	struct voltage_s *voltage = (type == VPP_VOLTAGE ? vpp_voltages :
				     handle->device->chip_type == MP_LOGIC ?
							   logic_voltages :
							   vcc_voltages);
	while (voltage->name) {
		if (voltage->value == value) {
			return voltage->name;
		}
		voltage++;
	}
	return "-";
}

// Get an integer from a string voltage name
int set_voltage(minipro_handle_t *handle, char *value, uint8_t *target,
		uint8_t type)
{
	struct voltage_s *vpp_voltages = (handle->version == MP_TL866IIPLUS ?
						  tl866ii_vpp_voltages :
						  tl866a_vpp_voltages);
	struct voltage_s *vcc_voltages = (handle->version == MP_TL866IIPLUS ?
						  tl866ii_vcc_voltages :
						  tl866a_vcc_voltages);
	struct voltage_s *voltage = (type == VPP_VOLTAGE ? vpp_voltages :
				     handle->device->chip_type == MP_LOGIC ?
							   logic_voltages :
							   vcc_voltages);
	while (voltage->name) {
		if (!strcasecmp(voltage->name, value)) {
			*target = voltage->value;
			return EXIT_SUCCESS;
		}
		voltage++;
	}
	return EXIT_FAILURE;
}

int get_device(minipro_handle_t *handle)
{
	db_data_t db_data;
	memset(&db_data, 0, sizeof(db_data));
	db_data.device_name = handle->cmdopts->device_name;
	db_data.logicic_path = handle->cmdopts->logicic_path;
	db_data.infoic_path = handle->cmdopts->infoic_path;
	db_data.version = handle->version;
	handle->device = get_device_by_name(&db_data);
	if (!handle->device) {
		fprintf(stderr, "Device %s not found!\n",
			handle->cmdopts->device_name);
		return EXIT_FAILURE;
	}
	return EXIT_SUCCESS;
}

void print_device_info_and_exit(cmdopts_t *cmdopts)
{
	minipro_handle_t *handle = calloc(1, sizeof(minipro_handle_t));
	if (!handle) {
		fprintf(stderr, "Out of memory!\n");
	}
	handle->cmdopts = cmdopts;
	handle->version = cmdopts->version;
	if (get_programmer_version(&handle->version))
		exit(EXIT_FAILURE);
	if (get_device(handle)) {
		minipro_close(handle);
		exit(EXIT_FAILURE);
	}
	device_t *device = handle->device;

	fprintf(stderr, "Name: %s\n", device->name);

	if (device->chip_type == MP_LOGIC) {
		fprintf(stderr,
			"Package:\t DIP%d\nVCC voltage:\t %sV\nVector count:\t %d\n",
			device->package_details.pin_count,
			get_voltage(handle, device->voltages.vcc, VCC_VOLTAGE),
			device->vector_count);

	} else {
		/* Memory shape */
		fprintf(stderr, "Memory: %u",
			device->code_memory_size / device->flags.word_size);
		switch (device->flags.data_org) {
		case 0:
			fprintf(stderr, " Bytes");
			break;
		case 1:
			fprintf(stderr, " Words");
			break;
		case 2:
			fprintf(stderr, " Bits");
			break;
		default:
			fprintf(stderr, "Unknown memory shape: 0x%x\n",
				device->flags.data_org);
			minipro_close(handle);
			exit(EXIT_FAILURE);
		}
		if (device->data_memory_size) {
			fprintf(stderr, " + %u Bytes",
				device->data_memory_size);
		}
		if (device->data_memory2_size) {
			fprintf(stderr, " + %u Bytes",
				device->data_memory2_size);
		}
		fprintf(stderr, "\n");

		/* Package info */
		fprintf(stderr, "Package: ");
		if (device->package_details.adapter) {
			fprintf(stderr, "Adapter%03d.JPG\n",
				device->package_details.adapter);
		} else if (device->package_details.pin_count) {
			fprintf(stderr, "DIP%d\n",
				device->package_details.pin_count);
		} else {
			fprintf(stderr, "ICSP only\n");
		}

		/* ICSP connection info */
		fprintf(stderr, "ICSP: ");
		if (device->package_details.icsp) {
			fprintf(stderr, "ICP%03d.JPG\n",
				device->package_details.icsp);
		} else {
			fprintf(stderr, "-\n");
		}

		fprintf(stderr, "Protocol: 0x%02x\n", device->protocol_id);
		fprintf(stderr, "Read buffer size: %u Bytes\n",
			device->read_buffer_size);
		fprintf(stderr, "Write buffer size: %u Bytes\n",
			device->write_buffer_size);

		// Printing device programming info
		if (device->flags.can_adjust_vcc ||
		    device->flags.can_adjust_vpp) {
			// Print VPP
			fprintf(stderr,
				"*******************************\nVPP programming voltage: %sV\n",
				get_voltage(handle, device->voltages.vpp,
					    VPP_VOLTAGE));
			if (device->flags.can_adjust_vcc) {
				// Print VDD
				fprintf(stderr, "VDD write voltage: %sV\n",
					get_voltage(handle,
						    device->voltages.vdd,
						    VCC_VOLTAGE));

				// Print VCC
				fprintf(stderr, "VCC verify voltage: %sV\n",
					get_voltage(handle,
						    device->voltages.vcc,
						    VCC_VOLTAGE));

				// Print pulse delay
				fprintf(stderr, "Pulse delay: %uus\n",
					device->pulse_delay);
			}
		}
	}
	minipro_close(handle);
	exit(EXIT_SUCCESS);
}

// Parse and set programming options for both TL866A/CS and TL866II+
int parse_options(minipro_handle_t *handle, int argc, char **argv)
{
	uint32_t v;
	int8_t c;
	char *p_end, option[64], value[64];
	int opt_idx = 0;
	device_t *device = handle->device;

	// Parse options first
	optind = 1;
	opterr = 0;

	while ((c = getopt_long(argc, argv, "o:", long_options, &opt_idx)) !=
	       -1) {
		switch (c) {
		case 2:
			if (!strlen(optarg)) {
				fprintf(stderr,
					"%s: option '--%s' requires an argument\n",
					argv[0], long_options[opt_idx].name);
				return EXIT_FAILURE;
			}
			switch (opt_idx) {
			case 0:
				errno = 0;
				v = strtoul(optarg, &p_end, 10);
				if ((p_end == optarg) || errno)
					return EXIT_FAILURE;
				if (v > 0xffff)
					return EXIT_FAILURE;
				device->pulse_delay = (uint16_t)v;
				break;
			case 1:
				if (set_voltage(handle, optarg,
						&device->voltages.vpp,
						VPP_VOLTAGE))
					return EXIT_FAILURE;
				break;
			case 2:
				if (set_voltage(handle, optarg,
						&device->voltages.vdd,
						VCC_VOLTAGE))
					return EXIT_FAILURE;
				break;
			case 3:
				if (set_voltage(handle, optarg,
						&device->voltages.vcc,
						VCC_VOLTAGE))
					return EXIT_FAILURE;
				break;
			default:
				return EXIT_FAILURE;
			}
			break;
		case 'o':
			if (sscanf(optarg, "%[^=]=%[^=]", option, value) != 2)
				return EXIT_FAILURE;
			if (!strcasecmp(option, "pulse")) {
				// Parse the numeric value
				errno = 0;
				v = strtoul(value, &p_end, 10);
				if ((p_end == value) || errno)
					return EXIT_FAILURE;
				if (v > 0xffff)
					return EXIT_FAILURE;
				handle->device->pulse_delay = (uint16_t)v;
			} else if (!strcasecmp(option, "vpp")) {
				if (set_voltage(handle, value,
						&device->voltages.vpp,
						VPP_VOLTAGE))
					return EXIT_FAILURE;
			} else if (!strcasecmp(option, "vdd")) {
				if (set_voltage(handle, value,
						&device->voltages.vdd,
						VCC_VOLTAGE))
					return EXIT_FAILURE;
			} else if (!strcasecmp(option, "vcc")) {
				if (set_voltage(handle, value,
						&device->voltages.vcc,
						VCC_VOLTAGE))
					return EXIT_FAILURE;
			} else
				return EXIT_FAILURE;
			break;
		}
	}

	// Exit if we are in logic test mode
	if (handle->device->chip_type == MP_LOGIC)
		return EXIT_SUCCESS;

	// Set the programming options
	if ((handle->device->flags.can_adjust_vcc ||
	     handle->device->flags.can_adjust_vpp) &&
	    handle->cmdopts->action == WRITE) {
		// Print VPP
		fprintf(stderr, "\nVPP=%sV",
			get_voltage(handle, device->voltages.vpp, VPP_VOLTAGE));

		if (handle->device->flags.can_adjust_vcc) {
			// Print VDD
			fprintf(stderr, ", VDD=%sV, ",
				get_voltage(handle, device->voltages.vdd,
					    VCC_VOLTAGE));

			// Print VCC
			fprintf(stderr, "VCC=%sV, ",
				get_voltage(handle, device->voltages.vcc,
					    VCC_VOLTAGE));

			// Print pulse delay
			fprintf(stderr, "Pulse=%uus\n",
				handle->device->pulse_delay);
		}
	}
	return EXIT_SUCCESS;
}

void hardware_check_and_exit()
{
	minipro_handle_t *handle = minipro_open(VERBOSE);
	if (!handle) {
		exit(EXIT_FAILURE);
	}

	minipro_print_system_info(handle);
	if (handle->status == MP_STATUS_BOOTLOADER) {
		fprintf(stderr, "in bootloader mode!\nExiting...\n");
		exit(EXIT_FAILURE);
	}

	int ret = minipro_hardware_check(handle);
	minipro_close(handle);
	exit(ret);
}

void firmware_update_and_exit(const char *firmware)
{
	minipro_handle_t *handle = minipro_open(VERBOSE);
	if (!handle) {
		exit(EXIT_FAILURE);
	}
	minipro_print_system_info(handle);
	if (handle->status == MP_STATUS_BOOTLOADER)
		fprintf(stderr, "in bootloader mode!\n");
	int ret = minipro_firmware_update(handle, firmware);
	minipro_close(handle);
	exit(ret);
}

// Autodetect 25xx SPI devices
void spi_autodetect_and_exit(uint8_t package_type, cmdopts_t *cmdopts)
{
	minipro_handle_t *handle = minipro_open(VERBOSE);
	if (!handle) {
		exit(EXIT_FAILURE);
	}
	minipro_print_system_info(handle);
	if (handle->status == MP_STATUS_BOOTLOADER) {
		fprintf(stderr, "in bootloader mode!\n");
		exit(EXIT_FAILURE);
	}
	uint32_t chip_id, count = 0;
	handle->cmdopts = cmdopts;

	if (cmdopts->pincheck) {
		if (handle->version == MP_TL866IIPLUS) {
			device_t device;
			device.pin_map = (package_type == 8 ? 0x01 : 0x03);
			handle->device = &device;
			if (minipro_pin_test(handle)) {
				minipro_end_transaction(handle);
				handle->device = NULL;
				minipro_close(handle);
				exit(EXIT_FAILURE);
			}
		} else
			fprintf(stderr, "Pin test is not supported.\n");
	}

	if (minipro_spi_autodetect(handle, package_type >> 4, &chip_id)) {
		exit(EXIT_FAILURE);
	}

	db_data_t db_data;
	memset(&db_data, 0, sizeof(db_data));
	db_data.logicic_path = cmdopts->logicic_path;
	db_data.infoic_path = cmdopts->infoic_path;
	db_data.chip_id = chip_id;
	db_data.pin_count = package_type;
	db_data.version = handle->version;
	db_data.count = &count;
	fprintf(stderr, "Autodetecting device (ID:0x%04X)\n", chip_id);
	if (list_devices(&db_data)) {
		minipro_close(handle);
		exit(EXIT_FAILURE);
	}

	fprintf(stderr, "%u device(s) found.\n", count);
	handle->device = NULL;
	minipro_close(handle);
	exit(EXIT_SUCCESS);
}

void parse_cmdline(int argc, char **argv, cmdopts_t *cmdopts)
{
	int8_t c;
	uint8_t package_type = 0;
	void (*p_func)(cmdopts_t *) = NULL;

	memset(cmdopts, 0, sizeof(cmdopts_t));
	long_options[4].flag = &cmdopts->filter_fuses;
	long_options[5].flag = &cmdopts->filter_uid;
	long_options[6].flag = &cmdopts->filter_locks;
	while ((c = getopt_long(argc, argv,
				"lL:q:Qkd:ea:zEbTuPvxyr:w:m:p:c:o:iIsSVhDtf:F:",
				long_options, NULL)) != -1) {
		switch (c) {
		case 0:
		case 2: // Skip vdd, vcc, vpp, pulse here
			break;
		case 3:
			cmdopts->infoic_path = optarg; // Custom infoic.xml
			break;
		case 4:
			cmdopts->logicic_path = optarg; // Custom logicic.xml
			break;

		case 'q':
			if (!strcasecmp(optarg, "tl866a"))
				cmdopts->version = MP_TL866A;
			else if (!strcasecmp(optarg, "tl866ii"))
				cmdopts->version = MP_TL866IIPLUS;
			else {
				fprintf(stderr,
					"Unknown programmer version (%s).\n",
					optarg);
				print_help_and_exit(argv[0]);
			}
			break;

		case 'Q':
			p_func = print_supported_programmers_and_exit;
			break;

		case 'k':
			p_func = print_connected_programmer_and_exit;
			break;

		case 'l':
			p_func = print_devices_and_exit;
			break;

		case 'L':
			cmdopts->device_name = optarg;
			p_func = print_devices_and_exit;
			break;

		case 'd':
			cmdopts->device_name = optarg;
			p_func = print_device_info_and_exit;
			break;

		case 'e':
			cmdopts->no_erase = 1; // 1= do not erase
			break;

		case 'u':
			cmdopts->protect_off = 1; // 1 = disable write protect
			break;

		case 'P':
			cmdopts->protect_on = 1; // 1 =  enable write protect
			break;

		case 'v':
			cmdopts->no_verify = 1; // 1= do not verify
			break;

		case 'x':
			cmdopts->idcheck_skip = 1; // 1= do not test id at all
			break;

		case 'y':
			cmdopts->idcheck_continue =
				1; // 1= do not stop on id mismatch
			break;

		case 'z':
			cmdopts->pincheck = 1; // 1= Check for bad pin contact
			break;

		case 'p':
			if (!strcasecmp(optarg, "help"))
				print_devices_and_exit(cmdopts);
			cmdopts->device_name = optarg;
			break;

		case 'c':
			if (!strcasecmp(optarg, "code"))
				cmdopts->page = CODE;
			else if (!strcasecmp(optarg, "data"))
				cmdopts->page = DATA;
			else if (!strcasecmp(optarg, "user"))
				cmdopts->page = USER;
			else if (!strcasecmp(optarg, "config"))
				cmdopts->page = CONFIG;
			else if (!strcasecmp(optarg, "calibration"))
				cmdopts->page = CALIBRATION;
			else {
				fprintf(stderr, "Unknown memory type\n");
				exit(EXIT_FAILURE);
			}
			break;

		case 'f':
			if (!strcasecmp(optarg, "ihex"))
				cmdopts->format = IHEX;
			if (!strcasecmp(optarg, "srec"))
				cmdopts->format = SREC;
			if (!cmdopts->format) {
				fprintf(stderr, "Unknown file format\n");
				exit(EXIT_FAILURE);
			}
			break;

		case 'r':
			cmdopts->action = READ;
			cmdopts->filename = optarg;
			break;

		case 'w':
			if (cmdopts->action == ERASE)
				cmdopts->force_erase = 1;
			cmdopts->action = WRITE;
			cmdopts->filename = optarg;
			break;

		case 'm':
			cmdopts->action = VERIFY;
			cmdopts->filename = optarg;
			break;

		case 'E':
			if (cmdopts->action != NO_ACTION)
				cmdopts->force_erase = 1;
			else
				cmdopts->action = ERASE;
			break;

		case 'b':
			cmdopts->action = BLANK_CHECK;
			break;

		case 'T':
			cmdopts->action = LOGIC_IC_TEST;
			break;

		case 'a':
			if (!strcasecmp(optarg, "8"))
				package_type = 8;
			else if (!strcasecmp(optarg, "16"))
				package_type = 16;
			else {
				fprintf(stderr, "Invalid argument.\n");
				print_help_and_exit(argv[0]);
			}
			break;

		case 'i':
			cmdopts->icsp = MP_ICSP_ENABLE | MP_ICSP_VCC;
			break;

		case 'I':
			cmdopts->icsp = MP_ICSP_ENABLE;
			break;

		case 'S':
			cmdopts->size_nowarn = 1;
			cmdopts->size_error = 1;
			break;

		case 's':
			cmdopts->size_error = 1;
			break;

		case 'D':
			cmdopts->idcheck_only = 1;
			break;

		case 'h':
			print_help_and_exit(argv[0]);
			break;

		case 'V':
			p_func = print_version_and_exit;
			break;

		case 't':
			hardware_check_and_exit();
			break;

		/*
       * Only check if the syntax is correct here.
       * The actual parsing of each 'o' option is done after the programmer
       * version is known.
       */
		case 'o':
			break;
		case 'F':
			firmware_update_and_exit(optarg);
			break;
		default:
			print_help_and_exit(argv[0]);
			break;
		}
	}

	if (optind < argc) {
		fprintf(stderr, "Extra argument: '%s'\n", argv[optind]);
		print_help_and_exit(argv[0]);
	}

	if (cmdopts->filter_fuses || cmdopts->filter_locks ||
	    cmdopts->filter_uid)
		cmdopts->page = CONFIG;
	if (cmdopts->version && !p_func) {
		fprintf(stderr,
			"-L, -l or -d command is required for this action.\n");
		print_help_and_exit(argv[0]);
	}
	if (p_func)
		p_func(cmdopts);
	if (package_type)
		spi_autodetect_and_exit(package_type, cmdopts);
}

// Search for config name in buffer.
int get_config_value(const char *buffer, const char *name, uint16_t *value)
{
	char *cur, *eol, *val;
	char num[128];
	for (;;) {
		cur = STRCASESTR(buffer, name); // find the line
		if (!cur)
			return EXIT_FAILURE;
		eol = STRCASESTR(cur, (char *)"\n"); // find the end of line
		if (!cur)
			return EXIT_FAILURE;
		cur = STRCASESTR(
			cur,
			(char *)"="); // find the '=' sign in the current line
		if (!cur)
			return EXIT_FAILURE;
		cur = STRCASESTR(
			cur,
			(char *)"0x"); // find the value in the current line
		if (!cur)
			return EXIT_FAILURE;
		val = num;
		cur += 2; // Advances the pointer to the first numeric character
		while (cur < eol) {
			if (isxdigit((int)*cur++)) // check for hex digit
			{
				*val++ = *(cur - 1); // put it in the buffer
			}
		}
		// here we reached the end of line
		*val = 0;	// insert null terminated string char
		if (val == num) // if no numeric value found exit with error
			break;
		else {
			*value = (uint16_t)strtol((char *)num, NULL,
						  16); // convert value
			return EXIT_SUCCESS;
		}
	}
	return EXIT_FAILURE;
}

void update_status(char *status_msg, char *fmt, ...)
{
	va_list args;
	va_start(args, fmt);
	fprintf(stderr, "\r\e[K%s", status_msg);
	vfprintf(stderr, fmt, args);
	fflush(stderr);
	va_end(args);
}

int compare_memory(uint8_t compare_mask, uint8_t *s1, uint8_t *s2, size_t size1,
		   size_t size2, uint32_t *address, uint8_t *c1, uint8_t *c2)
{
	size_t i;
	uint8_t v1, v2;
	size_t size = (size1 > size2) ? size2 : size1;
	for (i = 0; i < size; i++) {
		v1 = (i < size1) ?
			     s1[i] :
			     compare_mask; // use mask value when buffer too short
		v2 = (i < size2) ? s2[i] : compare_mask;
		v1 &= compare_mask;
		v2 &= compare_mask;
		if (v1 != v2) {
			if (address)
				*address = i;
			if (c1)
				*c1 = v1;
			if (c2)
				*c2 = v2;
			return EXIT_FAILURE;
		}
	}
	return EXIT_SUCCESS;
}

// returned value will be a byte offset
// sizes are in bytes
// replacement_value needs to be in native byte order
// sizes can be odd
int compare_word_memory(uint16_t replacement_value, uint16_t compare_mask,
			uint8_t little_endian, uint8_t *s1, uint8_t *s2,
			size_t size1, size_t size2, uint32_t *address,
			uint16_t *c1, uint16_t *c2)
{
	size_t i;
	uint16_t v1, v2;
	size_t size = (size1 > size2) ? size2 : size1;
	if (compare_mask == 0)
		compare_mask = 0xffff;
	uint8_t rvl = (replacement_value & compare_mask) & 0xff;
	uint8_t rvh = ((replacement_value & compare_mask) >> 8) & 0xff;

	for (i = 0; i < size; i += 2) {
		if (little_endian) {
			v1 = (i < size1) ? s1[i] : rvl;
			v1 |= (((i + 1) < size1) ? s1[i + 1] : rvh) << 8;
			v2 = (i < size2) ? s2[i] : rvl;
			v2 |= (((i + 1) < size2) ? s2[i + 1] : rvh) << 8;
		} else {
			v1 = ((i < size1) ? s1[i] : rvh) << 8;
			v1 |= ((i + 1) < size1) ? (s1[i + 1]) : rvl;
			v2 = ((i < size2) ? s2[i] : rvh) << 8;
			v2 |= ((i + 1) < size2) ? (s2[i + 1]) : rvl;
		}
		if ((v1 & compare_mask) != (v2 & compare_mask)) {
			if (address)
				*address = i;
			if (c1)
				*c1 = v1;
			if (c2)
				*c2 = v2;
			return EXIT_FAILURE;
		}
	}
	return EXIT_SUCCESS;
}

/* RAM-centric IO operations */
int read_page_ram(minipro_handle_t *handle, uint8_t *buf, uint8_t type,
		  size_t size)
{
	char status_msg[64], *name;
	switch (type) {
	case MP_DATA:
		name = "Data";
		break;
	case MP_USER:
		name = "User";
		break;
	default:
		name = "Code";
	}
	snprintf(status_msg, sizeof(status_msg), "Reading %s...  ", name);

	size_t buffer_size = size < handle->device->read_buffer_size ?
				     size :
				     handle->device->read_buffer_size;
	size_t blocks_count = size / buffer_size;
	if (size % buffer_size)
		blocks_count++;

	struct timeval begin, end;
	gettimeofday(&begin, NULL);

	// Some controllers have data memory (eeprom) mapped to a different address
	// than 0 in programming mode. For ex. AT89S8252
	uint32_t offset = (handle->device->flags.has_data_offset) ?
				  handle->device->page_size :
				  0;
	uint32_t address;
	size_t i;
	for (i = 0; i < blocks_count; i++) {
		update_status(status_msg, "%2d%%", i * 100 / blocks_count);
		// Translating address to protocol-specific
		address = i * buffer_size + offset;
		if (handle->device->flags.has_word && type == MP_CODE)
			address = address >> 1;

		if (minipro_read_block(handle, type, address,
				       buf + i * buffer_size, buffer_size))
			return EXIT_FAILURE;

		uint8_t ovc;
		if (minipro_get_ovc_status(handle, NULL, &ovc))
			return EXIT_FAILURE;
		if (ovc) {
			fprintf(stderr, "\nOvercurrent protection!\007\n");
			return EXIT_FAILURE;
		}
	}
	gettimeofday(&end, NULL);
	snprintf(status_msg, sizeof(status_msg), "Reading %s...  %.2fSec  OK",
		 name,
		 (double)(end.tv_usec - begin.tv_usec) / 1000000 +
			 (double)(end.tv_sec - begin.tv_sec));
	update_status(status_msg, "\n");
	return EXIT_SUCCESS;
}

int write_page_ram(minipro_handle_t *handle, uint8_t *buffer, uint8_t type,
		   size_t size)
{
	char status_msg[64], *name;
	switch (type) {
	case MP_DATA:
		name = "Data";
		break;
	case MP_USER:
		name = "User";
		break;
	default:
		name = "Code";
	}
	snprintf(status_msg, sizeof(status_msg), "Writing  %s...  ", name);

	size_t buffer_size = handle->device->write_buffer_size;
	size_t blocks_count = size / buffer_size;
	if (size % buffer_size)
		blocks_count++;

	struct timeval begin, end;
	gettimeofday(&begin, NULL);
	minipro_status_t status;
	size_t i;
	// Some controllers have data memory (eeprom) mapped to a different address
	// than 0 in programming mode. For ex. AT89S8252
	uint32_t offset = (handle->device->flags.has_data_offset) ?
				  handle->device->page_size :
				  0;
	uint32_t address;
	for (i = 0; i < blocks_count; i++) {
		update_status(status_msg, "%2d%%", i * 100 / blocks_count);
		// Translating address to protocol-specific
		address = i * buffer_size + offset;
		if (handle->device->flags.has_word && type == MP_CODE)
			address = address >> 1;

		// Last block
		if ((i + 1) * buffer_size > size)
			buffer_size = size % buffer_size;
		if (minipro_write_block(handle, type, address,
					buffer + i * buffer_size, buffer_size))
			return EXIT_FAILURE;

		uint8_t ovc = 0;
		if (minipro_get_ovc_status(handle, &status, &ovc))
			return EXIT_FAILURE;
		if (ovc) {
			fprintf(stderr, "\nOvercurrent protection!\007\n");
			return EXIT_FAILURE;
		}
		if (status.error && !handle->cmdopts->no_verify) {
			if (minipro_end_transaction(handle))
				return EXIT_FAILURE;
			fprintf(stderr,
				"\nVerification failed at address 0x%04X: File=0x%02X, "
				"Device=0x%02X\n",
				status.address,
				status.c2 &
					(handle->device->flags.word_size == 1 ?
						 0xFF :
						 0xFFFF),
				status.c1 &
					(handle->device->flags.word_size == 1 ?
						 0xFF :
						 0xFFFF));
			return EXIT_FAILURE;
		}
	}
	gettimeofday(&end, NULL);
	snprintf(status_msg, sizeof(status_msg), "Writing %s...  %.2fSec  OK",
		 name,
		 (double)(end.tv_usec - begin.tv_usec) / 1000000 +
			 (double)(end.tv_sec - begin.tv_sec));
	update_status(status_msg, "\n");
	return EXIT_SUCCESS;
}

// Read PLD device
int read_jedec(minipro_handle_t *handle, jedec_t *jedec)
{
	size_t i, j;
	struct timeval begin, end;
	gettimeofday(&begin, NULL);

	char status_msg[64];
	snprintf(status_msg, sizeof(status_msg), "Reading device... ");
	uint8_t buffer[32];
	gal_config_t *config = (gal_config_t *)handle->device->config;

	uint8_t ovc = 0;
	if (minipro_get_ovc_status(handle, NULL, &ovc))
		return EXIT_FAILURE;
	if (ovc) {
		fprintf(stderr, "\nOvercurrent protection!\007\n");
		return EXIT_FAILURE;
	}

	// Read fuses
	memset(jedec->fuses, 0, jedec->QF);
	for (i = 0; i < config->fuses_size; i++) {
		if (minipro_read_jedec_row(handle, buffer, i, 0,
					   config->row_width))
			return EXIT_FAILURE;
		// Unpacking the row
		for (j = 0; j < config->row_width; j++) {
			if (buffer[j / 8] & (0x80 >> (j & 0x07)))
				jedec->fuses[config->fuses_size * j + i] = 1;
		}
		update_status(status_msg, "%2d%%",
			      i * 100 / config->fuses_size);
	}

	// Read user electronic signature (UES)
	// UES data can be missing in jedec, e.g. for db entry "ATF22V10C"
	if ((config->ues_address != 0) && (config->ues_size != 0) &&
	    ((config->ues_address + config->ues_size) <= jedec->QF) &&
	    !(handle->device->voltages.vdd & ATF_IN_PAL_COMPAT_MODE)) {
		if (minipro_read_jedec_row(handle, buffer, i, 0,
					   config->ues_size))
			return EXIT_FAILURE;
		for (j = 0; j < config->ues_size; j++) {
			if (buffer[j / 8] & (0x80 >> (j & 0x07)))
				jedec->fuses[config->ues_address + j] = 1;
		}
	}

	// Read architecture control word (ACW)
	if (minipro_read_jedec_row(handle, buffer, config->acw_address,
				   config->acw_address, config->acw_size))
		return EXIT_FAILURE;
	for (i = 0; i < config->acw_size; i++) {
		if (buffer[i / 8] & (0x80 >> (i & 0x07)))
			jedec->fuses[config->acw_bits[i]] = 1;
	}

	// Read Power-Down bit
	if ((config->powerdown_row != 0) &&
	    (handle->device->flags.has_power_down)) {
		if (minipro_read_jedec_row(handle, buffer,
					   config->powerdown_row, 0, 1))
			return EXIT_FAILURE;
		jedec->fuses[jedec->QF - 1] = (buffer[0] >> 7) & 0x01;
	}

	gettimeofday(&end, NULL);
	snprintf(status_msg, sizeof(status_msg),
		 "Reading device...  %.2fSec  OK",
		 (double)(end.tv_usec - begin.tv_usec) / 1000000 +
			 (double)(end.tv_sec - begin.tv_sec));
	update_status(status_msg, "\n");
	return EXIT_SUCCESS;
}

// Write PLD device
int write_jedec(minipro_handle_t *handle, jedec_t *jedec)
{
	size_t i, j;
	struct timeval begin, end;
	gettimeofday(&begin, NULL);

	char status_msg[64];
	snprintf(status_msg, sizeof(status_msg), "Writing jedec file... ");
	uint8_t buffer[32];
	gal_config_t *config = (gal_config_t *)handle->device->config;

	uint8_t ovc = 0;
	if (minipro_get_ovc_status(handle, NULL, &ovc))
		return EXIT_FAILURE;
	if (ovc) {
		fprintf(stderr, "\nOvercurrent protection!\007\n");
		return EXIT_FAILURE;
	}

	// Write fuses
	for (i = 0; i < config->fuses_size; i++) {
		memset(buffer, 0, sizeof(buffer));
		// Building a row
		for (j = 0; j < config->row_width; j++) {
			if (jedec->fuses[config->fuses_size * j + i] == 1)
				buffer[j / 8] |= (0x80 >> (j & 0x07));
		}
		update_status(status_msg, "%2d%%",
			      i * 100 / config->fuses_size);
		if (minipro_write_jedec_row(handle, buffer, i, 0,
					    config->row_width))
			return EXIT_FAILURE;
	}

	// Write user electronic signature (UES)
	memset(buffer, 0, sizeof(buffer));
	// UES data can be missing in jedec, e.g. for db entry "ATF22V10C"
	if ((config->ues_address != 0) && (config->ues_size != 0) &&
	    ((config->ues_address + config->ues_size) <= jedec->QF) &&
	    !(handle->device->voltages.vdd & ATF_IN_PAL_COMPAT_MODE)) {
		for (j = 0; j < config->ues_size; j++) {
			if (jedec->fuses[config->ues_address + j] == 1)
				buffer[j / 8] |= (0x80 >> (j & 0x07));
		}
	}
	// UES field is always written, even when not contained in JEDEC
	if (minipro_write_jedec_row(handle, buffer, i, 0, config->ues_size))
		return EXIT_FAILURE;

	// Write architecture control word (ACW)
	memset(buffer, 0, sizeof(buffer));
	for (i = 0; i < config->acw_size; i++) {
		if (jedec->fuses[config->acw_bits[i]] == 1)
			buffer[i / 8] |= (0x80 >> (i & 0x07));
	}
	if (minipro_write_jedec_row(handle, buffer, config->acw_address,
				    config->acw_address, config->acw_size))
		return EXIT_FAILURE;

	// Disable Power-Down by writing to specific power-down row
	if (config->powerdown_row != 0) {
		// only '0' bits shall be written
		if (((handle->device->flags.has_power_down) &&
		     (jedec->fuses[jedec->QF - 1] == 0)) ||
		     (handle->device->flags.is_powerdown_disabled)) {
			memset(buffer, 0, sizeof(buffer));
			if (minipro_write_jedec_row(handle, buffer,
						    config->powerdown_row, 0,
						    1))
				return EXIT_FAILURE;
		}
	}

	gettimeofday(&end, NULL);
	snprintf(status_msg, sizeof(status_msg),
		 "Writing jedec file...  %.2fSec  OK",
		 (double)(end.tv_usec - begin.tv_usec) / 1000000 +
			 (double)(end.tv_sec - begin.tv_sec));
	update_status(status_msg, "\n");
	return EXIT_SUCCESS;
}

int erase_device(minipro_handle_t *handle)
{
	struct timeval begin, end;
	if (handle->cmdopts->no_erase == 0 &&
	    handle->device->flags.can_erase) // Not all chips can be erased...
	{
		fprintf(stderr, "Erasing... ");
		fflush(stderr);
		gettimeofday(&begin, NULL);
		if (minipro_erase(handle))
			return EXIT_FAILURE;
		gettimeofday(&end, NULL);
		fprintf(stderr, "%.2fSec OK\n",
			(double)(end.tv_usec - begin.tv_usec) / 1000000 +
				(double)(end.tv_sec - begin.tv_sec));
	}
	return EXIT_SUCCESS;
}

// Opens a physical file or a pipe if the pipe character is specified
int open_file(minipro_handle_t *handle, uint8_t *data, size_t *file_size)
{
	FILE *file;
	struct stat st;

	// Check if we are dealing with a pipe.
	if (handle->cmdopts->is_pipe) {
		file = stdin;
		st.st_size = 0;
	} else {
		file = fopen(handle->cmdopts->filename, "rb");
		int ret = stat(handle->cmdopts->filename, &st);
		if (!file || ret) {
			fprintf(stderr, "Could not open file %s for reading.\n",
				handle->cmdopts->filename);
			perror("");
			if (file)
				fclose(file);
			return EXIT_FAILURE;
		}
	}

	// Allocate a zero initialized buffer.
	// If the file size is unknown (pipe) a default size will be used.
	uint8_t *buffer = calloc(1, st.st_size ? st.st_size : READ_BUFFER_SIZE);
	if (!buffer) {
		fclose(file);
		fprintf(stderr, "Out of memory!\n");
		return EXIT_FAILURE;
	}

	// Try to read the whole file.
	// If we are reading from stdin  data will be read in small chunks of 64K
	// each until EOF.
	size_t br = 0;
	size_t sz = READ_BUFFER_SIZE;
	if (!st.st_size) {
		size_t ch;
		uint8_t *tmp;
		while (br < UINT32_MAX) {
			ch = fread(buffer + br, 1, READ_BUFFER_SIZE, file);
			br += ch;
			if (ch != READ_BUFFER_SIZE)
				break;
			sz += READ_BUFFER_SIZE;
			tmp = realloc(buffer, sz);
			if (!tmp) {
				free(buffer);
				fclose(file);
				fprintf(stderr, "Out of memory!\n");
				return EXIT_FAILURE;
			}
			buffer = tmp;
		}
	} else
		br = fread(buffer, 1, st.st_size, file);

	fclose(file);
	if (!br) {
		fprintf(stderr, "No data to read.\n");
		free(buffer);
		return EXIT_FAILURE;
	}

	// If we are dealing with a jed file just return the data.
	if (handle->device->chip_type == MP_PLD) {
		memcpy(data, buffer, br);
		free(buffer);
		*file_size = br;
		return EXIT_SUCCESS;
	}

	size_t chip_size = *file_size;
	*file_size = br;

	// Probe for an Intel hex file
	size_t hex_size = chip_size;
	int ret = read_hex_file(buffer, data, &hex_size);
	switch (ret) {
	case NOT_IHEX:
		break;
	case EXIT_FAILURE:
		free(buffer);
		return EXIT_FAILURE;
		break;
	case INTEL_HEX_FORMAT:
		*file_size = hex_size;
		fprintf(stderr, "Found Intel hex file.\n");
		free(buffer);
		return EXIT_SUCCESS;
	}

	// Probe for a Motorola srec file
	hex_size = chip_size;
	ret = read_srec_file(buffer, data, &hex_size);
	switch (ret) {
	case NOT_SREC:
		break;
	case EXIT_FAILURE:
		free(buffer);
		return EXIT_FAILURE;
		break;
	case SREC_FORMAT:
		*file_size = hex_size;
		fprintf(stderr, "Found Motorola S-Record file.\n");
		free(buffer);
		return EXIT_SUCCESS;
	}

	if (handle->cmdopts->format == IHEX) {
		fprintf(stderr, "This is not an Intel hex file.\n");
		free(buffer);
		return EXIT_FAILURE;
	}
	if (handle->cmdopts->format == SREC) {
		fprintf(stderr, "This is not an S-Record file.\n");
		free(buffer);
		return EXIT_FAILURE;
	}
	// This must be a binary file
	memcpy(data, buffer, *file_size > chip_size ? chip_size : *file_size);
	free(buffer);
	return EXIT_SUCCESS;
}

// Open a JED file
int open_jed_file(minipro_handle_t *handle, jedec_t *jedec)
{
	char *buffer = calloc(1, READ_BUFFER_SIZE);
	if (!buffer) {
		fprintf(stderr, "Out of memory!\n");
		return EXIT_FAILURE;
	}

	size_t file_size = handle->device->code_memory_size;
	if (open_file(handle, (uint8_t *)buffer, &file_size)) {
		free(buffer);
		return EXIT_FAILURE;
	}
	if (read_jedec_file(buffer, file_size, jedec))
		return EXIT_FAILURE;
	if (!jedec->fuses) {
		fprintf(stderr, "This file has no fuses (L) declaration!\n");
		free(buffer);
		return EXIT_FAILURE;
	}

	if (handle->device->code_memory_size != jedec->QF)
		fprintf(stderr,
			"\nWarning! JED file doesn't match the selected device!\n");

	fprintf(stderr,
		"\nDeclared fuse checksum: 0x%04X Calculated: 0x%04X ... %s\n",
		jedec->C, jedec->fuse_checksum,
		jedec->fuse_checksum == jedec->C ? "OK" : "Mismatch!");

	fprintf(stderr,
		"Declared file checksum: 0x%04X Calculated: 0x%04X ... %s\n",
		jedec->decl_file_checksum, jedec->calc_file_checksum,
		jedec->decl_file_checksum == jedec->calc_file_checksum ?
			"OK" :
			"Mismatch!");

	fprintf(stderr, "JED file parsed OK\n\n");
	free(buffer);
	return EXIT_SUCCESS;
}

FILE *get_file(minipro_handle_t *handle)
{
	FILE *file;
	if (handle->cmdopts->is_pipe)
		file = stdout;
	else {
		file = fopen(handle->cmdopts->filename, "wb");
		if (!file) {
			fprintf(stderr, "Could not open file %s for writing.\n",
				handle->cmdopts->filename);
			perror("");
			return NULL;
		}
	}
	return file;
}

/* Wrappers for operating with files */
int write_page_file(minipro_handle_t *handle, uint8_t type, size_t size)
{
	// Allocate the buffer and clear it with default value
	uint8_t *file_data = malloc(size);
	if (!file_data) {
		fprintf(stderr, "Out of memory!\n");
		return EXIT_FAILURE;
	}

	memset(file_data, handle->device->blank_value, size);
	size_t file_size = size;
	if (open_file(handle, file_data, &file_size))
		return EXIT_FAILURE;
	if (file_size != size) {
		if (!handle->cmdopts->size_error) {
			fprintf(stderr,
				"Incorrect file size: %zu (needed %zu, use -s/S to ignore)\n",
				file_size, size);
			free(file_data);
			return EXIT_FAILURE;
		} else if (handle->cmdopts->size_nowarn == 0)
			fprintf(stderr,
				"Warning: Incorrect file size: %zu (needed %zu)\n",
				file_size, size);

		/* The size of our array must be a multiple of handle->device->read_buffer_size,
     * else, read_page_ram will try to access an out of bounds index. */
		const uint16_t buffer_size = handle->device->read_buffer_size;
		size = MIN(file_size, size);
		const uint16_t size_mod = size % buffer_size;
		if (size_mod)
			size += buffer_size - size_mod;
	}

	// Perform an erase first
	if (erase_device(handle)) {
		free(file_data);
		return EXIT_FAILURE;
	}
	// We must reset the transaction after the erase
	if (minipro_end_transaction(handle)) {
		free(file_data);
		return EXIT_FAILURE;
	}
	if (minipro_begin_transaction(handle)) {
		free(file_data);
		return EXIT_FAILURE;
	}

	if (handle->cmdopts->protect_off &&
	    handle->device->flags.off_protect_before) {
		if (minipro_protect_off(handle)) {
			free(file_data);
			return EXIT_FAILURE;
		}
		fprintf(stderr, "Protect off...OK\n");
	}

	if (write_page_ram(handle, file_data, type, size)) {
		free(file_data);
		return EXIT_FAILURE;
	}

	// Verify if data was written ok
	if (handle->cmdopts->no_verify == 0) {
		// We must reset the transaction for VCC verify to have effect
		if (minipro_end_transaction(handle)) {
			free(file_data);
			return EXIT_FAILURE;
		}
		if (minipro_begin_transaction(handle)) {
			free(file_data);
			return EXIT_FAILURE;
		}

		uint8_t *chip_data = malloc(size);
		if (!chip_data) {
			fprintf(stderr, "Out of memory\n");
			free(file_data);
			return EXIT_FAILURE;
		}
		if (read_page_ram(handle, chip_data, type, size)) {
			free(file_data);
			free(chip_data);
			return EXIT_FAILURE;
		}

		int ret;
		uint8_t c1 = 0, c2 = 0;
		uint16_t cw1 = 0, cw2 = 0;
		uint32_t address;
		uint16_t compare_mask =
			(type == MP_CODE) ? handle->device->compare_mask : 0xff;
		if (compare_mask > 0xff) {
			ret = compare_word_memory(0xffff, compare_mask, 1,
						  file_data, chip_data,
						  file_size, size, &address,
						  &cw1, &cw2);
		} else {
			ret = compare_memory(compare_mask, file_data, chip_data,
					     file_size, size, &address, &c1,
					     &c2);
		}

		free(chip_data);
		free(file_data);

		if (ret) {
			if (compare_mask > 0xff) {
				fprintf(stderr,
					"Verification failed at address 0x%04X: File=0x%04X, Device=0x%04X\n",
					address, cw1, cw2);
			} else {
				fprintf(stderr,
					"Verification failed at address 0x%04X: File=0x%02X, Device=0x%02X\n",
					address, c1, c2);
			}
			return EXIT_FAILURE;
		} else {
			fprintf(stderr, "Verification OK\n");
		}
	}
	return EXIT_SUCCESS;
}

int read_page_file(minipro_handle_t *handle, uint8_t type, size_t size)
{
	FILE *file = get_file(handle);
	if (!file)
		return EXIT_FAILURE;

	uint8_t *buffer = malloc(size);
	if (!buffer) {
		fprintf(stderr, "Out of memory\n");
		fclose(file);
		return EXIT_FAILURE;
	}

	memset(buffer, handle->device->blank_value, size);
	if (read_page_ram(handle, buffer, type, size)) {
		fclose(file);
		free(buffer);
		return EXIT_FAILURE;
	}

	switch (handle->cmdopts->format) {
	case IHEX:
		if (write_hex_file(file, buffer, 0, size, 1)) {
			fclose(file);
			free(buffer);
			return EXIT_FAILURE;
		}
		break;
	case SREC:
		if (write_srec_file(file, buffer, 0, size, 1)) {
			fclose(file);
			free(buffer);
			return EXIT_FAILURE;
		}
		break;
	default:
		fwrite(buffer, 1, size, file);
	}

	fclose(file);
	free(buffer);
	return EXIT_SUCCESS;
}

int verify_page_file(minipro_handle_t *handle, uint8_t type, size_t size)
{
	uint8_t *file_data;

	char *name;
	switch (type) {
	case MP_DATA:
		name = "Data";
		break;
	case MP_USER:
		name = "User";
		break;
	default:
		name = "Code";
	}
	size_t file_size = size;

	// Allocate the buffer and clear it with default value
	file_data = malloc(size);
	if (!file_data) {
		fprintf(stderr, "Out of memory!\n");
		return EXIT_FAILURE;
	}
	if (handle->cmdopts->filename) {
		memset(file_data, handle->device->blank_value, size);
		if (open_file(handle, file_data, &file_size)) {
			free(file_data);
			return EXIT_FAILURE;
		}

		if (file_size != size) {
			if (!handle->cmdopts->size_error) {
				fprintf(stderr,
					"Incorrect file size: %zu (needed %zu, use -s/S to ignore)\n",
					file_size, size);
				free(file_data);
				return EXIT_FAILURE;
			} else if (handle->cmdopts->size_nowarn == 0)
				fprintf(stderr,
					"Warning: Incorrect file size: %zu (needed %zu)\n",
					file_size, size);
		}

	}
	// Blank check
	else
		memset(file_data, handle->device->blank_value, size);

	/* Downloading data from chip*/
	uint8_t *chip_data = malloc(size + 128);
	if (!chip_data) {
		fprintf(stderr, "Out of memory!\n");
		free(file_data);
		return EXIT_FAILURE;
	}
	if (read_page_ram(handle, chip_data, type, size)) {
		free(file_data);
		free(chip_data);
		return EXIT_FAILURE;
	}

	int ret;
	uint8_t c1 = 0, c2 = 0;
	uint16_t cw1 = 0, cw2 = 0;
	uint32_t address;
	uint16_t compare_mask =
		(type == MP_CODE) ? handle->device->compare_mask : 0xff;
	if (compare_mask > 0xff) {
		ret = compare_word_memory(0xffff, compare_mask, 1, file_data,
					  chip_data, file_size, size, &address,
					  &cw1, &cw2);
	} else {
		ret = compare_memory(compare_mask, file_data, chip_data,
				     file_size, size, &address, &c1, &c2);
	}

	free(file_data);
	free(chip_data);

	if (ret) {
		if (compare_mask > 0xff) {
			fprintf(stderr,
				"Verification failed at address 0x%04X: File=0x%04X, Device=0x%04X\n",
				address, cw1, cw2);
		} else {
			fprintf(stderr,
				"Verification failed at address 0x%04X: File=0x%02X, Device=0x%02X\n",
				address, c1, c2);
		}
		return EXIT_FAILURE;
	} else {
		if (handle->cmdopts->filename) {
			fprintf(stderr, "Verification OK\n");
		} else {
			fprintf(stderr, "%s memory section is blank.\n", name);
		}
	}
	return EXIT_SUCCESS;
}

int read_fuses(minipro_handle_t *handle, fuse_decl_t *fuses)
{
	size_t i;
	uint8_t buffer[64];
	uint16_t value;
	struct timeval begin, end;
	memset(buffer, 0x00, sizeof(buffer));

	FILE *file = get_file(handle);
	if (!file)
		return EXIT_FAILURE;

	// Read calibration byte(s) if requested
	if (handle->cmdopts->page == CALIBRATION) {
		if (minipro_read_calibration(handle, buffer,
					     fuses->num_calibytes)) {
			fclose(file);
			return EXIT_FAILURE;
		}

		fprintf(file, "calibration bytes: ");
		for (i = 0; i < fuses->num_calibytes; i++) {
			fprintf(file, "0x%02x%s", buffer[i],
				i < fuses->num_calibytes - 1 ? ", " : "");
		}
		fprintf(file, "\n");
		fclose(file);
		fprintf(stderr, "Reading calibration bytes... OK\n");
		return EXIT_SUCCESS;
	}

	cmdopts_t *cmdopts = handle->cmdopts;
	uint8_t filter = cmdopts->filter_fuses + cmdopts->filter_locks +
			 cmdopts->filter_uid;

	if (cmdopts->filter_fuses && !fuses->num_fuses) {
		fprintf(stderr, "No fuse section to read!\n");
		fclose(file);
		return EXIT_FAILURE;
	}

	if (cmdopts->filter_uid && !fuses->num_uids) {
		fprintf(stderr, "No user id section to read!\n");
		fclose(file);
		return EXIT_FAILURE;
	}

	if (cmdopts->filter_locks &&
	    (handle->device->flags.lock_bit_write_only || !fuses->num_locks)) {
		fprintf(stderr, "Can't read the lock byte for this device!\n");
		fclose(file);
		return EXIT_FAILURE;
	}

	gettimeofday(&begin, NULL);

	// Read fuses section if requested
	if (fuses->num_fuses && (!filter || cmdopts->filter_fuses)) {
		gettimeofday(&begin, NULL);
		uint8_t items = handle->device->flags.word_size == 2 ? 1 : 2;

		if (minipro_read_fuses(handle, MP_FUSE_CFG,
				       fuses->num_fuses *
					       handle->device->flags.word_size,
				       items, buffer)) {
			fclose(file);
			return EXIT_FAILURE;
		}
		for (i = 0; i < fuses->num_fuses; i++) {
			value = load_int(
				&(buffer[i * handle->device->flags.word_size]),
				handle->device->flags.word_size,
				MP_LITTLE_ENDIAN);
			// value |= ~(fuses->fuse[i].mask);
			if (handle->device->compare_mask > 0xff)
				value &= handle->device->compare_mask;
			if (handle->device->flags.word_size == 1)
				value &= 0xff;
			fprintf(file,
				handle->device->flags.word_size == 1 ?
					"%s = 0x%02x\n" :
					"%s = 0x%04x\n",
				fuses->fuse[i].name, value);
		}
	}

	// Read user id section if requested
	if (fuses->num_uids && (!filter || cmdopts->filter_uid)) {
		gettimeofday(&begin, NULL);
		uint8_t item_size = handle->device->flags.data_org ? 2 : 1;
		if (minipro_read_fuses(handle, MP_FUSE_USER,
				       fuses->num_uids * item_size, 0,
				       buffer)) {
			fclose(file);
			return EXIT_FAILURE;
		}
		for (i = 0; i < fuses->num_uids; i++) {
			value = load_int(&(buffer[i * item_size]), item_size,
					 MP_LITTLE_ENDIAN);
			value &= (handle->device->compare_mask);
			fprintf(file,
				item_size == 1 ? "%s = 0x%02x\n" :
						 "%s = 0x%04x\n",
				user_id[i], value);
		}
	}

	// Read lock section if requested
	if (fuses->num_locks && (!filter || cmdopts->filter_locks)) {
		gettimeofday(&begin, NULL);
		if (minipro_read_fuses(
			    handle, MP_FUSE_LOCK,
			    fuses->num_locks * handle->device->flags.word_size,
			    handle->device->flags.word_size, buffer)) {
			fclose(file);
			return EXIT_FAILURE;
		}
		for (i = 0; i < fuses->num_locks; i++) {
			value = load_int(
				&(buffer[i * handle->device->flags.word_size]),
				handle->device->flags.word_size,
				MP_LITTLE_ENDIAN);
			value |= ~(fuses->lock[i].mask);
			if (handle->device->flags.word_size == 1)
				value &= 0xff;
			fprintf(file,
				handle->device->flags.word_size == 1 ?
					"%s = 0x%02x\n" :
					"%s = 0x%04x\n",
				fuses->lock[i].name, value);
		}
	}

	gettimeofday(&end, NULL);

	fprintf(stderr, "Reading config... %.2fSec  OK\n",
		(double)(end.tv_usec - begin.tv_usec) / 1000000 +
			(double)(end.tv_sec - begin.tv_sec));
	fclose(file);
	return EXIT_SUCCESS;
}

int write_fuses(minipro_handle_t *handle, fuse_decl_t *fuses)
{
	size_t i;
	uint8_t wbuffer[64], vbuffer[64];
	uint16_t value;
	char config[1024];
	struct timeval begin, end;

	memset(config, 0, sizeof(config));
	size_t file_size = sizeof(config);
	if (open_file(handle, (uint8_t *)config, &file_size))
		return EXIT_FAILURE;

	// Perform an erase first if requested
	if (handle->cmdopts->force_erase) {
		if (erase_device(handle)) {
			return EXIT_FAILURE;
		}
		// We must reset the transaction after the erase
		if (minipro_end_transaction(handle)) {
			return EXIT_FAILURE;
		}
		if (minipro_begin_transaction(handle)) {
			return EXIT_FAILURE;
		}
	}

	cmdopts_t *section = handle->cmdopts;
	uint8_t filter = section->filter_fuses + section->filter_locks +
			 section->filter_uid;
	if (section->filter_fuses && !fuses->num_fuses) {
		fprintf(stderr, "No fuse section to write!!\n");
		return EXIT_FAILURE;
	}

	if (section->filter_uid && !fuses->num_uids) {
		fprintf(stderr, "No user id section to write!\n");
		return EXIT_FAILURE;
	}

	if (section->filter_locks && !fuses->num_locks) {
		fprintf(stderr, "No lock section to write!\n");
		return EXIT_FAILURE;
	}

	// Write Fuses section if requested
	if (fuses->num_fuses && (!filter || section->filter_fuses)) {
		gettimeofday(&begin, NULL);
		fprintf(stderr, "Writing fuses... ");
		fflush(stderr);

		uint8_t items = handle->device->flags.word_size == 2 ? 1 : 2;
		for (i = 0; i < fuses->num_fuses; i++) {
			if (get_config_value(config, fuses->fuse[i].name,
					     &value) == EXIT_FAILURE) {
				fprintf(stderr,
					"Could not read config %s value.\n",
					fuses->lock[i].name);
				return EXIT_FAILURE;
			}
			value |= ~(fuses->fuse[i].mask);
			if (handle->device->compare_mask > 0xff)
				value &= handle->device->compare_mask;
			if (handle->device->flags.word_size == 1)
				value &= 0xff;
			format_int(
				&(wbuffer[i * handle->device->flags.word_size]),
				value, handle->device->flags.word_size,
				MP_LITTLE_ENDIAN);
		}
		if (minipro_write_fuses(handle, MP_FUSE_CFG,
					fuses->num_fuses *
						handle->device->flags.word_size,
					items, wbuffer))
			return EXIT_FAILURE;
		if (minipro_read_fuses(handle, MP_FUSE_CFG,
				       fuses->num_fuses *
					       handle->device->flags.word_size,
				       items, vbuffer))
			return EXIT_FAILURE;

		// Mask vbuffer for compare
		for (i = 0; i < fuses->num_fuses; i++) {
			value = load_int(
				&(vbuffer[i * handle->device->flags.word_size]),
				handle->device->flags.word_size,
				MP_LITTLE_ENDIAN);
			value |= ~(fuses->fuse[i].mask);
			if (handle->device->compare_mask > 0xff)
				value &= handle->device->compare_mask;
			if (handle->device->flags.word_size == 1)
				value &= 0xff;
			format_int(
				&(vbuffer[i * handle->device->flags.word_size]),
				value, handle->device->flags.word_size,
				MP_LITTLE_ENDIAN);
		}

		if (memcmp(wbuffer, vbuffer,
			   fuses->num_fuses *
				   handle->device->flags.word_size)) {
			fprintf(stderr, "\nFuses verify error!\n");
		}
		gettimeofday(&end, NULL);
		fprintf(stderr, "%.2fSec  OK\n",
			(double)(end.tv_usec - begin.tv_usec) / 1000000 +
				(double)(end.tv_sec - begin.tv_sec));
	}

	// Write user id section if requested
	if (fuses->num_uids && (!filter || section->filter_uid)) {
		gettimeofday(&begin, NULL);
		fprintf(stderr, "Writing user id... ");
		fflush(stderr);
		uint8_t item_size = handle->device->flags.data_org ? 2 : 1;
		for (i = 0; i < fuses->num_uids; i++) {
			if (get_config_value(config, user_id[i], &value) ==
			    EXIT_FAILURE) {
				fprintf(stderr,
					"Could not read config %s value.\n",
					user_id[i]);
				return EXIT_FAILURE;
			}
			value &= (handle->device->compare_mask);
			format_int(&(wbuffer[i * item_size]), value, item_size,
				   MP_LITTLE_ENDIAN);
		}
		if (minipro_write_fuses(handle, MP_FUSE_USER,
					fuses->num_uids * item_size, item_size,
					wbuffer))
			return EXIT_FAILURE;
		if (minipro_read_fuses(handle, MP_FUSE_USER,
				       fuses->num_uids * item_size, 0, vbuffer))
			return EXIT_FAILURE;

		// Mask vbuffer for compare
		for (i = 0; i < fuses->num_uids; i++) {
			value = load_int(&(vbuffer[i * item_size]), item_size,
					 MP_LITTLE_ENDIAN);
			value &= (handle->device->compare_mask);
			format_int(&(vbuffer[i * item_size]), value, item_size,
				   MP_LITTLE_ENDIAN);
		}

		if (memcmp(wbuffer, vbuffer, fuses->num_uids * item_size)) {
			fprintf(stderr, "\nUser ID verify error!\n");
		}
		gettimeofday(&end, NULL);
		fprintf(stderr, "%.2fSec  OK\n",
			(double)(end.tv_usec - begin.tv_usec) / 1000000 +
				(double)(end.tv_sec - begin.tv_sec));
	}

	//Write lock section if requested
	if (fuses->num_locks && (!filter || section->filter_locks)) {
		gettimeofday(&begin, NULL);
		fprintf(stderr, "Writing lock bits... ");
		fflush(stderr);
		for (i = 0; i < fuses->num_locks; i++) {
			if (get_config_value(config, fuses->lock[i].name,
					     &value) == EXIT_FAILURE) {
				fprintf(stderr,
					"Could not read config %s value.\n",
					fuses->lock[i].name);
				return EXIT_FAILURE;
			}
			value |= ~(fuses->lock[i].mask);
			format_int(
				&(wbuffer[i * handle->device->flags.word_size]),
				value, handle->device->flags.word_size,
				MP_LITTLE_ENDIAN);
		}
		if (minipro_write_fuses(
			    handle, MP_FUSE_LOCK,
			    fuses->num_locks * handle->device->flags.word_size,
			    handle->device->flags.word_size, wbuffer))
			return EXIT_FAILURE;
		if (!handle->device->flags.lock_bit_write_only) {
			if (minipro_read_fuses(
				    handle, MP_FUSE_LOCK,
				    fuses->num_locks *
					    handle->device->flags.word_size,
				    handle->device->flags.word_size, vbuffer))
				return EXIT_FAILURE;

			// Mask vbuffer for compare
			for (i = 0; i < fuses->num_locks; i++) {
				value = load_int(
					&(vbuffer[i * handle->device->flags
							      .word_size]),
					handle->device->flags.word_size,
					MP_LITTLE_ENDIAN);
				value |= ~(fuses->lock[i].mask);
				if (handle->device->flags.word_size == 1)
					value &= 0xff;
				format_int(&(vbuffer[i * handle->device->flags
								 .word_size]),
					   value,
					   handle->device->flags.word_size,
					   MP_LITTLE_ENDIAN);
			}

			if (memcmp(wbuffer, vbuffer,
				   fuses->num_locks *
					   handle->device->flags.word_size)) {
				fprintf(stderr, "\nLock bits verify error!\n");
			}
		}
		gettimeofday(&end, NULL);
		fprintf(stderr, "%.2fSec  OK\n",
			(double)(end.tv_usec - begin.tv_usec) / 1000000 +
				(double)(end.tv_sec - begin.tv_sec));
	}
	return EXIT_SUCCESS;
}

int verify_fuses(minipro_handle_t *handle, fuse_decl_t *fuses)
{
	uint8_t wbuffer[64], vbuffer[64];
	uint16_t value;
	size_t i;
	char config[1024];
	int ret = EXIT_SUCCESS;

	memset(config, 0, sizeof(config));
	size_t file_size = sizeof(config);
	if (handle->cmdopts->filename &&
	    open_file(handle, (uint8_t *)config, &file_size))
		return EXIT_FAILURE;

	if (minipro_begin_transaction(handle))
		return EXIT_FAILURE;

	cmdopts_t *section = handle->cmdopts;
	uint8_t filter = section->filter_fuses + section->filter_locks +
			 section->filter_uid;

	if (section->filter_fuses && !fuses->num_fuses) {
		fprintf(stderr, "No fuse section to read!\n");
		return EXIT_FAILURE;
	}

	if (section->filter_uid && !fuses->num_uids) {
		fprintf(stderr, "No user id section to read!\n");
		return EXIT_FAILURE;
	}

	if (section->filter_locks &&
	    (handle->device->flags.lock_bit_write_only || !fuses->num_locks)) {
		fprintf(stderr, "Can't read the lock byte for this device!\n");
		return EXIT_FAILURE;
	}

	// Verify/Blank check fuses section if requested
	if (fuses->num_fuses && (!filter || section->filter_fuses)) {
		uint8_t items = handle->device->flags.word_size == 2 ? 1 : 2;
		for (i = 0; i < fuses->num_fuses; i++) {
			value = fuses->fuse[i].def;
			if (handle->cmdopts->filename &&
			    get_config_value(config, fuses->fuse[i].name,
					     &value)) {
				fprintf(stderr,
					"Could not read config %s value.\n",
					fuses->fuse[i].name);
				return EXIT_FAILURE;
			}
			value |= ~(fuses->fuse[i].mask);
			if (handle->device->compare_mask > 0xff)
				value &= handle->device->compare_mask;
			if (handle->device->flags.word_size == 1)
				value &= 0xff;
			format_int(
				&(wbuffer[i * handle->device->flags.word_size]),
				value, handle->device->flags.word_size,
				MP_LITTLE_ENDIAN);
		}
		if (minipro_read_fuses(handle, MP_FUSE_CFG,
				       fuses->num_fuses *
					       handle->device->flags.word_size,
				       items, vbuffer))
			return EXIT_FAILURE;

		// Mask vbuffer for compare
		for (i = 0; i < fuses->num_fuses; i++) {
			value = load_int(
				&(vbuffer[i * handle->device->flags.word_size]),
				handle->device->flags.word_size,
				MP_LITTLE_ENDIAN);
			value |= ~(fuses->fuse[i].mask);
			if (handle->device->compare_mask > 0xff)
				value &= handle->device->compare_mask;
			if (handle->device->flags.word_size == 1)
				value &= 0xff;
			format_int(
				&(vbuffer[i * handle->device->flags.word_size]),
				value, handle->device->flags.word_size,
				MP_LITTLE_ENDIAN);
		}

		if (memcmp(wbuffer, vbuffer,
			   fuses->num_fuses *
				   handle->device->flags.word_size)) {
			fprintf(stderr,
				handle->cmdopts->filename ?
					"Fuse bits verification error!\n" :
					"Fuse bits aren't in their default value!\n");

			ret = EXIT_FAILURE;
		} else
			fprintf(stderr,
				handle->cmdopts->filename ?
					"Fuse bits verification OK.\n" :
					"Fuse bits are in their default value.\n");
	}

	// Verify/Blank check user id section if requested
	if (fuses->num_uids && (!filter || section->filter_uid)) {
		uint8_t item_size = handle->device->flags.data_org ? 2 : 1;
		for (i = 0; i < fuses->num_uids; i++) {
			value = handle->device->compare_mask;
			if (handle->cmdopts->filename &&
			    get_config_value(config, user_id[i], &value)) {
				fprintf(stderr,
					"Could not read config %s value.\n",
					user_id[i]);
				return EXIT_FAILURE;
			}
			value &= (handle->device->compare_mask);
			format_int(&(wbuffer[i * item_size]), value, item_size,
				   MP_LITTLE_ENDIAN);
		}
		if (minipro_read_fuses(handle, MP_FUSE_USER,
				       fuses->num_uids * item_size, 0, vbuffer))
			return EXIT_FAILURE;

		// Mask buffer for compare
		for (i = 0; i < fuses->num_uids; i++) {
			value = load_int(&(vbuffer[i * item_size]), item_size,
					 MP_LITTLE_ENDIAN);
			value &= (handle->device->compare_mask);
			format_int(&(vbuffer[i * item_size]), value, item_size,
				   MP_LITTLE_ENDIAN);
		}

		if (memcmp(wbuffer, vbuffer, fuses->num_uids * item_size)) {
			fprintf(stderr,
				handle->cmdopts->filename ?
					"User ID verification error!\n" :
					"User ID section is not blank!\n");

			ret = EXIT_FAILURE;
		} else
			fprintf(stderr, handle->cmdopts->filename ?
						"User ID verification OK.\n" :
						"User ID section is blank.\n");
	}

	// Verify/Blank check lock section if requested
	if (fuses->num_locks && (!filter || section->filter_locks)) {
		for (i = 0; i < fuses->num_locks; i++) {
			value = fuses->lock[i].def;
			if (handle->cmdopts->filename &&
			    get_config_value(config, fuses->lock[i].name,
					     &value)) {
				fprintf(stderr,
					"Could not read config %s value.\n",
					fuses->lock[i].name);
				return EXIT_FAILURE;
			}
			value |= ~(fuses->lock[i].mask);
			if (handle->device->flags.word_size == 1)
				value &= 0xff;
			format_int(
				&(wbuffer[i * handle->device->flags.word_size]),
				value, handle->device->flags.word_size,
				MP_LITTLE_ENDIAN);
		}
		if (minipro_read_fuses(
			    handle, MP_FUSE_LOCK,
			    fuses->num_locks * handle->device->flags.word_size,
			    handle->device->flags.word_size, vbuffer))
			return EXIT_FAILURE;

		// Mask vbuffer for compare
		for (i = 0; i < fuses->num_locks; i++) {
			value = load_int(
				&(vbuffer[i * handle->device->flags.word_size]),
				handle->device->flags.word_size,
				MP_LITTLE_ENDIAN);
			value |= ~(fuses->lock[i].mask);
			if (handle->device->flags.word_size == 1)
				value &= 0xff;
			format_int(
				&(vbuffer[i * handle->device->flags.word_size]),
				value, handle->device->flags.word_size,
				MP_LITTLE_ENDIAN);
		}

		if (memcmp(wbuffer, vbuffer,
			   fuses->num_locks *
				   handle->device->flags.word_size)) {
			fprintf(stderr,
				handle->cmdopts->filename ?
					"Lock bits verification error!\n" :
					"Lock bits aren't in their default value!\n");
			ret = EXIT_FAILURE;
		} else
			fprintf(stderr,
				handle->cmdopts->filename ?
					"Lock bits verification OK.\n" :
					"Lock bits are in their default value.\n");
	}
	return ret;
	;
}

char *get_default_filename(const char *filename)
{
	char *default_filename = malloc(strlen(filename) + 32);
	if (!default_filename) {
		fprintf(stderr, "Out of memory!\n");
		return NULL;
	}
	strcpy(default_filename, filename);
	return default_filename;
}

/* Higher-level logic */
int action_read(minipro_handle_t *handle)
{
	jedec_t jedec;
	if (minipro_begin_transaction(handle))
		return EXIT_FAILURE;
	if (handle->device->chip_type == MP_PLD) {
		jedec.QF = handle->device->code_memory_size;
		if (!jedec.QF) {
			fprintf(stderr, "Unknown fuse size!\n");
			return EXIT_FAILURE;
		}
		jedec.fuses = malloc(jedec.QF);
		if (!jedec.fuses) {
			fprintf(stderr, "Out of memory\n");
			return EXIT_FAILURE;
		}
		memset(jedec.fuses, 0, jedec.QF);
		jedec.F = 0;
		jedec.G = 0;
		jedec.QP = handle->device->package_details.pin_count;
		jedec.device_name = handle->device->name;

		if (read_jedec(handle, &jedec)) {
			free(jedec.fuses);
			return EXIT_FAILURE;
		}
		FILE *file = get_file(handle);
		if (!file)
			return EXIT_FAILURE;
		if (write_jedec_file(file, &jedec)) {
			free(jedec.fuses);
			fclose(file);
			return EXIT_FAILURE;
		}
		free(jedec.fuses);
		fclose(file);
	} else {
		// No GAL device
		char *data_filename = handle->cmdopts->filename;
		char *user_filename = handle->cmdopts->filename;
		char *config_filename = handle->cmdopts->filename;

		char *default_data_filename =
			get_default_filename(handle->cmdopts->filename);
		if (!default_data_filename)
			return EXIT_FAILURE;
		char *default_user_filename =
			get_default_filename(handle->cmdopts->filename);
		if (!default_user_filename)
			return EXIT_FAILURE;
		char *default_config_filename =
			get_default_filename(handle->cmdopts->filename);
		if (!default_config_filename)
			return EXIT_FAILURE;

		if (!handle->cmdopts->is_pipe) {
			char *data_dot = strrchr(default_data_filename, '.');
			char *user_dot = strrchr(default_user_filename, '.');
			char *conf_dot = strrchr(default_config_filename, '.');
			char *data_ext, *user_ext;
			switch (handle->cmdopts->format) {
			case IHEX:
				data_ext = ".eeprom.hex";
				user_ext = ".user.hex";
				break;
			case SREC:
				data_ext = ".eeprom.srec";
				user_ext = ".user.srec";
				break;
			default:
				data_ext = ".eeprom.bin";
				user_ext = ".user.bin";
			}
			strcpy(data_dot ?
				       data_dot :
				       default_data_filename +
					       strlen(handle->cmdopts->filename),
			       data_ext);
			strcpy(user_dot ?
				       user_dot :
				       default_user_filename +
					       strlen(handle->cmdopts->filename),
			       user_ext);
			strcpy(conf_dot ?
				       conf_dot :
				       default_config_filename +
					       strlen(handle->cmdopts->filename),
			       ".fuses.conf");
		}

		int ret = EXIT_SUCCESS;
		if (handle->cmdopts->page == UNSPECIFIED) {
			data_filename = default_data_filename;
			user_filename = default_user_filename;
			config_filename = default_config_filename;
		}
		if (handle->cmdopts->page == CODE ||
		    handle->cmdopts->page == UNSPECIFIED) {
			if (read_page_file(handle, MP_CODE,
					   handle->device->code_memory_size)) {
				ret = EXIT_FAILURE;
				goto cleanup;
			}
		}
		if ((handle->cmdopts->page == DATA ||
		     (handle->cmdopts->page == UNSPECIFIED &&
		      !handle->cmdopts->is_pipe)) &&
		    handle->device->data_memory_size) {
			handle->cmdopts->filename = data_filename;
			if (read_page_file(handle, MP_DATA,
					   handle->device->data_memory_size)) {
				ret = EXIT_FAILURE;
				goto cleanup;
			}
		}
		if ((handle->cmdopts->page == USER ||
		     (handle->cmdopts->page == UNSPECIFIED &&
		      !handle->cmdopts->is_pipe)) &&
		    handle->device->data_memory2_size) {
			handle->cmdopts->filename = user_filename;
			if (read_page_file(handle, MP_USER,
					   handle->device->data_memory2_size)) {
				ret = EXIT_FAILURE;
				goto cleanup;
			}
		}
		if ((handle->cmdopts->page == CONFIG ||
		     (handle->cmdopts->page == CALIBRATION &&
		      handle->device->flags.has_calibration) ||
		     (handle->cmdopts->page == UNSPECIFIED &&
		      !handle->cmdopts->is_pipe)) &&
		    handle->device->config) {
			handle->cmdopts->filename = config_filename;
			if (read_fuses(handle, handle->device->config)) {
				ret = EXIT_FAILURE;
				goto cleanup;
			}
		}

		if (handle->cmdopts->page == DATA &&
		    !handle->device->data_memory_size) {
			fprintf(stderr, "No data section found.\n");
			ret = EXIT_FAILURE;
			goto cleanup;
		}

		if (handle->cmdopts->page == USER &&
		    !handle->device->data_memory2_size) {
			fprintf(stderr, "No user section found.\n");
			ret = EXIT_FAILURE;
			goto cleanup;
		}

		if (handle->cmdopts->page == CONFIG &&
		    !handle->device->config) {
			fprintf(stderr, "No config section found.\n");
			ret = EXIT_FAILURE;
			goto cleanup;
		}

		if (handle->cmdopts->page == CALIBRATION &&
		    !handle->device->flags.has_calibration) {
			fprintf(stderr,
				"This chip doesn't have any calibration bytes.\n");
			ret = EXIT_FAILURE;
			goto cleanup;
		}

cleanup:
		free(default_data_filename);
		free(default_user_filename);
		free(default_config_filename);
		return ret;
	}
	return EXIT_SUCCESS;
}

int action_write(minipro_handle_t *handle)
{
	jedec_t wjedec, rjedec;
	struct timeval begin, end;
	int ret = EXIT_SUCCESS;
	uint8_t c1, c2;
	uint32_t address;

	if (handle->device->chip_type == MP_PLD) {
		if (open_jed_file(handle, &wjedec))
			return EXIT_FAILURE;

		if (minipro_begin_transaction(handle)) {
			free(wjedec.fuses);
			return EXIT_FAILURE;
		}
		if (erase_device(handle)) {
			free(wjedec.fuses);
			return EXIT_FAILURE;
		}
		if (write_jedec(handle, &wjedec)) {
			free(wjedec.fuses);
			return EXIT_FAILURE;
		}
		if (minipro_end_transaction(handle)) {
			free(wjedec.fuses);
			return EXIT_FAILURE;
		}
		if (handle->cmdopts->no_verify == 0) {
			rjedec.QF = handle->device->code_memory_size;
			rjedec.F = wjedec.F;
			rjedec.fuses = malloc(rjedec.QF);
			if (!rjedec.fuses) {
				free(wjedec.fuses);
				return EXIT_FAILURE;
			}
			// compare fuses
			if (minipro_begin_transaction(handle)) {
				free(wjedec.fuses);
				free(rjedec.fuses);
				return EXIT_FAILURE;
			}
			if (read_jedec(handle, &rjedec)) {
				free(wjedec.fuses);
				free(rjedec.fuses);
				return EXIT_FAILURE;
			}
			if (minipro_end_transaction(handle)) {
				free(wjedec.fuses);
				free(rjedec.fuses);
				return EXIT_FAILURE;
			}
			ret = compare_memory(0x00, wjedec.fuses, rjedec.fuses,
					     wjedec.QF, rjedec.QF, &address,
					     &c1, &c2);

			// the error output is delayed until the security fuse has been written
			// to avoid a 99% correctly programmed chip without the security fuse

			free(rjedec.fuses);
		}
		free(wjedec.fuses);

		if (handle->cmdopts->protect_on) {
			fprintf(stderr, "Writing lock bit... ");
			fflush(stderr);
			gettimeofday(&begin, NULL);
			if (minipro_begin_transaction(handle))
				return EXIT_FAILURE;
			if (minipro_write_fuses(handle, MP_FUSE_LOCK, 0, 0,
						NULL))
				return EXIT_FAILURE;
			if (minipro_end_transaction(handle))
				return EXIT_FAILURE;
			gettimeofday(&end, NULL);
			fprintf(stderr, "%.2fSec OK\n",
				(double)(end.tv_usec - begin.tv_usec) /
						1000000 +
					(double)(end.tv_sec - begin.tv_sec));
		}

		// handle error from verify
		if (ret) {
			fprintf(stderr,
				"Verification failed at address 0x%04X: File=0x%02X, "
				"Device=0x%02X\n",
				address, c1, c2);
			return EXIT_FAILURE;
		} else {
			fprintf(stderr, "Verification OK\n");
		}

		return EXIT_SUCCESS;
	} else {
		// No GAL devices
		if (minipro_begin_transaction(handle))
			return EXIT_FAILURE;
		switch (handle->cmdopts->page) {
		case UNSPECIFIED:
		case CODE:
			if (write_page_file(handle, MP_CODE,
					    handle->device->code_memory_size))
				return EXIT_FAILURE;
			break;
		case DATA:
			if (handle->cmdopts->page == DATA &&
			    !handle->device->data_memory_size) {
				fprintf(stderr, "No data section found.\n");
				return EXIT_FAILURE;
			}
			if (write_page_file(handle, MP_DATA,
					    handle->device->data_memory_size))
				return EXIT_FAILURE;
			break;
		case USER:
			if (handle->cmdopts->page == USER &&
			    !handle->device->data_memory2_size) {
				fprintf(stderr, "No user section found.\n");
				return EXIT_FAILURE;
			}
			if (write_page_file(handle, MP_USER,
					    handle->device->data_memory2_size))
				return EXIT_FAILURE;
			break;
		case CONFIG:
			if (handle->cmdopts->page == CONFIG &&
			    !handle->device->config) {
				fprintf(stderr, "No config section found.\n");
				return EXIT_FAILURE;
			}
			if (handle->device->config) {
				if (write_fuses(handle, handle->device->config))
					return EXIT_FAILURE;
			}
			break;
		case CALIBRATION:
			fprintf(stderr, "Calibration bytes are read only.\n");
			return EXIT_FAILURE;
		}
		if (handle->cmdopts->protect_on &&
		    handle->device->flags.protect_after) {
			fprintf(stderr, "Protect on...");
			fflush(stderr);
			if (minipro_protect_on(handle))
				return EXIT_FAILURE;
			fprintf(stderr, "OK\n");
		}
	}
	return EXIT_SUCCESS;
}

int action_verify(minipro_handle_t *handle)
{
	jedec_t wjedec, rjedec;
	int ret = EXIT_SUCCESS;

	if (handle->device->chip_type == MP_PLD) {
		if (handle->cmdopts->filename) {
			if (open_jed_file(handle, &wjedec))
				return EXIT_FAILURE;
		}
		// Blank check
		else {
			wjedec.QF = handle->device->code_memory_size;
			wjedec.F = 0x01;
			wjedec.fuses = malloc(wjedec.QF);
			memset(wjedec.fuses, 0x01, wjedec.QF);
		}

		if (minipro_begin_transaction(handle)) {
			free(wjedec.fuses);
			return EXIT_FAILURE;
		}

		rjedec.QF = handle->device->code_memory_size;
		rjedec.F = wjedec.F;
		rjedec.fuses = malloc(rjedec.QF);
		if (!rjedec.fuses) {
			free(wjedec.fuses);
			return EXIT_FAILURE;
		}
		// compare fuses
		if (minipro_begin_transaction(handle)) {
			free(wjedec.fuses);
			free(rjedec.fuses);
			return EXIT_FAILURE;
		}
		if (read_jedec(handle, &rjedec)) {
			free(wjedec.fuses);
			free(rjedec.fuses);
			return EXIT_FAILURE;
		}
		if (minipro_end_transaction(handle)) {
			free(wjedec.fuses);
			free(rjedec.fuses);
			return EXIT_FAILURE;
		}
		uint8_t c1, c2;
		uint32_t address;

		if (compare_memory(0x00, wjedec.fuses, rjedec.fuses, wjedec.QF,
				   rjedec.QF, &address, &c1, &c2)) {
			if (handle->cmdopts->filename) {
				fprintf(stderr,
					"Verification failed at address 0x%04X: File=0x%02X, "
					"Device=0x%02X\n",
					address, c1, c2);
			} else {
				fprintf(stderr, "This device is not blank.\n");
			}
			free(rjedec.fuses);
			return EXIT_FAILURE;
		} else {
			if (handle->cmdopts->filename) {
				fprintf(stderr, "Verification OK\n");
			} else {
				fprintf(stderr, "This device is blank.\n");
			}
		}
		free(rjedec.fuses);
		free(wjedec.fuses);
	} else {
		// No GAL devices

		// Verifying code memory section. If filename is null then a blank check
		// is performed
		if (handle->cmdopts->page == UNSPECIFIED ||
		    handle->cmdopts->page == CODE) {
			if (minipro_begin_transaction(handle))
				return EXIT_FAILURE;
			if (verify_page_file(handle, MP_CODE,
					     handle->device->code_memory_size))
				ret = EXIT_FAILURE;
		}

		if (!handle->device->data_memory_size &&
		    handle->cmdopts->page == DATA) {
			fprintf(stderr, "No data section found.\n");
			return EXIT_FAILURE;
		}

		if (!handle->device->data_memory2_size &&
		    handle->cmdopts->page == USER) {
			fprintf(stderr, "No user section found.\n");
			return EXIT_FAILURE;
		}

		if (!handle->device->config &&
		    handle->cmdopts->page == CONFIG) {
			fprintf(stderr, "No config section found.\n");
			return EXIT_FAILURE;
		}

		// Verifying data memory section. If filename is null then a blank check
		// is performed
		if (handle->device->data_memory_size &&
		    (handle->cmdopts->page == DATA ||
		     (handle->cmdopts->page == UNSPECIFIED &&
		      !handle->cmdopts->filename))) {
			if (minipro_begin_transaction(handle))
				return EXIT_FAILURE;
			if (verify_page_file(handle, MP_DATA,
					     handle->device->data_memory_size))
				ret = EXIT_FAILURE;
		}

		// Verifying user memory section. If filename is null then a blank check
		// is performed
		if (handle->device->data_memory2_size &&
		    (handle->cmdopts->page == USER ||
		     (handle->cmdopts->page == UNSPECIFIED &&
		      !handle->cmdopts->filename))) {
			if (minipro_begin_transaction(handle))
				return EXIT_FAILURE;
			if (verify_page_file(handle, MP_USER,
					     handle->device->data_memory2_size))
				ret = EXIT_FAILURE;
		}

		// Verifying configuration bytes.
		if (handle->device->config &&
		    (handle->cmdopts->page == CONFIG ||
		     (handle->cmdopts->page == UNSPECIFIED &&
		      !handle->cmdopts->filename))) {
			ret = verify_fuses(handle, handle->device->config);
		}
	}
	return ret;
}

int main(int argc, char **argv)
{
#ifdef _WIN32
	system(" "); // If we are in windows start the VT100 support
	// Set the Windows translation mode to binary
	setmode(STDOUT_FILENO, O_BINARY);
	setmode(STDIN_FILENO, O_BINARY);
#endif

	cmdopts_t cmdopts;
	parse_cmdline(argc, argv, &cmdopts);

	// Check if a file name is required
	switch (cmdopts.action) {
	case LOGIC_IC_TEST:
		break;
	case READ:
	case WRITE:
	case VERIFY:
		if (!cmdopts.filename && !cmdopts.idcheck_only) {
			fprintf(stderr,
				"A file name is required for this action.\n");
			print_help_and_exit(argv[0]);
		}
		break;
	default:
		break;
	}

	// Check if a device name is required
	if (!cmdopts.device_name) {
		fprintf(stderr,
			"Device required. Use -p <device> to specify a device.\n");
		print_help_and_exit(argv[0]);
	}

	// don't permit skipping the ID read in write/erase-mode or ID only mode
	if ((cmdopts.action == WRITE || cmdopts.action == ERASE ||
	     cmdopts.idcheck_only) &&
	    cmdopts.idcheck_skip) {
		fprintf(stderr,
			"Skipping the ID check is not permitted for this action.\n");
		print_help_and_exit(argv[0]);
	}

	// Exit if no action is supplied
	if (cmdopts.action == NO_ACTION && !cmdopts.idcheck_only &&
	    !cmdopts.pincheck) {
		fprintf(stderr, "No action to perform.\n");
		print_help_and_exit(argv[0]);
	}

	// Set the pipe flag
	if (cmdopts.filename)
		cmdopts.is_pipe = (!strcmp(cmdopts.filename, "-"));

	// get a handle
	minipro_handle_t *handle = minipro_open(VERBOSE);
	if (!handle)
		return EXIT_FAILURE;
	handle->cmdopts = &cmdopts;

	// Get the requested device
	if (get_device(handle)) {
		minipro_close(handle);
		return EXIT_FAILURE;
	}

	// Exit if bootloader is active
	minipro_print_system_info(handle);
	if (handle->status == MP_STATUS_BOOTLOADER) {
		fprintf(stderr, "in bootloader mode!\nExiting...\n");
		minipro_close(handle);
		return EXIT_FAILURE;
	}

	// Parse programming options
	if (parse_options(handle, argc, argv)) {
		if (strlen(optarg))
			fprintf(stderr, "Invalid option '%s'\n", optarg);
		minipro_close(handle);
		print_help_and_exit(argv[0]);
	}

	if (cmdopts.pincheck) {
		if (handle->version == MP_TL866IIPLUS && !cmdopts.icsp) {
			if (minipro_pin_test(handle)) {
				minipro_end_transaction(handle);
				minipro_close(handle);
				return EXIT_FAILURE;
			}
		} else
			fprintf(stderr, "Pin test is not supported.\n");
		if (cmdopts.action == NO_ACTION && !cmdopts.idcheck_only)
			return EXIT_SUCCESS;
	}

	if (cmdopts.action == LOGIC_IC_TEST) {
		if (minipro_logic_ic_test(handle)) {
			minipro_close(handle);
			return EXIT_FAILURE;
		}
		minipro_close(handle);
		return EXIT_SUCCESS;
	}

	// Check for GAL/PLD
	if (handle->device->chip_type != MP_PLD &&
	    !handle->device->read_buffer_size) {
		minipro_close(handle);
		fprintf(stderr, "Unsupported device!\n");
		return EXIT_FAILURE;
	}

	// Check for NAND devices
	if (handle->device->chip_type == MP_NAND) {
		minipro_close(handle);
		fprintf(stderr, "NAND chips not supported yet.\n");
		return EXIT_FAILURE;
	}

	// Unlocking the TSOP48 adapter (if applicable)
	uint8_t status;
	switch (handle->device->package_details.adapter) {
	case TSOP48_ADAPTER:
	case SOP44_ADAPTER:
	case SOP56_ADAPTER:
		if (minipro_unlock_tsop48(handle, &status)) {
			minipro_close(handle);
			return EXIT_FAILURE;
		}
		switch (status) {
		case MP_TSOP48_TYPE_V3:
			fprintf(stderr, "Found TSOP adapter V3\n");
			break;
		case MP_TSOP48_TYPE_NONE:
			minipro_end_transaction(
				handle); // We need this to turn off the
					 // power on the ZIF socket.
			minipro_close(handle);
			fprintf(stderr, "TSOP adapter not found!\n");
			return EXIT_FAILURE;
		case MP_TSOP48_TYPE_V0:
			fprintf(stderr, "Found TSOP adapter V0\n");
			break;
		case MP_TSOP48_TYPE_FAKE1:
		case MP_TSOP48_TYPE_FAKE2:
			fprintf(stderr, "Fake TSOP adapter found!\n");
			break;
		}
		minipro_end_transaction(handle);
		break;
	}

	// Activate ICSP if the chip can only be programmed via ICSP.
	handle->icsp = 0;
	if (handle->device->flags.prog_support == MP_ICSP_ONLY) {
		handle->icsp = MP_ICSP_ENABLE | MP_ICSP_VCC;
	} else if (handle->device->flags.prog_support == MP_ZIF_ICSP)
		handle->icsp = cmdopts.icsp;
	if (handle->icsp)
		fprintf(stderr, "Activating ICSP...\n");
	if (cmdopts.icsp && handle->device->flags.prog_support == MP_ZIF_ONLY)
		fprintf(stderr,
			"Warning: ICSP is not supported by this chip.\n");

	uint8_t id_type;
	// Verifying Chip ID (if applicable)
	if (cmdopts.idcheck_skip) {
		fprintf(stderr, "WARNING: skipping Chip ID test\n");
	} else if (handle->device->flags.has_chip_id) {
		if (minipro_begin_transaction(handle)) {
			minipro_close(handle);
			return EXIT_FAILURE;
		}
		uint32_t chip_id;
		if (minipro_get_chip_id(handle, &id_type, &chip_id)) {
			minipro_close(handle);
			return EXIT_FAILURE;
		}
		if (minipro_end_transaction(handle)) {
			minipro_close(handle);
			return EXIT_FAILURE;
		}
		uint32_t chip_id_temp = chip_id;
		uint8_t shift = 0;
		fuse_decl_t *config = ((fuse_decl_t *)handle->device->config);
		/* The id_type will tell us the Chip ID type. There are 5 types */
		uint32_t ok = 0;
		switch (id_type) {
		case MP_ID_TYPE1: // 1-3 bytes ID
		case MP_ID_TYPE2: // 4 bytes ID
		case MP_ID_TYPE5: // 3 bytes ID, this ID type is returning from 25 SPI
				  // series.
			ok = (chip_id == handle->device->chip_id);
			if (ok) {
				fprintf(stderr, "Chip ID: 0x%04X  OK\n",
					chip_id);
			}
			break;
		case MP_ID_TYPE3: // Microchip controllers with 5 bit revision number.
			ok = (handle->device->chip_id >> 5 ==
			      (chip_id >>
			       5)); // Throw the chip revision (last 5 bits).
			if (ok) {
				fprintf(stderr,
					"Chip ID: 0x%04X, Rev.0x%02X  OK\n",
					chip_id >> 5, chip_id & 0x1F);
			}
			chip_id >>= 5;
			chip_id_temp = chip_id << 5;
			shift = 5;
			break;
		case MP_ID_TYPE4: // Microchip controllers with 4-5 bit revision
				  // number.
			ok = (handle->device->chip_id >> config->rev_bits ==
			      (chip_id >>
			       config->rev_bits)); // Throw the chip revision (last
						   // rev_mask bits).
			if (ok) {
				fprintf(stderr,
					"Chip ID: 0x%04X, Rev.0x%02X  OK\n",
					chip_id >> config->rev_bits,
					chip_id & ~(0xFF << config->rev_bits));
			}
			chip_id >>= config->rev_bits;
			chip_id_temp = chip_id << config->rev_bits;
			shift = config->rev_bits;
			break;
		}

		if (cmdopts.idcheck_only && ok) {
			minipro_close(handle);
			return EXIT_SUCCESS;
		}

		if (!ok) {
			db_data_t db_data;
			memset(&db_data, 0, sizeof(db_data));
			db_data.logicic_path = cmdopts.logicic_path;
			db_data.infoic_path = cmdopts.infoic_path;
			db_data.version = handle->version;
			db_data.chip_id = chip_id_temp;
			db_data.protocol = handle->device->protocol_id;
			const char *name = get_device_from_id(&db_data);
			if (cmdopts.idcheck_only) {
				fprintf(stderr,
					"Chip ID mismatch: expected 0x%04X, got 0x%04X (%s)\n",
					handle->device->chip_id >> shift,
					chip_id_temp >> shift,
					name ? name : "unknown");
				minipro_close(handle);
				if (name)
					free((char *)name);
				return EXIT_FAILURE;
			}
			if (cmdopts.idcheck_continue) {
				fprintf(stderr,
					"WARNING: Chip ID mismatch: expected 0x%04X, got 0x%04X (%s)\n",
					handle->device->chip_id >> shift,
					chip_id_temp >> shift,
					name ? name : "unknown");
			} else {
				fprintf(stderr,
					"Invalid Chip ID: expected 0x%04X, got 0x%04X (%s)\n(use '-y' "
					"to continue anyway at your own risk)\n",
					handle->device->chip_id >> shift,
					chip_id_temp >> shift,
					name ? name : "unknown");
				minipro_close(handle);
				if (name)
					free((char *)name);
				return EXIT_FAILURE;
			}
			if (name)
				free((char *)name);
		}

	} else if (cmdopts.idcheck_only) {
		minipro_close(handle);
		fprintf(stderr, "This chip doesn't have a chip ID!\n");
		return EXIT_FAILURE;
	}

	// Performing requested action
	int ret;
	switch (cmdopts.action) {
	case READ:
		ret = action_read(handle);
		break;
	case WRITE:
		if (handle->device->flags.prog_support == MP_READ_ONLY) {
			fprintf(stderr, "Read-only chip.\n");
			minipro_close(handle);
			return EXIT_FAILURE;
		}
		ret = action_write(handle);
		break;
	case VERIFY:
	case BLANK_CHECK:
		ret = action_verify(handle);
		break;
	case ERASE:
		if (!handle->device->flags.can_erase) {
			fprintf(stderr, "This chip can't be erased!\n");
			minipro_close(handle);
			return EXIT_FAILURE;
		}
		if (minipro_begin_transaction(handle)) {
			minipro_close(handle);
			return EXIT_FAILURE;
		}
		ret = erase_device(handle);
		break;
	default:
		ret = EXIT_FAILURE;
		break;
	}

	if (minipro_end_transaction(handle)) {
		minipro_close(handle);
		return EXIT_FAILURE;
	}
	minipro_close(handle);
	return ret;
}
