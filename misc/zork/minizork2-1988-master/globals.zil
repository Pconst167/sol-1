"GLOBALS for
	        Mini-Zork II: The Wizard of Frobozz
	(c) Copyright 1988 Infocom, Inc.  All Rights Reserved."

<DIRECTIONS NORTH EAST WEST SOUTH NE NW SE SW UP DOWN IN OUT LAND>

<OBJECT GLOBAL-OBJECTS
	(FLAGS INVISIBLE TOUCHBIT SURFACEBIT TRYTAKEBIT
	       OPENBIT SEARCHBIT TRANSBIT ONBIT RLANDBIT)>

<OBJECT LOCAL-GLOBALS
	(IN GLOBAL-OBJECTS)
	(SYNONYM ZZMGCK) ;"Yes, this synonym needs to exist... sigh">

<OBJECT ROOMS
	(IN TO ROOMS)>

<OBJECT INTNUM
	(IN GLOBAL-OBJECTS)
	(DESC "number")
	(SYNONYM INTNUM)
	(FLAGS TOOLBIT)>

<OBJECT PSEUDO-OBJECT
	(IN LOCAL-GLOBALS)
	(DESC "pseudo")
	(ACTION ME-F)>

<OBJECT IT
	(IN GLOBAL-OBJECTS)
	(SYNONYM IT THEM HER HIM)
	(DESC "thing")
	(FLAGS NDESCBIT TOUCHBIT)>

<OBJECT NOT-HERE-OBJECT
	(DESC "thing")
	(ACTION NOT-HERE-OBJECT-F)>

<ROUTINE NOT-HERE-OBJECT-F ("AUX" TBL (PRSO? T) OBJ)
	 ;"This COND is game independent (except the TELL)"
	 <COND (<AND <EQUAL? ,PRSO ,NOT-HERE-OBJECT>
		     <EQUAL? ,PRSI ,NOT-HERE-OBJECT>>
		<TELL "Those things aren't here!" CR>
		<RTRUE>)
	       (<EQUAL? ,PRSO ,NOT-HERE-OBJECT>
		<SET TBL ,P-PRSO>)
	       (T
		<SET TBL ,P-PRSI>
		<SET PRSO? <>>)>
	 ;"Here is the default 'cant see any' printer"
	 <SETG P-CONT <>>
	 <SETG QUOTE-FLAG <>>
	 <COND (<EQUAL? ,WINNER ,ADVENTURER>
		<TELL "You can't see any ">
		<NOT-HERE-PRINT .PRSO?>
		<TELL " here!" CR>)
	       (T
		<TELL "The " D ,WINNER " seems confused. \"I don't see any ">
		<NOT-HERE-PRINT .PRSO?>
		<TELL " here!\"" CR>)>
	 <RTRUE>>

;<ROUTINE FIND-NOT-HERE (TBL PRSO? "AUX" M-F OBJ)
	;"Here is where special-case code goes. <MOBY-FIND .TBL> returns
	   number of matches. If 1, then P-MOBY-FOUND is it. One may treat
	   the 0 and >1 cases alike or different. It doesn't matter. Always
	   return RFALSE (not handled) if you have resolved the problem."
	<SET M-F <MOBY-FIND .TBL>>
	;<COND (,DEBUG
	       <TELL "[Moby-found " N .M-F " objects" "]" CR>)>
	<COND (<AND <G? .M-F 1>
		    <SET OBJ <GETP <GET .TBL 1> ,P?GLOBAL>>>
	       <SET M-F 1>
	       <SETG P-MOBY-FOUND .OBJ>)>
	<COND (<==? 1 .M-F>
	       ;<COND (,DEBUG <TELL "[Namely: " D ,P-MOBY-FOUND "]" CR>)>
	       <COND (.PRSO? <SETG PRSO ,P-MOBY-FOUND>)
		     (T <SETG PRSI ,P-MOBY-FOUND>)>
	       <RFALSE>)
	      (<NOT .PRSO?>
	       <TELL "You wouldn't find any ">
	       <NOT-HERE-PRINT .PRSO?>
	       <TELL " there." CR>
	       <RTRUE>)
	      (T ,NOT-HERE-OBJECT)>>

