

	.FUNCT	WIZARD-F,RARG=M-OBJECT
	EQUAL?	WINNER,WIZARD /?PRG6
	CALL	HELLO?,WIZARD
	ZERO?	STACK /?CCL3
?PRG6:	PRINTR	"The Wizard seems surprised, much as you might be if a dog talked."
?CCL3:	EQUAL?	PRSA,V?GIVE \?CCL9
	EQUAL?	PRSI,WIZARD \?CCL9
	CALL	REMOVE-CAREFULLY,PRSO
	CALL	BOMB?,PRSO
	ZERO?	STACK /?PRG22
	IN?	DEMON,PENTAGRAM-ROOM \?CCL17
	MOVE	PRSO,HERE
	PRINTR	"The wizard accepts this final folly resignedly."
?CCL17:	REMOVE	WIZARD
	PRINT	WAVES-WAND
	PRINTR	"and says, ""Flower!"" Indeed, the bomb becomes a lovely bouquet. Both Wizard and flowers disappear."
?PRG22:	PRINTI	"He places the "
	PRINTD	PRSO
	PRINTI	" under his robe."
	CRLF	
	CALL	NOW-DARK?
	RSTACK	
?CCL9:	EQUAL?	PRSA,V?MUNG,V?ATTACK \FALSE
	REMOVE	WIZARD
	IN?	WAND,WIZARD \?CND26
	PRINT	WAVES-WAND
	PRINTI	"and chants, ""Freeze!"""
?CND26:	FSET?	DEMON,INVISIBLE /?CCL32
	PRINTR	" Nothing happens! Terrified, the wizard dashes from the room."
?CCL32:	SET	'SPELL?,S-FREEZE
	PUTP	ADVENTURER,P?ACTION,MAGIC-ACTOR
	CALL	QUEUE,I-WIZARD,10
	PUT	STACK,0,1
	PRINTR	" You suddenly cannot move."


	.FUNCT	I-WIZARD,CAST-PROB,PCNT=0,F,WLOC
	LOC	WINNER >WLOC
	CALL	QUEUE,I-WIZARD,4
	PUT	STACK,0,1
	ZERO?	DEAD \FALSE
	ZERO?	SPELL? /?CND1
	EQUAL?	SPELL?,S-FLOAT \?CCL7
	EQUAL?	HERE,TOP-OF-WELL \?CCL10
	CALL	JIGS-UP,STR?52
	RTRUE	
?CCL10:	FSET?	HERE,NONLANDBIT \?CND5
	EQUAL?	HERE,CIRCULAR-ROOM,VOLCANO-BOTTOM /?CND5
	CALL	JIGS-UP,STR?53
	RTRUE	
?CCL7:	EQUAL?	SPELL?,S-FEEBLE \?CCL15
	SET	'LOAD-ALLOWED,100
	JUMP	?CND5
?CCL15:	EQUAL?	SPELL?,S-FUMBLE \?CND5
	SET	'FUMBLE-NUMBER,7
	SET	'FUMBLE-PROB,8
?CND5:	GET	SPELL-STOPS,SPELL?
	ZERO?	STACK /?CND17
	GET	SPELL-STOPS,SPELL?
	PRINT	STACK
	CRLF	
?CND17:	PUTP	ADVENTURER,P?ACTION,0
	SET	'SPELL?,FALSE-VALUE
	RTRUE	
?CND1:	IN?	DEMON,PENTAGRAM-ROOM \?CND21
	CALL	INT,I-WIZARD
	PUT	STACK,0,0
	IN?	WIZARD,PENTAGRAM-ROOM /TRUE
	MOVE	WIZARD,PENTAGRAM-ROOM
	IN?	WINNER,PENTAGRAM-ROOM \TRUE
	PRINTR	"The Wizard appears, astonished to see his servant conversing with a common adventurer! He waves his wand frantically. ""Frobizz! Frobozzle! Frobnoid!"" The demon guffaws. ""You no longer control the Black Crystal, hedge-wizard! Your wand is powerless! Your doom is sealed!"" The demon turns to you, expectantly."
?CND21:	ZERO?	LIT \?CND29
	ZERO?	LAMP-BURNED-OUT /?CND29
	GRTR?	SCORE,200 \?CND29
	SET	'ALWAYS-LIT,TRUE-VALUE
	SET	'LIT,TRUE-VALUE
	PRINTR	"You hear the Wizard. ""Dear me, you're in a Fix."" Chuckling, he incants, ""Fluoresce!"" It is no longer dark."
?CND29:	LOC	WIZARD
	ZERO?	STACK /?CND36
	RANDOM	100
	GRTR?	80,STACK \?CND36
	ZERO?	LIT /?CND40
	IN?	WIZARD,HERE \?CND40
	PRINTI	"The Wizard vanishes."
	CRLF	
?CND40:	REMOVE	WIZARD
	RTRUE	
?CND36:	RANDOM	100
	GRTR?	10,STACK \FALSE
	EQUAL?	HERE,POSTS-ROOM,POOL-ROOM /FALSE
	ZERO?	LIT \?CCL53
	PRINT	MOVED-IN-DARK
	JUMP	?CND51
?CCL53:	FSET?	HERE,NONLANDBIT \?PRG60
	PRINTI	"The Wizard appears, floating nonchalantly in the air beside you."
	CRLF	
	JUMP	?CND51
?PRG60:	PRINTI	"An old, robed man appears suddenly. He is wearing a pointed hat with astrological signs, and has a long, unkempt beard."
	CRLF	
