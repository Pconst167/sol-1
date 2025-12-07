

	.FUNCT	FORMAL-GARDEN-F,RARG
	EQUAL?	RARG,M-ENTER \FALSE
	CALL	QUEUE,I-GARDEN,-1
	PUT	STACK,0,1
	RTRUE	


	.FUNCT	I-GARDEN
	EQUAL?	HERE,FORMAL-GARDEN \?CCL3
	IN?	UNICORN,FORMAL-GARDEN \?CCL6
	RANDOM	100
	GRTR?	33,STACK \?CCL6
	REMOVE	UNICORN
	PRINTR	"The unicorn bounds lightly away."
?CCL6:	IN?	PRINCESS,DRAGON-LAIR \FALSE
	IN?	UNICORN,FORMAL-GARDEN /FALSE
	RANDOM	100
	GRTR?	25,STACK \FALSE
	ZERO?	UNICORN-FRIGHTENED /?CND16
	SET	'UNICORN-FRIGHTENED,FALSE-VALUE
	RFALSE	
?CND16:	MOVE	UNICORN,FORMAL-GARDEN
	PRINTI	"A beautiful unicorn is peacefully cropping grass across the garden. A gold key hangs from a red satin ribbon around its neck."
	RTRUE	
?CCL3:	REMOVE	UNICORN
	CALL	INT,I-GARDEN
	PUT	STACK,0,0
	RFALSE	


	.FUNCT	UNICORN-F
	CALL	HELLO?,UNICORN
	ZERO?	STACK /?CCL3
	PRINTR	"The unicorn continues cropping grass."
?CCL3:	EQUAL?	PRSA,V?FOLLOW \?CCL7
	PRINTR	"The unicorn shies away as you near."
?CCL7:	EQUAL?	PRSA,V?RUB,V?PUT,V?TAKE /?CCL11
	EQUAL?	PRSA,V?ATTACK,V?MUNG \FALSE
?CCL11:	REMOVE	UNICORN
	SET	'UNICORN-FRIGHTENED,TRUE-VALUE
	PRINTR	"The unicorn, unsurprised to discover that you are indeed the uncouth sort it suspected you were, melts into the hedges and is gone."


	.FUNCT	GAZEBO-OBJECT-F
	EQUAL?	PRSA,V?ENTER \?CCL3
	EQUAL?	HERE,FORMAL-GARDEN \?PRG7
	CALL	DO-WALK,P?IN
	RSTACK	
?PRG7:	PRINT	LOOK-AROUND
	RTRUE	
?CCL3:	EQUAL?	HERE,GAZEBO \FALSE
	EQUAL?	PRSA,V?EXIT,V?LEAVE \FALSE
	CALL	DO-WALK,P?OUT
	RSTACK	


	.FUNCT	NEWSPAPER-F
	EQUAL?	PRSA,V?READ \FALSE
	PRINTI	"Famed Adventurer to Explore"
	PRINT	GUE-NAME
	PRINTI	"! A world-famous and battle-hardened adventurer has been seen in the vicinity of"
	PRINT	GUE-NAME
	PRINTR	". Local grues have been reported sharpening their (slavering) fangs..."


	.FUNCT	PLACE-MAT-F
	EQUAL?	PRSA,V?PUT-UNDER \?CCL3
	EQUAL?	PRSI,PDOOR \?CCL6
	MOVE	PRSO,HERE
	SET	'MUD-FLAG,TRUE-VALUE
	PRINTR	"The mat slies under the door."
?CCL6:	EQUAL?	PRSI,WIZ-DOOR,RIDDLE-DOOR \FALSE
	PRINTR	"There's not enough room."
?CCL3:	EQUAL?	PRSA,V?MOVE,V?TAKE \FALSE
	ZERO?	MATOBJ /FALSE
	MOVE	MATOBJ,HERE
	SET	'MATOBJ,FALSE-VALUE
	SET	'MUD-FLAG,FALSE-VALUE
	PRINTI	"As the place mat is moved, a "
	PRINTD	MATOBJ
	PRINTR	" falls from it to the floor."


	.FUNCT	TEAPOT-F
	EQUAL?	PRSA,V?CLOSE,V?OPEN \FALSE
	PRINTR	"The teapot has no lid."


	.FUNCT	MATCH-F,CNT
	EQUAL?	PRSA,V?BURN,V?LAMP-ON \?CCL3
	EQUAL?	PRSO,MATCH \?CCL3
	GRTR?	MATCH-COUNT,0 \?CND6
	DEC	'MATCH-COUNT
