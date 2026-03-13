"ABOVE-GROUND for
			     Mini-Zork '87
	  (c) Copyright 1987 Infocom, Inc. All Rights Reserved"

;"outside the house"

<ROOM WEST-OF-HOUSE
      (IN ROOMS)
      (DESC "West of House")
      (NORTH TO NORTH-OF-HOUSE)
      (SOUTH TO SOUTH-OF-HOUSE)
      (NE TO NORTH-OF-HOUSE)
      (SE TO SOUTH-OF-HOUSE)
      (EAST "The door is boarded and you can't remove the boards.")
      (SW TO INSIDE-THE-BARROW IF WON-FLAG)
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (GLOBAL WHITE-HOUSE BOARD FOREST)
      (ACTION WEST-OF-HOUSE-F)>

<ROUTINE WEST-OF-HOUSE-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"You are standing in an open field west of a white house, with a
boarded front door. ">
		<COND (,WON-FLAG
		       <TELL
"A secret path leads southwest into the forest. ">)>
		<TELL "You could circle the house to the north or south.">)>>

<OBJECT MAILBOX
	(IN WEST-OF-HOUSE)
	(DESC "small mailbox")
	(SYNONYM MAILBOX BOX)
	(ADJECTIVE SMALL MAIL)
	(FLAGS CONTBIT TRYTAKEBIT SEARCHBIT)
	(CAPACITY 10)
	(ACTION MAILBOX-F)>

<ROUTINE MAILBOX-F ()
	 <COND (<AND <VERB? TAKE>
		     <PRSO? ,MAILBOX>>
		<FASTENED ,MAILBOX "ground">)>>

<OBJECT LEAFLET
	(IN MAILBOX)
	(DESC "leaflet")
	(SYNONYM LEAFLET MAIL)
	(FLAGS READBIT TAKEBIT BURNBIT)
	(SIZE 2)
	(ACTION LEAFLET-F)>

