# This is to get the killifish positions for all the selected sites.
# Residues in other fish are also printed in a column. I use this to compare with 
# variants and check which ones are overlapping.

use strict;
use warnings;

# Output file
open OUT, '>Selecetd_sites_filtered_prank_p05_mhc_grz-mzm-overlap.txt' or die $!; # For all selected genes with p < 0.05
print OUT "Gene	P-value	Alignment position	Sequence position	Probability of selection	Killifish residue	Other fishes residues\n";

# Selection file with alignment positions in my analysis
open FH, 'selecetd_genes_prank_p0.05_aln-pos_mhc.txt' or die $!;  # all selected genes with p < 0.05 after multiple hypothesis correction
my @file = <FH>;
close (FH);
shift @file;

# This is the path having all killifish alignmnets to get the alignment -> killifish positions or vice versa
my $path = '/Users/Param/Work/Fish_genome/Selection_PAML/branch-site/alignments_prank';

foreach (@file){  # foreach gene under selection
	
	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
#	if ($line[0] eq 'LRP2B'){ # test for one gene
	
		my @allsites = split ',', $line[19];	# all sites under selection after filtering -- take in an array
		
		# get alignments for this gene
		my $alnRef = getAln($line[0]);
		my %Alignment = %$alnRef; # Alignment has species name as key and alignment with - for spaces as value
		
		foreach (@allsites){ # Foreach selected site
			
			my @pos = split " ", $_; # separate positions and probabilities. THESE ARE ALIGNMENT POSITIONS

			# get the position in killifish sequence - I just get the substring till current position
			# This is alignment so it has gaps or dashes -
			# I just replace it and then the remainig would be only sequence and I can get the position in seq using length
			my $kfSeq =  substr $Alignment{'Killifish'}, 0, $pos[0]; # substring from alignment
			$kfSeq =~s/-//g;                                         # replace -
			my $kfPos = length $kfSeq;                               # length is the killifish seq position
			
			print OUT "$line[0]\t$line[6]\t$pos[0]\t$kfPos\t$pos[2]\t";
			print OUT substr $Alignment{'Killifish'}, ($pos[0]-1), 1; # killifish residue
			print OUT "\t";
			foreach (keys %Alignment){ # Print resides in other fish
				if ($_ ne 'Killifish'){print OUT substr $Alignment{$_}, ($pos[0]-1), 1;}
			}
			print OUT "\n";
		}		
#	} # end test for one gene
}		

# Subroutein to get the alignmnet in a hash
# Key => species name
# Value => Alignment in a string
# Since this is alignment the length is same for each species
sub getAln {
	
	my $gene = shift;
	
	# get sequence codes - prank soes not have species zname in protein alignment so I need to use this mapping file to get the names
	# from the Seqs.codes file
	open CODE, "$path/$gene/Seqs.Codes" or die $!;
	my %Codes;
	foreach (<CODE>){
		
		my @codeline = split "\t", $_;
		map {$_=~s/\n//g} @codeline;		
		#print "$codeline[0]\t$codeline[1]\n";
		$Codes{$codeline[1]} = $codeline[0];
	}
	close (CODE);
	
	# Read fasta alignment with sequence codes and get the alignment with species name
	local $/ = '>';
	open ALN, "$path/$gene/MSA.PRANK.PROT.aln" or die $!;
	my @aln = <ALN>;
	close (ALN);
	shift @aln;
	
	my %Aln;
	foreach (@aln){
		
		my @alnline = split "\n", $_;
		if ($alnline[-1] eq '>'){pop @alnline;}
		my $name = shift @alnline;
		my $seq = join '', @alnline;
		$Aln{$Codes{$name}} = $seq; # Make my hash
	}
	return (\%Aln);
}


print 'done';
