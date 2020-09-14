#Download (file common_non-coding_dbSNP151.txt) common non-coding variants from dbSNP151 using genome table browser:
#Use Common SNPs(151) - SNPs with >= 1% minor allele frequency (MAF), mapping only once to reference assembly. Use filter:  filter: not (snp151Common.chrom like '%\\_%') and not (FIND_IN_SET('cds-indel', snp151Common.func)>0  OR FIND_IN_SET('frameshift', snp151Common.func)>0  OR FIND_IN_SET('stop-loss', snp151Common.func)>0  OR FIND_IN_SET('missense', snp151Common.func)>0  OR FIND_IN_SET('nonsense', snp151Common.func)>0  OR FIND_IN_SET('coding-synon', snp151Common.func)>0  OR FIND_IN_SET('unknown', snp151Common.func)>0 )

#adjust the path to pathogenic csv file:
path_file_path="/Users/sasha/Git/ncVarDB/data/ncVar_pathogenic.tsv"

#make standard csv header

sed -i 1d  common_non-coding_dbSNP151.txt
tail -c +2 common_non-coding_dbSNP151.txt > tmp
mv tmp common_non-coding_dbSNP151.txt

#filter by minor allele frequencey (MAF):

#split the large file
mkdir common_nc_dbSNP151
sed 1d  common_non-coding_dbSNP151.txt > snps
cd common_nc_dbSNP151
split -l 100000 ../snps
cd ../
rm snps
header=$(head -1 common_non-coding_dbSNP151.txt)
for file in common_nc_dbSNP151/*; do
    echo $header > tmp
    cat $file >> tmp
    mv tmp $file
done

#filter by MAF
for file in common_nc_dbSNP151/*; do
    python3 filter_by_MAF_100K.py $file 5-20_percent_MAF_nc_dbSNP151.tsv error.tsv
done

#or filter by MAF without splitting
#python3 filter_by_MAF.py common_non-coding_dbSNP151.txt 5-20_percent_MAF_nc_dbSNP151.tsv error.tsv

#variants in error.tsv are excluded

#filter variants that are within 30000 bp from pathogenic
sh filter_within_30K.sh

#subsample to make the proportion of different regions and mutation types matched with pathogenic
Rscript filter_to_match_freq.R 5-20_percent_MAF_nc_dbSNP151_within30K.tsv $path_file_path ncVar_benign_full_data.tsv

#shift by one all substiutions and deletions to match with pathogenic
python3 shift_positions.py ncVar_benign_full_data.tsv tmp

#sort
head -1 tmp > ncVar_benign_full_data.tsv
sed 1d  tmp | sort -k1,1V -k2,2V >> ncVar_benign_full_data.tsv
rm tmp

#convert to ncVar format
Rscript convert_to_ncVar_format.R ncVar_benign_full_data.tsv ncVar_benign.tsv

mv ncVar_benign.tsv ../data
