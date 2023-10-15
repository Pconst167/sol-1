/*
 * tl866plus.h - Low level ops for TL866II+ declarations and definitions
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

#ifndef __TL866IIPLUS_H
#define __TL866IIPLUS_H

#define TL866IIPLUS_FIRMWARE_VERSION 0x284
#define TL866IIPLUS_FIRMWARE_STRING  "04.2.132"

// TL866II+ low level functions.
int tl866iiplus_begin_transaction(minipro_handle_t *handle);
int tl866iiplus_end_transaction(minipro_handle_t *handle);
int tl866iiplus_read_block(minipro_handle_t *handle, uint8_t type,
			   uint32_t addr, uint8_t *buffer, size_t len);
int tl866iiplus_write_block(minipro_handle_t *handle, uint8_t type,
			    uint32_t addr, uint8_t *buffer, size_t len);
int tl866iiplus_protect_off(minipro_handle_t *handle);
int tl866iiplus_protect_on(minipro_handle_t *handle);
int tl866iiplus_get_ovc_status(minipro_handle_t *handle,
			       minipro_status_t *status, uint8_t *ovc);
int tl866iiplus_get_chip_id(minipro_handle_t *handle, uint8_t *type,
			    uint32_t *device_id);
int tl866iiplus_spi_autodetect(minipro_handle_t *handle, uint8_t type,
			       uint32_t *device_id);
int tl866iiplus_read_fuses(minipro_handle_t *handle, uint8_t type, size_t size,
			   uint8_t items_count, uint8_t *buffer);
int tl866iiplus_write_fuses(minipro_handle_t *handle, uint8_t type, size_t size,
			    uint8_t items_count, uint8_t *buffer);
int tl866iiplus_read_calibration(minipro_handle_t *handle, uint8_t *buffer,
				 size_t len);
int tl866iiplus_erase(minipro_handle_t *handle);
int tl866iiplus_unlock_tsop48(minipro_handle_t *handle, uint8_t *status);
int tl866iiplus_write_jedec_row(minipro_handle_t *handle, uint8_t *buffer,
				uint8_t row, uint8_t flags, size_t size);
int tl866iiplus_read_jedec_row(minipro_handle_t *handle, uint8_t *buffer,
			       uint8_t row, uint8_t flags, size_t size);
int tl866iiplus_hardware_check(minipro_handle_t *handle);
int tl866iiplus_firmware_update(minipro_handle_t *handle, const char *firmware);
int tl866iiplus_pin_test(minipro_handle_t *handle);
int tl866iiplus_logic_ic_test(minipro_handle_t *handle);
int tl866iiplus_reset_state(minipro_handle_t *);
int tl866iiplus_set_zif_direction(struct minipro_handle *, uint8_t *);
int tl866iiplus_set_zif_state(struct minipro_handle *, uint8_t *);
int tl866iiplus_get_zif_state(struct minipro_handle *, uint8_t *);
int tl866iiplus_set_pin_drivers(struct minipro_handle *, pin_driver_t *);
int tl866iiplus_set_voltages(struct minipro_handle *, uint8_t, uint8_t);
#endif
