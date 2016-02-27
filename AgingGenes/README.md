### Process mouse and human data from LongevityMap

1. Downloaded the mouse and human aging genes from Genage (July 2014)
2. The downloaded files are   
     
   **human_genes.zip**	**genage_human.csv** : human GenAge  
   **models_genes.zip**	**genage_models.csv** : Aging genes from all model organisms including mouse  
   
3. Fou mouse, I filter to only get the mouse gaing genes where the longevity association is known.  
   **Filtered Mouse Genes.txt**
   
4. For human it's the same list just pasted in text
   **Human Aging Genes.txt**      
   
5. I use slightly different versions of the same program to get the corresponding fish genes.  
   Scripts: `[getOrthologIds_ForFishHuman.pl](HumanAgingGenes/getOrthologIds_ForFishHuman.pl)`  
            `getOrthologIds_ForFishMouse.pl`
            
   Output:  **MouseAgingGeneList_ForFish.txt**  
            **HumanAgingGeneList_ForFish.txt**  
            The output files have fish id, mouse/human symbol, longevity (for mouse) and humsn/mouse id
            
    _These files are used to overlap the positive selected genes from Fish_
    

### Process LongevityMap

1. Downloaded the longevity map 20150722 : In folder **LongevityMap**  
     
   File of interest: **longevity.csv**  
   I make a tab separated file **longevity_tsv.txt**
   
2. `parseLongevityMap.pl` gets the fish orthologs based on my annotation. The ones that do not have orthologs are printed.  
   **LongevityMap_FishOrthologs.txt**  
   