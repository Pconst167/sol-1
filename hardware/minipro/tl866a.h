/*
 * tl866a.h - Low level ops for TL866A/CS declarations and definations
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

#ifndef __TL866A_H
#define __TL866A_H

/*
 * This header only contains low-level wrappers against typical requests.
 * Please refer main.c if you're looking for higher-level logic.
 */

/*
 * These are the known firmware versions along with the versions of the
 * official software from whence they came.
 *
 * Firmware	Official	Release		Firmware
 * Version	Program		Date		Version
 * String	Version				ID
 *
 * 3.2.86	6.85		Oct 19, 2018	0x0256
 * 3.2.85	6.82		Jul 14, 2018	0x0255
 * 3.2.82	6.71		Apr 17, 2018	0x0252
 * 3.2.81	6.70		Mar  7, 2018	0x0251
 * 3.2.80	6.60		May  9, 2017	0x0250
 * 3.2.72	6.50		Dec 25, 2015	0x0248
 * 3.2.69	6.17		Jul 11, 2015	0x0245
 * 3.2.68	6.16		Jun 12, 2015	0x0244
 * 3.2.66	6.13		Jun  9, 2015	0x0242
 * 3.2.63	6.10		Jul 16, 2014	0x023f
 * 3.2.62	6.00		Jan  7, 2014	0x023e
 * 3.2.61	5.91		Mar  9, 2013	0x023d
 * 3.2.60	5.90		Mar  4, 2013	0x023c
 * 3.2.59	5.80		Nov  1, 2012	0x023b
 * 3.2.58	5.71		Aug 31, 2012	0x023a
 * 3.2.57	5.70		Aug 27, 2012	0x0239
 * 3.2.56	5.60		Jun 12, 2012	0x0238
 * 3.2.51	4.95		Mar 31, 2012	0x0233
 *		1.00		Jun 18, 2010
 *
 */

#define TL866A_FIRMWARE_VERSION 0x0256
#define TL866A_FIRMWARE_STRING	"03.2.86"

// TL866A/CS low level functions.
int tl866a_begin_transaction(minipro_handle_t *handle);
int tl866a_end_transaction(minipro_handle_t *handle);
int tl866a_protect_off(minipro_handle_t *handle);
int tl866a_protect_on(minipro_handle_t *handle);
int tl866a_get_ovc_status(minipro_handle_t *handle, minipro_status_t *status,
			  uint8_t *ovc);
int tl866a_read_block(minipro_handle_t *handle, uint8_t type, uint32_t addr,
		      uint8_t *buffer, size_t len);
int tl866a_write_block(minipro_handle_t *handle, uint8_t type, uint32_t addr,
		       uint8_t *buffer, size_t len);
int tl866a_get_chip_id(minipro_handle_t *handle, uint8_t *type,
		       uint32_t *device_id);
int tl866a_spi_autodetect(minipro_handle_t *handle, uint8_t type,
			  uint32_t *device_id);
int tl866a_read_fuses(minipro_handle_t *handle, uint8_t type, size_t size,
		      uint8_t items_count, uint8_t *buffer);
int tl866a_write_fuses(minipro_handle_t *handle, uint8_t type, size_t size,
		       uint8_t items_count, uint8_t *buffer);
int tl866a_read_calibration(minipro_handle_t *handle, uint8_t *buffer,
			    size_t len);
int tl866a_erase(minipro_handle_t *handle);
int tl866a_unlock_tsop48(minipro_handle_t *handle, uint8_t *status);
int tl866a_hardware_check(minipro_handle_t *handle);
int tl866a_write_jedec_row(minipro_handle_t *handle, uint8_t *buffer,
			   uint8_t row, uint8_t flags, size_t size);
int tl866a_read_jedec_row(minipro_handle_t *handle, uint8_t *buffer,
			  uint8_t row, uint8_t flags, size_t size);
int tl866a_firmware_update(minipro_handle_t *handle, const char *firmware);
int tl866a_logic_ic_test(minipro_handle_t *handle);
int tl866a_reset_state(minipro_handle_t *);
int tl866a_set_zif_direction(struct minipro_handle *, uint8_t *);
int tl866a_set_zif_state(struct minipro_handle *, uint8_t *);
int tl866a_get_zif_state(struct minipro_handle *, uint8_t *);
int tl866a_set_pin_drivers(struct minipro_handle *, pin_driver_t *);
int tl866a_set_voltages(struct minipro_handle *, uint8_t, uint8_t);
#endif
