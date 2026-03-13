/*
 * prom.c - bipolar prom custom algorithm implementation
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
#include "usb.h"
#include "bitbang.h"

#define HITACHI_MASK_PROM_MASK 0x80

typedef struct prom {
	uint8_t *gnd_pins;	/* GND pins list */
	uint8_t *vcc_pins;	/* VCC pins list */
	uint8_t *data_bus_pins; /* data bus pins lsb to msb order */
	uint8_t *addr_bus_pins; /* address bus pins lsb to msb order */
	uint8_t *ce_lo_pins;	/* chip enable pins required to be low */
	uint8_t *ce_hi_pins;	/* chip enable pins required to be high */
	uint16_t compare_mask;	/* and mask for relevant bits */
} prom_t;

typedef struct mask_prom {
	uint8_t *gnd_pins;	/* GND pins list */
	uint8_t *vcc_pins;	/* VCC pins list */
	uint8_t *data_bus_pins; /* data bus pins lsb to msb order */
	uint8_t *addr_bus_pins; /* address bus pins lsb to msb order */
	uint8_t *ce_pins;	/* chip enable pins programmed into the ROM */
	uint8_t *cs_pins;	/* chip select pins programmed into the ROM */
	uint16_t compare_mask;	/* and mask for relevant bits */
} mask_prom_t;

/* All supported proms table
 * All pin lists must be zero terminated
 */
