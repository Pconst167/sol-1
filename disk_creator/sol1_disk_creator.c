#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>

/*

SECTION           SECTORS                    SIZE 
boot sector       1                          512 bytes 
directories       64 * 2 = 128 sectors       64KB
  (files per directory: 16)
file data         64 * 16 = 1024 sectors     512KB

directory file entry format:
filename (24)
attributes (1)  |_|_|file_type(3bits)|x|w|r| types: file, directory, device
  executable file: 0000_0111, directory: 0000_1011
  
LBA (2)
size (2)
day (1)
month (1)
year (1)
packet size = 32 bytes
*/

uint16_t loadfile(uint8_t *filename, uint8_t *dest);
__uint16_t  create_dir(uint8_t *dirname, __uint16_t  parent_id);
void install_bootloader(__uint16_t  kernel_lba);
void list_dirs();
uint16_t try_create_file(uint8_t *filename, uint8_t *filepath, uint16_t parent_id, uint8_t attributes);
__uint16_t create_file(uint8_t *filename, __uint16_t  parent_dir_id, uint8_t *data, __uint16_t  size, uint8_t permissions);
void list_files(__uint16_t  dir_id);

#define BOOT_SECT_SIZE           512 // bytes
#define FST_NBR_DIRECTORIES      64
#define FST_ENTRY_SIZE           32  // bytes
#define FST_FILES_PER_DIR        (512 / FST_ENTRY_SIZE)
#define FST_SECTORS_PER_DIR      (1 + (FST_ENTRY_SIZE * FST_FILES_PER_DIR / 512))    
#define FST_TOTAL_SECTORS        (FST_SECTORS_PER_DIR * FST_NBR_DIRECTORIES)
#define FST_LBA_START            32
#define FST_LBA_END              (FST_LBA_START + FST_TOTAL_SECTORS - 1)

#define FS_SECTORS_PER_FILE      32         // the first sector is always a header with a NULL parameter (first byte)
#define FS_NBR_FILES             (FST_NBR_DIRECTORIES * FST_FILES_PER_DIR)
#define FS_TOTAL_SECTORS         (FS_NBR_FILES * FS_SECTORS_PER_FILE)
#define FS_LBA_START             (FST_LBA_END + 1)
#define FS_LBA_END               (FS_LBA_START + FS_TOTAL_SECTORS - 1)
#define FS_MAX_FILESIZE          (FS_SECTORS_PER_FILE * 512)

uint8_t disk_image[BOOT_SECT_SIZE + FS_TOTAL_SECTORS * 512];
uint8_t temp_buffer[64 * 1024];
uint16_t largest_used_lba;

