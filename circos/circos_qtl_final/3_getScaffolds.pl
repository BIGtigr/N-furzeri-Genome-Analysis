# Reads the intermediate scaffold file and gets a file where only scaffolds that map to markers are kept
use strict;
use warnings;

open SC, '>scaffolds_final.txt' or die $!;

# Read intermediate scaffold file and make a hash where all the markers 
# for a particluar scaffold are in an array 
open FH, 'intermediate-scaffolds.txt' or die $!;
my @file = <FH>;
my %scaffolds;

foreach (@file){
	
	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
	if ($line[3] ne ''){
		push @{$scaffolds{$line[3]}}, $_; # Key => scaffold; Value array => all markers
	}
}


my $i = 0;
foreach (@file){ # Read the scaffold file again
	
	my @cLine = split "\t", $file[$i];    # Read the line and the next line to check if the scaffold is same
	my @nLine = split "\t", $file[$i+1];
	
	map {$_=~s/\n//g} @nLine;
	map {$_=~s/\n//g} @cLine;
	
	# Evalue conditions and generate radnom colors for scfolds
	if ($cLine[3] ne '' && $nLine[3] eq '') {             # If the scaffold is not there for next line - I use the same color
		print SC "$cLine[0]\t$cLine[1]\t$nLine[1]\t";
		print SC "fill_color=(".int(rand(255)).','.int(rand(255)).','.int(rand(255)).')'."\n";
	}
	if ($cLine[3] ne '' && $cLine[3] ne $nLine[3]) { # If the scaffold are different - I use the different color
		print SC "$cLine[0]\t$cLine[1]\t$nLine[1]\t";
		print SC "fill_color=(".int(rand(255)).','.int(rand(255)).','.int(rand(255)).')'."\n";
	}
	if ($cLine[3] ne '' && $cLine[3] eq $nLine[3]) { # If the scaffold are same - I use the same color and update the coordinates to sum the length
	
		my @first = split "\t", ${$scaffolds{$cLine[3]}}[0];
		my @last = split "\t", ${$scaffolds{$cLine[3]}}[-1];
		print SC "$first[0]\t$first[1]\t$last[2]\t";
		print SC "fill_color=(".int(rand(255)).','.int(rand(255)).','.int(rand(255)).')'."\n";
		$i = scalar(@{$scaffolds{$cLine[3]}}) + $i;
		next;
	}
	$i++;
}

print "done";
