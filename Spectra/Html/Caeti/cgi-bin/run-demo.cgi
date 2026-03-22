#!/usr/local/bin/perl
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

print &HtmlTop("Demo");

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

@args = ("demo-batch"); 
if ( system(@args)  != 0 ) 
#; acl < ../DemoDir/demo.lisp") != 0 )
{
    print "<li>failed";
};

print "<li>Finished"; 
print "<\ul>" . "\n";

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
