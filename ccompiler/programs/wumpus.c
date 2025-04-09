/*
 * Hunt the Wumpus 2015
 * by Daniele Olmisani <daniele.olmisani@gmail.com>
 *
 * compile:
 * gcc -Wall -std=c99 wumpus.c -o wumpus
 *
 * usage:
 * ./wumpus [-h] [-s seed] [-d]
 *
 * see also:
 * wumpus.c by Eric S. Raymond <esr@snark.thyrsus.com>
 */

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int arrows;
int debug = 0;	
int rand_val = 29;
int rand_inc=1;

#define YOU	    0
#define WUMPUS	1
#define PIT1	2
#define PIT2	3
#define BATS1	4
#define BATS2	5
#define LOCS	6

int loc[LOCS];

#define NOT	     0
#define WIN	     1
#define LOSE	2

int finished;

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
    {12,15,18},
};

int getnum(char* prompt) {

    int n;
    print(prompt);
    n = scann();

    return n;
}

int getlet(char* prompt) {

    char c = '\n';

    print(prompt);
    while (c == '\n') {
      c = getchar();
    }

    return toupper(c);
}

void print_instructions() {

  print("Welcome to 'hunt the wumpus'\n");
  print("The wumpus lives in a cave of 20 rooms. Each room\n");
  print("has 3 tunnels leading to other rooms.\n"); 
  print("Look at a dodecahedron to see how this works.\n");
  print("\n");
  print(" Hazards:\n");
  print(" Bottomless pits: Two rooms have bottomless pits in them\n");
  print(" If you go there, you fall into the pit (& lose!)\n");
  print(" SUPER BATS     : TWO OTHER ROOMS HAVE SUPER BATS. IF YOU\n");
  print(" GO THERE, A BAT GRABS YOU AND TAKES YOU TO SOME OTHER\n");
  print(" ROOM AT RANDOM. (WHICH MAY BE TROUBLESOME)\n\n");
  print(" WUMPUS:\n");
  print(" THE WUMPUS IS NOT BOTHERED BY HAZARDS (HE HAS SUCKER\n");
  print(" FEET AND IS TOO BIG FOR A BAT TO LIFT).  USUALLY\n");
  print(" HE IS ASLEEP.  TWO THINGS WAKE HIM UP: YOU SHOOTING AN\n");
  print(" ARROW OR YOU ENTERING HIS ROOM.\n");
  print(" IF THE WUMPUS WAKES HE MOVES (P=.75) ONE ROOM\n");
  print(" OR STAYS STILL (P=.25).  AFTER THAT, IF HE IS WHERE YOU\n");
  print(" ARE, HE EATS YOU UP AND YOU LOSE!\n");
  print("\n");
  print(" YOU:\n");
  print(" EACH TURN YOU MAY MOVE OR SHOOT A CROOKED ARROW\n");
  print(" MOVING:  YOU CAN MOVE ONE ROOM (THRU ONE TUNNEL)\n");
  print(" ARROWS:  YOU HAVE 5 ARROWS.  YOU LOSE WHEN YOU RUN OUT\n");
  print(" EACH ARROW CAN GO FROM 1 TO 5 ROOMS. YOU AIM BY TELLING\n");
  print("   THE COMPUTER THE ROOM#S YOU WANT THE ARROW TO GO TO.\n");
  print("   IF THE ARROW CAN'T GO THAT WAY (IF NO TUNNEL) IT MOVES\n");
  print("   AT RANDOM TO THE NEXT ROOM.\n");
  print("     IF THE ARROW HITS THE WUMPUS, YOU WIN.\n");
  print("     IF THE ARROW HITS YOU, YOU LOSE.\n");
  print(" WARNINGS:\n");
  print(" WHEN YOU ARE ONE ROOM AWAY FROM A WUMPUS OR HAZARD,\n");
  print(" THE COMPUTER SAYS:\n");
  print(" WUMPUS:  'I SMELL A WUMPUS'\n");
  print(" BAT   :  'BATS NEARBY'\n");
  print(" PIT   :  'I FEEL A DRAFT'\n");
  print("\n");
}

void show_room() {
    int room, k;
    print("\n");

    for (k = 0; k < 3; k++) {

	   room = cave[loc[YOU]][k];

	   if (room == loc[WUMPUS]) {
	       print("I SMELL A WUMPUS!\n");
	   } else if (room == loc[PIT1] || room == loc[PIT2]) {
	       print("I FEEL A DRAFT\n");
	   } else if (room == loc[BATS1] || room == loc[BATS2]) {
	       print("BATS NEARBY!\n");
       }
    }

    print("YOU ARE IN ROOM "); print_unsigned(loc[YOU]+1); print("\n");

    print("TUNNELS LEAD TO "); 
    print_unsigned(cave[loc[YOU]][0]+1); print(", ");
    print_unsigned(cave[loc[YOU]][1]+1); print(", ");
    print_unsigned(cave[loc[YOU]][2]+1);
    print("\n\n");
}

