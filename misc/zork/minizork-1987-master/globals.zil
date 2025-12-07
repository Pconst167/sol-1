"GLOBALS for
			     Mini-Zork '87
	  (c) Copyright 1987 Infocom, Inc. All Rights Reserved"

<DIRECTIONS NORTH EAST WEST SOUTH NE NW SE SW UP DOWN IN OUT LAND>

<OBJECT GLOBAL-OBJECTS
        (FLAGS RMUNGBIT INVISIBLE TOUCHBIT SURFACEBIT TRYTAKEBIT OPENBIT
	       SEARCHBIT TRANSBIT ONBIT RLANDBIT)>

<OBJECT LOCAL-GLOBALS
	(IN GLOBAL-OBJECTS)
	(DESC "it")>

<OBJECT ROOMS
	(IN TO ROOMS)>

<OBJECT PSEUDO-OBJECT
	(IN LOCAL-GLOBALS)
	(DESC "pseudo")
	(ACTION ME-F)>

<OBJECT IT
	(IN GLOBAL-OBJECTS)
	(SYNONYM IT THEM HER HIM)
	(DESC "thing")
	(FLAGS NDESCBIT TOUCHBIT)>

<OBJECT INTNUM
	(IN GLOBAL-OBJECTS)
	(FLAGS TOOLBIT)
	(SYNONYM INTNUM)
	(DESC "number")>

<OBJECT NOT-HERE-OBJECT
	(DESC "thing")
	(ACTION NOT-HERE-OBJECT-F)>

<ROUTINE NOT-HERE-OBJECT-F ("AUX" TBL (PRSO? T) OBJ)
	 <COND (<AND <EQUAL? ,PRSO ,NOT-HERE-OBJECT>
		     <EQUAL? ,PRSI ,NOT-HERE-OBJECT>>
		<TELL "Those things aren't here!" CR>
		<RTRUE>)
	       (<EQUAL? ,PRSO ,NOT-HERE-OBJECT>
		<SET TBL ,P-PRSO>)
	       (T
		<SET TBL ,P-PRSI>
		<SET PRSO? <>>)>
	 <SETG P-CONT <>>
	 <SETG QUOTE-FLAG <>>
	 <COND (<EQUAL? ,WINNER ,ADVENTURER>
		<TELL ,YOU-CANT "see any ">
		<NOT-HERE-PRINT .PRSO?>
		<TELL " here!" CR>)
	       (T
		<TELL "The " D ,WINNER " seems confused. \"I don't see any ">
		<NOT-HERE-PRINT .PRSO?>
		<TELL " here!\"" CR>)>
	 <RTRUE>>

<ROUTINE NOT-HERE-PRINT (PRSO?)
      <COND (,P-OFLAG
	     <COND (,P-XADJ
		    <PRINTB ,P-XADJN>)>
	     <COND (,P-XNAM
		    <PRINTB ,P-XNAM>)>)
	    (.PRSO?
	     <BUFFER-PRINT <GET ,P-ITBL ,P-NC1> <GET ,P-ITBL ,P-NC1L> <>>)
	    (T
	     <BUFFER-PRINT <GET ,P-ITBL ,P-NC2> <GET ,P-ITBL ,P-NC2L> <>>)>>

<OBJECT GLOBAL-WATER
	(IN LOCAL-GLOBALS)
	(DESC "water")
	(SYNONYM WATER)
	(FLAGS DRINKBIT)
	(ACTION WATER-F)>

<OBJECT WALL
	(IN GLOBAL-OBJECTS)
	(DESC "wall")
	(SYNONYM WALL WALLS)>

<OBJECT STAIRS
	(IN LOCAL-GLOBALS)
	(DESC "stairway")
	(SYNONYM STAIR STEPS STAIRCASE STAIRWAY)
	(ADJECTIVE STONE DARK FORBIDDING)
	(FLAGS NDESCBIT CLIMBBIT)
	(ACTION STAIRS-F)>

<ROUTINE STAIRS-F ()
	 <COND (<VERB? THROUGH>
		<TELL "Up? Down?" CR>)>>

<OBJECT SAILOR
	(IN GLOBAL-OBJECTS)
	(DESC "sailor")
	(SYNONYM SAILOR)
	(FLAGS NDESCBIT)
	(ACTION SAILOR-F)>

<GLOBAL HS 0> ;"counts occurences of HELLO, SAILOR"

