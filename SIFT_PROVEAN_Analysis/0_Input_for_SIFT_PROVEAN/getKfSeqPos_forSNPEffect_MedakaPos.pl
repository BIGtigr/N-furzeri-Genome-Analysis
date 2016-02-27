# This has been modified to get the medaka position of the 
# selected residues.
use strict;
use warnings;

# Input-Output pairs
print OUT "Gene	P-value	Alignment position	Sequence position	Probability of selection	Killifish residue	Other fishes residues\n";

# ----------------------------

#open FH, 'selected_aging_genes.txt' or die $!; # 19 aging related genes
#open OUT, '>Selecetd_sites_aging_genes_MedakaPos.txt' or die $!; # For aging genes

# ----------------------------

#open FH, 'selecetd_genes_prank_p0.05_aln-pos_mhc.txt' or die $!; # Input all selected genes
#open OUT, '>all_selected_genes_mhc_MedakaPos_Filtered.txt' or die $!; # Outfile for all 249 selected genes

#open OUT, '>all_selected_genes_mhc_MedakaPos_All.txt' or die $!; # All genes just to check -- with line 33 commented -- NOT USED
# ----------------------------

open FH, 'Selecetd_aging_genes_20150725.txt' or die $!; # aging related genes after adding CGNL1_1_3
open OUT, '>Selecetd_sites_aging_genes_MedakaPos_20150725.txt' or die $!; # Added CGNL1_1_3 here
# ----------------------------

my @file = <FH>;
close (FH);
shift @file;

my $path = '/Users/Param/Work/Fish_genome/Selection_PAML/branch-site/alignments_prank';

foreach (@file){  # foreach gene
	
	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
#	if ($line[0] eq 'RAF1'){ # test for one gene
	
		my @allsites = split ',', $line[20];	# all sites -- *CHECK THE COLUMN NUMBER HERE*
		
		# get alignments
		my $alnRef = getAln($line[0]);
		my %Alignment = %$alnRef;
		
		if (exists $Alignment{'Medaka'}){ # All alignments may not have medaka sequence -- so I do it for only the ones that have medaka sequence 
		
			foreach (@allsites){
				
				my @pos = split " ", $_; # positions and probabilities
					#print "$pos[0]\t";
				#print substr $Alignment{'Killifish'}, ($pos[0]-1), 1;
				#print "\n";
				
				# get the position in Medaka sequence 
				my $kfSeq =  substr $Alignment{'Medaka'}, 0, $pos[0]; # substring from alignment starting from 0 to the current position
				$kfSeq =~s/-//g;                                      # replace - from this so that we have only proper sequence
				#print length $kfSeq;                                
				#print "\n";
				my $kfPos = length $kfSeq;							 # Since it is the sequence, length is the medaka seq position
				
				print OUT "$line[0]\t$line[6]\t$pos[0]\t$kfPos\t$pos[2]\t";
				print OUT substr $Alignment{'Medaka'}, ($pos[0]-1), 1; # killifish residue
				print OUT "\t";
				my %unqMut; # To get unique amino acid in other fish -- here, only killifish
				foreach (keys %Alignment){
					if ($_ eq 'Killifish'){
						
						# This part was to get unique amino acids if there was more than one fish --- now it has no value since I only want killifish
						my $otfish = substr $Alignment{$_}, ($pos[0]-1), 1;
						print OUT "$otfish";
						$unqMut{$otfish} = '';
					}
				}
				print OUT "\t";
				
				# print the mutation
				print OUT substr $Alignment{'Medaka'}, ($pos[0]-1), 1; # Medaka residue
				print OUT "$kfPos";
				print OUT keys %unqMut;
							
				print OUT "\n";
			}
		}		
#	} # end test for one gene
}		


sub getAln {
	
	my $gene = shift;
	
	# get sequence codes
	open CODE, "$path/$gene/Seqs.Codes" or die $!;
	my %Codes;
	foreach (<CODE>){
		
		my @codeline = split "\t", $_;
		map {$_=~s/\n//g} @codeline;		
		#print "$codeline[0]\t$codeline[1]\n";
		$Codes{$codeline[1]} = $codeline[0];
	}
	close (CODE);
	
	local $/ = '>';
	open ALN, "$path/$gene/MSA.PRANK.PROT.aln" or die $!;
	my @aln = <ALN>;
	close (ALN);
	shift @aln;
	
	my %Aln;
	#print "$aln[0]\n";
	foreach (@aln){
		
		my @alnline = split "\n", $_;
		if ($alnline[-1] eq '>'){pop @alnline;}
		my $name = shift @alnline;
		my $seq = join '', @alnline;
		#print "$Codes{$name}\n";
		#print "$seq\n";
		$Aln{$Codes{$name}} = $seq;
	}
	return (\%Aln);
}


print 'done';