#!/usr/bin/perl

# parseTransTerm.pl

use warnings;
use strict;
use lib "/Users/wayne/Desktop/Archetype/PerlmodsCopy";
use PerlmodsCopy::OpenInFile;
use PerlmodsCopy::OpenOutFile;
use PerlmodsCopy::CloseFile;
use Data::Dumper;

print "START\n";

my $inFile0  = "/Users/wayne/Desktop/TransTerm/LTMG3_TransTerm.out";
my $r_in0 	 = OpenInFile::openInFile($inFile0);
my $TRANS_TERM      = $$r_in0;


my $outFile0 = "/Users/wayne/Desktop/TransTerm/LTMG3_TransTermEdit.txt";
my $r_out0 	 = OpenOutFile::openOutFile($outFile0);
my $OUT0     = $$r_out0;


my @transTermFull = ();
while (my $line = <$TRANS_TERM> ){

	$line =~ s/^\s+//;
	$line =~ s/\s+$//;

	if ($line =~ /^\#/){
		next;
	}else{
		#print $line,"\n";
		push (@transTermFull, $line);
    }
}
CloseFile::closeFile($TRANS_TERM);

my @resultGroup = ();
push (@resultGroup, shift@transTermFull);
for(my $i = 0; $i < scalar@transTermFull; $i++){

	##
	# capture first locus line
	##
	#if ($i == 0){
	#	push ( @resultGroup, $transTermFull[$i] );
	#	print ("Top \$transTermFull\[\$i\] \t", $transTermFull[$i],"\n");
	#	next;
	##
	# capture Term and Sequence lines up to and including next locus
	if($transTermFull[$i] =~ /^LTMG3_*/){
		#print ("if i :", $i," \$transTermFull\[\$i\] \t", $transTermFull[$i],"\n");
		push ( @resultGroup, $transTermFull[$i] );
		#print @resultGroup,"\n";
		##
		# process the result group and print Locus related to terminus, and terminus min, max and sequence
		##
		my $ra_resultGroup = \@resultGroup;
		#my $resultWithGeneOfRecord = addGeneOfRecord($ra_resultGroup);
		my $ra_resultWithGeneOfRecord = addGeneOfRecord($ra_resultGroup);
		my $previousLocusHasTerm      = pop(@$ra_resultWithGeneOfRecord);
		my $resultWithGeneOfRecord    = pop(@$ra_resultWithGeneOfRecord);
		print $OUT0 ($resultWithGeneOfRecord, "\n");
		@resultGroup = ();
		
		if ($previousLocusHasTerm){
			next;
		}else{
			# restart collection with last locus
			push (@resultGroup,$transTermFull[$i] );
		}
	}else{
		#print ("else i :", $i," \$transTermFull\[\$i\] \t", $transTermFull[$i],"\n");
		push ( @resultGroup, $transTermFull[$i] );
	}
}
CloseFile::closeFile($r_out0);

