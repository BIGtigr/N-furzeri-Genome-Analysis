# To get the SNP counts for a 20kb window in circos format to plot
# Do it for the 3 strains one by one
use strict;
use warnings;

# scaffolds and its lengths to filter on lengths if I want to -- I was doing it earlier to filter on largest scaffolds
# This is now just a way to limit the file size
open ALLSCAF, '../files_by_berenice_elisa/SSPACE_scaffolding_GapFilled.final.scaffolds.replaced-headers.genome' or die $!;
my %Scaffolds;

foreach (<ALLSCAF>){
	
	my @line = split "\t", $_;
	map {$_ =~s/\n//g} @line;
	map {$_=~s/GapFilledScaffold_/scaffold_/g} @line;
	$Scaffolds{$line[0]} = $line[1]; # scaffold name in key and its length in value
}

# Read the pair of infile and outfile for each strain -- uncomment the one you wnat
#open PGFSNP, '../files_by_berenice_elisa/Genetic_variation_20150729/BGI_P0GFA_bwa_map.snps.GATK.filteredrm.liftup.sorted.vcf' or die $!;
#open OUT, '>GRZ_wd=20k_20150730.txt' or die $!;

#open PGFSNP, '../files_by_berenice_elisa/Genetic_variation_20150729/BGI_P0GMA_bwa_map.GATK.snps.filteredrm.liftup.sorted.vcf' or die $!;
#open OUT, '>MZM0703_wd=20k_20150730.txt' or die $!;

open PGFSNP, '../files_by_berenice_elisa/Genetic_variation_20150729/MZM0403_MERGED.GATK.snps.v2.filteredrm.vcf' or die $!;
open OUT, '>MZM0403_wd=20k_20150730.txt' or die $!;

my %Snps;
foreach (<PGFSNP>){
	
	if ($_!~/^#/g){
		
		my @line = split "\t", $_;
		map {$_ =~s/\n//g} @line;
		map {$_=~s/GapFilledScaffold_/scaffold_/g} @line;
		$Snps{$line[0]}{$line[1]} = ''; # scaffold name in key and position in values. This will be used to check if it belongs to a particular window below
	}
}

my $window = 20000; # window size

foreach (keys %Scaffolds){ # Foreach scaffold
	
	# If it's larger than 100000
	if ($Scaffolds{$_} >= 100000){ # Earlier I was only taking scaffolds with length is more than 100000, but it doesn't matter now as i am only taking 100 largest scaffolds. BUt this is just a way to limit the file size now.
		
		for (my $i = 0; $i < ($Scaffolds{$_}+$window); $i = ($i + $window)){ # A loop where I jump to the window size
			
			# define start and end of windows
			my $end = $i + $window - 1;
			my $start = $i;
			if ($end > $Scaffolds{$_}){$end = $Scaffolds{$_};$i = ($i + $window);} # Adjust the ends if longer than window
			
			# Check if there are snps here and count if any
			my $snps = 0;
			if (exists $Snps{$_}){
				
				foreach (keys %{$Snps{$_}}){
					
					if ($_ >= $start && $_ <= $end){$snps++;}
				}
			}
			
			if ($snps > 0){
				print OUT "$_ $start $end $snps\n"; # Print the count
			}
		}
	}
}

print "done";