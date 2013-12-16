#!/usr/bin/perl -w
use strict;

# parse RFC-style DH params into two parameters for gen_pkcs3's
# command line

my ($p,$g) = ('',undef);
while(<>) {
  chomp;
  if(/^\s*((?:[\da-f]{8}\s*)+)\s*$/i) {
    $p .= "$1";
  }
  if(/The generator is:\s+(\d+)/) {
    $g = $1;
  }
}

$p =~ s/\s+//g;

printf "%s %d\n", $p, $g;
