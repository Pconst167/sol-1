From umcaner0@cc.umanitoba.ca Wed Sep 14 20:16:09 1994
From: umcaner0@cc.umanitoba.ca (Richard Theodore Caners)
Newsgroups: rec.games.programmer
Subject: A method for sprite animation (long)
Date: 13 Sep 1994 23:01:51 GMT
Organization: The University of Manitoba
NNTP-Posting-Host: mira.cc.umanitoba.ca


Hi, what follows is a text file I wrote describing a method of
sprite animation I am using in a game.  I hope people find it
informative.

A SIMPLE METHOD FOR SPRITE ANIMATION

By Darren Gyles
* [Shameless Plug] 
  Author of HOOP 
  ( Avaliable at  ftp.funet.fi /pub/msdos/games/cards/hoop11.zip )

Note : The following implementation of sprite animation uses linked lists
fairly extensively.  If you are not familiar with this concept, get any
first year computer science textbook and look into it.

I have recently been programming a simple Galaxian type shoot-em-up and
needed a method for sprite animation.  This is the solution that I came up
with.  I was fairly pleased with the results.  I'm sure that this method is 
not unique, but I haven't seen anybody mention it before so I will take
a stab at it.

I am assuming that you already have your sprite graphics routines written.
I will not cover machine specific graphics routines, just algorithms for 
implementing sprites. 

This document describes a simple sprite system and then expands this
system to include animation.  Be forewarned that even though there is
quite a bit of code given, you will never get it to work unless you
understand the methods completely.  It is really not very hard, the 
most confusing thing are the linked lists.  Good luck.


THE BASIC IDEA BEHIND SPRITE ANIMATION

The basic idea behind sprite animation (or any animation, for that matter) 
is:

     Show frame 1 -> wait delay period -> Show frame 2 -> delay -> etc..

Pretty simple, but how do you implement this?


                          - IMPLEMENTATION -

GENERAL SPRITE STUFF

For this discussion I will assume you have a linked list of sprites, and
each node in the list represents a sprite and contains all the information
relevant to that sprite (of course you could use an array for this as well
with some simple modifications).  I am using C type pseudo code - I hope
that everybody can understand it.

Each node may look like:

struct sprite {

   int      xpos, ypos;     // X and Y coordinates for sprite
   int      xspeed, yspeed; // X and Y speed of sprite
   int      type;           // Type of sprite (ie 1 = ship, 2 = bullet etc..)
                            // These types will be defined by you
   char     background[256];
                    // Stores the piece of the background 
                    // that this sprite covers
   .
   .    // Various other parameters describing the sprite that you may 
   .    // require.
   .    // (ie does the sprite collide with other sprites?,
   .    //     does the sprite bounce around or just disappear at edge of
   .    //     the screen?  etc.. )
   .
   struct sprite  *next;  // Pointer to next sprite (NULL means end of list)

};

And you will have a pointer to the top of this list:

    struct sprite *sprite_list;

So you will have a list that looks like this:

sprite_list --> Sprite Data    /----> Sprite Data     /-->NULL
                Next ---------/       Next  ---------/


NOTE: For simplicity, I am assuming that all sprites are the same size.
Which is a dumb assumption, but it should be pretty easy to alter
these functions to work with variable sized elements.

You should have an add_sprite() function and a delete_sprite() function 
(which are not given here, but are pretty simple) which add and delete
elements to and from the linked list.  And you will have a function that 
looks like this:

// This function goes through the sprite list and updates all sprites
void do_sprites(void) {

   struct sprite *current;

   current = sprite_list;

   while (current != NULL) {

      // This function restores the background, by placing the 
      // data pointed to by current->background at current->xpos,
      // current->ypos.  You write this one.
      RESTORE_BACKGROUND(current->background, current->xpos, current->ypos);
      
      // Update x and y coordinates
      current->xpos = current->xpos + current->xspeed;
      current->ypos = current->ypos + current->yspeed;

      // Do whatever bounds checking or whatever you want here

      // This function will make a copy of the background that will be 
      // covered by the sprite in the array pointed to by 
      // current->background. You have to write this one too.
      CUT_BACKGROUND(current->background, current->xpos, current->ypos);

      // Draw sprite - This function draws the sprite at xpos, ypos
      // the current->type would indicate what data to use when drawing.
      // You'll have to write this one also.
      // Uses the sprite_data[] array which contains the bitmaps for the
      // sprites, see below for more details.
      DRAWSPRITE(sprite_data[current->type], current->xpos, current->ypos);

      current = current->next;
   }
}

