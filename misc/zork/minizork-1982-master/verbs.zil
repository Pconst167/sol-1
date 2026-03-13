"SUBTITLE VERB FUNCTIONS"

"SUBTITLE DESCRIBE THE UNIVERSE"

"SUBTITLE SETTINGS FOR VARIOUS LEVELS OF DESCRIPTION"

<GLOBAL VERBOSE <>>
<GLOBAL SUPER-BRIEF <>>
<GDECL (VERBOSE SUPER-BRIEF) <OR ATOM FALSE>>

<ROUTINE V-VERBOSE ()
	 <SETG VERBOSE T>
	 <SETG SUPER-BRIEF <>>
	 <TELL "Maximum verbosity." CR>>

<ROUTINE V-BRIEF ()
	 <SETG VERBOSE <>>
	 <SETG SUPER-BRIEF <>>
	 <TELL "Brief descriptions." CR>>

<ROUTINE V-SUPER-BRIEF ()
	 <SETG SUPER-BRIEF T>
	 <TELL "Super-brief descriptions." CR>>

\

"SUBTITLE DESCRIBERS"

<ROUTINE V-LOOK ()
	 <COND (<DESCRIBE-ROOM T>
		<DESCRIBE-OBJECTS T>)>>

<ROUTINE V-FIRST-LOOK ()
	 <COND (<DESCRIBE-ROOM>
		<COND (<NOT ,SUPER-BRIEF> <DESCRIBE-OBJECTS>)>)>>

<ROUTINE V-EXAMINE ()
	 <COND (<GETP ,PRSO ,P?TEXT>
		<TELL <GETP ,PRSO ,P?TEXT> CR>)
	       (<OR <FSET? ,PRSO ,CONTBIT>
		    <FSET? ,PRSO ,DOORBIT>>
		<V-LOOK-INSIDE>)
	       (ELSE
		<TELL "There's nothing unusual about it." CR>)>>

<ROUTINE DESCRIBE-ROOM ("OPTIONAL" (LOOK? <>) "AUX" V? STR)
	 <SET V? <OR .LOOK? ,VERBOSE>>
	 <COND (<NOT ,LIT>
		<TELL 
"It is pitch black.  You are likely to be eaten by a grue." CR>
		<RETURN <>>)>
	 <COND (<OR <NOT <FSET? ,HERE ,TOUCHBIT>>
		    <FSET? ,HERE ,MAZEBIT>>
		<FSET ,HERE ,TOUCHBIT>
		<SET V? T>)>
	 <TELL D ,HERE CR>
	 <COND (<OR .LOOK? <NOT ,SUPER-BRIEF>>
		<COND (<FSET? <LOC ,WINNER> ,VEHBIT>
		       <TELL "(You are in the " D <LOC ,WINNER> ".)" CR>)>
		<COND (<AND .V? <APPLY <GETP ,HERE ,P?ACTION> ,M-LOOK>>
		       <RTRUE>)
		      (<AND .V? <SET STR <GETP ,HERE ,P?LDESC>>>
		       <TELL .STR CR>)>)>
	 T>

<ROUTINE DESCRIBE-OBJECTS ("OPTIONAL" (V? <>))
	 <COND (,LIT
		<COND (<FIRST? ,HERE>
		       <PRINT-CONT ,HERE <SET V? <OR .V? ,VERBOSE>> -1>)>)
	       (ELSE
		<TELL "I can't see in the dark." CR>)>>

"DESCRIBE-OBJECT -- takes object and flag.  if flag is true will print a
long description (fdesc or ldesc), otherwise will print short."

<ROUTINE DESCRIBE-OBJECT (OBJ V? LEVEL "AUX" (STR <>) AV)
	 <COND (<0? .LEVEL>
		<COND (<OR <AND <NOT <FSET? .OBJ ,TOUCHBIT>>
				<SET STR <GETP .OBJ ,P?FDESC>>>
			   <SET STR <GETP .OBJ ,P?LDESC>>>
		       <TELL .STR>)
		      (T <TELL "There is a " D .OBJ " here.">)>)
	       (ELSE
		<TELL <GET ,INDENTS .LEVEL>>
		<TELL "A " D .OBJ>)>
	 <COND (<AND <0? .LEVEL>
		     <SET AV <LOC ,WINNER>>
		     <FSET? .AV ,VEHBIT>
		     <IN? .OBJ ,HERE>>
		<TELL " (outside the " D .AV ")">)>
	 <CRLF>
	 <COND (<AND <SEE-INSIDE? .OBJ> <FIRST? .OBJ>>
		<PRINT-CONT .OBJ .V? .LEVEL>)>>

<ROUTINE PRINT-CONT (OBJ "OPTIONAL" (V? <>) (LEVEL 0)
		     "AUX" Y 1ST? AV STR (PV? <>) (INV? <>))
	 #DECL ((OBJ) OBJECT (LEVEL) FIX)
	 <COND (<NOT <SET Y <FIRST? .OBJ>>> <RTRUE>)>
	 <COND (<AND <SET AV <LOC ,WINNER>> <FSET? .AV ,VEHBIT>>
		T)
	       (ELSE <SET AV <>>)>
	 <SET 1ST? T>
	 <COND (<EQUAL? ,WINNER .OBJ <LOC .OBJ>>
		<SET INV? T>)
	       (ELSE
		<REPEAT ()
			<COND (<NOT .Y> <RETURN <NOT .1ST?>>)
			      (<==? .Y .AV> <SET PV? T>)
			      (<==? .Y ,WINNER>)
			      (<AND <NOT <FSET? .Y ,INVISIBLE>>
				    <NOT <FSET? .Y ,TOUCHBIT>>
				    <SET STR <GETP .Y ,P?FDESC>>>
			       <COND (<NOT <FSET? .Y ,NDESCBIT>>
				      <TELL .STR CR>)>
			       <COND (<AND <SEE-INSIDE? .Y> <FIRST? .Y>>
				      <PRINT-CONT .Y .V? 0>)>)>
			<SET Y <NEXT? .Y>>>)>
	 <SET Y <FIRST? .OBJ>>
	 <REPEAT ()
		 <COND (<NOT .Y>
			<COND (<AND .PV? .AV <FIRST? .AV>>
			       <SET LEVEL <+ .LEVEL 1>>
			       <PRINT-CONT .AV .V? .LEVEL>)> 
			<RETURN <NOT .1ST?>>)
		       (<EQUAL? .Y .AV ,ADVENTURER>)
		       (<AND <NOT <FSET? .Y ,INVISIBLE>>
			     <OR .INV?
				 <FSET? .Y ,TOUCHBIT>
				 <NOT <GETP .Y ,P?FDESC>>>>
			<COND (<NOT <FSET? .Y ,NDESCBIT>>
			       <COND (.1ST?
				      <FIRSTER .OBJ .LEVEL>
				      <SET LEVEL <+ 1 .LEVEL>>
				      <SET 1ST? <>>)>
			       <DESCRIBE-OBJECT .Y .V? .LEVEL>)
			      (<FIRST? .Y>
			       <SET LEVEL <+ .LEVEL 1>>
			       <PRINT-CONT .Y .V? .LEVEL>)>)>
		 <SET Y <NEXT? .Y>>>>

