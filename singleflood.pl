#!/usr/bin/perl

use strict;

use Config;
use strict;
use Data::Dumper;
use IO::Socket::INET;
my $socket;

my $width = 320;
my $height = 320;

my @datapoints;
my $max_packets = 1234;
my $runs_per_dataset = 1;
my $wait = 0.029;
my $timeout = 0.01;
my $count = 0;

sub new_socket() {
	$socket = new IO::Socket::INET (
		PeerHost => '145.116.223.67',
		PeerPort => '1234',
		Proto => 'tcp',
	);
	if (!$socket) { 
		select(undef,undef,undef, $timeout);
		return 0;
	}	
	return 1;
}	

sub close_socket() {
	if ($socket ) {
		close($socket);
	}	
}	

sub paars() {
	for (my $x = 10; $x < 20; $x++) {
		for (my $y = 170; $y < 180; $y++) {
			my $pixel = "PX $x $y FF00CC\n"; 
			push @datapoints, $pixel;
		}
	}
}	
		
sub geel() {
	for (my $x = 0; $x < 80; $x++) {
		for (my $y = 320; $y < 400; $y++) {
			my $pixel = "PX $x $y ffcc00\n"; 
			push @datapoints, $pixel;
		}
	}
}	
		
sub groen() {
	for (my $x = 240; $x < 320; $x++) {
		for (my $y = 320; $y < 400; $y++) {
			my $pixel = "PX $x $y 00ff33\n"; 
			push @datapoints, $pixel;
		}
	}
}	
		
sub oranje() {
	for (my $x = 240; $x < 320; $x++) {
		for (my $y = 320; $y < 400; $y++) {
			my $pixel = "PX $x $y ff6600\n"; 
			push @datapoints, $pixel;
		}
	}
}	

sub zwart() {
	open (FH, "<zwart.txt") or die();
	while (<FH>) {
		my $pixel = $_;
		if ($pixel =~ /000/) {
			push @datapoints, $pixel;	
		}	
	}	
	close(FH);
}	
	
zwart();

$max_packets = @datapoints * $runs_per_dataset;
new_socket();
while (1) {
	if (($count % $max_packets) == 0) {
		close_socket();
		$count = 0;
		print "\n$max_packets reached, starting new connection\n";
		if (! new_socket()) {
			next;
		}	
	}	

	$socket->send($datapoints[$count]);
	select(undef,undef,undef, $wait); # introduce a slight delay 

	$count++;
}	

close_socket();



