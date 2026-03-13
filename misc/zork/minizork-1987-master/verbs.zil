"VERBS for
			     Mini-Zork '87
	  (c) Copyright 1987 Infocom, Inc. All Rights Reserved"

;"game commands"

<GLOBAL VERBOSITY 1> ;"0 = superbrief, 1 = brief, 2 = verbose"

<ROUTINE V-VERBOSE ()
	 <SETG VERBOSITY 2>
	 <TELL "Maximum verbosity." CR>>

<ROUTINE V-BRIEF ()
	 <SETG VERBOSITY 1>
	 <TELL "Brief descriptions." CR>>

<ROUTINE V-SUPER-BRIEF ()
	 <SETG VERBOSITY 0>
	 <TELL "Superbrief descriptions." CR>>

<ROUTINE V-DIAGNOSE ("AUX" ADV-STR X)
	<SET ADV-STR <GETP ,ADVENTURER ,P?STRENGTH>>
	<TELL "You are ">
	<COND (<EQUAL? .ADV-STR 6>
	       <TELL "in perfect health">)
	      (<EQUAL? .ADV-STR 5>
	       <TELL "slightly wounded">)
	      (<EQUAL? .ADV-STR 3 4>
	       <TELL "somewhat wounded">)
	      (T
	       <TELL "seriously wounded">)>
	<COND (<NOT <EQUAL? .ADV-STR 6>>
	       <TELL ", but will be cured after ">
	       <SET X <+ <* <- 5 .ADV-STR> 10> ,CURE-COUNT>>
	       <TELL N .X " move">
	       <COND (<NOT <EQUAL? .X 1>>
		      <TELL "s">)>)>
	<COND (<NOT <0? ,DEATHS>>
	       <TELL ". You have been killed ">
	       <COND (<1? ,DEATHS>
		      <TELL "once">)
		     (T
		      <TELL "twice">)>)>
	<TELL ,PERIOD-CR>>

<ROUTINE V-INVENTORY ()
	 <COND (<FIRST? ,WINNER>
		<PRINT-CONT ,WINNER>)
	       (T
		<TELL "You are empty-handed." CR>)>>

<ROUTINE FINISH ("AUX" WRD)
	 <V-SCORE>
	 <REPEAT ()
		 <TELL
"|Would you like to restart from the beginning, restore a saved position,
or end this session of the game?|
(Type RESTART, RESTORE, or QUIT):| >">
		 <READ ,P-INBUF ,P-LEXV>
		 <SET WRD <GET ,P-LEXV 1>>
		 <COND (<EQUAL? .WRD ,W?RESTART>
			<RESTART>
			<TELL ,FAILED>)
		       (<EQUAL? .WRD ,W?RESTORE>
			<COND (<RESTORE>
			       <TELL "Ok." CR>)
			      (T
			       <TELL ,FAILED>)>)
		       (<EQUAL? .WRD ,W?QUIT ,W?Q>
			<QUIT>)>>>

<ROUTINE V-QUIT ()
	 <COND (<DO-YOU-WISH "leave the game">
		<QUIT>)>>

<ROUTINE V-RESTART ()
	 <COND (<DO-YOU-WISH "restart">
		<RESTART>
		<TELL ,FAILED>)>>

<ROUTINE DO-YOU-WISH (STRING)
	 <V-SCORE>
	 <TELL CR "Do you wish to " .STRING "? (Y is affirmative): ">
	 <COND (<YES?>
		<RTRUE>)
	       (T
		<TELL "Ok." CR>
		<RFALSE>)>>

<ROUTINE YES? ()
	 <PRINTI ">">
	 <READ ,P-INBUF ,P-LEXV>
	 <COND (<EQUAL? <GET ,P-LEXV 1> ,W?YES ,W?Y>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE V-RESTORE ()
	 <COND (<RESTORE>
		<TELL "Ok." CR>)
	       (T
		<TELL ,FAILED>)>>

<ROUTINE V-SAVE ()
	 <COND (<SAVE>
	        <TELL "Ok." CR>)
	       (T
		<TELL ,FAILED>)>>

<ROUTINE V-SCORE ()
	 <TELL
"Your score is " N ,SCORE " (of 350 points), in " N ,MOVES " move">
	 <COND (<NOT <1? ,MOVES>>
		<TELL "s">)>
	 <TELL ". This gives you the rank of ">
	 <COND (<EQUAL? ,SCORE 350>
		<TELL "Master">)
	       (<G? ,SCORE 250>
		<TELL "Senior">)
	       (<G? ,SCORE 150>
		<TELL "Junior">)
	       (<G? ,SCORE 75>
		<TELL "Novice">)
	       (T
		<TELL "Beginning">)>
	 <TELL " Adventurer." CR>>

<GLOBAL MOVES 0>

<GLOBAL SCORE 0>

<ROUTINE SCORE-OBJ (OBJ "AUX" TEMP)
	 <COND (<G? <SET TEMP <GETP .OBJ ,P?VALUE>> 0>
		<SETG SCORE <+ ,SCORE .TEMP>>
		<PUTP .OBJ ,P?VALUE 0>)>>

<ROUTINE V-SCRIPT ()
	<PUT 0 8 <BOR <GET 0 8> 1>>
	<TRANSCRIPT-MESSAGE "begin">>

<ROUTINE V-UNSCRIPT ()
	<TRANSCRIPT-MESSAGE "end">
	<PUT 0 8 <BAND <GET 0 8> -2>>
	<RTRUE>>

<ROUTINE TRANSCRIPT-MESSAGE (STRING)
	 <TELL "Here " .STRING "s a transcript of interation with" CR>
	 <V-VERSION>>

<ROUTINE V-VERSION ("AUX" (CNT 17))
	<TELL
"MINI-ZORK I: " ,GUE-NAME CR
"Copyright (c) 1988 Infocom, Inc. All rights reserved.|
ZORK is a registered trademark of Infocom, Inc.|
Release ">
	<PRINTN <BAND <GET 0 1> *3777*>>
	<TELL " / Serial number ">
	<REPEAT ()
		<COND (<G? <SET CNT <+ .CNT 1>> 23>
		       <RETURN>)
		      (T
		       <PRINTC <GETB 0 .CNT>>)>>
	<CRLF>>

<ROUTINE V-VERIFY ()
	 <TELL "Verifying..." CR>
	 <COND (<VERIFY>
		<TELL "Correct." CR>)
	       (T
		<TELL CR "***" ,FAILED>)>>

<ROUTINE V-COMMAND-FILE ()
	 <DIRIN 1>
	 <RTRUE>>

<ROUTINE V-RANDOM ()
	 <COND (<NOT <PRSO? ,INTNUM>>
		<TELL "Bad call to #RND." CR>)
	       (T
		<RANDOM <- 0 ,P-NUMBER>>
		<RTRUE>)>>

<ROUTINE V-RECORD ()
	 <DIROUT 4>
	 <RTRUE>>

<ROUTINE V-UNRECORD ()
	 <DIROUT -4>
	 <RTRUE>>
^L
"Real Verb Functions"

<ROUTINE V-ALARM ()
	 <TELL "The " D ,PRSO " isn't sleeping." CR>>

<ROUTINE V-ATTACK ()
	 <COND (<NOT <FSET? ,PRSO ,ACTORBIT>>
		<TELL "Fighting a " D ,PRSO "!?!" CR>)
	       (<OR <NOT ,PRSI>
		    <PRSI? ,HANDS>>
		<SUICIDAL "your bare hands">)
	       (<NOT <IN? ,PRSI ,WINNER>>
		<TELL ,YNH "the " D ,PRSI ,PERIOD-CR>)
	       (<NOT <FSET? ,PRSI ,WEAPONBIT>>
		<SUICIDAL>)
	       (T
	        <HERO-BLOW>)>>

<ROUTINE SUICIDAL ("OPTIONAL" (STRING <>))
	 <TELL "Trying to attack a " D ,PRSO " with ">
	 <COND (.STRING
		<TELL .STRING>)
	       (T
		<TELL "a " D ,PRSI>)>
	 <TELL " is suicidal." CR>>

<ROUTINE PRE-BOARD ()
	 <COND (<PRSO? ,INFLATED-BOAT>
		<COND (<NOT <IN? ,PRSO ,HERE>>
		       <TELL "The " D ,PRSO " isn't on the ground!" CR>)
		      (<IN? ,ADVENTURER ,INFLATED-BOAT>
		       <TELL ,LOOK-AROUND>)
		      (T
		       <RFALSE>)>)
	       (<PRSO? ,WATER ,GLOBAL-WATER>
		<PERFORM ,V?SWIM ,PRSO>
		<RTRUE>)
	       (T
		<TELL
"You have a theory on how to board a " D ,PRSO ", perhaps?" CR>)>
	 <RFATAL>>

<ROUTINE V-BOARD ("AUX" AV)
	 <TELL "You are now in the " D ,PRSO ,PERIOD-CR>
	 <MOVE ,WINNER ,PRSO>
	 <APPLY <GETP ,PRSO ,P?ACTION> ,M-ENTER>
	 <RTRUE>>

<ROUTINE V-BREATHE ()
	 <PERFORM ,V?INFLATE ,PRSO ,LUNGS>>

<ROUTINE PRE-BURN ()
	 <COND (<NOT ,PRSI>
		<TELL "You didn't say with what!" CR>)
	       (<FLAMING? ,PRSI>
	        <RFALSE>)
	       (T
	        <TELL "With a " D ,PRSI "??!?" CR>)>>

<ROUTINE V-BURN ()
	 <COND (<FSET? ,PRSO ,BURNBIT>
		<COND (<OR <IN? ,PRSO ,WINNER>
			   <IN? ,WINNER ,PRSO>>
		       <TELL "The " D ,PRSO>
		       <TELL " catches fire. Unfortunately, you were ">
		       <COND (<IN? ,WINNER ,PRSO>
			      <TELL "in">)
			     (T
			      <TELL "holding">)>
		       <JIGS-UP " it at the time.">)
		      (T
		       <TELL "The " D ,PRSO " is consumed by fire." CR>)>
		<REMOVE-CAREFULLY ,PRSO>)
	       (T
		<TELL ,YOU-CANT "burn a " D ,PRSO ,PERIOD-CR>)>>

<ROUTINE V-CLIMB ()
	 <COND (<PRSO? ,WALL>
		<TELL "Climbing the walls is to no avail." CR>)
	       (<OR <PRSO? ,ROOMS <> ,TREE>
		    <FSET? ,PRSO ,CLIMBBIT>>
		<DO-WALK ,P?UP>)
	       (T
		<TELL ,YOU-CANT "do that." CR>)>>

<ROUTINE V-CLIMB-DOWN ()
	 <COND (<OR <PRSO? ,ROOMS <> ,TREE>
		    <FSET? ,PRSO ,CLIMBBIT>>
		<DO-WALK ,P?DOWN>)
	       (T
		<TELL ,YOU-CANT "do that." CR>)>>

<ROUTINE V-CLIMB-ON ()
	 <TELL ,YOU-CANT "climb onto the " D ,PRSO ,PERIOD-CR>>

<ROUTINE V-CLOSE ()
	 <COND (<AND <NOT <FSET? ,PRSO ,CONTBIT>>
		     <NOT <FSET? ,PRSO ,DOORBIT>>>
		<TELL
"You must tell me how to do that to a " D ,PRSO ,PERIOD-CR>)
	       (<AND <NOT <FSET? ,PRSO ,SURFACEBIT>>
		     <NOT <EQUAL? <GETP ,PRSO ,P?CAPACITY> 0>>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <FCLEAR ,PRSO ,OPENBIT>
		       <TELL "Closed." CR>
		       <NOW-DARK?>)
		      (T
		       <TELL ,LOOK-AROUND>)>)
	       (<FSET? ,PRSO ,DOORBIT>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <FCLEAR ,PRSO ,OPENBIT>
		       <TELL "The " D ,PRSO " is now closed." CR>)
		      (T
		       <TELL ,LOOK-AROUND>)>)
	       (T
		<TELL "You cannot close that." CR>)>>

