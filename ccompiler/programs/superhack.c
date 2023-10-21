/*
 * superhack.c --- modern version of a classic adventure game
 *
 * Author: Eric S. Raymond <esr@snark.thyrsus.com>
 *
 * My update of a classic adventure game.  This code is no relation to
 * the elaborate dungeon game called `Hack'.
 *
 * Any resemblance to persons living or dead is strictly coincidental.  And
 * if you believe *that*...
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#include <stdio.h>
#include <ctype.h>
#include <string.h>

int path[5];
int j, k, scratchloc, pies;
char inp[BUFSIZ];		/* common input buffer */

#define NUMBERS "0123456789"
#define YOU	0
#define RMS	1
#define STARLET1	2
#define STARLET2	3
#define DROID1	4
#define DROID2	5
#define LUSER1	6
#define LUSER2	7
#define LOCS	8
int loc[LOCS];

#define NOT	0
#define WIN	1
#define LOSE	-1
int finished;


void IGNORE(int r){
do{
  if(r);
}while(0);
}

int cave[20][3] =
{
    {1,4,7},
    {0,2,9},
    {1,3,11},
    {2,4,13},
    {0,3,5},
    {4,6,14},
    {5,7,16},
    {0,6,8},
    {7,9,17},
    {1,8,10},
    {9,11,18},
    {2,10,12},
    {11,13,19},
    {3,12,14},
    {5,13,15},
    {14,16,19},
    {6,15,17},
    {8,16,18},
    {10,17,19},
    {12,15,18}
};

int FNA(){
  return rand() % 20;
}
int FNB(){
  return rand() % 3;
}
int FNC(){
  return rand() % 4;
}

int getlet(char *prompt){
    printf(prompt); printf("?");

  gets(inp);
  return(to_lower(inp[0]));
}

void PM(char *x){
  puts(x);
}

void print_instructions()
{
    PM("Welcome to `Hunt the Superhack'\n")

PM("   The superhack lives on the 9th floor of 45 Technology Square in");
PM("Cambridge, Massachusetts.  Your mission is to throw a pie in his face.\n");

    PM("   First, you'll have to find him.  A botched experiment by an MIT");
    PM("physics group has regularized the floor's topology, so that each");
    PM("room has exits to three other rooms.  (Look at a dodecahedron to");
    PM("see how this works --- if you don't know what a dodecahedron is,");
    PM("ask someone.)\n");

    PM("You:");
    PM("   Each turn you may move to an adjacent room or throw a pie.  If");
    PM("you run out of pies, you lose.  Each pie can pass through up to");
    PM("five rooms (connected by a continuous path from where you are).  You");
    PM("aim by telling the computer which rooms you want to throw through.");
    PM("If the path is incorrect (presumes a nonexistent connection) the ");
    PM("pie moves at random.");

    PM("   If a pie hits the superhack, you win. If it hits you, you lose!\n");

     puts("<Press return to continue>");
    IGNORE(gets(inp));
     putchar('\n');

    PM("Hazards:");
    PM("   Starlets --- two rooms contain lonely, beautiful women.  If you");
    PM("enter these, you will become fascinated and forget your mission as");
    PM("you engage in futile efforts to pick one up.  You weenie.");
    PM("   Droids --- two rooms are guarded by experimental AI security ");
    PM("droids.  If you enter either, the droid will grab you and hustle");
    PM("you off to somewhere else, at random.");
    PM("   Lusers --- two rooms contain hungry lusers.  If you blunder into");
    PM("either, they will eat one of your pies.");
    PM("   Superhack --- the superhack is not bothered by hazards (the");
    PM("lusers are in awe of him, he's programmed the droids to ignore him,");
    PM("and he has no sex life).  Usually he is hacking.  Two things can");
    PM("interrupt him; you throwing a pie or you entering his room.\n");
    PM("   On an interrupt, the superhack moves (3/4 chance) or stays where");
    PM("he is (1/4 chance).  After that, if he is where you are, he flames");
    PM("you and you lose!\n");

     puts("<Press return to continue>");
     gets(inp);
     putchar('\n');

    PM("Warnings:");
    PM("   When you are one room away from the superhack or a hazard,");
    PM("the computer says:");
    PM("   superhack:       \"I smell a superhack!\"");
    PM("   security droid:  \"Droids nearby!\"");
    PM("   starlet:         \"I smell perfume!\"");
    PM("   luser:           \"Lusers nearby!\"");

    PM("If you take too long finding the superhack, hazards may move.  You");
    PM("will get a warning when this happens.\n");

    PM("Commands:");
    PM("   Available commands are:\n");
    PM("  ?            --- print long instructions.");
    PM("  m <number>   --- move to room with given number.");
    PM("  t <numbers>  --- throw through given rooms.");
    PM("\nThe list of room numbers after t must be space-separated.  Anything");
    PM("other than one of these commands displays a short help message.");
}

