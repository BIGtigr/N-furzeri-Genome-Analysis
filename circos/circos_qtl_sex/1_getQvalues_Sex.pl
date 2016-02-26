# This is to get the q-values for circos for SEX. Earlier I had both Sex and Survival in here -- BUt I am using
# a separate one for survival now.

use strict;
use warnings;
use Math::Round;

open SEX, '>sexQvals.txt' or die $!;

open POS, '../qtl_files/go32014_all_pos_procesed.txt' or die $!;
my %Positions;

foreach (<POS>){
	
	my @line = split "\t", $_;
	map {$_ =~s/\n//g} @line;
	$Positions{$line[0]} = "LG$line[1]\t".eval(round($line[2]))."\t".eval(round($line[2])+1);
	print "LG$line[1]\t".eval(round($line[2]))."\t".eval(round($line[2])+1),"\n"; # Marker linkage group and rounded position on circos -- I need rounded position because circos cannot handle decimal coordinates
}
#print $Positions{'55476'};

# Markers and q-value -- first column has values for sex
open FH, '../qtl_files//go_qval.txt' or die $!;
my @qval = <FH>;
shift (@qval);

my %qVals;

foreach (@qval){
	
	my @line = split "\t", $_;
	map {$_ =~s/\n//g} @line;
	$line[0] =~s/^X//g;
	
	if (exists $Positions{$line[0]}){ # Only if it is anchored on linkage map -- get the q-value. There are 4099 such markers
		
		#print SUR "$Positions{$line[0]}\t";  # Obsolete
		#print SUR eval(-log($line[2])),"\n";
		
		print SEX "$Positions{$line[0]}\t";
		print SEX eval(-log($line[1])),"\n";
	}
}

print "done";
