# This one is to combine the NR BLAST hit results and the all-against-all output file
# I will read the output file for all-against-all blast and see if it has an NR hit. If yes, 
# just pront the description and teh query coverage from NR blast.

use strict;
use warnings;

# OUtput file in the parent folder
open OUT, '>../nfur_All_BBH_Symbol_with_nr.txt' or die $!;

# The processed NR result file -- make a hash
# Key => Nfur Id, value => NR hit line
open FH, '4_Unique_nfur-ids_nr-hit_with-description.txt' or die $!;
my %NR;

foreach (<FH>){
	
	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
	$NR{$line[0]} = \@line;
}

# For each line in BBH file
open FH2, '../nfur_All_BBH_Symbol.txt' or die $!;

foreach (<FH2>){

	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
	if (exists $NR{$line[0]}){ # If its in the NT hit file -- print the description and coverage
		print OUT join ("\t", @line), "\t${$NR{$line[0]}}[2]\t${$NR{$line[0]}}[13]\n"; # ${$NR{$line[0]}}[2] is the description and ${$NR{$line[0]}}[13] is the coverage pf the query
	}
	else {		
		print OUT join ("\t", @line), "\t\t\n"; # If it's not in NR -- just print the stuff and leave the two columns blank
	}
}

print "done";