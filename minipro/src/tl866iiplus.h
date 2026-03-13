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

/*
 * These are the known firmware versions along with the versions of the
 * official software from whence they came displayed in reverse
 * chronological order.  Firmware versions generally progress
 * sequentially and are not always updated with each release of the
 * official program.  Some firmware versions may have appeared first in
 * program versions earlier than listed here because they are yet
 * unknown, missing, or lost.
 *
 * Firmware	Official  Release	Firmware  Notes
 * Version	Program   Date		Version
 * String	Version			ID
 *
 * 4.2.132	12.20	Sep 21, 2022	0x284
 * 4.2.131	12.15	Aug 19, 2022	0x283
 * 4.2.130	12.11	Aug  3, 2022	0x282
 * 4.2.129	12.01	Jun 14, 2022	0x281
 * 4.2.128	11.60	Nov  4, 2021	0x280
 * 4.2.127	11.50	Oct 17, 2021	0x27f
 * 4.2.126	11.00	Jun  4, 2021	0x27e
 * 4.2.125	10.90	Apr 24, 2021	0x27d
 * 4.2.124	10.75	Jan 28, 2021	0x27c
 * 4.2.123	10.50	Nov 11, 2020	0x27b
 * 4.2.122	10.41	Oct 10, 2020	0x27a
 * 4.2.121	10.39	Oct  4, 2020	0x279	CRC Error in archive
 * 4.2.120	10.37	Sep  9, 2020	0x278
 * 4.2.119	10.33	Sep  2, 2020	0x277
 * 4.2.118	10.31	Aug 19, 2020	0x276
 * 4.2.117	10.27	Jul 23, 2020	0x275	CRC error in archive
 * 4.2.116	10.22	Jul  8, 2020	0x274
 * 4.2.115	10.19	Jun 28, 2020	0x273
 * 4.2.114	10.15	Jun  6, 2020	0x272
 * 4.2.113	10.14	??? ??, 2020	0x271	Lost?
 * 4.2.112	10.12	Apr 24, 2020	0x270
 * 4.2.111	10.05	Mar 26, 2020	0x26f
 * 4.2.110	9.16	Jan 10, 2020	0x26e
 * 4.2.109	9.00	Oct 10, 2019	0x26d
 * 4.2.105	8.51	May 14, 2019	0x269
 * 4.2.104	8.??	??? ??, 2019	0x268	Lost?
 * 4.2.103	8.33	Mar 25, 2019	0x267
 * 4.2.102	8.??	??? ??, 2019	0x266	Lost?
 * 4.2.101	8.30	Jan 21, 2019	0x265
 * 4.2.100	8.??	??? ??, 2019	0x264	Lost?
 * 4.2.99	8.11	Nov 16, 2018	0x263
 * 4.2.98	8.08	Oct 30, 2018	0x262
 * 4.2.97	8.07	Oct 23, 2018	0x261
 * 4.2.96	8.05	Oct 20, 2018	0x260
 * 4.2.95	8.02	Oct 16, 2018	0x25f
 * 4.2.94	8.01	Oct  9, 2018	0x25e
 * 4.2.93	8.00	Sep 29, 2018	0x25d
 * 4.2.92	7.35	Aug 23, 2018	0x25c
 * 4.2.91	7.32	Jul 17, 2018	0x25b
 * 4.2.90	7.30	Jun 29, 2018	0x25a
 * 4.2.89	7.22	Jun  4, 2018	0x259
 * 4.2.88	7.21	May 15, 2018	0x258
 * 4.2.87	7.11	Apr 17, 2018	0x257
 * 4.2.86	7.10	Apr  8, 2018	0x256
 * 4.2.85	7.08	Mar 29, 2018	0x255
 * 4.2.84	7.07	Mar 17, 2018	0x254	Big jump in sequence
 * 4.1.1	7.03	Feb 26, 2018	0x201	First known firmware
 *
 */

#define TL866IIPLUS_FIRMWARE_VERSION 0x284
#define TL866IIPLUS_FIRMWARE_STRING  "04.2.132"

/* TL866II+ low level functions. */
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
