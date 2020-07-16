#! /usr/bin/env python3.7
import sys
import pandas as pd
from subprocess import check_output

input_csv_file_name=sys.argv[1]
output_csv_file_name=sys.argv[2]
error_file_name=sys.argv[3]

df=pd.read_csv(input_csv_file_name, sep=",", encoding = "ISO-8859-1")

error_df=pd.DataFrame([], columns=df.columns)

bases=["A", "G", "C", "T"]
complements={"A":"T", "T":"A", "C":"G", "G":"C"}

for index, row in df.iterrows():
    if str(row["mut_type"])=="substitution":
        reference=str(row["ref"]).upper()
        mutant=str(row["alt"]).upper()
        chr=str(row["chr"])
        if chr=="MT":
            chr="M"
        location=str(row["pos"]) ##todo adjust for multiples
        position="chr"+chr+":"+str(int(location)-1)+"-"+location
        try:
            output=check_output(["twoBitToFa", "hg38.2bit:"+position, "stdout"])
            forward_nuc=str(output).split('\\n')[1].upper()
            if forward_nuc not in bases:
                print("ERROR: unexpected base at " + location+ ": " + forward_nuc + ". Ignoring this entry.")
            else:
                if forward_nuc != reference:
                    df.at[index,"ref"]=complements[reference]
                    df.at[index,"alt"]=complements[mutant]
        except:
            error_df.append(row)
            print("Could not fetch base at position: " + position)

df.to_csv(output_csv_file_name, sep=",", mode='a', index=False)
error_df.to_csv(error_file_name, index=False)
