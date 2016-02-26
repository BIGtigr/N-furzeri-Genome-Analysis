# To get the fish orthologs where only human
use strict;
use warnings;

# Outfile
open OUT, '>HumanAgingGeneList_ForFish_test.txt' or die $!;

# Read human aging genes
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

# Read all genes and get orthologs
#open ALLGENES, '/Users/Param/Work/Fish_genome/Vertebrates/Bi-Directional_Best_Hits_with_NR_and_Seqs.txt' or die $!;
open ALLGENES, 'F:\Fish_genome\Vertebrates\Bi-Directional_Best_Hits_with_NR_and_Seqs.txt' or die $!;

foreach (<ALLGENES>){
	
	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
	$line[10] = uc $line[10];
	$line[10] =~s/\*$//g;
		
	if (exists $Human{$line[10]}){
		
			$line[0] =~s /\-mRNA-\d+//g;
			print OUT "$line[0]\t$line[10]\t$line[27]\n"; # I dont need $Mouse{$line[12]} here, it was needed only for mouse, but for now its okay
	}
}

print "done";