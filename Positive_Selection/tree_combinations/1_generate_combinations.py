# This is to generate all the combinations of trees from my data 
# Input: <fishgenelist.txt>
# Output: all the trees in [trees] folder

from ete2 import Tree

# my species tree
t = Tree('((((((Killifish, Platyfish), Medaka), Sticklebac), (Tetraodon, Fugu)), Cod), Zebrafish);')
print "Tree with everything -----------"
print t

#
#                  /-Killifish
#               /-|
#            /-|   \-Platyfish
#           |  |
#         /-|   \-Medaka
#        |  |
#      /-|   \-Sticklebac
#     |  |
#     |  |   /-Tetraodon
#   /-|   \-|
#  |  |      \-Fugu
#--|  |
#  |   \-Cod
#  |
#  \-Zebrafish
#
print "-------------------------------"



file = open('fishgenelist.txt', 'r') # open the file with all the filtered genes
file.next()                          # remove the 1st file

for line in file:
        
    fishstr = line.split("\t")
    fishes = fishstr[4].split(",")   # split column 4 to get fishes that are there for this gene
    str = "_"						 # join fishes based on-
    print str.join(fishes)           # underscore
    outfile = str.join(fishes)       # get a variable for filename
    outfile = 'trees/'+outfile+'.txt'
    
    t.prune(fishes)                  # prune the tree -- keep only ones that are there
    print t                          # print pruned tree
    
    t.write(format=9, outfile=outfile) # write tree to an output file, if it exists already it wil be replaced and so i'll get non-redundant files

    # reset the tree to original tree
    t = Tree('((((((Killifish, Platyfish), Medaka), Sticklebac), (Tetraodon, Fugu)), Cod), Zebrafish);')    

        
        
        
        
        
        
        
        
        
        
        