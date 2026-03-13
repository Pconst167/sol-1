
# TL866II+ Protocol Documentation #


The TL866II+ programmers have 3 USB bulk endpoints. Endpoint 1 is used 
to send commands to the programmer and receive status information back 
from the programmer. Endpoints 2 and 3 are used when reading or writing 
a payload to a chip, presumably to help increase performance.

## Commands Bytes ##

* 0x00 - Get system(programmer) info
* 0x03 - Begin transaction
* 0x04 - End trasaction
* 0x05 - Read chipid
* 0x06 - Read USER
* 0x07 - Write USER
* 0x08 - Read Fuses
* 0x09 - Write Fuses
* 0x0A - Write payload to data2 memory
* 0x0B - Read payload from data2 memory
* 0x0C - Write payload to code memory
* 0x0D - Read payload from code memory
* 0x0E - Erase chip
* 0x10 - Read payload from data memory
* 0x11 - Write payload to data memory
* 0x14 - Write LOCK bits
* 0x15 - Read LOCK bits
* 0x16 - Read RC calibration
* 0x18 - Protect off
* 0x19 - Protect on
* 0x1b - ???
* 0x2d - Reset pin drivers
* 0x2e - ???
* 0x2f - ???
* 0x30 - ???
* 0x31 - ???
* 0x32 - ???
* 0x34 - ???
* 0x35 - Read pin state
* 0x36 - ???
* 0x38 - Unlock TSOP48
* 0x39 - Request status message


## Get Programmer Information ##

Sending command 0x00 to the programmer will return a block of 
information about programmer, including firmware version and the serial 
number. This command works almost identically to the TL866A/CS series 
except the returned data is 41 bytes long instead of 40. The updated 
data structure looks like the following:

```
struct minipro_report_info
{
	uint8_t  echo;
	uint8_t  device_status;
	uint16_t report_size;
	uint8_t  firmware_version_minor;
	uint8_t  firmware_version_major;
	uint16_t device_version; // changed from byte to word.
	uint8_t  device_code[8];
	uint8_t  serial_number[24];
	uint8_t  hardware_version;
};

```

For the TL866II+ the device version is 5.

## Pin drivers ##

The following command ids are used for for direct pin control: 0x1b, 
0x2d-0x32, 0x34-0x36. These sets of commands are used to implement pin 
detect and the hardware check feature.

Command 0x2d will reset the pin drivers to their defualt state and 
command 0x35 will read the current pin state.

The read pin state command will return 48 bytes over endpoint 1. The 
first 8 bytes are a header and the next 40 tell the current pin state 
for each pin.

## Transactions ##

A transaction needs to be started before you can read, write or erase a 
chip. The command to start a transaction is 0x03 and is used to give the 
programmer information about the chip being programmed. It is a 64 byte 
structure that looks like the following.

```
struct begin_transaction {
	uint8_t  cmd;                 // 0x00
	uint8_t  protocol;            // 0x01
	uint8_t  variant;             // 0x02
	uint8_t  icsp;                // 0x03
	uint8_t  unknown1;            // 0x04
	uint16_t opts1;               // 0x05
	uint8_t  unknown2;            // 0x07
	uint16_t data_memory_size;    // 0x08
	uint16_t opts2;               // 0x0A
	uint16_t opts3;               // 0x0C
	uint16_t data_memory2_size;   // 0X0E
	uint32_t code_memory_size;    // 0x10
	uint8_t  zero1[20];           // 0x14
	uint32_t package_details;     // 0x28
	uint32_t zero2[20]            // 0x2C
};
```

When finished you need to send an end transaction command of 0x04. This 
has a simple structure as follows:

```
struct end_transaction {
	uint8_t cmd;          // 0x00
	uint8_t zero[7]       // 0x01
};
```


## Reading/Writing ##

To initiate a read or write you must for send an 8 byte command to EP1 
that tells the programmer the protocol to used as well as the length of 
data being transferred and the offset in memory to start the transfer 
at.

#### Example of reading 512 bytes from a AT28C64B EEPROM at offset 0 ####


| cmd  | protocol | length  |offset              |
|:----:|:--------:|:-------:|:------------------:|
|0x0D  |0x07      |0x00 0x02| 0x00 0x00 0x00 0x00|


Actually reading or writing the data depends on the amount of data being 
read or written. If you are transferring less then 64 bytes of data then 
you will use endpoint 1 to transfer that data to or from the chip. This 
works much like the TL866A/CS series.

If however the data is 64 bytes or more you will need to send or receive 
the data over endpoints 2 and 3. In this case half the data will be 
transfered using endoint 2 and the other half will use endpoint 3. The 
data will be broken up into 64 byte blocks and alternate between the two 
endpoints.

For example if you were trying to read 512 bytes from an EEPROM, you 
would expect 256 bytes to be returned over endpoint 2 and another 256 
bytes returned over endpoint 3. The data over endpoint 2 would contain 
blocks [0,2,4,6] while endpoint 3 would give you blocks [1,3,5,7].
