/*
 * database.h - Definitions and declarations for dealing with the
 *		device database.
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

#ifndef __DATABASE_H
#define __DATABASE_H

#include <stdint.h>
#include "minipro.h"

typedef struct fuse {
	uint16_t mask;
	uint16_t def;
	char name[NAME_LEN];
} fuse_t;

typedef struct fuse_decl {
	uint8_t num_fuses;
	uint8_t num_uids; // For PIC only
	uint8_t num_locks;
	uint8_t num_calibytes; // For AVR family only
	uint8_t rev_bits;      // For PIC only
	uint32_t config_addr;  // For PIC only
	uint32_t uid_addr;     // For PIC only
	uint32_t eep_addr;     // For PIC only
	uint8_t osccal_save;   // For PIC only
	uint16_t bg_mask;      // For PIC only
	fuse_t fuse[16];
	fuse_t lock[4];
} fuse_decl_t;

typedef struct gal_config {
	uint8_t fuses_size;    // fuses size in bytes
	uint8_t row_width;     // how many bytes a row have
	uint16_t ues_address;  // user electronic signature address
	uint8_t ues_size;      // ues size in bits
	uint8_t powerdown_row; // row address to disable power down feature
	uint8_t acw_address;   // row address of 'architecture control word'
	uint8_t acw_size;      // acw size in bits
	uint16_t *acw_bits;    // acw bits order
} gal_config_t;

typedef struct pin_map {
	size_t gnd_count;
	size_t mask_count;
	uint16_t gnd_table[16];
	uint16_t mask[40];
} pin_map_t;

typedef struct db_data {
	const char *infoic_path;
	const char *logicic_path;
	const char *device_name;
	uint8_t version;
	uint32_t chip_id;
	uint32_t protocol;
	uint32_t pin_count;
	uint32_t index;
	uint32_t *count;
} db_data_t;

pin_map_t *get_pin_map(db_data_t *);
int print_chip_count(db_data_t *);
int list_devices(db_data_t *);
device_t *get_device_by_name(db_data_t *);
const char *get_device_from_id(db_data_t *);
#endif