;<ROUTINE GLOBAL-NOT-HERE-PRINT (OBJ)
	 ;<COND (,P-MULT <SETG P-NOT-HERE <+ ,P-NOT-HERE 1>>)>
	 <SETG P-CONT <>>
	 <SETG QUOTE-FLAG <>>
	 <TELL "You can't see any">
	 <COND (<EQUAL? .OBJ ,PRSO> <PRSO-PRINT>)
	       (T <PRSI-PRINT>)>
	 <TELL " here." CR>>

<ROUTINE NOT-HERE-PRINT (PRSO?)
 <COND (,P-OFLAG
	<COND (,P-XADJ <PRINTB ,P-XADJN>)>
	<COND (,P-XNAM <PRINTB ,P-XNAM>)>)
       (.PRSO?
	<BUFFER-PRINT <GET ,P-ITBL ,P-NC1> <GET ,P-ITBL ,P-NC1L> <>>)
       (T
	<BUFFER-PRINT <GET ,P-ITBL ,P-NC2> <GET ,P-ITBL ,P-NC2L> <>>)>>

<OBJECT GROUND
	(IN GLOBAL-OBJECTS)
	(DESC "ground")
	(SYNONYM GROUND DIRT FLOOR)
	(ACTION GROUND-F)>

<ROUTINE GROUND-F ()
	 <COND (<AND <VERB? PUT PUT-ON>
		     <EQUAL? ,PRSI ,GROUND>>
		<PERFORM ,V?DROP ,PRSO>
		<RTRUE>)>>

<OBJECT WATER
	(DESC "quantity of water")
	(LDESC "There is some water here.")
	(SYNONYM WATER LIQUID)
	(SIZE 4)
	(FLAGS TAKEBIT DRINKBIT)
	(ACTION WATER-F)>

<OBJECT GLOBAL-WATER
	(IN LOCAL-GLOBALS)
	(DESC "water")
	(SYNONYM WATER)
	(FLAGS DRINKBIT)
	(ACTION WATER-F)>

<ROUTINE WATER-F ("AUX" AV W PI?)
	 <COND (<VERB? SGIVE>
		<RFALSE>)
	       (<VERB? ENTER>
		<PERFORM ,V?SWIM ,PRSO>
		<RTRUE>)
	       (<VERB? FILL>	;"fill bottle with water =>"
		<SET W ,PRSI>	   ;"put water in bottle"
		<SETG PRSA ,V?PUT>
		<SETG PRSI ,PRSO>
		<SETG PRSO .W>
		<SET PI? <>>)
	       (<EQUAL? ,PRSO ,GLOBAL-WATER ,WATER>
		<SET W ,PRSO>
		<SET PI? <>>)
	       (,PRSI
		<SET W ,PRSI>
		<SET PI? T>)>
	 <COND (<EQUAL? .W ,GLOBAL-WATER>
		<SET W ,WATER>
		<COND (<VERB? TAKE PUT> <REMOVE .W>)>)>
	 <COND (.PI? <SETG PRSI .W>)
	       (T <SETG PRSO .W>)>
	 <SET AV <LOC ,WINNER>>
	 <COND (<NOT <FSET? .AV ,VEHBIT>> <SET AV <>>)>
	 <COND (<AND <VERB? TAKE PUT> <NOT .PI?>>
		<COND (<AND .AV <EQUAL? .AV ,PRSI>>
		       <PUDDLE .AV>)
		      (<AND .AV <NOT ,PRSI> <NOT <IN? .W .AV>>>
		       <PUDDLE .AV>)
		      (<AND ,PRSI <NOT <EQUAL? ,PRSI ,TEAPOT>>>
		       <TELL "The water leaks out of the " D ,PRSI
			     " and evaporates immediately." CR>
		       <REMOVE .W>)
		      (<IN? ,TEAPOT ,WINNER>
		       <COND (<NOT <FIRST? ,TEAPOT>>
			      <MOVE ,WATER ,TEAPOT>
			      <TELL "The teapot is now full of water." CR>)
			     (T
			      <TELL "The teapot isn't currently empty." CR>
			      <RTRUE>)>)
		      (<AND <IN? ,PRSO ,TEAPOT>
			    <VERB? TAKE>
			    <NOT ,PRSI>>
		       <SETG PRSO ,TEAPOT>
		       <ITAKE>
		       <SETG PRSO .W>)
		      (T
		       <TELL "The water slips through your fingers." CR>)>)
	       (.PI?
		<TELL "Nice try." CR>)
	       (<VERB? DROP GIVE>
		<COND (<AND <EQUAL? ,PRSO ,WATER>
			    <NOT <HELD? ,WATER>>>
		       <TELL "You don't have any water." CR>
		       <RTRUE>)>
		<REMOVE ,WATER>
		<COND (.AV
		       <PUDDLE .AV>)
		      (T
		       <TELL
"The water spills to the floor and evaporates." CR>
		       <REMOVE ,WATER>)>)
	       (<VERB? THROW>
		<TELL
"The water splashes on the walls and evaporates." CR>
		<REMOVE ,WATER>)>>

