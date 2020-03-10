setwd("~/Documents/Gardnerlab_bioinf/ncVariation_project/final_upload/scripts/")
table <- read.table("../data/raw_data/non_coding_chromosomes.txt")
library(ggplot2)
library(RColorBrewer)
table$V2 <- factor(table$V2,levels=c("1",'2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','Y','X'))

positions_all_over_5 <- read.delim("../data/raw_data/over5allsnpspos.txt", header=F)
positions_all_over_5_stripped <- positions_all_over_5
positions_all_over_5_stripped$V2 <- gsub(",.+", "", positions_all_over_5_stripped$V2)

positions_all <- read.table('../data/raw_data/all_snps_positions.txt',header=1)
positions_all_stripped <- positions_all
positions_all_stripped$position <- gsub(",.+" , "" , positions_all_stripped$position)

types_all_over_5 <- read.delim("../data/raw_data/over5allsnpstypes.txt", header=F)

positions_nc_over5 <- read.delim("../data/raw_data/over5noncodingpositions.txt",header=F)
colnames(positions_nc_over5) <- c("sum","position")
positions_nc_over5_stripped <- positions_nc_over5
positions_nc_over5_stripped$position <- gsub(",.+","",positions_nc_over5_stripped$position)


library(dplyr)
#full_join(positions_all_over_5, positions_nc_over5, by="V2")



unique_ids <- unique(positions_all_stripped[,2])
names <- c("sum", "identifier")
result_frame <- data.frame(matrix(ncol=2,nrow=0))
colnames(result_frame) <- names
head(result_frame)
for(i in 1:length(unique_ids)){
  x <- positions_all_stripped[(positions_all_stripped[,2]==unique_ids[i]),]
  to_add <- data.frame(sum(x[,1]),as.character(unique_ids[i]))
  result_frame <- rbind(result_frame, to_add)
}

colnames(result_frame) <- c("sum_all","position")
positions_all_aggregated <- result_frame



unique_ids <- unique(positions_all_over_5_stripped[,2])
names <- c("sum", "identifier")
result_frame <- data.frame(matrix(ncol=2,nrow=0))
colnames(result_frame) <- names
head(result_frame)
for(i in 1:length(unique_ids)){
  x <- positions_all_over_5_stripped[(positions_all_over_5_stripped[,2]==unique_ids[i]),]
  to_add <- data.frame(sum(as.integer(as.character((x[,1])))),as.character(unique_ids[i]))
  result_frame <- rbind(result_frame, to_add)
}

colnames(result_frame) <- c("sum_over5_all","position")
##Removing some text file artefacts
positions_over_5_aggregated <- result_frame[c(1,2,6,8:19),]


unique_ids <- unique(positions_nc_over5_stripped[,2])
names <- c("sum", "identifier")
result_frame <- data.frame(matrix(ncol=2,nrow=0))
colnames(result_frame) <- names
head(result_frame)
for(i in 1:length(unique_ids)){
  x <- positions_nc_over5_stripped[(positions_nc_over5_stripped[,2]==unique_ids[i]),]
  to_add <- data.frame(sum(as.integer(x[,1])),as.character(unique_ids[i]))
  result_frame <- rbind(result_frame, to_add)
}

colnames(result_frame) <- c("sum_over_5_nc","position")
positions_over_5_nc_aggregated <- result_frame


##Joining the over 5s to give the noncoding frame the required number of columns, then setting NAs to 0 
joined_over5_positions <- full_join(positions_over_5_nc_aggregated, positions_over_5_aggregated, by="position")
joined_over5_positions[is.na(joined_over5_positions)] <- 0


##joiing with the total SNPS
aggregated_total <- full_join(joined_over5_positions,positions_all_aggregated)


##Reading in counted pathogenic positions
path_positions_aggregated <- read.table("../data/raw_data/path_positions.txt")
colnames(path_positions_aggregated) <- c("sum_path", "position")
##Need multiple replace conditions
aggregated_total$position <- gsub("intron", "intronic", aggregated_total$position)
aggregated_total$position <-gsub("near-gene-3", "intergenic",aggregated_total$position)
aggregated_total$position <-gsub("near-gene-5", "intergenic",aggregated_total$position)
aggregated_total$position <-gsub("splice-3", "intronic",aggregated_total$position)
aggregated_total$position <-gsub("splice-5", "intronic",aggregated_total$position)
aggregated_total$position <-gsub("unknown", "intergenic",aggregated_total$position)
aggregated_total$position <-gsub("untranslated-3","3utr",aggregated_total$position)
aggregated_total$position <-gsub("untranslated-5","5utr",aggregated_total$position)
aggregated_total$position <-gsub("cds-indel","genic",aggregated_total$position)
aggregated_total$position <-gsub("coding-synon","genic",aggregated_total$position)
aggregated_total$position <-gsub("frameshift","genic",aggregated_total$position)
aggregated_total$position <-gsub("missense","genic",aggregated_total$position)
aggregated_total$position <-gsub("nonsense","genic",aggregated_total$position)
aggregated_total$position <-gsub("stop-loss","genic",aggregated_total$position)


