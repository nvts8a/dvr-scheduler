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
