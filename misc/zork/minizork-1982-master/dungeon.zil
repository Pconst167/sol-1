"SUBTITLE MINI-ZORK"

<DIRECTIONS NORTH EAST WEST SOUTH NE NW SE SW UP DOWN IN OUT LAND>

"SUBTITLE GLOBAL OBJECTS"

<GLOBAL LOAD-MAX 100>
<GLOBAL LOAD-ALLOWED 100>

<OBJECT GLOBAL-OBJECTS
	(FLAGS RWATERBIT RMUNGBIT INVISIBLE TOUCHBIT FIGHTBIT STAGGERED)>

<OBJECT LOCAL-GLOBALS (IN GLOBAL-OBJECTS) (SYNONYM MGCKJK)>
;"Yes, this synonym for LOCAL-GLOBALS needs to exist... sigh"

<OBJECT ROOMS>

<OBJECT PSEUDO-OBJECT
	(DESC "pseudo")
	(ACTION GRANITE)>

<OBJECT IT	;"was IT"
	(IN GLOBAL-OBJECTS)
	(SYNONYM IT THAT THIS HIM)
	(DESC "random object")
	(FLAGS NDESCBIT)>

<OBJECT STAIRS
	(IN LOCAL-GLOBALS)
	(SYNONYM STAIRS STEPS STAIRCASE STAIRWAY)
	(ADJECTIVE STONE FORBIDDING STEEP)
	(DESC "stairs")
	(FLAGS NDESCBIT CLIMBBIT)>

<OBJECT PATHOBJ
	(IN GLOBAL-OBJECTS)
	(SYNONYM PASSAGE CRAWLWAY EXIT PATH)
        (ADJECTIVE FOREST NARROW LONG WINDING)
	(DESC "way")
	(FLAGS NDESCBIT)
	(ACTION PATH-OBJECT)>

<OBJECT BOARDS
	(IN LOCAL-GLOBALS)
	(SYNONYM BOARDS BOARD)
	(DESC "board")
	(FLAGS NDESCBIT)>

<OBJECT WALL	;"was WALL"
	(IN GLOBAL-OBJECTS)
	(SYNONYM WALL WALLS)
	(DESC "wall")>

<OBJECT GROUND	;"was GROUND"
	(IN GLOBAL-OBJECTS)
	(SYNONYM GROUND EARTH SAND DIRT)
	(DESC "ground")
	(ACTION GROUND-FUNCTION)>

<OBJECT GRUE	;"was GRUE"
	(IN GLOBAL-OBJECTS)
	(SYNONYM GRUE)
	(ADJECTIVE LURKING)
	(DESC "lurking grue")
	(ACTION GRUE-FUNCTION)>

<OBJECT LUNGS	;"was LUNGS"
	(IN GLOBAL-OBJECTS)
	(SYNONYM LUNGS AIR MOUTH BREATH)
	(DESC "air")
	(FLAGS NDESCBIT)>

<OBJECT SONGBIRD	;"was SONGBIRD"
	(IN LOCAL-GLOBALS)
	(SYNONYM BIRD)
	(ADJECTIVE SONG)
	(DESC "song bird")
	(FLAGS NDESCBIT)
	(ACTION BIRD-OBJECT)>

<OBJECT WHITE-HOUSE	;"was WHITE-HOUSE"	
	(IN LOCAL-GLOBALS)
	(SYNONYM HOUSE)
	(ADJECTIVE WHITE)
	(DESC "white house")
	(FLAGS NDESCBIT)
	(ACTION HOUSE-FUNCTION)>

<OBJECT FOREST
	(IN LOCAL-GLOBALS)
	(SYNONYM FOREST TREES)
	(DESC "forest")
	(FLAGS NDESCBIT)
	(ACTION FOREST-FUNCTION)>

<OBJECT TREE	;"was TREE"
	(IN LOCAL-GLOBALS)
	(SYNONYM TREE TREES)
	(ADJECTIVE LARGE)
	(DESC "tree")
	(FLAGS NDESCBIT)>

<OBJECT GLOBAL-WATER	;"was GLOBAL-WATER"
	(IN LOCAL-GLOBALS)
	(SYNONYM WATER QUANTITY)
	(DESC "water")
	(FLAGS DRINKBIT)
	(ACTION WATER-FUNCTION)>

<OBJECT	KITCHEN-WINDOW	;"was KITCHEN-WINDOW"
	(IN LOCAL-GLOBALS)
	(SYNONYM WINDOW)
	(ADJECTIVE KITCHEN SMALL)
	(DESC "kitchen window")
	(FLAGS DOORBIT NDESCBIT)
	(ACTION WINDOW-FUNCTION)>

<OBJECT CHIMNEY
	(IN LOCAL-GLOBALS)
	(SYNONYM CHIMNEY)
	(ADJECTIVE DARK NARROW)
	(DESC "chimney")
	(FLAGS CLIMBBIT NDESCBIT)>
	
\

"SUBTITLE OBJECTS"

<OBJECT ADVENTURER	;"was ADVENTURER"
	(IN WEST-OF-HOUSE)
	(SYNONYM ADVENTURER)
	(DESC "cretin")
	(FLAGS VILLAIN NDESCBIT INVISIBLE SACREDBIT)
	(STRENGTH 0)
	(ACTION 0)>

<OBJECT ME
	(IN GLOBAL-OBJECTS)
	(SYNONYM ME MYSELF SELF CRETIN)
	(DESC "you")
	(FLAGS VILLAIN)
	(ACTION CRETIN)>

<OBJECT GHOST	;"was GHOST"
	(IN ENTRANCE-TO-HADES)
	(SYNONYM GHOSTS SPIRITS FORCE)
	(ADJECTIVE INVISIBLE EVIL)
	(DESC "number of ghosts")
	(FLAGS VICBIT NDESCBIT)
	(ACTION GHOST-FUNCTION)>

<OBJECT SKULL
	(IN LAND-OF-LIVING-DEAD)
	(SYNONYM SKULL TREASURE)
	(ADJECTIVE CRYSTAL)
	(DESC "crystal skull")
	(FDESC
"Lying in the corner is a beautifully carved crystal skull.")
	(FLAGS TAKEBIT)
	(VALUE 10)
	(TVALUE 10)>

<OBJECT LOWERED-BASKET	;"was FBASK"
	(IN LOWER-SHAFT)
	(SYNONYM BASKET)
	(LDESC "From the chain is suspended a basket.")
	(DESC "basket")
	(FLAGS)
	(ACTION DUMBWAITER)>

<OBJECT FOOD	;"was FOOD"
	(IN SANDWICH-BAG)
	(SYNONYM FOOD SANDWICH LUNCH)
	(ADJECTIVE HOT PEPPER)
	(DESC "lunch")
	(FLAGS TAKEBIT FOODBIT)
	(LDESC "A hot pepper sandwich is here.")>

<OBJECT RAISED-BASKET	;"was TBASK"
	(IN SHAFT-ROOM)
	(SYNONYM BASKET)
	(DESC "basket")
	(FLAGS TRANSBIT CONTBIT OPENBIT)
	(ACTION DUMBWAITER)
	(LDESC "At the end of the chain is a basket.")
	(CAPACITY 50)>

<OBJECT BAT	;"was BAT"
	(IN BAT-ROOM)
	(SYNONYM BAT VAMPIRE)
	(ADJECTIVE VAMPIRE DERANGED)
	(DESC "bat")
	(FLAGS NDESCBIT TRYTAKEBIT)
	(ACTION BAT-FUNCTION)>

<OBJECT BELL	;"was BELL"
	(IN NORTH-TEMPLE)
	(SYNONYM BELL)
	(ADJECTIVE BRASS)
	(DESC "brass bell")
	(FLAGS TAKEBIT)>

<OBJECT AXE	;"was AXE"
	(IN TROLL)
	(SYNONYM AXE)
	(ADJECTIVE BLOODY)
	(DESC "bloody axe")
	(FLAGS ;WEAPONBIT TRYTAKEBIT NDESCBIT)
	(ACTION AXE-FUNCTION)
	(SIZE 25)>

<OBJECT BOLT	;"was BOLT"
	(IN DAM-ROOM)
	(SYNONYM BOLT)
	(ADJECTIVE METAL LARGE)
	(DESC "bolt")
	(FLAGS NDESCBIT TURNBIT)
	(ACTION BOLT-FUNCTION)>

