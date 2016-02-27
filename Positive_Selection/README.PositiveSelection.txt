README for identification the genes under positive selection. Representative sample inputs and outputs are shown for each step 
due to size constrains. Let us know if you want more.

1. Select all the genes that have a Bidirectional best hit (BBH) in at least 5 other fish genomes using the matrix
   of BBH in Annotation folder. Then get all the proteins and CDS for alignment in separate folders.
   
   Script: *1_getFishGeneSeqsForPAML.pl*
   Output: <fishgenelist.txt> => list of fish genes that have at least 5 BBH with other fishes (13637 ortholog groups)
           [fishproteins]     => protein sequences for all the ortholog groups
           [fishcds]          => cds sequences for all the ortholog groups
           
2. Align these using PRANK implemented in GUIDANCE software. The output is an
   aligned fasta file for each gene from all fish species and multiple files having all the GUIDANCE quality scores that
   can be used to filter. It will create one forlder for each gene. Input is a list of genes names.
   
   Script: *2_align_prank_guidance.pl*: change the output directory in the program and run the command
           - Input file: <fishgenelist.txt> without the heading
   Output: [alignments_prank] with a folders for each gene.

3. Since PAML only takes phylip formatted sequences, Convert the fasta format into phylip now.
   
   Script: *3_convert2paml.pl*
   Output: [alignments_prank_paml] having all alignments in PhyLip format.

4. Since we may have different species (5 to 8 fish) for different orthologous gene families, we may need to use different 
   species trees for gene families. So we generated a file having all possible trees and unroot them for PAML.
   
   Scripts: *1_generate_combinations.py* : Generate all combinations from a starting tree. Original tree is with all 8 fish from our phylogeny
            *2_unrootTrees.pl*           : Unroot all trees. Newick is a rooted format so I will have to convert trees in the unrooted format using PhyLip program retree
   Output:  [tree_combinations/trees]   Total 64 unique combinations
            [tree_combinations/trees_unrooted]

5. Run Codeml program in paml for branch-site model of the test of selection for each alignment.

   Script: *calculateSelection_branch-site.pl*
   Example Input: <genelist_3> a part of <fishgenelist.txt>
   Output: <paml_bs_prank-003.txt>
   
   *** There are 27 such chunks of outputs that will be merged to make one output file.
       Final result file: <paml_bs_prank_all-results.txt> in [4_parse_bs_prank] with sample data.
   
6. Filter all these files based on GUIDANCE parameters, do multiple hypothesis correction and create a final file for analysis.
   Details and README in: [4_parse_bs_prank]
   
7. To check that if any of the selected site have overlap with the ones that are variable among strains we intersected them with the strain differences.
   See: [selection_non-synonymouse_variation_overlap] for details and README.
   
   ** This corresponds to Figure S3C in the paper.
   
   
   