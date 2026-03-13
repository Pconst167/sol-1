
#include <sys/types.h>
#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <pwd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <utmp.h>
#include <sys/ioctl.h>
#include <sys/stat.h>

#define ASTERISK '*'  /* ignore this in real name */
#define COMMA  ','  /* separator in pw_gecos field */
#define COMMAND  '-'  /* command line flag char */
#define SAMENAME '&'  /* repeat login name in real name */
#define TALKABLE 0220  /* tty is writable if this mode */

struct utmp user;
#define NMAX sizeof(user.ut_name)
#define LMAX sizeof(user.ut_line)
#define HMAX sizeof(user.ut_host)

struct person {   /* one for each person fingered */
  char *name;   /* name */
  char tty[LMAX+1];  /* null terminated tty line */
  char host[HMAX+1];  /* null terminated remote host name */
  long loginat;   /* time of (last) login */
  long idletime;   /* how long idle (if logged in) */
  char *realname;   /* pointer to full name */
  struct passwd *pwd;  /* structure of /etc/passwd stuff */
  char loggedin;   /* person is logged in */
  char writable;   /* tty is writable */
  char original;   /* this is not a duplicate entry */
  struct person *link;  /* link to next person */
  char *where;   /* terminal location */
  char hostt[HMAX+1];  /* login host */
};

char LASTLOG[] = "/usr/adm/lastlog"; /* last login info */
char USERLOG[] = "/etc/utmp";  /* who is logged in */

int unshort;
int lf;     /* LASTLOG file descriptor */
struct person *person1;   /* list of people */
long tloc;    /* current time */

int main (int argc, char *argv[]);
static void doall(void);
static void print(void);
static void fwopen(void);
static void decode(struct person *pers);
static void fwclose(void);
static void shortprint (struct person *pers);
static struct passwd *pwdcopy(struct passwd *pfrom);
static void findidle (struct person *pers);
static void stimeprint (long *dt);
static void findwhen (struct person *pers);

char* bigbuffer;
size_t bsize;
extern char* sbuf;

void adds(char* s) {
  if ((strlen(bigbuffer) + strlen(s)) < bsize) {
    strcat(bigbuffer, s);
  }
}

void html_finger(char* buf, size_t buf_size) {
  bigbuffer = buf;
  bsize = buf_size;
  *buf = 0;
  time(&tloc);
  doall();
  if (person1) {
    print();
  }
}

static void doall()
{
  register struct person *p;
  register struct passwd *pw;
  int uf;
  char name[NMAX + 1];

  if ((uf = open(USERLOG, 0)) < 0) {
    fprintf(stderr, "finger: error opening %s\n", USERLOG);
    return;
  }
  setpwent();
  fwopen();
  while (read(uf, (char *)&user, sizeof user) == sizeof user) {
    if (user.ut_name[0] == 0)
      continue;
    if (person1 == 0)
      p = person1 = (struct person *) malloc(sizeof *p);
    else {
      p->link = (struct person *) malloc(sizeof *p);
      p = p->link;
    }
    bcopy(user.ut_name, name, NMAX);
    name[NMAX] = 0;
    bcopy(user.ut_line, p->tty, LMAX);
    p->tty[LMAX] = 0;
    bcopy(user.ut_host, p->host, HMAX);
    p->host[HMAX] = 0;
    p->loginat = user.ut_time;
    p->pwd = 0;
    p->loggedin = 1;
    p->where = NULL;
    if (pw = getpwnam(name)) {
      p->pwd = pwdcopy(pw);
      decode(p);
      p->name = p->pwd->pw_name;
    } else
      p->name = strcpy(malloc(strlen(name) + 1), name);
  }
  fwclose();
  endpwent();
  close(uf);
  if (person1 == 0) {
    adds("No one logged on\n");
    return;
  }
  p->link = 0;
}

static void print()
{
  register struct person *p;

  /*
   * print out what we got
   */
  adds("<html><body bgcolor=\"#C0C0C0\">\n");
  adds("<font face=\"Century Gothic\">\n");
  adds("<head><title>finger</title></head>\n");
  adds("<hr><h2>finger</h2>\n");
  adds("<hr><table border=\"1\">\n");


  adds("<tr><th>Login</th><th>Name</th><th>TTY</th><th>Idle</th><th>When</th><th>Where</th></tr>\n");
  for (p = person1; p != 0; p = p->link) {
    shortprint(p);
    continue;
  }
  adds("</table></font></body></html>\n");
}

/*
 * Duplicate a pwd entry.
 * Note: Only the useful things (what the program currently uses) are copied.
 */
  static struct passwd* pwdcopy(struct passwd* pfrom) {
  register struct passwd *pto;

  pto = (struct passwd *) malloc(sizeof *pto);
#define savestr(s) strcpy(malloc(strlen(s) + 1), s)
  pto->pw_name = savestr(pfrom->pw_name);
  pto->pw_uid = pfrom->pw_uid;
  pto->pw_gecos = savestr(pfrom->pw_gecos);
  pto->pw_dir = savestr(pfrom->pw_dir);
  pto->pw_shell = savestr(pfrom->pw_shell);
#undef savestr
  return pto;
}

/*
 * print out information in short format, giving login name, full name,
 * tty, idle time, login time, and host.
 */