uint16_t main(void){ 
  __uint16_t  root_id;
  __uint16_t  usr_id;
  __uint16_t  bin0_id;
  __uint16_t  bin1_id;
  __uint16_t  sbin_id;
  __uint16_t  boot_id;
  __uint16_t  etc_id;
  __uint16_t  asm_id;
  __uint16_t  games_id;
  __uint16_t  bin_id;

  __uint16_t  kernel_lba;
  uint16_t file_size;

  root_id = FST_LBA_START;

  // -----------------------------------------------------------------------------------------------
  // create directories
  // -----------------------------------------------------------------------------------------------
  create_dir("", root_id); // root directory
  usr_id  = create_dir("usr",  root_id);
  etc_id  = create_dir("etc",  root_id);
  boot_id = create_dir("boot", root_id);
  asm_id  = create_dir("asm",  root_id);
  bin_id  = create_dir("bin",  root_id);
  sbin_id = create_dir("sbin", root_id);
  create_dir("cc",   root_id);
  create_dir("tmp",  root_id);
  create_dir("home", root_id);
  create_dir("src",  root_id);

  bin0_id  = create_dir("bin0",  usr_id);
  bin1_id  = create_dir("bin1",  usr_id);
  games_id = create_dir("games", usr_id);
  create_dir("share", usr_id);

  // -----------------------------------------------------------------------------------------------
  // create files
  // -----------------------------------------------------------------------------------------------
  // /boot
  kernel_lba = try_create_file("sol1.0", "../software/obj/kernel.obj", boot_id, 0x07);

  // /sbin
  try_create_file("init",      "../software/obj/init.obj",        sbin_id, 0x07);
                                                                                       
  try_create_file("install",   "../software/obj/install.obj",     boot_id, 0x07);
  try_create_file("swap",      "../software/obj/swap.obj",        boot_id, 0x07);
                                                                                       
  // /etc                                                                              
  try_create_file("shell.cfg", "../solarium/etc/shell.cfg",       etc_id, 0x03);
  try_create_file(".shellrc",  "../solarium/etc/.shellrc",        etc_id, 0x03);

  // bin
  try_create_file("primes",    "../ccompiler/out/obj/primes.obj", bin_id, 0x07);
  try_create_file("base64",    "../ccompiler/out/obj/base64.obj", bin_id, 0x07);
  try_create_file("rsa",       "../ccompiler/out/obj/rsa.obj", bin_id, 0x07);
  try_create_file("life",      "../ccompiler/out/obj/life.obj",   bin_id, 0x07);
  try_create_file("qs",        "../ccompiler/out/obj/qs.obj",     bin_id, 0x07);
  try_create_file("cowsay",    "../software/obj/cowsay.obj",      bin_id, 0x07);
  try_create_file("sieve",     "../software/obj/sieve.obj",       bin_id, 0x07);
  try_create_file("fdc",       "../software/obj/floppy_test.obj", bin_id, 0x07);
                                                                                       
  // /bin0                                                                             
  try_create_file("shell",     "../software/obj/shell.obj",       bin0_id, 0x07);
                                                                                       
  try_create_file("ls",        "../software/obj/ls.obj",          bin0_id, 0x07);
  try_create_file("mv",        "../software/obj/mv.obj",          bin0_id, 0x07);
  try_create_file("ps",        "../software/obj/ps.obj",          bin0_id, 0x07);
  try_create_file("mkbin",     "../software/obj/mkbin.obj",       bin0_id, 0x07);
  try_create_file("reboot",    "../software/obj/reboot.obj",      bin0_id, 0x07);
  try_create_file("rm",        "../software/obj/rm.obj",          bin0_id, 0x07);
  try_create_file("cat",       "../software/obj/cat.obj",         bin0_id, 0x07);
  try_create_file("date",      "../software/obj/date.obj",        bin0_id, 0x07);
  try_create_file("mkdir",     "../software/obj/mkdir.obj",       bin0_id, 0x07);
  try_create_file("rmdir",     "../software/obj/rmdir.obj",       bin0_id, 0x07);
  try_create_file("echo",      "../software/obj/echo.obj",        bin0_id, 0x07);
                                                                                       
  // /bin1                                                                             
  try_create_file("wc",        "../software/obj/wc.obj",          bin1_id, 0x07);
  try_create_file("clear",     "../software/obj/clear.obj",       bin1_id, 0x07);
  try_create_file("chmod",     "../software/obj/chmod.obj",       bin1_id, 0x07);
  try_create_file("pwd",       "../software/obj/pwd.obj",         bin1_id, 0x07);
  try_create_file("xxd",       "../software/obj/xxd.obj",         bin1_id, 0x07);
  try_create_file("ed",        "../software/obj/ed.obj",          bin1_id, 0x07);

  // games
  try_create_file("automaton", "../software/obj/automaton.obj",   games_id, 0x07);
  try_create_file("adventure", "../software/obj/advent.obj",      games_id, 0x07);
  try_create_file("wumpus",    "../ccompiler/out/obj/wumpus.obj", games_id, 0x07);

  // copy bootloader to beginning of disk image
  loadfile("../software/obj/boot.obj", disk_image);
  install_bootloader(kernel_lba);

  list_dirs();
  
  printf("\n");
  list_files(root_id);  
  printf("\n");
  list_files(sbin_id);  
  printf("\n");
  list_files(boot_id);  
  printf("\n");
  list_files(etc_id);  
  printf("\n");
  list_files(bin0_id);  
  printf("\n");
  list_files(bin1_id);  
  printf("\n");
  list_files(games_id);  
  printf("\n");

  FILE *fp;
  printf("Creating solarium.img ");
  if((fp = fopen("solarium.img", "wb")) == NULL){
    printf("ERROR: Unable to create output file.\n");
    exit(1);
  }
  fwrite(disk_image, 1, largest_used_lba * 512 + 64 * 512, fp); 
  fclose(fp);

  printf("[OK]\n");
  printf("Disk image size: %d bytes.\n", largest_used_lba * 512 + 32 * 512);

  printf("last: %d", FS_LBA_END);

  return 0;
}

