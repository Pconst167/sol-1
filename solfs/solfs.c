#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>

/*
  ------------------------------------------------------------------------------------------------------------------;
  DISK LAYOUT:
  Metadata               | Size (bytes)      | Blocks (2048 bytes)              |Start Block |  Comment
  ---------------------- | ----------------- | -------------------------------- |------------|-----------------------------------
  Bootloader/MBR         | 512 bytes         | 0.25 (1 sector)                  |  0         |
  Superblock             | 1024 bytes        | 1 block (2048 bytes, must align) |  0         |
                         |                   | 1 block (2048 bytes)             |  1         | reserved
  Block Bitmap           | 8,192 bytes       | 4 blocks                         |  2         | 4*2048*8 = 4*16384 = 65536 raw data blocks.  65536*2048 bytes = 134217728 bytes of disk space = 128MB
  Inode Bitmap           | 2,048 bytes       | 1 block                          |  6         | 2048*8=16384. total of 16384 bits, meaning 16384 inodes, which is 1 inode per 8KB of disk space
  Inode Table            | 2,097,152 bytes   | 1024 blocks                      |  7         | 128bytes per inode entry. 2097152 / 128 = 16384 inodes
  Data Blocks            | 134,217,728 bytes | 65528 blocks                     | 1031       | 65528 blocks = 134,201,344 bytes
  
  first 512 bytes: bootloader from 0 to 445, MBR partition table from 446 to 511 (64 bytes)
  up to 4 partitions, each 16 bytes long
  MBR:
  Byte | Description
  -----|----------------------------
  0    | Boot flag (0x80 active, 0x00 inactive)
  1-3  | Start CHS (head, sector, cylinder)
  4    | Partition type (filesystem ID)
    0x83 = Linux native (ext2/3/4)
    0x07 = NTFS/exFAT
    0x0B = FAT32 CHS
    0x0C = FAT32 LBA
    0x05 = Extended partition
    0x86 = Sol-1 partition
  5-7  | End CHS
  8-11 | Start LBA (little endian)
  12-15| Size in sectors (little endian)
  
  
  the superblock describers the filesystem as a whole such as inode count, free inode count, location of the raw data bitmap, inode table, etc.  
  SUPERBLOCK:
  | Field               | Description                               | Typical Size (bytes) | Notes                           |
  | ------------------- | ----------------------------------------- | -------------------- | ------------------------------- |
  | inodes_count        | Total number of inodes in the filesystem  | 2                    | 16-bit unsigned int             |
  | blocks_count        | Total number of data blocks               | 2                    | 16-bit unsigned int             |
  | free_inodes_count   | Number of free inodes                     | 2                    | 16-bit unsigned int             |
  | free_blocks_count   | Number of free blocks                     | 2                    | 16-bit unsigned int             |
  | block_bitmap        | Block ID of the **block bitmap**          | 2                    | 16-bit unsigned int
  | inode_bitmap        | Block ID of the **inode bitmap**          | 2                    | 16-bit unsigned int
  | inode_table         | Starting block of **inode table**         | 2                    | 16-bit unsigned int
  | first_data_block    | Block number of the first data block      | 2                    | 16-bit unsigned int             |
  | used_dirs_count     | Number of inodes allocated to directories | 2
  | log_block_size      | Block size = 1024 << `s_log_block_size    | 2                    | 16-bit unsigned int             |
  | mtime               | Last mount time                           | 4                    | 32-bit unsigned int (Unix time) |
  | wtime               | Last write time                           | 4                    | 32-bit unsigned int (Unix time) |
  | uuid                | Unique ID of the filesystem               | 16                   | 128-bit UUID                    |
  | volume_name         | Label of the filesystem                   | 16                   | Usually ASCII, padded           |
  | feature_flags       | Compatibility flags                       | 4                    | 32-bit unsigned int             |
  
  inode for root dir is #2, #0 and #1 not used
  raw data block #0 is not used. because 0 as a block ID means not used
  block size: 2048
  inode-table format:
  | Field         | Size (bytes) | Description                                                                                  |
  | ------------- | ------------ | -------------------------------------------------------------------------------------------- |
  | `mode`        | 2            | File type and permissions                                                                    |
  | `uid`         | 2            | Owner user ID                                                                                |
  | `size`        | 4            | Size of the file in bytes                                                                    |
  | `atime`       | 4            | Last access time (timestamp)                                                                 |
  | `ctime`       | 4            | Creation time (timestamp)                                                                    |
  | `mtime`       | 4            | Last modification time (timestamp)                                                           |
  | `dtime`       | 4            | Deletion time (timestamp)                                                                    |
  | `gid`         | 2            | Group ID                                                                                     |
  | `links_count` | 2            | Number of hard links                                                                         |
  | `blocks`      | 2            | Number of 2048-byte blocks allocated                                                         |
  | `flags`       | 4            | File flags                                                                                   |
  | `block`       | 47 * 2 = 94  | Pointers to data blocks (47 direct only) 


  DIRECTORY ENTRY
  this is the structure for file entries inside a directory.
  2048 / 64 = 32 entries

  each entry is 64 bytes wide
  uint16_t inode;      // Inode number (0 if entry is unused)
  char     name[62];   // File name (null terminated)

*/

#define MAX_ID_LEN                    512
#define NUM_INODES                    16384
#define ROOT_INODE                    2
#define NUM_DATA_BLOCKS               65528
#define NUM_INODE_BLOCK_POINTERS      47 // 0 .. 46
#define NUM_BLOCK_POINTERS_PER_BLOCK  (2048 / 2)
#define BLOCK_BITMAP_BLOCK_NUM        2
#define INODE_BITMAP_BLOCK_NUM        6
#define INODE_TABLE_BLOCK_NUM         7
#define PARTITION_0_FIRST_DATA_BLOCK  0

