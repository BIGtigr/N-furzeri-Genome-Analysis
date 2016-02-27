# 
# This is to parse the TransClust output and get the numbers of killi or medaka genes 
# in there. This is run one by one for each threshold and creates an output file for each.
#

use strict;
use warnings;

# change the threshold here for the file
my $threshold = 90;

# killifish - medaka
#open IN, '2_TrandsClust/Out_killi-medaka_all_clusters.txt' or die $!;
#open OUT, ">2_TrandsClust\/Processed_clusters_$threshold\.txt" or die $!;
#print OUT "famsize	medaka	killi	medaka genes	killi genes\n";

# platyfish - medaka
open IN, '2_TrandsClust_platy_medaka/Out_platy-medaka_all_clusters.txt' or die $!;
open OUT, ">2_TrandsClust_platy_medaka\/Processed_clusters_$threshold\.txt" or die $!;
print OUT "famsize	medaka	platy	medaka genes	platy genes\n";

my @families;

# This is to only take the cluster at a particular threshold in an array family
foreach (<IN>){ # Foreach threshold
	
	my @line = split "\t", $_;
	map {$_ =~s/\n//g} @line;
	
	if ($line[0] == $threshold){ # If the threshold is the one specified above
	
		@families = split ';', $line[2]; # push the clusters in families
	}
}

#print scalar keys @families;

foreach (@families) { # foreach family with a particular threshold
	
	#print "$_\n";
	my @cluster = split ',', $_; # Isolagte the cluster members
	map {$_ =~s/\s+//g;} @cluster;
	
	if (scalar @cluster > 1){ # if there are more than 1 gene in the cluster
	
		print OUT scalar @cluster, "\t";
		my @medaka; my @killi; # to hold killifish/platyfish and medaka ids

		foreach (@cluster){ # see if it matches the medaka gene
			
			if ($_=~/ENSORLG\d+/g){ # push it in medaka array
				push @medaka, $_;
			}
			else {push @killi, $_;} # else push it in killifish array. This would be for the platyfish too
		}
		# Print results in outfiles -- These will be plotted in R
		print OUT scalar @medaka,"\t";
		print OUT scalar @killi,"\t";
		
		print OUT join (',', @medaka),"\t";
		print OUT join (',', @killi),"\n";
		
	}
}

print "done\n";



