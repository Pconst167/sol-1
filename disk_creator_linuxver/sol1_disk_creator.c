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
attributes (1)  |_|_|file_type(3bits)|x|w|r| types: file, directory, uint8_tacter device
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
__uint16_t  create_file(uint8_t *filename, __uint16_t  parent_dir_id, uint8_t *data, __uint16_t  size, uint8_t permissions);
void list_files(__uint16_t  dir_id);

#define BOOT_SECT_SIZE           1   // sector
#define FST_NBR_DIRECTORIES      64
#define FST_ENTRY_SIZE           32  // bytes
#define FST_ENTRIES_PER_SECT     (512 / FST_ENTRY_SIZE)
#define FST_FILES_PER_DIR        (512 / FST_ENTRY_SIZE)
#define FST_SECTORS_PER_DIR      (1 + (FST_ENTRY_SIZE * FST_FILES_PER_DIR / 512))    
#define FST_TOTAL_SECTORS        (FST_SECTORS_PER_DIR * FST_NBR_DIRECTORIES)
#define FST_LBA_START            32
#define FST_LBA_END              (FST_LBA_START + FST_TOTAL_SECTORS - 1)

#define FS_SECTORS_PER_FILE      32         // the first sector is always a header with a NULL parameter (first byte)
#define FS_NBR_FILES             (FST_NBR_DIRECTORIES * FST_FILES_PER_DIR)
#define FS_TOTAL_SECTORS         (FS_NBR_FILES * FS_SECTORS_PER_FILE)
#define FS_LBA_START             (FST_LBA_END + 1)
#define FS_LBA_END               (FS_LBA_START + FS_NBR_FILES - 1)

