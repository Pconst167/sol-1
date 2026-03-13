
#2   33 07 Aug 85  06:32:49  $0.00
From: Donald Larson on Fido #333 in Net #115 Attache_Node, Schaumburg...........IL
To: Sysop And All On on Fido #100 in Net #115
Subject: Long Distance Services
Everyone has asked at one time or another which of the long distance services
are the best for data transmission.  This is especially true for the person
who calls all over the country in search of that one program that will make
their life easier.  Here's the story, according to an article in the August,
1984 issue of Data Communications.

The editors of the magazine made the following tests and observations.

Carrier    Connect   Attempts  1st Try	BER   Error   BLER   Signal
	    Time     Required		      Burst	      Loss

Allnet	    17.86      1.07	 93	 0	 0     0.0    -21.5
AT&T	    14.16      1.07	 93	105   0.99     1.0    -18.7
ITT-USTS    19.68      2.93	 40    2535   9.02    72.1    -20.6
MCI	    14.96      1.27	 73	427   1.82    14.4    -24.2
SBS	    21.72      1.13	 87	 64   0.50     1.5    -18.9
SPRINT	    16.40      1.67	 56	 96   0.50     4.5    -18.3
TELESAVER   26.67      1.40	 80    4314  23.3    109.0    -19.5
WU	    19.78      2.60	 47	221   1.64     7.4    -24.8

Connect Time - Seconds from last digit to answerback from distant modem
Attempts - Average Number of calls required to complete call to other end
1st Try - Percent of calls completed on first try
BER - Bit error rate, number of bits in error per million bits
Error Burst - number of bursts where 80 consecutive bits in error per million
bits transmitted
BLER - Block error rate, number of 1,000 bit blocks per 1,000 blocks
Signal loss - loss of signal level (in db) at mid frequency (1004 hz)

This is installment 1 of 3 installments.  More later.

Don



Read Command [2] 1 - 26, * :
#3   30 07 Aug 85  21:39:21  $0.00
From: Donald Larson on Fido #333 in Net #115 Attache_Node, Schaumburg...........IL
To: Sysop And All on Fido #100 in Net #115
Subject: Long Distance Services (Part 2)
OK folks, here's installment 2 on long distance services for data
transmission.  Again, this information is from an article in Data
Communications, August 1984.  Here are some additional pieces of data:

Carrier   Slope    S/N	   P/AR     Jitter     Billing

Allnet	   5.4	  27.8	   57.5      5.8	 8.4	 $3.52
AT&T	   1.7	  31.0	   71.3      4.5	 9.0	 $5.06
ITT-USTS   6.3	  25.4	   55.3     10.0	 9.0	 $3.95
MCI	   7.8	  27.9	   58.4      6.7	10.0	 $4.31
SBS	   5.6	  30.4	   50.0      4.1	 9.4	 $3.67
SPRINT	   7.4	  28.7	   63.6      6.1	10.0	 $5.10
TELESAVER  7.3	  26.1	   41.9      8.5	11.0	 $4.91
WU	   8.6	  29.0	   62.8      5.5	11.0	 $4.73

Slope - Difference in attenuation (or loss) between middle frequency (1004)
and the high and low levels (averaged). (Bell Spec < 14)
S/N (Signal to Noise) - Measurement of signal strength over noise (static)
background.  (Bell Spec > 24 db)
PAR (Peak to Average Ratio) - Measurement of velocity distortion according to
frequency.  Medium speed spec from Bell is > 48.
Jitter (Phase Jitter) - Measurement of AC influence upon signals, measured in
degrees.  Maximum permitted by Bell is 10 degrees.  Especially rough on phase
modulated modems (212A is Phase shift keyed).
Billing - Actual time was 8.5 minutes.	Amount shown is the amount the carrier
billed.  This may be due to billing errors and/or minimum connect times
(particularly important for Fido's short connects).  Dollar amounts are for
coast to coast tests and may not be accurate for other comparisons.

In the next and final installment, I'll discuss these stats in a management
overview style (excerpted from the article and annotated by my experience)
along with personal observations.

Stay tuned for chapter 3 (Summary and Recommendations along with a discussion
of equal access and the national toll network).

Don



Read Command [3] 1 - 26, * : 3 4
#5   37 13 Aug 85  16:18:05  $0.00
From: Donald Larson on Fido #333 in Net #115 Attache_Node, Schaumburg...........IL
To: Sysop And All on Fido #100 in Net #115
Subject: Long Distance Services - Part 3
This is the executive summary of the previous two articles.

Allnet - Best cost and bit error rates.  Suffered slightly in analog line
measurements.  Data applications are highly ranked but the voice levels may
suffer.  Excellent prices and billing accuracy.

AT&T - Best overall quality for mixed voice and data applications.  In general,
 the rates they charge are not bad for the quality compared to the batting
averages, rate accuracy, etc.  Still the standard to compare against.

GTE Sprint - Good quality for data, less for voice.  The general call "batting
average" for first try call completion.  Ended up as the highest call cost on
timed calls.  Their actual rates are lower than AT&T but the billing accuracy
was poor.

ITT USTS - Poor by almost all standards, except for price. Recommended for
patient voice callers with plenty of time.

MCI - Mediocre for data.  Voice quality probably acceptable but data
performance not as good as others available.

SBS - Second best in savings and surprisingly good quality.  A little long in
call set up time. May be some problems with over 1200 bps data due to
relatively poor P/AR rating.  Heavily recommended by Data Communications's
magazine tests.

Telesaver - Worst bit and block error rates overall.  Minimal savings over
AT&T does not justify for data or even voice.

Western Union - Poor call completion first attempt average; often required
more than six attempts to connect.  Passable data performance but marginally.
Not recommended for short voice and data calls but savings may be worth it on
long length rates.

I personally have been using SBS for several months with a great deal of
success.  I highly recommend it.  I have also used MCI but had a greater
problem with error rates.  My best advice is to try out the carrier and see
what you see.

Don

PS - Let me know your experiences; I'll try to collect them and publish them
occasionally.

