
//****************************************************************************
//**
//**    Hal.cpp
//**		Hardware Abstraction Layer for i86 architecture
//**
//**	The Hardware Abstraction Layer (HAL) provides an abstract interface
//**	to control the basic motherboard hardware devices. This is accomplished
//**	by abstracting hardware dependencies behind this interface.
//**
//****************************************************************************

#ifndef ARCH_X86
#error "[hal.cpp for i86] requires i86 architecture. Define ARCH_X86"
#endif

//============================================================================
//    IMPLEMENTATION HEADERS
//============================================================================

#include <Hal.h>
#include "cpu.h"
#include "pic.h"
#include "pit.h"
#include "idt.h"

//============================================================================
//    IMPLEMENTATION PRIVATE DEFINITIONS / ENUMERATIONS / SIMPLE TYPEDEFS
//============================================================================
//============================================================================
//    IMPLEMENTATION PRIVATE CLASS PROTOTYPES / EXTERNAL CLASS REFERENCES
//============================================================================
//============================================================================
//    IMPLEMENTATION PRIVATE STRUCTURES / UTILITY CLASSES
//============================================================================
//============================================================================
//    IMPLEMENTATION REQUIRED EXTERNAL REFERENCES (AVOID)
//============================================================================
//============================================================================
//    IMPLEMENTATION PRIVATE DATA
//============================================================================
//============================================================================
//    INTERFACE DATA
//============================================================================
//============================================================================
//    IMPLEMENTATION PRIVATE FUNCTION PROTOTYPES
//============================================================================
//============================================================================
//    IMPLEMENTATION PRIVATE FUNCTIONS
//============================================================================
//============================================================================
//    INTERFACE FUNCTIONS
//============================================================================

//! initialize hardware devices
int _cdecl hal_initialize () {

	//! disable hardware interrupts
	disable ();

	//! initialize motherboard controllers and system timer
	i86_cpu_initialize ();
	i86_pic_initialize (0x20,0x28);
	i86_pit_initialize ();
	i86_pit_start_counter (100,I86_PIT_OCW_COUNTER_0, I86_PIT_OCW_MODE_SQUAREWAVEGEN);

	//! enable interrupts
	enable ();

	return 0;
}

//! shutdown hardware devices
int _cdecl hal_shutdown () {

	//! shutdown system resources
	i86_cpu_shutdown ();
	return 0;
}


//! generate i86 interrupt request
void _cdecl geninterrupt (int n) {
#ifdef _MSC_VER
	_asm {
		mov al, byte ptr [n]
		mov byte ptr [genint+1], al
		jmp genint
	genint:
		int 0	// above code modifies the 0 to int number to generate
	}
#endif
}

//! notifies hal interrupt is done
inline void _cdecl	interruptdone (unsigned int intno) {

	//! insure its a valid hardware irq
	if (intno > 16)
		return;

	//! test if we need to send end-of-interrupt to second pic
	if (intno >= 8)
		i86_pic_send_command (I86_PIC_OCW2_MASK_EOI, 1);

	//! always send end-of-interrupt to primary pic
	i86_pic_send_command (I86_PIC_OCW2_MASK_EOI, 0);
}


//! output sound to speaker
void _cdecl	sound (unsigned frequency) {

	//! sets frequency for speaker. frequency of 0 disables speaker
	outportb (0x61, 3 | unsigned char(frequency<<2) );
}


//! read byte from device using port mapped io
unsigned char _cdecl inportb (unsigned short portid) {
#ifdef _MSC_VER
	_asm {
		mov		dx, word ptr [portid]
		in		al, dx
		mov		byte ptr [portid], al
	}
#endif
	return (unsigned char)portid;
}


//! write byte to device through port mapped io
void _cdecl outportb (unsigned short portid, unsigned char value) {
#ifdef _MSC_VER
	_asm {
		mov		al, byte ptr [value]
		mov		dx, word ptr [portid]
		out		dx, al
	}
#endif
}


//! enable all hardware interrupts
void _cdecl enable () {
#ifdef _MSC_VER
	_asm sti
#endif
}


//! disable all hardware interrupts
void _cdecl disable () {
#ifdef _MSC_VER
	_asm cli
#endif
}


//! sets new interrupt vector
void _cdecl setvect (int intno, void (_cdecl far &vect) ( ) ) {

	//! install interrupt handler! This overwrites prev interrupt descriptor
	i86_install_ir (intno, I86_IDT_DESC_PRESENT | I86_IDT_DESC_BIT32,
		0x8, vect);
}


//! returns current interrupt vector
void (_cdecl far * _cdecl	getvect (int intno)) ( ) {

	//! get the descriptor from the idt
	idt_descriptor* desc = i86_get_ir (intno);
	if (!desc)
		return 0;

	//! get address of interrupt handler
	uint32_t addr = desc->baseLo | (desc->baseHi << 16);

	//! return interrupt handler
	I86_IRQ_HANDLER irq = (I86_IRQ_HANDLER)addr;
	return irq;
}


//! returns cpu vender
const char* _cdecl get_cpu_vender () {

	return i86_cpu_get_vender();
}


//! returns current tick count (only for demo)
int _cdecl get_tick_count () {

	return i86_pit_get_tick_count();
}

//============================================================================
//    INTERFACE CLASS BODIES
//============================================================================
//****************************************************************************
//**
//**    END[Hal.cpp]
//**
//****************************************************************************
