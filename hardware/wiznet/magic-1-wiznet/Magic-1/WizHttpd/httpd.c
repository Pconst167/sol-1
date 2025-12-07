#include <minix/config.h>
#include <sys/types.h>
#include <sys/ioctl.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <unistd.h>
#include <net/netlib.h>
#include <net/hton.h>
#include <net/gen/in.h>
#include <net/gen/inet.h>
#include <net/gen/tcp.h>
#include <net/gen/tcp_io.h>
#include <net/gen/socket.h>
#include <net/gen/netdb.h>
#include <dirent.h>
#include <sys/stat.h>

#include "net.h"

#define FS_IMAGE "/usr/www/fs"
#define MAX_IMAGES 20

void donothing(int sig) {(void)sig;}

extern void html_finger(char* buf, size_t buf_size);

#define BIG_BUF_SIZE 8192
#define SMALL_BUF_SIZE 256
char bigbuf[BIG_BUF_SIZE];
char sbuf[SMALL_BUF_SIZE];
nwio_hitcount_t hits;
int verbose;

char* p404error = "HTTP/1.0 404 Not Found\nContent-Type: text/html\nContent-Length: 37\n\n<html><h1>404 Not Found</h1></html>\n\n";

char* p501error = "HTTP/1.0 501 Not Implemented\n\n";

typedef struct fs_entry_t {
  char* fname;
  char* text;
  unsigned int len;
  int is_static;
} fs_entry_t;

fs_entry_t* fs_image[MAX_IMAGES];
int num_images = 0;

#ifndef true
#define true 1
#define false 0
#endif
#ifndef TRUE
#define TRUE 1
#define FALSE 0
#endif


char* test_page = "HTTP/1.0 200 OK\nContent-Type: text/html\n\n<html>Hello World from Magic-1's Wiznet WIZ830MJ\n</html>";

char* text_header = "HTTP/1.0 200 OK\nContent-Type: text/html\nContent-Length: %d\n\n";
char* icon_header = "HTTP/1.0 200 OK\nContent-Type: image/x-icon\nContent-Length: %d\n\n";
char* jpg_header = "HTTP/1.0 200 OK\nContent-Type: image/jpeg\nContent-Length: %d\n\n";

static void alarm_handler(int sig) {
  (void)sig;
  // Nothing really to do here - just used to break out of read() on timeouts.
}

static char* strdup(char* str) {
  int len = strlen(str);
  char* res = (char*)malloc(len + 1);
  strcpy(res, str);
  return res;
}

void read_images(char* fs) {
  DIR* dip;
  int i;
  struct dirent* dit;
  u16_t total_len = 0;
  (void)dit;
  if ((dip = opendir(fs)) == NULL) {
    fprintf(stderr, "httpd: Could not open image directory: %s\n", fs);
    return;
  }
  while ((dit = readdir(dip)) != NULL) {
    struct stat st;
    char buf[256];
    char header_buf[256];
    char* header;
    int header_len;
    fs_entry_t* fse = (fs_entry_t*)malloc(sizeof(fs_entry_t));
    if (dit->d_name[0] == '.') continue;  // Skip hidden files.
    strcpy(buf, fs);
    strcat(buf, "/");
    strcat(buf, dit->d_name);
    stat(buf, &st);
    if (strstr(dit->d_name, ".htm")) {
      header = text_header;
    } else if (strstr(dit->d_name, ".ico")) {
      header = icon_header;
    } else if (strstr(dit->d_name, ".jpg")) {
      header = jpg_header;
    } else {
      printf("httpd: Unrecognized file type for %s\n", dit->d_name);
      continue;
    }
    sprintf(header_buf, header, (unsigned int)st.st_size);
    header_len = strlen(header_buf);
    fse->len = header_len + (unsigned int)st.st_size;
    fse->fname = strdup(dit->d_name);
    fse->is_static = true;
    fse->text = (char*)malloc(header_len + fse->len + 10);
    if (fse->text != NULL) {
      int fd;
      int r;
      strcpy(fse->text, header_buf);
      fd = open(buf, O_RDONLY);
      r = read(fd, fse->text + header_len, (unsigned int)st.st_size);
      if (r != (int)st.st_size) {
        fprintf(stderr, "httpd: bad read for %s\n", buf);
        printf("header len = %d, st_size = %d\n", header_len, (int)st.st_size);
        printf("r = %d, fse->len = %d\n", r, fse->len);
        free(fse->text);
        fse->text = NULL;
      } else {
        total_len += fse->len;
      }
      close(fd);
    }
    fs_image[num_images] = fse;
    num_images++;
  }
  closedir(dip);
  printf("httpd: Found %d files\n", num_images);
  for (i = 0; i < num_images; i++) {
    printf("File[%d]: %s, %u\n", i, fs_image[i]->fname,
        (u16_t)fs_image[i]->len);
  }
  printf("httpd: Cached %u total bytes\n", total_len);
}

