/*
 * srec.h - Definitions and declarations for dealing with
 * Motorola srec files.
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

#ifndef SREC_H_
#define SREC_H_

#include <stdint.h>

#define SREC_FORMAT 0
#define NOT_SREC    -1

int read_srec_file(uint8_t *buffer, uint8_t *data, size_t *size);
int write_srec_file(FILE *file, uint8_t *data, uint32_t address, size_t size,
		    int write_rec_count);

#endif