?CND51:	IN?	PALANTIR-4,ADVENTURER \?CCL64
	REMOVE	WIZARD
	ZERO?	LIT /?PRG70
	PRINTR	"The Wizard notices the Black Crystal, and hastily vanishes."
?PRG70:	PRINT	MOVED-IN-DARK
	RTRUE	
?CCL64:	RANDOM	100
	GRTR?	20,STACK \?CND62
	REMOVE	WIZARD
	ZERO?	LIT /?PRG78
	PRINTR	"He mutters something (muffled by his beard) and disappears as suddenly as he came."
?PRG78:	PRINTR	"You hear low, confused muttering."
?CND62:	IN?	PALANTIR-1,ADVENTURER \?CND80
	INC	'PCNT
?CND80:	IN?	PALANTIR-2,ADVENTURER \?CND82
	INC	'PCNT
?CND82:	IN?	PALANTIR-3,ADVENTURER \?CND84
	INC	'PCNT
?CND84:	MUL	PCNT,20
	SUB	80,STACK >CAST-PROB
	ZERO?	LIT /?PRG91
	PRINTI	"The Wizard draws forth his wand and waves it in your direction. It begins to glow with a faint blue glow."
	CRLF	
	JUMP	?CND86
?PRG91:	PRINTI	"You spot the Wizard, illuminated by the faint blue glow of a magic wand, pointed at you!"
	CRLF	
?CND86:	RANDOM	100
	GRTR?	CAST-PROB,STACK \?CCL95
	MOVE	WIZARD,HERE
	RANDOM	SPELLS >SPELL?
	PUTP	ADVENTURER,P?ACTION,MAGIC-ACTOR
	MUL	5,PCNT
	SUB	30,STACK
	RANDOM	STACK
	ADD	5,STACK
	CALL	QUEUE,I-WIZARD,STACK
	PUT	STACK,0,1
	RANDOM	100
	GRTR?	75,STACK \?PRG101
	PRINTI	"The Wizard, in a deep and resonant voice, speaks the word """
	GET	SPELL-NAMES,SPELL?
	PRINT	STACK
	PRINTI	"!"" He then vanishes, cackling gleefully."
	CRLF	
	JUMP	?CND96
?PRG101:	PRINTI	"The Wizard whispers a word beginning with ""F,"" and disappears."
	CRLF	
?CND96:	REMOVE	WIZARD
	GET	SPELL-HINTS,SPELL?
	ZERO?	STACK /?CND103
	GET	SPELL-HINTS,SPELL?
	PRINT	STACK
	CRLF	
?CND103:	EQUAL?	SPELL?,S-FALL \?CCL109
	FSET?	WLOC,VEHBIT \TRUE
	PRINTI	"You suddenly fall out of the "
	PRINTD	WLOC
	PRINT	INVISIBLE-HAND
	EQUAL?	HERE,TOP-OF-WELL \?CCL116
	CALL	JIGS-UP,STR?52
	RTRUE	
?CCL116:	FSET?	HERE,NONLANDBIT \?CCL118
	EQUAL?	HERE,VOLCANO-BOTTOM,CIRCULAR-ROOM /?CCL118
	CALL	JIGS-UP,STR?53
	RTRUE	
?CCL118:	MOVE	WINNER,HERE
	RTRUE	
?CCL109:	EQUAL?	SPELL?,S-FLOAT \?CCL122
	PRINTI	"You slowly rise into the air"
	FSET?	WLOC,VEHBIT \?PRG129
	MOVE	WINNER,HERE
	PRINTI	", leaving the "
	PRINTD	WLOC
?PRG129:	PRINTR	", stopping about five feet up."
?CCL122:	EQUAL?	SPELL?,S-FEEBLE \?CCL132
	SET	'LOAD-ALLOWED,50
	FIRST?	WINNER >F \TRUE
	PRINTI	"You feel so weak, you drop the "
	PRINTD	F
	PRINT	PERIOD-CR
	MOVE	F,WLOC
	RTRUE	
?CCL132:	EQUAL?	SPELL?,S-FUMBLE \TRUE
	SET	'FUMBLE-NUMBER,3
	SET	'FUMBLE-PROB,25
	FIRST?	ADVENTURER >F \TRUE
	PRINTI	"Oops! You dropped the "
	PRINTD	F
	PRINT	PERIOD-CR
	MOVE	F,WLOC
	RTRUE	
?CCL95:	RANDOM	100
	GRTR?	50,STACK \?CCL143
	REMOVE	WIZARD
	PRINTR	"There is a crackling noise. Blue smoke curls from the Wizard's sleeve. He sighs and disappears."
?CCL143:	RANDOM	100
	GRTR?	50,STACK \?CCL147
	REMOVE	WIZARD
	PRINTI	"The Wizard incants """
	CALL	RANDOM-ELEMENT,SPELL-NAMES
	PRINT	STACK
	PRINTR	"!"" but nothing happens. With an embarrassed glance in your direction, he vanishes."
?CCL147:	MOVE	WIZARD,HERE
	PRINTR	"The Wizard seems about to say something, but thinks better of it, and peers at you from under his bushy eyebrows."


	.FUNCT	MAGIC-ACTOR,V
	ZERO?	SPELL? /FALSE
	EQUAL?	SPELL?,S-FALL \?CCL6
	EQUAL?	PRSA,V?CLIMB-DOWN,V?CLIMB /?CTR8
	EQUAL?	PRSA,V?WALK \?CCL9
	GETPT	HERE,P?DOWN
	ZERO?	STACK /?CCL9
?CTR8:	GETPT	HERE,P?GLOBAL >V
	PTSIZE	V
	CALL	ZMEMQB,BRIDGE,V,STACK
	ZERO?	STACK /?PRG17
	CALL	JIGS-UP,STR?54
	RSTACK	
