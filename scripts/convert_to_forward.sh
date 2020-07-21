# this script converts "ref" and "alt" entries with "mutation type" "substitution" to bases that are on the forward strand. Insertions and deletions and one delin have been converted manually. 
# WARNING this script will download file hg38.2bit (835.4MB) from UCSC database 
# run from a directory that contains: convert_to_forward.py
# requires: python v3.7 and twoBitToFa (http://hgdownload.soe.ucsc.edu/admin/exe/)
# To use twoBitToFa one needs to add specification to $HOME/.hg.conf file (http://genome.ucsc.edu/goldenPath/help/mysql.html)

# adjust the path
path_to_original_csv="../data/ncVar_pathogenic.csv"
 
rsync -avzP rsync://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.2bit ./

python3 convert_to_forward.py $path_to_original_csv ncVar_pathogenic_forward.csv convert_to_forward_error_pathogenic
