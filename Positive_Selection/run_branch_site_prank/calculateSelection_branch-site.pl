# This one runs codeml in PAML as follows
# 
# Constructs the input files for null model, positive selection models in PAML
# Runs both the models - and gets all the raw resukts in a folder with gene name
# Do the LRT and get p-value, sites under selection in a text file
# I do it parallel for chunks of files and get a text file for all cunks, then I will parse them and make a single result file.
#

#!/usr/bin/perl
use strict;
use warnings;

local $| = 1;

my $fishfile = $ARGV[0];
my $outfile = $ARGV[1];

if ((not defined $fishfile) && (not defined $outfile)){
	print "\n         ~~~  Usage: perl program_name.pl input_file output_file ~~~ \ne.g. program.pl genelist_3 paml_bs_prank-003.txt\n\n";
	exit;
}

print "Input: $fishfile\nOutput: $outfile\n"; # input is a chunk of file from <fishgenelist.txt> from Step-1 in README
                                              # This one has information about gene name and tree to be used
                                              # An example input file is in this folder : named genelist_3

my $inputGenelist = '';
my $outputFile = '';
my $ctlnull = '';
my $ctlPos = '';
my $M0File = '';
my $M1File = '';

# Create an output text file
open OUT, ">$outfile" or die $!;
print OUT "Gene	Likelihood Null	Likelihood Selection	Background omega	Foreground omega	2*l(|null-sel|)	P-value	Sites under selection\n";

