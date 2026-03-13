From dnalib@KCVAX.LDC.LU.SE Mon Oct  2 16:13:23 1989
Date:	Fri, 29 Sep 89 11:00:00 EET
Reply-To: Magnus Olsson <dnalib@KCVAX.LDC.LU.SE>
Sender: Nutworks magazine & Other Nutty Stuff <NUTS@FINHUTC>
From:	Magnus Olsson <dnalib@KCVAX.LDC.LU.SE>
Subject:      Bored By Pascal?
To:	Timo Kiravuo <kiravuo@KAMPI.HUT.FI>

Hi there!

Since this list seems to be silently dying, I'll try to revive it by
actually *posting* something. The following files were circulating on the
one of the Vaxen at the dept. of Computer Science here in Lund a few years
ago. Nothing seems to be known about the author, except that he's never
existed...

By the way, all three programs compile and run under VAX/VMS. For non-VAXers,
the MTH$RANDOM function in the second program returns a random real between
0 and 1.


Have fun!

Magnus
(DNALIB@SELDC51)

___________________________BORED-1.FOR_______________________________________

C       BORED BY PASCAL?
C       ================
C       PASCAL IS DESIGNED SO THAT YOU DON'T HAVE TO THINK
C       WHILE PROGRAMMING. THIS IS GOOD FOR BEGINNERS BUT WILL
C       BECOME A LITTLE BORING AFTER A WHILE.
C       THIS LITTLE PROGRAM WAS WRITTEN TO DEMONSTRATE A
C       NICE FEATURE OF FORTRAN: THE POSSIBILITY OF WRITING
C       I N T E R E S T I N G  CODE.
C       IF THIS PROGRAM WERE WRITTEN IN PASCAL, IT WOULD BE QUITE
C       BANAL AND EASILY UNDERSTANDABLE EVEN TO THE AVERAGE TLTH
C       MEMBER. THAT WOULD BE NO FUN, HOWEVER.
C
C       NOTE THE FOLLOWING NICETIES:
C       * THE ABSENCE OF SENSIBLE COMMENTS-REAL PROGRAMMERS UNDERSTAND
C         FORTRAN BETTER THAN ENGLISH!
C       * THE ARITHMETIC IF-STATEMENTS (ADDING NICE FLAVOUR TO
C         THE CODE)
C       * THE WONDERFULLY CONCISE VARIABLE NAMES
C       * THE H-FORMAT FOR ALPHANUMERIC OUTPUT ( A LIVING FOSSIL
C         FROM THE HAPPY DAYS OF THE PUNCHED CARD)
C       * THE NICE SPAGHETTI STRUCTURE - STRUCTURED PROGRAMMING
C         IS ONLY FOR AMATEURS AND OLD LADIES
C
C       A SMALL REWARD IS OFFERED TO ANYBODY ABLE TO SAY WHAT
C       THIS PROGRAM DOES (WITHOUT ACTUALLY RUNNING IT)
C       SEND YOUR ANSWERS TO  TOM A.CRONA,
C                             DEPARTMENT OF COMMUTER SCIENCE
C                             AND NUMERICAL SYNTHESIS,
C                             UNIVERSITY OF LUND
C
C       PLEASE NOTE THAT THIS PROGRAM IS NOT IN ANY WAY PATHOLOGICAL
C       BUT A PERFECTLY NORMAL EXAMPLE OF WHAT PROGRAMMING WAS LIKE
C       BACK IN THE GOLDEN DAYS WHEN COMPUTERS WERE COMPUTERS AND
C       PROGRAMMERS WERE PROGRAMMERS...


 10     WRITE (*,487)
        READ (*,*) N
        IF (N) 10,10,30
 30     I1=2
 97     I2=0
 60     J=MOD(N,I1)
        IF (J) 40,50,40
 50     I2=I2+1
        N=N/I1
        GOTO 60
 40     IF (I2-1) 70,80,90
 70     I1=I1+2
        IF (I1-4) 120,135,120
 135    I1=3
 120    IF (I1-N) 97,97,3
 3      WRITE (*,65)
        READ (*,*) I3
        IF (I3) 3,130,10
 130    STOP
 80     WRITE (*,855) I1
        GOTO 70
 90     WRITE (*,930) I1,I2
        GOTO 70
 487    FORMAT (8H NUMBER?/)
  65    FORMAT (20H CONTINUE? (1=Y,0=N)/)
 855    FORMAT (I5)
 930    FORMAT (I5,3H **,I5)

