#setwd("/Users/Param/Work/Fish_genome/killifish_Medaka_clustering/2_TrandsClust_platy_medaka")

# Read the threshold you want to plot. FOr the paper I am using an intermediate threshold of 50
#families = read.table(file = "Processed_clusters_50.txt", header = T, sep = "\t")
#families = read.table(file = "Processed_clusters_60.txt", header = T, sep = "\t")
families = read.table(file = "Processed_clusters_70.txt", header = T, sep = "\t")
#families = read.table(file = "Processed_clusters_80.txt", header = T, sep = "\t")
#families = read.table(file = "Processed_clusters_90.txt", header = T, sep = "\t")

platy = families$platy[families$medaka > 0 & families$platy > 0] # All families with size > 0 for both
length(platy) # number of families

medaka = families$medaka[families$medaka > 0 & families$platy > 0] # All families with size > 0 for both
length(medaka) # number of families

# plot parameters
par(cex=2) # zoom
plot(medaka, platy, xlab="family size in Medaka", ylab="family size in Platyfish", main = "All families", col=rgb(0, 0, 1, 0.2), pch =20) 

# linear model 
medplat.lm <- lm(platy ~ medaka -1)
summary(medplat.lm)

# plot
plot(medaka, platy, xlab="Family size in medaka", ylab="Family size in platyfish", main = "All families", col=rgb(0, 0, 1, 0.2), pch =20) 
abline(medplat.lm,col="blue",lty="dashed")

medplat.lm <- lm(platy ~ medaka -1)
summary(medplat.lm)

# slope and std error of the line
slope = coef(summary(medplat.lm))[1]
error =  coef(summary(medplat.lm))[2]

text(10, 45, paste("Slope:", round(slope,digits = 3), "+/-", round(error,digits = 3)))

rm(list = ls())