   1-17-90

                Predicting the Stock Market with Neural Networks

                              by Jeannette Lawrence


    Choosing a stock to buy and deciding when to buy or sell can be a
    complicated and time-consuming activity.  Investment experts study the
    market for years to learn to see the patterns and make accurate
    predictions.  They use a combination of pattern recognition and their
    experience from observing cause-and-effect: "I've seen this scenario
    before and I know what usually happens." The experts have of various
    methods to choose a good stock to buy, sometimes involving many
    calculations before making any decisions.  Not all experts agree as to
    what information is important in making a determination.

    There are also more than 250 programs available to assist you in making
    decisions.  Traditionally, these computer programs have used
    mathematical methods such as linear regression and moving averages to
    make predictions.  Unfortunately, these methods cannot take anything
    subjective into consideration and financial trends are often affected by
    situations that are not easily reduced to equations (for example, how
    foreign relations can affect the price of crude oil).

    An ideal computer tool would look at the statistics as well as the
    subjective aspects and give you financial advice, such as whether or not
    a stock is a good buy.  It would operate in real-time, and be inexpensive
    and easy to use.  Now there is a computing tool that accomplishes all
    that: a neural network.  You can purchase a neural network program that
    runs on a PC for less than $200.

    Neural networks may be the best computer approach to predicting the
    stock market yet.  They learn to predict based upon experience, just
    like the experts.  They are shown many examples of what has happened in
    the past and they find the patterns and trends without formulas, rules
    or complex programming.

    Neural networks are a new kind of computing tool which simulate the
    brain's structure and operation.  The brain is composed of hundreds of
    billions of nerve cells (neurons) which have multitudinous connections
    to each other.  Recently biologists have learned that it is the way the
    cells are connected which provides us with intelligence, rather than
    what's in the cells.  Neural networks mimic many of the brain's most
    powerful abilities, including pattern recognition, association and the
    ability to generalize by observing data.

    In this article you'll learn how neural networks operate and get a look
    at a sample neural networks which predicts stock peaks and lows.  Other
    common uses for neural network include corporate bond evaluation,
    medical diagnostic systems, insurance claim evaluation, sports event
    predictions, loan risk evaluation, and business analysis and decision
    making.

                               Life as a Neural Network

    A new neural network starts out with a "blank mind".  The network is
    taught about a specific problem, such as predicting a stock's price,
    using a technique called training.  Training a neural network is like
    teaching a small child.  To teach a child to recognize the letters of
    the alphabet, you might first show him a picture of the letter "A" and
    ask him what letter he's looking at.  If he doesn't guess right, you
    tell him he is looking at an "A".  Next, you could show him a "B" and
    repeat the process.  You would do this for all the letters of the
    alphabet, then start over.  Eventually he will learn to recognize all of
    the letters correctly.

    The network is shown some historical data and it guesses what the result
    is.  When the network is wrong, it is corrected.  The next time it sees
    that data, it will guess more accurately.  The network is shown lots of
    data, over and over until is learns all the data and results.  Like a
    person, a trained neural network can generalize, making a reasonable
    guess from data which is different from any it has seen before.

    Just how does correcting the network cause it to learn?  It's all in the
    connections between the neurons.  The connections allow the neurons to
    communicate with each other and form answers.  When the network makes a
    wrong guess, an adjustment is made to the way neurons are connected,
    thus it is able to learn.  With most commercially available neural
    network programs (such as BrainMaker, the one used in the stock
    predicting example) training adjustments are performed automatically by
    the neural network program itself;  all you have to do is provide the
    data and the expected results for training.

                 A Neural Network Creates Its Own Working Model

    When choosing a stock to buy, the experts do not agree as to what
    information is important.  The performance of some stocks are tied to
    the strength of the economy and may react strongly to government
    economic news releases.  Some experts believe the price to earning ratio
    (P/E) is most important.  Some say "free" cash-flow (operating cash flow
    minus expenditures) has more effect on stock prices than P/E ratios.
    Others believe in the share price-to-book value ratio.  This is probably
    meaningful only when comparing stocks within the same industry.  Still
    others think that you should compare the P/E, yield, and price-to-book
    value of the potential buy to Standard & Poor Industrials.  Another
    method is to use the price-to-net working capital ratio.

    With a neural network, you don't need to worry about which theory to
    follow or perform endless calculations for comparison.  You can include
    information for any or all the theories plus some subjective item such
    as the quality of foreign affairs.  The network will figure out what
    information correlates to what.  It creates its own internal
    representation of the problem during training based upon whatever
    information you decide to give it.  People rarely use all the
    information available because it's just too much to keep track of, but
    neural networks do not get overwhelmed by detail.  If some piece of
    information you provide turns out to be unimportant, the network will
    just learn to ignore it.  Mathematical programs are not this flexible.

                           Designing a Neural Network

    Designing a neural network is a simple process.  The first thing you do
    is decide what you want the network to tell you and what information it
    will use to derive the answer.  For example, suppose you want to make a
    network which will predict what the Dollar to Yen ratio will be next week.
    We will use a very simple design just to summarize the process.  Let's
    choose some indicators upon which the network will base its result:

