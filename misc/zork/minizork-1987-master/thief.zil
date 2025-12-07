"THIEF for
			     Mini-Zork '87
	  (c) Copyright 1987 Infocom, Inc. All Rights Reserved"

<OBJECT THIEF
	(IN ROUND-ROOM)
	(DESC "thief")
	(LDESC
"There is a suspicious-looking individual, holding a large bag, leaning
against one wall. He is armed with a deadly stiletto.")
	(SYNONYM THIEF ROBBER MAN PERSON)
	(ADJECTIVE SUSPICIOUS)
	(FLAGS ACTORBIT INVISIBLE CONTBIT SEARCHBIT OPENBIT)
	(STRENGTH 5)
	(ACTION THIEF-F)>

<ROUTINE THIEF-F ()
	 <COND (<VERB? TELL LISTEN>
		<SETG P-CONT <>>
		<TELL "The thief is a strong, silent type." CR>)
	       (<AND <VERB? THROW>
		     <FSET? ,PRSO ,WEAPONBIT>>
		<MOVE ,PRSO ,HERE>
		<TELL
"You missed hitting the thief, but you suceeded in angering him." CR>)
	       (<AND <VERB? THROW GIVE>
		     <EQUAL? ,PRSI ,THIEF>>
		<MOVE ,PRSO ,THIEF>
		<TELL "The thief ">
		<COND (<FSET? ,PRSO ,TREASUREBIT>
		       <TELL
"is taken aback by your unexpected generosity, but ">)>
		<TELL
"puts the " D ,PRSO " in his bag and thanks you politely." CR>)
	       (<VERB? EXAMINE LOOK-INSIDE>
		<TELL
"The thief carries a large bag and a vicious stiletto, whose blade is aimed
menacingly in your direction." CR>)>>

<ROUTINE I-THIEF ("AUX" X (THIEF-LOC <LOC ,THIEF>)
		  ROBJ HERE? (ONCE <>) (FLG <>))
   <PROG ()
     <COND (<SET HERE? <NOT <FSET? ,THIEF ,INVISIBLE>>>
	    <SET THIEF-LOC <LOC ,THIEF>>)>
     <COND
      (<AND <EQUAL? .THIEF-LOC ,THIEFS-LAIR>
	    <NOT <EQUAL? .THIEF-LOC ,HERE>>>
       <DEPOSIT-BOOTY ,THIEFS-LAIR> ;"silent"
       <COND (.HERE?
	      <FSET ,THIEF ,INVISIBLE>
	      <SET X <FIRST? ,THIEFS-LAIR>>
	      <REPEAT ()
		 <COND (<NOT .X>
			<RETURN>)
		       (T
			<FCLEAR .X ,INVISIBLE>)>
		 <SET X <NEXT? .X>>>
	      <SET HERE? <>>)>)
      (<AND <EQUAL? .THIEF-LOC ,HERE>
	    <NOT <FSET? .THIEF-LOC ,ONBIT>>
	    <NOT <IN? ,TROLL ,HERE>>>
       <COND (<THIEF-VS-ADVENTURER .HERE?>
	      <RTRUE>)>
       <COND (<FSET? ,THIEF ,INVISIBLE>
	      <SET HERE? <>>)>)
      (T
       <COND (<AND <IN? ,THIEF .THIEF-LOC>
		   <NOT <FSET? ,THIEF ,INVISIBLE>>> ;"Leave if victim left"
	      <FSET ,THIEF ,INVISIBLE>
	      <SET HERE? <>>)>
       <COND (<FSET? .THIEF-LOC ,TOUCHBIT> ;"Hack the adventurer's belongings"
	      <ROB .THIEF-LOC ,THIEF T>
	      <SET FLG <COND (<AND <FSET? .THIEF-LOC ,MAZEBIT>
				   <FSET? ,HERE ,MAZEBIT>>
			      <ROB-MAZE .THIEF-LOC>)
			     (T
			      <STEAL-JUNK .THIEF-LOC>)>>)>)>
     <COND (<AND <SET ONCE <NOT .ONCE>>
		 <NOT .HERE?>> ;"Move to next room, and hack."
	    <REPEAT ()
		    <COND (<AND .THIEF-LOC
				<SET .THIEF-LOC <NEXT? .THIEF-LOC>>>)
			  (T
			   <SET THIEF-LOC <FIRST? ,ROOMS>>)>
		    <COND (<AND <NOT <FSET? .THIEF-LOC ,SACREDBIT>>
				<FSET? .THIEF-LOC ,RLANDBIT>>
			   <MOVE ,THIEF .THIEF-LOC>
			   <FSET ,THIEF ,INVISIBLE>
			   <SETG THIEF-HERE <>>
			   <RETURN>)>>
	    <AGAIN>)>>
   <COND (<NOT <EQUAL? .THIEF-LOC ,THIEFS-LAIR>>
	  <DROP-JUNK .THIEF-LOC>)>
   .FLG>

<ROUTINE DROP-JUNK (RM "AUX" X N (FLG <>))
	 <SET X <FIRST? ,THIEF>>
	 <REPEAT ()
		 <COND (<NOT .X>
			<RETURN .FLG>)>
		 <SET N <NEXT? .X>>
		 <COND (<AND <NOT <FSET? .X ,TREASUREBIT>>
			     <NOT <EQUAL? .X ,STILETTO ,LARGE-BAG>>
			     <PROB 30 T>>
			<FCLEAR .X ,INVISIBLE>
			<MOVE .X .RM>
			<COND (<AND <NOT .FLG>
				    <EQUAL? .RM ,HERE>>
			       <TELL
"The robber rummages through his bag and drops a few valueless items." CR>
			       <SET FLG T>)>)>
		 <SET X .N>>>

<ROUTINE STEAL-JUNK (RM "AUX" X N)
	 <SET X <FIRST? .RM>>
	 <REPEAT ()
		 <COND (<NOT .X>
			<RFALSE>)>
		 <SET N <NEXT? .X>>
		 <COND (<AND <FSET? .X ,TREASUREBIT>
			     <FSET? .X ,TAKEBIT>
			     <NOT <FSET? .X ,SACREDBIT>>
			     <NOT <FSET? .X ,INVISIBLE>>
			     <PROB 10 T>>
			<MOVE .X ,THIEF>
			<FSET .X ,TOUCHBIT>
			<FSET .X ,INVISIBLE>
			<COND (<EQUAL? .X ,ROPE>
			       <SETG DOME-FLAG <>>)>
			<COND (<EQUAL? .RM ,HERE>
			       <TELL "The " D .X " has vanished!" CR>
			       <RTRUE>)
			      (T
			       <RFALSE>)>)>
		 <SET X .N>>>

<ROUTINE ROB (WHAT WHERE JUST-TREASURES "AUX" N X (ROBBED <>))
	 <SET X <FIRST? .WHAT>>
	 <REPEAT ()
		 <COND (<NOT .X>
			<RETURN>)>
		 <SET N <NEXT? .X>>
		 <COND (<FSET? .X ,INVISIBLE>
			T)
		       (<AND .JUST-TREASURES
			     <OR <FSET? .X ,SACREDBIT>
				 <NOT <FSET? .X ,TREASUREBIT>>>>
			T)
		       (T
			<MOVE .X .WHERE>
			<FSET .X ,TOUCHBIT>
			<SET ROBBED T>
			<COND (<EQUAL? .WHERE ,THIEF>
			       <FSET .X ,INVISIBLE>)>)>
		 <SET X .N>>
	 <RETURN .ROBBED>>

<OBJECT LARGE-BAG
	(IN THIEF)
	(DESC "large bag")
	(SYNONYM BAG)
	(ADJECTIVE LARGE THIEFS)
	(FLAGS TRYTAKEBIT NDESCBIT)
	(ACTION LARGE-BAG-F)>

<ROUTINE LARGE-BAG-F ()
	 <COND (<VERB? TAKE EXAMINE>
		<TELL "It will be taken over the thief's dead body." CR>)
	       (<AND <VERB? PUT>
		     <EQUAL? ,PRSI ,LARGE-BAG>>
		<TELL ,GOOD-TRICK>)
	       (<VERB? OPEN CLOSE LOOK-INSIDE>
		<TELL ,GOOD-TRICK>)>>  

<OBJECT STILETTO
	(IN THIEF)
	(DESC "stiletto")
	(SYNONYM STILETTO)
	(ADJECTIVE VICIOUS)
	(FLAGS NDESCBIT)
	(SIZE 10)>

<GLOBAL THIEF-HERE <>>

"INTERACTION WITH ADVENTURER -- RETURNS T IF THIEF FINISHED."

<ROUTINE THIEF-VS-ADVENTURER (HERE? "AUX" ROBBED? (WINNER-ROBBED? <>))
  <COND (<AND <NOT ,DEAD>
	      <EQUAL? ,HERE ,THIEFS-LAIR>>)
        (<NOT ,THIEF-HERE>
         <COND (<AND <NOT ,DEAD>
		     <NOT .HERE?>
		     <PROB 30>>
		<FCLEAR ,THIEF ,INVISIBLE>
		<SETG THIEF-HERE T>
		<ENABLE <QUEUE I-FIGHT 2>>
		<TELL
"Someone carrying a large bag is casually leaning against the wall. It is
clear that the bag will be taken only over his dead body." CR>
		<RTRUE>)
	       (<AND .HERE?
		     <PROB 30>>
	        <FSET ,THIEF ,INVISIBLE>
		<TELL ,THIEF-LEFT-DISGUSTED>
	        <RTRUE>)
	       (<PROB 70>
		<RFALSE>)
	       (<NOT ,DEAD>
		<COND (<ROB ,HERE ,THIEF T>
		       <SET ROBBED? ,HERE>)
		      (<ROB ,WINNER ,THIEF T>
		       <SET ROBBED? ,ADVENTURER>)>
		<SETG THIEF-HERE T>
	        <COND (<AND .ROBBED?
			    <NOT .HERE?>>
		       <TELL
"A suspicious-looking individual with a large bag just wandered through and
quietly abstracted some valuables from ">
		       <COND (<EQUAL? .ROBBED? ,HERE>
			      <TELL "the room">)
			     (T
			      <TELL "your possession">)>
		       <TELL ,PERIOD-CR>
		       <NOW-DARK?>)
		      (.HERE?
		       <FSET ,THIEF ,INVISIBLE>
		       <SET HERE? <>>
		       <THIEF-ROBBED-AND-LEFT .ROBBED?>
		       <RTRUE>)
		      (T
		       <TELL
"A \"lean and hungry\" gentleman just wandered through, carrying a
large bag. " ,THIEF-LEFT-DISGUSTED>
		       <RTRUE>)>)>)
	(.HERE? ;"Here, already announced."
	 <COND (<PROB 30>
		<COND (<ROB ,HERE ,THIEF T>
		       <SET ROBBED? ,HERE>)
		      (<ROB ,WINNER ,THIEF T>
		       <SET ROBBED? ,ADVENTURER>)>
		<FSET ,THIEF ,INVISIBLE>
		<SET HERE? <>>
		<THIEF-ROBBED-AND-LEFT .ROBBED?>)>)>
       <RFALSE>>

<ROUTINE THIEF-ROBBED-AND-LEFT (ROBBED?)
	 <COND (.ROBBED?
		<TELL "The thief just left. You may not have noticed that he ">
		<COND (<EQUAL? .ROBBED? ,ADVENTURER>
		       <TELL "robbed you blind first">)
		      (T
		       <TELL "appropriated the valuables in the room">)>
		<TELL ,PERIOD-CR>
		<NOW-DARK?>)
	       (T
		<TELL ,THIEF-LEFT-DISGUSTED>)>>

<ROUTINE DEPOSIT-BOOTY (RM "AUX" X N (DROPPED-A-TREASURE <>))
	 <SET X <FIRST? ,THIEF>>
	 <REPEAT ()
		 <COND (<NOT .X>
			<RETURN>)>
		 <SET N <NEXT? .X>>
		 <COND (<FSET? .X ,TREASUREBIT>
			<MOVE .X .RM>
			<FCLEAR .X ,INVISIBLE>
			<SET DROPPED-A-TREASURE T>)>
		 <SET X .N>>
	 .DROPPED-A-TREASURE>

<ROUTINE ROB-MAZE (RM "AUX" X N)
	 <SET X <FIRST? .RM>>
	 <REPEAT ()
		 <COND (<NOT .X>
			<RFALSE>)>
		 <SET N <NEXT? .X>>
		 <COND (<AND <FSET? .X ,TAKEBIT>
			     <NOT <FSET? .X ,INVISIBLE>>
			     <PROB 40>>
			<TELL
"In the distance, someone says, \"My, I wonder what this
fine " D .X " is doing here.\"" CR>
			<COND (<PROB 60 80>
			       <MOVE .X ,THIEF>
			       <FSET .X ,TOUCHBIT>
			       <FSET .X ,INVISIBLE>)>
			<RETURN>)>
		 <SET X .N>>>
\
;"fighting"

<ROUTINE HERO-BLOW ("AUX" VIL-STR HIT-PROB)
	 <SET VIL-STR <GETP ,PRSO ,P?STRENGTH>>
	 <COND (<PRSO? ,TROLL>
		<SET HIT-PROB 45>)
	       (T
	 	<SET HIT-PROB <+ 15 </ ,SCORE 4>>>)>
	 <COND (<PROB .HIT-PROB>
		<COND (<PROB 50> ;"serious blow"
		       <SET VIL-STR <- .VIL-STR 2>>
		       <COND (<L? .VIL-STR 0>
			      <KILL-VILLAIN>)
			     (<PROB 50>
			      <TELL
"The " D ,PRSO " receives a deep gash in his side." CR>)
			     (T
			      <TELL
"Slash! Your " D ,PRSI " connects! This could be serious!" CR>)>)
		      (T ;"light blow"
		       <SET VIL-STR <- .VIL-STR 1>>
		       <COND (<L? .VIL-STR 0>
			      <KILL-VILLAIN>)
			     (<PROB 50>
			      <TELL
"The " D ,PRSO " is struck on the arm; blood begins to trickle down." CR>)
			     (T
			      <TELL
"The blow lands, making a shallow gash in the " D ,PRSO "'s arm!" CR>)>)>
		<PUTP ,PRSO ,P?STRENGTH .VIL-STR>)
	       (<PROB 50>
		<TELL
"A good slash, but it misses the " D ,PRSO " by a mile." CR>)
	       (T
		<TELL
"You charge, but the " D ,PRSO " jumps nimbly aside." CR>)>>

<ROUTINE KILL-VILLAIN ("AUX" X)
	 <TELL
"The fatal blow strikes the " D ,PRSO " square in the heart: He dies. As the "
D ,PRSO " breathes his last breath, a cloud of sinister black fog envelops
him; when it lifts, the carcass is gone." CR>
	 <REMOVE ,PRSO>
	 <COND (<PRSO? ,TROLL>
		<PUTP ,TROLL ,P?STRENGTH 2> ;"to stop I-CURE"
	        <MOVE ,AXE ,HERE>
	        <FCLEAR ,AXE ,NDESCBIT>
	        <FSET ,AXE ,WEAPONBIT>
		<FSET ,AXE ,TAKEBIT>
	        <SETG TROLL-FLAG T>
		<SETG SCORE <+ ,SCORE 10>>)
	       (T
		<PUTP ,THIEF ,P?STRENGTH 5> ;"to stop I-CURE"
	        <MOVE ,STILETTO ,HERE>
		<FCLEAR ,STILETTO ,NDESCBIT>
		<FSET ,STILETTO ,TAKEBIT>
		<FSET ,STILETTO ,WEAPONBIT>
		<DISABLE <INT I-THIEF>>
		<COND (<DEPOSIT-BOOTY ,HERE>
		       <COND (<EQUAL? ,HERE ,THIEFS-LAIR>
			      <TELL
"As the thief dies, his treasures reappear.">)
			     (T
			      <TELL "His booty remains.">)>
		       <CRLF> <CRLF>
		       <V-LOOK>)>)>>

<ROUTINE I-FIGHT ("AUX" ADV-STR TBL HIT-PROB)
	 <ENABLE <QUEUE I-FIGHT -1>>
	 <SET ADV-STR <GETP ,ADVENTURER ,P?STRENGTH>>
	 <COND (<IN? ,TROLL ,HERE>
		<SET HIT-PROB 55>
		<SET TBL ,TROLL-MELEE>)
	       (<IN? ,THIEF ,HERE>
		<SET HIT-PROB 60>
		<SET TBL ,THIEF-MELEE>)
	       (T
		<DISABLE <INT I-FIGHT>>
		<ENABLE <QUEUE I-CURE -1>>
		<RFALSE>)>
	 <COND (<PROB .HIT-PROB>
		<COND (<PROB 50> ;"serious blow"
		       <SET ADV-STR <- .ADV-STR 2>>
		       <COND (<L? .ADV-STR 0>
			      <JIGS-UP <GET .TBL 6>>)
			     (<PROB 50>
			      <TELL <GET .TBL 5> CR>)
			     (T
			      <TELL <GET .TBL 4> CR>)>)
		      (T ;"light blow"
		       <SET ADV-STR <- .ADV-STR 1>>
		       <COND (<L? .ADV-STR 0>
			      <JIGS-UP <GET .TBL 6>>)
			     (<PROB 50>
			      <TELL <GET .TBL 3> CR>)
			     (T
			      <TELL <GET .TBL 2> CR>)>)>
		<PUTP ,ADVENTURER ,P?STRENGTH .ADV-STR>)
	       (<PROB 50>
		<TELL <GET .TBL 1> CR>)
	       (T
		<TELL <GET .TBL 0> CR>)>>

<GLOBAL TROLL-MELEE
	<TABLE
      ;0 "The troll's axe barely misses your ear."
      ;1 "The axe crashes against the rock, throwing sparks!"
      ;2 "The axe blade nicks your side. Ouch!"
      ;3 "The flat of the troll's axe skins across your forearm."
      ;4 "The troll charges, and his axe slashes you on your arm."
      ;5 "An axe stroke makes a deep wound in your leg."
      ;6 "The troll neatly removes your head.">>

<GLOBAL THIEF-MELEE
	<TABLE
      ;0 "The thief stabs nonchalantly with his stiletto and misses."
      ;1 "You dodge as the thief comes in low."
      ;2 "The thief draws blood, raking his stiletto across your arm."
      ;3 "The stiletto flashes, and blood wells from your leg."
      ;4 "The stiletto gashes your forehead, and blood obscures your vision."
      ;5 "The thief slashes your wrist, leaving your grip slippery with blood."
      ;6 "The thief, forgetting his genteel upbringing, cuts your throat.">>

<GLOBAL CURE-COUNT 10>

<ROUTINE I-CURE ("AUX" ADV-STR TROLL-STR THIEF-STR)
	 <SET ADV-STR <GETP ,ADVENTURER ,P?STRENGTH>>
	 <SET TROLL-STR <GETP ,TROLL ,P?STRENGTH>>
	 <SET THIEF-STR <GETP ,THIEF ,P?STRENGTH>>
	 <COND (<AND <EQUAL? .ADV-STR 6>
		     <EQUAL? .TROLL-STR 2>
		     <EQUAL? .THIEF-STR 5>>
		<DISABLE <INT I-CURE>>
		<SETG CURE-COUNT 10>
		<RFALSE>)>
	 <SETG CURE-COUNT <- ,CURE-COUNT 1>>
	 <COND (<EQUAL? ,CURE-COUNT 0>
		<COND (<L? .ADV-STR 6>
		       <PUTP ,ADVENTURER ,P?STRENGTH <+ .ADV-STR 1>>)>
		<COND (<L? .TROLL-STR 2>
		       <PUTP ,TROLL ,P?STRENGTH <+ .TROLL-STR 1>>)>
		<COND (<L? .THIEF-STR 5>
		       <PUTP ,THIEF ,P?STRENGTH <+ .THIEF-STR 1>>)>
		<SETG CURE-COUNT 10>)>
	 <RFALSE>>