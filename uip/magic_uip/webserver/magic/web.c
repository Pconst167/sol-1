////////////////////////////////////////////////
//  Magic-1 Web Server
//
//  based on Adam Dunkel's uIP
//
//  User-mode
////////////////////////////////////////////////

#include <sys/types.h>
#include <string.h>
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include "m1.h"
#include "uipopt.h"

#define TRUE 1
#define FALSE 0

typedef struct time_server_t {
    u16_t addr[4];
    char *ip_name;
    char *full_name;
} time_server_t;

time_server_t time_servers[] = {
    {{129,6,15,28},"time-a.nist.gov","NIST, Gaithersburg, Maryland"},
    {{129,6,15,29},"time-b.nist.gov","NIST, Gaithersburg, Maryland"},
    {{132,163,4,101},"time-a.timefreq.bldrdoc.gov","NIST, Boulder, Colorado"},
    {{132,163,4,102},"time-b.timefreq.bldrdoc.gov","NIST, Boulder, Colorado"},
    {{132,163,4,103},"time-c.timefreq.bldrdoc.gov","NIST, Boulder, Colorado"},
    {{128,138,140,44},"utcnist.colorado.edu","University of Colorado, Boulder"},
    {{192,43,244,18},"time.nist.gov","NCAR, Boulder, Colorado"},
    /*{{131,107,1,10},"time-nw.nist.gov","Microsoft, Redmond, Washington"},*/
    {{69,25,96,13},"nist1.symmetricom.com","Symmetricom, San Jose, California"},
    {{216,200,93,8},"nist1-dc.glassey.com","Abovenet, Virginia"},
    {{208,184,49,9},"nist1-ny.glassey.com","Abovenet, New York City"},
    {{207,126,98,204},"nist1-sj.glassey.com","Abovenet, San Jose, California"},
    {{207,200,81,113},"nist1.aol-ca.truetime.com","TrueTime, AOL facility, Sunnyvale, California"},
    {{64,236,96,53},"nist1.aol-va.truetime.com","TrueTime, AOL facility, Virginia"},
    {{68,216,79,113},"nist1.columbiacountyga.gov","Columbia County, Georgia"}
};

//#define UIP_TIME0 129u
//#define UIP_TIME1 6u
//#define UIP_TIME2 15u
//#define UIP_TIME3 28u

#define UIP_TIME0 132u
#define UIP_TIME1 163u
#define UIP_TIME2 4u
#define UIP_TIME3 101u

#define MINUTES (60)
#define HOURS (60 * MINUTES)
#define TIME_SYNC_INTERVAL (5  * HOURS)

u16_t time_addr[2];

char boot_time[50];
char curr_time[50];
char sync_time[50];
char sign_time[50];
char start_time[50];
char version_string[50];

sysinfo_t sysinfo;

time_t outstanding_time_request = 0;

u16_t curr_time_server = 0;
u16_t num_time_servers = sizeof(time_servers)/sizeof(time_server_t);

// - Include source files here
#include "slipdev.h"
#include "m1slipdev.c"
#include "slipdev.c"
#include "uip.c"
#include "uip_arch.c"

#include "fs.c"
#include "cgi.c"
#include "httpd.c"

//#define FG

#define VERBOSE

#ifdef FG
void uip_log( char *msg) {
    printf("[log]: %s\n",msg);
}
#endif


#ifdef VERBOSE
void doip( u8_t *p ) {
    printf("%d.%d.%d.%d\n",p[0],p[1],p[2],p[3]);
}
#endif

void mygets(char *buf, int size) {
    int i = 0;
    while (i < size) {
	char ch;
	if (ch = kgetc(CONSOLE)) {
	    if (ch < ' ') {
	        buf[i] = 0;
	        return;
	    } else {
	        buf[i++] = ch;
	    }
        }
    }
}

