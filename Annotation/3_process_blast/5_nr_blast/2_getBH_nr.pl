# To get the best hit for each N furzeri protein in the NR database
# The output of this is in <Unique_nfur-ids_with_nr-hit.txt>

use strict;
use warnings;

open ALLID, 'allIds.txt' or die $!; # File having all the N furzeri protein ids

foreach (<ALLID>){ # Foreach Id
	
	$_=~s/\n|\>//g; # remove >
	
	print `grep "$_" outfiles/*.txt | awk "NR == 1"`; # Grep the best hit (NR == 1) having the current N furzeri Id in all of the files
	
	#print "$_\n";
}

print "done";
