#!/usr/bin/perl -w

#
# compute some stats about "cipher/digest", eg. sha384 -
#
# NOTE: this is actually a rewrite of PoC code I wrote a few years ago, based on MD5, /dev/random, and so on ..
# this code actually apply/use Moose, an OOP system for Perl5
# and a "wrapper" to random data generators.
#
# NICE TO HAVE: I should actually apply some tdd/bdd - using at least Test::More,
# as to verify its correctness,
# time-by-time.
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

my $data;
my %stats = ();
my $no_of_bytes = 0;
my %freqs = ();

sub setup {
  my $self = shift;
  my $s = Data::Entropy::RawSource::Local->new();
  # in-memory data, at once, like a 'slurp' - yet, from a /random device !
  $s->sysread($data, $self->chunk_size * $self->iterations, 0);
  # .. and gather some stats about it. yep !
  $self->_gather();
}

sub _gather {
  my $self = shift;
  for my $i (0 .. $self->iterations - 1) {
    my $chunk = substr($data, $i * $self->chunk_size, $self->chunk_size);
    my $d = sha384_hex($chunk);
    for my $b (unpack('(a2)*', $d)) {
      $stats{$b}++;
      ++$no_of_bytes;       # this may be computed, so it'd be ok for a unit test !?
    }
  }
}

sub compute_freqs {
  my $self = shift;
  for my $b (sort keys %stats) {
    my $n = sprintf "%.4f", 1.0 * $stats{$b} / $no_of_bytes;
    if (!exists $freqs{$n}) {
      @{$freqs{$n}} = ();
    }
    push @{$freqs{$n}}, $b;
  }
}

sub print {
  my $self = shift;
  my $output = shift || \*STDOUT;
  for my $n (sort keys %freqs) {
    $output->print("$n: \n", "\t", "@{$freqs{$n}}\n");
  }
}

####
package main;
#

my $obj = Stats->new(chunk_size => 1024, iterations => 1024);     # the usual "defaults", indeed.
$obj->setup();
$obj->compute_freqs();
$obj->print();
