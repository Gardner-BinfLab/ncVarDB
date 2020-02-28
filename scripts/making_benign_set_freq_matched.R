##Testing out fread
setwd("Documents/Gardnerlab_bioinf/ncVariation_project/")
library(data.table)
##  DO NOT VIEW THIS
over_5_all_snps_full_table <- fread("masked_over_5_all_snps_no_alts_info.txt")
##pathogenic set for calculating probabulities
path <- read.csv("repo/ncVar_pathogenic.csv")


over_5_all_snps_full_table$class <- gsub("microsatellite","insertion",over_5_all_snps_full_table$class)
over_5_all_snps_full_table$class <- gsub("mnp", "substitution",over_5_all_snps_full_table$class)
over_5_all_snps_full_table$class <- gsub("single","substitution",over_5_all_snps_full_table$class)



over_5_all_snps_full_table$func <- gsub("intron", "intronic", over_5_all_snps_full_table$func)
over_5_all_snps_full_table$func <-gsub("near-gene-3", "intergenic",over_5_all_snps_full_table$func)
over_5_all_snps_full_table$func <-gsub("near-gene-5", "intergenic",over_5_all_snps_full_table$func)
over_5_all_snps_full_table$func <-gsub("splice-3", "intronic",over_5_all_snps_full_table$func)
over_5_all_snps_full_table$func <-gsub("splice-5", "intronic",over_5_all_snps_full_table$func)
over_5_all_snps_full_table$func <-gsub("unknown", "intergenic",over_5_all_snps_full_table$func)
over_5_all_snps_full_table$func <-gsub("untranslated-3","3utr",over_5_all_snps_full_table$func)
over_5_all_snps_full_table$func <-gsub("untranslated-5","5utr",over_5_all_snps_full_table$func)
over_5_all_snps_full_table$func <-gsub("cds-indel","genic",over_5_all_snps_full_table$func)
over_5_all_snps_full_table$func <-gsub("coding-synon","genic",over_5_all_snps_full_table$func)
over_5_all_snps_full_table$func <-gsub("frameshift","genic",over_5_all_snps_full_table$func)
over_5_all_snps_full_table$func <-gsub("missense","genic",over_5_all_snps_full_table$func)
over_5_all_snps_full_table$func <-gsub("nonsense","genic",over_5_all_snps_full_table$func)
over_5_all_snps_full_table$func <-gsub("stop-loss","genic",over_5_all_snps_full_table$func)



##Getting the percentages for the pathogenic set
table(path$mut_type)
table(path$mut_position)


##mut types
#deletion    insertion substitution 
#16            7          747 
#2.08%      0.91%        97.01%

##Mut positions
#3utr     5utr intronic    ncRNA 
#46       78      572       74 



##Sampling 1:1 for the two categories that don't have 
intergenic_high_freq <- over_5_all_snps_full_table[over_5_all_snps_full_table$func == "intergenic"]
intergenic_split <- split(intergenic_high_freq, intergenic_high_freq$class)
##Need 770 total so can use the actual numbers from the path set
rbind(
  intergenic_split$deletion[sample(nrow(as.data.frame(intergenic_split$deletion)),16)],
  intergenic_split$insertion[sample(nrow(as.data.frame(intergenic_split$insertion)),7)],
  intergenic_split$substitution[sample(nrow(as.data.frame(intergenic_split$substitution)),747)]
)


genic_high_freq <- over_5_all_snps_full_table[over_5_all_snps_full_table$func == "genic"]
genic_split <- split(genic_high_freq, genic_high_freq$class)
genic_split$deletion[sample(nrow(as.data.frame(genic_split$deletion)),16)]
genic_split$insertion[sample(nrow(as.data.frame(genic_split$insertion)),7)]
genic_split$substitution[sample(nrow(as.data.frame(genic_split$substitution)),747)]