?CND6:	GRTR?	MATCH-COUNT,0 /?CCL10
	PRINTR	"You've run out of matches."
?CCL10:	FSET	MATCH,FLAMEBIT
	FSET	MATCH,ONBIT
	CALL	QUEUE,I-MATCH,2
	PUT	STACK,0,1
	PRINTR	"A match starts to burn."
?CCL3:	EQUAL?	PRSA,V?LAMP-OFF \?CCL16
	FSET?	MATCH,FLAMEBIT \?CCL16
	FCLEAR	MATCH,FLAMEBIT
	FCLEAR	MATCH,ONBIT
	CALL	QUEUE,I-MATCH,0
	PRINTR	"The match is out."
?CCL16:	EQUAL?	PRSA,V?COUNT \?CCL22
	PRINTI	"You have "
	SUB	MATCH-COUNT,1 >CNT
	PRINTN	CNT
	PRINTI	" match"
	EQUAL?	CNT,1 /?PRG31
	PRINTI	"es"
?PRG31:	PRINT	PERIOD-CR
	RTRUE	
?CCL22:	EQUAL?	PRSA,V?EXAMINE \FALSE
	FSET?	MATCH,ONBIT \?PRG40
	PRINTC	65
	JUMP	?PRG42
?PRG40:	PRINTI	"No"
?PRG42:	PRINTR	" match is burning."


	.FUNCT	I-MATCH
	FCLEAR	MATCH,FLAMEBIT
	FCLEAR	MATCH,ONBIT
	PRINTR	"The match has gone out."


	.FUNCT	TOPIARY-F,RARG
	EQUAL?	RARG,M-ENTER \FALSE
	CALL	QUEUE,I-TOPIARY,-1
	PUT	STACK,0,1
	RTRUE	


	.FUNCT	I-TOPIARY
	EQUAL?	HERE,TOPIARY \?CCL3
	ZERO?	TOPIARY-COUNTER \?CCL6
	RANDOM	100
	GRTR?	12,STACK \?CCL6
	SET	'TOPIARY-COUNTER,1
	PRINTR	"Strangely, the topiary animals seem to have shifted position a bit."
?CCL6:	ZERO?	TOPIARY-COUNTER \?CCL12
	RANDOM	100
	GRTR?	8,STACK \?CCL12
	SET	'TOPIARY-COUNTER,2
	PRINTR	"You turn, and the topiary animals seem to have closed in on you."
?CCL12:	ZERO?	TOPIARY-COUNTER \FALSE
	RANDOM	100
	GRTR?	4,STACK \FALSE
	SET	'TOPIARY-COUNTER,0
	CALL	JIGS-UP,STR?144
	RSTACK	
?CCL3:	CALL	INT,I-TOPIARY
	PUT	STACK,0,0
	RFALSE	


	.FUNCT	HEDGES-F
	EQUAL?	PRSA,V?EXAMINE \FALSE
	PRINTR	"The hedges are shaped like various animals: dogs, serpents, dragons..."


	.FUNCT	DRAGON-F
	CALL	QUEUE,I-DRAGON,-1
	PUT	STACK,0,1
	CALL	HELLO?,DRAGON
	ZERO?	STACK /?CCL3
	ADD	DRAGON-ANGER,2 >DRAGON-ANGER
	PRINTR	"The dragon looks amused."
?CCL3:	EQUAL?	PRSA,V?EXAMINE \?CCL7
	INC	'DRAGON-ANGER
	PRINTR	"He looks back at you, his cat's eyes yellow in the gloom. You start to feel weak, and quickly turn away."
?CCL7:	EQUAL?	PRSA,V?KICK,V?MUNG,V?ATTACK /?CTR10
	EQUAL?	PRSA,V?LAMP-ON \?CCL11
?CTR10:	ADD	DRAGON-ANGER,4 >DRAGON-ANGER
	EQUAL?	PRSA,V?LAMP-ON /?PRG21
	EQUAL?	PRSA,V?ATTACK \?PRG23
	ZERO?	PRSI \?PRG23
?PRG21:	PRINTR	"With your bare hands? I doubt the dragon even noticed."
?PRG23:	CALL	RANDOM-ELEMENT,DRAGON-ATTACKS
	PRINT	STACK
	CRLF	
	RTRUE	
