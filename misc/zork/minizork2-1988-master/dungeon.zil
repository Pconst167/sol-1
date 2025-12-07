"DUNGEON for
	        Mini-Zork II: The Wizard of Frobozz
	(c) Copyright 1988 Infocom, Inc.  All Rights Reserved."

<ROOM INSIDE-THE-BARROW
      (IN ROOMS)
      (DESC "Inside the Barrow")
      (LDESC
"You are in an ancient barrow which opens to the southwest.")
      (SW TO GREAT-CAVERN)
      (FLAGS RLANDBIT ONBIT)>

<OBJECT LAMP
	(IN INSIDE-THE-BARROW)
	(DESC "lamp")
	(FDESC "A familiar brass lantern is lying on the ground.")
	(SYNONYM LAMP LANTERN LIGHT)
	(ADJECTIVE BRASS)
	(SIZE 15)
	(FLAGS TAKEBIT LIGHTBIT)
	(ACTION LAMP-F)>

<ROUTINE LAMP-F ()
	 <COND (<AND <VERB? THROW>
		     <PRSO? ,LAMP>>
		<TELL "You'd break it!" CR>)
	       (<AND <VERB? EXAMINE LAMP-ON LAMP-OFF>
		     ,LAMP-BURNED-OUT>
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

<GLOBAL LAMP-BURNED-OUT <>>

<ROUTINE I-LANTERN ("AUX" TICK (TBL <VALUE LAMP-TABLE>))
	 <ENABLE <QUEUE I-LANTERN <SET TICK <GET .TBL 0>>>>
	 <COND (<0? .TICK>
		<FCLEAR ,LAMP ,ONBIT>
		<SETG LAMP-BURNED-OUT T>)>
	 <COND (<ACCESSIBLE? ,LAMP>
		<COND (<0? .TICK>
		       <TELL
"You'd better have more light than from the " D ,LAMP ,PERIOD-CR>)
		      (T
		       <TELL <GET .TBL 1> CR>)>)>
	 <COND (<NOT <0? .TICK>>
		<SETG LAMP-TABLE <REST .TBL 4>>)>>

<GLOBAL LAMP-TABLE
	<TABLE 225 "The lamp appears a bit dimmer."
	        75 "The lamp is definitely dimmer now."
	        25 "The lamp is nearly out." 0>>

<ROOM GREAT-CAVERN
      (IN ROOMS)
      (DESC "Great Cavern")
      (LDESC
"This is a huge limestone cavern, glowing with dim, phosphorescent light from
far above. Narrow paths wind south and northeast.")
      (NE TO INSIDE-THE-BARROW)
      (SOUTH TO SHALLOW-FORD)
      (FLAGS RLANDBIT ONBIT)>

<ROOM SHALLOW-FORD
      (IN ROOMS)
      (DESC "Shallow Ford")
      (LDESC
"You are ankle deep in a stream. To the southwest is a dark tunnel, and to the
north a dim cavern.")
      (NORTH TO GREAT-CAVERN)
      (SW TO DARK-TUNNEL)
      (FLAGS RLANDBIT ONBIT)
      (GLOBAL GLOBAL-WATER STREAM)>

<ROOM DARK-TUNNEL
      (IN ROOMS)
      (DESC "Dark Tunnel")
      (LDESC
"This smooth-walled tunnel runs northeast to southwest. A faint whirring sound
comes from the latter direction. Another opening, choked with leaves, leads
southeast.")
      (NE TO SHALLOW-FORD)
      (SE TO FORMAL-GARDEN)
      (SW TO CAROUSEL-ROOM)
      (WEST TO DEEP-FORD IF SECRET-DOOR)
      (FLAGS RLANDBIT)>

<OBJECT SWORD
	(IN DARK-TUNNEL)
	(DESC "elvish sword")
	(LDESC "An Elvish sword of great antiquity is here.")
	(SYNONYM SWORD BLADE)
	(ADJECTIVE ELVISH OLD ANTIQUE)
	(FLAGS TAKEBIT WEAPONBIT TRYTAKEBIT)
	(SIZE 30)>

<GLOBAL SECRET-DOOR <>>

<ROOM DEEP-FORD
      (IN ROOMS)
      (DESC "Deep Ford")
      (LDESC
"You are waist deep in a cold stream. On the northern bank, the walls rise
to a small ledge. A \"whir\" comes from an opening to the south.")
      (NORTH TO LEDGE-IN-RAVINE)
      (UP TO LEDGE-IN-RAVINE)
      (SOUTH TO CAROUSEL-ROOM)
      (EAST TO DARK-TUNNEL IF SECRET-DOOR)
      (FLAGS RLANDBIT)
      (GLOBAL GLOBAL-WATER STREAM)>

<ROOM CAROUSEL-ROOM
      (IN ROOMS)
      (DESC "Carousel Room")
      (NORTH TO DEEP-FORD)
      (NE TO DARK-TUNNEL)
      (EAST TO TOPIARY)
      (SE TO RIDDLE-ROOM)
      (SOUTH TO MENHIR-ROOM)
      (SW TO GUARDED-ROOM)
      (WEST TO ROOM-8)
      (NW TO COOL-ROOM)
      (FLAGS RLANDBIT)
      (ACTION CAROUSEL-ROOM-F)>

<ROUTINE CAROUSEL-ROOM-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"Eight identical passages leave this large circular room. The ceiling
is lost in gloom.">
		<COND (,CAROUSEL-ON
		       <TELL
" A loud whirring sound comes from all around, and you feel disoriented.">)>
		<CRLF>)
	       (<AND ,CAROUSEL-ON
		     <EQUAL? .RARG ,M-BEG>
		     <VERB? WALK>
		     <NOT <PRSO? ,P?UP ,P?DOWN>>>
		<TELL
"You're not sure which direction is which..." CR CR>
		<COND (<OR <EQUAL? ,PRSO ,P?WEST>
			   <PROB 80>>
		       <GOTO <PICK-ONE ,CAROUSEL-EXITS>>)
		      (T
		       <RFALSE>)>)>>

<GLOBAL CAROUSEL-EXITS
	<TABLE
COOL-ROOM DARK-TUNNEL DEEP-FORD TOPIARY RIDDLE-ROOM MENHIR-ROOM GUARDED-ROOM>>

<OBJECT VIOLIN
	(IN CAROUSEL-ROOM)
	(DESC "fancy violin")
 	(LDESC "There is a Stradivarius here.")
	(SYNONYM STRADIVARIUS VIOLIN TREASURE)
	(ADJECTIVE FANCY)
	(SIZE 10)
	(VALUE 20)
	(FLAGS INVISIBLE TAKEBIT)
	(ACTION VIOLIN-F)>

<ROUTINE VIOLIN-F ()
	 <COND (<AND <VERB? PLAY>
		     <EQUAL? ,PRSO ,VIOLIN>>
	        <TELL "An offensive noise issues from the violin." CR>)>>

<ROOM ROOM-8
      (IN ROOMS)
      (DESC "Room 8")
      (LDESC
"This is a small chamber carved from the western end of a short crawl. On
the wall is crudely chiseled the number \"8\".")
      (EAST TO CAROUSEL-ROOM)
      (FLAGS RLANDBIT)>

<OBJECT BILLS
	(IN ROOM-8)
	(DESC "stack of zorkmid bills")
	(LDESC "On the floor is a neat stack of 200 zorkmid bills.")
	(SYNONYM BILLS STACK MONEY TREASURE)
	(ADJECTIVE NEAT ZORKMID)
	(VALUE 25)
	(SIZE 10)
	(FLAGS READBIT TAKEBIT BURNBIT)
	(TEXT
"Each bill is worth 100 zorkmids and bears the legend \"In Frobs We Trust\".")
	(ACTION BILLS-F)>

<ROUTINE BILLS-F ()
	<COND (<VERB? BURN>
	       <TELL "Nothing like having money to burn! ">
	       <RFALSE>)>>

<ROOM MENHIR-ROOM
      (IN ROOMS)
      (DESC "Menhir Room")
      (NORTH TO CAROUSEL-ROOM)
      (SW TO KENNEL IF MENHIR-POSITION ELSE
       "You are trying to walk through an enormous rock.")
      (SOUTH TO CERBERUS-ROOM)
      (FLAGS RLANDBIT)
      (GLOBAL MENHIR)
      (ACTION MENHIR-ROOM-F)>

<ROUTINE MENHIR-ROOM-F (RARG)
	 <COND (<AND <EQUAL? .RARG ,M-FLASH>
		     ,MENHIR-POSITION>
		<DESCRIBE-MENHIR>)
	       (<EQUAL? .RARG ,M-LOOK>
		<TELL
"Large limestone chunks lie about this former quarry, which appears to have
produced menhirs (standing stones). Obvious passages lead north and south." CR>
		<COND (<IN? ,MENHIR ,LOCAL-GLOBALS>
		       <DESCRIBE-MENHIR>)>
		<RTRUE>)>>

<GLOBAL MENHIR-POSITION <>>

<ROUTINE DESCRIBE-MENHIR ()
	 <COND (<EQUAL? ,HERE ,MENHIR-ROOM>
		<COND (<EQUAL? ,MENHIR-POSITION <>>
		       <TELL
"One large menhir blocks a dark opening leading southwest.">)
		      (<EQUAL? ,MENHIR-POSITION 1>
		       <TELL "A menhir lies near a southwest passage.">)
		      (<EQUAL? ,MENHIR-POSITION 2>
		       <TELL "A dark opening leads southwest.">)
		      (<EQUAL? ,MENHIR-POSITION 3>
		       <TELL "There is a huge menhir here.">)
		      (T
		       <TELL
"A huge menhir is floating in midair above a southwest passage.">)>
		<CRLF>)
	       (T
		<TELL "A dark opening leads southwest." CR>)>>

<OBJECT GLOBAL-MENHIR
	(IN LOCAL-GLOBALS)
	(DESC "enormous menhir")
	(SYNONYM MENHIR ROCK STONE)
	(ADJECTIVE HUGE HEAVY ENORMOUS)
	(FLAGS NDESCBIT READBIT)
	(ACTION GLOBAL-MENHIR-F)>

<ROUTINE GLOBAL-MENHIR-F ()
	 <TELL "It's not here." CR>>

<OBJECT MENHIR
	(IN LOCAL-GLOBALS)
	(DESC "enormous menhir")
	(SYNONYM MENHIR ROCK STONE F)
	(ADJECTIVE HUGE HEAVY ENORMOUS)
	(FLAGS NDESCBIT READBIT)
	(ACTION MENHIR-F)>

<ROUTINE MENHIR-F ()
	 <COND (<AND <VERB? LOOK-UNDER LOOK-BEHIND>
		     <NOT ,MENHIR-POSITION>>
		<TELL "There's a dark passage beyond the menhir." CR>)
	       (<VERB? TAKE MOVE TURN>
		<TELL "The menhir weighs many tons!" CR>)
	       (<VERB? READ>
		<TELL "\"F\"" CR>)
	       (<VERB? EXAMINE>
		<TELL "The menhir is carved with an ornate letter \"F\"." CR>)
	       (<AND <VERB? ENCHANT>
		     <EQUAL? ,SPELL-USED ,W?FLOAT>>
		<SETG MENHIR-POSITION 3>
		<TELL
"The menhir floats majestically into the air. The passage beyond
beckons invitingly." CR>)
	       (<AND <VERB? DISENCHANT>
		     <EQUAL? ,SPELL-USED ,W?FLOAT>>
		<SETG MENHIR-POSITION <>>
		<COND (<EQUAL? ,HERE ,MENHIR-ROOM ,KENNEL>
		       <TELL "The menhir sinks to the ground." CR>)>)>>

<ROOM KENNEL
      (IN ROOMS)
      (DESC "Kennel")
      (LDESC
"This was once a kennel for a large dog (some of the bones would fit a
dinosaur). The only exit is northeast.")
      (FLAGS RLANDBIT)
      (NE TO MENHIR-ROOM IF MENHIR-POSITION ELSE
       "You are trying to walk through an enormous rock.")
      (OUT TO MENHIR-ROOM IF MENHIR-POSITION ELSE
       "You are trying to walk through an enormous rock.")
      (GLOBAL MENHIR)>

<OBJECT COLLAR
	(IN KENNEL)
	(SYNONYM COLLAR)
	(ADJECTIVE HUGE GIANT DOG)
	(FDESC "A gigantic dog collar lies amidst the dust.")
	(DESC "gigantic dog collar")
	(FLAGS TAKEBIT)
	(VALUE 15)
	(ACTION COLLAR-F)>

<ROUTINE COLLAR-F ()
	 <COND (<AND <VERB? TAKE>
		     ,CERBERUS-LEASHED>
		<JIGS-UP
"Bad idea. As you unfasten the collar, the monster rends you
into little doggy biscuits.">)
	       (<AND <VERB? ENCHANT>
		     <EQUAL? ,SPELL-USED ,W?FLOAT>>
		<PERFORM ,V?ENCHANT ,CERBERUS>
		<RTRUE>)>>

<ROOM CERBERUS-ROOM
      (IN ROOMS)
      (DESC "Cerberus Room")
      (LDESC
"This is the entrance to a huge tomb. A passage leads north.")
      (SOUTH TO CRYPT IF CERBERUS-LEASHED ELSE "The huge dog snaps at you.")
      (IN TO CRYPT IF CERBERUS-LEASHED ELSE "The huge dog snaps at you.")
      (NORTH TO MENHIR-ROOM)
      (FLAGS RLANDBIT)
      (PSEUDO "TOMB" TOMB-PSEUDO "CRYPT" TOMB-PSEUDO)>

<ROUTINE TOMB-PSEUDO ()
	 <COND (<VERB? ENTER>
		<DO-WALK ,P?SOUTH>)>>

<OBJECT GLOBAL-CERBERUS
	(IN LOCAL-GLOBALS)
	(DESC "three-headed dog")
	(SYNONYM CERBERUS DOG HOUND MONSTER)
	(ADJECTIVE HUGE GIANT THREE HEADED)
	(ACTION GLOBAL-CERBERUS-F)>

<ROUTINE GLOBAL-CERBERUS-F ()
	 <TELL "He's not here." CR>>

<OBJECT CERBERUS
	(IN CERBERUS-ROOM)
	(DESC "three-headed dog")
	(LDESC
"A vicious-looking dog guards the entrance to the south. It's your
usual dog, except that it has three heads and is the size of an elephant.")
	(SYNONYM CERBERUS DOG HOUND MONSTER)
	(ADJECTIVE HUGE GIANT THREE HEADED)
	(FLAGS ACTORBIT OPENBIT CONTBIT)
	(ACTION CERBERUS-F)>

<GLOBAL CERBERUS-LEASHED <>>

<ROUTINE CERBERUS-F ()
	 <COND (<AND <VERB? WAVE RUB RAISE>
		     <EQUAL? ,PRSO ,WAND>>
		<TELL "The dog looks puzzled." CR>
		<RFALSE>)
	       (<AND ,WAND-ON
		     <VERB? SAY INCANT>>
		<RFALSE>)
	       (<HELLO? ,CERBERUS>
		<COND (,CERBERUS-LEASHED
		       <TELL "\"Arf! Arf!\"" CR>)
		      (T
		       <TELL "\"Grrrr!\"" CR>)>)
	       (<VERB? ATTACK MUNG>
		<COND (,CERBERUS-LEASHED
		       <REMOVE ,CERBERUS>
		       <TELL
"With a quiet bark of disappointment, the creature expires into a small pile
of dust which blows away into nothing." CR>)
		      (T
		       <TELL
"The maddened dog-thing snaps at you viciously." CR>)>)
	       (<AND <VERB? PUT PUT-ON>
		     <EQUAL? ,PRSO ,COLLAR>>
		<SETG CERBERUS-LEASHED T>
		<MOVE ,COLLAR ,CERBERUS>
		<FSET ,COLLAR ,NDESCBIT>
		<FSET ,COLLAR ,TRYTAKEBIT>
		<PUTP ,CERBERUS ,P?LDESC
"A grinning, three-headed dog, wearing a huge collar, wags its tail here.">
		<TELL
"All three heads begin licking your face, and its huge tail wags
enthusiastically, almost blowing you over from the breeze it creates." CR>)
	       (<VERB? ENCHANT>
		<COND (<EQUAL? ,SPELL-USED ,W?FLOAT>
		       <SETG SPELL-HANDLED? T>
		       <TELL
"The huge dog rises an inch off the ground, for a moment." CR>)
		      (<EQUAL? ,SPELL-USED ,W?FEEBLE>
		       <TELL
"What an effect! He now has the strength of just one elephant, rather
than ten!" CR>)>)
	       (<NOT ,CERBERUS-LEASHED>
		<TELL "The three-headed dog snaps at you viciously!" CR>)
	       (<AND ,CERBERUS-LEASHED
		     <VERB? RUB>>
		<TELL
"The dog slobbers and whines with uncontained joy." CR>)>>

<ROOM CRYPT
      (IN ROOMS)
      (DESC "Crypt")
      (LDESC
"Before you are the earthly remains of the mighty Flatheads, twelve somewhat
flat heads mounted securely on poles. There is writing carved on the crypt.
To the north and south are dark doorways.")
      (NORTH TO CERBERUS-ROOM)
      (SOUTH TO ZORK3)
      (VALUE 2)
      (FLAGS RLANDBIT)>

<OBJECT HEADS
	(IN CRYPT)
        (DESC "set of poled heads")
	(SYNONYM HEADS HEAD POLE POLES)
	(FLAGS NDESCBIT TRYTAKEBIT)
	(ACTION HEADS-F)>

<ROUTINE HEADS-F ()
	 <COND (<VERB? HELLO TELL>
		<TELL "Dead Flatheads tell no tales." CR>)
	       (<VERB? KICK ATTACK RUB OPEN TAKE BURN>
		<JIGS-UP
"The Flatheads foresaw that someone might tamper with their remains,
and took steps to punish such actions.">)>>

<OBJECT CRYPT-OBJECT
	(IN CRYPT)
	(DESC "marble crypt")
	(SYNONYM TOMB CRYPT GRAVE)
	(ADJECTIVE MARBLE)
	(FLAGS NDESCBIT READBIT)
	(TEXT
"\"Here lie the Flatheads, whose heads were placed on poles by the
Dungeon Master for amazing untastefulness.\"")
	(ACTION CRYPT-OBJECT-F)>

<ROUTINE CRYPT-OBJECT-F ()
	 <COND (<VERB? OPEN>
		<TELL "The crypt is sealed for all time." CR>)>>

<ROOM ZORK3
      (IN ROOMS)
      (DESC "Landing")
      (FLAGS RLANDBIT ONBIT)
      (ACTION ZORK3-F)>

<ROUTINE ZORK3-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL "A rough-hewn stair leads down into darkness. ">
		<COND (<IN? ,WAND ,WINNER>
		       <TELL
"The wand vibrates and are compelled downward. There is a burst of light,
and you tumble down the staircase! At the bottom, a vast red-lit hall,
guarded by sinister statues, is visible far ahead.|
|
You have conquered the Wizard of Frobozz and become master of his domain,
but the final challenge awaits! (The Zork Trilogy concludes with \"Zork III:
The Dungeon Master\".)" CR CR>
		       <FINISH>)
		      (T
		       <JIGS-UP
"Strands of light vibrate toward you, as if searching for something.
One by one your possessions glow bright green. Finally, you are attacked
by these magical wardens, and destroyed!">)>)>>
\
;"blue palantir puzzle (the old mat-under-the-door trick)"

<GLOBAL MUD-FLAG <>>

<GLOBAL MATOBJ <>>

<GLOBAL PUNLOCK-FLAG <>>

<GLOBAL PLOOK-FLAG <>>

<ROOM LEDGE-IN-RAVINE
      (IN ROOMS)
      (DESC "Ledge in Ravine")
      (SOUTH TO DEEP-FORD)
      (DOWN TO DEEP-FORD)
      (WEST TO DRAGON-ROOM)
      (NORTH TO DREARY-ROOM IF PDOOR IS OPEN)
      (IN TO DREARY-ROOM IF PDOOR IS OPEN)
      (FLAGS RLANDBIT)
      (GLOBAL CHASM PDOOR STREAM PWINDOW)
      (ACTION LEDGE-IN-RAVINE-F)>

<ROUTINE LEDGE-IN-RAVINE-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"To the south, a stream runs through a narrow ravine. It looks as if you
could scramble down to the stream. A smokey odor drifts in from the west. ">
		<P-DOOR "north">)
	       (<NOT <VERB? LOOK>>
		<PCHECK>
		<RFALSE>)>>

<ROUTINE P-DOOR (STR)
	<COND (,PLOOK-FLAG
	       <SETG PLOOK-FLAG <>>
	       <RFALSE>)>
	<TELL
"On the " .STR " side of the room is an oak door with a small barred window
and a formidable lock (with keyhole).">
	<COND (,MUD-FLAG
	       <TELL " " ,PLACE-MAT-VISIBLE>
	       <COND (,MATOBJ
		      <TELL " Lying on the place mat is a " D ,MATOBJ ".">)>)>
	<CRLF>>

<ROUTINE PCHECK ()
	<SETG PLOOK-FLAG <>>
	<COND (<IN? ,KEY ,KEYHOLE-2>
	       <FSET ,KEY ,NDESCBIT>)
	      (T
	       <FCLEAR ,KEY ,NDESCBIT>)>
	<COND (<HELD? ,PLACE-MAT>
	       <SETG MUD-FLAG <>>)> ;"HUH?"
	<COND (,MUD-FLAG
	       <MOVE ,PLACE-MAT ,HERE>
	       <FSET ,PLACE-MAT ,NDESCBIT>)
	      (T
	       <FCLEAR ,PLACE-MAT ,NDESCBIT>)>>

<ROOM DREARY-ROOM
      (IN ROOMS)
      (DESC "Dreary Room")
      (SOUTH TO LEDGE-IN-RAVINE IF PDOOR IS OPEN)
      (OUT TO LEDGE-IN-RAVINE IF PDOOR IS OPEN)
      (FLAGS RLANDBIT ONBIT)
      (GLOBAL PDOOR PWINDOW)
      (ACTION DREARY-ROOM-F)>

<ROUTINE DREARY-ROOM-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"The room is eerily lit by a red glow emanating from a crack in one wall.
The light falls upon a dusty wooden table. ">
		<P-DOOR "south">)
	       (T
		<PCHECK>
		<RFALSE>)>>

<OBJECT PDOOR
	(IN LOCAL-GLOBALS)
	(DESC "door of oak")
	(SYNONYM DOOR)
	(ADJECTIVE WOODEN OAK)
	(FLAGS DOORBIT CONTBIT)
	(ACTION PDOOR-F)>

<ROUTINE PDOOR-F ("AUX" K)
	 <COND (<AND <VERB? LOOK-UNDER>
		     ,MUD-FLAG>
		<TELL ,PLACE-MAT-VISIBLE CR>)
	       (<VERB? UNLOCK>
		<COND (<EQUAL? ,PRSI ,KEY>
		       <SETG PUNLOCK-FLAG T>
		       <TELL "The door is now unlocked." CR>)
		      (<EQUAL? ,PRSI ,GOLD-KEY>
		       <TELL ,DOESNT-FIT-LOCK>)
		      (T
		       <TELL <PICK-ONE ,YUKS> CR>)>)
	       (<VERB? LOCK>
		<COND (<EQUAL? ,PRSI ,KEY>
		       <SETG PUNLOCK-FLAG <>>
		       <TELL "The door is locked." CR>)
		      (<EQUAL? ,PRSI ,GOLD-KEY>
		       <TELL ,DOESNT-FIT-LOCK>)
		      (T
		       <TELL <PICK-ONE ,YUKS> CR>)>)
	       (<VERB? PUT-UNDER>
		<COND (<EQUAL? ,PRSO ,ROBOT-LABEL>
		       <TELL "The tiny paper vanishes under the door." CR>
		       <MOVE ,PRSO <COND (<EQUAL? ,HERE ,LEDGE-IN-RAVINE>
					  ,DREARY-ROOM)
					 (T
					  ,LEDGE-IN-RAVINE)>>)
		      (<EQUAL? ,PRSO ,NEWSPAPER>
		       <TELL
"The newspaper crumples up and won't go under the door." CR>)>)
	       (<VERB? OPEN CLOSE>
		<COND (,PUNLOCK-FLAG
		       <OPEN-CLOSE>)
		      (T
		       <TELL "The door is locked." CR>)>)>>

<OBJECT PWINDOW
	(IN LOCAL-GLOBALS)
	(DESC "barred window")
	(SYNONYM WINDOW)
	(ADJECTIVE BARRED)
	(FLAGS DOORBIT)
	(ACTION PWINDOW-F)>

<ROUTINE PWINDOW-F ()
	 <COND (<VERB? LOOK-INSIDE>
		<SETG PLOOK-FLAG T>
		<COND (<FSET? ,PDOOR ,OPENBIT>
		       <TELL "The door is open!" CR>)
		      (T
		       <GO&LOOK <COND (<EQUAL? ,HERE ,DREARY-ROOM>
				       ,LEDGE-IN-RAVINE)
				      (T
				       ,DREARY-ROOM)>>)>)
	       (<VERB? ENTER>
		<TELL "Perhaps if you were diced...." CR>)>>

<OBJECT PTABLE
	(IN DREARY-ROOM)
	(DESC "table")
	(SYNONYM TABLE)
	(ADJECTIVE DUSTY WOODEN)
	(CAPACITY 40)
	(FLAGS NDESCBIT CONTBIT SURFACEBIT OPENBIT)>

<OBJECT PCRACK
	(IN DREARY-ROOM)
	(DESC "crack")
	(SYNONYM CRACK)
	(ADJECTIVE NARROW)
	(FLAGS NDESCBIT)>

<OBJECT KEYHOLE-1
	(IN LEDGE-IN-RAVINE)
	(DESC "keyhole")
	(SYNONYM KEYHOLE HOLE)
	(FLAGS NDESCBIT)
	(ACTION PKEYHOLE-F)>

<OBJECT KEYHOLE-2
	(IN DREARY-ROOM)
	(DESC "keyhole")
	(SYNONYM KEYHOLE HOLE)
	(FLAGS NDESCBIT)
	(ACTION PKEYHOLE-F)>

<ROUTINE PKEYHOLE-F ()
	 <COND (<VERB? LOOK-INSIDE>
		<TELL "You can">
		<COND (<OR  <IN? ,KEY ,KEYHOLE-2>
			    <NOT <LIT? <COND (<EQUAL? ,HERE ,DREARY-ROOM>
					      ,LEDGE-IN-RAVINE)
					     (T
					      ,DREARY-ROOM)>>>>
		       <TELL "'t">)>
		<TELL " see light through the keyhole." CR>)
	       (<VERB? PUT>
		<COND (<IN? ,KEY ,KEYHOLE-2>
		       <COND (<EQUAL? ,PRSO ,LETTER-OPENER>
			      <COND (,MUD-FLAG
				     <SETG MATOBJ ,KEY>)>
			      <MOVE ,KEY ,DREARY-ROOM>
			      <TELL
"There is a faint thud behind the door." CR>)
			     (T
			      <TELL "The " D ,PRSO " doesn't fit." CR>)>)
		      (T
		       <PERFORM ,V?UNLOCK ,PDOOR ,PRSO>
		       <RTRUE>)>)>>

<OBJECT KEY
	(IN KEYHOLE-2)
	(DESC "rusty iron key")
	(SYNONYM KEY)
	(ADJECTIVE IRON RUSTY)
	(SIZE 2)
	(FLAGS TAKEBIT NDESCBIT TOOLBIT)>