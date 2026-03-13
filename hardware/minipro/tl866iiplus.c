/*
 * tl866iiplus.c - Low level ops for TL866II+.
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
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <time.h>

#include "database.h"
#include "minipro.h"
#include "tl866iiplus.h"
#include "bitbang.h"
#include "usb.h"

#define TL866IIPLUS_NAND_INIT		 0x02
#define TL866IIPLUS_BEGIN_TRANS		 0x03
#define TL866IIPLUS_END_TRANS		 0x04
#define TL866IIPLUS_READID		 0x05
#define TL866IIPLUS_READ_USER		 0x06
#define TL866IIPLUS_WRITE_USER		 0x07
#define TL866IIPLUS_READ_CFG		 0x08
#define TL866IIPLUS_WRITE_CFG		 0x09
#define TL866IIPLUS_WRITE_USER_DATA	 0x0A
#define TL866IIPLUS_READ_USER_DATA	 0x0B
#define TL866IIPLUS_WRITE_CODE		 0x0C
#define TL866IIPLUS_READ_CODE		 0x0D
#define TL866IIPLUS_ERASE		 0x0E
#define TL866IIPLUS_READ_DATA		 0x10
#define TL866IIPLUS_WRITE_DATA		 0x11
#define TL866IIPLUS_WRITE_LOCK		 0x14
#define TL866IIPLUS_READ_LOCK		 0x15
#define TL866IIPLUS_READ_CALIBRATION	 0x16
#define TL866IIPLUS_PROTECT_OFF		 0x18
#define TL866IIPLUS_PROTECT_ON		 0x19
#define TL866IIPLUS_READ_JEDEC		 0x1D
#define TL866IIPLUS_WRITE_JEDEC		 0x1E
#define TL866IIPLUS_LOGIC_IC_TEST_VECTOR 0x28
#define TL866IIPLUS_AUTODETECT		 0x37
#define TL866IIPLUS_UNLOCK_TSOP48	 0x38
#define TL866IIPLUS_REQUEST_STATUS	 0x39

#define TL866IIPLUS_BOOTLOADER_WRITE	 0x3B
#define TL866IIPLUS_BOOTLOADER_ERASE	 0x3C
#define TL866IIPLUS_SWITCH		 0x3D

// Hardware Bit Banging
#define TL866IIPLUS_SET_VCC_VOLTAGE	 0x1B
#define TL866IIPLUS_SET_VPP_VOLTAGE	 0x1C
#define TL866IIPLUS_RESET_PIN_DRIVERS	 0x2D
#define TL866IIPLUS_SET_VCC_PIN		 0x2E
#define TL866IIPLUS_SET_VPP_PIN		 0x2F
#define TL866IIPLUS_SET_GND_PIN		 0x30
#define TL866IIPLUS_SET_PULLDOWNS	 0x31
#define TL866IIPLUS_SET_PULLUPS		 0x32
#define TL866IIPLUS_SET_DIR		 0x34
#define TL866IIPLUS_READ_PINS		 0x35
#define TL866IIPLUS_SET_OUT		 0x36

#define TL866IIPLUS_BTLDR_MAGIC		 0xA578B986

typedef struct zif_pins_s {
	uint8_t pin;
	uint8_t byte;
	uint8_t mask;
} zif_pins_t;

// clang-format off
// 21 VPP pins.
static zif_pins_t vpp_pins[] =
{
	{ .pin = 1, .byte = 10, .mask = 0x01 },
	{ .pin = 2, .byte = 11, .mask = 0x01 },
	{ .pin = 3, .byte = 12, .mask = 0x01 },
	{ .pin = 4, .byte = 13, .mask = 0x01 },
	{ .pin = 5, .byte = 14, .mask = 0x01 },
	{ .pin = 6, .byte = 8, .mask = 0x01 },
	{ .pin = 7, .byte = 8, .mask = 0x02 },
	{ .pin = 8, .byte = 8, .mask = 0x04 },
	{ .pin = 9, .byte = 8, .mask = 0x08 },
	{ .pin = 10, .byte = 8, .mask = 0x10 },
	{ .pin = 30, .byte = 8, .mask = 0x20 },
	{ .pin = 31, .byte = 8, .mask = 0x40 },
	{ .pin = 32, .byte = 8, .mask = 0x80 },
	{ .pin = 33, .byte = 9, .mask = 0x01 },
	{ .pin = 34, .byte = 9, .mask = 0x02 },
	{ .pin = 35, .byte = 9, .mask = 0x04 },
	{ .pin = 36, .byte = 9, .mask = 0x08 },
	{ .pin = 37, .byte = 9, .mask = 0x10 },
	{ .pin = 38, .byte = 9, .mask = 0x20 },
	{ .pin = 39, .byte = 9, .mask = 0x40 },
	{ .pin = 40, .byte = 9, .mask = 0x80 }
};

// 32 VCC Pins.
static zif_pins_t vcc_pins[] =
{
	{ .pin = 1, .byte = 8, .mask = 0x01 },
	{ .pin = 2, .byte = 8, .mask = 0x02 },
	{ .pin = 3, .byte = 8, .mask = 0x04 },
	{ .pin = 4, .byte = 8, .mask = 0x08 },
	{ .pin = 5, .byte = 8, .mask = 0x10 },
	{ .pin = 6, .byte = 8, .mask = 0x20 },
	{ .pin = 7, .byte = 8, .mask = 0x40 },
	{ .pin = 8, .byte = 8, .mask = 0x80 },
	{ .pin = 9, .byte = 9, .mask = 0x01 },
	{ .pin = 10, .byte = 9, .mask = 0x02 },
	{ .pin = 11, .byte = 9, .mask = 0x04 },
	{ .pin = 12, .byte = 9, .mask = 0x08 },
	{ .pin = 13, .byte = 9, .mask = 0x10 },
	{ .pin = 14, .byte = 9, .mask = 0x20 },
	{ .pin = 15, .byte = 9, .mask = 0x40 },
	{ .pin = 16, .byte = 9, .mask = 0x80 },
	{ .pin = 25, .byte = 10, .mask = 0x01 },
	{ .pin = 26, .byte = 10, .mask = 0x02 },
	{ .pin = 27, .byte = 10, .mask = 0x04 },
	{ .pin = 28, .byte = 10, .mask = 0x08 },
	{ .pin = 29, .byte = 10, .mask = 0x10 },
	{ .pin = 30, .byte = 10, .mask = 0x20 },
	{ .pin = 31, .byte = 10, .mask = 0x40 },
	{ .pin = 32, .byte = 10, .mask = 0x80 },
	{ .pin = 33, .byte = 11, .mask = 0x01 },
	{ .pin = 34, .byte = 11, .mask = 0x02 },
	{ .pin = 35, .byte = 11, .mask = 0x04 },
	{ .pin = 36, .byte = 11, .mask = 0x08 },
	{ .pin = 37, .byte = 11, .mask = 0x10 },
	{ .pin = 38, .byte = 11, .mask = 0x20 },
	{ .pin = 39, .byte = 11, .mask = 0x40 },
	{ .pin = 40, .byte = 11, .mask = 0x80 }
};

// 34 GND Pins.
static zif_pins_t gnd_pins[] =
{
	{ .pin = 1, .byte = 8, .mask = 0x01 },
	{ .pin = 2, .byte = 8, .mask = 0x02 },
	{ .pin = 3, .byte = 8, .mask = 0x04 },
	{ .pin = 4, .byte = 8, .mask = 0x08 },
	{ .pin = 5, .byte = 8, .mask = 0x10 },
	{ .pin = 6, .byte = 8, .mask = 0x20 },
	{ .pin = 7, .byte = 8, .mask = 0x40 },
	{ .pin = 8, .byte = 8, .mask = 0x80 },
	{ .pin = 9, .byte = 9, .mask = 0x01 },
	{ .pin = 10, .byte = 9, .mask = 0x02 },
	{ .pin = 11, .byte = 9, .mask = 0x04 },
	{ .pin = 12, .byte = 9, .mask = 0x08 },
	{ .pin = 13, .byte = 9, .mask = 0x10 },
	{ .pin = 14, .byte = 9, .mask = 0x20 },
	{ .pin = 15, .byte = 9, .mask = 0x40 },
	{ .pin = 16, .byte = 9, .mask = 0x80 },
	{ .pin = 20, .byte = 12, .mask = 0x01 },
	{ .pin = 21, .byte = 13, .mask = 0x01 },
	{ .pin = 25, .byte = 10, .mask = 0x01 },
	{ .pin = 26, .byte = 10, .mask = 0x02 },
	{ .pin = 27, .byte = 10, .mask = 0x04 },
	{ .pin = 28, .byte = 10, .mask = 0x08 },
	{ .pin = 29, .byte = 10, .mask = 0x10 },
	{ .pin = 30, .byte = 10, .mask = 0x20 },
	{ .pin = 31, .byte = 10, .mask = 0x40 },
	{ .pin = 32, .byte = 10, .mask = 0x80 },
	{ .pin = 33, .byte = 11, .mask = 0x01 },
	{ .pin = 34, .byte = 11, .mask = 0x02 },
	{ .pin = 35, .byte = 11, .mask = 0x04 },
	{ .pin = 36, .byte = 11, .mask = 0x08 },
	{ .pin = 37, .byte = 11, .mask = 0x10 },
	{ .pin = 38, .byte = 11, .mask = 0x20 },
	{ .pin = 39, .byte = 11, .mask = 0x40 },
	{ .pin = 40, .byte = 11, .mask = 0x80 },
};

enum VPP_PINS
{
    VPP1,	VPP2,	VPP3,	VPP4,	VPP5,	VPP6,	VPP7,
    VPP8,	VPP9,	VPP10,	VPP30,	VPP31,	VPP32,	VPP33,
    VPP34,	VPP35,	VPP36,	VPP37,	VPP38,	VPP39,	VPP40,
};

enum VCC_PINS
{
    VCC1,	VCC2,	VCC3,	VCC4,	VCC5,	VCC6,	VCC7,	VCC8,
    VCC9,	VCC10,	VCC11,	VCC12,	VCC13,	VCC14,	VCC15,	VCC16,
    VCC25,	VCC326,	VCC27,	VCC28,	VCC29,	VCC30,	VCC31,	VCC32,
    VCC33,	VCC34,	VCC35,	VCC36,	VCC37,	VCC38,	VCC39,	VCC40
};

enum GND_PINS
{
    GND1,	GND2,	GND3,	GND4,	GND5,	GND6,	GND7,	GND8,
    GND9,	GND10,	GND11,	GND12,	GND13,	GND14,	GND15,	GND16,
    GND20,	GND21,	GND25,	GND26,	GND27,	GND28,	GND29,	GND30,
    GND31,	GND32,	GND33,	GND34,	GND35,	GND36,	GND37,	GND38,
    GND39,	GND40
};

// clang-format on
int tl866iiplus_begin_transaction(minipro_handle_t *handle)
{
	uint8_t msg[64];
	uint8_t ovc;
	device_t *device = handle->device;

	memset(msg, 0x00, sizeof(msg));
	if (!handle->device->flags.custom_protocol) {
		/*
      // Send a NAND init
      if(handle->device->chip_type == MP_NAND){
              msg[0] = TL866IIPLUS_NAND_INIT;

             if(msg_send(handle->usb_handle, msg, sizeof(msg))) return
      EXIT_FAILURE; memset(msg, 0x00, sizeof(msg));
      }
    */

		msg[0] = TL866IIPLUS_BEGIN_TRANS;
		msg[1] = device->protocol_id;
		msg[2] = (uint8_t)handle->device->variant;
		msg[3] = handle->icsp;

		format_int(&(msg[4]), device->voltages.raw_voltages, 2,
			   MP_LITTLE_ENDIAN);
		msg[6] = (uint8_t)device->chip_info;
		msg[7] = (uint8_t)device->pin_map;
		format_int(&(msg[8]), device->data_memory_size, 2,
			   MP_LITTLE_ENDIAN);
		format_int(&(msg[10]), device->page_size, 2, MP_LITTLE_ENDIAN);
		format_int(&(msg[12]), device->pulse_delay, 2,
			   MP_LITTLE_ENDIAN);
		format_int(&(msg[14]), device->data_memory2_size, 2,
			   MP_LITTLE_ENDIAN);
		format_int(&(msg[16]), device->code_memory_size, 4,
			   MP_LITTLE_ENDIAN);

		msg[20] = (uint8_t)(device->voltages.raw_voltages >> 16);

		if ((device->voltages.raw_voltages & 0xf0) == 0xf0) {
			msg[22] = (uint8_t)device->voltages.raw_voltages;
		} else {
			msg[21] = (uint8_t)device->voltages.raw_voltages & 0x0f;
			msg[22] = (uint8_t)device->voltages.raw_voltages & 0xf0;
		}
		if (device->voltages.raw_voltages & 0x80000000)
			msg[22] = (device->voltages.raw_voltages >> 16) & 0x0f;

		format_int(&(msg[40]),
			   handle->device->package_details.packed_package, 4,
			   MP_LITTLE_ENDIAN);
		format_int(&(msg[44]), handle->device->read_buffer_size, 2,
			   MP_LITTLE_ENDIAN);
		format_int(&(msg[56]), handle->device->flags.raw_flags, 4,
			   MP_LITTLE_ENDIAN);

		if (msg_send(handle->usb_handle, msg, sizeof(msg)))
			return EXIT_FAILURE;
	} else {
		if (bb_begin_transaction(handle)) {
			return EXIT_FAILURE;
		}
	}
	if (tl866iiplus_get_ovc_status(handle, NULL, &ovc))
		return EXIT_FAILURE;
	if (ovc) {
		fprintf(stderr, "Overcurrent protection!\007\n");
		return EXIT_FAILURE;
	}
	return EXIT_SUCCESS;
}