uint8_t disk_image[BOOT_SECT_SIZE * 512 + FS_TOTAL_SECTORS * 512];
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

  __uint16_t  kernel_lba;
  uint16_t file_size;

  root_id = FST_LBA_START;

  // -----------------------------------------------------------------------------------------------
  // Directories
  // -----------------------------------------------------------------------------------------------
  create_dir("", root_id); // root directory
  usr_id = create_dir("usr", root_id);
  bin0_id = create_dir("bin0", usr_id);
  bin1_id = create_dir("bin1", usr_id);
  create_dir("share", usr_id);
  create_dir("games", usr_id);
  
  etc_id = create_dir("etc", root_id);
  boot_id = create_dir("boot", root_id);
  create_dir("cc", root_id);
  asm_id = create_dir("asm", root_id);
  create_dir("tmp", root_id);
  create_dir("bin", root_id);
  sbin_id = create_dir("sbin", root_id);
  create_dir("home", root_id);
  create_dir("dev", root_id);
  create_dir("doc", root_id);
  create_dir("src", root_id);

  // -----------------------------------------------------------------------------------------------
  // Files
  // -----------------------------------------------------------------------------------------------
  // /sbin
  file_size = loadfile("../software/obj/init.obj", temp_buffer);
  create_file("init", sbin_id, temp_buffer, file_size, 0x07);

  // /boot
  file_size = loadfile("../software/obj/kernel.obj", temp_buffer);
  kernel_lba = create_file("sol1.0", boot_id, temp_buffer, file_size, 0x07);
  file_size = loadfile("../software/obj/install.obj", temp_buffer);
  create_file("install", boot_id, temp_buffer, file_size, 0x07);
  file_size = loadfile("../software/obj/swap.obj", temp_buffer);
  create_file("swap", boot_id, temp_buffer, file_size, 0x07);

  // /etc
  file_size = loadfile("../solarium/etc/shell.cfg", temp_buffer);
  create_file("shell.cfg", etc_id, temp_buffer, file_size, 0x03);
  file_size = loadfile("../solarium/etc/.shellrc", temp_buffer);
  create_file(".shellrc", etc_id, temp_buffer, file_size, 0x03);

  // /asm
  file_size = loadfile("../ccompiler/out/obj/asm.obj", temp_buffer);
  create_file("asm", asm_id, temp_buffer, file_size, 0x03);

  // /bin0
  file_size = loadfile("../ccompiler/out/obj/shell.obj", temp_buffer);
  create_file("shell", bin0_id, temp_buffer, file_size, 0x07);
  file_size = loadfile("../ccompiler/out/obj/getparam.obj", temp_buffer);
  create_file("getparam", bin0_id, temp_buffer, file_size, 0x07);
  file_size = loadfile("../ccompiler/out/obj/setparam.obj", temp_buffer);
  create_file("setparam", bin0_id, temp_buffer, file_size, 0x07);

  file_size = loadfile("../software/obj/ls.obj", temp_buffer);
  create_file("ls", bin0_id, temp_buffer, file_size, 0x07);
  file_size = loadfile("../software/obj/mv.obj", temp_buffer);
  create_file("mv", bin0_id, temp_buffer, file_size, 0x07);
  file_size = loadfile("../software/obj/ps.obj", temp_buffer);
  create_file("ps", bin0_id, temp_buffer, file_size, 0x07);
  file_size = loadfile("../software/obj/mkbin.obj", temp_buffer);
  create_file("mkbin", bin0_id, temp_buffer, file_size, 0x07);
  file_size = loadfile("../software/obj/reboot.obj", temp_buffer);
  create_file("reboot", bin0_id, temp_buffer, file_size, 0x07);
  file_size = loadfile("../software/obj/rm.obj", temp_buffer);
  create_file("rm", bin0_id, temp_buffer, file_size, 0x07);
  file_size = loadfile("../software/obj/cat.obj", temp_buffer);
  create_file("cat", bin0_id, temp_buffer, file_size, 0x07);
  file_size = loadfile("../software/obj/date.obj", temp_buffer);
  create_file("date", bin0_id, temp_buffer, file_size, 0x07);
  file_size = loadfile("../software/obj/mkdir.obj", temp_buffer);
  create_file("mkdir", bin0_id, temp_buffer, file_size, 0x07);
  file_size = loadfile("../software/obj/rmdir.obj", temp_buffer);
  create_file("rmdir", bin0_id, temp_buffer, file_size, 0x07);
  file_size = loadfile("../software/obj/echo.obj", temp_buffer);
  create_file("echo", bin0_id, temp_buffer, file_size, 0x07);

  // /bin2
  file_size = loadfile("../software/obj/wc.obj", temp_buffer);
  create_file("wc", bin1_id, temp_buffer, file_size, 0x07);
  file_size = loadfile("../software/obj/clear.obj", temp_buffer);
  create_file("clear", bin1_id, temp_buffer, file_size, 0x07);
  file_size = loadfile("../software/obj/chmod.obj", temp_buffer);
  create_file("chmod", bin1_id, temp_buffer, file_size, 0x07);
  file_size = loadfile("../software/obj/pwd.obj", temp_buffer);
  create_file("pwd", bin1_id, temp_buffer, file_size, 0x07);
  file_size = loadfile("../software/obj/xxd.obj", temp_buffer);
  create_file("xxd", bin1_id, temp_buffer, file_size, 0x07);
  file_size = loadfile("../software/obj/ed.obj", temp_buffer);
  create_file("ed", bin1_id, temp_buffer, file_size, 0x07);


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

void list_dirs(){
  uint16_t i;
  printf("  ID     Parent   Name\n");
  for(i = FST_LBA_START; i <= FST_LBA_END; i += 2){
    if((__uint16_t )disk_image[i * 512 + 64] == 0) break;
    printf("%4d %6d %10s\n", i, *(__uint16_t  *)(disk_image + i * 512 + 64), disk_image + i * 512);
  }
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
__uint16_t  create_file(uint8_t *filename, __uint16_t  parent_dir_id, uint8_t *data, __uint16_t  size, uint8_t permissions){
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

void list_files(__uint16_t  dir_id){
  uint16_t i;
  printf("           NAME     LBA/ID    ATTRIB     SIZE       DATE\n");
  printf("--------------------------------------------------------\n");
  for(i = 0; i < 16 * 32 ; i += 32){
    if(*(disk_image + dir_id * 512 + 512 + i) != '\0')
      printf(
        "%15s     %6d       0x%x   %6d    %x %x %x\n", 
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