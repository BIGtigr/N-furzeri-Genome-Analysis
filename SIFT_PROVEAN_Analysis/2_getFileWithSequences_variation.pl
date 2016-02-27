use strict;
use warnings;
use List::MoreUtils qw(uniq);

# OUTFILE ----------------------------------------------------------------------------------------------------------------------
open OUT, '>1_files_for_analysis/all_sites_with_ns-variation.txt' or die $!;
print OUT "Gene	ProteinSequence	AllMutations\n";

# READ all variant sites file from Berenice, filter it and make a hash ------------------------------------------------------------------------------------
open SITES, 'non-GRZ_non_synonymous_variations.txt' or die $!;
my @sites = <SITES>;
shift @sites;

my %siteHash;

foreach (@sites){ # foreach site

	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
	# replace brackets etc
	#print "$line[6]\t";
	$line[6] =~s/\(/\_/g;
	$line[6] =~s/of/\_/g;
	$line[6] =~s/\)//g;	
	#print "$line[6]\t$line[5]\n";
		
	push @{$siteHash{$line[6]}}, $line[5];
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
	
	print OUT join (',', @{$siteHash{$_}}), "\n";
}







print "done";