* The change in London Gold from 2 weeks ago to 1 week ago (LG2_1)
* The change in London Gold from 1 week ago to today (LG1_0)
* Yen/Dollar exchange rate from 2 weeks ago to 1 week ago (YD2_1)
* Yen/Dollar exchange rate from 1 week ago to today (YD1_0)
* Deutche Mark/Dollar exchange from 2 weeks ago to 1 week ago (DM2_1)
* Deutche Mark/Dollar exchange from 1 week ago to today (DM1_0)
* Sterling/Dollar exchange from 2 weeks ago to 1 week ago (SD2_1)
* Sterling/Dollar exchange from 1 week ago to today (SD1_0)
* Dow Jones Average from 2 weeks ago to 1 week ago (D2_1)
* Dow Jones Average from 1 week ago to today (D1_0)
* New York Stock Exchange Volume from 2 weeks ago to 1 week ago (NYSE2_1)
* New York Stock Exchange Volume from 1 week ago to today (NYSE1_0)

    The output will be the change in the Yen/Dollar exchange rate between
    this week and the next:

* Yen/Dollar exchange rate next week (YD_out)

    You cannot teach a neural network trends by simply presenting the values
    for each type of input, one fact after another, in order of time.  You
    cannot tell it that fact #1 is month 1, fact #2 is month 2, etc.  It
    will not pick up the trend.  That is why we are showing it historical
    information.

    Now we must collect our historical data.  An easy way to do this is to
    look through back issues of the Wall Street Journal, or get the
    information from a financial database service.  The data goes into a
    file that the neural network program reads in.

    In addition you can use traditional mathematical methods with neural
    networks.  For example, to a trend-analyzing network you can add
    information based upon moving averages.  Creating moving averages helps
    build networks that depend on current numbers and past numbers, but
    ignore extremely short small changes.  For example, assume you want to
    predict how the price of a stock will move, but in a general sort of way
    in a bigger time frame.  Based on what the average stock price has been
    from week to week during this month and last, the network can predict
    what the average stock price is going to be each week for the next
    month.  NetMaker (a data manipulation program provided with BrainMaker)
    automates this task for you.

    After you have your data ready (including the output), BrainMaker
    program will create and train the new network for you.  With some
    programs, you can watch the training on your screen, edit and test the
    network using pop-up menus, print out the results, graph trends, etc.
    You can set the level of accuracy that you need from the network.  After
    the network is trained, you can give the network current information and
    get a prediction of next week's change in the Yen/Dollar ratio.

    The network would look like this:

    Inputs:                                                        Output:
                                                     ÚÄÄÄÄÄÄÄÄÄ¿
