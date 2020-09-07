#This script requiers bedtools
#adjust the path
path_file_path="/Users/sasha/Git/ncVarDB/data/ncVar_pathogenic.csv"

tail +2 $path_file_path | tr ',' '\t' | awk '{$3="chr"$3; printf "%s %s %s\n", $3, $4-30000, $4+30000}'| tr " " "\t" > ncVar_pathogenic.bed

#remove negative ranges and sort
awk '{print $1, ($2>0?$2:0), $3}' ncVar_pathogenic.bed | tr ' ' '\t' > tmp
sort -k1,1V -k2,2V tmp > ncVar_pathogenic.bed

#intersect but reverse
bedtools intersect -v -a 5-20_percent_MAF_nc_dbSNP151.csv -b ncVar_pathogenic.bed > 5-20_percent_MAF_nc_dbSNP151_within30K.csv

#add the header
head -1 5-20_percent_MAF_nc_dbSNP151.csv > tmp
cat 5-20_percent_MAF_nc_dbSNP151_within30K.csv >> tmp
mv tmp 5-20_percent_MAF_nc_dbSNP151_within30K.csv
