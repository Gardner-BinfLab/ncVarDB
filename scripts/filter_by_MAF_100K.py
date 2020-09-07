#! /usr/bin/env python3.7
import sys
import pandas as pd
import os

def get_index_of_minor_allele(allele_freqs):
    major_freq=max(allele_freqs)
    second_max=0.0
    minor_index=-1
    for i in range(0, len(allele_freqs)):
        if allele_freqs[i]>second_max and allele_freqs[i]!=major_freq:
            second_max=allele_freqs[i]
            minor_index=i
    return minor_index
    
def complement(allele):
    complements={"A":"T", "T":"A", "C":"G", "G":"C", "-":"-"}
    compl_allele=""
    for base in allele:
        compl_allele=compl_allele+complements[base]
    return compl_allele[::-1]

input_file_name=sys.argv[1]
output_csv_file_name=sys.argv[2]
error_file_name=sys.argv[3]
    
output_df=pd.DataFrame([], columns=["chrom","chromStart","chromEnd","name","strand","refNCBI","refUCSC", "minorAllele", "minorAlleleFreq",   "class","avHet","avHetSE","func","alleleFreqCount","alleles","alleleFreqs"])

chromosomes=["CHR"+str(i) for i in range(1,23)]
chromosomes.extend(["CHRM","CHRX","CHRY"])
complements={"A":"T", "T":"A", "C":"G", "G":"C"}

df=pd.read_csv(input_file_name, sep="\t", encoding = "ISO-8859-1", dtype="string")
    
error_df=pd.DataFrame([], columns=df.columns)

for index, row in df.iterrows():
    try:
        if row["chrom"].upper() in chromosomes:
            allele_freqs_str=str(row["alleleFreqs"]).strip(",").split(",")
            if len(allele_freqs_str)>=2:
                allele_freqs_float = [float(i) for i in allele_freqs_str]
                minor_index=get_index_of_minor_allele(allele_freqs_float)
                if minor_index!=-1:
                    minorAlleleFreq=allele_freqs_float[minor_index]
                    if 0.05<= minorAlleleFreq < 0.2:
                        minorAllele=str(row["alleles"]).strip(",").split(",")[minor_index]
                        reference=row["refUCSC"]
                        major_index=allele_freqs_float.index(max(allele_freqs_float))
                        majorAllele=str(row["alleles"]).strip(",").split(",")[major_index]
                        if (row["strand"]=="+" and reference==majorAllele) or (row["strand"]=="-" and reference==complement(majorAllele)):
                            if row["strand"]=="-":
                                compl_minorAllele=complement(minorAllele)
                                minorAllele=compl_minorAllele
                            new_row=pd.DataFrame([[row["chrom"],row["chromStart"],row["chromEnd"],row["name"],row["strand"],row["refNCBI"],row["refUCSC"], minorAllele, str(minorAlleleFreq),   row["class"],row["avHet"],row["avHetSE"],row["func"],row["alleleFreqCount"],row["alleles"],row["alleleFreqs"]]], columns=output_df.columns)
                            output_df=output_df.append(new_row, ignore_index=True)
    except (KeyError, IndexError):
        error_df=error_df.append(row)
            
if os.path.exists(output_csv_file_name):
    with open(output_csv_file_name, 'a') as output_file:
        output_df.to_csv(output_file, sep="\t", index=False, header=False)
else:
    with open(output_csv_file_name, 'w') as output_file:
           output_df.to_csv(output_file, sep="\t", index=False)
           
if os.path.exists(error_file_name):
    with open(error_file_name, 'a') as error_file:
        error_df.to_csv(error_file, sep="\t", index=False, header=False)
else:
    with open(error_file_name, 'w') as error_file:
        error_df.to_csv(error_file, sep="\t", index=False)

print("File "+ input_file_name + " have been processed.")




    


