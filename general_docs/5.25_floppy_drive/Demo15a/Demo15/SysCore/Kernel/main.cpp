/******************************************************************************
   main.cpp
		-Kernel main program

   modified\ Jul 19 2009
   arthor\ Mike
******************************************************************************/

#include <bootinfo.h>
#include <hal.h>
#include <kybrd.h>
#include <string.h>
#include <flpydsk.h>
#include <stdio.h>

#include "DebugDisplay.h"
#include "exception.h"
#include "mmngr_phys.h"
#include "mmngr_virtual.h"

struct memory_region {

	uint32_t	startLo;	//base address
	uint32_t	startHi;
	uint32_t	sizeLo;		//length (in bytes)
	uint32_t	sizeHi;
	uint32_t	type;
	uint32_t	acpi_3_0;
};

uint32_t kernelSize=0;

void init (multiboot_info* bootinfo) {

	//! clear and init display
	DebugClrScr (0x13);
	DebugGotoXY (0,0);
	DebugSetColor (0x17);

	hal_initialize ();

	enable ();
	setvect (0,(void (__cdecl &)(void))divide_by_zero_fault);
	setvect (1,(void (__cdecl &)(void))single_step_trap);
	setvect (2,(void (__cdecl &)(void))nmi_trap);
	setvect (3,(void (__cdecl &)(void))breakpoint_trap);
	setvect (4,(void (__cdecl &)(void))overflow_trap);
	setvect (5,(void (__cdecl &)(void))bounds_check_fault);
	setvect (6,(void (__cdecl &)(void))invalid_opcode_fault);
	setvect (7,(void (__cdecl &)(void))no_device_fault);
	setvect (8,(void (__cdecl &)(void))double_fault_abort);
	setvect (10,(void (__cdecl &)(void))invalid_tss_fault);
	setvect (11,(void (__cdecl &)(void))no_segment_fault);
	setvect (12,(void (__cdecl &)(void))stack_fault);
	setvect (13,(void (__cdecl &)(void))general_protection_fault);
	setvect (14,(void (__cdecl &)(void))page_fault);
	setvect (16,(void (__cdecl &)(void))fpu_fault);
	setvect (17,(void (__cdecl &)(void))alignment_check_fault);
	setvect (18,(void (__cdecl &)(void))machine_check_abort);
	setvect (19,(void (__cdecl &)(void))simd_fpu_fault);

	pmmngr_init (bootinfo->m_memorySize, 0xC0000000 + kernelSize*512);

	memory_region*	region = (memory_region*)0x1000;

	for (int i=0; i<10; ++i) {

		if (region[i].type>4)
			break;

		if (i>0 && region[i].startLo==0)
			break;

		pmmngr_init_region (region[i].startLo, region[i].sizeLo);
	}
	pmmngr_deinit_region (0x100000, kernelSize*512);

	//! initialize our vmm
	vmmngr_initialize ();

	//! install the keyboard to IR 33, uses IRQ 1
	kkybrd_install (33);

	//! set drive 0 as current drive
	flpydsk_set_working_drive (0);

	//! install floppy disk to IR 38, uses IRQ 6
	flpydsk_install (38);
}

//! sleeps a little bit. This uses the HALs get_tick_count() which in turn uses the PIT
void sleep (int ms) {

	static int ticks = ms + get_tick_count ();
	while (ticks > get_tick_count ())
		;
}

//! wait for key stroke
KEYCODE	getch () {

	KEYCODE key = KEY_UNKNOWN;

	//! wait for a keypress
	while (key==KEY_UNKNOWN)
		key = kkybrd_get_last_key ();

	//! discard last keypress (we handled it) and return
	kkybrd_discard_last_key ();
	return key;
}

//! command prompt
void cmd () {

	DebugPrintf ("\nCommand> ");
}

