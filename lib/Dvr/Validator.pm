#!/usr/bin/perl
package Dvr::Validator;
use strict;
use warnings;

# Validates a inout channel. DVR expects a certain format, will return 1 if format is valid or 0 if it is not
sub valid_channel {
	my ($channel) = @_;
	my $is_valid = 0;

	if( $channel ) {
		if( $channel =~ m/^[0-9]{1,3}$|^[0-9]{1,3}[\-\.][0-9]{1,2}$/ ) {
			$is_valid = 1;
		}
	}

	return $is_valid;
}

# Validates a timespan value, DVR expects a timespan to be greater than 0 and divisable by 15
sub valid_timespan {
	my ($timespan) = @_;
	my $is_valid = 0;
	
	if( $timespan ) {
		if( $timespan > 0 ) {
			my $remainder = $timespan % 15;

			if( $remainder == 0 ) {
				$is_valid = 1;
			}
		}
	}

	return $is_valid;
}

# Validates a datetime format, DVR expects a MySQL datetime fromat. Will return 1 on valid, 0 on invalid.
sub valid_datetime {
	my ($datetime) = @_;
	my $date_valid = 0;
	my $time_valid = 0;

	if( $datetime ) {
		my ($date, $time) = split( ' ', $datetime );	
		$date_valid = &_valid_date( $date );
		$time_valid = &_valid_time( $time );
	}

	return $date_valid && $time_valid;
}

# internal code used to clean up methods and make them more readable, not tested or used on its own
sub _valid_date {
	my ($date) = @_;
	my $is_valid = 0; 
	
	if( $date ) {
		my ($year, $month, $day) = split( '-', $date );
		
		if( $year =~ m/^[1-9][0-9]{3}$/ ) {
			if( $month =~ m/^[0][1-9]$|^[1][0-2]$/ ) {
				if( $day =~ m/^[0-2][0-9]$|^[3][01]$/ ) {
					# TODO: add month max day validation
					$is_valid = 1;
				}
			}
		}
	}	

	return $is_valid;
}

# internal code used to clean up methods and make them more readable, not tested or used on its own
sub _valid_time {
	my ($time) = @_;
	my $is_valid = 0;

	if( $time ) {
		my ($hour, $min, $sec) = split( ':', $time );
	
		if( $hour =~ m/^[01][0-9]$|^[2][0-3]$/ ) {
			if( $min =~ m/^[0-5][0-9]$/ ) {
				if( $sec =~ m/^[0-5][0-9]$/ ) {
					$is_valid = 1;
				}
			}
		}
	}

	return $is_valid;
}

1;