static prom_t prom_table[] = {
	/* Type 0; 32x8; DIP16 (74S188, 74S288, 82S23, 82S123) */
	{ .gnd_pins = (uint8_t[]){ 8, 0 },
	  .vcc_pins = (uint8_t[]){ 16, 0 },
	  .data_bus_pins = (uint8_t[]){ 1, 2, 3, 4, 5, 6, 7, 9, 0 },
	  .addr_bus_pins = (uint8_t[]){ 10, 11, 12, 13, 14, 0 },
	  .ce_lo_pins = (uint8_t[]){ 15, 0 },
	  .compare_mask = 0xff },

	/* Type 1; 256x4; DIP16 (74S287, 74S387, 82S126, 82S129) */
	{ .gnd_pins = (uint8_t[]){ 8, 0 },
	  .vcc_pins = (uint8_t[]){ 16, 0 },
	  .data_bus_pins = (uint8_t[]){ 12, 11, 10, 9, 0 },
	  .addr_bus_pins = (uint8_t[]){ 5, 6, 7, 4, 3, 2, 1, 15, 0 },
	  .ce_lo_pins = (uint8_t[]){ 13, 14, 0 },
	  .compare_mask = 0x0f },

	/* Type 2; 512x4; DIP16 (74S570, 74S571, 82S130, 82S131) */
	{ .gnd_pins = (uint8_t[]){ 8, 0 },
	  .vcc_pins = (uint8_t[]){ 16, 0 },
	  .data_bus_pins = (uint8_t[]){ 12, 11, 10, 9, 0 },
	  .addr_bus_pins = (uint8_t[]){ 5, 6, 7, 4, 3, 2, 1, 15, 14, 0 },
	  .ce_lo_pins = (uint8_t[]){ 13, 0 },
	  .compare_mask = 0x0f },

	/* Type 3; 1024x4; DIP18 (74S572, 74S573, 82S136, 82S137) */
	{ .gnd_pins = (uint8_t[]){ 9, 0 },
	  .vcc_pins = (uint8_t[]){ 18, 0 },
	  .data_bus_pins = (uint8_t[]){ 14, 13, 12, 11, 0 },
	  .addr_bus_pins = (uint8_t[]){ 5, 6, 7, 4, 3, 2, 1, 17, 16, 15, 0 },
	  .ce_lo_pins = (uint8_t[]){ 8, 10, 0 },
	  .compare_mask = 0x0f },

	/* Type 4; 2048x4; DIP18 (82S184, 82S185) */
	{ .gnd_pins = (uint8_t[]){ 9, 0 },
	  .vcc_pins = (uint8_t[]){ 18, 0 },
	  .data_bus_pins = (uint8_t[]){ 14, 13, 12, 11, 0 },
	  .addr_bus_pins = (uint8_t[]){ 5, 6, 7, 4, 3, 2, 1, 17, 16, 15, 8, 0 },
	  .ce_lo_pins = (uint8_t[]){ 10, 0 },
	  .compare_mask = 0x0f },

	/* Type 5; 256x8; DIP20 (82S135) */
	{ .gnd_pins = (uint8_t[]){ 10, 0 },
	  .vcc_pins = (uint8_t[]){ 20, 0 },
	  .data_bus_pins = (uint8_t[]){ 6, 7, 8, 9, 11, 12, 13, 14, 0 },
	  .addr_bus_pins = (uint8_t[]){ 1, 2, 3, 4, 5, 17, 18, 19, 0 },
	  .ce_lo_pins = (uint8_t[]){ 15, 16, 0 },
	  .compare_mask = 0xff },

	/* Type 6; 512x8; DIP20 (74S472, 74S473, 82S146, 82S147) */
	{ .gnd_pins = (uint8_t[]){ 10, 0 },
	  .vcc_pins = (uint8_t[]){ 20, 0 },
	  .data_bus_pins = (uint8_t[]){ 6, 7, 8, 9, 11, 12, 13, 14, 0 },
	  .addr_bus_pins = (uint8_t[]){ 1, 2, 3, 4, 5, 16, 17, 18, 19, 0 },
	  .ce_lo_pins = (uint8_t[]){ 15, 0 },
	  .compare_mask = 0xff },

	/* Type 7; 512x8; DIP24 (74S474, 74S475, 82S140, 82S141) */
	{ .gnd_pins = (uint8_t[]){ 12, 0 },
	  .vcc_pins = (uint8_t[]){ 24, 0 },
	  .data_bus_pins = (uint8_t[]){ 9, 10, 11, 13, 14, 15, 16, 17, 0 },
	  .addr_bus_pins = (uint8_t[]){ 8, 7, 6, 5, 4, 3, 2, 1, 23, 0 },
	  .ce_lo_pins = (uint8_t[]){ 21, 20, 0 },
	  .ce_hi_pins = (uint8_t[]){ 19, 18, 0 },
	  .compare_mask = 0xff },

	/* Type 8; 1024x8; DIP24 (74S478, 74S479, 82S180, 82S181) */
	{ .gnd_pins = (uint8_t[]){ 12, 0 },
	  .vcc_pins = (uint8_t[]){ 24, 0 },
	  .data_bus_pins = (uint8_t[]){ 9, 10, 11, 13, 14, 15, 16, 17, 0 },
	  .addr_bus_pins = (uint8_t[]){ 8, 7, 6, 5, 4, 3, 2, 1, 23, 22, 0 },
	  .ce_lo_pins = (uint8_t[]){ 21, 20, 0 },
	  .ce_hi_pins = (uint8_t[]){ 19, 18, 0 },
	  .compare_mask = 0xff },

	/* Type 9; 2024x8; DIP24 (82S190, 82S191) */
	{ .gnd_pins = (uint8_t[]){ 12, 0 },
	  .vcc_pins = (uint8_t[]){ 24, 0 },
	  .data_bus_pins = (uint8_t[]){ 9, 10, 11, 13, 14, 15, 16, 17, 0 },
	  .addr_bus_pins = (uint8_t[]){ 8, 7, 6, 5, 4, 3, 2, 1, 23, 22, 21, 0 },
	  .ce_lo_pins = (uint8_t[]){ 20, 0 },
	  .ce_hi_pins = (uint8_t[]){ 19, 18, 0 },
	  .compare_mask = 0xff },

	/* Type 10; 4096x8; DIP24 (82S321) */
	{ .gnd_pins = (uint8_t[]){ 12, 0 },
	  .vcc_pins = (uint8_t[]){ 24, 0 },
	  .data_bus_pins = (uint8_t[]){ 9, 10, 11, 13, 14, 15, 16, 17, 0 },
	  .addr_bus_pins =
		  (uint8_t[]){ 8, 7, 6, 5, 4, 3, 2, 1, 23, 22, 21, 19, 0 },
	  .ce_lo_pins = (uint8_t[]){ 20, 0 },
	  .ce_hi_pins = (uint8_t[]){ 18, 0 },
	  .compare_mask = 0xff },

	/* Type 11; 8192x8; DIP24 (82HS641/A/B) */
	{ .gnd_pins = (uint8_t[]){ 12, 0 },
	  .vcc_pins = (uint8_t[]){ 24, 0 },
	  .data_bus_pins = (uint8_t[]){ 9, 10, 11, 13, 14, 15, 16, 17, 0 },
	  .addr_bus_pins =
		  (uint8_t[]){ 8, 7, 6, 5, 4, 3, 2, 1, 23, 22, 21, 19, 18, 0 },
	  .ce_lo_pins = (uint8_t[]){ 20, 0 },
	  .compare_mask = 0xff },

	/* Type 12; 8192x8; DIP24 (D2364C) */
	{ .gnd_pins = (uint8_t[]){ 12, 0 },
	  .vcc_pins = (uint8_t[]){ 24, 0 },
	  .data_bus_pins = (uint8_t[]){ 9, 10, 11, 13, 14, 15, 16, 17, 0 },
	  .addr_bus_pins =
		  (uint8_t[]){ 8, 7, 6, 5, 4, 3, 2, 1, 23, 22, 19, 18, 21, 0 },
	  .ce_lo_pins = (uint8_t[]){ 20, 0 },
	  .compare_mask = 0xff },
};