char* get_file_request(char* buf) {
  char* res = strstr(buf, "GET ");
  if (res != buf) {
    res = NULL;
  }
  if (res != NULL) {
    char* q;
    res += 4;
    q = strstr(res," ");
    if (q != NULL) {
      *q = 0;
    } else {
      res = NULL;
    }
  }
  if (!strcmp(res, "index.html") ||
      !strcmp(res, "index.htm") ||
      !strcmp(res, "/")) {
    res = "index.html";
  }
  return res;
}

fs_entry_t tfse;

fs_entry_t* get_file_response(char* fname) {
  int i;
  if (fname[0] == '/') {
    fname++;
  }
  if (/*!strcmp(fname, "html_finger.cg") ||*/ !strcmp(fname, "html_ps.cgi")) {
    int fd;
    int index = 0;
    int r;
    char* dev_file = (!strcmp(fname, "html_finger.cg") ? "/proc/finger"
                                                       : "/proc/ps");
    fd = open(dev_file, O_RDONLY);
    if (fd < 0) {
      if (verbose) {
        printf("httpd: Could not open %s\n", dev_file);
      }
    }
    while (true) {
      // Note: this should protect against overflow.  We'd request a zero-length
      // read, which will break the loop.
/*
 * We have an issue with html_ps.cgi.  It seems to sometimes get hung and
 * not respond.  Set a timer and kill it off if needed.
 */
      signal(SIGALRM, donothing);
      alarm(5);
      r = read(fd, bigbuf + index, (BIG_BUF_SIZE - 1) - index);
      alarm(0);
      if (r <= 0) {
        break;
      } else {
        index += r;
      }
    }
    close(fd);
    tfse.fname = dev_file;
    tfse.text = bigbuf;
    tfse.len = index;
    tfse.is_static = true;
    return &tfse;
  }
  for (i = 0; i < num_images; i++) {
    if (!strcmp(fname, fs_image[i]->fname)) {
      return fs_image[i];
    }
  }
  return NULL;
}