?CCL11:	EQUAL?	PRSA,V?GIVE \?CCL26
	EQUAL?	PRSI,DRAGON \?CCL26
	INC	'DRAGON-ANGER
	FSET?	PRSO,TREASUREBIT \?CCL31
	MOVE	PRSO,CHEST
	PRINTI	"The dragon excuses himself for a moment and returns without the "
	PRINTD	PRSO
	PRINT	PERIOD-CR
	RTRUE	
?CCL31:	CALL	BOMB?,PRSO
	ZERO?	STACK /?PRG38
	ADD	DRAGON-ANGER,2 >DRAGON-ANGER
	REMOVE	BRICK
	PRINTR	"The politely swallows the bomb. A moment later, he belches and smoke curls from his nostrils."
?PRG38:	PRINTR	"The dragon refuses it."
?CCL26:	EQUAL?	PRSA,V?WALK \FALSE
	EQUAL?	HERE,DRAGON-ROOM \FALSE
	EQUAL?	PRSO,P?NORTH \FALSE
	ADD	DRAGON-ANGER,3 >DRAGON-ANGER
	PRINTR	"The dragon puts out a claw and blocks your way."


	.FUNCT	DRAGON-LEAVES
	MOVE	DRAGON,DRAGON-ROOM
	SET	'DRAGON-ANGER,0
	CALL	INT,I-DRAGON
	PUT	STACK,0,0
	RTRUE	


	.FUNCT	I-DRAGON,ROOM
	GRTR?	DRAGON-ANGER,6 \?CCL3
	PRINTI	"With an almost bored yawn, the dragon opens his mouth and blasts you with a gout of white-hot flame"
	EQUAL?	SPELL?,S-FIREPROOF \?CCL8
	PRINTI	", but it washes over you harmlessly."
	CRLF	
	JUMP	?CND1
?CCL8:	CALL	DRAGON-LEAVES
	CALL	JIGS-UP,STR?11
	JUMP	?CND1
?CCL3:	EQUAL?	HERE,DRAGON-ROOM \?CCL12
	IN?	DRAGON,DRAGON-ROOM /?CCL12
	MOVE	DRAGON,DRAGON-ROOM
	PRINTI	"The dragon charges in, maddened by your attempt to sneak past him. His eyes glow with anger. He opens his mouth, and a huge ball of flame engulfs you"
	EQUAL?	SPELL?,S-FIREPROOF \?CCL19
	CALL	JIGS-UP,STR?153
	JUMP	?CND1
?CCL19:	CALL	JIGS-UP,STR?11
	JUMP	?CND1
?CCL12:	GRTR?	DRAGON-ANGER,0 /?CCL21
	RANDOM	100
	GRTR?	50,STACK \?CCL24
	IN?	DRAGON,HERE \?CCL24
	PRINTI	"The dragon looks bored."
	CRLF	
	JUMP	?CND1
?CCL24:	CALL	DRAGON-LEAVES
	EQUAL?	HERE,OLD-HERE \?CND1
	PRINTI	"The dragon seems to have lost interest in you."
	EQUAL?	OLD-HERE,DRAGON-ROOM \?PRG36
	CRLF	
	JUMP	?CND1
?PRG36:	PRINTI	" He wanders off."
	CRLF	
	JUMP	?CND1
?CCL21:	CALL	FIND-TARGET,WINNER >ROOM
	ZERO?	ROOM \?CCL40
	RANDOM	100
	GRTR?	25,STACK \?CND1
	CALL	DRAGON-LEAVES
	JUMP	?CND1
?CCL40:	EQUAL?	ROOM,CAROUSEL-ROOM,DREARY-ROOM,LEDGE-IN-RAVINE \?CCL44
	RANDOM	100
	GRTR?	25,STACK \?PRG47
	CALL	DRAGON-LEAVES
?PRG47:	PRINTI	"The dragon follows no further."
	CRLF	
	JUMP	?CND1
?CCL44:	EQUAL?	ROOM,ICE-ROOM \?CCL50
	REMOVE	DRAGON
	REMOVE	ICE
	CALL	INT,I-DRAGON
	PUT	STACK,0,0
	ADD	SCORE,5 >SCORE
	SET	'ICE-MELTED,TRUE-VALUE
	CRLF	
	PRINTI	"The dragon enters and spies his reflection on the icy surface of the glacier. Thinking that another dragon has invaded his territory, he rears up to his full height and roars a challenge! The intruder responds! The dragon takes a deep breath and expels a massive gout of flame. It washes over the ice, which melts rapidly, sending out huge cloud of steam! When the steam dissipates, the glacier is gone, and so is the dragon. 
