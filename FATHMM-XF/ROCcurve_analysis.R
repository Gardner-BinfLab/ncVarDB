library(pROC)

args=commandArgs(TRUE)

if (length(args)==0) {
  stop("There should be two argemants: pathigenic file name and benign file name in this order.n", call.=FALSE)
}

pathogenic_filename=args[1]
benign_filename=args[2]

pathogenic <- read.csv(pathogenic_filename, sep="\t", stringsAsFactors=FALSE)
pathogenic$ncVar_type <- "pathogenic"
benign <- read.csv(benign_filename, sep="\t", stringsAsFactors=FALSE)
benign$ncVar_type <- "benign"
all_variants <- rbind(pathogenic, benign)
all_variants$Non.Coding.Score <- as.numeric(all_variants$Non.Coding.Score)
all_variants <- all_variants[!is.na(all_variants$Non.Coding.Score),]


pdf("FATHMM-XF_ROCcurve.pdf")
plot.roc(all_variants$ncVar_type, all_variants$Non.Coding.Score, print.thres=TRUE, print.thres.col="red", print.auc=TRUE)
dev.off()
