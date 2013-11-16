#!/usr/bin/perl -w
use strict;
use autodie qw(:all);
use File::Temp qw(tempdir);

##############################################################################
#
# take care -- this thing is fragile. That is, the emulator environment is
# fragile.
#
# run all available versions of android in the emulator, open an HTTPS
# URL in the system browser, and sniff the browser's cipher list
#
# make sure no other android devices/emulators are connected while running
# this script!
#
# since the "android" command cannot reliably generate AVDs, you need to
# generate those AVDs yourself, and name them "asc<apilevel>", e.g. "asc13".
#
#
# prerequisites:
# - an android SDK/emulator setup on a linux machine, with "android",
#   "adb" and "emulator" in the $PATH
# - all the system images for the versions you want to run
# - sniff-client-ciphers from ../sniff-client-ciphers
#
# cm@coretec.at 20131116
#
##############################################################################

my $usage = "usage: $0 pcap-output-dir apilevel\n";

my $outputdir = shift || die $usage;
my $apilevel = shift || die $usage;

# versions indexed by API level
# source: http://developer.android.com/guide/topics/manifest/uses-sdk-element.html#ApiLevels
my %androidversion = ( 2 => '1.1',
		       3 => '1.5',
		       4 => '1.6',
		       5 => '2.0',
		       6 => '2.0.1',
		       7 => '2.1',
		       8 => '2.2',
		       9 => '2.3-2.3.2',
		       10 => '2.3.3-2.3.7',
		       11 => '3.0',
		       12 => '3.1',
		       13 => '3.2',
		       14 => '4.0-4.0.2',
		       15 => '4.0.3-4.0.4',
		       16 => '4.1',
		       17 => '4.2',
		       18 => '4.3',
		       19 => '4.4',
		     );

my $tmpdir = tempdir(CLEANUP => 1);
print "Base dir: $tmpdir\n";

run_one_apilevel($apilevel);

sub run_one_apilevel {
  my $apilevel = shift;

#  my $n = create_avd($apilevel);
  my($pid, $pcap) = start_avd($apilevel);
  # wait until the emulator has truly booted...
  print "waiting for boot to complete...\n";
  sleep(60);
  print "starting browser...\n";
  send_intent("-a android.intent.action.VIEW -d https://git.bettercrypto.org");
  sleep(30);
  stop_avd($pid);
#  delete_avd($apilevel);
  print "pcap file for API $apilevel is $pcap\n";
  system("../sniff-client-ciphers/sniff-client-ciphers.pl 'tcp.port==443' $pcap 'Android $androidversion{$apilevel}' > $outputdir/Android_$androidversion{$apilevel}.txt");
}

# send an intent via "am start" command in the emulator.
# parameter is a string to be given as arguments to "am start"
# returns 1 when OK, undef on error
sub send_intent {
  my($intent) = shift;

  my $count = 60;
  while($count--) {
    my @result = `adb shell am start $intent`;
    if(grep /^Error/, @result) {
      print "ERROR\n";
    } else {
      return 1;
    }
    sleep(1);
  }
  return undef;
}

# fork a child and run the emulator
# return the ($emulator_pid, $pcap_filename)
sub start_avd {
  my($apilevel) = shift;

  my $name = "asc$apilevel";
  my $pcapfile = "$outputdir/$name.pcap";
  my($pid) = fork();
  if(!defined $pid) {
    die "start_avd: can't fork: $!\n";
  } elsif($pid) {
    # wait for emulator to be ready...
    print "emulator $name started, waiting for readyness...\n";
    system(qw(adb wait-for-device));
    return ($pid, $pcapfile);
  } else {
    exec(qw(emulator -avd), $name, qw(-no-boot-anim -tcpdump),
	 $pcapfile);
  }
}

sub stop_avd {
  my $pid = shift;
  kill("TERM", $pid);
  print "waiting for $pid to terminate...\n";
  waitpid($pid, 0);
}



#adb shell am start -a android.intent.action.VIEW -d https://www.ssllabs.com/ssltest/viewMyClient.html
# tshark -r /tmp/tls -d tcp.port==4433,ssl -O ssl



sub create_avd {
  my($apilevel) = shift;
  my $name = "asc$apilevel";
  delete_avd($apilevel);
  # "echo" is required because the command asks a question...
  system("echo | android -s create avd --name $name --target $apilevel --path $tmpdir/$name");
  print "created avd $name\n";
  $name;
}

sub delete_avd {
  my($apilevel) = shift;
  my $name = "asc$apilevel";
  ## ignore errors
  eval {
    system(qw(android -s delete avd --name), $name);
  }
}