With the ice gone, you notice a passage leading west."
	CRLF	
	JUMP	?CND1
?CCL50:	EQUAL?	ROOM,OLD-HERE /?PRG58
	MOVE	DRAGON,ROOM
	PRINTI	"The dragon follows you, out of mingled curiosity and anger."
	CRLF	
	JUMP	?CND53
?PRG58:	PRINTI	"The dragon continues to watch you carefully."
	CRLF	
?CND53:	GRTR?	DRAGON-ANGER,0 /?CND1
	SET	'DRAGON-ANGER,0
	CALL	INT,I-DRAGON
	PUT	STACK,0,0
?CND1:	LOC	DRAGON >OLD-HERE
	SUB	DRAGON-ANGER,2 >DRAGON-ANGER
	LESS?	DRAGON-ANGER,0 \TRUE
	SET	'DRAGON-ANGER,0
	RTRUE	


	.FUNCT	CHEST-F
	EQUAL?	PRSA,V?OPEN \FALSE
	IN?	PRINCESS,HERE \?PRG12
	ZERO?	PRINCESS-AWAKE \?PRG12
	RANDOM	100
	GRTR?	25,STACK \?PRG12
	CALL	V-OPEN
	PRINTI	"The squeaky lid startles the young woman."
	CRLF	
	JUMP	?CND4
?PRG12:	PRINTI	"The rusty hinges almost give. It would probably open if you tried again."
	IN?	PRINCESS,HERE \?CND14
	ZERO?	PRINCESS-AWAKE \?CND14
	PRINTI	" The commotion has startled the young woman."
?CND14:	CRLF	
?CND4:	PUTP	CHEST,P?ACTION,0
	IN?	PRINCESS,HERE \TRUE
	ZERO?	PRINCESS-AWAKE \TRUE
	CALL	PERFORM,V?ALARM,PRINCESS
	RTRUE	


	.FUNCT	PRINCESS-F,DEM
	CALL	INT,I-PRINCESS >DEM
	EQUAL?	PRSA,V?FOLLOW \?CCL3
	ZERO?	PRFOLLOW /?PRG7
	CALL	DO-WALK,PRFOLLOW
	RSTACK	
?PRG7:	PRINTR	"You've lost track of her."
?CCL3:	EQUAL?	PRSA,V?RAPE,V?MUNG,V?ATTACK \?CCL10
	REMOVE	PRINCESS
	PRINTI	"The princess screams, ""Won't someone deliver me from this awful fate?"" The Wizard of Frobozz "
	IN?	WIZARD,HERE \?PRG18
	PRINTI	"turns toward you"
	JUMP	?CND13
?PRG18:	PRINTI	"appears"
?CND13:	CALL	JIGS-UP,STR?158
	RSTACK	
?CCL10:	CALL	HELLO?,PRINCESS
	ZERO?	STACK \?CTR20
	EQUAL?	PRSA,V?EXAMINE,V?KISS,V?ALARM /?CTR20
	EQUAL?	PRSA,V?RUB \?CCL21
?CTR20:	IN?	PRINCESS,DRAGON-LAIR \?PRG32
	GET	DEM,C-ENABLED?
	ZERO?	STACK \?PRG32
	CALL	QUEUE,I-PRINCESS,2
	PUT	STACK,0,1
	SET	'PRINCESS-AWAKE,TRUE-VALUE
	PRINTR	"The princess shakes herself awake, notices you, and smiles. ""Thank you for rescuing me from that horrid worm, but I must depart."" She rises, looking purposefully out of the lair."
?PRG32:	PRINTI	"The princess ignores you; her eyes fix on the "
	EQUAL?	HERE,GAZEBO \?CCL36
	PRINTI	"garden"
	JUMP	?PRG49
?CCL36:	EQUAL?	HERE,FORMAL-GARDEN \?CCL40
	PRINTI	"gazebo"
	JUMP	?PRG49
?CCL40:	EQUAL?	HERE,LEDGE-IN-RAVINE \?PRG47
	PRINTI	"ledge"
	JUMP	?PRG49
?PRG47:	MUL	PRCOUNT,4
	GET	PRDIRS,STACK
	PRINT	STACK
?PRG49:	PRINT	PERIOD-CR
	RTRUE	
