# This is to generate the final lncRNA file to be put on server with the lncRNA Ids
# May give some warnings - but I can ignore that
use strict;
use warnings;

open OUT, '>lincRNA.gtf' or die $!; # output file

open FILE, 'FilteredDuplicateLines_Sorted.txt' or die $!; # the file without duplciates and manually sorted
my @rnafile = <FILE>;
my %finalRNA;


# Foreach gene - get the gene positions and scaffold and generates a hash where the final lncRNA position scaffold etc are key
# and the Id is value - Then I'll take help from the starting GTF file to get a proper GTF with Ids
my $count = 1;
for (my $i=0; $i < scalar @rnafile; $i++){

	my $rnaID = '';	
	## TO GET THE SCAFFOLD AND THE GENE COUNT ------------------------------------------------
	# Line and next line 
	my @line = split "\t", $rnafile[$i];
	my @nextline = split "\t", $rnafile[$i+1]; # It will give some warning as i+1 can get bigger than array indexing - I can ignore it
	
	# remove scaffold text and \n
	map {$_=~s/\n//g} @line;
	map {$_=~s/\n//g} @nextline;
	
	# remove gap filled scaffold text but take it in a new variable that i will use to make hash and then compare with the other file
	my $scaffold =$line[0];
	$line[0] =~s/GapFilledScaffold_//g;
	$nextline[0] =~s/GapFilledScaffold_//g;
	
	# Get the lengths of ids
	my $len1 = (5 - length($line[0]));
	my $len2 = (2 - length($count));
	
	# Paste the zeros to make lengths equal
	for (1..$len1){$line[0] = '0'.$line[0];}
	for (1..$len2){$count = '0'.$count;}
	
	$rnaID = $rnaID."NFURLNR$line[0]$count";
	#print "NFURLNR$line[0]$count";
	#print OUT "NFURG\t";
	#print OUT "$line[12]\t$count\n";
	
	# make gene counter zero if the next scaffold is not same
	if ($line[0] != $nextline[0]){ # It will give some warning as i+1 can get bigger than array indexing
		$count = 0;
	}	
	# increase counter
	$count++;
	
	# TO GET THE TISSUE BINARIES FOR - BRAIN, LIVER, TAIL, TESTES --------------------------------------------------------------

	my $tissuestr = '';
	while ($rnafile[$i]=~/gene_id \"(.+?)\";/g){
		#print "$1\t";
		$tissuestr = $tissuestr." $1";
	}
	#print "\n*$tissuestr*\n";
	my $tissuestr2 = my $tissuestr3 = my $tissuestr4 = $tissuestr;
	if ($tissuestr2 =~/brain/gi){$rnaID = $rnaID.'1';}else{$rnaID = $rnaID.'0';}
	if ($tissuestr =~/liver/gi){$rnaID = $rnaID.'1';}else{$rnaID = $rnaID.'0';}
	if ($tissuestr3 =~/tail/gi){$rnaID = $rnaID.'1';}else{$rnaID = $rnaID.'0';}
	if ($tissuestr4 =~/testes/gi){$rnaID = $rnaID.'1';}else{$rnaID = $rnaID.'0';}
	#print "\n";
	
	# The final hash having all the elements to identify unique lnCRNA as key and the id as value
	$finalRNA{"$scaffold\t$line[1]\t$line[2]\t$line[3]\t$line[4]\t$line[5]"} = $rnaID;
	
}

#print scalar keys %finalRNA; # print the final count
#foreach (keys %finalRNA){	
#	print "$_\t$finalRNA{$_}\n";
#}

# NOw read the starting GTF file and just primt it with my new Ids
local $/ = '';
open ALL, 'MERGED_Nfur_all_putative_non_coding_RNA.gtf' or die $!;
my $filestr = <ALL>;

my %allTrans;
my %checked; # I have to check as there can be some duplicate transcripts in the original starting file
while ($filestr =~/((.+\ttranscript\t.+\n)(.+\texon\t.+\n)+)/g){
	
	#print "$1\n\n";
	my @lines = split "\n", $1;
	my @fline = split "\t", $lines[0];

	if ((exists $finalRNA{"$fline[0]\t$fline[1]\t$fline[2]\t$fline[3]\t$fline[4]\t$fline[5]"}) && (not exists $checked{"$fline[0]\t$fline[1]\t$fline[2]\t$fline[3]\t$fline[4]\t$fline[5]"})){ # if the gene is not checked
		map {$_=~s/gene_id \"(.+?)\";/gene_id \"$finalRNA{"$fline[0]\t$fline[1]\t$fline[2]\t$fline[3]\t$fline[4]\t$fline[5]"}\";/g;} @lines; # substitute my gene id in there
		print OUT join ("\n", @lines),"\n";
		#print OUT "$lines[0]\n";
		
		$checked{"$fline[0]\t$fline[1]\t$fline[2]\t$fline[3]\t$fline[4]\t$fline[5]"} = '';
	}
	# else I dont care
}

# The final file will be used by Berencie for server 

print "done\n";
