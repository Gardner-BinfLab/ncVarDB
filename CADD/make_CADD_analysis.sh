## WARNING: DO NOT RUN THIS SCRIPT AS A WHOLE. IT REQUIERS MANUAL DOWNLOADS OF INTERMEDIATE FILES.
## convert to CADD format for insertions and deletions:
python3 convert_to_CADD_format.py ../data/ncVar_pathogenic.vcf ncVar_pathogenic_CADD.vcf ../scripts/hg38.2bit

python3 convert_to_CADD_format.py ../data/ncVar_benign.vcf ncVar_benign_CADD.vcf ../scripts/hg38.2bit

##score variants in ncVar_pathogenic_CADD.vcf and ncVar_benign_CADD.vcf using online tool: https://cadd.gs.washington.edu/score to obtain CADD_pathogenic_classification.tsv and CADD_benign_classification.tsv
