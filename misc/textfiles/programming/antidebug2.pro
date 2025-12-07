;;
;;  Note by Uwe E. Schirm:
;;  This refers to the 'Anti Debugging Tricks' by Inbar Raz
;;  which is also found in the 80XXX Snippets as ANTIDBG.TXT
;;

Sun 24 Jan 93
By: Michael Forrest


Hi.  Here's release 1 of the Anti-Anti Debugging Tricks article.

 > In order to avoid tracing of a code, one usually disables the
 > interrupt via the 8259 Interrupt Controller, addressed by 
 > read/write actions to port 21h.

This is completely ineffective against Soft-ICE, which will still  break 
in even when the KB interrupt is disabled.  I've never seen a case where 
SI won't break into the code without your program actually reaching  out 
and unplugging the keyboard.

 > Just as a side notice, the keyboard may be also disabled by
 > commanding the Programmable Peripheral Interface (PPI), port 61h.

That code doesn't seem to do anything at all, even to debug.

 > This is quite an easy form of an anti-debugging trick. 
 > All you have to do is simply replace the vectors of interrupts 
 > debuggers use, or any other interrupt you will not be using or 
 > expecting to occur.

Any  debugger  that's  worth  anything these days  works  in  a  virtual 
machine.   That  means  that it keeps a  separate  interrupt  table  for 
itself.  If you try to get to it, you'll get a general protection  fault 
and  you'll crash when running under QEMM, Windows, OS/2, or  any  other 
protected mode system.

 > This method involves manipulations of the interrupt vectors,
 > mainly for proper activation of the algorithm. Such action, as
 > exampled, may be used to decrypt a code (see also 2.1), using 
 > data stored ON the vectors.

Again, debuggers keep separate interrupt tables for themselves.

 > This is a really nasty trick, and it should be used ONLY if you
 > are ABSOLUTELY sure that your programs needs no more debugging.

It  IS a really nasty trick against a real-mode debugger like  Debug  or 
something else available 5-10 years ago, but completely useless  against 
Soft-ICE, TD386, or any other protected mode debugger.

 > This method simply retains the value of the clock counter, updated 
 > by interrupt 08h, and waits in an infinite loop until the value 
 > changes. This method is usefull only against RUN actions, not 
 > TRACE/PROCEED ones.

That'll  defeat DEBUG and not much else.  Any other debugger has  a  key 
that'll  break  into the code.  At that point, one could go  into  trace 
mode or just replace the JZ 0109 with a series of NOP instructions.

 > This is a very nice technique, that works especially and only on 
 > those who use Turbo Debugger or its kind. What you should do is 
 > init a jump to a middle of an instruction, whereas the real address 
 > actually contains another opcode.

I'm  not  really  sure what you're trying to  accomplish  here,  but  it 
doesn't  do  much.  A simple "U CS:IP" or its equivalent  in  any  other 
debugger  will  show the current instruction.  Anyway,  the  code  isn't 
correct.

        IN     AL,21                            IN    AL,21h
        MOV    AL,FF                            MOV   AL,0ffh
        JMP    0108                             JMP   108
        MOV    Byte Ptr [21E6],00    --->       MOV   BYTE PTR [21e6h],0cdh
        INT    20                    --->       db    20h

You had an extra 00 in there.

 > This is a nice trick, effective against almost any real mode 
 > debugger. What you should do is simply set the trace flag off 
 > somewhere in your program, and check for it later.

Isn't  it  sort  of silly to be trying to  defeat  real-mode  debuggers?  
That's sort of like putting locks on your back door to make sure  nobody 
gets into your house while leaving the front door wide open.

 > This is a technique that causes a debugger to stop the execution 
 > of a certain program. What you need to do is to put some INT 3 
 > instructions over the code, at random places, and any debugger 
 > trying to run will stop there.

Assembling  a NOP over the int 3 will get rid of the break.  Also,  many 
debuggers (like Soft-ICE) can be set to not break on an INT 3.

 > This trick is based on the fact that debuggers don't usually use a
 > stack space of their own, but rather the user program's stack space.

I'm not sure where you're getting this, but today's debuggers keep their 
own  stack safely hidden away in a protected segment where your  program 
can't  corrupt  it.   This  is also  only  effective  against  real-mode 
debuggers  if  you  intend to run your entire  routine  with  interrupts 
cleared, since most ISR's depend on your stack being there as well.

 > This is a nice way to fool Turbo Debugger's V8086 module (TD386). 
 > It is based on the fact that TD386 does not use INT 00h to detect 
 > division by zero.

Did  you actually try this?  It doesn't seem to have much effect at  all 
on TD386.  Soft-ICE traces through it quite happily too.

 > Another way of messing TD386 is fooling it into an exception.
 > Unfortunately, this exception will also be generated under any 
 > other program, running at V8086 mode.

Yes,  and  in  a debugger it's _really_ easy to change  the  code  while 
you're tracing through it to jump right over the offending  instruction.  
All that you've done is eliminated compatibility with a lot of systems.

 > The first category is simply a code, that has been encrypted, 
 > and has been added a decryption routine. The trick here is that 
 > when a debugger sets up a breakpoint, it simply places the opcode 
 > CCh (INT 03h) in the desired address, and once that interrupt is 
 > executed, the debugger regains control of things.

ANY  decent  debugger these days will let you use  hardware  breakpoints 
which  have nothing to do with INT 3 or any other instruction  replacing 
existing  code.   They'll let you set breakpoints  wherever  you'd  like 
without messing up encryption routines or self-modifying code.

 > This is an example of a self-tracing self-modifying code,
 > sometimes called 'The running line'. It was presented by Serge
 > Pachkovsky.

This is really the only effective measure in this document.  It defeated 
every debugger I tried except for Soft-ICE.  Even under Soft-ICE it  was 
hard to trace, since Soft-ICE has a quirk to it - it disables the  trace 
flag  after each instruction.  It also includes fkey macros  though,  so 
once  you realize what's going on, it's pretty easy to force it to  turn 
the  trap flag back on before it executes the next instruction.  With  a 
couple  of additional macros, I had it set up to trace through the  code 
like nothing unusual was happening, except of course that the code I was 
looking at kept changing, but that's another matter.

I had to change the routine you included since it doesn't handle  multi-
byte instructions very well.
