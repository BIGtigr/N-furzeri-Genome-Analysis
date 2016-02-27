use strict;
use warnings;
use List::MoreUtils qw(uniq);

# OUTFILE ----------------------------------------------------------------------------------------------------------------------
open OUT, '>1_files_for_analysis/all_sites_with_LG3-variation.txt' or die $!;
print OUT "Gene	ProteinSequence	AllMutations\n";

# READ all variant sites file from Berenice, filter it and make a hash ------------------------------------------------------------------------------------
open SITES, 'Sup_Table_S6_Significant_genes_and_SNPs_in_lifespan_QTL_LG3_peak.txt' or die $!;
my @sites = <SITES>;
shift @sites;

my %siteHash;

foreach (@sites){ # foreach site

	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
	# replace brackets etc
	#print "$line[6]\t";
	$line[4] =~s/\(/\_/g;
	$line[4] =~s/of/\_/g;
	$line[4] =~s/\)//g;	
	$line[8] =~s/\s+//g;	
	#print "$line[4]\t$line[8]\n";
	
	if ($line[8] ne 'N/A'){	
		print "$line[4]\t$line[8]\n";
		$siteHash{$line[4]} = $line[8];
	}
}

# Open all the protein sequence files --------------------------------------------------------------------------------------------
local $/ = '>';
open SEQS, '../Annotation/1_sequence_collection/0_Nfurzeri_sequences/nfurzeri_proteins_final_sline_symbol.txt' or die $!;
my @seqs = <SEQS>;
shift @seqs;
#print $seqs[0];

my %Seqs;

foreach (@seqs){
	
		my @lines = split "\n", $_;
		if ($lines[-1] eq '>'){pop @lines}
		
		# replace brackets etc
		$lines[0] =~s/ \(/\_/g;
		$lines[0] =~s/ of /\_/g;
		$lines[0] =~s/\)//g;
		
		$Seqs{$lines[0]} = $lines[1];
}
#print $Seqs{'SCRT1A_1_2'};

# get the final file with all sites -----------------------------------------------------------------------------------------

foreach (keys %siteHash){
		
	print OUT "$_\t";
	
	if (exists $Seqs{$_}){print OUT "$Seqs{$_}\t";}
	else {die "Seq for $_ not found !\n"}
	
	print OUT $siteHash{$_}, "\n";
}







print "done";

