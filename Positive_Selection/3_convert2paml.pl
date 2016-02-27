#---------------------------------------------------------------------------------------------------------------------+
# Copyright: Param Priya Singh and Anne Brunet (2015)                                                                 |
# Contact: param@stanford.edu                                                                                         |
#                                                                                                                     |
#  This script is a part of the analysis for manuscript, "The African turquoise killifish genome provides insights    |
#  into evolution and genetic architecture of lifespan", by Valenzano, Benayoun, Singh & Brunet et al. Cell (2015).   |                                                |
#                                                                                                                     |
#  This is distributed under the GNU General Public License <http://www.gnu.org/licenses/>.                           |
#---------------------------------------------------------------------------------------------------------------------+

# For codeml in PAML, the alignment format needed is phylip. So this script is to convert the fasta alignment from 
# GUIDANCE and PRANK into phylip format.

use strict;
use warnings;

# Directory having all the alignments from GUIGDANCE -- either from MAFFT or PRANK
foreach (<alignments_prank/*>){

	$_ =~/alignments_prank\/(.+)/g; # change here also for PRANK
	my $symbol = $1;
	
	#if ($symbol eq 'IGF1R_2_2'){ # test for 1 gene
		print "$symbol\t";
		convert($_, $symbol); # convert the format
		print "\n";
	#}
}


sub convert {
	
	my $file = shift;
	my $symb = shift;
	
	local $/ = '>';
	open FASTA, "$_/MSA.PRANK.aln.With_Names" or print "MSA not found"; # This will print the message if the alignment was not there --- copy paste it in a log file
	my @fastaseqs = <FASTA>;
	shift @fastaseqs;
	
	open OUT, ">alignments_prank_paml/$symb" or die $!; #outfile in a separate folder
	
	# print header for both interleaved and sequential
	print OUT " ";
	print OUT scalar @fastaseqs, " ";
	
	# get alignment length needed for phylip format
	my @forLength = split "\n", $fastaseqs[0];
	shift @forLength;
	if ($forLength[-1] eq '>'){pop @forLength;}
	my $forLen = join '', @forLength;
	my $alnLen = length $forLen;
	#print "@forLength";
	print OUT "$alnLen\n";

	my %Fasta;
	foreach (@fastaseqs){
	
		my @lines = split "\n", $_;
	
		my $org = shift @lines;
		if ($lines[-1] eq '>'){pop @lines;}
		my $len = length $org;
	
		my $spaces = 10 - $len;
		print OUT "$org";
		for (1..$spaces){print " "}
		print OUT "  ";
		print OUT join "", @lines;
		print OUT "\n";	
	
		$Fasta{$org} = join "", @lines;
	}
}

print "done";