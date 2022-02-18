#!/usr/bin/perl -w

use strict;
use warnings qw(all);

###
package main;
#

use v5.10;

my $some_text = "John Doe, went to mountains!";

my @l = unpack("(a2)*", $some_text);
for (@l) {
	state $s = 1;
	printf "%3d: $_\n", $s++;
}
