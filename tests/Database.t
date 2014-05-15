#!/usr/bin/perl
use strict;
use warnings;

use Test::More qw(no_plan);

#####
# Can access module?
use_ok( 'Dvr::Database' );

my %testdata = (
	channel => '123',
	starttime => '9999-12-31 23:59:59',
	endtime => '9999-12-31 23:59:59',
);

Dvr::Database::insert( %testdata );
Dvr::Database::delete( 'LZLmyXliO' );
