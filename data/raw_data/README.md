 # Creating the files that do not come with this repository
 
 To create the "snp151_no_alts" file used in some scripts, download this very large file:
 
 
 ftp://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/snp151.txt.gz
 
 
 And run the command to remove alternate chromosomes
 ```bash
 grep -v '_' snp151.txt >snp151_no_alts 
 ```
 
 To create the file "over_5_percent_all_snps.txt" navigate to the UCSC table broswer
 
 https://genome.ucsc.edu/cgi-bin/hgTables
 
 Select track "All SNPs(151)", table snp151, region genome
 
 Under the filter options select aveHet >.05, func DOESN'T include frameshift, cds-indel, coding-synon, nonsense, missense, stop-loss to prevent coding variants being selected. Download this file using the "get output" button, as a gzip compressed file. 
 
 To remove alternate chromosomes run
 ```bash
 grep -v '_' over_5_percent_non_coding.txt >over_5_all_snps_no_alts.txt
```
 
 
 # VARIANT TYPES AND POSITIONS

# all_snps_positions.txt

This is a count of each position category, generated from the snp151_no_alts.txt file (not provided as it is very large) 

# all_snps_types.txt 

A count of each variant type category, from snp151_no_alts.txt

# over5allsnpspos.txt 

A count of each category of variant positions in the over_5_percent_all_snps.txt file (not provided as it is very large)

# over5allsnpstypes.txt

A count of each category of variant type category in the over_5_percent_all_snps.txt file (not provided as it is very large)

# over5noncodingpositions.txt

A count of each category of variant positions in every SNP in a noncoding region, with over 5% population frequency

# over5noncodingtypes.txt

A count of each category of variant type category in every SNP in a noncoding region, with over 5% population frequency


To make the full file (snp151) run, it was split into many files, and the following was run: 
find ./split_snp_no_alts/* | parallel -j20 ./counting_split_snp_muttypes.sh

otherwise processing_summaries.sh was used


# MISC

# benign_snps_with_alternate

The benign database with the processed alternate chromosome (Making_alt_allele_column.R)

# masked_over_5_all_snps_no_alts.txt

All snps, excluding the ncVar pathogenic snps +/- 20000 bp (not provided as it is very large)

# non_coding_chromosomes.txt

Needed for plotting the graphs

# over_5_all_snps_no_alts.txt

Every SNP in a non alternate chromosome with a heterozygosity of >0.05

# path_types.txt

the counted types of variants in the ncVar pathogenic dataset



This repository also represents a lot of manual work, if there is something that seems like it doesn't match up, it was likely done by hand

