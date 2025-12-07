"Fighting demon"

<ROUTINE I-FIGHT ("AUX" (FIGHT? <>) (LEN <GET ,VILLAINS 0>)
		  CNT OO O P) 
      <COND (,DEAD <RTRUE>)>
      <SET CNT 0>
      <REPEAT ()
	      <SET CNT <+ .CNT 1>>
	      <COND (<==? .CNT .LEN> <RETURN>)>
	      <SET OO <GET ,VILLAINS .CNT>>
	      <COND (<IN? <SET O <GET .OO ,V-VILLAIN>> ,HERE>
		     <COND (<AND <==? .O ,THIEF> ,THIEF-ENGROSSED>
			    <SETG THIEF-ENGROSSED <>>)
			   (<L? <GETP .O ,P?STRENGTH> 0>
			    <SET P <GET .OO ,V-PROB>>
			    <COND (<AND <NOT <0? .P>> <PROB .P>>
				   <PUT .OO ,V-PROB 0>
				   <AWAKEN .O>)
				  (ELSE
				   <PUT .OO ,V-PROB <+ .P 25>>)>)
			   (<OR <FSET? .O ,FIGHTBIT>
				<APPLY <GETP .O ,P?ACTION> ,F-FIRST?>>
			    <SET FIGHT? T>)>)
		    (ELSE
		     <COND (<FSET? .O ,FIGHTBIT>
			    <APPLY <GETP .O ,P?ACTION> ,F-BUSY?>)>
		     <COND (<==? .O ,THIEF> <SETG THIEF-ENGROSSED <>>)>
		     <FCLEAR ,WINNER ,STAGGERED>
		     <FCLEAR .O ,STAGGERED>
		     <FCLEAR .O ,FIGHTBIT>
		     <AWAKEN .O>)>>
      <COND (<NOT .FIGHT?> <RTRUE>)>
      <DO-FIGHT .LEN>>

<ROUTINE AWAKEN (O "AUX" (S <GETP .O ,P?STRENGTH>))
	 <COND (<L? .S 0>
		<PUTP .O ,P?STRENGTH <- 0 .S>>
		<APPLY <GETP .O ,P?ACTION> ,F-CONSCIOUS>)>
	 T>

"SWORD demon"

<ROUTINE I-SWORD ("AUX" (DEM <INT I-SWORD>) (G <GETP ,SWORD ,P?TVALUE>)
		        (NG 0) P T L)
	 #DECL ((NG G) FIX)
	 <COND (<IN? ,SWORD ,ADVENTURER>
		<COND (<INFESTED? ,HERE> <SET NG 2>)
		      (ELSE
		       <SET P 0>
		       <REPEAT ()
			       <COND (<0? <SET P <NEXTP ,HERE .P>>>
				      <RETURN>)
				     (<NOT <L? .P ,LOW-DIRECTION>>
				      <SET T <GETPT ,HERE .P>>
				      <SET L <PTSIZE .T>>
				      <COND (<EQUAL? .L ,UEXIT ,CEXIT ,DEXIT>
					     <COND (<INFESTED? <GETB .T 0>>
						    <SET NG 1>
						    <RETURN>)>)>)>>)>
		<COND (<==? .NG .G>)
		      (<==? .NG 2>
		       <TELL "Your sword has begun to glow very brightly." CR>)
		      (<1? .NG>
		       <TELL "Your sword is glowing with a faint blue glow."
			     CR>)
		      (<0? .NG>
		       <TELL "Your sword is no longer glowing." CR>)>
		<PUTP ,SWORD ,P?TVALUE .NG>)
	       (ELSE <PUT .DEM ,C-ENABLED? 0>)>>

<ROUTINE INFESTED? (R "AUX" (F <FIRST? .R>)) 
	 <REPEAT ()
		 <COND (<NOT .F> <RETURN <>>)
		       (<AND <FSET? .F ,VILLAIN> <NOT <FSET? .F ,INVISIBLE>>>
			<RTRUE>)
		       (<NOT <SET F <NEXT? .F>>> <RETURN <>>)>>>

"THIEF demon"

