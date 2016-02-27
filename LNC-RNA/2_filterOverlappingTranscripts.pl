use strict;
use warnings;

open OUT, '>FilteredDuplicateLines.txt' or die $!;

local $/ = "\n-"; # use dash and \n as the input record separator so that each element in array is basically the bunch of duplicate lines
open FH, 'DuplicateLines.txt' or die $!;
my @file = <FH>;

# make a hash to get dupliate lines
my %dupLines;

pop(@file); # get rid of the last element of file that is just dashes

foreach (@file){ # foreach bunch of duplicate lines
	
	# take duplicate lines in array
	my @lines = split "\n", $_;
	shift(@lines); pop(@lines);
	my @tosort;
	
	foreach (@lines){ # forach part that's duplicate
		
		if ($_ ne ''){ # If it's indeed a part
			
			my @line = split "\t", $_;
			#print "$_\n";
			
			$dupLines{"$line[0]\t$line[3]\t$line[4]\t$line[5]"} = '';  # hash that has concatenated scaffold, start, end as key
			
			# get length and fpkm
			my $length = $line[4] - $line[3];
			#print "$length\t";
			$_=~/FPKM \"(.+?)\"\;/g;
			#print "$1\n";
			
			# push at the end of array
			push @line, $length, $1;
			push @tosort, [@line];
		}
		
	}
	# sort based on lebth and fpkm -- this is basically two dimentional
	# sorting
	my @sorted = sort {  $a->[22] <=> $b->[22] || 
                     $b->[23] cmp $a->[23]    } @tosort;
                     
	#print "------------\n";
	
	print OUT join ("\t", @{$sorted[0]}),";;"; # print best sorted part
	foreach (@sorted[0..$#sorted]){print OUT join (";", @{$_})}       # and then the properties of the rest of them. This will be separated by double ;;
	print OUT "\n";
	#print "------------\n";
}

# total duplicate lines are 2044 but some of them are same so 1745 is this count finally
#print scalar keys %dupLines;

# now open the filtered file and make a clean file for the one's that dont have duplicates
# duplicates are already taken care of above
local $/ = "\n";
open WITHHIST, 'MERGED_Nfur_putative_non_coding_RNA_transcripts_BrainH3K4me3_intersect_filter_SORTED.gtf' or die $!; # total in the file are 6959

foreach (<WITHHIST>){ # foreach of the potential lncRNA
	
	my @line = split "\t", $_;
	
	if (not exists $dupLines{"$line[0]\t$line[3]\t$line[4]\t$line[5]"}){ # print it if it does not exist in duplicate hash
		print OUT "$_";
	}
	
}

