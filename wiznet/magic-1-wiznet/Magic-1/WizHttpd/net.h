/* net.h
 *
 * This file is part of httpd.
 *
 *
 * 01/25/1996 			Michael Temari <Michael@TemWare.Com>
 * 07/07/1996 Initial Release	Michael Temari <Michael@TemWare.Com>
 * 12/29/2002			Michael Temari <Michael@TemWare.Com>
 *
 */

#define ERR_UNKNOWN_SERVICE -2
#define ERR_CANT_OPEN -3
#define ERR_CANT_CONFIGURE -4

char* get_client_ip(int socket);
void get_net_info(int socket);
int open_http_socket(char* service);
int reopen_http_socket(int socket);
int get_http_client(int socket);

extern int verbose;
extern char myhostname[256];
extern char rmthostname[256];
extern char rmthostaddr[3+1+3+1+3+1+3+1];