C       BE A CREATIVE PROGRAMMER - USE FORTRAN
C       (C) SFRGOD (The Society For Revival of the Good Old
C                   Days), Fortran section, 1984
        END

____________________________BORED-2.PAS_________________________________________

{   BORED BY PASCAL?    part 2
    ==========================
    In this degenerate age of the toy computer (by some weak souls
    called "personal computer" or something like that) everyone learns
    programming in kindergarten or at least in high school (if there's
    any difference between those school forms). For this activity, a
    language called BASIC is used almost exclusively. BASIC is rather
    like a small subset of FORTRAN with many of its good features
    amputated but with all of its drawbacks. Anyway, you can write
    all kinds of programs in BASIC, and since it (fortunately!) lacks
    any trace of structured constructs it promotes creative programming
    the same way FORTRAN does and you get programmers who THINK while
    they're programming.
    When these persons start a higher education, they are forced
    to write their programs in a "language" called Pascal and are
    thereby quickly converted into well-adapted quiche eaters without
    a trace of originality. This paper was written to point out a method
    of solving this problem.

    Actually, you don't have to learn Pascal at all - it's much easier
    to write your programs in BASIC and then translate them directly
    into Pascal. As an example, consider the following program. It was
    originally written in BASIC on a ZX80 (Yecch!) and then transformed
    into syntactically perfect Pascal during the pause between two
    lectures.
    Most Pascal addicts turn away in disgust when seeing the words
    GOTO and LABEL, but there's absolutely no reason to discriminate
    these constructs - after all they're a part of the language (if that's
    not too strong a word to use about Pascal). Why should any programmer
    reject what is good enough for the compiler? Besides, the GOTO was
    there first - structured programming is a much later (and unnecessary)
    addition.

    By following this recipe, the young, undestroyed programmers can
    continue writing their programs in BASIC, avoid learning more
    Pascal than absolutely necessary and at the same time satisfy the
    Pascal buffs of the university. }

PROGRAM NIM (INPUT,OUTPUT);
{(c) Tom A. Crona 1984}
LABEL 70,90,150,230,280,370,400,460,470,520,540,800,810,820;
VAR J,S1,D,E,H,R,K : INTEGER; { WHO NEEDS FANCY LONG VARIABLE NAMES?}
    A,B : ARRAY [0..3] OF INTEGER;
    C   : ARRAY [0..3,0..3] OF INTEGER;

FUNCTION MTH$RANDOM(VAR SEED:INTEGER):REAL; EXTERNAL;

    BEGIN
    WRITELN ('******* NIM *******');
    WRITELN ('I HOPE YOU KNOW THE RULES OF NIM.');
    WRITELN ('ANYWAY I''M NOT GOING TO RECITE THEM...');
    WRITELN ('ENTER RANDOM SEED');
    READ(S1);
 70:FOR D:=0 TO 3 DO
    A[D]:=TRUNC(MTH$RANDOM(S1)*15+1);
 90:FOR D:=0 TO 3 DO
    WRITELN (D+1,':',A[D]:2);
    IF A[0]+A[1]+A[2]+A[3]>0 THEN GOTO 150;
    WRITELN ('*I WON*');
    GOTO 540;
150:WRITELN ('WHICH PILE?');
    READ (D);
    IF (D<1) OR (D>4) THEN GOTO 800;
    WRITELN ('HOW MANY?');
    READ (E);
    IF (E<1) OR (E>A[D-1]) THEN GOTO 810;
    A[D-1]:=A[D-1]-E;
    D:=-1;
230:D:=D+1;
    IF D=4 THEN GOTO 460;
    FOR E:=0 TO 3 DO
    B[E]:=A[E];
280:B[D]:=B[D]-1;
    IF B[D]<0 THEN GOTO 230;
    FOR E:=0 TO 3 DO
    BEGIN
    H:=B[E];
    R:=16;
    FOR J:=0 TO 3 DO
    BEGIN
    C[J,E]:=0;
    R:=R DIV 2;
    IF H<R THEN GOTO 370;
    C[J,E]:=1;
    H:=H-R;
370:END;
    END;
    E:=-1;
400:E:=E+1;
    H:=C[E,0]+C[E,1]+C[E,2]+C[E,3];
    IF H MOD 2>0 THEN GOTO 280;
    IF E<3 THEN GOTO 400;
    A[D]:=B[D];
    GOTO 90;
