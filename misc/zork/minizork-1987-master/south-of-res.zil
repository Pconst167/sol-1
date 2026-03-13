"SOUTH-OF-RESERVOIR for
			     Mini-Zork '87
	  (c) Copyright 1987 Infocom, Inc. All Rights Reserved"

<ROOM CELLAR
      (IN ROOMS)
      (DESC "Cellar")
      (NORTH TO TROLL-ROOM)
      (EAST TO STUDIO)
      (UP TO LIVING-ROOM IF TRAP-DOOR IS OPEN)
      (WEST "You try to ascend the ramp, but slide back down.")
      (FLAGS RLANDBIT)
      (VALUE 25)
      (GLOBAL TRAP-DOOR SLIDE STAIRS)
      (ACTION CELLAR-F)>

<ROUTINE CELLAR-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
	 	<TELL
"You are in a dark, damp cellar with narrow passageways to the north and east.
On the west is the bottom of a steep metal ramp which is unclimbable.">)
	       (<EQUAL? .RARG ,M-ENTER>
	 	<COND (<AND <FSET? ,TRAP-DOOR ,OPENBIT>
		     	    <NOT <FSET? ,TRAP-DOOR ,TOUCHBIT>>>
		       <FCLEAR ,TRAP-DOOR ,OPENBIT>
		       <FSET ,TRAP-DOOR ,TOUCHBIT>
		       <TELL
"The trap door crashes shut, and you hear someone barring it." CR CR>)>)>>

