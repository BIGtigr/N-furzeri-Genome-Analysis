1. To construct the Beeswarm plot from the lifespan or data from all the organisms. I download the 
file <anage_data.txt> from the AnAge database in August 2014.

2. There is data from all sorts of sources, so I filter the ones having medium to large
   sample size and data from keptivity. This is high confidence one, and will be used for plot
   
   Script: *parseAnAge.pl*
   Output: <Survival_All-In-Captivity_GoodData.txt>

3. I manually modified the output file to for plotting. Did following modifications:
   
   3.1 Modified category names in alphabetical for plotting as follows. These will be plotted in this order now.

       aInvrt : Invertebrates
       bFish  : Fish
       cAmphi : Mammals
       dRept  : Reptiles
       eBird  : Birds
       fMaml  : Mammals
   
   3.2 The lifespan of N furzeri GRZ is 1.1 in the AnAge -- Replcaed with the data in our lab i.e. 0.4 years
   
   3.3 Added the lifespan for Soveia and MZM0703 from our lab - respectively 0.76 and 1.04 years
   
   3.4 Merged cartilaginous and bony fish.
   
   3.5 Made a csv file
   
   OUTPUT: <Survival_All-In-Captivity_GoodData_Processed.csv>
   
4. Plot the lifespan/survival beeswarm plot
   
   Script: *survival_plot.R*
   