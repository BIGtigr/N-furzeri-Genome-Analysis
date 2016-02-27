# Thsi si to make all the trees unrootes using Phylip as recommended by PAML
# Input is  - all the trees genered by python program
#           - input.txt is the options I need to interact with phylip
# Output is unrooted trees in [trees_unrooted] folder
#

use strict;
use warnings;

foreach (<trees/*.txt>){
	
	open FH, "$_" or die $!;
	my @line = <FH>;
	$_ =~s/trees\///g;
	
	print "$_\t$line[0]\n";
	
	open IN, ">intree" or die $!;
	print IN "$line[0]";
	
	print `retree < input.txt`;
	
	# replace killifih to mark #1 in front of its name
	open OUT, "outtree" or die $!;
	my @out = <OUT>;
	$out[0] =~s/Killifish/Killifish \#1/g;
	close (OUT);
	
	# open out file
	$_ =~s/trees\///g;
	open OUT2, ">trees_unrooted\\$_" or die $!;
	print OUT2 "$out[0]";
	close (OUT2);
	
	print `rm outtree`;
	
}