int tl866iiplus_end_transaction(minipro_handle_t *handle)
{
	if (handle->device->flags.custom_protocol) {
		return bb_end_transaction(handle);
	}
	uint8_t msg[8];
	memset(msg, 0x00, sizeof(msg));
	msg[0] = TL866IIPLUS_END_TRANS;
	return msg_send(handle->usb_handle, msg, sizeof(msg));
}

int tl866iiplus_read_block(minipro_handle_t *handle, uint8_t type,
			   uint32_t addr, uint8_t *buf, size_t len)
{
	if (handle->device->flags.custom_protocol) {
		return bb_read_block(handle, type, addr, buf, len);
	}
	uint8_t msg[64];

	if (type == MP_CODE) {
		type = TL866IIPLUS_READ_CODE;
	} else if (type == MP_DATA) {
		type = TL866IIPLUS_READ_DATA;
	} else if (type == MP_USER) {
		type = TL866IIPLUS_READ_USER_DATA;
	} else {
		fprintf(stderr, "Unknown type for read_block (%d)\n", type);
		return EXIT_FAILURE;
	}

	memset(msg, 0x00, sizeof(msg));
	msg[0] = type;
	format_int(&(msg[2]), len, 2, MP_LITTLE_ENDIAN);
	format_int(&(msg[4]), addr, 4, MP_LITTLE_ENDIAN);
	if (msg_send(handle->usb_handle, msg, 8))
		return EXIT_FAILURE;

	// data_memory2 page is always read over endpoint 1
	if (type == TL866IIPLUS_READ_USER_DATA)
		return msg_recv(handle->usb_handle, buf, len);
	return read_payload(handle->usb_handle, buf, len);
}

int tl866iiplus_write_block(minipro_handle_t *handle, uint8_t type,
			    uint32_t addr, uint8_t *buf, size_t len)
{
	if (handle->device->flags.custom_protocol) {
		return bb_write_block(handle, type, addr, buf, len);
	}
	uint8_t msg[64];

	if (type == MP_CODE) {
		type = TL866IIPLUS_WRITE_CODE;
	} else if (type == MP_DATA) {
		type = TL866IIPLUS_WRITE_DATA;
	} else if (type == MP_USER) {
		type = TL866IIPLUS_WRITE_USER_DATA;
	} else {
		fprintf(stderr, "Unknown type for write_block (%d)\n", type);
		return EXIT_FAILURE;
	}

	memset(msg, 0x00, sizeof(msg));
	msg[0] = type;
	format_int(&(msg[2]), len, 2, MP_LITTLE_ENDIAN);
	format_int(&(msg[4]), addr, 4, MP_LITTLE_ENDIAN);
	if (len < 57) { // If the header + payload is up to 64 bytes
		memcpy(&(msg[8]), buf,
		       len); // Send the message over the endpoint 1
		if (msg_send(handle->usb_handle, msg, 8 + len))
			return EXIT_FAILURE;
	} else { // Otherwise send only the header over the endpoint 1
		if (msg_send(handle->usb_handle, msg, 8))
			return EXIT_FAILURE;
		if (write_payload(handle->usb_handle, buf,
				  handle->device->write_buffer_size))
			return EXIT_FAILURE; // And payload to the endp.2 and 3
	}
	return EXIT_SUCCESS;
}

