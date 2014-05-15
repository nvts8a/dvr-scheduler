#!/usr/bin/perl
package Dvr::Validator;
use strict;
use warnings;

# Validates a inout channel. DVR expects a certain format, will return 1 if format is valid or 0 if it is not
sub valid_channel {
	my ($channel) = @_;
	my $is_valid = 0;

	if( $channel ) {
		if( $channel =~ m/^[0-9]{1,3}$|^[0-9]{1,3}[\-\.][0-9]{1,2}$/ ) {
			$is_valid = 1;
		}
	}

	return $is_valid;
}

1;
