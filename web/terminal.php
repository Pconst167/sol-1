<html>
<title>Sol-1 74 Series Logic Homebrew CPU - 2.5MHz</title>
	
<head>
<meta name="keywords" content="homebrew cpu,homebuilt cpu,ttl,alu,homebuilt computer,homebrew computer,74181,Sol-1, Sol, electronics, hardware, engineering, programming, assembly, cpu, logic">
<link rel="icon" href="http://sol-1.org/images/2.jpg">	

<style>
        body {
            margin: 0;
            padding: 0;
            background-image: url('images/bg/retro-sci-fi-background-futuristic-grid-landscape-of-the-80s-digital-cyber-surface-suitable-for-design-in-the-style-of-the-1980s-free-video.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            height: 100vh; /* Viewport height */
	    background-color: black;
	   color:white;
        }

        html {
            height: 100%;
        }
    </style>
</head>

<body>

<?php include("menu.php"); ?>

<h3><span id="headerSubTitle">Access the live terminal via Telnet</span></h3>

<table>
<tr>
<td>
<pre>
Sol-1's environment is freely accessible online. All you have to do is Telnet to it. When you do, you will
be presented with a live shell environment, directly conencted to Sol-1 via a serial port.
It is running a Unix-like homebrew operating system that I am writing from scratch, so for now it is all
very simple, and only a few Unix commands are available. You can use the terminal below to access the system.

This online telnet client is a bit buggy and was not written by me, so if it displays some weird stuff at login
please ignore it. Alternatively you can connect directly via your local console (telnet sol-1.org 51515), or using something like PuTTY.

The address is sol-1.org at port 51515.
Click 'Connect' below to visit the system.

<iframe width="1500" height="800" src="https://youfiles.herokuapp.com/telnetclient/"></iframe>
</pre>

<!--
<div id="fTelnetContainer" class="fTelnetContainer"></div>
<script>document.write('<script src="//embed-v2.ftelnet.ca/js/ftelnet-loader.norip.noxfer.js?v=' + (new Date()).getTime() + '"><\/script>');</script>
<script>
    var Options = new fTelnetOptions();
    Options.BareLFtoCRLF = true;
    Options.BitsPerSecond = 38400;
    Options.ConnectionType = 'telnet';
    Options.Emulation = 'ansi-bbs';
    Options.Enter = '\n';
    Options.Font = 'CP437';
    Options.ForceWss = false;
    Options.Hostname = 'sol-1.org';
    Options.LocalEcho = false;
    Options.NegotiateLocalEcho = false;
    Options.Port = 51515;
    Options.ProxyHostname = 'proxy-nl.ftelnet.ca';
    Options.ProxyPort = 80;
    Options.ProxyPortSecure = 443;
    Options.ScreenColumns = 80;
    Options.ScreenRows = 24;
    Options.SendLocation = false;
    var fTelnet = new fTelnetClient('fTelnetContainer', Options);
 </script>
 -->

</td>
</tr>
</table>



</body>
</html>

