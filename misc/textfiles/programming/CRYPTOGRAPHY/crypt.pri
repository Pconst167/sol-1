         
                                   
           __________  __                   __
          /  _______/ /_/                  / /
         /  /______  __  __  ___  _____  / / _____
        /______   / / / /  \/  / / _  / / / /  __/
       _______/  / / / / /\_/ / / // / / / / /-_ 
      /_________/ /_/ /_/  /_/ / ___/ /_/ /----/
                              / /
                             /_/
         ________                         __        __
        / ______/                        / /       / /
       / /       ______  __  __  _____ =/ /=____  / / ____  ____  __  __
      / /       / __ _/ / / / / / _  / / / /__ / / / /__ / /__ / / / / /
     / /_____  / /-//  / /_/ / / // / / / //_// / / //_// //_// / /_/ /
    /_______/ /_/ /_/ /___  / / ___/ /_/ /___/ /_/ /___/ /_  / /___  /
                       ___/ / / /                      ___/ /   ___/ /
                      /____/ /_/                      /____/   /____/
                                 

                         SIMPLE CRYPTOLOGY

                                from 
        
                         A Simple Cryptologer

         
                Written, and compiled by:                    
                                                            
                   Dave Ferret  <ferret%works@merk.com>     
                   [ cDc/K-rAd people are we/TheWorks ]     
                                                            
==============================================================================
  Borrowed without permission from sci.crypt:     
        Frequently Asked Questions 


    cryptology - the study of codes and ciphers

    cryptography - the act of inventing code or cipher systems

    cryptanalysis - the breaking of a code or cipher system without
                    benefit of the normal deciphering mechanism(s)


==============================================================================



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% What is Cryptography? (The Short Version) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 "Cryptography is the art and science of hiding data in plain sight."

 "It is also the art and science of stealing data hidden in plain sight."

       (both accurate definitions), by Larry Loen

  Have you ever made secret codes with your friends when you were little?
Whether it was number codes where for each letter of the alphabet you
substituted a number, or where you made a chart for each of you to translate
message... That is a simple form of Cryptography. As far as I can back up
Cryptology wasn't widely used until World War I, where actual machines were
created for the sole purpose of making messages unreadable to the enemy.

 Cryptography is the method by which plaintext is encrypted into an unreadable
form. The plaintext is the original text, before you altered it to make other
people unable to read it. The key, or code, is the actual password/or whatnot
you used to make it unreadable. (This is a very simplistic, and not completely
accurate view, I apologize for it, and again tell anyone seriously interested
to read real hard copy books and papers to explain what it REALLY is).

===============================================
= Why is encrypted communications important?  =
===============================================

   In todays electronic communication forums, encryption can be very important!
Do you know for fact that when you send a message to someone else, that someone
hasn't read it along the way? Have you ever really sent something you didn't
want anyone reading except the person you sent it to? As more and more things
become online, and 'paperless' communication predictions start coming true, all
the more reason for encryption. Unlike the normal U.S. Mail, where it is a
crime to tamper with your mail, it can commonly go unnoticed on electronic
pathways as your message hops from system to system on its route towards its
final destination. Just think, the average internet letter travels at least 2
hops before it reaches you, usually more... Even on public BBS's your mail is
usually stored in text, can you be sure someone else isn't reading it? Can
you be sure no one has read it at least once before you received a copy? 
No. You can't. Or how hard would it be for administrators to set up a process
to 'grep' (search for known text) all incoming/outgoing mail batches for
certain 'catch' phrases. Its not very hard, I assure you. Although most
people probably don't do things like this, the threat is there. Thats 
why you need to encrypt your messages... So you don't allow people to 
read your private and personal, mail; mail that isn't intended for them.
You have the right of privacy, as stated in the Constitution.
Thats why cryptography is so key. 

=========================================
= Different types of Encryption schemes =
=========================================

	    One-Way encryption algorithms: What are they?


   There are certain Mathametical/Cryptographical Algorithms that will
encrypt a string of text/numbers using a complex equation. However, you
cannot reverse these equations again (take my word for it, it has to do with
pieces of the equation being unknown, purposely lost in the encryption process)

	    A real-life example of One-Way Encryption

   These types of algorithms are used when they need to compare the text, such
as password validation checks. Crypt(), the Unix password validation routine
works like this. Your password is used at the key to encrypt a plaintext
string of 0s. Then, to verify your password, it tries to encrypt the same
string of plaintext with the password you typed in, if they match the original
encrypted text, then you have a valid password. (Note: Although you can't
reverse this to find out what the original password/key was, you can compare
two encryptions to see if its the same key.)