<ROUTINE SAILOR-F ()
	  <COND (<VERB? TELL>
		 <SETG P-CONT <>>
		 <SETG QUOTE-FLAG <>>
		 <TELL ,YOU-CANT "talk to the sailor that way." CR>)
		(<VERB? EXAMINE>
  		 <TELL "There is no sailor to be seen." CR>)
		(<VERB? HELLO>
		 <SETG HS <+ ,HS 1>>
		 <COND (<0? <MOD ,HS 12>>
			<TELL "You seem to be repeating yourself." CR>)
		       (T
			<TELL "Nothing happens here." CR>)>)>>

<OBJECT GROUND
	(IN GLOBAL-OBJECTS)
	(DESC "ground")
	(SYNONYM GROUND SAND DIRT FLOOR)
	(ACTION GROUND-F)>

<ROUTINE GROUND-F ()
	 <COND (<AND <VERB? PUT PUT-ON>
		     <EQUAL? ,PRSI ,GROUND>>
		<PERFORM ,V?DROP ,PRSO>
		<RTRUE>)
	       (<EQUAL? ,HERE ,SANDY-CAVE>
		<SAND-F>)
	       (<VERB? DIG>
		<TELL "The ground is too ">
		<COND (<EQUAL? ,HERE ,RESERVOIR>
		       <TELL "muddy">)
		      (T
		       <TELL "hard">)>
		<TELL " here." CR>)>>

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
"One is probably lurking in the dark nearby. Don't let your light
go out!" CR>)>>

<OBJECT LUNGS
	(IN GLOBAL-OBJECTS)
	(DESC "blast of air")
	(SYNONYM LUNGS AIR MOUTH BREATH)
	(FLAGS NDESCBIT)>

<OBJECT ME
	(IN GLOBAL-OBJECTS)
	(DESC "brave adventurer")
	(SYNONYM ME MYSELF SELF ADVENTURER)
	(ADJECTIVE BRAVE)
	(FLAGS ACTORBIT)
	(ACTION ME-F)>

<ROUTINE ME-F ()
	 <COND (<VERB? TELL>
		<SETG P-CONT <>>
		<SETG QUOTE-FLAG <>>
	        <TELL ,MENTAL-COLLAPSE>)
	       (<AND <VERB? GIVE>
		     <EQUAL? ,PRSI ,ME>>
		<PERFORM ,V?TAKE ,PRSO>
		<RTRUE>)
	       (<VERB? EAT>
		<TELL "Auto-cannibalism is not the answer." CR>)
	       (<AND <VERB? ATTACK MUNG>
		     <PRSO? ,ME>>
		<JIGS-UP "Poof, you're dead!">)
	       (<VERB? TAKE>
		<TELL "How romantic!" CR>)
	       (<VERB? EXAMINE>
		<COND (<EQUAL? ,HERE ,MIRROR-ROOM-NORTH ,MIRROR-ROOM-SOUTH>
		       <TELL "Your image in the mirror looks tired." CR>)
		      (T
		       <TELL "Are your eyes prehensile?" CR>)>)>>

<OBJECT ADVENTURER
	(DESC "you")
	(SYNONYM ADVENTURER)
	(FLAGS NDESCBIT INVISIBLE SACREDBIT ACTORBIT)
	(STRENGTH 6)
	(ACTION 0)>

<OBJECT PATH-OBJECT
	(IN GLOBAL-OBJECTS)
	(DESC "passage")
	(SYNONYM TRAIL PATH PASSAGE TUNNEL)
        (ADJECTIVE FOREST NARROW LONG WINDING)
	(FLAGS NDESCBIT)
	(ACTION PATH-OBJECT-F)>

<ROUTINE PATH-OBJECT-F ()
	 <COND (<VERB? TAKE FOLLOW>
		<V-WALK-AROUND>)
	       (<VERB? DIG>
		<TELL "Not a chance." CR>)>>

<OBJECT HANDS
	(IN GLOBAL-OBJECTS)
	(DESC "pair of hands")
	(SYNONYM PAIR HANDS HAND)
	(ADJECTIVE BARE)
	(FLAGS NDESCBIT TOOLBIT)>
\
;"stuff that belongs in more than one geographical area"

<ROUTINE MIRROR-ROOM-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
	        <TELL "You are in a square room with tall ceilings. A ">
		<COND (<EQUAL? ,MIRROR-MUNG ,HERE ,MIRROR>
		       <TELL "demolished">)
		      (T
		       <TELL "huge">)>
		<TELL
" mirror fills the south wall. There are exits east and northeast.">)>>

<OBJECT MIRROR
	(IN LOCAL-GLOBALS)
	(DESC "mirror")
	(SYNONYM REFLECTION MIRROR)
	(FLAGS TRYTAKEBIT NDESCBIT)
	(ACTION MIRROR-F)>

