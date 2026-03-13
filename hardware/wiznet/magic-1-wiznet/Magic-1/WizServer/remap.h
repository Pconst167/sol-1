#ifndef _REMAP_H
#define _REMAP_H
#include <minix/config.h>
#include <minix/type.h>
u8_t* remap_dev_page(phys_bytes base, int fast);
void remap_page(u8_t* res, phys_bytes base, int fast);

#endif
