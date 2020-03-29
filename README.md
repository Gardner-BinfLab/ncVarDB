# Welcome to ncVAR_db!
Repo for the ncVAR database
You can download this database using 
```bash
git clone https://github.com/Gardner-BinfLab/ncVarDB
```


# Motivation 
Variants within the non-coding genome  are frequently associated with phenotypes in genome-wide association studies. These regions may be involved in the regulation of gene expression, encode functional non coding RNAs, splicing, or other cellular functions. However, relatively few of these regions have been shown to be  causative of phenotypic variation. We have curated a list of well characterised non-coding human genome variants based on published evidence for causing functional consequences. In order to minimise possible annotation errors, two curators have independently verified the supporting evidence for pathogenicity of each non-coding variant from published literature. 
##Add paper link

# Project structure
Contained in this project are the final datasets, scripts, and additional raw data used in generating the ncVar database.

Data:

The final datasets, and the raw data used in the generation of the figures and benign dataset. Some files were too big for github but can be found on our Zenodo repository


Docs:

General helpful documents


Scripts: 

A collection of scripts used to generate results 


# Features
The ncVar database contains curated pathogenic variants, with a supplied benign control dataset.

The information contained in this database is as follows:

ID: An ID for this database 

Genome: The genome that the variant was found in 

Chr: The chromosome the variant is in 

Pos: The starting position of the variant (referring to the first affected nucleotide) 

Ref: The reference genome sequence

Alt: The variant sequence

Mutation_type: the type of mutation of the variant (single, insertion, deletion)

Mutation_position: The genomic position of the variant (intronic, 5utr, 3utr, ncRNA)

AveHet: The average heterozygosity across all populations of the variant 

AveHetSE: The average heterozygosity standard error across all populations of the variant

X_ref: Any ID’s from other databases e.g. dbSNP [REF] ClinVar [REF], OMIM [REF], Literature

The pathogenic dataset has an extra two columns:

Pubmed_ID: A pubmed identifier that relates to literature that confirms the pathogenicity of the variant

Phenotype: The phenotype associated with the variant (sourced from XXXX)



