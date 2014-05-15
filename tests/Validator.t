#!/usr/bin/perl
use strict;
use warnings;

use Test::More qw(no_plan);

#####
# Can access module?
use_ok( 'Dvr::Validator' );

#####
# Tests for channel validation

# Valid channels
is( Dvr::Validator::valid_channel('1'), '1', 'Valid channel: 1' ); 
is( Dvr::Validator::valid_channel('12'), '1', 'Valid channel: 12' ); 
is( Dvr::Validator::valid_channel('123'), '1', 'Valid channel: 123' ); 
is( Dvr::Validator::valid_channel('123-4'), '1', 'Valid channel: 123-4' ); 
is( Dvr::Validator::valid_channel('123-45'), '1', 'Valid channel: 123-45' ); 
is( Dvr::Validator::valid_channel('123.4'), '1', 'Valid channel: 123.4' ); 
is( Dvr::Validator::valid_channel('123.45'), '1', 'Valid channel: 123.45' ); 

# Invalid channels
is( Dvr::Validator::valid_channel(undef), '0', 'Invalid channel: undef' ); 
is( Dvr::Validator::valid_channel('0'), '0', 'Invalid channel: 0' ); 
is( Dvr::Validator::valid_channel('-1'), '0', 'Invalid channel: -1' ); 
is( Dvr::Validator::valid_channel('1234'), '0', 'Invalid channel: 1234' ); 
is( Dvr::Validator::valid_channel('123.'), '0', 'Invalid channel: 123.' ); 
is( Dvr::Validator::valid_channel('123-'), '0', 'Invalid channel: 123-' ); 
is( Dvr::Validator::valid_channel('1234.56'), '0', 'Invalid channel: 1234.56' ); 
is( Dvr::Validator::valid_channel('1234-56'), '0', 'Invalid channel: 1234-56' ); 
is( Dvr::Validator::valid_channel('123.456'), '0', 'Invalid channel: 123.456' ); 
is( Dvr::Validator::valid_channel('123-456'), '0', 'Invalid channel: 123-456' );



#####
# Tests for datetime validation

# Valid datetimes
is( Dvr::Validator::valid_datetime('1000-01-01 00:00:00'), '1', 'Valid datetime: 1000-01-01 00:00:00' );
is( Dvr::Validator::valid_datetime('9999-12-31 23:59:59'), '1', 'Valid datetime: 9999-12-31 23:59:59' );
is( Dvr::Validator::valid_datetime('2014-05-15 15:33:46'), '1', 'Valid datetime: 2014-05-15 15:33:46' );

# Invalid datetimes
is( Dvr::Validator::valid_datetime(undef), '0', 'Invalid datetime: undef' );
is( Dvr::Validator::valid_datetime('201A-05-15 15:33:46'), '0', 'Invalid datetime: 201A-05-15 15:33:46' );
is( Dvr::Validator::valid_datetime('201-05-15 15:33:46'), '0', 'Invalid datetime: 201-05-15 15:33:46' );
is( Dvr::Validator::valid_datetime('20141-05-15 15:33:46'), '0', 'Invalid datetime: 20141-05-15 15:33:46' );
is( Dvr::Validator::valid_datetime('05-15 15:33:46'), '0', 'Invalid datetime: 05-15 15:33:46' );
is( Dvr::Validator::valid_datetime('0014-05-15 15:33:46'), '0', 'Invalid datetime: 0014-05-15 15:33:46' );
is( Dvr::Validator::valid_datetime('2014-13-15 15:33:46'), '0', 'Invalid datetime: 2014-13-15 15:33:46' );
is( Dvr::Validator::valid_datetime('2014-05-32 15:33:46'), '0', 'Invalid datetime: 2014-05-32 15:33:46' );
is( Dvr::Validator::valid_datetime('2014-15 15:33:46'), '0', 'Invalid datetime: 2014-15 15:33:46' );
is( Dvr::Validator::valid_datetime('2014-05-15 24:33:46'), '0', 'Invalid datetime: 2014-05-15 24:33:46' );
is( Dvr::Validator::valid_datetime('2014-05-15 15:63:46'), '0', 'Invalid datetime: 2014-05-15 15:63:46' );
is( Dvr::Validator::valid_datetime('2014-05-15 15:33:66'), '0', 'Invalid datetime: 2014-05-15 15:33:66' );
is( Dvr::Validator::valid_datetime('2014-05-15 5:33:46'), '0', 'Invalid datetime: 2014-05-15 5:33:46' );
is( Dvr::Validator::valid_datetime('2014-05-15 15:3:46'), '0', 'Invalid datetime: 2014-05-15 15:3:46' );
is( Dvr::Validator::valid_datetime('2014-05-15 15:33:6'), '0', 'Invalid datetime: 2014-05-15 15:33:6' );
is( Dvr::Validator::valid_datetime('2014-05-15 151:33:46'), '0', 'Invalid datetime: 2014-05-15 151:33:46' );
is( Dvr::Validator::valid_datetime('2014-05-15 15:313:46'), '0', 'Invalid datetime: 2014-05-15 15:313:46' );
is( Dvr::Validator::valid_datetime('2014-05-15 15:33:461'), '0', 'Invalid datetime: 2014-05-15 15:33:461' );


