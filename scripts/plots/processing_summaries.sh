##remove starting whitespace
sed 's/^[ \t]*//g' $1 >no_whitespace
Rscript R_summaries.R
