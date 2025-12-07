"ALICE for
	        Mini-Zork II: The Wizard of Frobozz
	(c) Copyright 1988 Infocom, Inc.  All Rights Reserved."

<ROOM RIDDLE-ROOM
       (IN ROOMS)
       (DESC "Riddle Room")
       (NW TO CAROUSEL-ROOM)
       (EAST TO CIRCULAR-ROOM IF RIDDLE-DOOR IS OPEN)
       (FLAGS RLANDBIT)
       (ACTION RIDDLE-ROOM-F)
       (PSEUDO "RIDDLE" RIDDLE-PSEUDO)>

<ROUTINE RIDDLE-ROOM-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"This bare room has an exit in the northwest corner. To the east is a great ">
		<COND (<FSET? ,RIDDLE-DOOR ,OPENBIT>
		       <TELL "open">)
		      (T
		       <TELL "closed">)>
		<TELL
" door of stone. Above it is written: \"No one shall pass without solving
this riddle:" CR CR ,RIDDLE-TEXT>)
	       (<EQUAL? .RARG ,M-BEG>
		<COND (<VERB? SAY>
		       <COND (<FSET? ,RIDDLE-DOOR ,OPENBIT>
			      <RFALSE>)
			     (<OR <EQUAL? <GET ,P-LEXV ,P-CONT> ,W?WELL>
				  <EQUAL? <GET ,P-LEXV <+ ,P-CONT 2>> ,W?WELL>>
			      <SETG SCORE <+ ,SCORE 5>>
			      <FSET ,RIDDLE-DOOR ,OPENBIT>
			      <TELL
"With a deafening clap of thunder, the door opens." CR>)
			     (T
			      <TELL "A hollow laugh comes from the door." CR>)>
		      <SETG P-CONT <>>
		      <SETG QUOTE-FLAG <>>
		      <RTRUE>)>)>>

<ROUTINE RIDDLE-PSEUDO ()
	 <COND (<VERB? EXAMINE READ>
		<TELL ,RIDDLE-TEXT>)>>

<OBJECT RIDDLE-DOOR
	(IN RIDDLE-ROOM)
	(DESC "stone door")
	(SYNONYM DOOR)
	(ADJECTIVE GREAT STONE)
	(FLAGS DOORBIT CONTBIT NDESCBIT)
	(ACTION RIDDLE-DOOR-F)>

<ROUTINE RIDDLE-DOOR-F ()
	 <COND (<OR <AND <VERB? OPEN>
			 <NOT <FSET? ,RIDDLE-DOOR ,OPENBIT>>>
		    <AND <VERB? CLOSE>
			 <FSET? ,RIDDLE-DOOR ,OPENBIT>>>
		<TELL "It won't budge." CR>)>>

