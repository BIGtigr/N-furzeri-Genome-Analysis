# Thsi si to take all the selected sites as input and see if any of these ahve varian in the two MZM and one SRZ
# strains in my filteted sites. The output data has all 2009 selected site and the variation infor in any strain.
# This is to check if selected sites are variable or not. I think it will go in supp figure.

use strict;
use warnings;

# Open output file
open OUT, '>MZM-GRZ-Selection_overlap.txt' or die $!;
# Read the list and killifish positions for all selected sites
open FH, 'Selecetd_sites_filtered_prank_p05_mhc_grz-mzm-overlap.txt' or die $!;
my @file = <FH>;
close (FH);

my $head = shift @file;
$head =~s/\n//g;

print OUT  "$head\t";
print OUT  "GRZ all variable residues\tGRZ variation in selected residue\tGRZ Zygosity\t";
print OUT  "MZM all variable residues\tMZM variation in selected residue\tMZM Zygosity\t";
print OUT  "MZM0403 all variable residues\tMZM0403 variation in selected residue\tMZM0403 Zygosity\n";

# REad the variation files and make 2d hash for each having
# Key => Gene name and variant position
# Value => Vairant site
# ------------------------------  MZM0703 variation --------------------------------
open MZM, '3_variant_files_non-syn_filtered/NS_Coding_P0GMA_snps_MZM0703_LL_Clean.txt' or die $!;
my @mzm = <MZM>;
close (MZM);
shift @mzm;
my %Mzm; my %MzmZygosity;

foreach (@mzm){
	
	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
	if ($line[5] ne ''){
		
		$line[3] =~/.(\d+)./g;
		#print OUT  "$line[3]\t$1\t$line[5]\n";
		$Mzm{$line[5]}{$1} = $line[3];
		$MzmZygosity{$line[5]} = $line[6];
	}
}

# ------------------------------  GRZ variation (parent of the cross) --------------------------------
open GRZ, '3_variant_files_non-syn_filtered/NS_Coding_P0GFA_snps_GRZ_SL_Clean.txt' or die $!;
my @grz = <GRZ>;
close (GRZ);
shift @grz;
my %Grz; my %GrzZygosity;

foreach (@grz){
	
	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
	if ($line[5] ne ''){
		
		$line[3] =~/.(\d+)./g;
		#print OUT  "$line[3]\t$1\n";
		$Grz{$line[5]}{$1} = $line[3];
		$GrzZygosity{$line[5]} = $line[6];
	}
}

# ------------------------------  MZM0403 variation --------------------------------
open MZM2, '3_variant_files_non-syn_filtered/NS_Coding_snps_MZM0403_Clean.txt' or die $!;
my @mzm2 = <MZM2>;
close (MZM2);
shift @mzm2;
my %Mzm0403; my %Mzm0403Zygosity;

foreach (@mzm2){
	
	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
	if ($line[5] ne ''){
		
		$line[3] =~/.(\d+)./g;
		#print OUT  "$line[3]\t$1\t$line[5]\t$line[6]\n";
		$Mzm0403{$line[5]}{$1} = $line[3];
		$Mzm0403Zygosity{$line[5]} = $line[6];
	}
}

# Get the file with variation at any selected position
foreach (@file){ # foreach selected site
	
	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
	print OUT  join ("\t", @line), "\t";
	
	# GRZ -------------------------------------------------------------------
	if (exists $Grz{$line[0]}){ # If the gene is there in vaiation data
		foreach (keys %{$Grz{$line[0]}}){print OUT  "${$Grz{$line[0]}}{$_},"} # print OUT  all variant sites for this
	}
	else {print OUT  '';}
	print OUT  "\t";
	
	if (exists $Grz{$line[0]}{$line[2]}){print OUT  $Grz{$line[0]}{$line[2]};} # Check if the variation site is same as selected site
	else {print OUT  '';}
	print OUT  "\t";
	
	if (exists $GrzZygosity{$line[0]}){print OUT  $GrzZygosity{$line[0]};} # print OUT  zygosity data
	else {print OUT  '';}
	print OUT  "\t";
	
	# MZM0703 -------------------------------------------------------------------
	if (exists $Mzm{$line[0]}){
		foreach (keys %{$Mzm{$line[0]}}){print OUT  "${$Mzm{$line[0]}}{$_},"}
	}
	else {print OUT  '';}
	
	print OUT  "\t";
	if (exists $Mzm{$line[0]}{$line[2]}){print OUT  $Mzm{$line[0]}{$line[2]};}
	else {print OUT  '';}
	print OUT  "\t";
	
	if (exists $MzmZygosity{$line[0]}){print OUT  $MzmZygosity{$line[0]};}
	else {print OUT  '';}
	print OUT  "\t";

	# MZM0403 -------------------------------------------------------------------
	if (exists $Mzm0403{$line[0]}){
		foreach (keys %{$Mzm0403{$line[0]}}){print OUT  "${$Mzm0403{$line[0]}}{$_},"}
	}
	else {print OUT  '';}
	
	print OUT  "\t";
	if (exists $Mzm0403{$line[0]}{$line[2]}){print OUT  $Mzm0403{$line[0]}{$line[2]};}
	else {print OUT  '';}
	print OUT  "\t";
	
	if (exists $Mzm0403Zygosity{$line[0]}){print OUT  $Mzm0403Zygosity{$line[0]};}
	else {print OUT  '';}
	
	print OUT  "\n";
	
}

print "Done\n";