##Whoops need to aggregate them again

positions_over_5_nc_aggregated <-  aggregate(sum_over_5_nc ~ position, aggregated_total,sum)
positions_over_5_aggregated <- aggregate(sum_over5_all ~ position, aggregated_total,sum)
positions_all_aggregated <- aggregate(sum_all ~ position, aggregated_total,sum)


joined_intermediate <- full_join(positions_all_aggregated, positions_over_5_aggregated)
aggregated_total <- full_join(joined_intermediate,positions_over_5_nc_aggregated)
aggregated_all <- full_join(aggregated_total,path_positions_aggregated)
aggregated_all[is.na(aggregated_all)] <- 0
##Logging, so set to 1 so it will turn to 0
aggregated_all[aggregated_all == 0] <- 1
library(reshape2)
melted_aggregated_all <- melt(aggregated_all)
ggplot(melted_aggregated_all, aes(x=position,y=log(value),fill=variable)) + 
  geom_bar(stat='identity', position=position_dodge(width=0.5), width=0.4) + 
  theme_bw() + 
  labs(title="Mutation positions summaries", x="Positions", y="Total number of mutations (log10)")








##Doing mutation types now
##Path types
types_path <- read.table("../data/raw_data/path_types.txt")
colnames(types_path) <- c("sum_path","type")
##benign types
types_all <- read.table("../data/raw_data/all_snps_types.txt", header=1)
types_over5 <- read.table("../data/raw_data/over5allsnpstypes.txt")
types_over_5_noncoding <- read.table("../data/raw_data/over5noncodingtypes.txt")


##single = substitution
##indel remains 
##named remains the same
##MNP = substitution 
##insertion and deletion remain the same
##microsatellite = insertion 

types_all$position <- gsub("microsatellite","insertion",types_all$position)
types_all$position <- gsub("mnp", "substitution",types_all$position)
types_all$position <- gsub("single","substitution",types_all$position)



types_over5$V2 <- gsub("microsatellite","insertion",types_over5$V2)
types_over5$V2 <- gsub("mnp", "substitution",types_over5$V2)
types_over5$V2 <- gsub("single","substitution",types_over5$V2)

types_over_5_noncoding$V2 <- gsub("microsatellite","insertion",types_over_5_noncoding$V2)
types_over_5_noncoding$V2 <- gsub("mnp", "substitution",types_over_5_noncoding$V2)
types_over_5_noncoding$V2 <- gsub("single","substitution",types_over_5_noncoding$V2)


types_over_5nc_aggregated <- aggregate(V1 ~ V2, types_over_5_noncoding, sum)
colnames(types_over_5nc_aggregated) <- c("type","sum_over_5_noncoding")

types_over_5all_aggregated <- aggregate(V1 ~ V2, types_over5, sum)
colnames(types_over_5all_aggregated) <- c("type","sum_over_5_all")

types_all_aggregated <- aggregate(sum ~ position, types_all, sum)
colnames(types_all_aggregated) <- c("type","sum_all")

##Joining 
library(dplyr)
joined_int <- full_join(types_all_aggregated, types_over_5all_aggregated, by="type")
joined_int <- full_join(joined_int,types_over_5nc_aggregated )
types_full_aggregated <- full_join(joined_int,types_path)
types_full_aggregated[is.na(types_full_aggregated)] <- 1


melted_types_full_aggregated <- melt(types_full_aggregated)
ggplot(melted_types_full_aggregated, aes(x=type, y=log(value),fill=variable)) + 
  geom_bar(stat='identity', position=position_dodge(width=0.5), width=0.4) + 
  theme_bw() + 
  labs(title="Mutation types summaries", y="Total number of mutations (log10)",x="Type")




benign <- read.csv("../data/raw_data/benign_snps_with_alternate.csv")

