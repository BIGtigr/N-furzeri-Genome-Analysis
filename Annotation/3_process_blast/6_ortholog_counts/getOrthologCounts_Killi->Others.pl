# This is to get the number of genes in killifish -> to all other organisms that have at least one 
# ortholog in other organisms. I have to get all the fish genes with orthologs in a particular 
# genome and then filter depending on the final genes in our annotation.
# 
# I use the filtered best hits for each genome and get all the genes and their fish orthologs
# using grep. Then I look how many are in the final list and count them. It prints the ones that are 
# not in the fianl set. Generally they are only a few.
#

use strict;
use warnings;

# Outfile for all orthologs from others -> killifish
open OUT, ">Ortholog_Counts_Killifish-to-Others.txt" or die $!;

# Hash for the other organisms manually created
# Key => organism name; Value => Id pattern for the organism
# I will use this file name to get the genes below for each organism
my %Genomes = ('Human'   => 'ENSG\d{11}',
               'Dog'   => 'ENSCAFG\d{11}',
               'Zebrafish'   => 'ENSDARG\d{11}', 
               'Stickleback'   => 'ENSGACG\d{11}',  
               'Chicken'   => 'ENSGALG\d{11}',
               'Cod'   => 'ENSGMOG\d{11}', 
               'Coelacanth'  => 'ENSLACG\d{11}', 
               'Mouse'   => 'ENSMUSG\d{11}',
               'Medaka'  => 'ENSORLG\d{11}', 
               'Pig'   => 'ENSSSCG\d{11}',  
               'Tetraodon'   => 'ENSTNIG\d{11}', 
               'Fugu'   => 'ENSTRUG\d{11}',
               'Platyfish'   => 'ENSXMAG\d{11}', 
               'Xenopus'   => 'ENSXETG\d{11}'
);

# Read the final annotataion file first 
open FH, '../../4_final_annotation/FinalSymbol_20140715.txt' or die $!;
my %FinalList;

foreach (<FH>){
	my @line = split "\t", $_;
	map {$_=~s/\n//g;} @line;
	$FinalList{$line[1]} = $line[2];
}

#print scalar keys %FinalList;


# Run the analysis for each organism iusing the hash defined above
print OUT "Organism\tall genes with orthologs\tgenes with proper orthologs\tgenes with IMpropoer orthologs\tUnique genes (Total genes - proper orthologs)\n";
foreach my $orgname (keys %Genomes){ # foreach prganism
	
#if ($orgname eq 'Human'){ # Test for one organism

	my $id = $Genomes{$orgname}; # get the id pattern
	#print "$orgname\t$id\n";
	
	my $allGenes = `grep -P "$id" ../2_best_hits_Nfur_to_others/nfur_*_BH | cut -f1 -f2`; # get a list of ids wrt killifish for the current organism
	
	my @allgenes = split "\n", $allGenes; # process these ids to get the ones in final dataset

	my $totalCount = 0; # To count the total and the unique genes
	my $count= 0;       # count if impropoer genes
	my %uniqueCount; 

	foreach (@allgenes){ # foreach of the kilifish id
		
		my @line = split "\t", $_;
		map {$_=~s/\n//g;} @line;
		
		$line[0] =~s/-mRNA-\d+//g;
		$line[0] =~s/2_best_hits_Nfur_to_others\/nfur_\d+_BH\://g; # Check this properly in other context -- it may be slightly problematic
		#print "$line[0]\n";	
		
		if (exists $FinalList{$line[0]}){ # see if its there in my final dataset			
			$totalCount++;
			$uniqueCount{$line[0]} = '';
		}
		else { # These are the fish Ids that were not a part of the final analysis -- If you want to print them
			#print "$line[0]\t$line[1]\n";
			$totalCount++;
			$count++;
		}
	}
	
	print OUT "$orgname	$totalCount\t";
	print OUT scalar keys %uniqueCount,"\t$count\t";
	print OUT eval (28494 - (scalar keys %uniqueCount)),"\n"; # unique killifish genes
#} # end test for one organism
}

print "done\n";
