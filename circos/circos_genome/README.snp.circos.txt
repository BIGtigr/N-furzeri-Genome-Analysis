To plot the SNPs from the 3 strains on circos

1. *getSNPs_20150730.pl* reads the GATK files and calculates the number of snps on each scaffold in a 
   window of 20kb. I run it one by one for each of the three strains. 

   OUTPUTS: <MZM0403_wd=20k_20150730.txt>
            <MZM0703_wd=20k_20150730.txt>
            <GRZ_wd=20k_20150730.txt>
            
   *** These are used to plot the barplot in circos
   
2. <karyotype.killifish.all.txt>
   File manually made from scaffold lengths. This has longest scaffolds (>100000). I only plot
   100 largest in the circos using this file.
   
3. TO PLOT CIRCOS: Use the configuration file

   <killifish_scaffolds_only-snp_20150730.conf>
   <ideogram.conf>
   
   PLOTS: <circos.pdf>
          <circos.png>
          <circos.svg>
   