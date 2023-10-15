/*
 * bitbang.c - bit banging operations.
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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <time.h>

#include "database.h"
#include "minipro.h"
#include "bitbang.h"
#include "prom.h"
#include "usb.h"

static inline uint8_t PIN(uint8_t pin, uint8_t count)
{
	return pin <= count / 2 ? pin : 40 - count + pin;
}

void set_io_pins(uint8_t *zif, uint8_t *pins, uint8_t value, uint8_t package)
{
	for (; pins && *pins; pins++) {
		zif[PIN(*pins, package) - 1] = value;
	}
}

void set_pwr_pins(pin_driver_t *pwr, uint8_t *pins, uint8_t value,
		  uint8_t package, uint8_t type)
{
	for (; pins && *pins; pins++) {
		uint8_t pin = PIN(*pins, package);
		switch (type) {
		case GND_PIN:
			pwr[pin - 1].gnd = value;
			break;
		case VCC_PIN:
			pwr[pin - 1].vcc = value;
			break;
		case VPP_PIN:
			pwr[pin - 1].vpp = value;
			break;
		default:
			return;
		}
	}
}

void set_bits(uint8_t *zif, uint8_t *pins, uint32_t value, uint8_t package)
{
	for (; pins && *pins; pins++, value >>= 1) {
		zif[PIN(*pins, package) - 1] = value & 0x01;
	}
}

uint32_t get_bits(uint8_t *zif, uint8_t *pins, uint8_t package)
{
	uint32_t value = 0;
	uint8_t bit = 0;
	for (; pins && *pins; pins++, bit++) {
		if (zif[PIN(*pins, package) - 1])
			value |= (1 << bit);
	}
	return value;
}

int bb_begin_transaction(minipro_handle_t *handle)
{
	switch (handle->device->protocol_id) {
	case CP_PROM:
		return prom_init(handle);
	default:
		fprintf(stderr, "Unimplemented bb_begin_transaction\n");
		return EXIT_FAILURE;
	}
}

int bb_end_transaction(minipro_handle_t *handle)
{
	switch (handle->device->protocol_id) {
	case CP_PROM:
		return prom_terminate(handle);
	default:
		fprintf(stderr, "Unimplemented bb_end_transaction\n");
		return EXIT_FAILURE;
	}
}

int bb_read_block(minipro_handle_t *handle, uint8_t type, uint32_t addr,
		  uint8_t *buf, size_t len)
{
	switch (handle->device->protocol_id) {
	case CP_PROM:
		return prom_read(handle, addr, buf, len);
	default:
		fprintf(stderr, "Unimplemented read_block\n");
		return EXIT_FAILURE;
	}
}

int bb_write_block(minipro_handle_t *handle, uint8_t type, uint32_t addr,
		   uint8_t *buf, size_t len)
{
	fprintf(stderr, "Unimplemented write_block\n");
	return EXIT_FAILURE;
}

int bb_read_fuses(minipro_handle_t *handle, uint8_t type, size_t length,
		  uint8_t items_count, uint8_t *buffer)
{
	fprintf(stderr, "bb_read_fuses\n");
	return EXIT_SUCCESS;
}

int bb_write_fuses(minipro_handle_t *handle, uint8_t type, size_t length,
		   uint8_t items_count, uint8_t *buffer)
{
	fprintf(stderr, "bb_write_fuses\n");
	return EXIT_SUCCESS;
}

int bb_read_calibration(minipro_handle_t *handle, uint8_t *buffer, size_t len)
{
	fprintf(stderr, "bb_read_calibration\n");
	return EXIT_SUCCESS;
}

int bb_get_chip_id(minipro_handle_t *handle, uint32_t *device_id)
{
	fprintf(stderr, "bb_get_chip_id\n");
	return EXIT_SUCCESS;
}
int bb_spi_autodetect(minipro_handle_t *handle, uint8_t type,
		      uint32_t *device_id)
{
	fprintf(stderr, "bb_spi_autodetect\n");
	return EXIT_SUCCESS;
}

int bb_protect_off(minipro_handle_t *handle)
{
	fprintf(stderr, "bb_protect_off\n");
	return EXIT_SUCCESS;
}

int bb_protect_on(minipro_handle_t *handle)
{
	fprintf(stderr, "bb_protect_on\n");
	return EXIT_SUCCESS;
}

int bb_erase(minipro_handle_t *handle)
{
	fprintf(stderr, "bb_erase\n");
	return EXIT_SUCCESS;
}

int bb_write_jedec_row(minipro_handle_t *handle, uint8_t *buffer, uint8_t row,
		       uint8_t flags, size_t size)
{
	fprintf(stderr, "bb_write_jedec_row\n");
	return EXIT_SUCCESS;
}

int bb_read_jedec_row(minipro_handle_t *handle, uint8_t *buffer, uint8_t row,
		      uint8_t flags, size_t size)
{
	fprintf(stderr, "bb_read_jedec_row\n");
	return EXIT_SUCCESS;
}
