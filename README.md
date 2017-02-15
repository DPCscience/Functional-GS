# Functional-GS
Dunia Pino del Carpio, Roberto Lozano, et al.
Channel created to compile and share code for a functional GS article.
	We aim to improve genomic prediction models by
	
	-prioritizing SNPs with known biological/genomic function and following a multikernel approach
	-adjusting kinship matrices with an LD weight/score correction
	-annotating snps into genome structure categories: intro,exon,UTRs,etc	
	-including heritability values for genome structure categories



# Scripts short description:

getgformat.sh <- wrapper to transform a GBS vcf filtered file to the oxford "g" format required for running IMPUTE2

Folds.R<-R script to subset a large list of clone names to assign them into folds for "crossvalidation" GWAS			

bio_kernels.R<-R script to subset a large list of SNP names into lists based on their biological annotation, these SNP subsets will then be used for contruction Genomic relationship matrices (GRMs) 
