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

/* InfoIc2 algorithms defines */
#define IC2_ALG_NONE		0x00
#define IC2_ALG_IIC24C		0X01
#define IC2_ALG_MW93ALG		0X02
#define IC2_ALG_SPI25F_1	0X03
#define IC2_ALG_AT45D		0X04
#define IC2_ALG_F29EE		0X05
#define IC2_ALG_W29F32P		0X06
#define IC2_ALG_ROM28P_1	0X07
#define IC2_ALG_ROM32P		0X08
#define IC2_ALG_ROM40P		0X09
#define IC2_ALG_R28TO32P	0X0A
#define IC2_ALG_ROM24P_1	0X0B
#define IC2_ALG_ROM44		0X0C
#define IC2_ALG_EE28C32P	0X0D
#define IC2_ALG_RAM32_1		0X0E
#define IC2_ALG_SPI25F 		0X0F
#define IC2_ALG_28F32P		0X10
#define IC2_ALG_FWH			0X11
#define IC2_ALG_T48			0X12
#define IC2_ALG_T40A		0X13
#define IC2_ALG_T40B		0X14
#define IC2_ALG_T88V		0X15
#define IC2_ALG_PIC32X_1	0X16
#define IC2_ALG_P18F87J		0X17
#define IC2_ALG_P16F		0X18
#define IC2_ALG_P18F2		0X19
#define IC2_ALG_P16F5X		0X1A
#define IC2_ALG_P16CX		0X1B
#define IC2_ALG_PIC16C		0X1C
#define IC2_ALG_ATMGA		0X1D
#define IC2_ALG_ATTINY		0X1E
#define IC2_ALG_AT89P20		0X1F
#define IC2_ALG_SM89		0X20
#define IC2_ALG_AT89C		0X21
#define IC2_ALG_P87C		0X22
#define IC2_ALG_SST89		0X23
#define IC2_ALG_W78E		0X24
#define IC2_ALG_SM59		0X25
#define IC2_ALG_SM39		0X26
#define IC2_ALG_ROM24P_2	0X27
#define IC2_ALG_ROM28P_2	0X28
#define IC2_ALG_RAM32_2		0X29
#define IC2_ALG_GAL16		0X2A
#define IC2_ALG_GAL20		0X2B
#define IC2_ALG_GAL22		0X2C
#define IC2_ALG_NAND		0X2D
#define IC2_ALG_PIC32X_2	0X2E
#define IC2_ALG_RAM36		0X2F
#define IC2_ALG_KB90		0X30
#define IC2_ALG_EMMC		0X31
#define IC2_ALG_VGA			0X32
#define IC2_ALG_CPLD		0X33
#define IC2_ALG_GEN			0X34
#define IC2_ALG_ITE			0X35

/* T56 Utility algorithms defines */
#define UTIL_ALG_TTL1			0x00
#define UTIL_ALG_TTL2			0x01
#define UTIL_ALG_PINDECT100M	0x02
#define UTIL_ALG_STGND			0x03
#define UTIL_ALG_STPVGI			0x04
#define UTIL_ALG_UART_VGA		0x05
#define UTIL_ALG_VGA_11			0x06
#define UTIL_ALG_VGA_21			0x07
#define UTIL_ALG_VGA1024x768	0x08
#define UTIL_ALG_VGA1152x864	0x09
#define UTIL_ALG_VGA1280x1024	0x0A
#define UTIL_ALG_VGA1280x800	0x0B
#define UTIL_ALG_VGA1440x900	0x0C
#define UTIL_ALG_VGA1920x1080	0x0D
#define UTIL_ALG_VGA640x480		0x0E
#define UTIL_ALG_VGA800x600		0x0F
#define UTIL_ALG_VGA_HDMI		0x10

typedef struct fuse {
	uint16_t mask;
	uint16_t def;
	char name[NAME_LEN];
} fuse_t;

typedef struct fuse_decl {
	uint8_t num_fuses;
	uint8_t num_uids;	/* For PIC only */
	uint8_t num_locks;
	uint8_t num_calibytes;	/* For AVR family only */
	uint8_t rev_bits;	/* For PIC only */
	uint32_t config_addr;	/* For PIC only */
	uint32_t uid_addr;	/* For PIC only */
	uint32_t eep_addr;	/* For PIC only */
	uint8_t osccal_save;	/* For PIC only */
	uint16_t bg_mask;	/* For PIC only */
	fuse_t fuse[16];
	fuse_t lock[4];
} fuse_decl_t;

typedef struct gal_config {
	uint8_t fuses_size;	/* fuses size in bytes */
	uint8_t row_width;	/* how many bytes a row have */
	uint16_t ues_address;	/* user electronic signature address */
	uint8_t ues_size;	/* ues size in bits */
	uint8_t powerdown_row;	/* row address to disable power down feature */
	uint8_t acw_address;	/* row address of 'architecture control word' */
	uint8_t acw_size;	/* acw size in bits */
	uint16_t *acw_bits;	/* acw bits order */
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
	const char *algo_path;
	const char *device_name;
	uint8_t version;
	uint32_t chip_id;
	uint32_t protocol;
	uint32_t pin_count;
	uint32_t index;
	uint32_t *count;
} db_data_t;

pin_map_t *get_pin_map(db_data_t *);
int get_algorithm(device_t *, const char *, uint8_t, uint8_t, size_t);
int print_chip_count(db_data_t *);
int list_devices(db_data_t *);
device_t *get_device_by_name(db_data_t *);
const char *get_device_from_id(db_data_t *);
#endif