int main(int argc, char** argv) {
  int socket;
  int r;
  struct sigaction sa;
  FILE* logfile;
  char logname[40];
  snprintf(logname, 40, "/tmp/log.%d", getpid());
  logfile = fopen(logname, "w");
  verbose = ((argc == 2) && !strcmp(argv[1], "-d"));
  // st_init("/usr/bin/whttpd", SIGUSR2);
  printf("httpd server\n");
  read_images(FS_IMAGE);
  sa.sa_flags = 0;
  sigfillset(&sa.sa_mask);
  sa.sa_handler = alarm_handler;
  sigaction(SIGALRM, &sa, 0);
  socket = open_http_socket("http");
  if (socket < 0) {
    printf("httpd: No socket available - exiting\n");
    return 1;
  }
  if (verbose) {
    printf("httpd: Socket = %d\n", socket);
    printf("httpd: Listening....\n");
    fflush(stdout);
  }
  while (true) {
    int res;
    ipaddr_t last_clients[16];
    ipaddr_t new_client;
    int client_idx;
    int i;
    res = get_http_client(socket);
    if (res >= 0) {
      int client_res;
      int reject_count = 0;
      nwio_tcpconf_t tcpconf;
      client_res = ioctl(socket, NWIOGTCPCONF, &tcpconf);
      if (client_res < 0) {
        fprintf(logfile, "No client, reset\n");
        fflush(logfile);
        continue;
      } else {
        new_client = tcpconf.nwtc_remaddr;
      }
      // Check for ddos attack
      client_idx &= 0xf;  // Fast mod 16
      last_clients[client_idx] = new_client;
      client_idx++;
      client_idx &= 0xf;  // Fast mod 16
      for (i = 0; i < 16; i++) {
        if (new_client == last_clients[client_idx++]) {
          reject_count++;
        }
        client_idx &= 0xf;  // Fast mod 16
      }
      if (reject_count > 10) {
        if (reject_count == 11) {
          // Just print message once - otherwise may fill up /tmp
          fprintf(logfile, "** Reject %s\n", get_client_ip(socket));
          fflush(logfile);
        }
        continue;
      } else {
        fprintf(logfile, "Accept %s\n", get_client_ip(socket));
        fflush(logfile);
      }

      if (verbose) {
        printf("httpd: Got client\n");
        get_net_info(socket);
        printf("Host: %s, Client: %s, Client addr: %s\n", myhostname,
            rmthostname, rmthostaddr);
        fflush(stdout);
      }
      alarm(6);
      r = read(socket, bigbuf, BIG_BUF_SIZE);
      alarm(0);
      if (verbose) {
        printf("httpd: Got %d bytes\n", r);
        fflush(stdout);
      }
      if ((r > 0) && (r < BIG_BUF_SIZE)) {
        bigbuf[r] = 0;
        if (verbose) {
          printf("%s\n", bigbuf);
          fflush(stdout);
        }
      }
      if (r > 0) {
        char* fname = get_file_request(bigbuf);
        char* response;
        u16_t response_len = 0;
        int written = 0;
        ioctl(socket, NWIOADDHITCOUNT, 0);
        ioctl(socket, NWIOGETHITCOUNT, &hits);
        if (fname == NULL) {
          response = p501error;
          response_len = strlen(response);
        } else {
          fs_entry_t* f = get_file_response(fname);
          if (f == NULL) {
            response = p404error;
            response_len = strlen(p404error);
          } else if (!strcmp(f->fname, "about.html") ||
              !strcmp(f->fname, "index.html")) {
            char* p;
            memcpy(bigbuf, f->text, f->len);
            p = strstr(bigbuf, "X hits since last reboot");
            if (p) {
              char nbuf[32];
              sprintf(nbuf, "%ld hits since last reboot", hits.hit_count);
              memcpy(p, nbuf, strlen(nbuf));
            }
            response = bigbuf;
            response_len = strlen(bigbuf);
          } else {
            response = f->text;
            response_len = f->len;
          }
        }
        written = 0;
        while (written < response_len) {
          int w;
          w = write(socket, response, response_len - written);
          if (w <= 0) {
#if 0
            // FIXME: can we recover?  should we expect EINTR here?
            printf("httpd: Bad write, %d - %s\n", w, strerror(errno));
            printf("socket: %d, response_len: %d, written: %d\n",
                socket, response_len, written);
            fflush(stdout);
#endif
            break;
          }
          written += w;
          response += w;
        }
      } else {
        if (errno != EINTR) {
#if 0
          printf("httpd: Unexpected read failure %s\n", strerror(errno));
#endif
        }
        if (verbose) {
          printf("httpd: timeout after connect.  Resetting socket\n");
          fflush(stdout);
        }
      }
    }
    if (verbose) {
      printf("httpd: Resetting socket\n");
      fflush(stdout);
    }
    if (reopen_http_socket(socket)) {
      printf("http: reset error - exiting\n");
      exit(1);
    }
  }
  printf("httpd: exiting normally\n");
  return 0;
}
