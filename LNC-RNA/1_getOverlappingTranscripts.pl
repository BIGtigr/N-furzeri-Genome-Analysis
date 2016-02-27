# file <MERGED_Nfur_putative_non_coding_RNA_transcripts_BrainH3K4me3_intersect_filter_SORTED.gtf>
# has been created by sorting manually in excel based on column 0 then 6 then 4 then 5
# i.e. based on scaffold, orientation, start, end

# Now the idea is to get the lncRNA gene coordinates that overlap and then keep the smallest of them because
# we have more evidence for them i.e. from more transcripts. This one only gets the overlapping corrdinates and then
# I get rid of them later. Rest are all good.

use strict;
use warnings;

#open WITHHIST, 'FilteredDuplicateLines.txt' or die $!;
#open WITHHIST, 'koko.txt' or die $!;
open WITHHIST, 'MERGED_Nfur_putative_non_coding_RNA_transcripts_BrainH3K4me3_intersect_filter_SORTED.gtf' or die $!;
my @file = <WITHHIST>;

open OUT, '>2_DuplicateLines.txt' or die $!; # This will have duplicate files

for (my $i = 0; $i <= $#file; $i++){
	
	#print "$file[$i]";
	#print "$file[$i+1]\n";
	
	# This will give warning because array index will be greater for the last element
	my @current = split "\t", $file[$i];
	my @next = split "\t", $file[$i+1];
	
	#if ($next[1] >= $current[1] && $next[2] <= $current[2]){
	if ($next[0] eq $current[0] && $next[6] eq $current[6]){ # if chromosome and orientation is same : There can be 3 scenarios that i cover here to get overlap. Later I will have to also get the overlap value
		
		# The start of second file falls withing the current range
		if ($next[4] > $current[3] && $next[4] <= $current[4]){
			print OUT "\n$file[$i]";
			print OUT "$file[$i+1]";
		}
		# The end of the next file falls witin the curent range
		elsif ($next[3] >= $current[3] && $next[3] < $current[4]){
			print OUT "\n$file[$i]";
			print OUT "$file[$i+1]";
		}
		# The current is contained in the next one
		elsif ($current[3] > $next[3] && $current[3] < $next[4] && $current[4] > $next[3] && $current[4] < $next[4]) {
			print OUT "\n$file[$i]";
			print OUT "$file[$i+1]";		
		}
	}
	else {print OUT "-";} # otherwise it wil just print - to separate the overlapping fragments
}
