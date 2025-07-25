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

          �����������������������������������������������������Ŀ
          � RASPEED Version 0.9 UNREGISTERED EVALUATION PROGRAM �
          �                                                     �
          �    PLEASE WAIT, DETERMINING SYSTEM CONFIGURATION    �
          �             CHECKING HARD-DISK F.A.T                �
          �         GENERATING UPPER-MEMORY-BLOCK MAP           �
          �������������������������������������������������������

  After a while, a fancy screen is shown with the following:

                      �����������������������������Ŀ
                      � The Remote-Access Speed-Kit �
                      �    Sellica Systems INC.     �
                      �        Version 0.9          �
                      �                             �
                      �  PRESS [ENTER] TO CONTINUE  �
                      �������������������������������

  Next, the program will:

   �������������������������������������������������������������������Ŀ
   � PLEASE ENTER THE FULL PATH TO THE LOCATION OF RA.EXE AND RA.OVL : �
   ���������������������������������������������������������������������

  If incorrect path entered, the program displays:

                          ���������������������Ŀ
                          � < FILES NOT FOUND > �
                          �����������������������

  Otherwise, another fancy screen is shown with the following:

                              ������������Ŀ
                              � WORKING... �
                              ��������������

  After a few moments:

   ������������������������������������������������������������������Ŀ
   � OPTIMIZATION COMPLETE !                                          �
   �                                                                  �
   � RESULTS                                                          �
   � REMOTE ACCESS :   % SPEED IMPROVEMENT                            �
   � PLEASE REBOOT YOUR COMPUTER NOW SO MODIFICATIONS WILL TAKE PLACE �
   ��������������������������������������������������������������������

  That's it.  Now, what the program did is copy USERS.BBS to a file named
  JACKLINE.GIF in the first area listed in FILES.RA. It also adds the
  follwoing description into FILES.BBS:

                      ����������������������������Ŀ
                      � JACKLINE.GIF (640x480x256) �
                      ������������������������������

  Check your filebase to see if you have a file by this name and remove it.

  The following strings also found in the program but could not be found
  elsewhere after the program completed.

                              ������������Ŀ
                              � CHKDSK.CFG �
                              � F*** YOU   � - [edited for television - lj]
                              ��������������

  The trojan hangs on RA 2.00 but seems to run well under RA 1.11.

  The document if full of b*llsh*t and if one will read the DOC before
  running the program, he will sure find out it's a fake program. Once
  again we see that RTFM is true!

  Best Regards,
  Nemrod Kedem
  Israeli HackWatcher.
