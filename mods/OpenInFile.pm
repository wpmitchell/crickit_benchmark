#!/usr/bin/perl

package OpenInFile;

use warnings;
use strict;
use IO::File;
require Exporter;

our @ISA      = qw(Exporter);
our @EXPORT   = qw(openInFile);
# our @EXPORT_OK  = qw(); #Variables and functions in @EXPORT_OK are exported only when the program specifically requests them in the use statement.
our $VERSION   = 1.00;

sub openInFile
{

  my $inFile = $_[0];

  my $IN = IO::File->new("< $inFile")
  or die "Couldn't open $inFile for reading: $!\n";
  my $r_IN = \$IN;
  return $r_IN;
}
return 1

__END__

==head1 NAME

OpenInFile.pm
a package to open a file for reading and return a reference to the open file handle

=head1 VERSION 1.0

=head1 DATE
	
	2014.10.18

=head1 SYNOPSIS

    use openInFile($pathToFile);

=head1 DESCRIPTION

Takes a variable containg the fiull path to an exisiting file; opens it for reading;
returnsa reference to a file handle for the open file. 

=head2 Methods

=item translate<new>

Returns a reference  to an open file handle

=back

=head1 TEST_STATUS

Tested testFile_Packages.pl
Passed

=head1 LICENSE

This is released under the Artistic
License. See L<perlartistic>.

=head1 AUTHOR

Wayne Mitchell


=cut