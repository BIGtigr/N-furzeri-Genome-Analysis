#---------------------------------------------------------------------------------------------------------------------+
# Copyright: Param Priya Singh and Anne Brunet (2015)                                                                 |
# Contact: param@stanford.edu                                                                                         |
#                                                                                                                     |
#  This script is a part of the analysis for manuscript, "The African turquoise killifish genome provides insights    |
#  into evolution and genetic architecture of lifespan", by Valenzano, Benayoun, Singh & Brunet et al. Cell (2015).   |                                                |
#                                                                                                                     |
#  This is distributed under the GNU General Public License <http://www.gnu.org/licenses/>.                           |
#---------------------------------------------------------------------------------------------------------------------+
#
# This script will read all the Bidirectional best hits (BBH) files and the final filtered gene symbol files and get 
# the genes that are in our filtered list and that have a BBH with at least 5 fish genomes. 
# It also gets the sequences for cds and proteins for all these genomes to be used for alignment using GUIDANCE and PRANK
# on our server. The sequenences for all the protein and cds are taken from the folders where all the sequences are, 
# using the id in the BLAST-matrix file.
# 

use strict;
use warnings;

local $| = 1;
# output file this will have the list of genes that 
open GL, '>fishgenelist.txt' or die $!;

# Read gene name file
open NAME, '../Annotation/4_final_annotation/FinalSymbol_20140715.txt' or die $!;
my @names = <NAME>;
shift @names;

my %symbols;
foreach (@names){
	
	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	
	$line[2] =~s/ \((.+) of (.+)\)/_$1\_$2/s;
	#print "$line[2]\n";
	
	$symbols{$line[1]} = $line[2];
}

# column number in BBH file for fishes and their names 
my %orgName = ('6' => 'Zebrafish',
	           '9' => 'Cod',
	           '7' => 'Sticklebac',
	           '16' => 'Tetraodon',
	           '17' => 'Fugu',
	           '13' => 'Medaka',
	           '0' => 'Killifish',
	           '18' => 'Platyfish'
);

# column number and organism file --- to get the sequences from corresponding file
my %orgFile = ('6' => 'drerio',
	           '9' => 'gmorhua',
	           '7' => 'gaculeatus',
	           '17' => 'trubripes',
	           '13' => 'olatipes',
	           '0' => 'nfurzeri',
	           '16' => 'tnigroviridis',
	           '18' => 'xmaculatus'
);

# read all cds and proteins for 8 fishes
my %cds;
readCDS();
my %proteins;
readProteins();

# print header in the gene list file
print GL "Nfur-Symbol	Old-Nfur-Id	Total-Hits	BBH	Fish-with-BBH	Fish-with-no-BBH	Fish-with-no-hit\n";

# I am reading BBH file here because only that has Ids and I will need ids to get the seqquences
foreach (<..\/Annotation\/3_process_blast\/3_bi-directional-best_hits\/BBH\/*.txt>){ # foreach BBH file
#foreach (<test/*.txt>){ # foreach BBH file

	open BBH, "$_" or die $!;
	my @file = <BBH>;
	close (BBH);
	shift @file;
	
	foreach (@file){
		
		my @line = split "\t", $_;
		
		# check how many of the fish organisms are there
		my $orgCount = 8; my $BBHcount = 8;
		my $absent = ''; my $noBBH = ''; my $BBH = ''; # These will hold the name of fishes
		my @fishcolumns; # column number of proper fishes to get the sequences
		
		foreach (sort keys %orgName){ # for each line in BBH file

			if (($line[$_] =~/\*/g) || ($line[$_] eq '')){$BBHcount--; $noBBH = $noBBH."$orgName{$_},";} # no of bbh and fishes without bbh
			if ($line[$_] eq ''){$orgCount--; $absent = $absent."$orgName{$_},";}  # no of fishes without hit and their names
			if (($line[$_] !~/\*/) && ($line[$_] ne '')){$BBH = $BBH."$orgName{$_},"; push @fishcolumns, $_;} # proper fishes and their names, also push columns in the array
		}

		# This part is to get the filtered gene ids and print in the GL file
		
		$line[0] =~s/\-mRNA\-\d+//g; # replace the suffix
		
		if (($BBHcount >= 5) && (exists $symbols{$line[0]})){ # If at least 5 fishes have a bbh and it exists in the final curated genes, It may not be there even if 5 fishes have a bbh, but total hits < 10 and NR coverage < 30% --- there are 3 such Ids that are removed
		
			print GL "$symbols{$line[0]}\t";
			$noBBH =~s/\,$//g; $BBH =~s/\,$//g; $absent =~s/\,$//g; # remove extra comma
			print GL "$line[0]\t$orgCount\t$BBHcount\t$BBH\t$noBBH\t$absent\n"; # print info in the file
			#print "@fishcolumns\n";
		
				# To get the sequences
				getFilteredSeqs($symbols{$line[0]}, \@fishcolumns, \@line);	
		}
	}
}



