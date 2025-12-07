
=============================================================================
CERT(sm) Vendor-Initiated Bulletin VB-96.02
February 1, 1996

Topic: Incorrect Permissions on Packing Subsystem
Source: Silicon Graphics, Inc.

To aid in the wide distribution of essential security information, the CERT
Coordination Center is forwarding the following information from Silicon
Graphics, Inc. (SGI), who urges you to act on this information as soon as
possible. SGI contact information is included in the forwarded text
below; please contact them if you have any questions or need further
information.


========================FORWARDED TEXT STARTS HERE============================

______________________________________________________________________________
                Silicon Graphics Inc. Security Advisory


         Number:         19960102-01-P
         Date:           January 29, 1996
______________________________________________________________________________

Silicon Graphics provides this information freely to the SGI community
for its consideration, interpretation and implementation.   Silicon Graphics
recommends that this information be acted upon as soon as possible.

Silicon Graphics will not be liable for any consequential damages
arising from the use of, or failure to use or use properly, any of the
instructions or information in this Security Advisory.
______________________________________________________________________________


Silicon Graphics has discovered a security vulnerability within the
"ATT Packaging Utility" (eoe2.sw.oampkg) subsystem available for the
IRIX operating system.  SGI has investigated this issue and recommends
the following steps for neutralizing the exposure.  It is HIGHLY RECOMMENDED
that these measures be implemented on ALL SGI systems running IRIX 5.2, 5.3,
6.0, 6.0.1, 6.1.   This issue has been corrected for future releases of
IRIX.


- --------------
- --- Impact ---
- --------------

The "ATT Packaging Utility" (eoe2.sw.oampkg) subsystem is not installed
as part of the standard IRIX operating system.  It is optionally installed
when manually selected to be installed when using the IRIX inst program.
Therefore, not all SGI systems will have this subsystem installed.

For those systems that the subsystem installed, both local and remote
users may be able to overwrite files and/or become root on a targeted SGI
system.


- ----------------
- --- Solution ---
- ----------------

To determine if the packaging system is installed on a particular system,
the following command can be used:

       % versions eoe2.sw.oampkg | grep oampkg
       I  eoe2.sw.oampkg       03/25/94  ATT Packaging Utility
       %

In the above case, the packaging system is installed and the steps
below should be performed. If no output is returned by the command,
the subsystem is not installed and no further action is required.

*IF* the packaging subsystem is installed, the following steps can
be used to neutralize the exposure by changing permissions on select
programs of the eoe2.sw.oampkg subsystem.

There is no patch for this issue.


       1) Become the root user on your system.

              % /bin/su
              Password:
              #


       2) Change the permissions on the following programs.

              # /sbin/chmod 755 /usr/pkg/bin/pkgadjust
              # /sbin/chmod 755 /usr/pkg/bin/abspath


       3) Return to the previous user state.

              # exit
              %


- -----------------------------------------
- --- SGI Security Information/Contacts ---
- -----------------------------------------

Past SGI Advisories and security patches can be obtained via
anonymous FTP from sgigate.sgi.com or its mirror, ftp.sgi.com.
These security patches and advisories are provided freely to
all interested parties.   For issues with the patches on the
FTP sites, email can be sent to cse-security-alert@csd.sgi.com.

For assistance obtaining or working with security patches, please
contact your SGI support provider.

If there are questions about this document, email can be sent to
cse-security-alert@csd.sgi.com.

For reporting *NEW* SGI security issues, email can be sent to
security-alert@sgi.com or contact your SGI support provider.  A
support contract is not required for submitting a security report.

=========================FORWARDED TEXT ENDS HERE=============================

CERT publications, information about FIRST representatives, and other
security-related information are available for anonymous FTP from
        ftp://info.cert.org/pub/

CERT advisories and bulletins are also posted on the USENET newsgroup
        comp.security.announce

To be added to our mailing list for CERT advisories and bulletins, send your
email address to
        cert-advisory-request@cert.org

If you believe that your system has been compromised, contact the CERT
Coordination Center or your representative in the Forum of Incident Response
and Security Teams (FIRST).

If you wish to send sensitive incident or vulnerability information to CERT
staff by electronic mail, we strongly advise you to encrypt your message.
We can support a shared DES key or PGP. Contact the CERT staff for more
information.

Location of CERT PGP key
         ftp://info.cert.org/pub/CERT_PGP.key


CERT Contact Information
------------------------
Email    cert@cert.org

Phone    +1 412-268-7090 (24-hour hotline)
                CERT personnel answer 8:30-5:00 p.m. EST
                (GMT-5)/EDT(GMT-4), and are on call for
                emergencies during other hours.

Fax      +1 412-268-6989

Postal address
        CERT Coordination Center
        Software Engineering Institute
        Carnegie Mellon University
        Pittsburgh PA 15213-3890
        USA

CERT is a service mark of Carnegie Mellon University.


---
"Some call him the coolest cybernetic sidewalk surfer ever to hang-ten
on the shoulders of the Great Information Superhiway."

--- ifmail v.2.8.lwz
 * Origin: Monolithic Diversified Enterprises (1:340/13@fidonet)

