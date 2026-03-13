/*
 * t48.h - Low level ops for TL48 declarations and definitions
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

#ifndef __T48_H
#define __T48_H

#define T48_FIRMWARE_VERSION 0x120
#define T48_FIRMWARE_STRING  "01.1.32"

/* T48 low level functions. */
int t48_begin_transaction(minipro_handle_t *handle);
int t48_end_transaction(minipro_handle_t *handle);
int t48_read_block(minipro_handle_t *handle, uint8_t type,
			   uint32_t addr, uint8_t *buffer, size_t len);
int t48_write_block(minipro_handle_t *handle, uint8_t type,
			    uint32_t addr, uint8_t *buffer, size_t len);
int t48_get_ovc_status(minipro_handle_t *handle,
			       minipro_status_t *status, uint8_t *ovc);
int t48_get_chip_id(minipro_handle_t *handle, uint8_t *type,
			    uint32_t *device_id);
int t48_spi_autodetect(minipro_handle_t *handle, uint8_t type,
			       uint32_t *device_id);
int t48_read_fuses(minipro_handle_t *handle, uint8_t type, size_t size,
			   uint8_t items_count, uint8_t *buffer);
int t48_write_fuses(minipro_handle_t *handle, uint8_t type, size_t size,
			    uint8_t items_count, uint8_t *buffer);
int t48_protect_off(minipro_handle_t *handle);
int t48_protect_on(minipro_handle_t *handle);
int t48_erase(minipro_handle_t *handle);
int t48_write_jedec_row(minipro_handle_t *handle, uint8_t *buffer, uint8_t row,
			uint8_t flags, size_t size);
int t48_read_jedec_row(minipro_handle_t *handle, uint8_t *buffer,
			       uint8_t row, uint8_t flags, size_t size);
int t48_logic_ic_test(minipro_handle_t *handle);
int t48_firmware_update(minipro_handle_t *handle, const char *firmware);

int t48_reset_state(minipro_handle_t *handle);
int t48_set_zif_direction(minipro_handle_t *handle, uint8_t *zif);
int t48_set_zif_state(minipro_handle_t *handle, uint8_t *zif);
int t48_get_zif_state(minipro_handle_t *handle, uint8_t *zif);
int t48_set_pin_drivers(minipro_handle_t *handle, pin_driver_t *pins);
int t48_set_voltages(minipro_handle_t *handle, uint8_t vcc, uint8_t vpp);


int t48_set_input_and_pullup(minipro_handle_t *handle);
int t48_set_input_and_pulldown(minipro_handle_t *handle);

int t48_hardware_check(minipro_handle_t *handle);

#endif
