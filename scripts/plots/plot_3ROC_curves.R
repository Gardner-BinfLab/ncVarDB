library(pROC)

setwd("/Users/sasha/Git/ncVarDB")

pathogenic_fathmm <- read.csv("FATHMM-XF/fathmm-xf_pathogenic_classification.tsv", sep="\t", stringsAsFactors=FALSE)
pathogenic_fathmm$ncVar_type <- "pathogenic"
benign_fathmm <- read.csv("FATHMM-XF/fathmm-xf_benign_classification.tsv", sep="\t", stringsAsFactors=FALSE)
benign_fathmm$ncVar_type <- "benign"
fathmm <- rbind(pathogenic_fathmm, benign_fathmm)
fathmm$Non.Coding.Score <- as.numeric(fathmm$Non.Coding.Score)
not_scored_variants <- fathmm[is.na(fathmm$Non.Coding.Score),]
fathmm <- fathmm[!is.na(fathmm$Non.Coding.Score),]

print("The number of FATHMM-XF analysed pathogenic variants:" )
nrow(fathmm[fathmm$ncVar_type=="pathogenic",])
print("The number of FATHMM-XF analysed benign variants:" )
nrow(fathmm[fathmm$ncVar_type=="benign",])

pathogenic_cadd <- read.delim("CADD/CADD_pathogenic_classification.tsv", stringsAsFactors=FALSE, skip=1)
names(pathogenic_cadd) <- c("CHROM", "POS", "REF", "ALT", "RawScore", "PHRED")
pathogenic_cadd$ncVar_type <- "pathogenic"
benign_cadd <- read.delim("CADD/CADD_benign_classification.tsv", stringsAsFactors=FALSE, skip=1)
names(benign_cadd) <- c("CHROM", "POS", "REF", "ALT", "RawScore", "PHRED")
benign_cadd$ncVar_type <- "benign"
cadd <- rbind(pathogenic_cadd, benign_cadd)
cadd$PHRED <- as.numeric(cadd$PHRED)
cadd$RawScore <- as.numeric(cadd$RawScore)

print("The number of CADD analysed pathogenic variants:" )
nrow(cadd[cadd$ncVar_type=="pathogenic",])
print("The number of CADD analysed benign variants:" )
nrow(cadd[cadd$ncVar_type=="benign",])

pathogenic_dann <- read.csv("DANN/DANN_pathogenic_classification.tsv", sep="\t", stringsAsFactors=FALSE)
pathogenic_dann$ncVar_type <- "pathogenic"
benign_dann <- read.csv("DANN/DANN_benign_classification.tsv", sep="\t", stringsAsFactors=FALSE)
benign_dann$ncVar_type <- "benign"
dann <- rbind(pathogenic_dann, benign_dann)
dann$score <- as.numeric(dann$score)
dann <- dann[!is.na(dann$score),]

print("The number of DANN analysed pathogenic variants:" )
nrow(dann[dann$ncVar_type=="pathogenic",])
print("The number of DANN analysed benign variants:" )
nrow(dann[dann$ncVar_type=="benign",])

roc_fathmm <- roc(fathmm$ncVar_type, fathmm$Non.Coding.Score)
roc_cadd <- roc(cadd$ncVar_type, cadd$RawScore)
roc_dann <- roc(dann$ncVar_type, dann$score)
auc_fathmm = paste(paste("FATHMM-XF (AUC = ", round(as.numeric(auc(roc_fathmm)), 3),  sep=""), ")", sep="")
auc_cadd = paste(paste("CADD (AUC = ", round(as.numeric(auc(roc_cadd)), 3),  sep=""), ")", sep="")
auc_dann = paste(paste("DANN (AUC = ", round(as.numeric(auc(roc_dann)), 3),  sep=""), ")", sep="")

png("scripts/plots/3ROCcurves.png",width = 4, height = 4, units = 'in', res = 300)
plot(roc_fathmm, col=1, main="ROC curves for three ncVar data analyses", lwd=1.3, cex.main=1, cex.lab=0.8, cex.axis=0.8, mar = c(4, 4, 4, 2))
plot(roc_cadd, col="red", lwd=1.3, add=TRUE)
plot(roc_dann, col="blue3", lwd=1.3, add=TRUE)
legend(0.65, 0.3, legend=c(auc_fathmm, auc_cadd, auc_dann),
       col=c(1,"red","blue3"), lty=1, lwd=1.3, cex=0.6)
dev.off()
