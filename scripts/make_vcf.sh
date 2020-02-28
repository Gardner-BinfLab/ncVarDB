##Automatically update vcf files from most recent version of ncVar database

Rscript make_VCFs.R
cat path_vcf.csv | tr ',' '\t' >path_vcf_intermediate
cat ben_vcf.csv | tr ',' '\t' >ben_vcf_intermediate
cat vcf_meta_info.txt path_vcf_intermediate >ncVar_path.vcf
cat vcf_meta_info.txt ben_vcf_intermediate >ncVar_ben.vcf