<ROUTINE V-COUNT ()
	 <TELL "You have lost your mind." CR>>

<ROUTINE V-CROSS ()
	 <TELL ,YOU-CANT "cross that!" CR>>

<ROUTINE V-CURSES ()
	 <TELL "Such language in a high-class establishment like this!" CR>>

<ROUTINE V-CUT ()
	 <COND (<FSET? ,PRSO ,ACTORBIT>
		<PERFORM ,V?ATTACK ,PRSO ,PRSI>)
	       (<AND <FSET? ,PRSO ,BURNBIT>
		     <FSET? ,PRSI ,WEAPONBIT>>
		<COND (<IN? ,WINNER ,PRSO>
		       <TELL "Not a bright idea, since you're in it." CR>)
		      (T
		       <TELL
"Your skillful " D ,PRSI "smanship slices the " D ,PRSO
" into innumerable slivers which blow away." CR>
		       <REMOVE-CAREFULLY ,PRSO>)>)
	       (<NOT <FSET? ,PRSI ,WEAPONBIT>>
		<TELL
"The \"cutting edge\" of a " D ,PRSI " is hardly adequate." CR>)
	       (T
		<TELL "Strange concept, cutting the " D ,PRSO "..." CR>)>>

<ROUTINE V-DEFLATE ()
	 <TELL "Come on, now!" CR>>

<ROUTINE V-DIG ()
	 <COND (<NOT ,PRSI>
		<SETG PRSI ,HANDS>)>
	 <COND (<PRSI? ,SHOVEL>
		<TELL "There's no reason to be digging here." CR>)
	       (<FSET? ,PRSI ,TOOLBIT>
		<TELL "Digging with the " D ,PRSI " is slow and tedious." CR>)
	       (T
		<TELL "Digging with a " D ,PRSI " is silly." CR>)>>

<ROUTINE V-DRINK ()
	 <V-EAT>>

<ROUTINE V-DRINK-FROM ()
	 <TELL "How peculiar!" CR>>

<ROUTINE PRE-DROP ()
	 <COND (<IN? ,ADVENTURER ,PRSO>
		<PERFORM ,V?EXIT ,PRSO>
		<RTRUE>)>>

<ROUTINE V-DROP ()
	 <COND (<IDROP>
		<TELL "Dropped." CR>)>>

<ROUTINE V-EAT ("AUX" (L <>))
	 <COND (<FSET? ,PRSO ,FOODBIT>
		<COND (<NOT <HELD? ,PRSO>>
		       <TELL ,YNH "that." CR>)
		      (<VERB? DRINK>
		       <TELL "How can you drink that?" CR>)
		      (T
		       <HIT-SPOT>)>)
	       (<FSET? ,PRSO ,DRINKBIT>
		<SET L <LOC ,PRSO>>
		<COND (<OR <IN? ,PRSO ,GLOBAL-OBJECTS>
			   <GLOBAL-IN? ,GLOBAL-WATER>
			   <PRSO? ,PSEUDO-OBJECT>>
		       <HIT-SPOT>)
		      (<AND <ACCESSIBLE? .L>
			    <NOT <IN? .L ,WINNER>>>
		       <TELL ,YNH "the " D .L ,PERIOD-CR>)
		      (<NOT <FSET? .L ,OPENBIT>>
		       <TELL "You'll have to open the " D .L " first." CR>)
		      (T
		       <HIT-SPOT>)>)
	       (T
		<TELL
"It's unlikely that the " D ,PRSO " would agree with you." CR>)>>

<ROUTINE HIT-SPOT ()
	 <COND (<AND <PRSO? ,WATER>
		     <NOT <GLOBAL-IN? ,GLOBAL-WATER>>>
		<REMOVE-CAREFULLY ,PRSO>)>
	 <TELL "That really hit the spot." CR>>

<ROUTINE V-ENTER ()
	<DO-WALK ,P?IN>>

