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

#
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

# 
sub make_selection {
	print "Selection: ";
	my $selection = <>;
	
	while( !&validation_selection( $selection ) ) {
		print "Invalid selection: ";
		$selection = <>;
	}
	
	print "\n";

	return $selection;
}

# Add numbers to regex validation when you add additional selections
sub validation_selection {
	my ($selection) = @_;
	my $is_valid = 0;

	if( $selection =~ m/[12340]/ ) {
		$is_valid = 1;
	}

	return $is_valid;
}

# Router to run method based on selection
sub route_selection {
	my ($selection) = @_;

	if( $selection == 1 ) {
		&print_recordings( Dvr::Scheduler::get_current_recordings() );
	}
	elsif( $selection == 2 ) {
		&print_recordings( Dvr::Scheduler::get_datetime_recordings() );
	}
	elsif( $selection == 3 ) {
		&print_recordings( Dvr::Scheduler::get_datetime_recordings( &enter_datetime() ) );
	}
	elsif( $selection == 4 ) {
		&set_new_recording();
	}
}

# goes through the process of collecting data and making API calls to add a new recording
sub set_new_recording {
	my $proceed = 'Y';
	my $datetime = &enter_datetime();
	my $timespan = &enter_timespan();
	my $channel = &enter_channel();

	my %new_recording = Dvr::Scheduler::set_new_recording( $datetime, $timespan, $channel ); 
	
	while( $new_recording{'status'} ne '200' && $proceed eq 'Y' ) {
		
		if( $new_recording{'error'} eq 'datetime_taken' ) {
			# TODO: This could be in it's own sub, to increae readablity, testablity
			print "Recording already happening at this time: $new_recording{'recording'}\n";
			print "Would you like to replace this record? Y/N: ";
			my $replace = uc( substr( <>, 0, 1 ) );

			if( $replace eq 'Y' ) {
				my @old_recording = split( ',', $new_recording{'recording'} );
				my $old_recording_uuid = $old_recording[0];

				Dvr::Scheduler::delete_recording( $old_recording_uuid );
				%new_recording = Dvr::Scheduler::set_new_recording( $datetime, $timespan, $channel );	
			}
			else {
				$proceed = 'N';	
			}
		}
		else {
			# TODO: This could be in it's own sub, to increae readablity, testablity
			print "Setting the recording failed: $new_recording{'error'}\n";
			print "Would you like to try again? Y/N: ";
			$proceed = uc( substr( <>, 0, 1 ) );

			if( $proceed eq 'Y' ) {
				$datetime = &enter_datetime();
				$timespan = &enter_timespan();
				$channel = &enter_channel();

				%new_recording = Dvr::Scheduler::set_new_recording( $datetime, $timespan, $channel ); 	
			}
		}
	}

	return %new_recording;
}

# Reusuable sub for printing and array of recordings
sub print_recordings {
	my (@recordings) = @_;
	
	if( scalar @recordings > 0 ) {
		print "-- UUID, Added At, Channel, Start Time, End Time --\n";
	}
	else {
		print "No recordings found.\n\n";
	}

	foreach my $recording (@recordings) {
		print "$recording";
	}

	print "\n";
}

#####
# Little subs with copy prints and input to increae code readability 
sub enter_datetime {
	print "Please enter a date and time in this format: YYYY-MM-DD hh:mm:ss\n";
	print "Date and time: ";

	my $datetime = <>;
	print "\n";

	return $datetime;
}

sub enter_timespan {
	print "Please enter a span of time in minutes and in increments of 15\n";
	print "Timespan: ";

	my $timespan = <>;
	print "\n";

	return $timespan;
}

sub enter_channel {
	print "Please enter a channel, accetpable formats are values 1-999 as well subchannels .1-99 or -1-99 (123.45 or 123-45)\n";
	print "Channel: ";

	my $channel = <>;
	print "\n";

	return $channel;
}

