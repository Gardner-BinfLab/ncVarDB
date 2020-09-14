##Automatically update vcf files from most recent version of ncVar database
#adjust path
main_path="/Users/sasha/Git/ncVarDB/"

Rscript make_VCFs.R $main_path
cat $main_path'docs/vcf_meta_info.txt' $main_path'data/pathogenic_vcf.tsv' >$main_path'data/ncVar_pathogenic.vcf'
cat $main_path'docs/vcf_meta_info.txt' $main_path'data/benign_vcf.tsv' >$main_path'data/ncVar_benign.vcf'
rm $main_path'data/pathogenic_vcf.tsv'
rm $main_path'data/benign_vcf.tsv'
