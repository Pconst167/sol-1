<html>
<title>Sol-1 74 Series Logic Homebrew CPU - 2.5MHz</title>
	
<head>
<meta name="keywords" content="homebrew cpu,homebuilt cpu,ttl,alu,homebuilt computer,homebrew computer,74181,Sol-1, Sol, electronics, hardware, engineering, programming, assembly, cpu, logic">

<link rel="icon" href="http://sol-1.org/images/2.jpg">	

</head>

<body>

<?php include("menu.php"); ?>

<h3><span id="headerSubTitle">docs</span></h3>

<table>
<tr>
<td>
<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);

	$directory = "sol-1/software";
	

	  if ($opendirectory = opendir($directory)){
	    while (($file = readdir($opendirectory)) != false){
	   	if($file != "." && $file != "..")
		    echo "<a href=\"${directory}/{$file}\">" . $file . "</a></br>"; 
	    }
	    closedir($opendirectory);
	  }

?>

</td>

</tr>
</table>



</body>
</html>

