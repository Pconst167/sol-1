From: S_JUFFA@IRAV1.ira.uka.de (|S| Norbert Juffa)
Newsgroups: comp.sys.ibm.pc.hardware,comp.sys.intel
Subject: Compatibility issues Cyrix 486DLC/Intel 486SX w/ regard to NeXTstep OS
Message-ID: <1j699uINN8qg@iraul1.ira.uka.de>
Date: 15 Jan 1993 12:05:18 GMT
Organization: University of Karlsruhe, FRG
Lines: 550

Compatibility issues Cyrix Cx486SLC/DLC as compared to the Intel 80486SX


There has been quite a bit of discussion here recently about compatibility
issues involving the Cyrix Cx486SLC and Cx486DLC processors, in particular
about the fact that the NextStep operating system doesn't run on the Cyrix
processors for some reason. During the course of this discussion, we have
heard *a lot of opinions* (e.g. "Intel sucks", "Cyrix sucks") but only *few
facts*. So I thought it might a good idea to throw in a bit of the latter.
I'll try to give the facts as accurate as possible, drawing from personal
experience and Intel's and Cyrix' literature on the 80486DX/SX and 486DLC/SLC.
If you think you have found erroneous information, feel free to contact me:

S_JUFFA@IRAVCL.IRA.UKA.DE (Norbert Juffa)


NOTE: I have no affiliation whatsoever with either Intel or Cyrix!


The Cyrix 486DLC is a replacement chip for the Intel/AMD 80386DX. The Cyrix
486SLC is a replacement chip for the Intel/AMD 386SX. While the internals of
the Cyrix 486SLC/DLC are roughly equivalent to those in the Intel 80486SX,
the bus interface of these chips is identical to that of the Intel 80386DX
and 80386SX CPUs, respectively to allow easy replacement of the Intel CPUs
by the Cyrix chips. This also means that the Cx486SLC, as a replacement for
the Intel/AMD 80386SX can only address 16 MB of memory.

The 486SLC/DLC CPUs have a register set that is identical to that found on
the Intel 80486SX. However, there are a few subtle differences in the
meaning of certain bits in some systems registers (e.g. cache test registers).
These are covered in more details below. The instruction sets of the Intel
486SX and the Cyrix Cx486SCL/DLC are identical. The execution times of specific
instructions differ between the two chips, but the overall execution speed
(measured in CPI = clocks per instruction) seems to be about same.

On both, the Intel 80486SX and the Cyrix 486SLC/DLC, there is *no* on-chip
FPU (floating point unit). To add floating point capabilities to a 486SX
based system, one would install an 487 'coprocessor', which is basically a
486DX with a slighty different pin-out, or replace the 486SX with an OverDrive
processor, a clock-doubled 486DX with the 486SX pinout. With the 486SLC/DLC,
one buys a 387 compatible coprocessor to add floating-point capabilities. It
is recommended to get a Cyrix coprocessor for this purpose, since these are
the fastest387 compatible coprocessors available. Also, Cyrix sells kits
consisting of a 486SLC/DLC and a coprocessor that have a favourable value
for money ratio. The floating-point performance of a Cyrix 486DLC + Cyrix
83D87 combination is about 50% of that of an Intel 486DX running at the same
frequency.

The Cyrix 486SLC/DLC have a RISC-like execution unit with a flexible five
stage pipeline, just as the 80486SX has. Unlike the Intel 80486, which has
an 8 kB, 4-way associative cache on chip, the Cx486SLC/DLC only have an 1
kB, 2-way associative cache (the cache on the Cyrix chips can also be
configured to be of the direct mapped type). The 486DLC provides up to 80%
more integer performance than a 386DX at the same clock frequency, with the
average performance gain being about 35%. With the 1 kB on-chip cache enabled,
the 486DLC provides about 75% of the integer performance of a 486SX at the
same clock frequency. With the cache disabled, the 486DLC provides about 65%
of the integer performance of a 486SX. The lower performance of the Cyrix
486DLC as compared to the Intel 80486SX is mostly due to the slow 386DX bus
interface the 486DLC uses, which is up to 2 times slower than the 486 bus
interface. Some additional performance penalty is imposed by the smaller
cache on the 486SCL/DLC, which provides significantly lower hit rates than
the 8 kB cache of the 80486SX.


