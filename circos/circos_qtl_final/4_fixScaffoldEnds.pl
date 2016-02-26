# In the previous file- due to my logic it can be that scaffold end are the start of the next scaffold
# Here I fix this -- I will take the length and if that is the case I just make it the end of this scaffold
# If there is no number that can happen at the end -- I copy paste the size manually

use strict;
use warnings;

open LEN, '../Karyotype.Killifish.LG.txt' or die $!; # scaffold length file
open FH, 'scaffolds_final.txt' or die $!; # scaffold file
open OUT, '>scaffolds_final_2.txt' or die $!; # final file for plotting

# Read length
my %Lengths;
foreach (<LEN>){
	
	#print "$_";
	my @line = split ' ', $_;
	map {$_=~s/\n//g} @line;
	
	#print "$line[2]\t$line[5]\n";
	
	$Lengths{$line[2]} = $line[5];
}

foreach (<FH>){
	
	my @line = split ' ', $_;
	map {$_=~s/\n//g} @line;
	print "$line[2]\n";
	if ($line[2] < $line[1]){ # If the end is smaller than the start - change it and print the size of scaffold as end
		print OUT "$line[0]\t$line[1]\t$Lengths{$line[0]}\t$line[3]\n";
	}
	else {
		print OUT $_; # Else - print it as is
	}
}

print "done";