int main() {
    u8_t i;
    u16_t trigger;

    time_t last_seconds;
    time_t time_now;
    u16_t quiet = TRUE;
    u16_t ch;
    u16_t tries;
    u16_t get_time = 0;
    u16_t get_seconds = 0;
    u16_t skip;
    char buf[10];

#ifdef FG
    printf("Web Server based on Alex Dunkels' uIP\n");
    printf("Password protected\n");
    printf("Enter password now: \n");
    mygets(buf,10);
    if (strcmp(buf,"xxxx")) {
	printf("Sorry - invalid password\n");
	exit(1);
    }
#endif

#ifndef FG
    (void)kioctl(CONSOLE,1);  // Disable ctl-c
#endif

    (void)kgetinfo(&sysinfo);

    quiet = !sysinfo.debug_uip;

    srand((int)sysinfo.boot_time);

    curr_time_server = rand() % num_time_servers;

    strftime(boot_time,50,"%A, %B %d 20%y - %I:%M:%S %p %Z",localtime(&sysinfo.boot_time));
    strftime(start_time,50,"%A, %B %d 20%y - %I:%M:%S %p %Z",localtime(&sysinfo.curr_time));
    sprintf(version_string,"OS Version %s",sysinfo.os_version);
    if (sysinfo.curr_udt) {
       strftime(sync_time,50,"%A, %B %d 20%y - %I:%M:%S %p %Z",localtime(&sysinfo.curr_time));
    } else {
       strcpy(sync_time,"No sync since boot\n");
    }

#ifdef FG
    uip_log("Starting Magic-1 Web server initialization");
    printf("Boot time: %s\n",boot_time);
    printf("Start time: %s\n",start_time);
    //printf("%s\n",mhz_string);
    printf("%s\n",version_string);
#endif

    uip_init();


    httpd_init();

    slipdev_init();

    last_seconds = time(0);

#ifdef FG
    printf("Press '@!' to stop\n");
    printf("Press '@v' for verbose mode\n");
#endif
    trigger = 0;
    tries = 0;
    skip = 0;

    while(1) {

// Just check for time every now and then
	if ((++skip & 0x3f)==0){
	    long delta;
        
	    (void)kgetinfo(&sysinfo);
            quiet = !sysinfo.debug_uip;
	    time_now = time(0);
	    delta = ((long)time_now - (long)sysinfo.curr_udt);
	    if (!quiet) {
#ifdef VERBOSE
	        printf("Time delta = %0ld, now = %08lx, curr_udt = %08lx\n",delta,time_now,sysinfo.curr_udt);
#endif
	    }
	    delta = labs(delta);
#ifdef VERBOSE
	    if (!quiet) {
	        printf("labs(delta) = %ld\n",delta);
	    }
#endif
	    if (delta > TIME_SYNC_INTERVAL) {
		delta = labs(time_now - outstanding_time_request);
#ifdef VERBOSE
		if (!quiet) {
		    printf("last request was 0x%lx, delta is now %ld\n",
			outstanding_time_request,delta);
		}
#endif
		if (delta > 30) {
#ifdef VERBOSE
		    if (!quiet) {
		        printf("Setting request for new seconds\n");
		    }
#endif
		    get_seconds = 1;
		    outstanding_time_request = time_now;
		} 
	    }
	}

#ifdef FG
        if (ch=kgetc(CONSOLE)) {
	    if (ch=='t') {
		get_time = 1;
	    } else if (ch == 's') {
		get_seconds = 1;
	    } else if (ch=='@') {
		trigger = trigger ^ 1;
	    } else if (trigger && (ch=='v')) {
	        printf("Verbose mode on\n");
	        quiet = FALSE;
		trigger = 0;
	    } else if (trigger && (ch=='!')) {
		exit(0);
	    } else {
		long ctime;
		trigger = 0;
		printf("Sorry, Magic-1 is serving web pages now.\n");
		printf("Point your browser to http://64.142.4.132\n");
		printf("Check back later for telnet access - thanks!\n");
		quiet = TRUE;
		for (i=0;i<10;i++) {
		    kgetc(CONSOLE);
		}
		if (tries++ > 4) {
		    printf("Disconnecting now\r\n\004");
		    tries = 0;
		}
		for (i=0;i<10;i++) {
		    kgetc(CONSOLE);
		}
	    }
	}
#endif

	uip_len = slipdev_read();

	if (uip_len == 0) {

	    if (get_time | get_seconds) {
		struct uip_conn *conn;
		if (++curr_time_server == num_time_servers) {
		    curr_time_server = 0;
		}
		uip_ipaddr(time_addr,
			time_servers[curr_time_server].addr[0],
			time_servers[curr_time_server].addr[1],
			time_servers[curr_time_server].addr[2],
			time_servers[curr_time_server].addr[3]);
		if (get_seconds) {
		    conn = uip_connect(time_addr,HTONS(37));
		    get_seconds = FALSE;
		} else {
		    conn = uip_connect(time_addr,HTONS(13));
		    get_time = FALSE;
		}
#ifdef VERBOSE
		if (!quiet) {
		    printf("Making time request to %s - %s\n",
			time_servers[curr_time_server].ip_name,
			time_servers[curr_time_server].full_name);
		}
#endif
	    }

	    time_now = time(0);
	    if (time_now != last_seconds) {
	        for (i=0; i< UIP_CONNS; i++) {
		    uip_periodic(i);
		    if (uip_len > 0) {
		        if (!quiet) {
#ifdef VERBOSE
	                    uip_tcpip_hdr *p = (uip_tcpip_hdr*)&uip_buf[UIP_LLH_LEN];
	                    printf("Sending %d-byte packet to ",uip_len);
	                    doip((u8_t*)&p->destipaddr[0]);
#else
		            kputc('-',CONSOLE);
#endif
		        }
		        slipdev_send();
		    }
		}
	    }

	    last_seconds = time_now;

#if UIP_UDP
	    for (i=0; i < UIP_UDP_CONNS; i++) {
		uip_udp_periodic(i);
		if (uip_len > 0) {
		    uip_arp_out();
		    slipdev_send();
		}
	    }
#endif /* UIP_UDP */
#if 0
	    // Suspend here is nothing is going on.
	    _timeout(1);
	    _suspend(AUX,SUSPEND_ON_INPUT | SUSPEND_ON_OUTPUT);
#endif
	} else {  /* (uip_len != 0) */
#ifdef FG
	    if (!quiet) {
#ifdef VERBOSE
	    uip_tcpip_hdr *p = (uip_tcpip_hdr*)&uip_buf[UIP_LLH_LEN];
	    printf("Got ");
	    switch (p->proto) {
		case 1: printf("ICMP");
			break;
		case 2: printf("IGMP");
			break;
		case 6: printf("TCP");
#if 0
			printf("\n");
			{ int ii;
			    for (ii=0;ii<uip_len;ii++) {
				char c;
				c = uip_buf[ii];
				if ((c < ' ' || c > 'z')) {
				    c = '.';
				}
				printf("%c",c);
			    }
			    printf("\n");
			}
#endif
			break;
		case 17:printf("UDP");
			break;
		default:printf("Unknown[%d]",p->proto);
			break;
	    }
	    printf(" %d-byte packet from ",uip_len);
	    doip((u8_t*)&p->srcipaddr[0]);
#else
	    kputc('+',CONSOLE);
#endif
	    }
#endif
	    
	    uip_input(); 
	    if (uip_len > 0) {
#ifdef FG
		if (!quiet) {
#ifdef VERBOSE
	        uip_tcpip_hdr *p = (uip_tcpip_hdr*)&uip_buf[UIP_LLH_LEN];
	        printf("Sending %d-byte packet to ",uip_len);
	        doip((u8_t*)&p->destipaddr[0]);
#else
		kputc('-',CONSOLE);
#endif
		}
#endif

		slipdev_send();
	    }
	}
    }
#ifdef FG
    printf("Exiting Magic-1 Web server\n");
#endif
    return 0;
}