You would call this function every time you want to move the sprites (ie
every time you go through your main loop).  Note that this is very simple
and you don't have to do it this way, I am only providing this example
to make the discussion of the animation more understandable.

To draw the sprite, you send the drawing function the address where the 
sprite data starts. This data would be stored in an array that looks 
something like:

unsigned char sprite_data[MAX_NO_OF_SPRITES][MAX_SIZE_OF_SPRITES];

So the data for sprite type 10 starts at sprite_data[10][0]. Remember that
I am assuming all sprites are the same size. 

So, when do we animate?  Right now.


ANIMATION

For animation I use linked lists.  You could use arrays instead, but 
I like linked lists because they can be referenced faster and more neatly.
The downside is that they are a little messy to set up and to deallocate when
finished.

Each particular sprite animation has its own linked list and each node
in that list represents a frame.  Each node has a structure that looks like:

struct frame{
  unsigned char *data;  // Pointer to the bitmap data for this frame.
                        // If you are using compiled bitmaps, you could put
                        // a pointer to the compiled bitmap function here.
  
  int           delay;  // This value indicates how long to wait before
                        // going to the next frame.

   struct frame *next;  // Pointer to the next frame
}

So a sprite that just does the same thing over and over again.  Say an
enemy ship that has blinking lights would have a linked list that looks
like :

/-->   FRAME 1      ---->  FRAME2         -----\
|      (Lights on)         (Lights off)        |
|                                              |
|                                              |
 \---------------------------------------------/

Note that this animation only has two frames, but you could have as many as
you like.  Also note that each frame has its own delay time so you can 
make some frames appear for longer than others.


Now this is where linked lists get a little messy, to create a linked
list that had the above format it would look like:

   struct frame *current, *last;

   ...
   
   current        = allocate( sizeof(struct frame) );
   // We store the pointer to the start of the animation in the array
   // ANIMATIONS, see below for more details.
   animations[0]  = current;                      
   current->data  = POINTER_TO_FRAME1_DATA;
   current->delay = 20;
   last           = current;

   current        = allocate( sizeof(struct frame) );
   current->data  = POINTER_TO_FRAME2_DATA;
   current->delay = 20;
   current->next  = last;
   last->next     = current;

   ...


Now assuming that we have several animation lists set up, how
do we keep track of them?  Simply use an array.  We can use our TYPE
field to index this array.  For example:

struct frame *animations[MAX_ANIMATIONS];

So say that element 0 in the animations[] array is a ship and element
1 is a bullet, then the array would look like:

    animations[0] --> Animation linked list for ship.
    animations[1] --> Animation linked list for bullet.

So suppose we are creating a sprite that has type 4.  We know that the 
animation starts at animations[4].


Now we must add a couple of fields to the sprite struct that was defined 
a little earlier in this document to help with our animation.  
These fields are:

struct sprite {
   ...
   struct frame *a_frame;   // The animation frame that we are currently on
   int          a_count;    // A counter that keeps track of the delay
   ...
};

So for each sprite we have these extra two fields.  Now when we are adding
a sprite to the sprite_list, in addition to initializing xpos, ypos, xspeed,
yspeed etc..  we have the following two lines:
 
   new_sprite->a_frame = animations[new_sprite->type];
   new_sprite->a_count = new_sprite->a_frame->delay;

So for each sprite, we now will know what animation frame we are currently 
on and how long we have left on this frame.

Each time we update the sprite, we subtract one from the a_count value.
When a_count == 0, we move to the next frame.  
   

Here is a new version of do_sprites() using animation:

void do_sprites(void) {

   struct sprite *current;

   current = sprite_list;

   while (current != NULL) {

      RESTORE_BACKGROUND(current->background, current->xpos, current->ypos);

      // NEW PART STARTS HERE
      current->a_count--;
      if (current->a_count ==0) {
         // If we have reached end of animation, move to next frame and
         // reset a_count.
         current->a_frame = current->a_frame->next;
         current->a_count = current->a_frame->delay;
      }
      // NEW PART ENDS HERE

      current->xpos = current->xpos + current->xspeed;
      current->ypos = current->ypos + current->yspeed;

      // Do whatever bounds checking or whatever you want here

      CUT_BACKGROUND(current->background, current->xpos, current->ypos);
      DRAWSPRITE(sprite_data[current->type], current->xpos, current->ypos);

      current = current->next;
   }
}

