# Reads the transosed Id file and gets the concatenated sequences in fasta format to be used for alignment, tree building etc.
# This was run on my windows computer initially

use strict;
use warnings;


open IDS, '3_Bi-Directional_Best_Hits_Ids_ForTree.txt' or die $!;
# Output file for sequences for tree
open OUT, '>4_SeqsForTree_test.txt' or die $!;

# Foreach sequene id for one organism
foreach (<IDS>){
	
	my @line = split "\t", $_;
	map {$_=~s/\n|^\s+|\s+$//g} @line;
	my $organism = shift @line;
	#print scalar @line, "\n";
	
	# This will read the sequence file and get the sequences and concatenate them for the organism under consideration
	getOrganismHash($organism, \@line);
}


sub getOrganismHash {
	
	my $org = shift;
	my $ref = shift;
	my @seqIds = @$ref;
	
	# From the below folder read the file for current organism - these are all the proteins
	# for this organism
	foreach (<ensembl_75_seqs_filtered\/*.txt>){
		
		# Isolate the name of organism from the filename
		$_=~/.+\/(.+)/g;
		my $name = $1;

		if ($name =~/$org/gi){
			
			print "Reading: $org\t$name\t$_\n"; # print the name
			print OUT ">$org\n";
			
			# Read file and make a sequece hash having Ids as keys and protein seq as value
			local $/ = '>';
			open FH , "$_" or die $!;
			my @line = <FH>;
			close (FH);
			
			my %seqHash;
			
			shift (@line);
			foreach (@line){
			
				my ($head, $seq) = split "\n", $_;
				$head=~s/\n|^\s+|\s+$//g;
				$seqHash{$head} = $seq; # This is my hash for the current organism
			}
			
			# Now use this hash to get the seq and make one large string. 
			# For each id push the sequence in an array
			my @sequences;
			my $col = 1;
			foreach (@seqIds){
				
				if (exists $seqHash{"$_"}){
					
					#print OUT "$seqHash{$_}";
					push @sequences, $seqHash{$_};
					
					if ($seqHash{$_} =~/U|X/g){print "$col\n"}
					$col++;
				}
				else {
					die "$_ not found";
				}
			}
			
			# join the sequences to make one string and print fasta with 60 chars in one line using unpack function
			print OUT join "\n", unpack("(A60)*", join '', @sequences);
			print OUT "\n";
		}
	}
}
