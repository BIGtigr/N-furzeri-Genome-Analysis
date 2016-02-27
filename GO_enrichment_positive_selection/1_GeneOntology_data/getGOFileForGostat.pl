# Create files that I can use in GOstate package
# Run it one by one for human and danio and all hits and bbh
# Also change the output file name
use strict;
use warnings;

# ortholog file to GO id maping: 
# make a hash for the [Key: ensembl Id of human/Danio => Value: GO Id array] -----------------
#open ORTH, 'mart_export_go_danio.txt' or die $!; # This is for both Danio BBH and BH
open ORTH, 'mart_export_go_human.txt' or die $!; # This is for both Danio BBH and BH
my @orth = <ORTH>;
shift @orth;
close (ORTH);

my %Id2Go;
foreach (@orth){

	my @line = split "\t", $_;
	map {$_=~s/\n|\s+//g} @line;
	
	if ($line[2] ne ''){push @{$Id2Go{$line[0]}}, $line[2];}
}
# ---------------------------------------------------------------
# Human/Danio Id to Killiffish gene mapping
#open KFID, 'KF_Danio_with-BH.txt' or die $!;
#open KFID, 'KF_Danio_BBH.txt' or die $!;
#open KFID, 'KF_Human_with-BH.txt' or die $!;
open KFID, 'KF_Human_BBH.txt' or die $!;

my %Kf2Ens;
foreach (<KFID>){

	my @line = split "\t", $_;
	map {$_=~s/\n|\s+//g} @line;
	$line[1] =~s/\*$//g;
	
	$Kf2Ens{$line[2]}{$line[1]} = ''; # I make 2d hash to remove duplicate Ids
}

# ------------------------------------- print new file ------------
#open OUT, '>GO_danio_all-hits.txt' or die $!; # All hits with Danio
#open OUT, '>GO_danio_bbh.txt' or die $!;  # Only BBH 
#open OUT, '>GO_human_all-hits.txt' or die $!; # All hits with Human
open OUT, '>GO_human_bbh.txt' or die $!;  # Only BBH 

print OUT "go_id	Evidence	gene_id\n";

foreach my $kfId (keys %Kf2Ens){ # foreach killifish Id
	
	#print "$kfId\t";
	#print keys %{$Kf2Ens{$kfId}},"\n";
	foreach my $ensId (keys %{$Kf2Ens{$kfId}}){ # foreach human id if there are many human ids for this Kf Id
		
		if (exists $Id2Go{$ensId}){ # If thr is GO Id for this human id
			# print killifish id Evidence and GO
			foreach (@{$Id2Go{$ensId}}){
				print OUT "$_\tISO\t";
				print OUT "$kfId\n";
			}
		}
	}
}

