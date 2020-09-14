library(pROC)

args=commandArgs(TRUE)

if (length(args)==0) {
  stop("There should be two argemants: pathigenic file name and benign file name in this order.n", call.=FALSE)
}

pathogenic_filename=args[1]
benign_filename=args[2]

pathogenic <- read.delim(pathogenic_filename, stringsAsFactors=FALSE, skip=1)
names(pathogenic) <- c("CHROM", "POS", "REF", "ALT", "RawScore", "PHRED")
pathogenic$ncVar_type <- "pathogenic"
benign <- read.delim(benign_filename, stringsAsFactors=FALSE, skip=1)
names(benign) <- c("CHROM", "POS", "REF", "ALT", "RawScore", "PHRED")
benign$ncVar_type <- "benign"
all_variants <- rbind(pathogenic, benign)
all_variants$PHRED <- as.numeric(all_variants$PHRED)
all_variants$RawScore <- as.numeric(all_variants$RawScore)


pdf("CADD_ROCcurve_PHRED.pdf")
plot.roc(all_variants$ncVar_type, all_variants$PHRED, print.thres=TRUE, print.thres.col="red", print.auc=TRUE)
dev.off()

pdf("CADD_ROCcurve_RawScore.pdf")
plot.roc(all_variants$ncVar_type, all_variants$RawScore, print.thres=TRUE, print.thres.col="red", print.auc=TRUE)
dev.off()
