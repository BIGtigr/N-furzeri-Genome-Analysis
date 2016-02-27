# To get one to one orthologs between killifish and other organisms.
# Again - I filter based on proper genes
#
# This is based on the file that has Ids and BBH's for all the genes <nfur_All_BBH_Ids.txt>
# This has a header and the different columns correspond to different organisms. I will get the 
# columns I want based on grep command.

use strict;
use warnings;

# Outfile for all orthologs from others -> killifish
open OUT, ">Ortholog_Counts_One-to-One.txt" or die $!;

# Hash for the other organisms manually created
# Key => Id pattern for the organism; Value => organism name
# Since the heading in the file matcahes this pattern I can use it to print the name of the file
my %Genomes = ( 'xmac_BH' => 'Platyfish',
				'trub_BH' => 'Fugu',
				'tnig_BH' => 'Tetraodon',
				'gacu_BH' => 'Stickleback',
				'gmor_BH' => 'Cod',
				'olati_BH'=> 'Medaka',
				'drer_BH' => 'Zebrafish',
				'lchal_BH'=> 'Coelacanth',
				'hsap_BH' => 'Human',
				'mmus_BH' => 'Mouse',
				'cfam_BH' => 'Dog',
				'xtrop_BH'=> 'Xenopus',
				'sscr_BH' => 'Pig',
				'ggal_BH' => 'Chicken'
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


#my $allGenes = `grep -P "$id" BH_nfur_all/nfur_*_BH | cut -f1 -f2`; # get a list of ids wrt killifish for the current organism
#my @allgenes = split "\n", $allGenes; # process these ids to get the ones in final dataset


# Run the analysis for each organism using the hash defined above
print OUT "Organism	all genes with orthologs	genes with proper 1-2-1 orthologs	genes with IMpropoer 1-2-1 orthologs\n";

foreach my $column (2..20){ # foreach column 2 to 20 in the BBH file
	
	my $allGenes = `cut -f1 -f$column ../nfur_All_BBH_Ids.txt`; # get a list of ids wrt killifish for the current column -- This gets the a two column string that i process below. The first column is always killifish and the second one is the other organism
	
	my @allgenes = split "\n", $allGenes; # get these ids to filter the ones in final dataset
	my $head = shift @allgenes;           # Reomve the header to get the gene name so that I have proper 1-2-1 ortholog counts
	$head =~s/\n//g;
	#print "$head\n";
	my ($kf, $org) = split "\t", $head, 2; # isolate the organism name to print in output file below

	if (exists $Genomes{$org}){ # I need the counts only for vertebrates - If it's one of the column I want
	
			print "$Genomes{$org}\n";
			my $totalCount = 0; # To count the total and the unique genes
			my $count= 0;       # count improper matches
			my %uniqueCount;    # hash to hold unique counts

			foreach (@allgenes){ # foreach of the id pair
				
				my @line = split "\t", $_; # get the killifish and other id
				#print "@line\n";
				map {$_=~s/\n//g;} @line; # remove \n
				
				if ((scalar @line > 1) && ($line[1] ne '') && ($line[1] !~/\*/g)){ # grep just returns the killifish id if there is no id in the next column so i am putting 3 conditions :
				                                                                   # The length must be 2 so I know there is an id for other organism
				                                                                   # The id should not be null and should not have a * so I know this is the BBH	
					$line[0] =~s/-mRNA-\d+//g; # reomve extra things to match
					#print "$line[0]\t$line[1]\n";	
				
					if (exists $FinalList{$line[0]}){ # see if its there in my final dataset
						$totalCount++;
						$uniqueCount{$line[0]} = ''; # This will count unique lines
					}
					else { # These are the fish Ids that were not a part of the final analysis -- If you ant to print them
						#print "$line[0]\t$line[1]\n";
						$totalCount++;
						$count++;
					}
				}
			}
			print OUT "$Genomes{$org}	$totalCount\t";
			print OUT scalar keys %uniqueCount,"\t$count\n";
			
	}
}


print "done\n";
