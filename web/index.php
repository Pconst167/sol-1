<html>
<title>Sol-1 74 Series Logic Homebrew CPU - 2.5MHz</title>
	
<head>
<meta name="keywords" content="homebrew cpu,homebuilt cpu,ttl,alu,homebuilt computer,homebrew computer,74181,Sol-1, Sol, electronics, hardware, engineering, programming, assembly, cpu, logic">
<link rel="icon" href="http://sol-1.org/images/2.jpg">	
<style>
        body {
            margin: 0;
            padding: 0;
            background-image: url('images/bg/retro-sci-fi-background-futuristic-grid-landscape-of-the-80s-digital-cyber-surface-suitable-for-design-in-the-style-of-the-1980s-free-video.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            height: 100vh; /* Viewport height */
  	    background-attachment: fixed;
        }

        html {
            height: 100%;
        }
    </style>
</head>

<body >

<?php include("menu.php"); ?>

<header>
<h3><span id="headerSubTitle">home</span></h3>
</header>


<table>
<tr>
<td>
<pre>
This website is connected to a homebrew 16Bit CPU/Minicomputer built from scratch using 74-Series logic gates.
It is constructed using plain 74HC logic gates on wire-wrap boards and has around 270 chips in total.

# Sol-1 Homebrew Minicomputer

Sol-1 is a homebrew CPU and Minicomputer built from 74HC logic.
It is published here for educational purposes.

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

</pre>
</td>
</tr>
</table>






</body>
</html>

