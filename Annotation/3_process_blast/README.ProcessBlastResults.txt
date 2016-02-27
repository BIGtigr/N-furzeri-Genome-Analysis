1. [1_best_hits_others_to_Nfur]
   Get the best N. furzeri hit of every gene for the 19 organisms
   Script: *1_getBestHits_Others-2-Nfur.pl*
   
2. [2_best_hits_others_to_Nfur]
   Get the best hit to other organisms for all N. furzeri predicted genes.
   
   Since there are so many predicted genes I split the file in 20 chunks having 
   2000 sequences each. 
   Script: *getBestHits.pl* to get the best hit to all 19 organisms for every killifish gene.
           *generateShell.pl* generates a shell file to run on cluster for each of the chunk.
   
   Outputs:
   <nfur_000> sequence chunks
   <nfur_000.sh> shell script
   <nfur_000_BH> parsed Best hit file

3. [3_bi-directional-best_hits]
   get the bi-directional best hits
   Script: *3_getBiDirBestHits.pl* : Run on cluster for each of the N furzeri sequence chunk.
   
4. Concatenate all the BBH files together to generate a final file -- get rid of the 
   headers in each chunk.

   <nfur_All_BBH_Ids.txt>

5. Generate another file to get the gene symbol for each best hit and BBH.
   [bi-directional-best_hits_symbols]
   Script: *4_getSymbols.pl*
   
6. Concatenate all the chunks with symbols also in a single file.
   <nfur_All_BBH_Symbol.txt>
   
7. [5_nr_blast]
   I also ran a BLAST against all the non-redundant (nr) databse, and incorporated it with the
   results of all-against-all BLAST. Parameters from this nr blast also are used for the genertaion
   of final symbols as described in the Methods in the paper.
   
   7.1 NR database downloaded on 2014/06/19 from ftp://ftp.ncbi.nlm.nih.gov/blast/db/FASTA
   7.2 Ran blast using the 32 sequence chunks (nr_000 to nr_032) on scg3
   7.3 [1_outfiles] has output for each sequence chunk.
   7.4 Get the best NR hits for each Nfur sequence
       Script: *2_getBH_nr.pl*
       Output: <2_Unique_nfur-ids_with_nr-hit.txt>
   7.5 [3_unique-GI] I get the name of each NR GI Id manually from Batch Entrez
   7.6 Get a file having the name of each Nr hit
       Script: *4_getBH_details.pl*
       Output: <4_Unique_nfur-ids_nr-hit_with-description.txt>
   7.7 *** Finally, combine the results from the NR with rest of the BLAST
       Script: *5_get-All-BBH-with-nr.pl*
       Output: <nfur_All_BBH_Symbol_with_nr.txt> 
      
8. The final file that I take into account for all the purposes having all ortholog ids
   <nfur_All_BBH_Symbol_with_nr.txt>
   <nfur_All_BBH_Symbol_with_nr.xlsx>

9. [6_ortholog_counts]
    
    This is to get the genes from killifish and other vertebrates that have ortholog in each other.
    I am using my blast results and 3 separate programs to parse the hits and only keep them if
    they correspond to one of our final filtered killifish gene.
    
    *getOrthologCounts_One-to-One.pl*    : To get one-to-one ortholog between killifish and other vertebrates
    *getOrthologCounts_Killi->Others.pl* : To get the kilifish final genes that have at least one ortholog in other vertebrates
    *getOrthologCounts_Others->Killi.pl* : To get the genes in other vertebrate that have at least one hit to final killifish genes
   
   OUTPUT:
   
   <Ortholog_Counts_Killifish-to-Others.txt>
   <Ortholog_Counts_One-to-One.txt>
   <Ortholog_Counts_Others-to-Killifish.txt>
   
   *** These numbers are used in Table S3.
   
   
