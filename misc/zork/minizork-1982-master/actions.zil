"MINI-ZORK"

"SUBTITLE ACT1"

"SUBTITLE THE WHITE HOUSE"

<ROUTINE WEST-HOUSE (RARG)
	 <COND (<==? .RARG ,M-LOOK>
		<TELL 
"You are standing in an open field west of a white house, with a boarded
front door." CR>
		<COND (,WON-FLAG
		       <TELL
"A secret path leads southwest into the forest." CR>)>)>>

<ROUTINE EAST-HOUSE (RARG)
	 <COND (<==? .RARG ,M-LOOK>
		<TELL 
"You are behind the white house, where a path enters the forest to the east. 
In one corner of the house there is a small window which is ">
		<COND (<FSET? ,KITCHEN-WINDOW ,OPENBIT>
		       <TELL "open.">)
		      (ELSE <TELL "slightly ajar.">)>
		<CRLF>)>>

<ROUTINE WINDOW-FUNCTION ()
	 <COND (<VERB? OPEN CLOSE>
		<OPEN-CLOSE ,KITCHEN-WINDOW
"With great effort, you open the window far enough to allow entry."
"The window closes (more easily than it opened).">)
	       (<VERB? WALK THROUGH>
		<COND (<==? ,HERE ,KITCHEN>
		       <PERFORM ,V?WALK ,P?EAST>)
		      (T
		       <PERFORM ,V?WALK ,P?WEST>)>
		<RTRUE>)
	       (<VERB? LOOK-INSIDE>
		<TELL "You can see ">
		<COND (<==? ,HERE ,KITCHEN>
		       <TELL "a clear area leading towards a forest." CR>)
		      (T
		       <TELL "what appears to be a kitchen." CR>)>)>>

<ROUTINE OPEN-CLOSE (OBJ STROPN STRCLS)
	 #DECL ((OBJ) OBJECT (STROPN STRCLS) STRING)
	 <COND (<VERB? OPEN>
		<COND (<FSET? .OBJ ,OPENBIT>
		       <DUMMY>)
		      (ELSE
		       <TELL .STROPN CR>
		       <FSET .OBJ ,OPENBIT>)>)
	       (<VERB? CLOSE>
		<COND (<FSET? .OBJ ,OPENBIT>
		       <TELL .STRCLS CR>
		       <FCLEAR .OBJ ,OPENBIT>
		       T)
		      (ELSE <DUMMY>)>)>>

<ROUTINE KITCHEN-FCN (RARG) 
	<COND (<==? .RARG ,M-LOOK>
	       <TELL 
"You are in the kitchen of the house, where a table has been used recently 
to make food.  A door leads to the west and, next to a small chimney, 
a dark staircase leads up. To the east is a small window which is ">
	       <COND (<FSET? ,KITCHEN-WINDOW ,OPENBIT>
		      <TELL "open." CR>)
		     (ELSE
		      <TELL "slightly ajar." CR>)>)>>

<ROUTINE STONE-BARROW-FCN (RARG)
	 <COND (<AND <==? .RARG ,M-BEG>
		     <OR <VERB? ENTER>
			 <AND <VERB? WALK>
			      <==? ,PRSO ,P?WEST>>
			 <AND <VERB? THROUGH>
			      <==? ,PRSO ,BARROW>>>>
		<TELL

"In the Barrow|
The great stone door shuts behind you as you enter.  Ahead of you is an 
enormous cavern, dimly lit, and beyond a path leads into a dark tunnel.  You
hear a voice say:  All who stand within this barrow have completed a great 
and perilous adventure which has tested your wit and courage.">
		<V-QUIT <>>)>>

<ROUTINE BARROW-FCN ()
	 <COND (<VERB? THROUGH>
		<PERFORM ,V?WALK ,P?WEST>)>>

\

<GLOBAL RUG-MOVED <>>