<ROUTINE LEAFLET-F ()
	 <COND (<VERB? READ>
		<TELL
"\"WELCOME TO ZORK, a game of adventure, danger, and low cunning. No computer
should be without one!\"|
|
Note: this \"mini-zork\" contains only a sub-set of the locations, puzzles,
and descriptions found" ,DISK-BASED>)>>

<OBJECT FRONT-DOOR
	(IN WEST-OF-HOUSE)
	(SYNONYM DOOR)
	(ADJECTIVE FRONT BOARDED)
	(DESC "door")
	(FLAGS DOORBIT NDESCBIT)
	(ACTION WOODEN-DOOR-F)>

<GLOBAL WON-FLAG <>>

<ROOM INSIDE-THE-BARROW
      (IN ROOMS)
      (DESC "Inside the Barrow")
      (LDESC
"You have entered a stone barrow. The door closes behind you, leaving you in
darkness, but ahead is a brightly-lit cavern. Floating in the cavern is a large
sign: \"You have completed a great and perilous adventure which has tested
your wit and courage. You have mastered the first part of the ZORK trilogy.
Prepare yourself for an even greater test!\"|
|
The ZORK trilogy continues with \"ZORK II: The Wizard of Frobozz\" and
\"ZORK III: The Dungeon Master.\"")
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (ACTION INSIDE-THE-BARROW-F)>

<ROUTINE INSIDE-THE-BARROW-F (RARG) 
	 <COND (<EQUAL? .RARG ,M-END>
		<FINISH>)>>

<ROOM NORTH-OF-HOUSE
      (IN ROOMS)
      (LDESC
"You are facing the north side of a white house. There is no door here, and
all the windows are boarded up. A narrow path winds north through the trees.")
      (DESC "North of House")
      (SW TO WEST-OF-HOUSE)
      (SE TO BEHIND-HOUSE)
      (WEST TO WEST-OF-HOUSE)
      (EAST TO BEHIND-HOUSE)
      (NORTH TO FOREST-PATH)
      (SOUTH "The windows are all boarded.")
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (GLOBAL BOARDED-WINDOW BOARD WHITE-HOUSE FOREST)>

<ROOM SOUTH-OF-HOUSE
      (IN ROOMS)
      (LDESC
"You are facing the south side of a white house. There is no door here,
and all the windows are boarded.")
      (DESC "South of House")
      (WEST TO WEST-OF-HOUSE)
      (EAST TO BEHIND-HOUSE)
      (NE TO BEHIND-HOUSE)
      (NW TO WEST-OF-HOUSE)
      (NORTH "The windows are all boarded.")
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (GLOBAL BOARDED-WINDOW BOARD WHITE-HOUSE FOREST)>

<ROOM BEHIND-HOUSE
      (IN ROOMS)
      (DESC "Behind House")
      (NORTH TO NORTH-OF-HOUSE)
      (SOUTH TO SOUTH-OF-HOUSE)
      (SW TO SOUTH-OF-HOUSE)
      (NW TO NORTH-OF-HOUSE)
      (NE TO FOREST-NORTH)
      (EAST TO FOREST-SOUTH)
      (WEST TO KITCHEN IF KITCHEN-WINDOW IS OPEN)
      (IN TO KITCHEN IF KITCHEN-WINDOW IS OPEN)
      (ACTION BEHIND-HOUSE-F)
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (GLOBAL WHITE-HOUSE KITCHEN-WINDOW FOREST)>

<ROUTINE BEHIND-HOUSE-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"You are behind the white house. Paths lead into the forest to the east and
northeast. In one corner of the house">
		<DESCRIBE-WINDOW>)>>

<ROUTINE DESCRIBE-WINDOW ()
	 <TELL " is a small window which is ">
	 <COND (<FSET? ,KITCHEN-WINDOW ,OPENBIT>
		<TELL "open.">)
	       (T
		<TELL "slightly ajar.">)>>

<OBJECT WHITE-HOUSE	
	(IN LOCAL-GLOBALS)
	(SYNONYM HOUSE)
	(ADJECTIVE WHITE BEAUTI)
	(DESC "white house")
	(FLAGS NDESCBIT)
	(ACTION WHITE-HOUSE-F)>

<ROUTINE WHITE-HOUSE-F ()
	 <COND (<AND <EQUAL? ,HERE ,KITCHEN ,LIVING-ROOM ,ATTIC>
		     <VERB? FIND THROUGH>>
		<TELL ,LOOK-AROUND>)
	       (<VERB? EXAMINE>
		<TELL
"The house is a beautiful white colonial. The owners must have been
extremely wealthy." CR>)
	       (<VERB? THROUGH OPEN>
		<DO-WALK ,P?IN>)
	       (<VERB? BURN>
		<TELL "You must be joking." CR>)>>

<OBJECT BOARD
	(IN LOCAL-GLOBALS)
	(DESC "board")
	(SYNONYM BOARDS BOARD)
	(FLAGS NDESCBIT)
	(ACTION BOARD-F)>

<ROUTINE BOARD-F ()
	 <COND (<VERB? TAKE EXAMINE>
		<FASTENED ,BOARD "house">)>>

<OBJECT BOARDED-WINDOW
	(IN LOCAL-GLOBALS)
	(DESC "boarded window")
        (SYNONYM WINDOW)
	(ADJECTIVE BOARDED)
	(FLAGS NDESCBIT)
	(ACTION BOARDED-WINDOW-F)>

<ROUTINE BOARDED-WINDOW-F ()
	 <COND (<VERB? OPEN MUNG>
		<TELL "The windows are boarded!" CR>)>>

<ROUTINE NAILS-PSEUDO ()
	 <COND (<VERB? TAKE>
		<TELL "The nails are too deeply imbedded." CR>)>>

<OBJECT FOREST
	(IN LOCAL-GLOBALS)
	(DESC "forest")
	(SYNONYM FOREST TREES)
	(FLAGS NDESCBIT)
	(ACTION FOREST-F)>

<ROUTINE FOREST-F ()
	 <COND (<VERB? EXIT>
		<V-WALK-AROUND>)
	       (<VERB? FIND>
		<TELL ,LOOK-AROUND>)>>

<OBJECT TREE
	(IN LOCAL-GLOBALS)
	(DESC "tree")
	(SYNONYM TREE BRANCH)
	(ADJECTIVE LARGE)
	(FLAGS NDESCBIT CLIMBBIT)>

<ROOM FOREST-NORTH
      (IN ROOMS)
      (DESC "Forest")
      (LDESC "This is a dimly lit forest, with large trees all around.")
      (UP "There is no tree here suitable for climbing.")
      (WEST TO FOREST-PATH)
      (SW TO BEHIND-HOUSE)
      (SE TO FOREST-EDGE)
      (SOUTH TO FOREST-SOUTH)
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (GLOBAL TREE FOREST)>

<ROOM FOREST-SOUTH
      (IN ROOMS)
      (DESC "Forest")
      (LDESC "This is a dimly lit forest, with large trees all around.")
      (UP "There is no tree here suitable for climbing.")
      (EAST TO FOREST-EDGE)
      (WEST TO BEHIND-HOUSE)
      (NORTH TO FOREST-NORTH)
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (GLOBAL TREE FOREST)>

<ROOM FOREST-PATH
      (IN ROOMS)
      (DESC "Forest Path")
      (UP TO UP-A-TREE)
      (EAST TO FOREST-NORTH)
      (SOUTH TO NORTH-OF-HOUSE)
      (DOWN PER GRATING-EXIT)
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (GLOBAL GRATE TREE FOREST)
      (ACTION FOREST-PATH-F)>

<ROUTINE FOREST-PATH-F (RARG)
	 <COND (<AND <EQUAL? .RARG ,M-ENTER>
		     <NOT ,GRATE-REVEALED>>
		<FSET ,GRATE ,INVISIBLE>)
	       (<EQUAL? .RARG ,M-LOOK>
		<TELL
"This is a path through a dimly lit forest, curving from south to east.
A large tree with low branches stands by the edge of the path.">
		<COND (<FSET? ,GRATE ,OPENBIT>
		       <TELL
" There is an open grating, descending into darkness.">)
		      (,GRATE-REVEALED
		       <TELL
" There is a grating securely fastened into the ground.">)>)>>

<ROUTINE GRATING-EXIT ()
	 <COND (,GRATE-REVEALED
		<COND (<FSET? ,GRATE ,OPENBIT>
		       ,GRATING-ROOM)
		      (T
		       <TELL "The grating is closed!" CR>
		       <SETG P-IT-OBJECT ,GRATE>
		       <RFALSE>)>)
	       (T
		<TELL ,CANT-GO>
		<RFALSE>)>>

<ROOM UP-A-TREE
      (IN ROOMS)
      (DESC "Up a Tree")
      (DOWN TO FOREST-PATH)
      (UP "You cannot climb any higher.")
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (GLOBAL TREE FOREST)
      (ACTION UP-A-TREE-F)>

<ROUTINE UP-A-TREE-F (RARG "AUX" F)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"You are ten feet above the ground, nestled among large branches.">)
	       (<EQUAL? .RARG ,M-BEG>
		<COND (<AND <VERB? CLIMB-DOWN>
			    <PRSO? ,TREE ,ROOMS>>
		       <DO-WALK ,P?DOWN>)
		      (<VERB? DROP>
		       <COND (<NOT <IDROP>>
			      <RTRUE>)
			     (<NOT <PRSO? ,WINNER ,TREE>>
			      <MOVE ,PRSO ,FOREST-PATH>
			      <TELL "The " D ,PRSO " falls to the ground." CR>)
			     (<VERB? LEAP>
			      <JIGS-UP
"You should have looked before you leaped.">)>)>)>> 

<OBJECT NEST
	(IN UP-A-TREE)
	(DESC "bird's nest")
	(FDESC "Beside you on the branch is a small bird's nest.")
	(SYNONYM NEST)
	(ADJECTIVE BIRDS)
	(FLAGS TAKEBIT BURNBIT CONTBIT OPENBIT SEARCHBIT)
	(CAPACITY 20)
	(ACTION NEST-F)>

<ROUTINE NEST-F ()
	 <COND (<VERB? TAKE>
		<SCORE-OBJ ,EGG>
		<RFALSE>)>>

<OBJECT EGG
	(IN NEST)
	(DESC "jeweled egg")
	(FDESC
"In the bird's nest is a large egg encrusted with precious jewels, apparently
scavenged by a childless songbird.")
	(SYNONYM EGG TREASURE)
	(ADJECTIVE JEWELED)
	(FLAGS TREASUREBIT TAKEBIT)
	(VALUE 6)
	(ACTION EGG-F)>

<ROUTINE EGG-F ()
	 <COND (<AND <VERB? OPEN HATCH>
		     <PRSO? ,EGG>>
		<TELL "This egg only opens" ,DISK-BASED>)>>

<OBJECT LEAVES
	(IN FOREST-PATH)
	(DESC "pile of leaves")
	(LDESC "On the ground is a pile of leaves.")
	(SYNONYM LEAVES LEAF PILE)
	(FLAGS TAKEBIT BURNBIT TRYTAKEBIT)
	(SIZE 25)
	(ACTION LEAVES-F)>

<ROUTINE LEAVES-F ()
	<COND (<VERB? COUNT>
	       <TELL "69,105." CR>)
	      (<VERB? BURN>
	       <GRATING-APPEARS>
	       <TELL "The leaves burn">
	       <COND (<HELD? ,LEAVES>
		      <JIGS-UP ", and so do you.">)
		     (T
		      <TELL ,PERIOD-CR>)>
	       <REMOVE-CAREFULLY ,PRSO>)
	      (<VERB? CUT>
	       <GRATING-APPEARS>
	       <TELL "The leaves seem to be too soggy to cut." CR>)
	      (<AND <VERB? MOVE>
	       	    <GRATING-APPEARS>>
	       <CRLF>)
	      (<VERB? TAKE>
	       <GRATING-APPEARS>
	       <RFALSE>)
	      (<AND <VERB? LOOK-UNDER>
		    <NOT ,GRATE-REVEALED>>
	       <PEEK-UNDER ,LEAVES ,GRATE>)>>

<ROUTINE GRATING-APPEARS () 
	<COND (<AND <NOT <FSET? ,GRATE ,OPENBIT>>
	            <NOT ,GRATE-REVEALED>>
	       <FCLEAR ,GRATE ,INVISIBLE>
	       <SETG GRATE-REVEALED T>
	       <TELL "In disturbing the leaves, a grating is revealed. ">
	       <RTRUE>)
	      (T
	       <RFALSE>)>>

<ROOM FOREST-EDGE
      (IN ROOMS)
      (DESC "Forest Edge")
      (LDESC
"Paths lead into the forest to the west and northwest. Also, a well-marked
path extends east.")
      (UP "There is no tree here suitable for climbing.")
      (EAST TO CANYON-VIEW)
      (NW TO FOREST-NORTH)
      (WEST TO FOREST-SOUTH)
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (GLOBAL TREE FOREST)>

<ROOM CANYON-VIEW
      (IN ROOMS)
      (DESC "Canyon View")
      (LDESC
"You are atop the west wall of a great canyon, offering a marvelous view of the
mighty Frigid River below. Across the canyon, the walls of the White Cliffs
join the mighty ramparts of the Flathead Mountains. To the north, Aragain
Falls may be seen, complete with rainbow. Even further upstream, the river
flows out of a great dark cavern. To the west is an immense forest, stretching
for miles. It seems possible to climb down into the canyon from here.")
      (EAST TO CANYON-BOTTOM)
      (DOWN TO CANYON-BOTTOM)
      (WEST TO FOREST-EDGE)
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (GLOBAL CLIMBABLE-CLIFF RIVER RAINBOW)
      (ACTION CANYON-VIEW-F)>

<ROUTINE CANYON-VIEW-F (RARG)
	 <COND (<AND <EQUAL? .RARG ,M-BEG>
		     <VERB? LEAP>
		     <NOT ,PRSO>>
		<JIGS-UP "You should have looked before you leaped.">)>>

<OBJECT CLIMBABLE-CLIFF
	(IN LOCAL-GLOBALS)
	(DESC "cliff")
	(SYNONYM CLIFF)
	(FLAGS NDESCBIT CLIMBBIT)
	(ACTION CLIFF-F)>

<ROUTINE CLIFF-F ()
	 <COND (<OR <VERB? LEAP>
		    <AND <VERB? PUT>
			 <PRSO? ,ME>>>
		<JIGS-UP "You should have looked before you leaped.">)
	       (<AND <VERB? PUT THROW-OFF>
		     <PRSI? ,CLIMBABLE-CLIFF>>
	        <TELL "The " D ,PRSO " is now lost in the river." CR>
		<REMOVE-CAREFULLY ,PRSO>)>>

<ROOM CANYON-BOTTOM
      (IN ROOMS)
      (DESC "Canyon Bottom")
      (LDESC
"The walls of the river canyon may be climbable here. To the northeast is a
narrow path.")
      (UP TO CANYON-VIEW)
      (WEST TO CANYON-VIEW)
      (NE TO END-OF-RAINBOW)
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (GLOBAL GLOBAL-WATER CLIMBABLE-CLIFF RIVER)>

<ROOM END-OF-RAINBOW
      (IN ROOMS)
      (DESC "End of Rainbow")
      (LDESC
"You are on a small, rocky beach by the Frigid River, below the falls. A
rainbow crosses over the falls to the east and a narrow path continues to
the southwest.")
      (UP TO ARAGAIN-FALLS IF RAINBOW-FLAG ELSE
       "Can you walk on water vapor?")
      (EAST TO ARAGAIN-FALLS IF RAINBOW-FLAG ELSE
       "Can you walk on water vapor?")
      (SW TO CANYON-BOTTOM)
      (FLAGS RLANDBIT ONBIT)
      (GLOBAL STAIRS GLOBAL-WATER RAINBOW RIVER)>

<GLOBAL RAINBOW-FLAG <>>

<OBJECT RAINBOW
	(IN LOCAL-GLOBALS)
	(DESC "rainbow")
	(SYNONYM RAINBOW)
	(FLAGS NDESCBIT CLIMBBIT)
	(ACTION RAINBOW-F)>

<ROUTINE RAINBOW-F ()
	 <COND (<VERB? CROSS THROUGH>
		<COND (<EQUAL? ,HERE ,CANYON-VIEW>
		       <V-WALK-AROUND>)
		      (T
		       <DO-WALK ,P?UP>)>)
	       (<VERB? LOOK-UNDER>
		<TELL "The Frigid River flows under the rainbow." CR>)>>

<OBJECT POT-OF-GOLD
	(IN END-OF-RAINBOW)
	(DESC "pot of gold")
	(FDESC "At the end of the rainbow is a pot of gold.")
	(SYNONYM POT GOLD TREASURE)
	(ADJECTIVE GOLD)
	(FLAGS TREASUREBIT TAKEBIT INVISIBLE)
	(SIZE 15)
	(VALUE 19)>
\
;"inside the house"

<OBJECT	KITCHEN-WINDOW
	(IN LOCAL-GLOBALS)
	(DESC "window")
	(SYNONYM WINDOW)
	(ADJECTIVE SMALL)
	(FLAGS DOORBIT NDESCBIT)
	(ACTION KITCHEN-WINDOW-F)>

<ROUTINE KITCHEN-WINDOW-F ()
	 <COND (<VERB? OPEN CLOSE>
		<OPEN-CLOSE ,KITCHEN-WINDOW
"With great effort, you open the window enough to allow entry."
"The window closes (more easily than it opened).">)
	       (<AND <VERB? EXAMINE>
		     <NOT <FSET? ,KITCHEN ,OPENBIT>>>
		<TELL
"The window is slightly ajar, but not enough to allow entry." CR>)
	       (<VERB? WALK BOARD THROUGH>
		<DO-WALK <COND (<EQUAL? ,HERE ,KITCHEN> ,P?EAST)
			       (T ,P?WEST)>>)
	       (<VERB? LOOK-INSIDE>
		<TELL "You can see a ">
		<COND (<EQUAL? ,HERE ,KITCHEN>
		       <TELL "forest clearing." CR>)
		      (T
		       <TELL "kitchen." CR>)>)>>

<ROOM KITCHEN
      (IN ROOMS)
      (DESC "Kitchen")
      (EAST TO BEHIND-HOUSE IF KITCHEN-WINDOW IS OPEN)
      (WEST TO LIVING-ROOM)
      (OUT TO BEHIND-HOUSE IF KITCHEN-WINDOW IS OPEN)
      (UP TO ATTIC)
      (DOWN "Only Santa Claus climbs down chimneys.")
      (VALUE 10)
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (GLOBAL KITCHEN-WINDOW CHIMNEY STAIRS)
      (ACTION KITCHEN-F)>

<ROUTINE KITCHEN-F (RARG)
	<COND (<EQUAL? .RARG ,M-LOOK>
	       <TELL
"You are in the kitchen of the white house. A table has been used recently
for the preparation of food. A passage leads west and a dark staircase leads
upward. A chimney leads down and to the east">
	       <DESCRIBE-WINDOW>)>>

<OBJECT KITCHEN-TABLE
	(IN KITCHEN)
	(DESC "table")
	(SYNONYM TABLE)
	(FLAGS NDESCBIT CONTBIT SEARCHBIT OPENBIT SURFACEBIT)
	(CAPACITY 50)>

<OBJECT SANDWICH-BAG
	(IN KITCHEN-TABLE)
	(DESC "brown sack")
	(SYNONYM BAG SACK)
	(ADJECTIVE BROWN)
	(FLAGS TAKEBIT CONTBIT BURNBIT SEARCHBIT)
	(FDESC
"On the table is an elongated brown sack, smelling of hot peppers.")
	(CAPACITY 9)
	(SIZE 9)
	(ACTION SANDWICH-BAG-F)>

<ROUTINE SANDWICH-BAG-F ()
	 <COND (<AND <VERB? SMELL>
		     <IN? ,LUNCH ,PRSO>>
		<TELL "Hot peppers!" CR>)>>

<OBJECT LUNCH
	(IN SANDWICH-BAG)
	(DESC "lunch")
	(LDESC "A hot pepper sandwich is here.")
	(SYNONYM FOOD SANDWICH LUNCH)
	(ADJECTIVE HOT PEPPER)
	(FLAGS TAKEBIT FOODBIT)>

<OBJECT GARLIC
	(IN SANDWICH-BAG)
	(DESC "clove of garlic")
	(SYNONYM GARLIC CLOVE)
	(FLAGS TAKEBIT FOODBIT)
	(SIZE 4)
	(ACTION GARLIC-F)>

<ROUTINE GARLIC-F ()
	 <COND (<VERB? EAT>
		<REMOVE ,PRSO>
		<TELL
"You won't make friends this way, but nobody around here is too friendly
anyhow. Gulp!" CR>)>>

<OBJECT BOTTLE
	(IN KITCHEN-TABLE)
	(DESC "glass bottle")
	(FDESC "A bottle is sitting on the table.")
	(SYNONYM BOTTLE)
	(ADJECTIVE GLASS)
	(CAPACITY 4)
	(FLAGS TAKEBIT TRANSBIT CONTBIT)
	(ACTION BOTTLE-F)>

<ROUTINE BOTTLE-F ()
	 <COND (<AND <VERB? THROW MUNG>
		     <PRSO? ,BOTTLE>>
		<TELL "The bottle shatters.">
		<COND (<IN? ,WATER ,PRSO>
		       <REMOVE-CAREFULLY ,WATER>
		       <TELL " " ,WATER-EVAPORATES>)
		      (T
		       <CRLF>)>
		<REMOVE-CAREFULLY ,PRSO>)
	       (<AND <VERB? SHAKE>
		     <FSET? ,PRSO ,OPENBIT>
		     <IN? ,WATER ,PRSO>>
		<REMOVE-CAREFULLY ,WATER>
		<TELL ,WATER-EVAPORATES>)>>

<OBJECT WATER
	(IN BOTTLE)
	(DESC "quantity of water")
	(SYNONYM WATER QUANTITY)
	(FLAGS TRYTAKEBIT TAKEBIT DRINKBIT)
	(SIZE 4)
	(ACTION WATER-F)>

<ROUTINE WATER-F ()
	 <COND (<VERB? THROUGH BOARD>
		<TELL ,YOU-CANT "swim in the dungeon." CR>
		<RTRUE>)
	       (<VERB? FILL>
		<PERFORM ,V?PUT ,PRSI ,PRSO>
		<RTRUE>)
	       (<AND <VERB? TAKE>
		     <IN? ,PRSO ,BOTTLE>
		     <NOT ,PRSI>>
		<PERFORM ,V?TAKE ,BOTTLE>
		<RTRUE>)
	       (<AND <VERB? TAKE PUT>
		     <PRSO? ,WATER ,GLOBAL-WATER>>
		<COND (<NOT ,PRSI>
		       <COND (<HELD? ,BOTTLE>
			      <SETG PRSI ,BOTTLE>)
			     (T
			      <SETG PRSI ,HANDS>)>)>
		<COND (<PRSI? ,HANDS>
		       <TELL "The water slips through your fingers." CR>)
		      (<NOT <HELD? ,PRSI>>
		       <TELL ,YNH "the " D ,PRSI ,PERIOD-CR>)
		      (<NOT <PRSI? ,BOTTLE>>
		       <COND (<PRSO? ,WATER> ;"might be GLOBAL-WATER"
		       	      <REMOVE-CAREFULLY ,WATER>)>
		       <TELL
"The water leaks out of the " D ,PRSI " and evaporates immediately." CR>)
		      (<NOT <FSET? ,BOTTLE ,OPENBIT>>
		       <SETG P-IT-OBJECT ,BOTTLE>
		       <TELL "The bottle is closed." CR>)
		      (<NOT <FIRST? ,BOTTLE>>
		       <MOVE ,WATER ,BOTTLE>
		       <TELL "The bottle is now full of water." CR>)>)
	       (<AND <VERB? PUT>
		     <PRSI? ,WATER ,GLOBAL-WATER>
		     <GLOBAL-IN? ,RIVER>>
		<PERFORM ,V?PUT ,PRSO ,RIVER>
		<RTRUE>)
	       (<AND <VERB? DROP GIVE THROW>
		     <IN? ,WATER ,BOTTLE>>
		<COND (<NOT <FSET? ,BOTTLE ,OPENBIT>>
		       <TELL "The bottle is closed." CR>)
		      (T
		       <REMOVE-CAREFULLY ,WATER>
		       <TELL ,WATER-EVAPORATES>)>)>>

<ROOM ATTIC
      (IN ROOMS)
      (DESC "Attic")
      (LDESC "This is the attic. The only exit is the stairway down.")
      (DOWN TO KITCHEN)
      (FLAGS RLANDBIT SACREDBIT)
      (GLOBAL STAIRS)>

<OBJECT KNIFE
	(IN ATTIC)
	(DESC "nasty knife")
	(SYNONYM KNIVES KNIFE BLADE)
	(ADJECTIVE NASTY UNRUSTY)
	(FLAGS TAKEBIT WEAPONBIT TRYTAKEBIT)>

<OBJECT ROPE
	(IN ATTIC)
	(DESC "rope")
	(FDESC "A large coil of rope is lying in the corner.")
	(SYNONYM ROPE COIL)
	(ADJECTIVE LARGE)
	(FLAGS TAKEBIT SACREDBIT)
	(SIZE 10)
	(ACTION ROPE-F)>

<ROUTINE ROPE-F ()
	 <COND (<VERB? TIE>
		<COND (<PRSI? ,RAILING>
		       <COND (,DOME-FLAG
			      <TELL ,ALREADY>)
			     (T
			      <SETG DOME-FLAG T>
			      <FSET ,ROPE ,NDESCBIT>
			      <FSET ,ROPE ,TRYTAKEBIT>
			      <FSET ,ROPE ,CLIMBBIT>
			      <MOVE ,ROPE ,HERE>
			      <TELL
"The rope drops over the side and comes within ten feet of the floor." CR>)>)
		      (T
		       <TELL ,YOU-CANT "tie the rope to that." CR>)>)
	       (<AND <VERB? TIE-UP>
		     <PRSI? ,ROPE>>
		<TELL
"The " D ,PRSO " struggles and you cannot tie him up." CR>)
	       (<VERB? UNTIE>
		<COND (,DOME-FLAG
		       <SETG DOME-FLAG <>>
		       <FCLEAR ,ROPE ,NDESCBIT>
		       <FCLEAR ,ROPE ,TRYTAKEBIT>
		       <FCLEAR ,ROPE ,CLIMBBIT>
		       <TELL "The rope is now untied." CR>)
		      (T
		       <TELL "It is not tied to anything." CR>)>)
	       (<AND <VERB? TAKE>
		     ,DOME-FLAG>
		<TELL "The rope is tied to the railing." CR>)>>

<ROOM LIVING-ROOM
      (IN ROOMS)
      (DESC "Living Room")
      (EAST TO KITCHEN)
      (WEST TO CYCLOPS-ROOM IF MAGIC-FLAG ELSE "The door is nailed shut.")
      (DOWN PER TRAP-DOOR-EXIT)
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (GLOBAL STAIRS)
      (PSEUDO "NAILS" NAILS-PSEUDO "NAIL" NAILS-PSEUDO)
      (ACTION LIVING-ROOM-F)>

<ROUTINE TRAP-DOOR-EXIT ()
	 <COND (,RUG-MOVED
		<COND (<FSET? ,TRAP-DOOR ,OPENBIT>
		       <RETURN ,CELLAR>)
		      (T
		       <SETG P-IT-OBJECT ,TRAP-DOOR>
		       <TELL "The trap door is closed." CR>
		       <RFALSE>)>)
	       (T
		<TELL ,CANT-GO>
		<RFALSE>)>>

<ROUTINE LIVING-ROOM-F (RARG)
	<COND (<EQUAL? .RARG ,M-LOOK>
	       <TELL "The living room opens to the east. To the west is a">
	       <COND (,MAGIC-FLAG
		      <TELL " cyclops-shaped opening in a">)>
	       <TELL " wooden door, above which is strange gothic lettering. ">
	       <COND (<NOT ,MAGIC-FLAG>
		      <TELL "The door is nailed shut. ">)>
	       <TELL "There is a trophy case here, and a">
	       <COND (,RUG-MOVED
		      <TELL " rug lying beside a">
		      <COND (<FSET? ,TRAP-DOOR ,OPENBIT>
			     <TELL "n open">)
			    (T
			     <TELL " closed">)>
		      <TELL " trap door">)
		     (T
		      <TELL " large oriental rug in the center of the room">)>
	       <TELL ".">)
	      (<AND <EQUAL? .RARG ,M-END>
		    <VERB? PUT>
		    <PRSI? ,TROPHY-CASE>
		    <EQUAL? <COUNT-TREASURES ,TROPHY-CASE> 15>
		    <EQUAL? ,SCORE 325>
		    <NOT ,WON-FLAG>>
		<SETG WON-FLAG T>
		<SETG SCORE 350>
		<FCLEAR ,MAP ,INVISIBLE>
		<FCLEAR ,WEST-OF-HOUSE ,TOUCHBIT>
		<TELL
"A voice whispers, \"Look to your treasures for the final secret.\"" CR>)>>

<ROUTINE COUNT-TREASURES (OBJ "AUX" (X <FIRST? .OBJ>) (CNT 0))
	 <REPEAT ()
		 <COND (<NOT .X>
			<RETURN>)>
		 <COND (<FSET? .X ,TREASUREBIT>
		 	<SET CNT <+ .CNT 1>>)>
		 <SET CNT <+ .CNT <COUNT-TREASURES .X>>>
		 <SET X <NEXT? .X>>>
	 .CNT>

<OBJECT TROPHY-CASE ;"first obj so L.R. desc looks right."
	(IN LIVING-ROOM)
	(DESC "trophy case")
	(SYNONYM CASE)
	(ADJECTIVE TROPHY)
	(FLAGS TRANSBIT CONTBIT NDESCBIT TRYTAKEBIT SEARCHBIT)
	(CAPACITY 10000)
	(ACTION TROPHY-CASE-F)>

<ROUTINE TROPHY-CASE-F ()
	 <COND (<AND <VERB? TAKE>
		     <PRSO? ,TROPHY-CASE>>
		<FASTENED ,TROPHY-CASE "wall">)>>

<OBJECT MAP
	(IN TROPHY-CASE)
	(DESC "parchment map")
	(FDESC "In the trophy case is an ancient parchment map.")
	(SYNONYM MAP)
	(ADJECTIVE OLD PARCHMENT ANCIENT)
	(FLAGS INVISIBLE READBIT TAKEBIT)
	(SIZE 2)
	(TEXT
"The map shows a house in a forest clearing. Several paths leave the
clearing; one, leading southwest, is marked \"To Stone Barrow\".")>

<OBJECT SWORD
	(IN LIVING-ROOM)
	(DESC "sword")
	(FDESC
"Above the trophy case hangs an elvish sword of great antiquity.")
	(SYNONYM SWORD BLADE)
	(ADJECTIVE ELVISH OLD)
	(FLAGS TAKEBIT WEAPONBIT)
	(SIZE 30)>

<OBJECT LAMP
	(IN LIVING-ROOM)
	(DESC "brass lantern")
	(FDESC "A battery-powered brass lantern is on the trophy case.")
	(LDESC "There is a brass lantern (battery-powered) here.")
	(SYNONYM LAMP LANTERN LIGHT)
	(ADJECTIVE BRASS)
	(FLAGS TAKEBIT LIGHTBIT)
	(SIZE 15)
	(ACTION LAMP-F)>

<ROUTINE LAMP-F ()
	 <COND (<VERB? THROW>
		<TELL "You might break it!" CR>)
	       (<AND <VERB? LAMP-ON LAMP-OFF EXAMINE>
		     <FSET? ,LAMP ,RMUNGBIT>>
		<TELL "The lamp has burned out." CR>)
	       (<VERB? LAMP-ON>
		<ENABLE <INT I-LANTERN>>
		<RFALSE>)
	       (<VERB? LAMP-OFF>
		<DISABLE <INT I-LANTERN>>
		<RFALSE>)
	       (<VERB? EXAMINE>
		<TELL "The lamp is o">
		<COND (<FSET? ,LAMP ,ONBIT>
		       <TELL "n">)
		      (T
		       <TELL "ff">)>
		<TELL ,PERIOD-CR>)>>

<ROUTINE I-LANTERN ("AUX" TICK (TBL <VALUE LAMP-TABLE>))
	 <ENABLE <QUEUE I-LANTERN <SET TICK <GET .TBL 0>>>>
	 <LIGHT-INT ,LAMP .TBL .TICK>
	 <COND (<NOT <0? .TICK>>
		<SETG LAMP-TABLE <REST .TBL 4>>)>>

<GLOBAL LAMP-TABLE
	<TABLE (PURE)
	        75 "The lamp appears dimmer."
	        50 "The lamp is definitely dimmer now."
	        15 "The lamp is nearly out." 0>>

<OBJECT WOODEN-DOOR
	(IN LIVING-ROOM)
	(DESC "wooden door")
	(SYNONYM DOOR LETTERING WRITING)
	(ADJECTIVE WOODEN GOTHIC STRANGE WEST)
	(FLAGS READBIT DOORBIT NDESCBIT TRANSBIT)
	(TEXT
"The engravings translate to \"This space intentionally left blank.\"")
	(ACTION WOODEN-DOOR-F)>

<ROUTINE WOODEN-DOOR-F ()
	 <COND (<VERB? OPEN LOOK-BEHIND>
		<TELL "It won't open." CR>)
	       (<VERB? BURN MUNG>
		<TELL "Nice try." CR>)>>

<GLOBAL RUG-MOVED <>>

<OBJECT RUG
	(IN LIVING-ROOM)
	(DESC "carpet")
	(SYNONYM RUG CARPET)
	(ADJECTIVE LARGE ORIENTAL)
	(FLAGS NDESCBIT TRYTAKEBIT)
	(ACTION RUG-F)>

<ROUTINE RUG-F ()
	 <COND (<VERB? RAISE TAKE>
		<TELL "The rug is too heavy to lift">
		<COND (<NOT ,RUG-MOVED>
		       <TELL ", but you noticed an irregularity beneath it">)>
		<TELL ,PERIOD-CR>)
	       (<VERB? MOVE PUSH>
		<COND (,RUG-MOVED
		       <TELL ,ALREADY>)
		      (T
		       <FCLEAR ,TRAP-DOOR ,INVISIBLE>
		       <SETG P-IT-OBJECT ,TRAP-DOOR>
		       <SETG RUG-MOVED T>
		       <TELL
"You drag the rug to one side of the room, revealing a
closed trap door." CR>)>)
	       (<AND <VERB? LOOK-UNDER>
		     <NOT ,RUG-MOVED>>
		<PEEK-UNDER ,RUG ,TRAP-DOOR>)
	       (<VERB? CLIMB-ON>
		<COND (<NOT ,RUG-MOVED>
		       <TELL
"As you try to sit, you notice an irregularity beneath the rug." CR>)
		      (T
		       <TELL "It's not a magic carpet." CR>)>)>>

<OBJECT TRAP-DOOR
	(IN LIVING-ROOM)
	(DESC "trap door")
	(SYNONYM DOOR TRAPDOOR TRAP-DOOR)
	(ADJECTIVE TRAP DUSTY)
	(FLAGS DOORBIT NDESCBIT INVISIBLE)
	(ACTION TRAP-DOOR-F)>

<ROUTINE TRAP-DOOR-F ()
	 <COND (<OR <VERB? RAISE>
		    <AND <VERB? LOOK-UNDER>
			 <EQUAL? ,HERE ,LIVING-ROOM>>>
		<PERFORM ,V?OPEN ,TRAP-DOOR>
		<RTRUE>)
	       (<AND <VERB? OPEN CLOSE>
		     <EQUAL? ,HERE ,LIVING-ROOM>>
		<OPEN-CLOSE ,PRSO
"The door reluctantly opens to reveal a rickety staircase descending into
darkness."
"The door swings shut.">)
	       (<EQUAL? ,HERE ,CELLAR>
		<COND (<AND <VERB? OPEN UNLOCK>
			    <NOT <FSET? ,TRAP-DOOR ,OPENBIT>>>
		       <TELL "It's latched from above." CR>)
		      (<AND <VERB? CLOSE>
			    <FSET? ,TRAP-DOOR ,OPENBIT>>
		       <FCLEAR ,TRAP-DOOR ,OPENBIT>
		       <TELL "The door latches shut." CR>)>)>>