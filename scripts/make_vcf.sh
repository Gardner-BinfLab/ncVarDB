##Automatically update vcf files from most recent version of ncVar database
#adjust path
main_path="/Users/Sasha/Temp/Git/ncVarDB/"

Rscript make_VCFs.R $main_path
cat $main_path'data/pathogenic_vcf.csv' | tr ',' '\t' >path_vcf_intermediate
cat $main_path'data/benign_vcf.csv' | tr ',' '\t' >ben_vcf_intermediate
cat $main_path'docs/vcf_meta_info.txt' path_vcf_intermediate >$main_path'data/ncVar_pathogenic.vcf'
cat $main_path'docs/vcf_meta_info.txt' ben_vcf_intermediate >$main_path'data/ncVar_benign.vcf'
rm $main_path'data/pathogenic_vcf.csv'
rm $main_path'data/benign_vcf.csv'
rm path_vcf_intermediate
rm ben_vcf_intermediate