static mask_prom_t mask_prom_table[] = {
	/* Type 0x80; 16384x8; DIP28 w/ programmable CE (HN43128P) */
	{ .gnd_pins = (uint8_t[]){ 14, 0 },
	  .vcc_pins = (uint8_t[]){ 28, 0 },
	  .data_bus_pins = (uint8_t[]){ 11, 12, 13, 15, 16, 17, 18, 19, 0 },
	  .addr_bus_pins =
		  (uint8_t[]){ 10, 9, 8, 7, 6, 5, 4, 3, 25, 24, 21, 20, 23, 2, 0 },
	  .ce_pins = (uint8_t[]){ 22, 0 },
	  .cs_pins = (uint8_t[]){ 27, 26, 0 },
	  .compare_mask = 0xff },
	/* Type 0x81; 2048x8; DIP24 w/ programmable CE (2316) */
	{ .gnd_pins = (uint8_t[]){ 12, 0 },
	  .vcc_pins = (uint8_t[]){ 24, 0 },
	  .data_bus_pins = (uint8_t[]){ 9, 10, 11, 13, 14, 15, 16, 17, 0 },
	  .addr_bus_pins =
		  (uint8_t[]){ 8, 7, 6, 5, 4, 3, 2, 1, 23, 22, 19, 0 },
	  .ce_pins = (uint8_t[]){ 0 },
	  .cs_pins = (uint8_t[]){ 20, 18, 21, 0 },
	  .compare_mask = 0xff }
};

/* Persistent state */
static uint8_t zif_dir[40];
static uint8_t zif_state[40];
static pin_driver_t pin_drivers[40];

/* Set the initial state */
static int mask_prom_init(minipro_handle_t *handle)
{
	uint8_t type = (uint8_t)handle->device->variant & ~HITACHI_MASK_PROM_MASK;
	size_t prom_entries = sizeof(mask_prom_table) / sizeof(mask_prom_table[0]);

	if (type >= prom_entries) {
		fprintf(stderr, "Unknown custom protocol 0x%02x\n", type);
		return EXIT_FAILURE;
	}

	uint8_t pin_count = handle->device->package_details.pin_count;

	/* Modify the compare mask according to the chip type */
	handle->device->compare_mask = mask_prom_table[type].compare_mask;

	memset(zif_dir, MP_PIN_DIRECTION_IN, sizeof(zif_dir));
	memset(zif_state, 0x00, sizeof(zif_state));
	memset(pin_drivers, 0x00, sizeof(pin_drivers));

	/* Set address bus direction to output */
	set_io_pins(zif_dir, mask_prom_table[type].addr_bus_pins,
		    MP_PIN_DIRECTION_OUT, pin_count);

	/* Set chip enable pins direction to output */
	set_io_pins(zif_dir, mask_prom_table[type].ce_pins, MP_PIN_DIRECTION_OUT,
		    pin_count);
	set_io_pins(zif_dir, mask_prom_table[type].cs_pins, MP_PIN_DIRECTION_OUT,
		    pin_count);

	/* Set chip enable pins state to disabled */
	set_io_pins(zif_state, mask_prom_table[type].ce_pins, 1, pin_count);
	set_io_pins(zif_state, mask_prom_table[type].cs_pins, 1, pin_count);

	if (minipro_set_zif_direction(handle, zif_dir))
		return EXIT_FAILURE;
	if (minipro_set_zif_state(handle, zif_state))
		return EXIT_FAILURE;

	/* Set all GND and VCC power pins */
	set_pwr_pins(pin_drivers, mask_prom_table[type].gnd_pins, 1, pin_count,
		     GND_PIN);
	set_pwr_pins(pin_drivers, mask_prom_table[type].vcc_pins, 1, pin_count,
		     VCC_PIN);

	/* Now switch the power on. We need to set voltages after any
	 * pin driver settings because the firmware will reset all voltages
	 * to default. */
	if (minipro_set_pin_drivers(handle, pin_drivers))
		return EXIT_FAILURE;
	/* Set VPP and VCC voltages */
	return minipro_set_voltages(handle, handle->device->voltages.vcc,
					    handle->device->voltages.vpp);
}

