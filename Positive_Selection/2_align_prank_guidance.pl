#!/usr/bin/perl
#---------------------------------------------------------------------------------------------------------------------+
# Copyright: Param Priya Singh and Anne Brunet (2015)                                                                 |
# Contact: param@stanford.edu                                                                                         |
#                                                                                                                     |
#  This script is a part of the analysis for manuscript, "The African turquoise killifish genome provides insights    |
#  into evolution and genetic architecture of lifespan", by Valenzano, Benayoun, Singh & Brunet et al. Cell (2015).   |                                                |
#                                                                                                                     |
#  This is distributed under the GNU General Public License <http://www.gnu.org/licenses/>.                           |
#---------------------------------------------------------------------------------------------------------------------+

# This script is to align all the cds using guidance -- output alignment for each gene is in the folder [alignments_prank].
# For each gene, a folder is created that has all the output files from PRANK and the quality assessment from GUIDANCE.
#
# Input file is <fishgenelist.txt> that has all the gene names after removing the header in the file.
#

use strict;
use warnings;

local $| = 1;

my $file = 'fishgenelist.txt';

open NAME, "$file" or die $!; # $file is <fishgenelist.txt>

my @names = <NAME>;
map {$_=~s/\n//g} @names;

my %symbols;

my $count = 1;
foreach (@names){ # foreach gene name
	
		my @line = split "\t", $_;
		
		# Run the guidance command
		print "******************* Aligning protein $line[0] gene number $count *******************\n";
		print `perl www/Guidance/guidance.pl --seqFile allcds/$_ --msaProgram PRANK  --seqType codon --outDir alignments_prank/$_ --bootstraps 10`;				
}

print "done";