<ROUTINE FIRSTER (OBJ LEVEL)
	 <COND (<==? .OBJ ,TROPHY-CASE>
		<TELL "Your treasures are:" CR>)
	       (<==? .OBJ ,WINNER>
		<TELL "You are carrying:" CR>)
	       (<NOT <IN? .OBJ ,ROOMS>>
		<COND (<G? .LEVEL 0>
		       <TELL <GET ,INDENTS .LEVEL>>)>
		<COND (<FSET? .OBJ ,SURFACEBIT>
		       <TELL "Sitting on the " D .OBJ
			     " is: " CR>)
		      (ELSE
		       <TELL "The " D .OBJ
			     " contains:" CR>)>)>>

\

"SUBTITLE SCORING"

<GLOBAL MOVES 0>
<GLOBAL SCORE 0>
<GLOBAL BASE-SCORE 0>

<ROUTINE SCORE-UPD (NUM)
	 #DECL ((NUM) FIX)
	 <SETG BASE-SCORE <+ ,BASE-SCORE .NUM>>
	 <SETG SCORE <+ ,SCORE .NUM>>
	 <COND (<AND <NOT <L? ,SCORE ,SCORE-MAX>> <NOT ,WON-FLAG>>
		<SETG WON-FLAG T>
		<FCLEAR ,MAP ,INVISIBLE>
		<FCLEAR ,WEST-OF-HOUSE ,TOUCHBIT>
		<TELL
"An almost inaudible voice whispers in your ear, \"Look to your treasures
for the final secret.\"" CR>)>
	 T>

<ROUTINE SCORE-OBJ (OBJ "AUX" TEMP)
	 #DECL ((OBJ) OBJECT (TEMP) FIX)
	 <COND (<G? <SET TEMP <GETP .OBJ ,P?VALUE>> 0>
		<SCORE-UPD .TEMP>
		<PUTP .OBJ ,P?VALUE 0>)>>

<GLOBAL SCORE-MAX 350>

<ROUTINE V-SCORE ("OPTIONAL" (ASK? T))
	 #DECL ((ASK?) <OR ATOM FALSE>)
	 <TELL "Your score is ">
	 <TELL N ,SCORE>
	 <TELL " (total of ">
	 <TELL N ,SCORE-MAX>
	 <TELL " points), in ">
	 <TELL N ,MOVES>
	 <COND (<1? ,MOVES> <TELL " move.">) (ELSE <TELL " moves.">)>
	 <CRLF>>

<ROUTINE FINISH ()
	 <V-SCORE>
	 <QUIT>>

<ROUTINE V-QUIT ("OPTIONAL" (ASK? T) "AUX" SCOR)
	 #DECL ((ASK?) <OR ATOM <PRIMTYPE LIST>> (SCOR) FIX)
	 <V-SCORE>
	 <COND (<OR <AND .ASK?
			 <TELL 
"Do you wish to leave the game? (Y/N): ">
			 <YES?>>
		    <NOT .ASK?>>
		<QUIT>)
	       (ELSE <TELL "Ok." CR>)>>

