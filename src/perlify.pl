#!/usr/bin/env perl

use strict;


my $debug=1;

my $cipherStrB=`cat cipherStringB.txt`;
chomp $cipherStrB;

my @files=`find . -name "*.tex" -a \! -name "*_generated.tex" -print`;
my $f;

foreach  $f ( @files)  {
	chomp $f;
	$f =~ /(.*)\.tex/;
	my $ftex = "$1_generated.tex";

	my $rc=` grep -q "\@\@\@CIPHERSTRINGB\@\@\@" $f`;
	if ($rc == 0) {

		print "file = $f\n" if $debug;
		print "ftex = $ftex\n" if $debug;

		open(FH,    "<", $f ) or die "could not open file $f: $!";
		open(FHOUT, ">", $ftex ) or die "could not open file $ftex: $!";
		
		while (<FH>) {
			$_ =~ s/\@\@\@CIPHERSTRINGB\@\@\@/$cipherStrB/g;
			print FHOUT $_;
		}
	}
	else {
		print "skipping file $f\n" if $debug;
	}
}
