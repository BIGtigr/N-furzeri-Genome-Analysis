#setwd("/Volumes/Seagate Backup Plus Drive/Annotation_dropbox/Figure_1D_LifespanPlots/survival_plot.R") # Set your working directory
#setwd('~/Dropbox/Fish_paper/Code/Param/Figure_1D_LifespanPlots')

library("beeswarm") # Use the Beeswarm library

surv <- read.csv('Survival_All-In-Captivity_GoodData_Processed.csv', head=T, sep=',') 
levels(surv$group)

msurv_l <- subset(surv, surv$group=='fMaml')
msurv_ls <- msurv_l[order(msurv_l$years),]

bsurv_l <- subset(surv, surv$group=='eBird')
bsurv_ls <- bsurv_l[order(bsurv_l$years),]

rsurv_l <- subset(surv, surv$group=='dRept')
rsurv_ls <- rsurv_l[order(rsurv_l$years),]

asurv_l <- subset(surv, surv$group=='cAmphi')
asurv_ls <- asurv_l[order(asurv_l$years),]

fsurv_l <- subset(surv, surv$group=='bFish')
fsurv_ls <- fsurv_l[order(fsurv_l$years),]

isurv_l <- subset(surv, surv$group=='aInvrt')
isurv_ls <- isurv_l[order(isurv_l$years),]

surv_lf <- rbind(msurv_ls, rsurv_ls, asurv_ls, fsurv_ls, isurv_ls, bsurv_ls)

# Plot
beeswarm(years ~ group, method = "swarm", data = surv, 
         log = T, pch = 16, col = rainbow(6),
         vertical = F, xlab="",  ylab="Maximum Lifespan (Years)"
         )
