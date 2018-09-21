#!/usr/bin/perl 


# CalculateCPAI

package CalculateCPAIOneGeneAuckland;
require Exporter;
use Data::Dumper;
# call with CalculateCAI::calculateCAI($ra_bases, $rh_CPI_ByCodonPair)
#
# returns $CAI_thisGene;

our @ISA      = qw(Exporter);
our @EXPORT   = qw(calculateCPAIOneGeneAuckland);
# our @EXPORT_OK  = qw(calculateCPAI); 

sub  calculateCPAIOneGeneAuckland
{

  my $ra_bases                      = shift;
  my $rh_codonPairAdaptivityTable   = shift;
  my $thisLogCPA_Total              = 0;
  my $geneLengthInCodonPairs        = 0; 
  my @bases = @{$ra_bases};

  $geneLengthInCodonPairs = (scalar(@bases)/3) - 1;
  
  for (my $j =0; $j < scalar(@bases) - 5; $j += 3) {
    
    my $codon1 = $bases[$j].$bases[$j+1].$bases[$j+2];
    my $codon2 = $bases[$j+3].$bases[$j+4].$bases[$j+5];
    
    if ( ( $codon1  =~ /tag|taa|tga/) || ( $codon2 =~ /tag|taa|tga/) ){
      next;
    }
    
    my $thisCodonPair = $codon1.$codon2;
    #print "\$thisCodonPair ", $thisCodonPair; "\t";

    $thisLogCPA_Total += log($rh_codonPairAdaptivityTable->{$thisCodonPair});

  }
  #print "\$thisLogCA_Total ", $thisLogCA_Total, " \$geneLengthInCodons ",$geneLengthInCodons,"\n";
  my $thisCPAI = exp( $thisLogCPA_Total / $geneLengthInCodonPairs );
  return $thisCPAI;
}
return 1;