<ROUTINE YES? ()
	 <PRINTI ">">
	 <READ ,P-INBUF ,P-LEXV>
	 <COND (<EQUAL? <GET ,P-LEXV 1> ,W?YES ,W?Y>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<GLOBAL COPYRIGHT-YEAR 1982>

<ROUTINE V-VERSION ("AUX" (CNT 17)) 
	 <TELL 
"ZORK: The Great Underground Empire|
Copyright " N ,COPYRIGHT-YEAR " by Infocom, Inc.|
All rights reserved.|
ZORK is a trademark of Infocom, Inc.|
Release ">
	 <PRINTN <BAND <GET 0 1> *3777*>>
	 <CRLF>>

<ROUTINE V-AGAIN ("AUX" OBJ)
	 <SET OBJ
	      <COND (<AND ,L-PRSO <NOT <LOC ,L-PRSO>>>
		     ,L-PRSO)
		    (<AND ,L-PRSI <NOT <LOC ,L-PRSI>>>
		     ,L-PRSI)>>
	 <COND (.OBJ
		<TELL "I can't see the " D .OBJ " anymore." CR>
		<RFATAL>)
	       (T
		<PERFORM ,L-PRSA ,L-PRSO ,L-PRSI>)>> 

\

"SUBTITLE DEATH AND TRANSFIGURATION"

<GLOBAL DEAD <>>
<GLOBAL DEATHS 0>

<ROUTINE JIGS-UP (DESC "OPTIONAL" (PLAYER? <>))
 	 #DECL ((DESC) STRING (PLAYER?) <OR ATOM FALSE>)
 	 <TELL .DESC CR>
	 <PROG ()
	       <SCORE-UPD -10>
	       <TELL "
|    ****  You have died  ****
|
|">
	       <COND
		(<NOT <L? ,DEATHS 2>>
		 <TELL
"You clearly are a suicidal maniac.  We don't allow psychotics in the
cave, since they may harm other adventurers.  Sorry." CR>
		 <FINISH>)
		(T
		 <SETG DEATHS <+ ,DEATHS 1>>
		 <MOVE ,WINNER ,HERE>
		 <TELL  
"Now, let's take a look here...|
Well, you probably deserve another chance.  I can't quite fix you
up completely, but you can't have everything." CR>
		 <FCLEAR ,TRAP-DOOR ,TOUCHBIT>
		 <SETG P-CONT <>>
		 <RANDOMIZE-OBJECTS>
		 <KILL-INTERRUPTS>)>>>

<ROUTINE KILL-INTERRUPTS ()
	 <DISABLE <INT I-XB>>
	 <DISABLE <INT I-XC>>
	 <DISABLE <INT I-CYCLOPS>>
	 <DISABLE <INT I-LANTERN>>
	 <DISABLE <INT I-SWORD>>
	 <DISABLE <INT I-FOREST-ROOM>>
	 <RTRUE>>

<ROUTINE RANDOMIZE-OBJECTS ("AUX" (R <>) F N L)
	 <COND (<IN? ,LAMP ,WINNER>
		<MOVE ,LAMP ,LIVING-ROOM>)>
	 <COND (<IN? ,COFFIN ,WINNER>
		<MOVE ,COFFIN ,EGYPT-ROOM>)>
	 <PUTP ,SWORD ,P?TVALUE 0>
	 <SET N <FIRST? ,WINNER>>
	 <SET L <GET ,ABOVE-GROUND 0>>
	 <REPEAT ()
		 <SET F .N>
		 <COND (<NOT .F> <RETURN>)>
		 <SET N <NEXT? .F>>
		 <COND (<G? <GETP .F ,P?TVALUE> 0>
			<REPEAT ()
				<COND (<NOT .R> <SET R <FIRST? ,ROOMS>>)>
				<COND (<AND <FSET? .R ,RLANDBIT>
					    <NOT <FSET? .R ,ONBIT>>
					    <PROB 50>>
				       <MOVE .F .R>
				       <RETURN>)
				      (ELSE <SET R <NEXT? .R>>)>>)
		       (ELSE
			<MOVE .F <GET ,ABOVE-GROUND <RANDOM .L>>>)>>>

<ROUTINE V-RESTORE ()
	 <COND (<RESTORE>
		<TELL "Ok." CR>
		<V-FIRST-LOOK>)
	       (T
		<TELL "Failed." CR>)>>

<ROUTINE V-SAVE ()
	 <COND (<SAVE>
	        <TELL "Ok." CR>)
	       (T
		<TELL "Failed." CR>)>>

<ROUTINE V-RESTART ()
	 <V-SCORE T>
	 <TELL "Are you sure (Y/N): ">
	 <COND (<YES?>
		<RESTART>)>>

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

<ROUTINE V-WALK-AROUND ()
	 <TELL "Use directions to move." CR>>

<ROUTINE V-LAUNCH ()
	 <YUK>>

<ROUTINE YUK () <TELL <PICK-ONE ,YUKS> CR>>

<ROUTINE GO-NEXT (TBL "AUX" VAL)
	 #DECL ((TBL) TABLE (VAL) ANY)
	 <COND (<SET VAL <LKP ,HERE .TBL>>
		<GOTO .VAL>)>>

<ROUTINE LKP (ITM TBL "AUX" (CNT 0) (LEN <GET .TBL 0>))
	 #DECL ((ITM) ANY (TBL) TABLE (CNT LEN) FIX)
	 <REPEAT ()
		 <COND (<G? <SET CNT <+ .CNT 1>> .LEN>
			<RFALSE>)
		       (<==? <GET .TBL .CNT> .ITM>
			<COND (<==? .CNT .LEN> <RFALSE>)
			      (T
			       <RETURN <GET .TBL <+ .CNT 1>>>)>)>>>

<ROUTINE V-WALK ("AUX" PT PTS STR OBJ RM)
	 #DECL ((PT) <OR FALSE TABLE> (PTS) FIX (STR) <OR STRING FALSE>
		(OBJ) OBJECT (RM) <OR FALSE OBJECT>)
	 <COND (<SET PT <GETPT ,HERE ,PRSO>>
		<COND (<==? <SET PTS <PTSIZE .PT>> ,UEXIT>
		       <GOTO <GETB .PT ,REXIT>>)
		      (<==? .PTS ,NEXIT>
		       <TELL <GET .PT ,NEXITSTR> CR>
		       <RFATAL>)
		      (<==? .PTS ,FEXIT>
		       <COND (<SET RM <APPLY <GET .PT ,FEXITFCN>>>
			      <GOTO .RM>)
			     (T
			      <RFATAL>)>)
		      (<==? .PTS ,CEXIT>
		       <COND (<VALUE <GETB .PT ,CEXITFLAG>>
			      <GOTO <GETB .PT ,REXIT>>)
			     (<SET STR <GET .PT ,CEXITSTR>>
			      <TELL .STR CR>
			      <RFATAL>)
			     (T
			      <TELL "You can't go that way." CR>
			      <RFATAL>)>)
		      (<==? .PTS ,DEXIT>
		       <COND (<FSET? <SET OBJ <GETB .PT ,DEXITOBJ>> ,OPENBIT>
			      <GOTO <GETB .PT ,REXIT>>)
			     (<SET STR <GET .PT ,DEXITSTR>>
			      <TELL .STR CR>
			      <RFATAL>)
			     (T
			      <TELL "The " D .OBJ " is closed." CR>
			      <RFATAL>)>)>)
	       (<AND <NOT ,LIT>
		     <PROB 75>>
		<JIGS-UP 
"Oh, no!  You have walked into the fangs of a lurking grue!">) 
	       (T
		<TELL "You can't go that way." CR>
		<RFATAL>)>>

<ROUTINE V-INVENTORY ()
	 <COND (<FIRST? ,WINNER> <PRINT-CONT ,WINNER>)
	       (T <TELL "You are empty handed." CR>)>>

<GLOBAL INDENTS
	<TABLE "" "  " "    " "      ">>

\ 

<ROUTINE PRE-TAKE ()
	 <COND (<IN? ,PRSO ,WINNER> <TELL "You already have it." CR>)
	       (<AND <FSET? <LOC ,PRSO> ,CONTBIT>
		     <NOT <FSET? <LOC ,PRSO> ,OPENBIT>>>
		<TELL "I can't reach that." CR>
		<RTRUE>)
	       (,PRSI
		<COND (<AND <==? ,PRSI ,GROUND> <IN? ,PRSO ,HERE>>
		       <SETG PRSI <>>
		       <RFALSE>)
		      (<NOT <==? ,PRSI <LOC ,PRSO>>>
		       <TELL "It's not in that!" CR>)
		      (T
		       <SETG PRSI <>>
		       <RFALSE>)>)
	       (<==? ,PRSO <LOC ,WINNER>> <TELL "You're in it!" CR>)>>

<ROUTINE V-TAKE ()
	 <COND (<==? <ITAKE> T>
		<TELL "Taken." CR>)>>

<ROUTINE ITAKE ("OPTIONAL" (VB T) "AUX" CNT OBJ)
	 #DECL ((VB) <OR ATOM FALSE> (CNT) FIX (OBJ) OBJECT)
	 <COND (<NOT <FSET? ,PRSO ,TAKEBIT>>
		<COND (.VB <YUK>)>
		<RFALSE>)
	       (<AND <NOT <IN? <LOC ,PRSO> ,WINNER>>
		     <G? <+ <WEIGHT ,PRSO> <WEIGHT ,WINNER>> ,LOAD-ALLOWED>>
		<COND (.VB
		       <TELL "Your load is too heavy">
		       <COND (<L? ,LOAD-ALLOWED ,LOAD-MAX>
			      <TELL
", especially in light of your condition.">)
			     (ELSE <TELL ".">)>
		       <CRLF>)>
		<RFATAL>)
	       (<AND <G? <SET CNT <CCOUNT ,WINNER>> 7>
		     <PROB <* .CNT 8>>>
		<SET OBJ <FIRST? ,WINNER>>
		<SET OBJ <NEXT? .OBJ>>
		;"This must go!  Chomping compiler strikes again"
		<TELL "Oh, no.  The " D .OBJ
		      " slips from your arms while taking the "
		      D ,PRSO "
and both tumble to the ground." CR>
		<PERFORM ,V?DROP .OBJ>
		<RFATAL>)
	       (T
		<MOVE ,PRSO ,WINNER>
		<FSET ,PRSO ,TOUCHBIT>
		<SCORE-OBJ ,PRSO>
		<RTRUE>)>>

