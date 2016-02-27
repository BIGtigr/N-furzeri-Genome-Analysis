# This is to get the longest protein sequence for each protein coding gene.
#
# It reads the ids of filtered genes downloaded from Ensembl. It also reads all the 
# protein sequences and selectes the longest one if there are multiple proteins
# for a particular gene id. Then for each filtered gene id just print the longest 
# sequence with ids in a new file.
#
# The output file for this one will be used for BLAST, phylogeny and all other analysis.

use strict;
use warnings;

# change the input and output file name here for all 19 organisms
my $biomartfile = '2_gene_details_biomart/biomart_files_filtered/celegans_gene_ensembl_biomaRt_v75_20140403_2.txt';
my $seqfile = '1_ensembl_75_ftp_20140402/Caenorhabditis_elegans.WBcel235.75.pep.all.fa';
my $outfile = '3_ensembl_75_seqs_filtered/celegans_longest_proteins.txt';

# open file for all protein coding gene properties.
# This is donlaoded from biomart and has the gens I want to include in my analysis
# -----------------------------------------------------------------------------------
open FH, $biomartfile or die $!;
my @allPC = <FH>;
shift @allPC;

# make hash for all ensembl ids as keys -- and all properties as values
my %allSeqs;
foreach (@allPC){
	
	my @line = split "\t",$_;
	$allSeqs{$line[0]} = \@line;
}

# -----------------------------------------------------------------------------------
# open human proteins FASTA files and read seq-by-seq
local $/ = '>'; # Change input record separator to have one sequence in one array element 
open FH2, $seqfile or die $!;
my @seqs = <FH2>;
shift(@seqs);

# make sequence hash with Ensembl ids as keys and value contains an array with all protein sequence -- Then I will select the longest one
# I am appending the protein id to the sequence and later on I will filter the longest sequence
my %seqHash; # hash to hold sequences
foreach (@seqs){
	
	my @lines = split "\n", $_;
	if ($lines[-1] eq '>'){pop @lines}; # remove the > from sequences
	my $header = shift (@lines); # 1st line is header
	
	# get ensembl id and protein ids from the header in downloaded file
	$header =~/^(.+)pep\:.+gene\:(.+\d) transcript\:.+/g;
	my $protId = $1; my $ensId = $2;
	
	my $seq = join '', @lines; # join fasta seq chunks in one line
	
	# append protein id to sequence
	$seq = $protId.'~'.$seq;
	
	# push all the proteins for this ensembl id into an array
	push @{$seqHash{$ensId}}, $seq;
}

# -----------------------------------------------------------------------------------
open FH3, ">$outfile" or die $!;

foreach my $ens (keys %seqHash){
	
	# Only if it exists in filtered protein coding genes file
	if (exists $allSeqs{$ens}){
		
		# sort @{$seqHash{$ens}} (which contains all the proteins for one genes) on the basis of their length
		@{$seqHash{$ens}} = sort {length($a) <=> length($b)} @{$seqHash{$ens}};
		
		# split the protein id and sequence for the longest protein. If two proteins would have same lengths, the last one would be picked.
		my ($prot, $seq) = split '~', ${$seqHash{$ens}}[-1];
		
		print "$ens\t$prot\t"; # just for fun!
		print length $seq,"\n";
		
		
		# print Ensembl and protein id as header and sequence
		print FH3 ">$ens|$prot\n$seq\n";
		#print "$prot\n";
	}
}

print "done";