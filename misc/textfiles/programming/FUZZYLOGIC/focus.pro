
                          INTRODUCTION

     Cameras with automatic focusing systems usually measure the
     distance to the center of a finder's view. This method, however,
     is inaccurate when the object of interest is not at the center of
     the view (Figure 1). Measuring more than one distance is an
     approach that may solve this problem. The following example shows
     the application of fuzzy inference as a means of automatically
     determining correct focus distance. 



     FUZZY INFERENCE

     Objective

     Determine the object distance using three distance measures for
     an automatic camera focusing system. 
     
     Definition of Input/Out Variables 
     
     Inputs to the FIU (Fuzzy Inference Unit) are three distance
     measures at left, center and right points in the finder view.
     Outputs are the plausibility values associated with these three
     points (Figure 2). The point with the highest plausibility is
     deemed to be the object of interest. Its distance is then
     forwarded to the automatic focusing system.
     
     Each input variable, representing distance, has three labels:
     Near, Medium, and Far. Each output variable, representing
     plausibility, has four labels: Low, Medium, High, and VeryHigh.
     Membership functions corresponding to these labels are shown in
     Figures 3a and 3b. 
     
     
     Fuzzy Rules
     
     The guiding principle for establishing rules of this automatic
     focusing system is that the likelihood of an object being at
     medium distance (typically 10 meters) is high, and becomes very
     low as distance increases (say, more than 40 meters).
     
     Source Code of Fuzzy Inference Unit
     
     	$ FILENAME:	camera/af1.fil
     	$ DATE: 	07/29/92
     	$ UPDATE:	08/06/92
     
     	$ Three inputs, three outputs, decision making for
        $ Automatic Focusing System
     	$ INPUT(S):	Left(Distance), Center(Distance),
        $ Right(Distance)
     	$ OUTPUT(S):	Plau(sibility)_of_Left,
        $ Plau(sibility)_of_Center, Plau(sibility)_of_Right
     	
     	$ FIU HEADER
     	
     	fiu tvfi (min max) *8;
     	
     	$ DEFINITION OF INPUT VARIABLE(S)
     
     invar Left "meter" : 1 () 100 [
     	Far	(@10, 0,  @40,  1,  @100, 1),
     	Medium	(@1,  0,  @10,  1,  @40,  0),
     	Near	(@1,  1,  @10,  0)
     	]; 
     
     invar Center "meter" : 1 () 100 [
     	Far	(@10, 0,  @40,  1,  @100, 1),
     	Medium	(@1,  0,  @10,  1,  @40,  0),
     	Near	(@1,  1,  @10,  0)
     	]; 
     
     invar Right "meter" : 1 () 100 [
     	Far	(@10, 0,  @40,  1,  @100, 1),
     	Medium	(@1,  0,  @10,  1,  @40,  0),
     	Near	(@1,  1,  @10,  0)
     	]; 
     
     $ DEFINITION OF OUTPUT VARIABLE(S)
     
     outvar Plau_of_Left "degree" : 0 () 1 * (
     	VeryHigh = 1.0,      
     	High = 0.8,
     	Medium = 0.5,
     	Low = 0.3
         );
     
     outvar Plau_of_Center "degree" : 0 () 1 * (
     	VeryHigh = 1.0,      
     	High = 0.8,
     	Medium = 0.5,
     	Low = 0.3
         );
     
     outvar Plau_of_Right "degree" : 0 () 1 * (
     	VeryHigh = 1.0,
     	High = 0.8,
     	Medium = 0.5,
     	Low = 0.3
         );
     
     $ RULES
     
     if Left is Near then Plau_of_Left is Medium; 
     if Center is Near then Plau_of_Center is Medium; 
     if Right is Near then Plau_of_Right is Medium;
     
     if Left is Near and Center is Near and Right is Near then
     Plau_of_Center is High; 
     if Left is Near and Center is Near then Plau_of_Left is Low; 
     if Right is Near and Center is Near then Plau_of_Right is Low;
     
     if Left is Medium then Plau_of_Left is High; 
     if Center is Medium then Plau_of_Center is High; 
     if Right is Medium then Plau_of_Right is High;
     
     if Left is Medium and Center is Medium and Right is Medium then
     Plau_of_Center is VeryHigh; 
     if Left is Medium and Center is Medium then Plau_of_Left is Low;
     if Right is Medium and Center is Medium then Plau_of_Right is Low;
     
     if Left is Far then Plau_of_Left is Low; 
     if Center is Far then Plau_of_Center is Low; 
     if Right is Far then Plau_of_Right is Low; 
     if Left is Far and Center is Far and Right is Far then
     Plau_of_Center is High;
     
     if Left is Medium and Center is Far then Plau_of_Center is Low; 
     if Right is Medium and Center is Far then Plau_of_Center is Low
     
     end
     
     Input/Output Response
     
     Now let us compile the FIU source code given above and use the
     FIDE analyzer to see how this unit works. Figures 4a and 4b
     provide two input/output response surfaces of the FIU. From
     Figure 4a, we see that Plausibility_of_Center becomes high when
     the distance at the center is around 10 meters, a distance we
     defined to be Medium in the definition of input variables. It
     becomes lower when the distance increases, especially when the
     distance on the left is Medium. Figure 4b shows the
     Plausibility_of_Left is high when the distance on the left is
     around 10 meters.  In this case, when the distance at the center
     is about the same as that on the left, we choose center as the
     desired object.  The Plausibility_of_Right is similar to the
     Plausibility_of_Left.  The three outputs of the FIU are compared
     to identify the point with highest plausibility.  The distance
     at this point is the focus distance.  By adjusting the membership 
     functions of the distance labels, we can achieve different response
     surfaces for different purposes. 
     
     
     COMMENTS
     
     Remember that this example is provided only for easy-to-use
     compact cameras targeted for the mass market. For professional
     photographers it may be inappropriate to provide strictly
     automatic camera focusing using the three distance measures
     method. However, if suitable manual overrides were available, it
     would still be useful as an option in some situations (e.g. when
     speed is important). Besides automatic focusing(AF), fuzzy logic
     can be used in automatic exposure(AE) and automatic zooming(AZ).
     For AE and and AZ, the input/output variables and rules of the FIU
     will be different from those shown above for AF, but the design
     process is very similar.
     
     (Weijing Zhang, Applications Engineer, Aptronix Inc.)
  
     
     
                  For Further Information Please Contact:
    
                          Aptronix Incorporated
                      2150 North First Street #300
                           San Jose, CA 95131
                           Tel (408) 428-1888
                           Fax (408) 428-1884
                   FuzzyNet (408) 428-1883 data 8/N/1
    

    
                        Aptronix Company Overview
    
    Headquartered in San Jose, California, Aptronix develops and
    markets fuzzy logic-based software, systems and development
    tools for a complete range of commercial applications.  The
    company was founded in 1989 and has been responsible for a
    number of important innovations in fuzzy technology.
    
    Aptronix's product Fide (Fuzzy Inference Development
    Environment) -- is a complete environment for the development of
    fuzzy logic-based systems.  Fide provides system engineers with
    the most effective fuzzy tools in the industry and runs in
    MS-Windows(TM) on 386/486 hardware.  The price for Fide is $1495 and
    can be ordered from any authorized Motorola distributor.  For a
    list of authorized distributors or more information, please
    call Aptronix.  The software package comes with complete
    documentation on how to develop fuzzy logic based applications,
    free telephone support for 90 days and access to the Aptronix
    FuzzyNet information exchange.
     

                    
    
                         Automatic Focusing System
     
                    FIDE Application Note 002-150892		
                           Aptronix Inc., 1992 