/* Set the initial state */
int prom_init(minipro_handle_t *handle)
{
	uint8_t type = (uint8_t)handle->device->variant;
	if (type & HITACHI_MASK_PROM_MASK)
	  return mask_prom_init(handle);

	size_t prom_entries = sizeof(prom_table) / sizeof(prom_table[0]);

	if (type >= prom_entries) {
		fprintf(stderr, "Unknown custom protocol 0x%02x\n", type);
		return EXIT_FAILURE;
	}

	uint8_t pin_count = handle->device->package_details.pin_count;

	/* Modify the compare mask according to the chip type */
	handle->device->compare_mask = prom_table[type].compare_mask;

	memset(zif_dir, MP_PIN_DIRECTION_IN, sizeof(zif_dir));
	memset(zif_state, 0x00, sizeof(zif_state));
	memset(pin_drivers, 0x00, sizeof(pin_drivers));

	/* Set address bus direction to output */
	set_io_pins(zif_dir, prom_table[type].addr_bus_pins,
		    MP_PIN_DIRECTION_OUT, pin_count);

	/* Set chip enable pins direction to output */
	set_io_pins(zif_dir, prom_table[type].ce_lo_pins, MP_PIN_DIRECTION_OUT,
		    pin_count);
	set_io_pins(zif_dir, prom_table[type].ce_hi_pins, MP_PIN_DIRECTION_OUT,
		    pin_count);

	/* Set chip enable pins state to disabled */
	set_io_pins(zif_state, prom_table[type].ce_lo_pins, 1, pin_count);
	set_io_pins(zif_state, prom_table[type].ce_hi_pins, 0, pin_count);

	if (minipro_set_zif_direction(handle, zif_dir))
		return EXIT_FAILURE;
	if (minipro_set_zif_state(handle, zif_state))
		return EXIT_FAILURE;

	/* Set all GND and VCC power pins */
	set_pwr_pins(pin_drivers, prom_table[type].gnd_pins, 1, pin_count,
		     GND_PIN);
	set_pwr_pins(pin_drivers, prom_table[type].vcc_pins, 1, pin_count,
		     VCC_PIN);

	/* Now switch the power on. We need to set voltages after any
	 * pin driver settings because the firmware will reset all
	 * voltages to default. */
	if (minipro_set_pin_drivers(handle, pin_drivers))
		return EXIT_FAILURE;
	/* Set VPP and VCC voltages */
	return minipro_set_voltages(handle, handle->device->voltages.vcc,
					    handle->device->voltages.vpp);
}

/* Reset all pin drivers and terminate current session */
int prom_terminate(minipro_handle_t *handle)
{
	return minipro_reset_state(handle);
}

/* Helper function for prom_read - checks whether buffer is empty */
static int is_empty(uint8_t *buffer, size_t length)
{
	for (size_t cur = 0; cur < length; cur++)
		if(buffer[cur] != 0xFF) return 0;
	return 1;
}

