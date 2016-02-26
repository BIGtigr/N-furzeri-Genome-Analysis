# This is the new script for survival circos in the paper
# Gets all cirvival p-values to plot form the file <files_by_dario/all_markers_LG3_markers/c1-logqvals.PROCESSED.txt>
#
# This is just getting the file and printing the LG name and the rounded cM position of the markers in the file 
# since circos cannot handle decimal coordinates.
# 

use strict;
use warnings;
use Math::Round;

open SUR, '>survivalQvals.txt' or die $!;

open POS, '../qtl_files/c1-logqvals.PROCESSED.txt' or die $!;
my @pos = <POS>;
shift @pos;

foreach (@pos){
	
	my @line = split "\t", $_;
	map {$_ =~s/\n//g} @line;

	print SUR "LG$line[1]\t".eval(round($line[2]))."\t".eval(round($line[2])+1),"\t";
	print SUR "$line[3]\n"; # These are the linkage group corrected q-values
}

close (POS);
#print $Positions{'55476'};

print "done";