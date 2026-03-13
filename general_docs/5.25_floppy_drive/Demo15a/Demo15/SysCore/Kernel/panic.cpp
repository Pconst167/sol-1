
#include <hal.h>
#include <stdio.h>
#include "DebugDisplay.h"

static char* sickpc = " \
                               _______      \n\
                               |.-----.|    \n\
                               ||x . x||    \n\
                               ||_.-._||    \n\
                               `--)-(--`    \n\
                              __[=== o]___  \n\
                             |:::::::::::|\\ \n\
                             `-=========-`()\n\
                                M. O. S.\n\n";

//! something is wrong--bail out
void _cdecl kernel_panic (const char* fmt, ...) {

	disable ();

	va_list		args;
	static char buf[1024];

	va_start (args, fmt);
	va_end (args);

	char* disclamer="We apologize, MOS has encountered a problem and has been shut down\n\
to prevent damage to your computer. Any unsaved work might be lost.\n\
We are sorry for the inconvenience this might have caused.\n\n\
Please report the following information and restart your computer.\n\
The system has been halted.\n\n";

	DebugClrScr (0x1f);
	DebugGotoXY (0,0);
	DebugSetColor (0x1f);
	DebugPuts (sickpc);
	DebugPuts (disclamer);

	DebugPrintf ("*** STOP: %s", fmt);

	for (;;);
}