void install_bootloader(__uint16_t  kernel_lba){
  *(__uint16_t  *)(disk_image + 510) = kernel_lba + 1;
}

__uint16_t  create_dir(uint8_t *dirname, __uint16_t  parent_id){
  uint16_t i;
  uint16_t new_dir_id;
  time_t current_time;
  struct tm *local_time;

  time(&current_time);
  local_time = localtime(&current_time);
  uint8_t day = local_time->tm_mday; 
  uint8_t month = local_time->tm_mon + 1;
  uint8_t year = local_time->tm_year + 1900 - 2000;
  uint8_t dh, dl, mh, ml, yh, yl;
  dl = day % 10;
  dh = day / 10; 
  ml = month % 10;
  mh = month / 10; 
  yl = year % 10;
  yh = year / 10; 

  day = (dh << 4) | (dl & 0x0F);
  month = (mh << 4) | (ml & 0x0F);
  year = (yh << 4) | (yl & 0x0F);

  // Find empty directory slot an create new directory
  for(i = FST_LBA_START; i <= FST_LBA_END; i += 2){
    if((__uint16_t )disk_image[i * 512 + 64] == 0){ // found a free directory entry
      strcpy(disk_image + i * 512, dirname);
      *(__uint16_t  *)(disk_image + i * 512 + 64) = parent_id;
      new_dir_id = i;
      break;
    }
  }
  // Add .. and .
  strcpy(disk_image + new_dir_id * 512 + 512, "..");
  *(disk_image + new_dir_id * 512 + 512 + 24) = 0x0B; // dir, read, write
  *(__uint16_t  *)(disk_image + new_dir_id * 512 + 512 + 25) = parent_id;
  *(disk_image + new_dir_id * 512 + 512 + 29) = day;
  *(disk_image + new_dir_id * 512 + 512 + 30) = month;
  *(disk_image + new_dir_id * 512 + 512 + 31) = year;
  strcpy(disk_image + new_dir_id * 512 + 512 + 32, ".");
  *(disk_image + new_dir_id * 512 + 512 + 32 + 24) = 0x0B; // dir, read, write
  *(__uint16_t  *)(disk_image + new_dir_id * 512 + 512 + 32 + 25) = new_dir_id;
  *(disk_image + new_dir_id * 512 + 512 + 32 + 29) = day;
  *(disk_image + new_dir_id * 512 + 512 + 32 + 30) = month;
  *(disk_image + new_dir_id * 512 + 512 + 32 + 31) = year;
  
  // add the new directory as an entry into the current directory 
  if(!strcmp(dirname, "") == 0){ // Add entry only if dir is not root
    for(i = 0; i < 16 * 32 ; i += 32){
      if(*(disk_image + parent_id * 512 + 512 + i) == '\0'){
        strcpy(disk_image + parent_id * 512 + 512 + i, dirname);
        *(disk_image + parent_id * 512 + 512 + i + 24) = 0x0B; // dir, read, write
        *(__uint16_t  *)(disk_image + parent_id * 512 + 512 + i + 25) = new_dir_id;
        *(disk_image + parent_id * 512 + 512 + i + 29) = day;
        *(disk_image + parent_id * 512 + 512 + i + 30) = month;
        *(disk_image + parent_id * 512 + 512 + i + 31) = year;
        break;
      }
    }
  }

  return new_dir_id;
}

