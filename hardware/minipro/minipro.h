/*
 * minipro.h - Low level operations declarations and definitions.
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

#ifndef __MINIPRO_H
#define __MINIPRO_H

#include <stdint.h>
#include <stddef.h>

#define MP_TL866A			   1
#define MP_TL866CS			   2
#define MP_TL866IIPLUS			   5
#define MP_STATUS_NORMAL		   1
#define MP_STATUS_BOOTLOADER		   2

#define MP_CODE				   0x00
#define MP_DATA				   0x01
#define MP_USER				   0x02

#define MP_FUSE_USER			   0x00
#define MP_FUSE_CFG			   0x01
#define MP_FUSE_LOCK			   0x02

// ICSP
#define MP_ICSP_ENABLE			   0x80
#define MP_ICSP_VCC			   0x01

// TSOP48
#define MP_TSOP48_TYPE_V3		   0x00
#define MP_TSOP48_TYPE_NONE		   0x01
#define MP_TSOP48_TYPE_V0		   0x02
#define MP_TSOP48_TYPE_FAKE1		   0x03
#define MP_TSOP48_TYPE_FAKE2		   0x04

#define MP_ID_TYPE1			   0x01
#define MP_ID_TYPE2			   0x02
#define MP_ID_TYPE3			   0x03
#define MP_ID_TYPE4			   0x04
#define MP_ID_TYPE5			   0x05

// Various
#define MP_LITTLE_ENDIAN		   0
#define MP_BIG_ENDIAN			   1

#define MP_ZIF_ONLY			   0x00
#define MP_ZIF_ICSP			   0x01
#define MP_ICSP_ONLY			   0x02
#define MP_READ_ONLY			   0x80

#define MP_MEMORY			   0x01
#define MP_MCU				   0x02
#define MP_PLD				   0x03
#define MP_SRAM				   0x04
#define MP_LOGIC			   0x05
#define MP_NAND				   0x06

// voltage
// for ATF20V10C and ATF16V8C variants
// These flags are in voltages now (ex opts5)
#define LAST_JEDEC_BIT_IS_POWERDOWN_ENABLE (0x1000)
#define POWERDOWN_MODE_DISABLE		   (0x2000)
#define ATF_IN_PAL_COMPAT_MODE		   (0x4000)

// chip_info for PIC family
#define PIC_INSTR_WORD_WIDTH_12		   0x84
#define PIC_INSTR_WORD_WIDTH_14		   0x83
#define PIC_INSTR_WORD_WIDTH_16_PIC18F	   0x82
#define PIC_INSTR_WORD_WIDTH_16_PIC18J	   0x85

// chip_info for Atmel MCU family
#define ATMEL_AVR			   0x81
#define ATMEL_C51			   0x87
#define ATMEL_AT89			   0x88
#define ATMEL_AT90			   0x86

// Custom chip protocols
#define CP_PROM				   0x01

// Adapters
#define TSOP48_ADAPTER			   0x00000001
#define SOP44_ADAPTER			   0x00000002
#define TSOP40_ADAPTER			   0x00000003
#define VSOP40_ADAPTER			   0x00000004
#define TSOP32_ADAPTER			   0x00000005
#define SOP56_ADAPTER			   0x00000006

enum verbosity {
	NO_VERBOSE,
	VERBOSE
};
enum logic {
	LOGIC_0,
	LOGIC_1,
	LOGIC_L,
	LOGIC_H,
	LOGIC_C,
	LOGIC_Z,
	LOGIC_X,
	LOGIC_G,
	LOGIC_V
};

// Helper macros
#define PIN_COUNT(x)	     (((x)&PIN_COUNT_MASK) >> 24)

#define NAME_LEN	     40

#define MP_PIN_DIRECTION_OUT 0x00
#define MP_PIN_DIRECTION_IN  0x01
#define MP_PIN_PULLUP	     0x80

typedef struct flags {
	uint8_t can_erase;
	uint8_t has_chip_id;
	uint8_t has_data_offset;
	uint8_t has_word;
	uint8_t off_protect_before;
	uint8_t protect_after;
	uint8_t lock_bit_write_only;
	uint8_t has_calibration;
	uint8_t prog_support;
	uint8_t word_size;
	uint8_t data_org;
	uint8_t can_adjust_vpp;
	uint8_t can_adjust_vcc;
	uint8_t custom_protocol;
	uint8_t has_power_down;
	uint8_t is_powerdown_disabled;

	uint32_t raw_flags;
} flags_t;

typedef struct package_details {
	uint8_t pin_count;
	uint8_t adapter;
	uint8_t icsp;
	uint32_t packed_package;
} package_details_t;

typedef struct voltages {
	uint8_t vcc;
	uint8_t vdd;
	uint8_t vpp;
	uint32_t raw_voltages;
} voltages_t;

typedef struct pin_driver {
	uint8_t gnd;
	uint8_t vcc;
	uint8_t vpp;
} pin_driver_t;

typedef struct device {
	char name[NAME_LEN];
	uint32_t chip_type;
	uint8_t protocol_id;
	uint32_t variant;
	uint16_t read_buffer_size;
	uint16_t write_buffer_size;
	uint32_t code_memory_size; // Presenting for every device
	uint32_t data_memory_size;
	uint32_t data_memory2_size;
	uint32_t page_size;
	uint32_t pages_per_block; // NAND only
	uint32_t chip_id; // A vendor-specific chip ID (i.e. 0x1E9502 for ATMEGA48)
	uint8_t chip_id_bytes_count;
	voltages_t voltages;
	uint32_t pulse_delay;
	flags_t flags;
	uint32_t chip_info;
	uint32_t pin_map;
	uint16_t compare_mask;
	uint16_t blank_value;
	package_details_t
		package_details; // pins count or image ID for some devices
	void *config; // Configuration bytes that's presenting in some architectures
	uint8_t vector_count;
	uint8_t *vectors;
} device_t;

typedef struct minipro_status {
	uint8_t error;
	uint32_t address;
	uint32_t c1;
	uint32_t c2;
} minipro_status_t;

typedef struct cmdopts_s {
	char *filename;
	char *infoic_path;
	char *logicic_path;
	char *device_name;
	enum {
		UNSPECIFIED = 0,
		CODE,
		DATA,
		CONFIG,
		USER,
		CALIBRATION
	} page;
	enum {
		NO_ACTION = 0,
		READ,
		WRITE,
		ERASE,
		VERIFY,
		BLANK_CHECK,
		LOGIC_IC_TEST
	} action;
	enum {
		NO_FORMAT = 0,
		IHEX,
		SREC
	} format;
	uint8_t no_erase;
	uint8_t protect_off;
	uint8_t protect_on;
	uint8_t size_error;
	uint8_t size_nowarn;
	uint8_t no_verify;
	uint8_t icsp;
	uint8_t idcheck_skip;
	uint8_t idcheck_continue;
	uint8_t idcheck_only;
	uint8_t pincheck;
	uint8_t is_pipe;
	uint8_t version;
	uint8_t force_erase;
	int filter_fuses;
	int filter_locks;
	int filter_uid;
} cmdopts_t;

typedef struct minipro_handle {
	char *model;
	char firmware_str[16];
	char device_code[9];
	char serial_number[25];
	uint32_t firmware;
	uint8_t status;
	uint8_t version;

	device_t *device;
	uint8_t icsp;

	void *usb_handle;
	cmdopts_t *cmdopts;

	int (*minipro_begin_transaction)(struct minipro_handle *);
	int (*minipro_end_transaction)(struct minipro_handle *);
	int (*minipro_protect_off)(struct minipro_handle *);
	int (*minipro_protect_on)(struct minipro_handle *);
	int (*minipro_get_ovc_status)(struct minipro_handle *,
				      struct minipro_status *, uint8_t *);
	int (*minipro_read_block)(struct minipro_handle *, uint8_t, uint32_t,
				  uint8_t *, size_t);
	int (*minipro_write_block)(struct minipro_handle *, uint8_t, uint32_t,
				   uint8_t *, size_t);
	int (*minipro_get_chip_id)(struct minipro_handle *, uint8_t *,
				   uint32_t *);
	int (*minipro_spi_autodetect)(struct minipro_handle *, uint8_t,
				      uint32_t *);
	int (*minipro_read_fuses)(struct minipro_handle *, uint8_t, size_t,
				  uint8_t, uint8_t *);
	int (*minipro_write_fuses)(struct minipro_handle *, uint8_t, size_t,
				   uint8_t, uint8_t *);
	int (*minipro_read_calibration)(struct minipro_handle *, uint8_t *,
					size_t);
	int (*minipro_erase)(struct minipro_handle *);
	int (*minipro_unlock_tsop48)(struct minipro_handle *, uint8_t *);
	int (*minipro_hardware_check)(struct minipro_handle *);
	int (*minipro_write_jedec_row)(struct minipro_handle *, uint8_t *,
				       uint8_t, uint8_t, size_t);
	int (*minipro_read_jedec_row)(struct minipro_handle *, uint8_t *,
				      uint8_t, uint8_t, size_t);
	int (*minipro_firmware_update)(struct minipro_handle *, const char *);
	int (*minipro_pin_test)(struct minipro_handle *);
	int (*minipro_logic_ic_test)(struct minipro_handle *);
	int (*minipro_reset_state)(struct minipro_handle *);
	int (*minipro_set_zif_direction)(struct minipro_handle *, uint8_t *);
	int (*minipro_set_zif_state)(struct minipro_handle *, uint8_t *);
	int (*minipro_get_zif_state)(struct minipro_handle *, uint8_t *);
	int (*minipro_set_pin_drivers)(struct minipro_handle *,
				       struct pin_driver *);
	int (*minipro_set_voltages)(struct minipro_handle *, uint8_t, uint8_t);
} minipro_handle_t;

// These are old byte_utils functions
void format_int(uint8_t *out, uint32_t in, size_t size, uint8_t endianness);
uint32_t load_int(uint8_t *buffer, size_t size, uint8_t endianness);

// Helper functions
void minipro_print_system_info(minipro_handle_t *handle);
uint32_t crc32(uint8_t *data, size_t size, uint32_t initial);
int minipro_reset(minipro_handle_t *handle);
int minipro_get_devices_count(uint8_t version);

/*
 * Standard interface functions compatible with both TL866A/TL866II+
 * programmers. High level logic should include this file not the
 * tl866a.h/tl866iiplus.h device specific headers. These functions will return 0
 * on success and 1 on failure. This way we always return the success status to
 * the higher logic routines to exit cleanly leaving the device in a clean
 * state.
 */
