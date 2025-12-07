
          Current MSDOS 1.xx - 2.xx Disk formats T. Jennings 19 Aug 83
(8" formats updated 17 Aug)

          Disk Type                     Type Code
     .......................................................
     Single Density Single Sided 8"     (SD128)
     FIDO's 8" Double Density           (DD1K)
     Double Density Double Sided 8"     (DD1024-2)
     IBM Displaywriter System disk      (SD256)
     IBM Displaywriter System disk      (DD256-2)
     IBM PC 8 Sector Single Sided       (IBM8)
     IBM PC 9 Sector Single Sided       (IBM9)
     IBM PC 8 Sector Double Sided       (IBM8-2)
     IBM PC 9 Sector Double Sided       (IBM9-2)
     Single Density Double Sided 8"     (SD128-2)



     Type      Dir  Disk      Fats Blk  Res  Sec       FAT
     Code      Size Size           size secs size      ID
     .....................................................
     SD128      68   251K     2     512  1    128      FE
     DD1K      192   660K     2    1024  1   1024      FE
     DD1024-2  192  1232K     2    1024  1   1024      FE
     SD256      80   287K     2     512  2    256      FA  Note 1
     DD256-2   172  1001K     2    1024  2    256      FB  Note 2
     IBM8       64   162K     2     512  1    512      FE
     IBM9       64   180K     2     512  1    512      FC
     IBM8-2    112   320K     2    1024  1    512      FF
     IBM9-2    112   360K     2    1024  1    512      FD
     SD128-2    68            2     512  4    128      FC

	Absolute sectors below are sector numbers relative to the
start of the disk; sector 0 is track 0 sector 1 (the first sector).

                                           |-> Absolute Sectors
     Type      trks secs res  sec  FAT  dir  1st  2nd  1st  1st  totl num.
     Code           trk  secs size size size FAT  FAT  dir  data secs heads
     ......................................................................
     SD128     77   26    1    128   6  17    1    7   13   30   2002  1
     DD1024-2  77    8    1   1024   2   6    1    3    5   11   1232  2
     SD256     77   15   17    256   4  10    2    6   10   20   1155  1 Note 1
     DD256-2   77   26   54    256   6  20    2    8   14   34   4004  2 Note 2
     IBM8      40    8    1    512   1   4    1    2    3    7    320  1
     IBM9      40    9    1    512   2   4    1    3    5    9    360  1
     IBM8-2    40    8    1    512   1   7    1    3    5   10    640  2
     IBM9-2    40    9    1    512   2   7    1    3    5   12    720  2
     SD128-2   77    26   4    128  12  17    4   16   28   45   4004  2



Note 1:
     15 sector bias in BIOS

Note 2:
     52 sector bias in BIOS
