# I have to download the cds sequences for all the filtered protein sequences
# 
# This is to generate a file that has all the filtered protein ids that will
# be used by biomaRt in R to get the cds sequence (except Nfur). Since I already
# have cds for Nfur from our analysis.
# 
# This file will be used by my R script now
#

use strict;
use warnings;

open OUT, ">prot_id_file.txt" or die $!; # Output files having all the Ids for 19 organisms

foreach (<..\/3_ensembl_75_seqs_filtered\/*.txt>){ # Read the filtered Id files
	
	print "$_\n";
	$_=~/.+\\(.+\.txt)/g;
	my $name = $1; # get the organism name
	
	open FILE, $_ or die $!;
	my @file = <FILE>; # read the file
	
	print OUT "$name\t";
	foreach (@file){ # for each id -- separate and print the protein id
		
		if ($name ne 'nfurzeri_longest_proteins.txt' && $_=~/^\>/g){
			
			my ($gene, $prot) = split '\|', $_, 2;
			map {$_=~s/\>|\n//g} ($gene, $prot);
			
			print OUT "$prot\t";	
		}
	}
	print OUT "\n";
}

print "done";