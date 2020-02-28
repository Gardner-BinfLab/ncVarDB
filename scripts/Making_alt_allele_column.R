##Just chopping some letters off
##Reading in my controls file 
ucsc_ctrl <- read.delim("test.csv", stringsAsFactors = F)
alternate_column <- list()
for( i in 1:nrow(ucsc_ctrl)){
  ref <- ucsc_ctrl[i,"refNCBI"]
  spl <- strsplit(ucsc_ctrl[i,'observed'], '/')
  ret_splt <- !(spl[[1]] %in% ref)
  
  alternate <- spl[[1]][which(ret_splt)]
  alternate_column[[i]] <- alternate
}
ucsc_ctrl$Alternate_alle <- as.character(alternate_column)
write.csv(ucsc_ctrl, "ucsc_controls_w_alternate.csv")
