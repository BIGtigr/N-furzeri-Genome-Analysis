# I use following categories for plot
#
# 1. Actinopterygii + Sarcopterygii (Bony fishes) + Cephalaspidomorphi + Chondrichthyes: Fish
# 2. Amphibia 
# 3. Aves
# 4. Mammalia
# 5. Reptilia
# 6. Rest all are invertebrates
#
# Restrictions
#
# Only Animals
# Dara Quality: Acceptable or High
# Sample Size: Huge, large or medium
# Should have a lifespan value
# only captivity data
#
use strict;
use warnings;

open OUT, '>Survival_All-In-Captivity_GoodData.txt' or die $!;

# Use the anage data
open FH, 'anage_data.txt' or die $!;
my @anage = <FH>;
shift @anage;

my %AnAge;

foreach (@anage){ # foreach line

	my @line = split "\t", $_;
	map {$_ =~s/\n|^\s+|\s+$//g} @line;

    # Apply above filters
	if (($line[1] eq 'Animalia' || $line[1] eq 'Fungi') && $line[20] ne '' && $line[22] eq 'captivity' && ($line[23] eq 'huge' || $line[23] eq 'large' || $line[23] eq 'medium') && ($line[24] eq 'acceptable' || $line[24] eq 'high')){ # if there is a lifespan and only if the confidence is acceptable or high
		
		my $class; # This is the categorization discusses at the top
		if ($line[3] eq 'Actinopterygii' || $line[3] eq 'Sarcopterygii'){$class = 'Bony Fishes';}
		elsif ($line[3] eq 'Chondrichthyes' || $line[3] eq 'Cephalaspidomorphi'){$class = 'Cartilaginous Fishes';} # Catelageneous and bony fish are combined in the fianl plot
		elsif ($line[3] eq 'Amphibia'){$class = 'Amphibians';}
		elsif ($line[3] eq 'Aves'){$class = 'Birds';}
		elsif ($line[3] eq 'Mammalia'){$class = 'Mammals';}
		elsif ($line[3] eq 'Reptilia'){$class = 'Reptiles';}
		else {$class = 'Invertebrates';}
		
		$AnAge{$class}{$line[20]} = \@line; # here I am not rounding off ages. So only identicle ages will be removed
	}
}

print OUT "group\tyears\tspecies\tname\n";
foreach my $family (keys %AnAge){
	
	foreach my $rAge (keys %{$AnAge{$family}}){

			print OUT "$family\t";
			print OUT "${$AnAge{$family}{$rAge}}[20]\t${$AnAge{$family}{$rAge}}[6] ${$AnAge{$family}{$rAge}}[7]\t${$AnAge{$family}{$rAge}}[8]\n";
	}
}

print "done";