<ROUTINE PRE-PUT ()
	 <COND (<OR <IN? ,PRSO ,GLOBAL-OBJECTS>
		    <NOT <FSET? ,PRSO ,TAKEBIT>>>
		<YUK>)>>

<ROUTINE V-PUT ()
	 <COND (<OR <FSET? ,PRSI ,OPENBIT>
		    <OPENABLE? ,PRSI>
		    <FSET? ,PRSI ,VEHBIT>>)
	       (T
		<TELL "I can't do that." CR>
		<RTRUE>)>
	 <COND (<NOT <FSET? ,PRSI ,OPENBIT>>
		<TELL "The " D ,PRSI " isn't open." CR>)
	       (<==? ,PRSI ,PRSO>
		<YUK>)
	       (<IN? ,PRSO ,PRSI>
		<TELL "It's already there!" CR>)
	       (<G? <+ <- <WEIGHT ,PRSI> <GETP ,PRSI ,P?SIZE>>
		       <WEIGHT ,PRSO>>
		    <GETP ,PRSI ,P?CAPACITY>>
		<TELL "There's no room." CR>)
	       (<AND <NOT <HELD? ,PRSO>>
		     <FSET? ,PRSO ,TRYTAKEBIT>>
		<TELL "You don't have the " D ,PRSO "." CR>
		<RTRUE>)
	       (<AND <NOT <HELD? ,PRSO>>
		     <NOT <ITAKE>>>
		<RTRUE>)
	       (T
		<SCORE-OBJ ,PRSO>
		<MOVE ,PRSO ,PRSI>
		<FSET ,PRSO ,TOUCHBIT>
		<TELL "Done." CR>)>>

<ROUTINE PRE-DROP ()
	 <COND (<==? ,PRSO <LOC ,WINNER>>
		<PERFORM ,V?DISEMBARK ,PRSO>
		<RTRUE>)>>

<ROUTINE V-GIVE ()
	 <COND (<NOT <FSET? ,PRSI ,VICBIT>>
		<TELL "You can't give a " D ,PRSO " to a " D ,PRSI "!" CR>)
	       (<IDROP> <TELL "Given." CR>)>>

<ROUTINE V-SGIVE ()
	 <PERFORM ,V?GIVE ,PRSI ,PRSO>>

<ROUTINE V-DROP () <COND (<IDROP> <TELL "Dropped." CR>)>>

<ROUTINE V-THROW () <COND (<IDROP> <TELL "Thrown." CR>)>>

<ROUTINE V-OVERBOARD ("AUX" LOCN)
	 #DECL ((LOCN) OBJECT)
	 <COND (<==? ,PRSI ,OVERBOARD>
		<COND (<FSET? <SET LOCN <LOC ,WINNER>> ,VEHBIT>
		       <MOVE ,PRSO <LOC .LOCN>>
		       <TELL D ,PRSO " overboard!" CR>)
		      (ELSE <YUK>)>)
	       (T <TELL "Huh?" CR>)>>

<ROUTINE IDROP
	 ()
	 <COND (<AND <NOT <IN? ,PRSO ,WINNER>> <NOT <IN? <LOC ,PRSO> ,WINNER>>>
		<TELL "You're not carrying the " D ,PRSO "." CR>
		<RFALSE>)
	       (<AND <NOT <IN? ,PRSO ,WINNER>>
		     <NOT <FSET? <LOC ,PRSO> ,OPENBIT>>>
		<TELL "The " D ,PRSO " is closed." CR>
		<RFALSE>)
	       (T <MOVE ,PRSO <LOC ,WINNER>> <RTRUE>)>>

\ 

<ROUTINE V-OPEN ("AUX" F STR)
	 <COND (<NOT <FSET? ,PRSO ,CONTBIT>>
		<TELL "How does one open a " D ,PRSO "?" CR>)
	       (<NOT <==? <GETP ,PRSO ,P?CAPACITY> 0>>
		<COND (<FSET? ,PRSO ,OPENBIT> <TELL "It is already open." CR>)
		      (T
		       <FSET ,PRSO ,OPENBIT>
		       <COND (<OR <NOT <FIRST? ,PRSO>> <FSET? ,PRSO ,TRANSBIT>>
			      <TELL "Opened." CR>)
			     (<AND <SET F <FIRST? ,PRSO>>
				   <NOT <NEXT? .F>>
				   <SET STR <GETP .F ,P?FDESC>>>
			      <TELL "The " D ,PRSO " opens." CR>
			      <TELL .STR CR>)
			     (T
			      <TELL "Opening the " D ,PRSO " reveals ">
			      <PRINT-CONTENTS ,PRSO>
			      <TELL "." CR>)>)>)
	       (T <TELL "The " D ,PRSO " cannot be opened." CR>)>>

<ROUTINE PRINT-CONTENTS (OBJ "AUX" F N (1ST? T))
	 #DECL ((OBJ) OBJECT (F N) <OR FALSE OBJECT>)
	 <COND (<SET F <FIRST? .OBJ>>
		<REPEAT ()
			<SET N <NEXT? .F>>
			<COND (.1ST? <SET 1ST? <>>)
			      (ELSE
			       <TELL ", ">
			       <COND (<NOT .N> <TELL "and ">)>)>
			<TELL "a " D .F>
			<SET F .N>
			<COND (<NOT .F> <RETURN>)>>)>>

<ROUTINE V-CLOSE ()
	 <COND (<NOT <FSET? ,PRSO ,CONTBIT>>
		<TELL "You can't do that!" CR>)
	       (<FSET? ,PRSO ,OPENBIT>
		<TELL "Closed." CR>
		<FCLEAR ,PRSO ,OPENBIT>)
	       (T <TELL "It is already." CR>)>>

<ROUTINE CCOUNT (OBJ "AUX" (CNT 0) X)
	 <COND (<SET X <FIRST? .OBJ>>
		<REPEAT ()
			<SET CNT <+ .CNT 1>>
			<COND (<NOT <SET X <NEXT? .X>>>
			       <RETURN>)>>)>
	 .CNT>

