#!/usr/bin/perl
package Dvr::Database;
use strict;
use warnings;

use Data::Uniqid;
use constant DATAFILE => 'data/recordings.csv';
use constant COLUMNS => 'uuid,timestamp,channel,starttime,endtime';

sub select {
	my (%data) = @_;
	my @columns = split( ',', COLUMNS );

	return 1;
}

# Takes in a UUID and does not push that row to be written to disk if it exists
sub delete {
	my ($uuid) = @_;

	my @old_data = &_get_database(); 
	my @new_data;

	foreach my $row ( @old_data ) {
		my @current_row = split( ',', $row );
		if( $current_row[0] ne $uuid ) {
			push( @new_data, $row );
		}
	}

	&_set_database( @new_data );	
	
	return 1;
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

	return 1;
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