int tl866iiplus_read_fuses(minipro_handle_t *handle, uint8_t type,
			   size_t length, uint8_t items_count, uint8_t *buffer)
{
	if (handle->device->flags.custom_protocol) {
		return bb_read_fuses(handle, type, length, items_count, buffer);
	}
	uint8_t msg[64];

	if (type == MP_FUSE_USER) {
		type = TL866IIPLUS_READ_USER;
	} else if (type == MP_FUSE_CFG) {
		type = TL866IIPLUS_READ_CFG;
	} else if (type == MP_FUSE_LOCK) {
		type = TL866IIPLUS_READ_LOCK;
	} else {
		fprintf(stderr, "Unknown type for read_fuses (%d)\n", type);
		return EXIT_FAILURE;
	}

	memset(msg, 0, sizeof(msg));
	msg[0] = type;
	msg[1] = handle->device->protocol_id;
	msg[2] = items_count;
	format_int(&msg[4], handle->device->code_memory_size, 4,
		   MP_LITTLE_ENDIAN);
	if (msg_send(handle->usb_handle, msg, 8))
		return EXIT_FAILURE;
	if (msg_recv(handle->usb_handle, msg, sizeof(msg)))
		return EXIT_FAILURE;
	memcpy(buffer, &(msg[8]), length);
	return EXIT_SUCCESS;
}

int tl866iiplus_write_fuses(minipro_handle_t *handle, uint8_t type,
			    size_t length, uint8_t items_count, uint8_t *buffer)
{
	if (handle->device->flags.custom_protocol) {
		return bb_write_fuses(handle, type, length, items_count,
				      buffer);
	}
	uint8_t msg[64];

	if (type == MP_FUSE_USER) {
		type = TL866IIPLUS_WRITE_USER;
	} else if (type == MP_FUSE_CFG) {
		type = TL866IIPLUS_WRITE_CFG;
	} else if (type == MP_FUSE_LOCK) {
		type = TL866IIPLUS_WRITE_LOCK;
	} else {
		fprintf(stderr, "Unknown type for write_fuses (%d)\n", type);
	}

	memset(msg, 0, sizeof(msg));
	msg[0] = type;
	if (buffer) {
		msg[1] = handle->device->protocol_id;
		msg[2] = items_count;
		format_int(&msg[4], handle->device->code_memory_size - 0x38, 4,
			   MP_LITTLE_ENDIAN); // 0x38, firmware bug?
		memcpy(&(msg[8]), buffer, length);
	}
	return msg_send(handle->usb_handle, msg, sizeof(msg));
}

int tl866iiplus_read_calibration(minipro_handle_t *handle, uint8_t *buffer,
				 size_t len)
{
	if (handle->device->flags.custom_protocol) {
		return bb_read_calibration(handle, buffer, len);
	}
	uint8_t msg[64];
	memset(msg, 0x00, sizeof(msg));
	msg[0] = TL866IIPLUS_READ_CALIBRATION;
	format_int(&(msg[2]), len, 2, MP_LITTLE_ENDIAN);
	if (msg_send(handle->usb_handle, msg, sizeof(msg)))
		return EXIT_FAILURE;
	return msg_recv(handle->usb_handle, buffer, len);
}

int tl866iiplus_get_chip_id(minipro_handle_t *handle, uint8_t *type,
			    uint32_t *device_id)
{
	if (handle->device->flags.custom_protocol) {
		return bb_get_chip_id(handle, device_id);
	}
	uint8_t msg[8], format, id_length;
	memset(msg, 0x00, sizeof(msg));
	msg[0] = TL866IIPLUS_READID;
	if (msg_send(handle->usb_handle, msg, sizeof(msg)))
		return EXIT_FAILURE;
	if (msg_recv(handle->usb_handle, msg, 6))
		return EXIT_FAILURE;
	*type = msg[0]; // The Chip ID type (1-5)
	format = (*type == MP_ID_TYPE3 || *type == MP_ID_TYPE4 ?
			  MP_LITTLE_ENDIAN :
			  MP_BIG_ENDIAN);
	// The length byte is always 1-4 but never know, truncate to max. 4 bytes.
	id_length = handle->device->chip_id_bytes_count > 4 ?
			    4 :
			    handle->device->chip_id_bytes_count;
	*device_id = (id_length ? load_int(&(msg[2]), id_length, format) :
				  0); // Check for positive length.
	return EXIT_SUCCESS;
}

int tl866iiplus_spi_autodetect(minipro_handle_t *handle, uint8_t type,
			       uint32_t *device_id)
{
	if (handle->device->flags.custom_protocol) {
		return bb_spi_autodetect(handle, type, device_id);
	}
	uint8_t msg[64];
	memset(msg, 0, sizeof(msg));
	msg[0] = TL866IIPLUS_AUTODETECT;
	msg[8] = type;
	if (msg_send(handle->usb_handle, msg, 10))
		return EXIT_FAILURE;
	if (msg_recv(handle->usb_handle, msg, 16))
		return EXIT_FAILURE;
	*device_id = load_int(&(msg[2]), 3, MP_BIG_ENDIAN);
	return EXIT_SUCCESS;
}

int tl866iiplus_protect_off(minipro_handle_t *handle)
{
	if (handle->device->flags.custom_protocol) {
		return bb_protect_off(handle);
	}
	uint8_t msg[8];
	memset(msg, 0, sizeof(msg));
	msg[0] = TL866IIPLUS_PROTECT_OFF;
	return msg_send(handle->usb_handle, msg, sizeof(msg));
}

int tl866iiplus_protect_on(minipro_handle_t *handle)
{
	if (handle->device->flags.custom_protocol) {
		return bb_protect_on(handle);
	}
	uint8_t msg[8];
	memset(msg, 0, sizeof(msg));
	msg[0] = TL866IIPLUS_PROTECT_ON;
	return msg_send(handle->usb_handle, msg, sizeof(msg));
}

int tl866iiplus_erase(minipro_handle_t *handle)
{
	if (handle->device->flags.custom_protocol) {
		return bb_erase(handle);
	}
	uint8_t msg[64];
	memset(msg, 0, sizeof(msg));
	msg[0] = TL866IIPLUS_ERASE;

	fuse_decl_t *fuses = (fuse_decl_t *)handle->device->config;
	if (!fuses || fuses->num_fuses)
		msg[2] = 1;
	else
		msg[2] = (fuses->num_fuses > 4) ? 1 : fuses->num_fuses;

	if (msg_send(handle->usb_handle, msg, 15))
		return EXIT_FAILURE;
	memset(msg, 0x00, sizeof(msg));
	return msg_recv(handle->usb_handle, msg, sizeof(msg));
}

int tl866iiplus_get_ovc_status(minipro_handle_t *handle,
			       minipro_status_t *status, uint8_t *ovc)
{
	uint8_t msg[32];
	memset(msg, 0, sizeof(msg));
	msg[0] = TL866IIPLUS_REQUEST_STATUS;
	if (msg_send(handle->usb_handle, msg, 8))
		return EXIT_FAILURE;
	if (msg_recv(handle->usb_handle, msg, sizeof(msg)))
		return EXIT_FAILURE;
	if (status && !handle->device->flags.custom_protocol) {
		// This is verify while writing feature.
		status->error = msg[0];
		status->address = load_int(&msg[8], 4, MP_LITTLE_ENDIAN);
		status->c1 = load_int(&msg[2], 2, MP_LITTLE_ENDIAN);
		status->c2 = load_int(&msg[4], 2, MP_LITTLE_ENDIAN);
	}
	*ovc = msg[12]; // return the ovc status
	return EXIT_SUCCESS;
}