<ROUTINE LIVING-ROOM-FCN (RARG "AUX" RUG? TC)
	#DECL ((RUG?) <OR ATOM FALSE> (TC) OBJECT)
	<COND (<==? .RARG ,M-LOOK>
	       <COND (,MAGIC-FLAG
		      <TELL
"You are in the living room.  There is a door to the east.  To the
west is an old wooden door, which has a cyclops-sized hole in it,">)
		     (T
		      <TELL
"You are in the living room.  There is a door to the east, a rustic wooden
door to the west, which appears to be nailed shut, ">)>
	       <TELL "a trophy case, ">
	       <SET RUG? ,RUG-MOVED>
	       <COND (<AND .RUG? <FSET? ,TRAP-DOOR ,OPENBIT>>
		      <TELL
		       "and a rug lying beside an open trap-door.">)
		     (.RUG?
		      <TELL "and a closed trap-door at your feet.">)
		     (<FSET? ,TRAP-DOOR ,OPENBIT>
		      <TELL "and an open trap-door at your feet.">)
		     (ELSE
		      <TELL
		       "and a large oriental rug in the center of the room.">)>
	       <CRLF>
	       T)
	      (<==? .RARG ,M-END>
	       <COND (<OR <VERB? TAKE>
			  <AND <VERB? PUT>
			       <==? ,PRSI ,TROPHY-CASE>>>
		      <SETG SCORE <+ ,BASE-SCORE <OTVAL-FROB>>>
		      <SCORE-UPD 0>
		      <RFALSE>)>)>>

<ROUTINE OTVAL-FROB ("OPTIONAL" (O ,TROPHY-CASE) "AUX" F (SCORE 0))
	 #DECL ((VALUE) FIX)
	 <SET F <FIRST? .O>>
	 <REPEAT ()
		 <COND (<NOT .F> <RETURN .SCORE>)>
		 <SET SCORE <+ .SCORE <GETP .F ,P?TVALUE>>>
		 <COND (<FIRST? .F> <OTVAL-FROB .F>)>
		 <SET F <NEXT? .F>>>>

<ROUTINE TRAP-DOOR-FCN ()
    <COND (<AND <VERB? OPEN CLOSE>
		<==? ,HERE ,LIVING-ROOM>>
	   <OPEN-CLOSE ,PRSO
"The door reluctantly opens to reveal a rickety staircase
descending into darkness."
"The door closes.">)
	  (<==? ,HERE ,CELLAR>
	   <COND (<AND <VERB? OPEN UNLOCK>
		       <NOT <FSET? ,TRAP-DOOR ,OPENBIT>>>
		  <TELL
"The door is latched from above." CR>)
		 (<AND <VERB? CLOSE> <NOT <FSET? ,TRAP-DOOR ,OPENBIT>>>
		  <FCLEAR ,TRAP-DOOR ,TOUCHBIT>
		  <FCLEAR ,TRAP-DOOR ,OPENBIT>
		  <TELL "The door closes and latches." CR>)
		 (<VERB? OPEN CLOSE>
		  <DUMMY>)>)>>

<ROUTINE CELLAR-FCN (RARG)
  <COND (<==? .RARG ,M-LOOK>
	 <TELL
"You are in a dark cellar with a passages leading north and east.  To the 
west is the bottom of a steep metal ramp." CR>)
	(<==? .RARG ,M-ENTER>
	 <COND (<AND <FSET? ,TRAP-DOOR ,OPENBIT>
		     <NOT <FSET? ,TRAP-DOOR ,TOUCHBIT>>>
		<FCLEAR ,TRAP-DOOR ,OPENBIT>
		<FSET ,TRAP-DOOR ,TOUCHBIT>
		<TELL 
"The trap shuts and you hear someone latching it." CR>)>)>>

<ROUTINE CHIMNEY-FUNCTION ("AUX" F)
  <COND (<NOT <SET F <FIRST? ,WINNER>>>
	 <TELL "Going up empty-handed is a bad idea." CR>
	 <RFALSE>)
	(<AND <OR <NOT <SET F <NEXT? .F>>>
		  <NOT <NEXT? .F>>>
	      <IN? ,LAMP ,WINNER>>
	 <COND (<NOT <FSET? ,TRAP-DOOR ,OPENBIT>>
		<FCLEAR ,TRAP-DOOR ,TOUCHBIT>)>
	 <RETURN ,KITCHEN>)
	(T
	 <TELL "You and all of your baggage won't fit." CR>
	 <RFALSE>)>>

<ROUTINE TRAP-DOOR-EXIT ()
	 <COND (,RUG-MOVED
		<COND (<FSET? ,TRAP-DOOR ,OPENBIT>
		       <RETURN ,CELLAR>)
		      (T
		       <TELL "The trap door is closed." CR>
		       <RFALSE>)>)
	       (T
		<TELL "You can't go that way." CR>
		<RFALSE>)>>

<ROUTINE RUG-FCN ()
   <COND (<VERB? RAISE>
	  <COND (,RUG-MOVED
		 <TELL "The rug is too heavy." CR>)
		(ELSE
		 <TELL 
"The rug is too heavy, but in trying to take it you notice something 
beneath it." CR>)>)
	 (<VERB? MOVE>
	  <COND (,RUG-MOVED
		 <DUMMY>)
		(ELSE
		 <TELL
"With effort, the rug moves to reveal the dusty cover of a closed 
trap-door." CR>
		 <FCLEAR ,TRAP-DOOR ,INVISIBLE>
		 <SETG RUG-MOVED T>)>)
	 (<VERB? TAKE>
	  <TELL
"The rug too heavy." CR>)
	 (<AND <VERB? LOOK-UNDER>
	       <NOT ,RUG-MOVED>
	       <NOT <FSET? ,TRAP-DOOR ,OPENBIT>>>
	  <TELL "Underneath the rug is a closed trap door." CR>)>>

\

"SUBTITLE TROLL"

<ROUTINE AXE-FUNCTION ()
	 <COND (,TROLL-FLAG <>)
	       (ELSE <WEAPON-FUNCTION ,AXE ,TROLL>)>>

<ROUTINE STILETTO-FUNCTION ()
	 <WEAPON-FUNCTION ,STILETTO ,THIEF>>

<ROUTINE WEAPON-FUNCTION (W V)
	<COND (<NOT <IN? .V ,HERE>> <RFALSE>)
	      (<VERB? TAKE>
	       <COND (<IN? .W .V>
		      <TELL
"The " D .V " snatches it out of your reach." CR>)
		     (ELSE
		      <TELL
"The " D .W " seems white-hot.  You can't hold on to it." CR>)>
	       T)>>

<ROUTINE TROLL-FCN ("OPTIONAL" (MODE <>))
	 <COND (<==? .MODE ,F-DEAD>
		<MOVE ,AXE ,HERE>
		<FCLEAR ,AXE ,NDESCBIT>
		<FSET ,AXE ,WEAPONBIT>
		<SETG TROLL-FLAG T>)
	       (<==? .MODE ,F-FIRST?>
		<COND (<PROB 33> <FSET ,TROLL ,FIGHTBIT> T)>)
	       (<NOT .MODE>
		<COND (<OR <AND <VERB? THROW GIVE>
				<==? ,PRSI ,TROLL>>
			   <VERB? TAKE MOVE MUNG>>
		       <AWAKEN ,TROLL>
		       <COND (<VERB? THROW GIVE>
			      <TELL
"The troll grabs the " D ,PRSO " and eats it." CR>
			      <REMOVE ,PRSO>)
			     (<VERB? MUNG>
			      <TELL
"The troll laughs at your puny gesture." CR>)>)
		      (<VERB? LISTEN>
		       <TELL
"The troll growls at you." CR>)
		      (<AND ,TROLL-FLAG <VERB? HELLO>>
		       <TELL
"The troll growls at you." CR>)>)>>

\

"SUBTITLE GRATING/MAZE"

<GLOBAL LEAVES-GONE <>>
<GLOBAL GRATE-REVEALED <>>
<GLOBAL GRUNLOCK <>>

<ROUTINE LEAVES-APPEAR ()
	<COND (<AND <NOT <FSET? ,GRATE ,OPENBIT>>
	            <NOT ,GRATE-REVEALED>>
	       <TELL "A grating appears on the ground." CR>
	       <FCLEAR ,GRATE ,INVISIBLE>
	       <SETG GRATE-REVEALED T>)>
	<>>

<ROUTINE LEAF-PILE ()
	<COND (<VERB? BURN>
	       <LEAVES-APPEAR>
	       <REMOVE ,PRSO>
	       <COND (<IN? ,PRSO ,HERE>
		      <TELL
"The leaves burn." CR>)
		     (T
		      <JIGS-UP
"The leaves burn, and so do you.">)>)
	      
	      (<VERB? MOVE TAKE>
	       <COND (<VERB? MOVE> <TELL "Done." CR> <LEAVES-APPEAR> T)
		     (ELSE <LEAVES-APPEAR>)>)
	      (<AND <VERB? LOOK-UNDER>
		    <NOT ,GRATE-REVEALED>>
	       <TELL "Underneath the pile of leaves is a grating." CR>)>>

<ROUTINE HOUSE-FUNCTION ()
    <COND (<EQUAL? ,HERE ,KITCHEN ,LIVING-ROOM ,ATTIC>
	   <COND (<VERB? FIND>
		  <TELL "Why not find your brains?" CR>)
		 (<VERB? WALK-AROUND>
		  <GO-NEXT ,IN-HOUSE-AROUND>
		  T)>)
	  (<NOT <OR <EQUAL? ,HERE ,EAST-OF-HOUSE ,WEST-OF-HOUSE>
		    <EQUAL? ,HERE ,NORTH-OF-HOUSE ,SOUTH-OF-HOUSE>>>
	   <COND (<VERB? FIND>
		  <COND (<==? ,HERE ,CLEARING>
			 <TELL "It seems to be to the west." CR>)
			(ELSE
			 <TELL "It was here just a minute ago...." CR>)>)
		 (ELSE <TELL "You're not at the house." CR>)>)
	  (<VERB? FIND>
	   <TELL
"It's right in front of you.  Are you blind or something?" CR>)
	  (<VERB? WALK-AROUND>
	   <GO-NEXT ,HOUSE-AROUND>
	   T)
	  (<VERB? EXAMINE>
	   <TELL
"The house is painted white and seems to have been abandoned." CR>)
	  (<VERB? THROUGH>
	   <COND (<==? ,HERE ,EAST-OF-HOUSE>
		  <COND (<FSET? ,KITCHEN-WINDOW ,OPENBIT>
			 <GOTO ,KITCHEN>)
			(ELSE <TELL "The window is closed." CR>)>)
		 (ELSE <TELL "I can't see how to get in from here." CR>)>)
	  (<VERB? BURN>
	   <TELL "You must be joking." CR>)>>
    
<ROUTINE CLEARING-FCN (RARG)
  	 <COND (<==? .RARG ,M-ENTER>
		<COND (<NOT ,GRATE-REVEALED>
		       <FSET ,GRATE ,INVISIBLE>)>)
	       (<==? .RARG ,M-LOOK>
		<TELL 
"You are in a clearing within a forest.  Paths lead south, east, and west.">
		<COND (<FSET? ,GRATE ,OPENBIT>
		       <CRLF>
		       <TELL
"There is an open grating, descending into darkness.">)
		      (,GRATE-REVEALED
		       <CRLF>
		       <TELL
"There is a grating securely fastened into the ground.">)>
		<CRLF>)>>

<ROUTINE MAZE-11-FCN (RARG)
  	 <COND (<==? .RARG ,M-ENTER>
		<FCLEAR ,GRATE ,INVISIBLE>)
	       (<==? .RARG ,M-LOOK>
		<TELL 
"You are in a small room near the maze." CR>
		<COND (<FSET? ,GRATE ,OPENBIT>
		       <TELL
 "Above you is an open grating with sunlight pouring in.">)
		      (,GRUNLOCK
		       <TELL "Above you is a grating.">)
		      (ELSE
		       <TELL
 "Above you is a locked grating.">)>
		<CRLF>)>>

<ROUTINE GRATE-FUNCTION ()
    	 <COND (<AND <VERB? OPEN> <==? ,PRSI ,KEYS>>
		<PERFORM ,V?UNLOCK ,GRATE ,KEYS>
		<RTRUE>)
	       (<VERB? OPEN CLOSE>
		<COND (,GRUNLOCK
		       <OPEN-CLOSE ,GRATE
				   <COND (<==? ,HERE ,CLEARING>
					  "The grating opens.")
					 (T
					  "The grating opens to reveal trees above you.")>
				   "The grating is closed.">
		       <COND (<FSET? ,GRATE ,OPENBIT>
			      <COND (<AND <NOT <==? ,HERE ,CLEARING>>
					  <NOT ,GRATE-REVEALED>>
				     <TELL 
"A pile of leaves falls onto your head and to the ground." CR>
				     <MOVE ,LEAVES ,HERE>)>
			      <FSET ,GRATING-ROOM ,ONBIT>)
			     (ELSE <FCLEAR ,GRATING-ROOM ,ONBIT>)>)
		      (ELSE <TELL "The grating is locked." CR>)>)>>

\

<ROUTINE TORCH-OBJECT ()
    <COND (<VERB? EXAMINE>
	   <TELL "The torch is burning." CR>)
	  (<AND <VERB? LAMP-OFF> <FSET? ,PRSO ,ONBIT>>
	   <TELL
"You almost burn your hand trying to extinguish the flame." CR>)>>

\

"SUBTITLE THE DOME"

<ROUTINE TEMPLE-ROOM-FCN (RARG)
 	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"*****INSERT TEMPLE DESCRIPTION HERE*****." CR>
		<COND (,DOME-FLAG
		       <TELL
"A piece of rope descends from the railing above, ending some
five feet above your head." CR>)>)>>

<ROUTINE DOME-ROOM-FCN (RARG)
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"You are at a railing near the periphery of a large dome, which forms the 
ceiling of another room below." CR>
		<COND (,DOME-FLAG
		       <TELL 
"Hanging from the railing is a rope which ends about ten feet from the floor 
below." CR>)>)>>

<GLOBAL EGYPT-FLAG <>>

\

"SUBTITLE LAND OF THE DEAD"

<ROUTINE LLD-ROOM (RARG)
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"You are outside a large open gateway, on which is inscribed| 
     \"Abandon every hope, all ye who enter here.\"|
Thousands of voices, lamenting some hideous fate, can be heard." CR>
		<COND (<NOT ,LLD-FLAG>
		       <TELL 
"The way through the gate is barred by evil spirits, who jeer at your
attempts to pass." CR>)>)
	       (<NOT .RARG>
		<COND 
		 (<AND <NOT ,LLD-FLAG> <VERB? RING> <==? ,PRSO ,BELL>>
		  <SETG XB T>
		  <TELL
"As the bell rings, the spirits stop their jeering and slowly turn to 
face you, displaying a long-forgotten terror." CR>
		  <SETG XC T>
		  <ENABLE <QUEUE I-XC 3>>)
		 (<AND ,XC <VERB? READ> <==? ,PRSO ,BOOK> <NOT ,LLD-FLAG>>
		  <TELL
"The prayer reverberates through the hall.  As the last word fades, a 
heart-stopping scream fills the cavern, and the spirits flee your unearthly 
power." CR>
		  <REMOVE ,GHOST>
		  <SETG LLD-FLAG T>
		  <DISABLE <INT I-XC>>)
		 (<VERB? EXORCISE>
		  <COND (<NOT ,LLD-FLAG>
			 <COND (<AND <IN? ,BELL ,WINNER>
				     <IN? ,BOOK ,WINNER>>
				<TELL "You must perform the ceremony." CR>)
			       (ELSE
				<TELL "You don't have the equipment." CR>)>)>)>)>>

<GLOBAL XB <>>

<GLOBAL XC <>>

<ROUTINE I-XB ()
	 <OR ,XC
	     <AND <==? ,HERE ,ENTRANCE-TO-HADES>
		  <TELL
"The tension of the ceremony is broken, and the spirits, resume their 
hideous jeering." CR>>>
	 <SETG XB <>>>

<ROUTINE I-XC ()
	 <SETG XC <>>
	 <I-XB>>

<ROUTINE GHOST-FUNCTION ()
	 <COND (<VERB? EXORCISE>
		<TELL "Only the ceremony itself has any effect." CR>)
	       (<==? ,PRSI ,GHOST>
		<TELL "How can you attack a spirit with material objects?" CR>
		<>)
	       (<==? ,PRSO ,GHOST>
		<TELL "You seem unable to affect these spirits." CR>)>>

\

"SUBTITLE FLOOD CONTROL DAM #3"

<GLOBAL GATE-FLAG <>>

<ROUTINE DAM-ROOM-FCN (RARG) 
   	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"You are atop Flood Control Dam #3, which was once quite a tourist 
attraction.  There are paths to the north and west, and a scramble down." CR>
		<COND (,LOW-TIDE
		       <TELL
"The gates are open and the water level behind the dam is low.  Water 
rushes through the dam and downstream." CR>)
		      (ELSE
		       <TELL
"The sluice gates on the dam are closed.  Behind the dam is a wide 
reservoir.  Water is pouring over the abandoned dam." CR>)>
		<TELL 
"There is a control panel here.  Protruding from the panel is a large 
metal bolt." CR>
		<COND (,GATE-FLAG
		       <TELL "The panel is emitting a low-level hum." CR>)>)>>

<ROUTINE BOLT-FUNCTION () 
	<COND (<VERB? TURN>
	       <COND (<==? ,PRSI ,WRENCH>
		      <COND (,GATE-FLAG
			     <FCLEAR ,RESERVOIR-SOUTH ,TOUCHBIT>
			     <COND (,LOW-TIDE
				    <TELL
"Nothing happens." CR>
				    T)
				   (ELSE
				    <SETG LOW-TIDE T>
				    <TELL
"The sluice gates open and water pours through the dam." CR>
				    T)>)
			    (ELSE <TELL
"The bolt won't turn with your best effort." CR>)>)
		     (ELSE <TELL
"The bolt won't turn using the " D ,PRSI "." CR>)>)>>
	      
<ROUTINE DBUTTONS ()
	 <COND (<VERB? PUSH>
		<COND (<==? ,PRSO ,RED-BUTTON>
		       <TELL "The room lights ">
		       <COND (<FSET? ,HERE ,ONBIT>
			      <FCLEAR ,HERE ,ONBIT>
			      <TELL "shut off." CR>)
			     (ELSE
			      <FSET ,HERE ,ONBIT>
			      <TELL "come on." CR>)>)
		      (<==? ,PRSO ,BROWN-BUTTON>
		       <FCLEAR ,DAM-ROOM ,TOUCHBIT>
		       <SETG GATE-FLAG <>>
		       <TELL "Click." CR>)
		      (<==? ,PRSO ,YELLOW-BUTTON>
		       <FCLEAR ,DAM-ROOM ,TOUCHBIT>
		       <SETG GATE-FLAG T>
		       <TELL "Click." CR>)>)>>

<ROUTINE TOOL-CHEST-FCN ()
	 <COND (<VERB? EXAMINE>
		<TELL "The chests are all empty." CR>)>>

<ROUTINE DAM-FUNCTION ()
	 <COND (<VERB? OPEN CLOSE>
		<TELL "Sounds reasonable, but this isn't how." CR>)
	       (<VERB? PLUG>
		<COND (<==? ,PRSI ,HANDS>
		       <TELL
"Are you the little Dutch boy, then?" CR>)
		      (ELSE
		       <TELL
"With a " D ,PRSI "?  Do you know how big this dam is?" CR>)>)>>

<ROUTINE WITH-TELL (OBJ)
	 #DECL ((OBJ) OBJECT)
	 <TELL "With a " D .OBJ "?" CR>>

<ROUTINE RESERVOIR-SOUTH-FCN (RARG) 
	<COND (<==? .RARG ,M-LOOK>
	       <COND (,LOW-TIDE
		      <TELL
"You are in a long room south of a reservoir.  However, with the water 
level lowered, there is merely a muddy stream to the north.">)
		     (ELSE
		      <TELL 
"You are in a long room on the south shore of a large lake, far
too deep and wide for crossing.">)>
	       <CRLF>
	       <TELL 
"Rocky passages head toward the south and southwest.  To the east, a 
mighty structure can be seen." CR>)>>

<ROUTINE RESERVOIR-NORTH-FCN (RARG) 
	<COND (<==? .RARG ,M-LOOK>
	       <COND (,LOW-TIDE
		      <TELL 
"You are in a cavernous room north of what was formerly a lake. However, 
with the water level lowered, there is merely a muddy stream to the south.">)>
	       <CRLF>
	       <TELL
"There is a grimy stairway leaving the room to the north." CR>)>>

\

"SUBTITLE WATER, WATER EVERYWHERE..."

<ROUTINE BOTTLE-FUNCTION ("AUX" (E? <>))
  <COND (<VERB? THROW>
	 <REMOVE ,PRSO>
	 <SET E? T>
	 <TELL "The bottle hits the far wall and shatters." CR>)
	(<VERB? MUNG>
	 <SET E? T>
	 <REMOVE ,PRSO>
	 <TELL "A brilliant maneuver destroys the bottle." CR>)
	(<VERB? SHAKE>
	 <COND (<FSET? ,PRSO ,OPENBIT> <SET E? T>)>)>
  <COND (<AND .E? <IN? ,WATER ,PRSO>>
	 <TELL "The water spills to the floor and evaporates." CR>
	 <REMOVE ,WATER>
	 T)>>

<ROUTINE WATER-FUNCTION ("AUX" AV W PI?)
	 #DECL ((AV) <OR OBJECT FALSE> (W) OBJECT (PI?) <OR ATOM FALSE>)
	 <COND (<VERB? SGIVE> <RFALSE>)
	       (<VERB? THROUGH>
		<TELL <PICK-ONE ,SWIMYUKS>>
		<RTRUE>)
	       (<VERB? FILL>	;"fill bottle with water =>"
		<SET W ,PRSI>	   ;"put water in bottle"
		<SETG PRSA ,V?PUT>
		<SETG PRSI ,PRSO>
		<SETG PRSO .W>
		<SET PI? <>>)
	       (<OR <==? ,PRSO ,GLOBAL-WATER>
		    <==? ,PRSO ,WATER>>
		<SET W ,PRSO>
		<SET PI? <>>)
	       (<SET W ,PRSI>
		<SET PI? T>)>
	 <COND (<==? .W ,GLOBAL-WATER>
		<SET W ,WATER>
		<COND (<VERB? TAKE PUT> <REMOVE .W>)>)>
	 <COND (.PI? <SETG PRSI .W>)
	       (T <SETG PRSO .W>)>
	 <SET AV <LOC ,WINNER>>
	 <COND (<NOT <FSET? .AV ,VEHBIT>> <SET AV <>>)>
	 <COND (<AND <VERB? TAKE PUT> <NOT .PI?>>
		<COND (<AND .AV
			    <OR <==? .AV ,PRSI>
				<AND <NOT ,PRSI>
				     <NOT <IN? .W .AV>>>>>
		       <TELL "There is now a puddle in the bottom of the "
			     D .AV "." CR>
		       <REMOVE ,PRSO>
		       <MOVE ,PRSO .AV>)
		      (<AND ,PRSI <NOT <==? ,PRSI ,BOTTLE>>>
		       <TELL "The water leaks out of the " D ,PRSI
			     " and evaporates immediately." CR>
		       <REMOVE .W>)
		      (<IN? ,BOTTLE ,WINNER>
		       <COND (<NOT <FSET? ,BOTTLE ,OPENBIT>>
			      <TELL "The bottle is closed." CR>)
			     (<NOT <FIRST? ,BOTTLE>>
			      <MOVE ,WATER ,BOTTLE>
			      <TELL "The bottle is now full of water." CR>)
			     (T
			      <TELL "The water slips through your fingers." CR>
			      <RTRUE>)>)
		      (<AND <IN? ,PRSO ,BOTTLE>
			    <VERB? TAKE>
			    <NOT ,PRSI>>
		       <SETG PRSO ,BOTTLE>
		       <ITAKE>
		       <SETG PRSO .W>)
		      (T
		       <TELL "The water slips through your fingers." CR>)>)
	       (.PI? <TELL "Nice try." CR>)
	       (<VERB? DROP GIVE>
		<REMOVE ,WATER>
		<COND (.AV
		       <TELL "There is now a puddle in the bottom of the "
			     D .AV "." CR>
		       <MOVE ,WATER .AV>)
		      (T
		       <TELL
"The water spills to the floor and evaporates immediately." CR>
		       <REMOVE ,WATER>)>)
	       (<VERB? THROW>
		<TELL
"The water splashes on the walls and evaporates immediately." CR>
		<REMOVE ,WATER>)>>

\

"SUBTITLE CYCLOPS"

<GLOBAL CYCLOWRATH 0>

<ROUTINE CYCLOPS-FCN ("AUX" COUNT)
	#DECL ((COUNT) FIX)
	<SET COUNT ,CYCLOWRATH>
	<COND (,CYCLOPS-FLAG
	       <COND (<VERB? ALARM KICK ATTACK BURN MUNG KILL>
		      <TELL 
"The cyclops yawns and stares at the thing that woke him up." CR>
		      <SETG CYCLOPS-FLAG <>>
		      <FSET ,CYCLOPS ,FIGHTBIT>
		      <COND (<L? .COUNT 0>
			     <SETG CYCLOWRATH <- .COUNT>>)
			    (ELSE
			     <SETG CYCLOWRATH .COUNT>)>)>)
	      (<AND <VERB? GIVE> <==? ,PRSI ,CYCLOPS>>
	       <COND (<==? ,PRSO ,FOOD>
		      <COND (<NOT <L? .COUNT 0>>
			     <REMOVE ,FOOD>
			     <TELL
"The cyclops says 'Mmm Mmm.  I love hot peppers!  But oh, could I use
a drink--perhaps some blood.'  From the gleam in his eye, it is clear whose 
blood he means." CR>
			     <SETG CYCLOWRATH <MIN -1 <- .COUNT>>>)>
		      <ENABLE <QUEUE I-CYCLOPS -1>>)
		     (<==? ,PRSO ,WATER>
		      <COND (<L? .COUNT 0>
			     <REMOVE ,WATER>
			     <FCLEAR ,CYCLOPS ,FIGHTBIT>
			     <TELL 
"The cyclops yawns and falls fast asleep (what did you put in that
drink, anyway?)." CR>
			     <SETG CYCLOPS-FLAG T>)
			    (ELSE
			     <TELL 
"The cyclops is not thirsty and refuses your offer." CR>
			     <>)>)
		     (<==? ,PRSO ,GARLIC>
		      <TELL
"The cyclops may be hungry, but there is a limit." CR>)
		     (ELSE
		      <TELL
"The cyclops is not so stupid as to eat THAT!" CR>)>)
	      (<VERB? THROW ATTACK MUNG KILL>
	       <ENABLE <QUEUE I-CYCLOPS -1>>
	       <TELL 
"The cyclops shrugs and ignores your pitiful effort." CR>
	       <COND (<VERB? THROW> <MOVE ,PRSO ,HERE>)>)
	      (<VERB? TAKE>
	       <TELL
"The cyclops doesn't take kindly to being grabbed." CR>)
	      (<VERB? TIE>
	       <TELL
"You cannot tie the cyclops, though he is fit to be tied." CR>)
	      (<VERB? LISTEN>
	       <TELL
"You can hear his stomach rumbling.">)>>

<ROUTINE I-CYCLOPS ()
	 <COND (,CYCLOPS-FLAG <RTRUE>)
	       (<NOT <==? ,HERE ,CYCLOPS-ROOM>>
		<DISABLE <INT I-CYCLOPS>>)
	       (ELSE
		<COND (<G? <ABS ,CYCLOWRATH> 5>
		       <DISABLE <INT I-CYCLOPS>>
		       <JIGS-UP 
"The cyclops, tired of all of your games eats you. 
The cyclops says 'Mmm.  Just like Mom used to make 'em.'">)
		      (ELSE
		       <COND (<L? ,CYCLOWRATH 0>
			      <SETG CYCLOWRATH <- ,CYCLOWRATH 1>>)
			     (T
			      <SETG CYCLOWRATH <+ ,CYCLOWRATH 1>>)>
		       <COND (<NOT ,CYCLOPS-FLAG>
			      <TELL <NTH ,CYCLOMAD <- <ABS ,CYCLOWRATH> 1>>
				    CR>)>)>)>>

<ROUTINE CYCLOPS-ROOM-FCN (RARG)
	<COND (<==? .RARG ,M-LOOK>
	       <TELL 
"This room has an exit on the north, and a staircase leading up." CR>
	       <COND (<AND ,CYCLOPS-FLAG <NOT ,MAGIC-FLAG>>
		      <TELL 
"The cyclops is sleeping blissfully at the foot of the stairs." CR>)
		     (,MAGIC-FLAG
		      <TELL 
"The east wall, previously solid, now has a cyclops-sized hole in it." CR>)
		     (<0? ,CYCLOWRATH>
		      <TELL
"A hungry-looking cyclops blocks the staircase.  From the bloodstains on the 
walls you guess that he is not very friendly, though he likes people." CR>)
		     (<G? ,CYCLOWRATH 0>
		      <TELL
"The cyclops is standing in the corner, eyeing you closely.  He looks 
very hungry, even for a cyclops." CR>)
		     (<L? ,CYCLOWRATH 0>
		      <TELL 
"The cyclops, having eaten the hot peppers, appears to be gasping.
His enflamed tongue protrudes from his man-sized mouth." CR>)>)
	      (<==? .RARG ,M-ENTER>
	       <OR <0? ,CYCLOWRATH> <ENABLE <INT I-CYCLOPS>>>)>>

<GLOBAL CYCLOMAD
	<TABLE
	  "The cyclops seems agitated."
	  "The cyclops appears to be getting more agitated."
	  "The cyclops is looking for something."
	  "The cyclops was looking for salt and pepper.  I think he is 
preparing for a snack."
	  "The cyclops is moving toward you in an unfriendly manner."
	  "You have two choices: 1. Leave  2. Become dinner.">>

\

"SUBTITLE A SEEDY LOOKING GENTLEMAN..."

<GLOBAL THIEF-HERE <>>

;"I-THIEF moved to DEMONS"

\

"SUBTITLE THINGS THIEF MIGHT DO"

<ROUTINE THIEF-VS-ADVENTURER (HERE? "AUX" (OLD-LIT ,LIT) ROBBED?)
  <COND (<==? ,HERE ,TREASURE-ROOM> <RTRUE>)
        (<NOT .HERE?>
         <COND (<PROB 30>
	        <FCLEAR ,THIEF ,INVISIBLE>
		<TELL 
"A thief carrying a large bag is leaning against a wall.  He does not
speak, but it is clear that the bag will be taken over his dead body." CR>)>)
	(<PROB 30>
	 <COND (<SET ROBBED?
		     <OR <ROB ,HERE ,THIEF 100>
			 <ROB ,WINNER ,THIEF>>>
		<TELL
"The thief just left, after robbing you blind." CR>)
	       (ELSE
		<TELL
"The thief, finding nothing of value, just left." CR>)>
	 <FSET ,THIEF ,INVISIBLE>
	 <RTRUE>)>
       <RFALSE>>

<ROUTINE HACK-TREASURES ("AUX" X)
	 <FSET ,THIEF ,INVISIBLE>
	 <SET X <FIRST? ,TREASURE-ROOM>>
	 <REPEAT ()
		 <COND (<NOT .X> <RETURN>)
		       (ELSE <FCLEAR .X ,INVISIBLE>)>
		 <SET X <NEXT? .X>>>>

<ROUTINE DEPOSIT-BOOTY (RM "AUX" X N)
	 <SET X <FIRST? ,THIEF>>
	 <REPEAT ()
		 <COND (<NOT .X> <RETURN>)>
		 <SET N <NEXT? .X>>
		 <COND (<==? .X ,STILETTO>)
		       (<G? <GETP .X ,P?TVALUE> 0>
			<MOVE .X .RM>)>
		 <SET X .N>>>

<ROUTINE ROB-MAZE (RM "AUX" X N)
	 <SET X <FIRST? .RM>>
	 <REPEAT ()
		 <COND (<NOT .X> <RETURN>)>
		 <SET N <NEXT? .X>>
		 <COND (<AND <FSET? .X ,TAKEBIT>
			     <NOT <FSET? .X ,INVISIBLE>>
			     <PROB 40>>
			<TELL 
"You hear, off in the distance, someone saying \"My, I wonder what
this fine " D .X " is doing here.\"" CR>
			<COND (<PROB 60>
			       <MOVE .X ,THIEF>
			       <FSET .X ,TOUCHBIT>
			       <FSET .X ,INVISIBLE>)>
			<RETURN>)>
		 <SET X .N>>>

\

"ROBBER-FUNCTION -- more prosaic thiefly occupations"

<GLOBAL THIEF-ENGROSSED <>>

<ROUTINE ROBBER-FUNCTION ("OPTIONAL" (MODE <>) "AUX" (FLG <>) X N)
	 #DECL ((DEM) HACK (FLG) <OR ATOM FALSE>)
	 <COND (<NOT .MODE>
		<COND (<AND <==? ,PRSO ,KNIFE>
			    <VERB? THROW>>
		       <TELL
"You missed.  The thief doesn't take the knife, though it would be
a fine addition to his collection." CR>
		       <FSET ,THIEF ,FIGHTBIT>)
		      (<AND <VERB? THROW GIVE>
			    <==? ,PRSI ,THIEF>>
		       <MOVE ,PRSO ,THIEF>
		       <COND (<G? <GETP ,PRSO ,P?TVALUE> 0>
			      <SETG THIEF-ENGROSSED T>
			      <TELL
"The thief, surprised by your generosity, accepts the "
D ,PRSO " and stops to admire its beauty." CR>)
			     (T
			      <TELL
"The thief places the " D ,PRSO " in his bag." CR>)>)
		      (<VERB? LISTEN>
		       <TELL
"The thief says nothing.">)>)
	       (<==? .MODE ,F-DEAD>
		<DEPOSIT-BOOTY ,HERE>
		<COND (<==? ,HERE ,TREASURE-ROOM>
		       <SET X <FIRST? ,HERE>>
		       <REPEAT ()
			       <COND
				(<NOT .X>
				 <RETURN>)
				(<NOT <EQUAL? .X ,CHALICE ,ADVENTURER>>
				 <FCLEAR .X ,INVISIBLE>
				 <COND (<NOT .FLG>
					<SET FLG T>
					<TELL
"As the thief dies, his magic wanes, and his treasures reappear." CR>)>)>
			       <SET X <NEXT? .X>>>)
		      (ELSE
		       <TELL "His booty remains." CR>)>
		<DISABLE <INT I-THIEF>>)
	       (<==? .MODE ,F-FIRST?>
		<COND (<AND ,THIEF-HERE <PROB 20>>
		       <FSET ,THIEF ,FIGHTBIT>
		       T)>)>>

<ROUTINE MOVE-ALL (FROM TO "AUX" X N)
	 <COND (<SET X <FIRST? .FROM>>
		<REPEAT ()
			<COND (<NOT .X> <RETURN>)>
			<SET N <NEXT? .X>>
			<FCLEAR .X ,INVISIBLE>
			<MOVE .X .TO>
			<SET X .N>>)>>

<ROUTINE CHALICE-FCN ()
	 <COND (<VERB? TAKE>
		<COND (<AND <IN? ,PRSO ,TREASURE-ROOM>
			    <IN? ,THIEF ,TREASURE-ROOM>
			    <FSET? ,THIEF ,FIGHTBIT>
			    <NOT <FSET? ,THIEF ,INVISIBLE>>>
		       <TELL "You'd be stabbed in the back!" CR>)>)>>

<ROUTINE TREASURE-ROOM-FCN (RARG "AUX" (FLG <>) TL)
	 #DECL ((FLG) <OR ATOM FALSE>)
  <COND (<AND <==? .RARG ,M-ENTER>
	      <1? <GET <INT I-THIEF> ,C-ENABLED?>>
	      <NOT ,DEAD>>
	 <COND (<SET FLG <NOT <IN? ,THIEF ,HERE>>>
		<TELL
"You hear a scream of anguish as the thief rushes to defend his hideaway." CR>
		<MOVE ,THIEF ,HERE>
		<FSET ,THIEF ,FIGHTBIT>
		<FCLEAR ,THIEF ,INVISIBLE>)
	       (T
		<FSET ,THIEF ,FIGHTBIT>)>
	 <THIEF-IN-TREASURE>)>>

<ROUTINE THIEF-IN-TREASURE ("AUX" F N)
	 <SET F <FIRST? ,HERE>>
	 <COND (<AND .F <NEXT? .F>>
		<TELL
"The thief gestures and all his treasures vanish." CR>)>
	 <REPEAT ()
		 <COND (<NOT .F> <RETURN>)
		       (<AND <NOT <==? .F ,CHALICE>>
			     <NOT <==? .F ,THIEF>>>
			<FSET .F ,INVISIBLE>)>
		 <SET F <NEXT? .F>>>>

<ROUTINE DUMMY () <TELL "Look around." CR>>

<ROUTINE FRONT-DOOR-FCN ()
	 <COND (<VERB? OPEN>
		<TELL
		 "The door cannot be opened." CR>)
	       (<VERB? BURN>
		<TELL
		 "You cannot burn this door." CR>)
	       (<VERB? MUNG>
		<TELL "You cannot damage this door." CR>)
	       (<VERB? LOOK-BEHIND>
		<TELL "It won't open." CR>)>>

\

"SUBTITLE RANDOM FUNCTIONS"

<ROUTINE BLACK-BOOK ()
	 <COND (<VERB? OPEN>
		<TELL "The book is already open." CR>)
	       (<VERB? CLOSE>
		<TELL "Oddly, you cannot." CR>)
	       (<VERB? BURN>
		<TELL "Sacrelige!" CR>)>>

<ROUTINE PAINTING-FCN ()
	 <COND (<VERB? MUNG>
		<PUTP ,PRSO ,P?TVALUE 0>
		<PUTP ,PRSO ,P?LDESC
"There is a worthless canvas here.">
		<TELL
"Great! You have ruined the painting." CR>)>>

\

"SUBTITLE LET THERE BE LIGHT SOURCES"

<GLOBAL LAMP-TABLE
	<TABLE 100
	       "The lamp appears a bit dimmer."
	       70
	       "The lamp is definitely dimmer now."
	       15      
	       "The lamp is nearly out."
	       0>>

<ROUTINE LANTERN ()
	 <COND (<VERB? LAMP-ON>
		<COND (<NOT <FSET? ,LAMP ,LIGHTBIT>>
		       <TELL "A burned-out lamp won't light." CR>)
		      (ELSE
		       <ENABLE <INT I-LANTERN>>
		       <>)>)
	       (<VERB? LAMP-OFF>
		<COND (<NOT <FSET? ,LAMP ,LIGHTBIT>>
		       <TELL "The lamp has already burned out." CR>)
		      (ELSE
		       <DISABLE <INT I-LANTERN>>
		       <>)>)
	       (<VERB? EXAMINE>
		<COND (<NOT <FSET? ,LAMP ,LIGHTBIT>>
		       <TELL "The lamp has burned out.">)
		      (<FSET? ,LAMP ,ONBIT>
		       <TELL "The lamp is on.">)
		      (ELSE
		       <TELL "The lamp is turned off.">)>
		<CRLF>)>>

<ROUTINE MIN (N1 N2)
	 #DECL ((N1 N2) FIX)
	 <COND (<L? .N1 .N2> .N1)
	       (T .N2)>>

<ROUTINE LIGHT-INT (OBJ INTNAM TBLNAM "AUX" (TBL <VALUE .TBLNAM>) TICK)
	 #DECL ((OBJ) OBJECT (TBLNAM INTNAM) ATOM (TBL) <PRIMTYPE VECTOR>
		(TICK) FIX)
	 <ENABLE <QUEUE .INTNAM <SET TICK <GET .TBL 0>>>>
	 <COND (<0? .TICK>
		<FCLEAR .OBJ ,LIGHTBIT>
		<FCLEAR .OBJ ,ONBIT>)>
	 <COND (<OR <HELD? .OBJ> <IN? .OBJ ,HERE>> 
		<COND (<0? .TICK>
		       <TELL "The " D .OBJ " is out." CR>)
		      (T
		       <TELL <GET .TBL 1> CR>)>)>
	 <COND (<NOT <0? .TICK>>
		<SETG .TBLNAM <REST .TBL 4>>)>>

\

"SUBTITLE ASSORTED WEAPONS"

<ROUTINE SWORD-FCN ()
	 <COND (<AND <VERB? TAKE> <==? ,WINNER ,ADVENTURER>>
		<ENABLE <QUEUE I-SWORD -1>>
		<>)>>

"SUBTITLE COAL MINE"

<ROUTINE BOOM-ROOM (RARG "AUX" (DUMMY? <>) FLAME)
         <COND (<NOT .RARG>
		<COND (<IN? ,TORCH ,WINNER>
		       <TELL " ** BOOOOOOM **" CR>
		       <JIGS-UP
"Oh dear.  It seems that the smell coming from this room was coal
gas.  I would have thought twice about carrying the torch in here.">)>)>>    

<ROUTINE BATS-ROOM (RARG)
	 <COND (<==? .RARG ,M-LOOK>
		<TELL 
"You are in a small room which has doors only to the east and south." CR>
		<COND (<EQUAL? <LOC ,GARLIC> ,WINNER ,HERE>
		       <TELL 
"In the corner of the room on the ceiling is a large vampire bat who
is holding his nose." CR>)>)
	       (<==? .RARG ,M-ENTER>
		<COND (<NOT <EQUAL? <LOC ,GARLIC> ,WINNER ,HERE>>
		       <FLY-ME>)>)>>

<ROUTINE BAT-FUNCTION ()
	 <COND (<VERB? TAKE ATTACK KILL MUNG>
		<FLY-ME>)>>

<ROUTINE FLY-ME ("AUX" (N 4))
	 <REPEAT ()
		 <COND (<L? <SET N <- .N 1>> 1> <RETURN>)
		       (ELSE <TELL "  Fweep!" CR>)>>
	 <TELL
"A giant vampire bat swoops down from his perch and lifts you away...." CR>
	 <GOTO <PICK-ONE ,BAT-DROPS>>
	 T>

<GLOBAL BAT-DROPS
      <LTABLE MINE-1
	      MINE-2
	      MINE-3
	      GAS-ROOM
              SQUEEKY-ROOM
	      MINE-ENTRANCE>>

<GLOBAL CAGE-TOP T>

<ROUTINE DUMBWAITER ()
	 <COND (<VERB? RAISE>
		<COND (,CAGE-TOP
		       <DUMMY>)
		      (ELSE
		       <MOVE ,RAISED-BASKET ,SHAFT-ROOM>
		       <MOVE ,LOWERED-BASKET ,LOWER-SHAFT>
		       <TELL "The basket is now at the top of the shaft." CR>
		       <SETG CAGE-TOP T>)>)
	       (<VERB? LOWER>
		<COND (<NOT ,CAGE-TOP>
		       <DUMMY>)
		      (ELSE
		       <MOVE ,RAISED-BASKET ,LOWER-SHAFT>
		       <MOVE ,LOWERED-BASKET ,SHAFT-ROOM>
		       <TELL
"The basket is lowered to the bottom of the shaft." CR>
		       <SETG CAGE-TOP <>>
		       <COND (<AND ,LIT <NOT <SETG LIT <LIT? ,HERE>>>>
			      <TELL "It is now pitch black." CR>)>
		       T)>)
	       (<EQUAL? ,LOWERED-BASKET ,PRSO ,PRSI>
		<TELL "The basket is at the other end of the chain." CR>)
	       (<AND <VERB? TAKE>
		     <EQUAL? ,PRSO ,RAISED-BASKET ,LOWERED-BASKET>>
		<TELL "The cage is securely fastened to the chain." CR>)>>

<ROUTINE MACHINE-ROOM-FCN (RARG)
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"In one corner of this chilly room is a machine shaped somewhat like a
clothes dryer, with a grooved switch labelled START.  The switch is so 
small that your fingers can not turn it.  On top of the machine is a 
large lid, which is ">
		<COND (<FSET? ,MACHINE ,OPENBIT>
		       <TELL "open.">)
		      (ELSE <TELL "closed.">)>
		<CRLF>)>>

<ROUTINE MACHINE-FUNCTION ()
	 <COND
	  (<==? ,HERE ,MACHINE-ROOM>
	   <COND
	    (<VERB? OPEN>
	     <COND (<FSET? ,MACHINE ,OPENBIT>
		    <DUMMY>)
		   (<FIRST? ,MACHINE>
		    <TELL "The lid opens, revealing ">
		    <PRINT-CONTENTS ,MACHINE>
		    <TELL "." CR>
		    <FSET ,MACHINE ,OPENBIT>)
		   (ELSE
		    <TELL "The lid opens." CR>
		    <FSET ,MACHINE ,OPENBIT>)>)
	    (<VERB? CLOSE>
	     <COND (<FSET? ,MACHINE ,OPENBIT>
		    <TELL "The lid closes." CR>
		    <FCLEAR ,MACHINE ,OPENBIT>
		    T)
		   (ELSE <DUMMY>)>)>)>>

<ROUTINE MSWITCH-FUNCTION ("AUX" O)
	 <COND (<VERB? TURN>
		<COND (<==? ,PRSI ,SCREWDRIVER>
		       <COND (<FSET? ,MACHINE ,OPENBIT>
			      <TELL
"The machine won't work with the lid open." CR>)
			     (ELSE <TELL 
"The machine emits a brief display of dazzling lights and bizarre noises." CR>
			      <COND (<IN? ,COAL ,MACHINE>
				     <REMOVE ,COAL>
				     <MOVE ,DIAMOND ,MACHINE>)
				    (ELSE
				     <REPEAT ()
					     <COND (<SET O <FIRST? ,MACHINE>>
						    <REMOVE .O>)
						   (ELSE <RETURN>)>>
				     <MOVE ,GUNK ,MACHINE>)>)>)
		      (ELSE
		       <TELL "It seems that a " D ,PRSO " won't do." CR>)>)>>

<ROUTINE GUNK-FUNCTION ()
	 <REMOVE ,GUNK>
	 <TELL
"The slag crumbles into dust at your touch." CR>>

<ROUTINE NO-OBJS (RARG "AUX" F)
	 <COND (<==? .RARG ,M-BEG>
		<SET F <FIRST? ,WINNER>>
		<SETG EMPTY-HANDED T>
		<REPEAT ()
			<COND (<NOT .F> <RETURN>)
			      (<G? <WEIGHT .F> 4>
			       <SETG EMPTY-HANDED <>>
			       <RETURN>)>
			<SET F <NEXT? .F>>>
		<COND (<AND <==? ,HERE ,LOWER-SHAFT> ,LIT>
		       <SCORE-UPD ,LIGHT-SHAFT>
		       <SETG LIGHT-SHAFT 0>)>
		<RFALSE>)>>

<ROUTINE SOUTH-TEMPLE-FCN (RARG)
	 <COND (<==? .RARG ,M-BEG>
		<SETG COFFIN-CURE <NOT <IN? ,COFFIN ,WINNER>>>
		<RFALSE>)>> 

<GLOBAL LIGHT-SHAFT 13>

\ 

"SUBTITLE OLD MAN RIVER, THAT OLD MAN RIVER..."

<ROUTINE WHITE-CLIFFS-FUNCTION (RARG)
	 <COND (<NOT .RARG>
		<COND (<IN? ,INFLATED-BOAT ,WINNER>
		       <SETG DEFLATE <>>)
	       	      (ELSE <SETG DEFLATE T>)>)>>

<ROUTINE SCEPTRE-FUNCTION ()
	 <COND (<VERB? WAVE RAISE>
		<COND (<AND <NOT ,RAINBOW-FLAG>
			    <EQUAL? ,HERE ,ARAGAIN-FALLS ,END-OF-RAINBOW>>
		       <FCLEAR ,POT-OF-GOLD ,INVISIBLE>
		       <TELL
"Suddenly, the rainbow appears to become solid." CR>
		       <SETG RAINBOW-FLAG T>)
		      (ELSE
		       <TELL 
"A dazzling display of color briefly emanates from the sceptre." CR>)>)>>

<ROUTINE FALLS-ROOM (RARG)
    <COND (<==? .RARG ,M-LOOK>
	   <TELL
"You are near the top of Aragain Falls, an enormous waterfall.  The only path 
here is on the north end." CR>
	   <COND (,RAINBOW-FLAG
		  <TELL
"A solid rainbow spans the falls.">)
		 (ELSE
		  <TELL
"A beautiful rainbow can be seen over the falls to the west.">)>
	   <CRLF>)>>

<ROUTINE RAINBOW-FCN ()
	 <COND (<VERB? CROSS>
		<COND (,RAINBOW-FLAG
		       <COND (<==? ,HERE ,ARAGAIN-FALLS>
			      <GOTO ,END-OF-RAINBOW>)
			     (<==? ,HERE ,END-OF-RAINBOW>
			      <GOTO ,ARAGAIN-FALLS>)
			     (T
			      <TELL "You'll have to say which way..." CR>)>)
		      (T
		       <TELL "I didn't know you could walk on water vapor."
			     CR>)>)>> 

<GLOBAL YUKS
	<LTABLE
	 "A valiant attempt."
	 "You can't be serious."
	 ;"Not bloody likely."
	 "An interesting idea..."
	 "What a concept!">>

<ROUTINE RIVER-FUNCTION ()
	 <COND (<VERB? PUT>
		<COND (<==? ,PRSI ,RIVER>
		       <COND (<==? ,PRSO ,ME>
			      <JIGS-UP
"You fight the current for a while, and finally drown.">)
			     (<==? ,PRSO ,INFLATED-BOAT>
			      <TELL
"You should get in the boat then launch it." CR>)
			     (<FSET? ,PRSO ,BURNBIT>
			      <REMOVE ,PRSO>
			      <TELL
"The " D ,PRSO " floats for a moment, then sinks." CR>)
			     (ELSE
			      <REMOVE ,PRSO>
			      <TELL
"The " D ,PRSO " splashes into the water and is gone forever." CR>)>)>)
	       (<VERB? LEAP>
		<TELL
"A look before leaping reveals that the river is dangerous,with 
swift currents and sharp rocks.  You therefore decide to 
forgo your ill-considered swim." CR>)>>

<GLOBAL RIVER-SPEEDS
	<LTABLE RIVER-1 4 RIVER-2 3 RIVER-3 2>>

<GLOBAL RIVER-NEXT
	<LTABLE RIVER-1 RIVER-2 RIVER-3>>

<GLOBAL RIVER-LAUNCH
	<LTABLE DAM-BASE RIVER-1
		WHITE-CLIFFS RIVER-2
		SANDY-BEACH RIVER-3>> 

<ROUTINE I-RIVER ("AUX" RM)
	 #DECL ((RM) <OR FALSE OBJECT>)
	 <COND (<NOT <EQUAL? ,HERE ,RIVER-1 ,RIVER-2 ,RIVER-3>>
		<DISABLE <INT I-RIVER>>)
	       (<SET RM <LKP ,HERE ,RIVER-NEXT>>
		<TELL "The flow of the river carries you downstream." CR>
		<GOTO .RM>
		<ENABLE <QUEUE I-RIVER <LKP ,HERE ,RIVER-SPEEDS>>>)
	       (T
		<JIGS-UP
"Unfortunately, a rubber raft doesn't provide much protection from the rocks 
and boulders at the bottom of many waterfalls.  Including this one.">)>>

<ROUTINE RBOAT-FUNCTION ("OPTIONAL" (RARG <>))
    #DECL ((RARG) <OR FALSE FIX>)
    <COND (<==? .RARG ,M-ENTER> <>)	   
	  (<==? .RARG ,M-BEG>
	   <COND (<VERB? WALK>
		  <COND (<EQUAL? ,PRSO ,P?LAND ,P?EAST ,P?WEST>
			 <RFALSE>)
			(T
			 <TELL "You can't control the boat with words." CR>
			 <RTRUE>)>)
		 (<VERB? LAUNCH>
		  <COND (<GO-NEXT ,RIVER-LAUNCH>
			 <ENABLE <QUEUE I-RIVER <LKP ,HERE ,RIVER-SPEEDS>>>
			 <RTRUE>)
			(T
			 <TELL "You can't launch it from here." CR>)>)>)
	  (<VERB? LAUNCH>
	   <TELL "You're not in the boat!" CR>)
	  (<VERB? INFLATE FILL>
	   <TELL "Inflating it further would probably burst it." CR>)
	  (<VERB? DEFLATE>
	   <COND (<==? <LOC ,WINNER> ,INFLATED-BOAT>
		  <TELL
"You can't deflate the boat while you're in it." CR>)
		 (<NOT <IN? ,INFLATED-BOAT ,HERE>>
		  <TELL
"The boat must be on the ground to be deflated." CR>)
		 (ELSE <TELL
"The boat deflates." CR>
		  <SETG DEFLATE T>
		  <REMOVE ,INFLATED-BOAT>
		  <MOVE ,INFLATABLE-BOAT ,HERE>)>)>>

<ROUTINE BREATHE ()
	 <PERFORM ,V?INFLATE ,PRSO ,LUNGS>>

<ROUTINE IBOAT-FUNCTION ()
	 <COND (<VERB? INFLATE FILL>
		<COND (<NOT <IN? ,INFLATABLE-BOAT ,HERE>>
		       <TELL
"The boat must be on the ground to be inflated." CR>)
		      (<==? ,PRSI ,PUMP>
		       <TELL
"The boat inflates and appears seaworthy." CR>
		       <COND (<NOT <FSET? ,BOAT-LABEL ,TOUCHBIT>>
			      <TELL
"A tan label is lying inside the boat." CR>)>
		       <SETG DEFLATE <>>
		       <REMOVE ,INFLATABLE-BOAT>
		       <MOVE ,INFLATED-BOAT ,HERE>)
		      (<==? ,PRSI ,LUNGS>
		       <TELL
"You don't have enough lung power to inflate it." CR>)
		      (ELSE
		       <TELL
"With a " D ,PRSI "?  Surely you jest!" CR>)>)>>

<GLOBAL BEACH-DIG -1>

<GDECL (BEACH-DIG) FIX>

<ROUTINE GROUND-FUNCTION ()
	 <COND (<AND <VERB? PUT> <==? ,PRSI ,GROUND>>
		<PERFORM ,V?DROP ,PRSO>)
	       (<==? ,HERE ,SANDY-CAVE>
		<SAND-FUNCTION>)
	       (<VERB? DIG>
		<TELL "The ground is too hard for digging here." CR>)>>

<ROUTINE SAND-FUNCTION ()
	 <COND (<VERB? DIG>
		<SETG BEACH-DIG <+ 1 ,BEACH-DIG>>
		<COND (<G? ,BEACH-DIG 3>
		       <SETG BEACH-DIG -1>
		       <AND <IN? ,SCARAB ,HERE> <FSET ,SCARAB ,INVISIBLE>>
		       <JIGS-UP "The hole collapses, smothering you.">)
		      (<==? ,BEACH-DIG 3>
		       <COND (<FSET? ,SCARAB ,INVISIBLE>
			      <TELL
"You can see a scarab here in the sand." CR>
			      <FCLEAR ,SCARAB ,INVISIBLE>)>)
		      (T
		       <TELL <GET ,BDIGS ,BEACH-DIG> CR>)>)>>

<GLOBAL BDIGS
	<TABLE "You seem to be digging a hole here."
	       "The hole is getting deeper, but that's about it."
	       "You are surrounded by a wall of sand on all sides.">>

\ 

"SUBTITLE LURKING GRUES"

<ROUTINE GRUE-FUNCTION ()
    <COND (<VERB? EXAMINE>
	   <TELL
"The grue is a fearsome beast who inhabits the dark places of the
earth.  Its favorite diet is adventurers, but its huge
appetite is tempered by its fear of light." CR>)
	  (<VERB? FIND>
	   <TELL
"There is no grue here, but I'm sure there is at least one lurking
in the darkness nearby.  I wouldn't let my light go out if I were
you!" CR>)
	  (<VERB? LISTEN>
	   <TELL
"It makes no sound but is always lurking in the darkness nearby." CR>)>>

\ 

<ROUTINE CRETIN ()
	 <COND (<AND <VERB? GIVE> <==? ,PRSI ,ME>>
		<PERFORM ,V?TAKE ,PRSO>)
	       (<AND <VERB? GIVE> <==? ,PRSO ,ME> ,PRSI <FSET? ,PRSI ,VILLAIN>>
		<TELL "That would be suicidal." CR>)
	       (<VERB? ATTACK KILL MUNG>
		<COND (<AND ,PRSI <FSET? ,PRSI ,WEAPONBIT>>
		       <JIGS-UP 
			"If you insist.... Poof, you're dead!">)
		      (T <TELL "Suicide is not the answer." CR>)>)
	       (<VERB? TAKE>
		<TELL "How romantic!" CR>)
	       (<VERB? EXAMINE>
		<TELL
			"That's difficult unless your eyes are prehensile." CR>)>> 

\

<ROUTINE HELD? (CAN)
    #DECL ((CAN) OBJECT)
    <REPEAT ()
	    <SET CAN <LOC .CAN>>
	    <COND (<NOT .CAN> <RFALSE>)
		  (<==? .CAN ,WINNER> <RTRUE>)>>>

\ 

"SUBTITLE TOITY POIPLE BOIDS A CHOIPIN' AN' A BOIPIN' ... "

<ROUTINE TREE-ROOM (RARG "AUX" F)
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"You are about 10 feet above the ground nestled among some large
branches.  The nearest branch above you is above your reach.
A bird's nest is tangled around a branch here." CR>)
	       (<==? .RARG ,M-BEG>
		<COND (<VERB? DROP>
		       <COND (<NOT <IDROP>> <RTRUE>)
			     (<==? ,PRSO ,EGG>
			      <TELL 
"The egg falls to the ground and cracks open." CR>
			      <MOVE ,EGG ,PATH>
			      <OPEN-EGG>)
			     (<NOT <EQUAL? ,PRSO ,WINNER ,TOP-OF-TREE>>
			      <MOVE ,PRSO ,PATH>
			      <TELL
"The " D ,PRSO " falls to the ground." CR>)>)>)
	       (<==? .RARG ,M-ENTER> <ENABLE <QUEUE I-FOREST-ROOM -1>>)>>

<ROUTINE EGG-OBJECT () 
	 <COND (<AND <VERB? OPEN MUNG> <==? ,PRSO ,EGG>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <TELL "The egg is already open." CR>)
		      (T
		       <TELL 
"The egg is now open, but the clumsiness of your attempt has seriously
compromised its esthetic appeal." CR>
		       <OPEN-EGG>)>)
	       (<VERB? CLIMB-ON>
		<TELL
"There is a delicate crunch from beneath you.">
		<OPEN-EGG>)>>

<ROUTINE OPEN-EGG ("AUX" L)
	 <TELL
"Nestled inside the now broken egg is a golden clockwork canary." CR>
	 <MOVE ,BROKEN-EGG <LOC ,EGG>>
	 <MOVE ,CANARY ,BROKEN-EGG>
	 <REMOVE ,EGG>>

<GLOBAL SING-SONG <>>

<ROUTINE CANARY-OBJECT ()
	 <COND (<VERB? WIND>
		<COND (<AND <NOT ,SING-SONG> <FOREST-ROOM?>>
		       <TELL
"The canary chirps a beautiful song and as it does a lovely songbird
arrives and perches above your head.  As it opens its beak to sing,
a brass bauble drops from its mouth, bounces off your head, and lands
in the grass.  When the song ends, the bird flies away." CR>
		       <SETG SING-SONG T>
		       <MOVE ,BAUBLE
			     <COND (<==? ,HERE ,UP-A-TREE> ,PATH)
				   (ELSE ,HERE)>>)
		      (T
		       <TELL
"The canary chirps blithely for a short time." CR>)>)>>

<ROUTINE FOREST-ROOM? ()
	 <OR <EQUAL? ,HERE ,FOREST-EDGE>
	     <EQUAL? ,HERE ,PATH ,UP-A-TREE>>>

<ROUTINE I-FOREST-ROOM ()
	 <COND (<NOT <FOREST-ROOM?>>
		<DISABLE <INT I-FOREST-ROOM>>)
	       (<PROB 15>
		<TELL
"You hear in the distance the chirping of a song bird." CR>)>>

<ROUTINE FOREST-ROOM (RARG) 
	 <COND (<==? .RARG ,M-ENTER> <ENABLE <QUEUE I-FOREST-ROOM -1>>)>>

<ROUTINE FOREST-FUNCTION ()
	 <COND (<VERB? WALK-AROUND>
		<GO-NEXT ,FOREST-AROUND>)>>

<ROUTINE BIRD-OBJECT ()
	 <COND (<VERB? EXAMINE>
		<TELL "I can't see any songbird here." CR>)
	       (<VERB? FIND>
		<TELL "The songbird is not here." CR>)
	       (<VERB? LISTEN>
		<TELL "You can't hear the songbird just now." CR>)
	       (<VERB? FOLLOW>
		<TELL "You can't follow him." CR>)>>

<ROUTINE WCLIF-OBJECT ()
	 <COND (<VERB? CLIMB-UP CLIMB-DOWN CLIMB-FOO>
		<TELL "The cliff is too steep for climbing." CR>)>>

<ROUTINE CLIFF-OBJECT ()
	 <COND (<==? ,PRSI ,CLIMBABLE-CLIFF>
		<COND (<VERB? PUT>
		       <TELL
"The " D ,PRSO " tumbles into the river and is gone." CR>
		       <REMOVE ,PRSO>)>)>>

\

"SUBTITLE CHUTES AND LADDERS"

<ROUTINE ROPE-FUNCTION ("AUX" RLOC)
	 <COND (<NOT <==? ,HERE ,DOME-ROOM>>
		<SETG DOME-FLAG <>>
		<COND (<VERB? TIE>
		       <TELL "You can't tie the rope to that." CR>)>)
	       (<VERB? TIE>
		<COND (<==? ,PRSI ,RAILING>
		       <COND (,DOME-FLAG
			      <TELL
"The rope is already tied to it." CR>)
			     (ELSE
			      <TELL 
"The rope drops over the side of the railing." CR>
			      <SETG DOME-FLAG T>
			      <FSET ,ROPE ,NDESCBIT>
			      <SET RLOC <LOC ,ROPE>>
			      <COND (<OR <NOT .RLOC>
					 <NOT <IN? .RLOC ,ROOMS>>>
				     <MOVE ,ROPE ,HERE>)>
			      T)>)>)
	       (<VERB? UNTIE>
		<COND (,DOME-FLAG
		       <SETG DOME-FLAG <>>
		       <FCLEAR ,ROPE ,NDESCBIT>
		       <TELL "The rope is now untied." CR>)
		      (ELSE
		       <TELL "It is not tied to anything." CR>)>)
	       (<AND <VERB? DROP>
		     <==? ,HERE ,DOME-ROOM>
		     <NOT ,DOME-FLAG>>
		<MOVE ,ROPE ,NORTH-TEMPLE>
		<TELL "The rope drops gently to the floor below." CR>)
	       (<VERB? TAKE>
		<COND (,DOME-FLAG
		       <TELL "The rope is tied to the railing." CR>)>)>>

<ROUTINE UNTIE-FROM ()
    <COND (<AND <==? ,PRSO ,ROPE>
		<AND ,DOME-FLAG <==? ,PRSI ,RAILING>>>
	   <PERFORM ,V?UNTIE ,PRSO>)
	  (ELSE <TELL "It's not attached to that!" CR>)>>

<ROUTINE SLIDE-FUNCTION ()
	 <COND (<OR <VERB? THROUGH>
		    <AND <VERB? PUT> <==? ,PRSO ,ME>>>
		<TELL "You tumble down the slide...." CR>
		<GOTO ,CELLAR>)
	       (<VERB? PUT>
		<COND (<FSET? ,PRSO ,TAKEBIT>
		       <TELL
"The " D ,PRSO " falls into the slide and is gone." CR>
		       <COND (<==? ,PRSO ,WATER> <REMOVE ,PRSO>)
			     (T
			      <MOVE ,PRSO ,CELLAR>)>)
		      (ELSE <YUK>)>)>>

"MORE RANDOMNESS"

;"Pseudo-object routines"

<ROUTINE LAKE-PSEUDO ()
	 <COND (,LOW-TIDE
		<TELL "There's not much lake left...." CR>)
	       (<VERB? CROSS>
		<TELL "It's too wide to cross." CR>)
	       (<VERB? THROUGH>
		<TELL "You can't swim in this lake.">)>>

<ROUTINE GATE-PSEUDO ()
	 <COND (<VERB? THROUGH>
		<PERFORM ,V?WALK ,P?IN>
		<RTRUE>)
	       (ELSE
		<TELL
"The gate is protected by an invisible force." CR>)>>

<ROUTINE DOOR-PSEUDO ()			
	 <COND (<VERB? OPEN CLOSE>
		<TELL "The door won't budge." CR>)>>

<ROUTINE PAINT-PSEUDO ()
	 <COND (<VERB? MUNG>
		<TELL "Some paint chips away, revealing more paint." CR>)>>

<ROUTINE GAS-PSEUDO ()
	 <COND (<VERB? BREATHE>	;"REALLY BLOW"
		<TELL "There is too much gas to blow away." CR>)
	       (<VERB? SMELL>
		<TELL "It smells like coal gas in here." CR>)>>

<ROUTINE PATH-OBJECT ()
	 <COND (<VERB? TAKE FOLLOW>
		<TELL "You must specify a direction to go." CR>)
	       (<VERB? FIND>
		<TELL "I can't help you there...." CR>)>>

