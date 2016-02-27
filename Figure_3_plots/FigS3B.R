# For the veen in figure S3B
# I draw the 3 diagrams and then combine and scale them in illustrator

# area2 and cross.area in all the plots below is from </Users/Param/Work/Fish_genome/Selection_PAML/branch-site/selection_non-synonymouse_variation_overlap/MZM-GRZ-Selection_overlap.xlsx>

# MZM0403 and selection overlap
# area1 is from: </Users/Param/Work/Fish_genome/Selection_PAML/branch-site/selection_non-synonymouse_variation_overlap/2_variant_files_non-syn/NS_Coding_snps_MZM0403.txt>
draw.pairwise.venn(area1=37093, area2=2009, cross.area=7)

# MZM0703 and selection overlap
# area1 is from <NS_Coding_P0GMA_snps_MZM0703_LL.txt>
draw.pairwise.venn(area1=62073, area2=2009, cross.area=5)

# GRZ and selection set overlap
# area1 is from: <NS_Coding_P0GFA_snps_GRZ_SL.txt>
draw.pairwise.venn(area1=4502, area2=2009, cross.area=0)

# Put all these in illustrator and make the 2009 size exactly equal so 
# everything else would be scaled by that. Remember that this is only to
# show overlap between MZMs GRG and selection -- overlap between GRZ and MZMs
# is there but not shown here.