?PRG17:	PRINTI	"You trip on your own feet, "
	RANDOM	100
	GRTR?	25,STACK \?PRG22
	CALL	JIGS-UP,STR?55
	RSTACK	
?PRG22:	PRINTR	"but regain your balance and avoid a fatal fall."
?CCL9:	EQUAL?	PRSA,V?ENTER \FALSE
	PRINTI	"You get in the "
	PRINTD	PRSO
	PRINTI	" but you fall out again"
	PRINT	INVISIBLE-HAND
	RTRUE	
?CCL6:	EQUAL?	SPELL?,S-FLOAT \?CCL29
	EQUAL?	PRSA,V?WAIT,V?DIAGNOSE /FALSE
	EQUAL?	PRSA,V?WALK \?CCL34
	PRINTR	"Your feet are nowhere near the ground."
?CCL34:	EQUAL?	PRSA,V?DROP \?CCL38
	MOVE	PRSO,HERE
	PRINTI	"The "
	PRINTD	PRSO
	PRINTR	" drops to the ground."
?CCL38:	EQUAL?	PRSA,V?TAKE \FALSE
	IN?	PRSO,HERE \FALSE
	PRINTR	"You're floating and can't reach it."
?CCL29:	EQUAL?	SPELL?,S-FREEZE \?CCL48
	EQUAL?	PRSA,V?WAIT,V?DIAGNOSE /FALSE
	PRINTR	"You are frozen solid. You might as well wait it out, because you can't do anything else in this state."
?CCL48:	EQUAL?	SPELL?,S-FENCE \?CCL55
	EQUAL?	PRSA,V?WALK \?CCL55
	PRINTR	"An invisible force bars your way."
?CCL55:	EQUAL?	SPELL?,S-FERMENT \FALSE
	EQUAL?	PRSA,V?WALK \FALSE
	IN?	WINNER,HERE \FALSE
	PRINTI	"Oops, you seem a little unsteady... I'm not sure you got where you intended going."
	CRLF	
	CRLF	
	CALL	RANDOM-WALK
	RSTACK	


	.FUNCT	RANDOM-WALK,P,TX,L,S,D=0
	SET	'P,0
?PRG1:	NEXTP	HERE,P >P
	LESS?	P,LOW-DIRECTION \?CCL5
	ZERO?	D /TRUE
	SET	'S,SPELL?
	SET	'SPELL?,FALSE-VALUE
	SET	'WINNER,ADVENTURER
	MOVE	WINNER,HERE
	CALL	DO-WALK,D
	SET	'SPELL?,S
	RTRUE	
?CCL5:	GETPT	HERE,P >TX
	PTSIZE	TX >L
	EQUAL?	L,UEXIT /?CCL9
	EQUAL?	L,CEXIT \?PRD12
	GETB	TX,CEXITFLAG
	VALUE	STACK
	ZERO?	STACK \?CCL9
?PRD12:	EQUAL?	L,DEXIT \?PRG1
	GETB	TX,DEXITOBJ
	FSET?	STACK,OPENBIT \?PRG1
?CCL9:	ZERO?	D \?CCL19
	SET	'D,P
	JUMP	?PRG1
?CCL19:	RANDOM	100
	GRTR?	50,STACK \?PRG1
	SET	'D,P
	JUMP	?PRG1


	.FUNCT	WAND-F
	EQUAL?	PRSA,V?GIVE,V?PUT,V?TAKE \?CCL3
	IN?	WAND,WIZARD \?CCL3
	PRINTR	"The Wizard snatches it away."
?CCL3:	EQUAL?	PRSA,V?WAVE \?CCL9
	EQUAL?	PRSI,GRUE \?CCL9
	PRINTR	"A gurgling hiss issues from the darkness."
?CCL9:	EQUAL?	PRSA,V?RAISE,V?RUB,V?WAVE \FALSE
	EQUAL?	PRSO,WAND \?CCL18
	IN?	WAND,WINNER /?CCL18
	PRINTR	"You don't have the wand!"
?CCL18:	ZERO?	WAND-ON \?PRG28
	ZERO?	SPELL-USED \?PRG28
	ZERO?	SPELL-VICTIM /?CCL24
?PRG28:	PRINTR	"A magic wand must recharge after use!"
?CCL24:	EQUAL?	PRSA,V?WAVE \?CCL31
	EQUAL?	PRSO,WAND \?PRG37
	ZERO?	PRSI /?PRG37
	SET	'WAND-ON,PRSI
	SET	'WAND-ON-LOC,HERE
	JUMP	?CND16
?PRG37:	PRINTR	"At what?"
?CCL31:	EQUAL?	PRSA,V?RUB \?CCL40
	EQUAL?	PRSI,WAND \?PRG44
	SET	'WAND-ON,PRSO
?CND16:	ZERO?	WAND-ON /TRUE
	SET	'SPELL-USED,FALSE-VALUE
	SET	'SPELL-VICTIM,FALSE-VALUE
	EQUAL?	WAND-ON,ME,WAND \?PRG56
	SET	'WAND-ON,FALSE-VALUE
	PRINTI	"A safety interlock prevents this."
	CRLF	
	JUMP	?CND51
?PRG44:	PRINTR	"Touch what?"
?CCL40:	EQUAL?	PRSA,V?RAISE \?CND16
	PRINTR	"The wand grows warm and seems to vibrate."
?PRG56:	PRINTI	"The wand grows warm, the "
	PRINTD	WAND-ON
	PRINTI	" glows with magical essences, and you feel suffused with power."
	CRLF	
