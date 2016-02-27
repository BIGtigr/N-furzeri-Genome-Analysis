# This is to read the NR best hit file and teh details of NR gene ids and 
# get a file with the details of the NR hit
use strict;
use warnings;

# Make a hash for GI description for all GI Ids
my %giDescription;

foreach (<3_unique-GI/*Summary*.txt>){ 
	
		local $/= "\n\n"; # Change input record separator so it takes elements separated by \n\n in a single element
		open FH, $_ or die $!;
		my @lines = <FH>;
		
		# Parse, remove unnecessary things and make a hash
		# Key GI Id => value description
		foreach (@lines){			
			$_=~/\d+\.\s*(.+)\n.+\n.+GI\:(\d+)/g;
			$giDescription{$2} = $1; # $2 is GI and $1 is description
		}
}

# Read the best hit processed file and create an outfile
open FH, '2_Unique_nfur-ids_with_nr-hit.txt' or die $!;
open OUT, '>4_Unique_nfur-ids_nr-hit_with-description.txt' or die $!;

foreach (<FH>){ # Foreach bet NR hit
	
	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
	$line[1] =~/gi\|(\d+)\|.+\|.+\|/g; # get the GI id
	
	if (exists $giDescription{$1}){ # get the GI description and print it in outfile
		
		print OUT "$line[0]\t$line[1]\t$giDescription{$1}\t"; # Print the description in 3rd column
		print OUT join ("\t", @line[2..13]), "\n";            # Print rest of the columns
	}
}

print "done";
