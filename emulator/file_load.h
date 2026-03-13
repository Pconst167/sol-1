#ifndef FILE_LOAD_H
#define FILE_LOAD_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

size_t read_file_up_to_fgetc_or_die(const char *path, uint8_t *dst, size_t dst_cap);
size_t read_file_all_fgetc_or_die(const char *path, uint8_t *dst, size_t dst_cap);

#endif