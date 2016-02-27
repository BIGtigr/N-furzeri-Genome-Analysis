# After combining aging+longevty map we now have many more variations and I need to run SIFT on these
# So I am checking the ones that are new and will only run those and then combine all.
# 
# I am using the new file <2015-23-07_Aging_Genes_With_NS_var_and_Sites.parsed.txt> that has NS variations zin GRZ sequence given by Nerenice
#
# NO warnings allowed
#
use strict;
use warnings;
use List::MoreUtils qw(uniq);

# OUTFILE ----------------------------------------------------------------------------------------------------------------------
open OUT, '>1_files_for_analysis/all_sites_with_ns-variation_20150723.txt' or die $!;
print OUT "Gene	ProteinSequence	AllMutations\n";

# READ all variant sites file from Berenice, filter it and make a hash ------------------------------------------------------------------------------------
open SITES, '2015-23-07_Aging_Genes_With_NS_var_and_Sites.parsed.txt' or die $!;
my @sites = <SITES>;
#shift @sites; # no header in this file

my %siteHash;

foreach (@sites){ # foreach site

	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
	# replace brackets etc from the 7th column i.e. gene symbol. I'll use it to get the sequences
	#print "$line[7]\t";
	$line[7] =~s/\(/\_/g; 
	$line[7] =~s/of/\_/g;
	$line[7] =~s/\)//g;	
	#print "$line[7]\t$line[5]\n";
		
	push @{$siteHash{$line[7]}}, $line[5]; # column 5 is non synonymous variation
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