#define BLOCK_SIZE                    2048

#define DIR_ENTRY_LEN                 64
#define DIR_ENTRY_NAME_LEN            62
#define NUM_DIR_ENTRIES               (BLOCK_SIZE / DIR_ENTRY_LEN)

#define BOOTLOADER_START              0
#define BOOTLOADER_SIZE               446  
#define MBR_START                     446
#define MBR_SIZE                      64
#define SIGNATURE_START               510
#define SIGNATURE_SIZE                2 
#define SUPERBLOCK_START              1024 // starts at block 0, position 1024
#define SUPERBLOCK_SIZE               1024  // 1024 bytes long
#define BLOCK_GROUP_DESCRIPTOR_START (1 * 2048) // starts a block 1
#define BLOCK_GROUP_DESCRIPTOR_SIZE  32          // 32 bytes long
#define BLOCKS_BITMAP_START          (2 * 2048) // starts at block 2
#define BLOCKS_BITMAP_SIZE           (4 * 2048)  // 4 blocks long
#define INODE_BITMAP_START           (6 * 2048) // starts at block 6
#define INODE_BITMAP_SIZE            2048        // 1 block long
#define INODE_TABLE_START            (7 * 2048)  // starts at block 7
#define INODE_TABLE_NUM_ENTRIES      16384 // 16384 entries of 128bytes
#define INODE_TABLE_SIZE             (1024 * 2048)      // 1024 blocks long
#define DATA_BLOCKS_START            (1031 * 2048) // start of disk data blocks
#define DATA_BLOCKS_SIZE             (65536 * 2048)
#define TOTAL_DISK_SIZE              (BOOTLOADER_SIZE + MBR_SIZE + SIGNATURE_SIZE + 512\
                                    + SUPERBLOCK_SIZE + BLOCK_GROUP_DESCRIPTOR_SIZE + 2016\
                                    + BLOCKS_BITMAP_SIZE + INODE_BITMAP_SIZE\
                                    + INODE_TABLE_SIZE\
                                    + DATA_BLOCKS_SIZE)

struct superblock{
  uint16_t inodes_count     ; // Total number of inodes in the filesystem  
  uint16_t blocks_count     ; // Total number of data blocks         
  uint16_t free_inodes_count; // Number of free inodes                 
  uint16_t free_blocks_count; // Number of free blocks                
  uint16_t block_bitmap     ; // Block ID of the **block bitmap**
  uint16_t inode_bitmap     ; // Block ID of the **inode bitmap**
  uint16_t inode_table      ; // Starting block of **inode table**
  uint16_t first_data_block ; // Block number of the first data block   
  uint16_t used_dirs_count  ; // Number of inodes allocated to directories
  uint16_t log_block_size   ; // Block size = 1024 << `s_log_block_size` 
  uint32_t mtime            ; // Last mount time (unix time)              
  uint32_t wtime            ; // Last write time (unix time)              
  uint8_t  uuid[16]         ; // Unique ID of the filesystem            
  uint8_t  volume_name[16]  ; // Label of the filesystem               
  uint32_t feature_flags    ; // Compatibility flags                  
};

struct inode_table_entry{
  uint16_t mode       ; // File type and permissions 
  uint16_t uid        ; // Owner user ID
  uint32_t size       ; // Size of the file in bytes
  uint32_t atime      ; // Last access time (timestamp)
  uint32_t ctime      ; // Creation time (timestamp)
  uint32_t mtime      ; // Last modification time (timestamp)
  uint32_t dtime      ; // Deletion time (timestamp) 
  uint16_t gid        ; // Group ID         
  uint16_t links_count; // Number of hard links
  uint16_t blocks     ; // Number of blocks allocated (2048 blocks)
  uint32_t flags      ; // File flags
  uint16_t block[NUM_INODE_BLOCK_POINTERS]; // Pointers to data blocks (47 direct)
};

// each entry 64 bytes wide
struct directory_entry {
  uint16_t inode;                      // Inode number (0 if entry is unused)
  char     name[DIR_ENTRY_NAME_LEN];   // File name (null-terminated)
};

struct{
  uint16_t curr_inode;
  char directory_str[MAX_ID_LEN];
} fs_state;

void read_partition();
size_t loadfile_bootloader(const char *filename, uint8_t *dest);
size_t loadfile(const char *filename, char *dest);
uint16_t inode_bitmap_alloc();
uint16_t block_bitmap_alloc();
uint16_t create_inode(struct inode_table_entry inode_entry);
void init_directory(uint16_t block_index, uint16_t self_inode, uint16_t parent_inode);
uint16_t create_directory(char *name, uint16_t parent_dir_inode);
uint16_t create_file(char *name, char * filename, uint16_t parent_dir_inode);
void print_directory(uint16_t dir_inode);
void navigate(void);
char *name_from_inode(char *name, uint16_t inode, uint16_t parent_inode);
uint16_t superblock_free_blocks_dec();
uint16_t superblock_free_blocks_inc();
uint16_t superblock_free_inodes_dec();
uint16_t superblock_free_inodes_inc();
void print_inode_table();
void print_bitmap_table();

