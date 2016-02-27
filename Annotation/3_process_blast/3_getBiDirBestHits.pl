# This is to get the bi directional best hit (BBH) for each of the N furzeri genes.
# I use the 32 sequence chunks and run this on cluster one by one.
#
# The idea is similar. I use the Id pattern for the 19 organisms to grep the hits 
# and check if they are BBH.
#
# *** ON linux use double quots in grep and on mac use single quots. See what works and change accordingly
#

use strict;
use warnings;

local $| = 1;

my $nfurFile = $ARGV[0];
my $outFile = $ARGV[1];

if ((not defined $ARGV[0]) && (not defined $ARGV[1])){
	print "usage: perl program.pl nfurfile outfile\n";
	exit();
}

open OUT, ">$outFile" or die $!;
open NF, "$nfurFile" or die $!;

# Read the N furzeri file and take all ids in an array
my @nfur = <NF>;
close (NF);

my %Nfur;

foreach (@nfur){
	
	my @line = split "\t", $_;
	map {$_=~s/\n//g} @line;
	$Nfur{$line[0]} = '';
}
#print scalar keys %Nfur,"\n";
#print "......................[DONE]\n";

# Hash for Id patterns for all 19 organisms
my %orgname = ('hsap_BH'   => 'ENSG\d{11}',
               'cele_BH'   => 'WBGene\d{8}', 
               'cfam_BH'   => 'ENSCAFG\d{11}',
               'cint_BH'   => 'ENSCING\d{11}',
               'csav_BH'   => 'ENSCSAVG\d{11}',
               'dmela_BH'  => 'FBgn\d{7}',
               'drer_BH'   => 'ENSDARG\d{11}',
               'gacu_BH'   => 'ENSGACG\d{11}',
               'ggal_BH'   => 'ENSGALG\d{11}',
               'gmor_BH'   => 'ENSGMOG\d{11}',
               'lchal_BH'  => 'ENSLACG\d{11}',
               'mmus_BH'   => 'ENSMUSG\d{11}',
               'olati_BH'  => 'ENSORLG\d{11}',
               'spur_BH'   => 'SPU_\d{6}',
               'sscr_BH'   => 'ENSSSCG\d{11}',
               'tnig_BH'   => 'ENSTNIG\d{11}',
               'trub_BH'   => 'ENSTRUG\d{11}',
               'xmac_BH'   => 'ENSXMAG\d{11}',
               'xtrop_BH'   => 'ENSXETG\d{11}'
);

print OUT join ("\t", 'killifish', sort keys %orgname),"\tRBH\n"; # Print the header in alphabetical order

my $counter = 0;

foreach (keys %Nfur){ # Foreach Id
	
	my @line = split "\t", $_;
	print OUT "$line[0]\t"; # This is the N furzeri Id under consideration

	my $totalRBH = 0;
	
	# Foreach organism hash
	foreach my $org (sort keys %orgname){
				
		# get the best hit for a given organism, if exists -- If there is an error try to make this grep command work first
		my $hitId = `grep -P \"^$line[0]\\t$orgname{$org}\" $nfurFile \| awk \"NR==1\{print \$2\}\"`;
			
		# This returned id has a \n and | dont work later so replace them
		$hitId =~s/\n//g;
		print OUT "$hitId";
		$hitId =~s/\|/\\|/g;
		
		if ($hitId ne ''){ # If there is a hit
		
			# Get the best receprocal hit for this organism. The resultant id can be: null if no hit, the same id or a different id
			my $revHitId = `grep -P \"^$hitId\\t.+GapFilledScaffold\" best_hits_others_to_Nfur\/$org \| awk \"NR==1\{print \$2\}\"`;
			$revHitId =~s/\n//g;

			if ($revHitId eq $line[0]){ # If the reverse Id is same as the start Id -- It is a BBH
				$totalRBH++;
			}
			else {
				print OUT "*"; # If it's not a BBH -- print a * next to the Id
			}
		}
		print OUT "\t";
	}
	print OUT "$totalRBH\n";
	
	print "$counter of ";
	print scalar keys %Nfur,"\n";
	$counter++;
}
 
print "done";