<ROUTINE V-EXAMINE ()
	 <COND (<GETP ,PRSO ,P?TEXT>
		<TELL <GETP ,PRSO ,P?TEXT> CR>)
	       (<AND <OR <FSET? ,PRSO ,CONTBIT>
		    	 <FSET? ,PRSO ,DOORBIT>>
		     <NOT <PRSO? ,CHALICE>>>
		<V-LOOK-INSIDE>)
	       (T
		<TELL
,THERES-NOTHING "special about the " D ,PRSO ,PERIOD-CR>)>>

<ROUTINE V-EXIT ()
	 <COND (<AND <PRSO? <> ,ROOMS>
		     <IN? ,ADVENTURER ,INFLATED-BOAT>>
		<SETG PRSO ,INFLATED-BOAT>)>
	 <COND (<NOT ,PRSO>
		<DO-WALK ,P?OUT>)
	       (<NOT <IN? ,ADVENTURER ,PRSO>>
		<TELL ,LOOK-AROUND>)
	       (<FSET? ,HERE ,RLANDBIT>
		<MOVE ,WINNER ,HERE>
		<TELL "You are on your own feet again." CR>)
	       (T
		<TELL "Getting out here would be fatal." CR>
		<RFATAL>)>>

<ROUTINE V-EXORCISE ()
	 <TELL "What a bizarre concept!" CR>>

<ROUTINE PRE-FILL ()
	 <COND (<NOT ,PRSI>
		<COND (<GLOBAL-IN? ,GLOBAL-WATER>
		       <PERFORM ,V?FILL ,PRSO ,GLOBAL-WATER>
		       <RTRUE>)
		      (<IN? ,WATER <LOC ,WINNER>>
		       <PERFORM ,V?FILL ,PRSO ,WATER>
		       <RTRUE>)
		      (T
		       <TELL ,NOTHING-TO-FILL-WITH>)>)
	       (<NOT <PRSI? ,WATER ,GLOBAL-WATER>>
		<PERFORM ,V?PUT ,PRSI ,PRSO>
		<RTRUE>)>>

<ROUTINE V-FILL ()
	 <TELL "You may know how to do that, but I don't." CR>>

<ROUTINE V-FIND ("AUX" (L <LOC ,PRSO>))
	 <COND (<PRSO? ,HANDS ,LUNGS>
		<TELL "Within six feet of your head, hopefully." CR>)
	       (<PRSO? ,ME>
		<TELL "You're around here somewhere..." CR>)
	       (<EQUAL? .L ,GLOBAL-OBJECTS>
		<TELL "You find it." CR>)
	       (<IN? ,PRSO ,WINNER>
		<TELL "You have it." CR>)
	       (<OR <IN? ,PRSO ,HERE>
		    <GLOBAL-IN? ,PRSO>
		    <PRSO? ,PSEUDO-OBJECT>>
		<TELL "It's right here." CR>)
	       (<FSET? .L ,ACTORBIT>
		<TELL "The " D .L " has it." CR>)
	       (<FSET? .L ,SURFACEBIT>
		<TELL "It's on the " D .L ,PERIOD-CR>)
	       (<FSET? .L ,CONTBIT>
		<TELL "It's in the " D .L ,PERIOD-CR>)
	       (T
		<TELL "Beats me." CR>)>>

<ROUTINE V-FOLLOW ()
	 <TELL "You're nuts!" CR>>

<ROUTINE PRE-GIVE ()
	 <COND (<NOT <HELD? ,PRSO>>
		<TELL 
"That's easy for you to say since you don't even have the "
D ,PRSO ,PERIOD-CR>)>>

<ROUTINE V-GIVE ()
	 <COND (<NOT <FSET? ,PRSI ,ACTORBIT>>
		<TELL ,YOU-CANT "give a " D ,PRSO " to a " D ,PRSI "!" CR>)
	       (T
		<TELL "The " D ,PRSI " refuses it politely." CR>)>>

<ROUTINE V-HATCH ()
	 <TELL "Bizarre!" CR>>

<ROUTINE V-HELLO ()
	 <COND (,PRSO
		<COND (<FSET? ,PRSO ,ACTORBIT>
		       <TELL "The " D ,PRSO " bows his head in greeting." CR>)
		      (T
		       <TELL
"Only schizophrenics say \"Hello\" to a " D ,PRSO ,PERIOD-CR>)>)
	       (T
		<TELL "Good day." CR>)>>

<ROUTINE V-INFLATE ()
	 <TELL "How can you inflate that?" CR>>

<ROUTINE V-KICK ()
	 <HACK-HACK "Kicking the ">>

<ROUTINE V-KISS ()
	 <TELL "I'd sooner kiss a pig." CR>>

<ROUTINE V-KNOCK ()
	 <COND (<FSET? ,PRSO ,DOORBIT>
		<TELL "Nobody's home." CR>)
	       (T
		<TELL "Why knock on a " D ,PRSO "?" CR>)>>

<ROUTINE V-LAMP-OFF ()
	 <COND (<FSET? ,PRSO ,LIGHTBIT>
		<COND (<NOT <FSET? ,PRSO ,ONBIT>>
		       <TELL "It's already off." CR>)
		      (T
		       <FCLEAR ,PRSO ,ONBIT>
		       <TELL "The " D ,PRSO " is now off." CR>
		       <NOW-DARK?>)>)
	       (T
		<TELL ,YOU-CANT "turn that off." CR>)>>

<ROUTINE V-LAMP-ON ()
	 <COND (<FSET? ,PRSO ,LIGHTBIT>
		<COND (<FSET? ,PRSO ,ONBIT>
		       <TELL "It is already on." CR>)
		      (T
		       <FSET ,PRSO ,ONBIT>
		       <TELL "The " D ,PRSO " is now on." CR>
		       <COND (<NOT ,LIT>
			      <SETG LIT <LIT? ,HERE>>
			      <CRLF>
			      <V-LOOK>)>)>)
	       (<FSET? ,PRSO ,BURNBIT>
		<TELL "If you wish to burn the " D ,PRSO ", say so." CR>)
	       (T
		<TELL ,YOU-CANT "turn that on." CR>)>>

<ROUTINE V-LAUNCH ()
	 <TELL "That's pretty weird." CR>>

<ROUTINE V-LEAP ("AUX" TX S)
	 <COND (,PRSO
		<COND (<FSET? ,PRSO ,ACTORBIT>
		       <TELL "The " D ,PRSO " is too big to jump over." CR>)
		      (<IN? ,PRSO ,HERE>
		       <V-SKIP>)
		      (T
		       <TELL ,GOOD-TRICK>)>)
	       (<SET TX <GETPT ,HERE ,P?DOWN>>
		<SET S <PTSIZE .TX>>
		<COND (<OR <EQUAL? .S 2> ;NEXIT
       			   <AND <EQUAL? .S 4> ;CEXIT
				<NOT <VALUE <GETB .TX 1>>>>>
		       <TELL "This was not a very safe place to try jumping. ">
		       <JIGS-UP "You should have looked before you leaped.">)
		      (T
		       <V-SKIP>)>)
	       (T
		<V-SKIP>)>>

<ROUTINE V-LISTEN ()
	 <TELL "The " D ,PRSO " makes no sound." CR>>

<ROUTINE V-LOCK ()
	 <TELL "It" <PICK-ONE ,HO-HUM> ,PERIOD-CR>>

<ROUTINE V-LOOK ()
	 <COND (<DESCRIBE-ROOM T>
		<DESCRIBE-OBJECTS T>)>>

<ROUTINE V-LOOK-BEHIND ()
	 <TELL ,THERES-NOTHING "behind the " D ,PRSO ,PERIOD-CR>>

