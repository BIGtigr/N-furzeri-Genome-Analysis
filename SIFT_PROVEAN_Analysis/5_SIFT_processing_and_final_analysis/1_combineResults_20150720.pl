# 20150601
# To combine and make one file. MEDAKA comparison is reported in the paper
#
# *** Remember to change the column number for Medaka
#
# *** NO WARNINGS ALLOWED
#
# Run it one by one for each output
# 
# The idea here is to combine the SIFT and provean file into one and also get the information about their prediction, scores and sequence/alignment position
# I combine sites based on gene anme and alignment position.

use strict;
use warnings;

my $column = 4;

# FOR AGING GENES UNDER SELECTION --- MEDAKA COMPARISON
open ALLSEL, '../1_files_for_analysis/all_sites_under_pos_selection_aging_MEDAKA.txt' or die $!; # All aging sites under positive selection
open SIFT, 'medaka_aging/Positive_selection_AGING_Medaka_sift_SiteInfo.txt'; # SIFT prediction for all aging related genes
open PROVEAN, '../3_PROVEAN_results/provean_processed/PROVEAN_all_sites_under_pos_selection_aging_MEDAKA_SiteInfo.txt'; # All aging related genes
open OUT, '>AGING_genes_under_selection_MEDAKA_SIFT+PROVEAN.txt' or die $!;

# FOR ALL GENES UNDER SELECTION --- MEDAKA COMPARISON
#open ALLSEL, '.../1_files_for_analysis/all_sites_under_pos_selection_MEDAKA.txt' or die $!; # All sites under positive selection
#open SIFT, 'medaka_selection/Positive_selection_ALL_Medaka_sift_SiteInfo.txt'; # SIFT prediction for all selected genes
#open PROVEAN, '../3_PROVEAN_results/provean_processed/PROVEAN_all_sites_under_pos_selection_MEDAKA_SiteInfo.txt';  # PROVEAN prediction for all selected genes
#open OUT, '>All_genes_under_selection_MEDAKA_SIFT+PROVEAN.txt' or die $!;



# Raed the file with all the sites -------------------------------------
my @allsites = <ALLSEL>;
shift @allsites;

my %AllSites;
my %MedakaNames;
foreach (@allsites){
	
	#print "$_";
	my @line = split "\t", $_;
	map {$_=~s/\n//g;} @line;
	
	#print "$line[$column]\n";                               # 
	my @sites = split ',', $line[$column];                   # THIS COLUMN NUMBER WOULD BE 2 FOR GRZ, 4 FOR MEDAKA
 	map {$_=~s/\s+//g;} @sites;                              # 

	@{$AllSites{$line[0]}} = @sites;
	
	if ($column == 4){ # If it's medaka sequence also get the Medaka gene and Id for reference
		$MedakaNames{$line[0]} = "$line[1]\t$line[2]";
	}
	
}
#print "@{$AllSites{'ADAT2'}}";

# Read SIFT output file -------------------------------------------------
my @sift = <SIFT>;
my $sifthead = shift @sift;
chomp $sifthead;

my %Sift;

foreach (@sift){
	
	#print "$_";
	my @line = split "\t", $_;
	map {$_=~s/\n//g;} @line;
	#print "$line[0]\n";
	$Sift{$line[0]}{$line[1]} = [@line];	
}

# Read PROVEAN output file -------------------------------------------------

my @provean = <PROVEAN>;
my $provhead = shift @provean;
chomp $provhead;

my %Provean;

foreach (@provean){
	
	#print "$_";
	my @line = split "\t", $_;
	map {$_=~s/\n//g;} @line;
	
	$Provean{$line[0]}{$line[2]} = [@line];
}
#print @{$Provean{'IL1RAPL2_1_5'}{'G241T'}};

# Combine and print to a file ----------------------------------

print OUT "Gene\t$sifthead\t$provhead\n";
foreach my $gene (keys %AllSites){

	foreach (@{$AllSites{$gene}}){
	
		print OUT "$gene\t";
				
		if (exists $Sift{$gene}){
			
			if (not exists $Sift{$gene}{$_}){die "Error! $gene $_ not found in SIFT prediction\n";}
			print OUT join ("\t", @{$Sift{$gene}{$_}}),"\t";
		}
		else {print OUT "\t\t\t\t\t\t";}
		if (exists $Provean{$gene}){

			if (not exists $Provean{$gene}{$_}){die "Error! $gene $_ not found in provean prediction\n";}			
			print OUT join ("\t", @{$Provean{$gene}{$_}});
		}
		else {print OUT "\t\t\t\t\t\t";}
		
		
		if ($column == 4){print OUT "\t$MedakaNames{$gene}";} # print medaka names if its medaka
 		print OUT "\n";
	}
}


print "done";







