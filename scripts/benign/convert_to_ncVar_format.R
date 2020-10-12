args=commandArgs(TRUE)

input_filename=args[1]
output_filename=args[2]
error_filename=args[3]

benign_full_data <- read.delim(input_filename)

benign <-benign_full_data[c("chrom", "chromStart", "name", "refUCSC", "minorAllele", "minorAlleleFreq", "class", "func")]
num <- nrow(benign)
benign$genome=rep("hg38", num)
benign$ID=paste("ncVarB_A", sep="", formatC(c(1:num), width=6, flag=0))
benign <- benign[c("ID", "genome", "chrom", "chromStart", "refUCSC", "minorAllele", "class", "func", "minorAlleleFreq", "name")]
names(benign)<- c("ID", "genome", "chr", "pos", "ref", "alt", "mut_type", "mut_position", "MAF", "x_ref")
benign$chr <- gsub("chr", "", benign$chr)

error <- rbind(benign[benign$mut_type=="deletion" & benign$alt!="-",], benign[benign$mut_type=="insertion" & benign$ref!="-",], benign[benign$mut_type=="substitution" & (benign$ref=="-" | benign$alt=="-"),])

write.table(benign, output_filename, quote = F,row.names = F,sep = "\t")
write.table(error, error_filename, quote = F,row.names = F,sep = "\t")


