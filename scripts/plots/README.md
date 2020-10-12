This directory contains all scripts and (some) intermediate data files that are reqierd to produce the graphs for the publication. 

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
