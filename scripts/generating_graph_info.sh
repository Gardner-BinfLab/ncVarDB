

##Making bed file
tail -n +3 over_5_all_snps_no_alts.txt | awk '{print $1, $2,$2 }' | tr " " "\t" >over_5_all_snps.bed


##Making the path.bed file-  adding the regions
gawk 'BEGIN{FS=","; OFS="\t"} NR>1 {if($3~/MT/) {print "chr" $3, "0", $4+30000}
else {print "chr" $3, $4-30000, $4+30000}
}' ./repo/ncVar_pathogenic.csv >ncVar_path.bed


##intersect but reverse 
bedtools intersect -v -a over_5_all_snps.bed -b ncVar_path.bed >masked_snps_over_5_all.bed
##Cut 
cut -f 1,2 masked_snps_over_5_all.bed >cut_masked_snps
##get the info for the masked snps file
grep -f  cut_masked_snps over_5_all_snps_no_alts.txt >masked_over_5_all_snps_no_alts.txt
##Putting header, which is the 2nd row of file
sed -n 2p over_5_all_snps_no_alts.txt | cat - masked_over_5_all_snps_no_alts.txt >masked_over_5_all_snps_no_alts_info.txt
echo "After this you can run making_benign_set_freq_matched.R"
echo "The next steps can be found in docs/masked_snp_ucsc_instructions" 

