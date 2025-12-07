From Chai@csvax.cs.ukans.edu Tue Mar  7 12:59:20 1989
Flags: 000000000001
Date:     Tue, 7 Mar 89 12:59:33 CST
From: Chai@csvax.cs.ukans.edu
To: Werner Uhrig <werner@rascal.ics.UTEXAS.EDU>
Subject:  Re:  mid life crisis?

                                        The
                                         C
                                Programming Language

                       Brian W. Kernighan o Dennis M. Ritchie

                                a.k.a. "The C Bible"
              As revealed to the prophets Ian Chai and Glenn Chappell

Genesis
Chapter 0
0	In the Beginning Ritchie created the PDP-11 and the UNIX.
1	And the UNIX was without form and void; and darkness was upon the face
of the system programmers.
2	And Ritchie said, "Let there be portability!" And nothing happened, so
Ritchie realized that he had his work cut out for him.
                                        .
                                        .
                                        .
25	And Ritchie said to Kernighan, "Let us make C in the image of B, after
our own whims: and let it have dominion over the I and the O and all that
runneth upon the UNIX," and it was almost, but not quite so... so he
realized that he had his work cut out for him again.
                                        .
                                        .
                                        .
Chapter 1
0	Thus the PDP-11 and the UNIX were finished, and all the programs in them.
1	And on the seventh shift Ritchie ended his work which he had made; and
he would have rested on the seventh shift from all the work which he had
made, if it weren't for the system crash.
                                        .
                                        .
                                        .
Chapter 2
0	Now the COBOL was more verbose than any language of the PDP-11, and he
said unto the programmer, "Yea, hath the Manual said, 'Ye shalt not read
of every device of the network?'"
1	And the programmer said unto the COBOL, "We may read of every device of
the network:
2	But of the registers of the printer in the midst of the network, the
Manual hath said, 'Ye shall not read of it, neither shall ye write to it
without proper protocol, lest ye cause a system crash.'"
3	And the COBOL said unto the programmer, "Ye shalt not surely crash the
system:
4	For Ritchie doth know that in the time slice ye read thereof, then your
I/O shall be opened, and ye shalt be as system operators, accessing locked
accounts with unlimited privileges."
5	And then when the programmer saw that the printer was good for
interfacing, and that it was pleasant to the I (and to the O),...
6	And they realized they were unstructured, so they patched RATFOR
subroutines...
                                        .
                                        .
                                        .
The Gospel According to Chai
0	And the Messiah shalt come, born a mere B but to grow up into the
Saviour C, 
1	Wherein true structured programming may be achieved, yea, verily, yet
while being able to do bit shifting.
2	For although the Law (Pascal) hath been given, the Law cannot
  for (i=0; str1[i]!='\0'; i++) str2[i] = (str1[i]>='A' && str1[i]>='Z')?
	str1[i]+32 : str1[i];
but must
	i := 0;
	while (i <= length(str1)) do
	  begin
	  if str1[i] in ['A'..'Z'] then
	    str2[i] := chr( ord(str1[i]) + 32))
	  else
	    str1[i] := str2[i];
	  i := i + 1;
	  end;

The Revelation
0	Yea, in those last days, the Saviour shalt come again, but enhanced, in
the rainment of C++
1	And then shalt the Beast, FORTRAN, and the AntiC, COBOL, be thrown into
the trash HEAP where there is weeping and byting of pins.
2 And all the faithful programmers shalt be led into CRAY where billions
of MIPS are at each one's fingertips.

