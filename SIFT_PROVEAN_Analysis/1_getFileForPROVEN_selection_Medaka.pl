# 20150527

# This is for medaka position. With following differences
# 1. Need to get Medaka genes -- In the file I have killifish 1:1 orthologs 
# 2. That there can only be one amino acid in each case not many as theer were previously. So this simplifies the case and I can get rid of some of the lines.
# 3. There can be spaces in Medaka so I need to take care of that too.

# run it one by one for all sites and sites in aging genes

use strict;
use warnings;
use List::MoreUtils qw(uniq);

# OUTFILE ----------------------------------------------------------------------------------------------------------------------
#open OUT, '>1_files_for_analysis/all_sites_under_pos_selection_MEDAKA.txt' or die $!;
open OUT, '>1_files_for_analysis/all_sites_under_pos_selection_aging_MEDAKA.txt' or die $!;
print OUT "KfGene	MedakaGene	MedakaSymbol	ProteinSequence	AllMutations\n";

# READ all the selected sites file, filter it and make a hash ------------------------------------------------------------------------------------
#open SITES, '0_Input_for_SIFT_PROVEAN/all_selected_genes_mhc_MedakaPos_Filtered.txt' or die $!; # all 249 selected
open SITES, '0_Input_for_SIFT_PROVEAN/Selecetd_sites_aging_genes_MedakaPos.txt' or die $!;                 # Aging

my @sites = <SITES>;
shift @sites;

my %siteHash;

foreach (@sites){ # foreach site

	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
	$line[-1] =~ /([a-z,\-]+)(\d+)(.+)/gi; # get the position etc ... >20150602 I modified it slightly to include the - for a few genes that may have spaces in the first letter
	#print "$line[0]\t$line[-1]\t$1\t$2\t$3\n";
	my $mdk = $1; my $num = $2; my $kf = $3;
	
	if ($mdk ne '-' && $kf ne '-' && $kf ne $mdk && $mdk ne 'X' && $kf ne 'X'){ # dont print a site if its gap, same residue or X
		
		push @{$siteHash{$line[0]}}, $line[-1]; # hash with gene name as key and all mutation in an array as value
		#print "$line[-1]\n";
	}
	#else {print "$_";}
	#print "\n";
}
#print "@{$siteHash{'CREBBP_2_2'}}"; # test

# Open all the protein sequence files for medaka --------------------------------------------------------------------------------------------
# This has proetin ids and gene id in header and the entir sequence in the next line.
local $/ = '>';
open SEQS, '../Annotation/1_sequence_collection/3_ensembl_75_seqs_filtered/olatipes_longest_proteins.txt' or die $!;
my @seqs = <SEQS>;
shift @seqs;
#print $seqs[0];

my %Seqs;

foreach (@seqs){
	
		my @lines = split "\n", $_;
		if ($lines[-1] eq '>'){pop @lines}
		
		#print "$lines[0]\t";
		$lines[0] =~/(ENSORLG\d{11}).+/g;
		#print "$1\n";
		$Seqs{$1} = $lines[1]; # Medaka gene id and medaka sequence
}
#print $Seqs{'SCRT1A_1_2'};

local $/ = "\n";
# Killifish id and the corresponding Medaka ortholog in my results ----------------------------------------------------------
open KFTOMD, '../Annotation/3_process_blast/Bi-Directional_Best_Hits_with_NR_and_Seqs.txt' or die $!; # file with killifish and medaka names 
# medaka column is 13 killifish column in 27
# I need to check if there is no 2 killifish genes with same name
my @kffile = <KFTOMD>;
shift @kffile;

my %kfNumber; my %kf2Md;

foreach (@kffile){
	
	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
	if ($line[27] ne ''){
		
		# replace brackets etc
		$line[27] =~s/ \(/\_/g;
		$line[27] =~s/ of /\_/g;
		$line[27] =~s/\)//g;

		#print "$line[27]\n";
		push @{$kf2Md{$line[27]}}, $line[13];
		
	}
		
}

# Read medaka symbol to Id file and create a hash ---------------------------------------------------------------------------
open MDSTOID , '../Annotation/1_sequence_collection/2_gene_details_biomart/biomart_files/olatipes_gene_ensembl_biomaRt_v75_20140403' or die $!;
my @mdsymbol = <MDSTOID>;
shift @mdsymbol;

my %MedakaSymbols;

foreach (@mdsymbol){
	
	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
	# craeta hash with symbols to ids
	if ($line[1] ne ''){
		push @{$MedakaSymbols{$line[1]}}, $line[0];
	}
	else {push @{$MedakaSymbols{$line[0]}}, $line[0];} # If there is no symbol push the Id
		
}

# get the final file with all sites -----------------------------------------------------------------------------------------

foreach (keys %siteHash){
		
	print OUT "$_\t";
	# do some checks for medaka
	if (not exists $kf2Md{$_}){die "$_ not found!!!";} # If the kf symbol does not exist in the annotation file, die 
	elsif (scalar @{$kf2Md{$_}} > 1) {die "$_ has more than 1 names in NR file !!!";} # If the symbol is listed multiple times in the file, die
	elsif (not exists $MedakaSymbols{${$kf2Md{$_}}[0]}) {die "${$kf2Md{$_}} not found in Medaka seqs !!!"} # ${$kf2Md{$_}}[0]} is the medaka symbol -- if its not there in the medaka file, die 
	elsif (scalar @{$MedakaSymbols{${$kf2Md{$_}}[0]}} > 1){die "more than 1 medaka ids for the same symbol !!!"} # If there are > 1 ids for this symbol, die
	else { # All is well
		print OUT "${$kf2Md{$_}}[0]\t${$MedakaSymbols{${$kf2Md{$_}}[0]}}[0]\t";
		#print scalar @{$kf2Md{$_}}
	}
	
	# Get the sequence	
	if (exists $Seqs{${$MedakaSymbols{${$kf2Md{$_}}[0]}}[0]}){print OUT "$Seqs{${$MedakaSymbols{${$kf2Md{$_}}[0]}}[0]}\t";}
	else {die "Seq for $_ not found !\n"} # if the sequence is not found, die

	# print sites
	print OUT join (',', @{$siteHash{$_}});
	
	print OUT "\n";
}







print "done";


