1. [1_GeneOntology_data] This is to get the GO terms for killifish genes based on the
   orthologs of either human or zebrafish. I am trying two sets - GO based on all orthologs or
   GO based on only bi-directional-best (BBH) orthologs. Finally I will use GO based on only BBH
   Danio orthologs. The Annotation here is from my data and GO are downloaded from Ensembl using BioMart v75.

   1.1 *getHumanDanioOrth.pl* to get human and danio orthologs of killifish genes. The symbols here may not be
       the final symbol but I am more interested in direct human/danio othologs.
   
       <KF_Danio_BBH.txt>     :  Bidirectional best hits between killifish-zebrafish *** USED FOR ANALYSIS ***
       <KF_Danio_with-BH.txt> :  Only best hits between killifish-zebrafish
       <KF_Human_BBH.txt>     :  Bidirectional best hits between human-zebrafish
       <KF_Human_with-BH.txt> :  Only best hits between human-zebrafish
   
   1.2 From the above files take unique Danio and Human ids and paste in v75 Ensembl BioMart and download GO Id mapping.
       IN biomart select: Ensembl Gene ID, Associated Gene Name, GO Term Accession, GO Term Name, GO domain, GO Term Evidence Code
  
       <mart_export_go_danio> and <mart_export_go_danio.txt.gz>
       <mart_export_go_human> and <mart_export_go_human.txt.gz>

   1.3 *getGOFileForGostat.pl* Gets the file in Gostat format
       I am generating 4 files with all the go terms, I will filter GO terms for foreground and background from them.
       Run it 4 times for each dataset. These files can be input in GoStats package.
   
       <GO_danio_all-hits.txt>
       <GO_danio_bbh>
       <GO_human_all-hits>
       <GO_human_bbh>
   
2. [2_selected_genes] Contains list of selected genes and background.
   <considered_genes.txt>             : BACKGROUND. Have 13637 genes that were used for selection analysis. These make the background for GO enrichment.
   <prank_0.05_MultipleCorrected.txt> : 249 genes finally under selection after correcting for multiple comparison.


3. *HyperG_withEnrichment.R*: Does test for enrichment as descibed in the package GOStats. It also does multiple correction and calculates the enrichment value.
   I am running this for different datasets. Uncomment the input and output gene list for whatever data I want to use.

4. [3_go_results]
   It has the results of above test. There are all datasets here too. 
   
   The final file in the paper is: <prank-05-MC__bg=13k__go=danio-bbh_forPaper.txt>
   
5. [4_filter_and_plot]
   From the above result file I filter the top categories manually and plot it. This is for bubble-plot in Fig 3.
   Filtered terms are: <AllClassesForSelection.xlsx> and <goterms_for_plot_MHC.csv>
   
   Script to plot: *plot_bubbles_bar.R*
   
   Basically I try to select the terms that are also in other datasets and are among the top and enriched.
   
   *** Only the terms with at least 2X enrichment are shown in the plot. This is based on the filter in above excel sheet.
   