460:D:=-1;
470:D:=D+1;
    IF D=4 THEN GOTO 520;
    IF A[D]=0 THEN GOTO 470;
    A[D]:=A[D]-TRUNC(MTH$RANDOM(S1)*A[D]+1);
    GOTO 90;
520:WRITELN ('YOU WON.');
540:WRITELN ('ENTER 1 IF YOU WISH TO CONTINUE, 0 OTHERWISE');
    READ (K);
    IF K=1 THEN GOTO 70;
    GOTO 820;
800:WRITELN ('THERE IS NO SUCH PILE, STUPID!!!');
    GOTO 150;
810:WRITELN ('TRYING TO CHEAT, EH?');
    GOTO 150;
820:END.

______________________________BORED-3.COB__________________________________

* BORED BY PASCAL? part 3
* =======================
* With the advent of Pascal, the art of writing interesting code is quickly
* dying out among the younger programmers. I must confess that Pascal has
* made it possible for (almost) everyone to write working programs,
* but it also acts to stifle the true creativity expressed when writing
* (and trying to debug) self-modifying, spaghetti-structured programs
* written in any of the REAL programming languages. The only hope of
* rescue for the "lost generation" of brand-new Pascal "programmers" is
* to learn another language which is better suited for REAL programming.
* In the previous articles of this series we have discussed
* (i) the advantages of real, old-fashioned FORTRAN (not that miserable
*     pseudo-Pascal known as FORTRAN 77)
* (ii)the possibility of writing your programs in BASIC and then translating
*     them directly into Pascal.
* Some people may be repelled by the short and concise notation of these
* languages - they are suffering from the illusion that a program has
* to be self-explanatory so that every idiot can understand it.
* (in fact it's advantageous to write incomprehensible program since in
*  that case you (and not your competitors) will be called in to modify
*  it when it's found out that the program won't function because the
*  problem was incorrectly stated.)
* There is a cure even for these unfortunate people, however. It's called
* COBOL. The most distinct feature of this language is that it's extremely
* verbose - in fact COBOL is more like a subset of English than a
* programming language!
* While this will (probably) take care of the need for documentation,
* COBOL still has the properties that encourage creative programming,
* like for example:
*
* + The total absence of any "structured" language elements
* + The lack of local variables forcing you to remember all the
*   variables you're using (good for your memory if it's a long program)
* + The possibility of writing subroutines with multiple entry and
*   exit points (not even BASIC has this last feature!)
* + The ALTER statement for writing self-modifying code (see below)
* + The good old GO TO statement enabling you to give the program
*   any kind of structure you like.
*
* You should not be frightened by the fact that COBOL is said to be a
* language for commercial programming. Below is a pure computational
* program (it solves one of those nasty cubic equations)
* written in COBOL which functions quite excellently. (Besides, I have
* met programmers who actually write accounting programs in Algol...)
*
* Since the reader may not be acquainted with the semantics of COBOL,
* I have departed from my holy principles and inserted some comments
* into the code.

IDENTIFICATION DIVISION.
PROGRAM-ID. SOLVE-CUBIC.
AUTHOR. TOM A CRONA.
INSTALLATION. LDC.
DATE-WRITTEN. OCTOBER 22,1984.
DATE-COMPILED. OCTOBER 22,1984.
SECURITY. NONE.

ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SOURCE-COMPUTER. VAX.
OBJECT-COMPUTER. VAX.
SPECIAL-NAMES.
DECIMAL-POINT IS COMMA.

DATA DIVISION.
* If you think the variable declarations in Pascal are long and tedious,
* have a look at this:
WORKING-STORAGE SECTION.
77 ROOT-1       PICTURE S999V9(9) USAGE IS COMPUTATIONAL.
77 ROOT-2       PICTURE S999V9(9) USAGE IS COMPUTATIONAL.
77 EPS          PICTURE S999V9(9) USAGE IS COMPUTATIONAL.
77 X            PICTURE S999V9(9) USAGE IS COMPUTATIONAL.
77 OLD-X        PICTURE S999V9(9) USAGE IS COMPUTATIONAL.
77 LAST-X       PICTURE S999V9(9) USAGE IS COMPUTATIONAL.
77 NEW-X        PICTURE S999V9(9) USAGE IS COMPUTATIONAL.
77 Y            PICTURE S999V9(9) USAGE IS COMPUTATIONAL.
77 Y1           PICTURE S999V9(9) USAGE IS COMPUTATIONAL.
77 Y2           PICTURE S999V9(9) USAGE IS COMPUTATIONAL.
77 TEMP         PICTURE S999V9(9) USAGE IS COMPUTATIONAL.
77 TEMP2        PICTURE S999V9(9) USAGE IS COMPUTATIONAL.
77 EDITED-NBR   PICTURE ---9,9(9) USAGE IS DISPLAY.
77 ITERATIONS   PICTURE 99        USAGE IS COMPUTATIONAL.
* I'm not going to tell you what all this means - consult the nearest
* COBOL reference manual.

