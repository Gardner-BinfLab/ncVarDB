library(data.table)
library(ggplot2)

#adjust the path
setwd("/Users/sasha/Git/ncVarDB/")

all_positions <- read.delim("scripts/plots/all_snps_positions.txt")
all_positions$position <- gsub(",.+", "", all_positions$position)
all_positions <- setDT(all_positions)
all_positions <- all_positions[, list(Number=sum(sum)), by="position"]
all_positions$position <- gsub("intron|splice-3|splice-5", "intronic", all_positions$position)
all_positions$position <- gsub("near-gene-3|near-gene-5", "intergenic", all_positions$position)
all_positions$position <- gsub("untranslated-3", "3utr", all_positions$position)
all_positions$position <- gsub("untranslated-5", "5utr", all_positions$position)
#all_positions$position <-gsub("unknown", "intergenic", all_positions$position) #TODO should we treat the unknown as intergenic?
all_positions$position <-gsub("cds-indel|coding-synon|frameshift|missense|nonsense|stop-loss","genic",all_positions$position)
all_positions <- all_positions[, list(Number=sum(Number)), by="position"]
all_positions <- setDF(all_positions)
names(all_positions) <- c("mut_position", "Number")
all_positions$Dataset <- "dbSNP"
all_positions <- all_positions[all_positions$mut_position != "unknown",]

all_types <- read.delim("scripts/plots/all_snps_types.txt")
all_types$position <- gsub("single|mnp", "substitution", all_types$position)
all_types$position <- gsub("microsatellite", "insertion", all_types$position)
all_types <- all_types[all_types$position!="in-del" & all_types$position!="named",] #TODO classify those in-del and named in one of the three categories: insertion, deletion, substitution
all_types <- setDT(all_types)
all_types <- all_types[, list(Number=sum(sum)), by="position"]
all_types <- setDF(all_types)
names(all_types) <- c("mut_type", "Number")
all_types$Dataset <- "dbSNP"


#high_freq <- read.delim("scripts/benign/5-20_percent_MAF_nc_dbSNP151.tsv")
#high_freq_positions <- data.table(high_freq["func"], Number=rep(1,nrow(high_freq)))
#high_freq_positions <- high_freq_positions[, list(Number=sum(Number)), by="func"]
#high_freq_positions$func <- gsub(",.+", "", high_freq_positions$func)
#high_freq_positions <- high_freq_positions[, list(Number=sum(Number)), by="func"]
#high_freq_positions$func <- gsub("intron|splice-3|splice-5", "intronic", high_freq_positions$func)
#high_freq_positions$func <-gsub("near-gene-3|near-gene-5", "intergenic",high_freq_positions$func)
#high_freq_positions$func <-gsub("untranslated-3","3utr",high_freq_positions$func)
#high_freq_positions$func <-gsub("untranslated-5","5utr",high_freq_positions$func)
#high_freq_positions <- high_freq_positions[, list(Number=sum(Number)), by="func"]
#high_freq_positions <- setDF(high_freq_positions)
#names(high_freq_positions) <- c("mut_position", "Number")
#high_freq_positions$Dataset <- "5-20% MAF dbSNP"
#saveRDS(high_freq_positions, file = "scripts/plots/high_freq_positions.rds")

high_freq_positions <- readRDS("scripts/plots/high_freq_positions.rds")

#high_freq_types <- data.table(high_freq["class"], Number=rep(1,nrow(high_freq)))
#high_freq_types  <- high_freq_types[, list(Number=sum(Number)), by="class"]
#hf_indels <- high_freq[high_freq$class=="in-del",]
#high_freq_types <- rbind(high_freq_types, data.table( class=c("insertion", "deletion", "substitution"), Number=c(nrow(hf_indels[hf_indels$refUCSC=="-",]), nrow(hf_indels[hf_indels$minorAllele=="-",]), nrow(hf_indels[hf_indels$refUCSC!="-" & hf_indels$minorAllele!="-",]))))
#high_freq_types$class <- gsub("single", "substitution", high_freq_types$class)
#high_freq_types$class <- gsub("mnp", "substitution", high_freq_types$class)
#high_freq_types  <- high_freq_types[, list(Number=sum(Number)), by="class"]
#high_freq_types <- high_freq_types[high_freq_types$class!="in-del",]
#high_freq_types <- setDF(high_freq_types)
#names(high_freq_types) <- c("mut_type", "Number")
#high_freq_types$Dataset <- "5-20% MAF dbSNP"
#saveRDS(high_freq_types, file = "scripts/plots/high_freq_types.rds")

