This directory contains all scripts and (some) intermediate data files that are requierd to produce the graphs for the publication. 

# Figure 1 (frequency figure)
 
 Download this very large file:
 
 
 ftp://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/snp151.txt.gz
 
 
 And run the command to remove alternate chromosomes
 ```bash
 grep -v '_' snp151.txt >snp151_no_alts 
 ``

To avoid crashing computers, run 
```bash
split -b 30G snp151_no_alts
```

Then

```bash
find ./split_snp_no_alts/* | parallel -j20 ./counting_split_snp_muttypes.sh
``` 

This will simply take two solumns, and sort and count the occurence of the columns and outputs them into a file. 

Then run
```bash
cat snp_no_alts_muttypes.txt | sed 's/[0-9]*//g' | tr -d "[:blank:]" | sort | uniq -c >all_snps_muttypes.txt 
```

Then run this to count mutation types 

```bash
sh processing_summaries.sh all_snps_muttypes.txt
mv added_results.txt all_snps_types.txt
``` 

Finally, run
```
Rscript plot_frequencies.R
```

Two R data files 'high_freq_positions.rds' and 'high_freq_types.rds' were created using plot_frequencies.R from 'scripts/benign/5-20_percent_MAF_nc_dbSNP151.tsv'. This file was created when the benign data wss produced. It is too large and not included here. 

# Figure 2 (ROC curve figure)

First follow the instructions in the data analysis folders: FATHMM-XF, CADD, and DANN. Then use 'plot_3ROC_curves.R' to create the figure.