##For every category in path, randomly sample 10 
intronic_high_freq <- over_5_all_snps_full_table[over_5_all_snps_full_table$func =="intronic"]
intronic_split <- split(intronic_high_freq, intronic_high_freq$class)
##572 intronic, so want 5720 ##97.01% = 5548.9 ##.91% = 52.052 ##2.08% = 118.976
intronic_split$deletion[sample(nrow(as.data.frame(intronic_split$deletion)),119)]
intronic_split$insertion[sample(nrow(as.data.frame(intronic_split$insertion)),52)]
intronic_split$substitution[sample(nrow(as.data.frame(intronic_split$substitution)),5549)]



utr3_high_freq <- over_5_all_snps_full_table[over_5_all_snps_full_table$func == "3utr"]
utr3_split <- split(utr3_high_freq, utr3_high_freq$class)
##46 so need 460 ## 97% = 446.2 0.91% = 4.186 ## 2.08% = 9.568
utr3_split$deletion[sample(nrow(as.data.frame(utr3_split$deletion)),10)]
utr3_split$insertion[sample(nrow(as.data.frame(utr3_split$insertion)),4)]
utr3_split$substitution[sample(nrow(as.data.frame(utr3_split$substitution)),446)]


utr5_high_freq <- over_5_all_snps_full_table[over_5_all_snps_full_table$func == "5utr"]
utr5_split <- split(utr5_high_freq, utr5_high_freq$class)
##78 so need 780 97% = 756.6 ##0.91% = 7.098 ## 2.08% = 16.224
utr5_split$deletion[sample(nrow(as.data.frame(utr5_split$deletion)),16)]
utr5_split$insertion[sample(nrow(as.data.frame(utr5_split$insertion)),7)]
utr5_split$substitution[sample(nrow(as.data.frame(utr5_split$substitution)),757)]


ncrna_high_freq <- over_5_all_snps_full_table[over_5_all_snps_full_table$func =="ncRNA"]
ncrna_split <- split(ncrna_high_freq, ncrna_high_freq$class)
##74 so need 740 ## 97% =717.8 ##0.91% = 6.734 #2.8% = 15.392
ncrna_split$deletion[sample(nrow(as.data.frame(ncrna_split$deletion)),15)]
ncrna_split$insertion[sample(nrow(as.data.frame(ncrna_split$insertion)),7)]
ncrna_split$substitution[sample(nrow(as.data.frame(ncrna_split$substitution)),718)]

sampled_bound <- rbind(
  intergenic_split$deletion[sample(nrow(as.data.frame(intergenic_split$deletion)),16)],
  intergenic_split$insertion[sample(nrow(as.data.frame(intergenic_split$insertion)),7)],
  intergenic_split$substitution[sample(nrow(as.data.frame(intergenic_split$substitution)),747)],
  genic_split$deletion[sample(nrow(as.data.frame(genic_split$deletion)),16)],
  genic_split$insertion[sample(nrow(as.data.frame(genic_split$insertion)),7)],
  genic_split$substitution[sample(nrow(as.data.frame(genic_split$substitution)),747)],
  intronic_split$deletion[sample(nrow(as.data.frame(intronic_split$deletion)),119)],
  intronic_split$insertion[sample(nrow(as.data.frame(intronic_split$insertion)),52)],
  intronic_split$substitution[sample(nrow(as.data.frame(intronic_split$substitution)),5549)],
  utr3_split$deletion[sample(nrow(as.data.frame(utr3_split$deletion)),10)],
  utr3_split$insertion[sample(nrow(as.data.frame(utr3_split$insertion)),4)],
  utr3_split$substitution[sample(nrow(as.data.frame(utr3_split$substitution)),446)],
  utr5_split$deletion[sample(nrow(as.data.frame(utr5_split$deletion)),16)],
  utr5_split$insertion[sample(nrow(as.data.frame(utr5_split$insertion)),7)],
  utr5_split$substitution[sample(nrow(as.data.frame(utr5_split$substitution)),757)],
  ncrna_split$deletion[sample(nrow(as.data.frame(ncrna_split$deletion)),15)],
  ncrna_split$insertion[sample(nrow(as.data.frame(ncrna_split$insertion)),7)],
  ncrna_split$substitution[sample(nrow(as.data.frame(ncrna_split$substitution)),718)]
  
)


write.csv(sampled_bound, "proportion_matched_benign.csv", quote = F,row.names = F)



