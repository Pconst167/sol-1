"PRINCESS for
	        Mini-Zork II: The Wizard of Frobozz
	(c) Copyright 1988 Infocom, Inc.  All Rights Reserved."

<ROOM FORMAL-GARDEN
      (IN ROOMS)
      (DESC "Formal Garden")
      (LDESC
"A path of crushed white stone winds among bushes and flower beds of this
garden from south to north. Almost hidden by the shrubbery is a small white
gazebo.")
      (IN TO GAZEBO)
      (NORTH TO DARK-TUNNEL)
      (SOUTH TO TOPIARY)
      (FLAGS RLANDBIT)
      (GLOBAL GAZEBO-OBJECT)
      (ACTION FORMAL-GARDEN-F)>

<ROUTINE FORMAL-GARDEN-F (RARG)
	 <COND (<EQUAL? .RARG ,M-ENTER>
		<ENABLE <QUEUE I-GARDEN -1>>)>>

<ROUTINE I-GARDEN ()
	 <COND (<EQUAL? ,HERE ,FORMAL-GARDEN>
		<COND (<AND <IN? ,UNICORN ,FORMAL-GARDEN>
			    <PROB 33>>
		       <REMOVE ,UNICORN>
		       <TELL "The unicorn bounds lightly away." CR>)
		      (<AND <IN? ,PRINCESS ,DRAGON-LAIR>
			    <NOT <IN? ,UNICORN ,FORMAL-GARDEN>>
			    <PROB 25>>
		       <COND (,UNICORN-FRIGHTENED
			      <SETG UNICORN-FRIGHTENED <>>
			      <RFALSE>)>
		       <MOVE ,UNICORN ,FORMAL-GARDEN>
		       <TELL
"A beautiful unicorn is peacefully cropping grass across the garden. A gold
key hangs from a red satin ribbon around its neck.">)>)
	       (T
		<REMOVE ,UNICORN>
		<DISABLE <INT I-GARDEN>>
		<RFALSE>)>>

<OBJECT UNICORN
	(DESC "unicorn")
	(LDESC "A beautiful unicorn is munching grass here.")
	(SYNONYM UNICORN ANIMAL)
	(ADJECTIVE BEAUTIFUL WHITE)
	(FLAGS ACTORBIT TRYTAKEBIT OPENBIT CONTBIT)
	(ACTION UNICORN-F)>

<GLOBAL UNICORN-FRIGHTENED <>>

<ROUTINE UNICORN-F ()
	 <COND (<HELLO? ,UNICORN>
		<TELL "The unicorn continues cropping grass." CR>)
	       (<VERB? FOLLOW>
		<TELL "The unicorn shies away as you near." CR>)
	       (<VERB? TAKE PUT RUB MUNG ATTACK>
		<REMOVE ,UNICORN>
		<SETG UNICORN-FRIGHTENED T>
		<TELL
"The unicorn, unsurprised to discover that you are indeed the uncouth sort
it suspected you were, melts into the hedges and is gone." CR>)>>

<OBJECT GOLD-KEY
	(IN UNICORN)
	(DESC "delicate gold key")
	(SYNONYM KEY TREASURE)
	(ADJECTIVE DELICATE GOLD)
	(VALUE 15)
	(SIZE 3)
	(FLAGS NDESCBIT TAKEBIT TRYTAKEBIT TOOLBIT)
	(ACTION UNICORN-F)>

<OBJECT RIBBON
	(IN UNICORN)
	(DESC "ribbon")
	(SYNONYM RIBBON)
	(ADJECTIVE VELVET SATIN)
	(FLAGS NDESCBIT)
	(ACTION UNICORN-F)>

<ROOM GAZEBO
      (IN ROOMS)
      (DESC "Gazebo")
      (LDESC
"This is a gazebo in the midst of a formal garden. It is cool and restful
here. A tea table adorns the center of the gazebo.")
      (OUT TO FORMAL-GARDEN)
      (FLAGS RLANDBIT ONBIT)
      (GLOBAL GAZEBO-OBJECT)>

<OBJECT GAZEBO-OBJECT
	(IN LOCAL-GLOBALS)
	(DESC "gazebo")
	(SYNONYM GAZEBO)
	(ADJECTIVE WOODEN)
	(FLAGS NDESCBIT)
	(ACTION GAZEBO-OBJECT-F)>

<ROUTINE GAZEBO-OBJECT-F ()
	 <COND (<VERB? ENTER>
		<COND (<EQUAL? ,HERE ,FORMAL-GARDEN>
		       <DO-WALK ,P?IN>)
		      (T
		       <TELL ,LOOK-AROUND>)>)
	       (<AND <EQUAL? ,HERE ,GAZEBO>
		     <VERB? LEAVE EXIT>>
		<DO-WALK ,P?OUT>)>>

<OBJECT GAZEBO-TABLE
	(IN GAZEBO)
	(DESC "table")
	(SYNONYM TABLE)
	(CAPACITY 100)
	(FLAGS NDESCBIT SURFACEBIT CONTBIT OPENBIT)>

<OBJECT NEWSPAPER
	(IN GAZEBO-TABLE)
	(DESC "newspaper")
	(SYNONYM PAPER NEWSPAPER)
	(ADJECTIVE NEWS NEWSPAPER)
	(FLAGS TAKEBIT BURNBIT READBIT)
	(ACTION NEWSPAPER-F)>

<ROUTINE NEWSPAPER-F ()
	 <COND (<VERB? READ>
		<TELL
"Famed Adventurer to Explore" ,GUE-NAME "! A world-famous and battle-hardened
adventurer has been seen in the vicinity of" ,GUE-NAME ". Local grues have
been reported sharpening their (slavering) fangs..." CR>)>>

<OBJECT PLACE-MAT
	(IN GAZEBO-TABLE)
	(DESC "place mat")
	(SYNONYM MAT PLACEM)
	(ADJECTIVE PLACE)
	(SIZE 12)
	(CAPACITY 20)
	(FLAGS TAKEBIT SURFACEBIT CONTBIT OPENBIT)
	(ACTION PLACE-MAT-F)>

<ROUTINE PLACE-MAT-F ()
	 <COND (<VERB? PUT-UNDER>
		<COND (<EQUAL? ,PRSI ,PDOOR>
		       <MOVE ,PRSO ,HERE>
		       <SETG MUD-FLAG T>
		       <TELL "The mat slies under the door." CR>)
		      (<EQUAL? ,PRSI ,WIZ-DOOR ,RIDDLE-DOOR>
		       <TELL "There's not enough room." CR>)>)
	       (<AND <VERB? TAKE MOVE> ,MATOBJ>
		<MOVE ,MATOBJ ,HERE>
		<SETG MATOBJ <>>
		<SETG MUD-FLAG <>>
		<TELL
"As the place mat is moved, a " D ,MATOBJ " falls from it to the floor." CR>)>>

<OBJECT TEAPOT
	(IN GAZEBO-TABLE)
	(DESC "china teapot")
	(SYNONYM TEAPOT POT)
	(ADJECTIVE CHINA TEA)
	(CAPACITY 4)
	(FLAGS TAKEBIT TRANSBIT CONTBIT OPENBIT)
	(ACTION TEAPOT-F)>

<ROUTINE TEAPOT-F ()
	 <COND (<VERB? OPEN CLOSE>
		<TELL "The teapot has no lid." CR>)>>

<OBJECT LETTER-OPENER
	(IN GAZEBO-TABLE)
	(DESC "letter opener")
	(SYNONYM OPENER)
	(ADJECTIVE LETTER)
	(SIZE 2)
	(FLAGS TAKEBIT TOOLBIT)>

<OBJECT MATCH
	(IN GAZEBO-TABLE)
	(DESC "matchbook")
	(LDESC "There is a matchbook saying \"Visit ZORK I\" here.")
	(SYNONYM MATCH MATCHES MATCHBOOK)
	(SIZE 2)
	(FLAGS READBIT TAKEBIT)
	(TEXT
"\"Visit Exotic ZORK I! Consult the Frobozz Magic Travel Agency, or visit
your local computer store for details.\"")
	(ACTION MATCH-F)>

<GLOBAL MATCH-COUNT 6>

<ROUTINE MATCH-F ("AUX" CNT)
	 <COND (<AND <VERB? LAMP-ON BURN>
		     <EQUAL? ,PRSO ,MATCH>>
		<COND (<G? ,MATCH-COUNT 0>
		       <SETG MATCH-COUNT <- ,MATCH-COUNT 1>>)>
		<COND (<NOT <G? ,MATCH-COUNT 0>>
		       <TELL "You've run out of matches." CR>)
		      (T
		       <FSET ,MATCH ,FLAMEBIT>
		       <FSET ,MATCH ,ONBIT>
		       <ENABLE <QUEUE I-MATCH 2>>
		       <TELL "A match starts to burn." CR>)>)
	       (<AND <VERB? LAMP-OFF>
		     <FSET? ,MATCH ,FLAMEBIT>>
		<FCLEAR ,MATCH ,FLAMEBIT>
		<FCLEAR ,MATCH ,ONBIT>
		<QUEUE I-MATCH 0>
		<TELL "The match is out." CR>)
	       (<VERB? COUNT>
		<TELL "You have ">
		<SET CNT <- ,MATCH-COUNT 1>>
		<TELL N .CNT " match">
		<COND (<NOT <1? .CNT>>
		       <TELL "es">)>
		<TELL ,PERIOD-CR>)
	       (<VERB? EXAMINE>
		<COND (<FSET? ,MATCH ,ONBIT>
		       <TELL "A">)
		      (T
		       <TELL "No">)>
		<TELL " match is burning." CR>)>>

<ROUTINE I-MATCH ()
	 <FCLEAR ,MATCH ,FLAMEBIT>
	 <FCLEAR ,MATCH ,ONBIT>
	 <TELL "The match has gone out." CR>>

<ROOM TOPIARY
      (IN ROOMS)
      (DESC "Topiary")
      (LDESC
"This is the southern end of a garden, where fantastically shaped hedges are
arrayed with geometric precision. Though recently untended, the bushes have
clearly been shaped: There is a dragon, a unicorn, a great serpent, a huge
misshapen dog, and several human figures. To the west is a tunnel.")
      (WEST TO CAROUSEL-ROOM)
      (NORTH TO FORMAL-GARDEN)
      (FLAGS RLANDBIT)
      (ACTION TOPIARY-F)>

<ROUTINE TOPIARY-F (RARG)
	 <COND (<EQUAL? .RARG ,M-ENTER>
		<ENABLE <QUEUE I-TOPIARY -1>>)>>

<GLOBAL TOPIARY-COUNTER 0>

<ROUTINE I-TOPIARY ()
	 <COND (<EQUAL? ,HERE ,TOPIARY>
		<COND (<AND <EQUAL? ,TOPIARY-COUNTER 0>
			    <PROB 12>>
		       <SETG TOPIARY-COUNTER 1>
		       <TELL
"Strangely, the topiary animals seem to have shifted position a bit." CR>)
		      (<AND <EQUAL? ,TOPIARY-COUNTER 0>
			    <PROB 8>>
		       <SETG TOPIARY-COUNTER 2>
		       <TELL
"You turn, and the topiary animals seem to have closed in on you." CR>)
		      (<AND <EQUAL? ,TOPIARY-COUNTER 0>
			    <PROB 4>>
		       <SETG TOPIARY-COUNTER 0>
		       <JIGS-UP
"The topiary animals attack! You are crushed by their branches and clawed
by their thorns.">)>)
	       (T
		<DISABLE <INT I-TOPIARY>>
		<RFALSE>)>>

<OBJECT HEDGES
	(IN TOPIARY)
	(DESC "hedge")
	(SYNONYM HEDGE HEDGES)
	(FLAGS NDESCBIT)
	(ACTION HEDGES-F)>

<ROUTINE HEDGES-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"The hedges are shaped like various animals: dogs, serpents, dragons..." CR>)>>

<ROOM DRAGON-ROOM
      (IN ROOMS)
      (DESC "Dragon Room")
      (LDESC
"The walls of this large cavern are scorched and a sooty dry smell is very
strong here. A stone bridge leads the south, and a smokey tunnel opens to
the north. To the east is a small opening.")
      (EAST TO LEDGE-IN-RAVINE)
      (NORTH TO DRAGON-LAIR IF ICE-MELTED ELSE
       "The dragon hisses and blocks your way.")
      (IN TO DRAGON-LAIR IF ICE-MELTED ELSE
       "The dragon hisses and blocks your way.")
      (SOUTH TO STONE-BRIDGE)
      (FLAGS RLANDBIT)
      (GLOBAL BRIDGE)>

<OBJECT DRAGON
	(IN DRAGON-ROOM)
	(DESC "huge red dragon")
	(SYNONYM DRAGON)
	(ADJECTIVE RED HUGE)
	(LDESC "A huge red dragon is lying on the rocks, watching.")
	(FDESC
"A huge red dragon is blocking the north exit. Smoke curls from his nostrils.")
	(FLAGS ACTORBIT)
	(ACTION DRAGON-F)>

<ROUTINE DRAGON-F ()
	 <ENABLE <QUEUE I-DRAGON -1>>
	 <COND (<HELLO? ,DRAGON>
		<SETG DRAGON-ANGER <+ ,DRAGON-ANGER 2>>
		<TELL "The dragon looks amused." CR>)
	       (<VERB? EXAMINE>
		<SETG DRAGON-ANGER <+ ,DRAGON-ANGER 1>>
		<TELL
"He looks back at you, his cat's eyes yellow in the gloom. You start to
feel weak, and quickly turn away." CR>)
	       (<VERB? ATTACK MUNG KICK LAMP-ON>
		<SETG DRAGON-ANGER <+ ,DRAGON-ANGER 4>>
		<COND (<OR <VERB? LAMP-ON>
			   <AND <VERB? ATTACK>
				<NOT ,PRSI>>>
		       <TELL
"With your bare hands? I doubt the dragon even noticed." CR>)
		      (T
		       <TELL <RANDOM-ELEMENT ,DRAGON-ATTACKS> CR>)>)
	       (<AND <VERB? GIVE>
		     <EQUAL? ,PRSI ,DRAGON>>
		<SETG DRAGON-ANGER <+ ,DRAGON-ANGER 1>>
		<COND (<FSET? ,PRSO ,TREASUREBIT>
		       <MOVE ,PRSO ,CHEST>
		       <TELL
"The dragon excuses himself for a moment and
returns without the " D ,PRSO ,PERIOD-CR>)
		      (<BOMB? ,PRSO>
		       <SETG DRAGON-ANGER <+ ,DRAGON-ANGER 2>>
		       <REMOVE ,BRICK>
		       <TELL
"The politely swallows the bomb. A moment later, he belches and smoke curls
from his nostrils." CR>)
		      (T
		       <TELL "The dragon refuses it." CR>)>)
	       (<AND <VERB? WALK>
		     <EQUAL? ,HERE ,DRAGON-ROOM>
		     <EQUAL? ,PRSO ,P?NORTH>>
		<SETG DRAGON-ANGER <+ ,DRAGON-ANGER 3>>
		<TELL
"The dragon puts out a claw and blocks your way." CR>)>>

<GLOBAL DRAGON-ATTACKS
        <LTABLE
"Dragon hide is tough as steel, but you have annoyed him a bit. He looks
as if deciding whether or not to eat you."
"That captured his interest. He stares at you balefully."
"The dragon is surprised and interested (for the moment)."
"That did no damage, but he turns his smoky yellow eyes in your direction.">>

<GLOBAL DRAGON-ANGER 0>

<GLOBAL ICE-MELTED <>>

<GLOBAL OLD-HERE DRAGON-ROOM>

<ROUTINE DRAGON-LEAVES ()
	 <MOVE ,DRAGON ,DRAGON-ROOM>
	 <SETG DRAGON-ANGER 0>
	 <DISABLE <INT I-DRAGON>>>

<ROUTINE I-DRAGON ("AUX" ROOM)
	 <COND (<G? ,DRAGON-ANGER 6>
		<TELL
"With an almost bored yawn, the dragon opens his mouth and blasts you with
a gout of white-hot flame">
		<COND (<EQUAL? ,SPELL? ,S-FIREPROOF>
		       <TELL ", but it washes over you harmlessly." CR>)
		      (T
		       <DRAGON-LEAVES>
		       <JIGS-UP ".">)>)
	       (<AND <EQUAL? ,HERE ,DRAGON-ROOM>
		     <NOT <IN? ,DRAGON ,DRAGON-ROOM>>>
		<MOVE ,DRAGON ,DRAGON-ROOM>
		<TELL
"The dragon charges in, maddened by your attempt to sneak past him. His eyes
glow with anger. He opens his mouth, and a huge ball of flame engulfs you">
		<COND (<EQUAL? ,SPELL? ,S-FIREPROOF>
		       <JIGS-UP
", but you barely feel the heat. The dragon is puzzled, but not too
puzzled to crush you in his jaws.">)
		      (T
		       <JIGS-UP ".">)>)
	       (<NOT <G? ,DRAGON-ANGER 0>>
		<COND (<AND <PROB 50>
			    <IN? ,DRAGON ,HERE>>
		       <TELL "The dragon looks bored." CR>)
		      (T
		       <DRAGON-LEAVES>
		       <COND (<EQUAL? ,HERE ,OLD-HERE>
			      <TELL
"The dragon seems to have lost interest in you.">
			      <COND (<EQUAL? ,OLD-HERE ,DRAGON-ROOM>
				     <CRLF>)
				    (T
				     <TELL " He wanders off." CR>)>)>)>)
	       (T
		<SET ROOM <FIND-TARGET ,WINNER>>
		<COND (<NOT .ROOM>
		       <COND (<PROB 25>
			      <DRAGON-LEAVES>)>)
		      (<EQUAL? .ROOM ,CAROUSEL-ROOM
			       	     ,DREARY-ROOM ,LEDGE-IN-RAVINE>
		       <COND (<PROB 25>
			      <DRAGON-LEAVES>)>
		       <TELL "The dragon follows no further." CR>)
		      (<EQUAL? .ROOM ,ICE-ROOM>
		       <REMOVE ,DRAGON>
		       <REMOVE ,ICE>
		       <DISABLE <INT I-DRAGON>>
		       <SETG SCORE <+ ,SCORE 5>>
		       <SETG ICE-MELTED T>
		       <TELL CR
"The dragon enters and spies his reflection on the icy surface of the
glacier. Thinking that another dragon has invaded his territory, he rears
up to his full height and roars a challenge! The intruder responds! The
dragon takes a deep breath and expels a massive gout of flame. It washes
over the ice, which melts rapidly, sending out huge cloud of steam! When
the steam dissipates, the glacier is gone, and so is the dragon.
|
With the ice gone, you notice a passage leading west." CR>)
		      (T
		       <COND (<NOT <EQUAL? .ROOM ,OLD-HERE>>
			      <MOVE ,DRAGON .ROOM>
			      <TELL
"The dragon follows you, out of mingled curiosity and anger." CR>)
			     (T
			      <TELL
"The dragon continues to watch you carefully." CR>)>
		       <COND (<NOT <G? ,DRAGON-ANGER 0>>
			      <SETG DRAGON-ANGER 0>
			      <DISABLE <INT I-DRAGON>>)>)>)>
	 <SETG OLD-HERE <LOC ,DRAGON>>
	 <SETG DRAGON-ANGER <- ,DRAGON-ANGER 2>>
	 <COND (<L? ,DRAGON-ANGER 0>
		<SETG DRAGON-ANGER 0>)>
	 <RTRUE>>

<ROOM DRAGON-LAIR
      (IN ROOMS)
      (DESC "Dragon's Lair")
      (LDESC
"The rock walls are scarred by flame, and a blackened doorway leads south.")
      (SOUTH TO DRAGON-ROOM)
      (OUT TO DRAGON-ROOM)
      (FLAGS RLANDBIT)>

<OBJECT CHEST
	(IN DRAGON-LAIR)
	(DESC "wooden chest")
	(FDESC "An old wooden chest sits in the corner.")
	(SYNONYM CHEST TRUNK)
	(ADJECTIVE WOODEN OLD)
	(FLAGS CONTBIT TAKEBIT)
	(CAPACITY 40)
	(SIZE 40)
	(ACTION CHEST-F)>

<ROUTINE CHEST-F ()
	 <COND (<VERB? OPEN>
		<COND (<AND <IN? ,PRINCESS ,HERE>
			    <NOT ,PRINCESS-AWAKE>
			    <PROB 25>>
		       <V-OPEN>
		       <TELL "The squeaky lid startles the young woman." CR>)
		      (T
		       <TELL
"The rusty hinges almost give. It would probably open if you tried again.">
		       <COND (<AND <IN? ,PRINCESS ,HERE>
				   <NOT ,PRINCESS-AWAKE>>
			      <TELL
" The commotion has startled the young woman.">)>
		       <CRLF>)>
		<PUTP ,CHEST ,P?ACTION 0>
		<COND (<AND <IN? ,PRINCESS ,HERE>
			    <NOT ,PRINCESS-AWAKE>>
		       <PERFORM ,V?ALARM ,PRINCESS>)>
		<RTRUE>)>>

<OBJECT STATUETTE
	(IN CHEST)
	(DESC "golden dragon statuette")
	(FDESC "Nestled in the chest is a gold statuette of a dragon.")
	(SYNONYM TREASURE STATUE DRAGON)
	(ADJECTIVE GOLD)
	(FLAGS TREASUREBIT TAKEBIT)
	(VALUE 20)>

<OBJECT PRINCESS
	(IN DRAGON-LAIR)
	(DESC "beautiful princess")
	(FDESC
"A beautiful princess sits on a rock in the corner. Her hair is unkempt
and she appears to be in a trance.")
	(SYNONYM PRINCESS WOMAN LADY)
	(ADJECTIVE BEAUTIFUL YOUNG)
	(FLAGS ACTORBIT)
	(ACTION PRINCESS-F)>

<GLOBAL PRINCESS-AWAKE <>>

<ROUTINE PRINCESS-F ("AUX" (DEM <INT I-PRINCESS>))
	 <COND (<VERB? FOLLOW>
		<COND (,PRFOLLOW
		       <DO-WALK ,PRFOLLOW>)
		      (T
		       <TELL "You've lost track of her." CR>)>)
	       (<VERB? ATTACK MUNG RAPE>
		<REMOVE ,PRINCESS>
		<TELL
"The princess screams, \"Won't someone deliver me from this awful fate?\"
The Wizard of Frobozz ">
		<COND (<IN? ,WIZARD ,HERE>
		       <TELL "turns toward you">)
		      (ELSE
		       <TELL "appears">)>
		<JIGS-UP
". \"Fry!\" he intones, and a bolt of lightning reduces you to a pile of ash.
(Serves you right, too, if you ask me.)">)
	       (<OR <HELLO? ,PRINCESS>
		    <VERB? ALARM KISS EXAMINE RUB>>
		<COND (<AND <IN? ,PRINCESS ,DRAGON-LAIR>
			    <EQUAL? <GET .DEM ,C-ENABLED?> 0>>
		       <ENABLE <QUEUE I-PRINCESS 2>>
		       <SETG PRINCESS-AWAKE T>
		       <TELL
"The princess shakes herself awake, notices you, and smiles. \"Thank you for
rescuing me from that horrid worm, but I must depart.\" She rises, looking
purposefully out of the lair." CR>)
		      (T
		       <TELL
"The princess ignores you; her eyes fix on the ">
		       <COND (<EQUAL? ,HERE ,GAZEBO>
			      <TELL "garden">)
			     (<EQUAL? ,HERE ,FORMAL-GARDEN>
			      <TELL "gazebo">)
			     (<EQUAL? ,HERE ,LEDGE-IN-RAVINE>
			      <TELL "ledge">)
			     (T
			      <TELL <GET ,PRDIRS <* ,PRCOUNT 4>>>)>
		       <TELL ,PERIOD-CR>)>)
	       (<NOT ,PRINCESS-AWAKE>
		<TELL "She's in a trance!" CR>)>>

<ROUTINE I-PRINCESS ("AUX" (DEM <INT I-PRINCESS>) (OLDP <LOC ,PRINCESS>)
		     (PC <* ,PRCOUNT 4>))
	 <MOVE ,PRINCESS <GET ,PRDIRS <+ .PC 1>>>
	 <SETG PRFOLLOW <>>
	 <COND (<AND <IN? ,PRINCESS ,DARK-TUNNEL>
		     <IN? ,ADVENTURER ,DEEP-FORD>>
		<TELL
"The princess touches the ravine wall and a section slides away, revealing
a passage to the east. She enters it." CR>
		<COND (<IN? ,WINNER .OLDP>
		       <SETG PRFOLLOW <GET ,PRDIRS <+ .PC 3>>>)>
		<SETG SECRET-DOOR T>)
	       (<AND <IN? ,PRINCESS ,DARK-TUNNEL>
		     <IN? ,WINNER ,DARK-TUNNEL>>
		<SETG SECRET-DOOR T>
		<TELL
"The princess appears from behind some rocks, as though she had walked
through a wall." CR>)
	       (<IN? ,WINNER .OLDP>
		<SETG PRFOLLOW <GET ,PRDIRS <+ .PC 3>>>
	        <COND (<EQUAL? .OLDP ,FORMAL-GARDEN>
		       <TELL "The princess enters the gazebo." CR>)
		      (<EQUAL? .OLDP ,LEDGE-IN-RAVINE>
		       <TELL
"The princess climbs daintily down the rock face." CR>)
		      (T
		       <TELL "The princess walks ">
		       <TELL <GET ,PRDIRS .PC>>
		       <TELL ". She glances back at you as she goes." CR>)>)
	       (<IN? ,PRINCESS ,HERE>
		<COND (<EQUAL? ,HERE ,GAZEBO>
		       <TELL "The princess joins you in the gazebo." CR>)
		      (<EQUAL? ,HERE ,DEEP-FORD>
		       <TELL "The princess clambers down from the ledge." CR>)
		      (T
		       <TELL "The princess enters from the ">
		       <TELL <GET ,PRDIRS <+ 2 .PC>>>
		       <TELL ". She seems surprised to see you." CR>)>)>
	 <COND (<IN? ,PRINCESS ,GAZEBO>
		<DISABLE .DEM>
		<ENABLE <QUEUE I-UNICORN 6>>)
	       (T
		<SETG PRCOUNT <+ ,PRCOUNT 1>>
		<ENABLE <QUEUE I-PRINCESS <COND (<PROB 75> 1)
						(T 2)>>>)>
	 <RTRUE>>

<GLOBAL PRCOUNT 0>

<GLOBAL PRFOLLOW <>>

<GLOBAL PRDIRS
	<TABLE "south" DRAGON-ROOM "north" P?SOUTH
	       "east" LEDGE-IN-RAVINE "west" P?EAST
	       "south" DEEP-FORD "north" P?SOUTH
	       "east" DARK-TUNNEL "west" P?EAST
	       "south" FORMAL-GARDEN "north" P?SOUTH
	       "in" GAZEBO "out" P?IN>>

<ROUTINE I-UNICORN ()
	 <COND (<EQUAL? ,HERE ,GAZEBO ,FORMAL-GARDEN>
		<FCLEAR ,GOLD-KEY ,NDESCBIT>
		<MOVE ,GOLD-KEY ,WINNER>
		<SCORE-OBJ ,GOLD-KEY>
		<PUTP ,GOLD-KEY ,P?ACTION 0>
		<REMOVE ,PRINCESS>
		<TELL
"Shyly, a unicorn peeks out of the hedges and approaches the princess. Around
its neck hangs a gold key. The princess takes the key and, smiling, hands it
to you. \"It is the least I can do for one who rescued me from a fate I dare
not contemplate.\" With that, she mounts the unicorn and rides away." CR>)
	       (T
		<REMOVE ,PRINCESS>
		<RFALSE>)>>

<ROOM STONE-BRIDGE
      (IN ROOMS)
      (DESC "Stone Bridge")
      (LDESC
"You are on a north-south bridge spanning a deep ravine. Water flows
far beneath.")
      (NORTH TO DRAGON-ROOM)
      (SOUTH TO COOL-ROOM)
      (DOWN "It's a long way down.")
      (FLAGS RLANDBIT)
      (GLOBAL BRIDGE CHASM)>

<ROOM COOL-ROOM
      (IN ROOMS)
      (DESC "Cool Room")
      (LDESC
"The air is cool and damp. A path from the southeast splits here; north toward
a stone bridge, and west into a narrow tunnel. It is from the latter that the
chill originates.")
      (SE TO CAROUSEL-ROOM)
      (NORTH TO STONE-BRIDGE)
      (WEST TO ICE-ROOM)
      (FLAGS RLANDBIT)
      (GLOBAL BRIDGE)>

<ROOM ICE-ROOM
      (IN ROOMS)
      (DESC "Ice Room")
      (EAST TO COOL-ROOM)
      (WEST TO VOLCANO-BOTTOM IF ICE-MELTED ELSE
       "You don't even have an ice-pick.")
      (SOUTH TO GUARDED-ROOM)
      (FLAGS RLANDBIT)
      (ACTION ICE-ROOM-F)>

<ROUTINE ICE-ROOM-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"This is a large hall of ancient lava, worn smooth by a glacier. Tunnels
lead east and south.">
		<COND (,ICE-MELTED
		       <TELL " A damp, scorched passage leads west.">)>
		<CRLF>)>>

<OBJECT ICE
	(IN ICE-ROOM)
	(DESC "glacier")
	(LDESC "A mass of ice fills the western half of the room.")
	(SYNONYM ICE MASS GLACIER)
	(ADJECTIVE COLD ICY)
	(ACTION ICE-F)>

<ROUTINE ICE-F () 
	 <COND (<VERB? MELT>
		<TELL "This is a big glacier; you'll need lots of heat." CR>)>>