//! gets next command
void get_cmd (char* buf, int n) {

	KEYCODE key = KEY_UNKNOWN;
	bool	BufChar;

	//! get command string
	int i=0;
	while ( i < n ) {

		//! buffer the next char
		BufChar = true;

		//! grab next char
		key = getch ();

		//! end of command if enter is pressed
		if (key==KEY_RETURN)
			break;

		//! backspace
		if (key==KEY_BACKSPACE) {

			//! dont buffer this char
			BufChar = false;

			if (i > 0) {

				//! go back one char
				unsigned y, x;
				DebugGetXY (&x, &y);
				if (x>0)
					DebugGotoXY (--x, y);
				else {
					//! x is already 0, so go back one line
					y--;
					x = DebugGetHorz ();
				}

				//! erase the character from display
				DebugPutc (' ');
				DebugGotoXY (x, y);

				//! go back one char in cmd buf
				i--;
			}
		}

		//! only add the char if it is to be buffered
		if (BufChar) {

			//! convert key to an ascii char and put it in buffer
			char c = kkybrd_key_to_ascii (key);
			if (c != 0) { //insure its an ascii char

				DebugPutc (c);
				buf [i++] = c;
			}
		}

		//! wait for next key. You may need to adjust this to suite your needs
		sleep (10);
	}

	//! null terminate the string
	buf [i] = '\0';
}

//! read sector command
void cmd_read_sect () {

	uint32_t sectornum = 0;
	char sectornumbuf [4];
	uint8_t* sector = 0;

	DebugPrintf ("\n\rPlease type in the sector number [0 is default] >");
	get_cmd (sectornumbuf, 3);
	sectornum = atoi (sectornumbuf);

	DebugPrintf ("\n\rSector %i contents:\n\n\r", sectornum);

	//! read sector from disk
	sector = flpydsk_read_sector ( sectornum );

	//! display sector
	if (sector!=0) {

		int i = 0;
		for ( int c = 0; c < 4; c++ ) {

			for (int j = 0; j < 128; j++)
				DebugPrintf ("0x%x ", sector[ i + j ]);
			i += 128;

			DebugPrintf("\n\rPress any key to continue\n\r");
			getch ();
		}
	}
	else
		DebugPrintf ("\n\r*** Error reading sector from disk");

	DebugPrintf ("\n\rDone.");
}

//! our simple command parser
bool run_cmd (char* cmd_buf) {

	//! exit command
	if (strcmp (cmd_buf, "exit") == 0) {
		return true;
	}

	//! clear screen
	else if (strcmp (cmd_buf, "cls") == 0) {
		DebugClrScr (0x17);
	}

	//! help
	else if (strcmp (cmd_buf, "help") == 0) {

		DebugPuts ("\nOS Development Series Floppy Disk Demo");
		DebugPuts ("Supported commands:\n");
		DebugPuts (" - exit: quits and halts the system\n");
		DebugPuts (" - cls: clears the display\n");
		DebugPuts (" - help: displays this message\n");
		DebugPuts (" - read: reads a specific sector and displays it in hex\n");
		DebugPuts (" - reset: Resets and recalibrates floppy for reading\n");
	}

	//! read sector
	else if (strcmp (cmd_buf, "read") == 0) {
		cmd_read_sect ();
	}

	//! invalid command
	else {
		DebugPrintf ("\nUnkown command");
	}

	return false;
}

void run () {

	//! command buffer
	char	cmd_buf [100];

	while (1) {

		//! display prompt
		cmd ();

		//! get command
		get_cmd (cmd_buf, 98);

		//! run command
		if (run_cmd (cmd_buf) == true)
			break;
	}
}

int _cdecl kmain (multiboot_info* bootinfo) {

	_asm	mov	word ptr [kernelSize], dx

	init (bootinfo);

	DebugGotoXY (0,0);
	DebugPuts ("OSDev Series FDC Programming Demo");
	DebugPuts ("\nType \"exit\" to quit, \"help\" for a list of commands\n");
	DebugPuts ("+-------------------------------------------------------+\n");

	run ();

	DebugPrintf ("\nExit command recieved; demo halted");
	for (;;);
	return 0;
}
