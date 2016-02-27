# This is to just get the killifish residue in the medaka file to include it
# in the supplementary file in paper so that we have a reference in the killifish
# file too.
#
# I also get another column with medaka residue residue and position just for the 
# sake of supp info
#

use strict;
use warnings;

# Files ------------------------------------------------------------------
#open OUT, ">All_genes_under_selection_MEDAKA_SIFT+PROVEAN_GrzPos.txt" or die $!;     # outfile with killifish residue pasted at the end
#open GRZ, 'All_genes_under_selection_GRZref_SIFT+PROVEAN.txt' or die $!;     # GRZ file
#open MEDAKA, 'All_genes_under_selection_MEDAKA_SIFT+PROVEAN.txt' or die $!;  # MZM file

open OUT, ">AGING_genes_under_selection_MEDAKA_SIFT+PROVEAN_GrzPos.txt" or die $!; # outfile with killifish residue pasted at the end
open GRZ, 'AGING_genes_under_selection_GRZref_SIFT+PROVEAN.txt' or die $!;     # GRZ file
open MEDAKA, 'AGING_genes_under_selection_MEDAKA_SIFT+PROVEAN.txt' or die $!;  # MZM file

# Read killifish file and make a hash ------------------------------------
# This will get alignment position, gene name and the residue in GRZ to be
# prineted in final file.
my @grz = <GRZ>;
shift @grz;
#print $grz[0];

my %Grz;
foreach (@grz){
	
	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;

	# I have to put these condition because sometime the prediction is only done by either SIFT or PROVEAN	
	if ($line[6] ne ''){ # if there is a prediction from SIFT
		#print "$line[2]\t$line[6]\t";
		$line[2] =~/([a-z])(\d+)[a-z]/gi; # get GRZ sequence position and residue from column 2
		#if (not defined $1){print "@line\n";}
		$Grz{$line[0]}{$line[6]} = "$1\t$2"; # put it in hash
	}
	elsif ($line[13] ne ''){ # Else if from PROVEAN
		$line[9] =~/([a-z])(\d+)[a-z]/gi; # get GRZ sequence position and residue from column 8
		$Grz{$line[0]}{$line[13]} = "$1\t$2"; # put it in hash
	}
	else {die "Error!!";}
}
#print "$Grz{'NRBP1'}{'56'}";
#print "$Grz{'URB2'}{'1308'}";

# Medaka file ------------------------------------------------------------
my @medaka = <MEDAKA>;
my $head = shift @medaka;
$head =~s/\n//g;
print OUT "$head\tMedaka gene\tMedaka Id\tGRZ residue\tGRZ position\tMedaka residue\tMedaka position\n";

foreach (@medaka){
	
	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
	# I have to put these condition because sometime the prediction is only done by either SIFT or PROVEAN
	if ($line[6] ne ''){

		$line[2] =~/([a-z])(\d+)[a-z]/gi; # get medaka sequence position and residue from column 2
		if (exists $Grz{"$line[0]"}{"$line[6]"}){print OUT join ("\t", @line, $Grz{"$line[0]"}{"$line[6]"}, $1, $2),"\n";}
		else {die "Error!!!"}
	}
	elsif ($line[13] ne ''){

		$line[9] =~/([a-z])(\d+)[a-z]/gi;  # get medaka sequence position and residue from column 8
		if (exists $Grz{"$line[0]"}{"$line[13]"}){print OUT join ("\t", @line, $Grz{"$line[0]"}{"$line[13]"}, $1, $2), "\n";}
		else {die "Error!!!"}
	}
}

print "done";