London Gold change 2 weeks-1 week ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´         ³
London Gold 1 week -today ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´         ³
Yen/Dollar exchange rate change 2 weeks-1 week ÄÄÄÄÄÄ´         ³
Yen/Dollar exchange rate 1 week -today ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´         ³
Deutche Mark/Dollar exchange change 2 weeks-1 week ÄÄ´ The     ³
Deutche Mark/Dollar exchange 1 week -today ÄÄÄÄÄÄÄÄÄÄ´ Neural  ÃÄÄ Yen/Dollar
Sterling/Dollar exchange change 2 weeks-1 week ÄÄÄÄÄÄ´ Network ³   change one
Sterling/Dollar exchange 1 week -today ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´         ³   week later
Dow Jones Average change 2 weeks-1 week ÄÄÄÄÄÄÄÄÄÄÄÄÄ´         ³
Dow Jones Average 1 week -today ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´         ³
NY Stock Exchange Volume change 2 weeks-1 week ÄÄÄÄÄÄ´         ³
NY Stock Exchange Volume 1 week -today ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´         ³
                                                     ÀÄÄÄÄÄÄÄÄÄÙ

    Each type of input information is assigned to a certain input neuron.
    Each output (result) is assigned an output neuron.  What's in the box in
    between?  This is where all the internal, or hidden, neurons are kept.
    This is the area where connections are modified during training by the
    program.

                         A Stock Predicting Application

    Once you have decided on a stock to buy, you need to know when to buy
    it, and then later when to sell it.  This application pinpoints when a
    particular stock has reached either a long-term peak or a long-term low
    in value.

    Some-company has used BrainMaker to create a series of trained neural
    networks for people interested in investing in the stock market.  Their
    system determines when a particular stock price is as high, or as low,
    as it will be for a long time.  The investor can then buy those stocks
    which are ready to rise and sell (or sell short) stocks which have
    reached their peak.

    A separate network was trained for each stock being predicted.  Each of
    the ten current networks was trained with price data taken over the last
    two years.  Long-term highs and lows for training were chosen by the
    resident experts.  Once trained, the network detected 70% to 90% of the
    actual highs and lows when it was shown data it had never seen before.
    This compares very favorably with the 50% results which standard
    technical analysis had been providing.  In addition, intermediate highs
    and lows less extreme than the ones the network had been trained to spot
    were also found.  In each of these intermediate cases, the appropriate
    neurons fired to indicate the presence of a high or low, but they did
    not fire as strongly as when indicating a long-term high or low.  There
    were very few cases of the network mistakenly predicting a high or low
    when not even an intermediate high or low was present.  In the words of
    a Brainmaker user, "you're making more money with it than without it...
    It's definitely picking up the trends, which in the stock market is all
    you need."

    Each network is organized as follows: the closing prices of a particular
    stock for the twenty days up to the day you're interested in are the
    inputs (the information the network uses to make its prediction).  The
    outputs indicate if the stock is near a high or low, and they're
    organized as follows: there are thirteen outputs, each one corresponding
    to a different circumstance.  One output indicates that the stock is not
    nearing either a high or a low;  this is by far the most common case.
    Six of the outputs correspond to a stock nearing a high;  one of these
    means the high is today;  the others indicate a high in one to five days
    from now, respectively.  Similarly, there are six outputs indicating
    that the stock is nearing a low, in either one to five days, or today.
    The output neuron corresponding to today's condition is assigned a value
    of 1;  the other 12 are given value 0.

    Some-company currently has networks trained to locate trends in AT&T,
    Mobil, Boeing, and seven other major corporations.  As their service
    grows, they plan to expand to the entire Standard & Poor's 100, and
    eventually the S & P 500.

    This is a particularly well-designed network because it utilizes a real
    neural network strength, namely noticing hard-to-find patterns in large
    amounts of data, without requiring a high degree of numerical accuracy.

                                     Summary

    People have successfully designed and trained neural networks to predict
    the stock market.  Neural networks function by finding patterns in the
    examples which you provide.  These patterns become a part of the network
    during training.  You only need to provide the data upon which you want
    the network to base its predictions.  Neural networks operate at
    lightning speed, are inexpensive and run on PC's.

    The network described above was created with the BrainMaker Neural
    Network Software System.  BrainMaker is available from California
    Scientific Software, 10141 Evening Star Dr.  #6, Grass Valley, CA
    95945-9051, and includes a 255-page "Introduction to Neural Networks"
    and a 422-page User's Guide.  The price is $195.00.


    Note: Some-company has asked to have their name withheld except by
    special permission.
                                                          