int tl866iiplus_unlock_tsop48(minipro_handle_t *handle, uint8_t *status)
{
	uint8_t msg[48];
	uint16_t i, crc = 0;

	memset(msg, 0, sizeof(msg));
	msg[0] = TL866IIPLUS_UNLOCK_TSOP48;

	srand(time(NULL));
	for (i = 8; i < 16; i++) {
		msg[i] = (uint8_t)rand();
		// Calculate the crc16
		crc = (crc >> 8) | (crc << 8);
		crc ^= msg[i];
		crc ^= (crc & 0xFF) >> 4;
		crc ^= (crc << 12);
		crc ^= (crc & 0xFF) << 5;
	}
	msg[16] = msg[10];
	msg[17] = msg[12];
	msg[10] = (uint8_t)crc;
	msg[12] = (uint8_t)(crc >> 8);
	if (msg_send(handle->usb_handle, msg, sizeof(msg)))
		return EXIT_FAILURE;
	if (msg_recv(handle->usb_handle, msg, 8))
		return EXIT_FAILURE;
	*status = msg[1];
	return EXIT_SUCCESS;
}

int tl866iiplus_write_jedec_row(minipro_handle_t *handle, uint8_t *buffer,
				uint8_t row, uint8_t flags, size_t size)
{
	if (handle->device->flags.custom_protocol) {
		return bb_write_jedec_row(handle, buffer, row, flags, size);
	}
	uint8_t msg[64];
	memset(msg, 0, sizeof(msg));
	msg[0] = TL866IIPLUS_WRITE_JEDEC;
	msg[1] = handle->device->protocol_id;
	msg[2] = size;
	msg[4] = row;
	msg[5] = flags;
	memcpy(&msg[8], buffer, (size + 7) / 8);
	return msg_send(handle->usb_handle, msg, 64);
}

int tl866iiplus_read_jedec_row(minipro_handle_t *handle, uint8_t *buffer,
			       uint8_t row, uint8_t flags, size_t size)
{
	if (handle->device->flags.custom_protocol) {
		return bb_read_jedec_row(handle, buffer, row, flags, size);
	}
	uint8_t msg[32];
	memset(msg, 0, sizeof(msg));
	msg[0] = TL866IIPLUS_READ_JEDEC;
	msg[1] = handle->device->protocol_id;
	msg[2] = size;
	msg[4] = row;
	msg[5] = flags;
	if (msg_send(handle->usb_handle, msg, 8))
		return EXIT_FAILURE;
	if (msg_recv(handle->usb_handle, msg, 32))
		return EXIT_FAILURE;
	memcpy(buffer, msg, (size + 7) / 8);
	return EXIT_SUCCESS;
}

/* Firmware updater section
//////////////////////////////////////////////////////////////////////////////////

This is the UpdateII.dat file structure.
It has a variable size. There are small data blocks of 272 bytes each followed by the last data block which always has 2064 bytes.
|============|===========|============|==============|=============|=============|===================|======================|
|File version| File CRC  | XOR Table  | Blocks count | Block 0     | Block 1     | Block N           | Last block           |
|============|===========|============|==============|=============|=============|===================|======================|
|  4 bytes   | 4 bytes   | 1024 bytes | 4 bytes      | 272 bytes   | 272 bytes   | 272 bytes         | 2064 bytes           |
|============|===========|============|==============|=============|=============|===================|======================|
|  offset 0  | offset 4  | offset 8   | offset 1032  | offset 1036 | offset 1308 | offset 1036+N*272 | offset block N + 272 |
|============|===========|============|==============|=============|=============|===================|======================|


The structure of each data block is as following:
|============|===================|====================|=============================|================|
| Block CRC  | XOR table pointer | Encrypted address  | Internal decryption pointer | Encrypted data |
|============|===================|====================|=============================|================|
| 4 bytes    | 4 bytes           | 4 bytes            | 4 bytes (only LSB is used)  | 256/2048 bytes |
|============|===================|====================|=============================|================|
| offset 0   | offset 4          | offset 8           | offset 12                   | offset 16      |
|============|===================|====================|=============================|================|

*/