int move_or_shoot() {

    int c = -1;

    while ((c != 'S') && (c != 'M')) {
        c = getlet("SHOOT OR MOVE (S-M): ");
    }

    return (c == 'S') ? 1 : 0;
}


void move_wumpus() {
  int k;
    k = rand2() % 4;

    if (k < 3) {
       loc[WUMPUS] = cave[loc[WUMPUS]][k];
    }

    if (loc[WUMPUS] == loc[YOU]) {
        print("TSK TSK TSK - WUMPUS GOT YOU!\n");
        finished = LOSE;
    }
}


void shoot() {

    int path[5];
    int scratchloc = -1;
  int len, k;

    finished = NOT;

    len = -1;
    while (len < 1 || len > 5) {
        len = getnum("\nNUMBER OF ROOMS (1-5): ");
    }

    k = 0;
    while (k < len) {
        path[k] = getnum("ROOM #") - 1;

        if ((k>1) && (path[k] == path[k - 2])) {
            print("ARROWS AREN'T THAT CROOKED - TRY ANOTHER ROOM\n");
            continue; 
       } 

       k++;
    }
 
    scratchloc = loc[YOU];

    for (k = 0; k < len; k++) {

        if ((cave[scratchloc][0] == path[k]) ||
            (cave[scratchloc][1] == path[k]) ||
            (cave[scratchloc][2] == path[k])) {

            scratchloc = path[k];
        } else {
            scratchloc = cave[scratchloc][rand2()%3];
        }

        if (scratchloc == loc[WUMPUS]) {

            print("AHA! YOU GOT THE WUMPUS!\n");
            finished = WIN;

        } else if (scratchloc == loc[YOU]) {

            print("OUCH! ARROW GOT YOU!\n");
            finished = LOSE;
        }

        if (finished != NOT) {
            return;
        }
    }

	print("MISSED\n");

	move_wumpus();

	if (--arrows <= 0) {
	    finished = LOSE;
    }
}


void move() {
  int scratchloc;

    scratchloc = -1;
    while (scratchloc == -1) {

        scratchloc = getnum("\nWHERE TO: ")- 1;

        if (scratchloc < 0 || scratchloc > 19) {
            scratchloc = -1;
            continue;
        }

        if ((cave[loc[YOU]][0] != scratchloc) &
            (cave[loc[YOU]][1] != scratchloc) &
            (cave[loc[YOU]][2] != scratchloc) &
            (loc[YOU] != scratchloc)) {

            print("NOT POSSIBLE\n");

            scratchloc = -1;
            continue;
        }
    }
   
    loc[YOU] = scratchloc;

    while ((scratchloc == loc[BATS1]) || (scratchloc == loc[BATS2])) {
        print("ZAP--SUPER BAT SNATCH! ELSEWHEREVILLE FOR YOU!\n");
        scratchloc = loc[YOU] = rand2()%20;
    }

    if (scratchloc == loc[WUMPUS]) {
	   print("... OOPS! BUMPED A WUMPUS!\n");
	   move_wumpus();
    } 

    if (scratchloc == loc[PIT1] || scratchloc == loc[PIT2]) {
	   print("YYYYIIIIEEEE . . . FELL IN PIT\n");
	   finished = LOSE;
    }
}

int rand2(){
    rand_val=rand_val+rand_inc;
    rand_inc++;
    return rand_val;
}

void game_setup() {
  int j, k;
    int v;

    for (j = 0; j < LOCS; j++) {
        loc[j] = -1;
        while (loc[j] < 0) {
            v = rand2();
            loc[j] = v % 20;
            
            for (k=0; k < j - 1; k++) {
                if (loc[j] == loc[k]) {
                    loc[j] = -1;
                }
           }
       }
    }
}


void game_play() {

    arrows = 5;

    print("HUNT THE WUMPUS\n");

    if (debug) {
        print("Wumpus is at "); print_unsigned(loc[WUMPUS]+1);
        print(", pits at "); print_unsigned(loc[PIT1]+1);
        print(" & "); print_unsigned(loc[PIT2]+1);
        print(", bats at "); print_unsigned(loc[BATS1]+1);
        print(" & "); print_unsigned(loc[BATS2]+1);
    }

    finished = NOT;
    while (finished == NOT) {

        show_room();
        if (move_or_shoot()) {
            shoot();
        } else {
            move();
        }
    }

    if (finished == WIN) {
        print("HEE HEE HEE - THE WUMPUS'LL GET YOU NEXT TIME!!\n");
    }

    if (finished == LOSE) {
        print("HA HA HA - YOU LOSE!\n");
    }

    int c;
    c = getlet("NEW GAME (Y-N): ");

    if (c == 'N') {
        exit(1);
    }
  
}



int main() {
    int c;

    c = getlet("INSTRUCTIONS (Y-N): ");

    if (c == 'Y') {
	   print_instructions();
    }

    do { 
        game_setup();
        game_play();

    } while (getlet("NEW GAME (Y-N): ") != 'N');

    return 0;
}