?CND51:	CALL	QUEUE,I-WAND,2
	PUT	STACK,0,1
	RTRUE	


	.FUNCT	I-WAND
	ZERO?	WAND-ON /?CCL3
	EQUAL?	WAND-ON-LOC,HERE /?CTR2
	IN?	WAND-ON,WINNER \?CCL3
?CTR2:	SET	'WAND-ON,FALSE-VALUE
	PRINTI	"The "
	PRINTD	WAND-ON
	PRINTR	" stops glowing and the power within you weakens."
?CCL3:	SET	'WAND-ON,FALSE-VALUE
	RFALSE	


	.FUNCT	GUARDED-ROOM-F,RARG
	EQUAL?	RARG,M-LOOK \FALSE
	PRINTI	"This room is cobwebby and musty, but tracks in the dust indicate recent visitors. To the south is a"
	FSET?	WIZ-DOOR,OPENBIT \?PRG11
	PRINTI	"n open"
	JUMP	?PRG13
?PRG11:	PRINTI	"battered (but very strong-looking)"
?PRG13:	PRINTI	" door. Mounted on the door is a "
	ZERO?	GUARDIAN-FED \?PRG20
	PRINTI	"nast"
	JUMP	?PRG22
?PRG20:	PRINTI	"sleep"
?PRG22:	PRINTI	"y-looking lizard head, with sharp teeth and beady eyes. "
	IN?	CANDY,WINNER \?CCL26
	PRINTI	"The lizard is sniffing at you. "
	JUMP	?PRG32
?CCL26:	ZERO?	GUARDIAN-FED \?PRG32
	PRINTI	"The eyes follow your approach. "
?PRG32:	PRINTR	"To the north and northeast, corridors exit."


	.FUNCT	WIZ-DOOR-F
	ZERO?	GUARDIAN-FED \?CCL3
	EQUAL?	PRSA,V?UNLOCK,V?OPEN \?CCL3
	PRINTR	"The lizard snaps at you as you reach for the door."
?CCL3:	EQUAL?	PRSA,V?UNLOCK \?CCL9
	ZERO?	WIZ-DOOR-FLAG /?CCL12
	PRINT	ALREADY
	RTRUE	
?CCL12:	EQUAL?	PRSI,GOLD-KEY \?PRG19
	SET	'WIZ-DOOR-FLAG,TRUE-VALUE
	PRINTR	"The door is unlocked."
?PRG19:	PRINT	DOESNT-FIT-LOCK
	RTRUE	
?CCL9:	EQUAL?	PRSA,V?LOCK \?CCL22
	ZERO?	WIZ-DOOR-FLAG \?CCL25
	PRINT	ALREADY
	RTRUE	
?CCL25:	EQUAL?	PRSI,GOLD-KEY \?PRG32
	SET	'WIZ-DOOR-FLAG,FALSE-VALUE
	PRINTR	"The door is now locked."
?PRG32:	PRINT	DOESNT-FIT-LOCK
	RTRUE	
?CCL22:	EQUAL?	PRSA,V?CLOSE,V?OPEN \FALSE
	ZERO?	WIZ-DOOR-FLAG /?CCL38
	CALL	OPEN-CLOSE
	RSTACK	
?CCL38:	EQUAL?	PRSA,V?OPEN \FALSE
	PRINTR	"The door is locked!"


	.FUNCT	DOOR-KEEPER-F
	EQUAL?	PRSA,V?ALARM \?CCL3
	ZERO?	GUARDIAN-FED /?CCL3
	PRINTR	"You can't wake it."
?CCL3:	EQUAL?	PRSA,V?GIVE \?CCL9
	EQUAL?	PRSI,DOOR-KEEPER \?CCL9
	ZERO?	GUARDIAN-FED /?CCL14
	PRINTR	"You can't wake it."
?CCL14:	EQUAL?	PRSO,CANDY \?CCL18
	SET	'GUARDIAN-FED,TRUE-VALUE
	REMOVE	CANDY
	PRINT	GREEDILY-DEVOURS
	PRINTR	"the candy, package and all, and then its eyes close. (Lizards are known to sleep a long time while digesting meals.)"
?CCL18:	CALL	BOMB?,PRSO
	ZERO?	STACK /?CCL22
	REMOVE	PRSO
	PRINT	GREEDILY-DEVOURS
	PRINTR	"it. After a while, you hear a pop and the guardian's eyes bulge out. It hisses angrily."
?CCL22:	EQUAL?	PRSO,PALANTIR-1,PALANTIR-2,PALANTIR-3 \?CCL26
	MOVE	PRSO,HERE
	PRINT	GREEDILY-DEVOURS
	PRINTR	"the sphere but then spits it out."
?CCL26:	REMOVE	PRSO
	PRINT	GREEDILY-DEVOURS
	PRINTI	"the "
	PRINTD	PRSO
	PRINT	PERIOD-CR
	RTRUE	
?CCL9:	EQUAL?	PRSA,V?MUNG,V?ATTACK \FALSE
	PRINTR	"The guardian seems impervious."


	.FUNCT	TROPHY-ROOM-F,RARG
	EQUAL?	RARG,M-LOOK \FALSE
	PRINTI	"The Wizard's trophy room is filled with various memorabilia. On one wall is the Wizard's D. T. (Doctor of Thaumaturgy) degree from GUE Tech. Several old magic wands are mounted on a wand rack. There is a stuffed owl on a perch. Corridors lead east and west; a door to the north is "
	FSET?	WIZ-DOOR,OPENBIT \?PRG11
	PRINTI	"open"
	JUMP	?PRG13
