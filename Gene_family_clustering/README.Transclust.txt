1. [1_blast]
   Get all the proteins for platyfish, medaka and killifish -> make blast DB -> and run two all-against-all BLASTp
   Killifish-medka
   
   > makeblastdb -in killifish_medaka_all_proteins.fasta -dbtype prot -title killimedaka -out killimedaka
   > blastp -query killifish_medaka_all_proteins.fasta -task blastp -db killimedaka -out killi_medaka_blastout.txt  -evalue 1e-5
   
   Platyfish-medaka
   
   > makeblastdb -in Platyfish_medaka_all_proteins.fasta -dbtype prot -title platymedaka -out platymedaka
   > blastp -query platyfish_medaka_all_proteins.fasta -task blastp -db platymedaka -out platy_medaka_blastout.txt  -evalue 1e-5

2. Run TransClust using the blast results and all fasta sequences for killi-medaka and platy-medaka at different thresholds
   java -jar TransClust.jar -gui
   Perform clustering at 6 differet thresholds of 50 to 90
   
   [2_TrandsClust_killi_medaka]
   [2_TrandsClust_platy_medaka]
   
   For each comparison: the clusters are in the text file <Out_killi-medaka_all_clusters.txt>
   This has all the cluters at all thresholds. Each cluster is separated by ; and members in cluster by ,
   
3. To get the members in a clusters and make a parsable file uses
   *parseTransClust.pl*
   
   Run it one by one for each cluster threshold 50 to 90
   Input: <Out_killi-medaka_all_clusters.txt> or <Out_platy-medaka_all_clusters.txt>
   Output: <Processed_clusters_50/60/70/80/90.txt>

4. To plot the families that have at least 1 gene in each of the two species use
    *plot_platy_medaka_filtered.R*
    *plot_killi_medaka_filtered.R*
    
    Plots: <Killifish_Medaka.pdf>
           <Platyfish_Medaka.pdf>
           