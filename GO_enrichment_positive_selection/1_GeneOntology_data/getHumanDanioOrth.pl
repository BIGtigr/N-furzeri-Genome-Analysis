# This is to get 1:1 orthologs for killifish with human or danio
# I generate 4 files: For human-killifish: having best hits and BBH 
# And BBH adn BH for Danio rerio

use strict;
use warnings;

# Read the final symbol file from Annotation
open RS, 'F:\FishWork\Vertebrates\get Final Symbols\FinalSymbol_20140715.txt' or die $!;
my %Symbols;
foreach (<RS>){
	my @line = split "\t", $_;
	map {$_=~s/\n|\s+//g} @line;
	$line[2]=~s/\(|of/_/g;
	$line[2]=~s/\)//g;
	#print "$line[2]\n";
	$Symbols{$line[1]} = $line[2]; # Key => Id; Value => Symbol
}

# Read the annotation file having the Ids
open FH, 'F:\FishWork\Vertebrates\nfur_All_BBH_Ids.txt' or die $!;
#open FH, 'test.txt' or die $!;
# variables
my %KfHuman; my %KfDanio;
my %KfHumanBBH; my %KfDanioBBH;

foreach (<FH>){
	
	my @line = split "\t", $_;	

	# Replace protein Id from both human and Medaka Id
	map {$_=~s/\|ENSDARP\d{11}//g} @line;
	map {$_=~s/\|ENSP\d{11}//g} @line;
	
	$line[0] =~s/-mRNA-\d+//g; # replace mRNA from the killifish id
	#print "$line[10]\n";
	
	if ($line[6] ne ''){$KfDanio{$line[0]} = $line[6]} # Get best hit hash. BH Ids here will not have *
	if ($line[6]!~/\*$/g){$KfDanioBBH{$line[0]} = $line[6];} # Ids here will have *. This will also match blank Ids but I get rid of them in next step
	
	if ($line[10] ne ''){$KfHuman{$line[0]} = $line[10]}
	if ($line[10]!~/\*$/g){$KfHumanBBH{$line[0]} = $line[10];}
}

# Open output files for human and danio
open OUTH, '>KF_Human_with-BH.txt' or die $!;
open OUTD, '>KF_Danio_with-BH.txt' or die $!;
open OUTHBBH, '>KF_Human_BBH.txt' or die $!;
open OUTDBBH, '>KF_Danio_BBH.txt' or die $!;

# For the real genes in the final annotation file print the corresponding ids
# for both BH and BBH
foreach (keys %KfDanio){
	if (exists $Symbols{$_}){ # only if the gene is a real gene
		print OUTD "$_\t$KfDanio{$_}\t$Symbols{$_}\n";
	}
}
# for only BBH
foreach (keys %KfDanioBBH){
	if (exists $Symbols{$_}){ # only if the gene is a real gene
		print OUTDBBH "$_\t$KfDanioBBH{$_}\t$Symbols{$_}\n";
	}
}
# for both BH and BBH
foreach (keys %KfHuman){
	if (exists $Symbols{$_}){ # only if the gene is a real gene
		print OUTH "$_\t$KfHuman{$_}\t$Symbols{$_}\n";
	}
}
# for only BBH
foreach (keys %KfHumanBBH){
	if (exists $Symbols{$_}){ # only if the gene is a real gene
		print OUTHBBH "$_\t$KfHumanBBH{$_}\t$Symbols{$_}\n";
	}
}

print "done";
