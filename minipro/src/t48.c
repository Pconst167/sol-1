/*
 * t48.c - Low level ops for T48
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
#include <math.h>

#include "database.h"
#include "minipro.h"
#include "t48.h"
#include "bitbang.h"
#include "usb.h"

#define T48_NAND_INIT		 0x02
#define T48_BEGIN_TRANS		 0x03
#define T48_END_TRANS		 0x04
#define T48_READID		 0x05
#define T48_READ_USER		 0x06
#define T48_WRITE_USER		 0x07
#define T48_READ_CFG		 0x08
#define T48_WRITE_CFG		 0x09
#define T48_WRITE_USER_DATA	 0x0A
#define T48_READ_USER_DATA	 0x0B
#define T48_WRITE_CODE		 0x0C
#define T48_READ_CODE		 0x0D
#define T48_ERASE		 0x0E
#define T48_READ_DATA		 0x10
#define T48_WRITE_DATA		 0x11
#define T48_WRITE_LOCK		 0x14
#define T48_READ_LOCK		 0x15
#define T48_READ_CALIBRATION	 0x16
#define T48_PROTECT_OFF		 0x18
#define T48_PROTECT_ON		 0x19
#define T48_READ_JEDEC		 0x1D
#define T48_WRITE_JEDEC		 0x1E
#define T48_LOGIC_IC_TEST_VECTOR 0x28
#define T48_AUTODETECT		 0x37
#define T48_UNLOCK_TSOP48	 0x38
#define T48_REQUEST_STATUS	 0x39

#define T48_BOOTLOADER_WRITE	 0x3B
#define T48_BOOTLOADER_ERASE	 0x3C
#define T48_SWITCH		 0x3D
#define T48_RESET		 0x3F

/* Hardware Bit Banging */
#define T48_SET_VCC_VOLTAGE	 0x1B
#define T48_SET_VPP_VOLTAGE	 0x1C
#define T48_RESET_PIN_DRIVERS	 0x2D
#define T48_SET_VCC_PIN		 0x2E
#define T48_SET_VPP_PIN		 0x2F
#define T48_SET_GND_PIN		 0x30
#define T48_SET_PULLUPS		 0x31
#define T48_SET_PULLDOWNS	 0x32
#define T48_MEASURE_VOLTAGES	 0x33
#define T48_READ_PINS		 0x35
#define T48_SET_OUT		 0x36

/* Firmware */
#define T48_UPDATE_FILE_VERS_MASK 0xffff0000
#define T48_FIRMWARE_VERS_MASK 0x0000ffff
#define T48_UPDATE_FILE_VERSION 0xf0480000
#define T48_BTLDR_MAGIC  0xCDEF89AB45670123


/* #define DEBUG_USB_MSG */
typedef struct zif_pins_s {
	uint8_t pin;
	uint8_t byte;
	uint8_t mask;
} zif_pins_t;

/* clang-format off */
/* 17 VPP pins. */
static zif_pins_t vpp_pins[] =
{
	{ .pin = 31, .byte = 8, .mask = 0x01 },
	{ .pin = 30, .byte = 8, .mask = 0x02 },
	{ .pin = 10, .byte = 8, .mask = 0x04 },
	{ .pin =  9, .byte = 8, .mask = 0x08 },
	{ .pin =  4, .byte = 8, .mask = 0x10 },
	{ .pin =  3, .byte = 8, .mask = 0x20 },
	{ .pin =  2, .byte = 8, .mask = 0x40 },
	{ .pin =  1, .byte = 8, .mask = 0x80 },

	{ .pin = 32, .byte = 9, .mask = 0x01 },
	{ .pin = 33, .byte = 9, .mask = 0x02 },
	{ .pin = 34, .byte = 9, .mask = 0x04 },
	{ .pin = 36, .byte = 9, .mask = 0x08 },
	{ .pin = 37, .byte = 9, .mask = 0x10 },
	{ .pin = 38, .byte = 9, .mask = 0x20 },
	{ .pin = 39, .byte = 9, .mask = 0x40 },
	{ .pin = 40, .byte = 9, .mask = 0x80 },

        /* J1 */

	{ .pin = 41, .byte = 12, .mask = 0x01 }
};

/* 34 VCC Pins. */
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
	{ .pin = 9, .byte = 9, .mask = 0x80 },
	{ .pin = 10, .byte = 9, .mask = 0x40 },
	{ .pin = 11, .byte = 9, .mask = 0x20 },
	{ .pin = 12, .byte = 9, .mask = 0x10 },
	{ .pin = 13, .byte = 9, .mask = 0x08 },
	{ .pin = 14, .byte = 9, .mask = 0x04 },
	{ .pin = 15, .byte = 9, .mask = 0x02 },
	{ .pin = 16, .byte = 9, .mask = 0x01 },

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

        /* J13 */
	{ .pin = 53, .byte = 16, .mask = 0x01 },
        /* J14 */
	{ .pin = 54, .byte = 16, .mask = 0x02 }
};

/* 35 GND Pins. */
static zif_pins_t gnd_pins[] =
{
	{ .pin = 1, .byte = 8, .mask = 0x80 },
	{ .pin = 2, .byte = 8, .mask = 0x40 },
	{ .pin = 3, .byte = 8, .mask = 0x20 },
	{ .pin = 4, .byte = 8, .mask = 0x10 },
	{ .pin = 5, .byte = 8, .mask = 0x08 },
	{ .pin = 6, .byte = 8, .mask = 0x04 },
	{ .pin = 7, .byte = 8, .mask = 0x02 },
	{ .pin = 8, .byte = 8, .mask = 0x01 },
	{ .pin = 9, .byte = 9, .mask = 0x80 },
	{ .pin = 10, .byte = 9, .mask = 0x40 },
	{ .pin = 11, .byte = 9, .mask = 0x20 },
	{ .pin = 12, .byte = 9, .mask = 0x10 },
	{ .pin = 13, .byte = 9, .mask = 0x08 },
	{ .pin = 14, .byte = 9, .mask = 0x04 },
	{ .pin = 15, .byte = 9, .mask = 0x02 },
	{ .pin = 16, .byte = 9, .mask = 0x01 },
	{ .pin = 18, .byte = 10, .mask = 0x80 },
	{ .pin = 20, .byte = 10, .mask = 0x40 },

	{ .pin = 25, .byte = 10, .mask = 0x20 },
	{ .pin = 27, .byte = 10, .mask = 0x10 },
	{ .pin = 29, .byte = 10, .mask = 0x08 },
	{ .pin = 30, .byte = 10, .mask = 0x04 },
	{ .pin = 31, .byte = 10, .mask = 0x02 },
	{ .pin = 32, .byte = 10, .mask = 0x01 },
	{ .pin = 33, .byte = 11, .mask = 0x80 },
	{ .pin = 34, .byte = 11, .mask = 0x40 },
	{ .pin = 35, .byte = 11, .mask = 0x20 },
	{ .pin = 36, .byte = 11, .mask = 0x10 },
	{ .pin = 37, .byte = 11, .mask = 0x08 },
	{ .pin = 38, .byte = 11, .mask = 0x04 },
	{ .pin = 39, .byte = 11, .mask = 0x02 },
	{ .pin = 40, .byte = 11, .mask = 0x01 },

        /* J6 */
	{ .pin = 46, .byte = 16, .mask = 0x01 },
        /* J8 */
	{ .pin = 48, .byte = 16, .mask = 0x02 },
        /* J16 */
	{ .pin = 56, .byte = 16, .mask = 0x04 }
};
/* Indices to pin 1 for OVC tests */
#define VPP1	7
#define VCC1	0
#define GND1	0

