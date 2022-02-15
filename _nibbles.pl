#!/usr/bin/perl -w

#
# compute some stats about "cipher/digest", eg. sha384 -
#
# NOTE: this is actually a rewrite of "PoC" code from a few years ago, based on "SHA", /dev/random, ..
# it actually apply/use Moose, eg. an OOP system for Perl5
#

use strict;
use warnings qw(all);

###
package Stats;
#

use Moose;

use Digest::SHA qw(sha384_hex);
use Data::Entropy::RawSource::Local;
use IO::File;

has 'chunk_size' => (is => 'ro', isa => 'Int', default => 1024);
has 'n' => (is => 'ro', isa => 'Int', default => 1024);

my $stats = {};
my $freqs = {};
my $data;
my $no_of_bytes = 0;		# actual bytes count, for "digest freqs"-

sub setup {
	my $self = shift;
	my $rs = Data::Entropy::RawSource::Local->new();
	my $l = $self->chunk_size * $self->n;
	$rs->sysread($data, $l, 0);
	$self->_gather();
}

sub _sk {
	my $h = ref($_[0]) ? shift : { @_ };		# ref, or items -
	return sort keys %$h;
}

sub _gather {
	my $self = shift;
	my $h = shift || \&sha384_hex;		# default is "sha" -
	for my $i (0 .. $self->n - 1) {
		my $chunk = substr($data, $i * $self->chunk_size, $self->chunk_size);
		my $d = $h->($chunk);
		for my $b (unpack('(a2)*', $d)) {
			$stats->{$b}++;
		}
		$no_of_bytes += length($d) / 2;
	}
	return $stats;
}

sub frequencies {
	my $self = shift;
	my $s = sub { sprintf "%.4f", shift };
	for my $b (_sk $stats) {
		my $f = 1.0 * $stats->{$b} / $no_of_bytes;
		push @{$freqs->{$s->($f)}}, $b;
	}
	return $freqs;
}

sub show {
	my $self = shift;
	my $output = shift || \*STDOUT;
	for my $f (_sk $freqs) {
		my $n = $freqs->{$f};
		$output->print("$f: \n", "\t@{$n}\n");
	}
}

####
package main;
#

my $s = Stats->new(chunk_size => 1024, n => 1024);			# the usual "defaults", indeed.
$s->setup();
$s->frequencies();
$s->show();
