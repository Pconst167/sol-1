Article 1275 of 1310, Sat 15:08.                                                
Subject: Re: Format of .exe files?                                              
nization of Organization))                                                      
(119 lines) More? [ynq]                                                         
In article <8209@watdaisy.UUCP> dvadura@watdaisy.UUCP (Dennis Vadura) writes:   
>Can anyone out there point                                                     
>me to someplace that I can find a detailed description of the format of        
>a .exe file.  I need to know all the fields, their meanings, and their         
>offsets from the start of the file.  Any help will be greatly appreciated.     
                                                                                
OK, here it is.  The following is from the IBM Personal Computer                
Software Disk Operating System Technical Reference, v2.10, 3.00 and             
3.10, pp 10-3 to 10-6:                                                          
                                                                                
-- cut here --                                                                  
                                                                                
EXEILE STRUCTURE                                                                
                                                                                
The .EXE files produced by the Linker program consist of two parts:             
                                                                                
        * Control and relocation information                                    
        * The load module itself                                                
                                                                                
The control and relocation information, which is described below, is            
at the beginning of the file in an area known as the _header_.  The             
load module begins in the memory image of the modlue constructed by             
the Linker.                                                                     
                                                                                
The header is formatted as follows:                                             
                                                                                
HEX OFFSET      CONTENTS                                                        
00-01           4DH, 5AH -- this is the Link program's signature to             
                mark the file as a valid .EXE file.                             
02-03           Length of image mod 512 (remainder after dividing the           
                load module image size by 512).                                 
04-05           Size of the file in 512-byte increments (pages),                
                including the header.                                           
06-07           Number of relocation table items.                               
08-09           Size of theeader in 16-byte increments (paragraphs).            
                This is used to locate the beginning of the load                
                module in the file.                                             
0A-0B           Minimum number of 16-byte paragraphs required above             
                the end of the loaded program.                                  
0C-0D           Maximum number of 16-byte paragraphs required above             
                the end of the loaded program.                                  
0E-0F           Displacement in paragraphs of stack segment within load         
                module.                                                         
10-11           Offset to be in the SP register when the module is              
                given control.                                                  
12-13           Word checksum -- negative sum of all of the words in            
                thefile, ignoring overflow.                                     
14-15           Offset to be in the IP register when the module is given        
                control.                                                        
16-17           Displacement in paragraphs of code segment within load          
                module.                                                         
18-19           Displacement in bytes of the first relocation item              
              within the file.                                                  
1A-1B           Overlay number (0 for resident part of the program).            
                                                                                
NOTE:  Use the value at hex offset 18-19 to locate the first entry in           
the relocation table.                                                           
                                                                                
RELOCATION TABLE                                                                
                                                                                
The word at 18H locates the first entry in the relocation table.  The           
relocation table is made up of a variable number of relocation items.           
The number of items is contained at offset 06-07.  The relocation item          
contains two fields -- a 2-byte offset value, followed by a 2-byte              
segment value.  These two fields represent the displacement into the            
load module of a work which requires modification before the module is          
given control.  This process is called _relocation_ and is                      
accomplished as follows:                                                        
                                                                                
1.  A program segment prefix is built following the resident portion            
    of the program that is performing the load operation.                       
                                                                                
2.  The formatted part of the header is read in memory (it's size is            
    at offset 08-09).                                                           
                                                                                
3.  The load module size is determined by subtracting the header size           
more - return to continue, Q to quit                                            
    from the file size.  Offsets 04-05 and 08-09 can be used for this           
    calculation.  The actual size is downward adjusted based on the             
    contents of offsets 02-03.  Note that all files created by Link             
    programs prior to version 1.10 _always_ placed a value of 4 at that         
    location, regardless of actual program size.  Therefore, we recommend       
    that this field be ignored if it contains a value of 4.  Based on the       
    setting of the high/low loader switch, an appropriate segment is            
    determined at which to load the load module.  This segment is called        
    the _start_segment_.                                                        
                                                                                
4.  The load module is read into memory beginning at the start                  
    segment.  Note: The relocation table is an unordered list of                
    relocation items.  The first relocation item is the one that has the        
    lowest offset in the file.                                                  
                                                                                
5.  The relocation items are read into a work area (one of morat a              
    time).                                                                      
                                                                                
6.  Each relocation table item segment value is added to the start              
    segment value.  This calculated segment, in conjunction with the            
    relocation item offset value, points to a word in the load module           
    to which is added the start segment value.  The result is placed back       
    into the word in the load module.                                           
                                                                                
7.  Once all relocation items have been processed, the SS and SP                
    registers are set from the values in the header and the start segment       
    value is added to SS.  The ES and DS registers are set to the segment       
    address of the program segment prefix.  The start segment value is          
    added to the header CS register value.  The result, along with the          
    header IP value, is used to give the module control.                        
                                                                                
-- cut here --                                                                  
                                                                                
I'd have just given the location in the book, but I assume that not             
everyoneants to pay the ghastly amount that IBM charges for that                
tech manual.  Anyway, that's what the book has to say about EXE files.          
Good luck with whatever you're making, and happy hacking.                       
                                                                                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
          Jim Frost * The Madd Hacker | UUCP: ..!harvard!bu-cs!bucsb!madd       
  H H                                 | ARPA:         madd@bucsb.bu.edu         
H-C-C-OH <- heehee          +---------+----------------------------------       
  H H                       | "We are strangers in a world we never made"       
                                                                                
The above was an excerpt of UUCP Netnews, from E-mag, (713)561-0400.            
