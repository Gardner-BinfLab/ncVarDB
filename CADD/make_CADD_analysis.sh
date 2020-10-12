## WARNING: DO NOT RUN THIS SCRIPT AS A WHOLE. IT REQUIERS MANUAL DOWNLOADS OF INTERMEDIATE FILES.

## WARNING: this script will download file hg38.2bit (835.4MB) from UCSC database
# requires: python v3.7 and twoBitToFa (http://hgdownload.soe.ucsc.edu/admin/exe/)
# To use twoBitToFa one needs to add specification to $HOME/.hg.conf file (http://genome.ucsc.edu/goldenPath/help/mysql.html)
 
rsync -avzP rsync://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.2bit ./

## convert to CADD format for insertions and deletions:
python3 convert_to_CADD_format.py ../data/ncVar_pathogenic.vcf ncVar_pathogenic_CADD.vcf hg38.2bit

python3 convert_to_CADD_format.py ../data/ncVar_benign.vcf ncVar_benign_CADD.vcf hg38.2bit

##score variants in ncVar_pathogenic_CADD.vcf and ncVar_benign_CADD.vcf using online tool: https://cadd.gs.washington.edu/score to obtain CADD_pathogenic_classification.tsv and CADD_benign_classification.tsv
