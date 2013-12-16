#!/usr/bin/env perl

use strict;
use File::Basename;

my $debug=1;
my @exclude=('DH.tex', 'ECC.tex', 'LATER.tex', 'PKIs.tex', 'RNGs.tex', 'abstract.tex', 'acknowledgements.tex', 'applied-crypto-hardening.tex', 'bib.tex', 'cipher_suites.tex', 'disclaimer.tex', 'further_research.tex', 'howtoread.tex', 'keylengths.tex', 'links.tex', 'methods.tex', 'motivation.tex', 'practical_settings.tex', 'reviewers.tex', 'scope.tex', 'ssllibs.tex', 'suggested_reading.tex', 'template.tex', 'tools.tex');

my $cipherStrB=`cat cipherStringB.txt`;
chomp $cipherStrB;

my @files=`find . -name "*.tex" -a \! -name "*_generated.tex" -print`;
my $f;

foreach  $f ( @files)  {
	chomp $f;
	$f =~ /(.*)\.tex/;
	my $fbasename = basename($f);
	my $ftex = "$1_generated.tex";

	system("grep", "-q", "\@\@\@CIPHERSTRINGB\@\@\@" , $f);
	if ($? eq 0 ) { #and not (/$fbasename/ ~~ @exclude)) {

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