high_freq_types <- readRDS("scripts/plots/high_freq_types.rds")

benign <- read.delim("data/ncVar_benign.tsv")

benign_positions <- data.table(benign["mut_position"], Number=rep(1,nrow(benign)))
benign_positions <- benign_positions[, list(Number=sum(Number)), by="mut_position"]
benign_positions <- setDF(benign_positions)
benign_positions$Dataset <- "ncVar benign"

benign_types <- data.table(benign["mut_type"], Number=rep(1,nrow(benign)))
benign_types <- benign_types[, list(Number=sum(Number)), by="mut_type"]
benign_types <- setDF(benign_types)
benign_types$Dataset <- "ncVar benign"

path <- read.delim("data/ncVar_pathogenic.tsv")

path_positions <- data.table(path["mut_position"], Number=rep(1,nrow(path)))
path_positions <- path_positions[, list(Number=sum(Number)), by="mut_position"]
path_positions <- setDF(path_positions)
path_positions$Dataset <- "ncVar pathogenic"

path_types <- data.table(path["mut_type"], Number=rep(1,nrow(path)))
path_types <- path_types[, list(Number=sum(Number)), by="mut_type"]
path_types <- setDF(path_types)
path_types$Dataset <- "ncVar pathogenic"

positions <- rbind(all_positions, high_freq_positions, benign_positions, path_positions)
positions$mut_position <- gsub("intronic","Intronic", positions$mut_position)
positions$mut_position <- gsub("intergenic","Intergenic", positions$mut_position)
positions$mut_position <- gsub("3utr","3' UTR", positions$mut_position)
positions$mut_position <- gsub("5utr","5' UTR", positions$mut_position)

positions$Dataset <- factor(positions$Dataset, levels = c("dbSNP", "5-20% MAF dbSNP", "ncVar benign", "ncVar pathogenic"))

types <- rbind(all_types, high_freq_types, benign_types, path_types)
types$mut_type <- gsub("insertion", "Insertion", types$mut_type)
types$mut_type <- gsub("deletion", "Deletion", types$mut_type)
types$mut_type <- gsub("substitution", "Substitution", types$mut_type)

types$Dataset <- factor(types$Dataset, levels = c("dbSNP", "5-20% MAF dbSNP", "ncVar benign", "ncVar pathogenic"))

cbp1 <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

positions <- ggplot(positions, aes(x=mut_position, y=Number,fill=Dataset)) +
  geom_bar(stat='identity', position=position_dodge(width=0.4), width=0.3) +
  labs(title="Comparison of variant positions in each dataset", y="Total number of variants") +
  theme(axis.title.x=element_blank(), axis.text.x = element_text(angle = 45, hjust=1)) +
  xlim("Intronic","Intergenic","ncRNA","3' UTR","5' UTR") +
  scale_y_log10(limits=c(1,1e9)) +
  scale_fill_manual(values=cbp1)

types <-ggplot(types, aes(x=mut_type, y=Number,fill=Dataset)) +
  geom_bar(stat='identity', position=position_dodge(width=0.4), width=0.3) +
  labs(title="Comparison of variant types in each dataset", y="Total number of variants",x="Type") +
  theme(text = element_text(size=45), axis.title.x=element_blank(), axis.text.x = element_text(angle = 45, hjust=1)) +
  xlim("Substitution","Deletion","Insertion") +
  scale_y_log10(limits=c(1,1e9))+
  scale_fill_manual(values=cbp1)

theme_Publication <- function(base_size=14, base_family="Helvetica") {
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
            legend.key.size= unit(0.5, "cm"),
            legend.title = element_text(face="italic"),
            plot.margin=unit(c(5,5,5,5),"mm"),
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

library("ggpubr")

final_positions <- positions + theme_Publication() +
    theme(text = element_text(size=14), axis.title.x=element_blank(), axis.text.x = element_text(angle = 45, hjust=1))+ theme(legend.position = "none")
final_types <- types + theme_Publication() + theme(text = element_text(size=14), axis.title.x=element_blank(), axis.text.x = element_text(angle = 45, hjust=1))

png("scripts/plots/Frequency.png",width=7.5, height=8, res=600, units="in")

ggarrange(final_positions, final_types,
          labels = c("A", "B"),
          ncol = 1, nrow = 2)
