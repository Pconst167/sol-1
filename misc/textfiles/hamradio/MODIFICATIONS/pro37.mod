Newsgroups: rec.radio.shortwave
From: mb@sparrms.ists.ca (Mike Bell)
Subject: PRO-37 Scanner Modifications (Long)
Date: Tue, 24 Sep 91 13:32:11 GMT

MODIFICATIONS FOR THE PRO-37
----------------------------

The disassembly instructions are based on the excellent PRO-34 instructions
provided by Chris Scholefield (chriss@mid.com). I have added my own 
comments.

First of all, what modifications are possible?
----------------------------------------------

The PRO-37 uses a diode array to	l tell its microprocessor what model it
is, and thus which frequency bands to allow and what channel spacing to
use. European and Australian models have full 800 MHz coverage (at an 
unknown channel spacing) and a VHF-Mid band (68-88 MHz) rather than a
VHF-Low band (30-54 MHz). 

The Canadian and US models differ in the amount of care taken to reduce
EMI. The Canadian model has additional screening, and one or two other
minor component additions to achieve this. Therefore, if you have the choice,
the Canadian model is preferable to the US model. 

Changing from VHF-Low to VHF-Mid band coverage requires many
component value changes (and realignment of the appropriate RF stage). 
Given that the PRO-37 uses SMT technology, it's not worth trying. 
(You can change the diode array easily enough, but just don't
expect reasonable performance!)

The only sensible (straightforward) modification is the restoration of
full 800 MHz coverage on Canadian and US models. The ranges restored
appear with a 30kHz channel spacing - which just happens to coincide
with the N. American cellular telephone channel spacing. A remarkable
coincidence.

The modification described is therefore applicable ONLY to Canadian and
US models. (European and Australian readers could always remove
800 MHz coverage if they wished:-).

You will need:

	Soldering iron 		- with a fine point. (The components desoldered
				  and soldered are not SMT, but ....)
	Desoldering tool	- to remove excess solder
	Philips screwdriver	- if it fits the screws on the back of the
				  case it's the right size.
	Small pliers		- bending component leads while unsoldering
				  and removing hexagonal posts
	Earthing  wrist strap	- strongly advisable with CMOS components.
				  (Static can cause premature, if not immediate
				  failure of components). Wear this at all
				  times.
	Small screwdriver	- for prying components etc.

	Experience and confidence in working with modern electronics

	A couple of hours without interruptions...


Instructions
------------

0. READ THROUGH ALL OF THESE INSTRUCTIONS BEFORE STARTING!

1. Remove the battery

2. Remove the antenna

3. Pull to remove squelch and volume knobs

4. Unscrew the 4 screw on the back of the case

5. Separate the case beginning at the battery end and work over the circuit
   board and knobs at the top

6. Unsolder both connections to the antenna - ground can be bent away and the
   centre has a link to the board

7. Unsolder the two power switch links at the board end

8. Unsolder the ground connections to the metal shield

9. Disconnect the two connectors to the squelch and volume controls

10.Remove 4 hexagonal posts

11.The top board may now be removed by separating it gently from the 
   connector on the adjacent board

12.Remove 3 screws holding the shield in place

13.Lift the shield to separate it from the lower control circuit board

14.Identify diodes D12,D13 on the control board

15.EITHER cut the diode D13 and SKIP to reassembly OR continue to desolder diode

16.Remove last two screws and remove control board. Take care not to
   dislocate the KEY LOCK switch when doing this.

17.Unsolder screening from side of control board near diode array,
   and bend back out of way.

18.Unsolder and remove diode D13. Keep it somewhere so that you can replace
   it if required to do so by US legislation. 

Reassembly is the reverse of the above procedure.

If you performed steps 16-18 CHECK REALLY CAREFULLY that the metal part of
the KEY LOCK switch is in the right location. (Otherwise, you may find 
yourself having to disassemble the whole thing again - I know, I did!)

NOTES.

1.  One must exercise great caution in the procedure.  Check that no flakes
    of solder get dropped on the boards.  Take anti-static
    precautions by doing the work on a mat and wearing a wrist strap.  Do
    not make any adjustments to the upper analogue board or bend any of the 
    other wire links on it, which are tuned circuits.
    
2.  Another caution is that doing any of the work will probably violate 
    any warranty you may have on the scanner. Might be worth burning the
    scanner in for ~150 hrs before attempting this to reduce the risk of 
    a latent component fault appearing after you have made the modification.

3.  YOU PERFORM THE ABOVE PROCEDURE ENTIRELY AT YOUR OWN RISK. You may
    wish to obtain a copy of the PRO-37 Service Manual from Radio Shack
    before attempting this. (Cost about $20 - well written - just wish
    I could afford all the service gear required!)

4.  If you happen to find out what adding D14 does (another difference 
    between N. American and European/Australian versions), I'd be 
    interested to know. It's not mentioned in the service manual. I think
    it could affect 800 MHz channel spacing - any info on the European
    Australian PRO-37 specs in this area would be appreciated.

5.  If you found something wrong in the above instructions, let me know
    and I will try and post an update.

6.  If you found all this helpful, help someone else and donate $5.00 
    *today* to your favourite charity. 

Share and Enjoy!

-- Mike -- <mb@sparrms.ists.cao