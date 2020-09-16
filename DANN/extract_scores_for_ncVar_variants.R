args=commandArgs(TRUE)

if (length(args)<3) {
  stop("Please provide three arguments: ncVar file name, original file with DANN scores, converted to hg38 DANN score file, output file name.n, and error file name", call.=FALSE)
}

ncVar_file_name=args[1]
score_file_name=args[2]
score_hg38_file_name=args[3]
output_file_name=args[4]
error_file_name=args[5]

variants <-read.delim(ncVar_file_name)

variants <- variants[variants$mut_type=="substitution" & variants$chr!="Y"  & variants$chr!="M", ]

hg37_scores <- read.delim(score_file_name, header=F, col.names=c("chr", "start", "end", "ref", "alt", "score"))

scored_variants <- read.delim(score_hg38_file_name, header=F, col.names=c("chr", "start", "pos", "ref", "alt", "lost_score"))

#the end corresponds to pos in ncVar
scored_variants <- scored_variants[c("chr", "pos", "ref", "alt")]

scored_variants$score <- hg37_scores$score

scored_variants$unique_id <- paste(scored_variants$chr, scored_variants$pos, scored_variants$ref, scored_variants$alt, sep="_")

variants$unique_id <- paste(paste("chr", variants$chr, sep=""), variants$pos, variants$ref, variants$alt, sep="_")

scored_ncVar_variants <- scored_variants[scored_variants$unique_id %in% variants$unique_id, ]

unscored_ncVar_variants <- variants[!(variants$unique_id %in% scored_variants$unique_id),]

scored_ncVar_variants <- scored_ncVar_variants[c("chr", "pos", "ref", "alt", "score")]

unscored_ncVar_variants <- unscored_ncVar_variants[ ,names(unscored_ncVar_variants)!="unique_id"]

write.table(scored_ncVar_variants, output_file_name, sep="\t", quote=F, row.names=F)

write.table(unscored_ncVar_variants, error_file_name, sep="\t", quote=F, row.names=F)







