/*
 * jedec.h - Definitions and declarations for dealing with the
 *		jedec files.
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

#ifndef JEDEC_H_
#define JEDEC_H_

#include <stdint.h>

typedef struct jedec_s {
	const char *device_name;     // Device name
	uint8_t F;		     // Unlisted fuses value (0-1)
	uint8_t G;		     // Security Fuse
	uint16_t QF;		     // How many fuses in the JEDEC file are
	uint8_t QP;		     // Number of pins
	uint16_t C;		     // declared fuses checksum
	uint16_t fuse_checksum;	     // calculated fuses checksum
	uint16_t calc_file_checksum; // calculated file checksum
	uint16_t decl_file_checksum; // declared file checksum
	uint8_t *fuses;		     // Fuses array
} jedec_t;

int read_jedec_file(char *buffer, size_t size, jedec_t *jedec);
int write_jedec_file(FILE *file, jedec_t *jedec);

#endif /* JEDEC_H_ */