<ROUTINE I-THIEF ("AUX" (RM <LOC ,THIEF>) ROBJ HERE? (ONCE <>))
   <PROG ()
     <COND (<SET HERE? <NOT <FSET? ,THIEF ,INVISIBLE>>>
	    <SET RM <LOC ,THIEF>>)>
     <COND
      (<AND <==? .RM ,TREASURE-ROOM> <NOT <==? .RM ,HERE>>>
       <COND (.HERE? <HACK-TREASURES> <SET HERE? <>>)>
       <DEPOSIT-BOOTY ,TREASURE-ROOM>)
      (<==? .RM ,HERE>
       <THIEF-VS-ADVENTURER .HERE?>)
      (ELSE
       <COND (<AND <IN? ,THIEF .RM>
		   <NOT <FSET? ,THIEF ,INVISIBLE>>> ;"Leave if victim left"
	      <FSET ,THIEF ,INVISIBLE>
	      <SET HERE? <>>)>
       <COND (<FSET? .RM ,TOUCHBIT>     ;"Hack the adventurer's belongings"
	      <ROB .RM ,THIEF 75>
	      <COND (<AND <FSET? .RM ,MAZEBIT> <FSET? ,HERE ,MAZEBIT>>
		     <ROB-MAZE .RM>)
		    (ELSE <STEAL-JUNK .RM>)>)>)>
     <COND (<AND <SET ONCE <NOT .ONCE>> <NOT .HERE?>>
					   ;"Move to next room, and hack."
	    <REPEAT ()
		    <COND (<AND .RM <SET RM <NEXT? .RM>>>)
			  (ELSE <SET RM <FIRST? ,ROOMS>>)>
		    <COND (<AND <NOT <FSET? .RM ,SACREDBIT>>
				<FSET? .RM ,RLANDBIT>>
			   <MOVE ,THIEF .RM>
			   <FCLEAR ,THIEF ,FIGHTBIT>
			   <FSET ,THIEF ,INVISIBLE>
			   <RETURN>)>>
	    <AGAIN>)>>
   <COND (<NOT <==? .RM ,TREASURE-ROOM>>
	  <DROP-JUNK .RM>)>>

<ROUTINE DROP-JUNK (RM "AUX" X N)
	 <SET X <FIRST? ,THIEF>>
	 <REPEAT ()
		 <COND (<NOT .X> <RETURN>)>
		 <SET N <NEXT? .X>>
		 <COND (<==? .X ,STILETTO>)
		       (<AND <0? <GETP .X ,P?TVALUE>> <PROB 30 T>>
			<FCLEAR .X ,INVISIBLE>
			<MOVE .X .RM>
			<COND (<==? .RM ,HERE>
			       <TELL 
"The robber, rummaging through his bag, dropped a few items he found
valueless." CR>)>)>
		 <SET X .N>>>

<ROUTINE STEAL-JUNK (RM "AUX" X N)
	 <SET X <FIRST? .RM>>
	 <REPEAT ()
		 <COND (<NOT .X> <RETURN>)>
		 <SET N <NEXT? .X>>
		 <COND (<AND <0? <GETP .X ,P?TVALUE>>
			     <FSET? .X ,TAKEBIT>
			     <NOT <FSET? .X ,SACREDBIT>>
			     <NOT <FSET? .X ,INVISIBLE>>
			     <OR <==? .X ,STILETTO>
				 <PROB 10 T>>>
			<MOVE .X ,THIEF>
			<FSET .X ,TOUCHBIT>
			<FSET .X ,INVISIBLE>
			<COND (<==? .X ,ROPE> <SETG DOME-FLAG <>>)>
			<COND (<==? .RM ,HERE>
			       <TELL "You suddenly notice that the "
				     D .X " vanished." CR>)>
			<RETURN>)>
		 <SET X .N>>>

<ROUTINE ROB (WHAT THIEF "OPTIONAL" (PROB <>) "AUX" N X (ROBBED? <>))
	 <SET X <FIRST? .WHAT>>
	 <REPEAT ()
		 <COND (<NOT .X> <RETURN .ROBBED?>)>
		 <SET N <NEXT? .X>>
		 <COND (<AND <NOT <FSET? .X ,INVISIBLE>>
			     <NOT <FSET? .X ,SACREDBIT>>
			     <G? <GETP .X ,P?TVALUE> 0>
			     <OR <NOT .PROB> <PROB .PROB>>>
			<MOVE .X .THIEF>
			<FSET .X ,TOUCHBIT>
			<COND (<==? .THIEF ,THIEF> <FSET .X ,INVISIBLE>)>
			<SET ROBBED? T>)>
		 <SET X .N>>>