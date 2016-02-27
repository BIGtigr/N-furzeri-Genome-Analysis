1. Get the list of Ids havibg only bi-directional-best hits

   <1_Bi-Directional_Best_Hits_Ids.txt>          : The file having all the information about bidirectional best hits (BBH) and their ids for all 20 genomes.
   <2_Bi-Directional_Best_Hits_Ids_ForTree.xlsx> : Seleted 619 genes manually and transposed to get and concatenate their sequences.
   <3_Bi-Directional_Best_Hits_Ids_ForTree.txt>  : Transposed 619 BBH for all the 19 genomes. These will be used for phylogeny.

   I filter using excel manually the ones having all 19 BBH in a new file 
   I need to first filter and then transpose using Excel.
   <Bi-Directional_Best_Hits_Ids_ForTree.txt>
   <Bi-Directional_Best_Hits_Ids_ForTree.xlsx>

2. Get sequences corresponding to these 619 genes
   Script: *getSequencesForTree.pl* reads above file and gets the concatenated sequences for the ones having all 19 BBH in 
   Output: <4_SeqsForTree.fasta>

3. Align using MAFFT on oldie
   Mafft command: /usr/local/bin/mafft  --auto --anysymbol "4_SeqsForTree.txt" > "5_AlnForTree.fasta"
   Output: <5_AlnForTree.fasta>
   
4. Filter alignment using Gblocks to get conserved blocks. Gblock was run interactively using default parameters.
   Output: <6_AlnForTree-gb.fasta>
      
5. Use ProTest to get the parameters to construct phylogeny.
   [7_ProtTest] contains the <output.txt> for the datasets. 
   Best model according to BIC: LG+I+G so I will use this in PhyMl but let PhyML select the best parameters.

6. Fasta alignment is converted to phylip for phylogeny using:
   http://sequenceconversion.bugaco.com/converter/biology/sequences/fasta_to_phylip.php
   <AlnForTree_repeat_gb.phylip>

   Finally, Construct a maximum-likelihood tree in PhyML-3.1.
   Results are in:  [8_PhyML-3.1]

   <AlnForTree_repeat_gb.phylip_phyml_stats.txt> : PhyML parameters and input etc.
   <AlnForTree_repeat_gb.phylip_phyml_boot_stats.txt> : Bootstrap statistics
   <AlnForTree_repeat_gb.phylip_phyml_boot_trees.txt> : All bootstrap trees
   <AlnForTree_repeat_gb.phylip_phyml_tree.txt>  : Final species tree
      
7. This tree was rooted in Mega using C. elegans as outgroup
   
   <AlnForTree_repeat_gb.phylip_phyml_tree.nwk> is the same tree as above
    *** The final tree in paper is <species_tree_final_modified_MEGAsession.pdf>
    
    The MEGA6 session is saved in <species_tree_final_modified_MEGAsession.mts>
    
    
   
