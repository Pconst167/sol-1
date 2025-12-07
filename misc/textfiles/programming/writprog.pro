
                    ÛßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßÛ
                    Û       HOW TO PROGRAM         Û
                    Û                              Û
                    ÛÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÛ


                             INTRODUCTION


   Writing small programs is pretty easy stuff. True, there were some details
   that had to be learned, as well as new concepts. But, the basic mechanics
   were simple.

   Writing large programs is quite another matter. There are several reasons
   why long programs are more difficult to write. One is that short programs
   are often used just once, and then discarded. Long programs, on the other
   hand, are often designed for use by others. Consequently, they have to be
   written more carefully, to anticipate all forms of misuse. They must also
   be provided with elaborate documentation and manuals.





   Another reason, many believe, is the limitation of a human being's short
   term memory. Most persons can understand or grasp a short 10-line program
   in a few seconds. And they can keep it in mind while they contemplate
   changes. With large programs, the programmer must have all useful inform-
   ation written down so it can be referred to when attempting to understand
   or change the program.

   Still another reason is the limit of what can appear on single screen or
   page. Short programs that in their entirety occupy but one page, or one
   screenful, are easier to understand than longer programs, which require
   page-turning or screen-scrolling.

   Whatever the reasons, writing large programs is not easy. Even profes-
   sional programmers have trouble. One hears about rockets crashing because
   of programming errors. And one hears that large programs may have hun-
   dreds, or even thousands, of errors many months after they were allegedly
   completed.
   It is almost impossible to write a program that has no errors. If for no
   other reason, we often do not know exactly what the program is supposed to
   do, to the last detail, until after we have built it. But there is much
   when can do to bring us closer to that error-free goal. The first step is
   to understand the stages in developing a large program. These stages are
   often referred to as the Software Development Life Cycle.




                   ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                   ³                                ³
                   ³   1. SPECIFICATION             ³
                   ³   2. PROGRAM DESIGN            ³
                   ³   3. CODE DESIGN               ³
                   ³   4. CONSTRUCTION AND DESIGN   ³
                   ³                                ³
                   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



   If, despite all our efforts with these four stages, errors still exist in
   our program, then we will have to consider techniques to isolate errors.
   This process is often call DEBUGGING, and is usually considered to be part
   of STEP 4.










                  ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
                  º         SPECIFICATION            º
                  ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼



   It is important to know what the program is supposed to do before starting
   to build it. This is especially true if the program is being built for
   someone else.
   Matters to be determined during this stage include the user interface,
   algorithms, data structures, generality, and robustness.

   USER INTERFACE
   What should the user have to do to interact with the program? Should there
   be commands to be typed in? Should one use menus? How much freedom should
   be allowed the user, with respect to, say, spelling errors? What should the
   output displays look like?

   It is at this stage that you should decide how best to PROMPT the user for
   proper input, and how best to label the output. This is not always as easy
   as it sounds.







   ALGORITHMS
   If the program requires extensive computation, what methods should be used?
   For example, if a list of names needs sorting, which sorting ALGORITHM
   should be used. ALGORITHM is merely the name given to a computational method
   that (a) might require input, (b) always produces some output, (c) completes
   its work in a fnite amount of time, and (d) does what it is supposed to do.

   DATA STRUCTURES
   How should the data of a problem be organized? Should one use lists or
   tables? Should the data itself be sorted, or should use be made of an
   indexed sort? Which, if any, data should be stored in files? One should
   spend as much time answering questions like these as questions of what
   algorithms to use. For, the efficiency of a well-written sorting algorithm
   will be lost if the data are stored clumsily.






   GENERALITY
   Should a program be a special purpose program limited for use in a small
   number of situations? Or should the program be general purpose, of use in
   a wider variety of circumstances? There are arguments to be made in each
   choice. A special purpose program is almost always easier to use. Fewer
   commands have to be given, and fewer choices have to be made, to get it
   to do its job. More general programs, besides being much longer, require
   the user to make more choices and issue more commands to get it work.
   And, the user may have to study a much larger manual before using the
   program.

   On the other hand, a general purpose program will do more things for the
   user. And perhaps, only one general purpose program might be needed for
   a series of tasks, whereas several special purpose programs would be
   needed.

   ROBUSTNESS
   Robustness is the degree to which a program responds "gracefully" to being
   fed bad data or bad commands. For example, does it give the user a second
   chance if the user misspells the filename? These are but a few of the kinds
   of questions that must be during the specification or planning stages of
   building a large program.



                  ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
                  º         PROGRAM DESIGN           º
                  ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼



   Program design is the most difficult part of building a large program.
   For the most part, it involves deciding how a large program should be
   divided into subroutines. A design is often represented by a structure
   chart, which is simply a chart that shows which subroutines call which
   other subroutines.

   For example, a top-level subroutine, which is actually the main program,
   calls three other subroutines. Thats all there is, as the three other
   subroutines do not call other subroutines.

   Structure charts shows the names of the data that are used and produced
   by each subroutine. If the data are passed to and from the subroutine as
   parameters, their names appear next to small arrows close to the line
   connecting the subroutines. If the data are not passed, we use arrows
   that originate and terminate inside the rectangles that represent the
   subroutines.



   Given a particular design (a particular structure chart), there are
   two important questions that need to be raised. First, how does one
   evaluate the design? And second, how does one develop a design in the
   first place? Although there are design methodologies whose purpose is
   to come up with a design, suffice to say, they require a careful and
   thorough understanding of the underlying problem, and take sometime to
   explain and understand.


                               ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³                 ³
              ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´     SALES4      ÃÄÄÄÄÄÄÄÄÄ¿
              ³               ³                 ³         ³
              ³               ÀÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÙ         ³
        ITEMS ³              ITEMS  o  ³   ITEMS o¿ ³
       PERSONS³             PERSONS ³  ³    PERSONS      ³
      PRICE() ³            PRICE()    ³      PRICE()    ³
     SALES(,) ³           SALES(,)    ³       SALES(,)  ³
     ÚÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ¿       ÚÄÄÄÄÄÄÄÁÄÄÄÄÄÄ¿    ÚÄÄÄÄÄÄÁÄÄÄÄ¿
   ÀÄÄÃÄo               ³       ³ PERSONRESULT ³    ³ITEMRESULT ³
      ³    READDATA     ³       ³              ³    ³           ³
      ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ       ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    ÀÄÄÄÄÄÄÄÄÄÄÄÙ







   The following are a few ideas that can be used to evaluate a design,
   once one has been made. These ideas are heuristic because following
   them usually, but not necessarily, leads to a good design.


   KEEP SUBROUTINES SHORT

   It is better to keep subroutines shorter than one page, or one screenful,
   in length. If that is not possible, then so be it. But it is much harder
   understand a subroutine if you must constantly shift pages or screens
   back and forth.
   One exception to this principle occurs when a subroutine consist of,
   say an IF structure with a large number of ELSEIF parts. Here, the cure
   (having several short subroutines) is worse than the illness (having one
   long subroutine.)









   KEEP SUB-ROUTINES SINGLE-PURPOSE

   A subroutine that does one single task is almost always easier to write
   and test than a subroutine that does several tasks. A single task may,
   however, be quite complicated. For example, a subroutine that solves
   a linear programming problem is necessarily quite complicated, and may
   indeed call other subroutines. But it still has its purpose, a single
   task.

   Software engineers use the term (cohesion) to describe the degree to which
   subroutines can range from being single-purpose (functional Cohesion) to
   being a disjointed collection of unrelated tasks (coincidental cohesion).

   KEEP CALLING SEQUENCES SHORT

   If a subroutine needs four data elements to do its work, then the calling
   sequence must contain four parameters. For example, the subroutine person-
   result needs four parameters (the number of persons, the number of items
   the price list, and the sales table). Four is not too many, but if a
   calling sequence contains ten or more parameters, perhaps it is time to
   reconsider the design.






   COMMUNICATE DATA THROUGH CALLING SEQUENCES

   As much as it is possible, one should supply the data needed by subroutines
   through their calling sequences. The reason is that it is then clearer what
   data are needed by the subroutine and therefore less likely that errors will
   occur. This goal seems like the antithesis of our third goal. If we commun-
   icate the data through calling sequences, then the calling sequences will be
   longer. One recommendation is the use of internal subroutines without para-
   meters to subdivide a large program into smaller pieces. This is still a
   good idea. But if all the data needed by a subroutine is provided through
   its calling sequence, then the subroutine can be made external. External
   subroutines are much less likely to contribute to errors than internal sub-
   routines that share data. Furthermore, an internal subroutine that has no
   parameters, but that uses ten or Ffteen chunks of data, is likely to be
   quite complicated.











   Software engineers use the term "coupling" to measure the degree to which
   two subroutines are interrelated. Subroutines are (loosely coupled) if they
   share only a few data elements, and then only as parameters in their calling
   sequences. Subroutines that have long calling sequences or share data with
   other subroutines outside the calling sequences are said to be "tightly -
   coupled". Loose coupling is generally better inasmuch as changes made to
   one subroutine are then less likely to require changes to other subroutines.
   As with cohesion, coupling is an important matter in rating a particular
   design, but a more detailed discussion is beyond the scope of this text.
















   LIMIT USE OF FLAGS

   FLAGS are signals that one subroutine sends to another. The first subroutine
   decides something or other. It then sets a flag so that a different sub-
   routine can know what the first subroutine decided. In BASIC flags are
   usually variables that are set to either O or 1. For example, setting the
   variable ERROR to O may mean that no errors have occurred, whereas setting
   error to 1 may mean that one or more errors have occurred.

   Programs that contain many flags are extremely difficult to write and to
   test. And it is very difficult to make sure they are free from error.
   Sometimes it is hard to avoid the use of FLAGS. Examples are subroutines
   that test for errors. If these subroutines occur at a lower level, they
   must communicate their results (errors versus no errors) back to the higher
   level through a FLAG. Another occurs when a lower-level subroutine is
   assigned the job of reading information from a file. When the end of the
   file is reached, this subroutine must use a flag (or its equivalent) to
   inform the higher-level routines.









   MAKE DESIGN HIERACHICAL

   The structure chart of a large program should usually look like an upside
   down tree. That is, there is one box at the top (the main program) that
   calls several subroutines at the second level. The second-level subroutines
   often call more subroutines at the third level, and so on.
       A good design idea is to have the high-level subroutines deal in high-
   level concepts, like the top executives in a company. The often messy
   details should be left to the lower-level subroutines. In this way it is
   more likely that you will be able to separate the "forest from the trees",
   to separate the general concepts from the specific details.



                          TO BE CONTINUED









X-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-X

 Another file downloaded from:                               NIRVANAnet(tm)

 & the Temple of the Screaming Electron   Jeff Hunter          510-935-5845
 Rat Head                                 Ratsnatcher          510-524-3649
 Burn This Flag                           Zardoz               408-363-9766
 realitycheck                             Poindexter Fortran   415-567-7043
 Lies Unlimited                           Mick Freen           415-583-4102

   Specializing in conversations, obscure information, high explosives,
       arcane knowledge, political extremism, diversive sexuality,
       insane speculation, and wild rumours. ALL-TEXT BBS SYSTEMS.

  Full access for first-time callers.  We don't want to know who you are,
   where you live, or what your phone number is. We are not Big Brother.

                          "Raw Data for Raw Nerves"

X-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-X
