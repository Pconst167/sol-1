"WIZARD for
	        Mini-Zork II: The Wizard of Frobozz
	(c) Copyright 1988 Infocom, Inc.  All Rights Reserved."

<OBJECT WIZARD
	(DESC "Wizard of Frobozz")
	(LDESC "The Wizard of Frobozz is here, eyeing you warily.")
	(SYNONYM WIZARD MAN)
	(ADJECTIVE LITTLE FROBOZZ OLD)
	(FLAGS ACTORBIT CONTBIT OPENBIT)
	(ACTION WIZARD-F)>

<ROUTINE WIZARD-F ("OPTIONAL" (RARG ,M-OBJECT))
	 <COND (<OR <EQUAL? ,WINNER ,WIZARD>
		    <HELLO? ,WIZARD>>
		<TELL
"The Wizard seems surprised, much as you might be if a dog talked." CR>)
	       (<AND <VERB? GIVE>
		     <EQUAL? ,PRSI ,WIZARD>>
		<REMOVE-CAREFULLY ,PRSO>
		<COND (<BOMB? ,PRSO>
		       <COND (<IN? ,DEMON ,PENTAGRAM-ROOM>
			      <MOVE ,PRSO ,HERE>
			      <TELL
"The wizard accepts this final folly resignedly." CR>)
			     (T
			      <REMOVE ,WIZARD>
			      <TELL
,WAVES-WAND "and says, \"Flower!\" Indeed, the bomb becomes a lovely bouquet.
Both Wizard and flowers disappear." CR>)>)
		      (T
		       <TELL "He places the " D ,PRSO " under his robe." CR>
		       <NOW-DARK?>)>)
	       (<VERB? ATTACK MUNG>
		<REMOVE ,WIZARD>
		<COND (<IN? ,WAND ,WIZARD>
		       <TELL ,WAVES-WAND "and chants, \"Freeze!\"">)>
		<COND (<NOT <FSET? ,DEMON ,INVISIBLE>>
		       <TELL
" Nothing happens! Terrified, the wizard dashes from the room." CR>)
		      (T
		       <SETG SPELL? ,S-FREEZE>
		       <PUTP ,ADVENTURER ,P?ACTION MAGIC-ACTOR>
		       <ENABLE <QUEUE I-WIZARD 10>>
		       <TELL " You suddenly cannot move." CR>)>)>>

<ROUTINE I-WIZARD ("AUX" CAST-PROB (PCNT 0) F (WLOC <LOC ,WINNER>))
	 <ENABLE <QUEUE I-WIZARD 4>>
	 <COND (,DEAD
		<RFALSE>)
	       (,SPELL?
		<COND (<EQUAL? ,SPELL? ,S-FLOAT>
		       <COND (<EQUAL? ,HERE ,TOP-OF-WELL>
			      <JIGS-UP "You plunge down the well.">
			      <RTRUE>)
			     (<AND <FSET? ,HERE ,NONLANDBIT>
				   <NOT <EQUAL? ,HERE ,CIRCULAR-ROOM
						      ,VOLCANO-BOTTOM>>>
			      <JIGS-UP "You plunge down the volcano.">
			      <RTRUE>)>)
		      (<EQUAL? ,SPELL? ,S-FEEBLE>
		       <SETG LOAD-ALLOWED 100>)
		      (<EQUAL? ,SPELL? ,S-FUMBLE>
		       <SETG FUMBLE-NUMBER 7>
		       <SETG FUMBLE-PROB 8>)>
		<COND (<GET ,SPELL-STOPS ,SPELL?>
		       <TELL <GET ,SPELL-STOPS ,SPELL?> CR>)>
		<PUTP ,ADVENTURER ,P?ACTION 0>
		<SETG SPELL? <>>
		<RTRUE>)>
	 <COND (<IN? ,DEMON ,PENTAGRAM-ROOM>
		<DISABLE <INT I-WIZARD>> 
		<COND (<NOT <IN? ,WIZARD ,PENTAGRAM-ROOM>>
		       <MOVE ,WIZARD ,PENTAGRAM-ROOM>
		       <COND (<IN? ,WINNER ,PENTAGRAM-ROOM>
			      <TELL
"The Wizard appears, astonished to see his servant conversing with a common
adventurer! He waves his wand frantically. \"Frobizz! Frobozzle! Frobnoid!\"
The demon guffaws. \"You no longer control the Black Crystal, hedge-wizard!
Your wand is powerless! Your doom is sealed!\" The demon turns to you,
expectantly." CR>)>)>
		<RTRUE>)>
	 <COND (<AND <NOT ,LIT>
		     ,LAMP-BURNED-OUT
		     <G? ,SCORE 200>>
		<SETG ALWAYS-LIT T>
		<SETG LIT T>
		<TELL
"You hear the Wizard. \"Dear me, you're in a Fix.\" Chuckling, he incants,
\"Fluoresce!\" It is no longer dark." CR>
		<RTRUE>)>
	 <COND (<AND <LOC ,WIZARD>
		     <PROB 80>>
		<COND (<AND ,LIT <IN? ,WIZARD ,HERE>>
		       <TELL "The Wizard vanishes." CR>)>
		<REMOVE ,WIZARD>
		<RTRUE>)>
	 <COND (<AND <PROB 10>
		     <NOT <EQUAL? ,HERE ,POSTS-ROOM ,POOL-ROOM>>>
		<COND (<NOT ,LIT>
		       <TELL ,MOVED-IN-DARK>)
		      (<FSET? ,HERE ,NONLANDBIT>
		       <TELL
"The Wizard appears, floating nonchalantly in the air beside you." CR>)
		      (T
		       <TELL
"An old, robed man appears suddenly. He is wearing a pointed hat with
astrological signs, and has a long, unkempt beard." CR>)>
		<COND (<IN? ,PALANTIR-4 ,ADVENTURER>
		       <REMOVE ,WIZARD>
		       <COND (,LIT
			      <TELL
"The Wizard notices the Black Crystal, and hastily vanishes." CR>)
			     (T
			      <TELL ,MOVED-IN-DARK>)>
		       <RTRUE>)
		      (<PROB 20>
		       <REMOVE ,WIZARD>
		       <COND (,LIT
			      <TELL
"He mutters something (muffled by his beard) and disappears
as suddenly as he came." CR>)
			     (T
			      <TELL "You hear low, confused muttering." CR>)>
		       <RTRUE>)>
		<COND (<IN? ,PALANTIR-1 ,ADVENTURER>
		       <SET PCNT <+ .PCNT 1>>)>
		<COND (<IN? ,PALANTIR-2 ,ADVENTURER>
		       <SET PCNT <+ .PCNT 1>>)>
		<COND (<IN? ,PALANTIR-3 ,ADVENTURER>
		       <SET PCNT <+ .PCNT 1>>)>
		<SET CAST-PROB <- 80 <* .PCNT 20>>>
		<COND (,LIT
		       <TELL
"The Wizard draws forth his wand and waves it in your direction. It
begins to glow with a faint blue glow." CR>)
		      (T
		       <TELL
"You spot the Wizard, illuminated by the faint blue glow of a magic wand,
pointed at you!" CR>)>
		<COND (<PROB .CAST-PROB>
		       <MOVE ,WIZARD ,HERE>
		       <SETG SPELL? <RANDOM ,SPELLS>>
		       <PUTP ,ADVENTURER ,P?ACTION MAGIC-ACTOR>
		       <ENABLE
			    <QUEUE I-WIZARD <+ 5 <RANDOM <- 30 <* 5 .PCNT>>>>>>
		       <COND (<PROB 75>
			      <TELL
"The Wizard, in a deep and resonant voice, speaks the word \""
<GET ,SPELL-NAMES ,SPELL?> "!\" He then vanishes, cackling gleefully." CR>)
			     (T
			      <TELL
"The Wizard whispers a word beginning with \"F,\" and disappears." CR>)>
		       <REMOVE ,WIZARD>
		       <COND (<GET ,SPELL-HINTS ,SPELL?>
			      <TELL <GET ,SPELL-HINTS ,SPELL?> CR>)>
		       <COND (<EQUAL? ,SPELL? ,S-FALL>
			      <COND (<FSET? .WLOC ,VEHBIT>
				     <TELL
"You suddenly fall out of the " D .WLOC ,INVISIBLE-HAND>
				     <COND (<EQUAL? ,HERE ,TOP-OF-WELL>
					    <JIGS-UP
"You plunge down the well.">)
					   (<AND <FSET? ,HERE ,NONLANDBIT>
						 <NOT <EQUAL? ,HERE
							      ,VOLCANO-BOTTOM
							      ,CIRCULAR-ROOM>>>
					    <JIGS-UP
"You plunge down the volcano.">)
					   (T
					    <MOVE ,WINNER ,HERE>)>)>)
			     (<EQUAL? ,SPELL? ,S-FLOAT>
			      <TELL "You slowly rise into the air">
			      <COND (<FSET? .WLOC ,VEHBIT>
			      	     <MOVE ,WINNER ,HERE>
				     <TELL ", leaving the " D .WLOC>)>
			      <TELL ", stopping about five feet up." CR>)
			     (<EQUAL? ,SPELL? ,S-FEEBLE>
			      <SETG LOAD-ALLOWED 50>
			      <COND (<SET F <FIRST? ,WINNER>>
				     <TELL
"You feel so weak, you drop the " D .F ,PERIOD-CR>
				     <MOVE .F .WLOC>)>)
			     (<EQUAL? ,SPELL? ,S-FUMBLE>
			      <SETG FUMBLE-NUMBER 3>
			      <SETG FUMBLE-PROB 25>
			      <COND (<SET F <FIRST? ,ADVENTURER>>
				     <TELL
"Oops! You dropped the " D .F ,PERIOD-CR>
				     <MOVE .F .WLOC>)>)>
		       <RTRUE>)
		      (<PROB 50>
		       <REMOVE ,WIZARD>
		       <TELL
"There is a crackling noise. Blue smoke curls from the Wizard's
sleeve. He sighs and disappears." CR>)
		      (<PROB 50>
		       <REMOVE ,WIZARD>
		       <TELL
"The Wizard incants \"" <RANDOM-ELEMENT ,SPELL-NAMES> "!\" but nothing
happens. With an embarrassed glance in your direction, he vanishes." CR>)
		      (T
		       <MOVE ,WIZARD ,HERE>
		       <TELL
"The Wizard seems about to say something, but thinks better of it,
and peers at you from under his bushy eyebrows." CR>)>)>>

<ROUTINE MAGIC-ACTOR ("AUX" V)
	 <COND (,SPELL?
		<COND (<EQUAL? ,SPELL? ,S-FALL>
		       <COND (<OR <VERB? CLIMB CLIMB-DOWN>
				  <AND <VERB? WALK>
				       <GETPT ,HERE ,P?DOWN>>>
			      <SET V <GETPT ,HERE ,P?GLOBAL>>
			      <COND (<ZMEMQB ,BRIDGE .V <PTSIZE .V>>
				     <JIGS-UP
"You trip on something and fall over the edge of the bridge.">)
				    (T
				     <TELL "You trip on your own feet, ">
				     <COND (<PROB 25>
					    <JIGS-UP
"and the resulting fall does you in.">)
					   (T
				    	    <TELL
"but regain your balance and avoid a fatal fall." CR>)>)>)
			     (<VERB? ENTER>
			      <TELL
"You get in the " D ,PRSO " but you fall out again" ,INVISIBLE-HAND>)>)
		      (<EQUAL? ,SPELL? ,S-FLOAT>
		       <COND (<VERB? DIAGNOSE WAIT>
			      <RFALSE>)
			     (<VERB? WALK>
			      <TELL
"Your feet are nowhere near the ground." CR>)
			     (<VERB? DROP>
			      <MOVE ,PRSO ,HERE>
			      <TELL "The " D ,PRSO " drops to the ground." CR>)
			     (<AND <VERB? TAKE>
				   <IN? ,PRSO ,HERE>>
			      <TELL
"You're floating and can't reach it." CR>)>)
		      (<EQUAL? ,SPELL? ,S-FREEZE>
		       <COND (<VERB? DIAGNOSE WAIT>
			      <RFALSE>)
			     (T
			      <TELL
"You are frozen solid. You might as well wait it out, because you
can't do anything else in this state." CR>)>)
		      (<AND <EQUAL? ,SPELL? ,S-FENCE>
			    <VERB? WALK>>
		       <TELL "An invisible force bars your way." CR>
		       <RTRUE>)
		      (<AND <EQUAL? ,SPELL? ,S-FERMENT>
			    <VERB? WALK>
			    <IN? ,WINNER ,HERE>>
		       <TELL
"Oops, you seem a little unsteady... I'm not sure you got where
you intended going." CR CR>
		       <RANDOM-WALK>)>)>>

<ROUTINE RANDOM-WALK ("AUX" P TX L S (D <>))
	 <SET P 0>
	 <REPEAT ()
		 <COND (<L? <SET P <NEXTP ,HERE .P>> ,LOW-DIRECTION>
			<COND (.D
			       <SET S ,SPELL?>
			       <SETG SPELL? <>>
			       <SETG WINNER ,ADVENTURER>
			       <MOVE ,WINNER ,HERE>
			       <DO-WALK .D>
			       <SETG SPELL? .S>)>
			<RETURN>)
		       (T
			<SET TX <GETPT ,HERE .P>>
			<SET L <PTSIZE .TX>>
			<COND (<OR <EQUAL? .L ,UEXIT>
				   <AND <EQUAL? .L ,CEXIT>
					<VALUE <GETB .TX ,CEXITFLAG>>>
				   <AND <EQUAL? .L ,DEXIT>
					<FSET? <GETB .TX ,DEXITOBJ> ,OPENBIT>>>
			       <COND (<NOT .D>
				      <SET D .P>)
				     (<PROB 50>
				      <SET D .P>)>)>)>>>

<GLOBAL SPELL-HANDLED? <>>	;"T if handled before I-SPELL runs"

<GLOBAL WAND-ON <>>

<GLOBAL SPELL-USED <>>

<GLOBAL SPELL-VICTIM <>>

<GLOBAL SPELL? <>>

<CONSTANT SPELLS 9>
<CONSTANT S-FEEBLE 1>
<CONSTANT S-FUMBLE 2>
<CONSTANT S-FREEZE 3>
<CONSTANT S-FALL 4>
<CONSTANT S-FERMENT 5>
<CONSTANT S-FLOAT 6>
<CONSTANT S-FIREPROOF 7>
<CONSTANT S-FENCE 8>
<CONSTANT S-FANTASIZE 9>

<GLOBAL SPELL-NAMES
	<LTABLE
"Feeble" "Fumble" "Freeze" "Fall" "Ferment" "Float" "Fireproof" "Fence"
"Fantasize">>

<GLOBAL SPELL-HINTS
	<LTABLE
"All at once you feel very tired."
<>
"Your limbs suddenly feel like stone. You can't move a muscle."
<>
"You begin to feel lightheaded."
<>
<>
<>
<>>>

<GLOBAL SPELL-STOPS
	<LTABLE
"You feel more energetic now."
<>
"Your little finger begins to twitch, and then your whole body is free
again."
<>
"Your head is clearer now."
"You sink quietly down again."
<>
<>
<>>>

<GLOBAL FANTASIES
	<LTABLE "pile of jewels" "gold ingot" "basilisk"
		"bulging chest" "yellow sphere" "grue"
		"convention of wizards" "copy of ZORK I">>

<OBJECT WAND
	(IN WIZARD)
	(DESC "magic wand")
	(SYNONYM WAND)
	(ADJECTIVE MAGIC)
	(VALUE 30)
	(FLAGS NDESCBIT TAKEBIT TRYTAKEBIT)
	(ACTION WAND-F)>

<ROUTINE WAND-F ()
	 <COND (<AND <VERB? TAKE PUT GIVE>
		     <IN? ,WAND ,WIZARD>>
		<TELL "The Wizard snatches it away." CR>)
	       (<AND <VERB? WAVE>
		     <EQUAL? ,PRSI ,GRUE>>
	        <TELL "A gurgling hiss issues from the darkness." CR>)
	       (<VERB? WAVE RUB RAISE>
		<COND (<AND <EQUAL? ,PRSO ,WAND>
			    <NOT <IN? ,WAND ,WINNER>>>
		       <TELL "You don't have the wand!" CR>
		       <RTRUE>)
		      (<OR ,WAND-ON ,SPELL-USED ,SPELL-VICTIM>
		       <TELL "A magic wand must recharge after use!" CR>
		       <RTRUE>)
		      (<VERB? WAVE>
		       <COND (<AND <EQUAL? ,PRSO ,WAND> ,PRSI>
			      <SETG WAND-ON ,PRSI>
			      <SETG WAND-ON-LOC ,HERE>)
			     (T
			      <TELL "At what?" CR>
			      <RTRUE>)>)
		      (<VERB? RUB>
		       <COND (<EQUAL? ,PRSI ,WAND>
			      <SETG WAND-ON ,PRSO>)
			     (T
			      <TELL "Touch what?" CR>
			      <RTRUE>)>)
		      (<VERB? RAISE>
		       <TELL "The wand grows warm and seems to vibrate." CR>
		       <RTRUE>)>
		<COND (,WAND-ON
		       <SETG SPELL-USED <>>
		       <SETG SPELL-VICTIM <>>
		       <COND (<EQUAL? ,WAND-ON ,ME ,WAND>
			      <SETG WAND-ON <>>
			      <TELL "A safety interlock prevents this." CR>)
			     (T
			      <TELL
"The wand grows warm, the " D ,WAND-ON " glows with magical essences,
and you feel suffused with power." CR>)>
		       <ENABLE <QUEUE I-WAND 2>>)>
		T)>>

<GLOBAL WAND-ON-LOC <>>

<ROUTINE I-WAND ()
	 <COND (<AND ,WAND-ON
		     <OR <EQUAL? ,WAND-ON-LOC ,HERE>
			 <IN? ,WAND-ON ,WINNER>>>
		<SETG WAND-ON <>>
		<TELL
"The " D ,WAND-ON " stops glowing and the power within you weakens." CR>)
	       (T
		<SETG WAND-ON <>>
		<RFALSE>)>>

<ROOM GUARDED-ROOM
      (IN ROOMS)
      (DESC "Guarded Room")
      (NORTH TO ICE-ROOM)
      (SOUTH TO TROPHY-ROOM IF WIZ-DOOR IS OPEN)
      (IN TO TROPHY-ROOM IF WIZ-DOOR IS OPEN)
      (FLAGS RLANDBIT)
      (GLOBAL WIZ-DOOR)
      (ACTION GUARDED-ROOM-F)>

<ROUTINE GUARDED-ROOM-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"This room is cobwebby and musty, but tracks in the dust indicate recent
visitors. To the south is a">
		<COND (<FSET? ,WIZ-DOOR ,OPENBIT>
		       <TELL "n open">)
		      (T
		       <TELL "battered (but very strong-looking)">)>
		<TELL " door. Mounted on the door is a ">
		<COND (<NOT ,GUARDIAN-FED>
		       <TELL "nast">)
		      (T
		       <TELL "sleep">)>
		<TELL
"y-looking lizard head, with sharp teeth and beady eyes. ">
		<COND (<IN? ,CANDY ,WINNER>
		       <TELL "The lizard is sniffing at you. ">)
		      (<NOT ,GUARDIAN-FED>
		       <TELL "The eyes follow your approach. ">)>
		<TELL "To the north and northeast, corridors exit." CR>)>>

<OBJECT WIZ-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "door")
	(SYNONYM DOOR)
	(ADJECTIVE BATTERED)
	(FLAGS DOORBIT CONTBIT)
	(ACTION WIZ-DOOR-F)>

<ROUTINE WIZ-DOOR-F ()
	 <COND (<AND <NOT ,GUARDIAN-FED>
		     <VERB? OPEN UNLOCK>>
		<TELL "The lizard snaps at you as you reach for the door." CR>)
	       (<VERB? UNLOCK>
		<COND (,WIZ-DOOR-FLAG
		       <TELL ,ALREADY>)
		      (<EQUAL? ,PRSI ,GOLD-KEY>
		       <SETG WIZ-DOOR-FLAG T>
		       <TELL "The door is unlocked." CR>)
		      (T
		       <TELL ,DOESNT-FIT-LOCK>)>)
	       (<VERB? LOCK>
		<COND (<NOT ,WIZ-DOOR-FLAG>
		       <TELL ,ALREADY>)
		      (<EQUAL? ,PRSI ,GOLD-KEY>
		       <SETG WIZ-DOOR-FLAG <>>
		       <TELL "The door is now locked." CR>)
		      (T
		       <TELL ,DOESNT-FIT-LOCK>)>)
	       (<VERB? OPEN CLOSE>
		<COND (,WIZ-DOOR-FLAG
		       <OPEN-CLOSE>)
		      (<VERB? OPEN>
		       <TELL "The door is locked!" CR>)>)>>

<GLOBAL WIZ-DOOR-FLAG <>>

<GLOBAL GUARDIAN-FED <>>

<OBJECT DOOR-KEEPER
	(IN GUARDED-ROOM)
	(DESC "lizard")
	(SYNONYM GUARDIAN LIZARD HEAD)
	(ADJECTIVE NASTY)
	(FLAGS NDESCBIT)
	(ACTION DOOR-KEEPER-F)>

<ROUTINE DOOR-KEEPER-F ()
	 <COND (<AND <VERB? ALARM>
		     ,GUARDIAN-FED>
		<TELL "You can't wake it." CR>)
	       (<AND <VERB? GIVE>
		     <EQUAL? ,PRSI ,DOOR-KEEPER>>
		<COND (,GUARDIAN-FED
		       <TELL "You can't wake it." CR>)
		      (<EQUAL? ,PRSO ,CANDY>
		       <SETG GUARDIAN-FED T>
		       <REMOVE ,CANDY>
		       <TELL
,GREEDILY-DEVOURS "the candy, package and all, and then its eyes close.
(Lizards are known to sleep a long time while digesting meals.)" CR>)
		      (<BOMB? ,PRSO>
		       <REMOVE ,PRSO>
		       <TELL
,GREEDILY-DEVOURS "it. After a while, you hear a pop and the guardian's
eyes bulge out. It hisses angrily." CR>)
		      (<EQUAL? ,PRSO ,PALANTIR-1 ,PALANTIR-2 ,PALANTIR-3>
		       <MOVE ,PRSO ,HERE>
		       <TELL
,GREEDILY-DEVOURS "the sphere but then spits it out." CR>)
		      (T
		       <REMOVE ,PRSO>
		       <TELL
,GREEDILY-DEVOURS "the " D ,PRSO ,PERIOD-CR>)>)
	       (<VERB? ATTACK MUNG>
		<TELL "The guardian seems impervious." CR>)>>

<ROOM TROPHY-ROOM
      (IN ROOMS)
      (DESC "Trophy Room")
      (FLAGS RLANDBIT)
      (NORTH TO GUARDED-ROOM IF WIZ-DOOR IS OPEN)
      (OUT TO GUARDED-ROOM IF WIZ-DOOR IS OPEN)
      (WEST TO AQUARIUM-ROOM)
      (EAST TO WIZARDS-WORKSHOP)
      (VALUE 10)
      (GLOBAL WIZ-DOOR)
      (PSEUDO "OWL" TROPHY-PSEUDO)
      (ACTION TROPHY-ROOM-F)>

<ROUTINE TROPHY-ROOM-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"The Wizard's trophy room is filled with various memorabilia. On one wall is
the Wizard's D. T. (Doctor of Thaumaturgy) degree from GUE Tech. Several old
magic wands are mounted on a wand rack. There is a stuffed owl on a perch.
Corridors lead east and west; a door to the north is ">
		<COND (<FSET? ,WIZ-DOOR ,OPENBIT>
		       <TELL "open">)
		      (T
		       <TELL "closed">)>
		<TELL ,PERIOD-CR>)>>

<ROUTINE TROPHY-PSEUDO ()
	 <COND (<VERB? TAKE RUB>
		<TELL
"As you near it, you get a nasty (but fortunately unfatal) shock." CR>)>>

<OBJECT DEGREE
	(IN TROPHY-ROOM)
	(DESC "degree")
	(SYNONYM DEGREE DIPLOMA)
	(FLAGS NDESCBIT TRYTAKEBIT READBIT)
	(TEXT "The text is in an obscure tongue.")
	(ACTION TROPHY-PSEUDO)>

<OBJECT WANDS
	(IN TROPHY-ROOM)
	(DESC "set of used wands")
	(SYNONYM WANDS WAND RACK SET)
        (ADJECTIVE WORN USED)
	(FLAGS NDESCBIT TRYTAKEBIT)
	(ACTION TROPHY-PSEUDO)>

<ROOM WIZARDS-WORKSHOP
      (IN ROOMS)
      (DESC "Wizard's Workshop")
      (LDESC
"Halls lead west and south. The Wizard's workbench dominates the room. It is
stained from years of use, and is deeply gouged as though some huge clawed
animal was imprisoned on it. In the center of the bench, three stands - ruby,
sapphire, and diamond - form a triangle.")
      (WEST TO TROPHY-ROOM)
      (SOUTH TO PENTAGRAM-ROOM)
      (FLAGS RLANDBIT ONBIT)>

<OBJECT WORKBENCH
	(IN WIZARDS-WORKSHOP)
	(DESC "Wizard's workbench")
	(SYNONYM WORKBENCH BENCH TABLE)
	(ADJECTIVE WORK WIZARD)
	(CAPACITY 200)
	(FLAGS NDESCBIT SURFACEBIT CONTBIT OPENBIT)>

<OBJECT STAND-1
	(IN WORKBENCH)
	(DESC "ruby stand")
	(SYNONYM STAND STANDS)
	(ADJECTIVE CRYSTAL RUBY)
	(FLAGS NDESCBIT SURFACEBIT CONTBIT OPENBIT)
	(CAPACITY 10)
	(ACTION STAND-F)>

<OBJECT STAND-2
	(IN WORKBENCH)
	(DESC "sapphire stand")
	(SYNONYM STAND STANDS)
	(ADJECTIVE CRYSTAL SAPPHIRE)
	(FLAGS NDESCBIT SURFACEBIT OPENBIT CONTBIT)
	(CAPACITY 10)
	(ACTION STAND-F)>

<OBJECT STAND-3
	(IN WORKBENCH)
	(DESC "diamond stand")
	(SYNONYM STAND STANDS)
	(ADJECTIVE DIAMOND CRYSTAL)
	(FLAGS NDESCBIT SURFACEBIT OPENBIT CONTBIT)
	(CAPACITY 10)
	(ACTION STAND-F)>

<OBJECT STAND-4
	(DESC "black obsidian stand")
	(SYNONYM STAND STANDS)
	(ADJECTIVE OBSIDIAN BLACK CRYSTAL STRANGE)
	(FLAGS SURFACEBIT CONTBIT OPENBIT)
	(SIZE 5)
	(CAPACITY 10)
	(ACTION STAND-F)>

<ROUTINE STAND-F ()
	 <COND (<VERB? TAKE>
		<TELL "The " D ,PRSO " is firmly attached to the bench." CR>)
	       (<AND <VERB? PUT PUT-ON>
		     <EQUAL? ,PRSO ,PALANTIR-1 ,PALANTIR-2 ,PALANTIR-3>
		     <EQUAL? ,PRSI ,STAND-1 ,STAND-2 ,STAND-3>>
		<V-PUT>
		<COND (<AND <IN? ,PALANTIR-1 ,STAND-1>
			    <IN? ,PALANTIR-2 ,STAND-2>
			    <IN? ,PALANTIR-3 ,STAND-3>>
		       <REMOVE ,PALANTIR-1>
		       <REMOVE ,PALANTIR-2>
		       <REMOVE ,PALANTIR-3>
		       <MOVE ,STAND-4 ,WORKBENCH>
		       <TELL
"Instantly, a hum begins, and the hairs on the back of your neck stand up.
Suddenly, the spheres are gone! But amidst the three empty stands, there is
now a black stand of obsidian in which rests a strange black sphere." CR>)>
		<RTRUE>)>>

<OBJECT PALANTIR-4
	(IN STAND-4)
	(DESC "black crystal sphere")
	(LDESC "There is a strange black sphere here.")
	(SYNONYM SPHERE)
	(ADJECTIVE CRYSTAL STRANGE BLACK)
	(FLAGS TAKEBIT TRANSBIT)
	(VALUE 30)
	(SIZE 10)
	(ACTION SPHERE-F)>

<ROOM PENTAGRAM-ROOM
      (IN ROOMS)
      (DESC "Pentagram Room")
      (LDESC
"Inscribed on the floor is a great pentagram drawn with black chalk.
In its center is a black circle.")
      (NORTH TO WIZARDS-WORKSHOP)
      (FLAGS RLANDBIT ONBIT)
      (GLOBAL GLOBAL-MENHIR GLOBAL-CERBERUS)>

<OBJECT PENTAGRAM
	(IN PENTAGRAM-ROOM)
	(DESC "pentagram")
	(SYNONYM PENTAGRAM STAR CIRCLE)
	(ADJECTIVE GREAT BLACK)
	(FLAGS NDESCBIT SURFACEBIT CONTBIT OPENBIT)
	(CAPACITY 200)
	(ACTION PENTAGRAM-F)>

<ROUTINE PENTAGRAM-F ("OPTIONAL" (RARG ,M-BEG))
	 <COND (<EQUAL? .RARG ,M-BEG>
		<COND (<VERB? ENTER>
		       <TELL "You are forced back by an invisible power." CR>)
	              (<AND <VERB? PUT PUT-ON>
			    <EQUAL? ,PRSO ,PALANTIR-4>>
		       <REMOVE ,PALANTIR-4>
		       <FCLEAR ,DEMON ,INVISIBLE>
		       <MOVE ,DEMON ,PENTAGRAM-ROOM>
		       <TELL
"A chill wind blasts from the pentagram as a dim shape appears and resolves
into a formidable-looking demon. He tests the walls of the pentagram
experimentally, then sees you! \"Greetings, oh new master! Wouldst desire a
service? For a pittance of wealth, I will gratify thy desires to the utmost
limit of my powers!\" He grins vilely." CR>)>)>>

<OBJECT DEMON
	(SYNONYM DEVIL DEMON GENIE)
	(DESC "demon")
	(LDESC "There is a demon floating in midair here.")
	(FLAGS ACTORBIT INVISIBLE)
	(ACTION DEMON-F)>

<ROUTINE DEMON-F ("OPTIONAL" (RARG ,M-OBJECT) "AUX" V)
	<COND (<VERB? HELLO>
	       <TELL "The genie grins demonically." CR>)
	      (<EQUAL? ,WINNER ,DEMON>
	       <COND (<NOT ,DEMON-PAID>
		      <TELL
"\"My fee is not paid! I perform no tasks for free! We demons have a
strong union these days.\"" CR>
		      <RFATAL>)
		     (<VERB? SGIVE>
		      <RFALSE>)
		     (<OR <G? <GET ,P-PRSO 0> 1>
			  <G? <GET ,P-PRSI 0> 1>>
		      <TELL "\"I will do one thing only, master!\"" CR>
		      <RFATAL>)
		     (<AND <VERB? MOVE>
			   <EQUAL? ,PRSO ,GLOBAL-MENHIR>>
		      <SETG MENHIR-POSITION 1>
		      <TELL
,DEMON-GONE "\"A trifle... My little finger alone was enough.\"" CR>
		      <DEMON-LEAVES>)
		     (<VERB? TAKE>
		      <COND (<EQUAL? ,PRSO ,GLOBAL-MENHIR>
			     <REMOVE ,MENHIR>
			     <SETG MENHIR-POSITION 2>
			     <TELL
,DEMON-GONE "\"Perhaps I can use it as a toothpick...\"" CR>
			     <DEMON-LEAVES>)
			    (<EQUAL? ,PRSO ,WAND>
			     <REMOVE ,WAND>
			     <TELL
"\"Gladly, oh fool!\" Cackling, the demon snatches the wand and points it at
himself. \"Free!\" he commands, as the demon and wand vanish forever." CR>
			     <DEMON-LEAVES <>>)
			    (<FSET? ,PRSO ,TAKEBIT>
			     <DEMON-LEAVES <>>
			     <REMOVE ,PRSO>
			     <TELL
"The demon snaps his fingers; the " D ,PRSO " and he both depart." CR>)
			    (T
			     <TELL "\"I fear that I cannot take that.\"" CR>)>)
		     (<AND <VERB? GIVE>
			   <EQUAL? ,PRSI ,ME>>
		      <COND (<EQUAL? ,PRSO ,WAND>
			     <REMOVE ,WIZARD>
			     <DEMON-LEAVES <>>
			     <FCLEAR ,WAND ,NDESCBIT>
			     <MOVE ,WAND ,HERE>
			     <TELL
"\"I hear and obey!\" says the demon. The Wizard cries \"Fudge!\" but aside
from a strong odor of chocolate, there is no effect. The demon plucks the
wand out of his hand and lays it before you. He vanishes as the wizard runs
from the room in terror." CR>)
			    (<EQUAL? ,PRSO ,GLOBAL-MENHIR>
			     <MOVE ,MENHIR ,PENTAGRAM-ROOM>
			     <FCLEAR ,MENHIR ,NDESCBIT>
			     <FCLEAR ,MENHIR ,TAKEBIT>
			     <SETG MENHIR-POSITION 3>
			     <TELL
"He gestures, and the menhir appears at your feet." CR>
			     <DEMON-LEAVES>)
			    (<FSET? ,PRSO ,TAKEBIT>
			     <MOVE ,PRSO ,PENTAGRAM-ROOM>
			     <TELL
"The " D ,PRSO " appears before you and settles to the ground." CR>
			     <DEMON-LEAVES>)
			    (T
			     <TELL "\"If only it were possible...\"" CR>)>)
		     (<VERB? ATTACK>
		      <COND (<EQUAL? ,PRSO ,GLOBAL-CERBERUS>
			     <TELL
"\"This may prove taxing...\" " ,DEMON-GONE "He looks rather gnawed
and scratched. He winces. \"Never did like dogs anyway... Any other
orders, oh beneficent one?\"" CR>)
			    (<EQUAL? ,PRSO ,WIZARD>
			     <REMOVE ,WIZARD>
			     <FCLEAR ,WAND ,NDESCBIT>
			     <MOVE ,WAND ,HERE>
			     <TELL
"The demon grins hideously. \"This has been my desire e'er since this charlatan
bent me to his service!\" " ,WAVES-WAND "fruitlessly as the demon forms himself
into a smoky cloud which envelops the Wizard. A horrible scream is heard, and
the smoke clears, leaving no trace of the Wizard but his wand." CR>
			     <DEMON-LEAVES>)
			    (<EQUAL? ,PRSO ,ME>
			     <DEMON-LEAVES <>>
			     <SETG WINNER ,ADVENTURER>
			     <JIGS-UP
"The demon crushes you with his enormous hand.">)
			    (T
			     <TELL 
"\"I know no way to kill a " D ,PRSO ".\"" CR>)>)
		     (<VERB? FIND EXAMINE>
		      <TELL "\"I am not permitted to ">
		      <COND (<VERB? FIND>
			     <TELL "answer questions">)
			    (T
			     <TELL "perform such menial tasks">)>
		      <TELL
". The terms of my contract are explicit, and the penalty clauses are ...
hmm ... devilish.\"" CR>)
		     (T
		      <TELL
"\"Apologies, oh master, but even for such a one as I this is not possible.\"
He seems chagrined to have to admit this." CR>
		      <RTRUE>)>)
	      (<VERB? ATTACK MUNG>
	       <TELL "The demon laughs uproariously." CR>)
	      (<AND <VERB? GIVE>
		    <EQUAL? ,PRSI ,DEMON>>
	       <COND (<AND <GETPT ,PRSO ,P?VALUE>
			   <NOT <EQUAL? ,PRSO ,SWORD>>>
		      <REMOVE-CAREFULLY ,PRSO>
		      <SETG DEMON-HOARD <+ ,DEMON-HOARD 1>>
		      <SETG SCORE <+ ,SCORE 2>>
		      <COND (<NOT <L? ,DEMON-HOARD ,TREASURES-MAX>>
			     <SETG DEMON-PAID T>
			     <PUTP ,WIZARD ,P?LDESC
"A dejected and fearful Wizard watches from the corner.">
			     <TELL
"\"This paltry hoard will suffice for my fee.\"" CR>)
			    (T
			     <TELL
"\"" <GET ,DEMON-THANKS ,DEMON-HOARD> "\"" CR>
			     <COND (<EQUAL? ,DEMON-HOARD 8>
				    <TELL
"The Wizard tears his bears and looks at you as if you are a madman." CR>)>
			     <RTRUE>)>)
		     (<BOMB? ,PRSO>
		      <DEMON-LEAVES <>>
		      <TELL
"\"This violates my contract, oh fool. Thus, I am free to depart.\"" CR>)
		     (T
		      <REMOVE-CAREFULLY ,PRSO>
		      <TELL
"The demon takes the " D ,PRSO " and smiles balefully, revealing
enormous fangs." CR>)>)>>

<ROUTINE DEMON-LEAVES ("OPTIONAL" (NOISY? T))
	 <FSET ,DEMON ,INVISIBLE>
	 <COND (.NOISY?
		<TELL "The genie departs, his agreement fulfilled." CR>)>
	 <SETG P-CONT <>>
	 <RFATAL>>

<GLOBAL DEMON-PAID <>>

<GLOBAL DEMON-HOARD 0>

<CONSTANT TREASURES-MAX 10>

<GLOBAL DEMON-THANKS
	<LTABLE
"Most fine, master! But 'tis not enough. I will do a great service,
and are not great services bought at great price?"
"Very nice, but not enough!"
"Ah, truly magnificent! Keep them coming."
"Almost halfway there, oh worthy one!"
"Your generosity overwhelms me!"
"Very nice, but not enough!"
"Ah, truly magnificent! Keep them coming."
"Your generosity overwhelms me!"
"Wondrous fine, master! But one treasure is yet to be given!">>

<ROOM AQUARIUM-ROOM
      (IN ROOMS)
      (DESC "Aquarium Room")
      (LDESC
"Here a dark hallway turns a corner. To the south is a dark room, to
the east is fitful light.")
      (EAST TO TROPHY-ROOM)
      (IN TO MURKY-ROOM)
      (SOUTH TO WIZARDS-QUARTERS)
      (FLAGS RLANDBIT ONBIT)>

<OBJECT AQUARIUM
	(IN AQUARIUM-ROOM)
	(DESC "aquarium")
	(LDESC "Filling the northern half of the room is a huge aquarium.")
	(SYNONYM AQUARIUM GLASS)
	(ADJECTIVE HUGE)
	(FLAGS OPENBIT CONTBIT)
	(CAPACITY 200)
	(ACTION AQUARIUM-F)>

<ROUTINE AQUARIUM-F ("AUX" OBJ)
	 <COND (<VERB? ENTER>
		<DO-WALK ,P?IN>)
	       (<AND <VERB? LOOK-INSIDE>
		     <IN? ,SERPENT ,AQUARIUM>>
		<TELL
"A baby serpent in the aquarium eyes you suspiciously." CR>)
	       (<OR <AND <VERB? MUNG ATTACK>
			 <EQUAL? ,PRSO ,AQUARIUM>>
		    <AND <VERB? THROW>
			 <EQUAL? ,PRSI ,AQUARIUM>>>
		<COND (<EQUAL? ,PRSO ,AQUARIUM>
		       <COND (<NOT ,PRSI>
			      <RFALSE>)
			     (T 
			      <SET OBJ ,PRSI>)>)
		      (T
		       <SET OBJ ,PRSO>)>
		<MOVE .OBJ ,HERE>
		<COND (<IN? ,DEAD-SERPENT ,HERE>
		       <TELL "The aquarium is already broken!" CR>)
		      (<BOMB? .OBJ>
		       <DISABLE <INT I-FUSE>>)
		      (<OR <FSET? .OBJ ,WEAPONBIT>
			   <G? <GETP .OBJ ,P?SIZE> 10>>
		       <REMOVE ,SERPENT>
		       <MOVE ,DEAD-SERPENT ,HERE>
		       <MOVE ,PALANTIR-3 ,AQUARIUM>
		       <FCLEAR ,PALANTIR-3 ,NDESCBIT>
		       <PUTP ,AQUARIUM ,P?LDESC
"A shattered aquarium fills the northern half of the room.">
		       <TELL
"The " D .OBJ " shatters the aquarium, spilling salt water, wet sand, and
an extremely annoyed sea serpent. He is having difficulty breathing, and he
seems to hold you responsible. He ">
		       <COND (<VERB? MUNG>
			      <JIGS-UP
"rends you limb from limb before he drowns in the air.">)
			     (T
			      <TELL
"slithers toward you, but expires mere inches away. A clear crystal sphere
sits amid the sand and broken glass in the aquarium." CR>)>)
		      (T
		       <TELL
"The " D .OBJ " bounces harmlessly off the glass." CR>)>)>>

<OBJECT SERPENT
	(IN AQUARIUM)
	(DESC "baby sea serpent")
	(LDESC "There is a baby sea serpent swimming in the aquarium.")
	(SYNONYM SERPENT SNAKE)
	(ADJECTIVE BABY SEA)
	(FLAGS ACTORBIT)
	(ACTION SERPENT-F)>

<ROUTINE SERPENT-F ()
	 <COND (<EQUAL? ,SERPENT ,WINNER>
		<TELL "The serpent only stares hungrily at you." CR>)
	       (<VERB? ATTACK MUNG>
		<TELL
"He swims towards you, his dagger-like teeth dripping. Fortunately, he
doesn't want to crash into the aquarium wall, and contents himself with
splashing you with water." CR>)
	       (<AND <VERB? PUT>
		     <EQUAL? ,PRSO ,SERPENT>>
		<TELL "Impossible!" CR>)
	       (<VERB? TAKE GIVE>
		<JIGS-UP "He takes you instead. \"Uurrp!\"">)>>

<OBJECT DEAD-SERPENT
	(DESC "dead sea serpent")
	(SYNONYM SERPENT SNAKE)
	(ADJECTIVE DEAD BABY SEA)
	(FLAGS TAKEBIT)
	(SIZE 400)
	(ACTION DEAD-SERPENT-F)>

<ROUTINE DEAD-SERPENT-F ()
	 <COND (<VERB? TAKE>
		<TELL "This may be a baby, but it's as big as a whale." CR>)>>

<ROOM MURKY-ROOM
      (IN ROOMS)
      (DESC "Murky Room")
      ;(LDESC
"The floor is made of sand, but it is hard to see anything else.")
      (OUT TO AQUARIUM-ROOM)
      (FLAGS RLANDBIT ONBIT)
      (ACTION MURKY-ROOM-F)>

<ROUTINE MURKY-ROOM-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL " The floor is sandy, and your vision seems blurred.">
		<COND (<AND <IN? ,SERPENT ,AQUARIUM>
			    <PROB 20>>
		       <TELL " A shadow seems to swim by overhead.">)>
		<CRLF>)
	       (<EQUAL? .RARG ,M-ENTER>
		<COND (<IN? ,SERPENT ,AQUARIUM>
		       <JIGS-UP
"You drop into the aquarium with a splash, which attracts the serpent. Being
a hungry baby, he greedily eats you.">)
		      (T
		       <JIGS-UP
"You cut yourself severely on the broken glass.">)>)>>

<ROOM WIZARDS-QUARTERS
      (IN ROOMS)
      (DESC "Wizard's Quarters")
      (NORTH TO AQUARIUM-ROOM)
      (FLAGS RLANDBIT)
      (ACTION WIZARD-QUARTERS-F)>

<ROUTINE WIZARD-QUARTERS-F (RARG "AUX" PICK L)
	 <COND (<EQUAL? .RARG ,M-LOOK ,M-FLASH>
		<TELL
"This is where the Wizard of Frobozz lives. The room is "
<PICK-ONE ,WIZQDESCS> ,PERIOD-CR>)>>

<GLOBAL WIZQDESCS
	<LTABLE
"almost monkish in its austerity"
"an opulently furnished seraglio out of an Arabian folktale"
"decorated in the Louis XIV style"
"overhung with palm-trees and lianas. The only furniture is a hammock"
"a suburban bedroom out of the 1950's, complete with bunk beds"
"a dim cave, its floor piled with furs and old bones">>
\
;"the palantirs"

<OBJECT PALANTIR-1
	(IN DINGY-CLOSET)
	(DESC "red crystal sphere")
	(SYNONYM SPHERE)
	(ADJECTIVE CRYSTAL RED)
	(SIZE 10)
	(VALUE 20)
	(FLAGS TAKEBIT TRANSBIT TRYTAKEBIT)
	(ACTION SPHERE-F)>

<OBJECT PALANTIR-2
	(IN DREARY-ROOM)
	(DESC "blue crystal sphere")
	(FDESC "On the table sits a blue crystal sphere.")
	(SYNONYM SPHERE)
	(ADJECTIVE CRYSTAL BLUE)
	(VALUE 20)
	(FLAGS TAKEBIT TRANSBIT)
	(ACTION SPHERE-F)>

<OBJECT PALANTIR-3
	(IN MURKY-ROOM)
	(DESC "clear crystal sphere")
	(FDESC "There is a clear crystal sphere lying in the sand.")
	(SYNONYM SPHERE)
	(ADJECTIVE CRYSTAL WHITE CLEAR)
	(FLAGS TAKEBIT NDESCBIT TRANSBIT)
	(VALUE 20)
	(ACTION SPHERE-F)>

<ROUTINE SPHERE-F ()
	 <COND (<AND <VERB? TAKE MOVE PUT>
		     <PRSO? ,PALANTIR-1>
		     <NOT ,CAGE-SOLVE-FLAG>>
		<COND (<EQUAL? ,ADVENTURER ,WINNER>
	               <TELL
"As you reach for the sphere, a solid steel cage falls to entrap you. Worse,
poisonous gas begins seeping in." CR CR>
	               <COND (<IN? ,ROBOT ,HERE>
			      <MOVE ,ROBOT ,CAGE>
			      <FSET ,ROBOT ,NDESCBIT>)>
		       <GOTO ,CAGE>
	               <FSET ,CAGE-OBJECT ,NDESCBIT>
	               <FCLEAR ,CAGE-OBJECT ,INVISIBLE>
	               <ENABLE <QUEUE I-CAGE-DEATH 6>>
	               <MOVE ,CAGE-OBJECT ,HERE>)
		      (T
	               <FSET ,PALANTIR-1 ,INVISIBLE>
	               <REMOVE ,ROBOT>
	               <FSET ,PRSO ,INVISIBLE>
	               <MOVE ,CAGE-OBJECT ,DINGY-CLOSET>
	               <FCLEAR ,CAGE-OBJECT ,INVISIBLE>
	               <TELL
"As the robot touches the sphere, a solid steel cage falls from the ceiling,
trapping him. You can faintly hear his last words: " ,B-W-C>
		       <JIGS-UP "\"">)>)
	       (<VERB? LOOK-INSIDE>
		<PALANTIR-LOOK <COND (<EQUAL? ,PRSO ,PALANTIR-1> ,PALANTIR-2)
				     (<EQUAL? ,PRSO ,PALANTIR-2> ,PALANTIR-3)
				     (<EQUAL? ,PRSO ,PALANTIR-3> ,PALANTIR-1)
				     (T ,PALANTIR-4)>>)
	       (<VERB? EXAMINE>
		<TELL
"There is something misty in the sphere. Perhaps if you were to
look into it..." CR>)>>

<ROUTINE PALANTIR-LOOK (OBJ "AUX" RM L)
	 <COND (<EQUAL? .OBJ ,PALANTIR-4>
		<TELL
,STRANGE-VISION " a huge and fearful face which peers at you expectantly." CR>
		<RTRUE>)>
	 <SET RM <META-LOC .OBJ>>
	 <SET L <LOC .OBJ>>
	 <COND (<OR <NOT .L>
		    <NOT <LIT? .RM>>>
		<TELL ,ONLY-DARKNESS>)
	       (<NOT <IN? .L ,ROOMS>>
		<COND (<FSET? .L ,OPENBIT>
		       <TELL "You see the inside of a " D .L ,PERIOD-CR>)
		      (T
		       <TELL ,ONLY-DARKNESS>)>)
	       (T
		<COND (,DEAD
		       <TELL
"As you peer through the mist, a strangely colored vision of
a huge room takes shape">)
		      (T
		       <TELL
,STRANGE-VISION " of a distant room, which can be described clearly">)>
		<TELL "..." CR CR>
		<FSET .OBJ ,INVISIBLE>
		<GO&LOOK .RM>
		<COND (<EQUAL? ,HERE .RM>
		       <TELL
"An astonished adventurer is staring into a crystal sphere." CR>)>
		<FCLEAR .OBJ ,INVISIBLE>
		<COND (<NOT ,DEAD>
		       <TELL
"The vision fades, revealing only an ordinary crystal sphere." CR>)>)>
	 <RTRUE>>

<ROUTINE GO&LOOK (RM "AUX" OHERE OLIT (OSEEN <>))
	 <SET OHERE ,HERE>
	 <COND (<FSET? .OHERE ,TOUCHBIT>
		<SET OSEEN T>)>
	 <SET OLIT ,LIT>
	 <SETG HERE .RM>
	 <SETG LIT <LIT? .RM>>
	 <V-LOOK>
	 <COND (<NOT .OSEEN>
		<FCLEAR .OHERE ,TOUCHBIT>)>
	 <SETG HERE .OHERE>
	 <SETG LIT .OLIT>>

<ROOM DEAD-PALANTIR-1
	(IN ROOMS)
	(DESC "Room of Red Mist")
	(WEST TO DEAD-PALANTIR-2)
	(FLAGS RLANDBIT ONBIT)
	(GLOBAL GLOBAL-PALANTIR)
	(ACTION DEAD-PALANTIR-F)>

<ROOM DEAD-PALANTIR-2
	(IN ROOMS)
	(DESC "Room of Blue Mist")
	(WEST TO DEAD-PALANTIR-3)
	(FLAGS RLANDBIT ONBIT)
	(GLOBAL GLOBAL-PALANTIR)
	(ACTION DEAD-PALANTIR-F)>

<ROOM DEAD-PALANTIR-3
	(IN ROOMS)
	(DESC "Room of White Mist")
	(WEST TO DEAD-PALANTIR-4)
	(FLAGS RLANDBIT ONBIT)
	(GLOBAL GLOBAL-PALANTIR)
	(ACTION DEAD-PALANTIR-F)>

<ROOM DEAD-PALANTIR-4
	(IN ROOMS)
	(DESC "Room of Black Mist")
	(FLAGS RLANDBIT ONBIT)
	(ACTION DEAD-PALANTIR-F)>

<ROUTINE DEAD-PALANTIR-F (RARG "AUX" P)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL "You are in a huge crystalline sphere filled with thin ">
		<COND (<EQUAL? ,HERE ,DEAD-PALANTIR-1>
		       <SET P ,PALANTIR-1>
		       <TELL "red">)
		      (<EQUAL? ,HERE ,DEAD-PALANTIR-2>
		       <SET P ,PALANTIR-2>
		       <TELL "blue">)
		      (T
		       <SET P ,PALANTIR-3>
		       <TELL "white">)>
		<TELL " mist. The mist becomes ">
		<COND (<EQUAL? ,HERE ,DEAD-PALANTIR-1>
		       <TELL "blue">)
		      (<EQUAL? ,HERE ,DEAD-PALANTIR-2>
		       <TELL "white">)
		      (T
		       <TELL "black">)>
		<TELL
" to the west. You strain to look out through the mist..." CR CR>
		<COND (<FSET? .P ,TOUCHBIT>
		       <PALANTIR-LOOK .P>)
		      (<EQUAL? .P ,PALANTIR-1>
		       <TELL
"You see a small room with a sign, too blurry to read.">)
		      (<EQUAL? .P ,PALANTIR-2>
		       <TELL
"You see a dreary room with an oak door and a huge table. There
is an odd glow to the mist.">)
		      (<EQUAL? .P ,PALANTIR-3>
		       <TELL "A watery room is barely visible.">
		       <COND (<AND <IN? ,SERPENT ,AQUARIUM>
				   <PROB 25>>
			      <TELL " A shadow swims by as you look.">)>)>
		<CRLF>)
	       (<AND <EQUAL? .RARG ,M-ENTER>
		     <EQUAL? ,HERE ,DEAD-PALANTIR-4>>
		<COND (<IN? ,DEMON ,PENTAGRAM-ROOM>
		       <TELL
"The room is empty. A huge face looks down from outside and laughs
sardonically. It doesn't look like you're getting out of this predicament!" CR>
		       <FINISH>)>
		<TELL
"A huge and horrible face materializes out of the mist. \"">
		<COND (<NOT <L? ,DEATHS 3>>
		       <TELL
"You again! You'll obviously be no help to me.\" The face disappears
and everything goes black." CR>
		       <FINISH>)>
		<TELL
"Perhaps you may be of use in gaining my freedom from this place. I return
you to your foolish quest! Mayhap you will repay this favor in kind someday.\"
The mist swirls, and you are returned to the world of life." CR>
		<SETG DEAD <>>
		<GOTO ,INSIDE-THE-BARROW>)>>

<OBJECT GLOBAL-PALANTIR
	(IN LOCAL-GLOBALS)
	(DESC "sphere")
	(SYNONYM SPHERE)
	(ADJECTIVE RED BLUE WHITE CRYSTAL)
	(FLAGS NDESCBIT)
	(ACTION GLOBAL-PALANTIR-F)>

<ROUTINE GLOBAL-PALANTIR-F ()
	 <COND (<VERB? LOOK-INSIDE EXAMINE>
		<DEAD-PALANTIR-F ,M-LOOK>)
	       (<VERB? MUNG>
		<TELL "The sphere is unbreakable." CR>)>>