<ROUTINE V-LOOK-INSIDE ()
	 <COND (<FSET? ,PRSO ,DOORBIT>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <TELL "It's open, but you can't see what's beyond.">)
		      (T
		       <TELL "The " D ,PRSO " is closed.">)>
		<CRLF>)
	       (<FSET? ,PRSO ,CONTBIT>
		<COND (<FSET? ,PRSO ,ACTORBIT>
		       <TELL ,THERES-NOTHING "special to be seen." CR>)
		      (<SEE-INSIDE? ,PRSO>
		       <COND (<AND <FIRST? ,PRSO>
				   <PRINT-CONT ,PRSO>>
			      <RTRUE>)
			     (T
			      <TELL "The " D ,PRSO " is empty." CR>)>)
		      (T
		       <TELL "The " D ,PRSO " is closed." CR>)>)
	       (T
		<TELL ,YOU-CANT "look inside a " D ,PRSO ,PERIOD-CR>)>>

<ROUTINE V-LOOK-UNDER ()
	 <TELL ,THERES-NOTHING "but dust there." CR>>

<ROUTINE V-LOWER ()
	 <HACK-HACK "Playing in this way with the ">>

<ROUTINE V-MAKE ()
    	<TELL ,YOU-CANT "do that." CR>>

<ROUTINE PRE-MOVE ()
	 <COND (<HELD? ,PRSO>
		<TELL "Moved." CR>)>>

<ROUTINE V-MOVE ()
	 <COND (<FSET? ,PRSO ,TAKEBIT>
		<TELL "Moving the " D ,PRSO " reveals nothing." CR>)
	       (T
		<TELL ,YOU-CANT "move the " D ,PRSO ,PERIOD-CR>)>>

<ROUTINE PRE-MUNG ()
	 <COND (<OR <NOT ,PRSI>
		    <NOT <FSET? ,PRSI ,WEAPONBIT>>>
		<TELL "Trying to destroy the " D ,PRSO " with ">
		<COND (<NOT ,PRSI>
		       <TELL "your bare hands">)
		      (T
		       <TELL "a " D ,PRSI>)>
		<TELL " is futile." CR>)>>

<ROUTINE V-MUNG ()
	 <COND (<FSET? ,PRSO ,ACTORBIT>
		<PERFORM ,V?ATTACK ,PRSO>
		<RTRUE>)
	       (T
		<TELL "Nice try." CR>)>>

<ROUTINE V-ODYSSEUS ()
	 <COND (<AND <EQUAL? ,HERE ,CYCLOPS-ROOM>
		     <IN? ,CYCLOPS ,HERE>
		     <NOT ,CYCLOPS-FLAG>>
		<DISABLE <INT I-CYCLOPS>>
		<SETG CYCLOPS-FLAG T>
		<SETG MAGIC-FLAG T>
		<REMOVE ,CYCLOPS>
		<TELL 
"The cyclops, hearing the name of his father's deadly nemesis, flees by
crashing through the east wall." CR>)
	       (T
		<TELL "Wasn't he a sailor?" CR>)>>

<ROUTINE V-OPEN ("AUX" F STR)
	 <COND (<AND <FSET? ,PRSO ,CONTBIT>
		     <NOT <FSET? ,PRSO ,SURFACEBIT>>
		     <NOT <EQUAL? <GETP ,PRSO ,P?CAPACITY> 0>>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <TELL "It is already open." CR>)
		      (T
		       <FSET ,PRSO ,OPENBIT>
		       <FSET ,PRSO ,TOUCHBIT>
		       <COND (<OR <NOT <FIRST? ,PRSO>> <FSET? ,PRSO ,TRANSBIT>>
			      <TELL "Opened." CR>)
			     (<AND <SET F <FIRST? ,PRSO>>
				   <NOT <NEXT? .F>>
				   <NOT <FSET? .F ,TOUCHBIT>>
				   <SET STR <GETP .F ,P?FDESC>>>
			      <TELL "The " D ,PRSO " opens." CR>
			      <TELL .STR CR>)
			     (T
			      <TELL "Opening the " D ,PRSO " reveals ">
			      <PRINT-CONTENTS ,PRSO>
			      <TELL ,PERIOD-CR>)>)>)
	       (<FSET? ,PRSO ,DOORBIT>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <TELL "It is already open." CR>)
		      (T
		       <TELL "The " D ,PRSO " opens." CR>
		       <FSET ,PRSO ,OPENBIT>)>)
	       (T
		<TELL
"You must tell me how to do that to a " D ,PRSO ,PERIOD-CR>)>>

<ROUTINE V-PICK ()
	 <TELL ,YOU-CANT "pick that." CR>>

<ROUTINE V-POUR-ON ()
	 <COND (<PRSO? ,WATER>
	        <COND (<FLAMING? ,PRSI>
		       <TELL "The " D ,PRSI " is extinguished." CR>
		       <FCLEAR ,PRSI ,ONBIT>
		       <FCLEAR ,PRSI ,FLAMEBIT>)
	              (T
		       <TELL
"The water spills over the " D ,PRSI ", to the floor, and evaporates." CR>)>
		<REMOVE-CAREFULLY ,PRSO>
		<NOW-DARK?>)
	       (T
		<TELL ,YOU-CANT "pour that." CR>)>>

<GLOBAL ALTAR-SCORE 15>

<ROUTINE V-PRAY ()
	 <COND (<EQUAL? ,HERE ,ALTAR>
		<SETG SCORE <+ ,SCORE ,ALTAR-SCORE>>
		<SETG ALTAR-SCORE 0>
		<GOTO ,FOREST-EDGE>)
	       (T
		<TELL
"If you pray enough, your prayers may be answered." CR>)>>

<ROUTINE V-PUMP ()
	 <COND (<AND ,PRSI
		     <NOT <PRSI? ,PUMP>>>
		<TELL "With a " D ,PRSI "!?!" CR>)
	       (<IN? ,PUMP ,WINNER>
		<PERFORM ,V?INFLATE ,PRSO ,PUMP>)
	       (T
		<TELL "It's not clear how." CR>)>>

<ROUTINE V-PUSH ()
	 <HACK-HACK "Pushing the ">>

<ROUTINE PRE-PUT ()
	 <COND (<PRSO? ,WATER ,GLOBAL-WATER>
		<RFALSE>)
	       (T
	 	<PRE-GIVE>)>> ;"That's easy for you to say..."

<ROUTINE V-PUT ()
	 <COND (<AND <NOT <FSET? ,PRSI ,OPENBIT>>
		     <NOT <OPENABLE? ,PRSI>>
		     <NOT <FSET? ,PRSI ,VEHBIT>>>
	        <TELL ,YOU-CANT "do that." CR>)
	       (<NOT <FSET? ,PRSI ,OPENBIT>>
		<SETG P-IT-OBJECT ,PRSI>
		<TELL "The " D ,PRSI " isn't open." CR>)
	       (<PRSI? ,PRSO>
		<TELL "How can you do that?" CR>)
	       (<IN? ,PRSO ,PRSI>
		<TELL ,LOOK-AROUND>)
	       (<G? <- <+ <WEIGHT ,PRSI> <WEIGHT ,PRSO>>
		       <GETP ,PRSI ,P?SIZE>>
		    <GETP ,PRSI ,P?CAPACITY>>
		<TELL "There's no room." CR>)
	       (<AND <NOT <HELD? ,PRSO>>
		     <FSET? ,PRSO ,TRYTAKEBIT>>
		<TELL ,YNH "the " D ,PRSO ,PERIOD-CR>)
	       (<AND <NOT <HELD? ,PRSO>>
		     <NOT <ITAKE>>>
		<RTRUE>)
	       (T
		<MOVE ,PRSO ,PRSI>
		<FSET ,PRSO ,TOUCHBIT>
		<SCORE-OBJ ,PRSO>
		<TELL "Done." CR>)>>

<ROUTINE V-PUT-ON ()
	 <COND (<PRSI? ,GROUND>
		<PERFORM ,V?DROP ,PRSO>
		<RTRUE>)
	       (<FSET? ,PRSI ,SURFACEBIT>
		<V-PUT>)
	       (T
		<TELL "There's no good surface on the " D ,PRSI ,PERIOD-CR>)>>

<ROUTINE V-RAISE ()
	 <V-LOWER>>

<ROUTINE PRE-READ ()
	 <COND (<NOT ,LIT>
		<TELL ,TOO-DARK>)>>

