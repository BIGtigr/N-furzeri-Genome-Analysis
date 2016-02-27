# No warnings allowed in here
# This is to parse PROVEAN results and get the information on the effect and if the site is final filtered one or not.
# Run one by one for Aging and All genes

use strict;
use warnings;

##################
# ALL GENES
#open ALLSITES, '>provean_processed/PROVEAN_all_sites_under_pos_selection_MEDAKA_SiteInfo.txt' or die $!;
#open INFILE, 'provean/PARSED_PROVEAN_all_sites_under_pos_selection_MEDAKA_2.txt' or die $!;
#open MEDAKAPOS, '../0_Input_for_SIFT_PROVEAN//all_selected_genes_mhc_MedakaPos_Filtered.txt' or die $!; # File having all Medaka sites - This is used to get the alignment position for comparison later
# AGING GENES
open ALLSITES, '>provean_processed/PROVEAN_all_sites_under_pos_selection_aging_MEDAKA_SiteInfo.txt' or die $!;
open INFILE, 'provean/PARSED_PROVEAN_all_sites_under_pos_selection_aging_MEDAKA_2.txt' or die $!;
open MEDAKAPOS, '../0_Input_for_SIFT_PROVEAN/Selecetd_sites_aging_genes_MedakaPos.txt' or die $!; # Filtered Medaka sites - This is also used to get the alignment position for comparison later

##################

# Final result file with all sites, excluded sites and proper sites -------------------------------------------------------
open SEL, '/Users/Param/Work/Fish_genome/Selection_PAML/branch-site/parse_bs_prank/prank_AlnPos_revision_filtered_Final.txt' or die $!;
my @sel = <SEL>;
shift @sel;

my %ProperSites; # has gene names and all proper sites
my %colonInNames; # This is just to incorporate the condition because these output files have colon replaced by underscores
foreach (@sel){
	
		my @line = split "\t", $_;
		map {$_=~s/\n//g} @line;

#if ($line[0] eq 'ZFYVE1_3_3'){ # This is just a test for one gene
		
		#print "$line[18]\n";
		my @sites = split '\|', $line[18]; # Column 18 in the result file has all the final filtered sites
		#print join ',', @sites,"\n";
				
		foreach (@sites){
			
			#print "$_\n";
			$_=~/(\d+) [a-z] .+/gi;

			$ProperSites{$line[0]}{$1} = $_; # key is gene name and the alignment position of the porper site
			#print "$line[0]\t$1\n";
		}
#}
		# This part is to take care of the colons replaced by underscore
		if ($line[0]=~/\:/g){
			my $name = $line[0];
			$name =~s/\:/\_/g;
			$colonInNames{$name} = $line[0];
			#print "$name\t$line[0]\n";
		}
}


# I dont need to do that twice -- could have done it in the above loop --- Anyway!
my %AllSites; # Has gene names and all sites. This is to test that all the sites are there in the proper format and nothing's wrong
foreach (@sel){
	
		my @line = split "\t", $_;
		map {$_=~s/\n//g} @line;

#if ($line[0] eq 'ZFYVE1_3_3'){
		
		#print "$line[18]\n";
		my @sites = split '\|', $line[20]; # Column 20 is all sites
		#print join ',', @sites,"\n";
				
		foreach (@sites){
			
			#print "$_\n";
			$_=~/(\d+) ([a-z|\-]) .+/gi;

			$AllSites{$line[0]}{$1} = $_;
			#print "$line[0]\t$1$2\n";
#}			
		}
}


# Read the medaka pos file for the alignment positions of the sites ----------------------------
my @medakapos = <MEDAKAPOS>;
shift @medakapos;

my %MedakaAlnPos;

foreach (@medakapos){
	
	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
	$MedakaAlnPos{$line[0]}{$line[3]} = $line[2]; # gene name and sequence position to alignment position
}


# Print in Outfile -----------------------------------------------------------------
print ALLSITES "Gene\tNo of seqs\tMutation\tScore\tEffect\tGood site?\tAlignment position\n";


# infile ---------------------------------------------------------------------------
foreach (<INFILE>){ # foreach result
	
	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;

#if ($line[0] eq 'ZFYVE1_3_3'){	# Test for a few conditions

	if (exists $colonInNames{$line[0]}){$line[0] = $colonInNames{$line[0]}} # This is to get the colon in the name back
	
	print ALLSITES join ("\t", @line),"\t";;
	
	$line[2] =~/([a-z])(\d+)[a-z]/gi;
	
	my $alnpos = $MedakaAlnPos{$line[0]}{$2}; # If this gives warnings -- it's problematic -- check it
	
	if (exists $ProperSites{$line[0]}{$alnpos}){print ALLSITES "Y\t";}
	else {print ALLSITES "N\t";}
	
	print ALLSITES "$alnpos\n";
	
	# Check if everything is right and die if not -- thsi is to check if the position is a part of all site hash, if not it means something's wrong!!
	#if (not exists $AllSites{$line[0]}{$alnpos}){die "Error at $line[0] $2\n";}

#}
}

print "done\n";
