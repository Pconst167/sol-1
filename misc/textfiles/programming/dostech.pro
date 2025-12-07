
CHAPTER 1.
                         DOS TECHNICAL INFORMATION
 Programming Technical Reference - IBM
 Copyright 1988, Dave Williams


SOME HISTORY

 Development of MSDOS/PCDOS began in October 1980, when IBM began searching 
the market for an operating system for the yet-to-be-introduced IBM PC.
Microsoft had no real operating system to sell, but after some research licensed
Seattle Computer Products' 86-DOS, which had been written by a man named Tim 
Paterson for use on the company's line of 8086, S100 bus micros. This was 
hurriedly polished up and presented to IBM for evaluation. IBM had originally 
intended to use Digital Research's CP/M operating system, which was the industry
standard at the time. Folklore reports everything from obscure legal 
entanglements to outright snubbing of the IBM representatives by Digital,
irregardless, IBM found itself left with Microsoft's offering of "Microsoft Disk
Operating System 1.0". An agreement was reached between the two, and "IBM PC-DOS
1.0" was ready for the introduction of the IBM PC in October 1981. IBM subjected
the operating system to an extensive quality-assurance program, found well over
300 bugs, and decided to rewrite the programs. This is why PC-DOS is copyrighted
by both IBM and Microsoft. 

 It is sometimes amusing to reflect on the fact that the IBM PC was not
originally intended to run MSDOS. The target operating system at the end of the
development was for a (not yet in existence) 8086 version of CP/M. On the other
hand, when DOS was originally written the IBM PC did not yet exist! Although
PC-DOS was bundled with the computer, Digital Research's CP/M-86 would probably
have been the main operating system for the PC except for two things - Digital
Research wanted $495 for CP/M-86 (considering PC-DOS was essentially free) and
many software developers found it easier to port existing CP/M software to DOS
than to the new version of CP/M.

 MSDOS and PC-DOS have been run on more than just the IBM-PC and clones. There 
was an expansion board for the Apple ][ that allowed one to run (some) well - 
behaved DOS programs. There are expansion boards for the Commodore Amiga 2000,
the Apple MacIntosh II, and the IBM RT PC allowing them to run DOS, and the IBM
3270 PC, which ran DOS on a 68000 microprocessor. The Atari STs can run an 
emulator program and boot MSDOS.


Specific Versions of MS/PC-DOS:

 DOS version nomenclature: major.minor.minor.  The digit to the left of the 
decimal point indicates a major DOS version change. 1.0 was the first version. 
2.0 added subdirectories, etc. 3.0 added file handles and network support.
 The first minor version indicates customization for a major application. For 
example, 2.1 for the PCjr, 3.3 for the PS/2s. The second minor version does not 
seem to have any particular meaning.

 The main versions of DOS are:

 PC-DOS 1.0   October  1981  original release
 PC-DOS 1.1   June     1982  bugfix, double sided drive support
 MS-DOS 1.25  June     1982  for early compatibles
 PC-DOS 2.0   March    1983  for PC/XT, many UNIX-like functions
 PC-DOS 2.1   October  1983  for PCjr, bugfixes for 2.0
 MS-DOS 2.11  October  1983  compatible equivalent to 2.1
 PC-DOS 3.0   August   1984  for PC/AT, network support
 PC-DOS 3.1   November 1984  bugfix for 3.0
 MS-DOS 2.25  October  1985  compatible; extended foreign language support
 PC-DOS 3.2   July     1986  3.5 inch drive support for Convertible
 PC-DOS 3.3   April    1987  for PS/2 series


 Some versions of MS-DOS varied from PC-DOS in the availible external commands.
Some OEMs only licensed the basic operating system code (the xxxDOS and xxxBIO
programs, and COMMAND.COM) from Microsoft, and either wrote the rest themselves
or contracted them from outside software houses like Phoenix. Most of the 
external programs for DOS 3.x are written in "C" while the 1.x and 2.x utilities
were written in assembly language. Other OEMs required customized versions of 
DOS for their specific hardware configurations, such as Sanyo 55x and early 
Tandy computers, which were unable to exchange their DOS with the IBM version.

 At least two versions of DOS have been modified to be run entirely out of ROM.
The Sharp PC5000 had MSDOS 1.25 in ROM, and the Toshiba 1100 and some Tandy 
models have MSDOS 2.11 in ROM.


 THE OPERATING SYSTEM HIERARCHY

 The Disk Operating System (DOS) and the ROM BIOS serve as an insulating layer 
between the application program and the machine, and as a source of services 
to the application program.
 The system heirarchy may be thought of as a tree, with the lowest level being 
the actual hardware. The 8088 or V20 processor sees the computer's address 
space as a ladder two bytes wide and one million bytes long. Parts of this 
ladder are in ROM, parts in RAM, and parts are not assigned. There are also 
256 "ports" that the processor can use to control devices. 
 The hardware is normally addressed by the ROM BIOS, which will always know
where everything is in its particular system. The chips may usually also be
written to directly, by telling the processor to write to a specific address or
port. This sometimes does not work as the chips may not always be at the same
addresses or have the same functions from machine to machine.



 DOS STRUCTURE

DOS consists of four components:

 * The boot record
 * The ROM BIOS interface  (IBMBIO.COM or IO.SYS)
 * The DOS program file    (IBMDOS.COM or MSDOS.SYS)
 * The command processor   (COMMAND.COM or aftermarket replacement)


* The Boot Record

 The boot record begins on track 0, sector 1, side 0 of every diskette formatted
by the DOS FORMAT command.  The boot record is placed on diskettes to produce an
error message if you try to start up the system with a nonsystem diskette in 
drive A.  For hard disks, the boot record resides on the first sector of the DOS
partition.  All media supported by DOS use one sector for the boot record.


* Read Only Memory (ROM) BIOS Interface

 The file IBMBIO.COM or IO.SYS is the interface module to the ROM BIOS.
This file provides a low-level interface to the ROM BIOS device routines and 
may contain extensions or changes to the system board ROMs. Some compatibles do
not have a ROM BIOS to extend, and load the entire BIOS from disk. (Sanyo 55x,
Viasyn)


* The DOS Program File

 The actual DOS program is file IBMDOS.COM or MSDOS.SYS. It provides a high-
level interface for user (application) programs. This program consists of file
management routines, data blocking/deblocking for the disk routines, and a
variety of built-in functions easily accessible by user programs.
 When a user program calls these function routines, they accept high-level
information by way of register and control block contents. For device 
operations, the functions translate the requirement into one or more calls to 
IBMBIO.COM or MSDOS.SYS to complete the request.
    

* The Command Interpreter
  
 The Command interpreter, COMMAND.COM, consists of these parts:
    
Resident Portion:

 The resident portion resides in memory immediately following IBMDOS.COM and its
data area. This portion contains routines to process interrupts 22h (Terminate 
Address), 23h (Ctrl-Break Handler), and 24h (Critical Error Handler), as well as
a routine to reload the transient portion if needed. For DOS 3.x, this portion 
also contains a routine to load and execute external commands, such as files 
with exensions of COM or EXE.

 When a program terminates, a checksum is used to determine if the application 
program overlaid the transient portion of COMMAND.COM. If so, the resident 
portion will reload the transient portion from the area designated by COMSPEC= 
in the DOS environment. If COMMAND.COM cannot be found, the system will halt.

NOTE: DOS 3.3 checks for the presence of a hard disk, and will default to 
      COMSPEC=C:\. Previous versions default to COMSPEC=A:\. Under some DOS
      versions, if COMMAND.COM is not immediately availible for reloading
      (i.e., swapping to a floppy with COMMAND.COM on it) DOS may crash.

 All standard DOS error handling is done within the resident portion of 
COMMAND.COM.  This includes displaying error messages and interpreting the 
replies of Abort, Retry, Ignore, Fail.  

  
 An initialization routine is included in the resident portion and assumes
control during startup. This routine contains the AUTOEXEC.BAT file handler and
determines the segment address where user application programs may be loaded.
The initialization routine is then no longer needed and is overlaid by the first
program COMMAND.COM loads.

 NOTE: AUTOEXEC.BAT may be a hidden file.

 A transient portion is loaded at the high end of memory. This is the command 
processor itself, containing all of the internal command processors and the 
batch file processor. For DOS 2.x, this portion also contains a routine to load
and execute external commands, such as files with extensions of COM or EXE.

 This portion of COMMAND.COM also produces the DOS prompt (such as "A>"), reads
the command from the standard input device (usually the keyboard or a batch 
file), and executes the command. For external commands, it builds a command line
and issues an EXEC function call to load and transfer control to the program.

NOTE: COMMAND.COM may be a hidden file.
    
NOTE: For Dos 2.x, the transient portion of the command processor contains the
      EXEC routine that loads and executes external commands. For DOS 3.x, the
      resident portion of the command processor contains the EXEC routine. 



  DOS Initialization

 The system is initialized by a software reset (Ctrl-Alt-Del), a hardware reset
(reset button), or by turning the computer on. The Intel 80x8x series processors
always look for their first instruction at the end of their address space 
(0FFFF0h) when powered up or reset. This address contains a jump to the first 
instruction for the ROM BIOS.
 Built-in ROM programs (Power-On Self-Test, or POST, in the IBM) check machine
status and run inspection programs of various sorts. Some machines set up a
reserved RAM area with bytes indicating installed equipment (AT and PCjr). 
 The ROM routine looks for a disk drive at A: or an option ROM (usually a hard
disk) at absolute address C:800h. If no floppy drive or option ROM is found, the
BIOS calls int 19h (ROM BASIC if it is an IBM) or displays error message. 
 If a bootable disk is found, the ROM BIOS loads the first sector of information
from the disk and then jumps into the RAM location holding that code. This code
normally is a routine to load the rest of the code off the disk, or to "boot"
the system. 
 The following actions occur after a system initialization:

 1.  The boot record is read into memory and given control.    

 2.  The boot record then checks the root directory to assure that the first 
     two files are IBMBIO.COM and IBMDOS.COM. These two files must be the 
     first two files, and they must be in that order (IBMBIO.COM first, with 
     its sectors in contiguous order).
     NOTE: IBMDOS.COM need not be contiguous in version 3.x.

 3.  The boot record loads IBMBIO.COM into memory.

 4.  The initialization code in IBMBIO.COM loads IBMDOS.COM, determines 
     equipment status, resets the disk system, initializes the attached 
     devices, sets the system parameters and loads any installable device 
     drivers according to the CONFIG.SYS file in the root directory (if 
     present), sets the low-numbered interrupt vectors, relocates IBMDOS.COM 
     downward, and calls the first byte of DOS.
     NOTE: CONFIG.SYS may be a hidden file.

 5.  DOS initializes its internal working tables, initializes the interrupt
     vectors for interrupts 20h through 27h, and builds a Program Segment 
     Prefix for COMMAND.COM at the lowest available segment. For DOS versions
     3.10 up, DOS initializes interrupt vectors for interrupts 0Fh through 3Fh.

 6.  IBMBIO.COM uses the EXEC function call to load and start the top-level
     command processor. The default command processor is COMMAND.COM.




CHAPTER 2

 Programming Technical Reference - IBM
 Copyright 1988, Dave Williams

 CPU Port Assignments, System Memory Map, BIOS Data Area, Interrupts 00h to 09h


                        SYSTEM MEMORY MAP - OVERALL

 The IBM PC handles its address space in 64k segments, divided into 16k
fractions and then further as nescessary.

start   start  end
addr.   addr.  addr.              usage
(dec)      (hex)

00000 **** 640k *************** system data, drivers....
                        0000:0000  hardware interrupt vectors
                        0000:0040  BIOS interrupt vectors
0k      start of RAM |  0000:0080  DOS interrupt vector table
16k     00000-03FFF  |  0000:0300  Stack area during POST and bootstrap routine
32k     04000-07FFF  |  0000:0400  BIOS Data Area 
48k     08000-0BFFF  |  0000:04F0  Intra-Application Communications Area
                     |
64k     10000-13FFF  |  0000:0500  DOS reserved communication area
80k     14000-17FFF  |  xxxx:0000  IO.SYS - DOS interface to ROM I/O routines
96k     18000-1BFFF  |  xxxx:0000  MSDOS.SYS - DOS interrupt handlers, service
112k    1C000-1FFFF  |             routines (int 21 functions)
                     |
128k    20000-23FFF  |  xxxx:xxxx  DOS buffers, control areas, and installed
144k    24000-27FFF  |             device drivers.
160k    28000-2BFFF  |  xxxx:0000  resident portion of COMMAND.COM, interrupt
176k    2C000-2FFFF  |             handlers for int 22h, 23h,24h, and code to
                     |             reload the transient portion
192k    30000-33FFF  |  xxxx:0000  master environment block, default 64 bytes
208k    34000-37FFF  |  xxxx:0000  environment for next program
224k    38000-3BFFF  |  xxxx:0000  external commands or utilities (COM or EXE
240k    3C000-3FFFF  |             files)
                     |
256k    40000-43FFF  |  ----:----  application programs
272k    44000-47FFF  |  xxxx:0000  user stack for COM files (256 bytes)
288k    48000-4BFFF  |  xxxx:0000  transient portion of COMMAND.COM
304k    4C000-4FFFF  |
                     |
320k    50000-53FFF  |
336k    54000-57FFF  |
352k    58000-5BFFF  |
368k    5C000-5FFFF  |
                     |
384k    60000-63FFF  |
400k    64000-67FFF  |
416k    68000-6BFFF  |
432k    6C000-6FFFF  |
                     |
448k    70000-73FFF  |
464k    74000-77FFF  |
480k    78000-7BFFF  |
496k    7C000-7FFFF  |
                     |
512k    80000-83FFF  |
528k    84000-87FFF  |
544k    88000-8BFFF  | original IBM PC-1 BIOS limited memory to 544k
560k    8C000-8FFFF  |
                     |
576k    90000-93FFF  |
592k    94000-97FFF  |
609k    98000-9BFFF  |
624k    9C000-9FFFF  | to 640k (top of RAM address space)


A0000 ***** 64k *************** EGA address
640k    A0000-A95B0  MCGA 320x200 256 color video buffer
              AF8C0  MCGA 640x480 2 color video buffer
             -A3FFF 
656k    A4000-A7FFF
672k    A8000-ABFFF
688k    AC000-AFFFF


B0000 ***** 64k *************** mono and CGA address
704k    B0000-B3FFF  mono uses only 4k        | The PCjr and early Tandy 1000
720k    B4000-B7FFF                           | BIOSs revector direct writes to
736k    B8000-BBFFF  CGA uses entire 16k      | the B8 area to the Video Gate
756k    BC000-BFFFF                           | Array and reserved system RAM


C0000 ***** 64k *************** expansion ROM
768k    C0000-C3FFF  16k EGA BIOS C000:001E EGA BIOS signature (the letters IBM)
784k    C4000-C5FFF
        C6000-C63FF  256 bytes Professional Graphics Display communication area
        C6400-C7FFF
800k    C8000-CBFFF  16k hard disk controller BIOS, drive 0 default
816k    CC000-CDFFF  8k  IBM PC Network NETBIOS
        CE000-CFFFF

D0000 ***** 64k *************** expansion ROM | PCjr first ROM cartridge
832k    D0000-D7FFF  32k IBM Cluster Adapter  | address area.
        DA000        voice communications     |
848k    D4000-D7FFF                           | Common expanded memory board
864k    D8000-DBFFF                           | paging area.
880k    DC000-DFFFF                           |


E0000 ***** 64k *************** expansion ROM |    PCjr second ROM
896k    E0000-E3FFF                           |    cartridge address
912k    E4000-E7FFF                           |    area
928k    E8000-EBFFF                           |
944k    EC000-EFFFF                           |
                                             

F0000 ***** 64k *************** system        |    PCjr optional ROM
960k    F0000-F3FFF  reserved by IBM          |    cartridge address
976k    F4000-                                |    area (cartridge
        F6000        ROM BASIC Begins         |    BASIC)
992k    F8000-FB000                           |
1008k   FC000-FFFFF  ROM BASIC and original   |
                     BIOS (Compatibility BIOS |
                     in PS/2)                 |
1024k   FFFFF   end of memory (1024k) for 8088 machines
F000:FFF5 BIOS release date
F000:FFFE PC model identification

384k    100000-15FFFF  80286/AT extended memory area, 1Mb motherboard
15Mb    100000-FFFFFF  80286/AT extended memory address space

15Mb    160000-FDFFFF  Micro Channel RAM expansion (15Mb extended memory)
128k    FE0000-FFFFFF  system board ROM            (PS/2 Advanced BIOS)



       PC Port Assignment, Intel 8088, 80C88, 8086, 80286, 80386 CPUs

hex addr.                    Function

0000-000F       8237 DMA controller
0010-001F       8237 DMA controller  (AT, PS/2)
0020-0027       8259A interrupt controller
0020-003F       8259A interrupt controller  (AT)
0040-005F       8253-5 programmable timers
                (note: 0041 was memory refresh in PCs. Not used in PS/2)
0060-0067       8255 peripheral interface
0060-006F       8042 keyboard controller  (AT)
0200-020F       game-control adapter
0210-0217       expansion box (PC, XT)
0278-027F       LPT3
02F8-02FF       COM2
0300-031F       prototype card
0320-032F       hard disk controller 
0378-037F       LPT2
03BC-03BF       LPT1
03D0-03DF       CGA, MCGA, VGA adapter control
03F0-03F7       floppy disk controller
03F8-03FF       COM1

note:   These are functions common across the IBM range. The PCjr, PC 
        Convertible and PS/2 (both buses) have enhancements. In some cases, the
        AT and PS/2 series ignore, duplicate, or reassign ports arbitrarily. If
        your code incorporates specific port addresses for video or system board
        control it would be wise to have your application determine the machine
        type and video adapter and address the ports as required.



                   Reserved Memory Locations in the IBM PC

addr.  size            description

000h-3FFh      DOS interrupt vector table
30:00h-        used as a stack area during POST and bootstrap routines. This
3F:FFh         stack area may be revectored by an application program.
               The BIOS Data Area  addr. from 400h to 4FFh
40:00  word    COM1 port address |   These addresses are zeroed out in the
40:02  word    COM2 port address |   OS/2 DOS Compatibility Box if any of
40:04  word    COM3 port address |   the OS/2 COM??.SYS drivers are loaded.
40:06  word    COM4 port address |  
40:08  word    LPT1 port address
40:0A  word    LPT2 port address
40:0C  word    LPT3 port address
40:0E  word    LPT4 port address        (not valid in PS/2 machines)
40:0E  word    PS/2 pointer to 1k extended BIOS Data Area at top of RAM
40:10  word    equipment flag (see int 11h)
               bits:
               0        1 if floppy drive present (see bits 6&7)  0 if not
               1        1 if 80x87 installed  (not valid in PCjr)
               2,3      system board RAM   (not used on AT or PS/2)
                        00      16k
                        01      32k
                        10      48k
                        11      64k
               4,5      initial video mode
                        00      no video adapter
                        01      40 column color  (PCjr)
                        10      80 column color
                        11      MDA
               6,7      number of diskette drives
                        00      1 drive
                        01      2 drives
                        10      3 drives
                        11      4 drives
               8        0       DMA present
                        1       DMA not present (PCjr)
               9,A,B    number of RS232 serial ports
               C        game adapter  (joystick)
                        0       no game adapter
                        1       if game adapter
               D        serial printer (PCjr only)
                        0       no printer
                        1       serial printer present
               E,F      number of parallel printers installed
       note 1) The IBM PC and AT store the settings of the system board
               switches or CMOS RAM setup information (as obtained by the BIOS
               in the Power-On Self Test (POST)) at addresses 40:10h and
               40:13h. 00000001b indicates "on", 00000000b is "off".
            2) CMOS RAM map, PC/AT:
              offset               contents
                00h         Seconds
                01h         Second Alarm
                02h         Minutes
                03h         Minute Alarm
                04h         Hours
                05h         Hour Alarm
                06h         Day of the Week
                07h         Day of the Month
                08h         Month
                09h         Year
                0Ah         Status Register A
                0Bh         Status Register B
                0Ch         Status Register C
                0Dh         Status Register D
                0Eh         Diagnostic Status Byte
                0Fh         Shutdown Status Byte
                10h         Disk Drive Type for Drives A: and B:
                            The drive-type bytes use bits 0:3 for the first
                            drive and 4:7 for the other
                            Disk drive types:
                            00h         no drive present
                            01h         double sided 360k
                            02h         high capacity (1.2 meg)
                            03h-0Fh     reserved
                11h         (AT):Reserved    (PS/2):drive type for hard disk C:
                12h         (PS/2):drive type for hard disk D:
                            (AT, XT/286):hard disk type for drives C: and D:
                            Format of drive-type entry for AT, XT/286:
                            0       number of cyls in drive (0-1023 allowed)
                            2       number of heads per drive (0-15 allowed)
                            3       starting reduced write compensation (not
                                    used on AT)
                            5       starting cylinder for write compensation
                            7       max. ECC data burst length, XT only
                            8       control byte
                                    Bit
                                    7       disable disk-access retries
                                    6       disable ECC retries
                                    5-4     reserved, set to zero
                                    3       more than 8 heads
                                    2-0     drive option on XT (not used by AT)
                            9       timeout value for XT (not used by AT)
                            12      landing zone cylinder number
                            14      number of sectors per track (default 17,
                                    0-17 allowed)
                13h         Reserved
                14h         Equipment Byte (corresponds to sw. 1 on PC and XT)
                15h-16h     Base Memory Size      (low,high)
                17h-18h     Expansion Memory Size (low,high)
                19h-20h     Reserved
                            (PS/2) POS information Model 50 (60 and 80 use a 2k
                            CMOS RAM that is not accessible through software)
                21h-2Dh     Reserved (not checksumed)
                2Eh-2Fh     Checksum of Bytes 10 Through 20  (low,high)
                30h-31h     Exp. Memory Size as Det. by POST (low,high)
                32h         Date Century Byte
                33h         Information Flags (set during power-on)
                34h-3Fh     Reserved
            3) The alarm function is used to drive the BIOS wait function (int
               15h function 90h).
            4) To access the configuration RAM write the byte address (00-3Fh)
               you need to access to I/O port 70h, then access the data via I/O
               port 71h.
            5) CMOS RAM chip is a Motorola 146818
            6) The equipment byte is used to determine the configuration for the
               power-on diagnostics.
            7) Bytes 00-0Dh are defined by the chip for timing functions, bytes
               0Eh-3Fh  are defined by IBM.
40:12  byte    number of errors detected by infrared keyboard link (PCjr only)
40:13  word    availible memory size in Kbytes (less display RAM in PCjr)
               this is the value returned by int 12h
40:17  byte    keyboard flag byte 0 (see int 9h)
               bit 7  insert mode on      3  alt pressed
                   6  capslock on         2  ctrl pressed
                   5  numlock on          1  left shift pressed
                   4  scrollock on        0  right shift pressed
40:18  byte    keyboard flag byte 1 (see int 9h)
               bit 7  insert pressed      3  ctrl-numlock (pause) toggled
                   6  capslock pressed    2  PCjr keyboard click active
                   5  numlock pressed     1  PCjr ctrl-alt-capslock held
                   4  scrollock pressed   0
40:19  byte    storage for alternate keypad entry (not normally used)
40:1A  word    pointer to keyboard buffer head character
40:1C  word    pointer to keyboard buffer tail character
40:1E  32bytes 16 2-byte entries for keyboard circular buffer, read by int 16h
40:3E  byte    drive seek status - if bit=0, next seek will recalibrate by
               repositioning to Track 0.     
               bit 3  drive D          bit 2  drive C
                   1  drive B              0  drive A
40:3F  byte    diskette motor status
               bit 7  1, write in progress 3  1, D: motor on (floppy 3)
                   6                       2  1, C: motor on (floppy 2)
                   5                       1  1, B: motor on
                   4                       0  1, A: motor on
40:40  byte    motor off counter
               starts at 37 and is decremented 1 by each system clock tick.
               motor is shut off when count = 0.
40:41  byte    status of last diskette operation     where:
               bit 7 timeout failure            bit 3 DMA overrun
                   6 seek failure                   2 sector not found
                   5 controller failure             1 address not found
                   4 CRC failure                    0 bad command
40:42  7 bytes NEC status
40:49  byte    current CRT mode (hex value)
                   00h 40x25 BW      (CGA)          01h 40x25 color   (CGA)
                   02h 80x25 BW      (CGA)          03h 80x25 color   (CGA)
                   04h 320x200 color (CGA)          05h 320x200 BW    (CGA)
                   06h 640x200 BW    (CGA)          07h monochrome    (MDA)  
               extended video modes (EGA/MCGA/VGA or other)
                   08h lores,16 color               09h med res,16 color
                   0Ah hires,4 color                0Bh n/a
                   0Ch med res,16 color             0Dh hires,16 color   
                   0Eh hires,4 color                0Fh hires,64 color 
40:4A  word    number of columns on screen, coded as hex number of columns
               20 col = 14h  (video mode 8, low resolution 160x200 CGA graphics)
               40 col = 28h
               80 col = 46h
40:4C  word    screen buffer length in bytes
               (number of bytes used per screen page, varies with video mode)
40:4E  word    current screen buffer starting offset (active page)
40:50  8 words cursor position pages 1-8
               the first byte of each word gives the column (0-19, 39, or 79)
               the second byte gives the row (0-24)
40:60  byte    end line for cursor   (normally 1)
40:61  byte    start line for cursor (normally 0)
40:62  byte    current video page being displayed  (0-7)
40:63  word    base port address of 6845 CRT controller or equivalent
               for active display           3B4h=mono, 3D4h=color
40:65  byte    current setting of the CRT mode register
40:66  byte    current palette mask setting  (CGA)
40:67  5 bytes temporary storage for SS:SP during shutdown (cassette interface)
40:6C  word    timer counter low word
40:6E  word    timer counter high word
40:69  byte    HD_INSTALL (Columbia PCs) (not valid on most clone computers)
               bit  0 = 0  8 inch external floppy drives
                        1  5-1/4 external floppy drives
                  1,2 =    highest drive address which int 13 will accept
                           (since the floppy drives are assigned 0-3, subtract
                           3 to obtain the number of hard disks installed)

                  4,5 =    # of hard disks connected to expansion controller
                  6,7 =    # of hard disks on motherboard controller
                           (if bit 6 or 7 = 1, no A: floppy is present and
                           the maximum number of floppies from int 11 is 3)
40:70  byte    24 hour timer overflow 1 if timer went past midnight
               it is reset to 0 each time it is read by int 1Ah
40:71  byte    BIOS break flag (bit 7 = 1 means break key hit)
40:72  word    reset flag (1234 = soft reset, memory check will be bypassed)
               PCjr keeps 1234h here for softboot when a cartridge is installed
40:74  byte    status of last hard disk operation; PCjr special diskette control
40:75  byte    # of hard disks attached (0-2)    ; PCjr special diskette control
40:76  byte    hd control byte; temporary holding area for 6th param table entry
40:77  byte    port offset to current hd adapter ; PCjr special diskette control
40:78  4 bytes timeout value for LPT1,LPT2,LPT3,LPT4
40:7C  4 bytes timeout value for COM1,COM2,COM3,COM4 (0-FFh seconds, default 1) 
40:80  word    pointer to start of circular keyboard buffer, default 03:1E
40:82  word    pointer to end of circular keyboard buffer, default 03:3E
40:84  byte    rows on the screen (EGA only)
40:84  byte    PCjr interrupt flag; timer channel 0  (used by POST)
40:85  word    bytes per character (EGA only)
40:85  2 bytes (PCjr only) typamatic char to repeat
40:86  2 bytes (PCjr only) typamatic initial delay
40:87  byte    mode options (EGA only)
               Bit 1   0 = EGA is connected to a color display
                       1 = EGA is monochrome.
               Bit 3   0 = EGA is the active display,
                       1 = "other" display is active.
                  Mode combinations:
                  Bit3  Bit1     Meaning
                    0     0   EGA is active display and is color
                    0     1   EGA is active display and is monochrome
                    1     0   EGA is not active, a mono card is active
                    1     1   EGA is not active, a CGA is active
40:87  byte    (PCjr only) current Fn key code
40:88  byte    feature bit switches (EGA only) 0=on, 1=off
               bit 3 = switch 4 
               bit 2 = switch 3
               bit 1 = switch 2
               bit 0 = switch 1
40:88  byte    (PCjr only) special keyboard status byte
               bit 7 function flag      3 typamatic (0=enable,1=disable)
                   6 Fn-B break         2 typamatic speed (0=slow,1=fast)
                   5 Fn pressed         1 extra delay bef.typamatic (0=enable)
                   4 Fn lock            0 write char, typamatic delay elapsed
40:89  byte    PCjr, current value of 6845 reg 2 (horiz.synch) used by
               ctrl-alt-cursor screen positioning routine in ROM
40:8A  byte    PCjrCRT/CPU Page Register Image, default 3Fh
40:8B  byte    last diskette data rate selected
40:8C  byte    hard disk status returned by controller
40:8D  byte    hard disk error returned by controller
40:8E  byte    hard disk interrupt (bit 7=working int)
40:90  4 bytes media state drive 0, 1, 2, 3
40:94  2 bytes track currently seeked to drive 0, 1
40:96  byte    keyboard flag byte 3 (see int 9h)
40:97  byte    keyboard flag byte 2 (see int 9h)
40:98  dword   pointer to users wait flag
40:9C  dword   users timeout value in microseconds
40:A0  byte    real time clock wait function in use
40:A1  byte    LAN A DMA channel flags
40:A2  2 bytes status LAN A 0,1
40:A4  dword   saved hard disk interrupt vector
40:A8  dword   EGA pointer to parameter table
40:B4  byte    keyboard NMI control flags (Convertible)
40:B5  dword   keyboard break pending flags (Convertible)
40:B9  byte    port 60 single byte queue (Convertible)
40:BA  byte    scan code of last key (Convertible)
40:BB  byte    pointer to NMI buffer head (Convertible)
40:BC  byte    pointer to NMI buffer tail (Convertible)
40:BD  16bytes NMI scan code buffer (Convertible)
40:CE  word    day counter (Convertible and after)
to -04:8F               end of BIOS Data Area
40:90-40:EF             reserved by IBM
04:F0 16 bytes Intra-Application Communications Area (for use by applications
04:FF          to transfer data or parameters to each other)

05:00  byte    DOS print screen status flag
                        00h    not active or successful completion
                        01h    print screen in progress
                        0FFh   error during print screen operation
05:01          Used by BASIC
05:02-03       PCjr POST and diagnostics work area
05:04  byte    Single drive mode status byte
                        00     logical drive A
                        01     logical drive B
05:05-0E       PCjr POST and diagnostics work area
05:0F          BASIC: SHELL flag (set to 02h if there is a current SHELL)
05:10  word    BASIC: segment address storage (set with DEF SEG)
05:12  4 bytes BASIC: int 1Ch clock interrupt vector segment:offset storage
05:16  4 bytes BASIC: int 23h ctrl-break interrupt segment:offset storage
05:1A  4 bytes BASIC: int 24h disk error interrupt vector segment:offset storage
05:1B-1F       Used by BASIC for dynamic storage
05:20-21       Used by DOS for dynamic storage
05:22-2C       Used by DOS for diskette parameter table. See int 1Eh for values
05:30-33       Used by MODE command
05:34-FF       Unknown - Reserved for DOS


At Absolute Addresses:

0008:0047 IO.SYS or IBMBIO.COM IRET instruction. This is the dummy routine that
          interrupts 01h, 03h, and 0Fh are initialized to during POST. 
C000:001E EGA BIOS signature (the letters IBM)
F000:FFF5 BIOS release date
F000:FFFE PC model identification
             date      model byte            submodel byte    revision
           04/24/81     FF = PC-0 (16k)         --              --
           10/19/81     FF = PC-1 (64k)         --              --
           08/16/82     FF = PC, XT, XT/370     --              --
                             (256k motherboard)
           10/27/82     FF = PC, XT, XT/370     --              --
                             (256k motherboard)
           11/08/82     FE = XT, Portable PC    --              --
                             XT/370, 3270PC
           01/10/86     FB = XT                 00              01
           01/10/86     FB = XT-2 (early)   
           05/09/86     FB = XT-2 (640k)        00              02
           06/01/83     FD = PCjr               --              --
           01/10/84     FC = AT                 --              --
           06/10/85     FC = AT                 00              01
           11/15/85     FC = AT                 01              00
           04/21/86     FC = XT/286             02              00
           09/13/85     F9 = Convertible        00              00
           09/02/86     FA = PS/2 Model 30      00              00
           11/15/86     FC = AT, Enhanced 8mHz
           02/13/87     FC = PS/2 Model 50      04              00
           02/13/87     FC = PS/2 Model 60      05              00
           1987         F8 = PS/2 Model 80      00              00
                        2D = Compaq PC (4.77)   --              --
                        9A = Compaq Plus (XT)   --              --

                  00FC 7531/2 Industrial AT
             06FC 7552 Gearbox




                  The IBM PC System Interrupts   (Overview)

 The interrupt table is stored in the very lowest location in memory, starting 
at 0000:0000h. The locations are offset from segment 0, ie location 0000h has
the address for int 0, etc. Each address is four bytes long and its location in
memory can be found by multiplying the interrupt number by 4. For example, int
7 could be found by (7x4=28) or 1Bh (0000:001Bh).
 These interrupt vectors normally point to ROM tables or are taken over by DOS 
when an application is run. Some applications revector these interrupts to 
their own code to change the way the system responds to the user.
 
Interrupt Address    Function
 Number    (Hex)
    0      00-03    CPU   Divide by Zero
    1      04-07    CPU   Single Step
    2      08-0B    CPU   Nonmaskable
    3      0C-0F    CPU   Breakpoint
    4      10-13    CPU   Overflow
    5      14-17    BIOS  Print Screen
    6      18-1B    hdw   Reserved
    7      1C-1F    hdw   Reserved
    8      20-23    hdw   Time of Day
    9      24-27    hdw   Keyboard
    A      28-2B    hdw   Reserved
    B      2C-2F    hdw   Communications [8259]
    C      30-33    hdw   Communications
    D      34-37    hdw   Disk
    E      38-3B    hdw   Diskette
    F      3C-3F    hdw   Printer
   10      40-43    BIOS  Video
   11      44-47    BIOS  Equipment Check
   12      48-4B    BIOS  Memory
   13      4C-4F    BIOS  Diskette/Disk
   14      50-53    BIOS  Serial Communications
   15      54-57    BIOS  Cassette, System Services
   16      58-5B    BIOS  Keyboard
   17      5C-5F    BIOS  Parallel Printer
   18      60-63    BIOS  Resident BASIC
   19      64-67    BIOS  Bootstrap Loader
   1A      68-6B    BIOS  Time of Day
   1B      6C-6F    BIOS  Keyboard Break
   1C      70-73    BIOS  Timer Tick
   1D      74-77    BIOS  Video Initialization
   1E      78-7B    BIOS  Diskette Parameters
   1F      7C-7F    BIOS  Video Graphics Characters, second set
   20      80-83    DOS   General Program Termination
   21      84-87    DOS   DOS Services Function Request
   22      88-8B    DOS   Called Program Termination Address
   23      8C-8F    DOS   Control Break Termination Address
   24      90-93    DOS   Critical Error Handler
   25      94-97    DOS   Absolute Disk Read
   26      98-9B    DOS   Absolute Disk Write
   27      9C-9F    DOS   Terminate and Stay Resident
   28-3F   A0-FF    DOS   Reserved for DOS
   40-43   100-115  BIOS  Reserved for BIOS
   44      116-119  BIOS  First 128 Graphics Characters
   45-47   120-131  BIOS  Reserved for BIOS
   48      132-135  BIOS  PCjr Cordless Keyboard Translation
   49      136-139  BIOS  PCjr Non-Keyboard Scancode Translation Table
   50-5F   140-17F  BIOS  Reserved for BIOS
   60-67   180-19F  Reserved for User Software Interrupts
   68-7F   1A0-1FF  Reserved by IBM
   80-85   200-217  ROM BASIC
   86-F0   218-3C3  Used by BASIC Interpreter When BASIC is Running
   F1-FF   3C4-3FF  Reserved by IBM


 For consistency in this volume, all locations and offsets are in hexadecimal 
unless otherwise specified. All hex numbers are prefaced with a leading zero 
if they begin with an alphabetic character, and are terminated with a 
lowercase H (h). The formats vary according to common usage.


                The IBM-PC System Interrupts  (in detail)


Interrupt  00h  Divide by Zero (processor error). Automatically called at end
(0:0000h)       of DIV or IDIV operation that results in error. Normally set by
                DOS to display an error message and abort the program.


Interrupt  01h  Single step - Taken after every instruction when CPU Trap Flag
(0:0004h)       indicates single-step mode (bit 8 of FLAGS is 1). This is what
                makes the T command of DEBUG work for single stepping. Is not
                generated after MOV to segment register or POP of segment 
                register. (unless you have a very early 8088 with the microcode
                bug).


Interrupt  02h  Non-maskable interrupt - Vector not disabled via CLI. Used by
(0:0008h)       parity check routine in POST, 8087 coprocessor, PCjr infrared
                keyboard link.


Interrupt  03h  Breakpoint - Taken when CPU executes the 1-byte int 3 (0CCh).
(0:000Ch)       Generated by opcode 0CCh. Similar to 8080's RST instruction.
                Generally used to set breakpoints for DEBUG.


Interrupt 04h  Divide overflow -  Generated by INTO instruction if OF flag is
(0:0010h)      set. If flag is not set, INTO is effectively a NOP. Used to trap
               any arithmetic errors when program is ready to handle them rather
               than immediately when they occur.


Interrupt  05h  Print Screen - service dumps the screen to the printer. Invoked
(0:0014h)       by int 9 for shifted key 55 (PrtSc). Automatically called by 
                keyboard scan when PrtSc key is pressed. Normally executes 
                routine to print the screen, but may call any routine that can
                safely be executed from inside the keyboard scanner. Status and
                result byte are at address 0050:0000.
entry   AH      05h
return  absolute address 50:0   
        00h     print screen has not been called, or upon return from a call 
                there were no errors.
        01h     print screen is already in progress.
        0FFh    error encountered during printing.
note 1) Uses BIOS services to read the screen
     2) Output is directed to LPT1
     3) Revectored into GRAPHICS.COM if GRAPHICS.COM is loaded


Interrupt  06h  Reserved by IBM
(0:0018h)


Interrupt  07h  Reserved by IBM
(0:00C0h)


Interrupt  08h  Timer - 55ms timer "tick" taken 18.2 times per second. Updates
(0:0020h)  (IRQ0)  BIOS clock and turns off diskette drive motors after 2
           seconds of inactivity. 
entry   AH      08h
return  absolute addresses:
        40:6C   number of interrupts since power on (4 bytes)
        40:70   number of days since power on (1 byte)
        40:67   day counter on all products after AT
        40:40   motor control count - gets decremented and shuts off diskette 
                motor if zero
note    Int 1Ch invoked as a user interrupt.


Interrupt  09h  Keyboard - taken whenever a key is pressed or released. 
(0:0024h)  (IRQ1)  Stores characters/scan-codes in status at [0040:0017,18]
entry   AH      09h
return  at absolute memory addresses:
        40:17   bit
                0       right shift key depressed
                1       left shift key depressed
                2       control key depressed
                3       alt key depressed
                4       ScrollLock state has been toggled
                5       NumLock state has been toggled
                6       CapsLock state has been toggled
                7       insert state is active
        40:18   bit
                0       left control key depressed
                1       left alt key depressed
                2       SysReq key depressed
                3       Pause key has been toggled
                4       ScrollLock key is depressed
                5       NumLock key is depressed
                6       CapsLock key is depressed
                7       Insert key is depressed
        40:96   bit
                0       last code was the E1h hidden code
                1       last code was the E0h hidden code
                2       right control key down
                3       right alt key down
                4       101 key Enhanced keyboard installed
                5       force NumLock if rd ID & kbx
                6       last character was first ID character
                7       doing a read ID (must be bit 0)
        40:97   bit
                0       ScrollLock indicator
                1       NumLock indicator
                2       CapsLock indicator
                3       circus system indicator
                4       ACK received
                5       resend received flag
                6       mode indicator update
                7       keyboard transmit error flag
        40:1E   keyboard buffer (20h bytes)
        40:1C   buffer tail pointer
        40:72   1234h if ctrl-alt-del pressed on keyboard
     AL   scan code
note 1) Int 05h invoked if PrtSc key pressed
     2) Int 1Bh invoked if Ctrl-Break key sequence pressed
     3) Int 15h, AH=85h invoked on AT and after if SysReq key is pressed
     4) Int 15h, AH=4Fh invoked on machines after AT


Interrupt  0Ah  EGA Vertical Retrace
(0:0028h)  (IRQ2)  used by EGA vertical retrace, hard disk


Interrupt  0Bh  Communications Controller (serial port) hdw. entry
(0:002Ch)  (IRQ3)  Serial Port 2 (com2)
note    IRQ 3 may be used by SDLC (synchronous data-link control) or 
        bisynchronous communications cards instead of a serial port.


Interrupt  0Ch  Communications Controller (serial port) hdw. entry
(0:0030h)  (IRQ4)  Serial Port 1 (com1)
note    IRQ 4 may be used by SDLC (synchronous data-link control) or 
        bisynchronous communications cards instead of a serial port.
                                        

Interrupt  0Dh  Alternate Printer, PC/AT 80287
(0:0034h)  (IRQ5)  used by hard disk, 60 Hz RAM refresh, LPT2 on AT, XT/286,
            and PS/2, dummy CRT vertical retrace on PCjr


Interrupt  0Eh  Diskette - indicates that a seek is in progress
(0:0038h)  (IRQ6)  (sets bit 8 of 40:3E)


Interrupt  0Fh  Reserved by IBM
(0:003Ch)  (IRQ7)  IRQ7 used by PPI interrupt (LPT1, LPT2)

CHAPTER 3     THE PC ROM BIOS

 Programming Technical Reference - IBM
 Copyright 1988, Dave Williams

Interrupt  10h  Video I/O - services to handle video output
(0:0040h)       The ROM video routines in the original PC BIOS are designed for
                use with the Color Graphics Adapter and incorporate code to test
                for the horizontal retrace before writing. The check is
                performed no matter what actual display adapter is installed.
                The ROM character table for the first 128 characters is located
                at 0FA6Eh in the PC. Int 01Fh can be used to point to a second
                table of 128 characters.
                 CS, SS, DS, ES, BX, CX, DX are preserved during call. All
                others are destroyed.

Function 00h    Determine or Set Video State
entry   AH      00h     set video mode
        AL      display mode:                    CGA|PCjr|MDA|MCGA|EGA|VGA|8514
                00h     40x25 B/W text           CGA|PCjr|   |    |EGA|   |
  16 color      01h     40x25 color text         CGA|PCjr|   |    |EGA|   |
                02h     80x25 B/W text           CGA|PCjr|   |    |EGA|   |
  16 color      03h     80x25 color text         CGA|PCjr|   |    |EGA|VGA|
  4 color       04h     320x200 color graphics   CGA|PCjr|   |    |EGA|   |
  4 tone gray   05h     320x200 B/W graphics     CGA|PCjr|   |    |EGA|   |
  2 color       06h     640x200 B/W graphics     CGA|PCjr|   |    |EGA|   |
  monochrome    07h     80x25 monochrome text       |    |MDA|    |EGA|   |
  16 color      08h     160x200 color graphics   CGA|PCjr|   |    |   |   |
  16 color      09h     320x200 color graphics      |PCjr|   |    |   |VGA|
  4 color       0Ah     640x200 color graphics      |PCjr|   |    |   |   |
     N/A        0Bh     BIOS font load              |    |   |    |EGA|VGA|
     N/A        0Ch     BIOS font load              |    |   |    |EGA|VGA|
  16 color      0Dh     320x200 graphics            |    |   |    |EGA|VGA|
  16 color      0Eh     640x200 graphics            |    |   |    |EGA|VGA|
  monochrome    0Fh     640x350 graphics            |    |   |    |EGA|VGA|
  16 & 64 color 10h     640x350 color hi-res        |    |   |    |EGA|VGA|
  2 color       11h     640x480 graphics            |    |   |MCGA|   |VGA|
  16 color      12h     640x480 graphics            |    |   |    |   |VGA|
  256 color     13h     320x200 graphics            |    |   |MCGA|   |VGA|8514
                14h-20h used by EGA and VGA graphics modes
                18h     132x44 8x8 char mono        | Tseng Labs EVA
                19h     132x25 8x14 char mono       | Tseng Labs EVA
                1Ah     132x28 8x13 char mono       | Tseng Labs EVA
 monochrome     21h     Hercules Graphics, Graphics Page 1
 monochrome     22h     Hercules Graphics, Graphics Page 2
                22h     132x44                      | Tseng, Ahead
                23h     132x25                      | Tseng Labs EVA
                        132x25                      | Ahead Systems EGA2001
                        132x25                      | ATI EGA Wonder
                24h     132x28                      | Tseng Labs EVA
                25h     80x60  640x480              | Tseng Labs EVA
 16 color               640x480                     | VEGA VGA
                26h     80x60                       | Tseng Labs EVA
                        80x60   640x480             | Ahead Systems EGA2001
 16 color       27h     720x512                     | VEGA VGA
 monochrome             132x25                      | ATI EGA Wonder
                28h     unknown                     | VEGA VGA
 16 color       29h     800x600                     | VEGA VGA
 256 color      2Dh     640x350                     | VEGA VGA
 256 color      2Eh     640x480                     | VEGA VGA
 256 color      2Fh     720x512                     | VEGA VGA
 256 color      30h     800x600                     | VEGA VGA
                        unknown                     | AT&T 6300
 16 color       36h     960x720                     | VEGA VGA
 16 color       37h     1024x768                    | VEGA VGA
 monochrome             132x44                      | ATI EGA Wonder
 2 color        40h     640x400                     | AT&T 6300
                        80x43                       | VEGA VGA
 16 color       41h     640x200                     | AT&T 6300
                        132x25                      | VEGA VGA
 16 color       42h     640x400                     | AT&T 6300
                        132x43                      | VEGA VGA
                43h     unsupported 640x200 of 640x400 viewport  AT&T 6300
                        80x60                       | VEGA VGA
                44h     disable VDC and DEB output  | AT&T 6300
                        100x60                      | VEGA VGA
                48h     80x50   640x400             | AT&T 6300
                4Dh     120x25                      | VEGA VGA
                4Eh     120x43                      | VEGA VGA
                4Fh     132x25                      | VEGA VGA
 monochrome     50h     132x25                      | Ahead Systems EGA2001
 16 color               640x480                     | Paradise EGA-480
 monochrome             80x43                       | VEGA VGA
                        640x480 mono?               | Taxan 565 EGA
                51h     80x30                       | Paradise EGA-480
 monochrome             132x25                      | VEGA VGA
                        640x480 ?                   | ATI EGA Wonder
 monochrome     52h     132x44                      | Ahead Systems EGA2001
 monochrome             132x43                      | VEGA VGA
                        752x410 ?                   | ATI EGA Wonder
                53h     800x560 ?                   | ATI EGA Wonder
                54h     132x43                      | Paradise EGA-480
 16 color               132x43                      | Paradise VGA
 16 color               132x43                      | Paradise VGA on multisync
                        132x43                      | Taxan 565 EGA
                55h     132x25                      | Paradise EGA-480
 16 color               132x25                      | Paradise VGA
 16 color               132x25                      | Paradise VGA on multisync
                        132x25                      | Taxan 565 EGA
                56h     132x43                      | NSI Smart EGA+
                        132x43                      | Paradise VGA
                        132x43                      | Paradise VGA on multisync
 monochrome             132x43                      | Taxan 565 EGA
                57h     132x25                      | NSI Smart EGA+
                        132x25                      | Paradise VGA
                        132x25                      | Paradise VGA on multisync
 monochrome             132x25                      | Taxan 565 EGA
                58h     100x75   800x600 16/256k    | Paradise VGA
                59h     100x75   800x600            | Paradise VGA
                5Eh     640x400                     | Paradise VGA,VEGA VGA
                5Fh     640x480                     | Paradise VGA
                60h     80x???   ???x400            |  Corona/Cordata BIOS v4.10+
                        752x410                     | VEGA VGA
                60h     400 line graphics+80 col text |(Corona/Cordata)
                61h     400 line graphics           | Corona/Cordata BIOS v4.10+
                        720x540                     | VEGA VGA
                62h     800x600                     | VEGA VGA
 16 color       71h     100x35 800x600              | NSI Smart EGA+
                74h     640x400 graphics            | Toshiba 3100
                82h     80x25 B&W                   | AT&T VDC overlay mode *
                83h     80x25                       | AT&T VDC overlay mode *
                86h     640x200 B&W                 | AT&T VDC overlay mode *
                C0h     640x400   2/prog pallet     | AT&T VDC overlay mode *
                C4h     disable output              | AT&T VDC overlay mode *
                D0h     640x400                     | DEC VAXmate AT&T mode
                unknown 640x225                     | Z-100
                unknown 640x400                     | Z-100

note 1) If the high bit in AL is set, the display buffer is not cleared when a
        new mode is selected. This may be used to mix modes on the display;
        for example, characters of two difference sizes might be displayed
     2) Modes 8-10 are available on the PCjr, Tandy 1000, and PS/2
     3) IBM claims 100% software and hardware emulation of the CGA with the
        MCGA chipset. All registers may be read and written as CGA. All
        characters are double-scanned to give 80x25 with 400 line resolution.
        The attributes for setting border color may be set on MCGA, but the
        borders will remain the default color (they cannot actually be set)
     4) The IBM Color Graphics Adapter (CGA) is too slow for the screen to
        be updated before the vertical retrace of the monitor is completed.
        If the video RAM is addressed directly, the screen will have "snow"
        or interference. IBM's default is to turn the adapter off when it is
        being updated, ie "flickering" when the display is scrolled.
     5) The vertical retrace signal may be ignored when using the MCGA adapter.
        The MCGA will not generate snow when written to. There is no flicker
        with the MCGA.
     6) The PCjr Video Gate Array uses a user-defined block of main system RAM
        from 4 to 32k in size instead of having dedicated memory for the
        display. Vertical retrace may be ignored when writing to the PCjr.
        There is no flicker with the PCjr display.
     7) The Hercules Graphics Card has 750x348 resolution
     8) The Hercules Graphics Card takes 32k beginning at B:000 (same as MDA)
     9) The CGA, MCGA, and VGA adapters use hardware address B:800
    10) The BIOS clears the screen when the mode is set or reset.
    11) For AT&T VDC overlay modes, BL contains the DEB mode, which may be 06h,
        40h, or 44h


Function 01h    Set Cursor Type - set the size of the cursor or turn it off
entry   AH      01h
        CH      bit values:
                bits 0-4  top line for cursor in character cell
                bits 5-6  blink attribute
                          00    normal
                          01    invisible (no cursor)
                          10    slow      (not used on original IBM PC)
                          11    fast
        CL      bit values:
                bits 0-4  bottom line for cursor in character cell
return  none
note 1) The ROM BIOS default cursors are:  start    end
                     monochrome mode 07h:    11     12
                      text modes 00h-03h:     6      7
     2) The blinking in text mode is caused by hardware and cannot be turned
        off, though some kludges can temporarily fake a nonblinking cursor
     3) The cursor is automatically turned off in graphics mode
     4) Another method of turning off the cursor in text mode is to position it
        to a nondisplayable address, such as (X,Y)=(0,25)
     5) Buggy on EGA systems - BIOS remaps cursor shape in 43 line modes, but
        returns unmapped cursor shape


Function 02h    Set Cursor Position - reposition the cursor to (X,Y)
entry   AH      02h
        BH      video page
                00h     graphics mode
                03h     modes 2 and 3
                07h     modes 0 and 1
        DH      row    (Y=0-24)
        DL      column (X=0-79 or 0-39)
return  none
note 1) (0,0) is upper left corner of the screen


Function 03h    Read Cursor Position - return the position of the cursor
entry   AH      03h
        BH      page number
                00h     in graphics modes
                03h     in modes 2 & 3
                07h     in modes 0 & 1
return  CH      top line for cursor    (bits 4-0)
        CL      bottom line for cursor (bits 4-0)
        DH      row number    (Y=0-24)
        DL      column number (X=0-79 or 0-39)


Function 04h    Read Light Pen - fetch light pen information
entry   AH      04h
return  AH      00h     light pen not triggered
        AH      01h     light pen is triggered, values in resgisters
        BX      pixel column               (X=0-319 or 0-639)  graphics mode
        CH      raster line                (Y=0-199)        old graphics modes
        CX      (EGA) raster line (0-nnn)                   new graphics modes
        DH      row of current position    (Y=0-24)            text mode
        DL      column of current position (X=0-79 or 0-39)    text mode
note    Not supported on PS/2


Function 05h    Select Active Page - set page number for services 6 and 7
entry   AH      05h
        AL      number of new active page
                0-7     modes 00h and 01h (CGA)
                0-3     modes 02h and 03h (CGA)
                0-7     modes 02h and 03h (EGA)
                0-7     mode 0Dh (EGA)
                0-3     mode 0Eh (EGA)
                0-1     mode 0Fh (EGA)
                0-1     mode 10h (EGA)
for PCjr only:
        AL      80h to read CRT/CPU page registers
                81h to set CPU page register to value in BL
                82h to set CRT page register to value in BH
                83h to set both CPU and page registers
                    (and Corona/Cordata BIOS v4.10+)
        BH      CRT page number for subfunctions 82h and 83h
        BL      CPU page register for subfunctions 81h and 83h
return  standard PC  none
        PCjr         if called with AH bit 7=1 then
                     BH      CRT page register
                     BL      CPU page register
        DX      segment of graphics bitmap buffer (video modes 60h,61h; AL0Fh)
note 1) Mono adapter has only one display page
     2) CGA has four 80x25 text pages or eight 40x25 text pages
     3) A separate cursor is maintained for each display page
     4) Switching between pages does not affect their contents
     5) Higher page numbers indicate higher memory positions


Function 06h    Scroll Page Up - scroll up or clear a display "window"
entry   AH      06h
        AL      number of lines blanked at bottom of page
                0 = blank entire window
        BH      attributes to be used on blank line
        CH      row    (Y) of upper left corner or window
        CL      column (X) of upper left corner of window
        DH      row    (Y) of lower right corner of window
        DL      column (X) of lower right corner of window
return  none
note 1) Push BP before scrolling, pop after
     2) If in CGA text mode, affects current page only


Function 07h    Scroll Page Down - scroll down or clear a display "window"
entry   AH      07h
        AL      number of lines to be blanked at top of page
                0 = blank entire window
        BH      attributes to be used on blank line
        CH      row    (Y) of upper left corner or window
        CL      column (X) of upper left corner of window
        DH      row    (Y) of lower right corner of window
        DL      column (X) of lower right corner of window
return  none
note 1) Push BP before scrolling, pop after
     2) If in CGA text mode, affects current page only


Function 08h    Read Character Attribute - of character at current cursor pos.
entry   AH      08h
        BH      display page number - text mode
return  AH      character attribute - text mode
        AL      ASCII code of character at current cursor position


Function  09h   Write Character and Attribute - at current cursor position
entry   AH      09h
        AL      ASCII code of character to display
        BH      display page number - text mode
        BL      attribute/color of character
        CX      number of characters to write
return  none
note 1) CX should not exceed actual rows availible, or results may be erratic
     2) Setting CX to zero will cause runaway
     3) All values of AL result in some sort of display; the various control
        characters are not recognized as special and do not change the current
        cursor position
     4) Does not change cursor position when called - the cursor must be
        advanced with int 10 function 0Ah.
     5) If used to write characters in graphics mode with bit 7 of AH set to 1
        the character will by XORed with the current display contents.
     6) In graphics mode the bit patterns for ASCII character codes 80h-0FFh
        are obtained from a table. On the standard PC and AT, the location is at
        interrupt vector 01Fh (0000:007C). For ASCII characters 00h-07Fh, the
        table is at an address in ROM. On the PCjr the table is at interrupt
        vector 44h (0000:00110) and is in addressable RAM (may be replaced by
        the user)
     7) All characters are displayed, including CR, LF, and BS


Function 0Ah    Write Character - display character(s) (use current attribute)
entry   AH      0Ah
        AL      ASCII code of character to display
        BH      display page - text mode
        BL      color of character (graphics mode, PCjr only)
        CX      number of times to write character
return  none
note 1) CX should not exceed actual rows availible, or results may be erratic
     2) All values of AL result in some sort of display; the various control
        characters are not recognized as special and do not change the current
        cursor position
     3) If used to write characters in graphics mode with bit 7 of AH set to 1
        the character will by XORed with the current display contents.
     4) In graphics mode the bit patterns for ASCII character codes 80h-0FFh
        are obtained from a table. On the standard PC and AT, the location is at
        interrupt vector 01Fh (0000:007C). For ASCII characters 00h-07Fh, the
        table is at an address in ROM. On the PCjr the table is at interrupt
        vector 44h (0000:00110) and is in addressable RAM (may be replaced by
        the user)
     5) In EGA in graphics modes, replication count in CX works correctly only
        if all characters written are contained on the same row
     6) All characters are displayed, including CR, LF, and BS


Function 0Bh    Set Color Palette - set palette for graphics or text border
entry   AH      0Bh
        BH      00h     select border (text mode)
        BL      color 0-15, 16-31 for high-intensity characters
        BH      01h     set graphics palette with value in BL
 (CGA)  BL      0       green/red/yellow
                1       cyan/magenta/white
 (EGA) (graphics modes)
        BH      0
        BL      has border color (0-15) & high intensity bkgr'd color (16-31)
        BH      1
        BL      contains palette being selected (0-1)
return  none
note 1) Valid in CGA mode 04h, PCjr modes 06h, 08h-0Ah
     2) Although the registers in the MCGA may be set as if to change the
        border, the MCGA will not display a border no matter what register
        settings are used.


Function 0Ch    Write Dot - plot one graphics pixel
entry   AH      0Ch
        AL      dot color code  (0/1 in mode 6, 0-3 in modes 4 and 5)
                (set bit 7 to XOR the dot with current color)
                0-3 mode 04h, 05h
                0-1 mode 06h
        BH      page number (ignored if adapter supports only one page)
        CX      column (X=0000h - 027Fh)
                (0 - 319 in modes 4,5,13,  0 - 639 in modes 6,14,15,16)
        DX      row    (Y=0000h - 00C7h) (0 - 199 CGA)
return  none
note    Video graphics modes 4-6 only


Function 0Dh    Read Dot - determine the color of one graphics pixel
entry   AH      0Dh
        CX      column (X=0000h - 027Fh)  (0-319 or 639)
        DX      row    (Y=0000h - 00C7h)  (0-199)
return  AL      color of dot
note    Only valid in graphics mode


Function 0Eh    Write TTY - write one character and update cursor. Also handles
                CR (0Dh), beep (07h), backspace (10h), and scrolling
entry   AH      0Eh
        AL      ASCII code of character to be written
        BH      page number (text)
        BL      foreground color (video modes 6 & 7 only) (graphics)
return  none
note 1) The ASCII codes for bell, backspace, carriage return, and linefeed are
        recognized and appropriate action taken. All other characters are
        written to the screen and the cursor is advanced to the next position
     2) Text can be written to any CGA page regardless of current active page
     3) Automatic linewrap and scrolling are provided through this function
     4) This is the function used by the DOS CON console driver.
     5) This function does not explicitly allow the use of attributes to the
        characters written. Attributes may be provided by first writing an ASCII
        27h (blank) with the desired attributes using function 09h, then
        overwriting with the actual character using this function. While clumsy
        this allows use of the linewrap and scrolling services provided by
        this function


Function 0Fh    Return Current Video State - mode and size of the screen
entry   AH      0Fh
return  AH      number of character columns on screen
        AL      mode currently set (see AH=00h for display mode codes)
        BH      current active display page
note    If mode was set with bit 7 set ("no blanking"), the returned mode will
        also have bit 7 set


Function 10h    Set Palette Registers
                PCjr, Tandy 1000, EGA, MCGA, VGA
entry   AH      10h
        AL      00h     set individual palette register
                01h     set border color palette register
                02h     set all palette registers and overscan
                03h     toggle blink/intensity bit           (EGA, MCGA, VGA)
                04h     unknown
                05h     unknown
                06h     unknown
                07h     read individual palette register                 (VGA)
                08h     read overscan (order color)                      (VGA)
                09h     read all palette registers and overscan register (VGA)
                10h     set individual video DAC color register    (MCGA, VGA)
                11h     unknown
                12h     set block of video DAC color registers     (MCGA, VGA)
                13h     set video DAC color page                         (VGA)
                14h     unknown
                15h     read individual video DAC color register   (MCGA, VGA)
                16h     unknown
                17h     read block of video DAC color registers    (MCGA, VGA)
                18h     unknown
                19h     unknown
                1Ah     read video DAC color-page state                  (VGA)
                1Bh     perform gray-scale summing                       (VGA)
        BH      color value
        BL      if AL=00h       palette register to set (00h-0Fh)
                if AL=03h       0       to enable intensity
                                1       to enable blinking
        ES:DX   if AL=02h       pointer to 16-byte table of register values
                                followed by the overscan value:
                                bytes 0-15     values for palette registers 0-15
                                byte 16        value for border register
return  none
note    DAC is Digital to Analog Convertor circuit in MCGA/VGA chips


Function 11h    Character Generator Routine (EGA and after)
entry   AH      11h
                The following functions will cause a mode set, completely
                resetting the video environment, but without clearing the video
                buffer.
                AL      00h, 10h  load user-specified patterns
                        ES:BP   pointer to user table
                        CX      count of patterns to store
                        DX      character offset into map 2 block
                        BL      block to load in map 2
                        BH      number of bytes per character pattern
                AL      01h, 11h  load ROM monochrome patterns (8 by 14)
                        BL      block to load
                AL      02h, 12h  load ROM 8 by 8 double-dot patterns
                        BL      block to load
                AL      03h       set block specifier
                        BL      block specifier
                AL      04h       load 8x16 text characters (MCGA, VGA)
                AL      14h       set 8x16 text characters (MCGA, VGA)
                The routines called with AL=1x are designed to be called only
                immediately after a mode set and are similar to the routines
                called with AL=0x, except that:
                        Page 0 must be active.
                        Bytes/character is recalculated.
                        Max character rows is recalculated.
                        CRT buffer length is recalculated.
                        CRTC registers are reprogrammed as follows:
                        reg09h    bytes/char-1; max scan line (mode 7 only)
                        reg0Ah    bytes/char-2; cursor start
                        reg0Bh    0           ; cursor end
                        reg12h    ((rows+1)*(bytes/char))-1
                                              ; vertical display end
                        reg14h    bytes/char  ; underline loc
                                  (*** BUG: should be 1 less ***)
                The following functions are meant to be called only after a
                mode set:
                AL      20h     user 8 by 8 graphics characters (INT 1FH)
                                ES:BP = pointer to user table
                AL      21h     user graphics characters
                        ES:BP   pointer to user table
                        CX      bytes per character
                        BL      row specifier
                                0       user set - DL = number of rows
                                1       14 rows
                                2       25 rows
                                3       43 rows
                AL      22h     ROM 8 by 14 set
                        BL      row specifier
                AL      23h     ROM 8 by 8 double dot
                        BL      row specifier
                AL      24h     load 8x16 graphics characters (MCGA, VGA)
                AL      30h     return information
                        BH      pointer specifier
                                0       int 1Fh pointer
                                1       int 44h pointer
                                2       ROM 8 by 14 character font pointer
                                3       ROM 8 by 8 double dot font pointer
                                4       ROM 8 by 8 DD font (top half)
                                5       ROM text alternate (9 by 14) pointer
return  ES:BP   specified pointer value
        CX      bytes/character
        DL      character rows on screen



Function 12h    Alternate Select (EGA and after)
entry   AH      12h
        AL      00h     unknown
                01h     unknown
                02h     select 400 line mode                            (VGA)
        BL      10h     return EGA information
                20h     select alternate print screen routine
                30h     select vertical resolution for text modes       (VGA)
                31h     enable/disable default palette loading    (MCGA, VGA)
                32h     enable/disable video addressing           (MCGA, VGA)
                33h     enable/disable default gray scale summing (MCGA, VGA)
                34h     enable/diable text cursor emulation             (VGA)
                35h     display-switch interface
return  BH      00h     if color mode is in effect
                01h     if mono mode is in effect
        BL      00h     if 64k EGA memory
                01h     if 128k EGA memory
                02h     if 192k EGA memory
                03h     if 256k EGA memory
        CH      feature bits
        CL      switch settings


Function 13h    Write String, Don't Move Cursor              (AT, XT/286, PS/2)
entry   AH      13h
        AL      00h
        BH      display page number
        BL      attribute
        CX      length of string
        DX      starting cursor position
        ES:BP   pointer to start of string
return  none


Function 13h    Write String, Move Cursor                    (AT, XT/286, PS/2)
entry   AH      13h
        AL      01h
        BH      display page number
        BL      attribute
        DX      starting cursor position
        CX      length of string
        ES:BP   pointer to start of string
return  none


Function 13h    Write String of Alternating Characters and Attributes;
                Don't Move Cursor                            (AT, XT/286, PS/2)
entry   AH      13h
        AL      02h
                bit 0: set in order to move cursor after write
                bit 1: set if string contains alternating chars and attributes
        BH      display page number
        BL      attribute if AL bit 1 clear
        CX      length of string
        DH      row of starting cursor position
        DL      column of starting cursor position
        ES:BP   pointer to start of string
return  none


Function 13h    Write String of Alternating Characters and Attributes;
                Move Cursor                                  (AT, XT/286, PS/2)
entry   AH      13h
        AL      03h
            bit 0: set in order to move cursor after write
            bit 1: set if string contains alternating characters and attributes
        BH      display page number
        BL      attribute if AL bit 1 clear
        CX      length of string
        DH,DL   row,column of starting cursor position
        ES:BP   pointer to start of string
return  none
note    Recognizes CR, LF, BS, and bell


Function 14h    Load LCD Character Font                      (Convertible)
entry   AH      14h
        AL      00h     load user specified font

        BH      number of bytes per character
        BL      00h     load main font (block 0)
                01h     load alternate font (block 1)

        AL      01h     load system ROM default font
        BL      00h     load main font (block 0)
                01h     load alternate font (block 1)

        AL      02h     set mapping of LCD high intensity attribute
        BL      00h     ignore high intensity attribute
                01h     map high intensity to underscore
                02h     map high intensity to reverse video
                03h     map high intensity to seleected alternate font
        ES:DI   pointer to character font
        CX      number of characters to store
        DX      character offset into RAM font area


Function 15h    Return Physical Display Parameters           (Convertible)
return  AX      Alternate display adapter type
        ES:DI   pointer to parameter table:
                word #  information
                01h     monitor model number
                02h     vertical pixels per meter
                03h     horizontal pixels per meter
                04h     total number of vertical pixels
                05h     total number of horizontal pixels
                06h     horizontal pixel separation in micrometers
                07h     vertical pixel separation in micrometers


Function 1Ah    Display Combination Code                     (PS/2)
                Using the compatibility BIOS of the PS/2 Models 50, 60, 80 there
                is a way to determine which video controller and attached
                display are on the system.  The Display Combination Code (DCC)
                is a Video BIOS function that provides the capability.
entry   AH      1Ah
        AL      00h     read display combination code
                01h     write display combination code
return  AL      1Ah     indicates Compatibility BIOS is supported,
                         any other value is invalid
        BH      alternate display device
                where:
                00h     no display
                01h     IBM monochrome display and printer adapter
                02h     IBM color/graphics monitor adapter
                03h     reserved
                04h     IBM EGA (color display)
                05h     IBM EGA (monochrome)
                06h     IBM PGA
                07h     VGA (analog monochrome display)
                08h     VGA (analog color display)
                09h     reserved
                0Ah     reserved
                0Bh     IBM PS/2 Model 30 (analog monochrome display)
                0Ch     IBM PS/2 Model 30 (analog color display)
        BL      active display device


Function 1Bh    Functionality/State Information              (MCGA, VGA)
entry   AH      1Bh
return  unknown


Function 1Ch    Save/Restore Video State                     (VGA)
entry   AH      1Ch
        AL      00h     return state buffer size
                01h     save video state
                02h     restore video state
return  unknown
note    VGA only


Function 70h    Get Video RAM Address                        (Tandy 1000)
entry   AH      70h
return  AX      segment addresses of the following
                BX      offset address of green plane
                CX      segment address of green plane
                DX      segment address of red/blue plane
note    (red offset = 0, blue offset = 4000)


Function 71h    Get INCRAM Addresses                         (Tandy 1000)
entry   AH      71h
return  AX      segment address of the following
                BX = segment address of INCRAM
                CX = offset address of INCRAM


Function 72h    Scroll Screen Right                          (Tandy 1000)
entry   AH      72h
        AL      number of columns blanked at left of page
                00h     blank window
        BH      attributes to be used on blank columns
        CH,CL   row, column address of upper left corner
        DH,DL   row, column address of lower right corner


Function 73h    Scroll Screen Left                           (Tandy 1000)
entry   AH      73h
        AL      number of columns blanked at right of page
                00h     blank window
        BH      attributes to be used on blank columns
        CH,CL   row, column address of upper left corner
        DH,DL   row, column address of lower right corner


Function 81h    DESQview video - Get something?
entry   AH      81h
        DX      4456h ('DV')
return  ES    segment of DESQview data structure for video buffer
        byte ES:[0] = current window number
note    This function is probably meant for internal use only, due to the
        magic value required in DX


Function 82h    DESQview - Get Current Window Info
entry   AH      82h
        DX      4456h ('DV')
return  AH      unknown
        AL      current window number
        BH      unknown
        BL      direct screen writes
                0       program does not do direct writes
                1       program does direct writes, so shadow buffer not usable
        CH      unknown
        CL      current video mode
        DS      segment in DESQview for data structure
                in DV 2.00,
                  byte DS:[0] = window number
                  word DS:[1] = segment of other data structure
                  word DS:[3] = segment of window's object handle
        ES      segment of DESQview data structure for video buffer
note    This function is probably meant for internal use only, due to the magic
        value required in DX


Function 0F0h   Microsoft Mouse driver EGA support - Read One Register
entry   AH      0F0h
        BL      register number
        DX      group index
            Pointer/data chips
               00h CRT Controller (25 reg) 3B4h mono modes, 3D4h color modes
               08h Sequencer (5 registers) 3C4h
               10h Graphics Controller (9 registers) 3CEh
               18h Attribute Controller (20 registers) 3C0h
            Single registers
               20h Miscellaneous Output register 3C2h
               28h Feature Control register (3BAh mono modes, 3DAh color modes)
               30h Graphics 1 Position register 3CCh
               38h Graphics 2 Position register 3CAh
return  BL      data


Function 0F1h   Microsoft Mouse driver EGA support - Write One Register
entry   AH      0F1h
        DX      group index (see function F0h)
        BL      register number
        BH      value to write
return  BL      data


Function 0F2h   Microsoft Mouse driver EGA support - Read Register Range
entry   AH      0F2h
        CH      starting register number
        CL      number of registers (>1)
        DX      group index
                00h     CRTC (3B4h mono modes, 3D4h color modes)
                08h     Sequencer 3C4h
                10h     Graphics Controller 3CEh
                18h     Attribute Controller 3C0h
        ES:BX   pointer to buffer, CL bytes


Function 0F3h   Microsoft Mouse driver EGA support - Write Register Range
entry   AH      0F3h
        CH      starting register
        CL      number of registers (>1)
        DX      group index
                00h     CRTC (3B4h mono modes, 3D4h color modes)
                08h     Sequencer 3C4h
                10h     Graphics Controller 3CEh
                18h     Attribute Controller 3C0h
        ES:BX   pointer to buffer, CL bytes


Function 0F4h   Microsoft Mouse driver EGA support - Read Register Set
entry   AH      0F4h
        CX      number of registers (>1)
        ES:BX   pointer to table of records in this format:
             bytes 1-2 group index
                Pointer/data chips
                   00h CRTC (3B4h mono modes, 3D4h color modes)
                   08h Sequencer 3C4h
                   10h Graphics Controller 3CEh
                   18h Attribute Controller 3C0h
                Single registers
                   20h Miscellaneous Output register 3C2h
                   28h Feature Control register (3BAh mono modes, 3DAh color)
                   30h Graphics 1 Position register 3CCh
                   38h Graphics 2 Position register 3CAh
             byte 3 register number (0 for single registers)
             byte 4 register value


Function 0F5h   Microsoft Mouse driver EGA support - Read Register Set
entry   AH      0F5h
        CX      number of registers (>1)
        ES:BX   pointer to table of records in this format:
             bytes 1-2 port number
                Pointer/data chips
                   00h CRTC (3B4h mono modes, 3D4h color modes)
                   08h Sequencer 3C4h
                   10h Graphics Controller 3CEh
                   18h Attribute Controller 3C0h
                Single registers
                   20h Miscellaneous Output register 3C2h
                   28h Feature Control register (3BAh mono modes, 3DAh color)
                   30h Graphics 1 Position register 3CCh
                   38h Graphics 2 Position register 3CAh
             byte 3 register number (0 for single registers)
             byte 4 register value


Function 0F6h   Microsoft Mouse driver EGA support
                Revert to Default Registers
entry   AH      0F6h
return  unknown


Function 0F7h   Microsoft Mouse driver EGA support
                Define Default Register Table
entry   AH      0F7h
        DX      port number
           Pointer/data chips
              00h CRTC (3B4h mono modes, 3D4h color modes)
              08h Sequencer 3C4h
              10h Graphics Controller 3CEh
              18h Attribute Controller 3C0h
           Single registers
              20h Miscellaneous Output register 3C2h
              28h Feature Control register (3BAh mono modes, 3DAh color modes)
              30h Graphics 1 Position register 3CCh
              38h Graphics 2 Position register 3CAh
        ES:BX address of table of one byte entries, one byte
              to be written to each register


Function 0FAh   Microsoft Mouse driver EGA support - Interrogate Driver
entry   AH      0FAh
        BX      00h
return  BX      00h     if mouse driver not present
        ES:BX   pointer to EGA Register Interface version number, if present:
                byte 1  major release number
                byte 2  minor release number


Function 0FEh   Get Alternate Screen Buffer Address (text mode only)
                                                    (Topview/DesQview/Taskview)
entry   AH     0FEh
        ES:DI  segment:offset of assumed video buffer
return: ES:DI  segment:offset of actual video buffer
note 1) This alternate video buffer can be written to directly, in the same
        manner as writing to B:000 or B:800. The MT program will manage the
        actual display.
     2) There is no need to synchronize vertical retrace when writing to the
        alternate buffer; this is managed by the MT program
     3) If TopView or DESQview is not running, ES:DI is returned unchanged.
     4) TopView requires that function 0FFh be called every time you write into
        the buffer to tell TopView that something changed


Function 0FFh   Update Real Display (text mode only)                  (TopView)
                Update Video Buffer                 (Topview/DesQview/Taskview)
entry   AH      0FFh
        CX      number of sequential characters that have been modified
        DI      offset of first character that has been modified
        ES      segment of video buffer
return  unknown
note 1) DesQview supports this call, but does not require it
     2) Avoid CX=0




Interrupt 11h   Equipment Check
(0:0044h)       fetch a code describing active peripherals.
entry   AH      11h
return  AX      Equipment listing word          Bits are:
                0       number of floppy drives
                        0       no drives
                        1       bootable diskette installed
                1       math chip
                        0       no math coprocessor (80x87) present
                        1       math coprocessor (80x87) present
         (PS/2) 2       0       mouse not installed
                        1       mouse installed
          (PC)  2,3     system board RAM
                        0,0     16k    (PC-0, PC-1)
                        1,1     64k    (PC-2, XT)
                        note 1) not commonly used. Set both bits to 1
                             2) both bits always 1 in AT
                4,5     initial video mode
                        0,0     no video installed (use with dumb terminal)
                        0,1     40x25 color      (CGA)
                        1,0     80x25 color      (CGA)
                        1,1     80x25 monochrome (MDA or Hercules)
                6,7     number of diskette drives (only if bit 0  1)
                        0,0     1 drives
                        0,1     2 drives
                        1,0     3 drives
                        1,1     4 drives
                8       0       DMA present
                        1       no DMA on system (PCjr, some Tandy 1000s)
                9,A,B   number of RS232 serial ports (0-3)
                        0,0,0   none
                        0,0,1   1
                        0,1,0   2
                        0,1,1   3
                        1,0,0   4
                C       0       no game I/O attached
                        1       game I/O attached (default for PCjr)
                D       serial accessory installation
                        0       no serial accessories installed
                        1       Convertible - internal modem installed
                        1       PCjr - serial printer attached
                E,F     number of parallel printers
                        0,0     none
                        0,1     one   (LPT1, PRN)
                        1,0     two   (LPT2)
                        1,1     three (LPT3)
                        note    Models before PS/2 would allow a fourth
                                parallel printer. Remapping of the BIOS in the
                                PS/2s does not allow the use of LPT4.



Interrupt 12h   Memory Size
(0:0048h)       get system memory
return  AX      number of contiguous 1K RAM blocks
note 1) This service does not depend on the setting of the motherboard switches
     2) This is the same value stored in absolute address 04:13h



Interrupt 13h  Disk I/O - access the disk drives (floppy and hard disk)
(0:004Ch)      does not try rereading disk if an error is returned


Function 00h    Reset - reset the disk controller chip
entry   AH      00h
        DL      drive (if bit 7 is set both hard disks and floppy disks reset)
return  AH      status
note 1) Forces controller chip to recalibrate read/write heads
     2) Some systems (Sanyo 55x) this resets all drives


Function 01h    Get Status of disk system
entry   AH      01h
        DL      drive (hard disk if bit 7 set)
return  AL      status of most recent operation
                00h     successful completion
                01h     bad command
                02h     address mark not found
                03h     tried to write on write-protected disk
                04h     sector not found
                05h     reset failed (hard disk)
                06h     diskette removed or changed
                07h     bad parameter table (hard disk)
                08h     DMA overrun
                09h     attempt to DMA across 64K boundary
                0Ah     bad sector detected (hard disk)
                0Bh     bad track detected (hard disk)
                0Ch     unsupported track
                0Dh     invalid number of sectors on format (hard disk)
                0Eh     control data address mark detected (hard disk)
                0Fh     DMA arbitration error (hard disk)
                10h     bad CRC/EEC on read
                11h     data ECC corrected
                20h     controller failure
                40h     seek failed
                80h     timeout
                0AAh    drive not ready (hard disk)
                0BBh    undefined error (hard disk)
                0CCh    write fault     (hard disk)
                0E0h    status error    (hard disk)
                0FFh    sense operation failed (hard disk)


Function 02h    Read Sectors - read one or more sectors from diskette
entry   AH      02h
        AL      number of sectors to read
        BX      address of buffer (ES=segment)
        CH      track number (0-39 or 0-79 for floppies)
                (for hard disk, bits 8,9 in high bits of CL)
        CL      sector number (1 to 18, not value checked)
        DH      head number (0 or 1)
        DL      drive (0=A, 1=B, etc.) (bit 7=0)  (drive 0-7)
        ES:BX   address to store/fetch data  (buffer to fill)
       [0000:0078]  dword pointer to diskette parms
return  CF      clear (0) for successful
                set (1) failure
                AH      status (00h, 02h, 03h, 04h, 08h, 09h, 10h, 0Ah, 20h,
                        40h, 80h)
        AL      number of sectors transferred
note 1) Number of sectors begins with 1, not 0
     2) Trying to read zero sectors is considered a programming error; results
        are not defined


Function 03h    Write Sectors - write from memory to disk
entry   AH      03h
        AL      number of sectors to write (1-8)
        CH      track number (for hard disk, bits 8,9 in high bits of CL)
        CL      beginning sector number
                (if hard disk, high two bits are high bits of track #)
        DH      head number
        DL      drive number (0-7)
        ES:BX   address of buffer for data
return  CF      set if error
                AH      status (see above)
        AL      number of sectors written
note 1) Number of sectors begins with 1, not 0
     2) Trying to write zero sectors is considered a programming error; results
        are not defined


Function 04h    Verify - verify that a write operation was successful
entry   AH      04h
        AL      number of sectors to verify (1-8)
        CH      track number  (for hard disk, bits 8,9 in high bits of CL)
        CL      beginning sector number
        DH      head number
        DL      drive number (0-7)
return  CF      set on error
                AH      status (see above)
        AL      number of sectors verified


Function 05h    Format Track - write sector ID bytes for 1 track
entry   AH      05h
        AL      number of sectors to create on this track
        CH      track (or cylinder) number
        CL      sector number
        DH      head number (0, 1)
        DL      drive number (0-3)
        ES:BX   pointer to 4-byte address field (C-H-R-N)
                byte 1 = (C) cylinder or track
                byte 2 = (H) head
                byte 3 = (R) sector
                byte 4 = (N) bytes/sector (0 = 128, 1 = 256, 2 = 512, 3 = 1024)
return  CF      set if error occurred
                AH      status code (see above)
note    Not valid for ESDI hard disks on PS/2


Function 06h    Hard Disk - format track and set bad sector flags
                                                     (PC2, PC-XT, and Portable)
entry   AH      06h
        AL      interleave value (XT only)
        CH      cylinder number (bits 8,9 in high bits of CL)
        CL      sector number
        DH      head
        DL      drive
        ES:BX   512 byte format buffer
                the first 2*(sectors/track) bytes contain f,n for each sector
                   f  00Fh for good sector
                      80h for bad sector
                   n  sector number
return  AH      status code


Function 07h    Hard Disk - format the drive starting at the desired track
                                                      (PC2, PC-XT and Portable)
entry   AH      07h
        AL      interleave value (XT only) (01h-10h)
        CH      cylinder number (bits 8,9 in high bits of CL) (00h-03FFh)
        CL      sector number
        DH      head number (0-7)
        DL      drive number (80h-87h, 80h=C, 81h=D,...)
        ES:BX   format buffer, size = 512 bytes
                the first 2*(sectors/track) bytes contain f,n for each sector
                f=00h for good sector
                  80h for bad sector
                n=sector number
return  AH      status code (see above)


Function 08h    Read Drive Parameters             (XT, CONV, AT, XT/286, PS/2)
entry   AH      08h
        DL      drive number (0-2)
return  CF      set on error
                AH      status code (see above)
        BL      drive type (see AH=17h below) (AT/PS2 floppies only)
        CH      maximum useable value for cylinder number
        CL      maximum useable value for sector number or cylinder number
        DH      maximum usable value for head number
        DL      number of consecutive acknowledging drives (0-2)
        ES:DI   drive parameter table


Function 09h    Initialize Two Fixed Disk Base Tables    (XT, AT, XT/286, PS/2)
                (install nonstandard drive)
entry   AH      09h
return  CF      set on error
                AH      status code (see above)
                data block definitions:
                +0   maximum number of cylinders (dw)
                +2   maximum number of heads (db)
                +3   starting reduced write current cylinder  (dw - XT only)
                +5   starting write precomp cylinder (dw)
                +7   maximum ECC data burst length (db - XT only)
                +8   control byte: Bits
                     0,1,2 Ä drive option
                     3,4,5 - always zero
                         6 - disable ECC retries
                         7 - disable access retries
note 1) Int 41h points to table for drive 0
     2) Int 46h points to table for drive 1
     3) 41h used by XT, 41h and 46h used by AT


Function 0Ah    Read Long   (Hard disk)                 (XT, AT, XT/286, PS/2)
entry   AH      0Ah
        CH      cylinder number (bits 8,9 in high bits of CL)
        CL      sector number
        DL      drive ID
        DH      head number
        ES:BX   pointer to buffer to fill
return  CF      set on error
                AH      status code (see above)
        AL      number of sectors actually transferred
note 1) A "long" sector includes a 4 byte EEC (Extended Error Correction) code
     2) Used for diagnostics only on PS/2 systems


Function 0Bh    Write Long                              (XT, AT, XT/286, PS/2)
entry   AH      0Bh
        CH      cylinder (bits 8,9 in high bits of CL)
        CL      sector number
        DH      head number
        DL      drive ID
        ES:BX   pointer to buffer containing data
return  CF      set on error
                AH      status code (see above)
        AL      number of sectors actually transferred
note 1) A "long" sector includes a 4 byte EEC (Extended Error Correction) code
     2) Used for diagnostics only on PS/2 systems


Function 0Ch    Seek To Cylinder                (except PC, PCjr)
entry   AH      0Ch
        CH      cylinder number (bits 8,9 in high bits of CL)
        DH      head number
        DL      drive ID
return  CF      set on error
                AH      status code (see above)
note 1) Positions heads over a particular cylinder


Function 0Dh    Alternate Disk Reset                    (except PC, PCjr)
entry   AH      0Dh
        DL      drive ID
return  CF      set on error
        AH      status code (see above)
note    Not for PS/2 ESDI hard disks


Function 0Eh    Read Sector Buffer                         (XT, Portable PS/2)
entry   AH      0Eh
        AL      number of sectors
        CH      cylinder (bits 8,9 in top two bits of CL)
        CL      sector number
        DH      head number
        DL      drive number
        ES:BX   pointer to buffer
return  CF      set on error
                AH      status code (see above)
        AL      number of sectors actually transferred
note 1) Transfers controller's sector buffer.  No data is read from the drive
     2) Used for diagnostics only on PS/2 systems


Function 0Fh    Write sector buffer                          (XT, Portable)
entry   AH      0Fh
        AL      number of sectors
        CH      cylinder (bits 8,9 in top two bits of CL)
        CL      sector number
        DH      head number
        DL      drive number
        ES:BX   pointer to buffer
return  CF      set if error
                AH      status code
        AL      number of sectors actually transferred
note 1) Should be called before formatting to initialize the controller's
        sector buffer.
     2) Used for diagnostics only on PS/2 systems


Function 10h    Test For Drive Ready
entry   AH      10h
        DL      drive ID
return  CF      set on error
                AH      status code (see above)


Function 11h    Recalibrate Drive
entry   AH      11h
        DL      drive ID
return  CF      set on error
                AH      status code (see above)


Function 12h    Controller RAM Diagnostic                (XT, Portable, PS/2)
entry   AH      12h
return  CF      set on error
                AH      status code (see AH=1 above)
note    Used for diagnostics only on PS/2 systems


Function 13h    Drive Diagnostic                             (XT, Portable)
entry   AH      13h
return  CF      set on error
                AH      status code (see above)
note    Used for diagnostics only on PS/2 systems


Function 14h    Controller Internal Diagnostic               (AT, XT/286)
entry   AH      14h
return  CF      set on error
        AH      status code (see above)
note 1) OEM is Western Digital 1003-WA2 hard/floppy combination controller
        in AT and XT/286.
     2) Used for diagnostics only in PS/2 systems


Function 15h    Get Disk Type                                (except PC and XT)
entry   AH      15h
        DL      drive ID
return  AH      disk type
                00h     no drive is present
                01h     diskette, no change detection present
                02h     diskette, change detection present
                03h     fixed disk
        CX:DX   number of 512-byte sectors when AH = 03h


Function 16h    Change of Disk Status (diskette)             (except PC and XT)
entry   AH      16h
return  AH      disk change status
                00h     no disk change
                01h     disk changed
        DL      drive that had disk change


Function 17h    Set Disk Type for Format (diskette)          (except PC and XT)
entry   AH      17h
        AL      00h     no disk
                01h     360kb diskette in 360Kb drive
                02h     360kb diskette in 1.2M drive
                03h     1.2M diskette in 1.2M drive
                04h     720kb diskette in 720Kb drive
        DL      drive number
return  AH      status of operation
note    This function is probably enhanced for the PS/2 series to detect
        1.44 in 1.44 and 720k in 1.44.


Function 18h    Set Media Type For Format  (diskette)        (AT, XT/286, PS/2)
entry   AH      18h
        CH      lower 8 bits of number of tracks
        CL      high 2 bits of number of tracks (6,7) sectors per track
                (bits 0-5)
        DL      drive number
return  AH      00h      if requested combination supported
                01h      if function not available
                0Ch      if not suppported or drive type unknown
                80h      if there is no media in the drive
        ES:DI   pointer to 11-byte parm table


Function 19h    Park Hard Disk Heads                         (XT/286, PS/2)
entry   AH      19h
        DL      drive
return  CF      set on error
                AH      error code


Function 1Ah    ESDI Hard Disk - Format                         (PS/2)
entry   AH      1Ah
        AL      defect table count
        CL      format modifiers
                bit 0:  ignore primary defect map
                bit 1:  ignore secondary defect map
                bit 2:  update secondary defect map
                bit 3:  perform surface analysis
                bit 4:  generate periodic interrupt
        DL      drive
        ES:BX   pointer to defect table
return  CF      set on error
                AH      status (see AH=1 above)
note    If periodic interrupt selected, int 15h/AH=0Fh is called after each
        cylinder is formatted





Interrupt 14h   Initialize and Access Serial Port For Int 14
(0:0050h)       the following status is defined:

        serial status byte:
        bits    0 delta clear to send
                1 delta data set ready
                2 trailing edge ring detector
                3 delta receive line signal det.
                4 clear to send
                5 data set ready
                6 ring indicator
                7 receive line signal detect

        line status byte:
        bits    0 data ready
                1 overrun error
                2 parity error
                3 framing error
                4 break detect
                5 transmit holding reg. empty
                6 transmit shift register empty
                7 time out  note: if bit 7 set then other bits are invalid

 All routines have AH=function number and DX=RS232 card number (0 based).
AL=character to send or received character on exit, unless otherwise noted.

entry   AH      00h     Initialize And Access Serial Communications Port
                        bit pattern: BBBPPSLL
                        BBB = baud rate:   110,150,300,600,1200,2400,4800,9600
                        PP  = parity:      01 = odd, 11 = even
                        S   = stop bits:   0 = 1, 1 = 2
                        LL  = word length: 10 = 7-bits, 11 = 8-bits
        AL      parms for initialization:
                bit pattern:
                0       word length
                1       word length
                2       stop bits
                3       parity
                4       parity
                5       baud rate
                6       baud rate
                7       baud rate
                word length     10      7 bits
                                11      8 bits
                stop bits       0       1 stop bit
                                1       2 stop bits
                parity          00      none
                                01      odd
                                11      even
                baud rate       000     110 baud
                                001     150 baud
                                010     300 baud
                                011     600 baud
                                100     1200 baud
                                101     2400 baud
                                110     4800 baud
                                111     9600 baud  (4800 on PCjr)
        DX      port number
return  AH      line status
        AL      modem status


Function 01h    Send Character in AL to Comm Port DX (0 or 1)
entry   AH      01h
        AL      character
        DX      port number (0 or 1)
return  AH      RS232 status code
                bit     0       data ready
                        1       overrun error
                        2       parity error
                        3       framing error
                        4       break detected
                        5       transmission buffer register empty
                        6       transmission shift register empty
                        7       timeout
        AL      modem status
                bit
                        0       delta clear-to-send
                        1       delta data-set-ready
                        2       trailing edge ring detected
                        3       change, receive line signal detected
                        4       clear-to-send
                        5       data-set-ready
                        6       ring received
                        7       receive line signal detected


Function 02h    Wait For A Character From Comm Port DX
entry   AH      02h
return  AL      character received
        AH      error code (see above)(00h for no error)


Function 03h    Fetch the Status of Comm Port DX (0 or 1)
entry   AH      03h
return  AH      set bits (01h) indicate comm-line status
                bit     7       timeout
                bit     6       empty transmit shift register
                bit     5       empty transmit holding register
                bit     4       break detected ("long-space")
                bit     3       framing error
                bit     2       parity error
                bit     1       overrun error
                bit     0       data ready
        AL      set bits indicate modem status
                bit     7       received line signal detect
                bit     6       ring indicator
                bit     5       data set ready
                bit     4       clear to send
                bit     3       delta receive line signal detect
                bit     2       trailing edge ring detector
                bit     1       delta data set ready
                bit     0       delta clear to send


Function 04h    Extended Initialize                             (PC Convertible)
entry   AH      04h
        AL      break status
                01h     if break
                00h     if no break
        BH      parity
                00h     no parity
                01h     odd parity
                02h     even parity
                03h     stick parity odd
                04h     stick parity even
        BL      number of stop bits
                00h     one stop bit
                01h     2 stop bits (1« if 5 bit word length)
        CH      word length
                00h     5 bits
                01h     6 bits
                02h     7 bits
                03h     8 bits
        CL      baud rate
                00h     110
                01h     150
                02h     300
                03h     600
                04h     1200
                05h     2400
                06h     4800
                07h     9600
                08h     19200
return  AL      modem status
        AH      line control status


Function 05h    Extended Communication Port Control             (PS/2)
entry   AH      05h
        AL      00h     read modem control register
                return  BL      modem control reg (see AL=1)
        AL      01h     write modem control register
        BL      modem control register: (for AL=00 and AL=01)  bits
                0       data terminal ready
                1       request to send
                2       out1
                3       out2
                4       loop
                5,6,7   reserved
return  AH      status


Interrupt 15h   Cassette I/O
(0:0054h)       Renamed "System Services" on PS/2 line


Function 00h    Turn Cassette Motor On                          (PC, PCjr only)
entry   AH      00h
return  AH      86h     no cassette present
        CF      set on error
note    NOP for systems where cassette not supported


Function 01h    Turn Cassette Motor Off                         (PC, PCjr only)
entry   AH      01h
return  AH      86h     no cassette present
        CF      set on error
note    NOP for systems where cassette not supported


Function 02h    Read Blocks From Cassette                       (PC, PCjr only)
entry   AH      02h
        CX      count of bytes to read
        ES:BX   pointer to data buffer
return  CF      set on error
                AH      error code
                        01h     CRC error
                        02h     bad tape signals
                        03h     no data found on tape
                        04h     no data
                        80h     invalid command
                        86h     no cassette present
        DX      count of bytes actually read
        ES:BX   pointer past last byte written
note 1) NOP for systems where cassette not supported
     2) Cassette operations normally read 256 byte blocks


Function 03h    Write Data Blocks to Cassette                   (PC, PCjr only)
entry   AH      03h
        CX      count of bytes to write
        ES:BX   pointer to data buffer
return  CF      set on error
                AH      error code (see 02h)
        CX      0
        ES:BX   pointer to last byte written+1
note 1) NOP for systems where cassette not supported
     2) The last block is padded to 256 bytes with zeroes if needed
     3) No errors are returned by this service


Function 0Fh    ESDI Format Unit Periodic Interrupt          (PS/2 50, 60, 80)
entry   AH      0Fh
        AL      phase code
                00h     reserved
                01h     surface analysis
                02h     formatting
return  CF      clear   if formatting should continue
                set     if it should terminate
note    Called during ESDI drive formatting after each cylinder is completed


Function 10h    TopView API Function Calls                      (TopView)
entry   AX      00h     PAUSE   Give Up CPU Time
                        return  00h     after other processes run
                01h     GETMEM  allocate "system" memory
                        BX      number of bytes to allocate
                        return  ES:DI pointer to block of memory
                02h     PUTMEM  deallocate "system" memory
                        ES:DI   pointer to previously allocated block
                        return  block freed
                03h     PRINTC  display character/attribute on screen
                        BH      attribute
                        BL      character
                        DX      segment of object handle for window
                        note    BX=0 does not display anything, it only
                                positions the hardware cursor
                10h     unknown
                        AL      04h thru 12h
                        return  TopView - unimplemented in DV 2.0x
                                pops up "Programming error" window in DV 2.0x
                11h     unknown
                12h     unknown
                13h     GETBIT  define a 2nd-level interrupt handler
                        ES:DI   pointer to FAR service routine
                        return  BX      bit mask indicating which bit was
                                        allocated
                                        0 if no more bits available
                14h     FREEBIT undefine a 2nd-level interrupt handler
                        BX      bit mask from int 15/AH 13h
                15h     SETBIT  schedule one or more 2nd-level interrupts
                        BX      bit mask for interrupts to post
                        return  indicated routines will be called at next ???
                16h     ISOBJ   verify object handle
                        ES:DI   possible object handle
                        return   BX     -1 if ES:DI is a valid object handle
                                         0 if ES:DI is not
                17h     TopView - unimplemented in DV 2.00
                        return  pops up "Programming Error" window in DV 2.00
                18h     LOCATE  Find Window at a Given Screen Location
                        BH      column
                        BL      row
                        ES      segment of object handle for ???
                                (0 = use default)
                        return  ES      segment of object handle for window
                                        which is visible at the indicated
                                        position
                19h     SOUND   Make Tone
                        BX      frequency in Hertz
                        CX      duration in clock ticks (18.2 ticks/sec)
                        return  immediately, tone continues to completion
                        note    If another tone is already playing, the new tone
                                does not start until completion of the previous
                                one. In DV 2.00, it is possible to enqueue
                                about 32 tones before the process is blocked
                                until a note completes.
                                In DV 2.00, the lowest tone allowed is 20 Hz
                1Ah     OSTACK  Switch to Task's Internal Stack
                        return  stack switched
                1Bh     BEGINC  Begin Critical Region
                        return  task-switching temporarily disabled
                        note    Will not task-switch until END CRITICAL REGION
                                (AH=1Ch) is called
                1Ch     ENDC    End Critical Region
                        return  task-switching enabled
                1Dh     STOP    STOP TASK
                        ES      segment of object handle for task to be stopped
                                (== handle of main window for that task)
                        return  indicated task will no longer get CPU time
                        note    At least in DV 2.00, this function is ignored
                                unless the indicated task is the current task.
                1Eh     START   Start Task
                        ES      segment of object handle for task to be started
                                (== handle of main window for that task)
                        return  Indicated task is started up again
                1Fh     DISPEROR Pop-Up Error Window
                        BX      bit fields:
                                0-12    number of characters to display
                                13,14   which mouse button may be pressed to
                                        remove window
                                        00      either
                                        01      left
                                        10      right
                                        11      either
                                15      beep if 1
                        DS:DI   pointer to text of message
                        CH      width of error window (0 = default)
                        CL      height of error window (0 = default)
                        DX      segment of object handle
                        return  BX      status:
                                        1       left button pressed
                                        2       right button pressed
                                        27      ESC key pressed
                        note    Window remains on-screen until ESC or indicated
                                mouse button is pressed
                20h     TopView - unimplemented in DV 2.0x
                        return  pops up "Programming Error" window in DV 2.0x
                21h     PGMINT  Interrupt Another Task
                        BX      segment of object handle for task to interrupt
                        DX:CX   address of FAR routine to jump to next time
                                task is run
                        return  nothing?
                        note    The current ES, DS, SI, DI, and BP are passed
                                to the FAR routine
                22h     GETVER  Get Version
                        BX      00h
                        return  BX      nonzero, TopView or compatible loaded
                                BH      minor version
                                BL      major version
                        notes   TaskView returns BX = 0001h
                                DESQview 2.0 returns BX = 0A01h
                23h     POSWIN  Position Window
                        BX      segment of object handle for parent window
                                within which to position the window (0 = full
                                screen)
                        CH      # columns to offset from position in DL
                        CL      # rows to offset from position in DL
                        DL      bit flags
                                0,1     horizontal position
                                        00      current
                                        01      center
                                        10      left
                                        11      right
                                2,3     vertical position
                                        00      current
                                        01      center
                                        10      top
                                        11      bottom
                                4       don't redraw screen if set
                                5-7     not used
                        ES      segment of object handle for window to be
                                positioned
                        return  nothing
                24h     GETBUF  Get Virtual Screen Information
                        BX      segment of object handle for window (0=default)
                        return  CX      size of virtual screen in bytes
                                DL      0 or 1, unknown
                                ES:DI   address of virtual screen
                25h     USTACK  Switch Back to User's Stack
                        return  stack switched back
                        note    Call only after int 15h,fn1Ah
                26h
           thru 2Ah     DesQview (TopView?) - unimplemented in DV 2.0x
                        return  pops up "Programming Error" window in DV 2.0x
                2Bh     POSTTASK  Awaken Task       DesQview 2.0 (TopView?)
                        BX      segment of object handle for task
                        return  nothing
                2Ch     Start New Application in New Process
                        DesQview 2.0 (TopView?)
                        ES:DI   pointer to contents of .PIF/.DVP file
                        BX      size of .PIF/.DVP info
                        return  BX      segment of object handle for new task
                2Dh     Keyboard Mouse Control       DesQview 2.0
                        BL      subfunction
                                00h     determine whether using keyboard mouse
                                01h     turn keyboard mouse on
                                02h     turn keyboard mouse off
                        return  (calling BL was 00h)
                                BL      0       using real mouse
                                        1       using keyboard mouse





Function 20h    PRINT.COM  (DOS internal)        (AT, XT-286, PS/2 50+)
entry   AH      20h
        AL      subfunction
                00h     unknown (PRINT)
                01h     unknown (PRINT)
                10h     sets up SysReq routine on AT, XT/286, PS/2
                11h     completion of SysReq routine (software only)
note 1) AL=0 or 1 sets or resets some flags which affect what PRINT does when
        it tries to access the disk


Function 21h    Power-On Self Test (POST) Error Log             (PS/2 50+)
entry   AH      21h
        AL       00h    read POST log
                 01h    write POST log
                        BH      device ID
                        BL      error code
return  CF      set on error
        AH      status
                00h    OK
                01h    list full
                80h    invalid cmd
                86h    unsupported
        if function 00h:
                BX      number of error codes stored
                ES:DI   pointer to error log
note:   The log is a series of words, the first byte of which identifies the
        error code and the second the device.


Function 40h    Read/Modify Profiles                            (Convertible)
entry   AH      40h
        AL      00h     read system profile in CX,BX
                01h     write system profile from CX, BX
                02h     read internal modem profile in BX
                03h     write internal modem profile from BX
        BX      profile info
return  BX      internal modem profile (from 02h)
        CX,BX   system profile (from 00h)


Function 41h    Wait On External Event                          (Convertible)
entry   AH      41h
        AL      condition type
                bits 0-2: condition to wait for
                          0 any external event
                          1 compare and return if equal
                          2 compare and return if not equal
                          3 test and return if not zero
                          4 test and return if zero
                bit 3:    reserved
                bit 4:    1=port address, 0=user byte
                bits 5-7: reserved
        BH      condition compare or mask value
                condition codes:
                0       any external event
                1       compare and return if equal
                2       compare and return if not equal
                3       test and return if not zero
                4       test and return if zero
        BL      timeout value times 55 milliseconds
                0 if no time limit
        DX      I/O port address (if AL bit 4 = 1)
        ES:DI   pointer to user byte (if AL bit 4 = 0)


Function 42h    Request System Power Off                        (Convertible)
entry   AH      42h
        AL      00h     to use system profile
                01h     to force suspend regardless of profile


Function 43h    Read System Status                              (Convertible)
entry   AH      43h
return  AL      status bits:
                0       LCD detached
                1       reserved
                2       RS232/parallel powered on
                3       internal modem powered on
                4       power activated by alarm
                5       standby power lost
                6       external power in use
                7       battery low


Function 44h    (De)activate Internal Modem Power               (Convertible)
entry   AH      44h
        AL      00h      to power off
                01h      to power on


Function 4Fh    Keyboard Intercept                    (except PC, PCjr, and XT)
entry   AH      4Fh
        AL      scan code, CF set
return  AL      scan code, CF set if processing desired
note    Called by int 9 handler to translate scan codes


Function 80h    Device Open                                  (AT, XT/286, PS/2)
entry   AH      80h
        BX      device ID
        CX      process ID
return  CF      set on error
        AH      status


Function 81h    Device Close                                 (AT, XT/286, PS/2)
entry   AH      81h
        BX      device ID
        CX      process ID
return  CF      set on error
        AH      status


Function 82h    Program Termination                          (AT, XT/286, PS/2)
        AH      82h
        BX      device ID
return: CF      set on error
        AH      status
note    Closes all devices opened with function 80h


Function 83h    Event Wait                       (AT, XT/286, Convertible, PS/2)
entry   AH      83h
        AL      00h     to set interval
                10h     to cancel
        CX,DX   number of microseconds to wait (granularity is 976 microseconds)
        ES:BX   pointer to memory flag (bit 7 is set when interval expires)
                (pointer is to caller's memory)
return  CF      set (1) if function already busy


Function 84h    Read Joystick Input Settings                 (AT, XT/286, PS/2)
entry   AH      84h
        DX      00h     to read the current switch settings  (return in AL)
                01h     to read the resistive inputs
return  AX      A(X) value
        BX      A(Y) value
        CX      B(X) value
        DX      B(Y) value
        AL      switch settings (bits 7-4)


Function 85h    System Request (SysReq) Key Pressed        (except PC, PCjr, XT)
entry   AH      85h
return  AL      00h      key pressed
                01h      key released
note    Called by keyboard decode routine


Function 86h    Elapsed Time Wait                          (except PC, PCjr, XT)
        AH      86h
        CX,DX   number of microseconds to wait
return  CF      clear   after wait elapses
        CF      set     immediately due to error
note    Only accurate to 977 microseconds


Function 87h    Extended Memory Block Move              (286/386 machines only)
        AH      87h
        CX      number of words to move
        ES:SI   pointer to Global Descriptor Table (GDT)
                offset 00h      null descriptor
                       08h      uninitialized, will be made into GDT descriptor
                       10h      descriptor for source of move
                       18h      descriptor for destination of move
                       20h      uninitialized, used by BIOS
                       28h      uninitialized, will be made into SS descriptor
return  CF      set on error
        AH      status
                00h     source copied into destination
                01h     parity error
                02h     interrupt error
                03h     address line 20 gating failed


Function 88h    Extended Memory Size Determine                (AT, XT/286, PS/2)
entry   AH      88h
return  AX      # of contiguous 1K blocks of memory starting at address 1024k


Function 89h    Switch Processor to Protected Mode            (AT, XT/286, PS/2)
entry   AH      89h
        BH      interrupt number of IRQ 8 (IRQ 9Fh use next 7 interrupts)
        BL      interrupt number of IRQ 0 (IRQ 17h use next 7 interrupts)
        CX      offset into protected mode CS to jump to
        DS:SI   pointer to Global Descriptor Table for protected mode
                offset  00h     null descriptor
                        08h     GDT descriptor
                        10h     IDT descriptor
                        18h     DS
                        20h     ES
                        28h     SS
                        30h     CS
                        38h     uninitialized, used to build descriptor for
                                BIOS CS
return  AH      0FFh  error enabling address line 20
        CF      set on error


Function 90h    Device Busy Loop                         (except PC, PCjr, XT)
entry   AH      90h
        AL      type code:
                00h     disk
                01h     diskette
                02h     keyboard
                03h     PS/2 pointing device
                80h     network (ES:BX = ncb)
                0FCh    disk reset
                0FDh    diskette motor start
                0FEh    printer
        ES:BX   pointer to request block for type codes 80h through 0BFh
return  CF      1 (set) if wait time satisfied
                0 (clear) if driver must perform wait
note    Used by NETBIOS
        Type codes are allocated as follows:
        00h-7Fh non-reentrant devices; OS must arbitrate access
        80h-BFh reentrant devices; ES:BX points to a unique control block
        C0h-FFh wait-only calls, no complementary int 15,fn91h call


Function 91h    Set Flag and Complete Interrupt          (except PC, PCjr, XT)
entry   AH      91h
        AL      type code (see AH=90h above)
        ES:BX    pointer to request block for type codes 80h through 0BFh
return  AH       0
note    Used by NETBIOS


Function 0C0h   Get System Configuration      (XT after 1/10/86, PC Convertible,
                                               XT/286, AT, PS/2)
entry   AH      0C0h
return  CF      1 if BIOS doesn't support call
        ES:BX   pointer to ROM system descriptor table
                dword   number of bytes following
                byte    ID byte: PC    FF
                                 XT    FE or FB
                                 PCjr  FD
                byte    secondary ID distingushes between AT and XT/286, etc.
                byte    BIOS revision level, 0 for 1st release, 1 for 2nd, etc.
                byte    feature information
                        80h     DMA channel 3 used by hard disk BIOS
                        40h     2nd 8259 installed
                        20h     realtime clock installed
                        10h     int 15h,fn 04h called upon int 09h
                        08h     wait for external event supported
                        04h     extended BIOS area allocated at 640k
                        03h     reserved
                        02h     bus is Micro Channel instead of PC
                        01h     reserved
                        00h     reserved
                word    unknown (set to 0)
                word    unknown (set to 0)
note    Int 15h is also used for the Multitask Hook on PS/2 machines. No
        register settings availible yet.
        The 1/10/86 XT BIOS returns an incorrect value for the feature byte.



Function 0C1h   System - Return Extended-BIOS Data-Area Segment Address (PS/2)
entry   AH      0C1h
return  CF      set on error
        ES      segment of data area


Function 0C2h   Pointing Device BIOS Interface      (DesQview 2.x)    (PS/2)
entry   AH      0C2h
        AL      00h     enable/disable
                        BH      00h    disable
                01h     reset
                        return  BH     device ID
                02h     set sampling rate
                        BH      00h    10/second
                                01h    20/second
                                02h    40/second
                                03h    60/second
                                04h    80/second
                                05h    100/second
                                06h    200/second
                03h set resolution
                        BH     00h     one count per mm
                               01h     two counts per mm
                               02h     four counts per mm
                               03h     eight counts per mm
                04h     get type
                        return  BH      device ID
                05h     initialize
                        BH      data package size (1 - 8 bytes)
                06h     get/set scaling factor
                        BH      00h return device status
                                return  BL      status
                                        bit 0: right button pressed
                                        bit 1: reserved
                                        bit 2: left button pressed
                                        bit 3: reserved
                                        bit 4: 0=1:1 scaling, 1=2:1 scaling
                                        bit 5: device enabled
                                        bit 6: 0=stream mode, 1=remote mode
                                        bit 7: reserved
                                        CL      resolution (see function 03h)
                                        DL      sample rate, reports per second
                                01h     set scaling at 1:1
                                02h     set scaling at 2:1
                07h     set device handler address
                        ES:BX   user device handler
                        return  AL      00h
return  CF      set on error
        AH      status
                00h     successful
                01h     invalid function
                02h     invalid input
                03h     interface error
                04h     need to resend
                05h     no device handler installed
note    The values in BH for those functions that take it as input are stored
        in different locations for each subfunction


Function 0C3h   Enable/Disable Watchdog Timeout                 (PS/2 50+)
entry   AH      0C3h
        AL      00h     disable
                01h     enable
                        BX      timer counter
return  CF      set on error
note    The watchdog timer generates an NMI


Function 0C4h   Programmable Option Select                      (PS/2 50+)
entry   AH      04Ch
        AL      00h     return base POS register address
                01h     enable slot
                        BL      slot number
                02h     enable adapter
return  CF      set on error
        DX      base POS register address (if function 00h)


Function 0DEh   DesQview Services                             (DesQview)
entry   AH      0DEh
        AL      00h     Get Program Name
                        return  AX      offset into DESQVIEW.DVO of current
                                        program's record:
                                        byte    length of name
                                        n bytes name
                                        2 bytes keys to invoke program (second
                                                = 00h if only one key used)
                                        word    ? (I see 0 always)
                                        byte    end flag: 00h for all but last
                                                entry, which is 0FFh
                01h     Update "Open Window" Menu
                        return  none
                        note    Reads DESQVIEW.DVO, disables Open menu if file
                                not in current directory
                02h     unimplemented in DV 2.0x
                        return  nothing (NOP in DV 2.0x)
                03h     unimplemented in DV 2.0x
                        return  nothing (NOP in DV 2.0x)
                04h     Get Available Common Memory
                        return  BX      bytes of common memory available
                                CX      largest block available
                                DX      total common memory in bytes
                05h     Get Available Conventional Memory
                        return  BX      K of memory available
                                CX      largest block available
                                DX      total conventional memory in K
                06h     Get Available Expanded Memory
                        return  BX      K of expanded memory available
                                CX      largest block available
                                DX      total expanded memory in K
                07h     APPNUM  Get Current Program's Number
                        return  AX      number of program as it appears on the
                                        "Switch Windows" menu
                08h     GET (unknown)
                        return  AX      0       unknown
                                        1       unknown
                09h     unimplemented in DV 2.00
                        return  nothing (NOP in DV 2.00)
                0Ah     DBGPOKE Display Character on Status Line
                        BL      character
                        return  character displayed, next call will display in
                                next position (which wraps back to the start of
                                the line if off the right edge of screen)
                        note 1) Displays character on bottom line of *physical*
                                screen, regardless of current size of window
                                (even entirely hidden)
                             2) Does not know about graphics display modes,
                                just pokes the characters into display memory
                0Bh     APILEVEL Define Minimum API Level Required
                        BL      API level
                                >2 pops up "You need a newer version" error
                                window in DV 2.00
                        BH      unknown
                        return  AX      maximum API level?
                0Ch     GETMEM  Allocate "System" Memory
                        BX      number of bytes
                        return  ES:DI   pointer to allocated block
                0Dh     PUTMEM  Deallocate "System" Memory
                        ES:DI   pointer to previously allocated block
                        return  nothing
                0Eh     Find Mailbox by Name    (DV 2.0+)
                        ES:DI   pointer to name to find
                        CX      length of name
                        return  BX      0       not found
                                        1       found
                                DS:SI   object handle
                0Fh     Enable DesQview Extensions      (DV 2.0+)
                        return  AX and BX destroyed (seems to be bug, weren't
                                saved & restored)
                        note 1) Sends a manager stream with opcodes AEh, BDh,
                                and BFh to task's window
                             2) Enables an additional mouse mode
                10h     PUSHKEY  PUT KEY INTO KEYBOARD INPUT STREAM  (DV 2.0+)
                        BH      scan code
                        BL      character
                        return  BX      unknown (sometimes, but not always,
                                        same as BX passed in)
                        note    A later read will get the keystroke as if it
                                had been typed by the user
                11h     ENABLE/DISABLE AUTO JUSTIFICATION OF WINDOW (DV 2.0+)
                        BL      0       viewport will not move automatically
                                nonzero viewport will move to keep cursor
                                        visible
                        return  none
                12h     unknown (DV 2.0+)
                        BX      0       clear something?
                                nonzero set something?
                        return  none





Interrupt 16h   Keyboard I/O
(0:0058h)       access the keyboard


Function  00h   Get Keyboard Input - read the next character in keyboard buffer,
                if no key ready, wait for one.
entry   AH      00h
return  AH      scan code
        AL      ASCII character


Function  01h   Check Keystroke Buffer - Do Not Clear
entry   AH      01h
return  ZF      0 (clear) if character in buffer
                1 (set)   if no character in buffer
        AH      scan code of character (if ZF=0)
        AL      ASCII character if applicable
note    Keystroke is not removed from buffer


Function  02h   Shift Status - fetch bit flags indicating shift status
entry   AH      02h
return  AL      bit codes (same as [0040:0017])
                bit 7   Insert state
                bit 6   CapsLock state
                bit 5   NumLock state
                bit 4   ScrollLock state
                bit 3   Alt key
                bit 2   Control key
                bit 1   Left shift (left caps-shift key)
                bit 0   Right shift (right caps-shift key)
note    other codes found at [0040:0018]
                bit 7   Insert shift (Ins key)
                bit 6   Caps shift (CapsLock key)
                bit 5   Num shift (NumLock key)
                bit 4   Scroll shift (ScrollLock key)
                bit 3   Hold state (Ctrl-NumLock is in effect)


Function 03h    Keyboard - Set Repeat Rate            (PCjr, AT, XT/286, PS/2)
entry   AH      03h
        AL      00h     reset typematic             (PCjr)
                01h     increase initial delay      (PCjr)
                02h     increase continuing delay   (PCjr)
                03h     increase both delays        (PCjr)
                04h     turn off typematic          (PCjr)
                05h     set typematic rate          (AT, PS/2)
        BH      00h-03h for delays of 250ms, 500ms, 750ms, or 1s
        BL      00h-1Fh for typematic rates of 30cps down to 2cps


Function 04h    Keyboard Click Toggle                 (PCjr and Convertible)
entry   AH      04h
        AL      00h     for click off
                01h     for click on


Function 05h    Keyboard Buffer Write            (AT or PS/2 with enhanced kbd)
                (XT/286, PS/2, AT with "Enhanced" keyboard)
entry   AH      05h
        CH      scan code
        CL      ASCII character
return  AL      01h if buffer full


Function 10h    Get Enhanced Keystroke And Read      (F11, F12 Enhanced Keyb'd)
                (XT/286, PS/2, AT with "Enhanced" keyboard)
entry   AH      10h
return  AH      scan code
        AL      ASCII character if applicable


Function 11h    Check Enhanced Keystroke         (F11-F12 on enhanced keyboard)
                (XT/286, PS/2, AT with "Enhanced" keyboard)
entry   AH      11h
return  ZF      0       (clear) if key pressed
                1       if buffer empty
        AH      scan code (when ZF=0)
        AL      ASCII character if applicable (when ZF=0)
note    Keystroke is not removed from buffer


Function 12h    Extended Get Shift Status         (F11, F12 Enhanced keyboard)
entry    AH     12h
return   AL     bit
                0       right Shift key depressed
                1       left Shift key depressed
                2       Control key depressed
                3       Alt key depressed
                4       ScrollLock state active
                5       NumLock state active
                6       CapsLock state active
                7       insert state is active
        AH      0       left Control key pressed
                1       left Alt key depressed
                2       right Control key pressed
                3       right Alt key depressed
                4       Scroll Lock key depressed
                5       NumLock key depressed
                6       CapsLock key depressed
                7       SysReq key depressed


Function 0F0h   Set CPU speed (Compaq 386)
entry   AH      0F0h     set speed
return  unknown
note    used by Compaq DOS MODE command.
        parameters not availible




Interrupt 17h   Printer
(0:005Ch)       access the parallel printer(s)
                AH is changed. All other registers left alone.

Function  00h   Print Character/send AL to printer DX (0, 1, or 2)
entry   AH      00h
        AL      character
        DX      printer to be used (0,1,2)
return  AH      status byte
                bit
                0       time out
                1       unused
                2       unused
                3       I/O error
                4       selected
                5       out of paper
                6       acknowledge
                7       not busy


Function 01h    Initialize Printer - set init line low, send 0Ch to printer DX
entry   AH      01h
        DX      printer port to be initialized (0,1,2)
return  status as below


Function  02h   Printer Status - read status of printer DX into AH
entry   AH      02h
        DX      printer port to be used (0,1,2)
return  AH      bit flags       bit 7   0 = printer is busy
                                bit 6   ACKnowledge line state
                                bit 5   out-of-paper line state
                                bit 4   printer selected line state
                                bit 3   I/O error
                                bit 2   unused
                                bit 1   unused
                                bit 0   time-out error




Interrupt 18h   ROM BASIC
(0:0060h)       Execute ROM BASIC at address 0F600h:0000h
note 1) Often reboots a compatible




Interrupt 19h   Bootstrap Loader
(0:0064h)       Reads track 0, sector 1 into address 0000h:7C00h, then transfers
                control to that address. If no diskette drive available,
                transfers to ROM-BASIC or displays loader error message.
                Causes reboot of disk system if invoked while running.
                (no memory test performed).




Interrupt 1Ah   Time of Day
(0:0068h)       access the PC internal clock

Function 00h    Read System Time Counter
entry   AH      00h
return  CX      high word of clock count
        DX      low word of clock count
        AL      00h if clock was read or written (via AH=0,1) within the current
                24-hour period. Otherwise, AL > 0


Function 01h    Set Clock - set # of 55ms clock ticks in system time counter
entry   AH      01h
        CX:DX   high word/low word count of timer ticks
return  none
note 1) The clock ticks are incremented by timer interrupt at 18.2065 times
        per second or 54.9254milliseconds/count. Therefore:
                counts per second = 18      (12h)
                counts per minute = 1092    (444h)
                counts per hour   = 65543   (10011h)
                counts per day    = 1573040 (1800B0h)
     2) counter is zeroed when system is rebooted

     2) IBM and Microsoft recommend using int 21 Fn 4Ch. Using int 20 is
        officially frowned upon since the introduction of DOS 2.0


Function 02h    Read Real Time Clock Time                       (AT and after)
entry   AH      02h
return  CH      hours in BCD
        CL      minutes in BCD
        DH      seconds in BCD
        DL      1 (set) if daylight savings time option
        CF      1 (set) if clock not operating


Function 03h    Set Real Time Clock Time                        (AT and after)
entry   AH      03h
        CH      hours in BCD
        CL      minutes in BCD
        DH      seconds in BCD
        DL      0 (clear) if standard time
                1 (set) if daylight savings time option
return  none


Function 04h    Read Real Time Clock Date                       (AT and after)
entry   AH      04h
return  CH      century in BCD (19 or 20)
        CL      year in BCD
        DH      month in BCD
        DL      day in BCD
        CF      1 (set) if clock not operating


Function 05h    Set Real Time Clock Date                        (AT and after)
entry   AH      05h
        CH      century in BCD (19 or 20)
        CL      year in BCD
        DH      month in BCD
        DL      day in BCD
return  none


Function 06h    Set Real Time Clock Alarm                       (AT and after)
entry   AH      06h
        CH      hours in BCD
        CL      minutes in BCD
        DH      seconds in BCD
return  CF      set if alarm already set or clock inoperable
note    Int 4Ah occurs at specified alarm time every 24hrs until reset


Function 07h    Reset Real Time Clock Alarm                     (AT and after)
entry   AH      07h
return  none


Function 08h    Set Real Time Clock Activated Power On Mode     (Convertible)
entry   AH      08h
        CH      hours in BCD
        CL      minutes in BCD
        DH      seconds in BCD


Function 09h    Read Real Time Clock Alarm Time and Status
                                                (Convertible and PS/2 Model 30)
entry   AH      09h
return  CH      hours in BCD
        CL      minutes in BCD
        DH      seconds in BCD
        DL      alarm status:
                00h     if alarm not enabled
                01h     if alarm enabled but will not power up system
                02h     if alarm will power up system


Function 0Ah    Read System-Timer Day Counter   (XT-2 [640k motherboard], PS/2)
entry   AH      0Ah
return  CF      set on error
        CX      count of days since Jan 1,1980

Function 0Bh    Set System-Timer Day Counter    (XT-2 [640k motherboard], PS/2)
entry   AH      0Bh
        CX      count of days since Jan 1,1980
return  CF      set on error


Function 80h    Set Up Sound Multiplexor                (PCjr) (Tandy 1000?)
entry   AH      80h
        AL      00h     source is 8253 channel 2
                01h     source is cassette input
                02h     source is I/O channel "audio in"
                03h     source is TI sound generator chip




Interrupt 1Bh   Control-Break
(0:006Ch)       This interrupt is called when the keyboard scanner of the IBM
                machines detects Ctrl and Break pressed at the same time.

note 1) If the break occurred while processing an interrupt, one or more
        end of interrupt commands must be send to the 8259 Programmable
        Interrupt Controller.
     2) All I/O devices should be reset in case an operation was underway at
        the time.
     3) It is normally pointed to an IRET during system initialization so that
        it does nothing, but some programs change it to return a ctrl-C scan
        code and thus invoke int 23h.




Interrupt 1Ch   Timer Tick
(0:0070h)
note 1) Taken 18.2065 times per second
     2) Normally vectors to dummy IRET unless PRINT.COM has been installed.
     3) If an application moves the interrupt pointer, it is the responsibility
        of that application to save and restore all registers that may be
        modified.




Interrupt 1Dh   Vector of Video Initialization Parameters.
(0:0074h)       This doubleword address points to 3 sets of 16-bytes containing
                data to initialize for video modes for video modes 0 & 1 (40
                column), 2 & 3 (80 column), and 4, 5 & 6 (graphics) on the
                Motorola 6845 CRT controller chip.
 6845 registers:
        R0      horizontal total (horizontal sync in characters)
        R1      horizontal displayed (characters per line)
        R2      horizontal sync position (move display left or right)
        R3      sync width (vertical and horizontal pulse: 4-bits each)
        R4      vertical total (total character lines)
        R5      vertical adjust (adjust for 50 or 60 Hz refresh)
        R6      vertical displayed (lines of chars displayed)
        R7      vertical sync position (lines shifted up or down)
        R8      interlace (bits 4 and 5) and skew (bits 6 and 7)
        R9      max scan line addr (scan lines per character row)
        R10     cursor start (starting scan line of cursor)
        R11     cursor stop (ending scan line of cursor)
        R12     video memory start address high byte (6-bits)
        R13     video memory start address low byte (8-bits)
        R14     cursor address high byte (6-bits)
        R15     cursor address low byte (8-bits)

 6845 Video Init Tables:
        table for modes 0 and 1   \
        table for modes 2 and 3    \ each table is 16 bytes long and
        table for modes 4,5, and 6 / contains values for 6845 registers
        table for mode 7          /
        4 words:   size of video RAM for modes 0/1, 2/3, 4/5, and 6/7
        8 bytes:   number of columns in each mode
        8 bytes:   video controller mode byte for each mode
note 1) There are 4 separate tables, and all 4 must be initialized if all
        video modes will be used.
     2) The power-on initialization code of the computer points this vector
        to the ROM BIOS video routines.
     3) IBM recommends that is this table needs to be modified, it should be
        copied into RAM and only the nescessary changes made.




Interrupt 1Eh   Vector of Diskette Controller Parameters
(0:0078h)       Dword address points to data base table that is used by BIOS.
                Default location is at 0F000:0EFC7h. 11-byte table format:
                bytes:
                00h     4-bit step rate, 4-bit head unload time
                01h     7-bit head load time, 1-bit DMA flag
                02h     54.9254 ms counts - delay till motor off (37-38 typ)
                03h     sector size:
                        00h     128 bytes
                        01h     256 bytes
                        02h     512 bytes
                        03h     1024 bytes
                04h     last sector on track (8 or 9 typical)
                05h     gap between sectors on read/write (42 typical)
                06h     data length for DMA transfers (0FFh typical)
                07h     gap length between sectors for format (80 typical)
                08h     sector fill byte for format (0F6h typical)
                09h     head settle time (in milliseconds) (15 to 25 typical)
                        DOS 1.0   0
                        DOS 2.10  15
                        DOS 3.1   1
                10h     motor start time (in 1/8 second intervals) (2 to 4 typ.)
                        DOS 2.10  2
note 1) This vector is pointed to the ROM BIOS diskette tables on system
        initialization
     2) IBM recommends that is this table needs to be modified, it should be
        copied into RAM and only the nescessary changes made.




Interrupt 1Fh   Pointer to Graphics Character Extensions (Graphics Set 2)
(0:007Ch)       This is the pointer to data used by the ROM video routines to
                display characters above ASCII 127 while in CGA medium and high
                res graphics modes.

note 1) Doubleword address points to 1K table composed of 28 8-byte character
        definition bit-patterns. First byte of each entry is top row, last byte
        is bottom row.
     2) The first 128 character patterns are located in system ROM.
     3) This vector is set to 000:0 at system initialization
     4) Used by DOS' external GRAFTABL command


Interrupt 20h   PROGRAM TERMINATE
(0:0080h)
 Issue int 20h to exit from a program. This vector transfers to the logic in
DOS to restore the terminate address, the Ctrl-Break address,and the critical
error exit address to the values they had on entry to the program. All the file
buffers are flushed and all handles are closed. You should close all files
changed in length (see function calls 10h and 3Eh) before issuing this
interrupt. If the changed file is not closed, its length, time, and date are
not recorded correctly in the directory.
 For a program to pass a completion code or an error code when terminating, it
must use either function call 4Ch (Terminate a Process) or 31h (Terminate
Process and Stay Resident). These two methods are preferred over using
int 20h and the codes returned by them can be interrogated in batch processing.
Important: Before you issue an interrupt 20h, your program must ensure that
           the CS register contains the segment of its program segment prefix.

Interrupt 20h   DOS - Terminate Program
entry   no parameters
return  none

Interrupt 20h   Minix - Send/Receive Message
entry   AX      process ID of other process
        BX      pointer to message
        CX      1       send
                2       receive
                3       send&receive
note    The message contains the system call number (numbered as in V7 Unix)
        and the call parameters


CHAPTER 4

 Programming Technical Reference - IBM
 Copyright 1988, Dave Williams


                    DOS INTERRUPTS AND FUNCTION CALLS
CONTENTS

DOS Registers ........................................................... 4-
Interrupts .............................................................. 4-
        20h Program Terminate ........................................... 4-
        21h Function Request ............................................ 4-
            Function Calls .............................................. 4-
            Listing of Function Calls ................................... 4-
                00h Program Terminate ................................... 4-
                01h Keyboard Input ...................................... 4-
                02h Display Output ...................................... 4-
                03h Auxiliary Input ..................................... 4-
                04h Auxiliary Output .................................... 4-
                05h Printer Output ...................................... 4-
                06h Direct Console I/O .................................. 4-
                07h Direct Console Input Without Echo ................... 4-
                08h Console Input Without Echo ...........................4-
                09h Print String .........................................4-
                0Ah Buffered Keyboard Input ..............................4-
                0Bh Check Standard Input Status ..........................4-
                0Ch Clear Keyboard Buffer and Invoke a Kbd Function ..... 4-
                0Dh Disk Reset .......................................... 4-
                0Eh Select Disk ......................................... 4-
                0Fh Open File ........................................... 4-
                10h Close File .......................................... 4-
                11h Search for First Entry .............................. 4-
                12h Search for Next Entry ............................... 4-
                13h Delete File ......................................... 4-
                14h Sequential Read ..................................... 4-
                15h Sequential Write .................................... 4-
                16h Create File ......................................... 4-
                17h Rename File ......................................... 4-
                18h ** Unknown .......................................... 4-
                19h Current Disk ........................................ 4-
                1Ah Set Disk Transfer Address ........................... 4-
                1Bh Allocation Table Information ........................ 4-
                1Ch Allocation Table Information for Specific Device .... 4-
                1Dh ** Unknown .......................................... 4-
                1Eh ** Unknown .......................................... 4-
                1Fh ** Read DOS Disk Block (default drive) .............. 4-
                20h ** Unknown .......................................... 4-
                21h Random Read ......................................... 4-
                22h Random Write ........................................ 4-
                23h File Size ........................................... 4-
                24h Set Relative Record Field ........................... 4-
                25h Set Interrupt Vector ................................ 4-
                26h Create New Program Segment .......................... 4-
                27h Random Block Read ................................... 4-
                28h Random Block Write .................................. 4-
                29h Parse Filename ...................................... 4-
                2Ah Get Date ............................................ 4-
                2Bh Get Date ............................................ 4-
                2Ch Get Time ............................................ 4-
                2Dh Set Time ............................................ 4-
                2Eh Set/Reset Verify Switch ............................. 4-
                2Fh Get Disk Transfer Address (DTA) ..................... 4-
                30h Get DOS Version Number .............................. 4-
                31h Terminate Process and Stay Resident ................. 4-
                32h ** Read DOS Disk Block .............................. 4-
                33h Ctrl-Break Check .................................... 4-
                34h ** Return INDOS Flag ................................ 4-
                35h Get Vector .......................................... 4-
                36h Get Disk Free Space ................................. 4-
                37h ** Get/Set Switch Character (SWITCHAR) .............. 4-
                38h Return Country Dependent Information ................ 4-
                39h Create Subdirectory (MKDIR) ......................... 4-
                3Ah Remove Subdirectory (RMDIR) ......................... 4-
                3Bh Change Durrent Directory (CHDIR) .................... 4-
                3Ch Create a File (CREAT) ............................... 4-
                3Dh Open a File ......................................... 4-
                3Eh Close a File Handle ................................. 4-
                3Fh Read From a File or Device .......................... 4-
                40h Write to a File or Device ........................... 4-
                41h Delete a File from a Specified Directory (UNLINK) ... 4-
                42h Move File Read/Write Pointer (LSEEK) ................ 4-
                43h Change File Mode (CHMOD) ............................ 4-
                44h I/O Control for Devices (IOCTL) ..................... 4-
                45h Duplicate a File Handle (DUP) ....................... 4-
                46h Force a Duplicate of a Handle (FORCDUP) ............. 4-
                47h Get Current Directory ............................... 4-
                48h Allocate Memory ..................................... 4-
                49h Free Allocated Memory ............................... 4-
                4Ah Modify Allocated Memory Blocks (SETBLOCK) ........... 4-
                4Bh Load or Execute a Program (EXEC) .................... 4-
                4Ch Terminate a Process (EXIT) .......................... 4-
                4Dh Get Return Code of a Subprocess (WAIT) .............. 4-
                4Eh Find First Matching File (FIND FIRST) ............... 4-
                4Fh Find Next Matching File (FIND NEXT) ................. 4-
                50h ** Set PSP .......................................... 4-
                51h ** Get PSP .......................................... 4-
                52h ** IN-VARS .......................................... 4-
                53h ** Translate BPB .................................... 4-
                54h Get Verify Setting .................................. 4-
                55h ** Create Child PSP ................................. 4-
                56h Rename a File ....................................... 4-
                57h Get or Set Timestamp of a File ...................... 4-
                58h ** Get/Set Allocation Strategy (DOS 3.x) ............ 4-
                59h Get Extended Error Code ............................. 4-
                5Ah Create Unique Filename .............................. 4-
                5Bh Create a New File ................................... 4-
                5Ch Lock/Unlock File Access ............................. 4-
                5Dh ** Network - Partial ................................ 4-
                5Eh ** Network Printer .................................. 4-
                5Fh ** Network Redirection .............................. 4-
                60h ** Parse Pathname ................................... 4-
                61h ** Unknown .......................................... 4-
                62h Get Program Segment Prefix (PSP) Address ............ 4-
                63h ** Get Lead Byte Table (DOS 2.25) ................... 4-
                64h ** Unknown .......................................... 4-
                65h ** Get Extended Country Information (DOS 3.3) ....... 4-
                66h ** Get/Set Global Code Page Table (DOS 3.3) ......... 4-
                67h ** Set Handle Count (DOS 3.3) ....................... 4-
                68h ** Commit File (DOS 3.3) ............................ 4-
            Calling the DOS Services .................................... 4-
        22h Terminate Address ........................................... 4-
        23h Ctrl-Break Exit Address ..................................... 4-
        24h Critical Error Handler Vector ............................... 4-
        25h Absolute Disk Read .......................................... 4-
        26h Absolute Disk Write ......................................... 4-
        27h Terminate and Stay Resident ................................. 4-
        28h ** DOS Idle Interrupt ....................................... 4-
        29h ** Quick Screen Output ...................................... 4-
        2Ah Microsoft Networks Session Layer Interrupt .................. 4-
        2Bh ** Unknown .................................................. 4-
        2Ch ** Unknown .................................................. 4-
        2Dh ** Unknown .................................................. 4-
        2Eh ** Alternate EXEC ........................................... 4-
        2Fh Multiplex Interrupt ......................................... 4-




DOS REGISTERS

 DOS uses the following registers, pointers, and flags when it executes
interrupts and function calls:

GENERAL REGISTERS    register                definition
                        AX      accumulator (16 bit)
                        AH      accumulator high-order byte (8 bit)
                        AL      accumulator low order byte (8 bit)
                        BX      base (16 bit)
                        BH      base high-order byte (8 bit)
                        BL      base low-order byte (8 bit)
                        CX      count (16 bit)
                        CH      count high order byte (8 bit)
                        CL      count low order byte (8 bit)
                        DX      data (16 bit)
                        DH      date high order byte (8 bit)
                        DL      data low order byte (8 bit)

FLAGS                   AF, CF, DF, IF, OF, PF, SF, TF, ZF

POINTERS             register        definition
                        SP      stack pointer (16 bit)
                        BP      base pointer (16 bit)
                        IP      instruction pointer (16 bit)

SEGMENT REGISTERS    register       definition
                        CS      code  segment (16 bit)
                        DS      data  segment (16 bit)
                        SS      stack segment (16 bit)
                        ES      extra segment (16 bit)

INDEX REGISTERS      register        definition
                        DI      destination index (16 bit)
                        SI      stack       index (16 bit)


INTERRUPTS

 Microsoft recommends that a program wishing to examine or set the contents of
any interrupt vector use the DOS function calls 35h and 25h provided for those
purposes and avoid referencing the interrupt vector locations directly.
 DOS reserves interrupt numbers 20h to 3Fh for its own use. This means absolute
memory locations 80h to 0FFh are reserved by DOS. The defined interrupts are as
follows with all values in hexadecimal.


Interrupt 21h   FUNCTION CALL REQUEST
(0:0084h)
 DOS provides a wide variety of function calls for character device I/O, file
management, memory management, date and time functions,execution of other
programs, and more. They are grouped as follows:

          call              description
        00h             program terminate
        01h-0Ch         character device I/O, CP/M compatibility format
        0Dh-24h         file management,      CP/M compatibility format
        25h-26h         nondevice functions,  CP/M compatibility format
        27h-29h         file management,      CP/M compatibility format
        2Ah-2Eh         nondevice functions,  CP/M compatibility format
        2Fh-38h         extended functions
        39h-3Bh         directory group
        3Ch-46h         extended file management
        47h             directory group
        48h-4Bh         extended memory management
        54h-57h         extended functions
        5Eh-5Fh         networking
        60h-62h         extended functions
        63h-66h         enhanced foreign language support


List of DOS services:   * = undocumented
        00h     terminate program
        01h     get keyboard input
        02h     display character to STDIO
        03h     get character from STDAUX
        04h     output character to STDAUX
        05h     output character to STDPRN
        06h     direct console I/O - keyboard to screen
        07h     get char from std I/O without echo
        08h     get char from std I/O without echo, checks for ^C
        09h     display a string to STDOUT
        0Ah     buffered keyboard input
        0Bh     check STDIN status
        0Ch     clear keyboard buffer and invoke keyboard function
        0Dh     flush all disk buffers
        0Eh     select disk
        0Fh     open file with File Control Block
        10h     close file opened with File Control Block
        11h     search for first matching file entry
        12h     search for next matching file entry
        13h     delete file specified by File Control Block
        14h     sequential read from file specified by File Control Block
        15h     sequential write to file specified by File Control Block
        16h     find or create firectory entry for file
        17h     rename file specified by file control block
        18h*    unknown
        19h     return current disk drive
        1Ah     set disk transfer area (DTA)
        1Bh     get current disk drive FAT
        1Ch     get disk FAT for any drive
        1Dh*    unknown
        1Eh*    unknown
        1Fh*    read DOS disk block, default drive
        20h*    unknown
        21h     random read from file specified by FCB
        22h     random write to file specified by FCB
        23h     return number of records in file specified by FCB
        24h     set relative file record size field for file specified by FCB
        25h     set interrupt vector
        26h     create new Program Segment Prefix (PSP)
        27h     random file block read from file specified by FCB
        28h     random file block write to file specified by FCB
        29h     parse the command line for file name
        2Ah     get the system date
        2Bh     set the system date
        2Ch     get the system time
        2Dh     set the system time
        2Eh     set/clear disk write VERIFY
        2Fh     get the Disk Transfer Address (DTA)
        30h     get DOS version number
        31h     TSR, files opened remain open
        32h*    read DOS Disk Block
        33h     get or set Ctrl-Break
        34h*    INDOS  Critical Section Flag
        35h     get segment and offset address for an interrupt
        36h     get free disk space
        37h*    get/set option marking character (SWITCHAR)
        38h     return country-dependent information
        39h     create subdirectory
        3Ah     remove subdirectory
        3Bh     change current directory
        3Ch     create and return file handle
        3Dh     open file and return file handle
        3Eh     close file referenced by file handle
        3Fh     read from file referenced by file handle
        40h     write to file referenced by file handle
        41h     delete file
        42h     move file pointer (move read-write pointer for file)
        43h     set/return file attributes
        44h     device IOCTL (I/O control) info
        45h     duplicate file handle
        46h     force a diuplicate file handle
        47h     get current directory
        48h     allocate memory
        49h     release allocated memory
        4Ah     modify allocated memory
        4Bh     load or execute a program
        4Ch     terminate prog and return to DOS
        4Dh     get return code of subprocess created by 4Bh
        4Eh     find first matching file
        4Fh     fine next matching file
        50h*    set new current Program Segment Prefix (PSP)
        51h*    puts current PSP into BX
        52h*    pointer to the DOS list of lists
        53h*    translates BPB (Bios Parameter Block, see below)
        54h     get disk verification status (VERIFY)
        55h*    create PSP: similar to function 26h
        56h     rename a file
        57h     get/set file date and time
        58h     get/set allocation strategy             (DOS 3.x)
        59h     get extended error information
        5Ah     create a unique filename
        5Bh     create a DOS file
        5Ch     lock/unlock file contents
        5Dh*    network
        5Eh*    network printer
        5Fh*    network redirection
        60h*    parse pathname
        61h*    unknown
        62h     get program segment prefix (PSP)
        63h*    get lead byte table                     (DOS 2.25)
        64h*    unknown
        65h*    get extended country information        (DOS 3.3)
        66h*    get/set global code page table          (DOS 3.3)
        67h*    set handle count                        (DOS 3.3)
        68h*    commit file                             (DOS 3.3)


 CALLING THE DOS SERVICES

 The DOS services are invoked by placing the number of the desired function in
register AH, subfunction in AL, setting the other registers to any specific
requirements of the function, and invoking int 21h.

 On return, the requested service will be performed if possible. Most codes
will return an error; some return more information. Details are contained in
the listings for the individual functions. Extended error return may be
obtained by calling function 59h (see 59h).

 Register settings listed are the ones used by DOS. Some functions will return
with garbage values in unused registers. Do not test for values in unspecified
registers; your program may exhibit odd behavior.

 DS:DX pointers are the data segment register (DS) indexed to the DH and DL
registers (DX). DX always contains the offset address, DS contains the segment
address.

 The File Control Block services (FCB services) were part of DOS 1.0. Since
the release of DOS 2.0, Microsoft has recommended that these services not be
used. A set of considerably more enhanced services (handle services) were
introduced with DOS 2.0. The handle services provide support for wildcards and
subdirectories, and enhanced error detection via function 59h.

 The data for the following calls was compiled from various Intel, Microsoft,
IBM, and other publications. There are many subtle differences between MSDOS
and PCDOS and between the individual versions. Differences between the
versions are noted as they occur.

 There are various ways of calling the DOS functions. For all methods, the
function number is loaded into register AH, subfunctions and/or parameters are
loaded into AL or other registers, and call int 21 by one of the following
methods:
 A) call interrupt 21h directly
 B) perform a long call to offset 50h in the program's PSP.
    1) This method will not work under DOS 1.x
 C) place the function number in CL and perform an intrasegment call to
    location 05h in the current code segment. This location contains a long
    call to the DOS function dispatcher.
    1) IBM recommends this method be used only when using existing programs
       written for different calling conventions. This method should be avoided
       unless you some specific use for it
    2) AX is always destroyed by this method
    3) This method is valid only for functions 00h-24h.

INT 21H   DOS services
          Function (hex)

* Indicates Functions not documented in the IBM DOS Technical Reference.
 Note some functions have been documented in other Microsoft or licensed OEM
documentation.


00h   Terminate Program
      Ends program, updates, FAT, flushes buffers, restores registers
entry   AH      00h
        CS      segment address of PSP
return  none
note 1) Program must place the segment address of the PSP control block in CS
        before calling this function.
     2) The terminate, ctrl-break,and critical error exit addresses (0Ah, 0Eh,
        12h) are restored to the values they had on entry to the terminating
        program, from the values saved in the program segment prefix at
        locations PSP:000Ah, PSP:000Eh, and PSP:0012h.
     3) All file buffers are flushed and the handles opened by the process are
        closed.
     4) Any files that have changed in length and are not closed are not
        recorded properly in the directory.
     5) Control transfers to the terminate address.
     6) This call performs exactly the same function as int 20h.
     7) All memory used by the program is returned to DOS.


01h     Get Keyboard Input
        Waits for char at STDIN (if nescessary), echoes to STDOUT
entry   AH      01h
return  AL      char from STDIN (8 bits)
note 1) Checks char for Ctrl-C, if char is Ctrl-C, executes int 23h.
     2) For function call 06h, extended ASCII codes require two function calls.
        The first call returns 00h as an indicator that the next call will be an
        extended ASCII code.
     3) Input and output are redirectable. If redirected, there is no way to
        detect EOF.


02h   Display Output
      Outputs char in DL to STDOUT
entry   AH      02h
        DL      8 bit data (usually ASCII character)
return  none
note 1) If char is 08 (backspace) the cursor is moved 1 char to the left
        (nondestructive backspace).
     2) If Ctrl-C is detected after input, int 23h is executed.
     3) Input and output are redirectable. If redirected, there is no way to
        detect disk full.


03h   Auxiliary Input
      Get (or wait until) character from STDAUX
entry   AH      03h
return  AL      char from auxiliary device
note 1) AUX, COM1, COM2 is unbuffered and not interrupt driven
     2) This function call does not return status or error codes. For greater
        control it is recommended that you use ROM BIOS routine (int 14h) or
        write an AUX device driver and use IOCTL.
     3) At startup, PC-DOS initializes the first auxiliary port (COM1) to 2400
        baud, no parity, one stop bit, and an 8-bit word. MSDOS may differ.
     4) If Ctrl-C is has been entered from STDIN, int 23h is executed.


04h   Auxiliary Output
      Write character to STDAUX
entry   AH      04h
        DL      char to send to AUX
return  none
note 1) This function call does not return status or error codes. For greater
        control it is recommended that you use ROM BIOS routine (int 14h) or
        write an AUX device driver and use IOCTL.
     2) If Ctrl-C is has been entered from STDIN, int 23h is executed.
     3) Default is COM1 unless redirected by DOS.
     4) If the device is busy, this function will wait until it is ready.


05h   Printer Output
      Write character to STDPRN
entry   AL      05h
        DL      character to send
return  none
note 1) If Ctrl-C is has been entered from STDIN, int 23h is executed.
     2) Default is PRN or LPT1 unless redirected with the MODE command.
     3) If the printer is busy, this function will wait until it is ready.


06h   Direct Console I/O
      Get character from STDIN; echo character to STDOUT
entry   AH      06h
        DL      0FFh for console input, or 00h-0FEh for console output
return  ZF      zero flag set   (1) = no character
                zero flag clear (0) = character recieved
        AL      character
note 1) Extended ASCII codes require two function calls. The first call returns
        00h to indicate the next call will return an extended code.
     2) If DL is not 0FFh, DL is assumed to have a valid character that is
        output to STDOUT.
     3) This function does not check for Ctrl-C or Ctrl-PrtSc.
     4) Does not echo input to screen
     5) If I/O is redirected, EOF or disk full cannot be detected.


07h   Direct Console Input Without Echo         (does not check BREAK)
      Get or wait for char at STDIN, returns char in AL
entry   AH      07h
return  AL      character from standard input device
note 1) Extended ASCII codes require two function calls. The first call returns
        00h to indicate the next call will return an extended code.
     2) No checking for Ctrl-C or Ctrl-PrtSc is done.
     3) Input is redirectable.


08h   Console Input Without Echo                (checks BREAK)
      Get or Wait for char at STDIN, return char in AL
entry   AH      08h
return  AL      char from standard input device
note 1) Char is checked for ctrl-C. If ctrl-C is detected, executes int 23h.
     2) For function call 08h, extended ASCII characters require two function
        calls. The first call returns 00h to signify an extended ASCII code.
        The next call returns the actual code.
     3) Input is redirectable. If redirected, there is no way to check EOF.


09h   Print String
      Outputs Characters in the Print String to the STDOUT
entry   AH      09h
        DS:DX   pointer to the Character String to be displayed
return  none
note 1) The character string in memory must be terminated by a $ (24h)
        The $ is not displayed.
     2) Output to STDOUT is the same as function call 02h.


0Ah   Buffered Keyboard Input
      Reads characters from STDIN and places them in the buffer beginning
      at the third byte.
entry   AH      0Ah
        DS:DX   pointer to an input buffer
return  none
note 1) Min buffer size = 1, max = 255
     2) Char is checked for ctrl-C. If ctrl-C is detected, executes int 23h.
     3) Format of buffer DX:
        byte       contents
         1      Maximum number of chars the buffer will take, including CR.
                Reading STDIN and filling the buffer continues until a carriage
                return (<Enter> or 0Dh) is read. If the buffer fills to one less
                than the maximum number the buffer can hold, each additional
                number read is ignored and ASCII 7 (BEL) is output to the
                display until a carriage return is read. (you must set this
                value)
         2      Actual number of characters received, excluding the carriage
                return, which is always the last character. (the function sets
                this value)
         3-n    Characters received are placed into the buffer starting here.
                Buffer must be at least as long as the number in byte 1.
     4) Input is redirectable. If redirected, there is no way to check EOF.
     5) The string may be edited with the standard DOS editing commands as it
        is being entered.
     6) Extended ASCII characters are stored as 2 bytes, the first byte being
        zero.


0Bh   Check Standard Input (STDIN) status
      Checks for character availible at STDIN
entry   AH      0Bh
return  AL      0FFh    if a character is availible from STDIN
                00h     if no character is availible from STDIN
note 1) Checks for Ctrl-C. If Ctrl-C is detected, int 23h is executed
     2) Input can be redirected.
     3) Checks for character only, it is not read into the application


0Ch   Clear Keyboard Buffer & Invoke a Keyboard Function       (FCB)
      Dumps buffer, executes function in AL (01h,06h,07h,08h,0Ah only)
entry   AH      0Ch
        AL      function number (must be 01h, 06h, 07h, 08h, or 0Ah)
return  AL      00h     buffer was flushed, no other processing performed
                other   any other value has no meaning
note 1) Forces system to wait until a character is typed.
     2) Flushes all typeahead input, then executes function specified by AL (by
        moving it to AH and repeating the int 21 call).
     3) If AL contains a value not in the list above, the keyboard buffer is
        flushed and no other action is taken.


0Dh   Disk Reset
      Flushes all currently open file buffers to disk
entry   AH      0Dh
return          none
note 1) Does not close files. Does not update directory entries; files changed
        in size but not closed are not properly recorded in the directory
     2) Sets DTA address to DS:0080h
     3) Should be used before a disk change, Ctrl-C handlers, and to flush
        the buffers to disk.


0Eh   Select Disk
      Sets the drive specified in DL (if valid) as the default drive
entry   AL      0Eh
        DL      new default drive number (0=A:,1=B:,2=C:,etc.)
return  AL      total number of logical drives (not nescessarily physical)
note 1) For DOS 1.x and 2.x, the minimum value for AL is 2.
     2) For DOS 3.x, the minimum value for AL is 5.
     3) The drive number returned is not nescessarily a valid drive.
     4) For DOS 1.x: 16 logical drives are availible. A-P.
        For DOS 2.x: 63 logical drives are availible. (Letters are only used for
                     the first 26 drives. If more than 26 logical drives are
                     used, further drive letters will be other ASCII characters
                     ie {,], etc.
        For DOS 3.x: 26 logical drives are availible. A-Z.


0Fh   Open Disk File                                                    (FCB)
      Searches current directory for specified filename and opens it
entry   AH      0Fh
        DS:DX   pointer to an unopened FCB
return  AL      00h     if file found
                0FFh    if file not not found
note 1) If the drive code was 0 (default drive) it is changed to the actual
        drive used (1=A:,2=B:,3=C:, etc). This allows changing the default drive
        without interfering with subsequent operations on this file.
     2) The current block field (FCB bytes C-D, offset 0Ch) is set to zero.
     3) The size of the record to be worked with (FCB bytes E-F, offset 0Eh) is
        set to the system default of 80h. The size of the file (offset 10h) and
        the date (offset 14h) are set from information obtained in the root
        directory. You can change the default value for the record size (FCB
        bytes E-F) or set the random record size and/or current record field.
        Perform these actions after the open but before any disk operations.
     4) The file is opened in compatibility mode.
     5) Microsoft recommends handle function call 3Dh be used instead.
     6) This call is also used by the APPEND command in DOS 3.2+
     7) Before performing a sequential disk operation on the file, you must
        set the Current Record field (offset 20h). Before performing a random
        disk operation on the file, you must set the Relative Record field
        (offset 21h). If the default record size of 128 bytes is incorrect, set
        it to the correct value.


10h  Close File                                                         (FCB)
     Closes a File After a File Write
entry   AH      10h
        DS:DX   pointer to an opened FCB
return  AL      00h     if the file is found and closed
                0FFh    if the file is not found in the current directory
note 1) This function call must be done on open files that are no longer needed,
        and after file writes to insure all directory information is updated.
     2) If the file is not found in its correct position in the current
        directory, it is assumed that the diskette was changed and AL returns
        0FFh. This error return is reportedly not completely reliable with DOS
        version 2.x.
     3) If found, the directory is updated to reflect the status in the FCB, the
        buffers to that file are flushed, and AL returns 00h.


11h   Search For First Matching Entry                                   (FCB)
      Searches current disk & directory for first matching filename
entry   AH      11h
        DS:DX   pointer to address of FCB
return  AL      00h     successful match
                0FFh    no matching filename found
note 1) The FCB may contain the wildcard character ? under Dos 2.x, and ? or *
        under 3.x.
     2) The original FCB at DS:DX contains information to continue the search
        with function 12h, and should not be modified.
     3) If a matching filename is found, AL returns 00h and the locations at the
        Disk Transfer Address are set as follows:
        a) If the FCB provided for searching was an extended FCB, then the first
           byte at the disk transfer address is set to 0FFh followed by 5 bytes
           of zeroes, then the attribute byte from the search FCB, then the
           drive number used (1=A, 2=B, etc) then the 32 bytes of the directory
           entry. Thus, the disk transfer address contains a valid unopened FCB
           with the same search attributes as the search FCB.
        b) If the FCB provided for searching was a standard FCB, then the first
           byte is set to the drive number used (1=A,2=b,etc), and the next 32
           bytes contain the matching directory entry. Thus, the disk transfer
           address contains a valid unopened normal FCB.
     4) If an extended FCB is used, the following search pattern is used:
        a) If the FCB attribute byte is zero, only normal file entries are
           found. Entries for volume label, subdirectories, hidden or system
           files, are not returned.
        b) If the attribute byte is set for hidden or system files, or
           subdirectory entries, it is to be considered as an inclusive search.
           All normal file entries plus all entries matching the specified
           attributes are returned. To look at all directory entries except the
           volume label, the attribute byte may be set to hidden + system +
           directory (all 3 bits on).
        c) If the attribute field is set for the volume label, it is considered
           an exclusive search, and ONLY the volume label entry is returned.
     5) This call is also used by the APPEND command in DOS 3.2+


12h   Search For Next Entry Using FCB                                   (FCB)
      Search for next matching filename
entry   AH      12h
        DS:DX   pointer to the unopened FCB specified from the previous Search
                First (11h) or Search Next (12h)
return  AL      00h     if matching filename found
                0FFh    if matching filename was not found
note 1) After a matching filename has been found using function call 11h,
        function 12h may be called to find the next match to an ambiguous
        request. For DOS 2.x, ?'s are allowed in the filename. For DOS 3.x,
        global (*) filename characters are allowed.
     2) The DTA contains info from the previous Search First or Search Next.
     3) All of the FCB except for the name/extension field is used to keep
        information nescessary for continuing the search, so no disk operations
        may be performed with this FCB between a previous function 11h or 12h
        call and this one.
     4) If the file is found, an FCB is created at the DTA address and set up to
        open or delete it.


13h   Delete File Via FCB                                               (FCB)
      Deletes file specified in FCB from current directory
entry   AH      13h
        DS:DX   pointer to address of FCB
return  AL      00h     file deleted
                0FFh    if file not found or was read-only
note 1) All matching current directory entries are deleted. The global filename
        character "?" is allowed in the filename.
     2) Will not delete files with read-only attribute set
     3) Close open files before deleting them.
     4) Requires Network Access Rights


14h   Sequential Disk File Read                                         (FCB)
      Reads record sequentially from disk via FCB
entry   AH  14h
        DS:DX   pointer to an opened FCB
return  AL      00h     successful read
                01h     end of file (no data read)
                02h     Data Transfer Area too small for record size specified
                        or segment overflow
                03h     partial record read, EOF found
note 1) The record size is set to the value at offset 0Eh in the FCB.
     2) The record pointed to by the Current Block (offset 0Ch) and the Current
        Record (offset 20h) fields is loaded at the DTA, then the Current Block
        and Current Record fields are incremented.
     3) The record is read into memory at the current DTA address as specified
        by the most recent call to function 1Ah. If the size of the record and
        location of the DTA are such that a segment overflow or wraparound would
        occur, the error return is set to AL=02h
     4) If a partial record is read at the end of the file, it is passed to the
        requested size with zeroes and the error return is set to AL=03h.


15h   Sequential Disk Write                                             (FCB)
      Writes record specified by FCB sequentially to disk
entry   AH      15h
        DS:DX   pointer to address of FCB
return  AL      00h     successful write
                01h     diskette full, write canceled
                02h     disk transfer area (DTA) too small or segment wrap
note 1) The data to write is obtained from the disk transfer area
     2) The record size is set to the value at offset 0Eh in the FCB.
     3) This service cannot write to files set as read-only
     4) The record pointed to by the Current Block (offset 0Ch) and the Current
        Record (offset 20h) fields is loaded at the DTA, then the Current Block
        and Current Record fields are incremented.
     5) If the record size is less than a sector, the data in the DTA is written
        to a buffer; the buffer is written to disk when it contains a full
        sector of data, the file is closed, or a Reset Disk (function 0Dh) is
        issued.
     6) The record is written to disk at the current DTA address as specified
        by the most recent call to function 1Ah. If the size of the record and
        location of the DTA are such that a segment overflow or wraparound would
        occur, the error return is set to AL=02h


16h   Create A Disk File                                                (FCB)
      Search and open or create directory entry for file
entry   AH      16h
        DS:DX   pointer to an FCB
return  AL      00h     successful creation
                0FFh    no room in directory
note 1) If a matching directory entry is found, the file is truncated to zero
        bytes.
     2) If there is no matching filename, a filename is created.
     3) This function calls function 0Fh (Open File) after creating or
        truncating a file.
     4) A hidden file can be created by using an extended FCB with the attribute
        byte (offset FCB-1) set to 2.


17h   Rename File Specified by File Control Block (FCB)                 (FCB)
      Renames file in current directory
entry   AH      17h
        DS:DX   pointer to an FCB (see note 4)
return  AL      00h     successfully renamed
                0FFh    file not found or filename already exists
note 1) This service cannot rename read-only files
     2) The "?" wildcard may be used.
     3) If the "?" wildcard is used in the second filename, the corresponding
        letters in the filename of the directory entry are not changed.
     4) The FCB must have a drive number, filename, and extension in the usual
        position, and a second filename starting 6 bytes after the first, at
        offset 11h.
     5) The two filenames cannot have the same name.
     6) FCB contains new name starting at byte 17h.


18h  Internal to DOS
 *   Unknown
entry   AH      18h
return  AL      0


19h   Get Current Disk Drive
      Return designation of current default disk drive
entry   AH      19h
return  AL      current default drive (0=A, 1=B,etc.)
note    Some other DOS functions use 0 for default, 1=A, 2=B, etc.


1Ah   Set Disk Transfer Area Address (DTA)
      Sets DTA address to the address specified in DS:DX
entry   AH      1Ah
        DS:DX   pointer to buffer
return  none
note 1) The default DTA is 128 bytes at offset 80h in the PSP. DOS uses the
        DTA for all file I/O.
     2) Registers are unchanged.
     3) No error codes are returned.
     2) Disk transfers cannot wrap around from the end of the segment to the
        beginning or overflow into another segment.


1Bh   Get Current Drive File Allocation Table Information
      Returns information from the FAT on the current drive
entry   AH      1Bh
exit    AL      number of sectors per allocation unit (cluster)
        DS:BX   address of the current drive's media descriptor byte
        CX      number of bytes per sector
        DX      number of allocation units (clusters) for default drive
note 1) Save DS before calling this function.
     2) This call returned a pointer to the FAT in DOS 1.x. Beginning with
        DOS 2.00, it returns a pointer only to the table's ID byte.
     3) IBM recommends programmers avoid this call and use int 25h instead.


1Ch   Get File Allocation Table Information for Specific Device
      Returns information on specified drive
entry   AH      1Ch
        DL      drive number (1=A, 2=B, 3=C, etc)
return  AL      number of sectors per allocation unit (cluster)
        DS:BX   address of media descriptor byte for drive in DL
        CX      sector size in bytes
        DX      number of allocation units (clusters)
note 1) DL = 0 for default.
     2) Save DS before calling this function.
     3) Format of media-descriptor byte:
        bits:   0       0   (clear)   not double sided
                        1   (set)     double sided
                1       0   (clear)   not 8 sector
                        1   (set)     8 sector
                2       0   (clear)   nonremovable device
                        1   (set)     removable device
                3-7     always set (1)
     4) This call returned a pointer to the FAT in DOS 1.x. Beginning with
        DOS 2.00, it returns a pointer only to the table's ID byte.
     5) IBM recommends programmers avoid this call and use int 25h instead.


1Dh   Not Documented by Microsoft
 *    Unknown
entry   AH      1Dh
return  AL      0


1Eh   Not Documented by Microsoft
 *    Unknown
entry   AH      1Eh
return  AL      0
note    Apparently does nothing


1Fh Get Default Drive Parameter Block
 *  Same as function call 32h (below), except that the table is accessed from
    the default drive
entry   AH      1Fh
        other registers unknown
return  AL      00h     no error
                0FFh    error
        DS:BX   points to DOS Disk Parameter Block for default drive.
note 1) Unknown vector returned in ES:BX.
     2) For DOS 2.x and 3.x, this just invokes function 32h (undocumented,
        Read DOS Disk Block) with DL=0


20h  Unknown
 *   Internal - does nothing?
entry   AH      20h
return  AL      0


21h  Random Read from File Specified by File Control Block              (FCB)
     Reads one record as specified in the FCB into the current DTA.
entry   AH      21h
        DS:DX   address of the opened FCB
return  AL      00h     successful read operation
                01h     end of file (EOF), no data read
                02h     DTA too small for the record size specified
                03h     end of file (EOF), partial data read
note 1) The current block and current record fields are set to agree with the
        random record field. Then the record addressed by these fields is read
        into memory at the current Disk Transfer Address.
     2) The current file pointers are NOT incremented this function.
     3) If the DTA is larger than the file, the file is padded to the requested
        length with zeroes.


22h  Random Write to File Specified by FCB                              (FCB)
     Writes one record as specified in the FCB to the current DTA
entry   AH      22h
        DS:DX   address of the opened FCB
return  AL      00h     successful write operation
                01h     disk full; no data written (write was canceled)
                02h     DTA too small for the record size specified (write was
                        canceled)
note 1) This service cannot write to read-only files.
     2) The record pointed to by the Current Block (offset 0Ch) and the Current
        Record (offset 20h) fields is loaded at the DTA, then the Current Block
        and Current Record fields are incremented.
     3) If the record size is less than a sector, the data in the DTA is written
        to a buffer; the buffer is written to disk when it contains a full
        sector of data, the file is closed, or a Reset Disk (function 0Dh) is
        issued.
     4) The current file pointers are NOT incremented this function.
     5) The record is written to disk at the current DTA address as specified
        by the most recent call to function 1Ah. If the size of the record and
        location of the DTA are such that a segment overflow or wraparound would
        occur, the error return is set to AL=02h


23h  Get File Size                                                      (FCB)
     Searches current subdirectory for matching file, returns size in FCB
entry   AH      23h
        DS:DX   address of an unopened FCB
return  AL      00h file found
                0FFh file not found
note 1) Record size field (offset 0Eh) must be set before invoking this function
     2) The disk directory is searched for the matching entry. If a matching
        entry is found, the random record field is set to the number of records
        in the file. If the value of the Record Size field is not an even
        divisor of the file size, the value set in the relative record field is
        rounded up. This gives a returned value larger than the actual file size
     3) This call is used by the APPEND command in DOS 3.2+


24h  Set Relative Record Field                                          (FCB)
     Set random record field specified by an FCB
entry   AH      24h
        DS:DX   address of an opened FCB
return  Random Record Field of FCB is set to be same as Current Block
        and Current Record.
note 1) You must invoke this function before performing random file access.
     2) The relative record field of FCB (offset 21h) is set to be same as the
        Current Block (offset 0Ch) and Current Record (offset 20h).
     3) No error codes are returned.
     4) The FCB must already be opened.


25h  Set Interrupt Vector
     Sets the address of the code DOS is to perform each time the specified
     interrupt is invoked.
entry   AH      25h
        AL      int number to reassign the handler to
        DS:DX   address of new interrupt vector
return  none
note 1) Registers are unchanged.
     2) No error codes are returned.
     3) The interrupt vector table for the interrupt number specified in AL
        is set to the address contained in DS:DX. Use function 35h (Get Vector)
        to get the contents of the interrupt vector and save it for later use.
     4) When you use function 25 to set an interrupt vector, DOS 3.2 doesn't
        point the actual interrupt vector to what you requested. Instead, it
        sets the interrupt vector to point to a routine inside DOS, which does
        this:
                1. Save old stack pointer
                2. Switch to new stack pointer allocated from DOS's stack pool
                3. Call your routine
                4. Restore old stack pointer
        The purpose for this was to avoid possible stack overflows when there
        are a large number of active interrupts. IBM was concerned (this was an
        IBM change, not Microsoft) that on a Token Ring network there would be
        a lot of interrupts going on, and applications that hadn't allocated
        very much stack space would get clobbered.


26h  Create New Program Segment Prefix (PSP)
     This service copies the current program-segment prefix to a new memory
     location for the creation of a new program or overlay. Once the new PSP is
     in place, a DOS program can read a DOS COM or overlay file into the memory
     location immediately following the new PSP and pass control to it.
entry   AH      26h
        DX      segment number for the new PSP
return  none
note 1) Microsoft recommends you use the newer DOS service 4Bh (EXEC) instead.
     2) The entire 100h area at location 0 in the current PSP is copied into
        location 0 of the new PSP. The memory size information at location 6
        in the new segment is updated and the current termination, ctrl-break,
        and critical error addresses from interrupt vector table entries for
        ints 22h, 23h, and 24 are saved in the new program segment starting at
        0Ah. They are restored from this area when the program terminates.
     3) Current PSP is copied to specified segment


27h  Random Block Read From File Specified by FCB                       (FCB)
     Similar to 21h (Random Read) except allows multiple files to be read.
entry   AH      27h
        CX      number of records to be read
        DS:DX   address of an opened FCB
return  AL      00h     successful read
                01h     end of file, no data read
                02h     DTA too small for record size specified (read canceled)
                03h     end of file
        CX      actual number of records read (includes partial if AL=03h)
note 1) The record size is specified in the FCB. The service updates the Current
        Block (offset 0Ch) and Current Record (offset 20h) fields to the next
        record not read.
     2) If CX contained 0 on entry, this is a NOP.
     3) If the DTA is larger than the file, the file is padded to the requested
        length with zeroes.
     4) This function assumes that the FCB record size field (0Eh) is correctly
        set. If not set by the user, the default is 128 bytes.
     5) The record is written to disk at the current DTA address as specified
        by the most recent call to function 1Ah. If the size of the record and
        location of the DTA are such that a segment overflow or wraparound would
        occur, the error return is set to AL=02h


28h  Random Block Write to File Specified in FCB                        (FCB)
     Similar to 27h (Random Write) except allows multiple files to be read.
entry   AH      28h
        CX      number of records to write
        DS:DX   address of an opened FCB
return  AL      00h     successful write
                01h     disk full, no data written
                02h     DTA too small for record size specified (write canceled)
        CX      number of records written
note 1) The record size is specified in the FCB.
     2) This service allocates disk clusters as required.
     3) This function assumes that the FCB Record Size field (offset 0Eh) is
        correctly set. If not set by the user, the default is 128 bytes.
     4) The record size is specified in the FCB. The service updates the Current
        Block (offset 0Ch) and Current Record (offset 20h) fields to the next
        record not read.
     5) The record is written to disk at the current DTA address as specified
        by the most recent call to function 1Ah. If the size of the record and
        location of the DTA are such that a segment overflow or wraparound would
        occur, the error return is set to AL=02h
     6) If called with CX=0, no records are written, but the FCB's File Size
        entry (offset 1Ch) is set to the size specified by the FCB's Relative
        Record field (offset 21h).


29h  Parse the Command Line for Filename                                (FCB)
     Parses a text string into the fields of a File Control Block
entry   AH      29h
        DS:SI   pointer to string to parse
        ES:DI   pointer to memory buffer to fill with unopened FCB
        AL      bit mask to control parsing
                bit 0 = 0: parsing stops if file seperator found
                        1: causes service to scan past leading chars such as
                           blanks. Otherwise assumes the filename begins in
                           the first byte
                    1 = 0: drive number in FCB set to default (0) if string
                           contains no drive number
                        1: drive number in FCB not changed
                    2 = 0: filename in FCB set to 8 blanks if no filename in
                           string
                        1: filename in FCB not changed if string does not
                           contain a filename
                    3 = 0: extension in FCB set to 3 blanks if no extension in
                           string
                        1: extension left unchanged
                    4-7    must be zero
return  AL      00h     no wildcards in name or extension
                01h     wildcards appeared in name or extension
                0FFh    invalid drive specifier
        DS:SI   pointer to the first character after the parsed string
        ES:DI   pointer to the unopened FCB
note 1) If the * wildcard characters are found in the command line, this service
        will replace all subsequent chars in the FCB with question marks.
     2) This service uses the characters as filename separators
        DOS 1       : ; . , + / [ ] = " TAB SPACE
        DOS 2,3     : ; . , + = TAB SPACE
     3) This service uses the characters
        : ; . , + < > | / \ [ ] = " TAB SPACE
        or any control characters as valid filename separators
     4) A filename cannot contain a filename terminator. If one is encountered,
        all processing stops. The handle functions will allow use of some of
        these characters.
     5) If no valid filename was found on the command line, ES:DI +1 points
        to a blank (ASCII 32).
     6) This function cannot be used with filespecs which include a path
     7) Parsing is in the form D:FILENAME.EXT. If one is found, a corresponding
        unopened FCB is built at ES:DI


2Ah  Get Date
     Returns day of the week, year, month, and date
entry   AH      2Ah
return  CX      year    (1980-2099)
        DH      month   (1-12)
        DL      day     (1-31)
        AL      weekday 00h     Sunday
                        01h     Monday
                        02h     Tuesday
                        03h     Wednesday
                        04h     Thursday
                        05h     Friday
                        06h     Saturday
note 1) Date is adjusted automatically if clock rolls over to the next day,
        and takes leap years and number of days in each month into account.
     2) Although DOS cannot set an invalid date, it can read one, such as
        1/32/80, etc.
     3) DesQview also accepts CX = 4445h and DX = 5351h, i.e. 'DESQ' as valid
     4) DOS will accept CH=0 (midnight) as a valid time, but if a file's time
        is set to exactly midnight the time will not be displayed by the DIR
        command.


2Bh  Set Date
     set current system date
entry   AH      2Bh
        CX      year    (1980-2099)
        DH      month   (1-12)
        DL      day     (1-31)
return  AL      00h     no error (valid date)
                0FFh    invalid date specified
note 1) On entry, CX:DX must have a valid date in the same format as returned
        by function call 2Ah
     2) DOS 3.3 also sets CMOS clock


2Ch  Get Time
     Get current system time from CLOCK$ driver
entry   AH      2Ch
return  CH      hours   (0-23)
        CL      minutes (0-59)
        DH      seconds (0-59)
        DL      hundredths of a second (0-99)
note 1) Time is updated every 5/100 second.
     2) The date and time are in binary format


2Dh  Set Time
     Sets current system time
entry   AH      2Dh
        CH      hours   (0-23)
        CL      minutes (0-59)
        DH      seconds (0-59)
        DL      hundredths of seconds (0-99)
return  AL      00h     if no error
                0FFh    if bad value sent to routine
note 1) DOS 3.3 also sets CMOS clock
     2) CX and DX must contain a valid time in binary


2Eh  Set/Reset Verify Switch
     Set verify flag
entry   AH      2Eh
        AL      00      to turn verify off (default)
                01      to turn verify on
return  none
note 1) This is the call invoked by the DOS VERIFY command
     2) Setting of the verify switch can be obtained by calling call 54h
     3) This call is not supported on network drives
     4) DOS checks this flag each time it accesses a disk


2Fh  Get Disk Transfer Address (DTA)
     Returns current disk transfer address used by all DOS read/write operations
entry   AH      2Fh
return  ES:BX   address of DTA
note 1) The DTA is set by function call 1Ah
     2) Default DTA address is a 128 byte buffer at offset 80h in that program's
        Program Segment Prefix


30h  Get DOS Version Number
     Return DOS version and/or user number
entry   AH      30h
return  AH      minor version number  (i.e., DOS 2.10 returns AX = 0A02h)
        AL      major version number
        BH      OEM ID number
                00h     IBM
                16h     DEC
        BL:CX   24-bit user serial number
note 1) If AL returns a major version number of zero, the DOS version is
        below 1.28 for MSDOS and below 2.00 for PCDOS.
     2) IBM PC-DOS always returns 0000h in BX and CX.


31h  Terminate Process and Stay Resident
     KEEP, or TSR
entry   AH      31h
        AL      exit code
        DX      program memory requirement in 16 byte paragraphs
return  AX      return code (retrieveable by function 4Dh)
note 1) Files opened by the application are not closed when this call is made
     2) Memory can be used more efficiently if the block containing the copy of
        the DOS environment is deallocated before terminating. This can be done
        by loading ES with the segment contained in 2Ch of the PSP and issuing
        function call 49h (Free Allocated Memory).
     3) Unlike int 27h, more than 64k may be made resident with this call


32h  Read DOS Disk Block
 *   Retrieve the pointer to the drive parameter block for a drive
entry   AH      32h
        DL      drive (0=default, 1=A:, etc.).
return  AL      00h     if drive is valid
                0FFh    if drive is not valid
        DS:BX   points to DOS Drive Parameter Table.  Format of block:
                Bytes   Type        Value
                00h     byte    Drive: 0=A:, 1=B:, etc.
                01h     byte    Unit within drive (0, 1, 2, etc.)
                02h-03h word    Bytes per sector
                04h     byte    Sectors per cluster - 1
                05h     byte    Cluster to sector shift (i.e., how far to shift-
                                left the bytes/sector to get bytes/cluster)
                06h-07h word    Number of reserved (boot) sectors
                08h     byte    Number of FATs
                09h-0Ah word    Number of root directory entries
                0Bh-0Ch word    Sector # of 1st data. Should be same as # of
                                sectors/track.
                0Dh-0Eh word    # of clusters + 1 (=last cluster #)
                0Fh     byte    Sectors for FAT
                10h-11h word    First sector of root directory
                12h-15h dword   Address of device driver header for this drive
                16h     byte    Media Descriptor Byte for this drive
                17h     byte    Zero if disk has been accessed
                18h-1Bh dword   address of next DOS Disk Block (0FFFFh means
                                last in chain)
                22h     byte    Current Working Directory (2.0 only) (64 bytes)
note 1) Use [BX+0D] to find no. of clusters (>1000H, 16-bit FAT; if not, 12-bit
        (exact dividing line is probably a little below 1000h to allow for
        bad sectors, EOF markers, etc.)
     2) Short article by C.Petzold, PC Magazine  Vol.5,no.8, and the article
        "Finding Disk Parameters" in the May 1986 issue of PC Tech Journal.
     3) This call is mostly supported in OS/2 1.0's DOS Compatibility Box. The
        dword at 12h will not return the address of the next device driver when
        in the Compatibility Box.


33h  Control-Break Check
     Get or set control-break checking at CON
entry   AH      33h
        AL      00h     to test for break checking
                01h     to set break checking
                        DL      00h     to disable break checking
                                01h     to enable break checking
                02h     internal, called by PRINT.COM (DOS 3.1)
return  DL      00h     if break=off
                01h     if break=on
        AL      0FFh    error


34h  Return INDOS Flag
 *   Returns ES:BX pointing to Critical Section Flag, byte indicating whether
     it is safe to interrupt DOS.
entry   AH      34h
return  ES:BX   points to DOS "critical section flag"
note 1) If byte is 0, it is safe to interrupt DOS. This was mentioned in some
        documentation by Microsoft on a TSR standard, and PC Magazine reports
        it functions reliably under DOS versions 2.0 through 3.3. Chris
        Dunford (of CED fame) and a number of anonymous messages on the BBSs
        indicate it may not be totally reliable.
     2) The byte at ES:BX+1 is used by the Print program for this same purpose,
        so it's probably safer to check the WORD at ES:BX.
     3) Reportedly, examination of DOS 2.10 code in this area indicates that the
        byte immediately following this "critical section flag" must be 00h to
        permit the PRINT.COM interrupt to be called. For DOS 3.0 and 3.1 (except
        Compaq DOS 3.0), the byte before the "critical section flag" must be
        zero; for Compaq DOS 3.0, the byte 01AAh before it must be zero.
     4) In DOS 3.10 this reportedly changed to word value, with preceding byte.
     5) This call is supported in OS/2 1.0's DOS Compatibility Box
     6) Gordon Letwin of Microsoft discussed this call on ARPAnet in 1984. He
        stated:
        a) this is not supported under any version of the DOS
        b) it usually works under DOS 2, but there may be circumstances
           when it doesn't (general disclaimer, don't know of a specific
           circumstance)
        c) it will usually not work under DOS 3 and DOS 3.1; the DOS is
           considerably restructured and this flag takes on additional
           meanings and uses
        d) it will fail catastrophically under DOS 4.0 and forward.
        Obviously this information is incorrect since the call works fine
        through DOS 3.3. Microsoft glasnost?


35h  Get Vector
     Get interrupt vector
entry   AH      35h
        AL      interrupt number (hexadecimal)
return  ES:BX   address of interrupt vector
note    Use function call 25h to set the interrupt vectors


36h  Get Disk Free Space
     get information on specified drive
entry   AH      36h
        DL      drive number (0=default, 1=A:, 2=B:, etc)
return  AX      number of sectors per cluster
                0FFFFh means drive specified in DL is invalid
        BX      number of availible clusters
        CX      bytes per sector
        DX      clusters per drive
note 1) Mult AX * CX * BX for free space on disk
     2) Mult AX * CX * DX for total disk space
     3) Function 36h returns an incorrect value after an ASSIGN command. Prior
        to ASSIGN, the DX register contains 0943h on return, which is the free
        space in clusters on the HC diskette. After ASSIGN, even with no
        parameters, 0901h is returned in the DX register; this is an incorrect
        value. Similar results occur with DD diskettes on a PC-XT or a PC-AT.
        This occurs only when the disk is not the default drive. Results are as
        expected when the drive is the default drive. Therefore, the
        circumvention is to make the desired drive the default drive prior to
        issuing this function call.
     4) Int 21h, function call 36h returns an incorrect value after an ASSIGN
        command. Prior to ASSIGN, the DX register contains 0943h on return,
        which is the free space in clusters on the HC diskette. After ASSIGN,
        even with no parameters, 0901h is returned in the DX register; this is
        an incorrect value. Similar results occur with DD diskettes on a PC-XT
        or a PC-AT. This occurs only when the disk is not the default drive.
        Results are as expected when the drive is the default drive. Therefore,
        the circumvention is to make the desired drive the default drive prior
        to issuing this function call.
     5) This function supercedes functions 1Bh and 1Ch.


37h  SWITCHAR / AVAILDEV
 *   Get/set option marking character (is usually "/"), and device type
entry   AH      37h
        AL      00h     read switch character (returns current character in DL)
                01h     set character in DL as new switch character
      (DOS 2.x) 02h     read device availability (as set by function AL=3) into
                        DL. A 0 means devices that devices must be accessed in
                        file I/O calls by /dev/device. A non-zero value means
                        that devices are accessible at every level of the
                        directory tree (e.g., PRN is the printer and not a file
                        PRN).
                        AL=2 to return flag in DL, AL=3 to set from DL (0 = set,
                        1 = not set).
      (DOS 2.x) 03h     get device availability, where:
        DL      00h     means /dev/ must precede device names
                01h     means /dev/ need not precede device names
return  DL      switch character (if AL=0 or 1)
                device availability flag (if AL=2 or 3)
        AL      0FFh    the value in AL was not in the range 0-3.
note 1) Functions 2 & 3 appear not to be implemented for DOS 3.x.
     2) It is documented on page 4.324 of the MS-DOS (version 2) Programmer's
        Utility Pack (Microsoft - published by Zenith).
     3) Works on all versions of IBM PC-DOS from 2.0 through 3.3.1.
     4) The SWITCHAR is the character used for "switches" in DOS command
        arguments (defaults to '/', as in "DIR/P"). '-' is popular to make a
        system look more like UNIX; if the SWITCHAR is anything other than '/',
        then '/' may be used instead of '\' for pathnames
     5) Ignored by XCOPY, PKARC, LIST
     6) SWITCHAR may not be set to any character used in a filename
     7) In DOS 3.x you can still read the "AVAILDEV" byte with subfunction 02h
        but it always returns 0FFh even if you try to change it to 0 with
        subfunction 03h.
     8) AVAILDEV=0 means that devices must be referenced in an imaginary
        subdirectory "\dev" (similar to UNIX's /dev/*); a filename "PRN.DAT"
        can be created on disk and manipulated like any other. If AVAILDEV != 0
        then device names are recognized anywhere (this is the default):
        "PRN.DAT" is synonymous with "PRN:".
     9) These functions reportedly are not supported in the same fashion in
        various implementations of DOS.


38h  Return Country Dependent Information   (PCDOS 2.0, 2.1, MSDOS 2.00 only)
     get country-dependent information
entry   AH      38h
        AL      function code  (must be 0 in DOS 2.x)
        DS:DX   pointer to 32 byte memory area
return  AX      error code if CF set
        DS:DX   country data if CF not set
                word    date/time format
                        0 = USA standard       H:M:S   M/D/Y
                        1 = European standard  H:M:S   D/M/Y
                        2 = Japanese standard  H:M:S   D:M:Y
                byte    ASCIIZ string currency symbol followed by byte of zeroes
                byte    ASCIIZ string thousands separator followed by byte of
                        zeroes
                byte    ASCIIZ string decimal separator followed by byte of
                        zeroes
             24 bytes   reserved


38h  Get Country Dependent Information    (PCDOS 3.x+, MSDOS 2.01+)
     get country-dependent information
entry   AH      38h
        AL      function code
                00h     to get current country information
                code    country code to get information for, for countries
                        with codes less than 255
                0FFh    to get country information for countries with a code
                        greater than 255
        BX      16 bit country code if AL=0FFh
        DS:DX   pointer to the memory buffer where the data will be returned
return  CF      0 (clear) function completed
                1 (set) error
                   AX   error code if CF set
                        2  invalid country code (no table for it)
        BX      country code (usually international telephone code)
        DS:DX   country data if CF not set
                word    date/time format
                        0 = USA standard       H:M:S   M/D/Y
                        1 = European standard  H:M:S   D/M/Y
                        2 = Japanese standard  H:M:S   D:M:Y
              5 bytes   currency symbol null terminated
              2 bytes   thousands separator null terminated
              2 bytes   decimal separator null terminated
              2 bytes   date separator null terminated
              2 bytes   time separator null terminated
                byte    bit field currency format
                        bit 0 = 0  if currency symbol precedes the value
                                1  if currency symbol is after the value
                        bit 1 = 0  no spaces between value and currency symbol
                                1  one space between value and currency symbol
                        bits 2-7   not defined by Microsoft
                byte    number of significant decimal digits in currency
                        (number of places to right of decimal point)
                byte    time format
                        bit 0 = 0  12 hour clock
                        bit 0 = 1  24 hour clock
              2 words   case map call address
                        entry   AL  ASCII code of character to be converted to
                                    uppercase
                        return  AL  ASCII code of the uppercase input character
              2 bytes   data list separator null terminated
              5 words   reserved
note 1) When an alternate keyboard handler is invoked, the keyboard routine is
        loaded into user memory starting at the lowest portion of availible
        user memory. The BIOS interrupt vector that services the keyboard is
        redirected to the memory area where the new routine resides. Each new
        routine takes up about 1.6K of memory and has lookup tables that return
        values unique to each language. (KEYBxx in the DOS book)
         Once the keyboard interrupt vector is changed by the DOS keyboard
        routine, the new routine services all calls unless the system is
        returned to the US format by the ctrl-alt-F1 keystroke combination. This
        does not change the interrupt vector back to the BIOS location; it
        merely passes the table lookup to the ROM locations.
     2) Ctrl-Alt-F1 will only change systems with US ROMS to the US layout.
        Some systems are delivered with non-US keyboard handler routines in ROM
     3) Case mapping call: the segment/offset of a FAR procedure that performs
        country-specific lower-to-upper case mapping on ASCII characters 80h to
        0FFh. It is called with the character to be mapped in AL. If there is
        an uppercase code for the letter, it is returned in AL, if there is no
        code or the function was called with a value of less than 80h AL is
        returned unchanged.


38h  Set Country Dependent Information
     set country-dependent information
entry   AH      38h
        AL      code    country code to set information for, for countries
                        with codes less than 255
                0FFh    to set country information for countries with a code
                        greater than 255
        BX      16 bit country code if AL=0FFh
        DX      0FFFFh
return  CF      clear   successful
                set     if error
                        AX      error code if CF flag set


39h  Create Subdirectory (MKDIR)
     Makes a subdirectory along the indicated path
entry   AH      39h
        DS:DX   address of ASCIIZ pathname string
return  flag CF 0       successful
                1       error
                        AX      error code if any  (3, 5)
note 1) The ASCIIZ string may contain drive and subdirectory.
     2) Drive may be any valid drive (not nescessarily current drive)
     3) The pathname cannot exceed 64 characters


3Ah  Remove Subdirectory  (RMDIR)
     remove a directory entry
entry   AH      3Ah
        DS:DX   address of ASCIIZ pathname string
return  CF      clear     successful
                set       AX      error code if any  (3, 5, 16)
note 1) The ASCIIZ string may contain drive and subdirectory.
     2) Drive may be any valid drive (not nescessarily current drive)
     3) The pathname cannot exceed 64 characters


3Bh  Change Current Directory
     (CHDIR)
entry   AH      3Bh
        DS:DX   address of ASCIIZ string
return  flag CF 0       successful
                1       error
        AX      error code if any (3)
note 1) The pathname cannot exceed 64 characters
     2) The ASCIIZ string may contain drive and subdirectory.
     3) Drive may be any valid drive (not nescessarily current drive)


3Ch  Create A File (CREAT)
     create a file with handle
entry   AH      3Ch
        CX      attributes for file
                00h     normal
                01h     read only
                02h     hidden
                03h     system
        DS:DX   address of ASCIIZ filename string
return  flag CF 0       successful creation
                1       error
        AX      16 bit file handle
                or error code  (3, 4, 5)
note 1) The ASCIIZ string may contain drive and subdirectory.
     2) Drive may be any valid drive (not nescessarily current drive)
     3) If the volume label or subdirectory bits are set in CX, they are ignored
     4) The file is opened in read/write mode
     5) If the file does not exist, it is created. If one of the same name
        exists, it is truncated to a length of 0.


3Dh  Open A File
     Open disk file with handle
entry   AH      3Dh
        AL      access code byte
(DOS 2.x)       bits 0-2  file attribute
                000     read only
                001     write only
                010     read/write
                bits 3-7 should be set to zero
(DOS 3.x)       bits 0-2  file attribute
                000     read only
                001     write only
                010     read/write
                bit 3   reserved
                0       should be set to zero
                bits 4-6 sharing mode (network)
                000     compatibility mode (the way FCBs open files)
                001     read/write access denied (exclusive)
                010     write access denied
                011     read access denied
                100     full access permitted
                bit 7   inheritance flag
                0       file inherited by child process
                1       file private to child process
        DS:DX   address of ASCIIZ pathname string
return  flag CF set on error
                AX      error code
                1       error
        AX      16 bit file handle
                or error code (1, 2, 4, 5, 0Ch)
note 1) Opens any normal, system, or hidden file
     2) Files that end in a colon are not opened
     3) The rear/write pointer is set at the first byte of the file and the
        record size of the file is 1 byte (the read/write pointer can be changed
        through function call 42h). The returned file handle must be used for
        all subsequent input and output to the file.
     4) If the file handle was inherited from a parent process or was
        duplicated by DUP or FORCEDUP, all sharing and access restrictions are
        also inherited.
     5) A file sharing error (error 1) causes an int 24h to execute with an
        error code of 2


3Eh  Close A File Handle
     Close a file and release handle for reuse
entry   AH      3Eh
        BX      file handle
return  flag CF 0       successful close
                1       error
        AX      error code if error (6)
note 1) When executed, the file is closed, the directory is updated, and all
        buffers for that file are flushed. If the file was changed, the time
        and date stamps are changed to current
     2) If called with the handle 00000, it will close STDIN (normally the
        keyboard).


3Fh  Read From A File Or Device
     Read from file with handle
entry   AH      3Fh
        BX      file handle
        CX      number of bytes to read
        DS:DX   address of buffer
return  flag CF 0       successful read
                1       error
        AX      0       pointer was already at end of file
                        or number of bytes read
                        or error code (5, 6)
note 1) This function attempts to transfer the number of bytes specified in CX
        to a buffer location. It is not guaranteed that all bytes will be read.
        If AX < CX a partial record was read.
     2) If performed from STDIN (file handle 0000), the input can be redirected
     3) If used to read the keyboard, it will only read to the first CR
     4) The file pointer is incremented to the last byte read.


40h  Write To A File Or Device
     Write to file with handle
entry   AH      40h
        BX      file handle
        CX      number of bytes to write
        DS:DX   address of buffer
return  flag CF 0       successful write
                1       error
        AX      number of bytes written
                or error code  (5, 6)
note 1) This call attempts to transfer the number of bytes indicated in CX
        from a buffer to a file. If CX and AX do not match after the write,
        an error has taken place; however no error code will be returned for
        this problem. This is usually caused by a full disk.
     2) If the write is performed to STDOUT (handle 0001), it may be redirected
     3) To truncate the file at the current position of the file pointer, set
        the number of bytes in CX to zero before calling int 21h. The pointer
        can be moved to any desired position with function 42h.
     4) This function will not write to a file or device marked read-only.


41h  Delete A File From A Specified Subdirectory
     (UNLINK)
entry   AH      41h
        DS:DX   pointer to ASCIIZ filespec to delete
return  CF      0       successful
                1       error
                AX      error code if any  (2, 5)
note 1) This function will not work on a file marked read-only
     2) Wildcards are not accepted


42h  Move a File Read/Write Pointer
     (LSEEK)
entry   AH      42h
        AL      method code
                00h     offset from beginning of file
                01h     offset from present location
                02h     offset from end of file
        BX      file handle
        CX      most significant half of offset
        DX      least significant half of offset
return  AX      low offset of new file pointer
        DX      high offset of new file pointer
        CF      0       successful move
                1       error
                AX      error code (1, 6)
note 1) If pointer is at end of file, reflects file size in bytes.
     2) The value in DX:AX is the absolute 32 bit byte offset from the beginning
        of the file


43h  Get/Set file attributes
     (CHMOD)
entry   AH      43h
        AL      00h     get file attributes
                01h     set file attributes
                CX      file attributes to set
                        bit 0       read only
                        1       hidden file
                        2       system file
                        3       volume label
                        4       subdirectory
                        5       written since backup
        DS:DX   pointer to full ASCIIZ file name
return  CF      set if error
        AX      error code  (1, 2, 3, 5)
        CX      file attributes on get
                attributes:
                01h     read only
                02h     hidden
                04h     system
                0FFh    archive


44h  I/O Control for Devices (IOCTL)
     Get or set device information
entry   AH      44h
        AL      00h     get device information (from DX)
                        BX      file or device handle
                        return  DX      device info
                                        If bit 7 set: (character device)
                                           bit 0: console input device
                                               1: console output device
                                               2: NUL device
                                               3: CLOCK$ device
                                               4: device is special
                                               5: binary (raw) mode
                                               6: Not EOF
                                              12: network device (DOS 3.x)
                                              14: can process IOCTL control
                                                  strings (func 2-5)
                                         If bit 7 clear: (file)
                                         bits 0-5 are block device number
                                                6: file has not been written
                                               12: Network device (DOS 3.x)
                                            15: file is remote (DOS 3.x)
                01h     set device information (DH must be zero for this call)
                        DX bits:
                        0    1  console input device
                        1    1  console output device
                        2    1  null device
                        3    1  clock device
                        4    1  reserved
                        5    0  binary mode - don't check for control chars
                             1  cooked mode - check for control chars
                        6    0  EOF - End Of File on input
                        7       device is character device if set, if not, EOF
                                is 0 if channel has been written, bits 0-5 are
                                block device number
                        12      network device
                        14   1  can process control strings (AL 2-5, can only be
                                read, cannot be set)
                        15   n  reserved
                02h     read CX bytes to device in DS:DX from BX control chan
                03h     Write Device Control String
                        BX      device handle
                        CX      number of bytes to write
                        DS:DX   pointer to buffer
                        return  AX      number of bytes written
                04h     read from block device (drive number in BL)
                        BL      drive number (0=default)
                        CX      number of bytes to read
                        DS:DX   pointer to buffer
                        return  AX      number of bytes read

                05h     write to block device  (drive number in BL)
                        AX      number of bytes transfered
                06h     get input handle status
                07h     get output handle status
                        AX      0FFh    for ready
                                00h     for not ready
                08h     removable media bit (DOS 3.x)
                        return  AX      00h     device is removable
                                        01h     device is nonremovable
                                        0Fh     invalid drive specification
                09h     test local or network device in BL (DOS 3.x)
                        BL      drive number (0=default)
                        return  DX      attribute word, bit 12 set if device is
                                        remote
                0Ah     is handle in BX local or remote? (DOS 3.x)
                        BX     file handle
                        return DX (attribute word) bit 15 set if file is remote
                0Bh     change sharing retry count to DX (default=3), (DOS 3.x)
                        CX     delay (default 1)
                        DX     retry count (default 3)
                0Ch     general IOCTL (DOS 3.3 [3.2?]) allows a device driver to
                        prepare, select, refresh, and query Code Pages
                0Dh     Block Device Request (DOS 3.3+)
                        BL      drive number (0=default)
                        CH      major subfunction
                        CL      minor subfunction
                                40h set device parameters
                                41h write logical device track
                                42h format and verify logical device track
                                60h get device parameters
                                61h read logical device track
                                62h verify logical device track
                        DS:DX   pointer to parameter block
                0Eh     GET LOGICAL DEVICE (DOS 3.3+)
                        BL      drive number (0=default)
                        return  AL=0 block device has only one logical drive
                                assigned 1..n the last letter used to reference
                                the device (1=A:,etc)
                0Fh     Set Logical Device (DOS 3.3+)
        BL      drive number:  0=default, 1=A:, 2=B:, etc.
        BX      file handle
        CX      number of bytes to read or write
        DS:DX   data or buffer
        DX      data
return  AX      number of bytes transferred
                or error code (call function 59h for extended error codes)
                or status
                        00h     not ready
                        0FFh    ready
        CF      set if error


45h  Duplicate a File Handle (DUP)
     Create duplicate handle
entry   AH      45h
        BX      file handle to duplicate
return  CF      clear   AX      duplicate handle
                set     AX      error code  (4, 6)
note 1) If you move the pointed of one handle, the pointer of the other will
        also be moved.
     2) The handle in BX must be open


46h  Force Duplicate of a Handle (FORCEDUP or CDUP)
     forces handle in CX to refer to the same file at the same position as BX
entry   AH      46h
        BX      existing file handle
        CX      new file handle
return  CF      clear   both handles now refer to existing file
                set     error
                AX      error code (4, 6)
note 1) If CX was an open file, it is closed first
     2) If you move the read/write pointer of either file, both will move
     3) The handle in BX must be open


47h  Get Current Directory
     places full pathname of current directory/drive into a buffer
entry   AH      47h
        DL      drive (0=default, 1=A:, etc.)
        DS:SI   points to 64-byte buffer area
return  CF      clear   DS:DI   pointer to ASCIIZ pathname of current directory
                set     AX      error code (0Fh)
note   String does not begin with a drive identifier or a backslash


48h  Allocate Memory
     allocates requested number of 16-byte paragraphs of memory
entry   AH      48h
        BX      number of 16-byte paragraphs desired
return  CF      clear   AX      segment address of allocated space
                        BX      maximum number paragraphs available
                set     AX      error code (7, 8)
note    BX indicates maximum memory availible only if allocation fails


49h  Free Allocated Memory
     frees specified memory blocks
entry   AH      49h
        ES      segment address of area to be freed
return  CF      clear   successful
                set     AX      error code (7, 9)
note 1) This call is only valid when freeing memory obtained by function 48h.
     2) A program should not try to release memory not belonging to it.


4Ah  Modify Allocated Memory Blocks (SETBLOCK)
     expand or shrink memory for a program
entry   AH      4AH
        BX      new size in 16 byte paragraphs
        ES      segment address of block to change
return  CF      clear   nothing
                set     AX      error code (7, 8, 9)
                    or  BX      max number paragraphs available
note 1) Max number paragraphs availible is returned only if the call fails
     2) Memory can be expanded only if there is memory availible


4Bh  Load or Execute a Program
     (EXEC)
entry   AH      4Bh
        AL      00h     load and execute program. A PSP is built for the program
                        the ctrl-break and terminate addresses are set to the
                        new PSP.
               *01h     load but don't execute  (note 1)
               *02h     load (internal) but do not execute
                03h     load overlay (do not create PSP, do not begin execution)
        DS:DX   points to the ASCIIZ string with the drive, path, and filename
                to be loaded
        ES:BX   points to a parameter block for the load
               (AL=00h) word    segment address of environment string to be
                                passed
                        dword   pointer to the command line to be placed at
                                PSP+80h
                        dword   pointer to default FCB to be passed at PSP+5Ch
                        dword   pointer to default FCB to be passed at PSP+5Ch
               (AL=03h) word    segment address where file will be loaded
                        word    relocation factor to be applied to the image
return  CF      clear   successful
                set     error
                AX      error code (1, 2, 8, 0Ah, 0Bh)
note 1) If you make this call with AL=1 the program will be loaded as if you
        made the call with AL=0 except that the program will not be executed.
        Additionally, with AL=1 the stack segment and pointer along with the
        program's CS:IP entry point are returned to the program which made the
        4B01h call. These values are put in the four words at ES:BX+0eh. On
        entry to the call ES:BX points to the environment address, the command
        line and the two default FCBs. This form of EXEC is used by DEBUG.COM.
     2) Application programs may invoke a secondary copy of the command
        processor (normally COMMAND.COM) by using the EXEC function.  Your
        program may pass a DOS command as a parameter that the secondary
        command processor will execute as though it had been entered from the
        standard input device.
        The procedure is:
         A. Assure that adequate free memory (17k for 2.x and 3.0, 23k for 3.1
            up) exists to contain the second copy of the command processor and
            the command it is to execute. This is accomplished by executing
            function call 4Ah to shrink memory allocated to that of your current
            requirements. Next, execute function call 48h with BX=0FFFFh. This
            returns the amount of memory availible.
        B. Build a parameter string for the secondary command processor in the
           form:
                         1 byte   length of parameter string
                        xx bytes  parameter string
                         1 byte   0Dh (carriage return)
           For example, the assembly language statement below would build the
           string to cause execution of the command FOO.EXE:
                              DB 19, "/C C:FOO" , 13
        C. Use the EXEC function call (4Bh), function value 0 to cause execution
           of the secondary copy of the command processor. (The drive,
           directory, and name of the command processor can be gotten from the
           COMSPEC variable in the DOS environment passed to you at PSP+2Ch.)
        D. Remember to set offset 2 of the EXEC control block to point to the
           string built above.
     3) All open files of a process are duplicated in the newly created
        process after an EXEC, except for files originally opened with the
        inheritance bit set to 1.
     4) The environment is a copy of the original command processor's
        environment. Changes to the EXECed environment are not passed back to
        the original. The environment is followed by a copy of the DS:DX
        filename passed to the child process. A zero value will cause the
        child process to inherit the environment of the calling process. The
        segment address of the environment is placed at offset 2Ch of the
        PSP of the program being invoked.
     5) This function uses the same resident part of COMMAND.COM, but makes a
        duplicate of the transient part.
     6) How EXEC knows where to return to:  Basically the vector for int 22h
        holds the terminate address for the current process.  When a process
        gets started, the previous contents of int 22h get tucked away in the
        PSP for that process, then int 22h gets modified.  So if Process A
        EXECs process B, while Process B is running, the vector for int 22h
        holds the address to return to in Process A, while the save location in
        Process B's PSP holds the address that process A will return to when
        *it* terminates.  When Process B terminates by one of the usual legal
        means, the contents of int 22h are (surmising) shoved onto the stack,
        the old terminate vector contents are copied back to int 22h vector from
        Process B's PSP, then a RETF or equivalent is executed to return control
        to process A.


4Ch  Terminate a Process (EXIT)
     Quit with exit code
entry   AH      4Ch
        AL      exit code in AL when called, if any, is passed to next process
return  none
note 1) Control passes to DOS or calling program
     2) return code from AL can be retrieved by ERRORLEVEL or function 4Dh
     3) all files opened by this process are closed, buffers are flushed, and
        the disk directory is updated
     4) Restores Terminate vector from PSP:000Ah
                 Ctrl-C vector from PSP:000Eh
                 Critical Error vector from PSP:0012h


4Dh  Get Return Code of a Subprocess (WAIT)
     gets return code from functions 31h and 4Dh  (ERRORLEVEL)
entry   AH      4Dh
return  AL      exit code of subprogram (functions 31h or 4Ch)
        AH      circumstance which caused termination
                00h     normal termination
                01h     control-break
                02h     critical device error
                03h     terminate and stay resident (function 31h)
note    The exit code is only returned once


4Eh  Find First Matching File (FIND FIRST)
     Find first ASCIIZ
entry   AH      4Eh
        CX      search attributes
        DS:DX   pointer to ASCIIZ filename (with attributes)
return  CF      set     AX      error code (2, 12h)
                clear   data block written at current DTA
                        format of block is:
  documented by Micro-  |00h   1 byte   attribute byte of search
  soft as "reserved for |01h   1 byte   drive used in search
  DOS' use on subsquent |02h   11 bytes the search name used
  Find Next calls"      |0Ch   2 bytes  word value of last entry
  function 4Fh          |0Fh   4 bytes  dword pointer to this DTA
                        |13h   2 bytes  word directory start
                         15h   1 byte   file attribute
                         16h   2 bytes  file time
                         18h   2 bytes  file date
                         1Ah   2 bytes  low word of file size
                         1Ch   2 bytes  high word of file size
                         1Eh  13 bytes  name and extension of file found, plus
                                        1 byte of 0s. All blanks are removed
                                        from the name and extension, and if an
                                        extension is present it is preceded by a
                                        period.
note 1) Will not find volume label
     2) This function does not support network operations
     3) Wildcards are allowed in the filespec
     4) If the attribute is zero, only ordinary files are found. If the volume
        label bit is set, only volume labels will be found. Any other attribute
        will return that attribute and all normal files together.
     5) To look for everything except the volume label, set the hidden, system,
        and subdirectory bits all to 1


4Fh  Find Next Matching File (FIND NEXT)
     Find next ASCIIZ
entry   AH      4Fh
return  CF      clear   data block written at current DTA
                set     AX      error code (2, 12h)
note 1) If file found, DTA is formatted as in call 4Eh
     2) Volume label searches using 4Eh/4Fh reportedly aren't 100% reliable
        under DOS 2.x. The calls sometime report there's a volume label and
        point to a garbage DTA, and if the volume label is the only item they
        often won't find it
     3) This function does not support network operations
     4) Use of this call assumes that the original filespec contained wildcards


50h   Set PSP
 *    Set new Program Segment Prefix; current process ID
entry   AH      50h
        BX      segment address of new PSP
return  none - swaps PSP's regarded as current by DOS
note 1) By putting the PSP segment value into BX and issuing call 50h DOS stores
        that value into a variable and uses that value whenever a file call is
        made.
     2) Note that in the PSP (or PDB) is a table of 20 (decimal) open file
        handles. The table starts at offset 18h into the PSP. If there is an
        0FFh in a byte then that handle is not in use. A number in one of the
        bytes is an index into an internal FB table for that handle. For
        instance the byte at offset 18h is for handle 0, at offset 19h handle
        1, etc. up to 13h. If the high bit is set then the file associated by
        the handle is not shared by child processes EXEC'd with call 4Bh.
     3) Function 50h is dangerous in background operations prior to DOS 3.x as
        it uses the wrong stack for saving registers.  (same as functions
        0..0Ch in DOS 2.x)
     4) Under DOS 2.x, this function cannot be invoked inside an int 28h handler
        without setting the Critical Error flag
     5) Open File information, etc. is stored in the PSP DOS views as current.
        If a program (eg. a resident program) creates a need for a second PSP,
        then the second PSP should be set as current to make sure DOS closes
        that as opposed to the first when the second application finishes.
     6) See PC Mag Vol.5, No 9, p.314 for discussion.


51h   Get Program Segment Prefix
 *    Returns the PSP address of currently executing program
entry   AH      51h
return  BX      address of currently executing program
note 1) Used in DOS 2.x, 3.x uses 62h
     2) Function 51h is dangerous in background operations prior to DOS 3.x as
        it uses the wrong stack for saving registers.  (same as functions
        0..0Ch in DOS 2.x)
     3) 50h and 51h might be used if you have more than one process in a PC.
        For instance if you have a resident program that needs to open a file
        you could first call 51h to save the current id and then call 50h to set
        the ID to your PSP.
     4) Under DOS 2.x, this function cannot be invoked inside an int 28h handler


52h     IN-VARS
 *      returns a pointer to a set of DOS data variables MCB chain, pointer to
        first device driver and a pointer to disk parameter blocks (first one)
entry   AH      52h
return  ES:BX   pointer to the DOS list of lists, for disk information. Does not
                access the disk, so information in tables might be incorrect if
                disk has been changed. Returns a pointer to the following array
                of longword pointers:
                Bytes   Value
                -2h,-1h segment of first memory control block
                0h-3h   pointer to first DOS disk block (see function 36h)
                4h-7h   partially unknown. Pointer to a device driver. Maybe
                        first resident driver?
                8h-0Bh  pointer to CLOCK$ device driver, whether installable or
                        resident
                0Ch-0Fh pointer to actual CON: device driver, whether
                        installable or resident
        (DOS 2.x)
                10      Number of logical drives in system
                11-12   Maximum bytes/block of any block device
                13-16   unknown
                17      Beginning (not a pointer. The real beginning!) of NUL
                        device driver. This is the first device on DOS's linked
                        list of device drivers.
        (DOS 3.x)
                10h-11h maximum bytes/block of any block device (0200h)
                12h-15h unknown. Pointer to current directory block?
                16h-19h partially undefined: Pointer to array of drive info:
                        51h bytes per drive, starting with A: ...
                        00h-3Fh current path as ASCIIZ, starting with 'x:\'
                        40h-43h unknown    zeros always
                        44h     unknown    flags? Usually 40h, except for
                                entry after last valid entry = 00h
                        45h-48h pointer to DOS disk block for this drive
                        49h-4Ah unknown. Current track or block?
                                -1 if never accessed
                        4Bh-4Eh unknown  -1 always
                        4Fh-52h unknown   2 always
                1Ah-1Dh unknown. Pointer to data area, maybe including cluster
                        allocation table?
                1Eh-1Fh unknown. Zero always
                20h     Number of block devices
                21h     value of LASTDRIVE command in CONFIG.SYS (default 5)
                22h     Beginning (not a pointer. The real beginning!) of NUL
                        device driver. This is the first device on DOS's linked
                        list of device drivers.
note    This call is not supported in OS/2 1.0's DOS Compatibility Box


53h  Translate BPB
 *   Translates BPB (BIOS Parameter Block, see below) into a DOS Disk Block (see
     function call 32h).
entry   AH      53h
        DS:SI   pointer to BPB
        ES:BP   pointer to area for DOS Disk Block.
                Layout of Disk Block:
                bytes   value
                00h-01h bytes per sector, get from DDB bytes 02h-03h.
                02h     sectors per cluster, get from (DDB byte 4) + 1
                03h-04h reserved sectors, get from DDB bytes 06h-07h
                05h     number of FATs, get from DDB byte 08h
                06h-07h number of root dir entries, get from DDB bytes 09h-0Ah
                08h-09h total number of sectors, get from:
                        ((DDB bytes 0Dh-0Eh) - 1) * (sectors per cluster (BPB
                        byte 2)) + (DDB bytes 0Bh-0Ch)
                0Ah     media descriptor byte, get from DDB byte 16h
                0Bh-0Ch number of sectors per FAT, get from DDB byte 0Fh
return  unknown


54h  Get Verify Setting
     Get verify flag status
entry   AH      54h
return  AL      00h if flag off
                01h if flag on
note    Flag can be set with function 2Eh


55h  Create "Child" PSP
 *   Create PSP: similar to function 26h (which creates a new Program Segment
     Prefix at segment in DX) except creates a "child" PSP rather than copying
     the existing one.
entry   AH      55h
        DX      segment number at which to create new PSP.
return  unknown
note 1) This call is similar to call 26h which creates a PSP except that unlike
        call 26h the segment address of the parent process is obtained from the
        current process ID rather than from the CS value on the stack (from the
        INT 21h call). DX has the new PSP value and SI contains the value to be
        placed into PSP:2 (top of memory).
     2) Function 55 is merely a substitute for function 26h. It will copy the
        current PSP to the segment address DX with the addition that SI is
        assumed to hold the new memory top segment. This means that function
        26h sets SI to the segment found in the current PSP and then calls
        function 55h.


56h  Rename a File
     if the first file exists, it is renamed to the name in ES:DI
entry   AH      56h
        DS:DX   pointer to ASCIIZ old pathname
        ES:DI   pointer to ASCIIZ new pathname
return  CF      clear   successful rename
                set     AX      error code (2, 3, 5, 11h)
note 1) Works with files in same drive only
     2) Global characters not allowed in filename
     3) The name of a file is its full pathname. The file's full pathname can
        be changed, while leaving the actual FILENAME.EXT unchanged. Changing
        the pathname allows the file to be "moved" from subdirectory to
        subdirectory on a logical drive without actually copying the file.
     4) DOS 3.x allows renaming of directories



57h  Get/Set a File's Date and Time
     read or modify time and date stamp on a file's directory entry
entry   AH      57h
        AL      function code
                00h     get date and time
                01h     set date and time
                        CX      time to be set
                        DX      date to be set
        BX      file handle
return  CF     clear    CX      time of last write (if AL = 0)
                        DX      date of last write (if AL = 0)
               set      AX      error code (1, 6)
note    Date/time formats are:
        CX bits 0Bh-0Fh hours (0-23)    DX bits 09h-0Fh year (relative to 1980)
                05h-0Ah minutes (0-59)          05h-08h month (0-12)
                00h-04h #2 sec. incr. (0-29)   00h-04h day of the month (0-31)


58h   Get/Set Allocation Strategy
      DOS 3.x
entry   AH      58h
        AL      0       set current strategy
                1       set new current strategy
        BX      new strategy if AH=1
                0       first fit - chooses the lowest block in memory which
                        will fit (this is the default). (use first memory block
                        large enough)
                1       best fit - chooses the smallest block which will fill
                        the request.
                2       last fit - chooses the highest block which will fit.
return  CF      clear   (0)     successful
                set     (1)     error (1)
                                AX      error code
        AX      strategy code (CF=0)
note 1) Documented in Zenith DOS version 3.1, some in Advanced MSDOS
     2) The set subfunction accepts any value in BL; 2 or greater means last
        fit. The get subfunction returns the last value set, so programs should
        check whether the value is greater than or equal to 2.


59h  Get Extended Error Code (DOS 3.x)
     returns additional error information when requested
      The Get Extended Error function call (59h) is intended to provide a common
     set of error codes and to supply more extensive information about the error
     to the application. The information returned from function call 59h, in
     addition to the error code, is the error class, the locus, and the
     recommended action. The error class provides information about the error
     type (hardware, internal, system, etc.). The locus provides information
     about the area involved in the failure (serial device, block device,
     network, or memory). The recommended action provides a default action for
     programs that do not understand the specific error code.
       Newly written programs should use the extended error support both from
     interrupt 24h hard error handlers and after any int 21h function calls. FCB
     function calls report an error by returning 0FFh in AL. Handle function
     calls report an error by setting the carry flag and returning the error
     code in AX. Int 21h handle function calls for DOS 2.x continue to return
     error codes 0-18. Int 24h handle function calls continue to return error
     codes 0-12. But the application can obtain any of the error codes used in
     the extended error codes table by issuing function call 59h. Handle
     function calls for DOS 3.x can return any of the error codes. However, it
     is recommended that the function call be followed by function call 59h to
     obtain the error class, the locus, and the recommended action.
       The Get Extended Error function (59h) can always be called, regardless of
     whether the previous DOS call was old style (error code in AL) or new style
     (carry bit). It can also be used inside an int 24h handler.
      You can either check AL or the carry bit to see if there was no error,
     and call function 59h only if there was an error, or take the simple
     approach of always calling 59h and letting it tell you if there was an
     error or not. When you call function 59h it will return with AX=0 if the
     previous DOS call was successful.
entry   AH      59h
        BX      version code (0000 for DOS 3.0 and 3.1)
return  AX      extended error code:
                01h     Invalid function number
                02h     File not found
                03h     Path not found
                04h     Too many open files, no file handles left
                05h     Access denied
                06h     Invalid handle
                07h     Memory control blocks destroyed
                08h     Insufficient memory
                09h     Invalid memory block address
                0Ah     Invalid environment
                0Bh     Invalid format
                0Ch     Invalid access code
                0Dh     Invalid data
                0Eh     Reserved
                0Fh     Invalid drive was specified
                10h     Attempt to remove the current directory
                11h     Not same device
                12h     No more files
                13h     Attempt to write on write-protected diskette
                14h     Unknown unit
                15h     Drive not ready
                16h     Unknown command
                17h     Bad CRC check
                18h     Bad request structure length
                19h     Seek error
                1Ah     Unknown media type
                1Bh     Sector not found
                1Ch     Printer out of paper
                1Dh     Write fault
                1Eh     Read fault
                1Fh     General Failure
                20h     Sharing violation
                21h     Lock violation
                22h     Invalid disk change
                23h     FCB unavailible
                24h     Sharing buffer overflow
                25h     Reserved
                26h        "
                27h        "
                28h        "
                29h        "
                2Ah        "
                2Bh        "
                2Ch        "
                2Dh        "
                2Eh        "
                2Fh        "
                30h        "
                31h     Reserved
                32h     Network: request not supported (DOS 3.1 + MS Networks)
                33h     Remote computer not listening
                34h     Duplicate name on network
                35h     Network: name not found
                36h     Network: busy
                37h     Network: device no longer exists
                38h     NETBIOS command limit exceeded
                39h     Network: adapter hardware error
                3Ah     Incorrect response from network
                3Bh     Unexpected network error
                3Ch     Incompatible remote adapter
                3Dh     Print queue full
                3Eh     Not enough space for print file
                3Fh     Print file was deleted
                40h     Network: name was deleted
                41h     Network: Access denied
                42h     Network: device type incorrect
                43h     Network: name not found
                44h     Network: name limit exceeded
                45h     NETBIOS session limit exceeded
                46h     Temporarily paused
                47h     Network: request not accepted
                48h     Print or disk redirection paused (DOS 3.1 + MS Networks)
                49h     Reserved
                4Ah        "
                4Bh        "
                4Ch        "
                4Dh        "
                4Eh        "
                4Fh     Reserved
                50h     File exists
                51h     Reserved
                52h     Cannot make directory entry
                53h     Fail on interrupt 24h
                54h     Too many redirections
                55h     Duplicate redirection
                56h     Invalid password
                57h     Invalid parameter
                58h     Network: device fault
        BH      class of error:
                01h     Out of resource
                02h     Temporary situation
                03h     Authorization (denied access)
                04h     Internal
                05h     Hardware failure
                06h     System failure
                07h     Application program error
                08h     Not found
                09h     Bad format
                0Ah     Locked
                0Bh     Media error (wrong volume ID, disk failure)
                0Ch     Already exists
                0Dh     Unknown
        BL      suggested action code:
                01h     Retry
                02h     Delayed retry
                03h     Prompt user
                04h     Abort after cleanup
                05h     Immediate abort
                06h     Ignore
                07h     Retry after user intervention
        CH      locus (where error occurred):
                01h     Unknown or not appropriate
                02h     Block device
                03h     Network related
                04h     Serial device
                05h     Memory related
note 1) Not all DOS functions use the carry flag to indicate an error. Carry
        should be tested only on those functions which are documented to use it.
     2) None of the DOS functions which existed before 2.0 use the carry
        indicator.  Many of them use register AL as an error indication instead,
        usually by putting 0FFh in AL on an error. Most, but not all, the "new"
        (2.x, 3.x) functions do use carry, and most, but not all, of the "old"
        (1.x) functions use AL.
     3) On return, CL, DI, DS, DX, ES, BP, and SI are destroyed - save before
        calling this function if required.
     4) DOS 2.x Error Codes:  If you are using function calls 38h-57h with DOS
        2.x, to check if an error has occurred, check for the following error
        codes in the AX register:
        call    error code      call    error code      call    error code
        38h     2               41h     2,3,5           4Ah     7,8,9
        39h     3,5             42h     1,6             4Bh     1,2,3,5,8,10,11
        3Ah     3,5,15          43h     1,2,3,5         4Eh     2,3,18
        3Bh     3               44h     1,3,5,6         4Fh     18
        3Ch     3,4,5           45h     4,6             56h     2,3,5,17
        3Dh     2,3,4,5,12      46h     4,6             57h     1,6
        3Eh     6               47h     15
        3Fh     5,6             48h     7,8
        40h     5,6             49h     7,9
     5) note that extended error codes 13h through 1Fh correspond to error
        codes 00h through 0Ch returned by int 24h


5Ah  Create Temporary File
     Create unique filename (for temporary use) (DOS 3.x)
entry   AH      5Ah
        DS:DX   pointer to ASCIIZ directory pathname ending with a backslash (\)
        CX      file attribute
return  CF      clear   DS:DX   new ASCIIZ path name
                        AX      handle
                set     AX      error code (3 or 5)
note 1) The file created is not truly "temporary". It must be removed by the
        user.
     2) If the filename created already exists in the current directory, this
        function will call itself again with another unique filename until
        a unique filename is found


5Bh  Create a New File
     (DOS 3.x)
entry   AH      5Bh
        DS:DX   pointer to directory ASCIIZ path name
        CX      file attribute
return  CF      clear   AX      file handle
                        DS:DX   new ASCIIZ path name
                set     AX      error code (3, 4, 5, 50h)
note 1) Unlike function 3Ch, function 5Bh will fail if the file already exists.
     2) The new file is opened in read/write mode


5Ch  Lock/Unlock File Access
     (DOS 3.x)
entry   AH      5Ch
        AL      00h     to lock file
                01h     to unlock file
        BX      file handle
        CX:DX   starting offset of region to lock
        SI:DI   size of region  to lock
return  CF      clear   successful
                set     AX      error code (1, 6, 21h)
note 1) Close all files before exiting or undefined results may occur
     2) Programs spawned with EXEC inherit all the parent's file handles but
        not the file locks


5Dh  Set Extended Error Information
 *   DOS  Internal - partial (DOS 3.x)
entry   AH      5dh
        AL      subfunction
                06h     get address of critical error flag
                        return  DS:SI   pointer to critical error flag
                08h     (unknown - used by command.com)
                09h     (unknown - used by command.com)
                0Ah     set error info (Error, Class, Action, and Locus)
                        DS:DX   address of 11-word error information
                                words 0 to 7: values of AX,BX,CX,DX,SI,DI,DS,
                                              ES that function 59h will return
                                words 8 to 10: zero (reserved)
return: CX      unknown
        DX      unknown
        DS:SI   (for 06h) pointer to critical error flag
note 1) This call seems to have many different functions
     2) Function 0Ah; DOS 3.1+
     3) Function 06h; setting CritErr flag allows use of functions 50h/51h from
        int 28h under DOS 2.x by forcing use of correct stack


5Eh     Network Printer  (Partially documented by Microsoft)
        DOS 3.1+ with Networks software
entry   AH      5Eh
        AL      00      Get Machine Name
                        DS:DX   pointer to buffer for ASCIIZ name
                        return  CH      0       if name not defined
                                CL      NETBIOS name number if CH <> 0
                                DS:DX   pointer to identifier if CH <> 0
                        note    the ASCIIZ name is a 15 byte string padded
                                to length with zeroes
                01      Set Machine Name
                        DS:DX   pointer to ASCIIZ name
                        CH      unknown
                        CL      name number
                02      Set Printer Control String
                        BX      redirection list index
                        CX      length of setup string (max 64 bytes)
                        DS:SI   pointer to string buffer
                03      Get Printer Control String
                        BX      redirection list index
                        ES:DI   pointer to string buffer
                        return  CX      length of setup string (max 64 bytes)
return  CF      clear   successful
                set     error
                        AX      error code (1 for all listed subfunctions)
note 1) Used in IBM's & Microsoft's Network programs
     2) Partial documentation in Fall 1985 Byte
     3) These services require that the network software be installed
     4) Partial documentation in Advanced MS-DOS
     5) SHARE must be loaded or results can be unpredictable on 00h, or fail
        with 02h or 03h


5Fh     Network Redirection
        (DOS 3.1 + Microsoft Networks)
entry   AH      5Fh
        AL     *00h     Unknown
               *01h     Unknown
                02h     Get Redirection List Entry
                        BX      redirection list index
                        DS:SI   pointer to 16 byte buffer for local device name
                        ES:DI   pointer to 128 byte buffer for network name
                        return  BH      device status flag (bit 0 = 0 if valid)
                                                          (bit 0 = 1 if invalid)
                                BL      device type
                                        03      printer device
                                        04      drive device
                                CX      stored parameter value
                                DS:SI   pointer to 16 byte local device name
                                ES:DI   pointer to 128 byte network name
                        note    DX and BP are destroyed by this call!
                03h     Redirect Device
                        BL      device type
                                03      printer device
                                04      file device
                        CX      stored parameter value
                        DS:SI   pointer to source device name
                        ES:DI   pointer to destination ASCIIZ network path +
                                ASCIIZ password
                04h     Cancel Redirection
                        DS:SI   pointer to ASCIIZ device name or network path
return  CF      clear   successful
                set     if error
                        AX      error code
return  as above
note 1) Used in IBM's Network program
     2) Partial documentation in Fall 1985 Byte
     3) These services require that the network software be installed
     4) Partial documentation in Advanced MS-DOS
     5) SHARE must be loaded or the call will fail
     6) The network device name requires a password


60h     Parse pathname (DOS 3.x)
 *      Translate - perform name processing on a string (internal to DOS)
entry   AH      60h
        DS:SI   pointer to source string (null terminated)
        ES:DI   pointer to destination string buffer.
return  ES:DI   buffer filled with qualified name
        CF      0       no error
                1       error
                        AX      error code
note 1) Documented in Zenith 3.05 Tech Ref
     2) All name processing is performed on the input string: string
        substitution is performed on the components, current drive/directories
        are prepended, .  and ..  are removed.
     3) Example: If current drive/directory is c:\test,  myfile.x is translated
        to c:\test\myfile.x; ..\source\sample.asm is tranlated to c:\source\
        sample.asm
     4) It is the caller's responsibility to make sure DS:SI does not point to
        a null string. If it does, SI is incremented, a null byte is stored at
        ES:DI, and the routine returns.


61h     No Information Availible  (DOS 3.x)
 *      internal to DOS - parameters not known
entry   AH      61h
return  AL      0
note    Supposedly documented in Zenith DOS 3.05 Tech Ref


62h  Get Program Segment Prefix (PSP)
     Get PSP address (DOS 3.x)
entry   AH      62h
return  BX      segment address of PSP


63h  Get Lead Byte Table  (MS-DOS 2.25 only)
     added in MS-DOS version 2.25 for additional foreign character set support.
entry   AH      63h
        AL      subfunction
                00h     get system lead byte table address
                01h     set/clear interim console flag
                        DL      0 to clear interim console flag
                                1 to set interim console flag
                02h     get interim console flag
return  DS:SI   pointer to lead byte table (AL = 00h)
        DL      interim console flag (AL = 02h)
note    Function 63h destroys all registers on return.


64h  Internal
     unknown (DOS 3.3+)
entry   AH      64h


65h  Get Extended Country Information (DOS 3.3+)
     returns information about the selected country formats, code pages, and
     conversion tables
entry   AH      65h
        AL      info ID (1 - 6)
        BX      code page (-1 = global code page)
        CX      size of buffer
        DX      country ID (-1 = current country)
        ES:DI   pointer to country information buffer
return  AX      error code if carry set, otherwise
        CX      size of country information returned
        CF      set on error
        ES:DI   pointer to country information:
                1 byte info ID
                if info ID <> 1
                    dword  pointer to information
                if info ID = 1
                    word   size
                    word   country ID
                    word   code page
                 34 bytes  (see function 38h)


66h   Get/Set Global Code Page Table (DOS 3.3+)
      query/reset code page defaults
entry   AH      66h
        AL      00h     Get Global Code Page
                01h     Set Global Page
                        BX      active code page
                        DX      system code page (active page at boot time)
return  CF      clear  successful
                set    AX       error code
        if 00h         BX       active code page
                       DX       system code page (active page at boot time)
note    BX = active code page: 437 = US, 860 = Portugal, 863 = Canada (French)
                               865 = Norway/Denmark


67h  Set Handle Count  (DOS 3.3+)
     supports more than 20 open files per process
entry   AH      67h
        BX      desired number of handles (max 255)
return  CF      clear if OK
        CF      set if error
                AX      error code


68h  Commit File (DOS 3.3+)
     Write all buffered data to disk
entry   AH      68h
        BX      file handle
return  CF      set     AX      error code
                clear   successful
note    Faster and more secure method of closing a file in a network than
        current close commands


69h     Disk Serial Number  DOS 4.0 (US)
        Places and reads "Volume Serial Number" on disks formatted with 4.0+
entry   unknown
return  unknown
note    A call for DOS function 69h (AL=0, possibly a subfunction) uses DS:DX
        as a pointer to a table. On return, the table is filled in as follows:
        word            unknown (zeroes on my system)
        dword           disk serial number (binary)
        char[11]        volume label or "NO NAME    " if none
        char[8]         FAT type
        The FAT type field returns "FAT16   " on hard disk formatted with DOS
        3.3 and "FAT12   " on a 360K floppy.


6Ah     unknown  (DOS 4.0?)


6Bh     unknown  (DOS 4.0?)


6Ch     Extended Open/Create  DOS 4.0 (US)
        Combines functions available with Open, Create, Create New, and Commit
entry   AH      6Ch
        AL      00h  reserved  [which means there might be other subfunctions?]
        BX      mode    format  0WF0 0000 ISSS 0AAA
                                AAA is access code (read, write, read/write)
                                SSS is sharing mode
                                I       0       pass handle to child
                                        1       no inherit [interesting!]
                                F       0       use int 24h for errors
                                        1       disable int 24h for all
                                                I/O on this handle; use own
                                                error routine
                                W       0       no commit
                                        1       auto commit on all writes
        CX      create attribute
        DL      action if file exists/does not exists
                bits 7-4 action if file does not exist
                         0000   fail
                         0001   create
                bits 3-0 action if file exists
                         0000    fail
                         0001    open
                         0010    replace/open
        DH      0
        DS:SI   pointer to ASCIIZ file name
return  CF      set on error
                AX      error code
                clear
                AX      file handle
                CX      action taken
                        01h     file opened
                        02h     created/opened
                        03h     replaced/opened


89h  DOS_Sleep
 *   not documented by Microsoft
entry   AH      89h
return  unknown
note 1) Function included in Microsoft C 4.0 startup code MSDOS.INC
     2) Debugging shows that the first instruction on entry to DOS compares AH
        with 64h (at least in DOS 3.2) and aborts the call if AH > 64.
     3) Possibly used in European MSDOS 4.0?


Aftermarket Application Installed Function Calls:


0B6h, 0B8h, 0BBh, 0BCh, B0Eh, 0BFh, 0C0h, 0C1h, 0C2h, 0C3h, 0C4h, 0C5h, 0C6h,
0C7h, 0C8h, 0C9h, 0CAh, 0CBh, 0CCh, 0CDh, 0CEh, 0CFh, 0D0h, 0D1h, 0D2h, 0D3h,
0D4h, 0D5h, 0D6h, 0D7h, 0DAh, 0DBh
        Used by Novell NetWare


0DCh    Novell NetWare
        Get Station Number
entry   AH      0DCh
return  AL      station number
                00h     if NetWare not loaded or this machine is a non-
                        dedicated server


0DDh    Novell NetWare


0DEh    Novell NetWare
        Set Broadcast Mode

0DFh    Novell NetWare


0E0h    Novell NetWare


0E1h    Novell NetWare
        Broadcast Messages
entry   AH      E1h
        AL      00h     send broadcast message
                01h     get broadcase message
                02h-09h unknown

0E2h    Novell NetWare


0E3h    Novell NetWare
        Connection Control
entry   AH      E3h
        AL      00h-14h unknown
                15h     get object connection numbers
                16h     get connection information
                32h-47h unknown


E4h    DoubleDOS
        check status
entry   AX      00h
return  AL      <> 0 if DoubleDOS is active

0E4h    Novell NetWare


0E5h, 0E6h, 0E7h, 0E8h, 0E9h
        Novell NetWare


0EAh    DoubleDOS
        turn off task switching
entry   AX      EAh
return  task switching turned off


0EAh    Novell NetWare


0EBh    DoubleDOS
        turn on task switching
entry   AH      EBh
return  Task switching turned on


0EBh    Novell NetWare


0ECh    DoubleDOS
        get virtual screen address
entry   AH      ECh
return  ES      segment of virtual screen
note    Screen address can change if task switching is on!


0ECh    Novell NetWare


0EDh    Novell NetWare


0EEh    DoubleDOS
        give away time to other tasks
entry   AH      EEh
        AL      number of 55ms time slices to give away
return  Returns after giving away time slices


0EEh    Novell NetWare
        Get Node Address
entry   AH      EEh
return  CX:BX:AX = six-byte address


0EFh, 0F0h, 0F1h, 0F2h, 0F3h  Reportedly used by Novell NetWare.
        No parameters known


0FFh    CED   (CJ Dunford's DOS macro and command-line editor)
        CED installable commands
entry   AH      0FFh
        AL      00h     add installable command
                01h     remove installable command
                02h     reserved, may be used to test for CED installation
        BL      mode    bit 0 = 1 callable from DOS prompt
                        bit 1 = 1 callable from application
        DS:SI   pointer to cr-terminated command name
        ES:DI   pointer to far routine entry point
return  CF      set on error
        AX      01h     invalid function
                02h     command not found (subfunction 1 only)
                08h     insufficient memory (subfunction 0 only)
                0Eh     bad data (subfunction 0 only)
        AH      0FFh    if CED not installed

Chapter 5

 Programming Technical Reference - IBM
 Copyright 1988, Dave Williams

                        Interrupts 22h Through 86h


Interrupt 22h   Terminate Address
(0:0088h)
 This interrupt transfers control to the far (dword) address at this interrupt
location when an application program terminates. The default address for this
interrupt is 0:0088h through 0:008Bh. This address is copied into the program's
Program Segment Prefix at bytes 0Ah through 0Dh at the time the segment is
created and is restored from the PSP when the program terminates. The calling
program is normally COMMAND.COM or an application. Do not issue this interrupt
directly, as the EXEC function call does this for you. If an application
spawns a child process, it must set the Terminate Address prior to issuing the
EXEC function call, otherwise when the second program terminated it would
return to the calling program's Terminate Address rather than its own. This
address may be set with int 21, function 25h.



Interrupt 23h   Ctrl-Break Exit Address
(0:008Ch)
 If the user enters a Ctrl-Break during STDIN, STDOUT, STDPRN, or STDAUX, int
23h is executed. If BREAK is on, int 23h is checked on MOST function calls
(notably 06h). If the user written Ctrl-Break routine saves all registers, it
may end with a return-from-interrupt instruction (IRET) to continue program
execution. If the user-written interrupt program returns with a long return, the
carry flag is used to determine whether the program will be aborted. If the
carry flag is set, the program is aborted, otherwise execution continues (as
with a return by IRET). If the user-written Ctrl-Break interrupt uses function
calls 09h or 0Ah, then ctrl-C/CR/LF are output. If execution is continued with
an IRET, I/O continues from the start of the line. When the interrupt occurs,
all registers are set to the value they had when the original function call to
DOS was made. There are no restrictions on what the Ctrl-Break handler is
allowed to do, including DOS function calls, as long as the registers are
unchanged if an IRET is used. If the program creates a new segment and loads a
second program which itself changes the Ctrl-Break address, the termination of
the second program and return to the first causes the Ctrl-Break address to
be restored from the PSP to the value it had before execution of the second
program.



Interrupt 24h   Critical Error Handler
(0:0090h)
 When a critical error occurs within DOS, control is transferred to an error
handler with an int 24h. This may be the standard DOS error handler (ABORT,
RETRY, IGNORE) or a user-written routine.
 On entry to the error handler, AH will have its bit 7=0 (high order bit)
if the error was a disk error (probably the most common error), bit 7=1 if
not.
 BP:SI contains the address of a Device Header Control Block from which
additional information can be retrieved (see below).
 The register is set up for a retry operation and an error code is in the
lower half of the DI register with the upper half undefined. These are the
error codes:

 The user stack is in effect and contains the following from top to bottom:

        IP      DOS registers from issuing int 24h
        CS      int 24h
        flags
        AX      user registers at time of signal
        BX      int 21h request
        CX
        DX
        SI
        DI
        BP
        DS
        ES
        IP      from original int 21h
        CS
        flags

 To reroute the critical error handler to a user-writen critical error handler,
the following should be done:

Before an int 24h occurs:
1) The user application initialization code should save the int 24h vector and
   replace the vector with one pointing to the user error routine.

When the int 24h occurs:
2) When the user error routine received control it should push the flag
   registers onto the stack and execute a far call to the original int 24h
   vector saved in step 1.
3) DOS gives the appropriate prompt, and waits for user input (Abort, Retry,
   Ignore, Fail). After the user input, DOS returns control to the user error
   routine instruction following the far call.
4) The user error routine can now do any tasks nescessary. To return to the
   original application at the point the error occurred, the error routine needs
   to execute an IRET instruction. Otherwise, the user error routine should
   remove the IP, CS, and flag registers from the stack. Control can then be
   passed to the desired point.


 Int 24h provides the following values in registers on entry to interrupt
handler:

entry   AH      status byte
            bit 7       0       disk I/O hard error
                        1       other error - if block device, bad FAT
                                - if char device, code in DI
                6       unused
                5       0       if IGNORE is not allowed
                        1       if IGNORE is allowed
                4       0       if RETRY  is not allowed
                        1       if RETRY  is allowed
                3       0       if FAIL   is not allowed
                        1       if FAIL   is allowed
                2 \     disk area of error  00 = DOS area  01 = FAT
                1 /                         10 = root dir  11 = data area
                0       0       if read operation
                        1       if write operation
        AL      drive number if AH bit 7 = 1, otherwise undefined
                If it is as hard error on disk (AH bit 7=0), register AL
                contains the failing drive number (0=A:, 1=B:, etc.).
        BP:SI   address of a Device Header Control Block for which error
                occurred block device if high bit of BP:SI+4 = 1
 low byte of DI: error code (note: high byte is undefined)
               error code      description
                00h             attempt to write on write-protected diskette
                01h             unknown unit
                02h             drive not ready
                03h             unknown command
                04h             data error (bad CRC)
                05h             bad request structure length
                06h             seek error
                07h             unknown media type
                08h             sector not found
                09h             printer out of paper
                0Ah             write fault
                0Bh             read fault
                0Ch             general failure
                0Fh             invalid disk change (DOS 3.x)

handler must return

 The registers are set such that if an IRET is executed, DOS responds according
to (AL) as follows:
 AL     00h  ignore the error
        01h  retry the operation
        02h  terminate via int 22h
        03h  fail the system call that is in progress (DOS 3.2+)
note 1) Be careful when choosing to ignore a response because this causes DOS to
        beleive that an operation has completed successfully when it may not
        have.
     2) If the error was a character device, the contents of AL are invalid.



OTHER ERRORS

 If AH bit 7=1, the error occurred on a character device, or was the result of
a bad memory image of the FAT. The device header passed in BP:SI can be examined
to determine which case exists. If the attribute byte high-order bit indicates
a block device, then the error was a bad FAT. Otherwise, the error is on a
character device.
 If a character device is involved, the contents of AL are unpredictable, the
error code is in DI as above.

Notes:
1.  Before giving this routine control for disk errors, DOS performs several
    retries. The number of retries varies according to the DOS version.
2.  For disk errors, this exit is taken only for errors occurring during an
    int 21h function call. It is not used for errors during an int 25h or 26h.
3.  This routine is entered in a disabled state.
4.  All registers must be preserved.
5.  This interrupt handler should refrain from using DOS function calls. If
    necessary, it may use calls 01h through 12h. Use of any other call destroys
    the DOS stack and leaves DOS in an unpredictable state.
6.  The interrupt handler must not change the contents of the device header.
7.  If the interrupt handler handles errors itself rather than returning to DOS,
    it should restore the application program's registers from the stack,
    remove all but the last three words on the stack, then issue an IRET. This
    will return to the program immediately after the int 21h that experienced
    the error. Note that if this is done DOS will be in an unstable state until
    a function call higher than 12h is issued, therefore not recommended.
8.  For DOS 3.x, IGNORE requests (AL=0) are converted to FAIL for critical
    errors that occur on FAT or DIR sectors.
9.  For DOS 3.10 up, IGNORE requests (AL=0) are converted to FAIL requests
    for network critical errors (50-79).

The device header pointed to by BP:SI is as follows:

DWORD Pointer to next device (0FFFFh if last device)

WORD Attributes:

Bit     15      1       if character device.
                        If bit 15 is 1:
                        Bit 0 = 1 if current standard input
                        Bit 1 = 1 if current standard output
                        Bit 2 = 1 if current NULL device
                        Bit 3 = 1 if current CLOCK device
                0       if block device
Bit 14 is the IOCTL bit
WORD pointer to device driver strategy entry point
WORD pointer to device driver interrupt entry point
8-BYTE character device named field for block devices. The first byte is the
number of units.
 To tell if the error occurred on a block or character device, look at bit 15
in the attribute field (WORD at BP:SI+4).
 If the name of the character device is desired, look at the eight bytes
starting at BP:SI+10.


HANDLING OF INVALID RESPONSES (DOS 3.x)

        A) If IGNORE (AL=0) is specified by the user and IGNORE is not allowed
           (bit 5=0), make the response FAIL (AL=3).
        B) If RETRY (AL=1) is specified by the user and RETRY is not allowed
           (bit 4=0), make the response FAIL (AL=3).
        C) If FAIL (AL=3) is specified by the user and FAIL is not allowed (bit
           3=0), make the response ABORT. (AL=2)




Interrupt 25h   Absolute Disk Read
Interrupt 26h   Absolute Disk Write
(0:0094h, 0:0098h)
  These transfer control directly to the device driver. On return, the original
flags are still on the stack (put there by the INT instruction). This is
necessary because return information is passed back in the current flags.
  The number of sectors specified is transferred between the given drive and the
transfer address. Logical sector numbers are obtained by numbering each sector
sequentially starting from track 0, head 0, sector 1 (logical sector 0) and
continuing along the same head, then to the next head until the last sector on
the last head of the track is counted.  Thus, logical sector 1 is track 0, head
0, sector 2; logical sector 2 is track 0, head 0, sector 3; and so on. Numbering
then continues wih sector 1 on head 0 of the next track. Note that although the
sectors are sequentially numbered (for example, sectors 2 and 3 on track 0 in
the example above), they may not be physically adjacent on disk, due to
interleaving. Note that the mapping is different from that used by DOS 1.10 for
dual-sided diskettes.

The request is as follows:

int 25 for Absolute Disk Read,
int 26 for Absolute Disk Write
entry   AL      drive number (0=A:, 1=B:, etc)
        CX      number of sectors to read
        DS:BX   disk transfer address (buffer)
        DX      first relative sector to read - beginning logical sector number
return  CF      set if error
        AL      error code issued to int 24h in low half of DI
        AH      01h     bad command
                02h     bad address mark
                03h     write-protected disk
                04h     requested sector not found
                08h     DMA failure
                10h     data error (bad CRC)
                20h     controller failed
                40h     seek operation failed
                80h     attachment failed to respond
note 1) Original flags on stack! Be sure to pop the stack to prevent
        uncontrolled growth
     2) Ints 25 and 26 will try rereading a disk if they get an error the first
        time.
     3) All registers except the segment registers are destroyed by these calls



Interrupt 27h   Terminate And Stay Resident
(0:009Ch)       (obsolete)
 This vector is used by programs that are to remain resident when COMMAND.COM
regains control.
 After initializing itself, the program must set DX to its last address plus
one relative to the program's initial DS or ES value (the offset at which other
programs can be loaded), then execute interrupt 27h. DOS then considers the
program as an extension of itself, so the program is not overlaid when other
programs are executed. This is useful for loading programs such as utilities
and interrupt handlers that must remain resident.

entry   CS      current program segment
        DX      last program byte + 1
return  none
note 1) This interrupt must not be used by .EXE programs that are loaded into
        the high end of memory.
     2) This interrupt restores the interrupt 22h, 23h, and 24h vectors in the
        same manner as interrupt 20h.  Therefore, it cannot be used to install
        permanently resident Ctrl-Break or critical error handler routines.
     3) The maximum size of memory that can be made resident by this method is
        64K.
     4) Memory can be more efficiently used if the block containing a copy of
        the environment is deallocated before terminating. This can be done by
        loading ES with the segment contained in 2Ch of the PSP, and issuing
        function call 49h (Free Allocated Memory).
     5) DOS function call 4Ch allows a program to pass a completion code to DOS,
        which can be interpreted with processing (see function call 31h).
     6) Terminate and stay resident programs do not close files.
     7) Int 21, function 31h is the preferred method to cause a program to
        remain resident because this allows return information to be passed and
        allows a program larger than 64K to remain resident.



Interrupt 28h   (not documented by Microsoft)
           *    DOS Idle Interrupt
 This interrupt is continuously called by DOS itself whenever it is in a wait
state (i.e., when it is waiting for keyboard input) during a function call of
01h through 0Ch. DOS uses 3 separate internal stacks: one for calls 01h through
0Ch; another for calls 0Dh and above; and a third for calls 01h through 0Ch when
a Critical Error is in progress. When int 28h is called, any calls above 0Ch can
be executed without destroying the internal stack used by DOS at the time.
 It is used primarily by the PRINT.COM routines, but any number of other
routines can be chained to it by saving the original vector and calling it with
a FAR call (or just JMPing to it) at the end of the new routine.
 Int 28h is being issued it is usually safe to do DOS calls. You won't get int
28hs if a program is running that doesn't do its keyboard input through DOS. You
should rely on the timer interrupt for these.
 Int 28h is not called at all when any non-trivial foreground task is running.
As soon as a foreground program has a file open, INT28 no longer gets called.
Could make a good driver for for abackground program that really works as long
as there is nothing else going on in the machine.

entry   no parameters availible
return  none
note 1) The int 28h handler may invoke any int 21h function except functions
        00h through 0Ch (and 50h/51h under DOS 2.x).
     2) Apparently int 28h is also called during screen writes
     3) Until some program installs its own routine, this interrupt vector
        simply points to an IRET opcode.
     4) Supported in OS/2 1.0's DOS Compatibility Box


Interrupt 29h   (not documented by Microsoft)
           *    Internal - Quick Screen Output

 This method is extremely fast (much faster than DOS 21h subfunctions 2 and 9,
for example), and it is portable, even to "non-compatible" MS-DOS computers.

entry   AL      character to output to screen
return  unknown
note 1) Documented by Digital Research's DOS Reference as provided with the
        DEC Rainbow
     2) If ANSI.SYS is installed, character output is filtered through it.
     3) Works on the IBM PC and compatibles, Wang PC, HP-150 and Vectra, DEC
        Rainbow, NEC APC, Texas Instruments PC and others
     4) This interrupt is called from the DOS's output routines if output is
        going to a device rather than a file, and the device driver's attribute
        word has bit 3 (04h) set to "1".
     5) This call has been tested with MSDOS 2.11, PCDOS 2.1, PCDOS 3.1, PCDOS
        3.2, and PCDOS 3.3.
     6) Used in IBMBIO.COM as a vector to int 10, function 0Eh (write TTY)
        followed by an IRET.



Interrupt 2Ah   Microsoft Networks - Session Layer Interrupt
           *    (not documented by Microsoft)

entry   AH      00h     check to see if network BIOS installed
                        return: AH      <> 0 if installed
                01h     execute NETBIOS request
                02h     set net printer mode
                03h     get shared-device status (check direct I/O)
                        AL      00h
                        DS:SI   pointer to ASCIIZ disk device name
                        return  CF      0 if allowed
                04h     execute NETBIOS
                        AL      0 for error retry
                                1 for no retry
                        ES:BX   pointer to ncb
                        return  AX      0 for no error
                                AH      1 if error
                                AL      error code
                05h     get network resource information
                        AL      00h
                        return  AX      reserved
                                BX      number of network names
                                CX      number of commands
                                DX      number of sessions
                82h     unknown
                        return  ??
note    called by the int 21h function dispatcher in DOS 3.10


Interrupt 2Bh   (not documented by Microsoft)
           *    Unknown - Internal Routine for DOS (IRET)


Interrupt 2Ch   (not documented by Microsoft)
           *    Unknown - Internal Routine for DOS (IRET)


Interrupt 2Dh   (not documented by Microsoft)
           *    Unknown - Internal Routine for DOS (IRET)


Interrupt 2Eh   (undocumented by Microsoft)
           *    Internal Routine for DOS  (Alternate EXEC)

  This interrupt passes a command line addressed by DS:SI to COMMAND.COM. The
command line must be formatted just like the unformatted parameter area of a
Program Segment Prefix. That is, the first byte must be a count of characters,
and the second and subsequent bytes must be a command line with parameters,
terminated by a carriage return character.
  When executed, int 2Eh will reload the transient part of the command
interpreter if it is not currently in memory. If called from a program that
was called from a batch file, it will abort the batch file. If executed from a
program which has been spawned by the EXEC function, it will abort the whole
chain and probably lock up the computer. Int 2Eh also destroys all registers
including the stack pointer.
  Int 2Eh is called from the transient portion of the program to reset the DOS
PSP pointers using the above Functions #81 & #80, and then reenters the
resident program.
  When called with a valid command line, the command will be carried out by
COMMAND.COM just as though you had typed it in at the DOS prompt. Note that the
count does not include the carriage return. This is an elegant way to perform a
SET from an application program against the master environment block for
example.

entry   DS:SI   pointer to an ASCIIZ command line in the form:
                        count byte
                        ASCII string
                        carriage return
                        null byte
note 1) Destroys all registers including stack pointer
     2) Seems to work OK in both DOS 2.x and 3.x
     3) It is reportedly not used by DOS.
     4) As far as known, int 2Eh is not used by DOS 3.1, although it was called
        by COMMAND.COM of PCDOS 3.0, so it appears to be in 3.1 only for the
        sake of compatibility.



Interrupt 2Fh   Multiplex Interrupt

 Interrupt 2Fh is the multiplex interrupt. A general interface is defined
between two processes. It is up to the specific application using interrupt
2Fh to define specific functions and parameters.
 Every multiplex interrupt handler is assigned a specific multiplex number.
The multiplex number is specified in the AH register; the AH value tells which
program your request is directed toward. The specific function that the handler
is to perform is placed in the AL register. Other parameters are places in the
other registers as needed. The handlers are chained into the 2Fh interrupt
vector and the multiplex number is checked to see if any other application is
using the same multiplex number. There is no predefined method for assigning a
multiplex number to a handler. You must just pick one. To avoid a conflict if
two applications choose the same multiplex number, the multiplex numbers used by
an application should be patchable. In order to check for a previous
installation of the current application, you can search memory for a unique
string included in your program. If the value you wanted in AH is taken but
you don't find the string, then another application has grabbed that location.
 Int 2Fh was not documented under DOS 2.x. There is no reason not to use int 2Fh
as the multiplex interrupt in DOS 2.x. The only problem is that DOS does not
initialize the int 2Fh vector, so when you try to chain to it like you are
supposed to, it will crash. But if your program checks the vector for being zero
and doesn't chain in that case, it will work for you in 2.x just the same as
3.x.
 Int 2Fh doesn't require any support from DOS itself for it to be used in
application programs. It's not handled by DOS, but by the programs themselves.
The only support DOS has to provide is to initialize the vector to an IRET. DOS
3.2 does itself contain some int 2Fh handlers - it uses values of 08h, 13h, and
0F8h. There may be more.


entry   AH      01h     PRINT.COM
                AL      00h     PRINT  Get Installed State
                        This call must be defined by all int 2Fh handlers. It
                        is used by the caller of the handler to determine if
                        the handler is present. On entry, AL=0. On return, AL
                        contains the installed state as follows:
                return  AL      0FFh    installed
                                01h     not installed, not OK to install
                                00h     not installed, OK to install


                        01h     PRINT  Submit File
                        DS:DX   pointer to submit packet
                                format  BYTE    level
                                        DWORD   pointer to ASCIIZ filename
                return  CF      set if error
                                AX      error code
                note 1) A submit packet contains the level (BYTE) and a pointer
                        to the ASCIIZ string (DWORD in offset:segment form).
                        The ASCIIZ string must contain the drive, path, and
                        filename of the file you want to print. The filename
                        cannot contain global filename characters.
                return  CF      set if error
                                AX      error code

                        02h     PRINT Cancel File
                        On entry, AL=2 and DS:DX points to the ASCIIZ string for
                        the print file you want to cancel. Global filename
                        characters are allowed in the filename.
                DS:DX   pointer to ASCIIZ file name to cancel (wildcards OK)
                return  CF      set if error
                                AX      error code

                        03h     PRINT remove all files
                return  CF      set if error
                                AX      error code

                        04h     PRINT hold queue/get status
                        This call holds the jobs in the print queue so that you
                        can scan the queue. Issuing any other code releases the
                        jobs. On entry, AL=4. On return, DX contains the error
                        count. DS:SI points to the print queue. The print queue
                        consists of a series of filename entries. Each entry is
                        64 bytes long. The first entry in the queue is the file
                        currently being printed. The end of the queue is marked
                        by the entry having a null as the first character.
               return   DX      error count
                        DS:SI   pointer to print queue (null-string terminated
                                list of 64-byte ASCIIZ filenames)
                        CF      set if error
                               AX       error code
                                        01h     function invalid
                                        02h     file not found
                                        03h     path not found
                                        04h     too many open files
                                        05h     access denied
                                        08h     queue full
                                        09h     spooler busy
                                        0Ch     name too long
                                        0Fh     drive invalid

                        05h     PRINT restart queue
                return  CF      set if error
                                AX      error code

        AH      05h     DOS 3.x critical error handler
                AL      00h     installation check
                        return  AL      00h not installed, OK to install
                                        01h not installed, can't install
                                        0FFh installed
                        note    This set of functions allows a user program to
                                partially or completely override the default
                                critical error handler in COMMAND.COM
                AL      01h     handle error - nonzero error code in AL
                        return  CF      clear
                                        ES:DI   pointer to ASCIIZ error message
                                CF      set     use default error handler
                                AL      (?)

        AH      06h     ASSIGN
                        00h     installation check
                        return  AH <> 0 if installed

                        01h     get memory segment
                        return  ES      segment of ASSIGN work area

        AH      10h     SHARE
                        00h     installation check
                        return  AL      00h    not installed, OK to install
                                        01h    not installed, not OK to install
                                        0FFh   installed

        AH      11h     multiplex - network redirection
                        00h     installation check
                        return  AL      00h    not installed, OK to install
                                        01h    not installed, not OK to install
                                        0FFh   installed
                        01h     unknown
                        02h     unknown
                        03h     unknown
                        04h     unknown
                        05h     unknown
                        06h     close remote file
                        07h     unknown
                        08h     unknown
                        09h     unknown
                        0Ah     unknown
                                STACK: WORD (?)
                                return  CF      set on error
                        0Bh     unknown
                                STACK: WORD (?)
                                return  CF      set on error(?)
                        0Ch     unknown
                        0Dh     unknown
                        0Eh     unknown
                                STACK: WORD (?)
                                return  (?)
                        0Fh     unknown
                        11h     unknown
                        13h     unknown
                        16h     unknown
                        17h     unknown
                                STACK: WORD (?)
                                return  (?)
                        18h     unknown
                                STACK: WORD (?)
                                return  (?)
                        19h     unknown
                        1Bh     unknown
                        1Ch     unknown
                        1Dh     unknown
                        1Eh     do redirection
                                STACK: WORD function to execute
                                return  CF      set on error
                        1Fh     printer setup
                                STACK: WORD function(?)
                                return  CF      set on error(?)
                        20h     unknown
                        21h     unknown
                        22h     unknown
                        23h     unknown
                        24h     unknown
                        25h     unknown
                                STACK: WORD (?)
                        26h     unknown

        AH      12h     multiplex, DOS 3.x internal services
                        00h     installation check
                        return  AL      0FFh    for compatibility with other
                                                int 2Fh functions
                        01h     close file (?)
                                stack   word value - unknown
                                return  BX      unknown
                                        CX      unknown
                                        ES:DI   pointer to unknown value
                                note    Can be called only from within DOS
                        02h     get interrupt address
                                stack: word vector number
                                return  ES:BX pointer to interrupt vector
                                        Stack unchanged
                        03h     get DOS data segment
                                return  DS      segment of IBMDOS
                        04h     normalize path separator
                                stack: word character to normalize
                                return  AL      normalized character (forward
                                                slash turned to backslash)
                                        Stack unchanged
                        05h     output character
                                stack: word character to output
                                return  Stack unchanged
                                note    Can be called only from within DOS
                        06h     invoke critical error
                                return  AL      0-3 for Abort, Retry, Ignore,
                                                Fail
                                note    Can be called only from within DOS
                        07h     move disk buffer (?)
                                DS:DI   pointer to disk buffer
                                return  buffer moved to end of buffer list
                                note    Can be called only from within DOS
                        08h     decrement word
                                ES:DI   pointer to word to decrement
                                return  AX      new value of word
                                note    Word pointed to by ES:DI decremented,
                                        skipping zero
                        09h     unknown
                                DS:DI   pointer to disk buffer(?)
                                return  (?)
                                note    Can be called only from within DOS
                        0Ah     unknown
                                note    Can be called only from within DOS
                        0Bh     unknown
                                ES:DI   pointer to system file table entry(?)
                                return  AX      (?)
                                note    Can be called only from within DOS
                        0Ch     unknown
                                note    Can be called only from within DOS
                        0Dh     get date and time
                                return  AX      current date in packed format
                                        DX      current time in packed format
                                note    Can be called only from within DOS
                        0Eh     do something to all disk buffers (?)
                                return  DS:DI   pointer to first disk buffer
                                note    can be called only from within DOS
                        0Fh     unknown
                                DS:DI   pointer to (?)
                                return  DS:DI pointer to (?)
                                note 1) Can be called only from within DOS
                                     2) Calls on function 1207h
                        10h     find dirty/clean(?) buffer
                                DS:DI   pointer to first disk buffer
                                return  DS:DI   pointer to first disk buffer
                                                which has (?) flag clear
                                        ZF      clear if found
                                                set if not found
                        11h     normalize ASCIIZ filename
                                DS:SI   pointer to ASCIZ filename to normalize
                                ES:DI   ptr to buffer for normalized filename
                                return  destination buffer filled with upper-
                                        case filename, with slashes turned to
                                        backslashes
                        12h     get length of ASCIIZ string
                                ES:DI   pointer to ASCIZ string
                                return  CX      length of string
                        13h     uppercase character
                                stack: word character to convert to uppercase
                                return  AL      uppercase character
                                        Stack unchanged
                        14h     compare far pointers
                                DS:SI   first pointer
                                ES:DI   second pointer
                                return  ZF      set if pointers are equal
                                        ZF      clear if not equal
                        15h     unknown
                                DS:DI   pointer to disk buffer
                                stack: word (?)
                                return  Stack unchanged
                                note    Can be called only from within DOS
                        16h     get address of system FCB
                                BX      system file table entry number
                                return  ES:DI pointer to system file table entry
                        17h     set default drive (?)
                                stack: word drive (0 = A:, 1 = B:, etc)
                                return  DS:SI   pointer to drive data block for
                                                specified drive
                                        Stack unchanged
                                note    Can be called only from within DOS
                        18h     get something (?)
                                return  DS:SI pointer to (?)
                        19h     unknown
                                stack: word drive (0 = default, 1 = A:, etc)
                                return  (?)
                                        Stack unchanged
                                note 1) Can be called only from within DOS
                                     2) Calls function 1217h
                        1Ah     get file's drive
                                DS:SI   pointer to filename
                                return  AL      drive
                                        (0=default, 1=A:, etc, 0FFh=invalid)
                        1Bh     set something (?)
                                CL      unknown
                                return  AL      (?)
                                note    Can be called only from within DOS
                        1Ch     checksum memory
                                DS:SI   pointer to start of memory to checksum
                                CX      number of bytes
                                DX      initial checksum
                                return  DX      checksum
                                note    Can be called only from within DOS
                        1Dh     unknown
                                DS:SI   pointer to (?)
                                CX      (?)
                                DX      (?)
                                return  AX      (?)
                                        CX      (?)
                                        DX    = (?)
                        1Eh     compare filenames
                                DS:SI   pointer to first ASCIIZ filename
                                ES:DI   pointer to second ASCIIZ filename
                                return  ZF      set     if filenames equivalent
                                                clear   if not
                        1Fh     build drive info block
                                stack: word drive letter
                                return  ES:DI pointer to drive info block
                                              (will be overwritten by next call)
                                        Stack unchanged
                                note    Can be called only from within DOS
                        20h     get system file table number
                                BX      file handle
                                return  CF set on error
                                        AL      6 (invalid file handle)
                                        CF      clear if successful
                                        byte ES:[DI] = system file table entry
                                            number for file handle
                        21h     unknown
                                DS:SI   pointer to (?)
                                return  (?)
                                note    Can be called only from within DOS
                        22h     unknown
                                SS:SI   pointer to (?)
                                return  nothing(?)
                                note    Can be called only from within DOS
                        23h     check if character device (?)
                                return  DS:SI   pointer to device driver with
                                                same name as (?)
                                note    Can be called only from within DOS
                        24h     delay
                                return  after delay of (?) ms
                                note    Can be called only from within DOS
                        25h     get length of ASCIIZ string
                                DS:SI   pointer to ASCIIZ string
                                return  CX      length of string

        AH      43h     Microsoft Extended Memory Specification (XMS)

        AH      64h     SCRNSAV2.COM
                AL      00h     installation check
                        return  AL      00h     not installed
                                        0FFh    installed
                        note    SCRNSAV2.COM is a screen saver for PS/2's with
                                VGA by Alan Ballard

        AH      7Ah     Novell NetWare
                AL      00h     installation check
                        note    Returns address of entry point for IPX and SPX

        AH      0AAh    VIDCLOCK.COM
                AL      00h     installation check
                        return  AL      00h     not installed
                                        0FFh    installed
                        note    VIDCLOCK.COM is a memory-resident clock by
                                Thomas G. Hanlin III

        AH      0B7h    APPEND
                AL      00h     APPEND installation check
                                return  AH <> 0 if installed
                        01h     APPEND - unknown
                        02h     APPEND - version check

        AH      0B8h    Microsoft Networks
                AL      00h     network program installation check
                        return  AH <> 0 if installed
                                BX      installed component flags (test in this
                                        order!)
                                bit 6   server
                                bit 2   messenger
                                bit 7   receiver
                                bit 3   redirector
                        01h     unknown
                        02h     unknown
                        03h     get current POST address
                        return  ES:BX   POST address
                        04h     set new POST address
                        ES:BX   new POST address
                        09h     version check

        AH      0BBh    Network functions
                AL      00h     net command installation check
                        03h     get server POST address
                        04h     get server POST address

        AH      0F7h    AUTOPARK.COM  (PD TSR hard disk parking utility)
                AL      00h     installation check
                        return  AL      00h     not installed
                                        0FFh    installed
                        note    AUTOPARK is a TSR HD parker by Alan D. Jones
                        01h     set parking delay
                        BX:CX   32 bit count of 55ms timer ticks

return  AX      Error
                Codes       Description
                01h     invalid function number
                02h     file not found
                03h     path not found
                04h     too many open files
                05h     access denied
                06h     invalid handle
                08h     queue full
                09h     busy
                0Ch     name too long
                0Fh     invalid drive was specified
        CF      clear (0) if OK
                set (1) if error - error returned in AX
note 1) The multiplex numbers AH=0h through AH=7Fh are reserved for DOS.
        Applications should use multiplex numbers 80h through 0FFh.
     2) When in the chain for int 2Fh, if your code calls DOS or if you execute
        with interrupts enabled, your code must be reentrant/recursive.



Interrupt 30h   (not a vector!) far jump instruction for CP/M-style calls


Interrupt 31h   Unknown
note    The CALL 5 entry point does a FAR jump to here


Interrupt 32h   Unknown




Interrupt 33h   Used by Microsoft Mouse Driver
                Function Calls

        00h     Reset Driver and Read Status
        entry   AH      00h
        return  AH      status
                        0  hardware/driver not installed
                        -1 hardware/driver installed
                BX      number of buttons
                        -1      two buttons
                        0       other than two
                        3       Mouse Systems mouse

        01h     Show Mouse Cursor
        entry   AH      01h
        return  unknown

        02h     Hide Mouse Cursor
        entry   AH      02h
        return  unknown
        note    multiple calls to hide the cursor will require multiple calls
                to function 01h to unhide it.

        03h     Return Position and Button Status
        entry   AH      03h
        return  BX      button status
                        bit 0   left button pressed if 1
                        bit 1   right button pressed if 1
                        bit 2   middle button pressed if 1 (Mouse Systems mouse)
                CX      column
                DX      row

        04h     Position Mouse Cursor
        entry   AH      04h
                CX      column
                DX      row
                return  unknown

        05h     Return Button Press Data
        entry   AH      05h
                BX      button
                        0 left
                        1 right
                        2 middle (Mouse Systems mouse)
        return  AH      button states
                        bit 0   left button pressed if 1
                        bit 1   right button pressed if 1
                        bit 2   middle button pressed if 1 (Mouse Systems mouse)
                BX      no. of times specified button pressed since last call
                CX      column at time specified button was last pressed
                DX      row at time specified button was last pressed

        06h     Return Button Release Data
        entry   AH      06h
                BX      button
                        0       left
                        1       right
                        2       middle (Mouse Systems mouse)
        return  AH      button states
                        bit 0   left button pressed if 1
                        bit 1   right button pressed if 1
                        bit 2   middle button pressed if 1 (Mouse Systems mouse)
                BX      no. of times specified button released since last call
                CX      column at time specified button was last released
                DX      row at time specified button was last released

        07h     Define Horizontal Curos Range
        entry   AH      0007h
                CX      minimum column
                DX      maximum column
        return  unknown

        08h     Define Vertical Cursor Range
        entry   AH      08h
                CX      minimum row
                DX      maximum row
                return  unknown

        09h     Define Graphics Cursor
        entry   AH      09h
                BX      column of cursor hot spot in bitmap (-16 to 16)
                CX      row of cursor hot spot  (-16 to 16)
                ES:DX   pointer to bitmap
                        16 words screen mask
                        16 words cursor mask
                return  unknown
                note    Each word defines the sixteen pixels of a row, low bit
                        rightmost

        0Ah     Define Text Cursor
        entry   AH      0Ah
                BX      hardware/software text cursor
                        00h     software
                                CX      screen mask
                                DX      cursor mask
                        01h     hardware
                                CX      start scan line
                                DX      end scan line
        return  unknown
        note    When the software cursor is selected, the char/attribute data
                at the current screen position is ANDed with the screen mask
                and the with the cursor mask

        0BH     Read Motion Counters
        entry   AH      0Bh
        return  CX      number of mickeys mouse moved horiz. since last call
                DX      number of mickeys mouse moved vertically
        note 1) A mickey is the smallest increment the mouse can sense.
                Positive values indicate up/right

        0Ch     Define Interrupt Subroutine Parameters
        entry   AH      0Ch
                CX      call mask bit
                        bit 0   call if mouse moves
                        bit 1   call if left button pressed
                        bit 2   call if left button released
                        bit 3   call if right button pressed
                        bit 4   call if right button released
                        bit 5   call if middle button pressed (Mouse Systems)
                        bit 6   call if middle button released (Mouse Systems)
                ES:DX  address of FAR routine
        return  unknown
        note    when the subroutine is called, it is passed these values:
                AH      condition mask (same bit assignments as call mask)
                BX      button state
                CX      cursor column
                DX      cursor row
                DI      horizontal mickey count
                SI      vertical mickey count

        0Dh     Light Pen Emulation On
        entry   AH      0Dh
        return  unknown

        0Eh     Light Pen Emulation Off
        entry   AH      0Eh
        return  unknown

        0Fh     Define Mickey/Pixel Ratio
        entry   AH      0Fh
                CX      number of mickeys per 8 pixels horizontally
                DX      number of mickeys per 8 pixels vertically
        return  unknown

        10h     Define Screen Region for Updating
        entry   AH      10h
                CX,DX   X,Y coordinates of upper left corner
                SI,DI   X,Y coordinates of lower right corner
        return  unknown
        note    Mouse cursor is hidden during updating, and needs to be
                explicitly turned on again

        11h     not documented by Microsoft

        12h     Set Large Graphics Cursor Block
                AH      12h
                BH      cursor width in words
                CH      rows in cursor
                BL      horizontal hot spot (-16 to 16)
                CL      vertical hot spot (-16 to 16)
                ES:DX   pointer to bit map of screen and cursor maps
        return  AH      -1 if successful
        note    PC Mouse. Not dodcumented by Microsoft

        13h     Define Double-Speed Threshold
        entry   AH      13h
                DX      threshold speed in mickeys/second,
                        0 = default of 64/second
        return  unknown
        note    If speed exceeds threshold, the cursor's on-screen motion
                is doubled

        14h     Exchange Interrupt Subroutines
        entry   AH      14h
        return  unknown

        15h     Return Drive Storage Requirements
        entry   AH      15h
        return  BX      size of buffer needed to store driver state

        16h     Save Driver State
        entry   AH      16h
                ES:DX   pointer to buffer
        return  unknown

        17h     Restore Driver State
        entry   AH      17h
                ES:DX   pointer to buffer containing saved state
        return  unknown

        18h     not documented by Microsoft

        19h     not documented by Microsoft

        1Ah     not documented by Microsoft

        1Bh     not documented by Microsoft

        1Ch     not documented by Microsoft

        1Dh     Define Display Page Number
        entry   AH      1Dh

        1Eh     Return Display Page Number
        entry   AH      1Eh
        return  unknown

        42h     PCMouse - Get MSmouse Storage Requirements
                AH      42h
                return  AX      0FFFFh successful
                BX      buffer size in bytes for functions 50h and 52h
                        00h     MSmouse not installed
                        42h     functions 42h, 50h, and 52h not supported

        52h     PCMouse - Save MSmouse State
        entry   AH      50h
                BX      buffer size
                ES:DX   pointer to buffer
                return  AX      0FFFFh if successful

        52h     PCMouse - restore MSmouse state
        entry   AH      52h
                BX      buffer size
                ES:DX   pointer to buffer
                return  AX      0FFFFh if successful


Int 33: In addition, the following functions are appended to BIOS int 10h and
        implemented as the EGA Register Interface Library:

        0F0h    read one register
        0F1h    write one register
        0F2h    read consecutive register range
        0F3h    write consecutive register range
        0F4h    read non-consecutive register set
        0F5h    write non-consecutive register set
        0F6h    revert to default register values
        0F7h    define default register values
        0FAh    get driver status



Interrupt 34h   Turbo C/Microsoft languages - Floating Point emulation
                This interrupt emulates opcode 0D8h

Interrupt 35h   Turbo C/Microsoft languages - Floating Point emulation
                This interrupt emulates opcode 0D9h

Interrupt 36h   Turbo C/Microsoft languages - Floating Point emulation
                This interrupt emulates opcode 0DAh

Interrupt 37h   Turbo C/Microsoft languages - Floating Point emulation
                This interrupt emulates opcode 0DBh

Interrupt 38h   Turbo C/Microsoft languages - Floating Point emulation
                This interrupt emulates opcode 0DCh

Interrupt 39h   Turbo C/Microsoft languages - Floating Point emulation
                This interrupt emulates opcode 0DDh

Interrupt 3Ah   Turbo C/Microsoft languages - Floating Point emulation
                This interrupt emulates opcode 0DEh

Interrupt 3Bh   Turbo C/Microsoft languages - Floating Point emulation
                This interrupt emulates opcode 0DFh

Interrupt 3Ch   Turbo C/Microsoft languages - Floating Point emulation
                This int emulates instructions with an ES segment override

Interrupt 3Dh   Turbo C/Microsoft languages - Floating Point emulation
                This interrupt emulates a standalone FWAIT instruction

Interrupt 3Eh   Turbo C/Microsoft languages - Floating Point emulation

Interrupt 3Fh   Overlay manager interrupt (Microsoft LINK.EXE)

Interrupt 40h   Hard Disk BIOS
                Pointer to disk BIOS entry when a hard disk controller is
                installed. The BIOS routines use int 30h to revector the
                diskette handler (original int 13h) here so int 40 may be used
                for hard disk control

Interrupt 41h   Hard Disk Parameters  (XT,AT,XT2,XT286,PS except ESDI disks)
                Pointer to first Hard Disk Parameter Block, normally located
                in the controller card's ROM. This table may be copied to RAM
                and changed, and this pointer revectored to the new table.
note 1) format of parameter table is:
        dw      cylinders
        db      heads
        dw      starting reduced write current cylinder (XT only, 0 for others)
        db      maximum ECC burst length
        db      control byte
                  bits 0-2 drive option (XT only, 0 for others)
                  bit 3    set if more than 8 heads
                  bit 4    always 0
                  bit 5    set if manufacturer's defect map on max cylinder+1
                  bit 6    disable ECC retries
                  bit 7    disable access retries
        db      standard timeout (XT only, 0 for others)
        db      formatting timeout (XT only, 0 for others)
        db      timeout for checking drive (XT only, 0 for others)
        dw      landing zone    (AT, PS/2)
        db      sectors/track   (AT, PS/2)
        db      0
     2) normally vectored to ROM table when system is initialized.


Interrupt 42h   Pointer to screen BIOS entry  (EGA, VGA, PS/2)
                Relocated (by EGA, etc.) video handler (original int 10h).
                Revectors int 10 calls to EGA BIOS.


Interrupt 43h   Pointer to EGA initialization parameter table. The POST
                initializes this vector pointing to the default table located
                in the EGA ROM BIOS. (PC-2 and up). Not initialized if EGA not
                present.


Interrupt 44h   Pointer to EGA graphics character table (also PCjr). This
(0:0110h)       table contains the dot patterns for the first 128 characters
                in video modes 4,5, and 6, and all 256 characters in all
                additional graphics modes. Not initialized if EGA not present.
             2) EGA/VGA/CONV/PS - EGA/PCjr fonts, characters 00h to 7Fh
             3) Novell NetWare - High-Level Language API


Interrupt 45h   Reserved by IBM  (not initialized)

Interrupt 46h   Pointer to second hard disk, parameter block (AT, XT/286, PS/2)
                (see int 41h) (except ESDI hard disks) (not initialized unless
                specific user software calls for it)

Interrupt 47h   Reserved by IBM  (not initialized)

Interrupt 48h   Cordless Keyboard Translation (PCjr, XT [never delivered])
(0:0120h)       This vector points to code to translate the cordless keyboard
                scancodes into normal 83-key values. The translated scancodes
                are then passed to int 9. (not initialized on PC or AT)

Interrupt 49h   Non-keyboard Scan Code Translation Table Address (PCjr)
(0:0124h)       This interrupt has the address of a table used to translate
                non-keyboard scancodes (greater than 85 excepting 255). This
                interrupt can be revectored by a user application. IBM
                recommends that the default table be stored at the beginning
                of an application that required revectoring this interrupt,
                and that the default table be restored when the application
                terminates. (not initialized on PC or AT)

Interrupt 4Ah   Real-Time Clock Alarm (Convertible, PS/2)
                (not initialized on PC or AT)
                Invoked by BIOS when real-time clock alarm occurs

Interrupt 4Bh   Reserved by IBM  (not initialized)

Interrupt 4Ch   Reserved by IBM  (not initialized)

Interrupt 4Dh   Reserved by IBM  (not initialized)

Interrupt 4Eh   Reserved by IBM  (not initialized)

Interrupt 4Fh   Reserved by IBM  (not initialized)

Interrupt 50-57 IRQ0-IRQ7 relocated by DesQview
                (normally not initialized)

Interrupt 58h   Reserved by IBM  (not initialized)

Interrupt 59h   Reserved by IBM  (not initialized)
                GSS Computer Graphics Interface (GSS*CGI)
                DS:DX   Pointer to block of 5 array pointers
                return  CF      0
                        AX      return code
                        CF      1
                        AX      error code
                note 1) Int 59 is the means by which GSS*CGI language bindings
                        communicate with GSS*CGI device drivers and the GSS*CGI
                        device driver controller.
                     2) Also used by the IBM Graphic Development Toolkit

Interrupt 5Ah   Reserved by IBM  (not initialized)

Interrupt 5Bh   Reserved by IBM  (not initialized)

Interrupt 5Ah   Cluster Adapter BIOS entry address
                (normally not initialized)

Interrupt 5Bh   Reserved by IBM  (not initialized) (cluster adapter?)

Interrupt 5Ch   NETBIOS interface entry port
                ES:BX   pointer to network control block
note 1) When the NETBIOS is installed, interrupts 13 and 17 are interrupted by
        the NETBIOS; interrupt 18 is moved to int 86 and one of int 2 or 3 is
        used by NETBIOS. Also, NETBIOS extends the int 15 function 90 and 91h
        functions (scheduler functions)
     2) Normally not initialized.
     3) TOPS network card uses DMA 1, 3 or none.

Interrupt 5Dh   Reserved by IBM  (not initialized)

Interrupt 5Eh   Reserved by IBM  (not initialized)

Interrupt 5Fh   Reserved by IBM  (not initialized)

Interrupt 60h-67h  User Program Interrupts (availible for general use)

Interrupt 67h   Used by Lotus-Intel-Microsoft Expanded Memory Specification
        user    and Ashton-Tate/Quadram/AST Enhanced Expanded Memory
                specification (See Chapter 10)

Interrupt 68h   Not Used  (not initialized)

Interrupt 69h   Not Used  (not initialized)

Interrupt 6Ah   Not Used  (not initialized)

Interrupt 6Bh   Not Used  (not initialized)

Interrupt 6Ch   System Resume Vector (Convertible) (not initialized on PC)

Interrupt 6Dh   Not Used  (not initialized)

Interrupt 6Fh   Not Used  (not initialized)

Interrupt 70h   IRQ 8, Real Time Clock Interrupt  (AT, XT/286, PS/2)

Interrupt 71h   IRQ 9, Redirected to IRQ 8 (AT, XT/286, PS/2)
                LAN Adapter 1 (rerouted to int 0Ah by BIOS)

Interrupt 72h   IRQ 10  (AT, XT/286, PS/2)  Reserved

Interrupt 73h   IRQ 11  (AT, XT/286, PS/2)  Reserved

Interrupt 74h   IRQ 12  Mouse Interrupt (AT, XT/286, PS/2)

Interrupt 75h   IRQ 13, Coprocessor Error, BIOS Redirect to int 2 (NMI) (AT)

Interrupt 76h   IRQ 14, Hard Disk Controller (AT, XT/286, PS/2)

Interrupt 77h   IRQ 15 (AT, XT/286, PS/2)  Reserved

Interrupt 78h   Not Used

Interrupt 79h   Not Used

Interrupt 7Ah   Novell NetWare - LOW-LEVEL API

Interrupt 7Bh-7Fh  Not Used

Interrupt 80h-85h  Reserved by BASIC

note    interrupts 80h through ECh are apparently unused and not initialized.

Interrupt 86h   Relocated by NETBIOS int 18

Interrupt 86h-0F0h  Used by BASIC when BASIC interpreter is running

Intrerrupt 0E0h CP/M-86 function calls

Interrupt 0E4h  Logitech Modula-2 v2.0   MONITOR
entry   AX      05h     monitor entry
                06h     monitor exit
        BX      priority

Interrupts 0F1h-0FFh  (absolute addresses 3C4-3FF)
                      Location of Interprocess Communications Area

Interrupt 0F8h  Set Shell Interrupt (OEM)
                Set OEM handler for int 21h calls from 0F9h through 0FFh
entry   AH      0F8h
        DS:DX   pointer to handler for Functions 0F9h thru 0FFh
note 1) To reset these calls, pass DS and DX with 0FFFFh. DOS is set up to
        allow ONE handler for all 7 of these calls. Any call to these handlers
        will result in the carry bit being set and AX will contain 1 if they are
        not initialized. The handling routine is passed all registers just as
        the user set them. The OEM handler routine should be exited through an
        IRET.
     2) 10 ms interval timer (Tandy?)

Interrupt 0F9h  First of 8 SHELL service codes, reserved for OEM shell (WINDOW);
                use like HP Vectra user interface?

Interrupt 0FAh  USART ready (RS-232C)

Interrupt 0FBh  USART RS ready (keyboard)

Interrupt 0FCh  Unknown

Interrupt 0FDh  reserved for user interrupt

Interrupt 0FEh  AT/XT286/PS50+ - destroyed by return from protected mode

Interrupt 0FFh  AT/XT286/PS50+ - destroyed by return from protected mode

CHAPTER 6 

 Programming Technical Reference - IBM
 Copyright 1988, Dave Williams

                     DOS CONTROL BLOCKS AND WORK AREAS

When DOS loads a program, it first sets aside a section of memory for the 
program called the program segment, or code segment. Then it constructs a 
control block called the program segment prefix, or PSP, in the first 256 
(100h) bytes. Usually, the program is loaded directly after the PSP at 
100h.
 The PSP contains various information used by DOS to help run the program.  
The PSP is always located at offset 0 within the code segment. When a program 
recieves control certain registers are set to point to the PSP. For a COM 
file, all registers are set to point to the beginning of the PSP and the 
program begins at 100h. For the more complex EXE file structures, only DS and 
ES registers are set to point to the PSP. The linker passes the settings for 
the DS, IP, SS, and SP registers and may set the starting location in CS:IP to 
a location other than 100h.



IBMBIO provides an IRET instruction at absolute address 847h for use as a 
dummy routine for interrupts that are not used by DOS. This lets the 
interrupts do nothing until their vectors are rerouted to ttheir appropriate 
handlers.

A storage block is used by DOS to record the amount and location of allocated 
memory withion the machine's address spacd.
 A storage block, a Program Segment Prefix, and an environment area are built 
by FDOS for each program currently resident in the address space. The storage 
block is used by DOS to record the address range of memory allocated to a 
program. IOt us used by DOs to find th enext availible area to load  a program 
and to determine if there is a\enough memory to run that porogram. When a 
memory area is in use, it is said to be allocated. Then the program ends, or 
releases memory, it is said to bne deallocated. 
 A storage block contains a pointer ro rhe Program Segment Prefix assoiciated 
with each program. This control block is constructed by IBMDOS for the purpose 
opf providing stanfdardized areas for DOS/program communication., Within ghr 
PSP are arsas which  are used to save interrupt vectors, pass parameters to 
the program, record disk directory information, and to buffer disk reads and 
writes. This control block is 100h bytes in lengrth and is followed by the 
program mopdule loaded by DOS. 
 The PSP contains a pointer to the environment area for that program. This 
area contains a copy of the current DOS SET, PROMPT, COMSPEC, and PATH values 
as well as any user-set variables. The program may examine and modify this 
information as desired. 
 Each storage block is 10h bytes long, although only 5 bytes are currently 
used by DOS. The first byte contains 4Dh (a capital M) to indicate that it 
contains a pointer to the next storage block. A 5Ah (a capital Z) in the 
first byte of a storage block indicatres there are no more storage blocks 
following this one (it is the end of the chain). The identifier byte is 
followeed by a 2 byte segment number for the associated PSP for that program. 
The next 2 bytes contain the number of segments what are allocated to the 
program. If this is not the last storage block, then another storage block 
follows the allocated memory area.
 When thge storage block contains zero for the nuymber of allocated segments, 
then no storage is allocated to thius block and the next storage block 
immediately follows this one. This can ha-p[en whjen memory is allocated and 
then deallocated repeatedly.
 IBMDOS constructs a storage block and PSP before loading the command 
interpreter (default is COMMAND.COM).


If the copy of COMMAND.COM is a secondary copy, it will lack an environment 
address as PSP+2Ch.
 


 The Disk Transfer Area (DTA)

 DOS uses an area in memory to contain the data for all file reads and writes 
that are performed with FCB function calls. This are is known as the disk 
transfer area. This disk transfer area (DTA) is sometimes called a buffer. 
It can be located anywhere in the data area of your application program and 
should be set by your program.

 Only one DTA can be in effect at a time, so your program must tell DOS what 
memory location to use before using any disk read or write functions. Use 
function call 1Ah (Set Disk Transfer Address) to set the disk transfer address.
Use function call 2Fh (Get Disk Transfer Address) to get the disk transfer 
address. Once set, DOS continues to use that area for all disk operations until
another function call 1Ah is issued to define a new DTA. When a program is given
control by COMMAND.COM, a default DTA large enough to hold 128 bytes is 
established at 80h into the program's Program Segment Prefix.

 For file reads and writes that are performed with the extended function calls,
there is no need to set a DTA address. Instead, specify a buffer address when 
you issue the read or write call.


DOS Program Segment

 When you enter an external command or call a program through the EXEC function 
call, DOS determines the lowest availible address space to use as the start of 
available memory for the program being started. This area is called the Program
Segment.
 At offset 0 within the program segment, DOS builds the Program Segment Prefix 
control block. EXEC loads the program after the Program Segment Prefix (at
offset 100h) and gives it control.
 The program returns from EXEC by a jump to offset 0 in the Program Segment 
Prefix, by issuing an int 20h, or by issuing an int 21h with register AH=00h or 
4Ch, or by calling location 50h in the PSP with AH=00h or 4Ch.
 It is the responsibility of all programs to ensure that the CS register 
contains the segment address of the Program Segment Prefix when terminating by
any of these methods except call 4Ch.

 All of these methods result in returning to the program that issued the EXEC. 
During this returning process, interrupt vectors 22h, 23h, and 24h (Terminate, 
Ctrl-Break, and Critical Error Exit addresses) are restored from the values 
saved in the PSP of the terminating program. Control is then given to the 
terminate address.


When a program receives control, the following conditions are in effect:

For all programs:

1) The segment address of the passed environment is contained at offset 2Ch in 
   the Program Segment Prefix.

2) The environment is a series of ASCII strings totalling less than 32k bytes
   in the form:       NAME=parameter      The default environment is 160 bytes.
    Each string is terminated by a byte of zeroes, and the entire set of strings
   is terminated by abother byte of zeroes. Following the byte of zeroes that 
   terminates the set of environment string is a set of initial arguments passed
   to a program that contains a word count followed by an ASCIIZ string. The 
   ASCIIZ string contains the drive, path, and filename.ext of the executable 
   program. Programs may use this area to determine where the program was loaded
   from. The environment built by the command processor (and passed to all 
   programs it invokes) contains a COMSPEC=string at a minimum (the parameter on
   COMSPEC is the path used by DOS to locate COMMAND.COM on disk). The last PATH
   and PROMPT commands issued will also be in the environment, along with any 
   environment strings entered through the SET command. 
    The environment that you are passed is actually a copy of the invoking 
   process's environment. If your application terminates and stays resident 
   through int 27h, you should be aware that the copy of the environment passed 
   to you is static. That is, it will not change even if subsequent PATH,
   PROMPT, or SET commands are issued.
 
   The environment can be used to transfer information between processes or to
   store strings for later use by application programs. The environment is
   always located on a paragraph boundary. This is its format:
        byte    ASCIIZ string 1
        byte    ASCIIZ string 2
            ....
        byte    ASCIIZ string n
        byte    of zeros (0)
   Typically the environment strings have the form:
        parameter = value
   Following the byte of zeros in the environment, a WORD indicates the number 
   of other strings following. 

   If the environment is part of an EXECed command interpreter, it is followed 
   by a copy of the DS:DX filename passed to the child process. A zero value 
   causes the newly created process to inherit the parent's environment.

3) Offset 80h in the PSP contains code to invoke the DOS function dispatcher.
   Thus, by placing the desired function number in AH, a program can issue a
   long call to PSP+50h to invoke a DOS function rather than issuing an int 21h.

4) The disk transfer address (DTA) is set to 80h (default DTA in PSP).

5) File Control Blocks 5Ch and 6Ch are formatted from the first two parameters 
   entered when the command was invoked. Note that if either parameter contained
   a path name, then the corresponding FCB will contain only a valid drive
   number. The filename field will not be valid.

6) An unformatted parameter area at 81h contains all the characters entered
   after the command name (including leading and imbedded delimiters), with 80h
   set to the number of characters. If the <, >, or | parameters were entered
   on the command line, they (and the filenames associated with them) will not
   appear in this area, because redirection of standard input and output is
   transparent to applications.

(For EXE files only)
7) DS and ES registers are set to point to the PSP.

8) CS, IP, SS, and SP registers are set to the values passed by the linker.

(For COM files only)
9) For COM files, offset 6 (one word) contains the number of bytes availible in 
   the segment.

10) Register AX reflects the validity of drive specifiers entered with the
    first two parameters as follows:
        AL=0FFh is the first parameter contained an invalid drive specifier,
                otherwise AL=00h.
        AL=0FFh if the second parameter contained an invalid drive specifier, 
                otherwise AL=00h.

11) All four segment registers contain the segment address of the inital 
    allocation block, that starts within the PSP control block. All of user
    memory is allocated to the program. If the program needs to invoke another
    program through the EXEC function call (4Bh), it must first free some memory
    through the SETBLOCK function call to provide space for the program being
    invoked.

12) The Instruction Pointer (IP) is set to 100h.

13) The SP register is set to the end of the program's segment. The segment size
    at offset 6 is rounded down to the paragraph size.

14) A word of zeroes is placed on top of the stack.


 The PSP (with offsets in hexadecimal) is formatted as follows:

ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³     P  R  O  G  R  A  M       S  E  G  M  E  N  T       P  R  E  F  I  X     ³
ÃÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ offset³   size   ³                     C O N T E N T S                       ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 0000h ³ 2 bytes  ³ int 20h                                                   ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 0002h ³ 2 bytes  ³ segment address, end of allocation block                  ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 0004h ³ 1 byte   ³ reserved, normally 0                                      ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 0005h ³ 5 bytes  ³ long call to MSDOS function dispatcher                    ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 000Ah ³ 4 bytes  ³ previous termination handler interrupt vector (int 22h)   ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 000Eh ³ 4 bytes  ³ previous contents of ctrl-C interrupt vector (int 23h)    ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 0012h ³ 4 bytes  ³ prev. critical error handler interrupt vector (int 24h)   ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 0016h ³ 22 bytes ³ reserved for DOS                                          ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 002Ch ³ 2 bytes  ³ segment address of environment block                      ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 002Eh ³ 34 bytes ³ reserved, DOS work area                                   ³
ÀÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
        ³  4 bytes ³  stores the calling process's stack pointer when          ³
        ³          ³  switching to DOS's internal stack.                       ³
ÚÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 0050h ³  3 bytes ³ int 21h, RETF instructions                                ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 0053h ³  2 bytes ³ reserved                                                  ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 0055h ³  7 bytes ³ reserved, or FCB#1 extension                              ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 005Ch ³          ³ default File Control Block #1                             ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 006Ch ³          ³ default File Control Block #2 (overlaid if FCB #1 opened) ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 0080h ³  1 byte  ³ parameter length                                          ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 0081h ³          ³ parameters                                                ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 00FFh ³ 128 bytes³ command tail and default Disk Transfer Area (DTA)         ³
ÀÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

1. The first segment of availible memory is in segment (paragraph) form. For 
   example, 1000h would respresent 64k.

2. The word at offset 6 contains the number of bytes availible in the segment.

3. Offset 2Ch contains the segment address of the environment.

4. Programs must not alter any part of the PSP below offset 5Ch.

offset 0 contains hex bytes CD 20, the int 20h opcode. A program can end
       by making a jump to this location when the CS points to the PSP.
       For normal cases, int 21, function 4Ch should be used.

offset 2 contains the segment-paragraph address of the end of memory as 
        reported by DOS. (which may not be the same as the real end of RAM).
        Multiply this number by 10h or 16 to get the amount of memory availible.

offset 4 reserved

offset 05 contains a long call to the DOS function dispatcher. Programs may 
       jump to this address instead of calling int 21 if they wish. 

offsets 10, 14, 18  vectors

offset 2C is the segment:offset address of the environment for the program 
       using this particular PSP.

offset 2E The DWORD at PSP+2EH is used by DOS to store the calling process's
       stack pointer when switching to DOS's own private stack - at the end of
       a DOS function call, SS:SP is restored from this address.

offset 50h contains a long call to the DOS function dispatcher.

offsets 5C, 65, 6C  contain FCB information for use with FCB function calls. 
        The first FCB may overlay the second if it is an extended call; your
        program should revector these areas to a safe place if you intend to
        use them.

offset 80h and 81h contain th elength and value of parameters passed on the 
       command line. 

offset FF contains the DTA




STANDRD FILE CONTROL BLOCK

 The standard file control block is defined as follows, with the offsets in 
decimal:

ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³                 F I L E      C O N T R O L      B L O C K                    ³
ÃÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Bytes ³                           Function                                   ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³   0   ³ Drive number. For example:                                           ³
³       ³ Before open:    00h = default drive                                  ³
³       ³                 01h = drive A:                                       ³
³       ³                 02h = drive B: etc.                                  ³
³       ³ After open:     00h = drive C:                                       ³
³       ³                 01h = drive A:                                       ³
³       ³                 02h = drive B: etc.                                  ³
³       ³ 0 is replaced by the actual drive number during open.                ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³  1-8  ³ Filename, left justified with trailing blanks. If a reserved device  ³
³       ³ name is placed here (such as PRN) do not include the optional colon. ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³  9-11 ³ Filename extension, left justified with trailing blanks.             ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 12-13 ³ Current block number relative to beginning of file, starting with 0  ³
³       ³ (set to 0 by the open function call). A block consists of 128        ³
³       ³ records, each of the size specified in the logical record size field.³
³       ³ The current block number is used with the current record field       ³
³       ³ (below) for sequential reads and writes.                             ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 14-15 ³ Logical record size in bytes. Set to 80h by the OPEN function call.  ³
³       ³ If this is not correct, you must set the value because DOS uses it   ³
³       ³ to determine the proper locations in the file for all disk reads and ³
³       ³ writes.                                                              ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 16-19 ³ File size in bytes. In this 2 word field, the first word is the      ³
³       ³ low-order part of the size.                                          ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 20-21 ³ Date the file was created or last updated. The mm/dd/yy are mapped   ³
³       ³ as follows:                                                          ³
³       ³         15  14  13  12  11  10  9  8  7  6  5  4  3  2  1  0         ³
³       ³         y   y   y   y   y   y   y  m  m  m  m  d  d  d  d  d         ³
³       ³ where:            mm is 1-12                                         ³
³       ³                   dd is 1-31                                         ³
³       ³                   yy is 0-119 (1980-2099)                            ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 22-31 ³ Reserved for system use.                                             ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³  32   ³ Current relative record number (0-127) within the current block.     ³
³       ³ (See above). You must set this field before doing sequential         ³
³       ³ read/write operations to the diskette. This field is not initialized ³
³       ³ by the open function call.                                           ³
³       ³  If the record size is less than 64 bytes, both words are used.      ³
³       ³ Otherwise, only the first 3 bytes are used. Note that if you use the ³
³       ³ File Control Block at 5Ch in the program segment, the last byte of   ³
³       ³ the FCB overlaps the first byte of the unformatted parameter area.   ³
ÀÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

note 1) An unopened FCB consists of the FCB prefix (if used), drive number, and 
        filename.ext properly filled in. An open FCB is one in which the 
        remaining fields have been filled in by the CREAT or OPEN function 
        calls.
     2) Bytes 0-5 and 32-36 must be set by the user program. Bytes 16-31 are set
        by DOS and must not be changed by user programs.
     3) All word fields are stored with the least significant byte first. For 
        example, a record length of 128 is stored as 80h at offset 14, and 00h 
        at offset 15.



EXTENDED FILE CONTROL BLOCK

 The extended file control block is used to create or search for files in the 
disk directory that have special attributes.

It adds a 7 byte prefix to the FCB, formatted as follows:

ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³       E X T E N D E D     F I L E      C O N T R O L      B L O C K          ³
ÃÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Bytes ³                           Function                                   ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³   0   ³ Flag byte containing 0FFh to indicate an extended FCB.               ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³  1-6  ³ Reserved                                                             ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³  6-7  ³ Attribute byte. Refer to function call 11h (search first) for        ³
³       ³ details on using the attribute bits during directory searches. This  ³
³       ³ function is present to allow applications to define their own files  ³
³       ³ as hidden (and thereby excluded from normal directory searches) and  ³
³       ³ to allow selective directory searches.                               ³
ÀÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                     
 Any reference in the DOS function calls to an FCB, whether opened or unopened,
may use either a normal or extended FCB. If you are using an extended FCB, the 
appropriate register should be set to the first byte of the prefix, rather than
the drive-number field.



MEMORY CONTROL BLOCKS

 DOS keeps track of allocated and availible memory blocks, and provides three 
function calls for application programs to communicate their memory needs to 
DOS. These calls are 48h to allocate a memory block, 49h to free a previously 
allocated memory block, and 4Ah (SETBLOCK) to change the size of an allocated 
memory block.


CONTROL BLOCK

DOS manages memory as follows:

 DOS build a control block for each block of memory, whether free or allocated.
For example, if a program issues an "allocate" (48h), DOS locates a block of
free memory that satisfies the request, and then "carves" the requested memory 
out of that block. The requesting program is passed the location of the first 
byte of the block that was allocated for it - a memory management control block,
describing the allocated block, has been built for the allocated block and a 
second memory management control block describes the amount of space left in the
original free block of memory. When you do a setblock to shrink an allocated 
block, DOS builds a memory management control block for the area being freed and
adds it to the chain of control blocks. Thus, any program that changed memory 
that is not allocated to it stands a chance of destroying a DOS memory 
management control block. This causes unpredictable results that don't show up 
until an activity is performed where DOS uses its chain of control blocks. The 
normal result is a memory allocation error, which means a system reset will be 
required.

 When a program (command or application program) is to be loaded, DOS uses the 
EXEC function call 4Bh to perform the loading.

 This is the same function call that is availible to applications programs for 
loading other programs. This function call has two options:

      Function 00h, to load and execute a program (this is what the command
                    processor uses to load and execute external commands)

      Function 03h, to load an overlay (program) without executing it.

 Although both functions perform their loading in the same way (relocation is 
performed for EXE files) their handling of memory management is different.


FUNCTION 0: For function 0 to load and execute a program, EXEC first allocates 
the largest availible block of memory (the new program's PSP will be at offset 
0 in that block). Then EXEC loads the program. Thus, in most cases, the new 
program owns all the memory from its PSP to the end of memory, including memory
occupied by the transient parent of COMMAND.COM. If the program were to issue 
its own EXEC function call to load and execute another program, the request 
would fail because no availible memory exists to load the new program into.

NOTE: For EXE programs, the amount of memory allocated is the size of the 
      program's memory image plus the value in the MAX_ALLOC field of the file's
      header (offset 0Ch, if that much memory is availible. If not, EXEC 
      allocates the size of the program's memory image plus the value in the 
      MIN_ALLOC field in the header (offset 0Ah). These fields are set by the 
      Linker).

 A well-behaved program uses the SETBLOCK function call when it receives 
control, to shrink its allocated memory block down to the size it really needs.
A COM program should remember to set up its own stack before doing the SETBLOCK,
since it is likely that the default stack supplied by DOS lies in the area of 
memory being used. This frees unneeded memory, which can be used for loading 
other programs.

 If the program requires additional memory during processing, it can obtain 
the memory using the allocate function call and later free it using the free 
memory function call.

 When a program is loaded using EXEC function call 00h exits, its initial 
allocation block (the block beginning with its PSP) is automatically freed 
before the calling program regains control. It is the responsibility of all 
programs to free any memory they allocate before exiting to the calling 
program.


 FUNCTION 3: For function 3, to load an overlay, no PSP is built and EXEC 
assumes the calling program has already allocated memory to load the new program
into - it will NOT allocate memory for it. Thus the calling program should 
either allow for the loading of overlays when it determines the amount of memory
to keep when issuing the SETBLOCK call, or should initially free as much memory 
as possible. The calling program should then allocate a block (based on the size
of the program to be loaded) to hold the program that will be loaded using the 
"load overlay" call. Note that "load overlay" does not check to see if the 
calling program actually owns the memory block it has been instructed to load 
into - it assumes the calling program has followed the rules. If the calling 
program does not own the memory into which the overlay is being loaded, there is
a chance the program being loaded will overlay one of the control blocks that 
DOS uses to keep track of memory blocks.

 Programs loaded using function 3 should not issue any SETBLOCK calls since
they don't own the memory they are operating in. (This memory is owned by the
calling program)

 Because programs loaded using function 3 are given control directly by (and 
return contrrol directly to) the calling program, no memory is automatically 
freed when the called program exits. It is up to the calling program to 
determine the disposition of the memory that had been occupied by the exiting 
program. Note that if the exiting program had itself allocated any memory, it 
is responsible for freeing that memory before exiting.


 MEMORY CONTROL BLOCKS

 Only the first 5 bytes of the memory control block are used. The first byte 
will always have the value of 4Dh or 5Ah. The value 5Ah indicates the block is 
the last in a chain, all memory above it is unused. 4Dh means that the block is
intermediate in a chain, the memory above it belongs to the next program or to 
DOS.

 The next two bytes hold the PSP segment address of the program that owns the 
corresponding block of memory. A value of 0 means the block is free to be 
claimed, any other value represents a segment address. Bytes 3 and 4 indicate 
the size in paragraphs of the memory block. If you know the address of the first
block, you can find the next block by adding the length of the memory block plus
1 to the segment address of the control block. 

 Finding the first block can be difficult, as this varies according to the DOS 
version and the configuration. 

 The remaining 11 bytes are not currently used by DOS, and may contain "trash" 
characters left in memory from previous applications.

  If DOS determines that the allocation chain of memory control blocks has been 
corrupted, it will halt the system and display the message "Memory Allocation 
Error", and the system will halt, requiring a reboot.

 Each memory block consists of a signature byte (4Dh or 5Ah) then a word which
is the PSP value of the owner of the block (which allocated it), followed by a 
word which is the size in paragraphs of the block. The last block has a 
signature of 5Ah. All others have 4Dh. If the owner is 0000 then the block is 
free.

 User memory is allocated from the lowest end of available memory that will 
satisfy the request for memory.



CHAPTER 7

 Programming Technical Reference - IBM
 Copyright 1988, Dave Williams

                             DOS File Structure


File Management Functions

 Use DOS function calls to create, open, close, read, write, rename, find, and 
erase files. There are two sets of function calls that DOS provides for support
of file management. They are:

* File Control Block function calls   (0Fh-24h)
* Handle function calls               (39h-62h)

 Handle function calls are easier to use and are more powerful than FCB calls.
Microsoft recommends that the handle function calls be used when writing new
programs. DOS 3.0 up have been curtailing use of FCB function calls; it is
possible that future versions of DOS may not support FCB function calls.
 The following table compares the use of FCB calls to Handle function calls:

                FCB Calls                       Handle Calls

        Access files in current         Access files in ANY directory
        directory only.

        Requires the application        Does not require use of an FCB.
        program to maintain a file      Requires a string with the drive,
        control block to open,          path, and filename to open, create,
        create, rename or delete        rename, or delete a file. For file
        a file. For I/O requests,       I/O requests, the application program
        the application program         must maintain a 16 bit file handle
        also needs an FCB               that is supplied by DOS.

 The only reason an application should use FCB function calls is to maintain
the ability to run under DOS 1.x. To to this, the program may use only function
calls 00h-2Eh.


FCB FUNCTION CALLS

 FCB function calls require the use of one File Control Block per open file, 
which is maintained by the application program and DOS. The application program
supplies a pointer to the FCB and fills in ther appropriate fields required by 
the specific function call. An FCB function call can perform file management on
any valid drive, but only in the current logged directory. By using the current
block, current record, and record length fields of the FCB, you can perform 
sequential I/O by using the sequential read or write function calls. Random I/O
can be performed by filling in the random record and record length fields. 

 Several possible uses of FCB type calls are considered programming errors and 
should not be done under any circumstances to avoid problems with file sharing
and compatibility with later versions of DOS.
 Some errors are:
1) If program uses the same FCB structure to access more than one open file. By
   opening a file using an FCB, doing I/O, and then replacing the filename field
   in the file control block with a new filename, a program can open a second
   file using the same FCB. This is invalid because DOS writes control info-
   rmation about the file into the reserved fields of the FCB. If the program
   then replaces the filename field with the original filename and then tries to
   perform I/O on this file, DOS may become confused because the control info-
   rmation has been changed. An FCB should never be used to open a second file
   without closing the one that is currently open. If more than one File Control
   Block is to be open concurrently, separate FCBs should be used.

2) A program should never try to use the reserved fields in the FCB, as the
   function of the fields changes with different versions of DOS.

3) A delete or a rename on a file that is currently open is considered an error
   and should not be attempted by an application program.

 It is also good programming practice to close all files when I/O is done. This
avoids potential file sharing problems that require a limit on the number of
files concurrently open using FCB function calls.



HANDLE FUNCTION CALLS

 The recommended method of file management is by using the extended "handle" 
set of function calls. These calls are not restricted to the current directory.
Also, the handle calls allow the application program to define the type of 
access that other processes can have concurrently with the same file if the file
is being shared.

 To create or open a file, the application supplies a pointer to an ASCIIZ 
string giving the name and location of the file. The ASCIIZ string contains an 
optional drive letter, optional path, mandatory file specification, and a 
terminal byte of 00h. The following is an example of an ASCIIZ string:

                  format [drive][path] filename.ext,0

                      DB "A:\path\filename.ext",0

 If the file is being created, the application program also supplies the 
attribute of the file. This is a set of values that defines the file read 
only, hidden, system, directory, or volume label.

 If the file is being opened, the program can define the sharing and access 
modes that the file is opened in. The access mode informs DOS what operations 
your program will perform on this file (read-only, write-only, or read/write) 
The sharing mode controls the type of operations other processes may perform 
concurrently on the file. A program can also control if a child process inherits
the open files of the parent. The sharing mode has meaning only if file sharing
is loaded when the file is opened.

 To rename or delete a file, the appplication program simply needs to provide 
a pointer to the ASCIIZ string containing the name and location of the file 
and another string with the neew name if the file is being renamed.

 The open or create function calls return a 16-bit value referred to as the 
file handle. To do any I/O to a file, the program uses the handle to reference
the file. Once a file is opened, a program no longer needs to maintain the 
ASCIIZ string pointing to the file, nor is there any need to stay in the same 
directory. DOS keeps track of the location of the file regardless of what 
directory is current.

 Sequential I/O can be performed using the handle read (3Fh) or write (40h) 
function calls. The offset in the file that IO is performed to is automatically
moved to the end of what was just read or written. If random I/O is desired, the
LSEEK (42h) function call can be used to set the offset into the file where I/O 
is to be performed.


SPECIAL FILE HANDLES

 DOS reserves five special file handles for use by itself and applications 
programs. They are:

              0000h   STDIN   Standard Input Device
              0001h   STDOUT  Standard Output Device
              0002h   STDERR  Standard Error Output Device
              0003h   STDAUX  Standard Auxiliary Device
              0004h   STDPRN  Standard Printer Device

 These handles are predefined by DOS and can be used by an application program.
They do not need to be opened by a program, although a program can close these 
handles. STDIN should be treated as a read-only file, and STDOUT and STDERR 
should be treated as write-only files. STDIN and STDOUT can be redirected. All 
handles inherited by a process can be redirected, but not at the command line.

 These handles are very useful for doing I/O to and from the console device. 
For example,  you could read input from the keyboard using the read (3Fh) 
function call and file handle 0000h (STDIN), and write output to the console 
screen with the write function call (40h) and file handle 0001h (STDOUT). If 
you wanted an output that could not be redirected, you could output it using 
file handle 0002h (STDERR). This is very useful for error messages that must 
be seen by a user.

 File handles 0003h (STDAUX) and 0004h (STDPRN) can be both read from and 
written to. STDAUX is typically a serial device and STDPRN is usually a parallel
device.


ASCII and BINARY MODE

 I/O to files is done in binary mode. This means that the data is read or 
written without modification. However, DOS can also read or write to devices in
ASCII mode. In ASCII mode, DOS does some string processing and modification to 
the characters read and written. The predefined handles are in ASCII mode when 
initialized by DOS. All other file handles that don't refer to devices are in 
binary mode. A program, can use the IOCTL (44h) function call to set the mode 
that I/O is to a device. The predefined file handles are all devices, so the 
mode can be changed from ASCII to binary via IOCTL. Regular file handles that 
are not devices are always in binary mode and cannot be changed to ASCII mode.

 The ASCII/BINARY bit was called "raw" in DOS 2.x, but it is called ASCII/BINARY
in DOS 3.x.

 The predefined file handles STDIN (0000h) and STDOUT (0001h) and STDERR 
(0002h) are all duplicate handles. If the IOCTL function call is used to change
the mode of any of these three handles, the mode of all three handles is 
changed. For example, if IOCTL was used to change STDOUT to binary mode, then 
STDIN and STDERR would also be changed to binary mode.



FILE I/O IN BINARY (RAW) MODE

The following is true when a file is read in binary mode:

1)  The characters ^S (scroll lock), ^P (print screen), ^C (control break) are 
    not checked for during the read. Therefore, no printer echo occurs if ^S or
    ^P are read.
2)  There is no echo to STDOUT (0001h).
3)  Read the number of specified bytes and returns immediately when the last 
    byte is received or the end of file reached.
4)  Allows no editing of the ine input using the function keys if the input is 
    from STDIN (0000h).


The following is true when a file is written to in binary mode:

1)  The characters ^S (scroll lock), ^P (print screen), ^C (control break) are 
    not checked for during the write. Therefore, no printer echo occurs.
2)  There is no echo to STDOUT (0001h).
3)  The exact number of bytes specified are written.
4)  Does not caret (^) control characters. For example, ctrl-D is sent out as 
    byte 04h instead of the two bytes ^ and D.
5)  Does not expand tabs into spaces. 


FILE I/O IN ASCII (COOKED) MODE

The following is true when a file is read in ASCII mode:

1)  Checks for the characters ^C,^S, and ^P.
2)  Returns as many characters as there are in the device input buffer, or the 
    number of characters requested, whichever is less. If the number of 
    characters requested was less than the number of characters in the device 
    buffer, then the next read will address the remaining characters in the 
    buffer.
3)  If there are no more bytes remaining in the device input buffer, read a 
    line (terminated by ^M) into the buffer. This line may be edited with the 
    function keys. The characters returned terminated with a sequence of 0Dh,
    0Ah (^M,^J) if the number of characters requested is sufficient to include
    them. For example, if 5 characters were requested, and only 3 were entered
    before the carriage return (0Dh or ^M) was presented to DOS from the console
    device, then the 3 characters entered and 0Dh and 0Ah would be returned. 
    However, if 5 characters were requested and 7 were entered before the 
    carriage return, only the first 5 characters would be returned. No 0Dh,0Ah 
    sequence would be returned in this case. If less than the number of 
    characters requested are entered when the carriage return is received, the
    characters received and 0Dh,0Ah would be returned. The reason the 0Ah 
    (linefeed or ^J) is added to the returned characters is to make the devices
    look like text files.
4)  If a 1Ah (^Z) is found, the input is terminated at that point. No 0Dh,0Ah 
    (CR,LF) sequence is added to the string.
5)  Echoing is performed.
6)  Tabs are expanded.


The following is true when a file is written to in ASCII mode:

1)  The characters ^S,^P,and ^C are checked for during the write operation.
2)  Expands tabs to 8-character boundaries and fills with spaces (20h).
3)  Carets control characters, for example, ^D is written as two bytes, ^ and D.
4)  Bytes are output until the number specified is output or a ^Z is 
    encountered. The number actually output is returned to the user.


NUMBER OF OPEN FILES ALLOWED

 The number of files that can be open concurrently is restricted by DOS. This 
number is determined by how the file is opened or created (FCB or handle 
function call) and the number specified by the FCBS and FILES commands in the 
CONFIG.SYS file. The number of files allowed open by FCB function calls and the
number of files that can be opened by handle type calls are independent of one 
another.


RESTRICTIONS ON FCB USAGE

 If file sharing is not loaded using the SHARE command, there are no 
restrictions on the nuumber of files concurrently open using FCB function calls.

 However, when file sharing is loaded, the maximum number of FCBs open is set
by the the FCBS command in the CONFIG.SYS file.

 The FCBS command has two values you can specify, 'm' and 'n'. The value for 
'm' specifies the number of files that can be opened by FCBs, and the value 'n' 
specifies the number of FCBs that are protected from being closed.

 When the maximum number of FCB opens is exceeded, DOS automatically closes the
least recently used file. Any attempt to access this file results in an int 24h
critical error message "FCB not availible". If this occurs while an application
program is running, the value specified for 'm' in the FCBS command should be
increased.

 When DOS determines the least recently used file to close, it does not include
the first 'n' files opened, therefore the first 'n' files are protected from 
being closed.


RESTRICTIONS ON HANDLE USAGE

 The number of files that can be open simultaneously by all processes is 
determined by the FILES command in the CONFIG.SYS file. The number of files a 
single process can open depends on the value specified for the FILES command. If
FILES is greater than or equal to 20, a single process can open 20 files. If 
FILES is less than 20, the process can open less than 20 files. This value 
includes three predefined handles: STDIN, STDOUT, and STDERR. This means only
17 additional handles can be added. DOS 3.3 includes a function to use more than
20 files per application.

ALLOCATING SPACE TO A FILE

 Files are not nescessarily written sequentially on a disk. Space is allocated 
as needed and the next location availible on the disk is allocated as space for
the next file being written. Therefore, if considerable file generation has
taken place, newly created files will not be written in sequential sectors.
However, due to the mapping (chaining) of file space via the File Allocation
Table (FAT) and the function calls availible, any file may be used in either a
sequential or random manner.

 Space is allocated in increments called clusters. Cluster size varies 
according to the media type. An application program should not concern itself 
with the way that DOS allocates space to a file. The size of a cluster is only 
important in that it determines the smallest amount of space that can be 
allocated to a file. A disk is considered full when all clusters have been 
allocated to files.



MSDOS / PCDOS DIFFERENCES

 There is a problem of compatibility between MS-DOS and IBM PC-DOS having to 
do with FCB Open and Create. The IBM 1.0, 1.1, and 2.0 documentation of OPEN
(call 0Fh) contains the following statement:

 "The current block field (FCB bytes C-D) is set to zero [when an FCB is 
opened]."

 This statement is NOT true of MS-DOS 1.25 or MS-DOS 2.00. The difference is
intentional, and the reason is CP/M 1.4 compatibility. Zeroing that field is 
not CP/M compatible. Some CP/M programs will not run when machine translated if
that field is zeroed. The reason it is zeroed in the IBM versions is that IBM 
specifically requested that it be zeroed. This is the reason for the complaints
from some vendors about the fact that IBM MultiPlan will not run under MS-DOS.
It is probably the reason that some other IBM programs don't run under MS-DOS.

NOTE: Do what all MS/PC-DOS Systems programs do: Set every single FCB field you
want to use regardless of what the documentation says is initialized.



.EXE FILE STRUCTURE

 The EXE files produced by the Linker program consist of two parts, control and
relocation information and the load module itself.

 The control and relocation information, which is described below, is at the 
beginning of the file in an area known as the header. The load module 
immediately follows the header. The load module begins in the memory image of 
the module contructed by the Linker.

 When you are loading a file with the name *.EXE, DOS does NOT assume that it
is an EXE format file. It looks at the first two bytes for a signature telling
it that it is an EXE file. If it has the proper signature, then the load 
proceeds. Otherwise, it presumes the file to be a .COM format file.

 If the file has the EXE signature, then the internal consistency is checked.
Pre-2.0 versions of MSDOS did not check the signature byte for EXE files.

 The .EXE format can support programs larger than 64K. It does this by 
allowing separate segments to be defined for code, data, and the stack, each 
of which can be up to 64K long. Programs in EXE format may contain explicit 
references to segment addresses. A header in the EXE file has information for 
DOS to resolve these references.


The .EXE header is formatted as follows:
ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Offset  ³                      C O N T E N T S                              ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³   00h   ³ 4Dh ³ This is the Linker's signature to mark the file as a valid  ³ 
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄ´ .EXE file  (The ASCII letters M and Z, for Mark Zbikowski,  ³
³   01h   ³ 5Ah ³ one of the major designers of DOS at Microsoft)             ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 02h-03h ³ Length of the image mod 512 (remainder after dividing the load    ³
³         ³ module image by 512)                                              ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 04h-05h ³ Size of the file in 512 byte pages including the header.          ³ 
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 06h-07h ³ Number of relocation table items.                                 ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 08h-09h ³ Size of the header in 16 byte increments (paragraphs). This is    ³
³         ³ used to locate the beginning of the load module in the file.      ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 0Ah-0Bh ³ Minimum number of 16 byte paragraphs required above the end of    ³
³         ³ the loaded program.                                               ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 0Ch-0Dh ³ Maximum number of 16 byte paragraphs required above the end of    ³
³         ³ the loaded program.                                               ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 0Eh-0Fh ³ Displacement in paragraphs of stack segment within load module.   ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 10h-11h ³ Offset to be in SP register when the module is given control.     ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 12h-13h ³ Word Checksum - negative sum of all the words in the file,        ³
³         ³ ignoring overflow.                                                ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 14h-15h ³ Offset to be in the IP register when the module is given control. ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 16h-17h ³ Displacement in paragraphs of code segment within load module.    ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 18h-19h ³ Displacement in bytes of the first relocation item in the file.   ³
ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 1Ah-1Bh ³ Overlay number (0 for the resident part of the program)           ³
ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



THE RELOCATION TABLE

 The word at 18h locates the first entry in the relocation table. The 
relocation table is made up of a variable number of relocation items. The number
of items is contained at offset 06-07. The relocation item contains two fields
- a 2 byte offset value, followed by a 2 byte segment value. These two fields 
represent the displacement into the load module before the module is given 
control. The process is called relocation and is accomplished as follows:

1. A Program Segment Prefix is built following the resident portion of the 
   program that is performing the load operation.

2. The formatted part of the header is read into memory (its size is at 
   offset 08-09)

3. The load module size is determined by subtracting the header size from the 
   file size. Offsets 04-05 and 08-09 can be used for this calculation. The 
   actual size is downward adjusted based on the contents of offsets 02-03. 
   Note that all files created by the Linker programs prior to version 1.10 
   always placed a value of 4 at this location, regardless of the actual 
   program size. Therefore, Microsoft recommends that this field be ignored if 
   it contains a value of 4. Based on the setting of the high/low loader switch,
   an appropriate segment is determined for loading the load module. This
   segment is called the start segment.

4. The load module is read into memory beginning at the start segment. The
   relocation table is an ordered list of relocation items. The first relocation
   item is the one that has the lowest offset in the file. 

5. The relocation table items are read into a work area one or more at a time.

6. Each relocation table item segment value is added to the start segment value.
   The calculated segment, in conjunction with the relocation item offset value,
   points to a word in the load module to which is added the start segment 
   value. The result is placed back into the word in the load module.

7. Once all the relocation items have been processed, the SS and SP registers 
   are set from the values in the header and the start segment value is added 
   to SS. The ES and DS registers are set to the segment address of the program 
   segment prefix. The start segment value is added to the header CS register 
   value. The result, along with the header IP value, is used to give the 
   module control.


"NEW" .EXE FORMAT (Microsoft Windows and OS/2)

 The "old" EXE format is documented here. The "new" EXE format puts more 
information into the header section and is currently used in applications that 
run under Microsoft Windows. The linker that creates these files comes with the 
Microsoft Windows Software Development Kit and is called LINK4. If you try to 
run a Windows-linked program under DOS, you will get the error message "This 
program requires Microsoft Windows".

CHAPTER 8

 Programming Technical Reference - IBM
 Copyright 1988, Dave Williams

                          DOS DISK INFORMATION


THE DOS AREA

 All disks and diskettes formatted by DOS are created with a sector size of 512
bytes. The DOS area (entire area for a diskette, DOS partition for hard disks)
is formatted as follows:

        Boot record - 1 sector
        First copy of the FAT - variable size
        Second copy of the FAT - same size as first copy
        Root directory - variable size
        Data area

The following sections describe each of the allocated areas: 


THE BOOT RECORD

 The boot record resides on track 0, sector 1, side 0 of every diskette 
formatted by the DOS FORMAT program. It is put on all disks to provide an error
message is you try to start up with a nonsystem disk in drive A:. For hard disks
the boot record resides on the first sector of the DOS partition.


THE DOS FILE ALLOCATION TABLE (FAT)

 This section explains how DOS uses the FAT to convert the clusters of a file 
into logical sector numbers. We recommend that system utilities use the DOS 
handle calls rather than interpreting the FAT.

 The FAT is used by DOS to allocate disk space for files, one cluster at a time.

 The FAT consists of a 12 bit entry (1.5 bytes) for each cluster on the disk or
a 16 bit (2 bytes) entry when a hard disk has more than 20740 sectors as is the
case with fixed disks larger than 10Mb.
 The first two FAT entries map a portion of the directory; these FAT entries 
contain indicators of the size and format of the disk. The FAT can be in a 12 
or 16 bit format. DOS determines whether a disk has a 12 or 16 bit FAT by 
looking at the total number of allocation units on a disk. For all diskettes 
and hard disks with DOS partitions less than 20,740 sectors, the FAT uses a 12 
bit value to map a cluster. For larger partitions, DOS uses a 16 bit value.
 The second, third, and fourth bit applicable for 16 bit FAT bytes always 
contains 0FFFFh. The first byte is used as follows:

     hex value              meaning                     normally used

       0F8h      hard disk                         bootable hard disk at C:800
                 double sided  18 sector diskette   PS/2 1.44 meg DSQD
       0F9h      double sided  15 sector diskette   AT 1.2 meg DSQD
                 double sided  9  sector diskette   Convertible 720k DSHD
       0FCh      single sided  9  sector diskette   DOS 2.0, 180k SSDD
       0FDh      double sided  9  sector diskette   DOS 2.0, 360k DSDD
       0FEh      single sided  8  sector diskette   DOS 1.0, 160k SSDD
       0FFh      double sided  8  sector diskette   DOS 1.1, 320k SSDD


The third FAT entry begins mapping the data area (cluster 002).

NOTE: These values are provided as a reference. Therefore, programs should not 
      make use of these values.

 Each entry contains a hexadecimal character (or 4 for 16 bit FATs). () 
indicates the high order four bit value in the case of 16 bit FAT entries. 
They can be:

            (0)000h  if the cluster is unused and availible

(0F)FF8h - (0F)FFFh  to indicate the last cluster of a file

            (X)XXXh  any other hexadecimal numbers that are the cluster number
                     of the next cluster in the file. The cluster number is the
                     first cluster in the file that is kept in the file's 
                     directory entry.

 The values (0F)FF0h - (0F)FF7h are used to indicate reserved clusters. 
(0F)FF7h indicates a bad cluster if it is not part of the allocation chain. 
(0F)FF8h - (0F)FFFh are used as end of file markers.

 The file allocation table always occupies the sector or sectors immediately 
following the boot record. If the FAT is larger than 1 sector, the sectors 
occupy consecutive sector numbers. Two copies of the FAT are written, one 
following the other, for integrity. The FAT is read into one of the DOS buffers
whenever needed (open, allocate more space, etc).


USE OF THE 12 BIT FILE ALLOCATION TABLE

Obtain the starting cluster of the file from the directory entry.

Now, to locate each subsequent sector of the file:

1. Multiply the cluster number just used by 1.5 (each FAT entry is 1.5 
   bytes long).
2. The whole part of the product is offset into the FAT, pointing to the entry 
   that maps the cluster just used. That entry contains the cluster number of 
   the next cluster in the file.
3. Use a MOV instruction to move the word at the calculated FAT into a register.
4. If the last cluster used was an even number, keep the low order 12 bits of 
   the register, otherwise, keep the high order 12 bits.
5. If the resultant 12 bits are (0FF8h-0FFFh) no more clusters are in the file.
   Otherwise, the next 12 bits contain the cluster number of the next cluster in
   the file. 

  To convert the cluster to a logical sector number (relative sector, such as 
that used by int 25h and 26h and DEBUG):

1. Subtract 2 from the cluster number
2. Multiply the result by the number of sectors per cluster.
3. Add the logical sector number of the beginning of the data area.


USE OF THE 16 BIT FILE ALLOCATION TABLE

 Obtain the starting cluster of the file from the directory entry. Now to 
locate each subsequent cluster of the file:

1.  Multiply the cluster number used by 2 (each FAT entry is 2 bytes long).
2.  Use the MOV word instruction to move the word at the calculated FAT offset 
    into a register.
3.  If the resultant 16 bits are (0FF8h-0FFFFh) no more clusters are in the 
    file. Otherwise, the 16 bits contain the cluster number of the next cluster 
    in the file. 

 Compaq DOS makes availible a new disk type (6) with 32 bit partition values, 
allowing 512 megabytes per hard disk (Compaq DOS 3.3.1)



DOS DISK DIRECTORY

 The FORMAT command initially builds the root directory for all disks. Its 
location (logical sector number) and the maximum number of entries are 
availible through the device driver interfaces.



DIRECTORY ENTRIES 

 Since directories other than the root directory are actually files, there is 
no limit to the number of entries that they may contain. 

 All directory entries are 32 bytes long, and are in the following format (byte
and offset are decimal). The following paragraphs describe the directory entry 
bytes:

*BYTES 0-7
 Bytes 0-7 represent the filename. The first byte of the filename indicates the 
status of the filename. The status of a filename can contain the following 
values:

   00h Filename never used. This is used to limit the length of directory 
       searches, for performance reasons.
   05h Indicates that the first character of the filename actually has an 0Edh 
       character.
  0E5h Filename has been used but the file has been erased.
   2Eh This entry is for a directory. If the second byte is also 2Eh, the 
       cluster field contains the cluster number of this directory's parent 
       directory.  (0000h if the parent directory is the root directory).
                                                 
Any other character is the first character of a filename.

*BYTES 8-10
 These bytes indicate the filename extension.

*BYTE 11
 This byte indicates the file's attribute. The attribute byte is mapped as 
 follows (values are in hexadecimal):

NOTE: Attributes 08h and 10h cannot be changed using function call 43h (CHMOD).

 The system files IBMBIO.COM and IBMDOS.COM (or customized equivalent) are 
marked as read-only, hidden, and system files. Files can be marked hidden when 
they are created. Also, the read-only, hidden, and system and archive attributes
may be changed through the CHMOD function call.

01h Indicates that the file is marked read-only. An attempt to open the file 
    for output using function call 3Dh results in an error code being returned. 
    This value can be used with other values below.

02h Indicates a hidden file. The file is excluded from normal directory 
    searches.

04h Indicates a system file. This file is excluded from normal directory 
    searches.

08h Indicates that the entry contains the volume label in the first 11 bytes. 
    The entry contains no other usable information and may exist only in the 
    root directory.

20h Indicates an archive bit. This bit is set on whenever the file is written 
    to and closed. It is used by BACKUP and RESTORE.

All other bits are reserved, and must be 0.

*BYTES 12-21
 reserved by DOS


*BYTES 22-23
 These bytes contain the time when the file was created or last updated. The 
time is mapped in the bits as follows:
      ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      ³         B Y T E    23         ³         B Y T E    22         ³
      ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
      ³ F   E   D   C   B   A   9   8 ³ 7   6   5   4   3   2   1   0 ³
      ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
      ³ H   H   H   H   H ³ M   M   M   M   M   M ³ D   D   D   D   D ³
      ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
      ³ binary # hrs 0-23 ³ binary # minutes 0-59 ³ bin. # 2-sec incr ³
      ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

NOTE: The time is stored with the least significant byte first.


*BYTES 24-25
 This area contains the date when the file was created or last updated. The 
mm/dd/yy are mapped in the bits as follows:

      ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      ³         B Y T E    25         ³         B Y T E    24         ³
      ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
      ³ F   E   D   C   B   A   9   8 ³ 7   6   5   4   3   2   1   0 ³
      ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
      ³ Y   Y   Y   Y   Y   Y   Y ³ M   M   M   M ³ D   D   D   D   D ³
      ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
      ³      0-119 (1980-2099)    ³     1-12      ³       1-31        ³
      ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

NOTE: The date is stored with the least significant byte first.


*BYTES 26-27
 This area contains the starting cluster number of the first cluster in the 
file. The first cluster for data space on all fixed disks and floppy disks is 
always cluster 002. The cluster number is stored with the least significant 
byte first.


*BYTES 28-31
 This area contains the file size in bytes. The first word contains the low 
order part of the size. Both words are stored with the least significant byte 
first.


                        File Allocation Table
offset size                  description
   3       8 bytes system id (such as IBM 3.3)
  11      2 bytes number of bytes per sector, ie 512 bytes is 200h
  13      1 byte  sectors per cluster (1 or 2)
  14      2 bytes number of reserved sectors at beginning, 1 for floppies
  16      1 byte  number of copies of FAT, 2 for floppies
  17      2 bytes number of root directory entries (64, 112, 256,etc)
  19      2 bytes total sectors per disk
  21      1 byte  format ID (F8, F9, FC, FF, etc)
  22      2 bytes number of sectors per FAT (1 or 2)
  24      2 bytes number of sectors per track (8 or 9, 17)
  26      2 bytes number of sides, heads, or cylinders (1 or 2 for floppy)
  28      2 bytes number of special reserved sectors


THE DATA AREA

 Allocation of space for a file (in the data area) is done only when needed 
(it is not preallocated). The space is allocated one cluser (unit allocation) 
at a time. A cluster is always one or more consecutive sector numbers, and all 
of the clusters in a file are "chained" together in the FAT. 

 The clusters are arranged on disk to minimize head movement for multisided 
media. All of the space on a track (or cylinder) is allocated before moving 
on to the next track. This is accomplished by using the sequential sector 
numbers on the lowest-numbered head, then all the sector numbers on the next 
head, and so on until all sectors of all heads of the track are used. Then the 
next sector used will be sector 1 of head 0 on the next track.

 An interesting innovation that was introduced in MS-DOS 3.0: disk space that 
is freed by erasing a file is not re-used immediately, unlike earlier versions 
of DOS. Instead, free space is obtained from the area not yet used during the 
current session, until all of it is used up. Only then will space that is freed
during the current session be re-used.

 This feature minimizes fragmentation of files, since never-before-used space
is always contiguous. However, once any space has been freed by deleting a file,
that advantage vanishes at the next system boot. The feature also greatly
simplifies un-erasing files, provided that the need to do an un-erase is found
during the same session and also provided that the file occupies contiguous 
clusters.

 However, when one is using programs which make extensive use of temporary
files, each of which may be created and erased many times during a session,
the feature becomes a nuisance; it forces the permanent files to move farther
and farther into the inner tracks of the disk, thus increasing rather than
decreasing the amount of fragmentation which occurs.

 The feature is implemented in DOS by means of a single 16-bit "last cluster
used" (LCU) pointer for each physical disk drive; this pointer is a part of
the physical drive table maintained by DOS. At boot time, the LCU pointer is
zeroed. Each time another cluster is obtained from the free-space pool (the
FAT), its number is written into the LCU pointer. Each time a fresh cluster
is required, the FAT is searched to locate a free one; in older versions of
DOS this search always began at Cluster 0000, but in 3.x it begins at the
cluster pointed to by the LCU pointer.

 For hard disks, the size of the file allocation table and directory are 
determined when FORMAT initializes it and are based on the size of the DOS 
partition.

The following table gives the specifications for floppy disk formats:

               # of   sectors  FAT size    DIR        DIR     sectors  total
disk  DOS ver  sides  /track   (sectors) (sectors) (entries) /cluster sectors

(5-1/4 inch)
160k (DOS 1.0)   1     8  (40)     1        4         64         1      320
320k (DOS 1.1)   2     8  (40)     1        7         112        2      360
180k (DOS 2.0)   1     9  (40)     2        4         64         1      640
360k (DOS 2.0)   2     9  (40)     2        7         112        2      720
1.2M (DOS 3.0)   2     15 (80)     7        14        224        1      2400

(3-1/2 inch)                                                       
720k (DOS 3.2)   2     9  (80)     3        7         112        2      1440
1.44M(DOS 3.3)   2     18 (80)     9        14        224        1      2880

 Files in the data area are not nescessarily written sequentially on the first.
The data area space is allocated one cluster at a time, skipping over clusters 
already allocated. The first free cluster found is the next cluster allocated, 
regardless of its physical location on the disk. This permits the most efficient
utilization of disk space because clusters freed by erasing files can be 
allocated for new files. Refer back to the description of the DOS FAT in this 
chapter for more information.


Hard Disk Layout

 The DOS hard disk routines perform the following services:

1) Allow multiple operating systems to utilize the hard disk without the need 
   to backup and restore files when changing operating systems.

2) Allow a user-selected operating system to be started from the hard disk.
   
   I) In order to share the hard disk among operating systems, the disk may be 
      logically divided into 1 to 4 partitions. The space within a given 
      partition is contiguous, and can be dedicated to a specific operating 
      system. Each operating system may "own" only one partition in DOS versions
      2.0 through 3.2. PCDOS 3.3 introduced the "Extended DOS Partition" which 
      allows multiple DOS partitions on the same hard disk. The FDISK.COM (or 
      similar program from other DOS vendors) utility allows the user to select
      the number, type, and size of each partition. The partition information is
      kept in a partition table that is embedded in the master fixed disk boot 
      record on the first sector of the disk. The format of this table varies 
      from version to version of DOS.

  II) An operating system must consider its partition to be the entire disk, 
      and must ensure that its functions and utilities do not access other 
      partitions on the disk. 

 III) Each partition may contain a boot record on its first sector, and any 
      other programs or data that you choose - including a copy of an operating 
      system. For example, the DOS FORMAT command may be used to format and 
      place a copy of DOS in the DOS partition in the same manner that a 
      diskette is formatted. With the FDISK utility, you may designate a 
      partition as "active" (bootable). The master hard disk boot record causes
      that partition's boot record to receive control when the system is started
      or reset. Additional disk partitions could be FORTH, UNIX, Pick, CP/M-86,
      or the UCSD p-System.



SYSTEM INITIALIZATION

The boot sequence is as follows:

1. System initialization first attempts to load an operating system from 
   diskette drive A. If the drive is not ready or a read error occurs, it then 
   attempts to read a master hard disk boot record on the first sector of the 
   first hard disk in the system. If unsuccessful, or if no hard disk is 
   present, it invokes ROM BASIC in an IBM PC or displays a disk error 
   message on most compatibles.

2. If initialization is successful, the master hard disk boot record is given 
   control and it examines the partition table embedded within it. If one of 
   the entries indicates an active (bootable) partition, its boot record is 
   read from the partition's first sector and given control.

3. If none of the partitions is bootable, ROM BASIC is invoked on an IBM PC or
    a disk error on most compatibles.

4. If any of the boot indicators are invalid, or if more than one indicator is 
   marked as bootable, the message INVALID PARTITION TABLE is displayed and the 
   system stops.

5. If the partition's boot record cannot be successfully read within five 
   retries due to read errors, the message ERROR LOADING OPERATING SYSTEM 
   appears and the system stops.

6. If the partition's boot record does not contain a valid "signature", the 
   message MISSING OPERATING SYSTEM appears, and the system stops.

NOTE: When changing the size or location of any partition, you must ensure that
      all existing data on the disk has been backed up. The partitioning program
      will destroy the data on the disk.



BOOT RECORD/PARTITION TABLE

 A boot record must be written on the first sector of all hard disks, and 
must contain the following:

1. Code to load and give control to the boot record for one of four possible 
   operating systems.

2. A partition table at the end of the boot record. Each table entry is 16 
   bytes long, and contains the starting and ending cylinder, sector, and head 
   for each of four possible partitions, as well as the number of sectors 
   preceding the partition and the number of sectors occupied by the partition. 
   The "boot indicator" byte is used by the boot record to determine if one of 
   the partitions contains a loadable operating system. FDISK initialization 
   utilities mark a user-selected partition as "bootable" by placing a value 
   of 80h in the corresponding partition's boot indicator (setting all other 
   partitions' indicators to 0 at the same time). The presence of the 80h tells 
   the standard boot routine to load the sector whose location is contained in 
   the following three bytes. That sector is the actual boot record for the 
   selected operating system, and it is responsible for the remainder of the 
   system's loading process (as it is from the diskette). All boot records are 
   loaded at absolute address 0:7C00.

The partition table with its offsets into the boot record is:
(except for Wyse DOS 3.2 with 32 bit allocation table, and DOS 3.3-up)
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³ Offset   /    Purpose            ³          ³   Head   ³  Sector  ³ Cylinder ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ´
³ 1BEh partition 1 begin           ³ boot ind ³    H     ³    S     ³   cyl    ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ´
³ 1C2h partition 1 end             ³ syst ind ³    H     ³    S     ³   cyl    ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³ 1C6h partition 1 relative sector ³      low word       ³      high word      ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 1CAh partition 1 # sectors       ³      low word       ³      high word      ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´
³ 1CEh partition 2 begin           ³ boot ind ³    H     ³    S     ³   cyl    ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ´
³ 1D2h partition 2 end             ³ syst ind ³    H     ³    S     ³   cyl    ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³ 1D6h partition 2 relative sector ³      low word       ³      high word      ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 1DAh partition 2 # sectors       ³      low word       ³      high word      ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´
³ 1DEh partition 3 begin           ³ boot ind ³    H     ³    S     ³   cyl    ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ´
³ 1E2h partition 3 end             ³ syst ind ³    H     ³    S     ³   cyl    ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³ 1E6h partition 3 relative sector ³      low word       ³      high word      ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 1EAh partition 3 # sectors       ³      low word       ³      high word      ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´
³ 1EEh partition 4 begin           ³ boot ind ³    H     ³    S     ³   cyl    ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ´
³ 1F2h partition 4 end             ³ syst ind ³    H     ³    S     ³   cyl    ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³ 1F6h partition 4 relative sector ³      low word       ³      high word      ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 1FAh partition 4 # sectors       ³      low word       ³      high word      ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
³ 1FEh signature                   ³  hex 55  ³  hex AA  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ



HARD DISK TECHNICAL INFORMATION

 Boot indicator (boot ind): The boot indicator byte must contain 0 for a non- 
bootable partition or 80h for a bootable partition. Only one partition can be 
marked as bootable at a time.

 System Indicator (sys ind): The sys ind field contains an indicator of the 
operating system that "owns" the partition.

          The system indicators are:
                       00h unknown (unspecified or non-DOS)
                       01h DOS 12 bit FAT
                       02h DOS 16 bit FAT

 Cylinder (CYL) and Sector (S): The 1 byte fields labelled CYL contain the low 
order 8 bits of the cylinder number - the high order 2 bits are in the high 
order 2 bits of the sector (S) field. This corresponds with the ROM BIOS 
interrupt 13h (disk I/O) requirements, to allow for a 10 bit cylinder number.

 The fields are ordered in such a manner that only two MOV instructions are 
required to properly set up the DX and CX registers for a ROM BIOS call to 
load the appropriate boot record (hard disk booting is only possible from the 
first hard disk in the system, where a BIOS drive number of 80h corresponds 
to the boot indicator byte).

 All partitions are allocated in cylinder multiples and begin on sector 1,
head 0.

 EXCEPTION: The partition that is allocated at the beginning of the disk starts 
at sector 2, to account for the hard disk's master boot record.

 Relative Sector (rel sect): The number of sectors preceding each partition 
on the disk is kept in the 4 byte field labelled "rel sect". This value is 
obtained by counting the sectors beginning with cylinder 0, sector 1, head 0 
of the disk, and incrementing the sector, head, and then track values up to 
the beginning of the partition. This, if the disk has 17 sectors per track and 
4 heads, and the second partition begins at cylinder 1, sector 1, head 0,and 
the partition's starting relative sector is 68 (decimal) - there were 17 
sectors on each of 4 heads on 1 track allocated ahead of it. The field is stored
with the least significant word first.

 Number of sectors (#sects): The number of sectors allocated to the partition 
is kept in the "# of sects" field. This is a 4 byte field stored least 
significant word first.

 Signature: The last 2 bytes of the boot record (55AAh) are used as a signature
to identify a valid boot record. Both this record and the partition boot record 
are required to contain the signature at offset 1FEh.

 The master disk boot record invokes ROM BASIC if no indicator byte reflects a 
bootable system.

 When a partition's boot record is given control. It is passed its partition 
table entry address in the DS:SI registers.



DETERMINING FIXED DISK ALLOCATION

DOS determines disk allocation using the following formula:
              
                                         D * BPD
                            TS - RS -  ÄÄÄÄÄÄÄÄÄÄÄ
                                           BPS
                      SPF = ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                                        BPS * SPC
                                 CF + ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                                           BPC
where:

     TS      total sectors on disk
     RS      the number of sectrs at the beginning of the disk that are reserved
             for the boot record. DOS reserves 1 sector.
     D       The number of directory entries in the root directory.
     BPD     the number of bytes per directory entry. This is always 32.
     BPS     the number of bytes per logical sector. Typically 512, but you can
             specify a different number with VDISK.
     CF      The number of FATS per disk. Usually 2. VDISK is 1.
     SPF     the number of sectors per FAT. Maximum 64.
     SPC     The number of sectors per allocation unit.
     BPC     the number of bytes per FAT entry. BPC is 1.5 for 12 bit FATs.
             2 for 16 bit FATS.


To calculate the minimum partition size that will force a 16-bit FAT:

        CYL = (max clusters * 8)/(HEADS * SPT)

where:
     CYL     number of cylinders on the disk
     max clusters  4092 (maximum number of clusters for a 12 bit FAT)
     HEADS   number of heads on the hard disk
     SPT     sectors per track  (normally 17 on MFM)


note: DOS 2.0 uses a "first fit" algorithm when allocating file space on the 
hard disk. Each time an application requests disk space, it will scan from the 
beginning of the FAT until it finds a contiguous peice of storage large enough 
for the file.
 DOS 3.0 keeps a pointer into the disk space, and begins its search from the 
point it last left off. This pointer is lost when the system is rebooted. 
This is called the "next fit" algorithm. It is faster than the first fit and 
helps minimize fragmentation.
 In either case, if the FCB function calls are used instead of the handle 
function calls, the file will be broken into peices starting with the first 
availible space on the disk.


Comment to 826. Comment(s). 
----------
Better late than never...
A partition table entry for the IBM AT is set up as follows:

        DB      drive   ; 0 or 80H, 80H marks a bootable, active partition
        DB      head1   ; starting heads
        DW      trksec1 ; starting track/sector (CX value for INT 13)
        DB      system  ; see below
        DB      head2   ; ending head
        DW      trksec2 ; ending track/sector
        DD      sector1 ; absolute # of starting sector
        DD      sector2 ; absolute # of last sector

The system byte is different for different O/S entries:

        1      DOS, 12-bit FAT entries
        4      DOS, 16-bit FAT entries
        DB     Concurrent DOS
        F2     2nd partition for Sperry machines with large disks

        And so on.  There are bytes for XENIX, Prologue and lots of other O/S. 
Many manufacturers diddle with these system bytes to implement more than 1 DOS
partition per disk.  The only one I know about who violates the rule that only
one DOS partition (1 or 4) per disk may exist is Tandon. 
 

CHAPTER 9

 Programming Technical Reference - IBM
 Copyright 1988, Dave Williams


                       INSTALLABLE DEVICE DRIVERS


DEVICE DRIVER FORMAT

 A device driver is a COM or EXE file that contains all of the code needed to
control an add-in device. It has a special header to identify it as a device,
define the strategy and interrupt entry points, and define its various
attributes.

NOTE: For device drivers the COM file must not use the ORG 100h. Since the
      driver does not use the program segment prefix, it is simply loaded
      without offset. Therefore the memory image file must have an origin of 0 
      (ORG 0 or no ORG statement).


TYPES OF DEVICES

 There are two types of devices: Character devices and Block devices. Their 
attributes are as follows:

 Character devices are designed to do character I/O in a serial manner like 
CON, AUX, and PRN. These devices have names like CON, AUX, CLOCK$, and you can 
open channels (handles or FCBs) to do input and output with them. Because 
character devices have only one name, they can only support one device.

 Block devices are the fixed disk or diskette drives on a system. They can do 
random I/O in peices called blocks, which are usually the physical sector 
size of the disk. These devices are not named as character devices are, and 
cannot be opened directly. Instead they are mapped by using the drive letters 
A,B,C etc. Block devices can have units within them. In this way, a single block
driver can be responsible for one or more disk drives. For example, the first
block device driver can be responsible for drives A,B,C,and D. This means it has
four units defined and therefore takes up four drive letters. The position of
the driver in the chain of all drives determines the way in which the drive
letters correspond. For example, if the device driver is the first block driver
in the device chain, and it defines four units, then these devices are called
A,B,C, and D. If the second device driver defines three units, then those units
are E,F,and G. DOS 1.x allows 16 devices. DOS 2.x allows 63, and DOS 3.x allows
26. It is recommended that drivers limit themselves to 26 devices for
compatibility with DOS 3.x.

 DOS doesn't care about the position of installed character devices versus 
block devices. The installed character devices get put into the chain ahead of
resident character devices so that you can override the system's default driver
for CON etc.

 Although it is sometimes beleived that installed block devices get linked into
the chain BEHIND the resident block devices, if you look at the actual device
chain, this is not true (though it is true in the sense that installed block
devices get assigned drive letters in sequence, starting with the next letter
after the last one assigned to a resident block device).



DEVICE HEADER

 A device driver requires a device header at the beginning of the file. This 
is the format of the device header:

                Field                           Length

        Pointer to next device header field     dword
        Attribute                               word
        Pointer to device strategy routine      word
        Pointer to device interrupt routine     word
        Name/Unit field                         8 bytes


POINTER TO NEXT DEVICE HEADER FIELD

 The device header field is a pointer to the device header of the next device 
driver. It is a doubleword field that is set by DOS at the time the device 
driver is loaded. The first word is an offset and the second word is the 
segment.
 If you are loading only one device driver, set the device header field to -1 
before loading the device. If you are loading more than one device driver, set 
the first word of the device driver header to the offset of the next device 
driver's header. Set the device driver header field of the last device driver 
to -1.


ATTRIBUTE FIELD

 The attribute field is a word field that describes the attributes of the 
device driver to the system. The attributes are:

        word    bits (decimal)
                15      1       character device
                        0       block device
                14      1       supports IOCTL
                        0       doesn't support IOCTL
                13      1       non-IBM format (block only)
                        0       IBM format
                12      not documented - unknown
                11      1       supports removeable media
                        0       doesn't support removeable media
                10      reserved for DOS
             through
                4       reserved for DOS
                3       1       current block device
                        0       not current block device
                2       1       current NUL device
                        0       not current NUL device
                1       1       current standard output device
                        0       not current standard output device



BIT 15  is the device type bit. Use it to tell the system the that driver is a
        block or character device.

BIT 14  is the IOCTL bit. It is used for both character and block devices. Use 
        it to tell DOS whether the device driver can handle control strings
        through the IOCTL function call 44h.
         If a device driver cannot process control strings, it should set bit
        14 to 0. This way DOS can return an error is an attempt is made through
        the IOCTL function call to send or receive control strings to the
        device. If a device can process control strings, it should set bit 14 
        to 1. This way, DOS makes calls to the IOCTL input and output device 
        function to send and receive IOCTL strings.
         The IOCTL functions allow data to be sent to and from the device 
        without actually doing a normal read or write. In this way, the device
        driver can use the data for its own use, (for example, setting a baud
        rate or stop bits, changing form lengths, etc.) It is up to the device
        to interpret the information that is passed to it, but the information
        must not be treated as a normal I/O request.


BIT 13  is the non-IBM format bit. It is used for block devices only. It affects
        the operation of the Get BPB (BIOS parameter block) device call.

BIT 11  is the open/close removeable media bit. Use it to tell DOS if the 
        device driver can handle removeable media. (DOS 3.x only)

BIT 3   is the clock device bit. It is used for character devices only. Use it 
        to tell DOS if your character device driver is the new CLOCK$ device.

BIT 2   is the NUL attribute bit. It is used for character devices only. Use it
        to tell DOS if your character device driver is a NUL device. Although
        there is a NUL device attribute bit, you cannot reassign the NUL device.
        This is an attribute that exists for DOS so that DOS can tell if the NUL
        device is being used.

BIT 0   are the standard input and output bits. They are used for character
  &     devices only. Use these bits to tell DOS if your character device 
BIT 1   driver is the new standard input device or standard output device.


POINTER TO STRATEGY AND INTERRUPT ROUTINES

 These two fields are pointers to the entry points of the strategy and input 
routines. They are word values, so they must be in the same segment as the 
device header.


NAME/UNIT FIELD

 This is an 8-byte field that contains the name of a character device or the 
unit of a block device. For the character names, the name is left-justified and
the space is filled to 8 bytes. For block devices, the number of units can be 
placed in the first byte. This is optional because DOS fills in this location 
with the value returned by the driver's INIT code.


CREATING A DEVICE DRIVER

 To create a device driver that DOS can install, perform the following:

1) Create a memory image file or an EXE file with a device header at the start 
   of the file.
2) Originate the code (including the device header) at 0, not 100h.
3) Set the next device header field. Refer to "Pointer to Next Device Header 
   Attribute Field" for more information.
4) Set the attribute field of the device header. Refer to "Attribute Field" for 
   more information.
5) Set the entry points for the interrupt and strategy routines.
6) Fill in the name/unit field with the name of the character device or the unit
   number of the block device.

 DOS always processes installable character device drivers before handling the 
default devices. So to install a new CON device, simply name the device CON. 
Be sure to set the standard input device and standard output device bits in 
the attribute field of a new CON device. The scan of the device list stops on 
the first match so the installable device driver takes precedence.

NOTE: Because DOS can install the device driver anywhere in memory, care 
      must be taken in any FAR memory references. You should not expect that 
      your driver will be loaded in the same place every time.



INSTALLING DEVICE DRIVERS

 DOS installs new device drivers dynamically at boot time by reading and 
processing the DEVICE command in the config.sys file. For example, if you have 
written a device driver called DRIVER1, to install it put this command in the 
CONFIG.SYS file:
                             DEVICE=DRIVER1

 DOS calls a device driver at its strategy entry point first, passing in a 
request header the information describing what DOS wants the device driver 
to do.
 This strategy routine does not perform the request but rather queues the 
request or saves a pointer to the request header. The second entry point is 
the interrupt routine and is called by DOS immediately after the strategy 
routine returns. The interrupt routine is called with no parameters. Its 
function is to perform the operation based on the queued request and set up 
any return infromation.
 DOS passes the pointer to the request header in ES:BX. This structure consists
of a fixed length header (Request Header) followed by data pertinent to the 
operation to be performed.

NOTE: It is the responsibility of the device driver to preserve the machine 
      state. For example, save all registers on entry and restore them on exit.

 The stack used by DOS has enough room on it to save all the registers. If more
stack space is needed, it is the device driver's responsibility to allocate and
maintain another stack.
 All calls to execute device drivers are FAR calls. FAR returns should be 
executed to return to DOS.



INSTALLING CHARACTER DEVICES

 One of the functions defined for each device is INIT. This routine is called 
only once when the device is installed and never again. The INIT routine returns
the following:

A) A location to the first free byte of memory after the device driver, like a
   TSR that is stored in the terminating address field. This way, the 
   initialization code can be used once and then thrown away to save space.
B) After setting the address field, a character device driver can set the status
   word and return.


INSTALLING BLOCK DEVICES

 Block devices are installed in the same way as character devices. The 
difference is that block devices return additional information. Block devices 
must also return:

A) The number of units in the block device. This number determines the logical 
   names the devices will have. For example, if the current logical device 
   letter is F at the time of the install call, and the block device driver INIT
   routine returns three logical units, the letters G, H, and I are assigned to 
   the units. The mapping is determined by the position of the driver in the 
   device list and the number of units in the device. The number of units 
   returned by INIT overrides the value in the name/unit field of the device 
   header.
B) A pointer to a BPB (BIOS parameter block) pointer array. This is a pointer 
   to an array of *n* word pointers there *n* is the number of units defined. 
   These word pointers point to BPBs. This way, if all of the units are the 
   same, the entire array can point to the same BPB to save space.
    The BPB contains information pertinent to the devices such as the sector 
   size, number of sectors per allocation unit, and so forth. The sector size of
   the BPB cannot be greater than the maximum allotted size set at DOS 
   initialization time.
   NOTE: This array must be protected below the free pointer set by the return.
C) The media descriptor byte. This byte is passed to devices so that they know 
   what parameters DOS is currently using for a particular drive unit.

 Block devices can take several approaches. They can be *dumb* or *smart*. A 
dumb device would define a unit (and therefore a BPB) for each possible media 
drive combination. Unit 0=drive 0;single side, unit 1=drive 0;double side, etc.
 For this approach, the media descriptor bytes would mean nothing. A smart 
device would allow multiple media per unit. In this case, the BPB table 
returned at INIT must define space large enough to acommodate the largest 
possible medias supported (sector size in BPB must be as large as maximum 
sector size DOS is currently using). Smart drivers will use the media byte to 
pass information about what media is currently in a unit.


REQUEST HEADER

 The request header passes the information describing what DOS wants the 
device driver to do.

ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³  Length  ³                       F i e l d                                   ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³   BYTE   ³ Length in bytes of the request header plus any data at end        ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³   BYTE   ³ Unit code. The subunit the operation is for (minor device)        ³
³          ³ Has no meaning for character devices.                             ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³   WORD   ³ Command code                                                      ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 8 BYTES  ³ Deserved for DOS                                                  ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³(variable)³ Data appropriate for the operation                                ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


UNIT CODE FIELD

 The unit code field identifies which unit in a block device driver the request
is for. For example, if a block device driver has three units defined, then the
possible values of the unit code field would be 0,1,and 2.


COMMAND CODE FIELD

 The command code field in the request header can have the following values:

      CODE         FUNCTION

        0       INIT
        1       MEDIA CHECK      (block only,NOP for character)
        2       BUILD BPB        (block only, NOP for character)
        3       IOCTL input      (called only if IOCTL bit is 1)
        4       INPUT            (read)
        5       NONDESTRUCTIVE INPUT NO WAIT (character devices only)
        6       INPUT STATUS     (character devices only)
        7       INPUT FLUSH      (character devices only)
        8       OUTPUT           (write)
        9       OUTPUT           (write with verify)
        10      OUTPUT STATUS    (character devices only)
        11      OUTPUT FLUSH     (character devices only)
        12      IOCTL OUTPUT     (called only if IOCTL bit is 1)
        13      DEVICE OPEN      (called only if OPEN/CLOSE/RM bit is set)
        14      DEVICE CLOSE     (called only if OPEN/CLOSE/RM bit is set)
        15      REMOVEABLE MEDIA (called only if OPEN/CLOSE/RM bit is set and
                                  device is block)

NOTE: Command codes 13,14,and 15 are for use with DOS versions 3.x.


STATUS FIELD
The status field in the request header contains:

ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³            D E V I C E    D R I V E R    S T A T U S    F I E L D            ³
ÃÄÄÄÄÄÄÄÂÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³   B   ³ 0 ³                                                                  ³
³       ³ 1 ³                                                                  ³
³   Y   ³ 2 ³                                                                  ³
³       ³ 3 ³   Error message return code                                      ³
³   T   ³ 4 ³   (with bit 15=1)                                                ³
³       ³ 5 ³                                                                  ³
³   E   ³ 6 ³                                                                  ³
³       ³ 7 ³                                                                  ³
ÃÄÄÄÄÄÄÄÅÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³  bit  ³ 8 ³   DONE                                                           ³
ÃÄÄÄÄÄÄÄÅÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³  bit  ³ 9 ³   BUSY                                                           ³
ÃÄÄÄÄÄÄÄÅÄÄÄÁÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³  bits ³ 10 - 14 ³   Reserved                                                 ³
ÃÄÄÄÄÄÄÄÅÄÄÄÄÂÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³  bit  ³ 15 ³   Error                                                         ³
ÀÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

 The status word field is zero on entry and is set by the driver interrupt 
routine on return.

BIT 15  is the error bit. If this bit is set, the low 8 bits of the status word
        (7-0) indicate the error code.

BITS 14-10 are reserved.

BIT 9   is the busy bit. It is only set by status calls and the removable media 
        call. See "STATUS" and "REMOVABLE MEDIA" in this chapter for more 
        information about the calls.

BIT 8   is the done bit. If it is set, it means the operation is complete. The 
        driver sets the bit to 1 when it exits.

 The low 8 bits of the status word define an error message if bit 15 is set. 
These errors are:

        00h  Write protect violation   01h  Unknown unit
        02h  Device not ready          03h  Unknown command
        04h  CRC error                 05h  Bad drive request structure length
        06h  seek error                07h  unknown media
        08h  sector not found          09h  printer out of paper
        0Ah  write fault               0Bh  read fault
        0Ch  general failure           0Dh  reserved
        0Eh  reserved                  0Fh  invalid disk change


DEVICE DRIVER FUNCTIONS

 All strategy routines are called with ES:BX pointing to the request header. 
The interrupt routines get the pointers to the request header from the queue 
the strategy routines store them in. The command code in the request header 
tells the driver which function to perform.
NOTE: all DWORD pointers are stored offset first, then segment.

The following function call parameters are described:

        INIT
        MEDIA CHECK
        BUILD BPB (BIOS PARAMETER BLOCK)
        MEDIA DESCRIPTOR BYTE
        INPUT OR OUTPUT
        NONDESTRUCTIVE INPUT NO WAIT
        STATUS
        FLUSH
        OPEN OR CLOSE
        REMOVABLE MEDIA


INIT
Command code=0
        ES:BX   pointer to request header. Format of header:
                length           field
                13 bytes  request header
                 dword    number of units (not set by character devices)
                 dword    Ending address of resident program code
                 dword    Pointer to BPB array (not set by character devices)
                          /pointer to remainder of arguments
                  byte    Drive number (3x only)

The driver must do the following:

        A) set the number of units (block devices only)
        B) set up the pointer to the BPB array (block devices only)
        C) perform any initialization code (to modems, printers, etc)
        D) Set the ending address of the resident program code
        E) set the status word in the request header.

 To obtain information obtained from CONFIG.SYS to a device driver at INIT 
time, the BPB pointer field points to a buffer containing the information 
passed from CONFIG.SYS following the =. The buffer that DOS passes to the 
driver at INIT after the file specification contains an ASCII string for the 
file OPEN. The ASCII string (ending in 0h) is terminated by a carriage return 
(0Dh) and linefeed (0Ah). If there is no parameter information after the file 
specification, the file specification is immediately followed by a linefeed 
(0Ah). This information is read-only and only system calls 01h-0Ch and 30h can 
be issued by the INIT code of the driver.
 The last byte parameter contains the drive letter for the first unit of a 
block driver. For example, 0=A, 1=B etc.
 If an INIT routine determines that it cannot set up the device and wants to 
abort without using any memory, follow this procedure:

        A) set the number of units to 0
        B) set the ending offset address at 0
        C) set the ending offsret segment address to the code segment (CS)

NOTE: If there are multiple device drivers in a single memory image file, the 
      ending address returned by the last INIT called is the one DOS uses. It is
      recommended that all device drivers in a single memory image file return
      the same ending address.


MEDIA CHECK
command code=1
        ES:BX   pointer to request header. Format of header:
                length          field
                13 bytes  request header
                byte      media descriptor from DOS
                byte      return
                dword     returns a pointer to the previous volume ID (if bit
                          11=1 and disk change is returned) (DOS 3.x)

 When the command code field is 1, DOS calls MEDIA CHECK for a drive unit and 
passes its current media descriptor byte. See "Media Descriptor Byte" later in 
this chapter for more information about the byte. MEDIA CHECK returns one of 
the following:

        A) media not changed             C) not sure
        B) media changed                 D) error code

The driver must perform the following:
        A) set the status word in the request header
        B) set the return byte
               -1       media has been changed
                0       don't know if media has been changed
                1       media has not been changed

 DOS 3.x: If the driver has set the removable media bit 11 of the device header
attribute word to 1 and the driver returns -1 (media changed), the driver must 
set the DWORD pointer to the previous volume identification field. If DOS 
determines that the media changed is an error, DOS generates an error 0Fh 
(invalid disk change) on behalf of the device. If the driver does not implement
volume identification support, but has bit 11 set to 1, the driver should set a
pointer to the string "NO NAME",0.


MEDIA DESCRIPTOR
 Currently the media descriptor byte has been defined for a few media types. 
This byte should be idetnical to the media byte if the device has the non-IBM 
format bit off. These predetermined values are:

media descriptor byte =>    1  1  1  1  1  0  0  0
 (numerical order)          7  6  5  4  3  2  1  0

       BIT                MEANING        

        0       1=2 sided       0=not 2 sided
        1       1=8 sector      0=not 8 sector
        2       1=removeable    0=nonremoveable
       3-7      must be set to 1


Examples of current DOS media descriptor bytes:

           media      sides   sectors  ID byte

        hard disk       *       *       0F8h
        5-1/4 floppy    2       15      0F9h
        5-1/4 floppy    1       9       0FCh
        5-1/4 floppy    2       9       0FDh
        5-1/4 floppy    2       8       0FFh
        5-1/4 floppy    1       8       0FEh
        8" floppy       1       26      0FEh *
        8" floppy       2       26      0FDh
        8" floppy       2       8       0FEh *

*NOTE: The two Media Descriptor Bytes that are the same for 8" diskettes (0FEh) 
are not a misprint. To determine whether you are using a single sided or double
sided diskette, attempt to read the second side, and if an error occurs you can
assume the diskette is single sided.


BUILD BPB (BIOS Parameter Block)
command code =2
        ES:BX   pointer to request header. Format:
                length          field
                13 bytes  request header
                byte      media descriptor from DOS
                dword     transfer address (buffer address)
                dword     pointer to BPB table

DOS calls BUILD BPB under the following two conditions:

A) If "media changed" is returned
B) If "not sure" is returned, there are no used buffers. Used buffers are 
   buffers with changed data that has not yet been written to the disk.

The driver must do the following:

A) set the pointer to the BPB
B) set the status word in the request header.

 The driver must determine the correct media type currently in the unit to 
return the pointer to the BPB table. The way the buffer is used (pointer 
passed by DOS) is determined by the non-IBM format bit in the attribute field 
of the device header. If bit 13=0 (device is IBM compatible), the buffer 
contains the first sector of the FAT (most importantly the FAT ID byte). The 
driver must not alter this buffer in this case. If bit 13=1 the buffer is a 
one sector scratch area which can be used for anything.
 For drivers that support volume identification and disk change, the call 
should cause a new volume identification to be read off the disk. This call 
indicates that the disk has been legally changed.
 If the device is IBM compatible, it must be true that the first sector of the 
first FAT is located at the same sector for all possible media. This is 
because the FAT sector is read before the media is actually determined.
 The information relating to the BPB for a particular media is kept in the boot
sector for the media. In particular, the format of the boot sector is:

ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ For DOS 2.x, 3 byte near jump (0E9h) For DOS 3.x, 2 byte near jump (0EBh)    ³
³ followed by a NOP (90h)                                                      ³
ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ 8 bytes  ³  OEM name and version                                             ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³   BYTE   ³     ³  sectors per allocation unit (must be a power of 2)         ³
ÃÄÄÄÄÄÄÄÄÄÄ´     ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³   WORD   ³  B  ³  reserved sectors (strarting at logical sector 0)           ³
ÃÄÄÄÄÄÄÄÄÄÄ´     ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³   BYTE   ³     ³  number of FATs                                             ³
ÃÄÄÄÄÄÄÄÄÄÄ´     ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³   WORD   ³  P  ³  max number of root directory entries                       ³
ÃÄÄÄÄÄÄÄÄÄÄ´     ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³   WORD   ³     ³  number of sectors in logical image (total number of        ³
³          ³     ³  sectors in media, including boot sector directories, etc.) ³
ÃÄÄÄÄÄÄÄÄÄÄ´  B  ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³   BYTE   ³     ³  media descriptor                                           ³
ÃÄÄÄÄÄÄÄÄÄÄ´     ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³   WORD   ³     ³  number of sectors occupied by a single FAT                 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³   WORD   ³  sectors per track                                                ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³   WORD   ³  number of heads                                                  ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³   WORD   ³  number of hidden sectors                                         ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

 The three words at the end return information about the media. The number of
heads is useful for supporting different multihead drives that have the same
storage capacity but a different number of surfaces. The number of hidden
sectors is useful for drive partitioning schemes.


INPUT / OUTPUT
command codes=3,4,8,9,and 12
        ES:BX   pointer to request header. Format:
                length          field
                13 bytes  request header
                byte      media descriptor byte
                dword     transfer address (buffer address)
                word      byte/sector count
                dword     (DOS 3.x) pointer to the volume ID if error code 0Fh
                          is returned

The driver must perform the following:
        A) set the status word in the request header
        B) perform the requested function
        C) set the actual number of sectors or bytes tranferred

NOTE: No error checking is performed on an IOCTL I/O call. However the driver 
      must set the return sector or byte count to the actual number of bytes 
      transferred.


The following applies to block device drivers: 

 Under certain circumstances the device driver may be asked to do a write 
operation of 64k bytes that seems to be a *wrap around* of the transfer address
in the device driver request packet. This arises due to an optimization added to
write code in DOS. It will only happen in writes that are within a sector size
of 64k on files that are being exetended past the current end of file. It is 
allowable for the device driver to ignore the balance of the write that wraps 
around, if it so chooses. For example, a write of 10000h bytes worth of sectors
with a transfer address of XXXX:1 ignores the last two bytes.

Remember: A program that uses DOS function calls can never request an input or 
          output function of more than 0FFFFh bytes, therefore, a wrap around 
          in the transfer (buffer) segment can never occur. It is for this 
          reason you can ignore bytes that would have wrapped around in the 
          tranfer segment.

 If the driver returns an error code of 0Fh (invalid disk change) it must put 
a DWORD pointer to an ASCIIZ string which is the correct volume ID to ask the 
user to reinsert the disk.

DOS 3.x:
 The reference count of open files on the field (maintained by the OPEN and 
CLOSE calls) allows the driver to determine when to return error 0Fh. If there 
are no open files (reference count=0) and the disk has been changed, the I/O 
is all right, and error 0Fh is not returned. If there are open files 
(reference count > 0) and the disk has been changed, an error 0Fh condition 
may exist.


NONDESTRUCTIVE INPUT NO WAIT
command code=5
        ES:BX   pointer to request header. Format:
                length          field
                13 bytes  request header
                byte      read from device

The driver must do the following:
        A) return a byte from the device
        B) set the status word in the request header.

 If the character device returns busy bit=0 (characters in the buffer), then 
the next character that would be read is returned. This character is not removed
form the buffer (hence the term nondestructive input). This call allows DOS to
look ahead one character.


STATUS
command codes=8 and 10
        ES:BX   pointer to a request header. Format:
                length          field
                13 bytes  request header

This driver must perform the following:
        A) perform the requested function
        B) set the busy bit
        C) set the status word in the request header.

The busy bit is set as follows:

 For input on character devices: if the busy bit is 1 on return, a write 
request would wait for completion of a current request. If the busy bit is 0, 
there is no current request. Therefore, a write request would start immediately.

 For input on character devices with a buffer: if the busy bit is 1 on return, 
a read request does to the physical device. If the busy bit is 0, there are 
characters in the device buffer and a read returns quickly. It also indicates 
that a user has typed something. DOS assumes all character devices have a type-
ahead input buffer. Devices that do not have this buffer should always return 
busy=0 so that DOS does not hang waiting for information to be put in a buffer
that does not exist.


FLUSH
command codes=7 and 11
        ES:BX   pointer
                length          field
                13 bytes  request header

 This call tells the driver to flush (terminate) all pending requests that it 
has knowledge of. Its primary use is to flush the input queue on character 
devices.
 The driver must set the status word in the request header upon return.


OPEN or CLOSE (3.x)
command codes=13 and 14
        ES:BX   pointer
                length          field
                13 bytes  static request header

 These calls are designed to give the device information about the current file
activity on the device if bit 11 of the attribute word is set. On block 
devices, these calls can be used to manage local buffering. The device can keep
a reference count. Every OPEN causes the device to increment the reference
count. Every CLOSE causes the device to decrement the reference count. When the
reference count is 0, if means there are no open files in the device. Therefore,
the device should flush buffers inside the device it has written to because now
the user can change the media on a removeable media drive. If the media had been
changed, it is advisable to reset the reference count to 0 without flushing the
buffers. This can be thought of as "last close causes flush". These calls are 
more useful on character devices. The OPEN call can be used to send a device 
initialization string. On a printer, this could cause a string to be sent to set
the font, page size, etc. so that the printer would always be in a known state
in the I/O stream. Similarly, a CLOSE call can be used to send a post string 
(like a form feed) at the end of an I/O stream. Using IOCTL to set these pre and
post strings provides a flexible mechanism of serial I/O device stream control.

NOTE: Since all processes have access to STDIN,STDOUT,STDERR,STDAUX, and STDPRN
      (handles 0,1,2,3,and 4) the CON, AUX, and PRN devices are always open.


REMOVABLE MEDIA (DOS 3.x)
command code=15
        ES:BX   pointer
                length          field
                13 bytes  status request header

 To use this call, set bit 11 of the attribute field to 1. Block devices can 
only use this call through a subfunction of the IOCTL function call (44h). 
This call is useful because it allows a utility to know whether it is dealing 
with a nonremovable media drive or with a removable media drive. For example, 
the FORMAT utility needs to know whether a drive is removable or nonremovable 
because it prints different versions of some prompts.

 The information is returned in the BUSY bit of the status word. If the busy 
bit is 1, the media is nonremovable. 

NOTE: No error checking is performed. It is assumed that this call always 
      succeeds.


THE CLOCK$ DEVICE

 To allow a clock board to be integrated into the system for TIME and DATE,
the CLOCK$ device is used. This device defines and performs functions like any
other character device (most functions will be reset done bit, reset error bit,
and return). When a read or write to this device occurs, 6 bytes are
transferred. The first 2 bytes are a word, which is the count of days since
01-01-80. The third byte is minutes, the fourth is hours, the fifth is
hundredths of a second, and the sixth is seconds. 
Reading the CLOCK$ device gets the date and time, writing to it sets the date 
and time.



CHAPTER 10

 Programming Technical Reference - IBM
 Copyright 1988, Dave Williams

           LOTUS-INTEL-MICROSOFT  EXPANDED MEMORY SPECIFICATION

The Expanded Memory Manager ............................................ 10-
        History ........................................................ 10-
        Page Frames .................................................... 10-
Expanded Memory Services ............................................... 10-
AST/Quadram/Ashton-Tate Enhanced EMM ................................... 10-
        Calling the Manager ............................................ 10-
        Common EMS Functions (hex calls)
                 1 (40h) Get Manager Status ............................ 10-
                 2 (41h) Get Page Frame Segment ........................ 10-
                 3 (42h) Get Number of Pages ........................... 10-
                 4 (43h) Get Handle and Allocate Memory ................ 10-
                 5 (44h) Map Memory .................................... 10-
                 6 (45h) Release Handle and Memory ..................... 10-
                 7 (46h) Get EMM Version ............................... 10-
                 8 (47h) Save Mapping Context .......................... 10-
                 9 (48h) Restore Mapping Context ....................... 10-
                10 (49h) Reserved ...................................... 10-
                11 (4Ah) Reserved ...................................... 10-
                12 (4Bh) Get Number of EMM Handles ..................... 10-
                12 (4Ch) Get Pages Owned By Handle ..................... 10-
                14 (4Dh) Get Pages for All Handles ..................... 10-
                15 (4Eh) Get Or Set Page Map ........................... 10-
       new LIM 4.0 specification:
                16 (4Fh) Get/Set Partial Page Map ...................... 10-
                17 (50h) Map/Unmap Multiple Pages ...................... 10-
                18 (51h) Reallocate Pages .............................. 10-
                19 (52h) Handle Attribute Functions .................... 10-
                20 (53h) Get Handle Name ............................... 10-
                21 (54h) Get Handle Directory .......................... 10-
                22 (55h) Alter Page Map & Jump ......................... 10-
                23 (56h) Alter Page Map & Call ......................... 10-
                24 (57h) Move Memory Region ............................ 10-
                25 (58h) Get Mappable Physical Address Array ........... 10-
                26 (59h) Get Expanded Memory Hardware .................. 10-
                27 (5Ah) Allocate Raw Pages ............................ 10-
                28 (5Bh) Get Alternate Map Register Set ................ 10-
                29 (5Ch) Prepare Expanded Memory Hardware .............. 10-
                30 (5Dh) Enable OS/E Function Set ...................... 10-
                31 (5Eh) Unknown ....................................... 10-
                32 (5Fh) Unknown ....................................... 10-
                33 (60h) Unknown ....................................... 10-
                34 (61h) AST Generic Accelerator Card Support .......... 10-
Expanded Memory Manager Error Codes .................................... 10-



THE EXPANDED MEMORY MANAGER

History

 The Lotus/Intel/Microsoft Expanded Memory Manager was originally a Lotus and
Intel project and was announced as version 3.0 in the second quarter of 1985
primarily as a means of running larger Lotus worksheets by transparently
paging unused sections to bank-switched memory. Shortly afterward Microsoft
announced support of the standard and version 3.2 was subsequently released
with support for Microsoft Windows. LIM 3.2 supported up to 8 megabytes of
paged memory. The LIM 4.0 supports up to 32 megabytes of paged memory.



AST/QUADRAM/ASHTON-TATE ENHANCED EXPANDED MEMORY SPECIFICATION

 The AQA EEMS maintains upward compatibility with the LIM, but is a superset
of functions.

 The AQA EEMS permits its pages to be scattered throughout the unused portion
of the machine's address space.

On August 19, 1987, the new version of the Expanded Memory Specification (EMS)
was announced by Lotus, Intel and Microsoft. This new version of the
specification includes many features of the Enhanced Expanded Memory
Specification (EEMS) originally developed by AST Reserach, Quadram and Ashton-
Tate, although the three original sponsoring companies elected not to make the
new specification upward compatible with EEMS. AST Research says that they will
endorse EMS 4.0 without reservation.

 The definitive document for the LIM-EMS is Intel part number 300275-004,
August, 1987.

                                                       32M ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                                                          /³              ³
                                                           ³              ³
                                                     /     ³              ³
                                                           ³              ³
                                                /          ³              ³
                                                           ³              ³
                                           /               ³              ³
                                                           ³   Expanded   ³
                                      /                    ³    Memory    ³
          1024K ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                           ³              ³
                ³ / / / / / /  ³  /                        ³              ³
           960K ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´                           ³              ³
                ³  Page Frame  ³                           ³              ³
                ³              ³                           ³              ³
                ³ 12 16K-Byte  ³                           ³              ³
                ³   Physical   ³                           ³              ³
                ³    Pages     ³                           ³              ³
           768K ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´                           ³ Divided into ³
                ³ / / / / / /  ³ \                         ³   logical    ³
           640K ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´                           ³    pages     ³
                ³              ³   \                       ³              ³
                ³              ³                           ³              ³
                ³              ³     \                     ³              ³
                ³              ³                           ³              ³
                ³ 24 16K-Byte  ³       \                   ³              ³
                ³   Physical   ³                           ³              ³
                ³    Pages*    ³         \                 ³              ³
                ³              ³                           ³              ³
                ³              ³           \               ³              ³
                ³              ³                           ³              ³
                ³              ³             \             ³              ³
           256K ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´                           ³              ³
                ³              ³               \           ³              ³
                ³ / / / / / /  ³                           ³              ³
                ³              ³                 \         ³              ³
                ³ / / / / / /  ³                           ³              ³
                ³              ³                   \       ³              ³
                ³ / / / / / /  ³                           ³              ³
                ³              ³                     \     ³              ³
              0 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                           ³              ³
                                                       \   ³              ³
                                                           ³              ³
                                                         \ ³              ³
                                                         0 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


 The page frame is located above the 640k system RAM area, anywhere from
0A000h to 0FFFFh. This area is used by the video adapters, network cards, and
add-on ROMs (as in hard disk controllers). The page frames are mapped around
areas that are in use.



                 WRITING PROGRAMS THAT USE EXPANDED MEMORY

 In order to use expanded memory, applications must perform these steps in the
following order:

1. Determine if EMM is installed.
2. Determine if enough expanded memory pages exist for your application.
   (Function 3)
3. Allocate expanded memory pages. (Function 4 or 18)
4. Get the page frame base address. (Function 2)
5. Map in expanded memory pages. (Function 5 or 17)
6. Read/write/execute data in expanded memory, just as if it were conventional
   memory.
7. Return expanded memory pages to expanded memory pool before exiting. Function
   6 or 18)


Programming Guidelines

 The following section contains guidelines for programmers writing applications
that use EMM.

A) Do not put a program's stack in expanded memory.

B) Do not replace interrupt 67h. This is the interrupt vector the EMM uses.
   Replacing interrupt 67h could result in disabling the Expanded Memory
   Manager.

C) Do not map into conventional memory address space your application doesn't
   own. Applications that use the EMM to swap into conventional memory space,
   must first allocate this space from the operating system. If the operating
   system is not aware that a region of memory it manages is in use, it will
   think it is available. This could have disastrous results. EMM should not be
   used to "allocate" conventional memory. DOS is the proper manager of
   conventional memory space. EMM should only be used to swap data in
   conventional memory space previously allocated from DOS.

D) Applications that plan on using data aliasing in expanded memory must check
   for the presence of expanded memory hardware. Data aliasing occurs when
   mapping one logical page into two or more mappable segments. This makes one
   16K-byte expanded memory page appear to be in more than one 16K-byte memory
   address space. Data aliasing is legal and sometimes useful for applications.
    Software-only expanded memory emulators cannot perform data aliasing. A
   simple way to distinguish software emulators from actual expanded memory
   hardware is to attempt data aliasing and check the results. For example, map
   one logical page into four physical pages. Write to physical page 0. Read
   physical pages 1-3 to see if the data is there as well. If the data appears
   in all four physical pages, then expanded memory hardware is installed in the
   system, and data aliasing is supported.

E) Applications should always return expanded memory pages to the expanded
   memory manager upon termination. These pages will be made available for other
   applications. If unneeded pages are not returned to the expanded memory
   manager, the system could run out of expanded memory pages or expanded
   memory handles.

F) Terminate and stay resident programs (TSRs) should always save the state of
   the map registers before changing them. Since TSRs may interrupt other
   programs which may be using expanded memory, they must not change the state
   of the page mapping registers without first saving them. Before exiting, TSRs
   must restore the state of the map registers.
    The following sections describe the three ways to save and restore the state
   of the map registers.
   1) Save Page Map and Restore Page Map (Functions 8 and 9). This is the
      simplest of the three methods. The EMM saves the map register contents in
      its own data structures -- the application does not need to provide extra
      storage locations for the mapping context. The last mapping context to be
      saved, under a particular handle, will be restored when a call to Restore
      Page Map is issued with the same handle. This method is limited to one
      mapping context for each handle and saves the context for only LIM
      standard 64K-byte page frames.
   2) Get/Set Page Map (Function 15). This method requires the application to
      allocate space for the storage array. The EMM saves the mapping context in
      an array whose address is passed to the EMM. When restoring the mapping
      context with this method, an application passes the address of an array
      which contains a previously stored mapping context. This method is
      preferable if an application needs to do more than one save before a
      restore. It provides a mechanism for switching between more than one
      mapping context.
   3) Get/Set Partial Page Map (Function 16). This method provides a way for
      saving a partial mapping context. It should be used when the application
      does not need to save the context of all mappable memory. This function
      also requires that the storage array be part of the application's data.

G) All functions using pointers to data structures must have those data
   structures in memory which will not be mapped out. Functions 22 and 23
   (Alter Map & Call and Alter Map & Jump) are the only exceptions.



EMS 4.0 SPECIFICATIONS

Page Frames

 The bank switched memory chunks are referred to as "page frames". These frame
consist of four 16K memory blocks mapped into some of the normally unused
system ROM address area, 0C0000-0EFFFF. Each 16K page is independent of the
other and they can map to discrete or overlapping areas of the 8 megabyte
expanded memory address area. Most cards allow selection of addresses to prevent
conflict with other cards, such as hard disk controllers and other expanded
memory boards.


Calling the Manager

 Applications programs communicate with the EMM device driver directly via user
interrupt 67h. All communication between the application program and the driver
bypasses DOS completely. To call the driver, register AH is loaded with the
number of the EMM service requested; DX is loaded with the file handle; and
interrupt 67h is called. ES:DI is used to pass the address of a buffer or array
if needed.
 On return AH contains 0 if the call was successful or an error code from 80h to
8Fh if unsuccessful.



          TESTING FOR THE PRESENCE OF THE EXPANDED MEMORY MANAGER

 Before an application program can use the Expanded Memory Manager, it must
determine whether the manager is present. The two recommended methods are the
"open handle" technique and the "get interrupt vector" technique.

 The majority of application programs can use either the "open handle" or the
"get interrupt vector" method. However, if your program is a device driver or
if it interrupts DOS during file system operations, you must use only the "get
interrupt vector" method.

 Device drivers execute from within DOS and can't access the DOS file functions;
programs that interrupt DOS during file operations have a similar restriction.
During their interrupt processing procedures, they can't access the DOS file
functions because another program may be using the system. Since the "get
interrupt vector" method doesn't require the DOS file functions, you must use
it for programs of this type.


 The "Open Handle" Method

 Most application programs can use the DOS "Open Handle" method to test for
the presence of the EMM. To use this method, follow these steps in order:

1) Issue an "open handle" command (DOS function 3Dh) in "read only" access mode
   (register AL = 0). This function requires your program to point to an ASCII
   string which contains the path name of the file or device in which you're
   interested (register set DS:DX contains the pointer). In this case the file
   is actually the reserved name of the expanded memory manager.

   you should format the ASCII string as follows:

   ASCII_device_name  DB  'EMMXXXX0', 0

   The ASCII codes for the capital letters EMMXXXX0 are terminated by a byte
   containing a value of zero.

2) If DOS returns no error code, skip Steps 3 and 4 and go to Step 5. If DOS
   returns a "Too many open files" error code, go to Step 3. If DOS returns a
   "File/Path not found" error code, skip Step 3 and go to Step 4.

3) If DOS returns a "Too many open files" (not enough handles) status code, your
   program should invoke the "open file" command before it opens any other
   files. This will guarantee that at least one file handle will be available to
   perform the function without causing this error.
    After the program performs the "open file" command, it should perform the
   test described in Step 6 and close the "file handle" (DOS function 3Eh).
   Don't keep the manager "open" after this status test is performed since
   "manager" functions are not available through DOS. Go to Step 6.

4) If DOS returns a "File/Path not found," the memory manager is not installed.
   If your application requires the memory manager, the user will have to reboot
   the system with a disk containing the memory manager and the appropriate
   CONFIG.SYS file before proceeding.

5) If DOS doesn't return an error status code you can assume that either a
   device with the name EMMXXXX0 is resident in the system, or a file with this
   name is on disk in the current disk drive. Go to Step 6.

6) Issue an "I/O Control for Devices" command (DOS function 44h) with a "get
   device information" command (register AL = 0). DOS function 44h determines
   whether EMMXXXX0 is a device or a file.
    You must use the file handle (register BX) which you obtained in Step 1 to
   access the "EMM" device.
   This function returns the "device information" in a word (register DX).
   Go to Step 7.

7. If DOS returns any error code, you should assume that the memory manager
   device driver is not installed. If your application requires the memory
   manager, the user will have to reboot the system with a disk containing the
   memory manager and the appropriate CONFIG.SYS file before proceeding.

8) If DOS didn't return an error status, test the contents of bit 7 (counting
   from 0) of the "device information" word (register DX) the function
   returned. Go to Step 9.

9) If bit 7 of the "device information" word contains a zero, then EMMXXXX0 is
   a file, and the memory manager device driver is not present. If your
   application requires the memory manager, the user will have to reboot the
   system with a disk containing the memory manager and the appropriate
   CONFIG.SYS file before proceeding.
    If bit 7 contains a one, then EMMXXXX0 is a device. Go to Step 10.

10) Issue an "I/O Control for Devices" command (DOS function 44h) with a "get
    output status" command (register AL = 7). You must use the file handle you
    obtained in Step 1 to access the "EMM" device (register BX). Go to Step 11.

11) If the expanded memory device driver is ready, the memory manager passes
    a status value of 0FFh in register AL. The status value is 00h if the device
    driver is not ready.
     If the memory manager device driver is "not ready" and your application
    requires its presence, the user will have to reboot the system with a disk
    containing the memory manager and the appropriate CONFIG.SYS file before
    proceeding.
     If the memory manager device driver is "ready," go to Step 12.

12) Issue a "Close File Handle" command (DOS function 3Eh) to close the expanded
    memory device driver. You must use the file handle you obtained in Step 1 to
    close the "EMM" device (register BX).



 The "Get Interrupt Vector" technique

 Any type of program can use this method to test for the presence of the EMM.

 Use this method (not the "Open Handle" method) if your program is a device
driver or if it interrupts DOS during file system operations.

 Follow these steps in order:

1) Issue a "get vector" command (DOS function 35h) to obtain the contents of
   interrupt vector array entry number 67h (addresses 0000:019Ch thru
   0000:019Fh).
    The memory manager uses this interrupt vector to perform all manager
   functions. The offset portion of this interrupt service routine address is
   stored in the word located at address 0000:019Ch; the segment portion is
   stored in the word located at address 0000:019Eh.
2) Compare the "device name field" with the contents of the ASCII string which
   starts at the address specified by the segment portion of the contents of
   interrupt vector address 67h and a fixed offset of 000Ah. If DOS loaded the
   memory manager at boot time this name field will have the name of the device
   in it.
    Since the memory manager is implemented as a character device driver, its
   program origin is 0000h. Device drivers are required to have a "device
   header" located at the program origin. Within the "device header" is an 8
   byte "device name field." For a character mode device driver this name field
   is always located at offset 000Ah within the device header. The device name
   field contains the name of the device which DOS uses when it references the
   device.
    If the result of the "string compare" in this technique is positive, the
   memory manager is present.



 Terminate and Stay Resident (TSR) Program Cooperation:
 In order for TSR's to cooperate with each other and with other applications,
TSRs must follow this rule: a program may only remap the DOS partition it lives
in. This rule applies at all times, even when no expanded memory is present.




EXPANDED MEMORY SERVICES

FUNCTIONS DEFINED IN EMS 3.2 SPECIFICATION

Interrupt 67h

Function 40h Get Manager Status
LIM Function Call 1
             Returns a status code indicating whether the memory manager is
             present and the hardware is working correctly.
entry   AH      40h
return  AH      error status: 00h, 80h, 81h, 84h
note 1) upward and downward compatible with both EMS and EEMS 3.2.
        this call can be used only after establishing that the EMS driver is in
        fact present
     2) uses register AX


Function 41h Get Page Frame Segment
LIM Function Call 2
             Obtain segment address of the page frame used by the EMM.
entry   AH      41h
return  AH      error status: 00h, 80h, 81h, 84h
        BX      page frame segment address (error code 0)
note 1) upward and downward compatible with both EMS and EEMS 3.2.
     2) uses registers AX & BX


Function 42h Get Unallocated Page Count
LIM Function Call 3
             Obtain total number of logical expanded memory pages present in
             the system and the number of those pages not already allocated.
entry   AH      42h
return  AH      error status: 00h, 80h, 81h, 84h
        BX      number of unallocated pages currently availible
        DX      total number of pages
note 1) upward and downward compatible with both EMS and EEMS 3.2. Note that EMS
        and EEMS 3.2 had no mechanism to return the maximum number of handles
        that can be allocated by programs. This is handled by the EMS 4.0 new
        function 54h/02h.
     2) uses registers AX, BX, DX


Function 43h Get Handle and Allocate Memory
LIM Function Call 4
             Notifies the EMM that a program will be using extended memory,
             obtains a handle, and allocates a certain number of logical pages
             of extended memory to be controlled by that handle
entry   AH      43h
        BX      number of 16k logical pages requested (zero OK)
return  AH      error status: 00h, 80h, 81h, 84h, 85h, 87h, 88h, 89h
        DX      unique EMM handle (see note 2)
note 1) upward compatible with both EMS and EEMS 3.2; EMS and EEMS 3.2 do not
        allow the allocation of zero pages (returns error status 89h). EMS 4.0
        does allow zero pages to be requested for a handle, allocating pages
        later using function 51h
     2) your program must use this EMM handle as a parameter in any function
        that requires it. You can use up to 255 handles. The uppermost byte of
        the handle will be zero and cannot be used by the application.
     3) regs AX & DX are used


Function 44h Map Memory
LIM Function Call 5
             Maps one of the logical pages of expanded memory assigned to a
             handle onto one of the four physical pages within the EMM's page
             frame.
entry   AH      44h
        AL      physical page to be mapped (0-3)
        BX      the logical page to be mapped (zero through [number of pages
                allocated to the EMM handle - 1]). If the logical page number
                is 0FFFFh, the physical page specified in AL will be unmapped
                (made inaccessible for reading or writing).
        DX      the EMM handle your program received from Function 4 (Allocate
                Pages).
return  AH      error status: 00h, 80h, 81h, 83h, 84h, 8Ah, 8Bh
note 1) downward compatible with both EMS and EEMS 3.2; EMS and EEMS 3.2 do not
        support unmap (logical page 0FFFFh) capability. Also, EEMS 3.2
        specified there were precisely four physical pages; EMS 4.0 uses the
        subfunctions of function 58h to return the permitted number of physical
        pages. This incorporates the functionality of function 69h ("function
        42") of EEMS.
     2) uses register AX


Function 45h Release Handle and Memory
LIM Function Call 6
             Deallocates the logical pages of expanded memory currently
             assigned to a handle and then releases the handle itself.
entry   AH      45h
        DX      handle
return  AH      error status: 00h, 80h, 81h, 83h, 84h, 86h
note 1) upward and downward compatible with both EMS and EEMS 3.2.
     2) uses register AX
     3) when a handle is deallocated, its name is set to all ASCII nulls
        (binary zeros).
     4) a program must perform this function before it exits to DOS or no other
        programs can use these pages or the EMM handle.


Function 46h Get EMM Version
LIM Function Call 7
             Returns the version number of the Expanded Memory Manager software.
entry   AH      46h
return  AH      error status: 00h, 80h, 81h, 84h
        AL      version number byte (if AL=00h)
                binary coded decimal (BCD) format if version byte:
                high nibble: integer digit of the version number
                low nibble : fractional digit of version number
                i.e., version 4.0 is represented like this:
                          0100 0000
                            /   \
                           4  .  0
note 1) upward and downward compatible with both EMS and EEMS 3.2. It appears
        that the intended use for this function is to return the version of the
        vendor implementation of the expanded memory manager instead of the
        specification version.
     2) uses register AX


Function 47h Save Mapping Context
LIM Function Call 8
             Save the contents of the expanded memory page-mapping registers on
             the expanded memory boards, associating those contents with a
             specific EMM handle.
entry   AH      47h
        DX      caller's EMM handle (NOT current EMM handle)
return  AH      error status:  00h, 80h, 81h, 83h, 84h, 8Ch, 8Dh
note 1) upward and downward compatible with both EMS and EEMS 3.2.
     2) This only saves the context saved in EMS 3.2 specification; if a driver,
        interrupt routine or TSR needs to do more, functions 4Eh (Page Map
        functions) or 4Fh (Partial Page Map functions) should be used.
     3) no mention is made about the number of save contexts to provide. AST
        recommends in their Rampage AT manual one save context for each handle
        plus one per possible interrupt (5 + <handles>).
     4) uses register AX
     5) this function saves the state of the map registers for only the 64K page
        frame defined in versions 3.x of the LIM. Since all applications written
        to LIM versions 3.x require saving the map register state of only this
        64K page frame, saving the entire mapping state for a large number of
        mappable pages would be inefficient use of memory. Applications that use
        a mappable memory region outside the LIM 3.x page frame should use
        functions 15 or 16 to save and restore the state of the map registers.


Function 48h Restore Page Map
LIM Function Call 9
             Restores the contents of all expanded memory hardwere page-mapping
             registers to the values associated with the given handle by a
             previous function 08h (Save Mapping Context).
entry   AH      48h
        DX      caller's EMM handle (NOT current EMM handle)
return  AH      error status: 00h, 80h, 81h, 83h, 84h, 8Eh
note 1) upward and downward compatible with both EMS and EEMS 3.2.
     2) This only restores the context saved in EMS 3.2 specification; if a
        driver, interrupt routine or TSR needs to do more, functions 4Eh (Page
        Map functions) or 4Fh (Partial Page Map functions) should be used.
     3) uses register AX
     4) this function saves the state of the map registers for only the 64K page
        frame defined in versions 3.x of the LIM. Since all applications written
        to LIM versions 3.x require saving the map register state of only this
        64K page frame, saving the entire mapping state for a large number of
        mappable pages would be inefficient use of memory. Applications that use
        a mappable memory region outside the LIM 3.x page frame should use
        functions 15 or 16 to save and restore the state of the map registers.


Function 49h Reserved
LIM Function Call 10
             This function was used in EMS 3.0, but was no longer documented in
             EMS 3.2. It formerly returned the page mapping register I/O port
             array. Use of this function is discouraged, and in EMS 4.0 may
             conflict with the use of the new functions 16 through 30 (4Fh
             through 5Dh) and functions 10 and 11. Functions 10 and 11 are
             specific to the hardware on Intel expanded memory boards and may
             not work correctly on all vendors' expanded memory boards.


Function 4Ah Reserved
LIM Function Call 11
             This function was used in EMS 3.0, but was no longer documented in
             EMS 3.2. It was formerly Get Page Translation Array. Use of this
             function is discouraged, and in EMS 4.0 may conflict with the use
             of the new functions (4Fh through 5Dh).


Function 4Bh Get Number of EMM Handles
LIM Function Call 12
             The Get Handle Count function returns the number of open EMM
             handles (including the operating system handle 0) in the system.
entry   AH      4Bh
return  AH      error status: 00h, 80h, 81h, 84h
        BX      handle count (AH=00h) (including the operating system handle
                [0]). max 255.
note 1) upward and downward compatible with EMS and EEMS 3.2.
     2) uses registers AX and BX


Function 4Ch Get Pages Owned by Handle
LIM Function Call 13
             Returns number of logical expanded memory pages allocated to a
             specific EMM handle.
entry   AH      4Ch
        DX      handle
return  AH      error status: 00h, 80h, 81h, 83h, 84h
        BX      pages allocated to handle, max 2048 because the EMM allows a
                maximum of 2048 pages (32M bytes) of expanded memory.
note 1) This function is upward compatible with EMS and EEMS 3.2.
     2) programmers should compare the number returned in BX with the maximum
        number of pages returned by function 42h register DX, total number of
        EMM pages. This should be an UNSIGNED comparison, just in case the spec
        writers decide to use 16 bit unsigned numbers (for a maximum space of
        one gigabyte) instead of signed numbers (for a maximum space of 512
        megabytes). Unsigned comparisons will work properly in either case
     3) uses registers AX and BX


Function 4Dh Get Pages for All Handles
LIM Function Call 14
             Returns an array containing all active handles and the number of
             logical expanded memory pages associated with each handle.
entry   AH      4Dh
        ES:DI   pointer to 1020 byte array to receive information on an array of
                structures where a copy of all open EMM handles and the number
                of pages allocated to each will be stored.
return  AH      error status: 00h, 80h, 81h, 84h
        BX      number of active handles (1-255); array filled with 2-word
                entries, consisting of a handle and the number of pages
                allocated to that handle. (including the operating system handle
                [0]). BX cannot be zero because the operating system handle is
                always active and cannot be deallocated.
note 1) NOT COMPATIBLE with EMS or EEMS 3.2, since the new special OS handle
        0000h is returned as part of the array. Unless benign use of this
        information is used (such as displaying the handle and count of pages
        associated with the handle) code should be changed to only work with
        handles between 01h and FFh and to specifically ignore handle 00h.
     2) The array consists of an array of 255 elements. The first word of each
        element is the handle number, the second word contains the number of
        pages allocated.
     3) There are two types of handles, "standard" and "raw". The specification
        does not talk about how this function works when both raw and standard
        handles exist in a given system. There is no currently known way to
        differentiate between a standard handle and a raw handle in EMS 4.0.
     4) uses registers AX and BX


Function 4Eh Get or Set Page Map
LIM Function Call 15
             Gets or sets the contents of the EMS page-mapping registers on the
             expanded memory boards.
              This group of four subfunctions is provided for context switching
             required by operating environments and systems. These functions are
             upward and downward compatible with both EMS and EEMS 3.2; in
             addition, these functions now include the functionality of EEMS
             function 6Ah ("function 43") involving all pages.
              The size and contents of the map register array will vary from
             system to system based on hardware vendor, software vendor, number
             of boards and the capacity of each board in the system. Note the
             array size can be determined by function 4Eh/03h.
              Use these functions (except for 03h) instead of Functions 8 and 9
             if you need to save or restore the mapping context but don't want
             (or have) to use a handle.

        00h  Get Page Map
             This call saves the mapping context for all mappable memory regions
             (conventional and expanded) by copying the contents of the mapping
             registers from each expanded memory board to a destination array.
             The application must pass a pointer to the destination array.
entry   AH      4Eh
        AL      00h
        ES:DI   pointer to target array
return  AH      error status: 00h, 80h, 81h, 84h, 8Fh
note 1) uses register AX
     2) does not use an EMM handle


         01h  Set Page Map
             This call the mapping context for all mappable memory regions
             (conventional and expanded) by copying the contents of a source
             array into the mapping registers on each expanded memory board in
             the system. The application must pass a pointer to the source array.
entry   AH      4Eh
        AL      01h
        DS:SI   pointer to source array
return  AH      error status: 00h, 80h, 81h, 84h, 8Fh, 0A3h
note 1) uses register AX
     2) does not use an EMM handle


        02h  Get & Set Page Map
             This call simultaneously saves the current mapping context and
             restores a previous mapping context for all mappable memory regions
             (both conventional and expanded). It first copies the contents of
             the mapping registers from each expanded memory board in the system
             into a destination array. Then the subfunction copies the contents
             of a source array into the mapping registers on each of the
             expanded memory boards.
entry   AH      4Eh
        AL      02h
        DS:SI   pointer to source array
        ES:DI   pointer to target array
return  AH      error status: 00h, 80h, 81h, 84h, 8Fh, 0A3h
note 1) uses register AX


          03h  Get Size of Page Map Save Array
entry   AH      4Eh
        AL      03h
return  AH      error status:  00h, 80h, 81h, 84h, 8Fh
        AL      size in bytes of array
note 1) this subfunction does not require an EMM handle
     2) uses register AX



FUNCTIONS NEW TO EMS 4.0

Function 4Eh Get or Set Page Map
LIM Function Call 16
entry   AH      4Eh
        AL      00h     if getting mapping registers
                01h     if setting mapping registers
                02h     if getting and setting mapping registers at once
                03h     if getting size of page-mapping array
        DS:SI   pointer to array holding information (AL=01/02)
        ES:DI   pointer to array to receive information (AL=00/02)
return  AH      error status: 00h, 80h, 81h, 84h, 8Fh, 0A3h
note 1) this function was designed to be used by multitasking operating systems
        and should not ordinarily be used by appplication software.


Function 4Fh Get/Set Partial Page Map
LIM Function Call 16
             These four subfunctions are provided for context switching required
             by interrupt routines, operating environments and systems. This set
             of functions provides extended functionality over the EEMS function
             6Ah (function 43) involving subsets of pages. In EEMS, a subset of
             pages could be specified by starting position and number of pages;
             in this function a list of pages is specified, which need not be
             contiguous.
              Interrupt routines can use this function in place of functions 47h
             and 48h, especially if the interrupt routine wants to use more than
             the standard four physical pages.
        AH      4Fh
        AL      subfunction
                00h     get partial page map
                        DS:SI   pointer to structure containing list of
                                segments whose mapping contexts are to be saved
                        ES:DI   pointer to array to receive page map
                01h     set partial page map
                        DS:SI   pointer to structure containing saved partial
                                page map
                02h     get size of partial page map
                        BX      number of mappable segments in the partial map
                                to be saved
return  AH      error status (00h): 00h, 80h, 81h, 84h, 8Bh, 8Fh, 0A3h
                error status (01h): 00h, 80h, 81h, 84h, 8Fh, 0A3h
                error status (02h): 00h, 80h, 81h, 84h, 8Bh, 8Fh
        AL      size of partial page map for subfunction 02h
        DS:SI   (call 00h) pointer to array containing the partial mapping
                context and any additional information necessary to restore this
                context to its original state when the program invokes a Set
                subfunction.
note    uses register AX


Function 50h Map/Unmap Multiple Pages
LIM Function Call 17
entry   AH      50h
        AL      00h     (by physical page)
                01h     (by segment number)
        CX      contains the number of entries in the array. For example, if the
                array contained four pages to map or unmap, then CX would
                contain 4.
        DX      handle
        DS:SI   pointer to an array of structures that contains the information
                necessary to map the desired pages.
return  AH      error status: 00h, 80h, 81h, 83h, 84h, 8Ah, 8Bh, 8Fh
note 1) New function permits multiple logical-to-physical assignments to be made
        in a single call.(faster than mapping individual pages)
     2) The source map array is an array of word pairs. The first word of a
        pair contains the logical page to map (0FFFFh if the physical page is
        to be totally unmapped) and the second word of a pair contains the
        physical page number (subfunction 00h) or the segment selector
        (subfunction 01h) of the physical page in which the logical page shall
        be mapped.
     3) A map of available physical pages (by physical page number and segment
        selectors) can be obtained using function 58h/00h, Get Mappable
        Physical Address Array.
     4) uses register AX
     5) Both mapping and unmapping pages can be done simultaneously.
     6) If a request to map or unmap zero pages is made, nothing is done and no
        error is returned.
     7) Pages can be mapped or unmapped using one of two methods. Both methods
        produce identical results.
         A) A logical page and a physical page at which the logical page is to
            be mapped. This method is an extension of Function 5 (Map Handle
            Page).
         B) Specifys both a logical page and a corresponding segment address at
            which the logical page is to be mapped. While functionally the same
            as the first method, it may be easier to use the actual segment
            address of a physical page than to use a number which only
            represents its location. The memory manager verifies whether the
            specified segment address falls on the boundary of a mappable
            physical page. The manager then translates the segment address
            passed to it into the necessary internal representation to map the
            pages.


Function 51h Reallocate pages
LIM Function Call 18
             This function allows an application to change the number of logical
             pages allocated to an EMM handle.
entry   AH      51h
        BX      number of pages desired at return
        DX      handle
return  AH      error status: 00h, 80h, 81h, 83h, 84h, 87h, 88h
        BX      number of pages now associated with handle
note 1) uses registers AX, BX
     2) Logical pages which were originally allocated with Function 4 are called
        pages and are 16K bytes long. Logical pages which were allocated with
        Function 27 are called raw pages and might not be the same size as pages
        allocated with Function 4.
     3) If the status returned in BX is not zero, the value in BX is equal to
        the number of pages allocated to the handle prior to calling this
        function. This information can be used to verify that the request
        generated the expected results.


Function 52h Get/Set Handle Attributes
LIM Function Call 19
entry   AH      52h
        AL      subfunction
                00h     get handle attributes
                01h     set handle attributes
                        BL      new attribute
                                00h     make handle volatile
                                01h     make handle non-volatile
                02h     get attribute capability
        DX      handle
return  AH      error status: (function 00h) 00h, 80h, 81h, 83h, 84h, 8Fh, 91h
                error status: (function 01h) 00h, 80h, 81h, 83h, 84h, 8Fh, 90h,
                                             91h
                error status: (function 02h) 00h, 80h, 81h, 84h, 8Fh
        AL      attribute (for subfunction 00h)
                00h     handle is volatile
                01h     handle is nonvolatile
        AL      attribute capability (for subfunction 02h)
                00h     only volatile handles supported
                01h     both volatile and non-volatile supported
note 1) uses register AX
     2) A volatile handle attribute instructs the memory manager to deallocate
        both the handle and the pages allocated to it after a warm boot. If all
        handles have the volatile attribute (default) at warm boot the handle
        directory will be empty and all expanded memory will be initialized to
        zero immediately after a warm boot.
     3) If the handle's attribute has been set to non-volatile, the handle, its
        name (if it is assigned one), and the contents of the pages allocated to
        the handle are all maintained after a warm boot.
     4) Most PCs disable RAM refresh signals for a considerable period during a
        warm boot. This can corrupt some of the data in memory boards. Non-
        volatile handles should not be used unless it is definitely known that
        the EMS board will retain proper function through a warm boot.
     5) subfunction 02h can be used to determine whether the memory manager can
        support the non-volatile attribute.
     6) Currently the only attribute supported is non-volatile handles and
        pages, indicated by the least significant bit.


Function 53h Handle Name Functions
LIM Function Call 20
             EMS handles may be named. Each name may be any eight characters.
             At installation, all handles have their name initialized to ASCII
             nulls (binary zeros). There is no restriction on the characters
             which may be used in the handle name (ASCII chars 00h through
             0FFh). A name of eight nulls (zeroes) is special, and indicates a
             handle has no name. Nulls have no special significance, and they
             can appear in the middle of a name. The handle name is 64 bits of
             binary information to the EMM.
              Functions 53h and 54h provide a way of setting and reading the
             names associated with a particular handle. Function 53h manipulates
             names by number.
              When a handle is assigned a name, at least one character in the
             name must be a non-null character in order to distinguish it from
             a handle without a name.

        00h  Get Handle Name
             This subfunction gets the eight character name currently
             assigned to a handle.
              The handle name is initialized to ASCII nulls (binary zeros)
             three times:  when the memory manager is installed, when a handle
             is allocated, and when a handle is deallocated.
entry   AH      53h
        AL      00h
        DX      handle
        ES:DI   pointer to 8-byte handle name array into which the name
                currently assigned to the handle will be copied.
return  AH      error status: 00h, 80h, 81h, 83h, 84h, 8Fh
note    uses register AX

        01h  Set Handle Name
             This subfunction assigns an eight character name to a handle.
             A handle can be renamed at any time by setting the handle's
             name to a new value. When a handle is deallocated, its name is
             removed (set to ASCII nulls).
entry   AH      53h
        AL      01h
        DX      handle
        DS:SI   pointer to 8-byte handle name array that is to be assigned to
                the handle. The handle name must be padded with nulls if the
                name is less than eight characters long.
return  AH      error status: 00h, 80h, 81h, 83h, 84h, 8Fh, 0A1h
note    uses register AX


Function 54h Handle Directory Functions
LIM Function Call 21
             Function 54h manipulates handles by name.

        00h  Get Handle Directory
             Returns an array which contains all active handles and the names
             associated with each.
entry   AH      54h
        AL      00h
        ES:DI   pointer to 2550 byte target array
return  AH      error status: 00h, 80h, 81h, 84h, 8Fh
        AL      number of active handles
note 1) The name array consists of 10 byte entries; each entry has a word
        containing the handle number, followed by the eight byte (64 bit) name.
     2) uses register AX
     3) The number of bytes required by the target array is:
                10 bytes * total number of handles
     4) The maximum size of this array is:
                (10 bytes/entry) * 255 entries = 2550 bytes.

        01h  Search for Named Handle
             Searches the handle name directory for a handle with a particular
             name. If the named handle is found, this subfunction returns the
             handle number associated with the name.
entry   AH      54h
        AL      01h
        DS:SI   pointer to an 8-byte string that contains the name of the
                handle being searched for
return  AH      error status: 00h, 80h, 81h, 84h, 8Fh, A0h, 0A1h
        DX      handle number
note 1) uses registers AX and DX

        02h  Get Total Handles
             Returns the total number of handles the EMM supports, including
             the operating system handle (handle value 0).
entry   AH      54h
        AL      02h
return  AH      error status: 00h, 80h, 81h, 84h, 8Fh
        BX      total number of handles availible
note 1) This is NOT the current number of handles defined, but the maximum
        number of handles that can be supported in the current environment.
     2) uses registers AX and BX


Function 55h Alter Page Map and Jump (cross page branch)
LIM Function Call 22
             Alters the memory mapping context and transfers control to the
             specified address. Analogous to the FAR JUMP in the 8086 family
             architecture. The memory mapping context which existed before
             calling function is lost.
entry   AH      55h
        AL      00h     physical page numbers provided by caller
                01h     segment addresses provided by caller
        DX      handle
        DS:SI   pointer to structure containing map and jump address
return  AH      error status: 00h, 80h, 81h, 83h, 84h, 8Ah, 8Bh, 8Fh
note 1) Flags and all registers except AX are preserved across the jump.
     2) uses register AX
     3) Values in registers which don't contain required parameters maintain the
        values across the jump. The values in registers (with the exception of
        AX) and the flag state at the beginning of the function are still in the
        registers and flags when the target address is reached.
     4) Mapping no pages and jumping is not considered an error. If a request to
        map zero pages and jump is made, control is transferred to the target
        address, and this function performs a far jump.


Function 56h Alter Page Map and Call (cross page call)
LIM Function Call 23
        00h and 01h
               This subfunction saves the current memory mapping context,
               alters the specified memory mapping context, and transfers
               control to the specified address.
entry   AH      56h
        AL      00h physical page numbers provided by caller
                01h segment addresses provided by caller
        DS:SI   pointer to structure containing page map and call address
        DX      handle
return  AH      error status: 00h, 80h, 81h, 83h, 84h, 8Ah, 8Bh, 8Fh
note 1) Flags and all registers except AX are preserved to the called routine.
        On return, flags and all registers except AX are preserved; AL is set to
        zero and AX is undefined.
     2) uses register AX
     3) Values in registers which don't contain required parameters maintain
        the values across the call. The values in registers (with the exception
        of AX) and the flag state at the beginning of the function are still in
        the registers and flags when the target address is reached.
     4) Developers using this subfunction must make allowances for the
        additional stack space this subfunction will use.

        02h  Get Page Map Stack Space Size
             Since the Alter Page Map & Call function pushes additional
             information onto the stack, this subfunction returns the number of
             bytes of stack space the function requires.
entry   AH      56h
        AL      02h
return: BX      number of bytes of stack used per call
        AH      error status: 00h, 80h, 81h, 84h, 8Fh
note 1) if successful, the target address is called. Use a RETF to return and
        restore mapping context
     2) uses registers AX, BX


Function 57h Move/Exchange Memory Region
LIM Function Call 24
        00h  Move Memory Region
             Moves data between two memory areas. Includes moves between paged
             and non-paged areas, or between two different paged areas.
entry   AH      57h
        AL      00h
        SI      offset to request block
        DS      segment selector to request block
return  AH      error status: 00h, 80h, 81h, 83h, 84h, 8Ah, 8Fh, 92h, 93h, 94h,
                95h, 96h, 98h, 0A2h
note 1) uses register AX

        01h  Exchange Memory Region
             Exchanges data between two memory areas. Includes exchanges between
             paged and non-paged areas, or between two different paged areas.
entry   AH      57h
        AL      01h
        DS:SI   pointer to the data structure which contains the source and
                destination information for the exchange.
return  AH      error status: 00h, 80h, 81h, 83h, 84h, 8Ah, 8Fh, 93h, 94h, 95h,
                96h, 97h, 98h, 0A2h
note 1) The request block is a structure with the following format:
        dword   region length in bytes
        byte    0=source in conventional memory
                1=source in expanded memory
        word    source handle
        word    source offset in page or selector
        word    source logical page (expanded) or selector (conventional)
        byte    0=target in conventional memory
                1=target in expanded memory
        word    target handle
        word    target offset in page or selector
        word    target logical page (expanded) or selector (conventional)
     2) Expanded memory allocated to a handle is considered to be a linear
        array, starting from logical page 0 and progressing through logical page
        1, 2, ... n, n+1, ... up to the last logical page in the handle.
     3) uses register AX


Function 58h Mappable Physical Address Array
LIM Function Call 25
             These functions let you obtain a complete map of the way physical
             memory is laid out in a vendor independent manner. This is a
             functional equivalent of EEMS function 68h ("function 41"). EEMS
             function 60h ("function 33") is a subset call of 68h.

        00h  Get Array
             Returns an array containing the segment address and physical page
             number for each mappable physical page in a system. This array
             provides a cross reference between physical page numbers and the
             actual segment addresses for each mappable page in the system.
entry   AH      58h
        AL      00h
        ES:DI   pointer to target array
return  AH      error status: 00h, 80h, 81h, 84h, 8Fh
        CX      entries in target array
note 1) The information returned is in an array composed of word pairs. The
        first word is the physical page's segment selector, the second word the
        physical page number. Note that values are not necessarily returned in a
        particular order, either ascending/decending segment selector values or
        as ascending/decending physical page number.
     2) For compatibility with earlier EMS specifications, physical page zero
        contains the segment selector value returned by function 41h, and
        physical pages 1, 2 and 3 return segment selector values that corrospond
        to the physical 16 KB blocks immediately following physical page zero.
     3) uses registers AX and CX
     4) The array is sorted in ascending segment order. This does not mean that
        the physical page numbers associated with the segment addresses are
        also in ascending order.

        01h   Get Physical Page Address Array Entries.
              Returns a word which represents the number of entries in the
              array returned by the previous subfunction. This number also
              indicates the number of mappable physical pages in a system.
entry   AH      58h
        AL      01h
return  AH      error status: 00h, 80h, 81h, 84h, 8Fh
        CX      number of entries returned by 58h/00h
note 1) multiply CX by 4 for the byte count.
     2) uses registers AX and CX


Function 59h Get Expanded Memory Hardware Information
LIM Function Call 26
             These functions return information specific to a given hardware
             implementation and to use of raw pages as opposed to standard
             pages. The intent is that only operating system code ever need use
             these functions.
        00h  Get EMS Hardware Info
             Returns an array containing expanded memory hardware configuration
             information for use by an operating system.
entry   AH      59h
        AL      00h
        ES:DI   pointer to 10 byte target array
                The target array has the following format:
                word: raw page size in paragraphs (multiples of 16 bytes)
                word: number of alternate register sets
                word: size of page maps (function 4Eh [15])
                word: number of alternate registers sets for DMA
                word: DMA operation -- see full specification
return  AH      error status: 00h, 80h, 81h, 84h, 8Fh, 0A4h
note 1) uses register AX
     2) This function is for use by operating systems only.
     3) This function can be disabled at any time by the operating system.

        01h  Get Unallocated Raw Page Count
             Returns the number of unallocated non-standard length mappable
             pages as well as the total number of non-standard length mappable
             pages of expanded memory
entry   AH      59h
        AL      01h
return  AH      error status: 00h, 80h, 81h, 84h, 8Fh
        BX      unallocated raw pages availible for use
        DX      total raw 16k pages of expanded memory
note 1) uses registers AX, BX, CX
     2) An expanded memory page which is a sub-multiple of 16K is termed a raw
        page. An operating system may deal with mappable physical page sizes
        which are sub-multiples of 16K bytes.
     3) If the expanded memory board supplies pages in exact multiples of 16K
        bytes, the number of pages this function returns is identical to the
        number Function 3 (Get Unallocated Page Count) returns. In this case,
        there is no difference between a page and a raw page.


Function 5Ah Allocate Raw Pages
LIM Function Call 27
             Allocates the number of nonstandard size pages that the operating
             system requests and assigns a unique EMM handle to these pages.
entry   AH      5Ah
        AL      00h     allocate standard pages
                01h     allocate raw pages
        BX      number of pages to allocate
return  AH      error status: 00h, 80h, 81h, 84h, 85h, 87h, 88h
        DX      unique raw EMM handle (1-255)
note 1) it is intended this call be used only by operating systems
     2) uses registers AX and DX
     3) For all functions using the raw handle returned in DX, the length of
        the physical and logical pages allocated to it are some nonstandard
        length (that is, not 16K bytes).
     4) this call is primarily for use by operating systems or EMM drivers
        supporting hardware with a nonstandard EMS page size.


Function 5Bh Alternate Map Register Set - DMA Registers
LIM Function Call 28
entry   AH      00h     Get Alternate Map Register Set
                01h     Set Alternate Map Register Set
                        BL      new alternate map register set number
                        ES:DI   pointer to map register context save area if
                                BL=0
                02h     Get Alternate Map Save Array Size
                03h     Allocate Alternate Map Register Set
                04h     Deallocate Alternate Map Register Set
                        BL      number of alternate map register set
                05h     Allocate DMA Register Set
                06h     Enable DMA on Alternate Map Register Set
                        BL      DMA register set number
                        DL      DMA channel number
                07h     Disable DMA on Alternate Map Register Set
                        BL      DMA register set number
                08h     Deallocate DMA Register Set
                        BL      DMA register set number
return  AH      status: 00h, 02h   00h, 80h, 84h, 81h, 8Fh, 0A4h
                        01h        00h, 80h, 81h, 84h, 8Fh, 9Ah, 9Ch, 9Dh,
                                   0A3h, 0A4h
                        03h, 05h   00h  80h  81h  84h, 8Fh, 9Bh, 0A4h
                        04h        00h, 80h, 81h, 84h, 8Fh, 9Ch, 9Dh, 0A4h
                        06h, 07h   00h, 80h, 81h, 84h, 8Fh, 9Ah, 9Ch, 9Dh, 9Eh,
                                   9Fh, 0A4h
        BL      current active alternate map register set number if nonzero
                (AL=0)
        BL      number of alternate map register set; zero if not supported
                (AL=3)
        DX      array size in bytes (subfunction 02h)
        ES:DI   pointer to a map register context save area if BL=0 (AL=0)
note 1) this call is for use by operating systems only, and can be enabled
        or disabled at any time by the operating system
     2) This set of functions performs the same functions at EEMS function 6Ah
        subfunctions 04h and 05h ("function 43").
     3) 00h uses registers AX, BX, ES:DI
        01h uses register AX
        02h uses registers AX and DX
        03h uses registers AX and BX
        04h uses register AX
        05h uses registers AX, BX
        06h uses register AX
        07h uses register AX


Function 5Ch Prepare EMS Hardware for Warm Boot
LIM Function Call 29
             Prepares the EMM hardware for a warm boot.
entry   AH      5Ch
return  AH      error status: 00h, 80h, 81h, 84h
note 1) uses register AX
     2) this function assumes that the next operation that the operating system
        performs is a warm boot of the system.
     3) in general, this function will affect the current mapping context, the
        alternate register set in use, and any other expanded memory hardware
        dependencies which need to be initialized at boot time.
     4) if an application decides to map memory below 640K, the application must
        trap all possible conditions leading to a warm boot and invoke this
        function before performing the warm boot itself.


Function 5Dh Enable/Disable OS Function Set Functions
LIM Function Call 30
             Lets the OS allow other programs or device drivers to use the OS
             specific functions. This capability is provided only for an OS
             which manages regions of mappable conventional memory and cannot
             permit programs to use any of the functions which affect that
             memory, but must be able to use these functions itself.
entry   AH      5Dh
        AL      00h     enable OS function set
                01h     disable OS function set
                02h     return access key (resets memory manager, returns access
                        key at next invocation)
        BX,CX   access key returned by first invocation
return  BX,CX   access key, returned only on first invocation of function
        AH      status  00h, 80h, 81h, 84h, 8Fh, 0A4h
note 1) this function is for use by operating systems only. The operating system
        can disable this function at any time.
     2) 00h uses registers AX, BX, CX
        01h uses registers AX, BX, CX
        02h uses register AX
     3) 00h, 01h: The OS/E (Operating System/Environment) functions these
        subfunctions affect are:
        Function 26. Get Expanded Memory Hardware Information.
        Function 28. Alternate Map Register Sets.
        Function 30. Enable/Disable Operating System Functions.


Function 5Eh Unknown
LIM Function call (not defined under LIM)


Function 5Fh Unknown
LIM Function call (not defined under LIM)


Function 60h EEMS - Get Physical Window Array
LIM Function call (not defined under LIM)
entry   AH      60h
        ES:DI   pointer to buffer
return  AH      status
        AL      number of entries
        buffer at ES:DI filled


Function 61h Generic Accelerator Card Support
LIM Function Call 34
             Contact AST Research for a copy of the Generic Accelerator Card
             Driver (GACD) Specification
note    Can be used by accelerator card manufacturer to flush RAM cache,
        ensuring that the cache accurately reflects what the processor would
        see without the cache.


Function 68h EEMS - Get Addresses of All Page Frames in System
LIM Function Call (not defined under LIM)
entry   AH      68h
        ES:DI   pointer to buffer
return  AH      status
        AL      number of entries
        buffer at ES:DI filled
note    Equivalent to LIM 4.0 function 58h


Function 69h EEMS - Map Page Into Frame
LIM Function Call (not defined under LIM)
entry   AH      69h
        AL      frame number
        BX      page number
        DX      handle
return  AH      status
note    Similar to EMS function 44h


Function 6Ah  EEMS - Page Mapping
LIM Function Call (not defined under LIM)
entry   AH      6Ah
        AL      00h save partial page map
                        CH      first page frame
                        CL      number of frames
                        ES:DI   pointer to buffer which is to be filled
                01h restore partial page map
                        CH      first page frame
                        CL      number of frames
                        DI:SI   pointer to previously saved page map
                02h save and restore partial page map
                        CH      first page frame
                        CL      number of frames
                        ES:DI   buffer for current page map
                        DI:SI   new page map
                03h get size of save array
                        CH      first page frame
                        CL      number of frames
                return  AL      size of array in bytes
                04h switch to standard map register setting
                05h switch to alternate map register setting
                06h deallocate pages mapped to frames in conventional memory
                        CH      first page frame
                        CL      number of frames
return  AH      status
note    Similar to LIM function 4Eh, except that a subrange of pages can
        be specified



EXPANDED MEMORY MANAGER ERROR CODES

 EMM error codes are returned in AH after a call to the EMM (int 67h).

code    meaning

00h     function successful
80h     internal error in EMM software (possibly corrupted driver)
81h     hardware malfunction
82h     EMM busy (dropped in EEMS 3.2)
83h     invalid EMM handle
84h     function requested not defined - unknown function code in AH.
85h     no more EMM handles availible
86h     error in save or restore of mapping context
87h     more pages requested than exist
88h     allocation request specified more logical pages than currently
        availible in system (request does not exceed actual physical number of
        pages, but some are already allocated to other handles); no pages
        allocated
89h     zero pages; cannot be allocated (dropped in EMS 4.0)
8Ah     logical page requested to be mapped outside range of logical pages
        assigned to handle
8Bh     illegal page number in mapping request (valid numbers are 0 to 3)
8Ch     page-mapping hardware state save area full
8Dh     save of mapping context failed; save area already contains context
        associated with page handle
8Eh     retore of mapping context failed; save area does not contain context
        for requested handle
8Fh     subfunction parameter not defined (unknown function)

LIM 4.0 extended error codes:

90h     attribute type undefined
91h     warm boot data save not implemented
92h     move overlaps memory
93h     move/exchange larger than allocated region
94h     conventional/expanded regions overlap
95h     logical page offset outside of logical page
96h     region larger than 1 MB
97h     exchange source/destination overlap
98h     source/destination undefined or not supported
99h     (no status assigned)
9Ah     alternate map register sets supported, specified set is not
9Bh     all alternate map & DMA register sets allocated
9Ch     alternate map & DMA register sets not supported
9Dh     alternate map register or DMA set not defined, allocated or is currently
        defined set
9Eh     dedicated DMA channels not supported
9Fh     dedicated DMA channels supported; specifed channel is not
0A0h    named handle could not be found
0A1h    handle name already exists
0A2h    move/exchange wraps around 1 MB boundry
0A3h    data structure contains corrupted data
0A4h    access denied



  This is a user-supported technical reference. If you find this information 
to be of use, please mail your check or money order for $15 to:

        Dave Williams
        PO Box 181
        Jacksonville, AR 72087-0181
        USA

 In return for your support you will receive the very latest edition of this 
manual on a disk, plus one disk of appendixes and references and a third 
disk with source code. That's about two megabytes of raw data when 
uncompressed, or the equivalent of ten manuals the size of the technical 
reference manuals from IBM or Microsoft.

 In addition, supporting users may obtain updates by merely mailing a disk and 
return postage whenever they feel like it. 
INDEX

 DOS TECHNICAL INFORMATION
 Programming Technical Reference - IBM
 Copyright 1988, Dave Williams

CHAPTER 1.
 SOME HISTORY
 THE OPERATING SYSTEM HIERARCHY
 DOS STRUCTURE
 DOS Initialization

CHAPTER 2.
 SYSTEM MEMORY MAP - OVERALL
 PC Port Assignment, Intel 8088, 80C88, 8086, 80286, 80386 CPUs
 Reserved Memory Locations in the IBM PC
 At Absolute Addresses
 The IBM PC System Interrupts  (Overview)
 The IBM-PC System Interrupts  (in detail)
 Interrupt 00h Divide by Zero (processor error).
 Interrupt 01h Single step
 Interrupt 02h Non-maskable interrupt
 Interrupt 03h Breakpoint
 Interrupt 04h Divide overflow
 Interrupt 05h Print Screen
 Interrupt 06h Reserved by IBM
 Interrupt 07h Reserved by IBM
 Interrupt 08h Timer
 Interrupt 09h Keyboard
 Interrupt 0Ah EGA Vertical Retrace
 Interrupt 0Bh Communications Controller (serial port) hdw. entry
 Interrupt 0Ch Communications Controller (serial port) hdw. entry
 Interrupt 0Dh Alternate Printer, PC/AT 80287
 Interrupt 0Eh Diskette
 Interrupt 0Fh Reserved by IBM

CHAPTER 3. THE PC ROM BIOS
 Interrupt 10h Video I/O
  Function 00h Determine or Set Video State
           01h Set Cursor Type
           02h Set Cursor Position
           03h Read Cursor Position
           04h Read Light Pen
           05h Select Active Page
           06h Scroll Page Up
           07h Scroll Page Down
           08h Read Character Attribute
           09h Write Character and Attribute
           0Ah Write Character
           0Bh Set Color Palette
           0Ch Write Dot
           0Dh Read Dot
           0Eh Write TTY
           0Fh Return Current Video State
           10h Set Palette Registers
           11h Character Generator Routine (EGA and after)
           12h Alternate Select (EGA and after)
           13h Write String
           14h Load LCD Character Font
           15h Return Physical Display Parameters
           1Ah Display Combination Code
           1Bh Functionality/State Information
           1Ch Save/Restore Video State
           70h Get Video RAM Address
           71h Get INCRAM Addresses
           72h Scroll Screen Right
           73h Scroll Screen Left
           81h DESQview video - Get something?
           82h DESQview - Get Current Window Info
           F0h Microsoft Mouse driver EGA support - Read One Register
           F1h Microsoft Mouse driver EGA support - Write One Register
           F2h Microsoft Mouse driver EGA support - Read Register Range
           F3h Microsoft Mouse driver EGA support - Write Register Range
           F4h Microsoft Mouse driver EGA support - Read Register Set
           F5h Microsoft Mouse driver EGA support - Read Register Set
           F6h Microsoft Mouse driver EGA support
           F7h Microsoft Mouse driver EGA support
           FAh Microsoft Mouse driver EGA support - Interrogate Driver
           FEh Get Alternate Screen Buffer Address (text mode only)
           FFh Update Real Display (text mode only)
 Interrupt 11h Equipment Check
 Interrupt 12h Memory Size
 Interrupt 13h Disk I/O
  Function 00h Reset
           01h Get Status of disk system
           02h Read Sectors
           03h Write Sectors
           04h Verify
           05h Format Track
           06h Hard Disk
           07h Hard Disk
           08h Read Drive Parameters
           09h Initialize Two Fixed Disk Base Tables
           0Ah Read Long   (Hard disk)
           0Bh Write Long
           0Ch Seek To Cylinder
           0Dh Alternate Disk Reset
           0Eh Read Sector Buffer
           0Fh Write sector buffer
           10h Test For Drive Ready
           11h Recalibrate Drive
           12h Controller RAM Diagnostic
           13h Drive Diagnostic
           14h Controller Internal Diagnostic
           15h Get Disk Type
           16h Change of Disk Status (diskette)
           17h Set Disk Type for Format (diskette)
           18h Set Media Type For Format  (diskette)
           19h Park Hard Disk Heads
           1Ah ESDI Hard Disk - Format
 Interrupt 14h Initialize and Access Serial Port For Int 14
  Function 01h Send Character in AL to Comm Port DX (0 or 1)
           02h Wait For A Character From Comm Port DX
           03h Fetch the Status of Comm Port DX (0 or 1)
           04h Extended Initialize
           05h Extended Communication Port Control
 Interrupt 15h Cassette I/O
  Function 00h Turn Cassette Motor On
           01h Turn Cassette Motor Off
           02h Read Blocks From Cassette
           03h Write Data Blocks to Cassette
           0Fh ESDI Format Unit Periodic Interrupt
           10h TopView API Function Calls
           20h PRINT.COM  (DOS internal)
           21h Power-On Self Test (POST) Error Log
           40h Read/Modify Profiles
           41h Wait On External Event
           42h Request System Power Off
           43h Read System Status
           44h (De)activate Internal Modem Power
           4Fh Keyboard Intercept
           80h Device Open
           81h Device Close
           82h Program Termination
           83h Event Wait
           84h Read Joystick Input Settings
           85h System Request (SysReq) Key Pressed
           86h Elapsed Time Wait
           88h Extended Memory Size Determine
           89h Switch Processor to Protected Mode
           91h Set Flag and Complete Interrupt
           C0h Get System Configuration
           C1h System
           C2h Pointing Device BIOS Interface (DesQview 2.x)
           C3h Enable/Disable Watchdog Timeout
           C4h Programmable Option Select
           DEh DesQview Services
 Interrupt 16h Keyboard I/O
  Function 00h Get Keyboard Input
           01h Check Keystroke Buffer
           02h Shift Status
           03h Keyboard
           04h Keyboard Click Toggle
           05h Keyboard Buffer Write
           10h Get Enhanced Keystroke And Read
           11h Check Enhanced Keystroke
           12h Extended Get Shift Status
           F0h Set CPU speed (Compaq 386)
 Interrupt 17h Printer
  Function 00h Print Character/send AL to printer DX (0, 1, or 2)
           01h Initialize Printer
           02h Printer Status
 Interrupt 18h ROM BASIC
 Interrupt 19h Bootstrap Loader
 Interrupt 1Ah Time of Day
  Function 00h Read System Time Counter
           01h Set Clock
           02h Read Real Time Clock Time
           03h Set Real Time Clock Time
           04h Read Real Time Clock Date
           05h Set Real Time Clock Date
           06h Set Real Time Clock Alarm
           07h Reset Real Time Clock Alarm
           08h Set Real Time Clock Activated Power On Mode
           09h Read Real Time Clock Alarm Time and Status
           0Ah Read System-Timer Day Counter
           0Bh Set System-Timer Day Counter
           80h Set Up Sound Multiplexor
 Interrupt 1Bh Control-Break
 Interrupt 1Ch Timer Tick
 Interrupt 1Dh Vector of Video Initialization Parameters.
 Interrupt 1Eh Vector of Diskette Controller Parameters
 Interrupt 1Fh Pointer to Graphics Character Extensions (Graphics Set 2)
 Interrupt 20h PROGRAM TERMINATE
 Interrupt 20h DOS - Terminate Program
 Interrupt 20h Minix - Send/Receive Message

CHAPTER 4. DOS INTERRUPTS AND FUNCTION CALLS
 DOS Registers
 Interrupts
 Interrupt 21h Function Request (Overview)
 Calling the DOS Services
 Interrupt 21h Function Request (in detail)
  Function 00h Program Terminate
           01h Keyboard Input
           02h Display Output
           03h Auxiliary Input
           04h Auxiliary Output
           05h Printer Output
           06h Direct Console I/O
           07h Direct Console Input Without Echo
           08h Console Input Without Echo
           09h Print String
           0Ah Buffered Keyboard Input
           0Bh Check Standard Input Status
           0Ch Clear Keyboard Buffer and Invoke a Kbd Function
           0Dh Disk Reset
           0Eh Select Disk
           0Fh Open File
           10h Close File
           11h Search for First Entry
           12h Search for Next Entry
           13h Delete File
           14h Sequential Read
           15h Sequential Write
           16h Create File
           17h Rename File
           18h Unknown
           19h Current Disk
           1Ah Set Disk Transfer Address
           1Bh Allocation Table Information
           1Ch Allocation Table Information for Specific Device
           1Dh Unknown
           1Eh Unknown
           1Fh Read DOS Disk Block (default drive)
           20h Unknown
           21h Random Read
           22h Random Write
           23h File Size
           24h Set Relative Record Field
           25h Set Interrupt Vector
           26h Create New Program Segment
           27h Random Block Read
           28h Random Block Write
           29h Parse Filename
           2Ah Get Date
           2Bh Get Date
           2Ch Get Time
           2Dh Set Time
           2Eh Set/Reset Verify Switch
           2Fh Get Disk Transfer Address (DTA)
           30h Get DOS Version Number
           31h Terminate Process and Stay Resident
           32h Read DOS Disk Block
           33h Ctrl-Break Check
           34h Return INDOS Flag
           35h Get Vector
           36h Get Disk Free Space
           37h Get/Set Switch Character (SWITCHAR)
           38h Return Country Dependent Information
           39h Create Subdirectory (MKDIR)
           3Ah Remove Subdirectory (RMDIR)
           3Bh Change Durrent Directory (CHDIR)
           3Ch Create a File (CREAT)
           3Dh Open a File
           3Eh Close a File Handle
           3Fh Read From a File or Device
           40h Write to a File or Device
           41h Delete a File from a Specified Directory (UNLINK)
           42h Move File Read/Write Pointer (LSEEK)
           43h Change File Mode (CHMOD)
           44h I/O Control for Devices (IOCTL)
           45h Duplicate a File Handle (DUP)
           46h Force a Duplicate of a Handle (FORCDUP)
           47h Get Current Directory
           48h Allocate Memory
           49h Free Allocated Memory
           4Ah Modify Allocated Memory Blocks (SETBLOCK)
           4Bh Load or Execute a Program (EXEC)
           4Ch Terminate a Process (EXIT)
           4Dh Get Return Code of a Subprocess (WAIT)
           4Eh Find First Matching File (FIND FIRST)
           4Fh Find Next Matching File (FIND NEXT)
           50h Set PSP
           51h Get PSP
           52h IN-VARS
           53h Translate BPB
           54h Get Verify Setting
           55h Create Child PSP
           56h Rename a File
           57h Get or Set Timestamp of a File
           58h Get/Set Allocation Strategy (DOS 3.x)
           59h Get Extended Error Code
           5Ah Create Unique Filename
           5Bh Create a New File
           5Ch Lock/Unlock File Access
           5Dh Network - Partial
           5Eh Network Printer
           5Fh Network Redirection
           60h Parse Pathname
           61h Unknown
           62h Get Program Segment Prefix (PSP) Address
           63h Get Lead Byte Table (DOS 2.25)
           64h Unknown
           65h Get Extended Country Information (DOS 3.3)
           66h Get/Set Global Code Page Table (DOS 3.3)
           67h Set Handle Count (DOS 3.3)
           68h Commit File (DOS 3.3)
           69h     Disk Serial Number  DOS 4.0 (US)
           6Ah     unknown  (DOS 4.0?)
           6Bh     unknown  (DOS 4.0?)
           6Ch     Extended Open/Create  DOS 4.0 (US)
           89h  DOS_Sleep
 Aftermarket Application Installed Function Calls, Used by NetWare
  Function B6h-FFh   Novell NetWare

CHAPTER 5. Interrupts 22h Through 86h
 Interrupt 22h Terminate Address
 Interrupt 23h Ctrl-Break Exit Address
 Interrupt 24h Critical Error Handler
 Interrupt 25h Absolute Disk Read
 Interrupt 26h Absolute Disk Write
 Interrupt 27h Terminate And Stay Resident
 Interrupt 28h (not documented by Microsoft)
 Interrupt 29h (not documented by Microsoft)
 Interrupt 2Ah Microsoft Networks - Session Layer Interrupt
 Interrupt 2Bh (not documented by Microsoft)
 Interrupt 2Ch (not documented by Microsoft)
 Interrupt 2Dh (not documented by Microsoft)
 Interrupt 2Eh (undocumented by Microsoft)
 Interrupt 2Fh Multiplex Interrupt
 Interrupt 30h (not a vector!) far jump instruction for CP/M-style calls
 Interrupt 31h Unknown
 Interrupt 32h Unknown
 Interrupt 33h Used by Microsoft Mouse Driver
 Interrupt 34h Turbo C/Microsoft languages - Floating Point emulation
 Interrupt 35h Turbo C/Microsoft languages - Floating Point emulation
 Interrupt 36h Turbo C/Microsoft languages - Floating Point emulation
 Interrupt 37h Turbo C/Microsoft languages - Floating Point emulation
 Interrupt 38h Turbo C/Microsoft languages - Floating Point emulation
 Interrupt 39h Turbo C/Microsoft languages - Floating Point emulation
 Interrupt 3Ah Turbo C/Microsoft languages - Floating Point emulation
 Interrupt 3Bh Turbo C/Microsoft languages - Floating Point emulation
 Interrupt 3Ch Turbo C/Microsoft languages - Floating Point emulation
 Interrupt 3Dh Turbo C/Microsoft languages - Floating Point emulation
 Interrupt 3Eh Turbo C/Microsoft languages - Floating Point emulation
 Interrupt 3Fh Overlay manager interrupt (Microsoft LINK.EXE)
 Interrupt 40h Hard Disk BIOS
 Interrupt 41h Hard Disk Parameters
 Interrupt 42h Pointer to screen BIOS entry
 Interrupt 43h Pointer to EGA initialization parameter table
 Interrupt 44h Pointer to EGA graphics character table
 Interrupt 45h Reserved by IBM  (not initialized)
 Interrupt 46h Pointer to second hard disk, parameter block
 Interrupt 47h Reserved by IBM  (not initialized)
 Interrupt 48h Cordless Keyboard Translation
 Interrupt 49h Non-keyboard Scan Code Translation Table Address
 Interrupt 4Ah Real-Time Clock Alarm
 Interrupt 4Bh Reserved by IBM  (not initialized)
 Interrupt 4Ch Reserved by IBM  (not initialized)
 Interrupt 4Dh Reserved by IBM  (not initialized)
 Interrupt 4Eh Reserved by IBM  (not initialized)
 Interrupt 4Fh Reserved by IBM  (not initialized)
 Interrupt 50-57 IRQ0-IRQ7 relocated by DesQview
 Interrupt 58h Reserved by IBM  (not initialized)
 Interrupt 59h Reserved by IBM  (not initialized)
 Interrupt 5Ah Reserved by IBM  (not initialized)
 Interrupt 5Bh Reserved by IBM  (not initialized)
 Interrupt 5Ah Cluster Adapter BIOS entry address
 Interrupt 5Bh Reserved by IBM  (not initialized) (cluster adapter?)
 Interrupt 5Ch NETBIOS interface entry port
 Interrupt 5Dh Reserved by IBM  (not initialized)
 Interrupt 5Eh Reserved by IBM  (not initialized)
 Interrupt 5Fh Reserved by IBM  (not initialized)
 Interrupt 60h-67h User Program Interrupts (availible for general use)
 Interrupt 67h Used by Lotus-Intel-Microsoft Expanded Memory Specification
 Interrupt 68h Not Used  (not initialized)
 Interrupt 69h Not Used  (not initialized)
 Interrupt 6Ah Not Used  (not initialized)
 Interrupt 6Bh Not Used  (not initialized)
 Interrupt 6Ch System Resume Vector (Convertible) (not initialized on PC)
 Interrupt 6Dh Not Used  (not initialized)
 Interrupt 6Fh Not Used  (not initialized)
 Interrupt 70h IRQ 8, Real Time Clock Interrupt
 Interrupt 71h IRQ 9, Redirected to IRQ 8
 Interrupt 72h IRQ 10  (AT, XT/286, PS/2)  Reserved
 Interrupt 73h IRQ 11  (AT, XT/286, PS/2)  Reserved
 Interrupt 74h IRQ 12  Mouse Interrupt (AT, XT/286, PS/2)
 Interrupt 75h IRQ 13, Coprocessor Error, BIOS Redirect to int 2 (NMI) (AT)
 Interrupt 76h IRQ 14, Hard Disk Controller (AT, XT/286, PS/2)
 Interrupt 77h IRQ 15 (AT, XT/286, PS/2)  Reserved
 Interrupt 78h Not Used
 Interrupt 79h Not Used
 Interrupt 7Ah Novell NetWare - LOW-LEVEL API
 Interrupt 7Bh-7Fh  Not Used
 Interrupt 80h-85h Reserved by BASIC
 Interrupt 86h Relocated by NETBIOS int 18
 Interrupt 86h-F0h Used by BASIC when BASIC interpreter is running
 Interrupt E4h Logitech Modula-2 v2.0   MONITOR
 Interrupt F1h-FFh (absolute addresses 3C4-3FF)
 Interrupt F8h Set Shell Interrupt (OEM)
 Interrupt F9h First of 8 SHELL service codes, reserved for OEM shell (WINDOW);
 Interrupt FAh USART ready (RS-232C)
 Interrupt FBh USART RS ready (keyboard)
 Interrupt FCh Unknown
 Interrupt FDh reserved for user interrupt
 Interrupt FEh AT/XT286/PS50+ - destroyed by return from protected mode
 Interrupt FFh AT/XT286/PS50+ - destroyed by return from protected mode

CHAPTER 6. DOS CONTROL BLOCKS AND WORK AREAS
 The Disk Transfer Area (DTA)
 DOS Program Segment
 STANDRD FILE CONTROL BLOCK
 EXTENDED FILE CONTROL BLOCK
 MEMORY CONTROL BLOCKS
 CONTROL BLOCK
 MEMORY CONTROL BLOCKS

CHAPTER 7. DOS File Structure
 File Management Functions
 FCB FUNCTION CALLS
 HANDLE FUNCTION CALLS
 SPECIAL FILE HANDLES
 ASCII and BINARY MODE
 FILE I/O IN BINARY (RAW) MODE
 FILE I/O IN ASCII (COOKED) MODE
 NUMBER OF OPEN FILES ALLOWED
 RESTRICTIONS ON FCB USAGE
 RESTRICTIONS ON HANDLE USAGE
 ALLOCATING SPACE TO A FILE
 MSDOS / PCDOS DIFFERENCES
 .EXE FILE STRUCTURE
 THE RELOCATION TABLE
 "NEW" .EXE FORMAT (Microsoft Windows and OS/2)

CHAPTER 8. DOS DISK INFORMATION
 THE DOS AREA
 THE BOOT RECORD
 THE DOS FILE ALLOCATION TABLE (FAT)
 USE OF THE 12 BIT FILE ALLOCATION TABLE
 USE OF THE 16 BIT FILE ALLOCATION TABLE
 DOS DISK DIRECTORY
 DIRECTORY ENTRIES
 THE DATA AREA
 HArd DISK LAYOUT
 SYSTEM INITIALIZATION
 THE BOOT SEQUENCE
 BOOT RECORD/PARTITION TABLE
 HARD DISK TECHNICAL INFORMATION
 DETERMINING FIXED DISK ALLOCATION

CHAPTER 9. INSTALLABLE DEVICE DRIVERS
 DEVICE DRIVER FORMAT
 TYPES OF DEVICES
 DEVICE HEADER
 POINTER TO NEXT DEVICE HEADER FIELD
 ATTRIBUTE FIELD
 POINTER TO STRATEGY AND INTERRUPT ROUTINES
 NAME/UNIT FIELD
 CREATING A DEVICE DRIVER
 INSTALLING DEVICE DRIVERS
 INSTALLING CHARACTER DEVICES
 INSTALLING BLOCK DEVICES
 REQUEST HEADER
 UNIT CODE FIELD
 COMMAND CODE FIELD
 STATUS FIELD
 DEVICE DRIVER FUNCTIONS
 INIT
 MEDIA CHECK
 MEDIA DESCRIPTOR
 BUILD BPB (BIOS Parameter Block)
 INPUT / OUTPUT
 NONDESTRUCTIVE INPUT NO WAIT
 STATUS
 FLUSH
 OPEN or CLOSE (3.x)
 REMOVABLE MEDIA (DOS 3.x)
 THE CLOCK$ DEVICE

CHAPTER 10. LOTUS-INTEL-MICROSOFT  EXPANDED MEMORY SPECIFICATION
 The Expanded Memory Manager
  History
  Page Frames
 Expanded Memory Services
 AST/Quadram/Ashton-Tate Enhanced EMM
  Calling the Manager
  Common EMS         s (hex calls)
    1 (40h) Get Manager Status
    2 (41h) Get Page Frame Segment
    3 (42h) Get Number of Pages
    4 (43h) Get Handle and Allocate Memory
    5 (44h) Map Memory
    6 (45h) Release Handle and Memory
    7 (46h) Get EMM Version
    8 (47h) Save Mapping Context
    9 (48h) Restore Mapping Context
   10 (49h) Reserved
   11 (4Ah) Reserved
   12 (4Bh) Get Number of EMM Handles
   13 (4Ch) Get Pages Owned By Handle
   14 (4Dh) Get Pages for All Handles
   15 (4Eh) Get Or Set Page Map
  new LIM 4.0 specification:
   16 (4Fh) Get/Set Partial Page Map
   17 (50h) Map/Unmap Multiple Pages
   18 (51h) Reallocate Pages
   19 (52h) Handle Attribute Functions
   20 (53h) Get Handle Name
   21 (54h) Get Handle Directory
   22 (55h) Alter Page Map & Jump
   23 (56h) Alter Page Map & Call
   24 (57h) Move Memory Region
   25 (58h) Get Mappable Physical Address Array
   26 (59h) Get Expanded Memory Hardware
   27 (5Ah) Allocate Raw Pages
   28 (5Bh) Get Alternate Map Register Set
   29 (5Ch) Prepare Expanded Memory Hardware
   30 (5Dh) Enable OS/E Function Set
   31 (5Eh) Unknown
   32 (5Fh) Unknown
   33 (60h) Unknown
   34 (61h) AST Generic Accelerator Card Support
      (68h) EEMS - Get Addresses of All Page Frames in System
      (69h) EEMS - Map Page Into Frame
      (6Ah) EEMS - Page Mapping
 Expanded Memory Manager Error Codes
 LIM 4.0 extended error codes

 Programming Technical Reference - IBM
 Copyright 1988, Dave Williams


 These scan codes are generated by pressing a key on the PC's keyboard. This 
is the 'make' code. A 'break' code is generated when the key is released. The 
break scancode is 128 higher than the make code, and is generated by setting 
bit 7 of the scan code byte to 1.


                 IBM PC KEYBOARD EXTENDED CODES

        Normal          Shift          Control         Alt

ESC     1
1       2                                               0;120
2       3                                               0;121
3       4                                               0;122
4       5                                               0;123
5       6                                               0;124
6       7                                               0;125
7       8                                               0;126
8       9                                               0;127
9       10                                              0;128
0       11                                              0;129
-       12                                              0;130
=       13                                              0;131
TAB     15              0;15(backtab)
backtab none                                             0;15
RETURN  28

         Normal      Shift     Control      Alt     NumLock

Home      0;71                  0;119      none        7
UpArrow   0;72                  none       none        8
PgUp      0;73                  0;132      none        9
gray -    0;74                                         0;74
LArrow    0;75                  0;115      none        4
keypad 5  none                  none       none        5
RArrow    0;77                  0;116                  6
gray +    0;78                                         0;78  
End       0;79                  0;117      none        1
DnArrow   0;80                                         2
PgDn      0;81                  0;118      none        3
Ins       0;82                             none        11
Del       0;83                  0;128      none        52
PrtSc     55                    0;114       
L shift   42
R shift   54
alt key   56
capslock  58
spacebar  57
control key 29
numlock   69
scrollock 70
;         39
[         26
]         27
"         40
\         43
/         53
,         51
.         52

                 IBM PC KEYBOARD EXTENDED CODES

         Normal      Shift     Control      Alt

a   =     30                               0;30
b   =     48                               0;48
c   =     46                               0;46
d   =     32                               0;32
e   =     18                               0;18
f   =     33                               0;33
g   =     34                               0;34
h   =     35                               0;35
i   =     23                               0;23
j   =     36                               0;36
k   =     37                               0;37
l   =     38                               0;38
m   =     50                               0;50
n   =     49                               0;49
o   =     24                               0;24
p   =     25                               0;25
q   =     16                               0;16
r   =     19                               0;19
s   =     31                               0;31
t   =     20                               0;20
u   =     22                               0;22
v   =     47                               0;47
w   =     17                               0;17
x   =     45                               0;45
y   =     21                               0;21
z   =     44                               0;44

         Normal      Shift     Control      Alt

F1  =     0;59       0;84       0;94       0;104
F2  =     0;60       0;85       0;95       0;105
F3  =     0;61       0;86       0;96       0;106
F4  =     0;62       0;87       0;97       0;107
F5  =     0;63       0;88       0;98       0;108
F6  =     0;64       0;89       0;99       0;109
F7  =     0;65       0;90       0;100      0;110
F8  =     0;66       0;91       0;101      0;111
F9  =     0;67       0;92       0;102      0;112
F10 =     0;68       0;93       0;103      0;113

        "Enhanced" 101/102 key keyboard scancodes

         Normal      Shift     Control      Alt
F11 =     0;152      0;162      0;172      0;182  |
F12 =     0;153      0;163      0;173      0;183  | Tandy?

F11 =     0;133      0;135      0;137      0;139
F12 =     0;134      0;136      0;138      0;140

alt-home                                    0;151
UpArr                           0;141       0;152
Ctrl -                          0;142
Ctrl 5                          0;143
Ctrl +                          0;144
DnArr                           0;145       0;160
Ins                             0;146       0;162
Del                             0;147       0;163
Tab                             0;148       0;165
/                               0;149       0;164
Ctrl-*                          0;150
alt-Enter                                   0;166
alt-PgUp                                    0;153
alt-LArr                                    0;154
alt-RArr                                    0;155
alt-End                                     0;156
alt-PgDn                                    0;161

    BIOS keystroke codes, hexadecimal

    Key      Normal         Shift          Control        Alt

    Esc      011B           011B           011B            --
    1!       0231 '1'       0221 '!'        --            7800
    2@       0332 '2'       0340 '@'       0300           7900
    3#       0433 '3'       0423 '#'        --            7A00
    4$       0534 '4'       0524 '$'        --            7B00
    5%       0635 '5'       0625 '%'        --            7C00
    6^       0736 '6'       075E '^'       071E           7D00
    7&       0837 '7'       0826 '&'        --            7E00
    8*       0938 '8'       092A '*'        --            7F00
    9(       0A39 '9'       0A28 '('        --            8000
    0)       0B30 '0'       0B29 ')'        --            8100
    -_       0C2D '-'       0C5F '_'       0C1F           8200
    =+       0D3D '='       0D2B '+'        --            8300
    BkSpc    0E08           0E08           0E7F            --
    tab      0F09           0F00            --             --
    q        1071 'q'       1051 'Q'       1011           1000
    w        1177 'w'       1157 'W'       1117           1100
    e        1265 'e'       1245 'E'       1205           1200
    r        1372 'r'       1352 'R'       1312           1300
    t        1474 't'       1454 'T'       1414           1400
    y        1579 'y'       1559 'Y'       1519           1500
    u        1675 'u'       1655 'U'       1615           1600
    i        1769 'i'       1749 'I'       1709           1700
    o        186F 'o'       184F 'O'       180F           1800
    p        1970 'p'       1950 'P'       1910           1900
    [{       1A5B '['       1A7B '{'       1A1B            --
    ]}       1B5D ']'       1B7D '}'       1B1D            --
    enter    1C0D           1C0D           1C0A            --
    Ctrl      --             --             --             --
    a        1E61 'a'       1E41 'A'       1E01           1E00
    s        1F73 's'       1F53 'S'       1F13           1F00
    d        2064 'd'       2044 'D'       2004           2000
    f        2166 'f'       2146 'F'       2106           2100
    g        2267 'g'       2247 'G'       2207           2200
    h        2368 'h'       2348 'H'       2308           2300
    j        246A 'j'       244A 'J'       240A           2400
    k        256B 'k'       254B 'K'       250B           2500
    l        266C 'l'       264C 'L'       260C           2600
    ;:       273B ';'       273A ':'        --             --
    '"       2827 '''       2822 '"'        --             --
    `~       2960 '`'       297E '~'        --             --
    l shift   --             --             --             --
    \|       2B5C '\'       2B7C '|'       2B1C            --
    z        2C7A 'z'       2C5A 'Z'       2C1A           2C00
    x        2D78 'x'       2D58 'X'       2D18           2D00
    c        2E63 'c'       2E43 'C'       2E03           2E00
    v        2F76 'v'       2F56 'V'       2F16           2F00
    b        3062 'b'       3042 'B'       3002           3000
    n        316E 'n'       314E 'N'       310E           3100
    m        326D 'm'       324D 'M'       320D           3200
    ,<       332C ','       333C '<'        --             --
    .>       342E '.'       343E '>'        --             --
    /?       352F '/'       353F '?'        --             --
    r shift   --             --             --             --
    PrtSc    372A '*'        --            7200            --
    Alt       --             --             --             --
    spacebar 3920 ' '       3920 ' '       3920 ' '       3920 ' '
    CapsLock  --             --             --             --

    BIOS keystroke codes, hexadecimal, continued

    Key      Normal         Shift          Control        Alt

    F1       3B00           5400           5E00           6800
    F2       3C00           5500           5F00           6900
    F3       3D00           5600           6000           6A00
    F4       3E00           5700           6100           6B00
    F5       3F00           5800           6200           6C00
    F6       4000           5900           6300           6D00
    F7       4100           5A00           6400           6E00
    F8       4200           5B00           6500           6F00
    F9       4300           5C00           6600           7000
    F10      4400           5D00           6700           7100
    NumLock   --             --             --             --
    Scroll    --             --             --             --
    7 Home   4700           4737 '7'       7700            --
    8 up     4800           4838 '8'        --             --
    9 PgUp   4900           4939 '9'       8400            --
    grey -   4A2D '-'       4A2D '-'        --             --
    4 left   4B00           4B34 '4'       7300            --
    5         --            4C35 '5'        --             --
    6 right  4D00           4D36 '6'       7400            --
    grey +   4E2B '+'       4E2B '+'        --             --
    1 End    4F00           4F31 '1'       7500            --
    2 down   5000           5032 '2'        --             --
    3 PgDn   5100           5133 '3'       7600            --
    Ins      5200           5230 '0'        --             --
    Del      5300           532E '.'        --             --

    A table entry of "--" means you can't get that combination out of BIOS.

