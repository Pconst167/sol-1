/*
 * minipro.c - Low level operations.
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

#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include "database.h"
#include "minipro.h"
#include "tl866a.h"
#include "tl866iiplus.h"
#include "usb.h"

#define TL866A_RESET	  0xFF
#define TL866IIPLUS_RESET 0x3F

#define CRC32_POLYNOMIAL  0xEDB88320

void format_int(uint8_t *out, uint32_t in, size_t size, uint8_t endianness)
{
	uint32_t idx;
	size_t i;
	for (i = 0; i < size; i++) {
		idx = (endianness == MP_LITTLE_ENDIAN ? i : size - 1 - i);
		out[i] = (in & 0xFF << idx * 8) >> idx * 8;
	}
}

uint32_t load_int(uint8_t *buffer, size_t size, uint8_t endianness)
{
	uint32_t idx, result = 0;
	size_t i;
	for (i = 0; i < size; i++) {
		idx = (endianness == MP_LITTLE_ENDIAN ? i : size - 1 - i);
		result |= (buffer[i] << idx * 8);
	}
	return result;
}

// Simple crc32
uint32_t crc32(uint8_t *data, size_t size, uint32_t initial)
{
	uint32_t i, j, crc;
	crc = initial;
	for (i = 0; i < size; i++) {
		crc = crc ^ data[i];
		for (j = 0; j < 8; j++)
			crc = (crc >> 1) ^ (CRC32_POLYNOMIAL & (-(crc & 1)));
	}
	return crc;
}

static int minipro_get_system_info(minipro_handle_t *handle)
{
	uint8_t msg[80], hw;
	memset(msg, 0x0, sizeof(msg));

	if (msg_send(handle->usb_handle, msg, 5))
		return EXIT_FAILURE;
	if (msg_recv(handle->usb_handle, msg, sizeof(msg)))
		return EXIT_FAILURE;

	handle->version = msg[6];
	switch (msg[6]) {
	case MP_TL866IIPLUS:
		handle->status = (msg[4] == 0) ? MP_STATUS_BOOTLOADER :
						 MP_STATUS_NORMAL;
		handle->model = "TL866II+";
		memcpy(handle->device_code, msg + 8, 8);
		memcpy(handle->serial_number, msg + 16, 20);
		hw = msg[40];
		break;

	case MP_TL866A:
	case MP_TL866CS:
		handle->status = msg[1];
		handle->model = msg[6] == MP_TL866A ? "TL866A" : "TL866CS";
		memcpy(handle->device_code, msg + 7, 8);
		memcpy(handle->serial_number, msg + 15, 24);
		hw = msg[39];
		break;
	default:
		return EXIT_SUCCESS;
	}

	handle->firmware = load_int(&msg[4], 2, MP_LITTLE_ENDIAN);
	snprintf(handle->firmware_str, sizeof(handle->firmware_str),
		 "%02d.%d.%d", hw, msg[5], msg[4]);
	return EXIT_SUCCESS;
}

minipro_handle_t *minipro_open(uint8_t verbose)
{
	minipro_handle_t *handle = calloc(1, sizeof(minipro_handle_t));
	if (!handle) {
		if (verbose)
			fprintf(stderr, "Out of memory!\n");
		return NULL;
	}

	// get a usb handle
	handle->usb_handle = usb_open(verbose);
	if (!handle->usb_handle) {
		free(handle);
		return NULL;
	}

	// get the system info
	if (minipro_get_system_info(handle))
		return NULL;
	switch (handle->version) {
	case MP_TL866A:
	case MP_TL866CS:
	case MP_TL866IIPLUS:
		switch (handle->status) {
		case MP_STATUS_NORMAL:
		case MP_STATUS_BOOTLOADER:
			break;
		default:
			minipro_close(handle);
			if (verbose)
				fprintf(stderr,
					"\nUnknown device status!\nExiting...\n");
			return NULL;
		}
		break;
	default:
		minipro_close(handle);
		if (verbose)
			fprintf(stderr, "Unknown programmer model!\n");
		return NULL;
	}

	// Initialize function pointers
	switch (handle->version) {
	case MP_TL866A:
	case MP_TL866CS:
		handle->minipro_begin_transaction = tl866a_begin_transaction;
		handle->minipro_end_transaction = tl866a_end_transaction;
		handle->minipro_protect_off = tl866a_protect_off;
		handle->minipro_protect_on = tl866a_protect_on;
		handle->minipro_get_ovc_status = tl866a_get_ovc_status;
		handle->minipro_read_block = tl866a_read_block;
		handle->minipro_write_block = tl866a_write_block;
		handle->minipro_get_chip_id = tl866a_get_chip_id;
		handle->minipro_spi_autodetect = tl866a_spi_autodetect;
		handle->minipro_read_fuses = tl866a_read_fuses;
		handle->minipro_write_fuses = tl866a_write_fuses;
		handle->minipro_read_calibration = tl866a_read_calibration;
		handle->minipro_erase = tl866a_erase;
		handle->minipro_unlock_tsop48 = tl866a_unlock_tsop48;
		handle->minipro_hardware_check = tl866a_hardware_check;
		handle->minipro_read_jedec_row = tl866a_read_jedec_row;
		handle->minipro_write_jedec_row = tl866a_write_jedec_row;
		handle->minipro_firmware_update = tl866a_firmware_update;
		handle->minipro_logic_ic_test = tl866a_logic_ic_test;
		handle->minipro_reset_state = tl866a_reset_state;
		handle->minipro_set_zif_direction = tl866a_set_zif_direction;
		handle->minipro_set_zif_state = tl866a_set_zif_state;
		handle->minipro_get_zif_state = tl866a_get_zif_state;
		handle->minipro_set_pin_drivers = tl866a_set_pin_drivers;
		handle->minipro_set_voltages = tl866a_set_voltages;
		break;
	case MP_TL866IIPLUS:
		handle->minipro_begin_transaction =
			tl866iiplus_begin_transaction;
		handle->minipro_end_transaction = tl866iiplus_end_transaction;
		handle->minipro_get_chip_id = tl866iiplus_get_chip_id;
		handle->minipro_spi_autodetect = tl866iiplus_spi_autodetect;
		handle->minipro_read_block = tl866iiplus_read_block;
		handle->minipro_write_block = tl866iiplus_write_block;
		handle->minipro_protect_off = tl866iiplus_protect_off;
		handle->minipro_protect_on = tl866iiplus_protect_on;
		handle->minipro_erase = tl866iiplus_erase;
		handle->minipro_read_fuses = tl866iiplus_read_fuses;
		handle->minipro_write_fuses = tl866iiplus_write_fuses;
		handle->minipro_read_calibration = tl866iiplus_read_calibration;
		handle->minipro_get_ovc_status = tl866iiplus_get_ovc_status;
		handle->minipro_unlock_tsop48 = tl866iiplus_unlock_tsop48;
		handle->minipro_hardware_check = tl866iiplus_hardware_check;
		handle->minipro_read_jedec_row = tl866iiplus_read_jedec_row;
		handle->minipro_write_jedec_row = tl866iiplus_write_jedec_row;
		handle->minipro_firmware_update = tl866iiplus_firmware_update;
		handle->minipro_pin_test = tl866iiplus_pin_test;
		handle->minipro_logic_ic_test = tl866iiplus_logic_ic_test;
		handle->minipro_reset_state = tl866iiplus_reset_state;
		handle->minipro_set_zif_direction =
			tl866iiplus_set_zif_direction;
		handle->minipro_set_zif_state = tl866iiplus_set_zif_state;
		handle->minipro_get_zif_state = tl866iiplus_get_zif_state;
		handle->minipro_set_pin_drivers = tl866iiplus_set_pin_drivers;
		handle->minipro_set_voltages = tl866iiplus_set_voltages;
		break;
	}
	return handle;
}

void minipro_close(minipro_handle_t *handle)
{
	if (handle && handle->usb_handle)
		usb_close(handle->usb_handle);
	if (handle && handle->device) {
		if (handle->device->config) {
			if (handle->device->chip_type == MP_PLD &&
			    ((gal_config_t *)(handle->device->config))->acw_bits)
				free(((gal_config_t *)(handle->device->config))
					     ->acw_bits);
			free(handle->device->config);
		}
		if (handle->device->vectors)
			free(handle->device->vectors);
	}
	if (handle->device)
		free(handle->device);
	if (handle)
		free(handle);
}

// Reset TL866 device
int minipro_reset(minipro_handle_t *handle)
{
	uint8_t msg[8];
	uint8_t version = handle->version;

	memset(msg, 0, sizeof(msg));
	msg[0] = version == MP_TL866IIPLUS ? TL866IIPLUS_RESET : TL866A_RESET;
	if (msg_send(handle->usb_handle, msg,
		     version == MP_TL866IIPLUS ? 8 : 4)) {
		return EXIT_FAILURE;
	}

	uint32_t wait = 200; // 20 Sec wait to disappear
	do {
		wait--;
		usleep(100000);
	} while (minipro_get_devices_count(version) && wait);
	if (!wait) {
		return EXIT_FAILURE;
	}

	wait = 200; // 20 Sec wait to appear
	do {
		wait--;
		usleep(100000);
	} while (!minipro_get_devices_count(version) && wait);
	if (!wait) {
		return EXIT_FAILURE;
	}
	return EXIT_SUCCESS;
}

void minipro_print_system_info(minipro_handle_t *handle)
{
	uint16_t expected_firmware = 0;
	char *expected_firmware_str = NULL;

	switch (handle->version) {
	case MP_TL866A:
	case MP_TL866CS:
		expected_firmware = TL866A_FIRMWARE_VERSION;
		expected_firmware_str = TL866A_FIRMWARE_STRING;
		break;
	case MP_TL866IIPLUS:
		expected_firmware = TL866IIPLUS_FIRMWARE_VERSION;
		expected_firmware_str = TL866IIPLUS_FIRMWARE_STRING;
	}

	if (handle->status == MP_STATUS_BOOTLOADER) {
		fprintf(stderr, "Found %s ", handle->model);
		return;
	}

	fprintf(stderr, "Found %s %s (%#03x)\n", handle->model,
		handle->firmware_str, handle->firmware);

	if (handle->firmware < expected_firmware) {
		fprintf(stderr, "Warning: Firmware is out of date.\n");
		fprintf(stderr, "  Expected  %s (%#03x)\n",
			expected_firmware_str, expected_firmware);
		fprintf(stderr, "  Found     %s (%#03x)\n",
			handle->firmware_str, handle->firmware);
	} else if (handle->firmware > expected_firmware) {
		fprintf(stderr, "Warning: Firmware is newer than expected.\n");
		fprintf(stderr, "  Expected  %s (%#03x)\n",
			expected_firmware_str, expected_firmware);
		fprintf(stderr, "  Found     %s (%#03x)\n",
			handle->firmware_str, handle->firmware);
	}
	// fprintf(stderr, "Device code:%s\nSerial code:%s\n", handle->device_code,
	// handle->serial_number);
}

int minipro_begin_transaction(minipro_handle_t *handle)
{
	assert(handle != NULL);

	// pack voltages
	voltages_t *voltages = &handle->device->voltages;
	voltages->raw_voltages = (voltages->raw_voltages & 0xffff000f) |
				 (voltages->vdd << 12) | (voltages->vcc << 8) |
				 (voltages->vpp << 4);
	if (handle->minipro_begin_transaction) {
		return handle->minipro_begin_transaction(handle);
	} else {
		fprintf(stderr, "%s: begin_transaction not implemented\n",
			handle->model);
	}
	return EXIT_FAILURE;
}

int minipro_end_transaction(minipro_handle_t *handle)
{
	assert(handle != NULL);
	if (handle->minipro_end_transaction) {
		return handle->minipro_end_transaction(handle);
	} else {
		fprintf(stderr, "%s: end_transaction not implemented\n",
			handle->model);
	}
	return EXIT_FAILURE;
}

int minipro_protect_off(minipro_handle_t *handle)
{
	assert(handle != NULL);

	if (handle->minipro_protect_off) {
		return handle->minipro_protect_off(handle);
	} else {
		fprintf(stderr, "%s: protect_off not implemented\n",
			handle->model);
	}
	return EXIT_FAILURE;
}

int minipro_protect_on(minipro_handle_t *handle)
{
	assert(handle != NULL);

	if (handle->minipro_protect_on) {
		return handle->minipro_protect_on(handle);
	} else {
		fprintf(stderr, "%s: protect_on not implemented\n",
			handle->model);
	}
	return EXIT_FAILURE;
}

int minipro_get_ovc_status(minipro_handle_t *handle, minipro_status_t *status,
			   uint8_t *ovc)
{
	assert(handle != NULL);
	if (status) {
		memset(status, 0x00, sizeof(*status));
	}

	if (handle->minipro_get_ovc_status) {
		return handle->minipro_get_ovc_status(handle, status, ovc);
	}
	fprintf(stderr, "%s: get_ovc_status not implemented\n", handle->model);
	return EXIT_FAILURE;
}

int minipro_erase(minipro_handle_t *handle)
{
	assert(handle != NULL);
	if (handle->minipro_erase) {
		return handle->minipro_erase(handle);
	}
	fprintf(stderr, "%s: erase not implemented\n", handle->model);
	return EXIT_FAILURE;
}

int minipro_read_block(minipro_handle_t *handle, uint8_t type, uint32_t addr,
		       uint8_t *buffer, size_t len)
{
	assert(handle != NULL);
	if (handle->minipro_read_block) {
		return handle->minipro_read_block(handle, type, addr, buffer,
						  len);
	} else {
		fprintf(stderr, "%s: read_block not implemented\n",
			handle->model);
	}
	return EXIT_FAILURE;
}

int minipro_write_block(minipro_handle_t *handle, uint8_t type, uint32_t addr,
			uint8_t *buffer, size_t len)
{
	assert(handle != NULL);
	if (handle->minipro_write_block) {
		return handle->minipro_write_block(handle, type, addr, buffer,
						   len);
	} else {
		fprintf(stderr, "%s: write_block not implemented\n",
			handle->model);
	}
	return EXIT_FAILURE;
}

/* Model-specific ID, e.g. AVR Device ID (not longer than 4 bytes) */
int minipro_get_chip_id(minipro_handle_t *handle, uint8_t *type,
			uint32_t *device_id)
{
	assert(handle != NULL);
	if (handle->minipro_get_chip_id) {
		return handle->minipro_get_chip_id(handle, type, device_id);
	}
	fprintf(stderr, "%s: get_chip_id not implemented\n", handle->model);
	return EXIT_FAILURE;
}

