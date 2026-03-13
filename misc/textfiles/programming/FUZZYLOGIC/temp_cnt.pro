
                               INTRODUCTION

     Temperature control is widely used in various processes.  These
     processes, no matter if it is in a large industrial plant, or in
     a home appliance, share several unfavorable features. These
     include non-linearity, interference, dead time, and external
     disturbances, among others. Conventional approaches usually do
     not result in satisfactory temperature control. 
     
     In this Application Note we provide examples of fuzzy logic used
     to control temperature in several different situations. These
     examples are developed using FIDE, an integrated fuzzy inference
     development environment. 
     
     FUZZY CONTROL IN A GLASS MELTING FURNACE
     
     A glass melting furnace has two rooms, a melter and a refiner.
     Raw materials are melted into glass at high temperature in the
     melter. The temperature of the melted glass is adjusted to a
     suitable temperature for the glass forming process to follow. It
     takes a long time to change the temperature in the furnace, which
     is an example of dead-time in this process. The flow of melted
     glass is not uniform, especially at the bottom of the furnace. In
     addition to temperature, other factors also contribute to the
     thermal characteristics of melted glass.  Raw material mixing
     procedure, glass color, and the amount of the glass are some of
     the factors.  Because there are many variables and the procedure
     complex, it is very difficult to design an effective temperature
     controller for this application using conventional control
     approaches.
     
     
     Control Objective
     
     Control temperature in a dead time process such as in a glass
     melting furnace.
     
     Fuzzy Control System
     
     The control block diagram for a glass melting furnace is shown in
     Figure 1. Control value u is applied to the
     process to adjust the temperature. This value is changed by two
     compensators. The variation of u can be written
     as u = ud + ue where ud is the output of
     the dead time compensator, and ue is the output
     of the error compensator. The dead time compensator is used to
     reduce the effect dead time has on the process. Its output
     (ud), an incremental change in control value, is
     derived from the change in the current and previous control value
     (u) and the time differential of output
     temperature (y). The error compensator is used
     to reduce the difference between the desired temperature and the
     actual temperture of hte furnace.  Its outpu (ue), also an
     incremental change in control value, is inferred from the
     difference(error) e and its time differential ‚. ud and ue are
     combined to change the control value u.
       
     
     Input/Output Variables of the Dead Time Compensator
     
     Labels and membership functions of input/output variables of the
     dead time compensator are shown in Figure 2a, 2b, 2c. The
     membership functions can be created by using the MF editor in
     FIDE. 
     
     
     FIU Source Code for the Dead Time Compensator
     
     The following is the source code for the dead time compensator
     written in FIL, the fuzzy inference language provided in FIDE.  
     
     $ FILENAME:	temp/temp1_dt.fil 
     $ DATE: 	08/31/1992 
     $ UPDATE:	09/02/1992
     
     $ Temperature Controller : Part 1 : dead time compensator 
     $ Two inputs, one output 
     $ INPUT(S): Prev(ious)_Var(iationOf)_Ctrl, TimeDiff(erentialOf)_Output
     $ OUTPUT(S): Var(iationOf)_Ctrl
     
     $ FIU HEADER
     
     fiu tvfi (min max) *8;
     
     $ DEFINITION OF INPUT VARIABLE(S)
     
     invar Prev_Var_Ctrl " " : -1 () 1 [
     	P_Large        (@0.45,  0, @0.75,  1,  @1.00,  1),
     	P_Medium       (@0.15,  0, @0.45,  1,  @0.75,  0),
     	P_Small        (@-0.15, 0, @0.15,  1,  @0.45,  0),
     	N_Small        (@-0.45, 0, @-0.15, 1,  @0.15,  0),
     	N_Medium       (@-0.75, 0, @-0.45, 1,  @-0.15, 0),
     	N_Large        (@-1.00, 1, @-0.75, 1,  @-0.45, 0)
     	]; 
     
     invar TimeDiff_Output " " : -90 () 90 [
     	P_Large       (@20,  0,  @60,  1,  @90,  1),
     	P_Small       (@-20, 0,  @20,  1,  @60,  0),
     	N_Small       (@-60, 0,  @-20, 1,  @20,  0),
     	N_Large       (@-90, 1,  @-60, 1,  @-20, 0)
     	]; 
     
     $ DEFINITION OF OUTPUT VARIABLE(S)
     
     outvar Var_Ctrl " " : -1 () 1 * (
     	P_Large        = 0.80,
     	P_Medium       = 0.40,
     	P_Small        = 0.20,
     	Zero           = 0.00,
     	N_Small        = -0.20,
     	N_Medium       = -0.40,
     	N_Large        = -0.80
         );
     
     $ RULES
     
     if Prev_Var_Ctrl is P_Large and TimeDiff_Output is P_Large then
     Var_Ctrl is N_Large; 
     if Prev_Var_Ctrl is P_Large and TimeDiff_Output is P_Small then 
     Var_Ctrl is N_Medium; 
     if Prev_Var_Ctrl is P_Large and TimeDiff_Output is N_Small then
     Var_Ctrl is N_Small; 
     if Prev_Var_Ctrl is P_Large and TimeDiff_Output is N_Large then 
     Var_Ctrl is Zero;
      
     if Prev_Var_Ctrl is P_Medium and TimeDiff_Output is P_Large then 
     Var_Ctrl is N_Medium;
     if Prev_Var_Ctrl is P_Medium and TimeDiff_Output is P_Small then 
     Var_Ctrl is N_Small;
     if Prev_Var_Ctrl is P_Medium and TimeDiff_Output is N_Small then 
     Var_Ctrl is Zero;
     if Prev_Var_Ctrl is P_Medium and TimeDiff_Output is N_Large then 
     Var_Ctrl is Zero;
     
     if Prev_Var_Ctrl is P_Small and TimeDiff_Output is P_Large then 
     Var_Ctrl is N_Small;
     if Prev_Var_Ctrl is P_Small and TimeDiff_Output is P_Small then 
     Var_Ctrl is Zero;
     if Prev_Var_Ctrl is P_Small and TimeDiff_Output is N_Small then 
     Var_Ctrl is Zero;
     if Prev_Var_Ctrl is P_Small and TimeDiff_Output is N_Large then 
     Var_Ctrl is Zero;
     
     if Prev_Var_Ctrl is N_Small and TimeDiff_Output is P_Large then 
     Var_Ctrl is Zero;
     if Prev_Var_Ctrl is N_Small and TimeDiff_Output is P_Small then 
     Var_Ctrl is Zero;
     if Prev_Var_Ctrl is N_Small and TimeDiff_Output is N_Small then 
     Var_Ctrl is Zero;
     if Prev_Var_Ctrl is N_Small and TimeDiff_Output is N_Large then 
     Var_Ctrl is P_Small;
     
     if Prev_Var_Ctrl is N_Medium and TimeDiff_Output is P_Large then 
     Var_Ctrl is Zero;
     if Prev_Var_Ctrl is N_Medium and TimeDiff_Output is P_Small then 
     Var_Ctrl is Zero;
     if Prev_Var_Ctrl is N_Medium and TimeDiff_Output is N_Small then 
     Var_Ctrl is P_Small;
     if Prev_Var_Ctrl is N_Medium and TimeDiff_Output is N_Large then 
     Var_Ctrl is P_Medium;
     
     if Prev_Var_Ctrl is N_Large and TimeDiff_Output is P_Large then 
     Var_Ctrl is Zero;
     if Prev_Var_Ctrl is N_Large and TimeDiff_Output is P_Small then 
     Var_Ctrl is P_Small;
     if Prev_Var_Ctrl is N_Large and TimeDiff_Output is N_Small then 
     Var_Ctrl is P_Medium;
     if Prev_Var_Ctrl is N_Large and TimeDiff_Output is N_Large then 
     Var_Ctrl is P_Large
     
     end
     
     
     Input/Output Response of the Dead Time Compensator
     
     Figure 3 shows the response surface of the dead time compensator.
     This surface can be obtained by using the Analyzer tool provided
     in FIDE.  
     
     
     Input/Output Variables of the Error Compensator
     
     Labels and membership functions of input/output variables of the
     Error Compensator are shown in Figure 4a, 4b, 4c.
     
     
     FIU Source Code of Error Compensator
     
     $ FILENAME:	temp/temp1_er.fil
     $ DATE: 	09/02/1992
     $ UPDATE:	09/03/1992
     
     $ Temperature Controller : Part 2 : error compensator
     $ Two inputs, one output
     $ INPUT(S):	Error, TimeDiff(erentialOf)_Error
     $ OUTPUT(S):	Var(iationOf)_Ctrl
     
     $ FIU HEADER
     
     fiu tvfi (min max) *8;
     
     $ DEFINITION OF INPUT VARIABLE(S)
     
     invar Error " " : -100 () 100 [
     	P_Large		(@50,  0, @80,  1,  @100, 1),
     	P_Medium    	(@20,  0, @50,  1,  @80,  0),
     	P_Small     	(@0,   0, @20,  1,  @50,  0),
     	Zero        	(@-20, 0, @0,   1,  @20,  0),
     	N_Small     	(@-50, 0, @-20, 1,  @0,   0),
     	N_Medium    	(@-80, 0, @-50, 1,  @-20, 0),
     	N_Large     	(@-100,1, @-80, 1,  @-50, 0)
     	]; 
     
     invar TimeDiff_Error " " : -90 () 90 [
     	P_Large     	(@50,  0,  @70,  1,  @90,  1),
     	P_Medium    	(@30,  0,  @50,  1,  @70,  0),
     	P_Small     	(@0,   0,  @30,  1,  @50,  0),
     	Zero        	(@-30, 0,  @0,   1,  @30,  0),
     	N_Small     	(@-50, 0,  @-30, 1,  @0,   0),
     	N_Medium    	(@-70, 0,  @-50, 1,  @-30, 0),
     	N_Large     	(@-90, 1,  @-70, 1,  @-50, 0)
     	]; 
     
     
     $ DEFINITION OF OUTPUT VARIABLE(S)
     
     outvar Var_Ctrl " " : -1 () 1 * (
     	P_Large      	= 0.80,      
     	P_Medium     	= 0.40,
     	P_Small      	= 0.20,
     	Zero         	= 0.00,
     	N_Small      	= -0.20,
     	N_Medium     	= -0.40,
     	N_Large      	= -0.80
         );
     
     
     $ RULES
     
     if Error is Zero and TimeDiff_Error is P_Large then Var_Ctrl is 
     P_Large;
     if Error is Zero and TimeDiff_Error is P_Medium then Var_Ctrl is 
     P_Medium;
     if Error is Zero and TimeDiff_Error is P_Small then Var_Ctrl is 
     Zero;
     if Error is Zero and TimeDiff_Error is Zero then Var_Ctrl is 
     Zero;
     if Error is Zero and TimeDiff_Error is N_Small then Var_Ctrl is 
     Zero;
     if Error is Zero and TimeDiff_Error is N_Medium then Var_Ctrl is 
     N_Medium;
     if Error is Zero and TimeDiff_Error is N_Large then Var_Ctrl is 
     N_Large;
     
     if Error is P_Large  and TimeDiff_Error is Zero then Var_Ctrl is 
     P_Large;
     if Error is P_Medium and TimeDiff_Error is Zero then Var_Ctrl is 
     P_Medium;
     if Error is P_Small  and TimeDiff_Error is Zero then Var_Ctrl is 
     Zero;
     if Error is N_Small  and TimeDiff_Error is Zero then Var_Ctrl is 
     Zero;
     if Error is N_Medium and TimeDiff_Error is Zero then Var_Ctrl is 
     N_Medium;
     if Error is N_Large  and TimeDiff_Error is Zero then Var_Ctrl is 
     N_Large;
     
     if Error is P_Medium and TimeDiff_Error is P_Medium then Var_Ctrl is 
     P_Large;
     if Error is P_Small  and TimeDiff_Error is P_Small then Var_Ctrl is 
     Zero;
     if Error is P_Medium and TimeDiff_Error is N_Medium then Var_Ctrl is 
     Zero;
     if Error is P_Small  and TimeDiff_Error is N_Large then Var_Ctrl is 
     N_Medium;
     if Error is N_Small  and TimeDiff_Error is P_Large then Var_Ctrl is 
     P_Medium;
     if Error is N_Medium and TimeDiff_Error is P_Medium then Var_Ctrl is 
     Zero;
     if Error is N_Small  and TimeDiff_Error is N_Small then Var_Ctrl is 
     Zero;
     if Error is N_Medium and TimeDiff_Error is N_Medium then Var_Ctrl is 
     N_Large
     
     end
     
     
     Input/Output Response of Error Compensator
     
     Figure 5 shows the response surface of the error compensator. 
     
     
     COMMENTS
     
     Temperature control systems, using fuzzy controllers as shown
     above, have been put into operation and provide performance
     better than conventional control systems. Fuzzy controllers also
     show robust response in the handling of dead time behavior in the
     process. 
     
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
     



                            Temperature Control
                          
                     FIDE Application Note 004-080992 
                           Aptronix Inc., 1992 

                            
     


