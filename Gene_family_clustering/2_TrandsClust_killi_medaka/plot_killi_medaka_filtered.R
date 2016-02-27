#setwd("/Users/Param/Work/Fish_genome/killifish_Medaka_clustering/2_TrandsClust_killi_medaka")

# Read the threshold you want to plot. FOr the paper I am using an intermediate threshold of 50
# threshold: 70%, You can also read the other files here
#families = read.table(file = "Processed_clusters_50.txt", header = T, sep = "\t")
#families = read.table(file = "Processed_clusters_60.txt", header = T, sep = "\t")
families = read.table(file = "Processed_clusters_70.txt", header = T, sep = "\t")
#families = read.table(file = "Processed_clusters_80.txt", header = T, sep = "\t")
#families = read.table(file = "Processed_clusters_90.txt", header = T, sep = "\t")


# plot parameters
par(cex=2) # zoom
par(mfrow=c(2, 1)) # two rows

# To plot all the families and fit a line --------------------------------------------
killi = families$killi[families$medaka > 0 & families$killi > 0] # All families with size > 0 for both kili and medaka
length(killi) # number of families
medaka = families$medaka[families$medaka > 0 & families$killi > 0] # All families with size > 0 for both killi and medaka
length(medaka) # number of families

# linear model 
medkilli.lm <- lm(killi ~ medaka -1)
summary(medkilli.lm)

# plot
plot(medaka, killi, xlab="Family size in medaka", ylab="Family size in killifish", 
     main = "All families", col=rgb(1, 0, 0, 0.2), pch =20,ylim=c(0,280),xlim=c(0,280)) 
abline(medkilli.lm,col="red",lty="dashed")

# slope and std error of the line
slope = coef(summary(medkilli.lm))[1]
error =  coef(summary(medkilli.lm))[2]

# write it on the plot
text(50, 250, paste("Slope:", round(slope,digits = 3), "+/-", round(error,digits = 3)))

# remove these things
rm("killi", "medaka","slope","error","medkilli.lm")

# To exclude one family with 250 ZNF_235 copies and fit a line --------------------------

killi2 = families$killi[families$medaka > 0 & families$killi > 0 & families$medaka < 200 & families$killi < 200] # All families with size > 0 and < 200 for both
medaka2 = families$medaka[families$medaka > 0 & families$killi > 0 & families$medaka < 200 & families$killi < 200]

medkilli.lm2 <- lm(killi2 ~ medaka2 -1)
summary(medkilli.lm2)

plot(medaka2, killi2, xlab="Family size in medaka", ylab="Family size in killifish", 
     main = "All families with size < 200", col=rgb(1, 0, 0, 0.2), pch =20,ylim=c(0,50),xlim=c(0,50)) 
abline(medkilli.lm2,col="red",lty="dashed")

slope2 = coef(summary(medkilli.lm2))[1]
error2 =  coef(summary(medkilli.lm2))[2]

text(10, 45, paste("Slope:", round(slope2,digits = 3), "+/-", round(error2,digits = 3)))

rm(list = ls())