// Performing a firmware update
int tl866iiplus_firmware_update(minipro_handle_t *handle, const char *firmware)
{
	uint8_t msg[264];
	struct stat st;
	if (stat(firmware, &st)) {
		fprintf(stderr, "%s open error!: ", firmware);
		perror("");
		return EXIT_FAILURE;
	}

	off_t file_size = st.st_size;
	// Check the update.dat size
	if (file_size < 3100 || file_size > 1048576) {
		fprintf(stderr, "%s file size error!\n", firmware);
		return EXIT_FAILURE;
	}

	// Open the update.dat firmware file
	FILE *file = fopen(firmware, "rb");
	if (!file) {
		fprintf(stderr, "%s open error!: ", firmware);
		perror("");
		return EXIT_FAILURE;
	}
	uint8_t *update_dat = malloc(file_size);
	if (!update_dat) {
		fprintf(stderr, "Out of memory!\n");
		fclose(file);
		return EXIT_FAILURE;
	}

	// Read the updateII.dat file
	if (fread(update_dat, sizeof(char), st.st_size, file) != st.st_size) {
		fprintf(stderr, "%s file read error!\n", firmware);
		fclose(file);
		free(update_dat);
		return EXIT_FAILURE;
	}
	fclose(file);

	// Read the blocks count and check if correct
	uint32_t blocks = load_int(update_dat + 1032, 4, MP_LITTLE_ENDIAN);
	if (blocks * 272 + 3100 != file_size) {
		fprintf(stderr, "%s file size error!\n", firmware);
		free(update_dat);
		return EXIT_FAILURE;
	}

	// Compute the file CRC and compare
	uint32_t crc = 0xFFFFFFFF;
	// Note the order in which the crc is calculated!
	// First the data blocks crc
	if (blocks > 0) {
		crc = crc32(update_dat + 1036, blocks * 272, crc);
	}
	// Second the last block crc
	crc = crc32(update_dat + blocks * 272 + 1036, 2064, crc);
	// And last the xortable+blocks_count crc
	crc = crc32(update_dat + 8, 1028, crc);
	// The computed CRC32 must match the File CRC from the offset 4
	if (~crc != load_int(update_dat + 4, 4, MP_LITTLE_ENDIAN)) {
		fprintf(stderr, "%s file CRC error!\n", firmware);
		free(update_dat);
		return EXIT_FAILURE;
	}

	/*
   * Decrypting each data block (by deobfuscating the address)
   */

	size_t ptr = 1036; // This is the offset of the first data block

	// The updateII.dat contains a xor table of 1024 bytes length at the offset 8.
	// This table is used to obfuscate the block address.
	uint32_t xorptr;
	int i, j;
	for (i = 0; i < blocks; i++) {
		xorptr = load_int(
			update_dat + ptr + 4, 4,
			MP_LITTLE_ENDIAN); // Load the xor table pointer

		/*
     * The destination address of each data block (offset 8) is obfuscated
     * by xoring the LSB part of the address against a xortable 264 times (44*6)
     */
		for (j = 0; j < 44; j++) {
			update_dat[ptr + 8] ^= update_dat[(xorptr & 0x3FF) + 8];
			update_dat[ptr + 8] ^=
				update_dat[((xorptr + 1) & 0x3FF) + 8];
			update_dat[ptr + 8] ^=
				update_dat[((xorptr + 2) & 0x3FF) + 8];
			update_dat[ptr + 8] ^=
				update_dat[((xorptr + 3) & 0x3FF) + 8];
			update_dat[ptr + 8] ^=
				update_dat[((xorptr + 4) & 0x3FF) + 8];
			update_dat[ptr + 8] ^=
				update_dat[((xorptr + 5) & 0x3FF) + 8];
			xorptr += 6;
		}
		// After deobfuscating the address calculate the block crc and compare
		if (crc32(update_dat + ptr + 4, 268, 0) !=
		    load_int(update_dat + ptr, 4, MP_LITTLE_ENDIAN)) {
			fprintf(stderr, "%s file CRC error!\n", firmware);
			free(update_dat);
			return EXIT_FAILURE;
		}
		ptr += 272;
	}

	/*
   * The last data block destination address is obfuscated
   * by xoring the LSB part of the address against a xortable 2056 times (514*4)
   */
	xorptr = load_int(update_dat + ptr + 4, 4, MP_LITTLE_ENDIAN);
	for (i = 0; i < 514; i++) {
		update_dat[ptr + 8] ^= update_dat[(xorptr & 0x3FF) + 8];
		update_dat[ptr + 8] ^= update_dat[((xorptr + 1) & 0x3FF) + 8];
		update_dat[ptr + 8] ^= update_dat[((xorptr + 2) & 0x3FF) + 8];
		update_dat[ptr + 8] ^= update_dat[((xorptr + 3) & 0x3FF) + 8];
		xorptr += 4;
	}
	// After deobfuscating the address calculate the block crc and compare
	if (crc32(update_dat + ptr + 4, 2060, 0) !=
	    load_int(update_dat + ptr, 4, MP_LITTLE_ENDIAN)) {
		fprintf(stderr, "%s file CRC error!\n", firmware);
		free(update_dat);
		return EXIT_FAILURE;
	}

	fprintf(stderr, "%s contains firmware version %u.%u.%u", firmware,
		update_dat[1] >> 4, update_dat[1] & 0x0F, update_dat[0]);

	if ((handle->firmware & 0xFF) > update_dat[0])
		fprintf(stderr, " (older)");
	else if ((handle->firmware & 0xFF) < update_dat[0])
		fprintf(stderr, " (newer)");

	fprintf(stderr,
		"\n\nDo you want to continue with firmware update? y/n:");
	fflush(stderr);
	char c = getchar();
	if (c != 'Y' && c != 'y') {
		free(update_dat);
		fprintf(stderr, "Firmware update aborted.\n");
		return EXIT_FAILURE;
	}

	// Switching to boot mode if necessary
	if (handle->status == MP_STATUS_NORMAL) {
		fprintf(stderr, "Switching to bootloader... ");
		fflush(stderr);

		memset(msg, 0, sizeof(msg));
		msg[0] = TL866IIPLUS_SWITCH;
		format_int(&msg[4], TL866IIPLUS_BTLDR_MAGIC, 4,
			   MP_LITTLE_ENDIAN);
		if (msg_send(handle->usb_handle, msg, 8)) {
			free(update_dat);
			return EXIT_FAILURE;
		}
		if (minipro_reset(handle)) {
			fprintf(stderr, "failed!\n");
			free(update_dat);
			return EXIT_FAILURE;
		}
		handle = minipro_open(VERBOSE);
		if (!handle) {
			fprintf(stderr, "failed!\n");
			free(update_dat);
			return EXIT_FAILURE;
		}

		if (handle->status == MP_STATUS_NORMAL) {
			fprintf(stderr, "failed!\n");
			free(update_dat);
			return EXIT_FAILURE;
		}
		fprintf(stderr, "OK\n");
	}

	// Erase device
	fprintf(stderr, "Erasing... ");
	fflush(stderr);
	memset(msg, 0, sizeof(msg));
	msg[0] = TL866IIPLUS_BOOTLOADER_ERASE;
	if (msg_send(handle->usb_handle, msg, 8)) {
		fprintf(stderr, "\nErase failed!\n");
		free(update_dat);
		return EXIT_FAILURE;
	}
	memset(msg, 0, sizeof(msg));
	if (msg_recv(handle->usb_handle, msg, 8)) {
		fprintf(stderr, "\nErase failed!\n");
		free(update_dat);
		return EXIT_FAILURE;
	}
	if (msg[0] != TL866IIPLUS_BOOTLOADER_ERASE) {
		fprintf(stderr, "failed\n");
		free(update_dat);
		return EXIT_FAILURE;
	}

	// Reflash firmware
	fprintf(stderr, "OK\n");
	fprintf(stderr, "Reflashing... ");
	fflush(stderr);

	ptr = 1036; // First firmware block
	for (i = 0; i < blocks; i++) {
		msg[0] = TL866IIPLUS_BOOTLOADER_WRITE;
		msg[1] = update_dat[ptr + 12] & 0x7F; // Xor table index
		msg[2] = 0;			      // Data Length LSB
		msg[3] = 1; // Data length MSB (256 bytes)
		memcpy(&msg[4], &update_dat[ptr + 8], 4); // Destination address
		memcpy(&msg[8], &update_dat[ptr + 16], 256); // 256  bytes data

		// Send the command to the endpoint 1
		if (msg_send(handle->usb_handle, msg, 8)) {
			fprintf(stderr, "\nReflash failed\n");
			free(update_dat);
			return EXIT_FAILURE;
		}

		// And the payload to the endpoints 2 and 3
		if (write_payload(handle->usb_handle, msg + 8, 256)) {
			fprintf(stderr, "\nReflash failed\n");
			free(update_dat);
			return EXIT_FAILURE;
		}

		// Check if the firmware block was successfully written
		memset(msg, 0, sizeof(msg));
		msg[0] = TL866IIPLUS_REQUEST_STATUS;
		if (msg_send(handle->usb_handle, msg, 8)) {
			fprintf(stderr, "\nReflash... Failed\n");
			free(update_dat);
			return EXIT_FAILURE;
		}
		memset(msg, 0, sizeof(msg));
		if (msg_recv(handle->usb_handle, msg, 32)) {
			fprintf(stderr, "\nReflash... Failed\n");
			free(update_dat);
			return EXIT_FAILURE;
		}
		if (msg[1]) {
			fprintf(stderr, "\nReflash... Failed\n");
			free(update_dat);
			return EXIT_FAILURE;
		}
		ptr += 272;
		fprintf(stderr, "\r\e[KReflashing... %2d%%", i * 100 / blocks);
		fflush(stderr);
	}

	// Last firmware block
	uint8_t block[2056];

	block[0] = TL866IIPLUS_BOOTLOADER_WRITE;
	block[1] = update_dat[ptr + 12] | 0x80;
	block[2] = 0;
	block[3] = 8;
	memcpy(&block[4], &update_dat[ptr + 8], 4);
	memcpy(&block[8], &update_dat[ptr + 16], 2048);
	free(update_dat);

	// Send the command to the endpoint 1
	if (msg_send(handle->usb_handle, block, 8)) {
		fprintf(stderr, "\nReflash failed\n");
		return EXIT_FAILURE;
	}

	// And the payload to the endpoints 2 and 3
	if (write_payload(handle->usb_handle, block + 8, 2048)) {
		fprintf(stderr, "\nReflash failed\n");
		return EXIT_FAILURE;
	}

	// Check if the firmware block was successfully written
	memset(msg, 0, sizeof(msg));
	msg[0] = TL866IIPLUS_REQUEST_STATUS;
	if (msg_send(handle->usb_handle, msg, 8)) {
		fprintf(stderr, "\nReflash failed!\n");
		return EXIT_FAILURE;
	}
	memset(msg, 0, sizeof(msg));
	if (msg_recv(handle->usb_handle, msg, 32)) {
		fprintf(stderr, "\nReflash failed!\n");
		return EXIT_FAILURE;
	}
	if (msg[1]) {
		fprintf(stderr, "\nReflash... Failed\n");
		return EXIT_FAILURE;
	}
	fprintf(stderr, "\r\e[KReflashing... 100%%\n");

	// Switching back to normal mode
	fprintf(stderr, "Resetting device... ");
	fflush(stderr);
	if (minipro_reset(handle)) {
		fprintf(stderr, "failed!\n");
		return EXIT_FAILURE;
	}
	handle = minipro_open(VERBOSE);
	if (!handle) {
		fprintf(stderr, "failed!\n");
		return EXIT_FAILURE;
	}
	fprintf(stderr, "OK\n");
	if (handle->status != MP_STATUS_NORMAL) {
		fprintf(stderr, "Reflash... failed\n");
		return EXIT_FAILURE;
	}

	fprintf(stderr, "Reflash... OK\n");
	return EXIT_SUCCESS;
}

