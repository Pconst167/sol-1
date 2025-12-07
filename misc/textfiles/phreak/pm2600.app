

                  -Another article from Sir Briggs of SCDW-

         Hey all you phreakers!  Bet you didn't know about this!  It's...



                         The Poor Man's 2600 Hertz!!



What the hell could I be talking about!?!?  Well, let's say you're really hard

up (not in your usual sense, this time).  You really need to make 2600 Hertz

so you can have lotsa phun on the trunk lines, right?  But your mom and dad

didn't give you a blue box for Christmas- just an Apple!  And of course you

don't have a nice precision music card (like mine) or an Apple Cat.  So what

the hell can you do?  Well, you're not out of it yet.  You, too, can make 2600

Hertz!  Yes, that's right!  With   NO   additional hardware!  Try and beat

that with a stick (or your fist even for that matter).  And I bet you've even

figured out that I'm about to tell you just how to do this.  Well, you're

right!  EVERYBODY KNOWS... that at $FCA8, there's a little routine called 

"WAIT".  We are going to use that to produce the needed delay in the 

production of our tone.  Yes, you will have to use a little machine language.

But I'm going to show you exactly what to type here.  So even you, yes YOU

Poindexter, can get this right!  Here's all you do...



If you have an Apple //e with the enhancement installed, just type CALL-151 

from BASIC and get into the monitor.  From there, hit a "!" to use the mini-

assembler.  Enter this exactly as it appears...



!1000: LDX $C030

! LDA #$06

! JSR $FCA8

! JMP $1000



And there you have it!  Hit <RET> to get back to the monitor.  Then, type 

"1000G" and listen to that beautiful tone!  Not EXACTLY 2600 Hz, but close

enough to do the trick!



For you non-enhanced types, you can just load up INTEGER BASIC (Ha!) and type

"F666G" from the monitor and use the mini-assembler there.  After typing the

above code in, type "$FF69G" to return to the monitor, and proceed as above.

You would do that on a ][+, too (people still use those!?).



In all cases, just hit RESET to shut the thing up!  Use it as you will.  In 

case you didn't know, you can use that tone to reset SPRINT, MCI, etc. nodes

to there dial tone.  That way, you don't have to keep punching in your local

number first.  Just type the code and go!  Pretty nice.  Well, you can learn

what to do from all the philes around about blue boxing.  2600 Hz doesn't

work on 800 numbers here anymore.  SHIT!  What's going on?  ESS?  Well, if you

live in ESS, don't try this!  They'll snag your little butt fer sher!  Then 

it's off to reform school for you!  Well, have phun!  And remember...



I didn't tell you this!



     Sir Briggs of the SouthCentral Discount Waremeisters of Texas A & M



We brought you:



     AE: TAC 1.1

     Scream--> The Ultimate Telephone Terrorizer

     Duo-Disk Modz



Be on the lookout for Scream 2.0, The ALF Box (for those with ALF Music 

Synthesizer Cards), a one-pass copier for Apple Extended Memory Cards,



                       and MUCH, MUCH MORE!



  BYE!            



