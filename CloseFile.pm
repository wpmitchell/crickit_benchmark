#!/usr/bin/perl

package CloseFile;

use warnings;
use strict;
use IO::File;
require Exporter;

our @ISA      = qw(Exporter);
our @EXPORT   = qw(closeFile);
# our @EXPORT_OK  = qw(); #Variables and functions in @EXPORT_OK are exported only when the program specifically requests them in the use statement.
our $VERSION   = 1.00; 

sub closeFile
{ 
    my $r_FILE = $_[0];

    close $$r_FILE;
    return 1;
}
return 1;

__END__

==head1 NAME

CloseFile.pm
a package to close a file 

=head1 VERSION 1.0

=head1 DATE
	
	2014.10.18

=head1 SYNOPSIS

    use closeFile($pathToFile);

=head1 DESCRIPTION

Takes a variable containg the reference to an open file handle
Closee the file. Returns 1.

=head2 Methods

=item closeFile<new>

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