<GLOBAL MIRROR-MUNG <>> ;"if both mirrors are broken, SETG this to MIRROR"

<GLOBAL LUCKY T>

<ROUTINE MIRROR-F ("AUX" OTHER-ROOM)
	<COND (<AND <VERB? RUB>
		    <NOT ,MIRROR-MUNG>>
	       <COND (<EQUAL? ,HERE ,MIRROR-ROOM-NORTH>
		      <SET OTHER-ROOM ,MIRROR-ROOM-SOUTH>)
		     (T
		      <SET OTHER-ROOM ,MIRROR-ROOM-NORTH>)>
	       <ROB ,HERE ,MIRROR <>>
	       <ROB .OTHER-ROOM ,HERE <>>
	       <ROB ,MIRROR .OTHER-ROOM <>>
	       <GOTO .OTHER-ROOM <>>
	       <TELL "There is a rumble from deep within the earth." CR>)
	      (<VERB? LOOK-INSIDE EXAMINE>
	       <COND (<EQUAL? ,MIRROR-MUNG ,HERE ,MIRROR>
		      <TELL "The mirror is shattered.">)
		     (T
		      <TELL "An ugly person stares back at you.">)>
	       <CRLF>)
	      (<VERB? TAKE>
	       <FASTENED ,MIRROR "wall">)
	      (<VERB? MUNG THROW ATTACK>
	       <COND (<EQUAL? ,MIRROR-MUNG ,HERE ,MIRROR>
		      <TELL "You've done enough damage already." CR>)
		     (T
		      <COND (,MIRROR-MUNG ;"you've already broken the other"
			     <SETG MIRROR-MUNG ,MIRROR>)
			    (T
			     <SETG MIRROR-MUNG ,HERE>)>
		      <SETG LUCKY <>>
		      <TELL
"The mirror breaks. I hope you have a seven year supply of good luck
handy." CR>)>)>>

<OBJECT CHIMNEY
	(IN LOCAL-GLOBALS)
	(DESC "chimney")
	(SYNONYM CHIMNEY)
	(ADJECTIVE DARK NARROW)
	(FLAGS CLIMBBIT NDESCBIT)
	(ACTION CHIMNEY-F)>

<ROUTINE CHIMNEY-F ()
	 <COND (<VERB? EXAMINE>
		<TELL "The chimney leads ">
		<COND (<EQUAL? ,HERE ,KITCHEN>
		       <TELL "down">)
		      (T
		       <TELL "up, and looks climbable">)>
		<TELL ,PERIOD-CR>)>>
\
;"utility routines and shared stuff"

<ROUTINE LIGHT-INT (OBJ TBL TICK)
	 <COND (<0? .TICK>
		<FCLEAR .OBJ ,ONBIT>
		<FSET .OBJ ,RMUNGBIT>)>
	 <COND (<OR <HELD? .OBJ>
		    <IN? .OBJ ,HERE>>
		<COND (<0? .TICK>
		       <TELL "The " D .OBJ " fizzles and dies." CR>
		       <NOW-DARK?>)
		      (T
		       <TELL <GET .TBL 1> CR>)>)>>

<ROUTINE GLOBAL-IN? (OBJ "AUX" TX)
	 <COND (<SET TX <GETPT ,HERE ,P?GLOBAL>>
		<ZMEMQB .OBJ .TX <- <PTSIZE .TX> 1>>)>> 

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

<ROUTINE ACCESSIBLE? (OBJ "AUX" (L <LOC .OBJ>))
	 <COND (<FSET? .OBJ ,INVISIBLE>
		<RFALSE>)
	       (<NOT .L>
		<RFALSE>)
	       (<EQUAL? .L ,GLOBAL-OBJECTS>
		<RTRUE>)
	       (<AND <EQUAL? .L ,LOCAL-GLOBALS>
		     <GLOBAL-IN? .OBJ>>
		<RTRUE>)
	       (<NOT <EQUAL? <META-LOC .OBJ> ,HERE <LOC ,WINNER>>>
		<RFALSE>)
	       (<EQUAL? .L ,WINNER ,HERE <LOC ,WINNER>>
		<RTRUE>)
	       (<AND <FSET? .L ,OPENBIT>
		     <ACCESSIBLE? .L>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE META-LOC (OBJ)
	 <REPEAT ()
		 <COND (<NOT .OBJ>
			<RFALSE>)
		       (<IN? .OBJ ,GLOBAL-OBJECTS>
			<RETURN ,GLOBAL-OBJECTS>)>
		 <COND (<IN? .OBJ ,ROOMS>
			<RETURN .OBJ>)
		       (T
			<SET OBJ <LOC .OBJ>>)>>>

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

<ROUTINE REMOVE-CAREFULLY (OBJ)
	 <COND (<EQUAL? .OBJ ,P-IT-OBJECT>
		<SETG P-IT-OBJECT <>>)>
	 <REMOVE .OBJ>
	 <NOW-DARK?>>

<ROUTINE NOW-DARK? ()
	 <COND (<AND ,LIT
		     <NOT <LIT? ,HERE>>>
		<SETG LIT <>>
		<TELL "It is now pitch black." CR>)>
	 <RTRUE>>

<ROUTINE STUPID-CONTAINER (OBJ STR)
	 <COND (<VERB? CLOSE>
		<TELL "It is!" CR>)
	       (<VERB? LOOK-INSIDE EXAMINE OPEN>
		<TELL "Lots of " .STR ,PERIOD-CR>)
	       (<AND <VERB? PUT>
		     <EQUAL? ,PRSI .OBJ>>
		<TELL "Then it wouldn't be a " D .OBJ " anymore!" CR>)>>

<ROUTINE PEEK-UNDER (OBJ1 OBJ2)
	 <TELL
"Underneath the " D .OBJ1 " is a " D .OBJ2 ". As you release the " D .OBJ1
", the " D .OBJ2 " is once again concealed from view." CR>>

<ROUTINE FASTENED (OBJ STRING)
	 <TELL
"The " D .OBJ " is securely fastened to the " .STRING ,PERIOD-CR>>

<ROUTINE OPEN-CLOSE (OBJ STROPN STRCLS)
	 <COND (<VERB? OPEN>
		<COND (<FSET? .OBJ ,OPENBIT>
		       <TELL ,LOOK-AROUND>)
		      (T
		       <FSET .OBJ ,OPENBIT>
		       <TELL .STROPN CR>)>)
	       (<VERB? CLOSE>
		<COND (<FSET? .OBJ ,OPENBIT>
		       <FCLEAR .OBJ ,OPENBIT>
		       <TELL .STRCLS CR>)
		      (T
		       <TELL ,LOOK-AROUND>)>)>>

<ROUTINE HACK-HACK (STR)
	 <TELL .STR D ,PRSO <PICK-ONE ,HO-HUM> ,PERIOD-CR>>

<GLOBAL HO-HUM
	<LTABLE
	 0
	 " doesn't seem to work"
	 " isn't notably helpful"
	 " has no effect">>

<GLOBAL YUKS
	<LTABLE
	 0
	 "A valiant attempt."
	 "You can't be serious."
	 "Not bloody likely."
	 "What a concept!">>

<GLOBAL PERIOD-CR ".|">

<GLOBAL LOOK-AROUND "Look around you.|">

<GLOBAL FORMERLY-A-LAKE
"what was formerly a lake. However, with the water level lowered, there is
merely a shallow stream, easily">

<GLOBAL MENTAL-COLLAPSE
"Talking to yourself is said to be a sign of impending mental collapse.|">

<GLOBAL CANT-GO "You can't go that way.|">

<GLOBAL REFERRING "It's not clear what you're referring to.|">

<GLOBAL NOTHING-TO-FILL-WITH "There is nothing to fill it with.|">

<GLOBAL GOOD-TRICK "That would be a good trick.|">

<GLOBAL TOO-DARK "It's too dark to see.|">

<GLOBAL GUE-NAME "The Great Underground Empire">

<GLOBAL INTEGRAL-PART "It is an integral part of the control panel.|">

<GLOBAL PERFORM-CEREMONY "You must perform the ceremony.|">

<GLOBAL FAILED "Failed.|">

<GLOBAL THIEF-LEFT-DISGUSTED
"Finding nothing of value, the thief left, looking disgusted.|">

<GLOBAL YOU-CANT "You can't ">

<GLOBAL YNH "You're not holding ">

<GLOBAL THERES-NOTHING "There is nothing ">

<GLOBAL CANDLES-ARE "The candles are ">

<GLOBAL ALREADY "You already did that!|">

<GLOBAL WATER-EVAPORATES
"The water spills to the floor and evaporates immediately.|">

<GLOBAL BEG-PARDON "[I beg your pardon?]|">

<GLOBAL NOTHING-HAPPENS "Nothing happens.|">

<GLOBAL NOUN-MISSING "[There seems to be a noun missing in that sentence!]|">

<GLOBAL CYCLOPS-IS "The cyclops is">

<GLOBAL DISK-BASED " in the larger, disk-based version of Zork I.|">