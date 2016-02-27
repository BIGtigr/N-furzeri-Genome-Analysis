# This is to get the overlap between the 619 highlly conserved genes and the mouse and human 
# aging genes from GenAge
#
use strict;
use warnings; # no warnings allowed

# ------------------------ MOUSE -------------------------------------------------
open MM, '/Users/Param/Work/Fish_genome/genome-wide_KaKs/forMouseAgingGenes/MouseAgingGeneList_ForFish.txt' or die $!;
my @maginggenes = <MM>;
#shift @maginggenes;
my %Mouse;
foreach (@maginggenes){
	
	my @line = split "\t", $_;
	map {$_=~s/\n|\s+//g} @line;
	
	$line[3] =~s/\(/_/g; $line[3] =~s/of/_/g; $line[3] =~s/\)//g;
	$line[0]=~s/-mRNA-\d+//g;
	#print "$line[3]\n";
	$Mouse{$line[0]} = $line[1];
}
#print scalar keys %Mouse,"\n";

# ------------------------ HUMAN ------------------------------------------------
open HS, '/Users/Param/Work/Fish_genome/genome-wide_KaKs/forHumanAgingGenes/HumanAgingGeneList_ForFish.txt' or die $!;
my @haginggenes = <HS>;
#shift @haginggenes;
my %Human;
foreach (@haginggenes){
	
	my @line = split "\t", $_;
	map {$_=~s/\n|\s+//g} @line;
	$line[2] =~s/\(/_/g; $line[2] =~s/of/_/g; $line[2] =~s/\)//g;
	$line[0]=~s/-mRNA-\d+//g;
		
	#print "$line[2]\n";
	$Human{$line[0]} = $line[1];
}
#print scalar keys %Human,"\n";


# ------------------------ FINAL SYMBOL FILE ------------------------------------------------
open SYMB, '/Users/Param/Work/Fish_genome/Vertebrates/getFinalSymbols/FinalSymbol_20140715.txt' or die $!;
my %Symbols;
foreach (<SYMB>){
	
	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
	$Symbols{$line[1]} = $line[2];
}
#print scalar keys %Symbols;


# Read the Ids for tree ----------------------------------------------------------
open IDS, '../Bi-Directional_Best_Hits_Ids_ForTree.txt' or die $!; # All id file
my @file = <IDS>;     
my @ids = split "\t", (shift @file); # Get the 1st lien i.e. killifish Ids
shift @ids; # remove name nfur
#print scalar @ids;
map {$_=~s/\n//g} @ids;

my %Phylogeny619;

foreach (@ids){
	
	$_=~s/-mRNA-\d+//g;
	#print "$_\n";
	$Phylogeny619{$_} = '';

}
#print scalar keys %Phylogeny619;


# Get the final overlap --------------------------
open OUT, '>AgingOverlap.txt' or die $!;
print OUT "N. furzeri id\tN. furzeri Symbol\tAging gene in mouse?\tAging gene in human?\n"; 
foreach (keys %Phylogeny619){
	
	
	if (exists $Symbols{$_}){
	
		print OUT "$_\t$Symbols{$_}\t";

		if (exists $Mouse{$_}){print OUT "Yes\t";}
		else {print OUT "\t";}

		if (exists $Human{$_}){print OUT "Yes\n";}
		else {print OUT "\n";}
		
	}
	else {die "$_ no found in all genes\n"}
}













print "done";