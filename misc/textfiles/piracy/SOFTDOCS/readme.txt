
Cheat for The Elder Scrolls: Arena
----------------------------------

This file will instruct you how to modify one 
of your Arena save files to get a lot of money 
and to raise your statistics.

To accomplish this you need a sector editor or you can 
compile the C programs included.

The file to modify is saveengn.0x   where x is the number 
of the savefile.                -         -

To get 64000+ gold pieces: 
--------------------------

change offset 041F: from XX to CC.  XX is anything.
                         --                         

To raise your stats.
--------------------

We are going to trick to game into thinking you are
a 1st level. Your experience will be unchanged however.
The game will notice that your experience is more 
than needed to gain one or more levels. Your will then
be ask to distribute the bonus points you usually get
when you gain a level. The higher your level the more
Bonus points you'll get. You may have to kill something 
before the game notice your new level.

DO NOT SET ALL YOUR STATS TO 100.
--------------------------------

If you do so, when you gain your next level the
game will wait for you to distribute your bonus points
and you won't be able to put them anywhere.

You may have to kill something before the game notice
your new level.

change offset 0006: from XX to 81.
                         -- 
You may have to apply this trick a few time depending 
on the level of your character and your own greed level.
I was using it on a 7th level mage a got about 27 bonus
points every time So i suggest your compile the following
routines to do the job for you.

Here is the C code for the stats cheat.
---------------------------------------

#include <stdio.h>

main(int argc,char** argv){
FILE *handle;
int data=135;
handle=fopen("saveengn.0X","r+b");/* replace the X with the game number*/
fseek(handle,6,0);
fwrite(&data,1,1,handle);
fclose(handle);
}


Here is the C code for the money cheat.
---------------------------------------
#include <stdio.h>

main(int argc,char** argv){
FILE *handle;
int data=204;
handle=fopen("saveengn.0X","r+b"); /* replace the X with the game number*/
fseek(handle,0x041F,0);
fwrite(&data,1,1,handle);
fclose(handle);
}

You do not need to read the following but I include this because i will
not look any further and I would appreciate if someone were to improve
on my simple scheme.
 
I was checking the modifications to the savefiles when
you gain a level using

fc /b saveengn.00 saveengn.01

I'm sure offset 0038 is for luck: set it at E3 to have 100

The save file is encrypted somhow you may test for different values.

The others stats are located between offset 0029 and 0068.
You will have a better chance if you look at offset:0031-0038

You may try different values but it's really a gamble.

I word of caution I'm new to arena. I bought the game two days ago.
so make a copy of your saveengn.0x file before using my tips.
Please report any problems to gladue@jsp.umontreal.ca

Eric Gladu
02/06/94


P.S. In this archive the exe files will only change the saveengn.00 file