"WEIGHT:  Get sum of SIZEs of supplied object, recursing to the nth level."

<ROUTINE WEIGHT
	 (OBJ "AUX" CONT (WT 0))
	 #DECL ((OBJ) OBJECT (CONT) <OR FALSE OBJECT> (WT) FIX)
	 <COND (<SET CONT <FIRST? .OBJ>>
		<REPEAT ()
			<SET WT <+ .WT <WEIGHT .CONT>>>
			<COND (<NOT <SET CONT <NEXT? .CONT>>> <RETURN>)>>)>
	 <+ .WT <GETP .OBJ ,P?SIZE>>>

<ROUTINE PRE-MOVE
	 ()
	 <COND (<NOT <IN? ,PRSO ,HERE>> <TELL "I don't juggle objects!" CR>)>>

<ROUTINE V-MOVE ()
	 <COND (<FSET? ,PRSO ,TAKEBIT>
		<TELL "Moving the " D ,PRSO " reveals nothing." CR>)
	       (T <TELL "You can't move the " D ,PRSO "." CR>)>>

<ROUTINE V-LAMP-ON
	 ()
	 <COND (<FSET? ,PRSO ,LIGHTBIT>
		<COND (<FSET? ,PRSO ,ONBIT> <TELL "It is already on." CR>)
		      (ELSE
		       <FSET ,PRSO ,ONBIT>
		       <TELL "The " D ,PRSO " is now on." CR>
		       <COND (<NOT ,LIT>
			      <SETG LIT <LIT? ,HERE>>
			      <V-LOOK>)>)>)
	       (T
		<TELL "You can't turn that on." CR>)>
	 <RTRUE>>

<ROUTINE V-LAMP-OFF
	 ()
	 <COND (<FSET? ,PRSO ,LIGHTBIT>
		<COND (<NOT <FSET? ,PRSO ,ONBIT>>
		       <TELL "It is already off." CR>)
		      (ELSE
		       <FCLEAR ,PRSO ,ONBIT>
		       <COND (,LIT
			      <SETG LIT <LIT? ,HERE>>)>
		       <TELL "The " D ,PRSO " is now off." CR>
		       <COND (<NOT <SETG LIT <LIT? ,HERE>>>
			      <TELL "It is now pitch black." CR>)>)>)
	       (ELSE <TELL "You can't turn that off." CR>)>
	 <RTRUE>>

<ROUTINE V-WAIT ("OPTIONAL" (NUM 3))
	 #DECL ((NUM) FIX)
	 <TELL "Time passes..." CR>
	 <REPEAT ()
		 <COND (<L? <SET NUM <- .NUM 1>> 0> <RETURN>)
		       (<CLOCKER> <RETURN>)>
		 <SETG MOVES <+ ,MOVES 1>>>
	 <SETG CLOCK-WAIT T>>

<ROUTINE PRE-BOARD
	 ("AUX" AV)
	 <SET AV <LOC ,WINNER>>
	 <COND (<FSET? ,PRSO ,VEHBIT>
		<COND (<NOT <IN? ,PRSO ,HERE>>
		       <TELL "The "
			     D
			     ,PRSO
			     " must be on the ground." CR>)
		      (<FSET? .AV ,VEHBIT>
		       <TELL "You are already in it!" CR>)
		      (T <RFALSE>)>)
	       (T <YUK>)>
	 <RFATAL>>

<ROUTINE V-BOARD
	 ("AUX" AV)
	 #DECL ((AV) OBJECT)
	 <TELL "You are now in the " D ,PRSO "." CR>
	 <MOVE ,WINNER ,PRSO>
	 <APPLY <GETP ,PRSO ,P?ACTION> ,M-ENTER>
	 <RTRUE>>

<ROUTINE V-DISEMBARK
	 ()
	 <COND (<NOT <==? <LOC ,WINNER> ,PRSO>>
		<TELL "You're not in that!" CR>
		<RFATAL>)
	       (<FSET? ,HERE ,RLANDBIT>
		<TELL "You are on your feet again." CR>
		<MOVE ,WINNER ,HERE>)
	       (T
		<TELL 
"You realize that getting out would probably be fatal." CR>
		<RFATAL>)>>

<ROUTINE V-BREATHE ()
	 <PERFORM ,V?INFLATE ,PRSO ,LUNGS>>

<ROUTINE GOTO (RM "OPTIONAL" (V? T)
	       "AUX" (LB <FSET? .RM ,RLANDBIT>) (WLOC <LOC ,WINNER>)
	             (AV <>) OLIT)
	 #DECL ((RM WLOC) OBJECT (LB) <OR ATOM FALSE> (AV) <OR FALSE FIX>)
	 <SET OLIT ,LIT>
	 <COND (<FSET? .WLOC ,VEHBIT>
		<SET AV <GETP .WLOC ,P?VTYPE>>)>
	 <COND (<OR <AND <NOT .LB> <OR <NOT .AV> <NOT <FSET? .RM .AV>>>>
		    <AND <FSET? ,HERE ,RLANDBIT>
			 .LB
			 .AV
			 <NOT <==? .AV ,RLANDBIT>>
			 <NOT <FSET? .RM .AV>>>>
		<COND (.AV <TELL "You can't go there in a " D .WLOC ".">)
		      (T <TELL "You can't go there without a vehicle.">)>
		<CRLF>
		<RFALSE>)
	       (<FSET? .RM ,RMUNGBIT> <TELL <GETP .RM ,P?LDESC> CR> <RFALSE>)
	       (T
		<COND (.AV <MOVE .WLOC .RM>)
		      (T
		       <MOVE ,WINNER .RM>)>
		<SETG HERE .RM>
		<SETG LIT <LIT? ,HERE>>
		<COND (<AND <NOT .OLIT> <NOT ,LIT> <PROB 75>>
		       <JIGS-UP 
"Oh, no!  A lurking grue slithered into the room and devoured you!">)
		      (ELSE
		       <COND (<NOT ,LIT>
			      <TELL
"You have moved into a dark place." CR>)>
		       <APPLY <GETP ,HERE ,P?ACTION> ,M-ENTER>
		       <SCORE-OBJ .RM>
		       <COND (.V? <V-FIRST-LOOK>)>
		       <RTRUE>)>)>>

<ROUTINE PRE-POUR-ON
	 ()
	 <COND (<==? ,PRSO ,WATER> <RFALSE>)
	       (T <TELL "You can't." CR> <RTRUE>)>>

