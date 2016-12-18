#generate folds for cross validation
drgphenos5=read.table("drgphenos_gg_c1_GWAS-GS.txt", header=T, stringsAsFactor=F)
load("GG.C1.C2_snps_21016.Rdata")
drgphenos5<-drgphenos5[which(drgphenos5$CLONE%in%row.names(snps)),]
snps<-snps[which(row.names(snps)%in%drgphenos5$CLONE),]
###
DM<-na.omit(data.frame(drgphenos5$CLONE,drgphenos5$DM))
dataset<-DM
nFolds<-5
output <- list() 
DM<-data.frame(DM$drgphenos5.CLONE,seq(1:length(DM$drgphenos5.CLONE)))
colnames(DM)<-c("CLONE","ROW")

x <- function(dataset,nFolds){
  index <- 1:nrow(dataset)
  index <- sample(index) 
  fold <- rep(1:nFolds, each=nrow(dataset)/5)[1:nrow(dataset)]
  folds <- split(index, fold)
  return(folds) 
}
for(i in 1:10){ 
  result <- x(dataset,5)
  output <- c(output, list(result)) 
} 
################
for(i in 1:length(output))
{
  output[[i]]<-do.call(cbind,output[[i]])
  colnames(output[[i]]) <- c("fold1","fold2","fold3","fold4","fold5")
}
names(output)<-c(paste("rep",1:length(output),sep=""))
output <- lapply(output, function(x) as.data.frame(x))
list2env(output, environment())
################
  out <- vector("list", 5)
  for(i in seq(1:5))
  {
    library(dplyr)
    a<-select_(rep1, names.df[i])
    a<-as.matrix(a)
    colnames(a)<-"ROW"
    check<-merge(DM,a,by="ROW")
    check<-data.frame(1,check$CLONE)
    out[[i]] <- list(check)
  }
################
myrep<-function(g,h){
  out <- vector("list", 5)
  for(i in seq(1:5))
  {
    library(dplyr)
    c<-eval(parse(text=g))
    a<-dplyr::select_(c, names.df[i])
    a<-as.matrix(a)
    colnames(a)<-"ROW"
    check<-merge(DM,a,by="ROW")
    check<-data.frame(1,check$CLONE)
    out[[i]] <- list(check)
    Tax=as.symbol(paste("r",h,sep=""))
    names(out)<-c(paste(Tax,1:length(out),sep="f"))
    out<- lapply(out, function(x) as.data.frame(x))
  }
  return(out)
}
####EXAMPLE FOR REP1,REP NUMBER =1
d<-myrep("rep1",1)
lapply(names(d), function(x) {
  x1 <- out[[x]]
  write.table(x1,row.names=FALSE,col.names=FALSE,file=paste( x,".txt",sep=""),quote= FALSE)
})

