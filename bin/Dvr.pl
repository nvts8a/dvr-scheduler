#!/usr/bin/perl
use strict;
use warnings;

use Dvr::Scheduler;

&main();

sub main {
	my $selection = 1;
	
	while( $selection != 0 ) {
		&print_menu();	
		$selection = &make_selection(); 
		&route_selection( $selection );
	}
}


sub print_menu {
	print "--DVR Scheduler--\n";
	print "\n";
	print "Make a selection below:\n";
	print "1) Get entire DVR schedule\n";
	print "2) Get current recording\n";
	print "3) Enter a time and get whats recording then\n";
	print "4) Set a new recording\n";
	print "0) Exit\n";
	print "\n";
}

sub make_selection {
	print "Selection: ";
	my $selection = <>;
	
	while( !&validation_selection( $selection ) ) {
		print "Invalid selection: ";
		$selection = <>;
	}

	return $selection;
}

sub validation_selection {
	my ($selection) = @_;
	my $is_valid = 0;

	if( $selection =~ m/[12340]/ ) {
		$is_valid = 1;
	}

	return $is_valid;
}


sub route_selection {
	my ($selection) = @_;

	if( $selection == 1 ) {
		&print_recordings( Dvr::Scheduler::get_current_recordings() );
	}
	elsif( $selection == 2 ) {
		&print_recordings();
	}
	elsif( $selection == 3 ) {
		&print_recordings();
	}
	elsif( $selection == 4 ) {
	}
}

sub print_recordings {
	my (@recordings) = @_;

	foreach my $recording (@recordings) {
		print "$recording";
	}
}
