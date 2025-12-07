#include "common.h"

#include "../lib/ansi/loc_time.h"

static const int _kytab[2][12] = {
  { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 },
  { 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
};

/* Clock parameters. */
#define	RTC_S1		0x0
#define	RTC_S10		0x1
#define	RTC_MI1		0x2
#define	RTC_MI10	0x3
#define	RTC_H1		0x4
#define	RTC_H10		0x5
#define	RTC_D1		0x6
#define	RTC_D10		0x7
#define	RTC_MO1		0x8
#define	RTC_MO10	0x9
#define	RTC_Y1		0xa
#define	RTC_Y10		0xb
#define	RTC_W		0xc
#define	RTC_CD		0xd
#define	RTC_CE		0xe
#define	RTC_CF		0xf

#define	RTC_HOLD	0x1
#define	RTC_BUSY	0x2
#define	RTC_AMPM	0x4

#define RTC_24_HOUR	0x4

#define	RTC_64ths	0x0
#define RTC_1s		0x4
#define	RTC_1m		0x8
#define	RTC_1h		0xc

#define	RTC_PULSE_MODE		0x0
#define	RTC_INTERRUPT_MODE	0x2

#define	RTC_INTERRUPTS_ON	0x0
#define	RTC_INTERRUPTS_OFF	0x1


unsigned char time_mask[] = {
  0x0f, // S1
  0x07, // S10
  0x0f, // MI1
  0x07, // MI10
  0x0f, // H1
  0x03, // H10
  0x0f, // D1
  0x03, // D10
  0x0f, // MO1
  0x01, // MO10
  0x0f, // Y1
  0x0f, // Y10
  0x07, // W
  0x0f, // CD
  0x0f, // CE
  0x0f  // CF
};

// Copied from kernel/clock.c.  Because we have access to the real time clock,
// we can get the current time without having to make a system call (which
// is something we shouln't do.

/*===========================================================================*
 * 				get_rtc_time				     *
 * Read the Epson RTC-74721 and get absolute seconds.			     *
 * Much of this code cribbed from mktime(), but specialized to avoid the     *
 * unnecessary normalization and time zone checks.			     *
 *===========================================================================*/
time_t get_rtc_time() {
  int rtc_seconds;
  int rtc_minutes;
  int rtc_hours;
  int rtc_day;
  int rtc_month;
  int rtc_year;
  int utc_year;
  int yday;
  int month;
  unsigned long day;
  unsigned long seconds;

  unsigned char *p = (wiznet_base - WIZNET_PHYS_ADDR) + RTC_BASE;

  // Wait for the RTC to get ready, and then send it into hold mode
  p[RTC_CD] = (unsigned char)((p[RTC_CD] & (~RTC_BUSY)) | RTC_HOLD);
  while ( p[RTC_CD] & RTC_BUSY ) {
    p[RTC_CD] = (unsigned char)(p[RTC_CD] & ~(RTC_BUSY|RTC_HOLD));
    p[RTC_CD] = (unsigned char)((p[RTC_CD] & (~RTC_BUSY)) | RTC_HOLD);
  }

  rtc_seconds = ((p[RTC_S10] & 0x7) * 10)+ 
    (p[RTC_S1] & 0xf);
  rtc_minutes =  ((p[RTC_MI10] & 0x7) * 10) +
    (p[RTC_MI1] & 0xF);
  rtc_hours = ((p[RTC_H10] & 0x3) * 10) +
    (p[RTC_H1] & 0xf);
  rtc_day = ((p[RTC_D10] & 0x3) * 10) +
    (p[RTC_D1] & 0xf);
  rtc_month = (((p[RTC_MO10] & 0x1) * 10) +
      (p[RTC_MO1] & 0xf)) - 1;
  // The RTC-72421 holds the last two digits of the year.  I'm going to
  // hard-code that we're past the year 2000.
  rtc_year = ((p[RTC_Y10] & 0xf) *10) +
    (p[RTC_Y1] & 0xf) + 2000;

  p[RTC_CD] = p[RTC_CD] & ~(RTC_BUSY|RTC_HOLD);
  // Turn the clock loose again


  utc_year = rtc_year - EPOCH_YR; // 1970

  // Get the basic number of days since 1970
  day = (utc_year) * 365; 
  // Deal with leap years
  day += (utc_year) / 4 
    + ((rtc_year % 4) && rtc_year % 4 < EPOCH_YR % 4); 
  day -= (utc_year) / 100 
    + ((rtc_year % 100) && rtc_year % 100 < EPOCH_YR % 100); 
  day += (utc_year) / 400 
    + ((rtc_year % 400) && rtc_year % 400 < EPOCH_YR % 400);

  // Now, compute the days so far this year
  yday = month = 0; 
  while (month < rtc_month) { 
    yday += _kytab[LEAPYEAR(rtc_year)][month]; 
    month++; 
  } 
  yday += (rtc_day - 1); 
  // Add those in to the running total
  day += yday;

  // Start off with the total of seconds so far today
  seconds = ((rtc_hours * 60L) + rtc_minutes) * 60L + rtc_seconds;

  // Add in the previous seconds since 1970
  seconds += day * SECS_DAY;

  return (time_t) seconds;
}

