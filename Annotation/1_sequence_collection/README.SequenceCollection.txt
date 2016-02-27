1. [1_ensembl_75_ftp_20140402]
   Proteoms were downloaded from: Ensembl FTP or for sea urchin from Ensmebl metazoa FTP
   
2. [2_gene_details_biomart/biomart_files]
   Features for all the protein coding genes were downloaded using biomaRt package in R. 
   *get_biomaRt_files.R*

3. [2_gene_details_biomart/biomart_files_filtered]
   These files were filteted manually to remove the genes that are not on assembled chromosomes 
   or are on mitochondrial genome. Filtered files are in 

4. [3_ensembl_75_seqs_filtered]
   Longest protein transcript for each gene was obtained using the biomart-summary and ftp sequences.
   *getLongestProteinCodingGenes.pl*
   
6. [4_biomart_download_cds]
   Coding sequence (cds) will are needed for PAML. These were downloaded for 18 genomes using R biomaRt.
   Scripts: *1_getPeptideIds.pl* : generates idlist <prot_id_file.txt>
            *2_getCDS.R*         : downloads cds sequences kept in [cds_fils]
   
   For Sea urchin, since it belongs to separate Ensembl, the CDS was downloaded manually from Ensembl 
   Metazoa website.

7. [5_Nfurzeri_sequences]
   All the MAKER predicted protein, cds and transcript sequences for the killifish N. furzeri are in
   Protein sequences:    <nfurzeri_longest_proteins_all.txt>
   CDS sequences:        <nfurzeri_cds.fasta>
   Transcript sequences: <nfurzeri.all.maker.transcripts.fasta> 

8. All the filtered proitein sequences for 19 organisms and all predicted sequences for N. furzeri
   are used to run an all against all BLAST.
   