setwd("~/Google Drive/MultikernelV6/")
###Upload pheno files and dosage file
drgphenos5=read.table("drgphenos_gg_c1_GWAS-GS.txt", header=T, stringsAsFactor=F)
load("GG.C1.C2_snps_21016.Rdata")
drgphenos5<-drgphenos5[which(drgphenos5$CLONE%in%row.names(snps)),]
snps<-snps[which(row.names(snps)%in%drgphenos5$CLONE),]
snps_ind<-snps[rownames(snps) %in% drgphenos5$CLONE,]
###Upload lists of annotated snps within genes related to pathways,DE genes,etc
starch<-read.table(file="annotation/starch.snps",header=F,stringsAsFactor=F)
mrna<-read.table(file="annotation/mirnas.snps",header=F,stringsAsFactor=F)
tf<-read.table(file="annotation/TFs.snps",header=F,stringsAsFactor=F)
root<-read.table(file="annotation/roots.snps",header=F,stringsAsFactor=F)
###Filtering and remove overlapping snps between lists
dfList <- list(starch,mrna,tf,root)
for(i in 1:length(dfList))
{
  dfList[[i]]<-as.data.frame(dfList[[i]][!duplicated(dfList[[i]][,1]),],stringsAsFactors=FALSE)
  colnames(dfList[[i]])<-"SNP"
}
names(dfList)<-c("starch","mrna","tf","root")
list2env(dfList, environment())
###
library(magrittr)
library(dplyr)
root<-root %>%filter(!(root[,1] %in% starch[,1]))
mrna<-mrna %>%filter(!(mrna[,1] %in% root[,1]))
mrna<-mrna %>%filter(!(mrna[,1] %in% starch[,1]))
tf<-tf %>%filter(!(tf[,1] %in% mrna[,1]))
tf<-tf %>%filter(!(tf[,1] %in% root[,1]))
tf<-tf %>%filter(!(tf[,1] %in% starch[,1]))
###
dfList  <- list(starch,mrna,tf,root)
results <- lapply(dfList, function(x) snps[,colnames(snps) %in% x$SNP])
names(results)<-c("snps_starch","snps_mrna","snps_tf","snps_root")
list2env(results, environment())
###
kinship<-list(snps_starch,snps_mrna,snps_tf,snps_root)
library(rrBLUP)
Amat_kinship <- lapply(kinship, function(x) A.mat(x-1))
names(Amat_kinship)<-c("A.starch","A.mrna","A.tf","A.root")
list2env(Amat_kinship, environment())

###source FoldCrossValidation.V3.emmreml function
library(foreach)
library(doParallel)
traits<-c("DM","logRTWT","logSHTWT","logRTNO")
proctime<-proc.time()
cl<-makeCluster(4)
registerDoParallel(cl)
alltraits.bio<- foreach(a=traits, cassava=icount(), .inorder=TRUE) %dopar% {
  require(EMMREML)
  traits<-c("DM","logRTWT","logSHTWT","logRTNO")
  crossval<-FoldCrossValidation.V3.emmreml(drgphenos5,traits[cassava],"CLONE",list(A.starch,A.mrna,A.tf,A.root),5,25)
}
stopCluster(cl)
proc.time() - proctime