<ROUTINE V-READ ()
	 <COND (<FSET? ,PRSO ,READBIT>
		<TELL <GETP ,PRSO ,P?TEXT> CR>)
	       (T
		<TELL "How does one read a " D ,PRSO "?" CR>)>>

<ROUTINE V-READ-PAGE ()
	 <PERFORM ,V?READ ,PRSO>
	 <RTRUE>>

<ROUTINE V-REPENT ()
	 <TELL "It could very well be too late!" CR>>

<ROUTINE V-RING ()
	 <TELL "How, exactly, can you ring that?" CR>>

<ROUTINE V-RUB ()
	 <HACK-HACK "Fiddling with the ">>

<ROUTINE V-SAY ("AUX" V)
	 <COND (<NOT ,P-CONT>
		<TELL "Say what?" CR>
		<RTRUE>)>
	 <SETG QUOTE-FLAG <>>
	 <COND (<SET V <FIND-IN ,HERE ,ACTORBIT>>
		<TELL "You must address the " D .V " directly." CR>
		<SETG P-CONT <>>)
	       (<NOT <EQUAL? <GET ,P-LEXV ,P-CONT> ,W?HELLO>>
	        <SETG P-CONT <>>
		<TELL ,MENTAL-COLLAPSE>)>
	 <RTRUE>>

<ROUTINE V-SEARCH ()
	 <TELL "You find nothing unusual." CR>>

<ROUTINE V-SGIVE ()
	 <PERFORM ,V?GIVE ,PRSI ,PRSO>
	 <RTRUE>>

<ROUTINE V-SHAKE ()
	 <TELL "Shaken." CR>>

<ROUTINE V-SKIP ()
	 <TELL "Wheeeeeeeeee!!!!!" CR>>

<ROUTINE V-SMELL ()
	 <TELL "It smells like a " D ,PRSO ,PERIOD-CR>>

<ROUTINE V-STAB ("AUX" W)
	 <COND (<SET W <FIND-IN ,ADVENTURER ,WEAPONBIT>>
		<PERFORM ,V?ATTACK ,PRSO .W>
		<RTRUE>)
	       (T
		<TELL
"Do you propose to stab the " D ,PRSO " with your pinky?" CR>)>>

<ROUTINE V-STRIKE ()
	 <COND (<FSET? ,PRSO ,ACTORBIT>
		<TELL
"You aren't versed in hand-to-hand combat; you'd better use a weapon." CR>)
	       (T
		<PERFORM ,V?LAMP-ON ,PRSO>
		<RTRUE>)>>

<ROUTINE V-SWIM ()
	 <TELL "Swimming isn't allowed in the ">
	 <COND (<AND ,PRSO
		     <NOT <PRSO? ,WATER ,GLOBAL-WATER>>>
		<TELL D ,PRSO ".">)
	       (T
		<TELL "dungeon.">)>
	 <CRLF>>Y

<ROUTINE V-SWING ()
	 <COND (<NOT ,PRSI>
		<TELL "Whoosh!" CR>)
	       (T
		<PERFORM ,V?ATTACK ,PRSI ,PRSO>)>>

<ROUTINE PRE-TAKE ()
	 <COND (<IN? ,PRSO ,WINNER>
		<TELL ,ALREADY>)
	       (<AND <FSET? <LOC ,PRSO> ,CONTBIT>
		     <NOT <FSET? <LOC ,PRSO> ,OPENBIT>>>
		<TELL ,YOU-CANT "reach inside a closed container." CR>)
	       (,PRSI
		<COND (<PRSI? ,GROUND>
		       <SETG PRSI <>>
		       <RFALSE>)
		      (<NOT <PRSI? <LOC ,PRSO>>>
		       <TELL
"The " D ,PRSO " isn't in the " D ,PRSI ,PERIOD-CR>)
		      (T
		       <SETG PRSI <>>
		       <RFALSE>)>)
	       (<IN? ,ADVENTURER ,PRSO>
		<TELL "You're in it!" CR>)>>

<ROUTINE V-TAKE ()
	 <COND (<EQUAL? <ITAKE> T>
		<TELL "Taken." CR>)>>

<ROUTINE V-TELL ()
	 <COND (<FSET? ,PRSO ,ACTORBIT>
		<COND (,P-CONT
		       <SETG WINNER ,PRSO>
		       <SETG HERE <LOC ,WINNER>>)
		      (T
		       <TELL
"The " D ,PRSO " suggests that you reread your manual." CR>)>)
	       (T
		<TELL ,YOU-CANT "talk to the " D ,PRSO "!" CR>
		<SETG QUOTE-FLAG <>>
		<SETG P-CONT <>>
		<RFATAL>)>>

<ROUTINE V-THROUGH ("AUX" M)
	<COND (<AND <FSET? ,PRSO ,DOORBIT>
		    <SET M <OTHER-SIDE ,PRSO>>>
	       <DO-WALK .M>)
	      (<FSET? ,PRSO ,VEHBIT>
	       <PERFORM ,V?BOARD ,PRSO>
	       <RTRUE>)
	      (<NOT <FSET? ,PRSO ,TAKEBIT>>
	       <TELL
"You hit your head against the " D ,PRSO " as you attempt this feat." CR>)
	      (<IN? ,PRSO ,WINNER>
	       <TELL "That would involve quite a contortion!" CR>)
	      (T
	       <TELL <PICK-ONE ,YUKS> CR>)>>

<ROUTINE V-THROW ()
	 <COND (<IDROP>
		<COND (<PRSI? ,ME>
		       <TELL
"The " D ,PRSO " conks you in the head. Normally, this wouldn't do much
damage, but you fall over backwards trying to duck and break your neck,
justice being swift and merciful in " ,GUE-NAME>
		       <JIGS-UP ".">)
		      (<AND ,PRSI <FSET? ,PRSI ,ACTORBIT>>
		       <TELL
"The " D ,PRSI " ducks as the " D ,PRSO
" flies by and crashes to the ground." CR>)
		      (T
		       <TELL "Thrown." CR>)>)
	       (T
		<TELL "Huh?" CR>)>>

<ROUTINE V-THROW-OFF ()
	 <TELL ,YOU-CANT "throw anything off of that!" CR>>

<ROUTINE V-TIE ()
	 <COND (<PRSI? ,WINNER>
		<TELL ,YOU-CANT "tie anything to yourself." CR>)
	       (T
		<TELL ,YOU-CANT "tie the " D ,PRSO " to that." CR>)>>

<ROUTINE V-TIE-UP ()
	 <TELL "With a " D ,PRSI "!?!" CR>>

<ROUTINE PRE-TURN ()
	 <COND (<AND <PRSI? <> ,ROOMS>
		     <NOT <PRSO? ,BLACK-BOOK>>>
		<TELL "Your bare hands don't appear to be enough." CR>)
	       (<NOT <FSET? ,PRSO ,TURNBIT>>
		<TELL ,YOU-CANT "turn that!" CR>)>>

<ROUTINE V-TURN ()
	 <TELL "This has no effect." CR>>

<ROUTINE V-UNLOCK ()
	 <V-LOCK>>

<ROUTINE V-UNTIE ()
	 <TELL "This cannot be tied, so it cannot be untied!" CR>>

<ROUTINE V-WAIT ("OPTIONAL" (NUM 3))
	 <TELL "Time passes..." CR>
	 <REPEAT ()
		 <COND (<L? <SET NUM <- .NUM 1>> 0>
			<RETURN>)
		       (<CLOCKER>
			<RETURN>)>>
	 <SETG CLOCK-WAIT T>>

