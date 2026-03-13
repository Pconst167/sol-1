  =========================================================================
                                    ||
  From the files of The Hack Squad: ||  by Lee Jackson, Moderator, FidoNet
                                    ||   Int'l Echos SHAREWRE & WARNINGS
          The Hack Report           ||  Volume 2, Number 6
         File Test Results          ||  Result Report Date: May 29, 1993
                                    ||
  =========================================================================

  *************************************************************************
  *                                                                       *
  *  The following test results are courtesy of HackWatcher Nemrod Kedem, *
  *    a McAfee Associates Agent in Israel (FidoNet address 2:403/138).   *
  *                 His assistance is greatly appreciated.                *
  *                                                                       *
  *************************************************************************




  New trojan found in Israel.

  This one is named RASPEED and its archive is as follows:

  Archive:  RASPEED.ARJ

  Name        Length   Method    SF  Size now Mod Date   Time     CRC
  =========== ======== =======  ==== ======== ========= ======== ========
  RASPEED.EXE    29120 Comp-1    37     18242 21 May 93 08:51:14 B9717331
  RASPEED.DOC     4344 Comp-1    66      1443 21 May 93 12:46:36 194BB7EB
  FILE_ID.DIZ      611 Comp-1    57       262 20 May 93 10:13:48 0E680542
  =========== ======== =======  ==== ======== ========= ======== ========
  *total    3    34075 ARJ 4     40%    21310 29 May 93 21:16:56

  When run, it displays the following:

          ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          ³ RASPEED Version 0.9 UNREGISTERED EVALUATION PROGRAM ³
          ³                                                     ³
          ³    PLEASE WAIT, DETERMINING SYSTEM CONFIGURATION    ³
          ³             CHECKING HARD-DISK F.A.T                ³
          ³         GENERATING UPPER-MEMORY-BLOCK MAP           ³
          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

  After a while, a fancy screen is shown with the following:

                      ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                      ³ The Remote-Access Speed-Kit ³
                      ³    Sellica Systems INC.     ³
                      ³        Version 0.9          ³
                      ³                             ³
                      ³  PRESS [ENTER] TO CONTINUE  ³
                      ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

  Next, the program will:

   ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³ PLEASE ENTER THE FULL PATH TO THE LOCATION OF RA.EXE AND RA.OVL : ³
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

  If incorrect path entered, the program displays:

                          ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                          ³ < FILES NOT FOUND > ³
                          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

  Otherwise, another fancy screen is shown with the following:

                              ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
                              ³ WORKING... ³
                              ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ

  After a few moments:

   ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³ OPTIMIZATION COMPLETE !                                          ³
   ³                                                                  ³
   ³ RESULTS                                                          ³
   ³ REMOTE ACCESS :   % SPEED IMPROVEMENT                            ³
   ³ PLEASE REBOOT YOUR COMPUTER NOW SO MODIFICATIONS WILL TAKE PLACE ³
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

  That's it.  Now, what the program did is copy USERS.BBS to a file named
  JACKLINE.GIF in the first area listed in FILES.RA. It also adds the
  follwoing description into FILES.BBS:

                      ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                      ³ JACKLINE.GIF (640x480x256) ³
                      ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

  Check your filebase to see if you have a file by this name and remove it.

  The following strings also found in the program but could not be found
  elsewhere after the program completed.

                              ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
                              ³ CHKDSK.CFG ³
                              ³ F*** YOU   ³ - [edited for television - lj]
                              ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ

  The trojan hangs on RA 2.00 but seems to run well under RA 1.11.

  The document if full of b*llsh*t and if one will read the DOC before
  running the program, he will sure find out it's a fake program. Once
  again we see that RTFM is true!

  Best Regards,
  Nemrod Kedem
  Israeli HackWatcher.