The "One-Time Pad"
==================

A long string of random numbers are generated/created. Your messages cannot
be any longer than the string of random numbers, it may be less however. 

     Your text is encrypted by XOR'ing the bits in relation to the random
string of numbers. Bit by bit. So anyone not knowing the original key wouldn't
know whether your string, "123" was really "456" or "789" because in fact you
and the person your communicating with know its really, "012" (wrap around
9->0) This is the best I can do for this. This is a proven technique and is
almost 99% reliably secure. 


Single-Key Encryption
=====================

 This is what most non-crypto speak people would understand as 
an encryption system. You enter one string of characters (or 
whatnot - The KEY) and encrypt your plaintext with this key. 
Anyone with knowledge of what this key is can decrypt and read 
the plaintext you are trying to hide. 


Public-Key Encryption
=====================
   
        This is gaining a large following during the time of 
this writing with such known programs as RIPEM, PGP, and the 
availability of RSAREF, a RSA Public Key algorithm libraray. 
RIPEM, and PGP (Pretty Good Privacy by Phil Zimmerman) are 
both examples of RSA Public Key systems. There are two 
distinct parts to a Public key system. The PUBLIC key and the 
PRIVATE key. 

     o  The PUBLIC key is given out to everyone you know who 
       would want to send you an encrypted message.

     o   The PRIVATE key you keep secret and do not disclose 
       to anyone.

        What happens is User A (Iskra) wants to send a 
message to User B (John-Draper) so Iskra encrypts a message 
to John-Draper using John-Drapers public key that was given 
out at the last HoHoCon. No one except John-Draper has the 
private key to decrypt the message. So he takes his private 
key, the counterpart to his public key, and decrypts the 
message sent to him by Iskra. Viola. He now sees that the 
new Red Boxes are no longer working because AT&T has cinched 
up the timing checks. However, Veggie (User C) has intercepted 
the encrypted message and is trying to figure out what they 
are talking about. But because he doesn't have John-Draper's 
private key he cannot read it. A successful use of Public Key 
Encryption. 

(There are a LOT of books on this, so this is all I'm going to say) 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Books, Journals et al... %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NOTE: A lot of the 'good' and complete sources of Cryptography and some
      algorithms are classified by the United States Goverment,
      However, there are still a decent nunmber I can provide. Also, the
      NSA has been pushing for legislation to require all encryption
      schemes to be 'breakable' by them in some way in a reasonable matter 
      of time - Or to put back doors in them/ purposely weaken them
      so THEY can decrypt your messages. This is a violation of your
      rights. I hope you would oppose such things. 

-----------
** Sources: (Without who I wouldn't have gotten half as far as I have so far.)
----------- 
    by Larry Loen - lwloen@rchland.vnet.ibm.com  11/92)
       cme@ellisun.sw.stratus.com (Carl Ellison) 11/92)
       Alec Chambers (jac54@cas.org)         
       mrr@scss3.cl.msu.edu (Mark Riordan) 
