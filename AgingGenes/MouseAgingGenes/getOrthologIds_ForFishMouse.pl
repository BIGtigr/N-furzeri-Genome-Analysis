# To get the fish orthologs of mouse genes for overlap with selected genes etc 
use strict;
use warnings;

# Outfile
open OUT, '>MouseAgingGeneList_ForFish.txt' or die $!;

# Read mouse aging genes from GenAge and make a symbol hash
open AG, 'Filtered Mouse Genes.txt' or die $!;
my @aginggenes = <AG>;
shift @aginggenes;
my %Mouse;
foreach (@aginggenes){
	
	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
	$line[2] = uc $line[2];
	#print "$line[2]\t$line[7]\n";
	$Mouse{$line[2]} = $line[7];
}
#print scalar keys %Mouse;

# Read annotation file to see which ones of the mouse geens are in the GenAge file
open ALLGENES, '/Users/Param/Work/Fish_genome/Vertebrates/Bi-Directional_Best_Hits_with_NR_and_Seqs.txt' or die $!;

foreach (<ALLGENES>){ # forach gene in annotation file
	
	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
	$line[12] = uc $line[12];
	$line[12] =~s/\*$//g;
	
	if (exists $Mouse{$line[12]}){ # if the mouse gene is there in mouse genage
				
			print OUT "$line[0]\t$line[12]\t$Mouse{$line[12]}\t$line[27]\n"; # print it's information
	}
}

print "done";