# read the CDS file
sub readCDS {
	
	print "getting cds\n";

	foreach (<allcds\/*.fasta>){ # allcds is the folder having cds for all fish
		
		print "$_\t";
		$_ =~/allcds\/(.+)\.fasta/g;
		my $name = $1;
		print "$name\n";
		
		open FH, "$_" or die $!;
		my @seqs = <FH>;

		for (my $i = 0; $i < $#seqs; $i = $i+2){

			$seqs[$i] =~s/\-mRNA\-\d+_CDS//g;
			
			$seqs[$i] =~s/\>|\n//g;
			$seqs[$i+1] =~s/\>|\n//g;
			
			$cds{$name}{$seqs[$i]} = $seqs[$i+1];
			#print "$seqs[$i]\n$seqs[$i+1]\n";
		}
	}	
}

# read all proteins	
sub readProteins {

	print "getting proteins\n";	
	foreach (<allproteins\/*.txt>){ # folder with all the proteins

		print "$_\t";
		$_ =~/allproteins\/(.+)\_longest\_proteins\.txt/g; # read files one by one for all fish
		my $name = $1;
		print "$name\n";

		open FH, "$_" or die $!;
		my @seqs = <FH>;

		for (my $i = 0; $i <= $#seqs; $i=$i+2){

			$seqs[$i] =~s/ENS.{0,3}G\d{11}\|//g;
			$seqs[$i] =~s/\-mRNA\-\d+//g;
			$seqs[$i] =~s/\>|\n|\s+//g;
			$seqs[$i+1] =~s/\>|\n|\s+//g;
			
			$proteins{$name}{$seqs[$i]} = $seqs[$i+1];
			#print "$name\t$seqs[$i]\n$seqs[$i+1]\n";
		}
	}
	
}


sub getFilteredSeqs {
	
	my $symb = shift;
	my $ref1 = shift; my @fishcols = @$ref1;
	my $ref2 = shift; my @allIds = @$ref2;
	
	print "$symbols{$allIds[0]}\n";
	my $pfile = "fishproteins\/$symb\.protein.fasta";
	my $cfile = "fishcds\/$symb\.cds.fasta";

	open PT, ">$pfile" or die $!;
	open CS, ">$cfile" or die $!;
	

	foreach (sort {$a <=> $b} @fishcols){
		
		$allIds[$_] =~s/\*//g;
		
		if ($allIds[$_] =~/.+\|(.+)/g){ # remove protein Id
			
			# print in cds file
			print CS ">$orgName{$_}\n";  # organism
			print CS $cds{$orgFile{$_}}{$1},"\n"; # $orgFile{$_} is organism file name and $1 is Id

			# print in protein file
			print PT ">$orgName{$_}\n";  # organism
			print PT $proteins{$orgFile{$_}}{$1},"\n"; # $orgFile{$_} is organism file name and $1 is Id
			
		}
		else {
			$allIds[$_] =~s/\-mRNA\-\d+//g;
			# print in cds file
			print CS ">$orgName{$_}\n";  # organism
			print CS $cds{$orgFile{$_}}{$allIds[$_]},"\n"; # $orgFile{$_} is organism file name and $1 is Id

			# print in protein file
			print PT ">$orgName{$_}\n";  # organism
			print PT $proteins{$orgFile{$_}}{$allIds[$_]},"\n"; # $orgFile{$_} is organism file name and $1 is Id

		}
	}
	
	close(PT);
	close(CS);
	
}

