"MAZE for
			     Mini-Zork '87
	  (c) Copyright 1987 Infocom, Inc. All Rights Reserved"

<ROOM MAZE-1
      (IN ROOMS)
      (DESC "Maze")
      (LDESC "This is part of a maze of twisty little passages, all alike.")
      (EAST TO TROLL-ROOM)
      (WEST TO MAZE-3)
      (NW TO MAZE-2)
      (NE TO MAZE-1)
      (FLAGS RLANDBIT MAZEBIT)>

<ROOM MAZE-2
      (IN ROOMS)
      (DESC "Maze")
      (LDESC "This is part of a maze of twisty little passages, all alike.")
      (NORTH TO MAZE-1)
      (WEST TO MAZE-2)
      (SE TO MAZE-3)
      (DOWN TO MAZE-5)
      (FLAGS RLANDBIT MAZEBIT)>

<ROOM MAZE-3
      (IN ROOMS)
      (DESC "Maze")
      (LDESC "This is part of a maze of twisty little passages, all alike.")
      (WEST TO MAZE-2)
      (NORTH TO MAZE-1)
      (UP TO MAZE-5)
      (FLAGS RLANDBIT MAZEBIT)>

<ROOM MAZE-4
      (IN ROOMS)
      (DESC "Maze")
      (LDESC "This is part of a maze of twisty little passages, all alike.")
      (EAST TO MAZE-8)
      (DOWN TO MAZE-5)
      (SE TO MAZE-7)
      (SOUTH TO MAZE-10)
      (UP TO MAZE-6)
      (FLAGS RLANDBIT MAZEBIT)>

<ROOM MAZE-5
      (IN ROOMS)
      (DESC "Maze")
      (LDESC "This is part of a maze of twisty little passages, all alike.")
      (NORTH TO MAZE-3)
      (SW TO MAZE-4)
      (NW TO MAZE-2)
      (FLAGS RLANDBIT MAZEBIT)>

<OBJECT BURNED-OUT-LANTERN
	(IN MAZE-5)
	(DESC "burned-out lantern")
	(FDESC "The deceased adventurer's useless lantern is here.")
	(SYNONYM LANTERN LAMP)
	(ADJECTIVE RUSTY BURNED DEAD USELESS)
	(FLAGS TAKEBIT)
	(SIZE 20)>

<OBJECT BAG-OF-COINS
	(IN MAZE-5)
	(DESC "leather bag of coins")
	(LDESC "An old leather bag, bulging with coins, is here.")
	(SYNONYM BAG COINS TREASURE)
	(ADJECTIVE OLD LEATHER)
	(FLAGS TAKEBIT TREASUREBIT)
	(SIZE 15)
	(VALUE 11)
	(ACTION BAG-OF-COINS-F)>

<ROUTINE BAG-OF-COINS-F ()
	 <STUPID-CONTAINER ,BAG-OF-COINS "coins">>

<OBJECT RUSTY-KNIFE
	(IN MAZE-5)
	(DESC "rusty knife")
	(FDESC "Beside the skeleton is a rusty knife.")
	(SYNONYM KNIVES KNIFE)
	(ADJECTIVE RUSTY)
	(FLAGS TAKEBIT TRYTAKEBIT WEAPONBIT TOOLBIT)
	(SIZE 20)
	(ACTION RUSTY-KNIFE-F)>