void move_hazard(int where)
{
    int newloc;

 retry:
    newloc = FNA();
    for (j = 0; j < LOCS; j++)
	if (loc[j] == newloc)
	    goto retry;

    loc[where] = newloc;
}

void check_hazards()
{
    /* basic status report */
    printf("Room: "); printu(loc[YOU]+1); printf("\n");
    printf("Exit: "); printu(cave[loc[YOU]][0]+1); printf("\n");
    printf("Exit: "); printu(cave[loc[YOU]][1]+1); printf("\n");
    printf("Exit: "); printu(cave[loc[YOU]][2]+1); printf("\n");
    printf("Pies: "); printu(pies); printf("\n");

    /* maybe it's migration time */
    if (FNA() == 0)
	switch(2 + FNB())
	{
	case STARLET1:
	case STARLET2:
	    PM("Swish, swish, swish --- starlets are moving!");
	    move_hazard(STARLET1);
	    move_hazard(STARLET2);
	    break;

	case DROID1:
	case DROID2:
	    PM("Clank, clank, clank --- droids are moving!");
	    move_hazard(DROID1);
	    move_hazard(DROID2);
	    break;

	case LUSER1:
	case LUSER2:
	    PM("Grumble, grumble, grumble --- lusers are moving!");
	    move_hazard(LUSER1);
	    move_hazard(LUSER2);
	    break;
	}

    /* display hazard warnings */
    for (k = 0; k < 3; k++)
    {
	int room = cave[loc[YOU]][k];

	if (room == loc[RMS])
	     puts("I smell a superhack!");
	else if (room == loc[STARLET1] || room == loc[STARLET2])
	     puts("I smell perfume!");
	else if (room == loc[DROID1] || room == loc[DROID2])
	     puts("Droids nearby!");
	else if (room == loc[LUSER1] || room == loc[LUSER2])
	     puts("Lusers nearby!");
    }
}

void throw()
{
    //extern void check_shot(), move_superhack();
    int	j9;


    path[0]=scann();
    path[1]=scann();
    path[2]=scann();
    path[3]=scann();
    path[4]=scann();

    j9 = sscanf(inp + strcspn(inp, NUMBERS), "%d %d %d %d %d",
		    &path[0], &path[1], &path[2], &path[3], &path[4]);

    if (j9 < 1)
    {
	PM("Sorry, I didn't see any room numbers after your throw command.");
	return;
    }

    for (k = 0; k < j9; k++)
	if (k >= 2 && path[k] == path[k - 2])
	{
	     puts("Pies can't fly that crookedly --- try again.");
	    return;
	}

    scratchloc = loc[YOU];

    for (k = 0; k < j9; k++)
    {
	int	k1;

	for (k1 = 0; k1 < 3; k1++)
	{
	    if (cave[scratchloc][k1] == path[k])
	    {
		scratchloc = path[k];
		check_shot();
		if (finished != NOT)
		    return;
	    }

	}

	scratchloc = cave[scratchloc][FNB()];

	check_shot();

    }

    if (finished == NOT)
    {
	 puts("You missed.");

	scratchloc = loc[YOU];

	move_superhack();

	if (--pies <= 0)
	    finished = LOSE;
    }

}

