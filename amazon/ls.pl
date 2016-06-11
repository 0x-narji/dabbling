#!usr/bin/perl -w
###############################################################################
#
# TODO: todo :-D
#
###############################################################################

use strict;
use warnings qw(all);

###############################################################################
package Amazon::CodingTest::ListSegments;
###############################################################################

use File::Find::Rule;
use File::Spec;

our %implementedOptions = (
	'a' => 'all-files',
	'd' => 'directories',
	'n' => 'use-id',
	'l' => 'long-listing',
	'F' => 'file-nature',
	'R' => 'recursive',
	'r' => 'reverse', 
	't' => 'sort-by-last-modified'
);

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self = {};
	
	my $options = shift;							# expect a hash ref
	my %longOptions = map {
		$implementedOptions{$_} => 1				# set a true value for option evaluation
	} keys %$options;

	$self->{_options} = \%longOptions;

	bless $self, $class;
	return $self;
}

sub execute {
	my $self = shift;
	my $output = shift;
	my @operands = @_;
	
	# files found on command line first
	
	foreach my $file (sort grep { ! -d } @operands) {
		$output->print("$file\n");
	}
	
	# directories

	foreach my $dir (sort grep { -d } @operands) {
		$self->print_directory($output, $dir);
	}
}

sub print_directory {
	my $self = shift;
	my $output = shift;
	my $target = shift;
	
	$target = File::Spec->canonpath($target);
	
	$output->print("$target:\n");
	
	my @entries
		= sort File::Find::Rule->extras({follow => 1})->in($target);
	
	foreach my $entry (@entries) {
		my (undef, $path, $file) = File::Spec->splitpath($entry);
		$output->print("$file\n");
	}
	$output->print("\n");
	
	# exit subroutine unless recursion is required by the user
	return
		unless exists $self->{_options}->{recursive};
	
	my @directories
		= grep { -d && $_ ne $target } map { File::Spec->canonpath($_) } @entries;
	foreach my $directory (@directories) {
		$self->print_directory($output, $directory);
	}
}

###############################################################################
package main;
###############################################################################

use IO::Handle;
use Getopt::Std;
use Pod::Usage;

sub HELP_MESSAGE { pod2usage(1) }					# called when --help is specified

my %options = ();

my $implementedOptions
	= join '' => keys(%Amazon::CodingTest::ListSegments::implementedOptions);

getopts($implementedOptions, \%options)
	or pod2usage(2);

my $lsCommand
	= new Amazon::CodingTest::ListSegments(\%options);

my @files = @ARGV ? @ARGV : '.';					# default file is current directory

$lsCommand->execute(\*stdout, @files);

__END__

=head1 NAME

B<ls> -- list directory contents

=head1 SYNOPSIS

B<ls> [B<-adnlFRrt>] [U<file> U<...>]

=head1 OPTIONS

=over 8

=item B<--help>

Print a brief help message and exits.

=back

=head1 DESCRIPTION

For each operand that names a U<file> of a type other than directory, B<ls> displays its name
as well as any requested, associated information. For each operand that names
a U<file> of type directory, B<ls> displays the names of files contained within that directory,
as well as any requested, associated information.

If no operands are given, the contents of the current directory are displayed.
If more than one operand is given, non-directory operands are displayed first; directory and
non-directory operands are sorted separately and in lexicographical order.

=cut