int minipro_spi_autodetect(minipro_handle_t *handle, uint8_t type,
			   uint32_t *device_id)
{
	assert(handle != NULL);
	if (handle->minipro_spi_autodetect) {
		return handle->minipro_spi_autodetect(handle, type, device_id);
	}
	fprintf(stderr, "%s: spi_autodetect not implemented\n", handle->model);
	return EXIT_FAILURE;
}

int minipro_read_fuses(minipro_handle_t *handle, uint8_t type, size_t length,
		       uint8_t items_count, uint8_t *buffer)
{
	assert(handle != NULL);

	// If chip lock bit is write only don't read it.
	if (type == MP_FUSE_LOCK && handle->device->flags.lock_bit_write_only)
		return EXIT_SUCCESS;

	if (handle->minipro_read_fuses) {
		return handle->minipro_read_fuses(handle, type, length,
						  items_count, buffer);
	} else {
		fprintf(stderr, "%s: read_fuses not implemented\n",
			handle->model);
	}
	return EXIT_FAILURE;
}

int minipro_write_fuses(minipro_handle_t *handle, uint8_t type, size_t length,
			uint8_t items_count, uint8_t *buffer)
{
	assert(handle != NULL);

	if (handle->minipro_write_fuses) {
		return handle->minipro_write_fuses(handle, type, length,
						   items_count, buffer);
	} else {
		fprintf(stderr, "%s: write_fuses not implemented\n",
			handle->model);
	}
	return EXIT_FAILURE;
}

