# Flock Version 2.0 - Assembly Instructions

## Prerequisites

### Tools, Equipment, and Supplies

* Soldering iron with a fine tip. Temperature controlled soldering station is recommended
* Needle nose pliers for forming components' leads
* Small side cutters for cutting components' leads
* Multimeter with frequency measurement, an oscilloscope, or a logic analyzer can be beneficial for troubleshooting
* Desk lamp, magnifying glass
* Solder suitable for soldering electronics. For example: rosin core Sn63/Pb37, Sn60/Pb40, or a lead-free solder such as Sn96.5/Ag3.0/Cu0.5 (sometimes referred to as SAC305)
* Solder wick for removing excess of solder
* 99% Isopropyl Alcohol for removing the excess of flux after soldering
* Lint free wipes, used toothbrush, cotton swabs for cleaning the PCB before and after soldering

### Parts

The table below shows the images of the components included in the kit. The up to date list of parts provided in the [Bill of Materials](README.md#bill-of-materials) section of the [README.md](README.md) file. It also provides the recommended sources for the parts.

Image                                                                                           | Reference | Description                                            | Quantity
----------------------------------------------------------------------------------------------- | --------- | ------------------------------------------------------ | --------
<img src="images/Flock-V2-PCB-Front_Side-800px.jpg" alt="PCB - Flock V2" height="120">             | PCB       | Flock PCB - Version 2.0                                | 1
<img src="images/Component-IC-37C65-FDC.jpg" alt="FDC - 37C65" height="120">                    | U1        | WD37C65BJM - FDC, CMOS, 44 pin PLCC                    | 1
<img src="images/Component-IC-DS1302-RTC.jpg" alt="RTC - DS1302+" height="120">                 | U2        | DS1302+ - RTC, 8 pin DIP                               | 1
<img src="images/Component-IC-SPLD-Flock-V2.jpg" alt="Flock V2 SPLD - ATF16V8B" height="120">   | U3        | ATF16V8B SPLD, programmed with Flock V2 fuse map, 20 pin DIP | 1
<img src="images/Component-IC-74HCT174-6DFF.jpg" alt="Hex D Flip-Flop - 74HCT174" height="120"> | U4        | 74HCT174 - Hex D-type flip-flop with reset, 16 pin DIP | 1
<img src="images/Component-IC-74HCT125-8BUF.jpg" alt="3-State Buffer - 74HCT125" height="120">  | U5        | 74HCT125 - Quadruple bus buffer gates with 3-state outputs, 14 pin DIP | 1 
<img src="images/Component-Crystal-16MHz.jpg" alt="16 MHz Quartz Crystal" height="120">         | Y1        | Quarts crystal, 16 MHz, series                         | 1
<img src="images/Component-Crystal-32762Hz.jpg" alt="32762 Hz Quartz Crystal" height="120">     | Y2        | Quarts crystal, 32768 Hz, 6 pF                         | 1
<img src="images/Component-Header-2x17-Shrouded-RA.jpg" alt="2x17 Shrouded Pin Header Right Angle" height="120"> | J1      | Pin header, shrouded, 2x17 pins, right angle, 2.54 mm pitch | 1
<img src="images/Component-Conn-Latch-2-RA.jpg" alt="Friction Lock Connector" height="120">     | J2        | Pin header with friction lock, 2 pins, right angle     | 1 (optional)
<img src="images/Component-Header-2x40-RA.jpg" alt="Pin Header 2x40 Right Angle" height="120">  | J3        | Pin header, 2x40 pins, 2.54 mm pitch, right angle      | 1
<img src="images/Component-Header-2.jpg" alt="Pin Header 2 pins" height="120">                  | JP1       | Pin header, 2 pins, 2.54 mm pitch                      | 1
<img src="images/Component-Jumper-2.jpg" alt="Jumper" height="120">                             | JP1       | Jumper/Shunt, 2 pin 2.54 mm pitch
<img src="images/Component-Battery_Holder-CR2032.jpg" alt="CR2032 Battery Holder" height="120"> | BT1       | Battery Holder, CR2032 (optional; C7 can be installed instead) | 1
<img src="images/Component-Cap-0.1uF-MLCC.jpg" alt="Ceramic Capacitors - 0.1uF" height="120">   | C1 - C5   | Capacitor, MLCC, 0.1 uF, 50V, 5 mm pitch               | 5
<img src="images/Component-Cap-10uF-Polymer.jpg" alt="Organic Polymer Capacitor - 10uF" height="120"> | C6  | Capacitor, Organic Polymer, 10 uF, 63V, 6.3 mm diameter, 2.5 mm pitch (optional; BT1 can be installed instead) | 1
<img src="images/Component-Supercap-0.33F.jpg" alt="Supercapacitor - 0.33F" height="120">       | C7        | Supercapacitor, 0.22 F, 5.5V, 13.5 mm diameter, 5 mm pitch            | 1
<img src="images/Component-Cap-47pF-MLCC.jpg" alt="Ceramic Capacitor - 47pF" height="120">      | C8        | Capacitor, MLCC, 47 pF, 50V, 5 mm pitch                | 1
<img src="images/Component-Cap-15pF-MLCC.jpg" alt="Ceramic Capacitor - 15pF" height="120">      | C9        | Capacitor, MLCC, 15 pF, 50V, 5 mm pitch                | 1
<img src="images/Component-RN5-1k.jpg.jpg" alt="Resistor Network - 5x1k" height="120">          | RN1       | Resistor Network, 1 kohm, bussed, 6 pin SIP            | 1
<img src="images/Component-Res-10k.jpg" alt="Resistors - 10k" height="120">                    | R1 - R3    | Resistor, 10 kohm, 0.25 W, axial                       | 2
<img src="images/Component-Socket-PLCC44.jpg" alt="IC Socket - PLCC44" height="120">            | U1        | Integrated circuit socket, 44 pin PLCC, through hole   | 1
<img src="images/Component-Socket-DIP8.jpg" alt="IC Socket - DIP8" height="120">                | U2        | Integrated circuit socket, 8 pin DIP                   | 1 (optional)
<img src="images/Component-Socket-DIP20.jpg" alt="IC Socket - DIP20" height="120">              | U3        | Integrated circuit socket, 20 pin DIP                  | 1 (optional)
<img src="images/Component-Socket-DIP16.jpg" alt="IC Socket - DIP16" height="120">              | U4        | Integrated circuit socket, 16 pin DIP                  | 1 (optional)
<img src="images/Component-Socket-DIP14.jpg" alt="IC Socket - DIP16" height="120">              | U5        | Integrated circuit socket, 14 pin DIP                  | 1 (optional)
<img src="images/Floppy_Power_Cable.jpg" alt="Floppy power cable" height="120">                 |           | Floppy disk power cable                                | 1 (optional)

## Assembly Steps

### 1. Gather supplies and parts

* Check that you have all the equipment and parts listed in the [Prerequisites](#prerequisites) section above
* Organize your workspace. If available, use ESD-safe surface and ESD strap when working on this project

### 2. Solder the components

Solder the components to the PCB going from lower profile components to higher profile components, from smaller components to larger. Here is the recommended order:

* Start by soldering the R1 - R3 resistors. The resistors are not polarized and can be oriented either way. Trim the leads using cutters
* Next solder the Y1 and Y2 quartz crystals. Make a U-shaped loop using a resistor lead cut in the previous step, and secure Y2 to the PCB with that loop
* Solder RN1 resistor array. Make sure that the resistor array is oriented correctly. The first pin of the resistor array is marked with a printed dot, and the first pad on the board has a square shape
* Solder the C1 - C5, C8, and C9 capacitors. Note that these are non-polarized ceramic capacitors, so they can be oriented either way. Trim the leads using cutters
  * C1 – C5 have a “104” marking
  * C8 has “470” marking
  * C9 has “150” marking
* Solder DIP sockets for the U2 – U5 ICs. Double check the orientation of the sockets. The notch on the socket should match the notch on the PCB’s silkscreen.
Solder two opposite pins first, making sure that the socket sits flat on the PCB. Check the orientation and the alignment, fix as needed,
then solder the rest of the pins
  * Note that soldering the socket for U2 is optional. The real time clock would be more accurate without it,
as the socket introduces extra capacitance. You may choose to solder the DS1302 RTC IC directly to the PCB at this step
* Solder the PLCC socket for the U1 IC. Make sure that the cut side of the socket aligns with the drawing on the silkscreen
* Solder the J3 RCBus connector
* Solder the J2 floppy power connector. This connector is optional. You might choose to power the floppy drive(s) directly from the power supply instead
* Solder the J1 floppy interface connector
  * Note that you may need to cut or extract pin 3 from this connector to accommodate some floppy cables that have this pin position blocked
* Solder the JP1 header
* Solder the C6 capacitor. Pay attention to the __polarity__ – the negative side is painted white on the PCB and marked with blue on the capacitor. Note that C6 is marked as 47uF on the PCB. Install the supplied 10uF capacitor instead
* If a supercapacitor to be used for RTC backup, solder the C7 supercapacitor. Pay attention to the __polarity__ – the negative side is painted white on the PCB and marked with gray stripe on the supercapacitor. Note that C7 is marked as 0.22F on the PCB. Install the supplied 0.33F supercapacitor instead
* If a CR2032 battery to be used for RTC backup, solder BT1 battery holder. Observe the __polarity__

### 3. Check your soldering work

* Make sure all pins of all components are soldered properly
* If desired, clean the flux using isopropyl alcohol, cotton swabs. You might want to scrub the board lightly with a used toothbrush to remove the flux
* Check soldering work again after cleaning the board

### 4. Insert the integrated circuits to the sockets
* Prior to inserting DIP integrated circuits to the sockets board, bend their leads slightly, so they point 90 degrees downward. Put the IC on the side on a hard flat antistatic surface and gently push it down to bend the leads. Repeat on the other side of the IC
* Double check that you're placing the integrated circuit in the right socket, check the IC orientation. The index notch on the IC should match the notch on the socket and the drawing on the PCB's silkscreen
* To insert the 37C65 FDC integrated circuit in PLCC44 package, place it on the top of the socket, double check the orientation of the integrated circuit, and firmly push it down. It should click into the socket

![Assembled board](images/Flock-V2-Assembled_Board-800px.jpg)

## Module Installation Instructions

* Make sure that your RCBus or RC2014*-compatible system has I/O port range 0x48-0x5F available for the Floppy Disk Controller
* If you have a Z80-based system:
  * Make sure that jumper JP1 is **not** installed
  * Verify that I/O port range 0xC0-0xC1 is available
* If you have a Z180-base system:
  * Install jumper JP1
  * Verify that I/O port range 0x0C-0x0D is available
* Plug the module into your system
* Connect the floppy drive(s) to the board. Standard IBM PC ribbon floppy cable with twisted wires 10-16 should be used (not supplied). The first floppy drive is the one at the end of the cable, the second is on the middle of the cable
* Connect the floppy drive(s) to power supply. A single 3.5” 1.44 MB drive can be powered directly from the Flock board, using supplied power cable. Make sure to use powerful enough power supply. The floppy drive consumes about 1A
* Rebuild RomWBW with floppy support or use the pre-built image provided in the project’s GitHub repo. Here are the brief steps to rebuild the image. See [https://github.com/wwarthen/RomWBW/blob/master/Source/ReadMe.txt](https://github.com/wwarthen/RomWBW/blob/master/Source/ReadMe.txt) for complete instructons:
    a. Download the RomWBW source or clone its Git repository: [https://github.com/wwarthen/RomWBW/releases](https://github.com/wwarthen/RomWBW/releases)
  1. Open the _Source/HBIOS/Config/RCZ80_std.asm file_ in a text editor, and set _FDENABLE_ value to _TRUE_
  2. From the _Source_ folder, run the **BuildShared** command. This will build software that is shared by all RomWBW images
  3. From the _Source_ folder, run the **BuildRom** command. Select “RCZ80” platform and “std” configuration
  4. The resulting ROM image will be located in the Binary folder and will be named _RCZ80_std.rom_. Program the image to your systems’ flash ROM using either an EPROM programmer or FLASH4 command
* Power on your system. Verify that RomWBW shows DSRTC: device, reads the time from the RTC, shows FD: device, and displays floppy disk drives as shown in the screenshot below:

![RomWBW Boot Screen with Flock](images/RomWBW-Flock.png)

## Module Usage Instructions – Floppy Disk Controller
The FDU utility included in RomWBW and can be used to test the floppy disk controller and to format floppy disks
* Boot your system to CP/M or ZSDOS and run the **FDU** command. Type **H** to select “(H) RC2014 WDC (SMB)”
* Use the **S** command to set the floppy disk configuration. Select the correct media type (e.g., enter “01” for 1.44 MB disks), leave the default settings for mode and trace
* Use the **F** command to format the floppy disk. Note that all information on the disk will be destroyed
* Use the **R** and **W** commands to test reading from and writing to the floppy disk
Once formatted, the floppy disk can be accessed from CP/M and ZSDOS. RomWBW normally assigns letters _C:_ and _D:_ to the first and the second floppy drives respectively

## Module Usage Instructions – FAT12 Floppy formatting
The FAT utility included with RomWBW will format floppies to FAT12, rendering them writable on modern computers.
* Boot your system to an OS which supports the FAT utility (I.E. ZP/M). 
* Observe the disk unit number when booting your system for FD0 (I.E. Disk 2)
* Run **FAT FORMAT 2:** and be absolutely sure your disk unit number is correct.  
* Wait for the format to complete.
Once formatted, the disk can be used with a modern computer, such as with a USB to 1.44 Floppy drive. The floppy disk can be accessed only using the FAT utility on RomWBW; Formatting a disk this way is primarily to use it for a bridge to a modern machine. The FAT utility is used to copy files between your CP/M etc. system storage, and the FAT formatted floppy disk.

## Module Usage Instructions – Real Time Clock
The RTC utility included in RomWBW is used to set and test the real time clock
* Boot your system to CP/M or ZSDOS and run the **RTC** command
* Use the **I** command to enter the current date and time. Use two digit values for each entry
* Use the **S** command to set the RTC to the time entered in the previous step with I command
* Use the **T** command to print the current time. Check that the time is set correctly and RTC properly updates the time
* Use the **C** command to enable trickle charge, so that DS1302 will be charing the on-board supercapacitor


__Congratulations! Enjoy your Flock Module!__
