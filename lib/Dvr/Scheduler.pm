#!/usr/bin/perl
package Dvr::Scheduler;
use strict;
use warnings;

use Dvr::Database;
use Dvr::Validator;

sub set_new_recording {

}

sub _add_timespan {
	my ($datetime, $timespan) = @_;

	my ($date, $time) = split( ' ', $datetime );	
	my ($year, $month, $day) = split( '-', $date );
	my ($hour, $min, $sec) = split( ':', $time );

	my $additional_min = $timespan;
	my $additional_hour = 0;
	my $additional_day = 0;
	my $additional_month = 0;
	my $additional_year = 0;

	$min += $additional_min;

	while( $min >= 60 ) {
		$min -= 60;
		$additional_hour++;
	}

	$hour += $additional_hour;

	while( $hour >= 24 ) {
		$hour -= 24;
		$additional_day++;
	}

	$day += $additional_day;

	while( $day > 31 ) {
		$day -= 31;
		$additional_month++;
	}
	
	$month += $additional_month;

	while( $day > 12 ) {
		$day -= 12;
		$additional_year++;
	}

	$year += $additional_year;

	$month = ( $month < 10 ? "0$month" : $month );
	$day = ( $day < 10 ? "0$day" : $day );
	$hour = ( $hour < 10 ? "0$hour" : $hour );
	$min = ( $min < 10 ? "0$min" : $min );

	return "$year-$month-$day $hour:$min:$sec";
}

sub get_current_recordings {
}

sub get_channel_recordings {
}

sub delete_recording {
}

sub update_recording {
}

1;
