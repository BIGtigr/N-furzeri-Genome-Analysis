# This is to get the number of genes from all other organisms that have at least one
# ortholog in killifish. I have to get all the fish genes with orthologs in a particular 
# genome and then filter depending on the final genes in our annotation.
# 
# I use the filtered best hits for each genome and get all the genes and their fish orthologs
# using grep. Then I look how many are in the final list and count them. It prints the ones that are 
# not in the fianl set. Generally they are only a few.
#
use strict;
use warnings;

# OUtfile for all orthologs from others -> killifish
open OUT, ">Ortholog_Counts_Others-to-Killifish.txt" or die $!;

# Hash for the other organisms manually created
# Key => organism name; Value => The file name in my analysis
# I will use this file name to get the genes below for all organisms
my %Genomes = ( 'Platyfish' => 'xmac',
				'Fugu' => 'trub',
				'Tetraodon' => 'tnig',
				'Stickleback' => 'gacu',
				'Cod' => 'gmor',
				'Medaka' => 'olati',
				'Zebrafish' => 'drer',
				'Coelacanth' => 'lchal',
				'Human' => 'hasp',
				'Mouse' => 'mmus',
				'Dog' => 'cfam',
				'Xenopus' => 'xtrop',
				'Pig' => 'sscr',
				'Chicken' => 'ggal'
);

# These are the total number of genes in each organism in my analysis; manually calculated and can be checked intable S3
my %geneCounts = (
				'Killifish'	=>   '28494',
				'Zebrafish'	=>   '25625',
				'Cod'	=>       '20095',
				'Stickleback' => '18342',
				'Medaka' => 	 '17445',
				'Fugu' =>	     '18510',
				'Tetraodon' =>	 '19589',
				'Platyfish' =>	 '20389',
				'Coelacanth' =>	 '19569',
				'Dog' =>	     '19574',
				'Chicken' =>	 '14468',
				'Human' =>	     '20314',
				'Mouse' =>	     '22559',
				'Pig' =>	     '19429',
				'Xenopus' =>	 '18442',
				'Ciona1' =>	     '11806',
				'Ciona2' =>	     '11616',
				'Sea urchin' =>	 '28842',
				'Worm' =>	     '20529',
				'Fly' =>	     '13851'
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
print OUT "Organism\tUnique genes with proper orthologs\tUnique genes without orthologs\n";
foreach my $orgname (keys %Genomes){ # foreach organism

#if ($orgname eq 'Mouse'){ # test for one organism
	
	my $genome = $Genomes{$orgname}; # get the organism name 
	my $allGenes = `grep "GapFilledScaffold" ../../2_blast/blast_output/$genome | cut -f1 -f2`; # get a list of ids wrt killifish for the current organism
	
	my @allgenes = split "\n", $allGenes; # process these ids to get the ones in final dataset
	#print scalar @allgenes; # 420837
	
	my %uniqueCount; 

	foreach (@allgenes){ # foreach of the kilifish id
		
		my @line = split "\t", $_;
		map {$_=~s/\n//g;} @line;
		
		$line[1] =~s/-mRNA-\d+//g;
		#print "$line[1]\n";	
		
		if (exists $FinalList{$line[1]}){ # see if its there in my final dataset			
			$uniqueCount{$line[0]} = ''; # $line[0] is the id for the other organism
		}
		else { # These are the fish Ids that were not a part of the final analysis -- If you want to print them
			#print "$line[0]\t$line[1]\n";
		}
	}
	
	print OUT "$orgname\t";
	print OUT scalar keys %uniqueCount,"\t";
	print OUT eval ($geneCounts{$orgname} - (scalar keys %uniqueCount)),"\n";
	
	#print join "\n", keys %uniqueCount;

#} # end test for one organism

}

print "done\n";
