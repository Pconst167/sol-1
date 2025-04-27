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
- Two serial ports (16550), a real time clock(M48T02), 2 parallel ports(8255), a programmable timer(8253), an IDE hard-drive interface(2.5 Inch HDD), and a sound chip(AY-3-8910).
- 8 prioritized external interrupts
- DMA channel
- The sequencer is microcoded, with 15 ROMS operating horizontally
- 8/16-Bit MUL and DIV instructions
- Fast indexed string instructions in the spirit of x86's REP MOVSB, CMPSB, LODSB, STOSB, etc
- 32bit IEEE 754 Floating Point Unit (Under Development)

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

CC BY-NC-SA 4.0 DEED
Attribution-NonCommercial-ShareAlike 4.0 International

You are free to:
Share — copy and redistribute the material in any medium or format.
Adapt — remix, transform, and build upon the material.
The licensor cannot revoke these freedoms as long as you follow the license terms.

Under the following terms:
Attribution — You must give appropriate credit , provide a link to the license, and indicate if changes were made. 
You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
NonCommercial — You may not use the material for commercial purposes.
ShareAlike — If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original.

No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.
Notices:
No warranties are given. The license may not give you all of the permissions necessary for your intended use. 
For example, other rights such as publicity, privacy, or moral rights may limit how you use the material.

Paulo Constantino