<ROUTINE RUSTY-KNIFE-F ()
	<COND (<AND <VERB? TAKE>
		    <IN? ,SWORD ,WINNER>>
	       <TELL
"As you touch the rusty knife, your sword gives a single pulse of
blinding blue light." CR>
	       <RFALSE>)
	      (<OR <AND <PRSI? ,RUSTY-KNIFE>
			<VERB? ATTACK>>
		   <AND <VERB? SWING>
			<PRSO? ,RUSTY-KNIFE>
			,PRSI>>
	       <REMOVE ,RUSTY-KNIFE>
	       <JIGS-UP
"The knife, moving with its own force, slowly turns your hand, until the
blade is at your neck. The knife seems to sing as it savagely slits your
throat.">)>>

<OBJECT KEYS
	(IN MAZE-5)
	(DESC "skeleton key")
	(SYNONYM KEY)
	(ADJECTIVE SKELETON)
	(FLAGS TAKEBIT TOOLBIT)
	(SIZE 10)>

<OBJECT SKELETON
	(IN MAZE-5)
	(DESC "skeleton")
	(LDESC
"A skeleton, probably the remains of a luckless adventurer, lies here.")
	(SYNONYM BONES SKELETON BODY)
	(FLAGS TRYTAKEBIT NDESCBIT)
	(ACTION SKELETON-F)>

<ROUTINE SKELETON-F ()
	 <COND (<VERB? TAKE RUB MOVE PUSH RAISE LOWER ATTACK KICK KISS>
	 	<ROB ,HERE ,HADES T>
	 	<ROB ,ADVENTURER ,HADES T>
		<TELL
"A ghost appears, appalled at your desecration of the remains of a fellow
adventurer. He curses your valuables and banishes them to Hades. The ghost
leaves, muttering obscenities." CR>)>>

<ROOM MAZE-6
      (IN ROOMS)
      (DESC "Maze")
      (LDESC "This is part of a maze of twisty little passages, all alike.")
      (DOWN TO MAZE-2)
      (SOUTH TO MAZE-6)
      (SE TO MAZE-4)
      (NE TO GRATING-ROOM)
      (FLAGS RLANDBIT MAZEBIT)>

<ROOM MAZE-7
      (IN ROOMS)
      (DESC "Maze")
      (LDESC "This is part of a maze of twisty little passages, all alike.")
      (UP TO MAZE-10)
      (WEST TO MAZE-4)
      (DOWN TO MAZE-5)
      (SW TO MAZE-7)
      (FLAGS RLANDBIT MAZEBIT)>

<ROOM MAZE-8
      (IN ROOMS)
      (DESC "Maze")
      (LDESC "This is part of a maze of twisty little passages, all alike.")
      (NORTH TO MAZE-8)
      (EAST TO MAZE-9)
      (SE TO MAZE-10)
      (UP TO MAZE-4)
      (FLAGS RLANDBIT MAZEBIT)>

<ROOM MAZE-9
      (IN ROOMS)
      (DESC "Maze")
      (LDESC "This is part of a maze of twisty little passages, all alike.")
      (NORTH TO MAZE-8)
      (SOUTH TO MAZE-10)
      (SE TO CYCLOPS-ROOM)
      (FLAGS RLANDBIT MAZEBIT)>

<ROOM MAZE-10
      (IN ROOMS)
      (DESC "Maze")
      (LDESC "This is part of a maze of twisty little passages, all alike.")
      (SOUTH TO MAZE-9)
      (NE TO MAZE-8)
      (NW TO MAZE-7)
      (SW TO MAZE-4)
      (FLAGS RLANDBIT MAZEBIT)>

<ROOM GRATING-ROOM
      (IN ROOMS)
      (DESC "Grating Room")
      (SW TO MAZE-6)
      (UP TO FOREST-PATH IF GRATE IS OPEN ELSE "The grating is closed.")
      (GLOBAL GRATE)
      (FLAGS RLANDBIT)
      (ACTION GRATING-ROOM-F)>

<GLOBAL GRATE-REVEALED <>>

<GLOBAL GRUNLOCK <>>

<ROUTINE GRATING-ROOM-F (RARG)
  	 <COND (<EQUAL? .RARG ,M-ENTER>
		<FCLEAR ,GRATE ,INVISIBLE>)
	       (<EQUAL? .RARG ,M-LOOK>
		<TELL
"You are in a room off the maze, which lies to the southwest. Above you is a">
		<COND (<FSET? ,GRATE ,OPENBIT>
		       <TELL "n open grating with sunlight pouring in.">)
		      (,GRUNLOCK
		       <TELL " grating.">)
		      (T
		       <TELL
" grating locked with a skull-and-crossbones lock.">)>)>>

<OBJECT GRATE
	(IN LOCAL-GLOBALS)
	(DESC "grating")
	(SYNONYM GRATE GRATING)
	(FLAGS DOORBIT NDESCBIT INVISIBLE)
	(ACTION GRATE-F)>

<ROUTINE GRATE-F ()
    	 <COND (<AND <VERB? OPEN>
		     <PRSI? ,KEYS>>
		<PERFORM ,V?UNLOCK ,GRATE ,KEYS>
		<RTRUE>)
	       (<AND <VERB? LOCK UNLOCK>
		     <EQUAL? ,HERE ,FOREST-PATH>>
		<TELL ,YOU-CANT "from this side." CR>)
	       (<VERB? LOCK>
		<SETG GRUNLOCK <>>
		<TELL "Locked." CR>)
	       (<AND <VERB? UNLOCK>
		     <PRSO? ,GRATE>>
		<COND (<PRSI? ,KEYS>
		       <SETG GRUNLOCK T>
		       <TELL "Unlocked." CR>)
		      (T
		       <TELL "With a " D ,PRSI "!?!" CR>)>)
               (<VERB? PICK>
		<TELL "You haven't the skill." CR>)
               (<VERB? OPEN CLOSE>
		<COND (,GRUNLOCK
		       <OPEN-CLOSE ,GRATE "The grating opens."
				          "The grating closes.">
		       <COND (<FSET? ,GRATE ,OPENBIT>
			      <FSET ,GRATING-ROOM ,ONBIT>
			      <COND (<AND <NOT <EQUAL? ,HERE ,FOREST-PATH>>
					  <NOT ,GRATE-REVEALED>>
				     
				     <SETG GRATE-REVEALED T>
				     <MOVE ,LEAVES ,HERE>
				     <TELL
"A pile of leaves falls onto your head and to the ground." CR>)>)
			     (T
			      <FCLEAR ,GRATING-ROOM ,ONBIT>)>
		       <RTRUE>)
		      (T
		       <TELL "The grating is locked." CR>)>)
	       (<AND <VERB? PUT>
		     <PRSI? ,GRATE>>
		<TELL "It won't fit through the grating." CR>)>>

<ROOM CYCLOPS-ROOM
      (IN ROOMS)
      (DESC "Cyclops Room")
      (NW TO MAZE-9)
      (EAST TO LIVING-ROOM IF MAGIC-FLAG)
      (UP TO THIEFS-LAIR IF CYCLOPS-FLAG ELSE
       "The cyclops won't let you past.")
      (FLAGS RLANDBIT)
      (GLOBAL STAIRS)
      (ACTION CYCLOPS-ROOM-F)>

<GLOBAL CYCLOWRATH 0>

<GLOBAL CYCLOPS-FLAG <>>

<GLOBAL MAGIC-FLAG <>>

<ROUTINE CYCLOPS-ROOM-F (RARG)
	<COND (<EQUAL? .RARG ,M-LOOK>
	       <TELL
"This room has a northwest exit and a staircase leading up. ">
	       <D-CYCLOPS>)
	      (<EQUAL? .RARG ,M-ENTER>
	       <OR <0? ,CYCLOWRATH> <ENABLE <INT I-CYCLOPS>>>)>>

<OBJECT CYCLOPS
	(IN CYCLOPS-ROOM)
	(DESC "cyclops")
	(SYNONYM CYCLOPS EYE)
	(ADJECTIVE HUNGRY GIANT)
	(FLAGS ACTORBIT NDESCBIT TRYTAKEBIT)
	(ACTION CYCLOPS-F)>

<ROUTINE CYCLOPS-F ()
	<COND (<EQUAL? ,WINNER ,CYCLOPS>
	       <COND (,CYCLOPS-FLAG
		      <TELL "He's fast asleep." CR>)
		     (<VERB? ODYSSEUS>
		      <SETG WINNER ,ADVENTURER>
		      <PERFORM ,V?ODYSSEUS>
		      <RTRUE>)
		     (T
		      <TELL "He's not much of a conversationalist." CR>)>)
	      (<VERB? EXAMINE>
	       <D-CYCLOPS>
	       <CRLF>)
	      (,CYCLOPS-FLAG
	       <COND (<OR <VERB? ALARM KICK ATTACK BURN MUNG>
			  <AND <VERB? TIE-UP>
			       <PRSI? ,ROPE>>>
		      <TELL
"The cyclops yawns and stares at the thing that woke him up." CR>
		      <SETG CYCLOPS-FLAG <>>
		      <COND (<L? ,CYCLOWRATH 0>
			     <SETG CYCLOWRATH <- ,CYCLOWRATH>>)>)>)
	      (<AND <VERB? GIVE>
		    <PRSI? ,CYCLOPS>>
	       <COND (<PRSO? ,LUNCH>
		      <ENABLE <QUEUE I-CYCLOPS -1>>
		      <COND (<G? ,CYCLOWRATH -1>
			     <REMOVE ,LUNCH>
			     <SETG CYCLOWRATH
				   <COND (<L? -1 <- ,CYCLOWRATH>> -1)
					 (T <- ,CYCLOWRATH>)>>
			     <TELL
"The cyclops says, \"Yum, that made me thirsty. Perhaps I could drink the
blood of that thing.\" It appears that YOU are \"that thing.\"" CR>)>)
		     (<OR <PRSO? ,WATER>
			  <AND <PRSO? ,BOTTLE>
			       <IN? ,WATER ,BOTTLE>>>
		      <COND (<L? ,CYCLOWRATH 0>
			     <REMOVE-CAREFULLY ,WATER>
			     <MOVE ,BOTTLE ,HERE>
			     <FSET ,BOTTLE ,OPENBIT>
			     <SETG CYCLOPS-FLAG T>
			     <TELL
"The cyclops empties the bottle, yawns, and falls fast asleep. (What did
you put in that drink, anyway?)" CR>)
			    (T
			     <TELL
,CYCLOPS-IS "n't thirsty and refuses your offer." CR>)>)
		     (<PRSO? ,GARLIC>
		      <TELL ,CYCLOPS-IS "n't THAT hungry." CR>)
		     (T
		      <TELL "The cyclops won't eat THAT!" CR>)>)
	      (<VERB? THROW ATTACK MUNG>
	       <ENABLE <QUEUE I-CYCLOPS -1>>
	       <COND (<VERB? MUNG>
		      <TELL
"\"Do you think I'm as stupid as my father was?\", he says, dodging." CR>)
		     (T
		      <COND (<VERB? THROW>
			     <MOVE ,PRSO ,HERE>)>
		      <TELL "The cyclops ignores your pitiful attempt." CR>)>)
	      (<VERB? TIE>
	       <TELL "You cannot tie him, though he is fit to be tied." CR>)
	      (<VERB? LISTEN>
	       <TELL "You can hear his stomach rumbling." CR>)>>

<ROUTINE D-CYCLOPS ()
	 <COND (,MAGIC-FLAG
		<TELL "The east wall has a cyclops-sized opening in it.">)
	       (,CYCLOPS-FLAG
		<TELL
"The cyclops sleeps blissfully at the foot of the stairs.">)
	       (<0? ,CYCLOWRATH>
		<TELL
"A hungry cyclops blocks the staircase. From the bloodstains on the walls,
you gather that he is not very friendly, though he likes people.">)
	       (<G? ,CYCLOWRATH 0>
		<TELL
,CYCLOPS-IS " eyeing you closely. I don't think he likes you very much.
He looks extremely hungry, even for a cyclops.">)
	       (<L? ,CYCLOWRATH 0>
		<TELL
"The cyclops, having eaten the hot peppers, appears to be gasping.
His enflamed tongue protrudes from his man-sized mouth.">)>>

<ROUTINE I-CYCLOPS ()
	 <COND (<OR ,CYCLOPS-FLAG
		    ,DEAD>
		<RTRUE>)
	       (<NOT <EQUAL? ,HERE ,CYCLOPS-ROOM>>
		<DISABLE <INT I-CYCLOPS>>)
	       (<G? <ABS ,CYCLOWRATH> 5>
		<DISABLE <INT I-CYCLOPS>>
		<JIGS-UP
"The cyclops, tired of your trickery, grabs you firmly. \"Mmm. Just like Mom
used to make 'em.\"">)
	       (T
		<COND (<L? ,CYCLOWRATH 0>
		       <SETG CYCLOWRATH <- ,CYCLOWRATH 1>>)
		      (T
		       <SETG CYCLOWRATH <+ ,CYCLOWRATH 1>>)>
		<COND (<NOT ,CYCLOPS-FLAG>
		       <TELL
,CYCLOPS-IS <NTH ,CYCLOMAD <- <ABS ,CYCLOWRATH> 1>> CR>)>)>>

<GLOBAL CYCLOMAD
	<TABLE (PURE)
" agitated."
" getting more agitated."
" looking for something."
" now holding salt and pepper. Condiments for an upcoming snack?"
" looking at you and drooling."
" approaching in an unfriendly manner. You can: 1. Leave 2. Become dinner.">>

<ROOM THIEFS-LAIR
      (IN ROOMS)
      (DESC "Thief's Lair")
      (LDESC "The only visible exit is down a staircase.")
      (DOWN TO CYCLOPS-ROOM)
      (FLAGS RLANDBIT ;"can't have onbit")
      (VALUE 20)
      (GLOBAL STAIRS)
      (ACTION THIEFS-LAIR-F)>

<ROUTINE THIEFS-LAIR-F (RARG)
	 <COND (<AND <EQUAL? .RARG ,M-ENTER>
		     <1? <GET <INT I-THIEF> ,C-ENABLED?>>
		     <NOT ,DEAD>>
		<FCLEAR ,THIEF ,INVISIBLE>
		<COND (<NOT <IN? ,THIEF ,HERE>>
		       <MOVE ,THIEF ,HERE>
		       <ENABLE <QUEUE I-FIGHT -1>>
		       <TELL
"You hear a scream of anguish as the robber rushes
to defend his hideaway." CR>)>)>>

<OBJECT CHALICE
	(IN THIEFS-LAIR)
	(DESC "chalice")
	(LDESC "There is an intricate silver chalice here.")
	(SYNONYM CHALICE CUP TREASURE)
	(ADJECTIVE SILVER INTRICATE)
	(FLAGS TREASUREBIT TAKEBIT TRYTAKEBIT CONTBIT SEARCHBIT)
	(CAPACITY 5)
	(SIZE 10)
	(VALUE 20)
	(ACTION CHALICE-F)>

<ROUTINE CHALICE-F ()
	 <COND (<VERB? OPEN CLOSE>
		<TELL "Huh?" CR>)>>