#! /usr/bin/env python3.7
import sys
import pandas as pd
import os

input_file_name=sys.argv[1]
output_file_name=sys.argv[2]

with open (input_file_name, 'r') as input_file:
    df=pd.read_csv(input_file, sep="\t", encoding = "ISO-8859-1")

output_df=pd.DataFrame([], columns=df.columns)

for index, row in df.iterrows():
    if row["class"]=="substitution" or row["class"]=="deletion":
        start_position=str(int(row["chromStart"])+1)
        end_position=str(int(row["chromEnd"])+1)
        new_row=pd.DataFrame([[row["chrom"],str(start_position),str(end_position),row["name"],row["strand"],row["refNCBI"],row["refUCSC"], row["minorAllele"], row["minorAlleleFreq"],   row["class"],row["avHet"],row["avHetSE"],row["func"],row["alleleFreqCount"],row["alleles"],row["alleleFreqs"]]], columns=output_df.columns)
        output_df=output_df.append(new_row, ignore_index=True)
    else:
        output_df=output_df.append(row, ignore_index=True)

if os.path.exists(output_file_name):
    os.remove(output_file_name)
with open(output_file_name, 'w') as output_file:
    output_df.to_csv(output_file, sep="\t", index=False)