?PRG11:	PRINTI	"closed"
?PRG13:	PRINT	PERIOD-CR
	RTRUE	


	.FUNCT	TROPHY-PSEUDO
	EQUAL?	PRSA,V?RUB,V?TAKE \FALSE
	PRINTR	"As you near it, you get a nasty (but fortunately unfatal) shock."


	.FUNCT	STAND-F
	EQUAL?	PRSA,V?TAKE \?CCL3
	PRINTI	"The "
	PRINTD	PRSO
	PRINTR	" is firmly attached to the bench."
?CCL3:	EQUAL?	PRSA,V?PUT-ON,V?PUT \FALSE
	EQUAL?	PRSO,PALANTIR-1,PALANTIR-2,PALANTIR-3 \FALSE
	EQUAL?	PRSI,STAND-1,STAND-2,STAND-3 \FALSE
	CALL	V-PUT
	IN?	PALANTIR-1,STAND-1 \TRUE
	IN?	PALANTIR-2,STAND-2 \TRUE
	IN?	PALANTIR-3,STAND-3 \TRUE
	REMOVE	PALANTIR-1
	REMOVE	PALANTIR-2
	REMOVE	PALANTIR-3
	MOVE	STAND-4,WORKBENCH
	PRINTR	"Instantly, a hum begins, and the hairs on the back of your neck stand up. Suddenly, the spheres are gone! But amidst the three empty stands, there is now a black stand of obsidian in which rests a strange black sphere."


	.FUNCT	PENTAGRAM-F,RARG=M-BEG
	EQUAL?	RARG,M-BEG \FALSE
	EQUAL?	PRSA,V?ENTER \?CCL6
	PRINTR	"You are forced back by an invisible power."
?CCL6:	EQUAL?	PRSA,V?PUT-ON,V?PUT \FALSE
	EQUAL?	PRSO,PALANTIR-4 \FALSE
	REMOVE	PALANTIR-4
	FCLEAR	DEMON,INVISIBLE
	MOVE	DEMON,PENTAGRAM-ROOM
	PRINTR	"A chill wind blasts from the pentagram as a dim shape appears and resolves into a formidable-looking demon. He tests the walls of the pentagram experimentally, then sees you! ""Greetings, oh new master! Wouldst desire a service? For a pittance of wealth, I will gratify thy desires to the utmost limit of my powers!"" He grins vilely."


	.FUNCT	DEMON-F,RARG=M-OBJECT,V
	EQUAL?	PRSA,V?HELLO \?CCL3
	PRINTR	"The genie grins demonically."
?CCL3:	EQUAL?	WINNER,DEMON \?CCL7
	ZERO?	DEMON-PAID \?CCL10
	PRINTI	"""My fee is not paid! I perform no tasks for free! We demons have a strong union these days."""
	CRLF	
	RETURN	2
?CCL10:	EQUAL?	PRSA,V?SGIVE /FALSE
	GET	P-PRSO,0
	GRTR?	STACK,1 /?PRG21
	GET	P-PRSI,0
	GRTR?	STACK,1 \?CCL18
?PRG21:	PRINTI	"""I will do one thing only, master!"""
	CRLF	
	RETURN	2
?CCL18:	EQUAL?	PRSA,V?MOVE \?CCL26
	EQUAL?	PRSO,GLOBAL-MENHIR \?CCL26
	SET	'MENHIR-POSITION,1
	PRINT	DEMON-GONE
	PRINTI	"""A trifle... My little finger alone was enough."""
	CRLF	
	CALL	DEMON-LEAVES
	RSTACK	
?CCL26:	EQUAL?	PRSA,V?TAKE \?CCL32
	EQUAL?	PRSO,GLOBAL-MENHIR \?CCL35
	REMOVE	MENHIR
	SET	'MENHIR-POSITION,2
	PRINT	DEMON-GONE
	PRINTI	"""Perhaps I can use it as a toothpick..."""
	CRLF	
	CALL	DEMON-LEAVES
	RSTACK	
?CCL35:	EQUAL?	PRSO,WAND \?CCL39
	REMOVE	WAND
	PRINTI	"""Gladly, oh fool!"" Cackling, the demon snatches the wand and points it at himself. ""Free!"" he commands, as the demon and wand vanish forever."
	CRLF	
	CALL	DEMON-LEAVES,FALSE-VALUE
	RSTACK	
?CCL39:	FSET?	PRSO,TAKEBIT \?PRG46
	CALL	DEMON-LEAVES,FALSE-VALUE
	REMOVE	PRSO
	PRINTI	"The demon snaps his fingers; the "
	PRINTD	PRSO
	PRINTR	" and he both depart."
?PRG46:	PRINTR	"""I fear that I cannot take that."""
?CCL32:	EQUAL?	PRSA,V?GIVE \?CCL49
	EQUAL?	PRSI,ME \?CCL49
	EQUAL?	PRSO,WAND \?CCL54
	REMOVE	WIZARD
	CALL	DEMON-LEAVES,FALSE-VALUE
	FCLEAR	WAND,NDESCBIT
	MOVE	WAND,HERE
	PRINTR	"""I hear and obey!"" says the demon. The Wizard cries ""Fudge!"" but aside from a strong odor of chocolate, there is no effect. The demon plucks the wand out of his hand and lays it before you. He vanishes as the wizard runs from the room in terror."
?CCL54:	EQUAL?	PRSO,GLOBAL-MENHIR \?CCL58
	MOVE	MENHIR,PENTAGRAM-ROOM
	FCLEAR	MENHIR,NDESCBIT
	FCLEAR	MENHIR,TAKEBIT
	SET	'MENHIR-POSITION,3
	PRINTI	"He gestures, and the menhir appears at your feet."
	CRLF	
	CALL	DEMON-LEAVES
	RSTACK	