/* 56 io pins. */

#ifdef DEBUG_USB_MSG
static void print_msg(uint8_t *buffer, size_t size)
{
	for (size_t i = 0; i < size; i++) {
		printf("%.2x ", buffer[i]);
		if (i % 16 == 15)
			printf("\n");
	}
	printf("---\n");
}

static int wrap_msg_recv(void *handle, uint8_t *buffer, size_t size)
{
	printf("%s\n", __func__);
	int status = msg_recv(handle, buffer, size);
	print_msg(buffer, size);
	return status;
}

static int wrap_msg_send(void *handle, uint8_t *buffer, size_t size)
{
	printf("%s\n", __func__);
	print_msg(buffer, size);
	return msg_send(handle, buffer, size);
}

#define msg_send wrap_msg_send
#define msg_recv wrap_msg_recv
#endif

/* clang-format on */
int t48_begin_transaction(minipro_handle_t *handle)
{
	uint8_t msg[64];
	uint8_t ovc;
	device_t *device = handle->device;

	memset(msg, 0x00, sizeof(msg));
	if (!handle->device->flags.custom_protocol) {
		msg[0] = T48_BEGIN_TRANS;
		msg[1] = device->protocol_id;
		msg[2] = (uint8_t)handle->device->variant;
		msg[3] = handle->cmdopts->icsp;

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
	if (t48_get_ovc_status(handle, NULL, &ovc))
		return EXIT_FAILURE;
	if (ovc) {
		fprintf(stderr, "Overcurrent protection!\007\n");
		return EXIT_FAILURE;
	}
	return EXIT_SUCCESS;
}

int t48_end_transaction(minipro_handle_t *handle)
{
	if (handle->device->flags.custom_protocol) {
		return bb_end_transaction(handle);
	}
	uint8_t msg[8];
	memset(msg, 0x00, sizeof(msg));
	msg[0] = T48_END_TRANS;
	return msg_send(handle->usb_handle, msg, sizeof(msg));
	return EXIT_SUCCESS;
}

int t48_read_block(minipro_handle_t *handle, uint8_t type,
			   uint32_t addr, uint8_t *buf, size_t len)
{
	if (handle->device->flags.custom_protocol) {
		return bb_read_block(handle, type, addr, buf, len);
	}
	uint8_t msg[64];

	if (type == MP_CODE) {
		type = T48_READ_CODE;
	} else if (type == MP_DATA) {
		type = T48_READ_DATA;
	} else if (type == MP_USER) {
		type = T48_READ_USER_DATA;
	} else {
		fprintf(stderr, "Unknown type for read_block (%d)\n", type);
		return EXIT_FAILURE;
	}

	memset(msg, 0x00, sizeof(msg));
	msg[0] = type;
	/* msg[1] = 1; */
	format_int(&(msg[2]), len, 2, MP_LITTLE_ENDIAN);
	format_int(&(msg[4]), addr, 4, MP_LITTLE_ENDIAN);
	if (msg_send(handle->usb_handle, msg, 8))
		return EXIT_FAILURE;

	return read_payload2(handle->usb_handle, buf, len, 0);
}

int t48_write_block(minipro_handle_t *handle, uint8_t type,
			    uint32_t addr, uint8_t *buf, size_t len)
{
	if (handle->device->flags.custom_protocol) {
		return bb_write_block(handle, type, addr, buf, len);
	}
	uint8_t msg[64];

	if (type == MP_CODE) {
		type = T48_WRITE_CODE;
	} else if (type == MP_DATA) {
		type = T48_WRITE_DATA;
	} else if (type == MP_USER) {
		type = T48_WRITE_USER_DATA;
	} else {
		fprintf(stderr, "Unknown type for write_block (%d)\n", type);
		return EXIT_FAILURE;
	}

	memset(msg, 0x00, sizeof(msg));
	msg[0] = type;
	format_int(&(msg[2]), len, 2, MP_LITTLE_ENDIAN);
	format_int(&(msg[4]), addr, 4, MP_LITTLE_ENDIAN);
	if (msg_send(handle->usb_handle, msg, 8))
		return EXIT_FAILURE;
	if (write_payload2(handle->usb_handle, buf,
				handle->device->write_buffer_size, 0))
		return EXIT_FAILURE; /* And payload to the endp.2 */
	return EXIT_SUCCESS;
}

int t48_read_fuses(minipro_handle_t *handle, uint8_t type,
			   size_t length, uint8_t items_count, uint8_t *buffer)
{
	if (handle->device->flags.custom_protocol) {
		return bb_read_fuses(handle, type, length, items_count, buffer);
	}
	uint8_t msg[64];

	if (type == MP_FUSE_USER) {
		type = T48_READ_USER;
	} else if (type == MP_FUSE_CFG) {
		type = T48_READ_CFG;
	} else if (type == MP_FUSE_LOCK) {
		type = T48_READ_LOCK;
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

int t48_write_fuses(minipro_handle_t *handle, uint8_t type,
			    size_t length, uint8_t items_count, uint8_t *buffer)
{
	if (handle->device->flags.custom_protocol) {
		return bb_write_fuses(handle, type, length, items_count,
				      buffer);
	}
	uint8_t msg[64];

	if (type == MP_FUSE_USER) {
		type = T48_WRITE_USER;
	} else if (type == MP_FUSE_CFG) {
		type = T48_WRITE_CFG;
	} else if (type == MP_FUSE_LOCK) {
		type = T48_WRITE_LOCK;
	} else {
		fprintf(stderr, "Unknown type for write_fuses (%d)\n", type);
	}

	memset(msg, 0, sizeof(msg));
	msg[0] = type;
	if (buffer) {
		msg[1] = handle->device->protocol_id;
		msg[2] = items_count;
		format_int(&msg[4], handle->device->code_memory_size - 0x38, 4,
			   MP_LITTLE_ENDIAN); /* 0x38, firmware bug? */
		memcpy(&(msg[8]), buffer, length);
	}
	return msg_send(handle->usb_handle, msg, sizeof(msg));
}

int t48_get_chip_id(minipro_handle_t *handle, uint8_t *type,
			    uint32_t *device_id)
{
	if (handle->device->flags.custom_protocol) {
		return bb_get_chip_id(handle, device_id);
	}
	uint8_t msg[32], format, id_length;
	memset(msg, 0x00, sizeof(msg));
	msg[0] = T48_READID;
	if (msg_send(handle->usb_handle, msg, 8))
		return EXIT_FAILURE;
	if (msg_recv(handle->usb_handle, msg, sizeof(msg)))
		return EXIT_FAILURE;
	*type = msg[0]; /* The Chip ID type (1-5) */
	format = (*type == MP_ID_TYPE3 || *type == MP_ID_TYPE4 ?
			  MP_LITTLE_ENDIAN :
			  MP_BIG_ENDIAN);

	/* The length byte is always 1-4 but never know,
	 * truncate to max. 4 bytes. */
	id_length = handle->device->chip_id_bytes_count > 4 ?
			    4 :
			    handle->device->chip_id_bytes_count;
	*device_id = (id_length ? load_int(&(msg[2]), id_length, format) :
				  0); /* Check for positive length. */
	return EXIT_SUCCESS;
}

int t48_spi_autodetect(minipro_handle_t *handle, uint8_t type,
			       uint32_t *device_id)
{
	if (handle->device != NULL && handle->device->flags.custom_protocol) {
		return bb_spi_autodetect(handle, type, device_id);
	}
	uint8_t msg[64];
	memset(msg, 0, sizeof(msg));
	msg[0] = T48_AUTODETECT;
	msg[8] = type;
	if (msg_send(handle->usb_handle, msg, 10))
		return EXIT_FAILURE;
	if (msg_recv(handle->usb_handle, msg, 32))
		return EXIT_FAILURE;
	*device_id = load_int(&(msg[2]), 3, MP_BIG_ENDIAN);
	return EXIT_SUCCESS;
}

int t48_erase(minipro_handle_t *handle)
{
	if (handle->device->flags.custom_protocol) {
		return bb_erase(handle);
	}
	uint8_t msg[64];
	memset(msg, 0, sizeof(msg));
	msg[0] = T48_ERASE;

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

int t48_protect_off(minipro_handle_t *handle)
{
	uint8_t msg[8];
	memset(msg, 0, sizeof(msg));
	msg[0] = T48_PROTECT_OFF;
	return msg_send(handle->usb_handle, msg, sizeof(msg));
}

int t48_protect_on(minipro_handle_t *handle)
{
	uint8_t msg[8];
	memset(msg, 0, sizeof(msg));
	msg[0] = T48_PROTECT_ON;
	return msg_send(handle->usb_handle, msg, sizeof(msg));
}

int t48_get_ovc_status(minipro_handle_t *handle,
			       minipro_status_t *status, uint8_t *ovc)
{
	uint8_t msg[32];
	memset(msg, 0, sizeof(msg));
	msg[0] = T48_REQUEST_STATUS;
	if (msg_send(handle->usb_handle, msg, 8))
		return EXIT_FAILURE;
	if (msg_recv(handle->usb_handle, msg, sizeof(msg)))
		return EXIT_FAILURE;
	if (status && !handle->device->flags.custom_protocol) {
		/* This is verify while writing feature. */
		status->error = msg[0];
		status->address = load_int(&msg[8], 4, MP_LITTLE_ENDIAN);
		status->c1 = load_int(&msg[2], 2, MP_LITTLE_ENDIAN);
		status->c2 = load_int(&msg[4], 2, MP_LITTLE_ENDIAN);
	}
	*ovc = msg[12]; /* return the ovc status */
	return EXIT_SUCCESS;
}

int t48_write_jedec_row(minipro_handle_t *handle, uint8_t *buffer,
				uint8_t row, uint8_t flags, size_t size)
{
	/* Warning: Using JEDEC algorithm for TL866ii+. Results in T48 may be unexpected */
	if (handle->device->flags.custom_protocol) {
		return bb_write_jedec_row(handle, buffer, row, flags, size);
	}
	uint8_t msg[64];
	memset(msg, 0, sizeof(msg));
	msg[0] = T48_WRITE_JEDEC;
	msg[1] = handle->device->protocol_id;
	msg[2] = size;
	msg[4] = row;
	msg[5] = flags;
	memcpy(&msg[8], buffer, (size + 7) / 8);
	return msg_send(handle->usb_handle, msg, 64);
}

int t48_read_jedec_row(minipro_handle_t *handle, uint8_t *buffer,
			       uint8_t row, uint8_t flags, size_t size)
{
	/* Warning: Using JEDEC algorithm for TL866ii+. Results in T48 may be unexpected */
	if (handle->device->flags.custom_protocol) {
		return bb_read_jedec_row(handle, buffer, row, flags, size);
	}
	uint8_t msg[32];
	memset(msg, 0, sizeof(msg));
	msg[0] = T48_READ_JEDEC;
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

/* Pull: 0=Pull-up, 1=Pull-down */
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

		msg[0] = T48_LOGIC_IC_TEST_VECTOR;
		msg[1] = handle->device->voltages.vcc;
		msg[1] |= pull << 7; /* Set the pull-up/pull-down */
		format_int(&msg[2], pin_count, 2, MP_LITTLE_ENDIAN);
		format_int(&msg[4], n, 4, MP_LITTLE_ENDIAN);

		int i;
		/* Pack the vector to 2 pin/byte */
		for (i = 0; i < handle->device->package_details.pin_count;
		     i++) {
			if (i & 1)
				msg[8 + i / 2] |= *vector << 4;
			else
				msg[8 + i / 2] = *vector;
			vector++;
		}

		/* Send the test vector and read the pin status */
		if (msg_send(handle->usb_handle, msg, sizeof(msg))) {
			free(result);
			return NULL;
		}
		if (msg_recv(handle->usb_handle, msg, sizeof(msg))) {
			free(result);
			return NULL;
		}

		if (msg[1]) {
			fprintf(stderr, "Overcurrent protection!\007\n");
			free(result);
			return NULL;
		}

		/* Unpack the result from 2 pin/byte to 1 pin/byte */
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
 * these two steps to detect the Z state, for chips with totem-pole outputs
 * this is not really necessary but, sometimes internal issues can be
 * detected this way like burned H side or L side output transistors.
 * The C (clock) state is performed in firmware by first pulsing the pin
 * marked as C and then all pins are read back.
 * The X (don't care) state will leave the pin unconnected.
 * The V (VCC) and G (Ground) state will designate the power supply pins.
 */

int t48_logic_ic_test(minipro_handle_t *handle)
{
	uint8_t *vector = handle->device->vectors;
	uint8_t *first_step = NULL;
	uint8_t *second_step = NULL;
	int ret = EXIT_FAILURE;

	if (!(first_step = do_ic_test(handle, 0))) { /* Pull-up active */
		fprintf(stderr,
			"Error running the first step of logic test.\n");
	} else if (!(second_step = do_ic_test(handle, 1))) { /* Pull-down active */
		fprintf(stderr,
			"Error running the second step of logic test.\n");
	} else if (handle->cmdopts->logicic_out) {
		ret = write_logic_file(handle, first_step, second_step);
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
				case LOGIC_L: /* Pin must be 0 in both steps */
					if (first_step[n] || second_step[n])
						err = 1;
					break;
				case LOGIC_H: /* Pin must be 1 in both steps */
					if (!first_step[n] || !second_step[n])
						err = 1;
					break;
				case LOGIC_Z: /* Pin must be 1 in step 1 and 0 in step 2 */
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
	if (t48_end_transaction(handle))
		return EXIT_FAILURE;

	return ret;
}


/*****************************************************************************
 * Firmware updater section
 *****************************************************************************

This is the updateT48.dat file structure.
It has a fixed 16 byte header, followed by a number of 276-byte blocks
|============|===========|============|==============|
|File version| File CRC  | Unknown    | Blocks count |
|============|===========|============|==============|
|  4 bytes   | 4 bytes   | 4 bytes    | 4 bytes      |
|============|===========|============|==============|
|  offset 0  | offset 4  | offset 8   | offset 12    |
|============|===========|============|==============|

*/

/* Performing a firmware update */
int t48_firmware_update(minipro_handle_t *handle, const char *firmware)
{
	static uint8_t msg[288];

	struct stat st;
	if (stat(firmware, &st)) {
		fprintf(stderr, "%s open error!: ", firmware);
		perror("");
		return EXIT_FAILURE;
	}

	off_t file_size = st.st_size;
	/* Check the updateT48.dat size */
	if (file_size < 16 || file_size > 1048576) {
		fprintf(stderr, "%s file size error!\n", firmware);
		return EXIT_FAILURE;
	}

	/* Open the updateT48.dat firmware file */
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

	/* Read the updateT48.dat file */
	if (fread(update_dat, sizeof(char), st.st_size, file) != st.st_size) {
		fprintf(stderr, "%s file read error!\n", firmware);
		fclose(file);
		free(update_dat);
		return EXIT_FAILURE;
	}
	fclose(file);

	/* check for update file version */
	uint32_t version = load_int(update_dat, 4, MP_LITTLE_ENDIAN);
	if ((version & T48_UPDATE_FILE_VERS_MASK) != T48_UPDATE_FILE_VERSION) {
		fprintf(stderr, "%s file version error!\n", firmware);
		free(update_dat);
		return EXIT_FAILURE;
	}
	version &= T48_FIRMWARE_VERS_MASK;

	/* Read the blocks count and check if correct */
	uint32_t blocks = load_int(update_dat + 12, 4, MP_LITTLE_ENDIAN);
	if (blocks * 0x114 + 16 != file_size) {
		fprintf(stderr, "%s file size error!\n", firmware);
		free(update_dat);
		return EXIT_FAILURE;
	}

	/* Compute the file CRC and compare */
	uint32_t crc = crc_32(update_dat + 16, blocks * 0x114, 0xFFFFFFFF);
	if (crc != load_int(update_dat + 4, 4, MP_LITTLE_ENDIAN)) {
		fprintf(stderr, "%s file CRC error!\n", firmware);
		free(update_dat);
		return EXIT_FAILURE;
	}

	fprintf(stderr, "%s contains firmware version %02u.%u.%02u", firmware,
		0, (version >> 8) & 0xFF, (version & 0xFF));

	if (handle->firmware > version)
		fprintf(stderr, " (older)");
	else if (handle->firmware < version)
		fprintf(stderr, " (newer)");

	fprintf(stderr, "\n\nDo you want to continue with firmware update? y/n:");
	fflush(stderr);
	char c = getchar();
	if (c != 'Y' && c != 'y') {
		free(update_dat);
		fprintf(stderr, "Firmware update aborted.\n");
		return EXIT_FAILURE;
	}

	/* Switching to boot mode if necessary */
	if (handle->status == MP_STATUS_NORMAL) {
		fprintf(stderr, "Switching to bootloader... ");
		fflush(stderr);

		memset(msg, 0, sizeof(msg));
		msg[0] = T48_SWITCH;
		format_int(&msg[8], T48_BTLDR_MAGIC, 8, MP_LITTLE_ENDIAN);
		if (msg_send(handle->usb_handle, msg, 16)) {
			free(update_dat);
			return EXIT_FAILURE;
		}

		memset(msg, 0, sizeof(msg));
		if (msg_recv(handle->usb_handle, msg, 32)) {
			fprintf(stderr, "failed!\n");
			free(update_dat);
			return EXIT_FAILURE;
		}

		if (msg[0]) {
			fprintf(stderr, "failed (code: %d)!\n", msg[0]);
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

	/* Erase device */
	fprintf(stderr, "Erasing... ");
	fflush(stderr);

	memset(msg, 0, sizeof(msg));
	msg[0] = T48_BOOTLOADER_ERASE;
	format_int(&msg[8], T48_BTLDR_MAGIC, 8, MP_LITTLE_ENDIAN);
	if (msg_send(handle->usb_handle, msg, 16)) {
		fprintf(stderr, "\nErase failed!\n");
		free(update_dat);
		return EXIT_FAILURE;
	}

	memset(msg, 0, sizeof(msg));
	if (msg_recv(handle->usb_handle, msg, 32)) {
		fprintf(stderr, "\nErase failed!\n");
		free(update_dat);
		return EXIT_FAILURE;
	}

	if (msg[1]) {
		fprintf(stderr, "\nfailed\n");
		free(update_dat);
		return EXIT_FAILURE;
	}

	fprintf(stderr, "OK\n");

	/* Reflash firmware */
	fprintf(stderr, "Reflashing... ");
	fflush(stderr);

	/* Begin write blocks */
	memset(msg, 0, sizeof(msg));
	msg[0] = T48_BOOTLOADER_WRITE;
	msg[1] = 1;
	format_int(&msg[8], T48_BTLDR_MAGIC, 8, MP_LITTLE_ENDIAN);
	if (msg_send(handle->usb_handle, msg, 16)) {
		fprintf(stderr, "\nReflash failed!\n");
		free(update_dat);
		return EXIT_FAILURE;
	}

	for (uint32_t i = 0; i < blocks; i++) {
		memset(msg, 0, sizeof(msg));
		msg[0] = T48_BOOTLOADER_WRITE;
		msg[1] = 0;
		msg[2] = 0x14;	/* Data Length LSB */
		msg[3] = 0x01; 	/* Data length MSB */
		memcpy(&msg[8], update_dat + 16 + i * 0x114, 0x114); /* Block */

		/* Write firmware block */
		if (msg_send(handle->usb_handle, msg, 0x11c)) {
			fprintf(stderr, "\nReflash failed\n");
			free(update_dat);
			return EXIT_FAILURE;
		}

		/* Check if the firmware block was successfully written */
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

		fprintf(stderr, "\r\e[KReflashing... %2d%%", i * 100 / blocks);
		fflush(stderr);
	}

	/* Write last block */
	memset(msg, 0, sizeof(msg));
	msg[0] = T48_BOOTLOADER_WRITE;
	msg[1] = 3;
	msg[3] = 1;
	msg[5] = 0xFF;
	msg[6] = 3;
	msg[7] = 8;
	format_int(&msg[260], 0xCDEF8668, 4, MP_LITTLE_ENDIAN);
	if (msg_send(handle->usb_handle, msg, 264)) {
		fprintf(stderr, "\nReflash failed\n");
		free(update_dat);
		return EXIT_FAILURE;
	}

	/* Check if the last block was successfully written */
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

	memset(msg, 0, sizeof(msg));
	msg[0] = T48_BOOTLOADER_WRITE;
	msg[1] = 2;
	format_int(&msg[8], T48_BTLDR_MAGIC, 8, MP_LITTLE_ENDIAN);
	if (msg_send(handle->usb_handle, msg, 16)) {
		fprintf(stderr, "\nReflash failed!\n");
		free(update_dat);
		return EXIT_FAILURE;
	}

	fprintf(stderr, "\r\e[KReflashing... 100%%\n");

	/* Switching back to normal mode */
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

#define T48_NPINS 56

static pin_driver_t last_pinstate[T48_NPINS];
static uint8_t last_direction[T48_NPINS];
static uint8_t last_output[T48_NPINS];
static int last_vcc=0;
static int last_j1vcc=1;

/************************
 * Bit banging functions
 ************************/
static void set_pin(zif_pins_t *pins, uint8_t size, uint8_t *out, uint8_t pin)
{
	int i;
	for (i = 0; i < size; i++) {
		if (pins[i].pin == pin) {
			out[pins[i].byte] |= pins[i].mask;
		}
	}
}


int t48_set_zif_direction(minipro_handle_t *handle, uint8_t *zif) {
	/* Set Direction out on pins command
	   offset 8     7,20 or 34 or sth else?!? but this is also pin number
           offset 9     which pin
           returns number of set pins in offset 8 ?!?
         */
	uint8_t msg[48];
	memset(msg, 0, sizeof(msg));

        int pullup=0;
	for (int i = 0; i < T48_NPINS; i++)
          if(zif[i]&0x80) pullup=1;

        int err;
        if(pullup)
          err=t48_set_input_and_pullup(handle);
        else
          err=t48_set_input_and_pulldown(handle);

	if(err) return err;

	for (int i = 0; i < T48_NPINS; i++) {
          memset(msg,0,48);

          if(zif[i]&1) {
            // input - do nothing, all are already input

            last_direction[i]=MP_PIN_DIRECTION_IN;
          } else {
            // output
            last_direction[i]=MP_PIN_DIRECTION_OUT;
          }
        }

        return 0;
}

static int t48_set_gnd_pins(minipro_handle_t *handle,pin_driver_t* pins,int j1gnd) {
	/* Set GND pins command
	   offset 8     pin mask
	   offset 0x10  J6 J8 J16 EGND enable
	*/
	uint8_t msg[48];
	memset(&msg, 0, sizeof(msg));
	msg[0] = T48_SET_GND_PIN;
	for (int i = 0; i < T48_NPINS; i++) {
	  last_pinstate[i].gnd=pins[i].gnd;
	  if (pins[i].gnd) {
	    set_pin(gnd_pins,
		    sizeof(gnd_pins) / sizeof(gnd_pins[0]), msg,
		    i + 1);
	  }
	}
        msg[0x10]=j1gnd; /* J6 J8 J16 EGND enable */
	return msg_send(handle->usb_handle, msg, sizeof(msg));
}

static int t48_set_vpp_pins(minipro_handle_t *handle,pin_driver_t* pins,int j1vpp) {
	/* Set VPP pins command, sub command 0, sets vpp pins
	   offset 1    subcommand: 00 is set pins, 01 is set vpp voltage 0-63, 02 is set mcu io voltage 0-4
	   offset 8-13 pin mask
	   offset 12   PC5 J1 VPP-enable
	*/
	uint8_t msg[48];
	memset(&msg, 0, sizeof(msg));
	msg[0] = T48_SET_VPP_PIN;
	msg[1]=0; /* set vpp pins */
	for (int i = 0; i < T48_NPINS; i++) {
	  last_pinstate[i].vpp=pins[i].vpp;
	  if (pins[i].vpp) {
	    set_pin(vpp_pins,
		    sizeof(vpp_pins) / sizeof(vpp_pins[0]), msg,
		    i + 1);
	  }
	}
        msg[0xc]=j1vpp; /* PC5 J1 VPP-enable */
	return msg_send(handle->usb_handle, msg, sizeof(msg));
}

static int t48_set_vcc_voltage_and_pins(minipro_handle_t *handle,int vcc,pin_driver_t* pins,int j1vcc) {
	/* Set VCC pins command, J13/J14 VCC enable, DAC hold reg and optionally VCC voltage,
           offset 0x10   J13/J14 VCC enable
           offset 0x14   DAC hold register. Can not measure voltage if 0x01. Should be sth else? 0x96?
           offset 0x16   short(!) 1-63 vcc voltage
         */
	uint8_t msg[48];
	memset(&msg, 0, sizeof(msg));

	msg[0] = T48_SET_VCC_PIN;
	for (int i = 0; i < 40; i++) {
		last_pinstate[i].vcc=pins[i].vcc;
		if (pins[i].vcc) {
			set_pin(vcc_pins,
				sizeof(vcc_pins) / sizeof(vcc_pins[0]), msg,
				i + 1);
		}
	}

	msg[0x14]=0; /* DAC hold register */
        last_j1vcc=j1vcc;
	msg[0x10]=j1vcc; /* J13/J14 VCC enable */

	/* 0 does not change voltage so only save if  */
        if(vcc) last_vcc=vcc;
	msg[0x16]=vcc;
	msg[0x17]=0;
	return msg_send(handle->usb_handle, msg, sizeof(msg));
}

/* Find voltage in voltage map closest to value and within tolerance volts */
static int find_voltage(float* voltagemap,int length,float value,float tolerance) {
  float mind=-1.0;
  int mini=-1;
  for(int i=0;i<length;i++) {
    float v=voltagemap[i];
    if(v) {
      float d=fabs(value-v);
      if(mind==-1 || d<mind) { mind=d; mini=i; }
    }
  }
  if(mini!=-1 && mind<tolerance) return mini;
  return -1;
}

/* Note that 0 is not a valid setting. VCC voltage will not be changed if 0 is passed.
 */
static float voltagemap_vcc[64]={  0.0, 1.74, 1.83, 1.89, 2.00, 2.07, 2.18, 2.23,
                                  2.32, 2.41, 2.45, 2.56, 2.65, 2.73, 2.79, 2.90,
                                  3.02, 3.08, 3.16, 3.28, 3.33, 3.42, 3.48, 3.57,
                                  3.65, 3.75, 3.84, 3.89, 3.97, 4.08, 4.16, 4.23,
                                  4.31, 4.40, 4.48, 4.55, 4.65, 4.71, 4.80, 4.88,
                                  4.97, 5.05, 5.14, 5.18, 5.29, 5.37, 5.45, 5.54,
                                  5.64, 5.76, 5.81, 5.91, 5.99, 6.06, 6.18, 6.23,
                                  6.33, 6.37, 6.45, 6.54, 6.62, 6.72, 6.80, 6.86 };
static int t48_set_vcc_voltage(minipro_handle_t *handle,int vcc) {
	return t48_set_vcc_voltage_and_pins(handle,vcc,last_pinstate,last_j1vcc);
}
int t48_set_vcc_voltagef(minipro_handle_t *handle,float vcc,float tolerance) {
  int v=find_voltage(voltagemap_vcc,sizeof(voltagemap_vcc)/sizeof(float),vcc,tolerance);
  if(v!=-1) return t48_set_vcc_voltage(handle,v);
  return EXIT_FAILURE;
}

static int t48_set_vcc_pins(minipro_handle_t *handle,pin_driver_t* pins,int j1vcc) {
	/* pass 0 for voltage in order not to change vcc voltage */
	return t48_set_vcc_voltage_and_pins(handle,0,pins,j1vcc);
}

/* approximately 9.31+0.25*vppindex */
static float voltagemap_vpp[64]={  9.31,  9.56,  9.83, 10.11, 10.32, 10.60, 10.87, 11.14,
                                  11.32, 11.61, 11.86, 12.15, 12.35, 12.63, 12.90, 13.18,
                                  13.35, 13.62, 13.88, 14.16, 14.38, 14.66, 14.92, 15.19,
                                  15.39, 15.65, 15.93, 16.19, 16.43, 16.70, 16.95, 17.23,
                                  17.22, 17.48, 17.76, 18.04, 18.26, 18.53, 18.80, 19.07,
                                  19.25, 19.52, 19.80, 20.07, 20.30, 20.56, 20.85, 21.10,
                                  21.27, 21.56, 21.82, 22.10, 22.31, 22.59, 22.86, 23.13,
                                  23.32, 23.58, 23.86, 24.13, 24.37, 24.63, 24.90, 25.16 };
static int t48_set_vpp_voltage(minipro_handle_t *handle,int vpp) {
	/* Set VPP pins command, sub command 1, with param 0-63 sets vpp voltage
           offset 1   00 is set pins, 01 is set vpp voltage 0-63, 02 is set mcu io voltage 0-4
           offset 8   pin-mask or 0-4 for vccio and 0-63 for vpp voltage
         */
	uint8_t msg[48];
	memset(&msg, 0, sizeof(msg));
	msg[0] = T48_SET_VPP_PIN;
	msg[1]=1;
	msg[8]=vpp;
	return msg_send(handle->usb_handle, msg, sizeof(msg));
}

int t48_set_vpp_voltagef(minipro_handle_t *handle,float vpp,float tolerance) {
  int v=find_voltage(voltagemap_vpp,sizeof(voltagemap_vpp)/sizeof(float),vpp,tolerance);
  if(v!=-1) return t48_set_vpp_voltage(handle,v);
  return EXIT_FAILURE;
}


static float voltagemap_vccio[5]={ 2.35, 2.47, 2.93, 3.23, 3.45 };

static int t48_set_vccio_voltage(minipro_handle_t *handle,int vccio) {
	/* Set VPP pins command, sub command 2, with param 0-4 set vccio voltage
           offset 1   00 is set pins, 01 is set vpp voltage 0-63, 02 is set mcu io voltage 0-4
           offset 8   pin-mask or 0-4 for vccio and 0-63 for vpp voltage
         */
	uint8_t msg[48];
	memset(&msg, 0, sizeof(msg));
	msg[0] = T48_SET_VPP_PIN;
	msg[1]=2;
	msg[8]=vccio;
	return msg_send(handle->usb_handle, msg, sizeof(msg));
}

int t48_set_vccio_voltagef(minipro_handle_t *handle,float vccio,float tolerance) {
  int v=find_voltage(voltagemap_vccio,sizeof(voltagemap_vccio)/sizeof(float),vccio,tolerance);
  if(v!=-1) return t48_set_vccio_voltage(handle,v);
  return EXIT_FAILURE;
}







int t48_reset_state(minipro_handle_t *handle)
{
	uint8_t msg[48];
	memset(last_direction, 0, sizeof(last_direction));
	/* Set last_output to invalid value so we always change it if not set before */
	memset(last_output, 0xff, sizeof(last_direction));
	/* Also clear VCC/GND/VPP values */
	memset(last_pinstate, 0, sizeof(last_pinstate));
	last_vcc = 0;
	last_j1vcc = 1;
	memset(msg, 0, sizeof(msg));
	/* Reset pin drivers state */
	msg[0] = T48_RESET_PIN_DRIVERS;
	return msg_send(handle->usb_handle, msg, sizeof(msg));
}


int t48_set_input_and_pullup(minipro_handle_t *handle)
{
  /* Sets all pins to input and with pull down active
   */
	uint8_t msg[48];
	memset(last_direction, 0, sizeof(last_direction));
	/* Set last_output to invalid value so we always change it if not set before */
	memset(last_output, 0xff, sizeof(last_direction));
	memset(msg, 0, sizeof(msg));
	/* Reset pin drivers state */
	msg[0] = T48_SET_PULLUPS;
	return msg_send(handle->usb_handle, msg, sizeof(msg));
}

int t48_set_input_and_pulldown(minipro_handle_t *handle)
{
  /* Sets all pins to input and with pull up active
   */
	uint8_t msg[48];
	memset(last_direction, 0, sizeof(last_direction));
	/* Set last_output to invalid value so we always change it if not set before */
	memset(msg, 0, sizeof(msg));
	/* Reset pin drivers state */
	msg[0] = T48_SET_PULLDOWNS;
	return msg_send(handle->usb_handle, msg, sizeof(msg));
}

/*
    Returns reading from ADC for VPP, VUSB, VCC and VCCIO scaled by VUSB
    in float[4] array if passed.
 */
int t48_measure_voltages(minipro_handle_t* handle,float* voltages) {
	uint8_t msg[24];
	memset(msg, 0, sizeof(msg));
	msg[0] = T48_MEASURE_VOLTAGES;
	//msg[8] = 1;
	//msg[10] = 1;
	int err=msg_send(handle->usb_handle, msg, 16);
	if(err) return err;
	err=msg_recv(handle->usb_handle, msg, sizeof(msg));
        if(err) return EXIT_FAILURE;
	uint32_t vpp=load_int(&(msg[ 8]), 2, MP_LITTLE_ENDIAN)* 0xf78/0x1000;
	uint32_t vusb=load_int(&(msg[12]), 2, MP_LITTLE_ENDIAN)*0xccf6/0x27000;
	uint32_t vcc=load_int(&(msg[16]), 2, MP_LITTLE_ENDIAN)*0xb32e/0x27000-0x14;
	uint32_t vccio=load_int(&(msg[20]), 2, MP_LITTLE_ENDIAN)* 0x294/0x1000;
	if(voltages) {
	  voltages[0]=vpp/100.0;
	  voltages[1]=vusb/100.0;
	  voltages[2]=vcc/100.0;
	  voltages[3]=vccio/100.0;
	}
	return err;
}

/*
    Uses set pin output
    Setting out on a pin sets direction of that pin to output so we must never
    do T48_SET_OUT on a configured input.
 */
int t48_set_zif_state(minipro_handle_t *handle, uint8_t *zif)
{
	uint8_t msg[8];
	memset(msg, 0, sizeof(msg));
	for (int i = 0; i < T48_NPINS; i++) {
          if(last_direction[i]==MP_PIN_DIRECTION_OUT && last_output[i] != zif[i]) {
            msg[0] = T48_SET_OUT;
            msg[1] = zif[i];
            msg[4] = i;
            if (msg_send(handle->usb_handle, msg, 8))
              return EXIT_FAILURE;
	    last_output[i] = zif[i];
          }
	}

	return EXIT_SUCCESS;
}


int t48_get_zif_state(minipro_handle_t *handle, uint8_t *zif)
{
	// Byte 8-14 is response with pin 1 in lsb of byte 8.
	uint8_t msg[48];
	memset(msg, 0, sizeof(msg));
	msg[0] = T48_READ_PINS;
	if (msg_send(handle->usb_handle, msg, 8))
		return EXIT_FAILURE;
	if (msg_recv(handle->usb_handle, msg, sizeof(msg)))
		return EXIT_FAILURE;
	for(int i=0;i<T48_NPINS;i++) zif[i]=(msg[8+(i>>3)]>>(i&7))&1;
	return EXIT_SUCCESS;
}

int t48_screen_voltages(minipro_handle_t *handle) {
	float voltages[4];
	for(int i=0;i<64;i++) {
	  t48_set_vpp_voltage(handle,i);
          /* It takes max 450ms for vpp voltage to settle without load */
          usleep(450000);
	  t48_measure_voltages(handle,voltages);
	  printf("vpp %2d is %.2fV\n",i,voltages[0]);
	}
	for(int i=0;i<5;i++) {
	  t48_set_vccio_voltage(handle,i);
          /* No measurable settling time for vccio here so no sleep needed */
	  t48_measure_voltages(handle,voltages);
	  printf("vccio %2d is %.2fV\n",i,voltages[3]);
	}
	for(int i=0;i<64;i++) {
          /* note that 0 will NOT set voltage */
	  t48_set_vcc_voltage(handle,i);
          /* It takes max 600ms for vcc voltage to settle without load */
          usleep(600000);
	  t48_measure_voltages(handle,voltages);
	  printf("vcc %2d is %.2fV\n",i,voltages[2]);
	}
	printf("USB voltage %.2f\n",voltages[1]);
	return EXIT_SUCCESS;
}


/*
  VPP[0..15]
  9.0,  9.5, 10.0, 11.0, 11.5, 12.0, 12.5, 13.0,
  13.5, 14.0, 14.5, 15.5, 16.0, 16.5, 17.0, 18.0

  VCC[0..15]
  1.9, 2.7, 3.0, 3.3, 3.6, 3.9, 4.1, 4.5,
  4.8, 5.0, 5.3, 5.5, 6.0, 6.3, 6.5, 7.0
 */

int t48_set_voltages(minipro_handle_t *handle, uint8_t vcc, uint8_t vpp)
{
	/* Internal VCC table firmware map */
	static const uint8_t vcc_t[] = { 3, 13, 16, 19, 23, 27, 29, 34,
					 38, 40, 44, 47, 52, 56, 59, 62};
	int err=t48_set_vcc_voltage(handle,vcc_t[vcc]);
	if(err) return err;
	/* Internal VPP table firmware map */
	static const uint8_t vpp_t[] = {0, 1, 3, 6, 9, 10, 13, 14, 17, 18,
					20, 24, 26, 28, 30, 35};
	return t48_set_vpp_voltage(handle,vpp_t[vpp]);
}

int t48_set_pin_drivers(minipro_handle_t *handle, pin_driver_t *pins)
{
	/* Set GND pins */
        int err=t48_set_gnd_pins(handle,pins,1);
	if(err) return err;
	/* Set VCC pins */
        err=t48_set_vcc_pins(handle,pins,1);
	if(err) return err;
	/* Set VPP pins */
        return t48_set_vpp_pins(handle,pins,1);
}

static int zif_pin_state(uint8_t *msg, uint8_t pin)
{
	return (msg[8+(pin>>3)]>>(pin&7))&1;
}

/* Return 1 if ZIF/ICSP pin has no I/O pin associated with it */
static int zif_no_io(uint8_t pin)
{
	if (pin == 51 || pin == 53 || pin == 55)
		return 1;
	return 0;
}

static int t48_check_pins(minipro_handle_t *handle, char *name, uint8_t cmd, zif_pins_t *pins, size_t npins,
				int *perr)
{
	int i, j;
	uint8_t check_level;
	zif_pins_t *pin;
	uint8_t msg[64];
	if (t48_reset_state(handle))
		return EXIT_FAILURE;
	/* If testing GND set pullups and check level 0 otherwise pulldowns and 1 */
	if (cmd == T48_SET_GND_PIN) {
		if (t48_set_input_and_pullup(handle))
			return EXIT_FAILURE;
		check_level = 0;
	} else {
		if (t48_set_input_and_pulldown(handle))
			return EXIT_FAILURE;
		check_level = 1;
	}
	fprintf(stderr, "Testing %d %s pins\n", (int)npins, name);
	for (i = 0, pin = pins; i < npins; i++, pin++) {
		memset(msg, 0, sizeof(msg));
		msg[0] = cmd;
		msg[pin->byte] = pin->mask;
		if (msg_send(handle->usb_handle, msg, 64))
			return EXIT_FAILURE;
		msg[0] = T48_READ_PINS;
		if (msg_send(handle->usb_handle, msg, 8))
			return EXIT_FAILURE;
		if (msg_recv(handle->usb_handle, msg, sizeof(msg)))
			return EXIT_FAILURE;
		if (msg[1]) {
			msg[0] = T48_RESET_PIN_DRIVERS;
			if (msg_send(handle->usb_handle, msg, 10)) {
				return EXIT_FAILURE;
			}
			if (minipro_end_transaction(handle)) {
				return EXIT_FAILURE;
			}
			fprintf(stderr,
				"Overcurrent protection detected while testing %s pin driver "
				"%u!\007\n",
				name, pin->pin);
			return EXIT_FAILURE;
		}
		if (!zif_no_io(pin->pin - 1)) {
			int pin_ok = zif_pin_state(msg, pin->pin - 1) == check_level;
			fprintf(stderr, "%s pin %u state is %s\n", name, pin->pin, pin_ok ? "Good" : "Bad");
			if (!pin_ok)
				(*perr)++;
		}
		/* Check all other pins do *not* match expected value */
		for (j = 0; j < T48_NPINS; j++) {
			if (j == pin->pin - 1)
				continue;
			/* Skip unconnected J1 pins */
			if (zif_no_io(j))
				continue;
			if (zif_pin_state(msg, j) == check_level) {
				fprintf(stderr, "Unexpected state of pin %u when testing %s pin %u: shorted?\n",
												j + 1, name, pin->pin);
				(*perr)++;
			}
		}
	}
	return EXIT_SUCCESS;
}

static int t48_check_logic(minipro_handle_t *handle, uint8_t level, int *perr)
{
	int i, j;
	uint8_t msg[64];
	fprintf(stderr, "Testing 53 Logic level %u pins\n", level);
	for (i = 0; i < T48_NPINS; i++) {
		/* Unconnected ICSP pins can't be set to logic 1/0 so ignore them */
		if (zif_no_io(i))
			continue;
		if (level) {
			if (t48_set_input_and_pulldown(handle))
				return EXIT_FAILURE;
		} else {
			if (t48_set_input_and_pullup(handle))
				return EXIT_FAILURE;
		}

		memset(msg, 0, sizeof(msg));
		msg[0] = T48_SET_OUT;
		msg[1] = level;
		msg[4] = i;
		if (msg_send(handle->usb_handle, msg, 8))
			return EXIT_FAILURE;

		msg[0] = T48_READ_PINS;
		if (msg_send(handle->usb_handle, msg, 8))
			return EXIT_FAILURE;
		if (msg_recv(handle->usb_handle, msg, sizeof(msg)))
			return EXIT_FAILURE;
		if (msg[1]) {
			msg[0] = T48_RESET_PIN_DRIVERS;
			if (msg_send(handle->usb_handle, msg, 10)) {
				return EXIT_FAILURE;
			}
			if (minipro_end_transaction(handle)) {
				return EXIT_FAILURE;
			}
			fprintf(stderr,
				"Overcurrent protection detected while testing logic %u pin driver "
				"%u!\007\n",
				level, i + 1);
			return EXIT_FAILURE;
		}
		if (!zif_no_io(i)) {
			int pin_ok = zif_pin_state(msg, i) == level;
			fprintf(stderr, "Logic %u pin %u state is %s\n", level, i + 1, pin_ok ? "Good" : "Bad");
			if (!pin_ok)
				(*perr)++;
		}
		/* Check all other pins do *not* match expected value */
		for (j = 0; j < T48_NPINS; j++) {
			if (j == i)
				continue;
			/* Skip unconnected ICSP pins */
			if (zif_no_io(j))
				continue;
			if (zif_pin_state(msg, j) == level) {
				fprintf(stderr, "Unexpected state of pin %u when testing logic %u pin %u: shorted?\n",
												j + 1, level, i + 1);
				(*perr)++;
			}
		}
	}
	return EXIT_SUCCESS;
}

/* Minipro hardware check */
int t48_hardware_check(minipro_handle_t *handle)
{
	int nerr = 0;
	uint8_t msg[64];
	if (t48_check_pins(handle, "VPP", T48_SET_VPP_PIN, vpp_pins, sizeof(vpp_pins)/sizeof(zif_pins_t), &nerr))
		return EXIT_FAILURE;
	fprintf(stderr, "\n");
	if (t48_check_pins(handle, "VCC", T48_SET_VCC_PIN, vcc_pins, sizeof(vcc_pins)/sizeof(zif_pins_t), &nerr))
		return EXIT_FAILURE;
	fprintf(stderr, "\n");
	if (t48_check_pins(handle, "GND", T48_SET_GND_PIN, gnd_pins, sizeof(gnd_pins)/sizeof(zif_pins_t), &nerr))
		return EXIT_FAILURE;
	fprintf(stderr, "\n");
	if (t48_check_logic(handle, 0, &nerr))
		return EXIT_FAILURE;
	fprintf(stderr, "\n");
	if (t48_check_logic(handle, 1, &nerr))
		return EXIT_FAILURE;

	memset(msg, 0, sizeof(msg));
	msg[0] = T48_RESET_PIN_DRIVERS;
	if (msg_send(handle->usb_handle, msg, 10))
		return EXIT_FAILURE;

	msg[0] = T48_SET_GND_PIN;
	msg[gnd_pins[GND1].byte] = gnd_pins[GND1].mask;
	if (msg_send(handle->usb_handle, msg, 10))
		return EXIT_FAILURE;

	memset(msg, 0, sizeof(msg));
	msg[0] = T48_SET_VPP_PIN;
	msg[vpp_pins[VPP1].byte] = vpp_pins[VPP1].mask;
	if (msg_send(handle->usb_handle, msg, 10))
		return EXIT_FAILURE;

	memset(msg, 0, sizeof(msg));
	msg[0] = T48_READ_PINS;
	if (msg_send(handle->usb_handle, msg, 8))
		return EXIT_FAILURE;
	if (msg_recv(handle->usb_handle, msg, sizeof(msg)))
		return EXIT_FAILURE;

	fprintf(stderr, "\n");
	if (msg[1]) {
		fprintf(stderr, "VPP overcurrent protection is OK.\n");
	} else {
		fprintf(stderr, "VPP overcurrent protection failed!\007\n");
		nerr++;
	}

	memset(msg, 0, sizeof(msg));
	msg[0] = T48_RESET_PIN_DRIVERS;
	if (msg_send(handle->usb_handle, msg, 10))
		return EXIT_FAILURE;

	msg[0] = T48_SET_GND_PIN;
	msg[gnd_pins[GND1].byte] = gnd_pins[GND1].mask;
	if (msg_send(handle->usb_handle, msg, 10))
		return EXIT_FAILURE;

	memset(msg, 0, sizeof(msg));
	msg[0] = T48_SET_VCC_PIN;
	msg[vcc_pins[VCC1].byte] = vcc_pins[VCC1].mask;
	if (msg_send(handle->usb_handle, msg, 10))
		return EXIT_FAILURE;

	memset(msg, 0, sizeof(msg));
	msg[0] = T48_READ_PINS;
	if (msg_send(handle->usb_handle, msg, 8))
		return EXIT_FAILURE;
	if (msg_recv(handle->usb_handle, msg, sizeof(msg)))
		return EXIT_FAILURE;

	if (msg[1]) {
		fprintf(stderr, "VCC overcurrent protection is OK.\n");
	} else {
		fprintf(stderr, "VCC overcurrent protection failed!\007\n");
		nerr++;
	}

	memset(msg, 0, sizeof(msg));
	msg[0] = T48_RESET_PIN_DRIVERS;
	if (msg_send(handle->usb_handle, msg, 10))
		return EXIT_FAILURE;

	if (nerr)
		fprintf(stderr, "\nHardware test completed with %u error(s).\007\n", nerr);
	else
		fprintf(stderr, "\nHardware test completed successfully!\n");
	return EXIT_SUCCESS;
}
