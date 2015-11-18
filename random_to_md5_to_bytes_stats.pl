#!/usr/bin/perl -w
################################################################################

use strict;
use warnings qw(all);

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

use Digest::MD5 qw(md5_hex);

my $chunk_size = 1024;
my $iterations = 1024;        # this '10240 will results in about [.028, .054] ...
                              # ...  frequency boundaries.

my $data_length = $chunk_size * $iterations;
my $random_data = qx!cat /dev/random | head -c $data_length!;

my %bytes_stats = ();         # key is double hex byte
my $no_of_bytes = 0;          # bytes count

foreach my $iteration (0 .. $iterations - 1) {
  #my $md5 = qx!cat /dev/random | head -c $chunk_size | md5!;
  #chomp($md5);
  my $chunk = substr($random_data, $iteration * $chunk_size, $chunk_size);
  my $md5 = md5_hex($chunk);
  $md5 =~ s/(\w\w)/$1 /g;     # add a space between bytes
  chomp($md5);                # remove trailing space ' '
  my @md5_hex_bytes = split ' ', $md5;
  foreach my $byte (@md5_hex_bytes) {
    $bytes_stats{$byte}++;
    $no_of_bytes++;           # bytes count update
  }
}

my %frequencies = ();
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

# Print out results, remove tab '\t' for a compact format

foreach my $frequency (sort keys %frequencies) {
  print "$frequency:\n", "\t", "@{$frequencies{$frequency}}\n";
}
