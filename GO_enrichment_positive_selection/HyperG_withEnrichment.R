## This is to do GO enrichment analysis based on BBH list from zebrafish
#
# The starting object needs to be a data.frame with the 
# GO Id's in the 1st col, the evidence codes in the 2nd 
# column and the gene Id's in the 3rd

setwd('/Users/Param/Dropbox/Fish_paper/Code/Param/GO_enrichment_positive_selection');

library("GOstats")

frame = read.table(file ="1_GeneOntology_data/GO_danio_bbh.txt", header = T, colClasses=c(rep("factor",3)))
#str(frame)

# This is just to get the 3 column. I already have these so I dont need it anyway!
goframeData = data.frame(frame$go_id, frame$Evidence, frame$gene_id)

# put your data into a GOFrame object
goFrame=GOFrame(goframeData,organism="Danio")
#head(goframeData)

# cast this object to a GOAllFrame object will tap into the GO.db package and populate this object with the implicated GO2All mappings for you
goAllFrame=GOAllFrame(goFrame)

# generate geneSetCollection objects
library("GSEABase")
gsc <- GeneSetCollection(goAllFrame, setType = GOCollection())

library("GOstats")

# Make the universe
universe = read.table(file ="2_selected_genes/considered_genes.txt", header = T);
universe = universe$id
universe = lapply(universe, as.character)
universe = unlist(universe)

# The list of interest
#genes = read.table(file ="2_selected_genes/NegativeSelection.txt", header = T);  # MAFFT p < 0.05 after MHC 
#genes = read.table(file ="2_selected_genes/prank_mafft_overlap.txt", header = T);  # MAFFT p < 0.05 after MHC 
#genes = read.table(file ="2_selected_genes/prank_0.05_MultipleCorrected_SIFT-PROV.txt", header = T);  # MAFFT p < 0.05 after MHC 
#genes = read.table(file ="2_selected_genes/mafft_0.05_MultipleCorrected.txt", header = T);  # MAFFT p < 0.05 after MHC 
#genes = read.table(file ="2_selected_genes/prank_0.01_MultipleCorrected.txt", header = T);  # PRANK p < 0.01 after MHC
#genes = read.table(file ="2_selected_genes/prank_0.05_mhc_allsites.txt", header = T);  # PRANK p < 0.05 after MHC and all sites - not just BEB > 0.95 condition
genes = read.table(file ="2_selected_genes/prank_0.05_MultipleCorrected.txt", header = T);  # FINAL IN PAPER

genes = genes$id
genes = lapply(genes, as.character)
genes = unlist(genes)

params <- GSEAGOHyperGParams(name="My Custom GSEA based annot Params", 
                             geneSetCollection=gsc, geneIds = genes, 
                             universeGeneIds = universe,ontology = "BP",
                             pvalueCutoff = 0.05,
                             conditional = FALSE, 
                             testDirection = "over") # Default hyper geometric test gives both over and under enriched terms. I am specifying the direction by "over"

# call hyperGTest to do the test
Over <- hyperGTest(params)
#head(summary(Over))

# adjust p value for multile correction
padj = p.adjust(summary(Over)[2]$Pvalue, "BH")

# calculate enrichment and add it to data frame.
# Enrichmen = (count/size)/(size/13637) where 13637 is all the genes considered for selection anakysis
enrichment = (summary(Over)[5]$Count / summary(Over)[6]$Size) / (summary(Over)[6]$Size / 13637)

# create a new frame
adjusted = data.frame(summary(Over), padj, enrichment)

# write to a file
#write.table(adjusted, "NegativeSelection_GOenrichment.txt", quote = F, row.names = F, sep = "\t")
#write.table(adjusted, "prank-mafft_overlap.txt", quote = F, row.names = F, sep = "\t")
#write.table(adjusted, "prank-05_MC__bg=13k__go=danio-bbh_withEffect.txt", quote = F, row.names = F, sep = "\t")
#write.table(adjusted, "mafft-05_MC__bg=13k__go=danio-bbh.txt", quote = F, row.names = F, sep = "\t")
#write.table(adjusted, "prank-01-MC__bg=13k__go=danio-bbh.txt", quote = F, row.names = F, sep = "\t")
#write.table(adjusted, "prank-05_MC-ALL__bg=13k__go=danio-bbh.txt", quote = F, row.names = F, sep = "\t")
write.table(adjusted, "prank-05-MC__bg=13k__go=danio-bbh_forPaper.txt", quote = F, row.names = F, sep = "\t") # FINAL FOR PAPER

rm(list = ls())
