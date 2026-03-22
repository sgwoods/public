#!/usr/local/bin/perl
# Set STDOUT to autoflush
$| = 1;
push(@INC, "~sgwoods/Caeti/cgi-bin");
require("lib/cgi-lib.pl");

#
# CAETI DEMO VERSION MAY 30/97 - skip execution, give output page directly
#

# invoked by GifMerge/DemoGif/caeti-demo-alex.html

#
# This cgi script is intended as a testing bridge between the test-demo.html
#  file (which invokes it) and the lisp-based planner which it calls.  
# In addition,
# this script should create the appropriate gif file via GifMerge (for now),
# and the format the appropriate return screen.  This return screen is dummy
# quality for the time being and is output-only.
#

# Script Execution Steps
# 1. read in form fields to variables
# 2. generate demo.lisp lisp invokation file including run parameters
# 3. invoke lisp with demo.lisp startup file
#     ... lisp generates output files required ...
#     - gifmerge control file
#     - initial reqs file
#     - post-plan, pre-csp spec file
#     - post-csp spec file
#
# 4. execute gifmerge control file to generate Gif89 scenario on image
# 5. format and display output screen, including pointers to lisp-gen'd
#    information about the plan in question
#

$datefile = "./WriteHere/date.now"; 
@args = ("./date_test_local > $datefile");                      
$dateresult = system(@args);
if ( $dateresult == 0 ){
    &ReadParse(*input);
    open (IN,"<$datefile") or die "Can't open input $datefile: $!\n";
    sysread(IN, $buf, 8192);
    close IN;
}

print &PrintHeader;
print <<"EOT";
<!--
 This inclusion is from GifMerge/demo-plan.html

 This document encapsuated the demo output generated automatically from
 run-demo.cgi.  Note this version is optimized for the CAETI June/97 Demo
-->
<!--
  <META HTTP-EQUIV="refresh" content=30>  
-->
<HEAD>
<TITLE>UH/SGP - Live System Demonstration Output</TITLE>
</HEAD>
<BODY bgcolor="#ffffff">
<IMG SRC=http://spectra.eng.hawaii.edu/~alex/Images/Darpa.gif
     WIDTH=118 HEIGHT=70 ALIGN=RIGHT>
<IMG SRC=http://spectra.eng.hawaii.edu/~alex/Images/CaetiProject.gif
     WIDTH=72 HEIGHT=72>
<BR CLEAR=ALL>
<BLOCKQUOTE>
<H1 ALIGN=CENTER><FONT COLOR="0000FF">Generated Scenario Specification
</FONT></H1>
<H3 ALIGN=CENTER><FONT COLOR="0000FF">Run Date = $buf
</FONT></H3>
</BLOCKQUOTE> 
<B>Jump To:</B> [<A HREF=http://spectra.eng.hawaii.edu/~sgwoods/GifMerge/DemoGif/caeti-demo-alex.html>Previous Page</A>]  
<BR>
<HR SIZE=3 NOSHADE WIDTH=100%>
<P>
<B>Scenario Info:</B> [<A HREF=http://spectra.eng.hawaii.edu/~sgwoods/GifMerge/DemoGif/sc-demo.html>Requirements 1/2</A> |
		 <A HREF=http://spectra.eng.hawaii.edu/~sgwoods/GifMerge/DemoGif/sc-info.html>Requirements 2/2</A> |  
                 <A HREF=http://spectra.eng.hawaii.edu/~sgwoods/GifMerge/DemoGif/sc-req.html>Pre-Terrain Spec</A> |
                 <A HREF=http://spectra.eng.hawaii.edu/~sgwoods/GifMerge/DemoGif/sc-spec.html>Terrain Spec</A> ]
<BR>
<HR SIZE=3 NOSHADE WIDTH=100%>
<P>
<CENTER>
<!-- clickable version of the battle map -->
<a href="http://spectra.eng.hawaii.edu/~sgwoods/GifMerge/DemoGif/demo-map-1.map"><img src="http://spectra.eng.hawaii.edu/~sgwoods/GifMerge/DemoGif/demo-map-1.gif" WIDTH=675 HEIGHT=840 ISMAP></a>
<!--
<IMG SRC=http://spectra.eng.hawaii.edu/~sgwoods/GifMerge/DemoGif/demo-map-1.gif WIDTH=675 HEIGHT=840>
-->
<!-- repeating version - selectable below though
<IMG SRC=http://spectra.eng.hawaii.edu/~sgwoods/GifMerge/DemoGif/demo-map-lp.gif WIDTH=656 HEIGHT=816>
-->
</CENTER>
<P> <HR SIZE=3 NOSHADE><P>
<CENTER>
<B>Continuous Scenario Play:</B> [<A HREF=http://spectra.eng.hawaii.edu/~sgwoods/GifMerge/DemoGif/demo-map-lp.gif>Click Here</A>]
</CENTER>
<P> <HR SIZE=3 NOSHADE>
[<A HREF=http://spectra.eng.hawaii.edu/~alex/Research/Projects/CAETI/>UH/SGP Home Page</A> |
 <A HREF=http://spectra.eng.hawaii.edu/~alex/Research/Projects/CAETI/Overview/>UH/SGP Overview Page</A>]
</BODY>
EOT