?CCL58:	FSET?	PRSO,TAKEBIT \?PRG65
	MOVE	PRSO,PENTAGRAM-ROOM
	PRINTI	"The "
	PRINTD	PRSO
	PRINTI	" appears before you and settles to the ground."
	CRLF	
	CALL	DEMON-LEAVES
	RSTACK	
?PRG65:	PRINTR	"""If only it were possible..."""
?CCL49:	EQUAL?	PRSA,V?ATTACK \?CCL68
	EQUAL?	PRSO,GLOBAL-CERBERUS \?CCL71
	PRINTI	"""This may prove taxing..."" "
	PRINT	DEMON-GONE
	PRINTR	"He looks rather gnawed and scratched. He winces. ""Never did like dogs anyway... Any other orders, oh beneficent one?"""
?CCL71:	EQUAL?	PRSO,WIZARD \?CCL75
	REMOVE	WIZARD
	FCLEAR	WAND,NDESCBIT
	MOVE	WAND,HERE
	PRINTI	"The demon grins hideously. ""This has been my desire e'er since this charlatan bent me to his service!"" "
	PRINT	WAVES-WAND
	PRINTI	"fruitlessly as the demon forms himself into a smoky cloud which envelops the Wizard. A horrible scream is heard, and the smoke clears, leaving no trace of the Wizard but his wand."
	CRLF	
	CALL	DEMON-LEAVES
	RSTACK	
?CCL75:	EQUAL?	PRSO,ME \?PRG80
	CALL	DEMON-LEAVES,FALSE-VALUE
	SET	'WINNER,ADVENTURER
	CALL	JIGS-UP,STR?85
	RSTACK	
?PRG80:	PRINTI	"""I know no way to kill a "
	PRINTD	PRSO
	PRINTR	"."""
