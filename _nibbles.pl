#!/usr/bin/perl -w
################################################################################
#
# Compute the frequency of md5 digest bytes - double nibbles - out of a matrix
#   of random data, in this case obtained from 'dev/random'
#
# NOTE:
#
#   "Optimized" with builtin md5 digest, system level code remains
#     for reference purpouses.
#
################################################################################

use strict;
use warnings qw(all);

################################################################################
package Stats;
################################################################################

use Digest::MD5 qw(md5_hex);
use Digest::SHA qw(sha256_hex);

my $chunk_size = 1024;
my $iterations = 1024;         # this '1024' will results in about [.0028, .0054] ...
                                      # ...  frequency boundaries.

my $data_length = $chunk_size * $iterations;
my $random_data = qx!cat /dev/random | head -c $data_length!;

my %bytes_stats = ();            # key is double hex byte
my $no_of_bytes = 0;            # bytes count

my %frequencies = ();

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  return bless {}, $class;
}

sub collect_stats {
  foreach my $iteration (0 .. $iterations - 1) {
    #my $digest = qx!cat /dev/random | head -c $chunk_size | md5!;
    #chomp($digest);
    my $chunk = substr($random_data, $iteration * $chunk_size, $chunk_size);
    my $digest = md5_hex($chunk);
    #my $digest = sha256_hex($chunk);     # will fall between [.0030, .0050]
    $digest =~ s/(\w\w)/$1 /g;                    # add a space between bytes
    chomp($digest);                               # remove trailing space ' '
    my @hex_bytes = split ' ', $digest;
    foreach my $byte (@hex_bytes) {
      $bytes_stats{$byte}++;
      $no_of_bytes++;                             # bytes count update
    }
  }
}

sub compute_frequencies {
  my @ordered_bytes
    = sort { $bytes_stats{$a} cmp $bytes_stats{$b} } keys %bytes_stats;

  foreach my $byte (reverse @ordered_bytes) {
    my $frequency
      = sprintf "%.4f", $bytes_stats{$byte} / $no_of_bytes * 1.0;
    unless (exists $frequencies{$frequency}) {
      @{$frequencies{$frequency}} = ();
    }
    push @{$frequencies{$frequency}}, $byte;  # update fres => bytes list
  }
}

sub print_out_results {
  my $class = shift;
  my $output = shift; 

  # Print out results, remove tab '\t' for a compact format
  foreach my $frequency (sort keys %frequencies) {
    $output->print("$frequency:\n", "\t", "@{$frequencies{$frequency}}\n");
  }
}

################################################################################
package Main;
################################################################################

use IO::File;

my $stats = Stats->new();

$stats->collect_stats();
$stats->compute_frequencies();
$stats->print_out_results(\*STDOUT);

