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
            df.at[index, "chr"]="M"
        location=str(row["pos"])
        position="chr"+chr+":"+str(int(location)-1)+"-"+location
        if len(reference)>1:
            error_df.append(row)
            print("There is more than one base at location "+location+".Ignoring this sequence")
            continue
        try:
            output=check_output(["twoBitToFa", "hg38.2bit:"+position, "stdout"])
            forward_nuc=str(output).split('\\n')[1].upper()
            if forward_nuc not in bases:
                print("ERROR: unexpected base at " + location+ ": " + forward_nuc + ". Ignoring this entry.")
            else:
                if forward_nuc != reference:
                    complement_ref=complements[reference]
                    if complement_ref != forward_nuc:
                        error_df.append(row)
                        print("The base at position "+location+" does not correspond to UCSC base even if complemented.")
                    else:
                        df.at[index,"ref"]=complement_ref
                        df.at[index,"alt"]=complements[mutant]
        except:
            error_df.append(row)
            print("Could not fetch base at position: " + position)

df.to_csv(output_csv_file_name, sep=",", mode='a', index=False)
error_df.to_csv(error_file_name, index=False)
