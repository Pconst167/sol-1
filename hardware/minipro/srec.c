/*
 * srec.c - Functions for dealing with Motorola srec files.
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
#include "srec.h"

#define MIN_RECORD_SIZE 4
#define ROW_SIZE	16

typedef enum {
	S0 = 0,
	S1,
	S2,
	S3,
	S4,
	S5,
	S6,
	S7,
	S8,
	S9
} Rectype;

typedef enum {
	NO_ERROR = 0,
	BAD_FORMAT,
	BAD_RECORD,
	BAD_CKECKSUM,
	BAD_COUNT,
} Result;

typedef struct {
	uint32_t address;
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
	uint8_t byte_count;
	// Check for start code
	if (record[0] != 'S') {
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

	// Get the record type
	rec.type = (hex(record[1]));
	if (rec.type > S9) {
		rec.result = BAD_RECORD;
		return rec;
	}
	// Get the count field
	byte_count = (hex(record[2]) << 4) | hex(record[3]);
	if (i < byte_count * 2 + MIN_RECORD_SIZE) {
		rec.result = BAD_COUNT;
		return rec;
	}

	// Get the record address
	switch (rec.type) {
	case S0:
		rec.address = 0;
		rec.count = byte_count - 3;
		break;
	case S1:
	case S5:
	case S9:
		// Four hex digits address
		rec.address = (hex(record[4]) << 12) | (hex(record[5]) << 8) |
			      (hex(record[6]) << 4) | hex(record[7]);
		rec.count = byte_count - 3;
		break;
	case S2:
	case S6:
	case S8:
		// Six hex digits address
		rec.address = (hex(record[4]) << 20) | (hex(record[5]) << 16) |
			      (hex(record[6]) << 12) | (hex(record[7]) << 8) |
			      (hex(record[8]) << 4) | hex(record[9]);
		rec.count = byte_count - 4;
		break;
	case S3:
	case S7:
		// Eight hex digits address
		rec.address = (hex(record[4]) << 28) | (hex(record[5]) << 24) |
			      (hex(record[6]) << 20) | (hex(record[7]) << 16) |
			      (hex(record[8]) << 12) | (hex(record[9]) << 8) |
			      (hex(record[10]) << 4) | hex(record[11]);
		rec.count = byte_count - 5;
		break;
		// S4 record ignored
	default:
		rec.result = NO_ERROR;
		return rec;
	}

	// Calculate checksum and copy data bytes
	uint8_t checksum_c = byte_count + (rec.address >> 24) +
			     (rec.address >> 16) + (rec.address >> 8) +
			     (rec.address & 0xff);

	if (rec.type < S4) {
		memset(rec.data, 0x00, sizeof(rec.data));
		size_t data_offset = (byte_count - rec.count) * 2 + 2;
		for (i = 0; i < rec.count; i++) {
			rec.data[i] = (hex(record[data_offset + i * 2]) << 4) |
				      hex(record[data_offset + i * 2 + 1]);
			checksum_c += rec.data[i];
		}
	}

	checksum_c = ~checksum_c;
	uint8_t checksum_f = (hex(record[byte_count * 2 + 2]) << 4) |
			     hex(record[byte_count * 2 + 3]);
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
	uint8_t *pData = record->data;
	uint8_t fmt;
	switch (record->type) {
	case S2:
	case S6:
	case S8:
		fmt = 6;
		break;
	case S3:
	case S7:
		fmt = 8;
		break;
	default:
		fmt = 4;
	}

	uint8_t checksum = record->count + 1 + fmt / 2 +
			   (record->address >> 24) + (record->address >> 16) +
			   (record->address >> 8) + (record->address & 0xff);

	fprintf(file, "S%01X%02X%0*X", record->type,
		record->count + 1 + fmt / 2, fmt, record->address);
	while (record->count--) {
		fprintf(file, "%02X", *pData);
		checksum += *pData;
		pData++;
	}
	checksum = ~checksum;
	fprintf(file, "%02X\r\n", checksum);
	return EXIT_SUCCESS;
}

// Read a Motorola S-Record file
int read_srec_file(uint8_t *buffer, uint8_t *data, size_t *size)
{
	uint32_t line = 0;
	record_t rec;
	size_t s0 = 0;
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
			return NOT_SREC;
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
			switch (rec.type) {
			case S0:
				s0++;
				fprintf(stderr, "%s\n", rec.data);
				break;
			case S1:
			case S2:
			case S3:
				// If file data size is bigger than chip size
				// update the new size
				if (chip_size >= rec.address + rec.count)
					// copy record data
					memcpy(&(data[rec.address]), rec.data,
					       rec.count);
				else
					*size = (rec.address + rec.count);
				break;
			case S5:
			case S6:
				if (rec.address != line - 1 - s0) {
					fprintf(stderr,
						"Error: wrong record count.\n");
					return EXIT_FAILURE;
				}
				break;
			case S7:
			case S8:
			case S9:
				break;
			default:
				fprintf(stderr,
					"Error on line %u: unknown record type.\n",
					line);
				return EXIT_FAILURE;
			}
		}
		buffer = (uint8_t *)strchr((char *)++buffer, 'S');
	}
	return SREC_FORMAT;
}

// Write an S-Record file
int write_srec_file(FILE *file, uint8_t *data, uint32_t address, size_t size,
		    int write_rec_count)
{
	record_t rec;
	size_t len;
	uint8_t type;
	static size_t line = 0;

	char *header = "Written by Minipro open source software";
	memcpy(rec.data, header, strlen(header));
	rec.type = S0;
	rec.count = strlen(header);
	rec.address = 0x00;
	write_record(file, &rec);

	while (size) {
		if (address < 65536)
			type = S1;
		else if (address < 16777216)
			type = S2;
		else
			type = S3;
		len = (size > ROW_SIZE ? ROW_SIZE : size);
		rec.type = type;
		rec.count = len;
		rec.address = address;
		memcpy(rec.data, data, len);
		write_record(file, &rec);
		data += ROW_SIZE;
		size -= len;
		address += ROW_SIZE;
		line++;
	}
	// Write record count
	if (write_rec_count) {
		rec.type = (line < 65536 ? S5 : S6);
		rec.count = 0x00;
		rec.address = line;
		line = 0;
		write_record(file, &rec);
	}
	return EXIT_SUCCESS;
}