static void shortprint(pers)
  register struct person *pers;
{
  char *p;
  char dialup;

  adds("<tr>");

  if (pers->pwd == 0) {
    adds("<td>");
    adds(pers->name);
    adds("</td>\n");
    return;
  }
  adds("<td>");
  adds(pers->pwd->pw_name);
  adds("</td>");
  dialup = 0;
  if (pers->realname) {
    adds("<td> ");
    adds(pers->realname);
  } else {
    adds("<td>???");
  }
  adds(" ");
  if (pers->loggedin && !pers->writable)
    adds("*");
  else
    adds(" ");
  adds("</td><td>");
  if (*pers->tty) {
    if (pers->tty[0] == 't' && pers->tty[1] == 't' &&
        pers->tty[2] == 'y') {
      if (pers->tty[3] == 'd' && pers->loggedin)
        dialup = 1;
      sprintf(sbuf, "%-2.2s ", pers->tty + 3);
      adds(sbuf);
    } else {
      sprintf(sbuf, "%-2.2s ", pers->tty);
      adds(sbuf);
    }
  } else
    adds("   ");
  p = ctime(&pers->loginat);
  adds("</td><td>");
  if (pers->loggedin) {
    stimeprint(&pers->idletime); 
    adds("</td><td>");
    sprintf(sbuf, " %3.3s %-5.5s ", p, p + 11);
    adds(sbuf);
  } else if (pers->loginat == 0) {
    adds("</td><td>");
    adds(" < .  .  .  . >");
  } else if (tloc - pers->loginat >= 180L * 24 * 60 * 60) {
    adds("</td><td>");
    sprintf(sbuf, " <%-6.6s, %-4.4s>", p + 4, p + 20);
    adds(sbuf);
  } else {
    adds("</td><td>");
    sprintf(sbuf, " <%-12.12s>", p + 4);
    adds(sbuf);
  }
  adds("</td><td>");
  if (pers->host[0]) {
    sprintf(" %-20.20s", pers->host);
    adds(sbuf);
  } else {
    adds("</td></tr>");
  }
  adds("</td></tr>");
  adds("\n");
}


/*
 * decode the information in the gecos field of /etc/passwd
 */
  static void
decode(pers)
  register struct person *pers;
{
  char buffer[256];
  register char *bp, *gp, *lp;
  int len;

  pers->realname = 0;
  if (pers->pwd == 0)
    return;
  gp = pers->pwd->pw_gecos;
  bp = buffer;
  if (*gp == ASTERISK)
    gp++;
  while (*gp && *gp != COMMA)    /* name */
    if (*gp == SAMENAME) {
      lp = pers->pwd->pw_name;
      if (islower(*lp))
        *bp++ = toupper(*lp++);
      while (*bp++ = *lp++)
        ;
      bp--;
      gp++;
    } else
      *bp++ = *gp++;
  *bp++ = 0;
  if ((len = bp - buffer) > 1)
    pers->realname = strcpy(malloc(len), buffer);
  if (pers->loggedin)
    findidle(pers);
  else
    findwhen(pers);
}

/*
 * find the last log in of a user by checking the LASTLOG file.
 * the entry is indexed by the uid, so this can only be done if
 * the uid is known (which it isn't in quick mode)
 */

  static void
fwopen()
{
  if ((lf = open(LASTLOG, 0)) < 0) {
    if (errno == ENOENT) return;
    fprintf(stderr, "finger: %s open error\n", LASTLOG);
  }
}

  static void
findwhen(pers)
  register struct person *pers;
{
  struct utmp ll;
#define ll_line ut_line
#define ll_host ut_host
#define ll_time ut_time

  int i;

  if (lf >= 0) {
    lseek(lf, (long)pers->pwd->pw_uid * sizeof ll, 0);
    if ((i = read(lf, (char *)&ll, sizeof ll)) == sizeof ll) {
      bcopy(ll.ll_line, pers->tty, LMAX);
      pers->tty[LMAX] = 0;
      bcopy(ll.ll_host, pers->host, HMAX);
      pers->host[HMAX] = 0;
      pers->loginat = ll.ll_time;
    } else {
      if (i != 0)
        fprintf(stderr, "finger: %s read error\n", LASTLOG);
      pers->tty[0] = 0;
      pers->host[0] = 0;
      pers->loginat = 0L;
    }
  } else {
    pers->tty[0] = 0;
    pers->host[0] = 0;
    pers->loginat = 0L;
  }
}

static void fwclose()
{
  if (lf >= 0)
    close(lf);
}

/*
 * find the idle time of a user by doing a stat on /dev/tty??,
 * where tty?? has been gotten from USERLOG, supposedly.
 */
  static void
findidle(pers)
  register struct person *pers;
{
  struct stat ttystatus;
  static char buffer[20] = "/dev/";
  long t;
#define TTYLEN 5

  strcpy(buffer + TTYLEN, pers->tty);
  buffer[TTYLEN+LMAX] = 0;
  if (stat(buffer, &ttystatus) < 0) {
    fprintf(stderr, "finger: Can't stat %s\n", buffer);
    return;
  }
  time(&t);
  if (t < ttystatus.st_atime)
    pers->idletime = 0L;
  else
    pers->idletime = t - ttystatus.st_atime;
  pers->writable = (ttystatus.st_mode & TALKABLE) == TALKABLE;
}

/*
 * print idle time in short format; this program always prints 4 characters;
 * if the idle time is zero, it prints 4 blanks.
 */
  static void
stimeprint(dt)
  long *dt;
{
  register struct tm *delta;

  delta = gmtime(dt);
  if (delta->tm_yday == 0)
    if (delta->tm_hour == 0)
      if (delta->tm_min == 0) {
        adds("    ");
      } else {
        sprintf(sbuf, "  %2d", delta->tm_min);
        adds(sbuf);
      }
    else
      if (delta->tm_hour >= 10) {
        sprintf(sbuf, "%3d:", delta->tm_hour);
        adds(sbuf);
      } else {
        sprintf(sbuf, "%1d:%02d", delta->tm_hour, delta->tm_min);
        adds(sbuf);
      }
  else {
    sprintf(sbuf, "%3dd", delta->tm_yday);
    adds(sbuf);
  }
}
