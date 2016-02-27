# Script to get the attributes for all protein coding genes from the current Ensembl version (v75)

# read organism names for biomart
org = readLines("species.txt")

# define a filename tag
tag = "_biomaRt_v75_20140403"

# load biomart libraray
library("biomaRt")

# Get the attributes to be listed in the file
attr = c("ensembl_gene_id", "external_gene_id", "chromosome_name", "start_position", "end_position", "strand", "band", "gene_biotype", "description")

# for all organisms or species
for (i in 1:length(org)){
	
	# load ensembl biomart in a variable named ensembl
	# if the organism is sea urchin  - use ensembl metazoa biomart
	
	if (identical (org[i], "spurpuratus_gene_ensembl")){
		ensembl = useMart("metazoa_mart_21", dataset="spurpuratus_eg_gene") # The dataset name is also slightly different in this case
	}
	# else use regular biomart and names
	else {
		ensembl = useMart("ensembl", dataset=org[i])
	}
	
	# generate file name
	filename = paste(org[i], tag, sep = "")
	
	var = getBM(attributes = attr, filters = 'biotype', values = 'protein_coding', mart = ensembl)
	
	write.table(var, file = filename, sep ="\t", quote=F, row.names = F)
	
	#print (org[i])
	
}
