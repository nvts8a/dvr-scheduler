#!/usr/bin/perl
package Dvr::Scheduler;
use strict;
use warnings;

use Dvr::Database;
use Dvr::Validator;

# Takes in a date, timespan, and channel, Validates the data and enters it into the database
sub set_new_recording {
	my ($datetime, $timespan, $channel) = @_;
	my %response = ();

	if( !Dvr::Validator::valid_channel( $channel ) ) {
		$response{'status'} = 400;
		$response{'error'} = 'invalid_channel'; 
	}
	elsif( !Dvr::Validator::valid_datetime( $datetime ) ) {
		$response{'status'} = 400;
		$response{'error'} = 'invalid_datetime'; 
	}
	elsif( !Dvr::Validator::valid_timespan( $timespan ) ) {
		$response{'status'} = 400;
		$response{'error'} = 'invalid_timespan'; 
	}

	my @recording;
	my $test_timespan = $timespan;
	while( $test_timespan >= 0 && scalar @recording == 0 ) {
		@recording = &get_datetime_recordings( &_add_timespan( $datetime, $test_timespan ) );
		$test_timespan -= 15;
	}

	if( scalar @recording > 0 ) {
		$response{'status'} = 400;
		$response{'error'} = 'datetime_taken';
		$response{'recording'} = $recording[0];
	}

	if( !$response{'status'} ) {
		my %recording = (
			channel =>		$channel,
			starttime =>	$datetime,
			endtime =>		&_add_timespan( $datetime, $timespan )
		);

		my %database_entry = Dvr::Database::insert( %recording );

		if( $database_entry{'uuid'} ) {
			$response{'status'} = 200;
			$response{'recording'} = %database_entry;
		}
		else {
			$response{'status'} = 500;
			$response{'error'} = 'internal_server_error';
		}
	}

	return %response;
}

# Gets all of the current recordings
sub get_current_recordings {
	
	return Dvr::Database::select();
}

# Gets all of the recordings by channel
sub get_channel_recordings {
	my ($channel) = @_;

	return Dvr::Database::select( 'channel', $channel );
}

# Gets all of the recordings by a datetime
sub get_datetime_recordings {
	my ($datetime) = @_;

	if( !$datetime ) {
		$datetime = Dvr::Database::_get_current_datetime(); 
	}

	return Dvr::Database::select( 'datetime', $datetime ); 
}

# Deletes a recording using a prodvided UUID
sub delete_recording {
	my ($uuid) = @_;

	return Dvr::Database::delete( $uuid );
}

# TODO
sub update_recording {
}

# internal method to add a minute value to a provided datatime valiue
# FIXME: Adding timespan will only move to the next month on 31 days, does not support 30,29, or 28 day months
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

	while( $month > 12 ) {
		$month -= 12;
		$additional_year++;
	}

	$year += $additional_year;

	$month = ( $month < 10 ? "0$month" : $month );
	$day = ( $day < 10 ? "0$day" : $day );
	$hour = ( $hour < 10 ? "0$hour" : $hour );
	$min = ( $min < 10 ? "0$min" : $min );

	return "$year-$month-$day $hour:$min:$sec";
}


1;
