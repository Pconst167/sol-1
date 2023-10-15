/*
 * Remap the device page containig the Wiznet device into our process space. 
 */
#include "common.h"
#include <minix/config.h>
#include <fcntl.h>
#include <minix/const.h>
#include <minix/type.h>
#include <sys/ioc_memory.h>
#include "../kernel/const.h"

//#define SHOW_OFFSETS

#define PAGE_ALIGN(x) (((u16_t)x + ((u16_t)PAGE_SIZE-1)) & ~((u16_t)PAGE_SIZE-1))
#define PAGE_OFF(x) ((u16_t)x & ((u16_t)PAGE_SIZE-1))
#define PAGE_BASE(x) ((phys_bytes)x & ~((phys_bytes)PAGE_SIZE-1))

/*
 * Returns the address of a page in the current process's
 * virtual address range that is mapped to a page in device
 * memory.
 */
void remap_page(u8_t *res, phys_bytes base, int fast)
{
  struct mio_remap remap;
  int dmemfd;
  if ((dmemfd = open("/dev/dmem", O_WRONLY)) == -1) {
    printf("Couldn't open /dev/dmem.  Are you root?\n");
    exit(-1);
  }
  remap.new_page = (phys_bytes)PAGE_BASE(base);
  remap.vir_page = (vir_bytes)res;
  remap.is_text = FALSE;
  remap.wiznet_signals = TRUE;
  remap.page_attributes = DEVICE_WRITEABLE_PAGE;
  if (fast) {
    remap.page_attributes |= PAGE_NO_WAIT;
  }
  if (ioctl(dmemfd, MIOCREMAP, (void *)&remap) == -1) {
    printf("Couldn't remap page\n");
    exit(-1);
  }
}

#define NUM_REMAPS 1
int num_remapped = 0;
u8_t remap_buf[PAGE_SIZE * (NUM_REMAPS + 1)];

u8_t* remap_dev_page(phys_bytes base, int fast)
{
  u8_t* start_page;
  u8_t* res;
  if (num_remapped >= NUM_REMAPS) {
    printf("Error: number of remaps exceeded: %d\n", num_remapped);
    printf("Looping, because we can't exit\n");
    while (1) {
    }
    // exit(-1);
  }
  start_page = (u8_t*)PAGE_ALIGN(&remap_buf[0]);
  res = start_page + (num_remapped * PAGE_SIZE);
  num_remapped++;
  remap_page(res, base, fast);
#ifdef SHOW_OFFSETS
  printf("Starting page = 0x%x\n", (unsigned int)start_page);
  printf("base = 0x%x\n", (unsigned int)base);
  printf("PAGE_OFF(base) = 0x%x\n", (unsigned int)PAGE_OFF(base));
  printf("res = 0x%x\n", (unsigned int)(res + PAGE_OFF(base)));
#endif
  return res + PAGE_OFF(base);
}