# Read the file part
open NAME, "$fishfile"  or die $!;
my @names = <NAME>;
map {$_=~s/\n//g} @names;

my %symbols;
foreach (@names){ # foreach gene
	
	my @line = split "\t", $_;
	
# 	if ($line[0] eq 'VCP_1_2' || $line[0] eq 'STAT3'){ #  test for a few genes
			
		# prepare the tree file name from the column 4 of this file
		$line[4] =~s/\,/\_/g;
		$line[4] = $line[4].'.txt';
		
		print "$line[0]\t$line[4]\n";

		# make a dir with the gene name
		print `mkdir $line[0]`; 
		
		print "******************* Compute null model ******************\n";
		printCodemlNull($line[0], $line[4]); # print the null model for codeml
		system("codeml"); # run codeml command, it creates a bunch of files and I cannot change the name

		# So I move files to a diferent folder and rename them
		print `mv 2NG.dN $line[0]`;     print `mv $line[0]/2NG.dN $line[0]/2NG.dN.null`;
		print `mv 2NG.dS $line[0]`;     print `mv $line[0]/2NG.dS $line[0]/2NG.dS.null`;
		print `mv 2NG.t $line[0]`;      print `mv $line[0]/2NG.t $line[0]/2NG.t.null`;
		print `mv codeml.ctl $line[0]`; print `mv $line[0]/codeml.ctl $line[0]/codeml.ctl.null`;
		print `mv rst $line[0]`;        print `mv $line[0]/rst $line[0]/rst.null`;
		print `mv rst1 $line[0]`;       print `mv $line[0]/rst1 $line[0]/rst1.null`; 
		print `mv rub $line[0]`;        print `mv $line[0]/rub $line[0]/rub.null`;
		print `mv 4fold.nuc $line[0]`;  print `mv $line[0]/4fold.nuc $line[0]/4fold.nuc.null`;
		print `mv lnf $line[0]`;        print `mv $line[0]/lnf $line[0]/lnf.nuc.null`;
		
		# Do the same for positive selection model 
		print "******************* Compute positive selection ******************\n";
		printCodemlPositive($line[0], $line[4]);
		system("codeml");
		
		# move files to folder and rename
		print `mv 2NG.dN $line[0]`;     print `mv $line[0]/2NG.dN $line[0]/2NG.dN.pos`;
		print `mv 2NG.dS $line[0]`;     print `mv $line[0]/2NG.dS $line[0]/2NG.dS.pos`;
		print `mv 2NG.t $line[0]`;      print `mv $line[0]/2NG.t $line[0]/2NG.t.pos`;
		print `mv codeml.ctl $line[0]`; print `mv $line[0]/codeml.ctl $line[0]/codeml.ctl.pos`;
		print `mv rst $line[0]`;        print `mv $line[0]/rst $line[0]/rst.pos`;
		print `mv rst1 $line[0]`;       print `mv $line[0]/rst1 $line[0]/rst1.pos`;
		print `mv rub $line[0]`;        print `mv $line[0]/rub $line[0]/rub.pos`;
		print `mv 4fold.nuc $line[0]`;  print `mv $line[0]/4fold.nuc $line[0]/4fold.nuc.pos`;
		print `mv lnf $line[0]`;        print `mv $line[0]/lnf $line[0]/lnf.nuc.pos`;
		
		# DO the liklihood ratio test and get Chi square p-value		
		print "************* Likelihood ratio test and selected sites *********\n";
		my $null = parseLikelihood("$line[0]/results.null.txt"); # parse likelihood ratio for  null
		my $pos = parseLikelihood("$line[0]/results.pos.txt");   # for positive
		my ($background_W, $foreground_W, $ref) = parseSitesFromPos("$line[0]/results.pos.txt");   # parse selected sites and w ratios etc from positive file
		my @sitesUnderSelection = @$ref;
		
		# print omega info to outfile
		print OUT "$line[0]\t$null\t$pos\t";       
		print OUT "$background_W\t$foreground_W\t";
		
		# twice the likelihood difference
		my $Lratio = 2*abs(($null - $pos));
		print OUT "$Lratio\t";
		
		# chi squae p-value for selection
		my $chi2 =  `chi2 1 $Lratio`; 
		$chi2 =~/prob \= (.+) \=/g;
		print OUT "$1\t";

		print OUT join (',', @sitesUnderSelection);
		print OUT "\n";

#	} # end the bracket for example gene here
}


# This is to print the control file for positive selction
# The file names are hard coded here so you will need to change them for your file
sub printCodemlPositive {
	
	my $name = shift;
	my $tree = shift;
	
	open CODEML, ">codeml.ctl" or die $!;
	print CODEML "      seqfile = /Users/Param/Work/Fish_genome/Selection_PAML/branch-site/alignments_prank_paml/$name   * sequence data filename
     treefile = /Users/Param/Work/Fish_genome/Selection_PAML/branch-site/tree_combinations/trees_unrooted/$tree      * tree structure file name
     outfile = $name/results.pos.txt   * main result file name

        noisy = 9      * 0,1,2,3,9: how much rubbish on the screen
      verbose = 1      * 1:detailed output
      runmode = 0      * 0:user defined tree

      seqtype = 1      * 1:codons
    CodonFreq = 2      * 0:equal, 1:F1X4, 2:F3X4, 3:F61

        model = 2      * 2:user specified dN/dS ratios for branches 1:separate omega for each branches 0:one omega ratio for all branches 
      NSsites = 2      * M2a(null)

        icode = 0      * 0:universal code

    fix_kappa = 0      * 1:kappa fixed, 0:kappa to be estimated
        kappa = 2      * initial or fixed kappa

    fix_omega = 0      * 1:omega fixed, 0:omega to be estimated 
        omega = 1      * initial omega

	";
}




# This is to print the control file for NULL model
# Again the file names are hard coded here so you will need to change them for your file
sub printCodemlNull {
	
	my $name = shift;
	my $tree = shift;
	
	open CODEML, ">codeml.ctl" or die $!;
	print CODEML "      seqfile = /Users/Param/Work/Fish_genome/Selection_PAML/branch-site/alignments_prank_paml/$name   * sequence data filename
     treefile = /Users/Param/Work/Fish_genome/Selection_PAML/branch-site/tree_combinations/trees_unrooted/$tree      * tree structure file name
     outfile = $name/results.null.txt   * main result file name

        noisy = 9      * 0,1,2,3,9: how much rubbish on the screen
      verbose = 1      * 1:detailed output
      runmode = 0      * 0:user defined tree

      seqtype = 1      * 1:codons
    CodonFreq = 2      * 0:equal, 1:F1X4, 2:F3X4, 3:F61

        model = 2      * 2:user specified dN/dS ratios for branches 1:separate omega for each branches 0:one omega ratio for all branches 
      NSsites = 2      * M2a(null)

        icode = 0      * 0:universal code

    fix_kappa = 0      * 1:kappa fixed, 0:kappa to be estimated
        kappa = 2      * initial or fixed kappa

    fix_omega = 1      * 1:OMEGA FIXED, 0:omega to be estimated
        omega = 1      * initial omega

	";
}

# parse likelihood values for LRT
sub parseLikelihood {
	
	my $file = shift;
	my $like;
	
	open LK, $file or die $!;
	foreach (<LK>){
		
		if ($_=~/lnL\(ntime\:.+np\:.+\)\:\s*(.+)\s+.+\n/g){
			
			#print "$1\n";
			$like = $1;
		}
	}
	close (LK);
	return($like);	
}

# Parse the sites under selection and their BEB probabilities
sub parseSitesFromPos {
	
	my $file = shift;
	open LK, $file or die $!;
	my @file = <LK>;
	my $bgw; my $fgw;
	
	my $sitestart; my $siteend;
	my $i = 0;
	foreach (@file){
	
		if ($_=~/^background w\s+(.+)\s+(.+)\s+(.+)\s+(.+)/g){
			#print "$1  $2  $3  $4\n";
			$bgw = $3;
		}
		if ($_=~/^foreground w\s+(.+)\s+(.+)\s+(.+)\s+(.+)/g){
			#print "$1  $2  $3  $4\n";
			$fgw = $4;
		}
		
		# This is to basically get a regular expression to parse the sites under selection
		if ($_=~/Bayes Empirical Bayes \(BEB\) analysis \(Yang\, Wong \& Nielsen 2005\. Mol\. Biol\. Evol\. 22\:1107\-1118\)/g){
			#print "$i\t";
			$sitestart = $i+2; # This is the start of BEB probabilities
		}
		if ($_=~/The grid \(see ternary graph for p0\-p1\)/g){
			#print "$i\n";
			$siteend = $i-3; # The end of BEB probabilities
		}
		$i++;
	}
	
	close (LK);
	
	# Get the selected sites, if no sites this should be blank
	my @selectedSites = @file[$sitestart..$siteend];  
	map {$_=~s/\n//g} @selectedSites;     # remove extra spaces etc
	map {$_=~s/\s+$|^\s+//g} @selectedSites;
	
	return ($bgw, $fgw, \@selectedSites);
}


print "done";