I have personally used the Cyrix 486DLC with my 33.3/40 MHz 386 motherboard,
which uses the Forex chip set. I have also used the Intel RapidCAD and the
C&T 38600DX with this board. These are also replacement chips for the 386DX.
Replacing the 386DX is very easy: Just pull out the AMD/Intel 386DX, then
plug in the replacement chip (here: the Cyrix 486DLC). I haven't had *major*
problems with either of the available replacement chips. The problems
encountered using the Cyrix 486DLC were:

1) When a Cyrix EMC87, Cyrix 83D87 (chips produced prior to November 1991),
   or IIT 3C87 coprocessor is used with the 486DLC, the computer locks up
   completely at times, especially when running protected mode multitasked
   operating systems, such as Windows 3.1 in enhanced mode. This is caused
   by problems with the FSAVE and FRSTOR instructions when using these
   coprocessors. Cyrix tells me that this problem only occurs with first
   generation 486DLCs (read: sample chips like the one I have) and that the
   bug is fixed on the chips that are now available to OEMs and end users.
2) When using the DBOS 1.0 DOS-extender delivered with the Salford FTN/386
   Fortran compiler, the executable of the DODUC benchmark produced by that
   compiler aborts with a general protection fault. The DODUC executable
   runs fine with the DBOS 1.0 DOS-extender on the Intel 386DX, C&T 38600DX,
   Intel RapidCAD, and Intel 80486DX. I have informed Cyrix of the problem.

As for the problems with NextStep on the 486DLC, I have no idea what causes
them. I can think of the following possibilities:

1) NextStep has been tailored extremely close to the 486 programming model,
   not allowing for even slight changes in the architecture (e.g. smaller
   cache), so that the subtle changes needed to adapt the different HW of
   the Cyrix 486SLC/DLC to the 486 programming model can not be accomodated.
2) NextStep includes code that only runs because it uses officialy undocumented
   features of the 80486 that have not been disclosed by Intel to other vendors.
3) NextStep includes code that only runs correctly on the 80486 by accident.
   E.g. it could mask the contents of an system register and erroneously
   include a bit that is undefined as per Intel's documentation. This undefined
   bit could then be '1' on the 80486 and '0' on the 486SLC/DLC, for example,
   thus leading to corruption of the system further down the execution path.
4) For correct execution, NextStep relies on the timing of certain instructions
   that execute slower or faster on the Cx486SLC/DLC than they do on the Intel
   80486SX (a chip that reportedly runs NextStep).
5) NEXT Corporation used an early and possibly buggy sample chip to do their
   compatibility testing.
6) There is a bug in the Cyrix 486SLC/DLC that only creeps up if protected
   mode system level programs are used, similar to the problem I encountered
   with the DBOS 1.0 DOS-extender that is described above. However, it is
   interesting to note that several 32-bit operating systems have been
   successfully tested on the 486SLC/DLC (see below).




Summary of Intel 486SX / Cyrix 486SLC/DLC implementation details


Intel 486SX

bus interface:   supports burst mode memory accesses with the first
                 memory access taking two clock cycles and subsequent
                 accesses taking only one clock cycle.
prefetch queue:  32 bytes
on-chip cache:   8 KByte unified (code and data) write-through cache.
                 The cache is 4-way set-associative, with 128 sets
                 consisting of four cache lines each. Every cache line
                 consists of 16 bytes. Four write buffers. Hit rate: ~95%
                 Invalidation of cache lines: total cache line
execution unit:  RISC-like execution unit with five stage pipeline. Barrel
                 shifter. Conditional jump taken/not taken: 3/1 clock cycles.
                 Instructions that can be executed in 1 clock cycle if the
                 destination is a register and the source is either a register
                 or an immediate value:
                 ADC,ADD,AND,BSWAP,CMP,DEC,INC,MOV,NEG,NOT,OR,POP,PUSH,SBB,
                 SUB,TEST,XOR