<ROUTINE V-POUR-ON
	 ()
	 <REMOVE ,PRSO>
	 <COND (<FLAMING? ,PRSI>
		<COND (<==? ,PRSI ,TORCH>
		       <TELL "The water evaporates before it gets close.">)
		      (T <TELL "The " D ,PRSI " is extinguished.">)>
		<CRLF>
		<RTRUE>)
	       (T
		<TELL "The water spills over the "
		      D
		      ,PRSI
		      " and to the floor where it evaporates." CR>)>>

<ROUTINE PRE-FILL
	 ("AUX" T)
	 #DECL ((T) <OR FALSE TABLE>)
	 <COND (<AND <NOT ,PRSI> <SET T <GETPT ,HERE ,P?GLOBAL>>>
		<COND (<ZMEMQB ,GLOBAL-WATER .T <PTSIZE .T>>
		       <SETG PRSI ,GLOBAL-WATER>
		       <RFALSE>)
		      (T
		       <TELL ,NOFILL CR>
		       <RTRUE>)>)>
	 <COND (<NOT <EQUAL? ,PRSI ,WATER ,GLOBAL-WATER>>
		<PERFORM ,V?PUT ,PRSI ,PRSO>
		<RTRUE>)>>

<GLOBAL NOFILL "There is nothing to fill it with.">

<ROUTINE V-FILL ()
	 <COND (<NOT ,PRSI>
		<COND (<GLOBAL-IN? ,GLOBAL-WATER ,HERE>
		       <PERFORM ,V?FILL ,PRSO ,GLOBAL-WATER>)
		      (T
		       <TELL ,NOFILL CR>)>)
	       (T <YUK>)>>

<ROUTINE V-ODYSSEUS ()
	 <COND (<AND <==? ,HERE ,CYCLOPS-ROOM> <IN? ,CYCLOPS ,HERE>>
		<DISABLE <INT I-CYCLOPS>>
		<SETG CYCLOPS-FLAG T>
		<TELL 
"The cyclops, hearing the name of his father's deadly nemesis, flees the room
by knocking down the wall on the east of the room." CR>
		<SETG MAGIC-FLAG T>
		<FCLEAR ,CYCLOPS ,FIGHTBIT>
		<REMOVE ,CYCLOPS>)
	       (T <TELL "Wasn't he a sailor?" CR>)>>

<ROUTINE V-RING
	 ()
	 <COND (<==? ,PRSO ,BELL> <TELL "Ding, dong.">)
	       (ELSE <YUK>)>
	 <CRLF>>

<ROUTINE V-DRINK ()
	 <V-EAT>>

<ROUTINE V-EAT ("AUX" (EAT? <>) (DRINK? <>) (NOBJ <>))
	 #DECL ((NOBJ) <OR OBJECT FALSE> (EAT? DRINK?) <OR ATOM FALSE>)
	 <COND (<AND <SET EAT? <FSET? ,PRSO ,FOODBIT>> <IN? ,PRSO ,WINNER>>
		<COND (<VERB? DRINK> <TELL "How can I drink that?">)
		      (ELSE
		       <TELL "Thank you. It really hit the spot.">
		       <REMOVE ,PRSO>)>
		<CRLF>)
	       (<SET DRINK? <FSET? ,PRSO ,DRINKBIT>>
		<COND (<OR <IN? ,PRSO ,GLOBAL-OBJECTS>
			   <AND <SET NOBJ <LOC ,PRSO>>
				<IN? .NOBJ ,WINNER>
				<FSET? .NOBJ ,OPENBIT>>>
		       <TELL 
"Thank you very much.  I was rather thirsty." CR>
		       <REMOVE ,PRSO>)
		      (T <TELL "I can't get to it." CR>)>)
	       (<NOT <OR .EAT? .DRINK?>>
		<TELL "I don't think the "
		      D
		      ,PRSO
		      " would agree with you." CR>)>>

<ROUTINE V-LISTEN ()
	 <TELL "The " D ,PRSO " makes no sound." CR>>

<ROUTINE V-PRAY
	 ()
	 <COND (<==? ,HERE ,SOUTH-TEMPLE>
		<GOTO ,FOREST-1>)
	       (T
		<TELL
"Your prayers may be someday answered." CR>)>>

<ROUTINE V-LEAP
	 ("AUX" T S)
	 #DECL ((T) <OR FALSE TABLE>)
	 <COND (,PRSO
		<COND (<IN? ,PRSO ,HERE>
		       <COND (<FSET? ,PRSO ,VILLAIN>
			      <TELL "The "
				    D
				    ,PRSO
				    " is too big to jump over." CR>)
			     (T <YUK>)>)
		      (T <TELL "That would be a good trick." CR>)>)
	       (<SET T <GETPT ,HERE ,P?DOWN>>
		<SET S <PTSIZE .T>>
		<COND (<OR <==? .S 2>					 ;NEXIT
			   <AND <==? .S 4>				 ;CEXIT
				<NOT <VALUE <GETB .T 1>>>>>
		       <TELL "It would be suicidal." CR>)
		      (ELSE <V-SKIP>)>)
	       (ELSE <V-SKIP>)>>

<ROUTINE V-LEAVE () <PERFORM ,V?WALK ,P?OUT>>

<GLOBAL HS 0>

<ROUTINE V-HELLO
	 ()
	 <COND (,PRSO
		<COND (<==? ,PRSO ,SAILOR>
		       <SETG HS <+ ,HS 1>>
		       <COND (<0? <MOD ,HS 15>>
			      <TELL "You seem to be repeating yourself." CR>)
			     (ELSE <TELL "Nothing happens here." CR>)>)
		      (<FSET? ,PRSO ,VILLAIN>
		       <TELL "The "
			     D
			     ,PRSO
			     " bows to you." CR>)
		      (ELSE
		       <TELL 
"I think only schizophrenics say 'Hello' to a "
			     D
			     ,PRSO
			     "." CR>)>)
	       (ELSE <TELL "Good day." CR>)>>

<ROUTINE PRE-READ ()
	 <COND (<NOT ,LIT> <TELL "You can't read in the dark." CR>)>>

<ROUTINE V-READ ()
	 <COND (<NOT <FSET? ,PRSO ,READBIT>>
		<TELL "How can I read a " D ,PRSO "?" CR>)
	       (ELSE <TELL <GETP ,PRSO ,P?TEXT> CR>)>>

<ROUTINE V-LOOK-UNDER () <TELL "There is nothing but dust there." CR>>

<ROUTINE V-LOOK-BEHIND () <TELL "There is nothing behind the " D ,PRSO "." CR>>

