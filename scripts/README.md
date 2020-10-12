# Script descriptions


# R_summaries.R
Called during processing_summaries.sh, this counts the occurence of each unique variant type and outputs it to a file called 'added_results.txt' which can then be manually renamed

# counting_split_snp_muttypes.sh

To avoid crashing computers, run 
```bash
split -b 30G snp151_no_alts
```

Called as a part of the command

```bash
find ./split_snp_no_alts/* | parallel -j20 ./counting_split_snp_muttypes.sh
``` 

Simply takes two solumns, and sorts and counts the occurence of the columns and outputs them into a file

then run
```bash
cat snp_no_alts_muttypes.txt | sed 's/[0-9]*//g' | tr -d "[:blank:]" | sort | uniq -c >all_snps_muttypes.txt 
```

# make_VCFs.R

Used after everything has been generated to create VCFs from the .csv files ncVar_pathogenic.csv and ncVar_benign.csv. Called as part of make_vcf.sh 

# processing_summaries.sh

Creates summaries for the large snp151_no_alts file. Collapses the raw files into a file with unique mutation positions or types