<ROUTINE V-WALK ("AUX" PT PTS STR OBJ RM)
	 <COND (<NOT ,P-WALK-DIR>
		<V-WALK-AROUND>)
	       (<SET PT <GETPT ,HERE ,PRSO>>
		<COND (<EQUAL? <SET PTS <PTSIZE .PT>> ,UEXIT>
		       <GOTO <GETB .PT ,REXIT>>)
		      (<EQUAL? .PTS ,NEXIT>
		       <TELL <GET .PT ,NEXITSTR> CR>
		       <RFATAL>)
		      (<EQUAL? .PTS ,FEXIT>
		       <COND (<SET RM <APPLY <GET .PT ,FEXITFCN>>>
			      <GOTO .RM>)
			     (T
			      <RFATAL>)>)
		      (<EQUAL? .PTS ,CEXIT>
		       <COND (<VALUE <GETB .PT ,CEXITFLAG>>
			      <GOTO <GETB .PT ,REXIT>>)
			     (<SET STR <GET .PT ,CEXITSTR>>
			      <TELL .STR CR>
			      <RFATAL>)
			     (T
			      <TELL ,CANT-GO>
			      <RFATAL>)>)
		      (<EQUAL? .PTS ,DEXIT>
		       <COND (<FSET? <SET OBJ <GETB .PT ,DEXITOBJ>> ,OPENBIT>
			      <GOTO <GETB .PT ,REXIT>>)
			     (<SET STR <GET .PT ,DEXITSTR>>
			      <TELL .STR CR>
			      <RFATAL>)
			     (T
			      <TELL "The " D .OBJ " is closed." CR>
			      <SETG P-IT-OBJECT .OBJ>
			      <RFATAL>)>)>)
	       (<AND <NOT ,LIT>
		     <PROB 80>
		     <EQUAL? ,WINNER ,ADVENTURER>
		     <NOT <FSET? ,HERE ,NONLANDBIT>>>
		<JIGS-UP
"Oh, no! You have walked into the slavering fangs of a lurking grue!">)
	       (T
		<TELL ,CANT-GO>
		<RFATAL>)>>

<ROUTINE V-WALK-AROUND ()
	 <TELL "Use compass directions for movement." CR>>

<ROUTINE V-WAVE ()
	 <HACK-HACK "Waving the ">>

<ROUTINE V-YELL ()
	 <TELL "Aaarrrggghhh!" CR>>

<ROUTINE V-ZORK ()
	 <TELL "At your service!" CR>>
\
;"describers"

<GLOBAL INDENTS
	<TABLE (PURE)
	       ""
	       "  "
	       "    "
	       "      "
	       "        "
	       "          ">>

<GLOBAL LIT <>>

<ROUTINE DESCRIBE-ROOM ("OPTIONAL" (VERB-IS-LOOK <>) "AUX" (V? <>) STR)
	 <COND (<OR .VERB-IS-LOOK
		    <EQUAL? ,VERBOSITY 2>>
		<SET V? T>)>
	 <COND (<NOT ,LIT>
		<TELL
"It is pitch black. You are likely to be eaten by a grue." CR>
		<RFALSE>)
	       (<NOT <FSET? ,HERE ,TOUCHBIT>>
		<FSET ,HERE ,TOUCHBIT>
		<SET V? T>)
	       (<FSET? ,HERE ,MAZEBIT>
		<SET V? T>)>
	 <TELL D ,HERE>
	 <COND (<IN? ,ADVENTURER ,INFLATED-BOAT>
		<TELL ", in the " D ,INFLATED-BOAT>)>
	 <CRLF>
	 <COND (<NOT .V?>
		<RTRUE>)
	       (<SET STR <GETP ,HERE ,P?LDESC>>
		<TELL .STR>)
	       (T
		<APPLY <GETP ,HERE ,P?ACTION> ,M-LOOK>)>
	 <CRLF>>

<ROUTINE DESCRIBE-OBJECTS ("OPTIONAL" (V? <>))
	 <COND (,LIT
		<COND (<FIRST? ,HERE>
		       <PRINT-CONT ,HERE
				   <SET V? <OR .V? <EQUAL? ,VERBOSITY 2>>>
				   -1>)>)
	       (T
		<TELL ,TOO-DARK>)>>

<GLOBAL DESC-OBJECT <>>

;"DESCRIBE-OBJECT -- takes object and flag.  if flag is true will print a
long description (fdesc or ldesc), otherwise will print short."
<ROUTINE DESCRIBE-OBJECT (OBJ V? LEVEL "AUX" (STR <>) AV)
	 <SETG DESC-OBJECT .OBJ>
	 <COND (<AND <0? .LEVEL>
		     <APPLY <GETP .OBJ ,P?DESCFCN> ,M-OBJDESC>>
		<RTRUE>)
	       (<AND <0? .LEVEL>
		     <OR <AND <NOT <FSET? .OBJ ,TOUCHBIT>>
			      <SET STR <GETP .OBJ ,P?FDESC>>>
			 <SET STR <GETP .OBJ ,P?LDESC>>>>
		<TELL .STR>)
	       (<0? .LEVEL>
		<TELL "There is a " D .OBJ " here">
		<COND (<FSET? .OBJ ,ONBIT>
		       <TELL " (providing light)">)>
		<TELL ".">)
	       (T
		<TELL <GET ,INDENTS .LEVEL>>
		<TELL "A " D .OBJ>
		<COND (<FSET? .OBJ ,ONBIT>
		       <TELL " (providing light)">)>)>
	 <CRLF>
	 <COND (<AND <SEE-INSIDE? .OBJ> <FIRST? .OBJ>>
		<PRINT-CONT .OBJ .V? .LEVEL>)>>

<ROUTINE PRINT-CONTENTS (OBJ "AUX" F N (1ST? T) (IT? <>) (TWO? <>))
	 <COND (<SET F <FIRST? .OBJ>>
		<REPEAT ()
			<SET N <NEXT? .F>>
			<COND (.1ST?
			       <SET 1ST? <>>)
			      (T
			       <TELL ", ">
			       <COND (<NOT .N>
				      <TELL "and ">)>)>
			<TELL "a " D .F>
			<COND (<AND <NOT .IT?>
				    <NOT .TWO?>>
			       <SET IT? .F>)
			      (T
			       <SET TWO? T>
			       <SET IT? <>>)>
			<SET F .N>
			<COND (<NOT .F>
			       <COND (<AND .IT?
					   <NOT .TWO?>>
				      <SETG P-IT-OBJECT .IT?>)>
			       <RTRUE>)>>)>>

<ROUTINE PRINT-CONT (OBJ "OPTIONAL" (V? <>) (LEVEL 0)
		     "AUX" Y 1ST? SHIT (AV <>) STR (PV? <>) (INV? <>))
	 <COND (<NOT <SET Y <FIRST? .OBJ>>>
		<RTRUE>)
	       (<IN? ,ADVENTURER ,INFLATED-BOAT>
		<SET AV <LOC ,WINNER>>)>
	 <SET 1ST? T>
	 <SET SHIT T>
	 <COND (<EQUAL? ,WINNER .OBJ <LOC .OBJ>>
		<SET INV? T>)
	       (T
		<REPEAT ()
			<COND (<NOT .Y>
			       <RETURN>)
			      (<EQUAL? .Y .AV>
			       <SET PV? T>)
			      (<EQUAL? .Y ,WINNER>
			       T)
			      (<AND <NOT <FSET? .Y ,INVISIBLE>>
				    <NOT <FSET? .Y ,TOUCHBIT>>
				    <SET STR <GETP .Y ,P?FDESC>>>
			       <COND (<NOT <FSET? .Y ,NDESCBIT>>
				      <TELL .STR CR>
				      <SET SHIT <>>)>
			       <COND (<AND <SEE-INSIDE? .Y>
					   <NOT <GETP <LOC .Y> ,P?DESCFCN>>
					   <FIRST? .Y>>
				      <COND (<PRINT-CONT .Y .V? 0>
					     <SET 1ST? <>>)>)>)>
			<SET Y <NEXT? .Y>>>)>
	 <SET Y <FIRST? .OBJ>>
	 <REPEAT ()
		 <COND (<NOT .Y>
			<COND (<AND .PV? .AV <FIRST? .AV>>
			       <SET LEVEL <+ .LEVEL 1>>
			       <PRINT-CONT .AV .V? .LEVEL>)>
			<RETURN>)
		       (<EQUAL? .Y .AV ,ADVENTURER>
			T)
		       (<AND <NOT <FSET? .Y ,INVISIBLE>>
			     <OR .INV?
				 <FSET? .Y ,TOUCHBIT>
				 <NOT <GETP .Y ,P?FDESC>>>>
			<COND (<NOT <FSET? .Y ,NDESCBIT>>
			       <COND (.1ST?
				      <COND (<FIRSTER .OBJ .LEVEL>
					     <COND (<L? .LEVEL 0>
						    <SET LEVEL 0>)>)>
				      <SET LEVEL <+ 1 .LEVEL>>
				      <SET 1ST? <>>)>
			       <COND (<L? .LEVEL 0>
				      <SET LEVEL 0>)>
			       <DESCRIBE-OBJECT .Y .V? .LEVEL>)
			      (<AND <FIRST? .Y>
				    <SEE-INSIDE? .Y>>
			       <SET LEVEL <+ .LEVEL 1>>
			       <PRINT-CONT .Y .V? .LEVEL>
			       <SET LEVEL <- .LEVEL 1>>)>)>
		 <SET Y <NEXT? .Y>>>
	 <COND (<AND .1ST? .SHIT>
		<RFALSE>)
	       (T
		<RTRUE>)>>