void check_shot()
{
    if (scratchloc == loc[RMS])
    {
	 puts("Splat!  You got the superhack!  You win.");
	finished = WIN;
    }

    else if (scratchloc == loc[YOU])
    {
	 puts("Ugh!  The pie hit you!  You lose.");
	finished = LOSE;
    }
}

void move_superhack()
{
    k = FNC();

    if (k < 3)
	loc[RMS] = cave[loc[RMS]][k];

    if (loc[RMS] != loc[YOU])
	return;

     puts("The superhack flames you to a crisp.  You lose!");

    finished = LOSE;

}

void move()
{
    if (sscanf(inp + strcspn(inp, NUMBERS), "%d", &scratchloc) < 1)
    {
	PM("Sorry, I didn't see a room number after your `m' command.");
	return;
    }

    scratchloc--;

    for (k = 0; k < 3; k++)
	if (cave[loc[YOU]][k] == scratchloc)
	    goto goodmove;

    PM("You can't get there from here!");
    return;

goodmove:
    loc[YOU] = scratchloc;

    if (scratchloc == loc[RMS])
    {
	PM("Yow! You interrupted the superhack.");
	move_superhack();
    }
    else if (scratchloc == loc[STARLET1] || scratchloc == loc[STARLET2])
    {
	PM("You begin to babble at an unimpressed starlet.  You lose!");
	finished = LOSE;
    }
    else if (scratchloc == loc[DROID1] || scratchloc == loc[DROID2])
    {
	PM("Zap --- security droid snatch.  Elsewheresville for you!");
	scratchloc = loc[YOU] = FNA();
	goto goodmove;
    }
    else if (scratchloc == loc[LUSER1] || scratchloc == loc[LUSER2])
    {
	PM("Munch --- lusers ate one of your pies!");
	pies--;
    }
}

int main(int argc, char *argv[])
{
    if (argc >= 2 && strcmp(argv[1], "-s") == 0)
	srand(atoi(argv[2]));
    else
	srand((int)time((long *) 0));

    for (;;)
    {
    badlocs:
	for (j = 0; j < LOCS; j++)
	    loc[j] = FNA();

	for (j = 0; j < LOCS; j++)
	    for (k = 0; k < LOCS; k++)
		if (j == k)
		    continue;
		else if (loc[j] == loc[k])
		    goto badlocs;

	 puts("Hunt the Superhack");

	pies = 5;
	scratchloc = loc[YOU];
	finished = NOT;

	while (finished == NOT)
	{
	    int c;

	    check_hazards();

	    c = getlet("Throw, move or help [t,m,?]");

	    if (c == 't')
		throw();
	    else if (c == 'm')
		move();
	    else if (c == '?')
		print_instructions();
#ifdef DEBUG
	    else if (c == 'd')
	    {
		 printf("RMS is at %d, starlets at %d/%d, droids %d/%d, lusers %d/%d\n",
			      loc[RMS] + 1,
			      loc[STARLET1] + 1, loc[STARLET2] + 1,
			      loc[DROID1] + 1, loc[DROID2] + 1,
			      loc[LUSER1] + 1, loc[LUSER2] + 1);
	    }
#endif /* DEBUG */
	    else
	    {
		PM("Available commands are:\n");
		PM("  ?            --- print long instructions.");
		PM("  m <number>   --- move to room with given number.");
		PM("  t <numbers>  --- throw through given rooms.");
#ifdef DEBUG
		PM("  d            --- dump hazard locations.");
#endif /* DEBUG */
		PM("The list of room numbers after t must be space-separated");
	    }

	     putchar('\n');
	}

	if (getlet("Play again") != 'y')
	{
	    PM("Happy hacking!");
	    break;
	}
    }
    return 0;
}

/* superhack.c ends here */