int minipro_write_jedec_row(minipro_handle_t *handle, uint8_t *buffer,
			    uint8_t row, uint8_t flags, size_t size)
{
	assert(handle != NULL);
	if (handle->minipro_write_jedec_row) {
		return handle->minipro_write_jedec_row(handle, buffer, row,
						       flags, size);
	} else {
		fprintf(stderr, "%s: write jedec row not implemented\n",
			handle->model);
	}
	return EXIT_FAILURE;
}

int minipro_read_jedec_row(minipro_handle_t *handle, uint8_t *buffer,
			   uint8_t row, uint8_t flags, size_t size)
{
	assert(handle != NULL);
	if (handle->minipro_read_jedec_row) {
		return handle->minipro_read_jedec_row(handle, buffer, row,
						      flags, size);
	} else {
		fprintf(stderr, "%s: read jedec row not implemented\n",
			handle->model);
	}
	return EXIT_FAILURE;
}

int minipro_read_calibration(minipro_handle_t *handle, uint8_t *buffer,
			     size_t size)
{
	assert(handle != NULL);
	if (handle->minipro_read_calibration) {
		return handle->minipro_read_calibration(handle, buffer, size);
	} else {
		fprintf(stderr, "%s: read calib. bytes not implemented\n",
			handle->model);
	}
	return EXIT_FAILURE;
}

