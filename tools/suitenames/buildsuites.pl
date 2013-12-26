#!/usr/bin/perl -w
use strict;
use autodie;
use Text::CSV;
use Template;

my $usage = "usage: $0 template csv-file openssl-file\n";

my $template = shift;
my $iana_csv = shift;
my $openssl_txt = shift;

my $ossl_version;


my $iana = parse_csv($iana_csv);
#print Dumper($iana);
my $ossl = parse_openssl($openssl_txt);
#print Dumper($ossl);

my @merged;
for my $id (sort keys {map { $_ => 1 } (keys %$iana, keys %$ossl)}) {
  push(@merged, [$id, $iana->{$id}, $ossl->{$id}]);
}

my $tt = Template->new();
$tt->process($template, {table => \@merged,
			 openssl_version => $ossl_version,
			 timestamp => scalar localtime time,
			});

sub parse_csv {
  my $fn = shift;

  my $d = {};

  my $csv = Text::CSV->new({binary => 1})
    or die "CSV open error: " . Text::CSV->error_diag();
  open my $fh, "<:encoding(utf8)", $fn or die "$fn: $!";
  while(my $row = $csv->getline($fh)) {
    $row->[1] =~ /^TLS_/ or next;
    $d->{$row->[0]} = $row->[1];
  }
  $d;
}
sub parse_openssl {
  my $fn = shift;

  my $d = {};
  open(F, "<$fn");
  while(<F>) {
    chomp;
    if(/^OpenSSL/) {
      $ossl_version = $_;
      next;
    }
    /^\s*([\da-fx,]+)\s*-\s*(\S+)\s/i || next;
    $d->{$1} = $2;
  }
  close(F);
  $d;
}