Once you have set up the animation linked list and added the sprite to 
the sprite linked list, every time you call do_sprites the animation is done
automatically.


FINITE ANIMATIONS

Finite animations are animations that don't have a loop, that is, they end.
Say for example an explosion, may have three frames: A small explosion,
a bigger explosion and the final biggest explosion.  Once this animation 
has ended we want to delete the explosion from sprite_list.  This is easy
to do.


The animation linked list for the described explosion would look like:

  EXPLOSION  ----->  EXPLOSION  -----> EXPLOSION -----> NULL
  FRAME # 1          FRAME # 2         FRAME # 3


The NEXT field of the last frame will be a NULL pointer.  So when you are
advancing an animation, simply check to see if the next frame if NULL, if
it is, then delete the sprite.

This alteration would look like:      

void do_sprites(void) 
{
   ...
      
      current->a_count--;
      if (current->a_count ==0) {
         // If we have reached end of animation, move to next frame and
         // reset a_count.
         if (current-a_frame->next == NULL)
            // This function deletes the sprite from sprite_list
            delete_sprite(current);
         else {
            current->a_frame = current->a_frame->next;
            current->a_count = current->a_frame->delay;
         }
      }

   ...
}


Two things I must mention:
   1. I didn't bother to show it in the above code fragment, but if you
      delete the sprite, make sure that you jump over the following lines
      that update the x and y positions and draw the sprite.  Since the node
      no longer exists, these operations are no longer valid.

   2. This has nothing to do with sprites, but it is important to
      realize that on MS-DOS machines comparing two pointers will
      not always work because of the segmented architecture. 

      This is important when deleting a node.  For example suppose
      CURRENT is the node to be deleted, and LAST is the node directly
      before CURRENT in the list.  To delete CURRENT we would do the 
      following:

          last->next = current->next;
          free(current);

      So we need to know which node precedes the node to be deleted.
      Since the nodes don't keep track of the previous node (only the next) 
      we must traverse the list and find the node that precedes the node 
      to be deleted.  But since we cannot compare pointers, we cannot simply 
      do the following: (current is a pointer to node to be deleted)

         last = sprite_list;
         while (last->next != current)
            last = last->next

      What I did was to give each node a unique nodeid, so to delete
      a node, do the following:

         last = sprite_list;
         while (last->next->nodeid != current->nodeid)
            last = last->next

      This version would work.  Remember that each node must have a UNIQUE 
      nodeid value.  I hope this makes sense,  if you are familiar with
      linked lists it should.  Although this isn't directly related to 
      sprite animation you must understand this problem if you wish to
      implement the system as described in this document.


CLEANING UP THE ANIMATIONS

When the program is done executing, we must deallocate all the memory
that is used up by the animation linked lists.  As I mentioned earlier, 
this is a little messy, but not too bad. (Also remember to deallocate all 
the nodes in the sprite_list linked list.  This is very easy to do.)

Remember that all the animations are pointed to by the array called
(not surprisingly) animations[].  For each element in this array, we 
delete the animation that is pointed to.

This is pretty simple, except that some of the animations have loops in them
so we cannot simply do the following.

   struct frame *current, *next;
   
   current = animations[0];
   while (current!=NULL) {
      next = current->next;
      free(current);
      current=next;
    }

What we must do is first check to see if the list is finite.  So what I do 
is follow the list for 10 frames and see if a NULL pointer is found, if we
find one, the list does not loop and we can use the above method.  If we 
don't find an end, (and we are assuming that no animations have 10 or
more frames) then we "break" the loop, turning the animation int a non-
looped list and delete the animation as above. This "breaking" looks
like:
    
   struct frame *current, *next;
   
   // Break the loop
   next = animations[0];
   current = next->current
   next->next = NULL;

   // Deallocate list
   while (current!=NULL) {
      next = current->next;
      free(current);
      current=next;
    }

It is good practice to always deallocate all dynamic memory before 
terminating your program, so always try to do it, even if it is a pain.


CONCLUSION

Well, that's pretty much it.  The basic idea is pretty simple, but I 
complicated it with all the implementation details.  I hope this makes 
sense to people.  

If you have any questions/comments/criticisims please feel free to E-mail 
me at umcaner0@ccu.umantioba.ca

Also feel free to send me any programs you write that uses this technique,
I would like to see if anybody can actually decipher this mess and 
get something working.







