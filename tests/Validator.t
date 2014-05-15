#!/usr/bin/perl
use strict;
use warnings;

use File::Basename;
use lib dirname (__FILE__);
use Test::More tests => 2;

use_ok( 'Dvr::Validator' );

is( Dvr::Validator::valid_channel('1'), '1', 'Valid channel' ); 
is( Dvr::Validator::valid_channel('12'), '1', 'Valid channel' ); 
is( Dvr::Validator::valid_channel('123'), '1', 'Valid channel' ); 
is( Dvr::Validator::valid_channel('123-4'), '1', 'Valid channel' ); 
is( Dvr::Validator::valid_channel('123-45'), '1', 'Valid channel' ); 
is( Dvr::Validator::valid_channel('123.4'), '1', 'Valid channel' ); 
is( Dvr::Validator::valid_channel('123.45'), '1', 'Valid channel' ); 

is( Dvr::Validator::valid_channel(undef), '0', 'Invalid channel' ); 
is( Dvr::Validator::valid_channel('0'), '0', 'Invalid channel' ); 
is( Dvr::Validator::valid_channel('-1'), '0', 'Invalid channel' ); 
is( Dvr::Validator::valid_channel('1234'), '0', 'Invalid channel' ); 
is( Dvr::Validator::valid_channel('123.'), '0', 'Invalid channel' ); 
is( Dvr::Validator::valid_channel('123-'), '0', 'Invalid channel' ); 
is( Dvr::Validator::valid_channel('1234.56'), '0', 'Invalid channel' ); 
is( Dvr::Validator::valid_channel('1234-56'), '0', 'Invalid channel' ); 
is( Dvr::Validator::valid_channel('123.456'), '0', 'Invalid channel' ); 
is( Dvr::Validator::valid_channel('123-456'), '0', 'Invalid channel' ); 