sub addGeneOfRecord
{

	my $ra_resultGroup = shift;

	my @resultGroup = @{$ra_resultGroup};
	# LTMG3_10           79 - 285      + | 
	my $firstLine = shift(@resultGroup);
	my $lastLine  =   pop(@resultGroup);
	
	print "\$firstLine ", $firstLine, "\t\$lastLine ", $lastLine,"\n";
	(my $prefixLeft, my $suffixLeft)  = split(/\|/,$firstLine);
	print "LEFT \$prefixLeft ",$prefixLeft,"\t\$suffixLeft ", $suffixLeft,"\n";
	
	(my $leftLocus, my $coord1Left, my $dash, my $coord2Left, my $locusDirLeft ) = split(/\s+/, $prefixLeft);

	(my $prefixRight, my $suffixRight)  = split(/\|/,$lastLine);
	print "RIGHT \$prefixright ",$prefixRight,"\n";
	
	(my $rightLocus, my $coord1Right, $dash, my $coord2Right, my $locusDirRight ) = split(/\s+/, $prefixRight);


	my $locusMinLeft = 0;
	my $locusMaxLeft = 0;
	if ($locusDirLeft =~ /\+/){
		$locusDirLeft = 'F';
		$locusMinLeft = $coord1Left;
		$locusMaxLeft = $coord2Left;

	}elsif($locusDirLeft =~ /\-/){
		$locusDirLeft = 'R';
		$locusMinLeft = $coord2Left;
		$locusMaxLeft = $coord1Left;

	}

	my $locusMinRight = 0;
	my $locusMaxRight = 0;
	if ($locusDirRight =~ /\+/){
		$locusDirRight = 'F';
		$locusMinRight = $coord1Right;
		$locusMaxRight = $coord2Right
	}elsif($locusDirRight =~ /\-/){
		$locusDirRight = 'R';
		$locusMinRight = $coord2Right;
		$locusMaxRight = $coord1Right;

	}	
print "Top \$locusDirRight ",$locusDirRight, "\n";
	my $geneOfRecord 				= '';
	my $bestTermScore 				= 0;
	my $bestScoringTermName 		= '';
	my $bestScoringTermLeftCoord 	= 0;
	my $bestScoringTermRightCoord 	= 0;
	my $bestScoringTermDir 			= '';
	my $bestScoringTermSeq			= '';

	for(my $i = 0 ; $i < scalar@resultGroup; $i+=2){
		my $term = $resultGroup[$i];
		#print "\$term ", $term, "\n";
		my $seq  = $resultGroup[$i+1];
		$seq =~ s/\s+/\t/g;
		$seq = lc($seq);
		#print "\$seq\t",$seq,"\n";
		#my $prefixTerm, my $suffixTerm  =~ split(/\|/,$term );
		#print "\$prefixTerm ",$prefixTerm,"\n";
		#TERM 5          471 - 520      + T   100 -15.9 -3.63241 
		
		my @tmp = split(/\s+/, $term);
		#print "\@tmp ", @tmp,"\n";
		my $termName		= $tmp[0]; 
		my $termNumber		= $tmp[1]; 
		my $termLeftCoord	= $tmp[2]; 
		$dash 				= $tmp[3]; 
		my $termRightCoord	= $tmp[4]; 
		my $termDir 		= $tmp[5];
		my $termType 		= $tmp[6];
		my $termScore 	 	= $tmp[7];
		my $r 				= $tmp[8];
		my $s 				= $tmp[9]; 
		
		$termName = "Term_".$termNumber;
		if ($termScore > $bestTermScore){
			print "BETTER SCORE \n";
			$bestTermScore 				= $termScore; 
			$bestScoringTermName 		= $termName;
			$bestScoringTermLeftCoord 	= $termLeftCoord;
			$bestScoringTermRightCoord 	= $termRightCoord;
			$bestScoringTermDir 		= $termDir;
			$bestScoringTermSeq			= $seq;

		}
		print "Inside \$bestScoringTermName\t",$bestScoringTermName ,"\n";
	}
print "Outside \$bestScoringTermName\t",$bestScoringTermName ,"\n";
	##
	# change leftCoord and rightCoord to LT Min Max convention
	##
	my $bestScoringTermMin = 0;
	my $bestScoringTermMax = 0;
	if ($bestScoringTermDir =~ /\+/){
		$bestScoringTermDir = 'F';
		$bestScoringTermMin = $bestScoringTermLeftCoord;
		$bestScoringTermMax = $bestScoringTermRightCoord;

	}elsif($bestScoringTermDir =~ /\-/){
		$bestScoringTermDir = 'R';
		$bestScoringTermMin = $bestScoringTermRightCoord;
		$bestScoringTermMax = $bestScoringTermLeftCoord;

	}

	##
	# set gene of interest
	##

	my $distanceTermToLeftLocus  = 0;
	my $distanceTermToRightLocus = 0;
	my $minOfRecord 			 = 0;
	my $maxOfRecord 			 = 0;
	my $dirOfRecord 			 = '';

	my $previousLocusHasTerm = 0;
print "\$locusDirLeft ", $locusDirLeft,"\$locusDirRight ", $locusDirRight, "\n";
	if (($locusDirLeft =~ /\+/) && ($locusDirRight =~ /\+/) ){
		$geneOfRecord = $leftLocus;
	}elsif(($locusDirLeft =~ /\-/) && ($locusDirRight =~ /\-/) ){
		$geneOfRecord = $rightLocus;
		$previousLocusHasTerm++;
	}else{
		# type 'T' => <= , is term closer to left term or right term ?
	
		##
		# get shortest distance from best terminator to left and rigth loci and compare
		##

		#if ($locusDirLeft =~ /\sF\s/){
			$distanceTermToLeftLocus = $bestScoringTermMin - $locusMaxLeft;
		#}elsif($locusDirLeft =~ /\sR\s/){
			$distanceTermToRightLocus = $locusMinRight - $bestScoringTermMax;
		#}

		if ($distanceTermToLeftLocus <= $distanceTermToRightLocus){
			$geneOfRecord 	= $leftLocus;
			$minOfRecord 	= $locusMinLeft;
			$maxOfRecord 	= $locusMaxLeft;
			$dirOfRecord 	= $locusDirLeft;

		}elsif(($distanceTermToRightLocus < $distanceTermToLeftLocus)){
			$geneOfRecord 	= $rightLocus;
			$minOfRecord 	= $locusMinRight;
			$maxOfRecord 	= $locusMaxRight;
			$dirOfRecord 	= $locusDirRight;
			$previousLocusHasTerm++;
		}
	}

	##
	# prepare result and return
	##

	my $resultWithGeneOfRecord = $geneOfRecord."\t".$minOfRecord."\t".$maxOfRecord."\t".$dirOfRecord."\t".$bestScoringTermName."\t".$bestTermScore."\t".$bestScoringTermMin."\t".$bestScoringTermMax."\t".$bestScoringTermSeq; 
print "\$resultWithGeneOfRecord","\$",$resultWithGeneOfRecord,"\n";
	my @resultWithGeneOfRecord = $resultWithGeneOfRecord;
	push(@resultWithGeneOfRecord ,$previousLocusHasTerm);
	my $ra_resultWithGeneOfRecord = \@resultWithGeneOfRecord;
	return $ra_resultWithGeneOfRecord;
}



print "END\n";