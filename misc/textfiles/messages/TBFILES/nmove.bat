Message-I

 Here is a batch file that move files into a directory and numbering
 the extensions from 000-999. It is a Self-Modifying Batch File so
 there would be no need for an external control file to store the
 extension number.

 -------------NMove.BAT--------------------
 @echo off
 loadbtm on
 if not exist %1 .or. not isdir %2 goto Help
 setlocal
 gosub Init_Ext
 ::-----Auto-cycle from 000-999-000-999...
 for %f in (%1) (
   move %f %2\%@name[%f].%ext
   set ext=%@instr[2,-3,00%@inc[%ext]]
 )
 gosub Save_Ext
 quit

 :Help
  beep
  text

  NMove.BAT v1.0 - Numeric Move - Phi Nguyen 01.12.96

  Usage: NMove filespec destination_directory

  Example: NMove mails.* d:\mail\bwave\dl

  enxtext
  quit 1

 :Save_Ext
  set handle=%@fileopen[%_batchname,append,b]
  if %handle eq -1 (beep %+ echo Can't update extension %+ quit 2)
  set nul=%@fileseek[%handle,-15,2]
  set nul=%@filewriteb[%handle,3,%ext]
  set nul=%@fileclose[%handle]
  return

 :Init_Ext
  set ext=000
  return
 -------------NMove.BAT--------------------

 It requires 4DOS. Since this is a SMBF, it is a good idea not to mess
 around with the Init_Ext routine. Do not remove the leading spaces
 in front of every line.

 Phi

... One lie always leads to another.
-!- GEcho 1.11+
 ! Origin: The Transporter Room: 16 lines, Internet Access 704/567-9513
(1:379/1)