unsigned char disk[TOTAL_DISK_SIZE];
unsigned char mbr_data[] = {
  // partition 0
  0x80, 
  0x00, 0x00, 
  0x00,
  0x83,
  0x00, 0x00,
  0x00,
  0x01, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0x08, 0x00,
  // partition 1
  0x00, 
  0x00, 0x00, 
  0x00,
  0x83,
  0x00, 0x00,
  0x00,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  // partition 2
  0x00, 
  0x00, 0x00, 
  0x00,
  0x83,
  0x00, 0x00,
  0x00,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  // partition 3
  0x00, 
  0x00, 0x00, 
  0x00,
  0x83,
  0x00, 0x00,
  0x00,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00,
  0x00, 0x00
};

typedef uint8_t datablock_t[BLOCK_SIZE]; // type for data blocks

unsigned char *p = disk;
unsigned char *mbr_p = disk + MBR_START;
unsigned char *signature_p = disk + SIGNATURE_START;
unsigned char *superblock_p = disk + SUPERBLOCK_START;
datablock_t *data_blocks_p = (datablock_t *)(disk + DATA_BLOCKS_START);
struct inode_table_entry *inode_table_p = (struct inode_table_entry *)(disk + INODE_TABLE_START);
unsigned char *inode_bitmap_p = disk + INODE_BITMAP_START;
unsigned char *blocks_bitmap_p = disk + BLOCKS_BITMAP_START;

int show_block_bitmap = 0;
int show_inode_bitmap = 0;