?CCL68:	EQUAL?	PRSA,V?EXAMINE,V?FIND \?PRG95
	PRINTI	"""I am not permitted to "
	EQUAL?	PRSA,V?FIND \?PRG91
	PRINTI	"answer questions"
	JUMP	?PRG93
?PRG91:	PRINTI	"perform such menial tasks"
?PRG93:	PRINTR	". The terms of my contract are explicit, and the penalty clauses are ... hmm ... devilish."""
?PRG95:	PRINTR	"""Apologies, oh master, but even for such a one as I this is not possible."" He seems chagrined to have to admit this."
?CCL7:	EQUAL?	PRSA,V?MUNG,V?ATTACK \?CCL98
	PRINTR	"The demon laughs uproariously."
?CCL98:	EQUAL?	PRSA,V?GIVE \FALSE
	EQUAL?	PRSI,DEMON \FALSE
	GETPT	PRSO,P?VALUE
	ZERO?	STACK /?CCL107
	EQUAL?	PRSO,SWORD /?CCL107
	CALL	REMOVE-CAREFULLY,PRSO
	INC	'DEMON-HOARD
	ADD	SCORE,2 >SCORE
	LESS?	DEMON-HOARD,TREASURES-MAX /?PRG115
	SET	'DEMON-PAID,TRUE-VALUE
	PUTP	WIZARD,P?LDESC,STR?86
	PRINTR	"""This paltry hoard will suffice for my fee."""
?PRG115:	PRINTC	34
	GET	DEMON-THANKS,DEMON-HOARD
	PRINT	STACK
	PRINTC	34
	CRLF	
	EQUAL?	DEMON-HOARD,8 \TRUE
	PRINTR	"The Wizard tears his bears and looks at you as if you are a madman."
?CCL107:	CALL	BOMB?,PRSO
	ZERO?	STACK /?CCL122
	CALL	DEMON-LEAVES,FALSE-VALUE
	PRINTR	"""This violates my contract, oh fool. Thus, I am free to depart."""
?CCL122:	CALL	REMOVE-CAREFULLY,PRSO
	PRINTI	"The demon takes the "
	PRINTD	PRSO
	PRINTR	" and smiles balefully, revealing enormous fangs."


	.FUNCT	DEMON-LEAVES,NOISY?=1
	FSET	DEMON,INVISIBLE
	ZERO?	NOISY? /?CND1
	PRINTI	"The genie departs, his agreement fulfilled."
	CRLF	
?CND1:	SET	'P-CONT,FALSE-VALUE
	RETURN	2


	.FUNCT	AQUARIUM-F,OBJ
	EQUAL?	PRSA,V?ENTER \?CCL3
	CALL	DO-WALK,P?IN
	RSTACK	
?CCL3:	EQUAL?	PRSA,V?LOOK-INSIDE \?CCL5
	IN?	SERPENT,AQUARIUM \?CCL5
	PRINTR	"A baby serpent in the aquarium eyes you suspiciously."
?CCL5:	EQUAL?	PRSA,V?ATTACK,V?MUNG \?PRD13
	EQUAL?	PRSO,AQUARIUM /?CCL11
?PRD13:	EQUAL?	PRSA,V?THROW \FALSE
	EQUAL?	PRSI,AQUARIUM \FALSE
?CCL11:	EQUAL?	PRSO,AQUARIUM \?CCL20
	ZERO?	PRSI /FALSE
	SET	'OBJ,PRSI
	JUMP	?CND18
?CCL20:	SET	'OBJ,PRSO
?CND18:	MOVE	OBJ,HERE
	IN?	DEAD-SERPENT,HERE \?CCL26
	PRINTR	"The aquarium is already broken!"
?CCL26:	CALL	BOMB?,OBJ
	ZERO?	STACK /?CCL30
	CALL	INT,I-FUSE
	PUT	STACK,0,0
	RTRUE	
?CCL30:	FSET?	OBJ,WEAPONBIT /?CTR31
	GETP	OBJ,P?SIZE
	GRTR?	STACK,10 \?PRG42
?CTR31:	REMOVE	SERPENT
	MOVE	DEAD-SERPENT,HERE
	MOVE	PALANTIR-3,AQUARIUM
	FCLEAR	PALANTIR-3,NDESCBIT
	PUTP	AQUARIUM,P?LDESC,STR?95
	PRINTI	"The "
	PRINTD	OBJ
	PRINTI	" shatters the aquarium, spilling salt water, wet sand, and an extremely annoyed sea serpent. He is having difficulty breathing, and he seems to hold you responsible. He "
	EQUAL?	PRSA,V?MUNG \?PRG40
	CALL	JIGS-UP,STR?96
	RSTACK	
?PRG40:	PRINTR	"slithers toward you, but expires mere inches away. A clear crystal sphere sits amid the sand and broken glass in the aquarium."
?PRG42:	PRINTI	"The "
	PRINTD	OBJ
	PRINTR	" bounces harmlessly off the glass."


	.FUNCT	SERPENT-F
	EQUAL?	SERPENT,WINNER \?CCL3
	PRINTR	"The serpent only stares hungrily at you."
?CCL3:	EQUAL?	PRSA,V?MUNG,V?ATTACK \?CCL7
	PRINTR	"He swims towards you, his dagger-like teeth dripping. Fortunately, he doesn't want to crash into the aquarium wall, and contents himself with splashing you with water."
?CCL7:	EQUAL?	PRSA,V?PUT \?CCL11
	EQUAL?	PRSO,SERPENT \?CCL11
	PRINTR	"Impossible!"
?CCL11:	EQUAL?	PRSA,V?GIVE,V?TAKE \FALSE
	CALL	JIGS-UP,STR?98
	RSTACK	


	.FUNCT	DEAD-SERPENT-F
	EQUAL?	PRSA,V?TAKE \FALSE
	PRINTR	"This may be a baby, but it's as big as a whale."


	.FUNCT	MURKY-ROOM-F,RARG
	EQUAL?	RARG,M-LOOK \?CCL3
	PRINTI	" The floor is sandy, and your vision seems blurred."
	IN?	SERPENT,AQUARIUM \?CND6
	RANDOM	100
	GRTR?	20,STACK \?CND6
	PRINTR	" A shadow seems to swim by overhead."
?CND6:	CRLF	
	RTRUE	
?CCL3:	EQUAL?	RARG,M-ENTER \FALSE
	IN?	SERPENT,AQUARIUM \?CCL16
	CALL	JIGS-UP,STR?99
	RSTACK	
?CCL16:	CALL	JIGS-UP,STR?100
	RSTACK	


	.FUNCT	WIZARD-QUARTERS-F,RARG,PICK,L
	EQUAL?	RARG,M-LOOK,M-FLASH \FALSE
	PRINTI	"This is where the Wizard of Frobozz lives. The room is "
	CALL	PICK-ONE,WIZQDESCS
	PRINT	STACK
	PRINT	PERIOD-CR
	RTRUE	


	.FUNCT	SPHERE-F
	EQUAL?	PRSA,V?PUT,V?MOVE,V?TAKE \?CCL3
	EQUAL?	PRSO,PALANTIR-1 \?CCL3
	ZERO?	CAGE-SOLVE-FLAG \?CCL3
	EQUAL?	ADVENTURER,WINNER \?CCL9
	PRINTI	"As you reach for the sphere, a solid steel cage falls to entrap you. Worse, poisonous gas begins seeping in."
	CRLF	
	CRLF	
	IN?	ROBOT,HERE \?CND12
	MOVE	ROBOT,CAGE
	FSET	ROBOT,NDESCBIT
?CND12:	CALL	GOTO,CAGE
	FSET	CAGE-OBJECT,NDESCBIT
	FCLEAR	CAGE-OBJECT,INVISIBLE
	CALL	QUEUE,I-CAGE-DEATH,6
	PUT	STACK,0,1
	MOVE	CAGE-OBJECT,HERE
	RTRUE	
?CCL9:	FSET	PALANTIR-1,INVISIBLE
	REMOVE	ROBOT
	FSET	PRSO,INVISIBLE
	MOVE	CAGE-OBJECT,DINGY-CLOSET
	FCLEAR	CAGE-OBJECT,INVISIBLE
	PRINTI	"As the robot touches the sphere, a solid steel cage falls from the ceiling, trapping him. You can faintly hear his last words: "
	PRINT	B-W-C
	CALL	JIGS-UP,STR?109
	RSTACK	
?CCL3:	EQUAL?	PRSA,V?LOOK-INSIDE \?CCL17
	EQUAL?	PRSO,PALANTIR-1 \?CCL20
	PUSH	PALANTIR-2
	JUMP	?CND18
?CCL20:	EQUAL?	PRSO,PALANTIR-2 \?CCL22
	PUSH	PALANTIR-3
	JUMP	?CND18
?CCL22:	EQUAL?	PRSO,PALANTIR-3 \?CCL24
	PUSH	PALANTIR-1
	JUMP	?CND18
?CCL24:	PUSH	PALANTIR-4
?CND18:	CALL	PALANTIR-LOOK,STACK
	RSTACK	
?CCL17:	EQUAL?	PRSA,V?EXAMINE \FALSE
	PRINTR	"There is something misty in the sphere. Perhaps if you were to look into it..."


	.FUNCT	PALANTIR-LOOK,OBJ,RM,L
	EQUAL?	OBJ,PALANTIR-4 \?CND1
	PRINT	STRANGE-VISION
	PRINTR	" a huge and fearful face which peers at you expectantly."
?CND1:	CALL	META-LOC,OBJ >RM
	LOC	OBJ >L
	ZERO?	L /?PRG10
	CALL	LIT?,RM
	ZERO?	STACK \?CCL7
?PRG10:	PRINT	ONLY-DARKNESS
	RTRUE	
?CCL7:	IN?	L,ROOMS /?CCL13
	FSET?	L,OPENBIT \?PRG19
	PRINTI	"You see the inside of a "
	PRINTD	L
	PRINT	PERIOD-CR
	RTRUE	
?PRG19:	PRINT	ONLY-DARKNESS
	RTRUE	
?CCL13:	ZERO?	DEAD /?PRG26
	PRINTI	"As you peer through the mist, a strangely colored vision of a huge room takes shape"
	JUMP	?PRG28
?PRG26:	PRINT	STRANGE-VISION
	PRINTI	" of a distant room, which can be described clearly"
?PRG28:	PRINTI	"..."
	CRLF	
	CRLF	
	FSET	OBJ,INVISIBLE
	CALL	GO&LOOK,RM
	EQUAL?	HERE,RM \?CND30
	PRINTI	"An astonished adventurer is staring into a crystal sphere."
	CRLF	
?CND30:	FCLEAR	OBJ,INVISIBLE
	ZERO?	DEAD \TRUE
	PRINTR	"The vision fades, revealing only an ordinary crystal sphere."


	.FUNCT	GO&LOOK,RM,OHERE,OLIT,OSEEN=0
	SET	'OHERE,HERE
	FSET?	OHERE,TOUCHBIT \?CND1
	SET	'OSEEN,TRUE-VALUE
?CND1:	SET	'OLIT,LIT
	SET	'HERE,RM
	CALL	LIT?,RM >LIT
	CALL	V-LOOK
	ZERO?	OSEEN \?CND3
	FCLEAR	OHERE,TOUCHBIT
?CND3:	SET	'HERE,OHERE
	SET	'LIT,OLIT
	RETURN	LIT


	.FUNCT	DEAD-PALANTIR-F,RARG,P
	EQUAL?	RARG,M-LOOK \?CCL3
	PRINTI	"You are in a huge crystalline sphere filled with thin "
	EQUAL?	HERE,DEAD-PALANTIR-1 \?CCL8
	SET	'P,PALANTIR-1
	PRINTI	"red"
	JUMP	?PRG17
?CCL8:	EQUAL?	HERE,DEAD-PALANTIR-2 \?CCL12
	SET	'P,PALANTIR-2
	PRINTI	"blue"
	JUMP	?PRG17
?CCL12:	SET	'P,PALANTIR-3
	PRINTI	"white"
?PRG17:	PRINTI	" mist. The mist becomes "
	EQUAL?	HERE,DEAD-PALANTIR-1 \?CCL21
	PRINTI	"blue"
	JUMP	?PRG30
?CCL21:	EQUAL?	HERE,DEAD-PALANTIR-2 \?PRG28
	PRINTI	"white"
	JUMP	?PRG30
?PRG28:	PRINTI	"black"
?PRG30:	PRINTI	" to the west. You strain to look out through the mist..."
	CRLF	
	CRLF	
	FSET?	P,TOUCHBIT \?CCL34
	CALL	PALANTIR-LOOK,P
	JUMP	?CND32
?CCL34:	EQUAL?	P,PALANTIR-1 \?CCL36
	PRINTR	"You see a small room with a sign, too blurry to read."
?CCL36:	EQUAL?	P,PALANTIR-2 \?CCL40
	PRINTR	"You see a dreary room with an oak door and a huge table. There is an odd glow to the mist."
?CCL40:	EQUAL?	P,PALANTIR-3 \?CND32
	PRINTI	"A watery room is barely visible."
	IN?	SERPENT,AQUARIUM \?CND32
	RANDOM	100
	GRTR?	25,STACK \?CND32
	PRINTR	" A shadow swims by as you look."
?CND32:	CRLF	
	RTRUE	
?CCL3:	EQUAL?	RARG,M-ENTER \FALSE
	EQUAL?	HERE,DEAD-PALANTIR-4 \FALSE
	IN?	DEMON,PENTAGRAM-ROOM \?PRG60
	PRINTI	"The room is empty. A huge face looks down from outside and laughs sardonically. It doesn't look like you're getting out of this predicament!"
	CRLF	
	CALL	FINISH
?PRG60:	PRINTI	"A huge and horrible face materializes out of the mist. """
	LESS?	DEATHS,3 /?PRG66
	PRINTI	"You again! You'll obviously be no help to me."" The face disappears and everything goes black."
	CRLF	
	CALL	FINISH
?PRG66:	PRINTI	"Perhaps you may be of use in gaining my freedom from this place. I return you to your foolish quest! Mayhap you will repay this favor in kind someday."" The mist swirls, and you are returned to the world of life."
	CRLF	
	SET	'DEAD,FALSE-VALUE
	CALL	GOTO,INSIDE-THE-BARROW
	RSTACK	


	.FUNCT	GLOBAL-PALANTIR-F
	EQUAL?	PRSA,V?EXAMINE,V?LOOK-INSIDE \?CCL3
	CALL	DEAD-PALANTIR-F,M-LOOK
	RSTACK	
?CCL3:	EQUAL?	PRSA,V?MUNG \FALSE
	PRINTR	"The sphere is unbreakable."

	.ENDI
