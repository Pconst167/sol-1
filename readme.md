# Sol-1 Homebrew Minicomputer

Sol-1 is a homebrew CPU and Minicomputer built from 74HC logic.
It is published here for educational purposes ONLY.

## Features
### Hardware
- User and Kernel privilege modes, with up to 256 processes running in parallel.
- Paged virtual memory, such that each process can have a total of 64KB RAM for itself.
- Two serial ports (16550), a real time clock(M48T02), 2 parallel ports(8255), a programmable timer(8253), an IDE hard-drive interface(2.5 Inch HDD), and a soundboard(AY-3-8910).
- 8 prioritized external interrupts
- DMA channel
- The sequencer is microcoded, with 15 ROMS operating horizontally
- 8/16-Bit MUL and DIV instructions
- Fast indexed string instructions in the spirit of x86's REP MOVSB, CMPSB, LODSB, STOSB, etc

### Register Table
#### General Purpose Registers

| 16bit | 8bit  | Description |
| ----- | ----- | ----------- |
| A     | AH/AL | Accumulator |
| B     | BH/BL | Base Register (Secondary Counter Register) |
| C     | CH/CL | Counter Register (Primary Counter) |
| D     | DH/DL | Data Register / Data Pointer |
| G     | GH/GL | General Register (For scratch) |

#### Special Purpose Registers

| 16bit  | 8bit   | Description |
| ------ | ------ | ----------- |
| PC     |        | Program Counter |
| SP     |        | Stack Pointer |
| SSP    |        | Supervisor Stack Pointer |
| BP     |        | Base Pointer (Used to manage stack frames) |
| SI     |        | Source Index (Source address for string operations) |
| DI     |        | Destination Index (Destination address for string operations) |
| PTB    |        | Page Table Base |
| Status |        | CPU Status |
| Flags  |        | Arithmetic and Logic flags register |
| TDR    | TDRH/TDRL | Temporary Data Register (Internal CPU scratch register) |

### Software
- Unix-like operating system (in progress and very early)
- C compiler that generates a Sol-1 assembly output file (The output assembly is then assembled separately.)
- SystemVerilog model

[Video demonstrations here](https://www.youtube.com/@PauloConstantino167/videos)
