#ifndef _HAL_H
#define _HAL_H
//****************************************************************************
//**
//**    Hal.h
//**		Hardware Abstraction Layer Interface
//**
//**	The Hardware Abstraction Layer (HAL) provides an abstract interface
//**	to control the basic motherboard hardware devices. This is accomplished
//**	by abstracting hardware dependencies behind this interface.
//**
//**	All routines and types are declared extern and must be defined within
//**	external libraries to define specific hal implimentations.
//**
//****************************************************************************

#ifndef ARCH_X86
#pragma error "HAL not implimented for this platform"
#endif

//============================================================================
//    INTERFACE REQUIRED HEADERS
//============================================================================

#include <stdint.h>

//============================================================================
//    INTERFACE DEFINITIONS / ENUMERATIONS / SIMPLE TYPEDEFS
//============================================================================

#ifdef _MSC_VER
#define interrupt __declspec (naked)
#else
#define interrupt
#endif

#define far
#define near

//============================================================================
//    INTERFACE CLASS PROTOTYPES / EXTERNAL CLASS REFERENCES
//============================================================================
//============================================================================
//    INTERFACE STRUCTURES / UTILITY CLASSES
//============================================================================
//============================================================================
//    INTERFACE DATA DECLARATIONS
//============================================================================
//============================================================================
//    INTERFACE FUNCTION PROTOTYPES
//============================================================================

//! initialize hardware abstraction layer
extern	int				_cdecl	hal_initialize ();

//! shutdown hardware abstraction layer
extern	int				_cdecl	hal_shutdown ();

//! enables hardware device interrupts
extern	void			_cdecl	enable ();

//! disables hardware device interrupts
extern	void			_cdecl	disable ();

//! generates interrupt
extern	void			_cdecl	geninterrupt (int n);

//! reads from hardware device port
extern	unsigned char	_cdecl	inportb (unsigned short id);

//! writes byte to hardware port
extern	void			_cdecl	outportb (unsigned short id, unsigned char value);

//! sets new interrupt vector
extern	void			_cdecl	setvect (int intno, void (_cdecl far &vect) ( ) );

//! returns current interrupt at interrupt vector
extern	void (_cdecl	far * _cdecl getvect (int intno)) ( );

//! notifies hal the interrupt is done
extern	void			_cdecl	interruptdone (unsigned int intno);

//! generates sound
extern	void			_cdecl	sound (unsigned frequency);

//! returns cpu vender
extern const char*		_cdecl	get_cpu_vender ();

//! returns current tick count (Only for demo)
extern	int				_cdecl	get_tick_count ();

//============================================================================
//    INTERFACE OBJECT CLASS DEFINITIONS
//============================================================================
//============================================================================
//    INTERFACE TRAILING HEADERS
//============================================================================
//****************************************************************************
//**
//**    END [Hal.h]
//**
//****************************************************************************
#endif