/* Read bytes from Hitachi mask PROMs */
static int prom_read_mask_prom(minipro_handle_t *handle, uint32_t address,
	                uint8_t *buffer, size_t length) {
	static uint8_t zif[40];
	uint8_t type = (uint8_t)handle->device->variant & ~HITACHI_MASK_PROM_MASK;
	uint8_t pin_count = handle->device->package_details.pin_count;
	uint8_t ce_pin_count = strlen((const char *) mask_prom_table[type].ce_pins);
	uint8_t cs_pin_count = strlen((const char *) mask_prom_table[type].cs_pins);

	/* Set data bus direction to input with pull-up resistors */
	set_io_pins(zif_dir, mask_prom_table[type].data_bus_pins,
		    MP_PIN_DIRECTION_IN | MP_PIN_PULLUP, pin_count);

	if (minipro_set_zif_direction(handle, zif_dir))
		return EXIT_FAILURE;
	if (minipro_set_zif_state(handle, zif_state))
		return EXIT_FAILURE;

	for (uint8_t ce_bit_pattern = 0; ce_bit_pattern < (1 << ce_pin_count);
		 ce_bit_pattern++) {
	  for (uint8_t cs_bit_pattern = 0; cs_bit_pattern < (1 << cs_pin_count);
		   cs_bit_pattern++) {
		/* Read length bytes */
		for (int i = 0; i < length; i++) {
			/* Set address value to zif pins */
			set_bits(zif_state, mask_prom_table[type].addr_bus_pins,
				 address + i, pin_count);
			set_bits(zif_state, mask_prom_table[type].cs_pins,
					 cs_bit_pattern, pin_count);
			if (minipro_set_zif_state(handle, zif_state))
				return EXIT_FAILURE;

			set_bits(zif_state, mask_prom_table[type].ce_pins,
					 ce_bit_pattern, pin_count);
			if (minipro_set_zif_state(handle, zif_state))
			  return EXIT_FAILURE;

			/* Now read the zif pins */
			if (minipro_get_zif_state(handle, zif))
				return EXIT_FAILURE;

			/* Convert zif data bus value and write it to buffer */
			buffer[i] = get_bits(zif, mask_prom_table[type].data_bus_pins,
					     pin_count);

			set_bits(zif_state, mask_prom_table[type].ce_pins,
					 ~ce_bit_pattern, pin_count);
			if (minipro_set_zif_state(handle, zif_state))
			  return EXIT_FAILURE;
		}

		/* Check if contents are read properly. Necessaray as CS
		 * and CE are mask programmed, and may be active high or
		 * active low */
		if (is_empty(buffer, length) == 0) {
		  return EXIT_SUCCESS;
		}
	  }
	}

	return EXIT_SUCCESS;
}

/* Read bytes from the chip */
int prom_read(minipro_handle_t *handle, uint32_t address, uint8_t *buffer,
	      size_t lenght)
{
	if ((uint8_t)handle->device->variant & HITACHI_MASK_PROM_MASK)
		return prom_read_mask_prom(handle, address, buffer, lenght);

	static uint8_t zif[40];
	uint8_t type = (uint8_t)handle->device->variant;
	uint8_t pin_count = handle->device->package_details.pin_count;

	/* Set data bus direction to input with pull-up resistors */
	set_io_pins(zif_dir, prom_table[type].data_bus_pins,
		    MP_PIN_DIRECTION_IN | MP_PIN_PULLUP, pin_count);

	/* Set chip enable pins state to enabled */
	set_io_pins(zif_state, prom_table[type].ce_lo_pins, 0, pin_count);
	set_io_pins(zif_state, prom_table[type].ce_hi_pins, 1, pin_count);

	if (minipro_set_zif_direction(handle, zif_dir))
		return EXIT_FAILURE;
	if (minipro_set_zif_state(handle, zif_state))
		return EXIT_FAILURE;

	/* Read length bytes */
	for (int i = 0; i < lenght; i++) {
		/* Set address value to zif pins */
		set_bits(zif_state, prom_table[type].addr_bus_pins, address + i,
			 pin_count);
		if (minipro_set_zif_state(handle, zif_state))
			return EXIT_FAILURE;

		/* Now read the zif pins */
		if (minipro_get_zif_state(handle, zif))
			return EXIT_FAILURE;

		/* Convert zif data bus value and write it to buffer */
		buffer[i] = get_bits(zif, prom_table[type].data_bus_pins,
				     pin_count);
	}

	/* Set chip enable pins state to disabled */
	set_io_pins(zif_state, prom_table[type].ce_lo_pins, 1, pin_count);
	set_io_pins(zif_state, prom_table[type].ce_hi_pins, 0, pin_count);
	return minipro_set_zif_state(handle, zif_state);
}