------------

    David Kahn, The Codebreakers, Macmillan, 1967 [history; excellent]

    H. F. Gaines, Cryptanalysis, Dover, 1956 [originally 1939, as
        Elementary Cryptanalysis]

    Abraham Sinkov, Elementary Cryptanalysis, Math. Assoc. of Amer.,
        1966

    D Denning, Cryptography and Data Security, Addison-Wesley, 1983

    [ Dorothy Denning, also wrote a paper proposing all public      ]
    [ key systems be required to 'register' their private keys with ]
    [ the NSA or other agency for decryption should the gov't feel  ]
    [ it necessary                                                  ]
                 
    Alan G. Konheim, Cryptography:  A Primer, Wiley-Interscience, 1981

    Meyer and Matyas, Cryptography:  A New Dimension in Computer Data
        Security, John Wiley & Sons, 1982.

  Books can be ordered from Aegan Park Press.  They are not inexpensive,
        but they are also the only known public source for most of these
        and other books of historical and analytical interest.

        From the Aegean Park Press P.O. Box 2837, Laguna
        Hills, CA 92654-0837

        [write for current catalog].

  The following is a quality, scholarly journal.  Libraries may carry it if
     they are into high technology or computer science.

     Cryptologia:  a cryptology journal, quarterly since Jan 1977.
        Cryptologia; Rose-Hulman Institute of Technology; Terre Haute
        Indiana 47803 [general: systems, analysis, history, ...]
 

        Gordon Welchman, The Hut Six Story, McGraw-Hill, 1982
                (excellent description of his WW-II crypto work
                 (breaking the German Enigma); discussion of modern
                 cryptological implications)
       
       
        Various volumes from Artech House, 610 Washington St., Dedham MA
        02026; including:

                Deavours & Hruh, Machine Cryptography and Modern Cryptanalysis
                        (operation and breaking of cipher machines through
                         about 1955).

                Deavours, et al., CRYPTOLOGY Yesterday, Today, and Tomorrow
                        (Cryptologia reprints -- 1st volume)

                Deavours, et al., CRYPTOLOGY: Machines, History & Methods
                        (Cryptologia reprints -- 2nd volume)

        Cryptologia:  a cryptology journal, quarterly since Jan 1977.
                Cryptologia
                Rose-Hulman Institute of Technology
                Terre Haute Indiana  47803

        Journal of the International Association for Cryptologic Research
                (quarterly since 1988).

        The RSA paper: The Comm. of the ACM, Feb 1978, p. 120

        Claude Shannon's 2 1940's papers in the Bell System Tech Journal.

        Herbert O. Yardley, The American Black Chamber, Bobbs-Merrill, 1931
                (1st hand history -- WW-I era)

        Edwin Layton, "And I Was There", William Morrow & Co., 1985
                (1st hand history -- WW-II)

        W. Kozaczuk, Enigma, University Publications of America, 1984
                (1st hand history (Rejewski's) -- pre-WW-II)


%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Journals, et al         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

        Journal of Cryptology
        Springer-Verlag New York, Inc.
        Service Center Secaucus
        44 Hartz Way
        Secaucus, NJ  07094  USA
        (201)348-4033

$87/year + $8 postage & handling.  Published three times a year.
Scholarly journal.  
 
        Cryptosystems Journal
        Tony Patti, Editor and Publisher
        P. O. Box 188
        Newtown, PA  18940-0188  USA
        (215)579-9888    tony_s_patti@cup.portal.com

$45/year.  Published three times a year.
Journal dedicated to the implementation of cryptographic systems
on IBM PCs.  Emphasis on tutorial/pragmatic aspects.  Evidently
all articles are written by the publisher.  

        FORBIDDEN KNOWLEDGE
        PO BOX 770813
        LAKEWOOD, OH 44107
        
$18 a year - make check m/o to Darren Smith (editor).
Jack Jeffries (cj137@cleveland.Freenet.Edu) says that this is a 
local publication which has articles on cryptology.  That's all
I know about it.


        The Cryptogram
        Journal of the American Cryptogram Association
        P. O. Box 6454 
        Silver Spring, MD  20906

Available by joining the ACA; dues are probably about $20/year by now.
Published six times a year.  
Contains mostly puzzles for you to solve.  No techniques invented
after 1920 are used, with simple substitution being the most common.
Also contains articles on classical cryptosystems, and book reviews.
Not a scholarly journal.


        The Cryptogram Computer Supplement
        Dan Veeneman
        P. O. Box 7
        Burlington, IL  60109  USA

$2.50/issue.  Published three times a year for ACA members.
Newsletter for computer hobbyist members of the ACA.


        The Public Key
        George H. Foot, Editor
        Waterfall, Uvedale Road
        Oxted, Surry  RH8 0EW
        United Kingdom

(Cost unknown.)
Magazine devoted to public key cryptography, especially amoungst
personal computer owners.  [Note that RSA's patents do not apply in
Europe, hence the existence of this magazine.]
 
%%%%%%%%%%
% OTHER  %
%%%%%%%%%%

 There is a publication called the "Surveillant" (6 issues/year, $48.00)
which announces new acquisitions and has some news from the intelligence
field.  Each issue comes with a check-off order form for books announced
in that issue.  It can be contacted at:

Surveillant,
Lock Box Mail Unit 18757
Washington, DC 20036-8757.
==============================================================================

 I'd highly recommend if you have the time and access to follow 
the Usenet groups as they have a wealth of information. Also, 
reading the sci.crypt FAQ, and the few online publications 
including Dorothy Dennings work will help you gain a better 
understanding. In fact, probably better than my hack job. 

Exeunt. 

     Anyone who wishes to correct, add to, or talk about this file 
may feel free to contact me at the internet address above, or BBS below. 

End of File - 12/15/92 - Dave Ferret - Rights? I have rights?
==============================================================================

Do something useful, call The Works BBS: +1 617 861-8976 - cDc 
        "We're in it for the money and the girlies"
