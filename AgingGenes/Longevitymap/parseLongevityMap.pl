# To get the overlap between longevitymap and fish orthologs
use strict;
use warnings;

# outfile
open OUT, '>LongevityMap_FishOrthologs.txt' or die $!;

# Read the longevity map file
open FH, 'LongevityMap/longevity_tsv.txt' or die $!;
my @longmap = <FH>;
my $head = shift @longmap;

my %uniqueGenes; # To hold uniqque genes in Longevity Map

foreach (@longmap){ # foreach record
	
	my @line = split "\t", $_;
	map {$_=~s/\n|\s+//g;} @line;
	
	if ($line[2] ne '' && $line[2] eq 'significant' && $line[5] ne ''){ # if longevity is significant and there are genes associated with it: total 232
		
		# split if there are multiple genes
		my @genes = split ',', $line[5];
		foreach (@genes){
			
			$_ = uc $_;
			push @{$uniqueGenes{$_}}, "$line[6]"; # for duplicates just print the pubmed id in an array
			#print join ("\t", @line, $_),"\n";
		}
	}
}

# Read all genes and get orthologs for human
open ALLGENES, '/Users/Param/Work/Fish_genome/Vertebrates/Bi-Directional_Best_Hits_with_NR_and_Seqs.txt' or die $!;
my %checked; # mark the checked genes
foreach (<ALLGENES>){
	
	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
	$line[10] = uc $line[10]; # column 10 strating from 0 is the human symbol
	$line[10] =~s/\*$//g;
		
	if (exists $uniqueGenes{$line[10]}){ # If the human symbol is there in the LongevityMap
		
			$line[0] =~s /\-mRNA-\d+//g;
			print OUT "$line[0]\t$line[10]\t$line[27]\n"; # print it with final symbol and current symbol. There may not be a symbol if it's one of those genes that's not in final annotation. But I will take care of it later.
			$checked{$line[10]} = '';
	}
}
print scalar keys %uniqueGenes;
print " out of ";
print scalar keys %checked;
print " are in <LongevityMap/longevity_tsv.txt>\nThe ones that do not have orthologs in human are below\n\n";

# Now see if there are any that did not get covered because they did not have orthologs
foreach my $gene (keys %uniqueGenes){
	
	if (not exists $checked{$gene}){
		print "$gene\t";
		print join (',', @{$uniqueGenes{$gene}}),"\n";
	}
}
print "done\n";