<ROUTINE V-LOOK-INSIDE
	 ()
	 <COND (<FSET? ,PRSO ,DOORBIT>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <TELL "The "
			     D
			     ,PRSO
			     " is open, but I can't tell what's beyond it.">)
		      (ELSE <TELL "The " D ,PRSO " is closed.">)>
		<CRLF>)
	       (<FSET? ,PRSO ,CONTBIT>
		<COND (<SEE-INSIDE? ,PRSO>
		       <COND (<AND <FIRST? ,PRSO> <PRINT-CONT ,PRSO>>
			      <RTRUE>)
			     (T
			      <TELL "The " D ,PRSO " is empty." CR>)>)
		      (ELSE <TELL "The " D ,PRSO " is closed." CR>)>)
	       (ELSE <TELL "I can't look inside a " D ,PRSO "." CR>)>>

<ROUTINE SEE-INSIDE? (OBJ)
	 <AND <NOT <FSET? .OBJ ,INVISIBLE>>
	      <OR <FSET? .OBJ ,TRANSBIT> <FSET? .OBJ ,OPENBIT>>>>
<ROUTINE PRE-BURN ()
	 <COND (<FLAMING? ,PRSI> <RFALSE>)
	       (T <TELL "With a " D ,PRSI "??!?" CR>)>>

<ROUTINE V-BURN
	 ()
	 <COND (<FSET? ,PRSO ,BURNBIT>
		<COND (<IN? ,PRSO ,WINNER>
		       <REMOVE ,PRSO>
		       <TELL "The " D ,PRSO " catches fire." CR>
		       <JIGS-UP 
"Unfortunately, you were holding it at the time.">)
		      (T
		       <REMOVE ,PRSO>
		       <TELL "The " D ,PRSO " is consumed by fire." CR>)
		      (ELSE <TELL "You don't have that." CR>)>)
	       (T <TELL "You can't burn a " D ,PRSO "." CR>)>>

<ROUTINE PRE-TURN
	 ()
	 <COND (<NOT <FSET? ,PRSO ,TURNBIT>> <TELL "You can't turn that!" CR>)
	       (<NOT ,PRSI>
		<TELL "You need a tool." CR>)
	       (<NOT <FSET? ,PRSI ,TOOLBIT>>
		<TELL "You can't turn it with a " D ,PRSI "." CR>)>>

<ROUTINE V-TURN () <TELL "This has no effect." CR>>

<ROUTINE V-PUMP
	 ()
	 <COND (<AND ,PRSI <NOT <==? ,PRSI ,PUMP>>>
		<TELL "Pump it up with a " D ,PRSI "?" CR>)
	       (<IN? ,PUMP ,WINNER>
		<PERFORM ,V?INFLATE ,PRSO ,PUMP>)
	       (T <TELL "I really don't see how." CR>)>>

<ROUTINE V-INFLATE () <YUK>>

<ROUTINE V-DEFLATE () <YUK>>

<ROUTINE V-CUT ()
	 <COND (<FSET? ,PRSO ,VILLAIN>
		<PERFORM ,V?KILL ,PRSO ,PRSI>)
	       (<AND <FSET? ,PRSO ,BURNBIT>
		     <FSET? ,PRSI ,WEAPONBIT>>
		<REMOVE ,PRSO>
		<TELL "You slice it into tiny bits which disappear!" CR>)
	       (<NOT <FSET? ,PRSI ,WEAPONBIT>>
		<TELL "Not so sharp." CR>)
	       (T
		<YUK>)>>

<ROUTINE V-KILL ()
	 <IKILL "kill">>

<ROUTINE IKILL (STR)
	 #DECL ((STR) STRING)
	 <COND (<NOT ,PRSO> <TELL "There is nothing to " .STR "." CR>)
	       (<AND <NOT <FSET? ,PRSO ,VILLAIN>>
		     <NOT <FSET? ,PRSO ,VICBIT>>>
		<TELL "I've known weirdos, but fighting a "
		      D
		      ,PRSO
		      "?" CR>)
	       (<OR <NOT ,PRSI> <EQUAL? ,PRSI ,HANDS>>
		<TELL "Trying to "
		      .STR
		      " a "
		      D
		      ,PRSO
		      " with your hands is suicidal." CR>)
	       (<NOT <FSET? ,PRSI ,WEAPONBIT>>
		<TELL "Trying to "
		      .STR
		      " the "
		      D
		      ,PRSO
		      " with a "
		      D
		      ,PRSI
		      " is suicidal." CR>)
	       (ELSE <HERO-BLOW>)>>

<ROUTINE V-ATTACK () <IKILL "attack">>

<ROUTINE V-SWING ()
	 <COND (<NOT ,PRSI>
		<TELL "Whoosh!" CR>)
	       (T
		<PERFORM ,V?ATTACK ,PRSI ,PRSO>)>>

<ROUTINE V-KICK () <HACK-HACK "Kicking the ">>

<ROUTINE V-WAVE () <HACK-HACK "Waving the ">>

<ROUTINE V-RAISE () <HACK-HACK "Playing in this way with the ">>

<ROUTINE V-LOWER () <HACK-HACK "Playing in this way with the ">>

<ROUTINE V-RUB () <HACK-HACK "Fiddling with the ">>

<ROUTINE V-PUSH () <HACK-HACK "Pushing the ">>

<ROUTINE PRE-MUNG ()
	 <COND (<NOT <FSET? ,PRSO ,VICBIT>>
		<HACK-HACK "Trying to destroy the ">)
	       (<NOT ,PRSI>
		<TELL "Trying to destroy the "
		      D
		      ,PRSO
		      " with your bare hands is suicidal." CR>)
	       (<NOT <FSET? ,PRSI ,WEAPONBIT>>
		<TELL "Trying to destroy the "
		      D
		      ,PRSO
		      " with a "
		      D
		      ,PRSI
		      " is useless." CR>)>>

<ROUTINE V-MUNG () <HERO-BLOW>>

<ROUTINE HACK-HACK
	 (STR)
	 #DECL ((STR) STRING)
	 <TELL .STR D ,PRSO <PICK-ONE ,HO-HUM> CR>>

<GLOBAL HO-HUM
	<LTABLE
	 " doesn't work."
	 " has no effect.">>

<ROUTINE WORD-TYPE
	 (OBJ WORD "AUX" SYNS)
	 #DECL ((OBJ) OBJECT (WORD SYNS) TABLE)
	 <ZMEMQ .WORD
		<SET SYNS <GETPT .OBJ ,P?SYNONYM>>
		<- </ <PTSIZE .SYNS> 2> 1>>>

<ROUTINE V-KNOCK
	 ()
	 <COND (<WORD-TYPE ,PRSO ,W?DOOR>
		<TELL "Nobody's home." CR>)
	       (ELSE <YUK>)>>

<ROUTINE V-YELL () <TELL "Aaaarrrrgggghhhh!" CR>>

<ROUTINE V-EXORCISE () <TELL "What a bizarre concept!" CR>>

