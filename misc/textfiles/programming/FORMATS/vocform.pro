I have figured out most of the .VOC format, and here it is: 
============================================================= 
 
 
HEADER: (bytes 00-19) 
======= 
     byte #           Description 
     ------           ----------- 
     00-12            Creative Voice File 
     13               1A (eof to abort printing of file) 
     14-15            1A 00  word offset in file of first data block 
     16-17            Version number             (VOC-HDR puts 0A 01) 
     18-19            2's Comp of Ver. # + 1234h (VOC-HDR puts 29 11) 
 
DATA: (bytes 1A+)    A series of data blocks terminated by 00 
===== 
 
   Data Block:  TYPE(1-byte), SIZE(3-bytes), INFO(0+ bytes) 
   ----------- 
 
      TYPE   Description   Size (3-byte int)   info 
      ----   -----------   -----------------   ---- 
      01     Sound data    2+length of data    * 
      02     ???? 
      03     Silence       3                   * 
      04     Marker        2                   marker # 
      05     ???? 
      06     Repeat        2                   # of repetitions 
      07     End repeat    0 
      08+    ???? 
 
*Sound info format:         *Silence info format: 
 -----------------           -------------------- 
 00   Sample rate            00-01  Length of silence (weird encryption) 
 01   Compression type       02     38 
 02+  Data 
 
 
Sample rate       -- SR byte = 256-(1000000/sample_rate) 
Length of silence -- (# of .1 seconds encrypted) 
Compression type  -- 8-bits    = 0 
                     4-bits    = 1 
                     2.5-bits  = 2 
                     2-bits    = 3 
                     Multi DAC = 3+(# of channels) 
 
Silence encoding in VOXKIT finds quiet places in file, and creates a separate 
block that is of type Silence. 
 
 
 
The only remaining mysteries are what types 2&5&8+ are if they exist, and the 
exact conversion of the silence length integer to seconds.  If you have any 
more information, please email me at:   galt@dsd.es.com 
I hope this info will help to create more  public domain utilities for the 
soundblaster. 
           Greg 
 
 
 