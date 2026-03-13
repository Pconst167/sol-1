/*
 * usb.h - Low level USB declarations *nix libusb implementation
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

#ifndef USB_H_
#define USB_H_

#include <stdint.h>

void *usb_open(uint8_t verbose);
int usb_close(void *usb_handle);
int minipro_get_devices_count(uint8_t version);

int msg_send(void *handle, uint8_t *buffer, size_t size);
int msg_recv(void *handle, uint8_t *buffer, size_t size);
int write_payload(void *handle, uint8_t *buffer, size_t length);
int read_payload(void *handle, uint8_t *buffer, size_t length);
#endif