int main(int argc, char **argv){
  struct superblock superblock;
  struct inode_table_entry inode_table_entry;
  struct inode_table_entry root_inode;
  
  fs_state.curr_inode = 2; // #2 is root
  strcpy(fs_state.directory_str, "/"); // clear directory name

  if(argc == 1){
    printf("usage: solfs -w : write disk\n");
    printf("       solfs -r : read disk image and show parameters\n");
    printf("       solfs -n : navigate disk\n");
  }

  if(!strcmp(argv[1], "-r")){
    if(argc > 2){
      if(!strcmp(argv[2], "-b")) show_block_bitmap = 1;
      if(!strcmp(argv[2], "-i")) show_inode_bitmap = 1;
    }
    if(argc > 3){
      if(!strcmp(argv[3], "-b")) show_block_bitmap = 1;
      if(!strcmp(argv[3], "-i")) show_inode_bitmap = 1;
    }
    read_partition();
    exit(1);
  }
  if(!strcmp(argv[1], "-n")){
    navigate();
  }
    // generate disk image
  if(!strcmp(argv[1], "-w")){
    // LOAD BOOTLOADER AND WRITE TO BOOT SECTOR
    if(loadfile_bootloader("../software/obj/boot.obj", disk) == -1){
      printf("> exiting...\n");
      return 0;
    };

    // COPY MBR TABLE TO DISK
    for(int i = 0; i < sizeof(mbr_data); i++){
      *(mbr_p + i) = mbr_data[i];
    }

    // SET BOOTLOADER SIGNATURE
    *(uint16_t *)(signature_p) = 0x55AA;

    // SUPERBLOCK
    // start block: 0
    // start offset: 1024
    // size: 1024 bytes
    superblock.inodes_count      = NUM_INODES; // Total number of inodes in the filesystem  
    superblock.blocks_count      = NUM_DATA_BLOCKS; // Total number of data blocks         
    superblock.free_inodes_count = NUM_INODES; // Number of free inodes                 
    superblock.free_blocks_count = NUM_DATA_BLOCKS; // Number of free blocks                
    superblock.block_bitmap      = BLOCK_BITMAP_BLOCK_NUM; // Block ID of the **block bitmap**
    superblock.inode_bitmap      = INODE_BITMAP_BLOCK_NUM; // Block ID of the **inode bitmap**
    superblock.inode_table       = INODE_TABLE_BLOCK_NUM; // Starting block of **inode table**
    superblock.first_data_block  = 0; // Block number of the first data block   
    superblock.used_dirs_count   = 1; // Number of inodes allocated to directories
    superblock.log_block_size    = 1; // Block size = 1024 << `s_log_block_size` 
    superblock.mtime             = 0; // Last mount time (unix time)              
    superblock.wtime             = 0; // Last write time (unix time)              
    memset(superblock.uuid, 0, 16); // Unique ID of the filesystem            
    strcpy(superblock.volume_name, "Sol-1 Volume"); // Label of the filesystem               
    superblock.feature_flags     = 0; // Compatibility flags                  
    *(struct superblock *)(superblock_p) = superblock;

    
    // BLOCK BITMAP
    // start block: 2
    // start offset: 4096
    // size = 4 * 2048 = 8192 bytes
    *(blocks_bitmap_p) = 0x01; // the very first bit is set to 1 so it can never be found as free
    for(int i = 1; i < BLOCKS_BITMAP_SIZE; i++){
      *(blocks_bitmap_p + i) = 0x00; // set each bitmap byte to 0
    }

    // INODE BITMAP
    // start block: 6
    // start offset: 12288
    // size = 1 block = 2048 bytes
    *(inode_bitmap_p) = 0x03; // inode bits 0, 1 are set to used so they can never be found as free
    for(int i = 1; i < INODE_BITMAP_SIZE; i++){
      *(inode_bitmap_p + i) = 0x00; // set each bitmap byte to 0
    }

    // INODE TABLE
    // start block: 7
    // start offset: 14336
    // size = 1024 blocks = 2,097,152 bytes
    inode_table_entry.mode        = 0; // File type and permissions 
    inode_table_entry.uid         = 0; // Owner user ID
    inode_table_entry.size        = 0; // Size of the file in bytes
    inode_table_entry.atime       = 0; // Last access time (timestamp)
    inode_table_entry.ctime       = 0; // Creation time (timestamp)
    inode_table_entry.mtime       = 0; // Last modification time (timestamp)
    inode_table_entry.dtime       = 0; // Deletion time (timestamp) 
    inode_table_entry.gid         = 0; // Group ID         
    inode_table_entry.links_count = 0; // Number of hard links
    inode_table_entry.blocks      = 0; // Number of 512-byte blocks allocated 
    inode_table_entry.flags       = 0; // File flags
    memset(inode_table_entry.block, 0, NUM_INODE_BLOCK_POINTERS * 2); // Pointers to data blocks (47 direct)

    // reset entire inode table to unused
    for(int i = 0; i < INODE_TABLE_NUM_ENTRIES; i++){
      *(inode_table_p + i) = inode_table_entry;
    }

    // CREATE ROOT DIRECTORY
    memset(&root_inode, 0, sizeof(root_inode)); // reset entire inode
    root_inode.mode        = 0x41ED;   // directory (0x4000) + rwxr-xr-x (0x1ED)
    root_inode.uid         = 0;        // root user
    root_inode.gid         = 0;
    root_inode.size        = 2048;     // one block for the directory
    root_inode.atime       = root_inode.ctime = root_inode.mtime = time(NULL);
    root_inode.links_count = 2;        // "." and parent ("..")
    root_inode.blocks      = 1; 
    root_inode.block[0]    = block_bitmap_alloc(); // allocate block for root and set pointer in inode entry (will allocate block 1)
    // allocate inode bitmap and set inode table entry for root
    create_inode(root_inode); // this will allocate inode #2 for root
    // ADD . AND .. ENTRIES TO ROOT DIRECTORY
    init_directory(root_inode.block[0], 2, 2);
    printf("> root directory created: %d\n", 2);

    // create /usr directory
    uint16_t usr_inode  = create_directory("usr",   2); // create /usr directory
    uint16_t tmp_inode  = create_directory("tmp",   2); // create /usr directory
    uint16_t etc_inode  = create_directory("etc",   2); // create /usr directory
    uint16_t bin_inode  = create_directory("bin",   2); // create /usr directory
    uint16_t sbin_inode = create_directory("sbin",  2); // create /usr directory
    uint16_t boot_inode = create_directory("boot",  2); // create /usr directory
    uint16_t asm_inode  = create_directory("asm",   2); // create /usr directory
    uint16_t cc_inode   = create_directory("cc",    2); // create /usr directory
    uint16_t home_inode = create_directory("home",  2); // create /usr directory
    uint16_t src_inode  = create_directory("src",   2); // create /usr directory

    uint16_t usr_bin_inode   = create_directory("bin", usr_inode);
    uint16_t usr_sbin_inode  = create_directory("sbin",  usr_inode);
    uint16_t usr_games_inode = create_directory("games", usr_inode);
    uint16_t usr_share_inode = create_directory("share", usr_inode);
    uint16_t usr_local_inode = create_directory("local", usr_inode);

    create_file("ls", "../software/obj/ls.obj", usr_bin_inode);
    create_file("mkbin", "../software/obj/mkbin.obj", usr_bin_inode);
    create_file("mkdir", "../software/obj/mkdir.obj", usr_bin_inode);
    create_file("rmdir", "../software/obj/rmdir.obj", usr_bin_inode);
    create_file("cat", "../software/obj/cat.obj", usr_bin_inode);
    create_file("clear", "../software/obj/clear.obj", usr_bin_inode);
    create_file("chmod", "../software/obj/chmod.obj", usr_bin_inode);
    create_file("date", "../software/obj/date.obj", usr_bin_inode);
    create_file("echo", "../software/obj/echo.obj", usr_bin_inode);
    create_file("ed", "../software/obj/ed.obj", usr_bin_inode);
    create_file("mv", "../software/obj/mv.obj", usr_bin_inode);
    create_file("ps", "../software/obj/ps.obj", usr_bin_inode);
    create_file("pwd", "../software/obj/pwd.obj", usr_bin_inode);
    create_file("reboot", "../software/obj/reboot.obj", usr_bin_inode);
    create_file("rm", "../software/obj/rm.obj", usr_bin_inode);
    create_file("rmdir", "../software/obj/rmdir.obj", usr_bin_inode);

    create_file("shell", "../software/obj/shell.obj", usr_sbin_inode);

    create_file("boot", "../software/obj/boot.obj", boot_inode);
    create_file("kernel1.0", "../software/obj/kernel.obj", boot_inode);

    create_file("shell.cfg", "../solarium/etc/shell.cfg", etc_inode);
    create_file(".shellrc", "../solarium/etc/.shellrc", etc_inode);

    // generate disk image file
    FILE *f = fopen("disk.bin", "wb"); // open for writing in binary mode
    if (!f) {
        perror("Failed to open file");
        return 1;
    }

    // fwrite(pointer, size_of_each_item, number_of_items, file_pointer)
    size_t written = fwrite(disk, 1, TOTAL_DISK_SIZE, f);
    if (written != TOTAL_DISK_SIZE) {
        perror("Failed to write all bytes");
        fclose(f);
        return 1;
    }
    fclose(f);
  }

  return 1;
}

size_t loadfile_bootloader(const char *filename, uint8_t *dest) {
  FILE *fp = fopen(filename, "rb");
  if (!fp) {
      printf("> error: file '%s' not found.\n", filename);
      exit(1);
  }
  size_t size = fread(dest, 1, 446, fp); // only read up to bootloader size
  fclose(fp);
  return size;
}

