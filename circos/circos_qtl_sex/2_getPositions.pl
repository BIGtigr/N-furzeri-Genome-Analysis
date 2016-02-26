# This is to get all the markers that are common between genome and Linkage Map and prepae a file that
# has all scaffolds that map to linkage maps. I will use it to print the blue circle for markers and the scaffold
# lengths scaled to cM

use strict;
use warnings;

open HI, '>markers.txt' or die $!;
open SC, '>intermediate-scaffolds.txt' or die $!;

# get scaffolds from GG file. This hash has marker Id and the scaffold number for that marker
open GG, '../genome_files/2014_04_21_G-2014_4_22_REORDERED_RADTAGs.txt' or die $!;
my %marker2scaff;
foreach (<GG>){

	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
	$line[1] =~/.+cM_(\d+)/g; # get the Marker Id from $line[1]
	#print "$1\n";	
	$marker2scaff{$1} = $line[2]; # $line[2] column is scaffold
}

# Files with all the markers to be plotted
open FH, '../qtl_files/go32014_all_pos_procesed.txt' or die $!;
my @file = <FH>;
shift @file;
my %Plotted; # To remove redundant stuff so that circos doesnt take a lot of time to plot

for (my $i = 0; $i < $#file; $i++){
	
	my @line = split "\t", $file[$i];
	
	if (not exists $Plotted{"$line[1]\t".int($line[2])}){ # If it has not been plotted already
		
		# Print the marker to be printed in blue and the rounded position
		print  HI "LG$line[1]\t";
		print  HI int($line[2]),"\t";
		print  HI int($line[2])+1,"\n";
		
		# Print the marker also in the scaffold file to be printed aloing with the scaffold id
		print  SC "LG$line[1]\t";
		print  SC int($line[2]),"\t";
		print  SC int($line[2])+1,"\t";
		
		$Plotted{"$line[1]\t".int($line[2])} = 1; # Mark it plotted
		
		if (exists $marker2scaff{$line[0]}){  # If the marker is on scaffold -- print the scaffold number -- I will process this in next step to get the scaled scaffolds
			print SC "$marker2scaff{$line[0]}\n";
		}
		else {
			print SC "\n";
		}
	}
}

print "done";