<ROUTINE V-SHAKE ("AUX" X)
	 <COND (<FSET? ,PRSO ,VILLAIN>
		<YUK>)
	       (<NOT <FSET? ,PRSO ,TAKEBIT>>
		<TELL "You don't have it." CR>)
	       (<AND <NOT <FSET? ,PRSO ,OPENBIT>>
		     <FIRST? ,PRSO>>
		<TELL "There's something in the "
		      D
		      ,PRSO
		      "."
		      CR>)
	 (<AND <FSET? ,PRSO ,OPENBIT> <FIRST? ,PRSO>>
	  <WHY>)>>

<ROUTINE PRE-DIG
	 ()
	 <COND (<NOT ,PRSI> <SETG PRSI ,HANDS>)>
	 <COND (<==? ,PRSI ,SHOVEL> <RFALSE>)
	       (<FSET? ,PRSI ,TOOLBIT>
		<TELL "Digging with the " D ,PRSI " is slow and tedious." CR>)
	       (ELSE <YUK>)>>

<ROUTINE V-DIG () <RTRUE>>

<ROUTINE V-SMELL () <TELL "It smells like a " D ,PRSO "." CR>>

<ROUTINE GLOBAL-IN? (OBJ1 OBJ2 "AUX" T)
	 #DECL ((OBJ1 OBJ2) OBJECT (T) <OR FALSE TABLE>)
	 <COND (<SET T <GETPT .OBJ2 ,P?GLOBAL>>
		<ZMEMQB .OBJ1 .T <PTSIZE .T>>)>>

<ROUTINE V-SWIM ()
	 <TELL "This is an adventure, not a vacation!" CR>>

<ROUTINE PRE-UNTIE ()
	 <COND (<NOT <==? ,PRSO ,ROPE>>
		<TELL "It's not tied!" CR>)>>

<ROUTINE V-UNTIE () <RTRUE>>

<ROUTINE PRE-TIE
	 ()
	 <COND (<NOT <==? ,PRSO ,ROPE>>
		<TELL "How can you tie that to anything." CR>)
	       (<==? ,PRSI ,WINNER>
		<TELL "You can't tie the rope to yourself." CR>)>>

<ROUTINE V-TIE () <TELL "You can't tie the " D ,PRSO " to that." CR>>

<ROUTINE V-TIE-UP
	 ()
	 <COND (<==? ,PRSI ,ROPE>
		<COND (<FSET? ,PRSO ,VILLAIN>
		       <COND (<L? <GETP ,PRSO ,P?STRENGTH> 0>
			      <TELL
"Your attempt to tie up the " D ,PRSO " awakens him.">
			      <AWAKEN ,PRSO>)
			     (ELSE
			      <TELL
"The " D ,PRSO " struggles and you cannot tie him up." CR>)>)
		      (ELSE <WHY>)>)
	       (ELSE <TELL "You'd never tie it with that!" CR>)>>

<ROUTINE WHY () <TELL "What on earth for?" CR>>

<ROUTINE V-MELT () <TELL "It's not frozen!" CR>>

<ROUTINE V-MUMBLE ()
	 <TELL "I can't hear you!" CR>>

<ROUTINE V-ALARM ()
	 <COND (<FSET? ,PRSO ,VILLAIN>
		<COND (<L? <GETP ,PRSO ,P?STRENGTH> 0>
		       <TELL "The " D ,PRSO " is rudely awakened." CR>
		       <AWAKEN ,PRSO>)
		      (T
		       <TELL "He's wide awake, or haven't you noticed..."
			     CR>)>)
	       (ELSE
		<TELL "The " D ,PRSO " isn't sleeping." CR>)>>

<ROUTINE MUNG-ROOM (RM STR)
	 #DECL ((STR) STRING)
	 <FSET .RM ,RMUNGBIT>
	 <PUTP .RM ,P?LDESC .STR>>

<ROUTINE V-COMMAND ()
	 <COND (<FSET? ,PRSO ,VICBIT>
		<TELL "The " D ,PRSO " pays no attention." CR>)
	       (ELSE
		<TELL "You cannot talk to that!" CR>)>>

<ROUTINE V-CLIMB-ON ()
	 <COND (<FSET? ,PRSO ,VEHBIT>
		<V-CLIMB-UP ,P?UP T>)
	       (T
		<TELL "You can't climb onto the " D ,PRSO "." CR>)>>

<ROUTINE V-CLIMB-FOO () <V-CLIMB-UP ,P?UP T>>

<ROUTINE V-CLIMB-UP ("OPTIONAL" (DIR ,P?UP) (OBJ <>) "AUX" X)
	 #DECL ((DIR) FIX (OBJ) <OR ATOM FALSE> (X) TABLE)
	 <COND (<GETPT ,HERE .DIR>
		<PERFORM ,V?WALK .DIR>
		<RTRUE>)
	       (<NOT .OBJ>
		<TELL "You can't go that way." CR>)
	       (<AND .OBJ
		     <ZMEMQ ,W?WALL
			    <SET X <GETPT ,PRSO ,P?SYNONYM>> <PTSIZE .X>>>
		<TELL "Climbing the walls is to no avail." CR>)
	       (ELSE <TELL "Bizarre!" CR>)>>

<ROUTINE V-CLIMB-DOWN () <V-CLIMB-UP ,P?DOWN>>

<ROUTINE V-WIND ()
	 <TELL "You cannot wind up a " D ,PRSO "." CR>>

<ROUTINE V-COUNT ("AUX" OBJS CNT)
    #DECL ((CNT) FIX)
    <COND (<==? ,PRSO ,LEAVES>
	   <TELL "There are 69,105 leaves here." CR>)
	  (T
	   <WHY>)>>

<ROUTINE V-PUT-UNDER ()
	 <TELL "You can't do that." CR>>

<ROUTINE V-ENTER ()
	<PERFORM ,V?WALK ,P?IN>>

<ROUTINE V-THROUGH ("OPTIONAL" (OBJ <>))
	<COND (<AND <NOT .OBJ> <FSET? ,PRSO ,VEHBIT>>
	       <PERFORM ,V?BOARD ,PRSO>)
	      (<AND <NOT .OBJ> <NOT <FSET? ,PRSO ,TAKEBIT>>>
	       <TELL "You hit your head on the "
		     D ,PRSO " in your attempt." CR>)
	      (.OBJ <TELL "You can't do that!">)
	      (<IN? ,PRSO ,WINNER>
	       <TELL "That would be quite a contortion!" CR>)
	      (ELSE <YUK>)>>

<ROUTINE V-CROSS ()
	 <TELL "You can't cross that!" CR>>

<ROUTINE V-SEARCH ()
	 <TELL "You find nothing unusual." CR>>

<ROUTINE V-FIND ()
	 <TELL "You're the adventurer." CR>>