size_t loadfile(const char *filename, char *dest) {
  FILE *fp = fopen(filename, "rb");
  if (!fp) {
    printf("> error: file '%s' not found.\n", filename);
    exit(1);
  }

  // Get file size
  fseek(fp, 0, SEEK_END);
  size_t filesize = ftell(fp);
  rewind(fp);

  // Read entire file
  size_t read_bytes = fread(dest, 1, filesize, fp);
  fclose(fp);

  if (read_bytes != filesize) {
    printf("> error: could not read entire file.\n");
    exit(1);
  }
  return filesize;
}

void navigate(void){
  uint16_t inodes_count     ; // Total number of inodes in the filesystem  
  uint16_t blocks_count     ; // Total number of data blocks         
  uint16_t free_inodes_count; // Number of free inodes                 
  uint16_t free_blocks_count; // Number of free blocks                
  uint16_t block_bitmap     ; // Block ID of the **block bitmap**
  uint16_t inode_bitmap     ; // Block ID of the **inode bitmap**
  uint16_t inode_table      ; // Starting block of **inode table**
  uint16_t first_data_block ; // Block number of the first data block   
  uint16_t used_dirs_count  ; // Number of inodes allocated to directories
  uint16_t log_block_size   ; // Block size = 1024 << `s_log_block_size` 
  uint32_t mtime            ; // Last mount time (unix time)              
  uint32_t wtime            ; // Last write time (unix time)              
  uint8_t  uuid[16]         ; // Unique ID of the filesystem            
  uint8_t  volume_name[16]  ; // Label of the filesystem               
  uint32_t feature_flags    ; // Compatibility flags                  

  time_t t_mtime;
  time_t t_wtime;

  struct superblock *superblock = (struct superblock *)superblock_p;

  int size = loadfile("disk.bin", disk);

  inodes_count      = superblock->inodes_count      ; // Total number of inodes in the filesystem  
  blocks_count      = superblock->blocks_count      ; // Total number of data blocks         
  free_inodes_count = superblock->free_inodes_count ; // Number of free inodes                 
  free_blocks_count = superblock->free_blocks_count ; // Number of free blocks                
  block_bitmap      = superblock->block_bitmap      ; // Block ID of the **block bitmap**
  inode_bitmap      = superblock->inode_bitmap      ; // Block ID of the **inode bitmap**
  inode_table       = superblock->inode_table       ; // Starting block of **inode table**
  first_data_block  = superblock->first_data_block  ; // Block number of the first data block   
  used_dirs_count   = superblock->used_dirs_count   ; // Number of inodes allocated to directories
  log_block_size    = superblock->log_block_size    ; // Block size = 1024 << `s_log_block_size` 
  mtime             = superblock->mtime             ; // Last mount time (unix time)              
  wtime             = superblock->wtime             ; // Last write time (unix time)              
  feature_flags     = superblock->feature_flags     ; // Compatibility flags                  
  memcpy(volume_name, superblock->volume_name, 16)  ; // Label of the filesystem               
  memcpy(uuid, superblock->uuid, 16)                ; // Unique ID of the filesystem            
 
  t_mtime = (time_t)mtime;
  t_wtime = (time_t)wtime;

  printf("\n");
  printf("Volume name: %s\n", volume_name);
  printf("UUID: ");
  for(int i = 15; i >= 0; i--){
    printf("%02x ", uuid[i]);
  }
  printf("\n");
  printf("Inodes Count: %d\n", inodes_count);
  printf("Blocks Count: %d\n", blocks_count);
  printf("Free Inodes Count: %d\n", free_inodes_count);
  printf("Free Blocks Count: %d\n", free_blocks_count);
  printf("Block Bitmap: %d\n", block_bitmap);
  printf("Inode Bitmap: %d\n", inode_bitmap);
  printf("Inode Table: %d\n", inode_table);
  printf("First Data Block: %d\n", first_data_block);
  printf("Used Dirs Count: %d\n", used_dirs_count);
  printf("Log Block Size: %d\n", log_block_size);
  printf("mtime: %s", ctime((time_t*)&t_mtime));
  printf("wtime: %s", ctime((time_t*)&t_wtime));
  printf("Feature Flags: %x\n", feature_flags);

  char command[MAX_ID_LEN];
  for(;;){
    printf("%s: ", fs_state.directory_str);
    if(fgets(command, MAX_ID_LEN, stdin)){
      command[strcspn(command, "\n")] = 0;
      printf("%s\n", command);
    }
  }
}

int cd(char *path){
  
}

