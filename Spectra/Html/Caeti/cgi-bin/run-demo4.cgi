#!/usr/local/bin/perl
# Set STDOUT to autoflush
$| = 1;

#
# This cgi script is intended as a testing bridge between the test-demo.html
#  file (which invokes it) and the lisp-based planner which it calls.  In addition
# this script should create the appropriate gif file via GifMerge (for now),
# and the format the appropriate return screen.  This return screen is dummy
# quality for the time being and is output-only.
#

# push directory onto the stack INC
push(@INC, "~sgwoods/Caeti/cgi-bin");

# load standard library cgi-lib.pl
require("lib/cgi-lib.pl");

$demo_lisp_func = "DemoDir/demo.lisp"; 
@fields = ('theStartForm',
			'theStartCoords',
			'theEndCoords',
			'MinDuration',
			'MaxDuration',
			'one-leg?',
			'Leg1Tform',
			'Leg1TravT',
			'Leg1BDrill',
			'Leg1StopForm',
			'two-legs?',
			'Leg2Tform',
			'Leg2TravT',
			'Leg2BDrill', 
			'Leg2StopForm',
			'three-legs?',
			'Leg3Tform',
			'Leg3TravT',
			'Leg3BDrill',
			'Leg3StopForm'
	);

&ReadParse(*demo_data);

print &PrintHeader;

print &HtmlTop("Demo 2");

open(TMP_LISP_EXE, ">$demo_lisp_func")
       || die "Couldn't open $demo_lisp_func: $!\n";

print "<ul>" . "\n";

print TMP_LISP_EXE &LoadFunctions;
print TMP_LISP_EXE &DemoFuncBgn;         ## actually call to caeti demo here
 
	foreach $field (@fields) {
		$temp = $demo_data{$field}; 
		if( $temp ) {
			print "<li> $field: <em>$temp</em>";
			print TMP_LISP_EXE ":" . $field . " " . "\"". $temp . "\"". "\n";
		} 
	}

print TMP_LISP_EXE &DemoFuncEnd;

print "<\ul>" . "\n";

print &HtmlBot;

close TMP_LISP_EXE;

#; ---------------------------------------------------------------------------
#; ---------------------------------------------------------------------------

print "<ul>" . "\n";
print "<li>------------------------------------------------------"; 
print "<li>Starting Lisp Execution ..."; 
use Cwd;  $dir="";  $okcd="";
$dir = cwd(); print "<li> Initial working directory = $dir"; 
chdir 'Abtweak96' or die "Abtweak96 directory not found: $!\n";
$dir = cwd(); print "<li> Current working directory = $dir"; 
@args = ("./cl-copy < ../DemoDir/demo.lisp > ../DemoDir/demo.msgs");    
print "<li>Args  = @args"; 
print "<li>More: Lisp to standard output ..."; 

$reslt = system(@args); 
print "<li>System call return value = $reslt";
if ( $reslt == 0 ) 
{
    print "<li>status = sys call success";		
}
else
{				
    print "<li>status = sys call failure";		
};			

print "<li>------------------------------------------------------"; 
print "<\ul>" . "\n";



#; ---------------------------------------------------------------------------
#; ---------------------------------------------------------------------------

sub LoadFunctions  
{
return <<END_OF_TEXT;
(load "forms-to-planner-utils.fasl")
(load "forms-to-planner.fasl")
(load-planner)
END_OF_TEXT
}

sub DemoFuncBgn
{
  return "(demo " . "\n";

} 

sub DemoFuncEnd
{
  return ")" . "\n" . ":exit";
}

sub BatchDemo 
{
  return <<END_OF_TEXT;
#!/bin/csh
cd /users/yjzhang/thesis/CSP/qcsp-alex/
 
nice time /extra/acl4.2/bin/cl <\
        /users/yjzhang/thesis/CSP/qcsp-alex/MyBatch/batch-0.lisp >\
        /users/yjzhang/thesis/CSP/qcsp-alex/testdata/Results/Inter/0.msg
END_OF_TEXT
}  
