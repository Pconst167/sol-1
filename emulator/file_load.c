#include <stdint.h>
#include <errno.h>
#include "file_load.h"

/* Read up to dst_cap bytes using fgetc().
 * Returns number of bytes read.
 * Exits on open/read error.
 */
size_t read_file_up_to_fgetc_or_die(const char *path, uint8_t *dst, size_t dst_cap){
  FILE *fp = fopen(path, "rb");
  if(!fp){
    fprintf(stderr, "ERROR: cannot open '%s': %s\n", path, strerror(errno));
    exit(1);
  }

  size_t i = 0;
  for(; i < dst_cap; i++){
    int c = fgetc(fp);
    if(c == EOF){
      if(ferror(fp)){
        fprintf(stderr, "ERROR: read error on '%s': %s\n", path, strerror(errno));
        fclose(fp);
        exit(1);
      }
      break; /* normal EOF */
    }
    dst[i] = (uint8_t)c;
  }

  fclose(fp);
  return i;
}

/* Read entire file into dst using fgetc(); if file is bigger than dst_cap, error.
 * Returns bytes read.
 */
size_t read_file_all_fgetc_or_die(const char *path, uint8_t *dst, size_t dst_cap){
  FILE *fp = fopen(path, "rb");
  if(!fp){
    fprintf(stderr, "ERROR: cannot open '%s': %s\n", path, strerror(errno));
    exit(1);
  }

  size_t i = 0;
  int c;
  while((c = fgetc(fp)) != EOF){
    if(i >= dst_cap){
      fprintf(stderr, "ERROR: '%s' is larger than capacity (%zu bytes)\n", path, dst_cap);
      fclose(fp);
      exit(1);
    }
    dst[i++] = (uint8_t)c;
  }

  if(ferror(fp)){
    fprintf(stderr, "ERROR: read error on '%s': %s\n", path, strerror(errno));
    fclose(fp);
    exit(1);
  }

  fclose(fp);
  return i;
}