#####Reading in tbales for benign shuffled set 
benign_pos <- as.data.frame(table(benign$mut_position))
benign_type <- as.data.frame(table(benign$mut_type))

##swapping out labels for ncVar stuff
colnames(benign_pos) <- c("position","sum_benign")

##Comparing shuffled set to ensure proportions are retained
benign_pos$prop <- (benign_pos$sum_benign / sum(benign_pos$sum_benign)) * 100
positions_over_5_aggregated$prop <- (positions_over_5_aggregated$sum_over5_all / sum(positions_over_5_aggregated$sum_over5_all)) *100


benign_type$prop <- (benign_type$Freq / sum(benign_type$Freq)) * 100 
benign_type$Var1 <- gsub("microsatellite","insertion",benign_type$Var1)
benign_type$Var1 <- gsub("mnp", "substitution",benign_type$Var1)
benign_type$Var1 <- gsub("single","substitution",benign_type$Var1)

benign_types_aggregated <- aggregate(Freq ~ Var1, benign_type, sum)
colnames(benign_types_aggregated) <- c("type", "sum_benign")

joined_int <- full_join(types_all_aggregated, types_over_5all_aggregated, by="type")
joined_int <- full_join(joined_int,benign_types_aggregated)
types_full_aggregated <- full_join(joined_int,types_path)
types_full_aggregated[is.na(types_full_aggregated)] <- 1

melted_types_full_aggregated <- melt(types_full_aggregated)
ggplot(melted_types_full_aggregated, aes(x=type, y=log(value),fill=variable)) + 
  geom_bar(stat='identity', position=position_dodge(width=0.5), width=0.4) + 
  theme_bw() + 
  labs(title="Mutation types summaries", y="Total number of mutations (log10)",x="Type")


melted_no_named_no_indel_types <- melted_types_full_aggregated[melted_types_full_aggregated$type != c("in-del"),]
melted_no_named_no_indel_types <- melted_no_named_no_indel_types[melted_no_named_no_indel_types$type != c("named"),]

melted_no_named_no_indel_types$type <- gsub("insertion", "Insertion", melted_no_named_no_indel_types$type)
melted_no_named_no_indel_types$type <- gsub("deletion", "Deletion", melted_no_named_no_indel_types$type)
melted_no_named_no_indel_types$type <- gsub("substitution", "Substitution", melted_no_named_no_indel_types$type)


##Changing the names to allow colour scaling later

melted_no_named_no_indel_types$Dataset <- melted_no_named_no_indel_types$variable
melted_no_named_no_indel_types$Dataset <- gsub("sum_all","All SNPs", melted_no_named_no_indel_types$Dataset)
melted_no_named_no_indel_types$Dataset <- gsub("sum_over_5_all","High frequency SNPs", melted_no_named_no_indel_types$Dataset)
melted_no_named_no_indel_types$Dataset <- gsub("sum_benign","Benign set", melted_no_named_no_indel_types$Dataset)
melted_no_named_no_indel_types$Dataset <- gsub("sum_path","Pathogenic set", melted_no_named_no_indel_types$Dataset)


##Reorder and sort factors by descending
melted_no_named_no_indel_types$Dataset <- reorder(melted_no_named_no_indel_types$Dataset, melted_no_named_no_indel_types$value )
melted_no_named_no_indel_types$Dataset <- factor(melted_no_named_no_indel_types$Dataset, levels=rev(levels(melted_no_named_no_indel_types$Dataset)))


##Set a color blind palette
cbp1 <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")


types <-ggplot(melted_no_named_no_indel_types, aes(x=type, y=value,fill=Dataset)) + 
  geom_bar(stat='identity', position=position_dodge(width=0.5), width=0.4) + 
  labs(title="Comparison of variant types in each dataset", y="Total number of variants",x="Type") + 
  theme(text = element_text(size=45), axis.title.x=element_blank(), axis.text.x = element_text(angle = 45, hjust=1)) + 
  xlim("Substitution","Deletion","Insertion") + 
  scale_y_log10(limits=c(1,1e9))+ 
  scale_fill_manual(values=cbp1)






joined_intermediate <- full_join(positions_all_aggregated, positions_over_5_aggregated[,c(1,2)])
aggregated_total <- full_join(joined_intermediate,benign_pos[,c(1,2)])
aggregated_all <- full_join(aggregated_total,path_positions_aggregated)
aggregated_all[is.na(aggregated_all)] <- 1
##Logging, so set to 1 so it will turn to 0
melted_aggregated_all <- melt(aggregated_all)