minipro_handle_t *minipro_open(uint8_t verbose);
void minipro_close(minipro_handle_t *handle);
int minipro_begin_transaction(minipro_handle_t *handle);
int minipro_end_transaction(minipro_handle_t *handle);
int minipro_protect_off(minipro_handle_t *handle);
int minipro_protect_on(minipro_handle_t *handle);
int minipro_get_ovc_status(minipro_handle_t *handle, minipro_status_t *status,
			   uint8_t *ovc);
int minipro_read_block(minipro_handle_t *handle, uint8_t type, uint32_t addr,
		       uint8_t *buffer, size_t len);
int minipro_write_block(minipro_handle_t *handle, uint8_t type, uint32_t addr,
			uint8_t *bufffer, size_t len);
int minipro_get_chip_id(minipro_handle_t *handle, uint8_t *type,
			uint32_t *device_id);
int minipro_spi_autodetect(minipro_handle_t *handle, uint8_t type,
			   uint32_t *device_id);
int minipro_read_fuses(minipro_handle_t *handle, uint8_t type, size_t length,
		       uint8_t items_count, uint8_t *buffer);
int minipro_write_fuses(minipro_handle_t *handle, uint8_t type, size_t length,
			uint8_t items_count, uint8_t *buffer);
int minipro_read_calibration(minipro_handle_t *handle, uint8_t *buffer,
			     size_t size);
int minipro_write_jedec_row(minipro_handle_t *handle, uint8_t *buffer,
			    uint8_t row, uint8_t flags, size_t size);
int minipro_read_jedec_row(minipro_handle_t *handle, uint8_t *buffer,
			   uint8_t row, uint8_t flags, size_t size);
int minipro_erase(minipro_handle_t *handle);
int minipro_unlock_tsop48(minipro_handle_t *handle, uint8_t *status);
int minipro_hardware_check(minipro_handle_t *handle);
int minipro_firmware_update(minipro_handle_t *handle, const char *firmware);
int minipro_pin_test(minipro_handle_t *handle);
int minipro_logic_ic_test(minipro_handle_t *handle);
#endif
