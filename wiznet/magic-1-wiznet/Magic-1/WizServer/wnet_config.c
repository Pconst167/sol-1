#include "common.h"
#include <sys/stat.h>
#define DEBUG 1

// NOTE: this file compiled for SYSTEM, or error number must be negated
static void fatal(char* msg) {
  printf("Fatal error: %s\n", msg);
  exit(-1);
}

#if 0
// Unused?
static void check_rm(char *device)
  /* Check if a device is not among the living. */
{
  if (unlink(device) < 0) {
    if (errno == -ENOENT) return;
    assert(0);
  }
}
#endif

static void check_mknod(char *device, mode_t mode, int minor)
  /* Check if a device exists with the proper device number. */
{
  struct stat st;
  dev_t dev;

  dev= (ip_dev & (unsigned)0xFF00) | minor;

  if (stat(device, &st) < 0) {
    if (errno != -ENOENT) {
      printf("Stat failure: %s\n", strerror(-errno));
      fatal(device);
    }
  } else {
    if (S_ISCHR(st.st_mode) && st.st_rdev == dev) {
      if (verbose > 0) {
        printf("Device %s good to go\n", device);
      }
      return;
    }
    if (verbose > 0) {
      printf("Old device %s has wrong mode, removing\n", device);
    }
    if (unlink(device) < 0) fatal(device);
  }

  if (verbose > 0) {
    printf("Doing mknod for %s: 0x%04x\n", device, dev);
  }
  if (mknod(device, S_IFCHR | mode, dev) < 0) fatal(device);
}

static void check_ln(char *old, char *new)
  /* Check if 'old' and 'new' are still properly linked. */
{
  struct stat st_old, st_new;

  if (stat(old, &st_old) < 0) fatal(old);
  if (stat(new, &st_new) < 0) {
    if (errno != -ENOENT) fatal(new);
  } else {
    if (st_new.st_dev == st_old.st_dev
        && st_new.st_ino == st_old.st_ino) {
      return;
    }
    if (unlink(new) < 0) fatal(new);
  }

  if (link(old, new) < 0) fatal(new);
}

void create_devices() {
  static struct devlist {
    char	*defname;
    mode_t	mode;
    u8_t	minor_off;
  } devlist[] = {
    {	"/dev/wdebug",	0600,	WIZ_DEBUG_DEV_OFF	},
    {	"/dev/wip",	0600,	WIZ_IP_DEV_OFF	},
    {	"/dev/wtcp",	0666,	WIZ_TCP_DEV_OFF	},
    {	"/dev/wudp",	0666,	WIZ_UDP_DEV_OFF	},
  };
  struct devlist *dvp;
  int i;
  char device[sizeof("/dev/wdebug0")];
  char *dp;
  struct stat st;

  // Set umask 0 so we can creat mode 666 devices.
  (void) umask(0);

  /* See what the device number of /dev/wip is.  That's what we
   * used last time for the network devices, so we keep doing so.
   */
  // Get major device number for /dev/wip.
  if (verbose > 0) {
    printf("Looking for /dev/wip\n");
  }
  if (stat("/dev/wip", &st) < 0) fatal("/dev/wip not found");
  ip_dev= st.st_rdev;
  if (verbose > 0) {
    printf("Major/minor of /dev/wip is 0x%04x\n", ip_dev);
  }
  for (i= 0; i < sizeof(devlist) / sizeof(devlist[0]); i++) {
    dvp= &devlist[i];
    strcpy(device, dvp->defname);
    dp= device + strlen(device);
    *dp++ = '0';
    *dp = 0;
    // check_rm(device);  /* Needed? */
    check_mknod(device, dvp->mode, dvp->minor_off);
    check_ln(device, dvp->defname);
  }
}
