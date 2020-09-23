# DO NOT RUN THIS SCRIPT AS A WHOLE. It requiers manual downloading files.
# requiers bedops v.2.4.39
# adjust paths:
pathogenic_file="/Users/sasha/Git/ncVarDB/data/ncVar_pathogenic.tsv"
benign_file="/Users/sasha/Git/ncVarDB/data/ncVar_benign.tsv"

# convert tsv to bed
Rscript make_bed_file.R ../data/ncVar_pathogenic.tsv ncVar_pathogenic.bed
Rscript make_bed_file.R ../data/ncVar_bening.tsv ncVar_benign.bed
# convert ncVar_pathogenic.bed and ncVar_benign.bed from 38 to 37 using UCSC hgLiftOover tool:  https://genome.ucsc.edu/cgi-bin/hgLiftOver to obtain ncVar_pathogenic_hg19.bed and ncVar_benign_hg19.bed
# download DANN_whole_genome_SNVs.bed.starch from https://cbcl.ics.uci.edu/public_data/DANN/data/
# unarchive
unstarch DANN_whole_genome_SNVs.bed.starch > DANN_whole_genome_SNVs.bed

# sort and extract scores
sort-bed ncVar_pathogenic_hg19.bed > sorted_ncVar_pathogenic_hg19.bed
bedextract DANN_whole_genome_SNVs.bed sorted_ncVar_pathogenic_hg19.bed > DANN_pathogenic_scores.bed

sort-bed ncVar_benign_hg19.bed > sorted_ncVar_benign_hg19.bed
bedextract DANN_whole_genome_SNVs.bed sorted_ncVar_benign_hg19.bed > DANN_benign_scores.bed

# convert DANN_pathogenic_scores.bed and DANN_benign_scores.bed to hg38 using UCSC hgLiftOover tool:  https://genome.ucsc.edu/cgi-bin/hgLiftOver to obtain DANN_pathogenic_scores_hg38.bed and DANN_benign_scores_hg38.bed

Rscript extract_scores_for_ncVar_variants.R $pathogenic_file DANN_pathogenic_scores.bed DANN_pathogenic_scores_hg38.bed DANN_pathogenic_classification.tsv path_error.tsv

Rscript extract_scores_for_ncVar_variants.R $benign_file DANN_benign_scores.bed DANN_benign_scores_hg38.bed DANN_benign_classification.tsv benign_error.tsv

Rscript ROCcurve_analysis.R DANN_pathogenic_classification.tsv DANN_benign_classification.tsv
