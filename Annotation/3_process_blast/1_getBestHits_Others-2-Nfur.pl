# To get the best N. furzeri hit for every gene in all the 19 organisms
# I read the headers from protein sequence filea and then get the best 
# N. furzeri hit for each organism using grep.
#
# I change the blast output and protein coding seq file for each organism
# and run it one by one for all organisms. This file is an example for C. elegans
#
# Results are copy pasted in a new file.


use strict;
use warnings;

local $| = 1;

# ------------------------------ CHANGE THESE FOR EACH ORGANISM ------------------------------------
my $org = '../2_blast/blast_output/cele'; # the blast output file
my $allHeaders = `grep '>' ../1_sequence_collection/3_ensembl_75_seqs_filtered/celegans_longest_proteins.txt`; # the sequence file
# ----------------------------------------------------------------------------------------

# get all the gene ids in an array
my @headers = split '>', $allHeaders;
#print @headers[0..5];
shift @headers;

map {$_=~s/\r\n//g} @headers; # note the imp difference between this and windows style
map {$_=~s/\|/\\\|/g} @headers; # replace | with \| because | doesnt work in grep

my $count = 0;

foreach my $gene (@headers){ # for each gene id
	
	$count++;
	#print "$org\t$count\n";
	
	$gene =~s/^\t|\t$|^\s+|\s+$|\r\n//g;
	
	# Get the best hit for the current Id. I do grep with the current id and N furzeri id and get the 
	# NR == 1 so it only gets one row -- that would be the best N furzeri hit for the current $gene.
	print `grep -P "^$gene\\t.+GapFilledScaffold" $org | awk 'NR==1' >> $org\'_BH\'`;
	
	# *** This will create an output file with _BH appended in the blast_output directory
}

print "done";