PROCEDURE DIVISION.
COMPUTE-ROOTS. DISPLAY "THIS PROGRAM SOLVES 63x^3-9x^2-7x+1=0".
        COMPUTE EPS = 10 ** -5.
        PERFORM SOLVE THROUGH END-SOLVE MOVE LAST-X TO ROOT-1.
* This is the COBOL equivalent of a subroutine call - and you specify both
* entry and exit points yourself!
        ALTER SKIP TO PROCEED TO ELIMINATE-1.
* The above statement is a real goodie - it changes the GO TO END-FUNC below
* to GO TO ELIMINATE-1.
        PERFORM SOLVE THROUGH END-SOLVE MOVE LAST-X TO ROOT-2.
        ALTER SKIP TO PROCEED TO ELIMINATE-2.
        PERFORM SOLVE THROUGH END-SOLVE.
        DISPLAY "NO MORE ROOTS".
        STOP RUN.

SOLVE.  MOVE -1 TO OLD-X MOVE ALL ZEROES TO LAST-X, ITERATIONS.
LOOP.   MOVE OLD-X TO X PERFORM COMPUTE-FUNCTION THROUGH END-FUNC
        MOVE Y TO Y1.
        MOVE LAST-X TO X PERFORM COMPUTE-FUNCTION THROUGH END-FUNC
        MOVE Y TO Y2.
        IF OLD-X - LAST-X IS LESS THAN EPS AND GREATER THAN - EPS
                 GO TO END-SOLVE.
        SUBTRACT OLD-X FROM LAST-X GIVING TEMP.
        SUBTRACT Y1 FROM Y2 GIVING TEMP2.
        MULTIPLY Y2 BY TEMP DIVIDE TEMP2 INTO TEMP.
        SUBTRACT TEMP FROM LAST-X GIVING NEW-X.
        MOVE LAST-X TO OLD-X MOVE NEW-X TO LAST-X.
        ADD 1 TO ITERATIONS.
* This way of writing aritmetical statements is peculiar to COBOL.
* You are permitted to write COMPUTE NEW-X = LAST-X -
* ( LAST-X - OLD-X ) / ( Y2 - Y1 )  instead, but that's no sport!
        IF ITERATIONS IS GREATER THAN 20 DISPLAY "NO ROOT FOUND"
                                                 STOP RUN.
        IF Y2 IS LESS THAN - EPS OR GREATER THAN EPS GO TO LOOP.
END-SOLVE. MOVE LAST-X TO EDITED-NBR DISPLAY "X=", EDITED-NBR.
* Numbers are formatted for output by moving them to special "edited"
* variabels like EDITED-NBR.These variables are defined by special
* PICTURE clauses in the DATA DIVISION (if that makes you any wiser,
* you don't need to read the rest)

COMPUTE-FUNCTION. MULTIPLY 7 BY X GIVING Y
        SUBTRACT 1 FROM Y MULTIPLY X BY Y MULTIPLY 9 BY Y.
        SUBTRACT 7 FROM Y MULTIPLY X BY Y ADD 1 TO Y.
SKIP.   GO TO END-FUNC.
* This statement is altered twice: first to GO TO ELIMINATE-1
* and then to GO TO ELIMINATE-2. This self-modifying feature makes it
* possible to write very elegant programs and is a real challenge to
* any creative programmer.
ELIMINATE-2. SUBTRACT ROOT-2 FROM X GIVING TEMP
        DIVIDE TEMP INTO Y.
ELIMINATE-1. SUBTRACT ROOT-1 FROM X GIVING TEMP
        DIVIDE TEMP INTO Y.
END-FUNC. EXIT.


