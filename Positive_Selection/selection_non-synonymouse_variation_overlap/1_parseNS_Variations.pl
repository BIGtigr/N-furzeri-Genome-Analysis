# This is to further clean the file having the non-synonumous variations and 
# isolate a few columns that would be useful later 
#
# NO WARNINGS ALLOWED
#
use strict;
use warnings;

# Read variation file and the output one by one -------------------------------------------------------------------------------------
#open FH, '2_variant_files_non-syn/NS_Coding_P0GMA_snps_MZM0703_LL.txt' or die $!; # mzm0703 variation
#open OUT, '>3_variant_files_non-syn_filtered/NS_Coding_P0GMA_snps_MZM0703_LL_Clean.txt' or die $!;   # mzm0703 variation

#open FH, '2_variant_files_non-syn/NS_Coding_P0GFA_snps_GRZ_SL.txt' or die $!;      # grz variation
#open OUT, '>3_variant_files_non-syn_filtered/NS_Coding_P0GFA_snps_GRZ_SL_Clean.txt' or die $!;        # grz variation

open FH, '2_variant_files_non-syn/NS_Coding_snps_MZM0403.txt' or die $!;      # mzm0403 variation -- new 
open OUT, '>3_variant_files_non-syn_filtered/NS_Coding_snps_MZM0403_Clean.txt' or die $!;   # mzm0403 variation - new output

# Read gene name to Id mapping  I'll use to get the Gene Id from the symbol ---------------------------------------------------------------------------------
open IDS, '/Users/Param/Work/Fish_genome/Vertebrates/getFinalSymbols/FinalSymbol_20140715.txt' or die $!;
my %Symbol;

foreach (<IDS>){
	
	my @line = split "\t", $_;
	map {$_=~s/\n|\s+//g} @line;
	
	$line[2] =~s/\(/_/g; $line[2] =~s/of/_/g; $line[2] =~s/\)//g;
	
	$Symbol{$line[2]} = $line[1]; # Id to symbol
}
#print scalar keys %Symbol;

# Parse variations in genes and get desired columns-------------------------------------------------------------------------------
print OUT "Effect	MutType	DNA	Protein	Id	Symbol	Zygosity	Score\n"; # This is what I will keep in clean files
foreach (<FH>){
		
		# Get zygosity
		my $zygous = '';			
		if ($_=~/ABHet\=(.+?)\;/g){$zygous = "Het\t$1";}
		elsif ($_=~/ABHom\=(.+?)\;/g){$zygous = "Hom\t$1";}
		elsif ($_=~/AF\=(.+?)[\;\,]/g){
			if ($1 eq '0.50'){$zygous = "Het\t";}
			else{$zygous = "Hom\t";}
		}
		else {print "error at $_";}
		
		# Get other stuff from the brackets that follows pattern	
		if ($_=~/NON_SYNONYMOUS(.+?)\|(.+?)\|(.+?)\|(.+?)\|(.+?)\|/g){
			
			my $effect = $1; my $type = $2; my $dna = $3; my $prot = $4; my $id = $5; # assign stuff t variables
			map {$_=~s/\(|\|//g} ($effect, $type, $dna, $prot, $id); # remove if there are any extra pipes for any of them
			$effect =~s/_START|_CODING//g;
			$id =~s/(.+)_(\d+)of(\d+)_/$1\_$2\_$3/g; # remove extra stuff form the Ids to match them unambiguously later
			
			print OUT "$effect\t$type\t$dna\t$prot\t$Symbol{$id}\t$id"; # print everything -- If it gives warnings -- It's bad
			print OUT "\t$zygous\n";
		}
}

print "done";


