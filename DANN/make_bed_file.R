args=commandArgs(TRUE)

if (length(args)==0) {
  stop("Please provide arguments: input file name and output file name.n", call.=FALSE)
}

input_file_name=args[1]
output_file_name=args[2]

variants <-read.delim(input_file_name)

variants_snv <- variants[variants$mut_type=="substitution",]

variants_snv <- variants[length(variants$ref)==1,]

variants_snv$start <- variants_snv$pos-1

variants_snv$end <- variants_snv$pos

variants_snv_bed <- variants_snv[c("chr", "start", "end")]

variants_snv_bed$chr <- paste("chr", variants_snv_bed$chr, sep="")

write.table(variants_snv_bed, output_file_name, sep="\t", quote=F, row.names=F, col.names=F)