void read_partition(){
  uint16_t inodes_count     ; // Total number of inodes in the filesystem  
  uint16_t blocks_count     ; // Total number of data blocks         
  uint16_t free_inodes_count; // Number of free inodes                 
  uint16_t free_blocks_count; // Number of free blocks                
  uint16_t block_bitmap     ; // Block ID of the **block bitmap**
  uint16_t inode_bitmap     ; // Block ID of the **inode bitmap**
  uint16_t inode_table      ; // Starting block of **inode table**
  uint16_t first_data_block ; // Block number of the first data block   
  uint16_t used_dirs_count  ; // Number of inodes allocated to directories
  uint16_t log_block_size   ; // Block size = 1024 << `s_log_block_size` 
  uint32_t mtime            ; // Last mount time (unix time)              
  uint32_t wtime            ; // Last write time (unix time)              
  uint8_t  uuid[16]         ; // Unique ID of the filesystem            
  uint8_t  volume_name[16]  ; // Label of the filesystem               
  uint32_t feature_flags    ; // Compatibility flags                  

  time_t t_mtime;
  time_t t_wtime;

  struct superblock *superblock = (struct superblock *)superblock_p;

  int size = loadfile("disk.bin", disk);

  inodes_count      = superblock->inodes_count      ; // Total number of inodes in the filesystem  
  blocks_count      = superblock->blocks_count      ; // Total number of data blocks         
  free_inodes_count = superblock->free_inodes_count ; // Number of free inodes                 
  free_blocks_count = superblock->free_blocks_count ; // Number of free blocks                
  block_bitmap      = superblock->block_bitmap      ; // Block ID of the **block bitmap**
  inode_bitmap      = superblock->inode_bitmap      ; // Block ID of the **inode bitmap**
  inode_table       = superblock->inode_table       ; // Starting block of **inode table**
  first_data_block  = superblock->first_data_block  ; // Block number of the first data block   
  used_dirs_count   = superblock->used_dirs_count   ; // Number of inodes allocated to directories
  log_block_size    = superblock->log_block_size    ; // Block size = 1024 << `s_log_block_size` 
  mtime             = superblock->mtime             ; // Last mount time (unix time)              
  wtime             = superblock->wtime             ; // Last write time (unix time)              
  feature_flags     = superblock->feature_flags     ; // Compatibility flags                  
  memcpy(volume_name, superblock->volume_name, 16)  ; // Label of the filesystem               
  memcpy(uuid, superblock->uuid, 16)                ; // Unique ID of the filesystem            
 
  t_mtime = (time_t)mtime;
  t_wtime = (time_t)wtime;

  printf("\n");
  printf("Volume name: %s\n", volume_name);
  printf("UUID: ");
  for(int i = 15; i >= 0; i--){
    printf("%02x ", uuid[i]);
  }
  printf("\n");
  printf("Inodes Count: %d\n", inodes_count);
  printf("Blocks Count: %d\n", blocks_count);
  printf("Free Inodes Count: %d\n", free_inodes_count);
  printf("Free Blocks Count: %d\n", free_blocks_count);
  printf("Block Bitmap: %d\n", block_bitmap);
  printf("Inode Bitmap: %d\n", inode_bitmap);
  printf("Inode Table: %d\n", inode_table);
  printf("First Data Block: %d\n", first_data_block);
  printf("Used Dirs Count: %d\n", used_dirs_count);
  printf("Log Block Size: %d\n", log_block_size);
  printf("mtime: %s", ctime((time_t*)&t_mtime));
  printf("wtime: %s", ctime((time_t*)&t_wtime));
  printf("Feature Flags: %x\n", feature_flags);

  printf("\n");
  print_inode_table();
  printf("\n\n");
  print_bitmap_table();
  printf("\n");

  // BLOCK BITMAP
  // start block: 2
  // start offset: 4096
  // size = 4 * 2048 = 8192 bytes
  if(show_block_bitmap){
    printf("\nBLOCK BITMAP\n");
    for(int i = 0; i < BLOCKS_BITMAP_SIZE; i++){
      printf("%02x ", *(blocks_bitmap_p + i));
      if((i + 1) % 16 == 0) printf("\n");
    }
  }

  // INODE BITMAP
  // start block: 6
  // start offset: 12288
  // size = 1 block = 2048 bytes
  if(show_inode_bitmap){
    printf("\n\nINODE BITMAP\n");
    for(int i = 0; i < INODE_BITMAP_SIZE; i++){
      printf("%02x ", *(inode_bitmap_p + i));
      if((i + 1) % 16 == 0) printf("\n");
    }
  }
}

void print_inode_table(){
  struct inode_table_entry *inode_entry_p;
  uint8_t inode_byte;
  uint32_t total_num_bytes_used = 0;

  printf("*** inode table ***\n");
  // run through inode bitmap bytes 0 to 2047 (NUM_INODES / 8) == (16384 / 8) == 2048
  for(int i = 0; i < NUM_INODES / 8; i++){
    inode_byte = *(inode_bitmap_p + i); // read byte
    for(int j = 0; j < 8; j++){ 
      if((inode_byte & (0x01 << j))){
        inode_entry_p = inode_table_p + i * 8 + j;
        printf("inode: %d, num blocks: %d( ", i * 8 + j, inode_entry_p->blocks);
        for(int i = 0; i < inode_entry_p->blocks; i++){
          if(inode_entry_p->block[i]) printf("%d ", inode_entry_p->block[i]);
          total_num_bytes_used += BLOCK_SIZE;
        }
        printf("), mode: %x, size: %d bytes\n", inode_entry_p->mode, inode_entry_p->size);
      }
    }
  }

  printf("\ndisk used: %d bytes\n", total_num_bytes_used);
//  printf("\n\n*** inode table bit layout ***\n");
//  // run through inode bitmap bytes 0 to 2047 (NUM_INODES / 8) == (16384 / 8) == 2048
//  for(int i = 0; i < NUM_INODES / 8; i++){
//    inode_byte = *(inode_bitmap_p + i); // read byte
//    for(int j = 0; j < 8; j++){ 
//      printf("%1d", (inode_byte & (0x01 << j)) == 0 ? 0 : 1);
//    }
//  }

}

void print_bitmap_table(){
  uint8_t data_byte;

  printf("*** data blocks bitmap ***\n");
  for(int i = 0; i < NUM_DATA_BLOCKS / 8; i++){
    data_byte = *(blocks_bitmap_p + i); // read byte
    printf("%02x ", data_byte);
  }
}