<ROUTINE PUDDLE (AV)
	<TELL "There is now a puddle in the bottom of the " D .AV ,PERIOD-CR>
	<MOVE ,PRSO .AV>>

<OBJECT GRUE
	(IN GLOBAL-OBJECTS)
	(DESC "lurking grue")
	(SYNONYM GRUE)
	(ADJECTIVE LURKING)
	(ACTION GRUE-F)>

<ROUTINE GRUE-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"The grue is a sinister, lurking presence in the dark places of the earth.
Its favorite diet is adventurers, but its insatiable appetite is tempered
by its fear of light." CR>)
	       (<VERB? FIND>
		<TELL
"There's probably one lurking in the darkness nearby. Don't let your light
go out!" CR>)>>

<OBJECT ME
	(IN GLOBAL-OBJECTS)
	(DESC "brave adventurer")
	(SYNONYM ME MYSELF SELF)
	(FLAGS ACTORBIT)
	(ACTION ME-F)>

<ROUTINE ME-F () 
	 <COND (<VERB? TELL>
		<SETG P-CONT <>>
		<SETG QUOTE-FLAG <>>
		<TELL
"Talking to yourself is a sign of impending mental collapse." CR>)
	       (<AND <VERB? GIVE>
		     <EQUAL? ,PRSI ,ME>>
		<PERFORM ,V?TAKE ,PRSO>
		<RTRUE>)
	       (<VERB? EAT>
		<TELL "Auto-cannibalism is not the answer." CR>)
	       (<VERB? ATTACK MUNG>
		<JIGS-UP "Poof, you're dead!">)
	       (<VERB? TAKE>
		<TELL "How romantic!" CR>)
	       (<VERB? EXAMINE>
		<TELL "Difficult, unless your eyes are prehensile." CR>)>>

<OBJECT ADVENTURER
	(IN INSIDE-THE-BARROW)
	(DESC "thing")
	(SYNONYM ADVENTURER)
	(STRENGTH 0)
	(FLAGS NDESCBIT INVISIBLE SACREDBIT ACTORBIT)
	(ACTION 0)>

<OBJECT PATH-OBJECT
	(IN GLOBAL-OBJECTS)
	(DESC "passage")
	(SYNONYM PATH PASSAGE TUNNEL)
	(ADJECTIVE DARK DAMP SMOKEY SCORCHED NARROW)
	(FLAGS NDESCBIT)
	(ACTION PATH-OBJECT-F)>

<ROUTINE PATH-OBJECT-F ()
	 <COND (<VERB? TAKE FOLLOW>
		<V-WALK-AROUND>)>>

<OBJECT ZORKMID
	(IN GLOBAL-OBJECTS)
	(DESC "zorkmid")
	(SYNONYM ZORKMID)
	(ACTION ZORKMID-F)>

<ROUTINE ZORKMID-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"The zorkmid is the unit of currency of" ,GUE-NAME ,PERIOD-CR>)>>

