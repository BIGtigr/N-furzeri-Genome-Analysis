
# Venn diagram library
library("VennDiagram")

# All the numbers are derived manually from the results 

# -------------------------------------------- Fig 3B and S3A ------------------------------------------------------
# Pie chart for the gens under selection and total genes considered etc
draw.triple.venn(area1=28494,area2=13637,area3=249, n12=13637, n13=249, n23=249,n123=249) # for smaller aging list
draw.triple.venn(area1=28494,area2=13637,area3=497, n12=13637, n13=497, n23=497,n123=497) # for larger aging list

# --------------------------------------------- Fig S3B -------------------------------------------------------------
# Pie charts for phenotypic effect of sites under selection 
# SIFT
slices <- c(401,1035) # Numbers are from </Users/Param/Work/Fish_genome/Selection_PAML/snp_effect/SIFT_processing/MedakaComparison.xlsx> Good site [col-E] = Y, deleterious vs tolerated
lbls <- c("Deleterious", "Tolerated")
pie(slices, labels = lbls, main="MEDAKA - SIFT")

# PROVEAN
slices <- c(809,700) # Numbers are from </Users/Param/Work/Fish_genome/Selection_PAML/snp_effect/SIFT_processing/MedakaComparison.xlsx> Good site [col-E] = Y, not neutral vs neutral
lbls <- c("Non-neutral", "Neutral")
pie(slices, labels = lbls, main="MEDAKA - PROVEAN")

# Overlap between SIFT and PROVEAN
draw.pairwise.venn(area1=401, area2=809, cross.area=340)

