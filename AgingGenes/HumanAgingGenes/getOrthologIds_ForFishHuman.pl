# To get the fish orthologs of the human genes based on the
# gene symbols from my annotation file.
use strict;
use warnings;

# Outfile
open OUT, '>HumanAgingGeneList_ForFish.txt' or die $!;

# Read human aging genes and make a hash of gene symbols
open AG, 'Human Aging Genes.txt' or die $!;
my @aginggenes = <AG>;
shift @aginggenes;
my %Human;
foreach (@aginggenes){
	
	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
	$line[2] = uc $line[2];
	#print "$line[2]\n";
	$Human{$line[2]} = '';
}
#print scalar keys %Human;

# Read the annotation file and get orthologs based on symbol from my data
open ALLGENES, '/Users/Param/Work/Fish_genome/Vertebrates/Bi-Directional_Best_Hits_with_NR_and_Seqs.txt' or die $!;

foreach (<ALLGENES>){
	
	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
	$line[10] = uc $line[10]; # make symbol uppercase
	$line[10] =~s/\*$//g;
		
	if (exists $Human{$line[10]}){ # If the human symbol from annotation file matches the current symbol - print it
		
			$line[0] =~s /\-mRNA-\d+//g;
			print OUT "$line[0]\t$line[10]\t$line[27]\n"; 
	}
}

print "done";