int tl866iiplus_pin_test(minipro_handle_t *handle)
{

	// for mapping the programmer pin numbers to the device pin numbers
	int p_pins = 40;
	int d_pins = handle->device->package_details.pin_count;
	int p_pin = 0;
	int d_pin = 0;
	int x_pin = d_pins/2;
	int pno = p_pins-d_pins;

	uint8_t msg[48], pins[p_pins];
	int i;
	db_data_t db_data;
	memset(&db_data, 0, sizeof(db_data));

	// Get the chip pin mask for testing
	db_data.infoic_path = handle->cmdopts->infoic_path;
	db_data.logicic_path = handle->cmdopts->logicic_path;
	db_data.index = handle->device->pin_map;
	pin_map_t *map = get_pin_map(&db_data);
	if (!map)
		return EXIT_FAILURE;

	// Set the desired output pins
	memset(msg, 0, sizeof(msg));
	msg[0] = TL866IIPLUS_SET_DIR;
	memset(&msg[8], 0x01, 40);
	if (map->gnd_count) {
		for (i = 0; i < (map->gnd_count); i++) {
			msg[map->gnd_table[i] + 7] = 0;
		}
	}

	int ret = EXIT_FAILURE;
	// Set the ZIF socket pins direction
	if (msg_send(handle->usb_handle, msg, sizeof(msg)))
		goto cleanup;

	// Set output pins to logic one
	msg[0] = TL866IIPLUS_SET_OUT;
	memset(&msg[8], 0x01, 40);
	if (msg_send(handle->usb_handle, msg, sizeof(msg)))
		goto cleanup;

	// Enable right side ZIF socket pull-up resistors
	msg[0] = TL866IIPLUS_SET_PULLUPS;
	memset(&msg[28], 0x00, 20);
	if (msg_send(handle->usb_handle, msg, sizeof(msg)))
		goto cleanup;

	// Enable left side ZIF socket pull-down resistors
	msg[0] = TL866IIPLUS_SET_PULLDOWNS;
	memset(&msg[8], 0x00, 20);
	memset(&msg[28], 0x01, 20);
	if (msg_send(handle->usb_handle, msg, sizeof(msg)))
		goto cleanup;

	// Read ZIF socket pins and save the left side pins status
	msg[0] = TL866IIPLUS_READ_PINS;
	if (msg_send(handle->usb_handle, msg, 8))
		goto cleanup;
	if (msg_recv(handle->usb_handle, msg, sizeof(msg)))
		goto cleanup;
	memcpy(pins, &msg[8], 20);

	// Enable left side ZIF socket pull-up resistors
	msg[0] = TL866IIPLUS_SET_PULLUPS;
	memset(&msg[8], 0x00, 20);
	memset(&msg[28], 0x01, 20);
	if (msg_send(handle->usb_handle, msg, sizeof(msg)))
		goto cleanup;

	// Enable right side ZIF socket pull-down resistors
	msg[0] = TL866IIPLUS_SET_PULLDOWNS;
	memset(&msg[8], 0x01, 20);
	memset(&msg[28], 0x00, 20);
	if (msg_send(handle->usb_handle, msg, sizeof(msg)))
		goto cleanup;

	// Read ZIF socket pins and save the right side pins status
	msg[0] = TL866IIPLUS_READ_PINS;
	if (msg_send(handle->usb_handle, msg, 8))
		goto cleanup;
	if (msg_recv(handle->usb_handle, msg, sizeof(msg)))
		goto cleanup;
	memcpy(&pins[20], &msg[28], 20);

	// Set output pins to logic zero
	msg[0] = TL866IIPLUS_SET_OUT;
	memset(&msg[8], 0x00, 40);
	if (msg_send(handle->usb_handle, msg, sizeof(msg)))
		goto cleanup;

	// Reset ZIF socket pins direction
	msg[0] = TL866IIPLUS_SET_DIR;
	memset(&msg[8], 0x01, 40);
	if (msg_send(handle->usb_handle, msg, sizeof(msg)))
		goto cleanup;

	// Reset pull-ups
	msg[0] = TL866IIPLUS_SET_PULLUPS;
	memset(&msg[8], 0x01, 40);
	if (msg_send(handle->usb_handle, msg, sizeof(msg)))
		goto cleanup;

	// Reset pull-downs
	msg[0] = TL866IIPLUS_SET_PULLDOWNS;
	memset(&msg[8], 0x00, 40);
	if (msg_send(handle->usb_handle, msg, sizeof(msg)))
		goto cleanup;

	// End of transaction
	msg[0] = TL866IIPLUS_END_TRANS;
	if (msg_send(handle->usb_handle, msg, sizeof(msg)))
		return EXIT_FAILURE;

	// Now check for bad pin contact
	ret = EXIT_SUCCESS;
	for (i = 0; i < map->mask_count; i++) {

		// map programmer pin# to device pin#
		p_pin = map->mask[i];
		d_pin = p_pin;
		if (p_pin > x_pin) d_pin = p_pin - pno;

		if (!pins[p_pin - 1]) {
			fprintf(stderr, "Bad contact on pin:%u\n",d_pin);
			ret = EXIT_FAILURE;
		}
	}
	if (!ret)
		fprintf(stderr, "Pin test passed.\n");

cleanup:
	free(map);
	return ret;
}

// Pull: 0=Pull-up, 1=Pull-down
static uint8_t *do_ic_test(minipro_handle_t *handle, int pull)
{
	uint8_t *vector = handle->device->vectors;
	uint8_t msg[32];
	uint8_t *result;
	uint8_t pin_count = handle->device->package_details.pin_count;

	result = calloc(pin_count, handle->device->vector_count);
	if (!result)
		return NULL;

	uint8_t *out = result;
	int n;
	for (n = 0; n < handle->device->vector_count; n++) {
		memset(msg, 0xff, sizeof(msg));

		msg[0] = TL866IIPLUS_LOGIC_IC_TEST_VECTOR;
		msg[1] = handle->device->voltages.vcc;
		msg[1] |= pull << 7; // Set the pull-up/pull-down
		format_int(&msg[2], pin_count, 2, MP_LITTLE_ENDIAN);
		format_int(&msg[4], n, 4, MP_LITTLE_ENDIAN);

		int i;
		//Pack the vector to 2 pin/byte
		for (i = 0; i < handle->device->package_details.pin_count;
		     i++) {
			if (i & 1)
				msg[8 + i / 2] |= *vector << 4;
			else
				msg[8 + i / 2] = *vector;
			vector++;
		}

		// Send the test vector and read the pin status
		if (msg_send(handle->usb_handle, msg, sizeof(msg))) {
			free(result);
			return NULL;
		}
		if (msg_recv(handle->usb_handle, msg, sizeof(msg))) {
			free(result);
			return NULL;
		}

		// Unpack the result from 2 pin/byte to 1 pin/byte
		for (i = 0; i < handle->device->package_details.pin_count; i++)
			*out++ = (msg[8 + i / 2] >> (4 * (i & 1))) & 0xf;
	}

	return result;
}

/* Performing a logic test. This is accomplished in two steps.
 * The first step will set a pull-up resistor on all chip outputs (L, H, Z).
 * The second step will set a pull-down resistor on all chip outputs.
 * According to the vector table then each output is compared against the two
 * result array. Considering the weak pull-up/pull-down resistors we can detect
 * L(low) state as 0 in both steps, H(high) state as 1 in both steps and
 * Z(high impedance) state as 1 in step 1 when the pull-up is activated and
 * 0 in step 2 when the pull-down is activated.
 * While for chips with open collector/open drain output we need to perform
 * these two steps to detect the Z state, for chips with totem-pole outputs this is
 * not really necessary but, sometimes internal issues can be detected this way
 * like burned H side or L side output transistors.
 * The C (clock) state is performed in firmware by first pulsing the pin marked as
 * C and then all pins are read back.
 * The X (don't care) state will leave the pin unconnected.
 * The V (VCC) and G (Ground) state will designate the power supply pins.
 */
int tl866iiplus_logic_ic_test(minipro_handle_t *handle)
{
	uint8_t *vector = handle->device->vectors;
	uint8_t *first_step = NULL;
	uint8_t *second_step = NULL;
	int ret = EXIT_FAILURE;

	if (!(first_step = do_ic_test(handle, 0))) { // Pull-up active
		fprintf(stderr,
			"Error running the first step of logic test.\n");
	} else if (!(second_step = do_ic_test(handle, 1))) { //Pull-down active
		fprintf(stderr,
			"Error running the second step of logic test.\n");
	} else {
		int errors = 0, err;
		static const char pst[] = "01LHCZXGV";
		size_t n = 0;

		printf("      ");
		for (int pin = 1;
		     pin <= handle->device->package_details.pin_count; pin++)
			printf("%-3d", pin);
		putchar('\n');

		for (int i = 0; i < handle->device->vector_count; i++) {
			printf("%04d: ", i);
			for (int pin = 0;
			     pin < handle->device->package_details.pin_count;
			     pin++) {
				err = 0;
				switch (vector[n]) {
				case LOGIC_L: // Pin must be 0 in both steps
					if (first_step[n] || second_step[n])
						err = 1;
					break;
				case LOGIC_H: // Pin must be 1 in both steps
					if (!first_step[n] || !second_step[n])
						err = 1;
					break;
				case LOGIC_Z: // Pin must be 1 in step 1 and 0 in step 2
					if (!first_step[n] || second_step[n])
						err = 1;
					break;
				}
				printf("%s%c%c ", err ? "\e[0;91m" : "\e[0m",
				       pst[vector[n]], err ? '-' : ' ');
				errors += err;
				n++;
			}
			printf("\e[0m\n");
		}

		if (errors) {
			fprintf(stderr,
				"Logic test failed: %d errors encountered.\n",
				errors);
		} else {
			fprintf(stderr, "Logic test successful.\n");
			ret = EXIT_SUCCESS;
		}
	}

	free(second_step);
	free(first_step);
	if (tl866iiplus_end_transaction(handle))
		return EXIT_FAILURE;

	return ret;
}

