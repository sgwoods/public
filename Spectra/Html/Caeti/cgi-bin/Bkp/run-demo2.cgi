#!/usr/local/bin/perl
# Set STDOUT to autoflush
$| = 1;

push(@INC, "~sgwoods/Caeti/cgi-bin");
require("lib/cgi-lib.pl");

$demo_lisp_func = "DemoDir/demo.lisp"; 
@fields = ('theStartForm',
			'theStartCoords',
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
			'Leg3StopForm',
			'theEndForm',  
			'theEndCoords'
	);

&ReadParse(*demo_data);

print &PrintHeader;

print &HtmlTop("Demo 2");

open(TMP_LISP_EXE, ">$demo_lisp_func")
       || die "Couldn't open $demo_lisp_func: $!\n";

print "<ul>" . "\n";

print TMP_LISP_EXE &LoadFunctions;
print TMP_LISP_EXE &DemoFuncBgn;  
 
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

print "<li>Starting 1 ..."; 
#; @args = ("/bin/csh demo-batch");  # ise
#; @args = ("./demo-batch");         # ise
@args = ("demo-batch");              # fails to run  ??
print "<li>Args  = @args";
$reslt = system(@args);
print "<li>reslt = $reslt";
if ( $reslt == 0 ) 
{
    print "<li>status = ok,start";		
    print "<li>status = ok, end";		
}
else
{				
    print "<li>status = failed";		
};				
print "<li>Finished 1"; 

print "<li>------------------------------------------------------"; 
print "<li>Starting 2 ..."; 
$datefile = "./WriteHere/date.now"; 
#; @args = ("/bin/date > $datefile");                               # ok
#; @args = ("/users2/other/sgwoods/bin/date_test > $datefile");     # fail
#; @args = ("./date_test_soft > $datefile");                        # fail
   @args = ("./date_test_local > $datefile");                       # ok
print "<li>Args  = @args"; $reslt = system(@args); print "<li>reslt = $reslt";
if ( $reslt == 0 ) 
{
    print "<li>status = ok, start";		
    &ReadParse(*input);
    open (IN,"<$datefile") or die "Can't open input $datefile: $!\n";
    sysread(IN, $buf, 8192);
    close IN;
    print "<li> date read is = $buf";
    print "<li>status = ok, end";		
}
else
{				
    print "<li>status = failed";		
};			
print "<li>Finished 2"; 

print "<li>------------------------------------------------------"; 
print "<li>Starting 3 ..."; 
use Cwd;  $dir="";  $okcd="";
$dir = cwd(); print "<li> Initial working directory = $dir"; 
chdir 'Abtweak96' or die "Abtweak96 directory not found: $!\n";
$dir = cwd(); print "<li> Current working directory = $dir"; 
@args = ("./cl-copy < ../DemoDir/demo.lisp");    
print "<li>Args  = @args\n"; 

# redefine standard out
# open(SAVEOUT,">&STDOUT") or die "Cannot redirect std out pt1: $!\n ";
# open(STDOUT,">./WriteHere/std.out") or die "Cannot redirect std out pt2: $!\n";
# select STDOUT; $| = 1;
# print STDOUT "stdout 1\n";

$reslt = system(@args); 
print "<li>reslt = $reslt";
if ( $reslt == 0 ) 
{
    print "<li>status = ok,start";		
    print "<li>status = ok, end";		
}
else
{				
    print "<li>status = failed";		
};			
# close STDOUT;	
print "<li>Finished 3"; 
print "<\ul>" . "\n";

#; ---------------------------------------------------------------------------
#; ---------------------------------------------------------------------------

sub LoadFunctions  
{
return <<END_OF_TEXT;
(load "init.lsp")
(load "yj-test.lsp") 
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
