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
has 'iterations' => (is => 'ro', isa => 'Int', default => 1024);

my %stats = ();
my %freqs = ();
my $data;
my $no_of_bytes = 0;					# actual bytes count

sub setup {
	my $self = shift;
	my $s = Data::Entropy::RawSource::Local->new();
	$s->sysread($data, $self->chunk_size * $self->iterations, 0);
	$self->_gather();
}

sub _gather {
	my $self = shift;
	my $h = shift || \&sha384_hex;						# default is "sha" -
	foreach my $i (0 .. $self->iterations - 1) {
		my $chunk = substr($data, $i * $self->chunk_size, $self->chunk_size);
		my $d = $h->($chunk);
		foreach my $b (unpack('(a2)*', $d)) {
			$stats{$b}++;
		}
		$no_of_bytes += length($d) / 2;
	}
}

sub frequencies {
	my $self = shift;
	foreach my $b (sort keys %stats) {
		my $n = sprintf "%.4f", 1.0 * $stats{$b} / $no_of_bytes;
		push @{$freqs{$n}}, $b;
	}
}

sub display {
	my $self = shift;
	my $output = shift || \*STDOUT;
	foreach my $n (sort keys %freqs) {
		$output->print("$n: \n", "\t@{$freqs{$n}}\n");
	}
}

####
package main;
#

my $s = Stats->new(chunk_size => 1024, iterations => 1024);			# the usual "defaults", indeed.
$s->setup();
$s->frequencies();
$s->display();