Cyrix 486DLC

bus interface:   Cx486SLC/DLC uses same the same bus interface as the
                 Intel 386DX/386SX. Highest speed at which memory is
                 accessed is two clock cycles per memory access, there
                 is *no* burst mode. Seven additional signals have been
                 assigned to pins that are not connected on the 386DX/
                 386SX. After power-on or reset, these pins are also
                 electrically disabled on the Cx486SLC/DLC and must be
                 specifically enabled by software. Signals added are used
                 for cache management (KEN#, FLUSH#, RPLSET and RPLVAL#),
                 power management (SUSP#, SUSPA#), and A20 control (A20M#).
                 Each signal can be enabled/disabled independently of the
                 enable/disable status of the other signals.
instruction set: complete Intel 486SX instruction set, including *all*
                 486 specific instructions: WBINVD (write back and
                 invalidate data cache), XADD (exchange and add), CMPXCHG
                 (compare and exchange), BSWAP (Byte Swap), INVLPG
                 (Invalidate TLB entry), INVD (Invalidate Data Cache)
prefetch queue:  16 bytes
on-chip cache:   1 KByte unified (code and data) write-through cache.
                 The cache is 2-way set-associative, with 128 sets
                 consisting of two cache lines each. Every cache line
                 consists of 4 bytes. Two write buffers. Hit rate: ~65%
                 Invalidation of cache lines: single bytes in cache line
                 The cache is disabled after power-on or reset for
                 compatibility reasons and must be enabled by software.
                 Under DOS, you can use a program provided by Cyrix for
                 this purpose. As far as I know, there are no programs
                 available yet for OS/2 and Unix that enable the cache.
execution unit:  RISC-like execution unit with five stage pipeline. Barrel
                 shifter. 16x16 bit hardware multiplier (16x16 bit multiply:
                 3 cycles, 32x32 bit multiply: 7 cycles, AAD: 4 cycles).
                 Conditional jump taken/not taken: 6/1 clock cycles.
                 Instructions that can be executed in 1 clock cycle
                 if the destination is a register and the source is
                 either a register or an immediate value:
                 ADC,ADD,AND,CDQ,CLC,CLD,CMC,CMP,CWD,DEC,INC,MOV,MOVSX,
                 NEG, NOT,OR,SBB,SHLD,SHRD,STC,STD,SUB,TEST,XOR




Summary of known compatiblity issues

The following is an extract from the Cx486SLC and Cx486DLC Compatibility
Report, Cyrix Corporation 1992, Order No. 94074-00, with some additional
information added by me that has been taken from the Cyrix Cx486SLC
Microprocessor Data Sheet, Cyrix Corporation 1991, Order No. 94073-00,
the i486 Microprocessor Hardware Reference Manual, Intel Corporation,
Order No. 240552-001, and the i486 Microprocessor Programmer's Reference
Manual, Order No. 240486-001.


SUBSTANTIVE DIFFERENCES - (SOFTWARE)

SS-1 Description

     The TR4 cache test register holds the cache tag address, valid bits
     and LRU bits for the current cache test operation. The TR5 cache test
     register defines the cache line, cache set and control bits for the
     cache test operation. Since the cache size and organization differ
     between the Cx486SLC/DLC and the 80486, TR4 and TR5 have similar but
     not identical bit definitions on the Cx486SLC/DLC and the 80486.

     Analysis

     Cache test and diagnostic software - if written to explicitly depend
     on the cache size and organization of the 80486 - may produce unexpected
     results when run on a Cx486SLC/DLC. The results of the programs typically
     have no effect on operating systems or applications software. For proper
     test or diagnosis of the Cx486SLC/DLC cache, software should be used
     which is specifically written to comprehend the Cx486SLC/DLC.


     80486SX

     31                                       11 10  9      7 6     3 2      0
     +------------------------------------------+---+--------+-------+--------+
TR4  |           Tag                            | V |  LRU   | Valid | Unused |
     +------------------------------------------+---+--------+-------+--------+

     V     This is the valid bit for the particular cache line which was
           accessed. On a cache lookup, it is a copy of one of the bits
           reported in bits 3..6, which are the valid bits for all four
           cache lines in the selected set. On a cache write, it becomes
           the new valid bit for the particular cache line selected within
           the selected set.
     LRU   On a cache lookup, these are the three LRU bits of the set which
           was accessed. On a cache write, these bits are ignored; the LRU
           bits in the cache are updated by the pseudo-LRU cache replacement
           algorithm. LRU bit 0 (TR4 bit 7) indicates which group of two
           cache lines in the set contains the cache line that has been least
           recently used. The bit is clear when the least recently used line
           is either line 0 or line 1, and is set when the least recently
           used line in the set is either line 2 or line 3. LRU bit 1 (TR4
           bit 8) and LRU bit 2 (TR4 bit 9) indicate which of the two lines
           in the group of lines selected by LRU bit 0 is the least recently
           used, where LRU bit 1 indicates either line 0 (bit=0) or line 1
           (bit=1) and LRU bit 2 indicates either line 2 (bit=0) or line 3
           (bit=1) has been least recently used. A real LRU replacement
           algorithm would have to use 5 bits.
     Valid On a cache lookup, these are the four Valid bits of the set which
           was accessed, where each bit corresponds to one of the four cache
           lines in the set.


     486SLC/DLC

     31                                              9 8   7   6     3 2     0
     +------------------------------------------------+-+-----+-------+-------+
TR4  |           Tag                                  |U| LRU | Valid | 0 0 0 |
     +------------------------------------------------+-+-----+-------+-------+

     U     bit 8 is unused.
     LRU   On a cache lookup, this is the LRU bit associated with the cache
           set. On a cache write, this bit is ignored. Bit=0 means line 0
           in the selected set has been least recently used, bit=1 means line
           1 in the selcted set has been least recently used.
     Valid On a cache lookup, these are the four valid bits for the particular
           cache line accessed (one bit per byte in the cache line). On a cache write
           these are the valid bits written into the line.



     80486SX

     31                                   11 10               4 3     2 1    0
     +--------------------------------------+------------------+-------+------+
TR5  |       Unused                         |     Set Select   | Entry | Ctrl |
     +--------------------------------------+------------------+-------+------+

     Set Select  Selects one of the 128 sets of the cache.
     Entry       Selects one of the four cache lines within the selected set.
     Ctrl        00 write to cache fill buffer, or read from cache read buffer
                 01 perform cache write
                 10 perform cache read
                 11 flush cache (mark all entries invalid)

     486SLC/DLC

     31                                   11 10               4 3   2   1    0
     +--------------------------------------+------------------+-+-----+------+
TR5  |       Unused                         |     Set Select   |U| Ent | Ctrl |
     +--------------------------------------+------------------+-+-----+------+

     Set Select  Selects one of the 128 sets of the cache.
     U           bit 3 is unused
     Entry       Selects one of the two cache lines within the selected set.
     Ctrl        00 ignored
                 01 perform cache write
                 10 perform cache read
                 11 flush cache (mark all entries invalid)


SS-2 Description

     The 80486 NW (not write-through) bit in CR0 disables 80486 write-through
     capability. If the cache disabled bit is on, a write occurs to a cache-hit
     location, and NW is a 1, then the 80486 does not perform an external write
     bus cycle. This bit is not available on the Cx486SLC/DLC and is fixed at
     zero.

     Analysis

     The NW bit on the 80486 allows for a capability of self-contained
     processing once a program has been loaded into the cache and the cache
     disabled. Programs that use this feature will work on the Cx486SLC/DLC
     with writes happening on external write bus cycles.


SS-3 Description

     On systems with hardware FPUs, whose FPU ERROR signal is routed to the
     CPU ERROR signal (NE bit set on the 80486DX), a floating point error is
     normally acknowledged by the CPU upon execution of the next floating
     point instruction. If the next floating point instruction is a load single
     or load double precision that would have generated a General Protection
     (GP) fault, it is possible for the Cx486SLC/DLC to acknowledge the GP
     fault before the coprocessor error fault. The 80486 acknowledges the
     coprocessor error first.

     Analysis

     This condition (FPU ERROR connected to CPU ERROR) does not occur in PC
     compatible designs.



INFORMATIONAL DIFFERENCES - (SOFTWARE)

IS-1  Description

      Certain 80486 flag bits in the flags register are documented by Intel
      as undefined after execution of certain instructions. Testing at Cyrix
      has shown that the final states of theses flag bits are in fact
      unpredictable. The Cx486SLC/DLC leaves the flag bit values unmodified
      after execution of the same instructions.

      Analysis

      Since the flag bits are documented by Intel to be undefined after certain
      operations, software can not reliably use the resulting flag bit values.


IS-2  Description

      Early revision 80486SX CPUs have a programmable Numeric Exception control
      bit in control register CR0 (bit 28). This bit was intended to control
      whether numeric execptions are handled internally (NE=1) or driven
      externally on a discrete CPU pin (NE=0). On these 80486SXs, the NE bit
      can be set to a one even though numeric execptions can not be handled
      internally due to the fact that no coprocessor exists. Reading the NE
      bit on the coprocessor exists. Reading the NE bit on the Cx486SLC/DLC
      always returns a zero indicating that numeric exceptions are always
      handled externally.

      Analysis

      Since the Cx486SLC/DLC does not have an on-board floating point unit, the
      coprocessor interface (including numeric exception signaling) operates in
      a fashion compatible with the 80386.The Cx486SLC/DLC and 80386 use an
      external coprocessor which generates the numeric exception and always
      return zero when the NE bit is read.


IS-3  Description

      When trying to reference CR1 in protected mode while not at the highest
      privilege level (level 0), the 80486 generates an Invalid Opcode fault,
      whereas the Cx486SLC/DLC generate a General Protection (GP) fault.

      Analysis

      The Cx486SLC/DLC and 80486 do not define the bits in the CR1 register.
      Since there are no valid bits in the CR1 register, any exception taken,
      whether it is a GP fault or Invalid Opcode fault, will signal that an
      invalid operation has taken place.


IS-4  Description

      When using the Translation Lookaside Buffer (TLB) test registers, the
      undefined bits in TR7 may differ between the 80486 and the Cx486SLC/DLC
      when a look-up miss (TR7 bit 4 is clear) occurs. This includes the REP
      field (bits 2-3).

      Analysis

      The majority of the bits in TR7 are documented by Intel to be undefined
      after a TLB look-up miss. Therefore, software programs can not reliably
      use the resulting values of these undefined bits.


IS-5  Description

      Cx486SLC/DLC reads and writes to Debug Register 4 (DR4) and Debug
      Register 5 (DR5) result in accesses to Debug Register 6 (DR6) and
      Debug Register 7 (DR7), respectively. Accessing DR4 and DR5 on the
      80486 produces an Invalid Opcode fault.

      Analysis

      DR4 and DR5 are documented as undefined by Intel on the 80486. Since
      the results are undefined, software programs can not reliably use the
      register results.


IS-6  Description

      Writing duplicate TLB tags using the TLB test registers generates
      different results on the Cx486SLC/DLC than on the 80486 when the
      duplicate address is looked up. The results of writing duplicate
      TLB tags is documented as undefined by Intel.

      Analysis

      Writing duplicate TLB tags using the TLB test registers is an unsupported
      operation. The Cx486SLC/DLC and 80486 return undefined results when
      looking up the resulting address. Since the results are undefined,
      software programs can not reliably use the register results.


IS-7  Description

      The 80486 imposes a performance penalty in order to report debug faults
      precisely. The Cx486SLC/DLC reports debug faults precisely without a
      performance penalty (except for a repeated MOVS instruction).

      Analysis

      The Cx486SLC/DLC provides superior debugging capability.


IS-8  Description

      The 80486 writes zeroes to the destination register when executing a
      Bit-Scan Forward (BSF) instruction if all zeroes are found in the
      specified bit map. The Cx486DLC/DLC leaves the destination register
      unchanged under this condition.

      Analysis

      The value in the destination register of a BSF instruction is specified
      by Intel to be undefined when a one bit is not found in the source
      operand. Since the results are undefined, software programs can not be
      reliably use the register results.


IS-9  Description

      Memory versions of the instructions ADC, ADD, AND, DEC, INC, MOVS, NEG,
      NOT, OR, RCl, ROL, ROR, SAl, SAR, SBB, SUB, SHL, SHLD, SHR, SHRD, XCHG,
      and XOR read the destination memory, operate on it, and write it back to
      memory. The Cx486SLC/DLC checks the writability of the destination before
      performing these instructions. On non-writable locations, the Cx486SLC/
      DLC faults before starting the instruction. The 80486 performs the read,
      sets the read location acessed bit, and modifies the flags before
      faulting.

      Analysis

      By checking the writability first prior to execution of the instruction
      (at no performance penalty), the Cx486SLC/DLC avoids unnecessary
      operations. Leaving the accessed bit and flag contents in their original
      state is prefered if the instruction is restarted.


IS-10 Description

      In the case above, if the read locatuion is also not present, the 80486
      will attempt the read, take a page fault, reload the page, restart the
      instruction, and then take a GP fault. The Cx486SLC/DLC will take a GP
      fault.

      Analysis

      The 80486 wastes time loading the requested page before taking the
      required GP fault. The GP fault is eventually detected by both the 80486
      and the Cx486SLC/DLC.


IS-11 Description

      If a locked instruction accesses a memory page marked as not present, the
      80486 reports in the error code that the access type was a write while
      the Cx486SLC/DLC reports that the access type was a read.

      Analysis

      Since the page is not present in either case (read or write), the same
      page fault is taken by both the Cx486SLC/DLC and the 80486.


IS-12 Description

      When alignment checking is enabled an an ENTER instruction that misaligns
      the stack is executed, the 80486 generates an alingment check fault even
      though the misaligned stack has not been accessed. The Cx486SLC/DLC
      generates the aligment check fault only when the misaligned stack is
      accessed.

      Analysis

      The Cx486SLC/DLC correctly generates an alignment check fault only when
      a misaligned stack is accessed. The 80486 unnecessarily takes the fault
      in the case described.


IS-13 Description

      When executing a REP LOOPE (repeated loop while equal) instruction, the
      80486 does not perform the "if equal" function of the instruction. The
      Cx486SLC/DLC does perfrom the "if equal" check under the same
      circumstances.

      Analysis

      The 80486 execution should be considered incorrect. The Cx486SCL/DLC
      correctly executes this instruction sequence.


IS-14 Description

      The 80486 incorrectly asserts the LOCK# pin while enterinf the illegal
      instruction exception handler when using the LOCK prefix on instructions
      other than those allowed (Only BTS, BTR, BTC, XCHG, INC, DEC, NOT, NEG,
      ADD, ADC, SUB, SBB, AND, OR, XOR are allowed). The Cx486SLC/DLC correctly
      does not assert LOCK# in this case.

      Analysis

      When using the 80486 in a multi-processor environment, the bus may be
      locked unnecessarily causing performance degradation.



Operating systems/operating environments tested with the Cx486SLC/DLC:

Digital Research: Concurrent DOS 386 5.0, DR-DOS 6.0
Ergo:             OS/386
IBM:              IBM DOS 3.3, IBM DOS 4.0, OS/2 2.0, OS/2 SE 1.3
IGC:              VM/386 2.01
Interactive:      Interactive Unix 3.2
Mark Williams:    Coherent 3.1, Coherent 3.2
Microsoft:        MS-DOS 3.3, MS-DOS 4.01, MS-DOS 5.0, Windows 3.0, Windows 3.1
Pharlap:          DOS-Extender 286, DOS-Extender 386
Quarterdeck:      Desqview 386 2.32
Rational:         DOS/4G
SCO:              SCO Open Desktop, SCO Unix, SCO Xenix 2.3.2c
Symantec:         Norton Desktop for Windows 1.0
UHC:              Developers Environment, Network Module, X11R4/Motif Windowing
                  Module, UNIX Release 4.0 Ver. 3.6
 