<OBJECT HANDS
	(IN GLOBAL-OBJECTS)
	(DESC "pair of hands")
	(SYNONYM PAIR HANDS HAND)
	(ADJECTIVE BARE)
	(FLAGS NDESCBIT TOOLBIT)>

<OBJECT STREAM
	(IN LOCAL-GLOBALS)
	(DESC "stream")
	(SYNONYM STREAM)
	(ADJECTIVE COLD)
	(FLAGS NDESCBIT)
	(ACTION STREAM-F)>

<ROUTINE STREAM-F ()
	 <COND (<VERB? ENTER>
		<V-SWIM>)>>

<OBJECT CHASM
	(IN LOCAL-GLOBALS)
	(DESC "chasm")
	(SYNONYM CHASM RAVINE)
	(ADJECTIVE DEEP)
	(FLAGS NDESCBIT)
	(ACTION CHASM-F)>

<ROUTINE CHASM-F ()
	 <COND (<OR <VERB? LEAP>
		    <AND <VERB? PUT>
			 <EQUAL? ,PRSO ,ME>>>
		<JIGS-UP "You should have looked before you leaped.">)
	       (<AND <VERB? PUT>
		     <EQUAL? ,PRSI ,PSEUDO-OBJECT>>
		<REMOVE ,PRSO>
		<TELL "The " D ,PRSO " disappears into the chasm." CR>)>>

<OBJECT BRIDGE
	(IN LOCAL-GLOBALS)
	(DESC "bridge")
	(SYNONYM BRIDGE)
	(ADJECTIVE STONE)
	(FLAGS NDESCBIT)
	(ACTION BRIDGE-F)>

<ROUTINE BRIDGE-F ()
	 <COND (<VERB? LEAP>
		<JIGS-UP "You should have looked before you leaped.">)>>

<OBJECT WALL
	(IN GLOBAL-OBJECTS)
	(DESC "wall")
	(SYNONYM WALL)
	(ADJECTIVE EAST EASTERN WEST WESTERN SOUTH SOUTHE NORTH NORTHE)>

<ROUTINE OPEN-CLOSE ()
	 <COND (<VERB? OPEN>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <TELL ,LOOK-AROUND>)
		      (T
		       <FSET ,PRSO ,OPENBIT>
		       <TELL "The " D ,PRSO " is now open." CR>)>)
	       (<FSET? ,PRSO ,OPENBIT>
		<FCLEAR ,PRSO ,OPENBIT>
		<TELL "The " D ,PRSO " is now closed." CR>)
	       (T
		<TELL ,LOOK-AROUND>)>>

<ROUTINE HELLO? (WHO)
	 <COND (<OR <EQUAL? ,WINNER .WHO>
		    <VERB? TELL SAY HELLO INCANT>>
		<COND (<VERB? TELL SAY INCANT>
		       <SETG P-CONT <>>
		       <SETG QUOTE-FLAG <>>)>
		<RTRUE>)>>

<ROUTINE FIND-TARGET (TARGET "AUX" P TX L ROOM)
	 <COND (<IN? .TARGET ,HERE> ,HERE)
	       (T
		<SET P 0>
		<REPEAT ()
			<COND (<0? <SET P <NEXTP ,HERE .P>>>
			       <RETURN <>>)
			      (<NOT <L? .P ,LOW-DIRECTION>>
			       <SET TX <GETPT ,HERE .P>>
			       <SET L <PTSIZE .TX>>
			       <COND (<EQUAL? .L ,UEXIT ,CEXIT ,DEXIT>
				      <SET ROOM <GETB .TX 0>>
				      <COND (<IN? .TARGET .ROOM>
					     <RETURN .ROOM>)>)>)>>)>>

