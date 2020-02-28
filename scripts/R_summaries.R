table <- read.table("no_whitespace", sep = " ")

unique_ids <- unique(table[,2])
names <- c("sum", "identifier")
result_frame <- data.frame(matrix(ncol=2,nrow=0))
colnames(result_frame) <- names
head(result_frame)
for(i in 1:length(unique_ids)){
	x <- table[(table[,2]==unique_ids[i]),]
	to_add <- data.frame(sum(x[,1]),as.character(unique_ids[i]))
	result_frame <- rbind(result_frame, to_add)
}

colnames(result_frame) <- c("sum","type")
write.table(result_frame, "added_results.txt",quote=FALSE,row.names=FALSE,sep="\t")

