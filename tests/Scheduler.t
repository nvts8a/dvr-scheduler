#!/usr/bin/perl
use strict;
use warnings;

use Test::More qw(no_plan);

#####
# Can access module?
use_ok( 'Dvr::Scheduler' );


#####
# Tests for _add_timespan internal function
is( Dvr::Scheduler::_add_timespan( '2014-05-15 15:33:46', 60 ), '2014-05-15 16:33:46', "Valid: add 60 minutes - same day" );
is( Dvr::Scheduler::_add_timespan( '2014-05-15 23:33:46', 60 ), '2014-05-16 00:33:46', "Valid: add 60 minutes - new day" );
is( Dvr::Scheduler::_add_timespan( '2014-05-31 23:33:46', 60 ), '2014-06-01 00:33:46', "Valid: add 60 minutes - new month" );
is( Dvr::Scheduler::_add_timespan( '2014-02-28 23:33:46', 60 ), '2014-03-01 00:33:46', "Valid: add 60 minutes - new month" );
is( Dvr::Scheduler::_add_timespan( '2014-12-31 23:33:46', 60 ), '2015-01-01 00:33:46', "Valid: add 60 minutes - new year" );
is( Dvr::Scheduler::_add_timespan( '2014-05-15 15:33:46', 30 ), '2014-05-15 16:03:46', "Valid: add 30 minutes" );
is( Dvr::Scheduler::_add_timespan( '2014-05-15 15:33:46', 15 ), '2014-05-15 15:48:46', "Valid: add 15 minutes" );

#####
# Tests for set_new_recording
my %test_recording = Dvr::Scheduler::set_new_recording( '2014-05-30 20:00:00', 30, '432' );
is( $test_recording{'status'}, 200, "Status 200 on good new recording." );

%test_recording = Dvr::Scheduler::set_new_recording( '2014-05-30 20:00:00', 30, '4321' );
is( $test_recording{'status'}, 400, "Status 400 on bad channel" );

%test_recording = Dvr::Scheduler::set_new_recording( '201-05-30 20:00:00', 30, '321' );
is( $test_recording{'status'}, 400, "Status 400 on bad timestamp" );

%test_recording = Dvr::Scheduler::set_new_recording( '2014-05-30 20:00:00', 31, '321' );
is( $test_recording{'status'}, 400, "Status 400 on bad timespan" );

