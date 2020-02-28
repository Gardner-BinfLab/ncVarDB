##Matching and editing variant ID's for ncVar path
setwd("./Documents/Gardnerlab_bioinf/ncVariation_project")
path <- read.csv("matched_with_variants.csv", stringsAsFactors = F)

collapsed <- data.frame()
##for every ncVar entry
for(i in unique(path$ID)){
  ##subset that ID 
  X <- path[path$ID ==i,]
  ##Add id idenitifer
  X$variant_id <-  paste("clinvarID:",X$variant_id,sep="")
  ##If there's mmore than one entry
  if(nrow(X) > 1){
    ##collapse the entries
    for(i in 1:nrow(X)){
      ##If the entry has a clinvarID
      if(X[i, "variant_id"] != "clinvarID:NA"){
        id <- X[i,"variant_id"]
        X[1,"x_ref"] <- paste(as.character(X[1,"x_ref"]), as.character(id), sep=";")
      } 
      }
    collapsed <- rbind(collapsed, X[1,])
  } else { 
    ##No need to collapse them, just paste the column
    if(X$variant_id != "clinvarID:NA"){
      X$x_ref <- paste(as.character(X$x_ref), as.character(X$variant_id), sep=";")
      collapsed <- rbind(collapsed, X)
    } else{
      collapsed <- rbind(collapsed, X)
    }
      }
}

##Remove "dbsnp:NA" 
collapsed$x_ref <- gsub("dbsnp:NA", "NA", collapsed$x_ref)


##Joining on citation numbers now 





##Matching OMIM numbers now 
omim <- read.csv("./omim_entries.csv", stringsAsFactors = F)
##Make a list of unique names
names <- list()
omim_names <- data.frame(stringsAsFactors = F)
##Remove the NA's
for(i in unique(na.omit(omim$rs_id))){
  X <- subset(omim,omim$rs_id == i)
  name <- paste("omimID:",X$OMIM_num, sep="")
  if(name %in% names){
    next
  }
  names <- c(names, name)
  ##paste into dataframe
  XX <- collapsed[collapsed$pmed_ID == X$Literature,]
  try(XX$x_ref <- paste(XX$x_ref, name,sep=";"))
  collapsed[collapsed$ID %in% XX$ID, ] <- XX
}





collapsed$x_ref <- gsub("dbsnp:NA;", "", collapsed$x_ref)





write.csv(collapsed[,2:14], "collapsed_ncVar.csv", row.names = F)














