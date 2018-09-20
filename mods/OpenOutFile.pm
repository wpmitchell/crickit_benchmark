#!/usr/bin/perl

package OpenOutFile;

use warnings;
use strict;
use IO::File;
require Exporter;

our @ISA      = qw(Exporter);
our @EXPORT   = qw(openOutFile);
# our @EXPORT_OK  = qw(); #Variables and functions in @EXPORT_OK are exported only when the program specifically requests them in the use statement.
our $VERSION   = 1.00;


sub openOutFile
{

  my $outFile = shift;

  #untaint;
  if ( $outFile =~ m/^([\/\-a-zA-Z0-9\n_\>\.\-]+)$/ ) {$outFile = $1};

  my $OUT = IO::File->new("> $outFile")
  or die "Couldn't open $outFile for writting: $!\n";

  my $r_OUT = \$OUT;
  return $r_OUT;

}
return 1;

__END__

==head1 NAME

OpenOutFile.pm
a package to open a file for writting and return a reference to the open file handle

=head1 VERSION 1.0

=head1 DATE
	
	2014.10.18

=head1 SYNOPSIS

    use openOutFile($pathToFile);

=head1 DESCRIPTION

Takes a variable containg the fiull path to an exisiting file; opens it for writting;
returnsa reference to a file handle for the open file. 

=head2 Methods

=item openOutFile<new>

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