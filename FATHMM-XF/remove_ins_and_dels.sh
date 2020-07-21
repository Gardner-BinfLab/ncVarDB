#adjust main path
main_path="/Users/Sasha/Temp/Git/ncVarDB"

mkdir data

echo "ID,genome,chr,pos,ref,alt,mut_type,mut_position,avHet,avHetSE,x_ref,pmed_ID,phenotype" > data/ncVar_pathogenic.csv

echo "ID,genome,chr,pos,ref,alt,mut_type,mut_position,avHet,avHetSE,x_ref" > data/ncVar_benign.csv

grep -w "substitution\|delins" $main_path'/data/ncVar_pathogenic.csv' >> data/ncVar_pathogenic.csv

grep -w "substitution\|delins" $main_path'/data/ncVar_benign.csv' >> data/ncVar_benign.csv

Rscript $main_path'/scripts/make_VCFs.R' $main_path'/FATHMM-XF/'

cat data/pathogenic_vcf.csv | tr ',' '\t' > path_vcf_intermediate
cat data/benign_vcf.csv | tr ',' '\t' > ben_vcf_intermediate
cat $main_path'/docs/vcf_meta_info.txt' path_vcf_intermediate > data/ncVar_pathogenic.vcf
cat $main_path'/docs/vcf_meta_info.txt' ben_vcf_intermediate > data/ncVar_benign.vcf
rm data/pathogenic_vcf.csv
rm data/benign_vcf.csv
rm path_vcf_intermediate
rm ben_vcf_intermediate





