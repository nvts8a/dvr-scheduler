#!/usr/bin/perl
package Dvr::Database;
use strict;
use warnings;

use Data::Uniqid;
use constant DATAFILE => 'data/recordings.csv';
use constant COLUMNS => 'uuid,timestamp,channel,starttime,endtime';

# Can select data in a where-key-equals-data fasion, supports proprietary look-up by uuid and datetime
sub select {
	my ($key, $data) = @_;
	my @columns = split( ',', COLUMNS );
	my @results;

	if( lc( $key ) eq 'uuid' ) {
		@results = &_select_by_uuid( $data );
	}
	elsif( lc( $key ) eq 'datetime' ) {
		@results = &_select_by_datetime( $data );
	}
	elsif( lc( $key ) eq 'channel' ) {
		@results = &_select_by_channel( $data );
	}

	return @results;
}

# internal method to look-up by uuid
sub _select_by_uuid {
	my ($uuid) = @_;
	my @database = &_get_database(); 
	my @results;

	foreach my $row ( @database ) {
		my @current_row = split( ',', $row );
		
		if( $current_row[0] eq $uuid ) {
			push( @results, $row );
		}
	}

	return @results;
}

# internal method to look-up by channel
sub _select_by_channel {
	my ($channel) = @_;
	my @database = &_get_database(); 
	my @results;

	foreach my $row ( @database ) {
		my @current_row = split( ',', $row );
		
		if( $current_row[2] eq $channel ) {
			push( @results, $row );
		}
	}

	return @results;
}

# internal method to look-up by datetime
sub _select_by_datetime {
	my ($datetime) = @_;
	my @database = &_get_database(); 
	my @results;
	
	$datetime = &_reduce_timestamp( $datetime );
	foreach my $row ( @database ) {
		my @current_row = split( ',', $row );
		
		my $starttime = &_reduce_timestamp( $current_row[3] );
		my $endtime = &_reduce_timestamp( $current_row[4] );

		if( $datetime >= $starttime && $datetime < $endtime ) {
			push( @results, $row );
		}
	}

	return @results;
}

sub _reduce_timestamp {
	my ($timestamp) = @_;
	$timestamp =~ s/[\:\- ]//g;

	return $timestamp;
}

# Takes in a UUID and does not push that row to be written to disk if it exists
sub delete {
	my ($uuid) = @_;
	my $deleted_data = 0;

	my @old_data = &_get_database(); 
	my @new_data;


	foreach my $row ( @old_data ) {
		my @current_row = split( ',', $row );
		if( $current_row[0] ne $uuid ) {
			push( @new_data, $row );
		}
		else {
			$deleted_data = 1;
		}
	}

	&_set_database( @new_data );	
	
	return $deleted_data;
}

# Simply pushes a string onto an array of strings to be written to disk
sub insert {
	my (%data) = @_;
	my @columns = split( ',', COLUMNS );

	$data{'uuid'} = Data::Uniqid->suniqid;
	$data{'timestamp'} = &_get_current_datetime(); 

	my $row;
	foreach my $column (@columns) {
		$row = $row . $data{$column} . ',';
	}

	my @database = &_get_database(); 
	push( @database, $row . "\n" );
	&_set_database( @database );

	return %data;
}



# Internal method used only to open and get the contents of a provided data file
sub _get_database {

	open DATABASE, "<", DATAFILE or die $!;
	my @data = <DATABASE>;
	close DATABASE;

	return @data;
}

# Internal method used only to write data to a database
sub _set_database {
	my (@data) = @_;

	open DATABASE, ">", DATAFILE or $!; 
	
	foreach my $row (@data) {
		print DATABASE $row;
	}

	close DATABASE;

	return 1;
}

# Creates a much nicer timestamp from Perl localtime
sub _get_current_datetime {
	my $datetime = do {
    	my ($s,$m,$h,$D,$M,$Y) = localtime();
    	$Y += 1900;
    	$M++;

		$M = ( $M < 10 ? "0$M" : $M );
		$D = ( $D < 10 ? "0$D" : $D );
		$h = ( $h < 10 ? "0$h" : $h );
		$m = ( $m < 10 ? "0$m" : $m );
		$s = ( $s < 10 ? "0$s" : $s );
			
		"$Y-$M-$D $h:$m:$s" 
	};

	return $datetime;
}

1;
