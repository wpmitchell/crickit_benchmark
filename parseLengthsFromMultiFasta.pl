#!/usr/bin/perl

# parseLengthsFromMultiFasta.pl

use warnings;
use strict;
use lib "./mods";
use mods::OpenInFile;
use mods::OpenOutFile;
use mods::CloseFile;
use mods::CalculateCPAIOneGeneAuckland;
use mods::ReverseComplement;
use mods::Translate;
use Data::Dumper;

print "START\n";

my $inFile0  = "./data/LTMG1_proteinMultiFasta.txt";
my $r_in0 	 = OpenInFile::openInFile($inFile0);
my $SOURCE0  = $$r_in0;

my $inFile1  = "./data/LTMG1.fasta.txt";
my $r_in1 	 = OpenInFile::openInFile($inFile1);
my $SOURCE1  = $$r_in1;

my $outFile0 = "./output/LTMG1_proteinLengths.txt";
my $r_out0 	 = OpenOutFile::openOutFile($outFile0);
my $PROTLENGTH     = $$r_out0;

my $outFile1 = "./output/.txt";
my $r_out1 	 = OpenOutFile::openOutFile($outFile1);
my $GENE     = $$r_out1;

my @headers = ();
while (my $line = <$SOURCE0> ){

	$line =~ s/^\s+//;
	$line =~ s/\s+$//;

	if ($line =~ /^\#/){
		next;
	}elsif($line =~ /^\>/){
		push (@headers, $line);
	}else{
		next;
	}
}
CloseFile::closeFile($SOURCE0);

my @genome = ();
while (my $line = <$SOURCE1> ){

	$line =~ s/^\s+//;
	$line =~ s/\s+$//;

	if($line =~ /^\>/){
		push (@headers, $line);
	}else{
		push (@genome, split('',$line));
	}
}
CloseFile::closeFile($SOURCE0);

#my @lengths = ();
my %lengthByLocus;

#>LTMG1_40       789     1268    R
foreach my $line (@headers){

	(my $locus, my $min, my $max, my $dir) = split('\t', $line);
	
	my $ra_gene = extractGeneSequence($ra_genome, $min, $max, $dir)
    printToGeneFile($line, $ra_gene, $r_out1);
	$locus =~ s/\>//;
    my $length = calcProteinLengths($locus, $min, $max);
	$lengthByLocus{$locus} = $length;

}

##
# sort by length and print length file
##
my $i = 1;
foreach my $locus (sort { $lengthByLocus{$b} <=> $lengthByLocus{$a} } keys %lengthByLocus) {
    print $PROTLENGTH ($locus,"\t", $lengthByLocus{$locus},"\t", $i,"\n");
    $i++;
}
CloseFile::closeFile($PROTLENGTH);

##
# print multiFastaGene file
##

CloseFile::closeFile($GENE);
CloseFile::closeFile($SOURCE1);
print "END\n";

sub extractGeneSequence
{
	my $ra_genome = shift;
	my $min		  = shift;
	my $max 	  = shift;
	my $dir 	  = shift;

	##
	# get slice from @genome
	##

	$ra_gene = ;
	return $ra_gene;
}

sub calcProteinLengths
{
	my $locus = shift;
	my $min   = shift;
	my $max   = shift;

	my $length = $max - $min + 1;
	return $length;

}

printToGeneFile
{
	my $header  			= shift;
	my $ra_gene 			= shift;
	my $r_out1				= shift;

	my $GENE = $$r_out1;

	print $GENE ($header, "\n");
	for (my $i = 1; $i < scalar(@{$ra_gene}); $i++){
 		if ($i == 1){
 			print $GENE ($ra_gene->[$i]);
 		}elsif($i%3 == 0){
 			print $GENE ($ra_gene->[$i], "\n");
 		}else{
 			print $GENE ($ra_gene->[$i], "\n");
 		}
	}
	if ($i%3 != 0){
		print $GENE ("\n");
	}
}

print "END\n";