##Changing some names around
melted_aggregated_all$position <- gsub("intronic","Intronic", melted_aggregated_all$position)
melted_aggregated_all$position <- gsub("genic","Genic", melted_aggregated_all$position)
melted_aggregated_all$position <- gsub("interGenic","Intergenic", melted_aggregated_all$position)
melted_aggregated_all$position <- gsub("3utr","3' UTR", melted_aggregated_all$position)
melted_aggregated_all$position <- gsub("5utr","5' UTR", melted_aggregated_all$position)


##Changing the names to allow colour scaling later

melted_aggregated_all$Dataset <- melted_aggregated_all$variable
melted_aggregated_all$Dataset <- gsub("sum_all","All SNPs", melted_aggregated_all$Dataset)
melted_aggregated_all$Dataset <- gsub("sum_over5_all","High frequency SNPs", melted_aggregated_all$Dataset)
melted_aggregated_all$Dataset <- gsub("sum_benign","Benign set", melted_aggregated_all$Dataset)
melted_aggregated_all$Dataset <- gsub("sum_path","Pathogenic set", melted_aggregated_all$Dataset)

##Reorder and sort factors by descending
melted_aggregated_all$Dataset <- reorder(melted_aggregated_all$Dataset, melted_aggregated_all$value )
melted_aggregated_all$Dataset <- factor(melted_aggregated_all$Dataset, levels=rev(levels(melted_aggregated_all$Dataset)))

positions <- ggplot(melted_aggregated_all, aes(x=position,y=value,fill=Dataset)) + 
  geom_bar(stat='identity', position=position_dodge(width=0.5), width=0.4) + 
  labs(title="Comparison of variant positions in each dataset", y="Total number of variants") +
  theme(text = element_text(size=45), axis.title.x=element_blank(), axis.text.x = element_text(angle = 45, hjust=1)) + 
  xlim("Intronic","Intergenic","Genic","ncRNA","3' UTR","5' UTR") +
  scale_y_log10(limits=c(1,1e9)) + 
  scale_fill_manual(values=cbp1)


theme_Publication <- function(base_size=14, base_family="helvetica") {
  library(grid)
  library(ggthemes)
  (theme_foundation(base_size=base_size, base_family=base_family)
    + theme(plot.title = element_text(face = "bold",
                                      size = rel(1.2), hjust = 0.5),
            text = element_text(),
            panel.background = element_rect(colour = NA),
            plot.background = element_rect(colour = NA),
            panel.border = element_rect(colour = NA),
            axis.title = element_text(face = "bold",size = rel(1)),
            axis.title.y = element_text(angle=90,vjust =2),
            axis.title.x = element_text(vjust = -0.2),
            axis.text = element_text(), 
            axis.line = element_line(colour="black"),
            axis.ticks = element_line(),
            panel.grid.major = element_line(colour="#f0f0f0"),
            panel.grid.minor = element_blank(),
            legend.key = element_rect(colour = NA),
            legend.position = "bottom",
            legend.direction = "horizontal",
            legend.key.size= unit(1, "cm"),
            legend.margin = unit(0, "cm"),
            legend.title = element_text(face="italic"),
            plot.margin=unit(c(10,5,5,5),"mm"),
            strip.background=element_rect(colour="#f0f0f0",fill="#f0f0f0"),
            strip.text = element_text(face="bold")
    ))
  
}

scale_fill_Publication <- function(...){
  library(scales)
  discrete_scale("fill","Publication",manual_pal(values = c("#386cb0","#fdb462","#7fc97f","#ef3b2c","#662506","#a6cee3","#fb9a99","#984ea3","#ffff33")), ...)
  
}

scale_colour_Publication <- function(...){
  library(scales)
  discrete_scale("colour","Publication",manual_pal(values = c("#386cb0","#fdb462","#7fc97f","#ef3b2c","#662506","#a6cee3","#fb9a99","#984ea3","#ffff33")), ...)
  
}
##Adding publication ready themes
positions + theme_Publication() + 
  labs(tag="A") +
  theme(text = element_text(size=38), axis.title.x=element_blank(), axis.text.x = element_text(angle = 45, hjust=1))

types + theme_Publication() + 
  labs(tag="B") + 
  theme(text = element_text(size=38), axis.title.x=element_blank(), axis.text.x = element_text(angle = 45, hjust=1))
###Plot side by side and add tag 
library(patchwork)