uint16_t inode_bitmap_alloc(){
  uint8_t inode_byte;

  // run through inode bitmap bytes 0 to 2047 (NUM_INODES / 8) == (16384 / 8) == 2048
  for(int i = 0; i < NUM_INODES / 8; i++){
    inode_byte = *(inode_bitmap_p + i); // read byte
    for(int j = 0; j < 8; j++){ 
      if((inode_byte & (0x01 << j)) == 0){
        *(inode_bitmap_p + i) = *(inode_bitmap_p + i) | (0x01 << j); // set inode as used
        return i * 8 + j; // check each bit inside the byte
      }
    }
  }

  return -1;
}

uint16_t block_bitmap_alloc(){
  uint8_t block_byte;

  // run through block bitmap bytes 0 to 8190 (NUM_DATA_BLOCKS / 8) == (65528 / 8) == 8191
  for(int i = 0; i < NUM_DATA_BLOCKS / 8; i++){
    block_byte = *(blocks_bitmap_p + i); // read byte
    for(int j = 0; j < 8; j++){ 
      if((block_byte & (0x01 << j)) == 0){
        *(blocks_bitmap_p + i) = *(blocks_bitmap_p + i) | (0x01 << j); // set block as used
        superblock_free_blocks_dec();
        memset(data_blocks_p + (i * 8 + j), 0, BLOCK_SIZE); // fill the data b,ock with 0's
        return i * 8 + j; // return block number
      }
    }
  }

  return -1;
}

uint16_t create_inode(struct inode_table_entry inode_entry){
  uint16_t inode_index;

  if((inode_index = inode_bitmap_alloc()) != -1){
    *(inode_table_p + inode_index) = inode_entry;
    superblock_free_inodes_dec();
    return inode_index;
  }

  return -1;
}

  // ADD . AND .. ENTRIES TO DATA BLOCK
void init_directory(uint16_t block_index, uint16_t self_inode, uint16_t parent_dir_inode){
  uint8_t *block_p = (uint8_t *)(data_blocks_p + block_index);

  memset(block_p, 0, BLOCK_SIZE);

  // Entry 1: "."
  struct directory_entry *dot = (struct directory_entry *)(block_p);
  dot->inode = self_inode;
  strcpy(dot->name, ".");

  // Entry 2: ".."
  struct directory_entry *dotdot = (struct directory_entry *)(block_p + DIR_ENTRY_LEN);
  dotdot->inode = parent_dir_inode;
  strcpy(dotdot->name, "..");
}

// allocate free block for directory
// allocate new inode for directory
// initialize new block as an empty directory
// add new directory entry to parent directory
//   search through block pointer list in parent inode
//   for each block, search for space to add new entry
uint16_t create_directory(char *name, uint16_t parent_dir_inode){
  struct inode_table_entry new_inode;
  uint16_t inode_num;
  uint16_t block_num;
  uint8_t *parent_data_block_p;
  uint16_t parent_block_num;
  struct directory_entry *curr_entry;

  // create inode for directory
  block_num = block_bitmap_alloc();
  memset(&new_inode, 0, sizeof(new_inode)); // reset entire inode
  new_inode.mode        = 0x41ED;   // directory (0x4000) + rwxr-xr-x (0x1ED)
  new_inode.uid         = 0;        // root user
  new_inode.gid         = 0;
  new_inode.size        = 2048;     // one block for the directory
  new_inode.atime       = new_inode.ctime = new_inode.mtime = time(NULL);
  new_inode.links_count = 1;        // "."
  new_inode.blocks      = 1; 
  new_inode.block[0]    = block_num; // set index of block #0 to new found block
  inode_num = create_inode(new_inode); // create and insert new inode into inode table
  init_directory(block_num, inode_num, parent_dir_inode); // initialize new block as an empty directory

  struct superblock *sp = (struct superblock *)superblock_p;
  sp->used_dirs_count++;

  // inode(2) | name(62) |   total size = 64
  // add new entry to parent directory based on parent_dir_inode
  for(int i = 0; i < NUM_INODE_BLOCK_POINTERS; i++){ // loop through each of the direct pointer blocks
    parent_block_num = (inode_table_p + parent_dir_inode)->block[i];
    if(parent_block_num == 0){ // if the block we are working with does not actually exist, then allocate it
      (inode_table_p + parent_dir_inode)->block[i] = parent_block_num = block_bitmap_alloc();
      printf("> block pointer %d empty. allocating new data block: %d\n", i, parent_block_num);
    }
    // pointer to the directory block
    parent_data_block_p = (uint8_t *)(data_blocks_p + parent_block_num); 
    // search for space inside block for new entry
    for(int i_entry = 0; i_entry < NUM_DIR_ENTRIES; i_entry++){
      curr_entry = (struct directory_entry *)parent_data_block_p + i_entry;
      if(curr_entry->inode == 0){ // empty entry
        curr_entry->inode = inode_num;
        strcpy(curr_entry->name, name);
        printf("  directory created: %s (%d)\n", name, inode_num);
        return inode_num; // after adding new entry, return
      }
    }
  }
}

