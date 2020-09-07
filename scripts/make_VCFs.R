args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("A main path argument must be supplied.n", call.=FALSE)
}

main_directory = args[1]
main_directory_no_slash = gsub('/$', '', main_directory)
wd = paste(main_directory_no_slash, "data", sep="/")
setwd(wd)
##Make VCFs from current database version 

Pathogenic <- read.delim("ncVar_pathogenic.csv")

path_VCF <- data.frame(Pathogenic$chr, Pathogenic$pos,Pathogenic$x_ref, Pathogenic$ref, Pathogenic$alt)

path_VCF$QUAL <- 50
path_VCF$PASS <- 'PASS'
path_VCF$INFO <- Pathogenic$ID

colnames(path_VCF) <- c("#CHR", "POS","ID", "REF", "ALT", "QUAL", "FILTER", "INFO")

##Remove the dbsnp string
path_VCF$ID <- gsub("dbsnp:", "", path_VCF$ID)
##Add info heading
path_VCF$INFO <- gsub('nc', 'NC=nc',path_VCF$INFO)

##Info header
#'##INFO=<ID=NC,Number=.,Type=String,Description="ncVAR ID">'


Benign <- read.delim("ncVar_benign.csv")

Ben_VCF <- data.frame(Benign$chr, Benign$pos,Benign$x_ref, Benign$ref, Benign$alt)
Ben_VCF$QUAL <- 50
Ben_VCF$PASS <- 'PASS'
Ben_VCF$INFO <- Benign$ID

colnames(Ben_VCF) <- c("#CHR", "POS","ID", "REF", "ALT", "QUAL", "FILTER", "INFO")

##Remove the dbsnp string
Ben_VCF$ID <- gsub("dbsnp:", "", Ben_VCF$ID)
##Add info heading
Ben_VCF$INFO <- gsub('nc', 'NC=nc',Ben_VCF$INFO)

write.table(Ben_VCF, "benign_vcf.csv", quote = F,row.names = F,sep = "\t")
write.table(path_VCF, "pathogenic_vcf.csv", quote = F,row.names = F,sep = "\t")