uint16_t try_create_file(uint8_t *filename, uint8_t *filepath, uint16_t parent_id, uint8_t attributes){
  uint16_t file_size;
  uint16_t lba;
  uint8_t temp_buffer[64 * 1024];

  file_size = loadfile(filepath, temp_buffer);
  if(file_size <= FS_MAX_FILESIZE)
    lba = create_file(filename, parent_id, temp_buffer, file_size, attributes);
  else{
    printf("filesize exceeds %d", FS_MAX_FILESIZE);
    exit(1);
  }
  
  return lba;
}
/*
directory file entry format:
filename (24)
attributes (1)  |_|_|file_type(3bits)|x|w|r| types: file, directory, uint8_tacter device
LBA (2)
size (2)
day (1)
month (1)
year (1)
packet size = 32 bytes
*/
__uint16_t create_file(uint8_t *filename, __uint16_t parent_dir_id, uint8_t *data, __uint16_t size, uint8_t permissions){
  uint16_t i, j;
  uint8_t *p;
  __uint16_t  LBA;
  time_t current_time;
  struct tm *local_time;

  time(&current_time);
  local_time = localtime(&current_time);
  uint8_t day = local_time->tm_mday; 
  uint8_t month = local_time->tm_mon + 1;
  uint8_t year = local_time->tm_year + 1900 - 2000;
  uint8_t dh, dl, mh, ml, yh, yl;
  dl = day % 10;
  dh = day / 10; 
  ml = month % 10;
  mh = month / 10; 
  yl = year % 10;
  yh = year / 10; 

  day = (dh << 4) | (dl & 0x0F);
  month = (mh << 4) | (ml & 0x0F);
  year = (yh << 4) | (yl & 0x0F);

  // look for emty space in disk for the new file
  for(i = FS_LBA_START; i <= FS_LBA_END; i += 32){
    if(disk_image[i * 512] == 0){ // found a free filedata entry
      *(__uint16_t  *)(disk_image + i * 512) = 1;
      p = data;
      for(j = 0; j < size; j++) *(disk_image + i * 512 + 512 + j) = *p++;
      LBA = i;
      largest_used_lba = i;
      break;
    }
  }

  // find an empty entry in the directory and use it
  for(i = 0; i < 16 * 32 ; i += 32){
    if(*(disk_image + parent_dir_id * 512 + 512 + i) == '\0'){
      strcpy(disk_image + parent_dir_id * 512 + 512 + i, filename);
      *(disk_image + parent_dir_id * 512 + 512 + i + 24) = permissions; 
      *(__uint16_t  *)(disk_image + parent_dir_id * 512 + 512 + i + 25) = LBA; // LBA
      *(__uint16_t  *)(disk_image + parent_dir_id * 512 + 512 + i + 27) = size; // LBA
      *(disk_image + parent_dir_id * 512 + 512 + i + 29) = day;
      *(disk_image + parent_dir_id * 512 + 512 + i + 30) = month;
      *(disk_image + parent_dir_id * 512 + 512 + i + 31) = year;
      break;
    }
  }

  return LBA;
}

void list_dirs(){
  uint16_t i;
  printf("  ID     Parent   Name\n");
  for(i = FST_LBA_START; i <= FST_LBA_END; i += 2){
    if((__uint16_t )disk_image[i * 512 + 64] == 0) break;
    printf("%4d %6d %10s\n", i, *(__uint16_t  *)(disk_image + i * 512 + 64), disk_image + i * 512);
  }
}

void list_files(__uint16_t  dir_id){
  uint16_t i;
  printf("           NAME     LBA/ID    ATTRIB     SIZE       DATE\n");
  printf("--------------------------------------------------------\n");
  for(i = 0; i < 16 * 32 ; i += 32){
    if(*(disk_image + dir_id * 512 + 512 + i) != '\0')
      printf("%15s     %6d       0x%x   %6d    %x %x %x\n", 
        disk_image + dir_id * 512 + 512 + i, 
        *(__uint16_t  *)(disk_image + dir_id * 512 + 512 + i + 25), 
        *(uint8_t *)(disk_image + dir_id * 512 + 512 + i + 24), 
        *(__uint16_t  *)(disk_image + dir_id * 512 + 512 + i + 27),
        *(disk_image + dir_id * 512 + 512 + i + 29),
        *(disk_image + dir_id * 512 + 512 + i + 30),
        *(disk_image + dir_id * 512 + 512 + i + 31)
      );
  }
  printf("\n");
}

uint16_t loadfile(uint8_t *filename, uint8_t *dest){
  FILE *fp;
  uint16_t size;
  uint8_t *p;
  
  if((fp = fopen(filename, "rb")) == NULL){
    printf("ERROR: '%s' not found.\n", filename);
    exit(1);
  }
  
  size = 0;
  p = dest;
  for(; !feof(fp) ;){
    *p++ = fgetc(fp);
    size++;
  }
  *(p - 1) = '\0'; // overwrite the EOF uint8_t with NULL

  fclose(fp);

  size--;
  return size;
}