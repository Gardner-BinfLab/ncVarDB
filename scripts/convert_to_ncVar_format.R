args=commandArgs(TRUE)

input_filename=args[1]
output_filename=args[2]

benign_full_data <- read.delim(input_filename)

benign <-benign_full_data[c("chrom", "chromStart", "name", "refUCSC", "minorAllele", "minorAlleleFreq", "class", "func")]
num <- nrow(benign)
benign$genome=rep("hg38", num)
benign$ID=paste("ncVarB_A", sep="", formatC(c(1:num), width=6, flag=0))
benign <- benign[c("ID", "genome", "chrom", "chromStart", "refUCSC", "minorAllele", "class", "func", "minorAlleleFreq", "name")]
names(benign)<- c("ID", "genome", "chr", "pos", "ref", "alt", "mut_type", "mut_position", "MAF", "x_ref")

write.table(benign, output_filename, quote = F,row.names = F,sep = "\t")


