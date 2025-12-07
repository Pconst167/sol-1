# Sol-1 Homebrew Minicomputer

Sol-1 is a homebrew CPU and Minicomputer built from 74HC logic.
It is published here for educational purposes.

### Directory Struture
| Folder Name | Description |
| ------------- | ----------- |
| ccompiler     | a c compiler written for the Sol-1 CPU. It outputs Sol-1 assembly |
| hardware      | schematics, board pictures, microcode assembler |
| software      | bios, kernel, shell, and unix utilities programs written in ASM for Sol-1 |
| solarium      | the operating system for Sol-1 |
| systemverilog | systemverilog models for the Sol-1 CPU, computer, and a few other things |
| general_docs  | datasheets and miscellaneous documents related to Sol-1 and digital design in general | 
| sol1_docs     | documents directly related to Sol-1 | 

## Features
### Hardware
- User and Kernel privilege modes, with up to 256 processes running in parallel.
- Paged virtual memory, such that each process can have a total of 64KB RAM for itself.
- Two serial ports (16550), a real time clock(M48T02), 2 parallel ports(8255), a programmable timer(8253), an IDE hard-drive interface(2.5 Inch HDD), a sound chip(AY-3-8910),
5.25" floppy drive controller (WD1770).
- 8 prioritized external interrupts
- DMA channel
- The sequencer is microcoded, with 15 ROMS operating horizontally
- 8/16-Bit MUL and DIV instructions
- Fast indexed string instructions in the spirit of x86's REP MOVSB, CMPSB, LODSB, STOSB, etc
- 32bit IEEE 754 Floating Point Unit (Under Development)
- 5.25" floppy drive :)

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

### Software
- Unix-like operating system (in progress and very early)
- C compiler that generates a Sol-1 assembly output file
- SystemVerilog model

[Video demonstrations here](https://www.youtube.com/@PauloConstantino167/videos)


![Wirewrap Board](https://github.com/Pconst167/sol-1/blob/main/images/20180728_193513.jpg)
![Register Board](https://github.com/Pconst167/sol-1/blob/main/images/20180727_015916.jpg)
![Front](https://github.com/Pconst167/sol-1/blob/main/images/front-1.jpg)
![Boot](https://github.com/Pconst167/sol-1/blob/main/images/Screenshot%20from%202023-07-22%2020-40-15.png)
![Front](https://github.com/Pconst167/sol-1/blob/main/images/Screenshot%202022-10-05%20194412.png)

### Licensing Terms

Sol-1 Homebrew CPU/Minicomputer is a CPU + system around it, made from 74 series logic from scratch
as an educational project.
Copyright (C) 2025  Paulo Constantino

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, see
<https://www.gnu.org/licenses/>.

contact: pconstantino@sol-1.org
