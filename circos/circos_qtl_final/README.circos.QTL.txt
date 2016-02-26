For QTL plot in [PLOT QTL CIRCOS]

1. <Karyotype.Killifish.LG.txt> is the file I manually prepared from the QTL data. It has the length i terms of cM for each
   scaffold. I use it as my coordinate systm to plot circos. The file used to prepare this is <qtl_files/c1-logqvals.PROCESSED.txt>

2. Get Q values and their rounded position on circos to plot

   SCRIPT: *1_getQvalues_survival.pl*
   OUTPUT: <survivalQvals.txt>
   
   *** These are the Q-values to be plotted on circos
   
3. Scaffolds scaled to the length of LG and all markers and their position on LG

   SCRIPT: *2_getPositions.pl*
   OUTPUT: <markers.txt> : Has all the markers that mapped on LG
           *** This is the markers circle to be plotted on circos
           <intermediate-scaffolds.txt> scaled scaffold file, that I process more below.
   
4. Now process the file generated above 
   SCRIPT: *3_getScaffolds.pl*
   OUTPUT: <scaffolds_final.txt> 

5. Process some more to fix the end of scaffolds
   SCRIPT: *4_fixScaffoldEnds.pl*
   OUTPUT: <scaffolds_final_2.txt>
   
   *** This is the scaffold circle to be plotted on circos

6. PLOT QTL CIRCOS
   
   Use the conf files to plot circos
   <killifish.final.conf>
   <ideogram.conf>
   
   Final plots: <circos.svg>
                <circos.png>


