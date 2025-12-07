#ifndef _CRTDEFS_H
#define _CRTDEFS_H

//****************************************************************************
//**
//**    crtdefs.h
//**    - basic definitions
//**
//****************************************************************************
//============================================================================
//    INTERFACE REQUIRED HEADERS
//============================================================================
//============================================================================
//    INTERFACE DEFINITIONS / ENUMERATIONS / SIMPLE TYPEDEFS
//============================================================================

#if defined (_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

#if !defined (CRT_EXPORTS) && !defined (CRT_IMPORTS)
#define CRT_EXPORTS
#endif

#if defined (_WIN32)
#if defined ( _MSC_VER )

//MSVC++ specific

#ifndef  ARCH_X86
#define ARCH_X86
#endif

#if defined ( BUILD_STATIC )
#define _CRTIMP
#else // build dyanimc
#ifdef CRT_EXPORTS
#define _CRTIMP __declspec (dllexport)
#else
#define _CRTIMP __declspec (dllimport)
#endif
#endif

#else //MSVC++
#error "The Win32 envirement is currently  not supported."
#endif

#else //WIN32
#error "Platform not implimented"
#endif

#undef far
#undef near
#undef pascal

#define far
#define near

#ifdef _WIN32
#if (!defined(_MAC)) && ((_MSC_VER >= 800) || defined(_STDCALL_SUPPORTED))
#define pascal __stdcall
#else
#define pascal
#endif
#endif

#ifdef _MAC
#ifndef _CRTLIB
#define _CRTLIB    __cdecl
#endif
#ifdef _68K_
#ifndef __pascal
#define __pascal
#endif
#endif
#elif defined( _WIN32)
#if (_MSC_VER >= 800) || defined(_STDCALL_SUPPORTED)
#ifndef _CRTLIB
#define _CRTLIB __stdcall
#endif
#else
#ifndef _CRTLIB
#define _CRTLIB
#endif
#endif
#endif

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
//============================================================================
//    INTERFACE OBJECT CLASS DEFINITIONS
//============================================================================
//============================================================================
//    INTERFACE TRAILING HEADERS
//============================================================================
//****************************************************************************
//**
//**    END crtdefs.h
//**
//****************************************************************************

#endif
