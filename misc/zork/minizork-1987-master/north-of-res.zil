"NORTH-OF-RESERVOIR for
			     Mini-Zork '87
	  (c) Copyright 1987 Infocom, Inc. All Rights Reserved"

<ROOM RESERVOIR
      (IN ROOMS)
      (DESC "Reservoir")
      (NORTH TO RESERVOIR-NORTH)
      (SOUTH TO RESERVOIR-SOUTH)
      (DOWN "The dam blocks your way.")
      (EAST "The dam blocks your way.")
      (FLAGS NONLANDBIT)
      (PSEUDO "STREAM" STREAM-PSEUDO)
      (GLOBAL GLOBAL-WATER DAM-OBJECT)
      (ACTION RESERVOIR-F)>

<ROUTINE RESERVOIR-F (RARG)
   	<COND (<EQUAL? .RARG ,M-LOOK>
	       <COND (,LOW-TIDE
		      <TELL
"You are on what used to be a large lake, but which is now a large
mud pile. There are \"shores\" to the north and south.">)
		     (T
		      <TELL
"You are on the lake with beaches to the north and south and
a dam to the east.">)>)>>

<ROUTINE STREAM-PSEUDO ()
	 <COND (<VERB? SWIM THROUGH>
		<PERFORM ,V?BOARD ,WATER>
		<RTRUE>)
	       (<VERB? CROSS>
      		<V-WALK-AROUND>)>>

<ROUTINE LAKE-PSEUDO ()
	 <COND (,LOW-TIDE
		<TELL "The lake's gone..." CR>)
	       (<VERB? CROSS THROUGH>
		<PERFORM ,V?BOARD ,WATER>
		<RTRUE>)>>

<OBJECT TRUNK
	(IN RESERVOIR)
	(DESC "trunk of jewels")
	(FDESC "Half-buried in the mud is an old trunk, bulging with jewels.")
	(LDESC "There is an old trunk here, bulging with assorted jewels.")
	(SYNONYM TRUNK CHEST JEWELS TREASURE)
	(ADJECTIVE OLD)
	(FLAGS TREASUREBIT TAKEBIT INVISIBLE)
	(SIZE 35)
	(VALUE 15)
	(ACTION TRUNK-F)>

<ROUTINE TRUNK-F ()
	 <STUPID-CONTAINER ,TRUNK "jewels">>

<ROOM RESERVOIR-NORTH
      (IN ROOMS)
      (DESC "Reservoir North")
      (UP TO DRAFTY-CAVE)
      (NORTH TO DRAFTY-CAVE)
      (SOUTH TO RESERVOIR IF LOW-TIDE ELSE "You would drown.")
      (FLAGS RLANDBIT)
      (GLOBAL GLOBAL-WATER STAIRS)
      (PSEUDO "LAKE" LAKE-PSEUDO)
      (ACTION RESERVOIR-NORTH-F)>

<ROUTINE RESERVOIR-NORTH-F (RARG)
	<COND (<EQUAL? .RARG ,M-LOOK>
	       <TELL "You are in cavern to the north of ">
	       <COND (,LOW-TIDE
		      <TELL ,FORMERLY-A-LAKE>)
		     (T
		      <TELL "a large lake">)>
	       <TELL ". A slimy stairway climbs to the north.">)>>

<OBJECT PUMP
	(IN RESERVOIR-NORTH)
	(SYNONYM PUMP AIR-PUMP)
	(ADJECTIVE HAND-HELD AIR)
	(DESC "hand-held air pump")
	(FLAGS TAKEBIT TOOLBIT)>

<ROOM DRAFTY-CAVE
      (IN ROOMS)
      (DESC "Drafty Cave")
      (LDESC
"This is a tiny cave with entrances west and north, and a dark, forbidding
staircase leading down.")
      (NORTH TO WINDING-PASSAGE)
      (WEST TO MIRROR-ROOM-NORTH)
      (DOWN TO RESERVOIR-NORTH)
      (SOUTH TO RESERVOIR-NORTH)
      (FLAGS RLANDBIT)
      (GLOBAL STAIRS)
      (ACTION WINDY-CAVE-F)>

<ROOM MIRROR-ROOM-NORTH
      (IN ROOMS)
      (DESC "Mirror Room")
      (NE TO WINDING-PASSAGE)
      (EAST TO DRAFTY-CAVE)
      (FLAGS RLANDBIT)
      (GLOBAL MIRROR)
      (ACTION MIRROR-ROOM-F)>

<ROOM WINDING-PASSAGE
      (IN ROOMS)
      (DESC "Winding Passage")
      (LDESC
"This is a crooked corridor from the north, with forks to the southwest
and south.")
      (SOUTH TO DRAFTY-CAVE)
      (SW TO MIRROR-ROOM-NORTH)
      (NORTH TO SLIDE-ROOM)
      (FLAGS RLANDBIT)>

<ROOM SLIDE-ROOM
      (IN ROOMS)
      (DESC "Slide Room")
      (LDESC
"This small chamber appears to have been part of a coal mine. To the west
and south are passages, and a steep metal slide twists downward.")
      (WEST TO MINE-ENTRANCE)
      (DOWN TO CELLAR)
      (SOUTH TO WINDING-PASSAGE)
      (FLAGS RLANDBIT)
      (GLOBAL SLIDE)>

<OBJECT	SLIDE
	(IN LOCAL-GLOBALS)
	(DESC "chute")
	(SYNONYM CHUTE RAMP SLIDE)
	(ADJECTIVE STEEP METAL TWISTING)
	(FLAGS CLIMBBIT)
	(ACTION SLIDE-F)>

<ROUTINE SLIDE-F ()
	 <COND (<OR <VERB? THROUGH CLIMB-DOWN CLIMB>
		    <AND <VERB? PUT>
			 <EQUAL? ,PRSO ,ME>>>
		<DO-WALK <COND (<EQUAL? ,HERE ,CELLAR> ,P?WEST)
			       (T ,P?DOWN)>>)
	       (<AND <VERB? PUT>
		     <PRSI? ,SLIDE>
		     <FSET? ,PRSO ,TAKEBIT>>
		<TELL "The " D ,PRSO " disappears into the slide." CR>
		<COND (<EQUAL? ,PRSO ,WATER>
		       <REMOVE-CAREFULLY ,WATER>)
		      (T
		       <MOVE ,PRSO ,CELLAR>)>)>>

<ROOM MINE-ENTRANCE
      (IN ROOMS)
      (DESC "Mine Entrance")
      (LDESC
"You are at the entrance of an abandoned coal mine. Strange squeaky sounds
come from the passage at the north end. You may also escape to the east.")
      (NORTH TO BAT-ROOM)
      (IN TO BAT-ROOM)
      (EAST TO SLIDE-ROOM)
      (FLAGS RLANDBIT)>

<ROOM BAT-ROOM
      (IN ROOMS)
      (DESC "Bat Room")
      (SOUTH TO MINE-ENTRANCE)
      (EAST TO SHAFT-ROOM)
      (FLAGS RLANDBIT SACREDBIT)
      (ACTION BAT-ROOM-F)>

<ROUTINE BAT-ROOM-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"You are in a small room with exits to the east and south.">)
	       (<AND <EQUAL? .RARG ,M-END>
		     <NOT ,DEAD>
		     <NOT <EQUAL? <LOC ,GARLIC> ,WINNER ,HERE>>>
		<CRLF>
		<FLY-ME>)>>

<OBJECT BAT
	(IN BAT-ROOM)
	(DESC "bat")
	(SYNONYM BAT)
	(ADJECTIVE VAMPIRE)
	(FLAGS ACTORBIT TRYTAKEBIT)
	(DESCFCN BAT-D)
	(ACTION BAT-F)>

<ROUTINE BAT-D ("OPTIONAL" FOO)
	 <COND (<EQUAL? <LOC ,GARLIC> ,WINNER ,HERE>
		<TELL
"In the corner of the ceiling, a large vampire bat is holding his nose." CR>)
	       (T
		<TELL "A large vampire bat swoops down at you!" CR>)>>

<ROUTINE BAT-F ()
	 <COND (<VERB? TELL>
		<FWEEP 6>
		<SETG P-CONT <>>)
	       (<VERB? TAKE ATTACK MUNG>
		<COND (<EQUAL? <LOC ,GARLIC> ,WINNER ,HERE>
		       <TELL ,YOU-CANT "reach him; he's on the ceiling." CR>)
		      (T
		       <FLY-ME>)>)>>

<ROUTINE FLY-ME ()
	 <FWEEP 4>
	 <TELL "The bat grabs you and lifts you away..." CR CR>
	 <GOTO <PICK-ONE ,BAT-DROPS>>>

<ROUTINE FWEEP (N)
	 <REPEAT ()
		 <COND (<L? <SET N <- .N 1>> 1>
			<RETURN>)
		       (T
			<TELL "    Fweep!" CR>)>>
	 <CRLF>>

<GLOBAL BAT-DROPS
      <LTABLE 0
	      COAL-MINE-1
	      COAL-MINE-2
	      COAL-MINE-3
	      LADDER-ROOM
	      SHAFT-ROOM
	      MINE-ENTRANCE>>

<OBJECT JADE
	(IN BAT-ROOM)
	(DESC "jade figurine")
	(LDESC "There is an exquisite jade figurine here.")
	(SYNONYM FIGURINE TREASURE)
	(ADJECTIVE EXQUISITE JADE)
	(FLAGS TAKEBIT TREASUREBIT)
	(SIZE 10)
	(VALUE 13)>

<ROOM SHAFT-ROOM
      (IN ROOMS)
      (DESC "Shaft Room")
      (LDESC
"In the middle this room a small shaft descends into darkness below. Above the
shaft is a metal framework to which a heavy iron chain is attached. There are
exits to the west and north. A foul odor can be detected from the latter
direction.")
      (DOWN "The shaft is too small for you.")
      (WEST TO BAT-ROOM)
      (NORTH TO GAS-ROOM)
      (FLAGS RLANDBIT)
      (PSEUDO "CHAIN" CHAIN-PSEUDO)>

<OBJECT BASKET
	(IN SHAFT-ROOM)
	(DESC "basket")
	(LDESC "From the chain is suspended a basket.")
	(SYNONYM BASKET)
	(FLAGS TRYTAKEBIT CONTBIT OPENBIT SEARCHBIT)
	(CAPACITY 50)
	(ACTION BASKET-F)>

<GLOBAL BASKET-RAISED T>

<ROUTINE BASKET-F ()
	 <COND (<VERB? MOVE>
		<PERFORM <COND (,BASKET-RAISED ,V?LOWER)
			       (T ,V?RAISE)> ,BASKET>
		<RTRUE>)
	       (<VERB? RAISE>
		<COND (,BASKET-RAISED
		       <TELL ,LOOK-AROUND>)
		      (T
		       <MOVE ,BASKET ,SHAFT-ROOM>
		       <SETG BASKET-RAISED T>
		       <TELL
"The basket is raised to the top of the shaft." CR>
		       <NOW-DARK?>)>)
	       (<VERB? LOWER>
		<COND (<NOT ,BASKET-RAISED>
		       <TELL ,LOOK-AROUND>)
		      (T
		       <MOVE ,BASKET ,DRAFTY-ROOM>
		       <SETG BASKET-RAISED <>>
		       <TELL
"The basket is lowered to the bottom of the shaft." CR>
		       <NOW-DARK?>)>)
	       (<AND <VERB? TAKE>
		     <EQUAL? ,PRSO ,BASKET>>
		<FASTENED ,BASKET "chain">)>>

<ROUTINE CHAIN-PSEUDO ()
	 <COND (<VERB? TAKE>
		<TELL "The chain is secure." CR>)
	       (<VERB? RAISE LOWER MOVE>
		<PERFORM ,PRSA ,BASKET>
		<RTRUE>)
	       (<AND <VERB? EXAMINE>
		     <IN? ,BASKET ,HERE>>
		<TELL <GETP ,BASKET ,P?LDESC> CR>)>>

<ROOM GAS-ROOM
      (IN ROOMS)
      (DESC "Gas Room")
      (LDESC
"This room smells strongly of coal gas. Narrow tunnels lead lead
east and south.")
      (SOUTH TO SHAFT-ROOM)
      (EAST TO COAL-MINE-1)
      (FLAGS RLANDBIT SACREDBIT)
      (PSEUDO "GAS" GAS-PSEUDO "ODOR" GAS-PSEUDO)
      (ACTION GAS-ROOM-F)>

<ROUTINE GAS-ROOM-F (RARG)
         <COND (<EQUAL? .RARG ,M-END>
		<COND (<OR <AND <HELD? ,CANDLES>
				<FSET? ,CANDLES ,ONBIT>>
			   <AND <HELD? ,TORCH>
				<FSET? ,TORCH ,ONBIT>>
			   <AND <HELD? ,MATCH>
				<FSET? ,MATCH ,ONBIT>>>
		       <JIGS-UP
"Oh dear. That smell was coal gas. I would have thought twice about
carrying flaming objects in here.|
|
Booooooom!!!">)>)>>

<ROUTINE GAS-PSEUDO ()
	 <COND (<VERB? BREATHE>	;"REALLY BLOW"
		<TELL "There is too much gas to blow away." CR>)
	       (<VERB? SMELL>
		<TELL "It smells like coal gas in here." CR>)>>

<OBJECT BRACELET
	(IN GAS-ROOM)
	(DESC "sapphire-encrusted bracelet")
	(SYNONYM BRACELET JEWEL SAPPHIRE TREASURE)
	(ADJECTIVE SAPPHIRE)
	(FLAGS TAKEBIT TREASUREBIT)
	(SIZE 10)
	(VALUE 10)>

<ROOM COAL-MINE-1
      (IN ROOMS)
      (DESC "Coal Mine")
      (LDESC "This is a nondescript part of a coal mine.")
      (WEST TO GAS-ROOM)
      (NORTH TO COAL-MINE-2)
      (SOUTH TO COAL-MINE-1)
      (FLAGS RLANDBIT)>

<ROOM COAL-MINE-2
      (IN ROOMS)
      (DESC "Coal Mine")
      (LDESC "This is a nondescript part of a coal mine.")
      (NE TO COAL-MINE-2)
      (NW TO COAL-MINE-1)
      (SOUTH TO COAL-MINE-3)
      (UP TO COAL-MINE-2)
      (FLAGS RLANDBIT)>

<ROOM COAL-MINE-3
      (IN ROOMS)
      (DESC "Coal Mine")
      (LDESC "This is a nondescript part of a coal mine.")
      (EAST TO COAL-MINE-2)
      (WEST TO COAL-MINE-3)
      (DOWN TO LADDER-ROOM)
      (FLAGS RLANDBIT)>

<ROOM LADDER-ROOM
      (IN ROOMS)
      (DESC "Ladder Room")
      (LDESC
"At the east end of this narrow passage, a ladder leads upward. There's a
strong draft from the west, where the passage narrows even further.")
      (UP TO COAL-MINE-3)
      (WEST TO DRAFTY-ROOM IF EMPTY-HANDED ELSE
       "You can't fit through with that load.")
      (FLAGS RLANDBIT SACREDBIT)
      (ACTION NO-OBJECT-ROOM-F)
      (PSEUDO "LADDER" LADDER-PSEUDO)>

<OBJECT COAL
	(IN LADDER-ROOM)
	(DESC "small pile of coal")
	(SYNONYM COAL PILE)
	(ADJECTIVE SMALL)
	(FLAGS TAKEBIT BURNBIT)
	(SIZE 20)>

<ROUTINE LADDER-PSEUDO ()
	 <COND (<VERB? CLIMB>
		<DO-WALK ,P?UP>)>>

<GLOBAL EMPTY-HANDED <>>

<ROUTINE NO-OBJECT-ROOM-F (RARG "AUX" F)
	 <COND (<EQUAL? .RARG ,M-BEG>
		<SET F <FIRST? ,WINNER>>
		<SETG EMPTY-HANDED T>
		<REPEAT ()
			<COND (<NOT .F> <RETURN>)
			      (<G? <WEIGHT .F> 4>
			       <SETG EMPTY-HANDED <>>
			       <RETURN>)>
			<SET F <NEXT? .F>>>
		<COND (<AND <EQUAL? ,HERE ,DRAFTY-ROOM>
			    ,LIT
			    <NOT ,DRAFTY-ROOM-SCORE>>
		       <SETG DRAFTY-ROOM-SCORE T>
		       <SETG SCORE <+ ,SCORE 10>>)>
		<RFALSE>)>>

<GLOBAL DRAFTY-ROOM-SCORE <>>

<ROOM DRAFTY-ROOM
      (IN ROOMS)
      (DESC "Drafty Room")
      (LDESC
"This is a small room at the bottom of a long shaft. A heavy iron chain hangs
down the shaft. To the south is a passageway and to the east a very narrow
passage.")
      (SOUTH TO MACHINE-ROOM)
      (OUT TO LADDER-ROOM IF EMPTY-HANDED ELSE
       "You can't fit through with that load.")
      (EAST TO LADDER-ROOM IF EMPTY-HANDED ELSE
       "You can't fit through with that load.")
      (FLAGS RLANDBIT SACREDBIT)
      (PSEUDO "CHAIN" CHAIN-PSEUDO)
      (ACTION NO-OBJECT-ROOM-F)>

<ROOM MACHINE-ROOM
      (IN ROOMS)
      (DESC "Machine Room")
      (NORTH TO DRAFTY-ROOM)
      (OUT TO DRAFTY-ROOM)
      (FLAGS RLANDBIT)
      (ACTION MACHINE-ROOM-F)>

<ROUTINE MACHINE-ROOM-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"This is a chilly room whose sole exit is to the north. In one corner is a
machine, reminiscent of a clothes dryer, with a switch labelled \"START\".
The switch does not appear to be manipulable by any human hand (unless the
fingers are about 1/16 by 1/4 inch). The machine has a large lid, which is ">
		<COND (<FSET? ,MACHINE ,OPENBIT>
		       <TELL "open.">)
		      (T
		       <TELL "closed.">)>)>>

<OBJECT MACHINE
	(IN MACHINE-ROOM)
	(DESC "machine")
	(SYNONYM MACHINE DRYER LID)
	(FLAGS CONTBIT SEARCHBIT NDESCBIT TRYTAKEBIT)
	(CAPACITY 50)
	(ACTION MACHINE-F)>

<ROUTINE MACHINE-F ()
	 <COND (<VERB? LAMP-ON>
		<COND (<NOT ,PRSI>
		       <TELL ,YOU-CANT "do it with your bare hands." CR>)
		      (T
		       <PERFORM ,V?TURN ,MACHINE-SWITCH ,PRSI>
		       <RTRUE>)>)>>

<OBJECT MACHINE-SWITCH
	(IN MACHINE-ROOM)
	(DESC "switch")
	(SYNONYM SWITCH)
	(FLAGS NDESCBIT TURNBIT)
	(ACTION MACHINE-SWITCH-F)>

<ROUTINE MACHINE-SWITCH-F ("AUX" SLAG?)
	 <COND (<VERB? TURN>
		<COND (<EQUAL? ,PRSI ,SCREWDRIVER>
		       <COND (<FSET? ,MACHINE ,OPENBIT>
			      <TELL ,NOTHING-HAPPENS>)
			     (T
			      <SET SLAG? <FIRST? ,MACHINE>>
			      <ROB ,MACHINE ,MACHINE-SWITCH <>>
			      <COND (<IN? ,COAL ,MACHINE-SWITCH>
				     <MOVE ,DIAMOND ,MACHINE>)
				    (.SLAG?
				     <MOVE ,SLAG ,MACHINE>)>
			      <TELL
"The machine produces a dazzling display of colored lights and
bizarre noises. A moment later, the excitement abates." CR>)>)
		      (T
		       <TELL "It seems that a " D ,PRSI " won't do." CR>)>)>>

<OBJECT SLAG
	(DESC "small piece of vitreous slag")
	(SYNONYM PIECE SLAG)
	(ADJECTIVE SMALL VITREOUS)
	(FLAGS TAKEBIT TRYTAKEBIT)
	(SIZE 10)
	(ACTION SLAG-F)>

<ROUTINE SLAG-F ()
	 <REMOVE ,SLAG>
	 <TELL "The insubstantial slag crumbles at your touch." CR>>

<OBJECT DIAMOND
	(DESC "huge diamond")
	(LDESC "There is an enormous diamond (perfectly cut) here.")
	(SYNONYM DIAMOND TREASURE)
	(ADJECTIVE HUGE ENORMOUS)
	(FLAGS TAKEBIT TREASUREBIT)
	(VALUE 25)>