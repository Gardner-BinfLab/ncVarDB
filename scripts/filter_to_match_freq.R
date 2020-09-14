library(data.table)
set.seed(0)

args=commandArgs(TRUE)

benign_unfiltered_filename=args[1]
pathogenic_filename=args[2]
output_benign_filename=args[3]

over_5_all_snps_full_table <- fread(benign_unfiltered_filename)
##pathogenic set for calculating probabulities
path <- read.delim(pathogenic_filename)

over_5_all_snps_full_table$class <- gsub("microsatellite","insertion",over_5_all_snps_full_table$class)
over_5_all_snps_full_table$class <- gsub("mnp", "substitution",over_5_all_snps_full_table$class)
over_5_all_snps_full_table$class <- gsub("single","substitution",over_5_all_snps_full_table$class)


over_5_all_snps_full_table$func <- gsub("intron", "intronic", over_5_all_snps_full_table$func)
over_5_all_snps_full_table$func <-gsub("near-gene-3", "intergenic",over_5_all_snps_full_table$func)
over_5_all_snps_full_table$func <-gsub("near-gene-5", "intergenic",over_5_all_snps_full_table$func)
over_5_all_snps_full_table$func <-gsub("splice-3", "intronic",over_5_all_snps_full_table$func)
over_5_all_snps_full_table$func <-gsub("splice-5", "intronic",over_5_all_snps_full_table$func)
over_5_all_snps_full_table$func <-gsub("untranslated-3","3utr",over_5_all_snps_full_table$func)
over_5_all_snps_full_table$func <-gsub("untranslated-5","5utr",over_5_all_snps_full_table$func)


##Getting the percentages for the pathogenic set

percentage=table(path$mut_type)/length(path$mut_type)

##Mut positions
path_mut_positions=table(path$mut_position)

##For every category in path, randomly sample 10

intergenic_high_freq <- over_5_all_snps_full_table[over_5_all_snps_full_table$func == "intergenic"]
intergenic_split <- split(intergenic_high_freq, intergenic_high_freq$class)

intronic_high_freq <- over_5_all_snps_full_table[over_5_all_snps_full_table$func =="intronic"]
intronic_split <- split(intronic_high_freq, intronic_high_freq$class)

utr3_high_freq <- over_5_all_snps_full_table[over_5_all_snps_full_table$func == "3utr"]
utr3_split <- split(utr3_high_freq, utr3_high_freq$class)

utr5_high_freq <- over_5_all_snps_full_table[over_5_all_snps_full_table$func == "5utr"]
utr5_split <- split(utr5_high_freq, utr5_high_freq$class)

ncrna_high_freq <- over_5_all_snps_full_table[over_5_all_snps_full_table$func =="ncRNA"]
ncrna_split <- split(ncrna_high_freq, ncrna_high_freq$class)

sampled_bound <- rbind(
    intergenic_split$deletion[sample(nrow(as.data.frame(intergenic_split$deletion)),round(as.vector(path_mut_positions["intergenic"])*10*percentage)[[1]])],
    intergenic_split$insertion[sample(nrow(as.data.frame(intergenic_split$insertion)),round(as.vector(path_mut_positions["intergenic"])*10*percentage)[[2]])],
    intergenic_split$substitution[sample(nrow(as.data.frame(intergenic_split$substitution)),round(as.vector(path_mut_positions["intergenic"])*10*percentage)[[3]])],
    intronic_split$deletion[sample(nrow(as.data.frame(intronic_split$deletion)),round(as.vector(path_mut_positions["intronic"])*10*percentage)[[1]])],
    intronic_split$insertion[sample(nrow(as.data.frame(intronic_split$insertion)),round(as.vector(path_mut_positions["intronic"])*10*percentage)[[2]])],
    intronic_split$substitution[sample(nrow(as.data.frame(intronic_split$substitution)),round(as.vector(path_mut_positions["intronic"])*10*percentage)[[3]])],
    utr3_split$deletion[sample(nrow(as.data.frame(utr3_split$deletion)),round(as.vector(path_mut_positions["3utr"])*10*percentage)[[1]])],
    utr3_split$insertion[sample(nrow(as.data.frame(utr3_split$insertion)),round(as.vector(path_mut_positions["3utr"])*10*percentage)[[2]])],
    utr3_split$substitution[sample(nrow(as.data.frame(utr3_split$substitution)),round(as.vector(path_mut_positions["3utr"])*10*percentage)[[3]])],
    utr5_split$deletion[sample(nrow(as.data.frame(utr5_split$deletion)),round(as.vector(path_mut_positions["5utr"])*10*percentage)[[1]])],
    utr5_split$insertion[sample(nrow(as.data.frame(utr5_split$insertion)),round(as.vector(path_mut_positions["5utr"])*10*percentage)[[2]])],
    utr5_split$substitution[sample(nrow(as.data.frame(utr5_split$substitution)),round(as.vector(path_mut_positions["5utr"])*10*percentage)[[3]])],
    ncrna_split$deletion[sample(nrow(as.data.frame(ncrna_split$deletion)),round(as.vector(path_mut_positions["ncRNA"])*10*percentage)[[1]])],
    ncrna_split$insertion[sample(nrow(as.data.frame(ncrna_split$insertion)),round(as.vector(path_mut_positions["ncRNA"])*10*percentage)[[2]])],
    ncrna_split$substitution[sample(nrow(as.data.frame(ncrna_split$substitution)),round(as.vector(path_mut_positions["ncRNA"])*10*percentage)[[3]])])

write.table(sampled_bound, output_benign_filename, quote = F,row.names = F,sep = "\t")