static int init_zif(minipro_handle_t *handle, uint8_t pullup)
{
	uint8_t msg[48];
	// Reset pin drivers state
	msg[0] = TL866IIPLUS_RESET_PIN_DRIVERS;
	if (msg_send(handle->usb_handle, msg, 8)) {
		return EXIT_FAILURE;
	}

	// Set all zif pins to input
	memset(&msg[8], 0x01, 40);
	msg[0] = TL866IIPLUS_SET_DIR;
	if (msg_send(handle->usb_handle, msg, sizeof(msg))) {
		return EXIT_FAILURE;
	}

	// Set pull-up resistors (0=enable, 1=disable)
	memset(&msg[8], pullup, 40);
	msg[0] = TL866IIPLUS_SET_PULLUPS;
	return msg_send(handle->usb_handle, msg, sizeof(msg));
}

// TL866II+ hardware check
int tl866iiplus_hardware_check(minipro_handle_t *handle)
{
	uint8_t msg[48], read_buffer[48];
	int i, errors = 0;

	memset(msg, 0, sizeof(msg));

	// Testing 21 VPP pin drivers

	// Init ZIF socket, no pull-up resistors
	if (init_zif(handle, 1))
		return EXIT_FAILURE;

	for (i = 0; i < 21; i++) {
		memset(&msg[8], 0, 40);
		msg[0] = TL866IIPLUS_SET_VPP_PIN;
		msg[vpp_pins[i].byte] = vpp_pins[i].mask; // set the vpp pin

		if (msg_send(handle->usb_handle, msg, sizeof(msg))) {
			minipro_close(handle);
			return EXIT_FAILURE;
		}
		usleep(5000);
		msg[0] = TL866IIPLUS_READ_PINS;
		if (msg_send(handle->usb_handle, msg, 8)) {
			return EXIT_FAILURE;
		}
		if (msg_recv(handle->usb_handle, read_buffer,
			     sizeof(read_buffer)))
			return EXIT_FAILURE;
		if (read_buffer[1]) {
			msg[0] = TL866IIPLUS_RESET_PIN_DRIVERS;
			if (msg_send(handle->usb_handle, msg, 8)) {
				return EXIT_FAILURE;
			}
			fprintf(stderr,
				"Overcurrent protection detected while testing VPP pin driver "
				"%u!\007\n",
				vpp_pins[i].pin);
			return EXIT_FAILURE;
		}
		if (!read_buffer[7 + vpp_pins[i].pin])
			errors++;
		fprintf(stderr, "VPP driver pin %u is %s\n", vpp_pins[i].pin,
			read_buffer[7 + vpp_pins[i].pin] ? "OK" : "Bad");
	}
	fprintf(stderr, "\n");

	// Testing 32 VCC pin drivers

	// Init ZIF socket, no pull-up resistors
	if (init_zif(handle, 1))
		return EXIT_FAILURE;

	for (i = 0; i < 32; i++) {
		memset(&msg[8], 0, 40);
		msg[0] = TL866IIPLUS_SET_VCC_PIN;
		msg[vcc_pins[i].byte] = vcc_pins[i].mask; // set the vcc pin

		if (msg_send(handle->usb_handle, msg, sizeof(msg))) {
			minipro_close(handle);
			return EXIT_FAILURE;
		}
		usleep(5000);
		msg[0] = TL866IIPLUS_READ_PINS;
		if (msg_send(handle->usb_handle, msg, 8)) {
			return EXIT_FAILURE;
		}
		if (msg_recv(handle->usb_handle, read_buffer,
			     sizeof(read_buffer)))
			return EXIT_FAILURE;
		if (read_buffer[1]) {
			msg[0] = TL866IIPLUS_RESET_PIN_DRIVERS;
			if (msg_send(handle->usb_handle, msg, 8)) {
				return EXIT_FAILURE;
			}
			fprintf(stderr,
				"Overcurrent protection detected while testing VCC pin driver "
				"%u!\007\n",
				vcc_pins[i].pin);
			return EXIT_FAILURE;
		}
		if (!read_buffer[7 + vcc_pins[i].pin])
			errors++;
		fprintf(stderr, "VCC driver pin %u is %s\n", vcc_pins[i].pin,
			read_buffer[7 + vcc_pins[i].pin] ? "OK" : "Bad");
	}
	fprintf(stderr, "\n");

	// Testing 34 GND pin drivers

	// Init ZIF socket, active pull-up resistors
	if (init_zif(handle, 0))
		return EXIT_FAILURE;

	for (i = 0; i < 34; i++) {
		memset(&msg[8], 0, 40);
		msg[0] = TL866IIPLUS_SET_GND_PIN;
		msg[gnd_pins[i].byte] = gnd_pins[i].mask; // set the gnd pin

		if (msg_send(handle->usb_handle, msg, sizeof(msg))) {
			minipro_close(handle);
			return EXIT_FAILURE;
		}
		usleep(5000);
		msg[0] = TL866IIPLUS_READ_PINS;
		if (msg_send(handle->usb_handle, msg, 8)) {
			return EXIT_FAILURE;
		}
		if (msg_recv(handle->usb_handle, read_buffer,
			     sizeof(read_buffer)))
			return EXIT_FAILURE;
		if (read_buffer[1]) {
			msg[0] = TL866IIPLUS_RESET_PIN_DRIVERS;
			if (msg_send(handle->usb_handle, msg, 8)) {
				return EXIT_FAILURE;
			}
			fprintf(stderr,
				"Overcurrent protection detected while testing GND pin driver "
				"%u!\007\n",
				gnd_pins[i].pin);
			return EXIT_FAILURE;
		}
		if (read_buffer[7 + gnd_pins[i].pin])
			errors++;
		fprintf(stderr, "GND driver pin %u is %s\n", gnd_pins[i].pin,
			read_buffer[7 + gnd_pins[i].pin] ? "Bad" : "OK");
	}
	fprintf(stderr, "\n\n");

	// Testing VPP overcurrent protection

	// Init ZIF socket, no pull-up resistors
	if (init_zif(handle, 1))
		return EXIT_FAILURE;

	// Set VPP on pin1
	memset(&msg[8], 0, 40);
	msg[0] = TL866IIPLUS_SET_VPP_PIN;
	msg[vpp_pins[VPP1].byte] = vpp_pins[VPP1].mask;
	if (msg_send(handle->usb_handle, msg, sizeof(msg))) {
		return EXIT_FAILURE;
	}
	// Set GND also on pin1
	memset(&msg[8], 0, 40);
	msg[0] = TL866IIPLUS_SET_GND_PIN;
	msg[gnd_pins[GND1].byte] = gnd_pins[GND1].mask;
	if (msg_send(handle->usb_handle, msg, sizeof(msg))) {
		return EXIT_FAILURE;
	}
	// Reset pins
	memset(&msg[8], 0, 40);
	msg[0] = TL866IIPLUS_SET_GND_PIN;
	if (msg_send(handle->usb_handle, msg, sizeof(msg))) {
		return EXIT_FAILURE;
	}

	msg[0] =
		TL866IIPLUS_READ_PINS; // Read back the OVC status (should be active)
	if (msg_send(handle->usb_handle, msg, 8)) {
		return EXIT_FAILURE;
	}
	if (msg_recv(handle->usb_handle, read_buffer, sizeof(read_buffer))) {
		return EXIT_FAILURE;
	}
	if (read_buffer[1]) {
		fprintf(stderr, "VPP overcurrent protection is OK.\n");
	} else {
		fprintf(stderr, "VPP overcurrent protection failed!\007\n");
		errors++;
	}

	// Testing VCC overcurrent protection

	// Init ZIF socket, no pull-up resistors
	if (init_zif(handle, 1))
		return EXIT_FAILURE;

	// Set VCC voltage to 4.5V
	memset(&msg[8], 0, 40);
	msg[0] = TL866IIPLUS_SET_VCC_VOLTAGE;
	msg[8] = 0x01;
	if (msg_send(handle->usb_handle, msg, sizeof(msg))) {
		return EXIT_FAILURE;
	}

	// Set VCC on pin1
	memset(&msg[8], 0, 40);
	msg[0] = TL866IIPLUS_SET_VCC_PIN;
	msg[vcc_pins[VCC1].byte] = vcc_pins[VCC1].mask;
	if (msg_send(handle->usb_handle, msg, sizeof(msg))) {
		return EXIT_FAILURE;
	}
	// Set GND also on pin1
	memset(&msg[8], 0, 40);
	msg[0] = TL866IIPLUS_SET_GND_PIN;
	msg[gnd_pins[GND1].byte] = gnd_pins[GND1].mask;
	if (msg_send(handle->usb_handle, msg, sizeof(msg))) {
		return EXIT_FAILURE;
	}
	// Reset pins
	memset(&msg[8], 0, 40);
	msg[0] = TL866IIPLUS_SET_GND_PIN;
	if (msg_send(handle->usb_handle, msg, sizeof(msg))) {
		return EXIT_FAILURE;
	}

	msg[0] =
		TL866IIPLUS_READ_PINS; // Read back the OVC status (should be active)
	if (msg_send(handle->usb_handle, msg, 8)) {
		return EXIT_FAILURE;
	}
	if (msg_recv(handle->usb_handle, read_buffer, sizeof(read_buffer))) {
		return EXIT_FAILURE;
	}
	if (read_buffer[1]) {
		fprintf(stderr, "VCC overcurrent protection is OK.\n");
	} else {
		fprintf(stderr, "VCC overcurrent protection failed!\007\n");
		errors++;
	}

	if (errors)
		fprintf(stderr,
			"\nHardware test completed with %u error(s).\007\n",
			errors);
	else
		fprintf(stderr, "\nHardware test completed successfully!\n");

	// Reset pin drivers
	msg[0] = TL866IIPLUS_RESET_PIN_DRIVERS;
	return msg_send(handle->usb_handle, msg, 8);
}

