/*
 * ihex.c - Functions for dealing with intel hex files.
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

#include <ctype.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ihex.h"

#define MIN_RECORD_SIZE 11
#define ROW_SIZE	16

typedef enum {
	IHEX_DATA = 0,
	IHEX_EOF,
	IHEX_ESA,
	IHEX_SSA,
	IHEX_ELA,
	IHEX_SLA
} Rectype;

typedef enum {
	NO_ERROR = 0,
	BAD_FORMAT,
	BAD_RECORD,
	BAD_CKECKSUM,
	BAD_COUNT,
} Result;

typedef struct {
	uint16_t address;
	uint8_t count;
	Rectype type;
	Result result;
	uint8_t data[255];
} record_t;

// Convert an ascii hex character
static uint8_t hex(const char hex)
{
	if (hex >= '0' && hex <= '9')
		return hex - '0';
	else if (hex >= 'A' && hex <= 'F')
		return hex - 'A' + 10;
	else if (hex >= 'a' && hex <= 'f')
		return hex - 'a' + 10;
	else
		return 0xff;
}

// Parse a record
static record_t parse_record(uint8_t *record)
{
	record_t rec;
	size_t i;
	// Check for start code
	if (record[0] != ':') {
		rec.result = BAD_FORMAT;
		return rec;
	}

	// Check for valid characters
	for (i = 1; record[i] != '\r' && record[i] != '\n'; i++) {
		if (hex(record[i]) > 0x0F) {
			rec.result = BAD_FORMAT;
			return rec;
		}
	}

	// Get the count field
	rec.count = (hex(record[1]) << 4) | hex(record[2]);
	if (i < rec.count * 2 + MIN_RECORD_SIZE) {
		rec.result = BAD_COUNT;
		return rec;
	}

	// Get the record address
	rec.address = (hex(record[3]) << 12) | (hex(record[4]) << 8) |
		      (hex(record[5]) << 4) | hex(record[6]);

	// Get the record type
	rec.type = (hex(record[7]) << 4) | hex(record[8]);
	if (rec.type > IHEX_SLA) {
		rec.result = BAD_RECORD;
		return rec;
	}

	// Calculate checksum and copy data bytes
	uint8_t checksum_c = rec.count + (rec.address >> 8) +
			     (rec.address & 0xFF) + rec.type;
	for (i = 0; i < rec.count; i++) {
		rec.data[i] = (hex(record[i * 2 + 9]) << 4) |
			      hex(record[i * 2 + 10]);
		checksum_c += rec.data[i];
	}
	checksum_c = ~checksum_c + 1;
	uint8_t checksum_f = (hex(record[rec.count * 2 + 9]) << 4) |
			     hex(record[rec.count * 2 + 10]);
	if (checksum_c != checksum_f) {
		rec.result = BAD_CKECKSUM;
		return rec;
	}
	rec.result = NO_ERROR;
	return rec;
}

// Write a record
static int write_record(FILE *file, record_t *record)
{
	uint8_t checksum = record->count + (uint8_t)record->address +
			   (uint8_t)(record->address >> 8) + record->type;
	uint8_t *pData = record->data;
	fprintf(file, ":%02X%04X%02X", record->count, record->address,
		record->type);
	while (record->count--) {
		fprintf(file, "%02X", *pData);
		checksum += *pData;
		pData++;
	}
	checksum = ~checksum + 1;
	fprintf(file, "%02X\r\n", checksum);
	return EXIT_SUCCESS;
}

// Read an Intel hex file
int read_hex_file(uint8_t *buffer, uint8_t *data, size_t *size)
{
	uint32_t line = 0, uba = 0;
	record_t rec;
	uint8_t eof = 0;

	size_t chip_size = *size;
	while (buffer) {
		// Skip empty lines
		line++;
		if (*buffer == '\r' || *buffer == '\n') {
			buffer++;
			continue;
		}

		rec = parse_record(buffer);
		switch (rec.result) {
		case BAD_FORMAT:
			return NOT_IHEX;
		case BAD_RECORD:
			fprintf(stderr, "Error on line %u: bad record type.\n",
				line);
			return EXIT_FAILURE;
		case BAD_COUNT:
			fprintf(stderr, "Error on line %u: bad count.\n", line);
			return EXIT_FAILURE;
		case BAD_CKECKSUM:
			fprintf(stderr, "Error on line %u: bad checksum.\n",
				line);
			return EXIT_FAILURE;
		default:
			if (rec.type != IHEX_EOF && eof) {
				fprintf(stderr,
					"Error on line %u: wrong record after end of file .\n",
					line);
			}
			switch (rec.type) {
			case IHEX_DATA:
				// If file data size is bigger than chip size
				// update the new size
				if (chip_size >= uba + rec.address + rec.count)
					// copy record data
					memcpy(&(data[uba + rec.address]),
					       rec.data, rec.count);
				//else
				//*size = (uba + rec.address + rec.count);
				break;
			case IHEX_EOF:
				if (eof) {
					fprintf(stderr,
						"Error on line %u: wrong end of file record.\n",
						line);
					return EXIT_FAILURE;
				}
				eof = 1;
				break;
				// Calculate the upper block address from a segment address
			case IHEX_ESA:
				uba = ((rec.data[0] << 12) |
				       (rec.data[1] << 4));
				break;
				// Calculate the upper block address from an extended linear address
			case IHEX_ELA:
				uba = ((rec.data[0] << 24) | rec.data[1] << 16);
				break;
				// Load a segmented address
			case IHEX_SSA:
				uba = ((rec.data[0] << 12) |
				       (rec.data[1] << 4)) +
				      ((rec.data[2] << 8) | rec.data[3]);
				break;
				// Load a linear address
			case IHEX_SLA:
				uba = ((rec.data[0] << 24) |
				       (rec.data[1] << 16) |
				       (rec.data[2] << 8) | rec.data[3]);
				break;
			default:
				fprintf(stderr,
					"Error on line %u: unknown record type.\n",
					line);
				return EXIT_FAILURE;
			}
		}
		buffer = (uint8_t *)strchr((char *)++buffer, ':');
	}
	if (!eof) {
		fprintf(stderr, "Error: no end of file record found.\n");
		return EXIT_FAILURE;
	}
	return INTEL_HEX_FORMAT;
}

// Write an Intel hex file
int write_hex_file(FILE *file, uint8_t *data, uint16_t address, size_t size,
		   int write_eof)
{
	record_t rec;
	uint16_t uba = 0;
	size_t len;

	// if size > 64K insert an extended linear address record
	memset(rec.data, 0x00, sizeof(rec.data));
	if (size > 65536) {
		rec.type = IHEX_ELA;
		rec.count = 0x02;
		rec.address = 0x00;
		write_record(file, &rec);
	}

	while (size) {
		// Write data
		len = (size > ROW_SIZE ? ROW_SIZE : size);
		rec.type = IHEX_DATA;
		rec.count = len;
		rec.address = address;
		memcpy(rec.data, data, len);
		write_record(file, &rec);
		data += ROW_SIZE;
		size -= len;
		address += ROW_SIZE;

		// Insert an extended linear address record
		if (!address && size) {
			uba++;
			rec.type = IHEX_ELA;
			rec.count = 0x02;
			rec.address = 0x00;
			rec.data[0] = (uint8_t)uba << 8;
			rec.data[1] = (uint8_t)uba;
			write_record(file, &rec);
		}
	}

	// Insert EOF record if requested
	if (write_eof) {
		rec.type = IHEX_EOF;
		rec.count = 0x00;
		rec.address = 0x00;
		write_record(file, &rec);
	}
	return EXIT_SUCCESS;
}