<ROUTINE NOW-DARK? ()
	 <SETG LIT <LIT? ,HERE>>
	 <COND (<NOT ,LIT>
		<TELL "It is now pitch black." CR>)>
	 <RTRUE>>

<ROUTINE DO-WALK (DIR)
	 <SETG P-WALK-DIR .DIR>
	 <PERFORM ,V?WALK .DIR>>

<ROUTINE GLOBAL-IN? (OBJ1 OBJ2 "AUX" TX)
	 <COND (<SET TX <GETPT .OBJ2 ,P?GLOBAL>>
		<ZMEMQB .OBJ1 .TX <- <PTSIZE .TX> 1>>)>> 

<ROUTINE FIND-IN (WHERE WHAT "AUX" W)
	 <SET W <FIRST? .WHERE>>
	 <COND (<NOT .W>
		<RFALSE>)>
	 <REPEAT ()
		 <COND (<AND <FSET? .W .WHAT>
			     <NOT <EQUAL? .W ,ADVENTURER>>>
			<RETURN .W>)
		       (<NOT <SET W <NEXT? .W>>>
			<RETURN <>>)>>>

<ROUTINE HELD? (CAN)
	 <REPEAT ()
		 <SET CAN <LOC .CAN>>
		 <COND (<NOT .CAN>
			<RFALSE>)
		       (<EQUAL? .CAN ,WINNER>
			<RTRUE>)>>>

<ROUTINE OTHER-SIDE (DOBJ "AUX" (P 0) TX) ;"finds room beyond given door"
	 <REPEAT ()
		 <COND (<L? <SET P <NEXTP ,HERE .P>> ,LOW-DIRECTION>
			<RETURN <>>)
		       (T
			<SET TX <GETPT ,HERE .P>>
			<COND (<AND <EQUAL? <PTSIZE .TX> ,DEXIT>
				    <EQUAL? <GETB .TX ,DEXITOBJ> .DOBJ>>
			       <RETURN .P>)>)>>>

<ROUTINE HACK-HACK (STR)
	 <TELL .STR D ,PRSO <PICK-ONE ,HO-HUM> CR>>

<GLOBAL HO-HUM
	<LTABLE
	 0
	 " doesn't seem to work."
	 " isn't notably helpful."
	 " has no effect.">>

<GLOBAL YUKS
	<LTABLE
	 0
	 "A valiant attempt."
	 "You can't be serious."
	 "Not bloody likely."
	 "An interesting idea..."
	 "What a concept!">>

<GLOBAL RIDDLE-TEXT
"What's tall as a house,|
  round as a cup,|
    and all the king's horses|
      can't draw it up?\"|">

<GLOBAL PERIOD-CR ".|">

<GLOBAL DEMON-GONE "The demon is gone for a moment. ">

<GLOBAL MOVED-IN-DARK "You feel a rush of air as something moved nearby.|">

<GLOBAL STRANGE-VISION
"As you peer into the sphere, a strange vision takes shape">

<GLOBAL LOOK-AROUND "Look around you.|">

<GLOBAL TOO-DARK "It's too dark to see.">

<GLOBAL ONLY-DARKNESS "You see only darkness.|">

<GLOBAL ALREADY "It already is!|">

<GLOBAL WAND-STOPS-GLOWING
"The wand stops glowing, but there is no other apparent effect.|">

<GLOBAL CANT-GO "You can't go that way.|">

<GLOBAL PLACE-MAT-VISIBLE "The edge of a place mat is visible under the door.">

<GLOBAL DOESNT-FIT-LOCK "It doesn't fit the lock.|">

<GLOBAL GUE-NAME " the Great Underground Empire">

<GLOBAL REFERRING "It's not clear what you're referring to.|">

<GLOBAL STOPS " comes to a stop.||">

<GLOBAL B-W-C "\"Buzz, whirr, click!">

<GLOBAL WAVES-WAND "The Wizard waves his wand ">

<GLOBAL INVISIBLE-HAND
", almost as though an invisible hand had tipped it over.|">

<GLOBAL GREEDILY-DEVOURS "The guardian greedily devours ">