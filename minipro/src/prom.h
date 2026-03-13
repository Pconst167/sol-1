/*
 * prom.h - bipolar prom custom algorithm definitions
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

#ifndef PROM_H_
#define PROM_H_

int prom_init(minipro_handle_t *);
int prom_terminate(minipro_handle_t *);
int prom_read(minipro_handle_t *, uint32_t, uint8_t *, size_t);

#endif /* PROM_H_ */