// Unlocking the TSOP48 adapter.
int minipro_unlock_tsop48(minipro_handle_t *handle, uint8_t *status)
{
	assert(handle != NULL);

	if (handle->minipro_unlock_tsop48) {
		return handle->minipro_unlock_tsop48(handle, status);
	}
	fprintf(stderr, "%s: unlock_tsop48 not implemented\n", handle->model);
	return EXIT_FAILURE;
}

// Minipro hardware check
int minipro_hardware_check(minipro_handle_t *handle)
{
	assert(handle != NULL);

	if (handle->minipro_hardware_check) {
		return handle->minipro_hardware_check(handle);
	} else {
		fprintf(stderr, "%s: hardware_check not implemented\n",
			handle->model);
	}
	return EXIT_FAILURE;
}

int minipro_firmware_update(minipro_handle_t *handle, const char *firmware)
{
	assert(handle != NULL);
	if (handle->minipro_firmware_update) {
		return handle->minipro_firmware_update(handle, firmware);
	} else {
		fprintf(stderr, "%s: firmware update not implemented\n",
			handle->model);
	}
	return EXIT_FAILURE;
}

// Pin contact test
int minipro_pin_test(minipro_handle_t *handle)
{
	assert(handle != NULL);
	if (handle->minipro_pin_test) {
		return handle->minipro_pin_test(handle);
	} else {
		fprintf(stderr, "%s: pin test not implemented\n",
			handle->model);
	}
	return EXIT_FAILURE;
}

int minipro_logic_ic_test(minipro_handle_t *handle)
{
	assert(handle != NULL);
	if (handle->minipro_logic_ic_test) {
		return handle->minipro_logic_ic_test(handle);
	}
	fprintf(stderr, "%s: logic IC test not implemented\n", handle->model);
	return EXIT_FAILURE;
}