<OBJECT ALTAR
	(IN SOUTH-TEMPLE)
	(SYNONYM ALTAR)
	(DESC "altar")
	(FLAGS NDESCBIT SURFACEBIT CONTBIT OPENBIT)
	(CAPACITY 50)>

<OBJECT BOOK	;"was BOOK"
	(IN ALTAR)
	(SYNONYM BOOK)
	(ADJECTIVE PRAYER)
	(DESC "prayer book")
	(FLAGS READBIT TAKEBIT CONTBIT BURNBIT TURNBIT)
	(ACTION BLACK-BOOK)
	(FDESC "On the altar is an open prayer book.")
	(SIZE 10)
	(TEXT
"The book contains instructions for using certain noises and prayers to 
drive away evil." )>

<OBJECT SCEPTRE	;"was STICK"
	(IN COFFIN)
	(SYNONYM SCEPTRE TREASURE)
	(ADJECTIVE EGYPTIAN ANCIENT)
	(DESC "sceptre")
	(FLAGS TAKEBIT)
	(ACTION SCEPTRE-FUNCTION)
	(FDESC
"An ancient Egyptian sceptre, ornamented with multi-colored jewels, is in 
the coffin.")
	(SIZE 3)
	(VALUE 4)
	(TVALUE 6)>

<OBJECT TIMBERS	;"was OTIMB"
	(IN TIMBER-ROOM)
	(SYNONYM TIMBERS PILE)
	(ADJECTIVE WOODEN BROKEN)
	(DESC "broken timber")
	(FLAGS TAKEBIT)
	(SIZE 50)>

<OBJECT	SLIDE	;"was SLIDE"
	(IN LOCAL-GLOBALS)
	(SYNONYM SLIDE)
	(ADJECTIVE STEEP METAL TWISTING)
	(DESC "slide")
	(FLAGS CLIMBBIT)
	(ACTION SLIDE-FUNCTION)>

<OBJECT KITCHEN-TABLE
	(IN KITCHEN)
	(SYNONYM TABLE)
	(ADJECTIVE KITCHEN)
	(DESC "kitchen table")
	(FLAGS NDESCBIT CONTBIT OPENBIT SURFACEBIT)
	(CAPACITY 30)>

<OBJECT SANDWICH-BAG	;"was SBAG"
	(IN KITCHEN-TABLE)
	(SYNONYM BAG SACK)
	(ADJECTIVE BROWN ELONGATED SMELLY)
	(DESC "brown sack")
	(FLAGS TAKEBIT CONTBIT BURNBIT)
	(FDESC
"On the table is an elongated brown sack, smelling of hot peppers.")
	(CAPACITY 15)
	(SIZE 3)>

<OBJECT OVERBOARD
	(IN GLOBAL-OBJECTS)
	(SYNONYM OVERBOARD)
	(FLAGS NDESCBIT)>

<OBJECT TOOL-CHEST	;"first obj in room"
	(IN MAINTENANCE-ROOM)
	(SYNONYM CHEST TOOLCHEST)
	(ADJECTIVE TOOL)
	(DESC "tool chest")
	(FLAGS OPENBIT SACREDBIT)>

<OBJECT BUTTON	;"was YBUTT"
	(IN MAINTENANCE-ROOM)
	(SYNONYM BUTTON)
	(DESC "button")
	(FLAGS NDESCBIT)
	(ACTION DBUTTONS)>

<OBJECT TROPHY-CASE	;"was TCASE -- first obj so L.R. desc looks right."
	(IN LIVING-ROOM)
	(SYNONYM CASE)
	(ADJECTIVE TROPHY)
	(DESC "trophy case")
	(FLAGS TRANSBIT CONTBIT NDESCBIT)
	(ACTION TROPHY-CASE-FCN)
	(CAPACITY 10000)>

<OBJECT RUG	;"was RUG"
	(IN LIVING-ROOM)
	(SYNONYM RUG CARPET)
	(ADJECTIVE LARGE ORIENTAL)
	(DESC "carpet")
	(FLAGS NDESCBIT TRYTAKEBIT)
	(ACTION RUG-FCN)>

<OBJECT CHALICE	;"was CHALI"
	(IN TREASURE-ROOM)
	(SYNONYM CHALICE SILVER TREASURE)
	(ADJECTIVE SILVER) 
	(DESC "silver chalice")
	(FLAGS TAKEBIT)
	(ACTION CHALICE-FCN)
	(SIZE 10)
	(VALUE 10)
	(TVALUE 5)>

<OBJECT GARLIC	;"was GARLI"
	(IN SANDWICH-BAG)
	(SYNONYM GARLIC CLOVE)
	(DESC "clove of garlic")
	(FLAGS TAKEBIT FOODBIT)>

<OBJECT CYCLOPS	;"was CYCLO"
	(IN CYCLOPS-ROOM)
	(SYNONYM CYCLOPS)
	(ADJECTIVE HUNGRY GIANT)
	(DESC "cyclops")
	(FLAGS VICBIT VILLAIN NDESCBIT)
	(ACTION CYCLOPS-FCN)
	(STRENGTH 10000)>

<OBJECT DAM	;"was DAM"
	(IN DAM-ROOM)
	(SYNONYM DAM GATE GATES)
	(DESC "dam")
	(FLAGS NDESCBIT)
	(ACTION DAM-FUNCTION)>

<OBJECT TRAP-DOOR	;"was DOOR"
	(IN LIVING-ROOM)
	(SYNONYM DOOR TRAP-DOOR)
	(ADJECTIVE TRAP)
	(DESC "trap door")
	(FLAGS DOORBIT NDESCBIT INVISIBLE)
	(ACTION TRAP-DOOR-FCN)>

<OBJECT BOARDED-WINDOW
	(SYNONYM WINDOW)
	(ADJECTIVE BOARDED)
	(DESC "boarded window")
	(FLAGS NDESCBIT)>

<OBJECT NAILS
	(IN WOODEN-DOOR)
	(SYNONYM NAILS NAIL)
	(DESC "nail")
	(FLAGS NDESCBIT)>

<OBJECT FRONT-DOOR	;"was FDOOR"
	(IN WEST-OF-HOUSE)
	(SYNONYM DOOR)
	(ADJECTIVE FRONT BOARDED)
	(DESC "door")
	(FLAGS DOORBIT NDESCBIT)
	(ACTION FRONT-DOOR-FCN)>

<OBJECT BARROW-DOOR	
	(IN STONE-BARROW)
	(SYNONYM DOOR)
	(ADJECTIVE HUGE STONE)
	(DESC "stone door")
	(FLAGS DOORBIT NDESCBIT)>

<OBJECT BARROW
	(IN STONE-BARROW)
	(SYNONYM BARROW TOMB)
	(ADJECTIVE MASSIVE STONE)
	(DESC "stone barrow")
	(FLAGS NDESCBIT)
	(ACTION BARROW-FCN)>

\

<OBJECT BOTTLE	;"was BOTTL"
	(IN KITCHEN-TABLE)
	(SYNONYM BOTTLE)
	(ADJECTIVE GLASS)
	(DESC "glass bottle")
	(FLAGS TAKEBIT TRANSBIT CONTBIT)
	(ACTION BOTTLE-FUNCTION)
	(FDESC "A bottle is sitting on the table.")
	(CAPACITY 4)>

<OBJECT COFFIN	;"was COFFI"
	(IN EGYPT-ROOM)
	(SYNONYM COFFIN TREASURE)
	(ADJECTIVE SOLID GOLD)
	(DESC "gold coffin")
	(FLAGS TAKEBIT CONTBIT SACREDBIT)
	(LDESC
"The solid-gold coffin used for the burial of Ramses II is here.")
	(CAPACITY 35)
	(SIZE 55)
	(VALUE 10)
	(TVALUE 15)>

<OBJECT GRATE	;"was GRATE"
	(IN LOCAL-GLOBALS)
	(SYNONYM GRATE GRATING LOCK)
	(DESC "grating")
	(FLAGS DOORBIT NDESCBIT INVISIBLE)
	(ACTION GRATE-FUNCTION)>

<OBJECT PUMP	;"was PUMP"
	(IN RESERVOIR-NORTH)
	(SYNONYM PUMP AIR-PUMP)
	(ADJECTIVE HAND-HELD HAND HELD)
	(DESC "hand-held air pump")
	(FLAGS TAKEBIT TOOLBIT)>

<OBJECT DIAMOND	;"was DIAMO"
	(SYNONYM DIAMOND TREASURE)
	(ADJECTIVE HUGE)
	(DESC "huge diamond")
	(FLAGS TAKEBIT)
	(LDESC "There is a huge diamond (perfectly cut) here.")
	(VALUE 10)
	(TVALUE 10)>

<OBJECT JADE	;"was JADE"
	(IN BAT-ROOM)
	(SYNONYM FIGURINE TREASURE)
	(ADJECTIVE JADE)
	(DESC "jade figurine")
	(FLAGS TAKEBIT)
	(LDESC "There is an exquisite jade figurine here.")
	(SIZE 10)
	(VALUE 5)
	(TVALUE 5)>

<OBJECT KNIFE	;"was KNIFE"
	(IN ATTIC)
	(SYNONYM KNIFE)
	(ADJECTIVE NASTY NASTY-LOOKING)
	(DESC "nasty knife")
	(FLAGS TAKEBIT WEAPONBIT)
	(FDESC "On the ground is a nasty-looking knife.")>

<OBJECT BONES	;"was BONES"
	(IN MAZE-5)
	(SYNONYM BONES SKELETON BODY)
	(DESC "skeleton")
	(FLAGS TRYTAKEBIT NDESCBIT)>

<OBJECT BURNED-OUT-LANTERN	;"was BLANT"
	(IN MAZE-5)
	(SYNONYM LANTERN LAMP)
	(ADJECTIVE BURNED)
	(DESC "burned-out lantern")
	(FLAGS TAKEBIT)
	(FDESC "The deceased adventurer's burned-out lantern is here.")
	(SIZE 20)>

<OBJECT BAG-OF-COINS	;"was BAGCO"
	(IN MAZE-5)
	(SYNONYM BAG COINS TREASURE)
	(DESC "bag of coins")
	(FLAGS TAKEBIT)
	(LDESC "A bag, bulging with coins, is here.")
	(SIZE 15)
	(VALUE 10)
	(TVALUE 5)>

<OBJECT LAMP	;"was LAMP"
	(IN LIVING-ROOM)
	(SYNONYM LAMP LANTERN LIGHT)
	(ADJECTIVE BRASS)
	(DESC "lamp")
	(FLAGS TAKEBIT LIGHTBIT)
	(ACTION LANTERN)
	(FDESC "A battery-powered brass lantern is on the trophy case.")
	(SIZE 15)>

<OBJECT MACHINE	;"was MACHI"
	(IN MACHINE-ROOM)
	(SYNONYM MACHINE LID)
	(DESC "machine")
	(FLAGS CONTBIT NDESCBIT)
	(ACTION MACHINE-FUNCTION)
	(CAPACITY 50)>

<OBJECT INFLATED-BOAT	;"was RBOAT"
	(SYNONYM BOAT)
	(ADJECTIVE INFLAT MAGIC PLASTIC)
	(DESC "inflated boat")
	(FLAGS TAKEBIT BURNBIT VEHBIT OPENBIT)
	(ACTION RBOAT-FUNCTION)
	(CAPACITY 100)
	(SIZE 20)
	(VTYPE RWATERBIT)>

<OBJECT MAILBOX	;"was MAILB"
	(IN WEST-OF-HOUSE)
	(SYNONYM MAILBOX BOX)
	(DESC "mailbox")
	(FLAGS CONTBIT)
	(CAPACITY 10)>

<OBJECT PAINTING	;"was PAINT"
	(IN STUDIO)
	(SYNONYM PAINTING TREASURE)
	(DESC "painting")
	(FLAGS TAKEBIT BURNBIT)
	(ACTION PAINTING-FCN)
	(FDESC
"Hanging on the far wall is a painting of unparalleled beauty.")
	(SIZE 15)
	(VALUE 4)
	(TVALUE 6)>

<OBJECT LEAVES	;"was LEAVE"
	(IN GRATING-CLEARING)
	(SYNONYM LEAVES PILE)
	(DESC "pile of leaves")
	(FLAGS TAKEBIT BURNBIT TRYTAKEBIT)
	(ACTION LEAF-PILE)
	(LDESC "On the ground is a pile of leaves.")
	(SIZE 25)>

<OBJECT INFLATABLE-BOAT	;"was IBOAT"
	(IN DAM-BASE)
	(SYNONYM BOAT PILE PLASTIC VALVE)
	(ADJECTIVE PLASTIC INFLAT)
	(DESC "pile of plastic")
	(FLAGS TAKEBIT BURNBIT)
	(ACTION IBOAT-FUNCTION)
	(LDESC
"There is a folded pile of plastic here which has a small valve attached.")
	(SIZE 20)>

<OBJECT POT-OF-GOLD	;"was POT"
	(IN END-OF-RAINBOW)
	(SYNONYM POT TREASURE)
	(ADJECTIVE GOLD)
	(DESC "pot of gold")
	(FLAGS TAKEBIT INVISIBLE)
	(FDESC "At the end of the rainbow is a pot of gold.")
	(SIZE 15)
	(VALUE 10)
	(TVALUE 10)>

<OBJECT WATER	;"was WATER"
	(IN BOTTLE)
	(SYNONYM WATER QUANTITY)
	(DESC "quantity of water")
	(FLAGS TAKEBIT DRINKBIT)
	(ACTION WATER-FUNCTION)
	(LDESC "There is some water here.")
	(SIZE 4)>

<OBJECT RAILING	;"was RAILI"
	(IN DOME-ROOM)
	(SYNONYM RAILING RAIL)
	(ADJECTIVE WOODEN)
	(DESC "wooden railing")
	(FLAGS NDESCBIT)>

<OBJECT DOME
	(IN LOCAL-GLOBALS)
	(SYNONYM DOME)
	(DESC "dome")
	(FLAGS NDESCBIT)>

<OBJECT RAINBOW	;"was RAINB"
	(IN LOCAL-GLOBALS)
	(SYNONYM RAINBOW)
	(DESC "rainbow")
	(FLAGS NDESCBIT CLIMBBIT)
	(ACTION RAINBOW-FCN)>

<OBJECT RIVER
	(IN LOCAL-GLOBALS)
	(DESC "river")
	(SYNONYM RIVER)
	(ADJECTIVE FRIGID)
	(ACTION RIVER-FUNCTION)
	(FLAGS NDESCBIT)>

<OBJECT ROPE	;"was ROPE"
	(IN ATTIC)
	(SYNONYM ROPE COIL)
	(DESC "rope")
	(FLAGS TAKEBIT SACREDBIT TRYTAKEBIT)
	(ACTION ROPE-FUNCTION)
	(FDESC "A coil of rope is lying in the corner.")
	(SIZE 10)>

<OBJECT SAND	;"was SAND"
	(IN SANDY-CAVE)
	(SYNONYM SAND)
	(DESC "sand")
	(FLAGS NDESCBIT)
	(ACTION SAND-FUNCTION)>

<OBJECT SCREWDRIVER	;"was SCREW"
	(IN MAINTENANCE-ROOM)
	(SYNONYM SCREWDRIVER DRIVER)
	(ADJECTIVE SCREW)
	(DESC "screwdriver")
	(FLAGS TAKEBIT TOOLBIT)>

<OBJECT SHOVEL	;"was SHOVE"
	(IN SANDY-BEACH)
	(SYNONYM SHOVEL)
	(DESC "shovel")
	(FLAGS TAKEBIT TOOLBIT)
	(SIZE 15)>

<OBJECT COAL	;"was COAL"
	(IN DEAD-END-5)
	(SYNONYM COAL PILE)
	(ADJECTIVE SMALL)
	(DESC "small pile of coal")
	(FLAGS TAKEBIT BURNBIT)
	(SIZE 20)>

<OBJECT SCARAB	;"was STATU"
	(IN SANDY-CAVE)
	(SYNONYM SCARAB TREASURE)
        (ADJECTIVE PRECIOUS CARVED)
	(DESC "scarab")
	(FLAGS TAKEBIT INVISIBLE)
	(LDESC "There is a precious carved scarab here.")
	(SIZE 8)
	(VALUE 5)
	(TVALUE 5)>

<OBJECT STILETTO	;"was STILL"
	(IN THIEF)
	(SYNONYM STILETTO)
	(DESC "stiletto")
	(ACTION STILETTO-FUNCTION)
	(FLAGS ;WEAPONBIT TAKEBIT NDESCBIT)
	(SIZE 10)>

<OBJECT MACHINE-SWITCH	;"was MSWIT"
	(IN MACHINE-ROOM)
	(SYNONYM SWITCH)
	(DESC "switch")
	(FLAGS NDESCBIT TURNBIT)
	(ACTION MSWITCH-FUNCTION)>

<OBJECT WOODEN-DOOR
	(IN LIVING-ROOM)
	(SYNONYM DOOR LETTERING)
	(ADJECTIVE WOODEN GOTHIC STRANGE)
	(DESC "wooden door")
	(FLAGS READBIT DOORBIT NDESCBIT TRANSBIT)
	(ACTION FRONT-DOOR-FCN)
	(TEXT
"The engravings translate to 'This space intentionally left blank.'")>

<OBJECT SWORD	;"was SWORD"
	(IN LIVING-ROOM)
	(SYNONYM SWORD)
	(ADJECTIVE ELVISH)
	(DESC "sword")
	(FLAGS TAKEBIT WEAPONBIT TRYTAKEBIT)
	(ACTION SWORD-FCN)
	(FDESC
"Above the trophy case hangs an elvish sword of great antiquity.")
	(SIZE 30)
	(TVALUE 0)>

<OBJECT MAP
	(IN TROPHY-CASE)
	(SYNONYM PARCHMENT MAP)
	(ADJECTIVE ANCIENT)
	(DESC "ancient map")
	(FLAGS INVISIBLE READBIT TAKEBIT)
	(FDESC
"In the trophy case is an ancient parchment which appears to be a map.")
	(SIZE 2)
	(TEXT
"It shows a white house in the middle of a clearing within a vast forest, 
which lies on the edge of a mighty canyon.  The map indicates three paths 
leaving the clearing--to the north, east, and southwest.")>

<OBJECT BOAT-LABEL	;"was LABEL"
	(IN INFLATED-BOAT)
	(SYNONYM LABEL)
	(ADJECTIVE TAN)
	(DESC "tan label")
	(FLAGS READBIT TAKEBIT BURNBIT)
	(SIZE 2)
	(TEXT
"  FROBOZZ MAGIC BOAT COMPANY|
|
   To enter a body of water, say 'Launch'.|
   To get to shore, say 'Land'.|
")>

<OBJECT THIEF	;"was THIEF"
	(IN ROUND-ROOM)
	(SYNONYM THIEF ROBBER INDIVIDUAL)
	(ADJECTIVE SHADY SUSPICIOUS SEEDY)
	(DESC "thief")
	(FLAGS VICBIT VILLAIN INVISIBLE OPENBIT)
	(ACTION ROBBER-FUNCTION)
	(LDESC
"There is a suspicious-looking individual, holding a bag, leaning
against one wall.  He is armed with a deadly stiletto.")
	(STRENGTH 5)>

<OBJECT TORCH	;"was TORCH"
	(IN ALTAR)
	(SYNONYM TORCH TREASURE)
	(ADJECTIVE FLAMING IVORY)
	(DESC "torch")
	(FLAGS TAKEBIT LIGHTBIT FLAMEBIT ONBIT SACREDBIT)
	(ACTION TORCH-OBJECT)
	(FDESC "Sitting on the altar is a flaming torch, made of ivory.")
	(SIZE 20)
	(VALUE 14)
	(TVALUE 6)>

<OBJECT TROLL	;"was TROLL"
	(IN TROLL-ROOM)
	(SYNONYM TROLL)
	(DESC "troll")
	(FLAGS VICBIT VILLAIN OPENBIT)
	(ACTION TROLL-FCN)
	(LDESC
"A troll, brandishing a bloody axe, blocks all the exits.")
	(STRENGTH 2)>

<OBJECT TRUNK	;"was TRUNK"
	(IN RESERVOIR)
	(SYNONYM TRUNK TREASURE)
	(DESC "trunk of jewels")
	(FLAGS TAKEBIT INVISIBLE)
	(FDESC
"Lying half buried in the mud is an old trunk, bulging with jewels.")
	(SIZE 35)
	(VALUE 15)
	(TVALUE 5)>

<OBJECT TOP-OF-TREE	;"was TTREE"
	(IN UP-A-TREE)
	(SYNONYM TREE)
	(ADJECTIVE LARGE)
	(DESC "large tree")
	(FLAGS NDESCBIT CLIMBBIT)>

<OBJECT CLIMBABLE-CLIFF	;"was CCLIF"
	(IN LOCAL-GLOBALS)
	(SYNONYM CLIFF)
	(ADJECTIVE ROCKY SHEER)
	(DESC "cliff")
	(ACTION CLIFF-OBJECT)
	(FLAGS NDESCBIT CLIMBBIT)>

<OBJECT WHITE-CLIFF	;"was WCLIF"
	(IN LOCAL-GLOBALS)
	(SYNONYM CLIFF CLIFFS)
	(ADJECTIVE WHITE)
	(DESC "white cliffs")
	(FLAGS NDESCBIT CLIMBBIT)
	(ACTION WCLIF-OBJECT)>

<OBJECT WRENCH	;"was WRENC"
	(IN MAINTENANCE-ROOM)
	(SYNONYM WRENCH)
	(DESC "wrench")
	(FLAGS TAKEBIT TOOLBIT)
	(SIZE 10)>

<OBJECT CONTROL-PANEL	;"was CPANL"
	(IN DAM-ROOM)
	(SYNONYM PANEL)
	(ADJECTIVE CONTROL)
	(DESC "control panel")
	(FLAGS NDESCBIT)>

\

"SUBTITLE FOREST OBJECTS"

<OBJECT NEST	;"was NEST"
	(IN UP-A-TREE)
	(SYNONYM NEST)
	(DESC "bird's nest")
	(FLAGS BURNBIT OPENBIT NDESCBIT)
	(CAPACITY 20)>

<OBJECT CANARY	;"was GCANA"
	(IN EGG)
	(SYNONYM CANARY)
	(ADJECTIVE GOLD GOLDEN)
	(DESC "golden canary")
	(FLAGS TAKEBIT)
	(ACTION CANARY-OBJECT)
	(VALUE 6)
	(TVALUE 4)
	(FDESC
"There is a golden canary nestled in the egg.  Through a crystal window 
you can see intricate machinery inside.  It appears to have wound down.")>

<OBJECT BAUBLE	;"was BAUBL"
	(SYNONYM BAUBLE)
	(ADJECTIVE BRASS BEAUTIFUL)
	(DESC "brass bauble")
	(FLAGS TAKEBIT)
	(VALUE 1)
	(TVALUE 1)>

<OBJECT BROKEN-EGG	;"was BEGG"
	(SYNONYM EGG)
	(ADJECTIVE BROKEN)
	(DESC "broken egg")
	(FLAGS TAKEBIT CONTBIT OPENBIT)
	(CAPACITY 6)
	(TVALUE 2)>

<OBJECT GUNK	;"was GUNK"
	(SYNONYM GUNK PIECE SLAG)
	(ADJECTIVE VITREOUS)
	(DESC "piece of vitreous slag")
	(FLAGS TAKEBIT TRYTAKEBIT)
	(ACTION GUNK-FUNCTION)
	(SIZE 10)>

<OBJECT EGG	;"was EGG"
	(IN NEST)
	(SYNONYM EGG TREASURE)
	(ADJECTIVE ENCRUSTED JEWELED)
	(DESC "jewel-encrusted egg")
	(FLAGS TAKEBIT CONTBIT)
	(ACTION EGG-OBJECT)
	(VALUE 5)
	(TVALUE 5)
	(CAPACITY 6)
	(FDESC
"In the nest is a large egg encrusted with precious jewels and inlaid with 
gold, apparently scavenged somewhere by a childless songbird.")>

\

"SUBTITLE ROOMS"

"SUBTITLE CONDITIONAL EXIT FLAGS"

<GLOBAL CYCLOPS-FLAG <>>
<GLOBAL DEFLATE <>>
<GLOBAL DOME-FLAG <>>
<GLOBAL EMPTY-HANDED <>>
<GLOBAL LLD-FLAG <>>
<GLOBAL LOW-TIDE <>>
<GLOBAL MAGIC-FLAG <>>
<GLOBAL RAINBOW-FLAG <>>
<GLOBAL TROLL-FLAG <>>
<GLOBAL WON-FLAG <>>
<GLOBAL COFFIN-CURE <>>

"SUBTITLE FOREST AND OUTSIDE OF HOUSE"

<ROOM WEST-OF-HOUSE	;"was WHOUS"
      (IN ROOMS)
      (DESC "West of House")
      (NORTH TO NORTH-OF-HOUSE)
      (SOUTH TO SOUTH-OF-HOUSE)
      (EAST "The door is boarded and you can't remove the boards.")
      (SW TO STONE-BARROW IF WON-FLAG)
      (ACTION WEST-HOUSE)
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (GLOBAL WHITE-HOUSE BOARDS)>

<ROOM STONE-BARROW	;"was WHOUS"
      (IN ROOMS)
      (LDESC
"You are east of a massive stone tomb.  Through an open door you see 
darkness within.")
      (DESC "Stone Barrow")
      (NE TO WEST-OF-HOUSE)
      (ACTION STONE-BARROW-FCN)
      (FLAGS RLANDBIT ONBIT SACREDBIT)>

<ROOM NORTH-OF-HOUSE	;"was NHOUS"
      (IN ROOMS)
      (LDESC
"You are north of the white house.  There is no door here, and all the 
windows are boarded up.  To the north a narrow path enters the woods.")
      (DESC "North of House")
      (WEST TO WEST-OF-HOUSE)
      (EAST TO EAST-OF-HOUSE)
      (NORTH TO PATH)
      (SOUTH "The windows are all boarded.")
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (GLOBAL BOARDED-WINDOW BOARDS WHITE-HOUSE)>

<ROOM SOUTH-OF-HOUSE	;"was SHOUS"
      (IN ROOMS)
      (LDESC
"You are south of the white house. There is no door here, and all the 
windows are boarded.")
      (DESC "South of House")
      (WEST TO WEST-OF-HOUSE)
      (EAST TO EAST-OF-HOUSE)
      (NORTH "The windows are all boarded.")
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (GLOBAL BOARDED-WINDOW BOARDS WHITE-HOUSE)>

<ROOM EAST-OF-HOUSE	;"was EHOUS"
      (IN ROOMS)
      (DESC "Behind House")
      (NORTH TO NORTH-OF-HOUSE)
      (SOUTH TO SOUTH-OF-HOUSE)
      (EAST TO CANYON-VIEW)
      (WEST TO KITCHEN IF KITCHEN-WINDOW IS OPEN)
      (IN TO KITCHEN IF KITCHEN-WINDOW IS OPEN)
      (ACTION EAST-HOUSE)
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (GLOBAL WHITE-HOUSE KITCHEN-WINDOW)>

<ROOM FOREST-EDGE
      (IN ROOMS)
      (LDESC "You are on a path in a dimly-lit forest.  The path heads west 
into the heart of the forest, and to the southeast where the trees seem to 
thin out.")
      (DESC "Forest Edge")
      (UP "There is no tree here suitable for climbing.")
      (SE TO CANYON-VIEW)
      (WEST TO PATH)
      (ACTION FOREST-ROOM)
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (GLOBAL TREE SONGBIRD WHITE-HOUSE FOREST)>

<ROOM PATH	;"was FORE3"
      (IN ROOMS)
      (LDESC
"This is a path winding through a dimly-lit forest.  The path turns a corner 
here, heading south and east.  One large tree with some low branches stands 
at the edge of the path.")
      (DESC "Forest Path")
      (UP TO UP-A-TREE)
      (EAST TO FOREST-EDGE)
      (SOUTH TO NORTH-OF-HOUSE)
      (DOWN TO GRATING-ROOM
       IF GRATE IS OPEN ELSE "You can't go through the closed grating.")
      (ACTION FOREST-ROOM)
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (GLOBAL TREE SONGBIRD WHITE-HOUSE FOREST)>

<ROOM UP-A-TREE	;"was TREE"
      (IN ROOMS)
      (DESC "Up a Tree")
      (DOWN TO PATH)
      (UP "You cannot climb any higher.")
      (ACTION TREE-ROOM)
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (GLOBAL FOREST SONGBIRD WHITE-HOUSE)>

\

"SUBTITLE HOUSE"

<ROOM KITCHEN	;"was KITCH"
      (IN ROOMS)
      (DESC "Kitchen")
      (EAST TO EAST-OF-HOUSE IF KITCHEN-WINDOW IS OPEN)
      (WEST TO LIVING-ROOM)
      (OUT TO EAST-OF-HOUSE IF KITCHEN-WINDOW IS OPEN)
      (UP TO ATTIC)
      (DOWN "Only Santa Claus climbs down chimneys.")
      (ACTION KITCHEN-FCN)
      (FLAGS RLANDBIT ONBIT RHOUSEBIT SACREDBIT)
      (VALUE 10)
      (GLOBAL KITCHEN-WINDOW CHIMNEY STAIRS)>

<ROOM ATTIC	;"was ATTIC"
      (IN ROOMS)
      (LDESC "This is the attic.  The only exit is a stairway leading down.")
      (DESC "Attic")
      (DOWN TO KITCHEN)
      (FLAGS RLANDBIT RHOUSEBIT SACREDBIT)
      (GLOBAL STAIRS)>

<ROOM LIVING-ROOM	;"was LROOM"
      (IN ROOMS)
      (DESC "Living Room")
      (EAST TO KITCHEN)
      (WEST TO CYCLOPS-ROOM IF MAGIC-FLAG ELSE "The door is nailed shut.")
      (DOWN PER TRAP-DOOR-EXIT)	;"to CELLAR"
      (ACTION LIVING-ROOM-FCN)
      (FLAGS RLANDBIT ONBIT RHOUSEBIT SACREDBIT)
      (GLOBAL STAIRS)>

\

"SUBTITLE CELLAR AND VICINITY"

<ROOM CELLAR	;"was CELLA"
      (IN ROOMS)
      (DESC "Cellar")
      (NORTH TO TROLL-ROOM)
      (EAST TO STUDIO)
      (UP TO LIVING-ROOM IF TRAP-DOOR IS OPEN)
      (WEST
"You try to ascend the ramp, but it is impossible, and you slide back down.")
      (ACTION CELLAR-FCN)
      (FLAGS RLANDBIT)
      (VALUE 25)
      (GLOBAL TRAP-DOOR SLIDE STAIRS)>

<ROOM TROLL-ROOM	;"was MTROL"
      (IN ROOMS)
      (LDESC
"This is a small room with passages to the east and south and a
forbidding hole leading west.  Bloodstains and deep scratches mar the walls.")
      (DESC "The Troll Room")
      (SOUTH TO CELLAR)
      (NE TO RESERVOIR-SOUTH
       IF TROLL-FLAG ELSE "The troll fends you off with a menacing gesture.")
      (EAST TO ROUND-ROOM 
       IF TROLL-FLAG ELSE "The troll fends you off with a menacing gesture.")
      (WEST TO MAZE-1
       IF TROLL-FLAG ELSE "The troll fends you off with a menacing gesture.")
      (FLAGS RLANDBIT)>

<ROOM STUDIO	;"was STUDI"
      (IN ROOMS)
      (LDESC
"This appears to have been an artist's studio.  The walls and floors are 
splattered with paint.  At the west end of the room is an open door.  A 
narrow chimney leads up from a fireplace; although you might be able to 
get up it, it seems unlikely you could get back down.")
      (DESC "Studio")
      (WEST TO CELLAR) 
      (UP PER CHIMNEY-FUNCTION)	;"to KITCHEN"
      (FLAGS RLANDBIT)
      (GLOBAL CHIMNEY)
      (PSEUDO "DOOR" DOOR-PSEUDO "PAINT" PAINT-PSEUDO)>

\

"SUBTITLE MAZE"

<ROOM MAZE-1	;"was MAZE1"
      (IN ROOMS)
      (LDESC "This is part of a maze of twisty little passages, all alike.")
      (DESC "Maze")
      (EAST TO TROLL-ROOM)
      (NE TO MAZE-1)
      (NW TO MAZE-2)
      (WEST TO MAZE-3)
      (FLAGS RLANDBIT MAZEBIT)>

<ROOM MAZE-2	;"was MAZE2"
      (IN ROOMS)
      (LDESC "This is part of a maze of twisty little passages, all alike.")
      (DESC "Maze")
      (NORTH TO MAZE-1)
      (WEST TO MAZE-2)
      (SE TO MAZE-3)
      (DOWN TO MAZE-5)
      (FLAGS RLANDBIT MAZEBIT)>

<ROOM MAZE-3	;"was MAZE3"
      (IN ROOMS)
      (LDESC "This is part of a maze of twisty little passages, all alike.")
      (DESC "Maze")
      (WEST TO MAZE-2)
      (NORTH TO MAZE-1)
      (EAST TO DEAD-END-1)
      (UP TO MAZE-5)
      (FLAGS RLANDBIT MAZEBIT)>

<ROOM MAZE-4 
      (IN ROOMS)
      (LDESC "This is part of a maze of twisty little passages, all alike.")
      (DESC "Maze")
      (DOWN TO MAZE-5)
      (UP TO MAZE-6)
      (SOUTH TO MAZE-10)
      (WEST TO MAZE-8)
      (SE TO MAZE-7)
      (NW TO GRATING-ROOM)
      (FLAGS RLANDBIT MAZEBIT)>

<ROOM DEAD-END-1	;"was DEAD1"
      (IN ROOMS)
      (DESC "Dead End")
      (LDESC "You have come to a dead end in the maze.")
      (DOWN TO MAZE-3)
      (FLAGS RLANDBIT MAZEBIT)>

<ROOM MAZE-5	;"was MAZE5"
      (IN ROOMS)
      (LDESC "This is part of a maze of twisty little passages, all alike.
A skeleton, probably the remains of a luckless adventurer, lies here.")
      (DESC "Maze")
      (NW TO MAZE-2)
      (NORTH TO MAZE-3)
      (SW TO MAZE-4)
      (FLAGS RLANDBIT MAZEBIT)>

<ROOM DEAD-END-2	;"was DEAD2"
      (IN ROOMS)
      (DESC "Dead End")
      (LDESC "You have come to a dead end in the maze.")
      (SOUTH TO MAZE-6)
      (FLAGS RLANDBIT MAZEBIT)>

<ROOM MAZE-6	;"was MAZE6"
      (IN ROOMS)
      (LDESC "This is part of a maze of twisty little passages, all alike.")
      (DESC "Maze")
      (UP TO MAZE-6)
      (SE TO MAZE-4)
      (WEST TO DEAD-END-2)
      (DOWN TO MAZE-2) 
      (FLAGS RLANDBIT MAZEBIT)>

<ROOM MAZE-7	;"was MAZE7"
      (IN ROOMS)
      (LDESC "This is part of a maze of twisty little passages, all alike.")
      (UP TO MAZE-10)
      (WEST TO MAZE-4)
      (DOWN TO MAZE-5) 
      (FLAGS RLANDBIT MAZEBIT)>

<ROOM MAZE-8	;"was MAZE8"
      (IN ROOMS)
      (LDESC "This is part of a maze of twisty little passages, all alike.")
      (DESC "Maze")
      (SE TO MAZE-10)
      (EAST TO MAZE-9)
      (UP TO MAZE-4)
      (NORTH TO MAZE-8) 
      (FLAGS RLANDBIT MAZEBIT)>

<ROOM MAZE-9	;"was MAZE9"
      (IN ROOMS)
      (LDESC "This is part of a maze of twisty little passages, all alike.")
      (DESC "Maze")
      (NORTH TO MAZE-8)
      (SE TO CYCLOPS-ROOM)
      (SOUTH TO MAZE-10)
      (FLAGS RLANDBIT MAZEBIT)>

<ROOM MAZE-10	;"was MAZ10"
      (IN ROOMS)
      (LDESC "This is part of a maze of twisty little passages, all alike.")
      (DESC "Maze")
      (NE TO MAZE-8)
      (NW TO MAZE-7)
      (SW TO MAZE-4)
      (SOUTH TO MAZE-9)
      (FLAGS RLANDBIT MAZEBIT)>

<ROOM GRATING-ROOM	;"was MGRAT"
      (IN ROOMS)
      (DESC "Grating Room")
      (SOUTH TO MAZE-4)
      (UP TO PATH
       IF GRATE IS OPEN ELSE "The grating is closed.")
      (ACTION MAZE-11-FCN)
      (GLOBAL GRATE)
      (FLAGS RLANDBIT)>

\

"SUBTITLE CYCLOPS AND HIDEAWAY"

<ROOM CYCLOPS-ROOM	;"was CYCLO"
      (IN ROOMS)
      (DESC "Cyclops Room")
      (NORTH TO MAZE-9)
      (EAST TO LIVING-ROOM
       IF MAGIC-FLAG ELSE "The east wall is solid rock.")
      (UP TO TREASURE-ROOM
       IF CYCLOPS-FLAG
        ELSE "The cyclops doesn't look like he'll let you past.")
      (ACTION CYCLOPS-ROOM-FCN)
      (FLAGS RLANDBIT)
      (GLOBAL STAIRS)>

<ROOM TREASURE-ROOM	;"was TREAS"
      (IN ROOMS)
      (LDESC
"This room is full of discarded bags, which crumble at your touch.  There 
is an exit down a staircase.")
      (DESC "Thief's Den")
      (DOWN TO CYCLOPS-ROOM)
      (ACTION TREASURE-ROOM-FCN)
      (FLAGS RLANDBIT)
      (VALUE 25)
      (GLOBAL STAIRS)>

\

"SUBTITLE RESERVOIR AREA"

<ROOM RESERVOIR-SOUTH	;"was RESES"
      (IN ROOMS)
      (DESC "Reservoir South")
      (SOUTH TO ROUND-ROOM)
      (SW TO TROLL-ROOM)
      (EAST TO DAM-ROOM)
      (NORTH TO RESERVOIR
       IF LOW-TIDE ELSE "You are not equipped for swimming.")
      (ACTION RESERVOIR-SOUTH-FCN)
      (FLAGS RLANDBIT)
      (GLOBAL GLOBAL-WATER)
      (PSEUDO "LAKE" LAKE-PSEUDO)>

<ROOM RESERVOIR	;"was RESER"
      (IN ROOMS)
      (DESC "Reservoir")
      (LDESC
"You are on what used to be a large lake, but which is now a large
mud pile.  There are 'shores' to the north and south.")
      (NORTH TO RESERVOIR-NORTH)
      (SOUTH TO RESERVOIR-SOUTH)
      (FLAGS RWATERBIT )
      (GLOBAL GLOBAL-WATER)>

<ROOM RESERVOIR-NORTH	;"was RESEN"
      (IN ROOMS)
      (DESC "Reservoir North")
      (SOUTH TO RESERVOIR)
      (UP TO DUSTY-CAVE)
      (ACTION RESERVOIR-NORTH-FCN)
      (FLAGS RLANDBIT)
      (GLOBAL GLOBAL-WATER STAIRS)
      (PSEUDO "LAKE" LAKE-PSEUDO)>

<ROOM WINDY-CAVE	;"was CAVE2"
      (IN ROOMS)
      (LDESC
"This is a tiny cave with an entrance on the north, and a 
forbidding staircase leading down.")
      (DESC "Windy Cave")
      (NORTH TO ROUND-ROOM)
      (DOWN TO ENTRANCE-TO-HADES)
      (FLAGS RLANDBIT)
      (GLOBAL STAIRS)>

<ROOM DUSTY-CAVE 	;"was PASS4"
      (IN ROOMS)
      (LDESC
"This is a small cave with exits on the east and west.")
      (DESC "Dusty Cave")
      (WEST TO SLIDE-ROOM)
      (EAST TO RESERVOIR-NORTH)
      (FLAGS RLANDBIT)>

\

"SUBTITLE ROUND ROOM AND VICINITY"

<ROOM ROUND-ROOM	;"was CAROU"
      (IN ROOMS)
      (LDESC
"This is a circular stone room with passages in all directions, although 
several have been blocked by cave-ins.")
      (DESC "Round Room")
      (EAST TO WHITE-CLIFFS)
      (WEST TO TROLL-ROOM)
      (NORTH TO RESERVOIR-SOUTH)
      (SOUTH TO WINDY-CAVE)
      (SE TO DOME-ROOM)
      (FLAGS RLANDBIT)>

<ROOM ENTRANCE-TO-HADES	
      (IN ROOMS)
      (DESC "Entrance to Hades")
      (UP TO WINDY-CAVE)
      (IN TO LAND-OF-LIVING-DEAD
       IF LLD-FLAG
       ELSE "Some invisible force prevents you from passing through the gate.")
      (SOUTH TO LAND-OF-LIVING-DEAD
       IF LLD-FLAG
       ELSE "Some invisible force prevents you from passing through the gate.")
      (ACTION LLD-ROOM)
      (FLAGS RLANDBIT ONBIT)
      (PSEUDO "GATE" GATE-PSEUDO)>

<ROOM LAND-OF-LIVING-DEAD	;"was LLD2"
      (IN ROOMS)
      (LDESC
"You have entered the Land of the Living Dead. You can hear the sounds of
thousands of lost souls weeping and moaning.  A passage exits to the north.")
      (DESC "Land of the Dead")
      (OUT TO ENTRANCE-TO-HADES)
      (NORTH TO ENTRANCE-TO-HADES)
      (FLAGS RLANDBIT ONBIT)>

\

"SUBTITLE DOME, TEMPLE, EGYPT"

<ROOM EGYPT-ROOM	;"was EGYPT"
      (IN ROOMS)
      (LDESC
"This is a former Egyptian tomb. There is an ascending staircase to the west.")
      (DESC "Egyptian Room")
      (WEST TO NORTH-TEMPLE)
      (UP TO NORTH-TEMPLE)
      (FLAGS RLANDBIT)
      (GLOBAL STAIRS)>

<ROOM DOME-ROOM	;"was DOME"
      (IN ROOMS)
      (DESC "Dome Room")
      (NW TO DOME-ROOM)
      (DOWN TO TORCH-ROOM
       IF DOME-FLAG ELSE "You cannot go down without fracturing many bones.")
      (ACTION DOME-ROOM-FCN)
      (FLAGS RLANDBIT)
      (GLOBAL DOME)>

<ROOM NORTH-TEMPLE	;"was TEMP1"
      (IN ROOMS)
      (LDESC
"This is the north end of a large temple.  Engraved on the east wall is 
a prayer in a long-forgotten language.  Below the prayer is a staircase 
leading down.")
      (DESC "Temple")
      (DOWN TO EGYPT-ROOM)
      (EAST TO EGYPT-ROOM)
      (SOUTH TO SOUTH-TEMPLE)
      (UP "You cannot reach the rope.")
      (ACTION TORCH-ROOM-FCN)
      (GLOBAL DOME STAIRS)
      (FLAGS RLANDBIT ONBIT SACREDBIT)>

<ROOM SOUTH-TEMPLE	;"was TEMP2"
      (IN ROOMS)
      (LDESC
"You are next to the altar at the south end of the temple.  In one corner
is a small hole in the floor.")
      (DESC "Altar")
      (NORTH TO NORTH-TEMPLE)
      (DOWN TO ENTRANCE-TO-HADES
       IF COFFIN-CURE
       ELSE "You haven't a prayer of getting the coffin down that hole.")
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (ACTION SOUTH-TEMPLE-FCN)>
******ADD TORCH******

\

"SUBTITLE FLOOD CONTROL DAM #3"

<ROOM DAM-ROOM	;"was DAM"
      (IN ROOMS)
      (DESC "Dam")
      (DOWN TO DAM-BASE)
      (NORTH TO MAINTENANCE-ROOM)
      (WEST TO RESERVOIR-SOUTH)
      (ACTION DAM-ROOM-FCN)
      (FLAGS RLANDBIT ONBIT)
      (GLOBAL GLOBAL-WATER)>

<ROOM MAINTENANCE-ROOM	;"was MAINT"
      (IN ROOMS)
      (LDESC
"This was maintenance room for Flood Control Dam #3.  On the wall is an 
important-looking button.  The west wall contains a door.")
      (DESC "Maintenance Room")
      (WEST TO DAM-ROOM)
      (FLAGS RLANDBIT)>

\

"SUBTITLE RIVER AREA"

<ROOM DAM-BASE	;"was DOCK"
      (IN ROOMS)
      (LDESC
"You are at the base of the dam, on a bank of the river Frigid.")
      (DESC "Dam Base")
      (UP TO DAM-ROOM)
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (GLOBAL GLOBAL-WATER RIVER)>

<ROOM RIVER-1	;"was RIVR1"
      (IN ROOMS)
      (LDESC
"You are on a quiet section of the Frigid River near the Dam.  There is 
a landing on the west shore.")
      (DESC "Frigid River")
      (UP "The current prevents upstream travel.")
      (WEST TO DAM-BASE)
      (LAND TO DAM-BASE)
      (DOWN TO RIVER-2)
      (EAST "The White Cliffs prevent your landing here.")
      (FLAGS RWATERBIT SACREDBIT)
      (GLOBAL GLOBAL-WATER RIVER)>

<ROOM RIVER-2	;"was RIVR3"
      (IN ROOMS)
      (LDESC
"The river descends into a valley with a narrow beach on the west shore.  
In the distance a rumbling can be heard.")
      (DESC "Frigid River")
      (UP "You cannot go upstream due to strong currents.")
      (DOWN TO RIVER-3)
      (LAND TO WHITE-CLIFFS)
      (WEST TO WHITE-CLIFFS)
      (FLAGS RWATERBIT SACREDBIT)
      (GLOBAL GLOBAL-WATER RIVER)>

<ROOM WHITE-CLIFFS
      (IN ROOMS)
      (LDESC
"You are on a narrow beach at the base of the White Cliffs.  A passage 
leads west into the Cliffs.")
      (DESC "White Cliffs Beach")
      (WEST TO ROUND-ROOM IF DEFLATE ELSE "The path is too tight.")
      (ACTION WHITE-CLIFFS-FUNCTION)
      (FLAGS RLANDBIT SACREDBIT )
      (GLOBAL GLOBAL-WATER WHITE-CLIFF RIVER)>

<ROOM RIVER-3	;"was RIVR4"
      (IN ROOMS)
      (LDESC
"The river is running faster here, and the roar of rushing water is almost 
unbearable.  You can see beaches on both the east and west shores.")
      (DESC "Frigid River")
      (UP "You cannot go upstream due to strong currents.")
      (LAND TO SANDY-BEACH)
      (EAST TO SANDY-BEACH)
      (ACTION RIVR4-ROOM)
      (FLAGS RWATERBIT SACREDBIT)
      (GLOBAL GLOBAL-WATER RIVER)>

<ROOM SANDY-BEACH	;"was BEACH"
      (IN ROOMS)
      (LDESC
"You are on a large sandy beach on the east shore of the river.  A path runs 
along the river to the south, and a cave that is partially buried in sand 
lies to the northeast.")
      (DESC "Sandy Beach")
      (NE TO SANDY-CAVE)
      (SOUTH TO ARAGAIN-FALLS)
      (FLAGS RLANDBIT SACREDBIT)
      (GLOBAL GLOBAL-WATER RIVER)>

<ROOM SANDY-CAVE	;"was TCAVE"
      (IN ROOMS)
      (LDESC
"This is a sand-filled cave whose exit is to the southwest.")
      (DESC "Sandy Cave")
      (SW TO SANDY-BEACH)
      (FLAGS RLANDBIT)>

<ROOM ARAGAIN-FALLS	;"was FALLS"
      (IN ROOMS)
      (DESC "Aragain Falls")
      (WEST TO END-OF-RAINBOW IF RAINBOW-FLAG)
      (DOWN "It's a long way...")
      (NORTH TO SANDY-BEACH)
      (UP TO END-OF-RAINBOW IF RAINBOW-FLAG)
      (ACTION FALLS-ROOM)
      (FLAGS RLANDBIT SACREDBIT)
      (GLOBAL GLOBAL-WATER RIVER RAINBOW)>

<ROOM END-OF-RAINBOW	;"was POG"
      (IN ROOMS)
      (LDESC
"This is a small beach on the Frigid River below the Falls.  A rainbow 
crosses over the falls to the east and a path leads to the southwest.")
      (DESC "End of Rainbow")
      (UP TO ARAGAIN-FALLS IF RAINBOW-FLAG)
      (EAST TO ARAGIAN-FALLS IF RAINBOW-FLAG)
      (SW TO CANYON-BOTTOM)
      (FLAGS RLANDBIT ONBIT )
      (GLOBAL GLOBAL-WATER RAINBOW RIVER)>

<ROOM CANYON-BOTTOM	;"was CLBOT"
      (IN ROOMS)
      (LDESC
"You are at the base of a river canyon near the flowing runoff of Aragain 
Falls. The cliff wall may be climbable, and to the northeast is a narrow
path.")
      (DESC "Canyon Bottom")
      (UP TO CANYON-VIEW)
      (NE TO END-OF-RAINBOW)
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (GLOBAL GLOBAL-WATER CLIMBABLE-CLIFF RIVER)>

<ROOM CANYON-VIEW	;"was CLTOP"
      (IN ROOMS)
      (LDESC
"You are atop the west wall of a great canyon.  From here there is a superb
view of the Frigid River as it flows out of a dark cavern, flanked
by towering white cliffs.  Below rainbow-clad Aragain Falls, the river twists 
into a passage which is impossible to enter. Paths enter the forest to
the west and north.  It is possible to climb down into the canyon from here.")
      (DESC "Canyon View")
      (DOWN TO CLIFF-BOTTOM)
      (WEST TO EAST-OF-HOUSE)
      (NORTH TO FOREST-EDGE)
      (FLAGS RLANDBIT ONBIT SACREDBIT)
      (GLOBAL CLIMBABLE-CLIFF RIVER)>

\

"SUBTITLE COAL MINE AREA"

<ROOM MINE-ENTRANCE	;"was ENTRA"
      (IN ROOMS)
      (LDESC

"You are at the entrance of a disused coal mine.  Strange squeaky sounds 
come from a shaft leading into the north wall, and there is another exit 
to the south.")
      (DESC "Mine Entrance")
      (SOUTH TO SLIDE-ROOM)
      (IN TO BAT-ROOM)
      (NORTH TO BAT-ROOM)
      (FLAGS RLANDBIT)>

<ROOM BAT-ROOM	;"was BATS"
      (IN ROOMS)
      (DESC "Bat Room")
      (SOUTH TO MINE-ENTRANCE)
      (EAST TO SHAFT-ROOM)
      (ACTION BATS-ROOM)
      (FLAGS RLANDBIT SACREDBIT)>

<ROOM SHAFT-ROOM	;"was TSHAF"
      (IN ROOMS)
      (LDESC
"This is a large room with exits to the west and north.  In the middle of 
the room is a small shaft descending through the floor into darkness below.
Constructed over the top of the shaft is a metal framework to which a heavy 
iron chain is attached.  A foul odor comes from the room to the north.")
      (DESC "Shaft Room")
      (DOWN "You'd never fit.")
      (WEST TO BAT-ROOM)
      (NORTH TO SMELLY-ROOM)
      (FLAGS RLANDBIT)>

<ROOM GAS-ROOM	;"was BOOM"
      (IN ROOMS)
      (LDESC
"This room smells strongly of coal gas.  Tunnels lead south and east.")
      (DESC "Gas Room")
      (SOUTH TO SHAFT-ROOM)
      (EAST TO MINE-1)
      (ACTION BOOM-ROOM)
      (FLAGS RLANDBIT SACREDBIT)
      (GLOBAL STAIRS)
      (PSEUDO "GAS" GAS-PSEUDO "ODOR" GAS-PSEUDO)>

<ROOM DEAD-END-5	;"was DEAD7"
      (IN ROOMS)
      (DESC "Dead End")
      (LDESC "You have come to a dead end in the mine.")
      (NORTH TO TIMBER-ROOM)
      (FLAGS RLANDBIT)>

<ROOM TIMBER-ROOM	;"was TIMBE"
      (IN ROOMS)
      (LDESC
"This is a long east-west passage which is cluttered with broken timbers.  
At the east end of the room, a rickety ladder leads through an opening in 
the roof.  A strong draft comes from the west where the room narrows 
considerably.")
      (DESC "Timber Room")
      (UP TO MINE-3)
      (WEST TO LOWER-SHAFT
       IF EMPTY-HANDED
       ELSE "You cannot fit through this passage with that load.")
      (ACTION NO-OBJS)
      (FLAGS RLANDBIT SACREDBIT)>

<ROOM LOWER-SHAFT	;"was BSHAF"
      (IN ROOMS)
      (LDESC
"This is a drafty room at the bottom of a long shaft. To the south is a 
passageway and to the east a very narrow crack. In the shaft can be seen 
a heavy iron chain.")
      (DESC "Drafty Room")
      (SOUTH TO MACHINE-ROOM)
      (OUT TO TIMBER-ROOM
       IF EMPTY-HANDED
       ELSE "You cannot fit through this passage with that load.")
      (EAST TO TIMBER-ROOM
       IF EMPTY-HANDED
       ELSE "You cannot fit through this passage with that load.")
      (UP "The chain is not climbable.")
      (ACTION NO-OBJS)
      (FLAGS RLANDBIT SACREDBIT)>

<ROOM MACHINE-ROOM	;"was MACHI"
      (IN ROOMS)
      (DESC "Machine Room")
      (NORTH TO LOWER-SHAFT)
      (ACTION MACHINE-ROOM-FCN)
      (FLAGS RLANDBIT)>

\

"SUBTITLE COAL MINE"

<ROOM MINE-1	;"was MINE1"
      (IN ROOMS)
      (LDESC "This is a non-descript part of a coal mine.")
      (DESC "Coal Mine")
      (WEST TO GAS-ROOM)
      (SOUTH TO MINE-1)
      (NORTH TO MINE-2)
      (FLAGS RLANDBIT)>

<ROOM MINE-2	;"was MINE2"
      (IN ROOMS)
      (LDESC "This is a non-descript part of a coal mine.")
      (DESC "Coal Mine")
      (NE TO MINE-2)
      (NW TO MINE-1)
      (SOUTH TO MINE-3)
      (FLAGS RLANDBIT)>

<ROOM MINE-3	;"was MINE3"
      (IN ROOMS)
      (LDESC "This is a non-descript part of a coal mine.  The top of a 
rickety ladder pokes through a hole in the floor.")
      (DESC "Coal Mine")
      (WEST TO MINE-3)
      (DOWN TO TIMBER-ROOM)
      (EAST TO MINE-2)
      (FLAGS RLANDBIT)>

<ROOM SLIDE-ROOM	;"was SLIDE"
      (IN ROOMS)
      (LDESC
"This is a small chamber, which appears to have been part of a coal mine.
There are openings to the north and east, and a steep metal slide twisting 
downward.")
      (DESC "Slide Room")
      (EAST TO DUSTY-CAVE)
      (NORTH TO MINE-ENTRANCE)
      (DOWN TO CELLAR)
      (FLAGS RLANDBIT)
      (GLOBAL SLIDE)>

\

;"RANDOM TABLES FOR WALK-AROUND"

<GLOBAL HOUSE-AROUND
  <LTABLE WEST-OF-HOUSE NORTH-OF-HOUSE EAST-OF-HOUSE SOUTH-OF-HOUSE
	  WEST-OF-HOUSE>>

<GLOBAL FOREST-AROUND
  <LTABLE FOREST-1 FOREST-2 PATH FOREST-1>>

<GLOBAL IN-HOUSE-AROUND
  <LTABLE LIVING-ROOM KITCHEN ATTIC KITCHEN>>

<GLOBAL ABOVE-GROUND
  <LTABLE WEST-OF-HOUSE NORTH-OF-HOUSE EAST-OF-HOUSE SOUTH-OF-HOUSE
	  FOREST-1 FOREST-2 PATH GRATING-CLEARING
	  CANYON-VIEW>>