<SETG LENTAB <IVECTOR 4 0>>
<SETG TBL <IVECTOR 26 0>>
<SETG LINE <ISTRING 100>>

<DEFINE CNTLIN (C "AUX" STR L)
	<PROG ()
	      <READSTRING ,LINE .C <STRING <ASCII 13>> '<RETURN <>>>
	      <READCHR .C>
	      <READCHR .C>
	      <SET L <REST <MEMQ !\, ,LINE>>>
	      <SET STR <PARSE .L>>
	      <MAPF <>
		    <FUNCTION (CHR "AUX" OFF)
			 <SET OFF <- <ASCII .CHR> 96>>
			 <PUT ,TBL .OFF <+ <NTH ,TBL .OFF> 1>>>
		    .STR>>>

<DEFINE WRDLIN (C "AUX" STR L)
	<PROG ()
	      <READSTRING ,LINE .C <STRING <ASCII 13>> '<RETURN <>>>
	      <READCHR .C>
	      <READCHR .C>
	      <SET L <REST <MEMQ !\, ,LINE>>>
	      <SET STR <PARSE .L>>
	      <SET LEN </ <+ 4
			     <MAPF ,+
				   <FUNCTION (CHR)
					<COND (<MEMQ .CHR ,BAD> 2)
					      (T 1)>>
				   .STR>> 4>>
	      <PUT ,LENTAB .LEN <+ <NTH ,LENTAB .LEN> 1>>>>

<DEFINE WRDFILE (NAM "AUX" C)
	<COND (<SET C <OPEN "READ" .NAM>>
	       <REPEAT ()
		       <COND (<NOT <WRDLIN .C>> <RETURN>)>>
	       <CLOSE .C>)>>

<DEFINE CNTFILE (NAM "AUX" C)
	<COND (<SET C <OPEN "READ" .NAM>>
	       <REPEAT ()
		       <COND (<NOT <CNTLIN .C>> <RETURN>)>>
	       <CLOSE .C>)>>