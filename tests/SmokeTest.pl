#!/usr/bin/perl
use strict;
use warnings;

use File::Find::Rule;
use Test::Harness qw(&runtests);


my $rule = File::Find::Rule->new;
$rule->or(
	$rule->new->directory->name('CVS')->prune->discard,
	$rule->new->file->name( '*.t' )
);

my @start = @ARGV ? @ARGV : '.';
my @files;

for ( @start ) {
	push( @files, (-d) ? $rule->in($_) : $_ );
}

runtests(@files);
