# To get the symbols for ease of viewing and getting the gene symbols for N  furzeri genes.
# I get it from the summary files I earlier downloaded from BioMart
#
# I am also counting the best hits and gene without any hits and appending these number at the end
# of the symbo file.
#

use strict;
use warnings;

# In file and outfile -- do it for each of the 32 files one by one
my $infile = '3_bi-directional-best_hits\nfur_032_BBH.txt';
my $outfile = '4_bi-directional-best_hits_symbols\nfur_032_BBH_Symbol.txt';
open OUT, ">$outfile" or die $!;

# Make a hash having all the symbols and Ids for all the 19 organisms
my %Symbols;
foreach (<..\\1_sequence_collection\\2_gene_details_biomart\\biomart_files_filtered\\*.txt>){ # The summary files from BioMart
	
	open FILE, $_ or die $!;
	my @file = <FILE>;
	shift @file;
	close (FILE);	
	
	foreach (@file){
		
		my @line = split "\t", $_;
		map {$_=~s/\n|^\s+|\s+$//g} @line;
		
		# If there is no gene symbol -- use the Id
		if ($line[1] ne ''){
			$Symbols{$line[0]} = $line[1];
		}
		else {
			$Symbols{$line[0]} = $line[0];
		}
	}
}

# open BBH file
open BBH, $infile or die $!;
my @bbh = <BBH>;
my $head = shift @bbh;
close (BBH);

$head =~s/\n//g;
print OUT "$head\tOnly BH\tNo Hit\tTotal Hits\n";

foreach (@bbh){ # foreach BBH
	
	my @line = split "\t", $_;
	map {$_=~s/\n|^\s+|\s+$//g} @line;	
	
	my $onlyBH = 0; my $noHit = 0;
	
	foreach (@line){
		
		my $star = '';
		if ($_=~/\*/g){$star = '*'; $onlyBH++;} # its only best hit if there is a star. take * in a variable to be printed later.
		if ($_=~/^$/g){$noHit++;}
		
		$_=~s/\|.+$//g;
		
		if (exists $Symbols{$_}){
			print OUT "$Symbols{$_}";
		}
		else {
			print OUT "$_";
		}
		print OUT "$star\t";
	}
	print OUT "$onlyBH\t$noHit\t";
	print OUT eval($line[20]+$onlyBH);
	print OUT "\n";
}

print "done";