//// Bit banging functions
static void set_pin(zif_pins_t *pins, uint8_t size, uint8_t *out, uint8_t pin)
{
	int i;
	for (i = 0; i < size; i++) {
		if (pins[i].pin == pin) {
			out[pins[i].byte] |= pins[i].mask;
		}
	}
}

int tl866iiplus_reset_state(minipro_handle_t *handle)
{
	uint8_t msg[8];
	// Reset pin drivers state
	msg[0] = TL866IIPLUS_RESET_PIN_DRIVERS;
	return msg_send(handle->usb_handle, msg, sizeof(msg));
}

int tl866iiplus_set_zif_direction(minipro_handle_t *handle, uint8_t *zif)
{
	uint8_t msg[48];
	memset(msg, 0, sizeof(msg));
	int i;
	for (i = 0; i < 40; i++) {
		msg[i + 8] = zif[i] & 0x7f;
	}
	msg[0] = TL866IIPLUS_SET_DIR;
	if (msg_send(handle->usb_handle, msg, sizeof(msg)))
		return EXIT_FAILURE;
	for (i = 0; i < 40; i++) {
		msg[8 + i] = zif[i] & 0x80 ? 0x00 : 0x01;
	}
	msg[0] = TL866IIPLUS_SET_PULLUPS;
	return msg_send(handle->usb_handle, msg, sizeof(msg));
}

int tl866iiplus_set_zif_state(minipro_handle_t *handle, uint8_t *zif)
{
	uint8_t msg[48];
	memset(msg, 0, sizeof(msg));
	memcpy(&msg[8], zif, 40);
	msg[0] = TL866IIPLUS_SET_OUT;
	return msg_send(handle->usb_handle, msg, sizeof(msg));
}

int tl866iiplus_get_zif_state(minipro_handle_t *handle, uint8_t *zif)
{
	uint8_t msg[48];
	memset(msg, 0, sizeof(msg));
	msg[0] = TL866IIPLUS_READ_PINS;
	if (msg_send(handle->usb_handle, msg, 8))
		return EXIT_FAILURE;
	if (msg_recv(handle->usb_handle, msg, sizeof(msg)))
		return EXIT_FAILURE;
	memcpy(zif, &msg[8], 40);
	return EXIT_SUCCESS;
}

int tl866iiplus_set_pin_drivers(minipro_handle_t *handle, pin_driver_t *pins)
{
	uint8_t msg[48];
	int i;

	// Set GND pins
	memset(msg, 0x00, sizeof(msg));
	msg[0] = TL866IIPLUS_SET_GND_PIN;
	for (i = 0; i < 40; i++) {
		if (pins[i].gnd) {
			set_pin(gnd_pins,
				sizeof(gnd_pins) / sizeof(gnd_pins[0]), msg,
				i + 1);
		}
	}
	if (msg_send(handle->usb_handle, msg, sizeof(msg))) {
		return EXIT_FAILURE;
	}

	// Set VCC pins
	memset(msg, 0x00, sizeof(msg));
	msg[0] = TL866IIPLUS_SET_VCC_PIN;
	for (i = 0; i < 40; i++) {
		if (pins[i].vcc) {
			set_pin(vcc_pins,
				sizeof(vcc_pins) / sizeof(vcc_pins[0]), msg,
				i + 1);
		}
	}
	if (msg_send(handle->usb_handle, msg, sizeof(msg))) {
		return EXIT_FAILURE;
	}

	// Set VPP pins
	memset(msg, 0x00, sizeof(msg));
	msg[0] = TL866IIPLUS_SET_VPP_PIN;
	for (i = 0; i < 40; i++) {
		if (pins[i].vpp) {
			set_pin(vpp_pins,
				sizeof(vpp_pins) / sizeof(vpp_pins[0]), msg,
				i + 1);
		}
	}
	return msg_send(handle->usb_handle, msg, sizeof(msg));
}

/*
  VPP[0..15]
  9.0,  9.5, 10.0, 11.0, 11.5, 12.0, 12.5, 13.0,
  13.5, 14.0, 14.5, 15.5, 16.0, 16.5, 17.0, 18.0

  VCC[0..15]
  1.9, 2.7, 3.0, 3.3, 3.6, 3.9, 4.1, 4.5,
  4.8, 5.0, 5.3, 5.5, 6.0, 6.3, 6.5, 7.0
 */

int tl866iiplus_set_voltages(minipro_handle_t *handle, uint8_t vcc, uint8_t vpp)
{
	uint8_t msg[48];
	memset(&msg, 0, sizeof(msg));

	// Internal VCC table firmware map
	static const uint8_t vcc_t[] = { 0, 1, 2,  4,  3,  5,  6,  8,
					 7, 9, 10, 12, 11, 13, 14, 15 };

	// Internal VPP table firmware map
	static const uint8_t vpp_t[] = { 0,  8,	 1, 9,	2, 10, 3, 4,
					 11, 12, 5, 13, 6, 14, 7, 15 };
	msg[0] = TL866IIPLUS_SET_VCC_VOLTAGE;
	msg[8] = (vcc_t[vcc] & 0x01);
	msg[9] = ((vcc_t[vcc] >> 1) & 0x01);
	msg[10] = (vcc_t[vcc] >> 2) & 0x01;
	msg[11] = (vcc_t[vcc] << 4) & 0x80;
	if (msg_send(handle->usb_handle, msg, sizeof(msg))) {
		return EXIT_FAILURE;
	}
	msg[0] = TL866IIPLUS_SET_VPP_VOLTAGE;
	msg[8] = (vpp_t[vpp] & 0x01);
	msg[9] = ((vpp_t[vpp] >> 1) & 0x01);
	msg[10] = (vpp_t[vpp] >> 2) & 0x01;
	msg[11] = (vpp_t[vpp] << 4) & 0x80;
	return msg_send(handle->usb_handle, msg, sizeof(msg));
}