<ROOM CIRCULAR-ROOM
      (IN ROOMS)
      (DESC "Circular Room")
      (LDESC
"This is a tall, damp room with brick walls. There are some etchings on
the walls. A passage leads west.")
      (WEST TO RIDDLE-ROOM)
      (UP "The walls cannot be climbed.")
      (FLAGS RLANDBIT NONLANDBIT)
      (GLOBAL WELL)>

<OBJECT BOTTOM-ETCHINGS
	(IN CIRCULAR-ROOM)
	(DESC "wall with etchings")
	(SYNONYM ETCHINGS WALL)
	(FLAGS READBIT NDESCBIT)
	(TEXT
"       o  b  o|
|
       A  G  I|
|
        E   L|
|
       m  p  a")>

<OBJECT PEARL-NECKLACE
	(IN CIRCULAR-ROOM)
	(DESC "pearl necklace")
	(SYNONYM NECKLACE TREASURE)
	(ADJECTIVE PEARL)
	(SIZE 10)
	(VALUE 15)
	(FLAGS TAKEBIT)>

<OBJECT BUCKET
	(IN CIRCULAR-ROOM)
	(DESC "wooden bucket")
	(LDESC
"There is a wooden bucket here, 3 feet in diameter and 3 feet high.")
	(SYNONYM BUCKET)
	(ADJECTIVE WOODEN)
	(CAPACITY 100)
	(SIZE 100)
	(VTYPE 0)
	(FLAGS VEHBIT OPENBIT CONTBIT)
	(CONTFCN BUCKET-CONT)
	(ACTION BUCKET-F)>

<ROUTINE BUCKET-CONT ()
	 <COND (<AND <VERB? TAKE>
		     <NOT <IN? ,WINNER ,BUCKET>>>
	        <TELL "You must get in the bucket to reach it." CR>)>>

<ROUTINE BUCKET-F ("OPTIONAL" (RARG ,M-BEG))
	<COND (<EQUAL? .RARG ,M-BEG>
	       <COND (<AND <VERB? BURN>
			   <EQUAL? ,PRSO ,BUCKET>>
		      <TELL "The bucket appears to be fireproof." CR>)
		     (<AND <VERB? DROP PUT>
			   <EQUAL? ,PRSO ,WATER>
			   <EQUAL? ,PRSI ,BUCKET>
			   <IN? ,BUCKET ,CIRCULAR-ROOM>
			   <NOT <IN? ,WINNER ,BUCKET>>>
		      <MOVE ,BUCKET ,TOP-OF-WELL>
		      <MOVE ,WATER ,BUCKET>
		      <SETG BUCKET-TOP-FLAG T>
		      <ENABLE <QUEUE I-BUCKET 100>>
		      <TELL "The bucket swiftly rises up, and is gone." CR>)
		     (<VERB? KICK>
		      <JIGS-UP "If you insist.">)>)
	      (<EQUAL? .RARG ,M-END>
	       <COND (<AND <IN? ,WATER ,BUCKET>
			   <NOT ,BUCKET-TOP-FLAG>>
		      <SETG BUCKET-TOP-FLAG T>
		      <SETG EVAPORATED <>>
		      <PASS-THE-BUCKET ,TOP-OF-WELL>
		      <ENABLE <QUEUE I-BUCKET 100>>
		      <TELL "The bucket rises and" ,STOPS>)
		     (<AND ,BUCKET-TOP-FLAG
			   <NOT <IN? ,WATER ,BUCKET>>>
		      <COND (,EVAPORATED
			     <TELL
"The last of the water evaporates, and the bucket descends." CR CR>)
			    (T
			     <TELL "The bucket descends and" ,STOPS>)>
		      <SETG BUCKET-TOP-FLAG <>>
		      <PASS-THE-BUCKET ,CIRCULAR-ROOM>)>)
	      (<VERB? CLIMB-ON>
	       <PERFORM ,V?ENTER ,PRSO>
	       <RTRUE>)>>

<ROUTINE PASS-THE-BUCKET (R)
	 <MOVE ,BUCKET .R>
	 <COND (<IN? ,WINNER ,BUCKET>
		<GOTO .R>)>>

<GLOBAL BUCKET-TOP-FLAG <>>

<GLOBAL EVAPORATED <>>

<ROUTINE I-BUCKET ()
	 <COND (<IN? ,WATER ,BUCKET>
		<SETG EVAPORATED T>
		<REMOVE ,WATER>)>
	 <RFALSE>>

<OBJECT WELL
        (IN LOCAL-GLOBALS)
	(DESC "well")
	(SYNONYM WELL)
	(ADJECTIVE MAGIC)
	(FLAGS NDESCBIT)
	(ACTION WELL-F)>

<ROUTINE WELL-F ()
    	<COND (<AND <VERB? THROW PUT DROP>
		    <FSET? ,PRSO ,TAKEBIT>>
	       <MOVE ,PRSO ,CIRCULAR-ROOM>
	       <TELL "The " D ,PRSO " is now at the bottom of the well." CR>)
	      (<VERB? CLIMB CLIMB-DOWN>
	       <TELL "You can't climb the well." CR>)>>

<ROOM TOP-OF-WELL
      (IN ROOMS)
      (DESC "Top of Well")
      (LDESC
"You have made it to the top. Well done. There are etchings on the well. A
crack runs across the floor at the doorway to the east, but it can be crossed
easily. Another doorway leads northeast.")
      (EAST TO TEA-ROOM)
      (NE TO MACHINE-ROOM)
      (DOWN "It's a long way down!")
      (VALUE 10)
      (FLAGS RLANDBIT NONLANDBIT)
      (GLOBAL WELL)
      (PSEUDO "CRACK" CRACK-PSEUDO)>

<ROUTINE CRACK-PSEUDO ()
	 <COND (<VERB? EXAMINE>
		<TELL "It's a small, uninteresting crack." CR>)>>

<OBJECT TOP-ETCHINGS
	(IN TOP-OF-WELL)
	(DESC "wall with etchings")
	(SYNONYM ETCHINGS WALL)
	(FLAGS READBIT NDESCBIT)
	(TEXT
"       o  b  o|
   r             z|
f   M  A  G  I  C   z|
|
c    W  E   L  L    y|
   o             n|
       m  p  a")>

<OBJECT ROBOT
	(IN TOP-OF-WELL)
	(DESC "robot")
	(SYNONYM ROBOT)
	(FLAGS ACTORBIT CONTBIT OPENBIT)
	(ACTION ROBOT-F)>

<ROUTINE ROBOT-F ("OPTIONAL" (RARG ,M-OBJECT)) ;"RARG necesary?"
	<COND (<EQUAL? ,WINNER ,ROBOT>
	       <COND (<VERB? SGIVE>
		      <RFALSE>)
		     (<VERB? FOLLOW>
		      <TELL
"\"I'm too primitive. I can walk in any direction you order, though.\"" CR>)
		     (<AND <VERB? RAISE TAKE MOVE>
			   <EQUAL? ,PRSO ,CAGE-OBJECT>>
		      <TELL "The robots pulverizes the cage to dust." CR CR>
		      <DISABLE <INT I-CAGE-DEATH>>
		      <SETG WINNER ,ADVENTURER>
		      <FCLEAR ,ROBOT ,NDESCBIT>
		      <FSET ,PALANTIR-1 ,TAKEBIT>
		      <MOVE ,ROBOT ,DINGY-CLOSET>
		      <SETG CAGE-SOLVE-FLAG T>
		      <GOTO ,DINGY-CLOSET>)
		     (<VERB? DROP PUT THROW>
		      <COND (<NOT <ACCESSIBLE? ,ROBOT>>
			     <RFALSE>)
			    (T
			     <TELL ,B-W-C>
			     <COND (<IN? ,PRSO ,ROBOT>
			     	    <TELL "\"" CR>
				    <RFALSE>)
				   (T
			            <TELL " I don't have that!\"" CR>)>)>)
		     (<OR <VERB? WALK>
			  <AND <VERB? TAKE PUSH>
			       <NOT <FSET? ,PRSO ,ACTORBIT>>>>
		      <COND (<NOT <ACCESSIBLE? ,ROBOT>>
			     <RFALSE>)
			    (T
			     <TELL ,B-W-C "\"" CR>)>
		      <RFALSE>)
		     (T
		      <COND (<ACCESSIBLE? ,ROBOT>
			     <TELL
"\"My programming is insufficient for that task.\"" CR>)>
		      <RTRUE>)>)
	      (<VERB? OPEN LOOK-INSIDE CLOSE>
	       <TELL "The robot has no access panel." CR>)
	      (<AND <VERB? GIVE>
		    <EQUAL? ,PRSI ,ROBOT>>
	       <MOVE ,PRSO ,ROBOT>
	       <TELL "The robot accepts the " D ,PRSO ,PERIOD-CR>)
	      (<VERB? THROW MUNG>
	       <TELL
"The robot (being of shoddy construction) disintegrates before your eyes." CR>
	       <REMOVE <COND (<VERB? THROW> ,PRSI)
			     (T ,PRSO)>>)>>

<OBJECT ROBOT-LABEL
	(IN TOP-OF-WELL)
	(DESC "green piece of paper")
	(SYNONYM PAPER PIECE)
	(ADJECTIVE GREEN)
	(SIZE 3)
	(FLAGS READBIT TAKEBIT BURNBIT)
	(TEXT
"This robot was trained at GUE Tech to perform simple household functions. To
activate, say:|
        >ROBOT, <thing to do>|
A product of the Frobozz Magic Robot Company.")>

<ROOM MACHINE-ROOM
      (IN ROOMS)
      (DESC "Machine Room")
      (LDESC
"This room is full of assorted machinery, whirring noisily. On one wall is a
triangular button labelled, \"DANGER -- HIGH VOLTAGE.\" There are exits to the
south and southwest.")
      (SOUTH TO DINGY-CLOSET)
      (SW TO TOP-OF-WELL)
      (FLAGS RLANDBIT ONBIT)>

<OBJECT TRIANGULAR-BUTTON
	(IN MACHINE-ROOM)
	(DESC "triangular button")
	(SYNONYM BUTTON)
	(ADJECTIVE TRIANGULAR)
	(FLAGS NDESCBIT)
	(ACTION TRIANGULAR-BUTTON-F)>

<GLOBAL CAROUSEL-ON T>

<ROUTINE TRIANGULAR-BUTTON-F ()
	<COND (<VERB? PUSH>
	       <COND (<EQUAL? ,WINNER ,ADVENTURER>
		      <JIGS-UP "You are instantly electrocuted.">)
		     (T
		      <SETG CAROUSEL-ON <NOT ,CAROUSEL-ON>>
		      <COND (<FSET? ,VIOLIN ,INVISIBLE>
			     <FCLEAR ,VIOLIN ,INVISIBLE>
			     <FCLEAR ,CAROUSEL-ROOM ,TOUCHBIT>
			     <TELL "You hear a distant thump." CR>)
			    (T
			     <TELL "Click." CR>)>)>)>>

<ROOM DINGY-CLOSET
      (IN ROOMS)
      (DESC "Dingy Closet")
      (LDESC
"This is a former broom closet. A larger room lies to the north. Chiselled
on the wall are the words \"Protected by the Frobozz Magic Alarm Company.\"")
      (OUT TO MACHINE-ROOM)
      (NORTH TO MACHINE-ROOM)
      (FLAGS ONBIT RLANDBIT)>

<OBJECT CAGE-OBJECT
	(IN DINGY-CLOSET)
	(DESC "solid steel cage")
	(SYNONYM CAGE)
	(ADJECTIVE STEEL SOLID)
	(FLAGS INVISIBLE)>

<ROOM CAGE
      (IN ROOMS)
      (DESC "Cage")
      (LDESC "You are trapped in a solid steel cage.")
      (FLAGS RLANDBIT NWALLBIT ONBIT)
      (ACTION CAGE-F)>

<GLOBAL CAGE-SOLVE-FLAG <>>

<ROUTINE CAGE-F (RARG)
	 <COND (,CAGE-SOLVE-FLAG
		<SETG HERE ,DINGY-CLOSET>)>>

<ROUTINE I-CAGE-DEATH ()
	 <COND (<EQUAL? ,HERE ,DINGY-CLOSET ,CAGE>
		<FSET ,PALANTIR-1 ,INVISIBLE>
		<JIGS-UP "The poison gas takes effect.">)>>

<ROOM TEA-ROOM
      (IN ROOMS)
      (DESC "Tea Room")
      (LDESC
"An oblong table here is set for afternoon tea. It is clear that the users
were indeed mad. To the east is a small hole (perhaps four inches high). A
doorway leads west.")
      (EAST "Only a mouse could fit.")
      (WEST TO TOP-OF-WELL)
      (FLAGS RLANDBIT ONBIT)
      (PSEUDO "HOLE" ALICE-HOLE)>

<ROUTINE ALICE-HOLE ()
	 <COND (<VERB? ENTER EXAMINE>
		<DO-WALK ,P?EAST>)
	       (<VERB? LOOK-INSIDE>
		<TELL ,ONLY-DARKNESS>)
	       (<AND <VERB? PUT>
		     <EQUAL? ,PRSI ,PSEUDO-OBJECT>>
		<TELL "It doesn't fit." CR>)>>

<OBJECT PORTRAIT
	(IN TEA-ROOM)
	(DESC "portrait of J. Pierpont Flathead")
	(FDESC "A rare portrait of J. Pierpont Flathead hangs on the wall.")
	(SYNONYM PORTRAIT PAINTING TREASURE)
	(ADJECTIVE RARE FLATHEAD)
	(SIZE 25)
	(VALUE 20)
	(FLAGS TAKEBIT BURNBIT)>

<OBJECT ALICE-TABLE
	(IN TEA-ROOM)
	(DESC "table")
	(SYNONYM TABLE)
	(ADJECTIVE OBLONG)
	(CAPACITY 50)
	(FLAGS CONTBIT SURFACEBIT OPENBIT)>

<OBJECT GREEN-CAKE
	(SIZE 4)
	(IN ALICE-TABLE)
	(DESC "cake frosted with green letters")
	(SYNONYM CAKE ICING CAKES LETTER)
	(ADJECTIVE GREEN FROSTED)
	(FLAGS READBIT TAKEBIT FOODBIT)
	(TEXT "The icing spells, \"Eat Me.\"")
	(ACTION GREEN-CAKE-F)>

<ROUTINE GREEN-CAKE-F ("AUX" F N)
    <COND (<AND <VERB? EAT>
		<EQUAL? ,PRSO ,GREEN-CAKE>
		<EQUAL? ,HERE ,TEA-ROOM>>
	   <REMOVE ,GREEN-CAKE>
	   <FSET ,ALICE-TABLE ,INVISIBLE>
	   <FSET ,ROBOT ,INVISIBLE>
	   <SET F <FIRST? ,HERE>>
	   <REPEAT ()
		   <COND (<NOT .F>
			  <RETURN>)>
		   <SET N <NEXT? .F>>
		   <COND (<AND <NOT <EQUAL? .F ,ADVENTURER>>
			       <FSET? .F ,TAKEBIT>>
			  <FSET .F ,NONLANDBIT>
			  <FSET .F ,TRYTAKEBIT>
			  <MOVE .F ,POSTS-ROOM>)>
		   <SET F .N>>
	   <TELL
"Suddenly, the room becomes huge (although your possessions retain their
normal size)." CR CR>
	   <GOTO ,POSTS-ROOM>)
	  (T
	   <CAKE-CRUMBLE>)>>

<OBJECT BLUE-CAKE
	(IN ALICE-TABLE)
	(DESC "cake frosted with blue letters")
	(SYNONYM CAKE ICING CAKES LETTER)
	(ADJECTIVE BLUE FROSTED)
	(SIZE 4)
	(FLAGS READBIT TAKEBIT FOODBIT)
	(ACTION CAKE-F)>

<OBJECT ORANGE-CAKE
	(IN ALICE-TABLE)
	(DESC "cake frosted with orange letters")
	(SYNONYM CAKE CAKES ICING LETTER)
	(ADJECTIVE ORANGE FROSTED)
	(SIZE 4)
	(FLAGS READBIT TAKEBIT FOODBIT)
	(ACTION CAKE-F)>

<OBJECT RED-CAKE
	(IN ALICE-TABLE)
	(DESC "cake frosted with red letters")
	(SYNONYM CAKE CAKES ICING LETTER)
	(ADJECTIVE RED FROSTED)
	(SIZE 4)
	(FLAGS READBIT TAKEBIT FOODBIT)
	(ACTION CAKE-F)>

<ROUTINE CAKE-F ("AUX" F N)
	<COND (<VERB? READ>
	       <COND (<FSET? ,PRSO ,NONLANDBIT>
		      <TELL "The cake is now too tall to read." CR>)
		     (T
		      <TELL
"The letters are tiny; all you can make out is \"E">
		      <COND (<EQUAL? ,PRSO ,RED-CAKE>
			     <TELL "VA">)
			    (<EQUAL? ,PRSO ,ORANGE-CAKE>
			     <TELL "XP">)
			    (T
			     <TELL "NL">)>
		      <TELL "\"." CR>)>)
	      (<AND <VERB? EAT>
		    <EQUAL? ,HERE ,TEA-ROOM ,POSTS-ROOM ,POOL-ROOM>>
	       <COND (<EQUAL? ,PRSO ,ORANGE-CAKE>
		      <REMOVE ,PRSO>
    		      <JIGS-UP
"You are blasted to smithereens (wherever they are).">)
		     (<EQUAL? ,PRSO ,RED-CAKE>
		      <REMOVE ,PRSO>
		      <JIGS-UP "Taste: yum. Effect: massive dehydration.">)
		     (<EQUAL? ,PRSO ,BLUE-CAKE>
		      <REMOVE ,PRSO>
		      <TELL "The room shrinks." CR CR>
		      <COND (<EQUAL? ,HERE ,POSTS-ROOM>
			     <FCLEAR ,ROBOT ,INVISIBLE>
			     <FCLEAR ,ALICE-TABLE ,INVISIBLE>
			     <FSET ,POSTS ,INVISIBLE>
			     <SET F <FIRST? ,HERE>>
	   		     <REPEAT ()
				<COND (<NOT .F>
				       <RETURN>)>
				<SET N <NEXT? .F>>
				<COND (<AND <NOT <EQUAL? .F ,ADVENTURER>>
					    <FSET? .F ,TAKEBIT>>
				       <FCLEAR .F ,NONLANDBIT>
				       <FCLEAR .F ,TRYTAKEBIT>
				       <MOVE .F ,TEA-ROOM>)>
				<SET F .N>>
			     <GOTO ,TEA-ROOM>)
			    (T
			     <JIGS-UP
"The room is now too small to hold you, and the walls are tougher
than your body." >)>)>)
	      (<AND <VERB? THROW PUT>
		    <EQUAL? ,PRSO ,ORANGE-CAKE>
		    <EQUAL? ,HERE ,TEA-ROOM ,POSTS-ROOM ,POOL-ROOM>>
	       <REMOVE ,PRSO>
    	       <JIGS-UP
"You are blasted to smithereens (wherever they are).">)
	      (<AND <VERB? THROW PUT>
		    <EQUAL? ,PRSI ,POOL>>
	       <COND (<EQUAL? ,PRSO ,BLUE-CAKE ,ORANGE-CAKE>
		      <TELL "\"Splash!\"" CR>
		      <REMOVE ,PRSO>
		      <RTRUE>)>
	       <MOVE ,PRSO ,HERE>
	       <REMOVE ,PRSI>
	       <FCLEAR ,CANDY ,INVISIBLE>
	       <TELL
"The pool evaporates, leaving a damp (but still valuable) package of
rare candies." CR>)
	      (T
	       <CAKE-CRUMBLE>)>>

<ROUTINE CAKE-CRUMBLE ("AUX" CAKE)
	 <COND (<FSET? ,PRSO ,FOODBIT>
		<SET CAKE ,PRSO>)
	       (T
		<SET CAKE ,PRSI>)>
	 <COND (<OR <EQUAL? ,HERE ,TEA-ROOM ,POSTS-ROOM ,POOL-ROOM>
		    <EQUAL? ,HERE ,MACHINE-ROOM ,DINGY-CLOSET ,TOP-OF-WELL>
		    <EQUAL? ,HERE ,CAGE>>
	        <RFALSE>)
	       (T
	        <REMOVE .CAKE>
	        <TELL "The " D .CAKE " crumbles to dust." CR>)>>

<ROOM POSTS-ROOM
      (IN ROOMS)
      (DESC "Posts Room")
      (LDESC
"In the center of this enormous room, four wooden posts support a huge
oblong roof. To the east is a large hole; to the west a gaping chasm.")
      (EAST TO POOL-ROOM)
      (WEST "A chasm blocks your way.")
      (FLAGS RLANDBIT ONBIT)
      (VALUE 10)
      (GLOBAL CHASM)
      (ACTION POSTS-ROOM-F)>

<ROUTINE POSTS-ROOM-F (RARG)
	 <COND (<AND <EQUAL? .RARG ,M-BEG>
		     <VERB? TAKE>
		     <FSET? ,PRSO ,NONLANDBIT>>
		<TELL
"The " D ,PRSO " is now huge. You have no hope of taking it." CR>)>>

<OBJECT POSTS
	(IN POSTS-ROOM)
	(DESC "group of wooden posts")
	(SYNONYM POSTS POST)
	(ADJECTIVE WOODEN)
	(FLAGS NDESCBIT)>

<ROOM POOL-ROOM
      (IN ROOMS)
      (DESC "Pool Room")
      (LDESC "The far half of this room is depressed. The only exit is west.")
      (OUT TO POSTS-ROOM)
      (WEST TO POSTS-ROOM)
      (FLAGS RLANDBIT)>

<OBJECT POOL
	(IN POOL-ROOM)
	(DESC "pool")
	(LDESC
"The depressed area is filled with water. There is something hazy at the
deepest part of the pool.")
	(SYNONYM POOL)
	(ACTION POOL-F)>

<ROUTINE POOL-F ()
	 <COND (<VERB? DRINK>
		<PERFORM ,V?DRINK ,WATER>
		<RTRUE>)
	       (<VERB? LOOK-UNDER>
		<TELL "You can't make out what's below the surface." CR>)
	       (<VERB? ENTER>
		<V-SWIM>)>>

<OBJECT CANDY
	(IN POOL-ROOM)
	(DESC "package of candy")
	(LDESC "There is a package of candied insects here.")
	(SYNONYM PACKAGE CANDY INSECTS)
	(ADJECTIVE CANDIED RARE)
	(SIZE 8)
	(VALUE 15)
	(FLAGS FOODBIT TAKEBIT INVISIBLE READBIT)
	(ACTION CANDY-F)>

<ROUTINE CANDY-F ()
	 <COND (<VERB? EXAMINE READ>
		<TELL
"\"Frobozz Magic Candy Company -- Special Assortment! Candied Grasshoppers,
Chocolated Ants, and Worms Glacee!\"" CR>)
	       (<VERB? EAT OPEN>
		<TELL "It's too rich for your tastes." CR>)>>