<ROUTINE FIRSTER (OBJ LEVEL)
	 <COND (<EQUAL? .OBJ ,TROPHY-CASE>
		<TELL "Your treasures include:" CR>)
	       (<EQUAL? .OBJ ,WINNER>
		<TELL "You have:" CR>)
	       (<NOT <IN? .OBJ ,ROOMS>>
		<COND (<G? .LEVEL 0>
		       <TELL <GET ,INDENTS .LEVEL>>)>
		<COND (<FSET? .OBJ ,SURFACEBIT>
		       <TELL "Sitting on the " D .OBJ " is:" CR>)
		      (<FSET? .OBJ ,ACTORBIT>
		       <TELL "The " D .OBJ " is holding:" CR>)
		      (T
		       <TELL "The " D .OBJ " contains:" CR>)>)>>

<ROUTINE SEE-INSIDE? (OBJ)
	 <AND <NOT <FSET? .OBJ ,INVISIBLE>>
	      <OR <FSET? .OBJ ,TRANSBIT> <FSET? .OBJ ,OPENBIT>>>>
\
;"death"

<GLOBAL DEAD <>>

<GLOBAL DEATHS 0>

<ROUTINE JIGS-UP (DESC)
 	 <SETG WINNER ,ADVENTURER>
	 <TELL .DESC>
	 <COND (<NOT ,LUCKY>
		<TELL " Bad luck, huh?">)>
	 <CRLF>
	 <COND (,DEAD
		<TELL "|
Congratulations. It's not easy to be killed while already dead." CR>
		<FINISH>)>
	 <PROG ()
	       <SETG SCORE <- ,SCORE 10>>
	       <TELL "
|    ****  You have died  ****
|
|">
	       <MOVE ,WINNER ,HERE>
	       <COND (<NOT <L? ,DEATHS 2>>
		      <TELL
"You clearly are a suicidal maniac. Your remains will be put in Hades for your
fellow adventurers to gloat over." CR>
		      <FINISH>)
		     (T
		      <SETG DEATHS <+ ,DEATHS 1>>
		      <MOVE ,WINNER ,HERE>
		      <COND (<FSET? ,ALTAR ,TOUCHBIT>
			     <TELL
"You feel relieved of your burdens and find yourself before the gates of Hell">
			     <COND (<NOT ,HADES-FLAG>
				    <TELL
", where the spirits jeer and deny you entry">)>
			     <TELL
". Your senses are disturbed. Objects around you appear indistinct,
bleached of color, even unreal." CR CR>
			     <SETG DEAD T>
			     <SETG TROLL-FLAG T>
			     <PUTP ,WINNER ,P?ACTION DEAD-FUNCTION>
			     <GOTO ,ENTRANCE-TO-HADES>)
			    (T
			     <TELL
"Well, you probably deserve another chance. I can't quite fix you up
completely, but you can't have everything." CR CR>
			     <FCLEAR ,TRAP-DOOR ,TOUCHBIT>
			     <GOTO ,FOREST-EDGE>)>
		      <SETG P-CONT <>>
		      <RANDOMIZE-OBJECTS>
		      <KILL-INTERRUPTS>
		      <RFATAL>)>>>

<ROUTINE RANDOMIZE-OBJECTS ("AUX" (R <FIRST? ,ROOMS>) F N)
	 <COND (<IN? ,LAMP ,WINNER>
		<MOVE ,LAMP ,LIVING-ROOM>)>
	 <COND (<IN? ,COFFIN ,WINNER>
		<MOVE ,COFFIN ,EGYPTIAN-ROOM>)>
	 <SET N <FIRST? ,WINNER>>
	 <REPEAT ()
		 <SET F .N>
		 <COND (<NOT .F>
			<RETURN>)>
		 <SET N <NEXT? .F>>
		 <COND (<FSET? .F ,TREASUREBIT>
			<REPEAT ()
				<COND (<AND <FSET? .R ,RLANDBIT>
					    <NOT <FSET? .R ,ONBIT>>
					    <PROB 50>>
				       <MOVE .F .R>
				       <RETURN>)
				      (T
				       <SET R <NEXT? .R>>)>>)
		       (T
			<MOVE .F <GET ,ABOVE-GROUND-ROOMS <RANDOM 7>>>)>>>

<GLOBAL ABOVE-GROUND-ROOMS
	<TABLE
	 <>
	 NORTH-OF-HOUSE
	 FOREST-PATH
	 BEHIND-HOUSE
	 FOREST-EDGE
	 FOREST-NORTH
	 FOREST-SOUTH
	 CANYON-VIEW>>

<ROUTINE KILL-INTERRUPTS ()
	 <DISABLE <INT I-XB>>
	 <DISABLE <INT I-XC>>
	 <DISABLE <INT I-CYCLOPS>>
	 <DISABLE <INT I-LANTERN>>
	 <DISABLE <INT I-CANDLES>>
	 <DISABLE <INT I-MATCH>>
	 <FCLEAR ,MATCH ,ONBIT>
	 <RTRUE>>

<ROUTINE DEAD-FUNCTION ("OPTIONAL" (FOO <>) "AUX" M)
	 <COND (<VERB? WALK>
		<COND (<AND <EQUAL? ,HERE ,LADDER-ROOM>
			    <EQUAL? ,PRSO ,P?WEST>>
		       <TELL "The draft blows you back." CR>)>)
	       (<VERB? BRIEF VERBOSE SUPER-BRIEF VERSION SAVE RESTORE
		       QUIT RESTART>
		<RFALSE>)
	       (<VERB? ATTACK MUNG ALARM SWING>
		<TELL "Attacks are vain in your condition." CR>)
	       (<VERB? OPEN CLOSE EAT DRINK INFLATE DEFLATE TURN BURN
		       TIE UNTIE RUB>
		<TELL "Such action is beyond your capabilities." CR>)
	       (<VERB? WAIT>
		<TELL "Might as well. You've got an eternity." CR>)
	       (<VERB? LAMP-ON>
		<TELL "You need no light to guide you." CR>)
	       (<VERB? SCORE>
		<TELL "You're dead! How can you think of your score?" CR>)
	       (<VERB? TAKE RUB>
		<TELL "Your hand passes through it." CR>)
	       (<VERB? DROP THROW INVENTORY>
		<TELL "You have no possessions." CR>)
	       (<VERB? DIAGNOSE>
		<TELL "You are dead." CR>)
	       (<VERB? LOOK>
		<TELL "The room looks unearthly">
		<COND (<NOT <FIRST? ,HERE>>
		       <TELL ".">)
		      (T
		       <TELL " and objects appear indistinct.">)>
		<COND (<NOT <FSET? ,HERE ,ONBIT>>
		       <TELL
" Although there is no light, the room seems dimly illuminated.">)>
		<CRLF> <CRLF>
		<RFALSE>)
	       (<VERB? PRAY>
		<COND (<EQUAL? ,HERE ,ALTAR>
		       <FCLEAR ,LAMP ,INVISIBLE>
		       <PUTP ,WINNER ,P?ACTION 0>
		       <SETG DEAD <>>
		       <COND (<IN? ,TROLL ,TROLL-ROOM>
			      <SETG TROLL-FLAG <>>)>
		       <TELL
"The sound of a distant trumpet is heard. You find yourself in the
woods, rising as if from a long sleep. A breeze rustles the treetops;
then, all is still." CR CR>
		       <GOTO ,FOREST-EDGE>)
		      (T
		       <TELL "Your prayers are not heard." CR>)>)
	       (T
		<TELL ,YOU-CANT "even do that." CR>
		<SETG P-CONT <>>
		<RFATAL>)>>
