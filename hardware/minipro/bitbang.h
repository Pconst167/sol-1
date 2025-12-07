/*
 * bitbang.h - bit-banging declarations and definitions.
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

#ifndef BITBANG_H_
#define BITBANG_H_

enum pwr_pin_type {
	GND_PIN,
	VCC_PIN,
	VPP_PIN
};

// Bit-banging functions
int bb_begin_transaction(minipro_handle_t *);
int bb_end_transaction(minipro_handle_t *);
int bb_read_block(minipro_handle_t *, uint8_t, uint32_t, uint8_t *, size_t);
int bb_write_block(minipro_handle_t *, uint8_t, uint32_t, uint8_t *, size_t);
int bb_read_fuses(minipro_handle_t *, uint8_t, size_t, uint8_t, uint8_t *);
int bb_write_fuses(minipro_handle_t *, uint8_t, size_t, uint8_t, uint8_t *);
int bb_read_calibration(minipro_handle_t *, uint8_t *, size_t);
int bb_get_chip_id(minipro_handle_t *, uint32_t *);
int bb_spi_autodetect(minipro_handle_t *, uint8_t, uint32_t *);
int bb_protect_off(minipro_handle_t *);
int bb_protect_on(minipro_handle_t *);
int bb_erase(minipro_handle_t *);
int bb_write_jedec_row(minipro_handle_t *, uint8_t *, uint8_t, uint8_t, size_t);
int bb_read_jedec_row(minipro_handle_t *, uint8_t *, uint8_t, uint8_t, size_t);

// Helper functions
void set_io_pins(uint8_t *, uint8_t *, uint8_t, uint8_t);
void set_pwr_pins(pin_driver_t *, uint8_t *, uint8_t, uint8_t, uint8_t);
void set_bits(uint8_t *, uint8_t *, uint32_t, uint8_t);
uint32_t get_bits(uint8_t *, uint8_t *, uint8_t);

#endif
