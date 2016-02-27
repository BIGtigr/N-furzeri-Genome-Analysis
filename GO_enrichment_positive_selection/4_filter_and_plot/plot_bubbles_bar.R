#
# This is to plot a bubble plot in R for the selected Go enrichment terms
#

setwd('/Users/Param/Dropbox/Fish_paper/Code/Param/GO_enrichment_positive_selection/4_filter_and_plot')
#setwd("G:\\Dropbox\\Fish_paper\\Code\\Param\\GO_enrichment_positive_selection\\4_filter_and_plot")

library("ggplot2")

# This is manually made from the sheet
bar = read.table("goterms_for_plot_MHC.csv", header = T, sep = ",")

# change margins to fit the plot in
par(mar = c(3, 10, 1, 1))

# plot barplot
# rev is to reverse the order otherwise it will be from bottom to top
# las = 2 is to rotate the label of Y axis

#pdf("koko.pdf", width=10, height=10) # If you want in pdf uncomment this and graphics.off below
p <- ggplot(bar, aes(rev(padj), position))

p + geom_point(aes(colour = log(bar$enrichment), size = bar$Count)) + 
  scale_colour_gradient(low = "blue", high = "red") + 
  scale_size(range = c(3, 9)) +
  scale_y_discrete(label = rev(bar$Term)) # for Go Id it would be bar$GOBPID 

#graphics.off()

# This is for the bar plot: I am not using it now
#barplot(rev(-log10(bar$padj)), horiz = T, names.arg = rev(bar$Term), las = 2, xlim=c(0, 5)) # To plot Go term names
#barplot(rev(-log10(bar$padj)), horiz = T, names.arg = rev(bar$GOBPID), las = 2, xlim=c(0, 5)) # To plot Go Ids


rm(list = ls())

