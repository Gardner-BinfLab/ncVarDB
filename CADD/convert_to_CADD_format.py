#! /usr/bin/env python3.7
import sys
import pandas as pd
from subprocess import check_output

if len(sys.argv) < 3:
    print("Please provide arguments: input vcf file name, output vcf file name, and path to hg38.bit file")
    exit()

input_vcf_file_name=sys.argv[1]
output_vcf_file_name=sys.argv[2]
path_to_hg38bit=sys.argv[3]
path_to_hg38bit=path_to_hg38bit.rstrip("/")

df=pd.read_csv(input_vcf_file_name, sep="\t", encoding = "ISO-8859-1",skiprows=2)

for index, row in df.iterrows():
    reference=str(row["REF"]).upper()
    mutant=str(row["ALT"]).upper()
    mut_type="substitution"
    if reference=="-":
        mut_type="insertion"
    if mutant=="-":
        mut_type="deletion"
    if mut_type=="insertion" or mut_type=="deletion":
        chr=str(row["#CHR"])
        location=str(row["POS"])
        if mut_type=="insertion":
           position="chr"+chr+":"+str(int(location)-1)+"-"+location
        if mut_type=="deletion":
            position="chr"+chr+":"+str(int(location)-2)+"-"+str(int(location)-1)
            df.at[index,"POS"]=str(int(location)-1)
        try:
            output=check_output(["twoBitToFa", path_to_hg38bit+":"+position, "stdout"])
            preceding_nuc=str(output).split('\\n')[1].upper()
            new_reference=preceding_nuc+reference
            new_reference=new_reference.replace("-", "")
            new_mutant=preceding_nuc+mutant
            new_mutant=new_mutant.replace("-", "")
            df.at[index,"REF"]=new_reference
            df.at[index,"ALT"]=new_mutant                
        except:
            print("Could not fetch base at position: " + position)

with open(output_vcf_file_name, 'w') as output_file:
    df.to_csv(output_vcf_file_name, sep="\t", index=False)

