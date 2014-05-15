#!/usr/bin/perl
use strict;
use warnings;

use Test::More qw(no_plan);

#####
# Can access module?
use_ok( 'Dvr::Database' );

my %testdata = (
	channel => '123',
	starttime => '2001-01-01 00:00:00',
	endtime => '2001-12-31 23:59:59',
);

# Insert test data
my %inserted_data = Dvr::Database::insert( %testdata );

# Select inserted test data
my @select_by_uuid = Dvr::Database::select( 'uuid', $inserted_data{'uuid'} );
diag( @select_by_uuid );

my @select_by_datetime = Dvr::Database::select( 'datetime', '2001-06-31 23:59:59' );
diag( @select_by_datetime );

#Dvr::Database::delete( $inserted_data{'uuid'} );