uint16_t create_file(char *name, char * filename, uint16_t parent_dir_inode){
  struct inode_table_entry new_inode;
  struct directory_entry *curr_entry;
  uint16_t inode_num;
  uint8_t *data_block_p;
  uint16_t num_blocks_needed;
  uint16_t parent_block_num;
  uint8_t *parent_data_block_p;
  uint8_t file_image[BLOCK_SIZE * NUM_INODE_BLOCK_POINTERS]; // image of maximum file size
  uint32_t file_size;

  file_size = loadfile(filename, file_image); // load the file from disk and write to image
  num_blocks_needed = (file_size + BLOCK_SIZE - 1) / BLOCK_SIZE; // find the number of blocks needed to keep file.  a partial block count as full block.
  printf("> creating file: %s, %d bytes, %d blocks\n", name, file_size, num_blocks_needed);
  if(num_blocks_needed > NUM_INODE_BLOCK_POINTERS){
    printf("  error: file size exceeds maximum allowed of %d bytes, %d blocks\n", NUM_INODE_BLOCK_POINTERS * BLOCK_SIZE, NUM_INODE_BLOCK_POINTERS);
    exit(1);
  }

  // create inode for the file
  memset(&new_inode, 0, sizeof(new_inode)); // reset entire inode
  new_inode.mode        = 0x81ED;   // regular file (0x8000) + rwxr-xr-x (0x1ED)
  new_inode.uid         = 0;        // root user
  new_inode.gid         = 0;
  new_inode.size        = file_size;     // file size
  new_inode.atime       = new_inode.ctime = new_inode.mtime = time(NULL);
  new_inode.links_count = 1;
  new_inode.blocks      = num_blocks_needed; // number of data blocks used by this file
  for(int i = 0; i < num_blocks_needed; i++) // allocate data blocks for file
    new_inode.block[i] = block_bitmap_alloc();
  inode_num = create_inode(new_inode); // create and insert new inode into inode table

  superblock_free_inodes_dec(); // decrease total number of free inodes in superblock

  // now copy the file contents into the data blocks
  for(int i = 0; i < num_blocks_needed; i++){ // allocate data blocks for file
    data_block_p = (uint8_t *)(data_blocks_p + new_inode.block[i]);
    memcpy((void *)(data_block_p + i), (void *)(&file_image[i * BLOCK_SIZE]), BLOCK_SIZE);
  }

  // now add an entry for this file into the parent directory
  // inode(2) | name(62) |   total size = 64
  printf("  new inode for file: %d. now adding file entry into directory with inode: %d\n", inode_num, parent_dir_inode);
  for(int i = 0; i < NUM_INODE_BLOCK_POINTERS; i++){ // loop through each of the direct pointer blocks
    parent_block_num = (inode_table_p + parent_dir_inode)->block[i];
    if(parent_block_num == 0){ // if the block we are working with does not actually exist, then allocate it
      (inode_table_p + parent_dir_inode)->block[i] = parent_block_num = block_bitmap_alloc();
      printf("  block pointer %d empty. allocating new data block: %d\n", i, parent_block_num);
    }
    // pointer to the directory block
    parent_data_block_p = (uint8_t *)(data_blocks_p + parent_block_num); 
    // search for space inside block for new entry
    for(int i_entry = 0; i_entry < NUM_DIR_ENTRIES; i_entry++){
      curr_entry = (struct directory_entry *)parent_data_block_p + i_entry;
      if(curr_entry->inode == 0){ // empty entry
        curr_entry->inode = inode_num;
        strcpy(curr_entry->name, name);
        return inode_num; // after adding new entry, return
      }
    }
  }
}

char *name_from_inode(char *name, uint16_t inode, uint16_t parent_dir_inode){
  uint8_t *curr_data_block_p;
  uint16_t curr_block_num;
  struct directory_entry *curr_entry;

  // inode(2) | name(62) |   total size = 64
  for(int i = 0; i < NUM_INODE_BLOCK_POINTERS; i++){ // loop through each of the direct pointer blocks
    curr_block_num = (inode_table_p + parent_dir_inode)->block[i];
    if(curr_block_num == 0) continue; // if block not allocated, skip it
    // pointer to the directory block
    curr_data_block_p = (uint8_t *)(data_blocks_p + curr_block_num); 
    // search for space inside block for new entry
    for(int i_entry = 0; i_entry < NUM_DIR_ENTRIES; i_entry++){
      curr_entry = (struct directory_entry *)curr_data_block_p + i_entry;
      if(curr_entry->inode == inode){
        strcpy(name, curr_entry->name);
        return name; 
      }
    }
  }
  name[0] = '\0';
  strcpy(name, "not found");
  return name;
}

void print_directory(uint16_t dir_inode){
  uint8_t *dir_data_block_p;
  uint16_t dir_block_num;
  struct directory_entry *dir_entry;

  // inode(2) | name(62) |   total size = 64
  for(int i = 0; i < NUM_INODE_BLOCK_POINTERS; i++){
    dir_block_num = (inode_table_p + dir_inode)->block[i];
    if(dir_block_num == 0) continue; // if block not allocated, skip it
    // pointer to the directory block
    dir_data_block_p = (uint8_t *)(data_blocks_p + dir_block_num);
    // search for space inside block for new entry
    for(int i_entry = 0; i_entry < NUM_DIR_ENTRIES; i_entry++){
      dir_entry = (struct directory_entry *)dir_data_block_p + i_entry;
      if(dir_entry->inode != 0){
        printf("%d %s\n", dir_entry->inode, dir_entry->name);
      }
    }
  }
}

uint16_t superblock_free_blocks_dec(){
  return --(((struct superblock *)(superblock_p))->free_blocks_count); // decrease number of free blocks in superblock
}

uint16_t superblock_free_blocks_inc(){
  return ++(((struct superblock *)(superblock_p))->free_blocks_count); // decrease number of free blocks in superblock
}

uint16_t superblock_free_inodes_dec(){
  return --(((struct superblock *)(superblock_p))->free_inodes_count); // decrease number of free blocks in superblock
}

uint16_t superblock_free_inodes_inc(){
  return ++(((struct superblock *)(superblock_p))->free_inodes_count); // decrease number of free blocks in superblock
}