<ROOM STUDIO
      (IN ROOMS)
      (DESC "Studio")
      (LDESC
"This was once an artist's studio. The walls are splattered with paints of
69 different colors. To the west is a doorway (also covered with paint).
A dark and narrow chimney leads up from a fireplace; although you might be
able to get up it, it seems unlikely you could get back down.")
      (WEST TO CELLAR)
      (UP PER UP-CHIMNEY-F)
      (FLAGS RLANDBIT)
      (GLOBAL CHIMNEY)
      (PSEUDO "PAINT" PAINT-PSEUDO)>

<ROUTINE UP-CHIMNEY-F ("AUX" (F <FIRST? ,WINNER>))
	 <COND (<L? <CCOUNT ,ADVENTURER> 3>
		<COND (<NOT <FSET? ,TRAP-DOOR ,OPENBIT>>
		       <FCLEAR ,TRAP-DOOR ,TOUCHBIT>)>
		,KITCHEN)
	       (T
		<TELL ,YOU-CANT "fit with what you're carrying." CR>
		<RFALSE>)>>

<ROUTINE PAINT-PSEUDO ()
	 <COND (<VERB? MUNG>
		<TELL "Some paint chips away, revealing more paint." CR>)>>

<OBJECT PAINTING
	(IN STUDIO)
	(DESC "painting")
	(FDESC "On the far wall is a painting of unparalleled beauty.")
	(LDESC "A painting by a neglected genius is here.")
	(SYNONYM PAINTING ART CANVAS TREASURE)
	(ADJECTIVE BEAUTI MUTILATED)
	(FLAGS TREASUREBIT TAKEBIT BURNBIT)
	(SIZE 15)
	(VALUE 7)
	(ACTION PAINTING-F)>

<ROUTINE PAINTING-F ()
	 <COND (<VERB? MUNG>
		<TELL "Don't be a vandal!" CR>)>>

<ROOM TROLL-ROOM
      (IN ROOMS)
      (DESC "Troll Room")
      (LDESC
"This is a small room with passages to the east, northeast and south, and a
forbidding hole leading west. Bloodstains and deep scratches (perhaps made by
an axe) mar the walls.")
      (SOUTH TO CELLAR)
      (EAST TO ROUND-ROOM IF TROLL-FLAG ELSE
       "The troll fends you off with a menacing gesture.")
      (WEST TO MAZE-1 IF TROLL-FLAG ELSE
       "The troll fends you off with a menacing gesture.")
      (NE TO RESERVOIR-SOUTH IF TROLL-FLAG ELSE
       "The troll fends you off with a menacing gesture.")
      (FLAGS RLANDBIT)
      (ACTION TROLL-ROOM-F)>

<GLOBAL TROLL-FLAG <>>

<ROUTINE TROLL-ROOM-F (RARG)
	 <COND (<AND <EQUAL? .RARG ,M-ENTER>
		     <IN? ,TROLL ,HERE>>
		<ENABLE <QUEUE I-FIGHT 2>>
		<SETG P-IT-OBJECT ,TROLL>)>>

<OBJECT TROLL
	(IN TROLL-ROOM)
	(DESC "troll")
	(LDESC
"A troll, brandishing a bloody axe, blocks all passages out of the room.")
	(SYNONYM TROLL)
	(FLAGS ACTORBIT OPENBIT)
	(STRENGTH 2)
	(ACTION TROLL-F)>

<ROUTINE TROLL-F ()
	<COND (<VERB? TELL>
		<SETG P-CONT <>>
		<TELL "He's not much of a conversationalist." CR>)
	      (<VERB? EXAMINE>
	       <TELL <GETP ,TROLL ,P?LDESC> CR>)
	      (<VERB? MUNG>
	       <TELL "The troll laughs at your puny gesture." CR>)
	      (<VERB? THROW GIVE>
	       <TELL
"The troll grabs the " D ,PRSO " and, not having the most discriminating
tastes, gleefully eats it." CR>
	       <REMOVE-CAREFULLY ,PRSO>)
	      (<VERB? LISTEN>
	       <TELL "The troll is mumbling in a guttural tongue." CR>)>>

<OBJECT AXE
	(IN TROLL)
	(DESC "bloody axe")
	(SYNONYM AXE AX)
	(ADJECTIVE BLOODY)
	(FLAGS WEAPONBIT NDESCBIT)
	(SIZE 25)>

<ROOM ROUND-ROOM
      (IN ROOMS)
      (DESC "Round Room")
      (LDESC
"This is a circular room with passages in all directions. Several have
unfortunately been blocked by cave-ins.")
      (EAST TO WHITE-CLIFFS-BEACH)
      (WEST TO TROLL-ROOM)
      (NORTH TO RESERVOIR-SOUTH)
      (SOUTH TO TWISTING-PASSAGE)
      (SE TO DOME-ROOM)
      (FLAGS RLANDBIT)>

<ROOM RESERVOIR-SOUTH
      (IN ROOMS)
      (DESC "Reservoir South")
      (SW TO TROLL-ROOM)
      (EAST TO DAM)
      (SOUTH TO ROUND-ROOM)
      (NORTH TO RESERVOIR IF LOW-TIDE ELSE "You would drown.")
      (FLAGS RLANDBIT)
      (GLOBAL GLOBAL-WATER)
      (PSEUDO "LAKE" LAKE-PSEUDO)
      (ACTION RESERVOIR-SOUTH-F)>

<ROUTINE RESERVOIR-SOUTH-F (RARG)
	<COND (<EQUAL? .RARG ,M-LOOK>
	       <TELL "You are south of ">
	       <COND (,LOW-TIDE
		      <TELL ,FORMERLY-A-LAKE>)
		     (T
		      <TELL "a large lake, far too deep and wide to be">)>
	       <TELL " crossed. Paths lead east, south, and southwest.">)>>

<ROOM DAM
      (IN ROOMS)
      (DESC "Dam")
      (DOWN TO DAM-BASE)
      (NE TO MAINTENANCE-ROOM)
      (WEST TO RESERVOIR-SOUTH)
      (FLAGS RLANDBIT ONBIT)
      (GLOBAL GLOBAL-WATER DAM-OBJECT)
      (ACTION DAM-F)>

<GLOBAL GATE-FLAG <>>

<ROUTINE DAM-F (RARG)
   	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"You are atop Flood Control Dam #3, which was once quite a tourist attraction.
There are exits to the northeast and west, and a scramble down. The ">
		<COND (,LOW-TIDE
		       <TELL
"water level behind the dam is low; the gates are open and water rushes
through the dam and downstream">)
		      (T
		       <TELL
"sluice gates on the dam are closed. Behind the dam is a wide reservoir.
Water is pouring over the top of the abandoned dam">)>
		<TELL
". There is a control panel here, on which a large metal bolt is mounted.
Above the bolt is a small green plastic bubble">
		<COND (,GATE-FLAG
		       <TELL " which is glowing serenely">)>
		<TELL ".">)>>

<OBJECT MATCH
	(IN DAM)
	(DESC "matchbook")
	(LDESC
"There is a matchbook whose cover says \"Visit Beautiful FCD#3\" here.")
	(SYNONYM MATCH MATCHES MATCHBOOK)
	(ADJECTIVE MATCH)
	(FLAGS READBIT TAKEBIT)
	(SIZE 2)
	(TEXT "(Close cover before striking.)")
	(ACTION MATCH-F)>

<GLOBAL MATCH-COUNT 6>

<ROUTINE MATCH-F ("AUX" CNT)
	 <COND (<AND <VERB? LAMP-ON BURN>
		     <EQUAL? ,PRSO ,MATCH>>
		<COND (<NOT <G? ,MATCH-COUNT 0>>
		       <TELL "You have run out of matches." CR>
		       <RTRUE>)>
		<SETG MATCH-COUNT <- ,MATCH-COUNT 1>>
		<COND (<EQUAL? ,HERE ,DRAFTY-ROOM ,LADDER-ROOM>
		       <TELL "A draft instantly blows the match out." CR>)
		      (T
		       <FSET ,MATCH ,FLAMEBIT>
		       <FSET ,MATCH ,ONBIT>
		       <ENABLE <QUEUE I-MATCH 2>>
		       <TELL "One of the matches starts to burn." CR>
		       <COND (<NOT ,LIT>
			      <SETG LIT T>
			      <CRLF>
			      <V-LOOK>)>
		       <RTRUE>)>)
	       (<AND <VERB? LAMP-OFF>
		     <FSET? ,MATCH ,FLAMEBIT>>
		<FCLEAR ,MATCH ,FLAMEBIT>
		<FCLEAR ,MATCH ,ONBIT>
		<QUEUE I-MATCH 0>
		<TELL "The match is out." CR>
		<NOW-DARK?>)
	       (<VERB? COUNT OPEN>
	        <SET CNT <- ,MATCH-COUNT 1>>
		<TELL "You have ">
		<COND (<NOT <G? .CNT 0>>
		       <TELL "no">)
		      (T
		       <TELL N .CNT>)>
		<TELL " match">
		<COND (<NOT <1? .CNT>>
		       <TELL "es">)>
		<TELL ,PERIOD-CR>)
	       (<VERB? EXAMINE>
		<COND (<FSET? ,MATCH ,ONBIT>
		       <TELL "The match is burning.">)
		      (T
		       <TELL
"The matchbook is uninteresting, except for what's written on it.">)>
		<CRLF>)>>

<ROUTINE I-MATCH ()
	 <TELL "The match has gone out." CR>
	 <FCLEAR ,MATCH ,FLAMEBIT>
	 <FCLEAR ,MATCH ,ONBIT>
	 <NOW-DARK?>>

<OBJECT GUIDE
	(IN DAM)
	(DESC "tour guidebook")
	(FDESC
"A guidebook entitled \"Flood Control Dam #3\" is on the ground.")
	(SYNONYM BOOK GUIDEBOOK)
	(ADJECTIVE TOUR GUIDE)
	(FLAGS READBIT TAKEBIT BURNBIT)
	(TEXT
"\"Flood Control Dam #3 was constructed in 783 GUE with a grant of 37
million zorkmids from Lord Dimwit Flathead the Excessive. This impressive
structure is composed of 370,000 cubic feet of concrete, is 256 feet tall
and 193 feet wide.|
|
The construction of FCD#3 took 112 days from ground breaking to dedication.
It required a work force of 384 slaves, 34 slave drivers, and 12 engineers,
2345 bureaucrats, and nearly one million dead trees.|
|
As you start your tour, notice the more interesting features of FCD#3. On
your right...")>

<OBJECT CONTROL-PANEL
	(IN DAM)
	(DESC "control panel")
	(SYNONYM PANEL)
	(ADJECTIVE CONTROL)
	(FLAGS NDESCBIT)>

<GLOBAL LOW-TIDE <>>

<OBJECT BOLT
	(IN DAM)
	(DESC "bolt")
	(SYNONYM BOLT)
	(ADJECTIVE METAL LARGE)
	(FLAGS NDESCBIT TURNBIT TRYTAKEBIT)
	(ACTION BOLT-F)>

<ROUTINE BOLT-F ()
	<COND (<VERB? TURN>
	       <COND (<EQUAL? ,PRSI ,WRENCH>
		      <COND (<AND ,GATE-FLAG
				  <NOT ,LOW-TIDE>>
			     <FCLEAR ,RESERVOIR-SOUTH ,TOUCHBIT>
			     <FSET ,RESERVOIR ,RLANDBIT>
	 		     <FCLEAR ,RESERVOIR ,NONLANDBIT>
	 		     <FCLEAR ,TRUNK ,INVISIBLE>
	 		     <SETG LOW-TIDE T>
			     <SETG SCORE <+ ,SCORE 20>>
			     <TELL
"The sluice gates open and water pours through the dam." CR>)
			    (T
			     <TELL "The bolt won't budge." CR>)>)
		     (T
		      <TELL
"The bolt won't turn using the " D ,PRSI ,PERIOD-CR>)>)
	      (<VERB? TAKE>
	       <TELL ,INTEGRAL-PART>)>>

<OBJECT BUBBLE
	(IN DAM)
	(DESC "green bubble")
	(SYNONYM BUBBLE)
	(ADJECTIVE SMALL GREEN PLASTIC)
	(FLAGS NDESCBIT TRYTAKEBIT)
	(ACTION BUBBLE-F)>

<ROUTINE BUBBLE-F ()
	 <COND (<VERB? TAKE>
		<TELL ,INTEGRAL-PART>)>>

<OBJECT DAM-OBJECT
	(IN LOCAL-GLOBALS)
	(DESC "dam")
	(SYNONYM DAM GATE GATES FCD\#3)
	(FLAGS NDESCBIT TRYTAKEBIT)
	(ACTION DAM-OBJECT-F)>

<ROUTINE DAM-OBJECT-F ()
	 <COND (<VERB? OPEN CLOSE>
		<TELL "Sounds reasonable, but this isn't how." CR>)>>

<ROOM MAINTENANCE-ROOM
      (IN ROOMS)
      (DESC "Maintenance Room")
      (LDESC
"This was the maintenance room for Flood Control Dam #3. Apparently, the room
has been ransacked, for most of the valuable equipment is gone. On one wall
is a group of buttons colored yellow, brown, and red. The only doorway is
southwest.")
      (SW TO DAM)
      (OUT TO DAM)
      (FLAGS RLANDBIT)>

<OBJECT YELLOW-BUTTON
	(IN MAINTENANCE-ROOM)
	(DESC "yellow button")
	(SYNONYM BUTTON)
	(ADJECTIVE YELLOW)
	(FLAGS NDESCBIT)
	(ACTION BUTTON-F)>

<OBJECT BROWN-BUTTON
	(IN MAINTENANCE-ROOM)
	(DESC "brown button")
	(SYNONYM BUTTON)
	(ADJECTIVE BROWN)
	(FLAGS NDESCBIT)
	(ACTION BUTTON-F)>

<OBJECT RED-BUTTON
	(IN MAINTENANCE-ROOM)
	(DESC "red button")
	(SYNONYM BUTTON)
	(ADJECTIVE RED)
	(FLAGS NDESCBIT)
	(ACTION BUTTON-F)>

<ROUTINE BUTTON-F ()
	 <COND (<VERB? PUSH>
		<COND (<EQUAL? ,PRSO ,RED-BUTTON>
		       <TELL "The room lights ">
		       <COND (<FSET? ,HERE ,ONBIT>
			      <FCLEAR ,HERE ,ONBIT>
			      <TELL "go off." CR>)
			     (T
			      <FSET ,HERE ,ONBIT>
			      <TELL "come on." CR>)>)
		      (<EQUAL? ,PRSO ,BROWN-BUTTON>
		       <FCLEAR ,DAM ,TOUCHBIT>
		       <SETG GATE-FLAG <>>
		       <TELL "Click." CR>)
		      (<EQUAL? ,PRSO ,YELLOW-BUTTON>
		       <FCLEAR ,DAM ,TOUCHBIT>
		       <SETG GATE-FLAG T>
		       <TELL "Click." CR>)>)>>

<OBJECT SCREWDRIVER
	(IN MAINTENANCE-ROOM)
	(DESC "screwdriver")
	(SYNONYM SCREWDRIVER DRIVER)
	(ADJECTIVE SCREW)
	(FLAGS TAKEBIT TOOLBIT)>

<OBJECT WRENCH
	(IN MAINTENANCE-ROOM)
	(DESC "wrench")
	(SYNONYM WRENCH)
	(FLAGS TAKEBIT TOOLBIT)
	(SIZE 10)>

<ROOM DAM-BASE
      (IN ROOMS)
      (DESC "Dam Base")
      (LDESC
"You are at the base of the dam, which looms above you. The river Frigid
begins here. Across it, to the east, cliffs form giant walls stretching
north-south along the shore.")
      (UP TO DAM)
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (GLOBAL GLOBAL-WATER RIVER)>

<OBJECT INFLATABLE-BOAT
	(IN DAM-BASE)
	(DESC "pile of plastic")
	(LDESC
"There is a folded pile of plastic here which has a small valve attached.")
	(SYNONYM BOAT PILE PLASTIC VALVE)
	(ADJECTIVE PLASTIC INFLAT)
	(FLAGS TAKEBIT BURNBIT)
	(SIZE 20)
	(ACTION INFLATABLE-BOAT-F)>

<ROUTINE INFLATABLE-BOAT-F ()
	 <COND (<VERB? INFLATE FILL>
		<COND (<NOT <IN? ,INFLATABLE-BOAT ,HERE>>
		       <MUST-BE-ON-GROUND "in">)
		      (<EQUAL? ,PRSI ,PUMP>
		       <MOVE ,INFLATED-BOAT ,HERE>
		       <SETG P-IT-OBJECT ,INFLATED-BOAT>
		       <TELL
"The boat inflates and appears seaworthy.">
		       <COND (<NOT <FSET? ,BOAT-LABEL ,TOUCHBIT>>
			      <TELL
" A tan label is lying inside the boat.">)>
		       <CRLF>
		       <REMOVE-CAREFULLY ,INFLATABLE-BOAT>)
		      (<EQUAL? ,PRSI ,LUNGS>
		       <TELL "You haven't enough lung power." CR>)
		      (T
		       <TELL "With a " D ,PRSI "!?!" CR>)>)>>

<OBJECT BOAT-LABEL
	(IN INFLATED-BOAT)
	(DESC "tan label")
	(SYNONYM LABEL)
	(ADJECTIVE TAN)
	(FLAGS READBIT TAKEBIT BURNBIT)
	(SIZE 2)
	(TEXT
"Hello, Sailor! Instructions: To enter a body of water, say \"Launch\". To get
to shore, say \"Land\" or the direction you want to go. FROBOZZ MAGIC BOAT
COMPANY Warranty: This boat is guaranteed for 9 seconds from date of purchase
or until used, whichever comes first. Good Luck!")>

<OBJECT INFLATED-BOAT
	(DESC "magic boat")
	(SYNONYM BOAT RAFT)
	(ADJECTIVE INFLAT PLASTIC)
	(FLAGS TAKEBIT BURNBIT VEHBIT OPENBIT SEARCHBIT)
	(CAPACITY 100)
	(SIZE 20)
	(ACTION INFLATED-BOAT-F)>

<ROUTINE INFLATED-BOAT-F ("OPTIONAL" (RARG <>) "AUX" TMP)
	 <COND (<EQUAL? .RARG ,M-BEG>
		<COND (<VERB? WALK>
		       <COND (<AND <EQUAL? ,HERE ,RIVER-1 ,RIVER-2 ,RIVER-3> 
				 <PRSO? ,P?LAND ,P?EAST ,P?WEST ,P?UP ,P?DOWN>>
			      <RFALSE>)
			     (<AND <EQUAL? ,HERE ,RESERVOIR>
				   <EQUAL? ,PRSO ,P?NORTH ,P?SOUTH>>
			      <RFALSE>)
			     (T
			      <TELL "Read the tan label!" CR>)>)
		      (<VERB? LAUNCH>
		       <COND (<OR <EQUAL? ,HERE ,RIVER-1 ,RIVER-2 ,RIVER-3>
				  <EQUAL? ,HERE ,RESERVOIR>>
			      <TELL ,ALREADY>)
			     (<EQUAL? <SET TMP <GO-NEXT ,RIVER-LAUNCH>> 1>
			      <ENABLE
			       <QUEUE I-RIVER <LKP ,HERE ,RIVER-SPEEDS>>>
			      <RTRUE>)
			     (<NOT <EQUAL? .TMP 2>>
			      <TELL ,YOU-CANT "launch it here." CR>)
			     (T
			      <RTRUE>)>)>)
	       (.RARG
		<RFALSE>)
	       (<VERB? INFLATE FILL>
		<TELL "Inflating it further might burst it." CR>)
	       (<VERB? DEFLATE>
		<COND (<IN? ,ADVENTURER ,INFLATED-BOAT>
		       <TELL "You're in it!" CR>)
		      (<NOT <IN? ,INFLATED-BOAT ,HERE>>
		       <MUST-BE-ON-GROUND "de">)
		      (T
		       <MOVE ,INFLATABLE-BOAT ,HERE>
		       <SETG P-IT-OBJECT ,INFLATABLE-BOAT>
		       <TELL "The boat deflates." CR>
		       <REMOVE-CAREFULLY ,INFLATED-BOAT>)>)
	       (<VERB? CLIMB-ON>
		<PERFORM ,V?BOARD ,PRSO>
		<RTRUE>)>>

<ROUTINE MUST-BE-ON-GROUND (STRING)
	 <TELL ,YOU-CANT .STRING "flate it unless it's on the ground." CR>>

<ROOM WHITE-CLIFFS-BEACH
      (IN ROOMS)
      (DESC "White Cliffs Beach")
      (LDESC
"You are on a narrow strip of beach between the White Cliffs and the Frigid
River. A tiny passage leads west into the cliff.")
      (WEST TO ROUND-ROOM)
      (FLAGS RLANDBIT SACREDBIT)
      (GLOBAL GLOBAL-WATER RIVER)>

<OBJECT WHITE-CLIFF
	(IN WHITE-CLIFFS-BEACH)
	(DESC "White Cliffs")
	(SYNONYM CLIFF CLIFFS)
	(ADJECTIVE WHITE)
	(FLAGS NDESCBIT CLIMBBIT)
	(ACTION WHITE-CLIFF-F)>

<ROUTINE WHITE-CLIFF-F ()
	 <COND (<VERB? CLIMB-DOWN CLIMB>
		<TELL "The cliff is unclimbable." CR>)>>

<ROOM DOME-ROOM
      (IN ROOMS)
      (DESC "Dome Room")
      (NW TO ROUND-ROOM)
      (DOWN TO TEMPLE IF DOME-FLAG ELSE "You'd fracture many bones.")
      (FLAGS RLANDBIT)
      (PSEUDO "DOME" DOME-PSEUDO)
      (ACTION DOME-ROOM-F)>

<GLOBAL DOME-FLAG <>>

<ROUTINE DOME-ROOM-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"You are at the periphery of a large dome, which forms the ceiling of another
room below. A wooden railing protects you from a precipitous drop.">
		<COND (,DOME-FLAG
		       <TELL
" A rope hangs from the rail and ends about ten feet from the floor below.">)>)
	       (<AND <EQUAL? .RARG ,M-ENTER>
		     ,DEAD>
		<MOVE ,WINNER ,TEMPLE>
		<SETG HERE ,TEMPLE>
		<TELL
"As you enter, a strong pull as if from a wind draws you over the
railing and down." CR>)
	       (<AND <EQUAL? .RARG ,M-BEG>
		     <VERB? LEAP>>
		<JIGS-UP "You should have looked before you leaped.">)>>

<ROUTINE DOME-PSEUDO ()
	 <RFALSE>>

<OBJECT RAILING
	(IN DOME-ROOM)
	(DESC "wooden railing")
	(SYNONYM RAILING RAIL)
	(ADJECTIVE WOODEN)
	(FLAGS NDESCBIT)>

<ROOM TEMPLE
      (IN ROOMS)
      (DESC "Temple")
      (DOWN TO EGYPTIAN-ROOM)
      (EAST TO EGYPTIAN-ROOM)
      (UP "You cannot reach the rope.")
      (SOUTH TO ALTAR)
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (GLOBAL STAIRS)
      (PSEUDO "DOME" DOME-PSEUDO)
      (ACTION TEMPLE-F)>

<ROUTINE TEMPLE-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL "This is a large domed temple. ">
		<COND (,DOME-FLAG
		       <TELL
"A piece of rope descends from the railing of the dome, about 20 feet
above, ending some five feet above your head. ">)>
		<TELL
"On the east wall is an ancient inscription, probably a prayer in a
long-forgotten language. Below the prayer, a stair leads down. The temple's
altar is to the south. In the center of the room sits a white marble
pedestal.">)>>

<OBJECT PEDESTAL
	(IN TEMPLE)
	(DESC "pedestal")
	(SYNONYM PEDESTAL)
	(ADJECTIVE WHITE MARBLE)
	(FLAGS NDESCBIT CONTBIT SEARCHBIT OPENBIT SURFACEBIT)
	(CAPACITY 30)>

<OBJECT TORCH
	(IN PEDESTAL)
	(DESC "torch")
	(FDESC "Sitting on the pedestal is a flaming torch, made of ivory.")
	(SYNONYM TORCH IVORY TREASURE)
	(ADJECTIVE FLAMING IVORY)
	(FLAGS TREASUREBIT TAKEBIT FLAMEBIT ONBIT LIGHTBIT)
	(SIZE 20)
	(VALUE 12)
	(ACTION TORCH-F)>

<ROUTINE TORCH-F ()
	 <COND (<VERB? EXAMINE>
		<TELL "The torch is burning." CR>)
	       (<AND <VERB? POUR-ON>
		     <PRSO? ,WATER>>
		<TELL "The water evaporates before it gets close." CR>)
	       (<AND <VERB? LAMP-OFF>
		     <FSET? ,PRSO ,ONBIT>>
		<TELL
"You nearly burn your hand trying to extinguish the flame." CR>)>>

<OBJECT BELL
	(IN TEMPLE)
	(DESC "brass bell")
	(SYNONYM BELL)
	(ADJECTIVE SMALL BRASS)
	(FLAGS TAKEBIT)
	(ACTION BELL-F)>

<ROUTINE BELL-F ()
	 <COND (<AND <VERB? RING>
		     <OR <NOT <EQUAL? ,HERE ,HADES>>
			 ,HADES-FLAG>>
		<TELL "Ding, dong." CR>)>>

<OBJECT PRAYER
	(IN TEMPLE)
	(DESC "prayer")
	(SYNONYM PRAYER INSCRIPTION)
	(ADJECTIVE ANCIENT OLD)
	(FLAGS READBIT SACREDBIT NDESCBIT)
	(TEXT
"The prayer is a philippic against small insects, absent-mindedness, and the
picking up and dropping of small objects. All evidence indicates that the
beliefs of the ancient Zorkers were obscure.")>

<ROOM EGYPTIAN-ROOM
      (IN ROOMS)
      (DESC "Egyptian Room")
      (LDESC "This looks like an Egyptian tomb. A stair ascends to the west.")
      (WEST TO TEMPLE)
      (UP TO TEMPLE)
      (FLAGS RLANDBIT)
      (GLOBAL STAIRS)>

<OBJECT COFFIN
	(IN EGYPTIAN-ROOM)
	(DESC "gold coffin")
	(LDESC
"The solid-gold coffin used for the burial of Ramses II is here.")
	(SYNONYM COFFIN CASKET TREASURE)
	(ADJECTIVE GOLD)
	(FLAGS TREASUREBIT TAKEBIT CONTBIT SACREDBIT SEARCHBIT)
	(CAPACITY 35)
	(SIZE 55)
	(VALUE 13)>

<OBJECT SCEPTRE
	(IN COFFIN)
	(DESC "sceptre")
	(FDESC
"A sceptre, possibly that of ancient Egypt itself, is in the coffin. The
sceptre is ornamented with jewels.")
	(SYNONYM SCEPTRE TREASURE)
	(ADJECTIVE ANCIENT)
	(FLAGS TREASUREBIT TAKEBIT)
	(SIZE 3)
	(VALUE 9)
	(ACTION SCEPTRE-F)>

<ROUTINE SCEPTRE-F ()
	 <COND (<VERB? WAVE RAISE>
		<COND (<OR <EQUAL? ,HERE ,ARAGAIN-FALLS>
			   <EQUAL? ,HERE ,END-OF-RAINBOW>>
		       <COND (<NOT ,RAINBOW-FLAG>
			      <TELL
"The rainbow solidifies and is now walkable (the stairs
and bannister are the giveaway).">
			      <COND (<AND <EQUAL? ,HERE ,END-OF-RAINBOW>
					  <IN? ,POT-OF-GOLD ,END-OF-RAINBOW>
					  <FSET? ,POT-OF-GOLD ,INVISIBLE>>
				     <TELL
" A shimmering pot of gold appears at the end of the rainbow.">)>
			      <FCLEAR ,POT-OF-GOLD ,INVISIBLE>
			      <SETG RAINBOW-FLAG T>
			      <CRLF>)
			     (T
			      <SETG RAINBOW-FLAG <>>
			      <TELL
"The rainbow has become somewhat run-of-the-mill." CR>)>)
		      (T
		       <TELL
"Dazzling colors briefly emanate from the sceptre." CR>)>)>>

<ROOM ALTAR
      (IN ROOMS)
      (DESC "Altar")
      (LDESC
"Standing by the temple's altar, you can see a small hole in the floor
which leads into darkness. The rest of the temple is north of here.")
      (NORTH TO TEMPLE)
      (DOWN TO WINDY-CAVE IF COFFIN-CURE ELSE
       "You haven't a prayer of getting the coffin down there.")
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (ACTION ALTAR-F)>

<GLOBAL COFFIN-CURE <>>

<ROUTINE ALTAR-F (RARG)
	 <COND (<EQUAL? .RARG ,M-BEG>
		<SETG COFFIN-CURE <NOT <IN? ,COFFIN ,WINNER>>>
		<RFALSE>)>>

<OBJECT ALTAR-OBJECT
	(IN ALTAR)
	(DESC "altar")
	(SYNONYM ALTAR)
	(FLAGS NDESCBIT SURFACEBIT CONTBIT OPENBIT SEARCHBIT)
	(CAPACITY 50)>

<OBJECT BLACK-BOOK
	(IN ALTAR-OBJECT)
	(DESC "black book")
	(FDESC "On the altar is a large black book, open to page 569.")
	(SYNONYM BOOK PRAYER PAGE BOOKS)
	(ADJECTIVE LARGE BLACK)
	(FLAGS READBIT TAKEBIT CONTBIT BURNBIT TURNBIT)
	(SIZE 10)
	(TEXT
"Commandment #12592|
|
Oh ye who say: \"Hello sailor\":|
Dost thou know thy sin?|
Yea, thou shalt be crushed by stones.|
Shall angry gods turn thee to dust?|
Shall they stab thy eye with a stick!|
Even to eternity shalt thou roam and|
Unto Hades shalt thou be sent at last.|
Surely thou shalt then repent.")
	(ACTION BLACK-BOOK-F)>

<ROUTINE BLACK-BOOK-F ()
	 <COND (<VERB? OPEN>
		<TELL "The book is already open." CR>)
	       (<VERB? CLOSE>
		<TELL "Oddly, the book cannot be closed." CR>)
	       (<OR <VERB? TURN>
		    <AND <VERB? READ-PAGE>
			 <EQUAL? ,PRSI ,INTNUM>
			 <NOT <EQUAL? ,P-NUMBER 569>>>>
		<TELL
"Beside page 569, there is only one page with legible printing. It seems to be
about the banishment of evil using certain noises, lights, and prayers." CR>)>>

<OBJECT CANDLES
	(IN ALTAR-OBJECT)
	(DESC "pair of candles")
	(FDESC "On the two ends of the altar are burning candles.")
	(SYNONYM CANDLES PAIR)
	(ADJECTIVE BURNING)
	(FLAGS TAKEBIT FLAMEBIT ONBIT LIGHTBIT)
	(SIZE 10)
	(ACTION CANDLES-F)>

<ROUTINE CANDLES-F ()
	 <COND (<NOT <FSET? ,CANDLES ,TOUCHBIT>>
		<ENABLE <INT I-CANDLES>>)>
	 <COND (<EQUAL? ,CANDLES ,PRSI>
		<RFALSE>)
	       (<VERB? LAMP-ON BURN>
		<COND (<FSET? ,CANDLES ,RMUNGBIT>
		       <TELL
"Alas, there's not enough candle left to burn." CR>)
		      (<FSET? ,CANDLES ,ONBIT>
		       <TELL ,CANDLES-ARE "already lit!" CR>)
		      (<NOT ,PRSI>
		       <COND (<FSET? ,MATCH ,FLAMEBIT>
			      <TELL "(with the match)" CR>
			      <PERFORM ,V?LAMP-ON ,CANDLES ,MATCH>
			      <RTRUE>)
			     (T
			      <TELL "With what?" CR>
			      <RFATAL>)>)
		      (<AND <EQUAL? ,PRSI ,MATCH>
			    <FSET? ,MATCH ,ONBIT>>
		       <FSET ,CANDLES ,ONBIT>
		       <ENABLE <INT I-CANDLES>>
		       <TELL ,CANDLES-ARE "are now lit." CR>)
		      (<EQUAL? ,PRSI ,TORCH>
		       <TELL "The torch's heat vaporizes the candles." CR>
		       <REMOVE-CAREFULLY ,CANDLES>)
		      (T
		       <TELL <PICK-ONE ,YUKS> CR>)>) 
	       (<VERB? COUNT>
		<TELL "How many in a pair? Don't tell me, I'll get it..." CR>)
	       (<VERB? LAMP-OFF>
		<DISABLE <INT I-CANDLES>>
		<COND (<FSET? ,CANDLES ,ONBIT>
		       <FCLEAR ,CANDLES ,ONBIT>
		       <FSET ,CANDLES ,TOUCHBIT>
		       <TELL "The flame is extinguished." CR>
		       <NOW-DARK?>)
		      (T
		       <TELL ,CANDLES-ARE "not lighted." CR>)>)
	       (<AND <VERB? PUT>
		     <FSET? ,PRSI ,BURNBIT>>
		<PERFORM ,V?BURN ,PRSI ,CANDLES>
		<RTRUE>)
	       (<VERB? EXAMINE>
		<TELL ,CANDLES-ARE>
		<COND (<FSET? ,CANDLES ,ONBIT>
		       <TELL "burning.">)
		      (T
		       <TELL "out.">)>
		<CRLF>)>>

<GLOBAL CANDLE-TABLE
	<TABLE (PURE)
	       20 "The candles grow shorter."
	       10 "The candles are becoming quite short."
	        5 "The candles won't last long now." 0>>

<ROUTINE WINDY-CAVE-F (RARG)
	 <COND (<AND <EQUAL? .RARG ,M-END>
		     <IN? ,CANDLES ,WINNER>
		     <FSET? ,CANDLES ,ONBIT>
		     <PROB 50 80>>
		<DISABLE <INT I-CANDLES>>
		<FCLEAR ,CANDLES ,ONBIT>
		<TELL "A gust of wind blows out your candles!" CR>
		<NOW-DARK?>)>>

<ROUTINE I-CANDLES ("AUX" TICK (TBL <VALUE CANDLE-TABLE>))
	 <FSET ,CANDLES ,TOUCHBIT>
	 <ENABLE <QUEUE I-CANDLES <SET TICK <GET .TBL 0>>>>
	 <LIGHT-INT ,CANDLES .TBL .TICK>
	 <COND (<NOT <0? .TICK>>
		<SETG CANDLE-TABLE <REST .TBL 4>>)>>

<ROOM TWISTING-PASSAGE
      (IN ROOMS)
      (DESC "Twisting Passage")
      (LDESC
"This is a crooked corridor from the north, with forks to the southwest
and south.")
      (NORTH TO ROUND-ROOM)
      (SOUTH TO WINDY-CAVE)
      (SW TO MIRROR-ROOM-SOUTH)
      (FLAGS RLANDBIT)>

<ROOM MIRROR-ROOM-SOUTH
      (IN ROOMS)
      (DESC "Mirror Room")
      (NE TO TWISTING-PASSAGE)
      (EAST TO WINDY-CAVE)
      (FLAGS RLANDBIT ONBIT)
      (GLOBAL MIRROR)
      (ACTION MIRROR-ROOM-F)>

<ROOM WINDY-CAVE
      (IN ROOMS)
      (DESC "Windy Cave")
      (LDESC
"This is a tiny cave with entrances west and north, and a dark, forbidding
staircase leading down.")
      (NORTH TO TWISTING-PASSAGE)
      (WEST TO MIRROR-ROOM-SOUTH)
      (DOWN TO ENTRANCE-TO-HADES)
      (FLAGS RLANDBIT)
      (GLOBAL STAIRS)
      (ACTION WINDY-CAVE-F)>

<ROOM ENTRANCE-TO-HADES
      (IN ROOMS)
      (DESC "Entrance to Hades")
      (UP TO WINDY-CAVE)
      (IN TO HADES IF HADES-FLAG ELSE
       "The spirits block you from passing through the gate.")
      (SOUTH TO HADES IF HADES-FLAG ELSE
       "The spirits block you from passing through the gate.")
      (FLAGS RLANDBIT ONBIT)
      (GLOBAL BODIES)
      (PSEUDO "GATE" GATE-PSEUDO "GATES" GATE-PSEUDO)
      (ACTION ENTRANCE-TO-HADES-F)>

<GLOBAL HADES-FLAG <>>

<ROUTINE ENTRANCE-TO-HADES-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"You are outside a large gate inscribed, \"Abandon hope all ye who enter
here!\" The gate is open; beyond you can see a desolation, with a pile of
mangled bodies in one corner. Thousands of voices, lamenting some hideous
fate, can be heard.">
		<COND (<AND <NOT ,HADES-FLAG>
			    <NOT ,DEAD>>
		       <TELL
" The gate is barred by evil spirits, who jeer at your attempts to pass.">)>)
	       (<EQUAL? .RARG ,M-BEG>
		<COND (<VERB? EXORCISE>
		       <COND (,HADES-FLAG
			      <TELL ,ALREADY CR>)
			     (<AND <HELD? ,BELL>
				   <HELD? ,BLACK-BOOK>
				   <HELD? ,CANDLES>>
			      <TELL ,PERFORM-CEREMONY>)
			     (T
			      <TELL
"You're not equipped for an exorcism." CR>)>)
		      (<AND <NOT ,HADES-FLAG>
			    <VERB? RING>
			    <EQUAL? ,PRSO ,BELL>>
		       <SETG XB T>
		       <ENABLE <QUEUE I-XB 6>>
		       <TELL
"A deep peal issues from the bell. The wraiths stop jeering and an expression
of long-forgotten terror takes shape on their ashen faces.">
		       <COND (<IN? ,CANDLES ,WINNER>
			      <MOVE ,CANDLES ,HERE>
			      <FCLEAR ,CANDLES ,ONBIT>
			      <DISABLE <INT I-CANDLES>>
			      <TELL
" In your confusion, the candles drop to the ground (and they are out).">)>
		       <CRLF>)
		      (<AND ,XC
			    <VERB? READ>
			    <EQUAL? ,PRSO ,BLACK-BOOK>
			    <NOT ,HADES-FLAG>>
		       <REMOVE ,GHOSTS>
		       <SETG HADES-FLAG T>
		       <DISABLE <INT I-XC>>
		       <TELL
"The prayer reverberates in a deafening confusion. As the last word fades, a
heart-stopping scream fills the cavern, and the spirits, sensing a greater
power, flee through the walls." CR>)>)
	       (<EQUAL? .RARG ,M-END>
		<COND (<AND ,XB
			    <IN? ,CANDLES ,WINNER>
			    <FSET? ,CANDLES ,ONBIT>
			    <NOT ,XC>>
		       <SETG XC T>
		       <DISABLE <INT I-XB>>
		       <ENABLE <QUEUE I-XC 3>>
		       <TELL
"The flames flicker wildly and the earth trembles beneath your feet. The
spirits cower at your unearthly power." CR>)>)>>

<ROUTINE GATE-PSEUDO ()
	 <COND (<VERB? THROUGH>
		<DO-WALK ,P?IN>)
	       (T
		<TELL
"The gate is protected by an invisible force. It makes your teeth ache
to touch it." CR>)>>

<OBJECT GHOSTS
	(IN ENTRANCE-TO-HADES)
	(DESC "number of ghosts")
	(SYNONYM GHOSTS SPIRITS FORCE)
	(ADJECTIVE INVISIBLE EVIL)
	(FLAGS ACTORBIT NDESCBIT)
	(ACTION GHOSTS-F)>

<ROUTINE GHOSTS-F ()
	 <COND (<VERB? TELL>
		<TELL "The spirits jeer loudly and ignore you." CR>
		<SETG P-CONT <>>)
	       (<VERB? EXORCISE>
		<TELL ,PERFORM-CEREMONY>)
	       (<AND <VERB? ATTACK MUNG>
		     <EQUAL? ,PRSO ,GHOSTS>>
		<TELL ,YOU-CANT "attack a spirit with material objects!" CR>)>>

<GLOBAL XB <>>

<GLOBAL XC <>>

<ROUTINE I-XB ()
	 <OR ,XC
	     <AND <EQUAL? ,HERE ,ENTRANCE-TO-HADES>
		  <TELL
"The tension of this ceremony is broken, and the wraiths, amused but
shaken at your clumsy attempt, resume their hideous jeering." CR>>>
	 <SETG XB <>>>

<ROUTINE I-XC ()
	 <SETG XC <>>
	 <I-XB>>

<ROOM HADES
      (IN ROOMS)
      (DESC "Hades")
      (LDESC
"You have entered the Land of the Living Dead. Thousands of lost souls can
be heard weeping and moaning. In a corner are the remains of previous
adventurers less fortunate than yourself. A passage exits to the north.")
      (OUT TO ENTRANCE-TO-HADES)
      (NORTH TO ENTRANCE-TO-HADES)
      (FLAGS RLANDBIT ONBIT)
      (GLOBAL BODIES)>

<OBJECT BODIES
	(IN LOCAL-GLOBALS)
	(DESC "pile of bodies")
	(SYNONYM BODIES BODY REMAINS PILE)
	(ADJECTIVE MANGLED)
	(FLAGS NDESCBIT TRYTAKEBIT)
	(ACTION BODIES-F)>

<ROUTINE BODIES-F ()
	 <COND (<VERB? TAKE>
		<TELL "Yuk!" CR>)
	       (<VERB? MUNG BURN ATTACK>
		<JIGS-UP
"A voice booms from the darkness, \"Your disrespect costs you your life!\"">)>>

<OBJECT SKULL
	(IN HADES)
	(DESC "crystal skull")
	(FDESC
"Lying in one corner is a beautifully carved crystal skull. It appears to
be grinning at you rather nastily.")
	(SYNONYM SKULL HEAD TREASURE)
	(ADJECTIVE CRYSTAL)
	(FLAGS TREASUREBIT TAKEBIT)
	(VALUE 22)>
\
<ROOM RIVER-1
      (IN ROOMS)
      (DESC "Frigid River")
      (LDESC
"You are on the Frigid River just below the dam. The river flows quietly
here. There is a landing on the west shore.")
      (UP "You cannot go upstream due to strong currents.")
      (WEST TO DAM-BASE)
      (LAND TO DAM-BASE)
      (DOWN TO RIVER-2)
      (EAST "The White Cliffs prevent your landing here.")
      (FLAGS NONLANDBIT SACREDBIT ONBIT)
      (GLOBAL GLOBAL-WATER RIVER)>

<ROOM RIVER-2
      (IN ROOMS)
      (DESC "Frigid River")
      (LDESC
"The river descends here into a valley. The are no landings on either
shore. In the distance a faint rumbling can be heard.")
      (UP "You cannot go upstream due to strong currents.")
      (DOWN TO RIVER-3)
      (LAND "There are no landings here.")
      (FLAGS NONLANDBIT SACREDBIT)
      (GLOBAL GLOBAL-WATER RIVER)>

<ROOM RIVER-3
      (IN ROOMS)
      (DESC "Frigid River")
      (LDESC
"The sound of rushing water is nearly unbearable here. On the both the
east and west shores are beaches.")
      (UP "You cannot go upstream due to strong currents.")
      (EAST TO SANDY-BEACH)
      (WEST TO WHITE-CLIFFS-BEACH)
      (LAND "East or west?")
      (FLAGS NONLANDBIT SACREDBIT ONBIT)
      (GLOBAL GLOBAL-WATER RIVER)>

<OBJECT BUOY
	(IN RIVER-3)
	(DESC "red buoy")
	(FDESC "There is a red buoy here (probably a warning).")
	(SYNONYM BUOY)
	(ADJECTIVE RED)
	(FLAGS TAKEBIT CONTBIT SEARCHBIT)
	(CAPACITY 20)
	(SIZE 10)
	(ACTION BUOY-F)>

<ROUTINE BUOY-F ()
	 <COND (<VERB? OPEN>
		<SCORE-OBJ ,EMERALD>
		<RFALSE>)
	       (<AND <VERB? TAKE>
		     <NOT <IN? ,BUOY ,ADVENTURER>>
		     <IN? ,EMERALD ,BUOY>>
		<MOVE ,BUOY ,ADVENTURER>
	        <TELL
"As you take the buoy, you notice something odd about the feel of it." CR>)>>

<OBJECT EMERALD
	(IN BUOY)
	(DESC "large emerald")
	(SYNONYM EMERALD TREASURE)
	(ADJECTIVE LARGE)
	(FLAGS TREASUREBIT TAKEBIT)
	(VALUE 18)>

<ROOM SANDY-BEACH
      (IN ROOMS)
      (DESC "Sandy Beach")
      (LDESC
"You are on a large beach on the east shore of the river, which flows by
quickly. A path runs south along the river, and a sand-filled passage leads
northeast.")
      (NE TO SANDY-CAVE)
      (SOUTH TO ARAGAIN-FALLS)
      (FLAGS RLANDBIT SACREDBIT)
      (GLOBAL GLOBAL-WATER RIVER)>

<OBJECT SHOVEL
	(IN SANDY-BEACH)
	(DESC "shovel")
	(SYNONYM SHOVEL)
	(FLAGS TAKEBIT TOOLBIT)
	(SIZE 15)>

<ROOM SANDY-CAVE
      (IN ROOMS)
      (DESC "Sandy Cave")
      (LDESC "This is a sand-filled cave whose exit is to the southwest.")
      (SW TO SANDY-BEACH)
      (OUT TO SANDY-BEACH)
      (FLAGS RLANDBIT)>

<OBJECT SAND
	(IN SANDY-CAVE)
	(DESC "sand")
	(SYNONYM SAND)
	(FLAGS NDESCBIT)
	(ACTION SAND-F)>

<ROUTINE SAND-F ()
	 <COND (<AND <VERB? DIG>
		     <PRSI? ,SHOVEL>>
		<SETG BEACH-DIG <+ 1 ,BEACH-DIG>>
		<COND (<G? ,BEACH-DIG 3>
		       <SETG BEACH-DIG -1>
		       <COND (<IN? ,SCARAB ,HERE>
			      <FSET ,SCARAB ,INVISIBLE>)>
		       <JIGS-UP "The hole collapses, smothering you.">)
		      (<EQUAL? ,BEACH-DIG 3>
		       <COND (<FSET? ,SCARAB ,INVISIBLE>
			      <SETG P-IT-OBJECT ,SCARAB>
			      <FCLEAR ,SCARAB ,INVISIBLE>
			      <TELL "You spot a scarab in the sand." CR>)>)
		      (T
		       <TELL <GET ,BDIGS ,BEACH-DIG> CR>)>)>>

<GLOBAL BEACH-DIG -1>

<GLOBAL BDIGS
	<TABLE (PURE)
	       "You seem to be digging a hole here."
	       "The hole is getting deeper, but that's about it."
	       "You are surrounded by a wall of sand on all sides.">>

<OBJECT SCARAB
	(IN SANDY-CAVE)
	(DESC "beautiful jeweled scarab")
	(SYNONYM SCARAB BUG BEETLE TREASURE)
	(ADJECTIVE BEAUTI JEWELED)
	(FLAGS TREASUREBIT TAKEBIT INVISIBLE)
	(SIZE 8)
	(VALUE 15)>

<ROOM ARAGAIN-FALLS
      (IN ROOMS)
      (DESC "Aragain Falls")
      (WEST TO END-OF-RAINBOW IF RAINBOW-FLAG ELSE
       "Can you walk on water vapor?")
      (DOWN "It's a long way...")
      (NORTH TO SANDY-BEACH)
      (UP TO END-OF-RAINBOW IF RAINBOW-FLAG ELSE
       "Can you walk on water vapor?")
      (FLAGS RLANDBIT SACREDBIT ONBIT)
      (GLOBAL STAIRS GLOBAL-WATER RIVER RAINBOW)
      (ACTION ARAGAIN-FALLS-F)>

<ROUTINE ARAGAIN-FALLS-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"You are near the top of Aragain Falls. The only path leads north. A ">
		<COND (,RAINBOW-FLAG
		       <TELL "solid">)
		      (T
		       <TELL "beautiful">)>
		<TELL " rainbow spans the falls to the west.">)>>

<OBJECT RIVER
	(IN LOCAL-GLOBALS)
	(DESC "river")
	(SYNONYM RIVER)
	(ADJECTIVE FRIGID)
	(FLAGS NDESCBIT)
	(ACTION RIVER-F)>

<ROUTINE RIVER-F ()
	 <COND (<AND <VERB? PUT>
		     <EQUAL? ,PRSI ,RIVER>>
		<COND (<EQUAL? ,PRSO ,ME>
		       <PERFORM ,V?THROUGH ,RIVER>
		       <RTRUE>)
		      (<EQUAL? ,PRSO ,INFLATED-BOAT>
		       <TELL "Read the tan label!" CR>)
		      (<FSET? ,PRSO ,BURNBIT>
		       <TELL "The current sweeps it away." CR>
		       <REMOVE-CAREFULLY ,PRSO>)
		      (T
		       <TELL "The " D ,PRSO " sinks into the water." CR>
		       <REMOVE-CAREFULLY ,PRSO>)>)
	       (<VERB? LEAP THROUGH>
		<TELL
"The river is wide and dangerous, with swift currents and hidden rocks. You
decide to forgo your swim." CR>)>>

<GLOBAL RIVER-SPEEDS
	<LTABLE (PURE) RIVER-1 5 RIVER-2 4 RIVER-3 3>>

<GLOBAL RIVER-NEXT
	<LTABLE (PURE) RIVER-1 RIVER-2 RIVER-3>>

<GLOBAL RIVER-LAUNCH
	<LTABLE (PURE) DAM-BASE RIVER-1
		WHITE-CLIFFS-BEACH RIVER-3
		SANDY-BEACH RIVER-3
		RESERVOIR-SOUTH RESERVOIR
		RESERVOIR-NORTH RESERVOIR>>

<ROUTINE I-RIVER ("AUX" RM)
	 <COND (<NOT <EQUAL? ,HERE ,RIVER-1 ,RIVER-2 ,RIVER-3>>
		<DISABLE <INT I-RIVER>>)
	       (<SET RM <LKP ,HERE ,RIVER-NEXT>>
		<ENABLE <QUEUE I-RIVER <LKP ,HERE ,RIVER-SPEEDS>>>
		<TELL "The current carries you downstream." CR CR>
		<GOTO .RM>)
	       (T
		<JIGS-UP
"Unfortunately, the raft provides little protection from the boulders one
meets at the bottom of waterfalls. Including this one.">)>>

;"0 -> no next, 1 -> success, 2 -> failed move"

<ROUTINE GO-NEXT (TBL "AUX" VAL)
	 <COND (<SET VAL <LKP ,HERE .TBL>>
		<COND (<NOT <GOTO .VAL>>
		       2)
		      (T
		       1)>)>>

<ROUTINE LKP (ITM TBL "AUX" (CNT 0) (LEN <GET .TBL 0>))
	 <REPEAT ()
		 <COND (<G? <SET CNT <+ .CNT 1>> .LEN>
			<RFALSE>)
		       (<EQUAL? <GET .TBL .CNT> .ITM>
			<COND (<EQUAL? .CNT .LEN>
			       <RFALSE>)
			      (T
			       <RETURN <GET .TBL <+ .CNT 1>>>)>)>>>