\
;"object manipulation"

<CONSTANT FUMBLE-NUMBER 7>

<CONSTANT FUMBLE-PROB 8>

<ROUTINE ITAKE ("OPTIONAL" (VB T) "AUX" CNT OBJ LOAD-ALLOWED)
	 <SET LOAD-ALLOWED <- 100 <* <- 6 <GETP ,ADVENTURER ,P?STRENGTH>> 10>>>
	 <COND (,DEAD
		<COND (.VB
		       <TELL "Your hand passes through it." CR>)>
		<RFALSE>)
	       (<NOT <FSET? ,PRSO ,TAKEBIT>>
		<COND (.VB
		       <TELL <PICK-ONE ,YUKS> CR>)>
		<RFALSE>)
	       (<AND <EQUAL? ,HERE ,THIEFS-LAIR>
		     <IN? ,THIEF ,HERE>
		     <FSET? ,PRSO ,TREASUREBIT>>
		<COND (.VB
		       <TELL "The thief doesn't let you near." CR>)>
		<RFALSE>)
	       (<AND <FSET? <LOC ,PRSO> ,CONTBIT>
		     <NOT <FSET? <LOC ,PRSO> ,OPENBIT>>>
		;"Kludge for parser calling itake"
		<RFALSE>)
	       (<AND <NOT <IN? <LOC ,PRSO> ,WINNER>>
		     <G? <+ <WEIGHT ,PRSO> <WEIGHT ,WINNER>> .LOAD-ALLOWED>>
		<COND (.VB
		       <TELL "Your load is too heavy">
		       <COND (<L? .LOAD-ALLOWED 100>
			      <TELL", especially in light of your condition">)>
		       <TELL ,PERIOD-CR>)>
		<RFATAL>)
	       (<AND <VERB? TAKE>
		     <G? <SET CNT <CCOUNT ,WINNER>> ,FUMBLE-NUMBER>
		     <PROB <* .CNT ,FUMBLE-PROB>>>
		<TELL "You're holding too many things already!" CR>
		<RFALSE>)
	       (T
		<MOVE ,PRSO ,WINNER>
		<FCLEAR ,PRSO ,NDESCBIT>
		<FSET ,PRSO ,TOUCHBIT>
		<SCORE-OBJ ,PRSO>
		<RTRUE>)>>

<ROUTINE IDROP ()
	 <COND (<AND <NOT <IN? ,PRSO ,WINNER>>
		     <NOT <IN? <LOC ,PRSO> ,WINNER>>>
		<TELL ,YNH "the " D ,PRSO ,PERIOD-CR>
		<RFALSE>)
	       (<AND <NOT <IN? ,PRSO ,WINNER>>
		     <NOT <FSET? <LOC ,PRSO> ,OPENBIT>>>
		<TELL "The " D ,PRSO " is closed." CR>
		<RFALSE>)
	       (T
		<MOVE ,PRSO <LOC ,WINNER>>
		<RTRUE>)>>

<ROUTINE CCOUNT (OBJ "AUX" (CNT 0) X)
	 <COND (<SET X <FIRST? .OBJ>>
		<REPEAT ()
			<SET CNT <+ .CNT 1>>
			<COND (<NOT <SET X <NEXT? .X>>>
			       <RETURN>)>>)>
	 .CNT>

<ROUTINE WEIGHT (OBJ "AUX" CONT (WT 0))
	 <COND (<SET CONT <FIRST? .OBJ>>
		<REPEAT ()
			<SET WT <+ .WT <WEIGHT .CONT>>>
			<COND (<NOT <SET CONT <NEXT? .CONT>>> <RETURN>)>>)>
	 <+ .WT <GETP .OBJ ,P?SIZE>>>
\
;"movement stuff"

<CONSTANT REXIT 0>
<CONSTANT UEXIT 1>
<CONSTANT NEXIT 2>
<CONSTANT FEXIT 3>
<CONSTANT CEXIT 4>
<CONSTANT DEXIT 5>

<CONSTANT NEXITSTR 0>
<CONSTANT FEXITFCN 0>
<CONSTANT CEXITFLAG 1>
<CONSTANT CEXITSTR 1>
<CONSTANT DEXITOBJ 1>
<CONSTANT DEXITSTR 1>

<ROUTINE GOTO (RM "OPTIONAL" (V? T) "AUX" (WLOC <LOC ,WINNER>) OLIT OHERE)
	 <SET OLIT ,LIT>
	 <SET OHERE ,HERE>
	 <COND (<AND <FSET? .RM ,NONLANDBIT>
		     <NOT <IN? ,ADVENTURER ,INFLATED-BOAT>>>
		<TELL ,YOU-CANT "go there without a boat." CR>
		<RFALSE>)
	       (<AND <FSET? .RM ,RLANDBIT>
		     <FSET? ,HERE ,RLANDBIT>
		     <IN? ,ADVENTURER ,INFLATED-BOAT>>
		<TELL "You'll have to get out of the raft first." CR>
		<RFALSE>)
	       (T
		<COND (<AND <IN? ,ADVENTURER ,INFLATED-BOAT>
			    <NOT <FSET? ,HERE ,RLANDBIT>>
			    <FSET? .RM ,RLANDBIT>
			    <NOT ,DEAD>>
		       <TELL
"The " D .WLOC " comes to a rest on the shore." CR CR>)>
		<COND (<IN? ,ADVENTURER ,INFLATED-BOAT>
		       <MOVE .WLOC .RM>)
		      (T
		       <MOVE ,WINNER .RM>)>
		<SETG HERE .RM>
		<SETG LIT <LIT? ,HERE>>
		<COND (<AND <NOT .OLIT>
			    <NOT ,LIT>
			    <PROB 80>>
		       <TELL "Oh, no! A lurking grue slithered into the ">
		       <COND (<IN? ,ADVENTURER ,INFLATED-BOAT>
			      <TELL D <LOC ,WINNER>>)
			     (T
			      <TELL "room">)>
		       <JIGS-UP " and devoured you!">
		       <RTRUE>)>
		<COND (<AND <NOT ,LIT>
			    <EQUAL? ,WINNER ,ADVENTURER>>
		       <TELL "You have moved into a dark place." CR>
		       <SETG P-CONT <>>)>
		<APPLY <GETP ,HERE ,P?ACTION> ,M-ENTER>
		<SCORE-OBJ .RM>
		<COND (<NOT <EQUAL? ,HERE .RM>>
		       <RTRUE>)
		      ;(<AND <NOT <EQUAL? ,ADVENTURER ,WINNER>>
			    <IN? ,ADVENTURER .OHERE>>
		       <TELL "The " D ,WINNER " leaves the room." CR>)
		      (<AND <EQUAL? ,HERE .OHERE> ;"no double description"
			    <EQUAL? ,HERE ,ENTRANCE-TO-HADES>>
		       <RTRUE>)
		      (<AND .V?
			    <EQUAL? ,WINNER ,ADVENTURER>
			    <DESCRIBE-ROOM>
			    <G? ,VERBOSITY 0>>
		       <DESCRIBE-OBJECTS>)>
		<RTRUE>)>>

<ROUTINE DO-WALK (DIR)
	 <SETG P-WALK-DIR .DIR>
	 <PERFORM ,V?WALK .DIR>
	 <RTRUE>>