#!/usr/bin/perl -w
use strict;
use autodie;
use Data::Dumper;

##############################################################################
#
# a tool that takes a PCAP file and spits out
# the client ciphers of the first SSL negotiation in there.
#
# prerequisites: tshark (from the wireshark package) must be in the $PATH
#
# tested with tshark v1.8.2
#
##############################################################################

my $usage = "usage: $0 'wireshark filter expression' filename [software]\n";

my $filter = shift || die $usage;
my $filename = shift || die $usage;
my $software = shift || "";

my @output = `tshark -r "$filename" -d tcp.port==1-65535,ssl -O ssl -R "$filter"`;

my $state = 'init';
my %d = ();
for (@output) {
  chomp;

  if($state eq 'init') {
    if(/^\s+SSL Record Layer: Handshake Protocol: Client Hello/) {
      $state = 'parse';
      next;
    }
  }
  if($state eq 'parse') {
    if(/^\w/) {
      $state = 'init';
      dump_info();
      %d = ();
      last;
    }

    if(/^\s*Version: (.*)$/) {
      $d{Version} = $1;
    } elsif(/^\s*Cipher Suite:\s+(.*)$/) {
      push(@{$d{Cipher_Suites}}, $1);
    } elsif(/^\s*Compression Method:\s+(.*)$/) {
      push(@{$d{Compression_Methods}}, $1);
    } elsif(/^\s*Extension: server_name/) {
      push(@{$d{Extensions}}, 'SNI');
    } elsif(/^\s*Elliptic curve:\s+(.*)$/) {
      push(@{$d{Elliptic_Curves}}, $1);
    } elsif(/^\s*Extension: SessionTicket TLS/) {
      push(@{$d{Extensions}}, 'SessionTicket');
    } elsif(/^\s*Extension: next_protocol_negotiation/) {
      push(@{$d{Extensions}}, 'NextProtocolNegotiation');
    }
  }
}

sub dump_info {
  print "Client Software: $software\n\n";
  print "TLS Version: $d{Version}\n\n";
  print "Cipher Suites:\n";
  for my $cs (@{$d{Cipher_Suites}}) {
    printf "  %s\n", $cs;
  }
  print "\n";

  print "Compression Methods:\n";
  for my $co (@{$d{Compression_Methods}}) {
    printf "  %s\n", $co;
  }
  print "\n";

  if(exists $d{Elliptic_Curves}) {
    print "Elliptic Curves:\n";
    for my $ec (@{$d{Elliptic_Curves}}) {
      printf "  %s\n", $ec;
    }
    print "\n";
  }

  print "Extensions:\n";
  for my $ex (@{$d{Extensions}}) {
    printf "  %s\n", $ex;
  }
  print "\n";
}
