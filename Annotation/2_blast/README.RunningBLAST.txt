1. BLAST database made using: 

  $ makeblastdb -in sequences/allgenomes.fasta -dbtype prot -title allgenomes -out allgenomes
   
   Where <allgenomes.fasta> is the concatenated protein sequences from the 20 genomes.
   The blast database is in [blastdb].
   
2. BLASTp was run for each genome in parallel using an example command below for Xenopus tropicalis.

  $ blastp -query "sequences\\xtropicalis_longest_proteins.txt" -task blastp -db "blastdb\\allgenomes" -out xtrpout  -evalue 1e-5  -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qcovs qcovhsp"

   The shell scripts to run BLAST on cluster are in [shellscripts] -- 20 files, one for each organism
   
3. Results of BLAST are in [blast_output] folder. These were used to process and filter the 
   annotations, identify bi-directional (or reciprocal) BLAST hits and final protein coding
   gene sets for N furzeri.