?CCL21:	ZERO?	PRINCESS-AWAKE \FALSE
	PRINTR	"She's in a trance!"


	.FUNCT	I-PRINCESS,DEM,OLDP,PC
	CALL	INT,I-PRINCESS >DEM
	LOC	PRINCESS >OLDP
	MUL	PRCOUNT,4 >PC
	ADD	PC,1
	GET	PRDIRS,STACK
	MOVE	PRINCESS,STACK
	SET	'PRFOLLOW,FALSE-VALUE
	IN?	PRINCESS,DARK-TUNNEL \?CCL3
	IN?	ADVENTURER,DEEP-FORD \?CCL3
	PRINTI	"The princess touches the ravine wall and a section slides away, revealing a passage to the east. She enters it."
	CRLF	
	IN?	WINNER,OLDP \?CND8
	ADD	PC,3
	GET	PRDIRS,STACK >PRFOLLOW
?CND8:	SET	'SECRET-DOOR,TRUE-VALUE
	JUMP	?CND1
?CCL3:	IN?	PRINCESS,DARK-TUNNEL \?CCL11
	IN?	WINNER,DARK-TUNNEL \?CCL11
	SET	'SECRET-DOOR,TRUE-VALUE
	PRINTI	"The princess appears from behind some rocks, as though she had walked through a wall."
	CRLF	
	JUMP	?CND1
?CCL11:	IN?	WINNER,OLDP \?CCL17
	ADD	PC,3
	GET	PRDIRS,STACK >PRFOLLOW
	EQUAL?	OLDP,FORMAL-GARDEN \?CCL20
	PRINTI	"The princess enters the gazebo."
	CRLF	
	JUMP	?CND1
?CCL20:	EQUAL?	OLDP,LEDGE-IN-RAVINE \?PRG27
	PRINTI	"The princess climbs daintily down the rock face."
	CRLF	
	JUMP	?CND1
?PRG27:	PRINTI	"The princess walks "
	GET	PRDIRS,PC
	PRINT	STACK
	PRINTI	". She glances back at you as she goes."
	CRLF	
	JUMP	?CND1
?CCL17:	IN?	PRINCESS,HERE \?CND1
	EQUAL?	HERE,GAZEBO \?CCL36
	PRINTI	"The princess joins you in the gazebo."
	CRLF	
	JUMP	?CND1
?CCL36:	EQUAL?	HERE,DEEP-FORD \?PRG43
	PRINTI	"The princess clambers down from the ledge."
	CRLF	
	JUMP	?CND1
?PRG43:	PRINTI	"The princess enters from the "
	ADD	2,PC
	GET	PRDIRS,STACK
	PRINT	STACK
	PRINTI	". She seems surprised to see you."
	CRLF	
?CND1:	IN?	PRINCESS,GAZEBO \?CCL51
	PUT	DEM,0,0
	CALL	QUEUE,I-UNICORN,6
	PUT	STACK,0,1
	RTRUE	
?CCL51:	INC	'PRCOUNT
	RANDOM	100
	GRTR?	75,STACK \?CCL54
	PUSH	1
	JUMP	?CND52
?CCL54:	PUSH	2
?CND52:	CALL	QUEUE,I-PRINCESS,STACK
	PUT	STACK,0,1
	RTRUE	


	.FUNCT	I-UNICORN
	EQUAL?	HERE,GAZEBO,FORMAL-GARDEN \?CCL3
	FCLEAR	GOLD-KEY,NDESCBIT
	MOVE	GOLD-KEY,WINNER
	CALL	SCORE-OBJ,GOLD-KEY
	PUTP	GOLD-KEY,P?ACTION,0
	REMOVE	PRINCESS
	PRINTR	"Shyly, a unicorn peeks out of the hedges and approaches the princess. Around its neck hangs a gold key. The princess takes the key and, smiling, hands it to you. ""It is the least I can do for one who rescued me from a fate I dare not contemplate."" With that, she mounts the unicorn and rides away."
?CCL3:	REMOVE	PRINCESS
	RFALSE	


	.FUNCT	ICE-ROOM-F,RARG
	EQUAL?	RARG,M-LOOK \FALSE
	PRINTI	"This is a large hall of ancient lava, worn smooth by a glacier. Tunnels lead east and south."
	ZERO?	ICE-MELTED /?CND6
	PRINTR	" A damp, scorched passage leads west."
?CND6:	CRLF	
	RTRUE	


	.FUNCT	ICE-F
	EQUAL?	PRSA,V?MELT \FALSE
	PRINTR	"This is a big glacier; you'll need lots of heat."

	.ENDI
