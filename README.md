# Bioinformatics_tools
Repository for VERO bioinformatics tools


## Contents
### metaSNV
Script to parse results from metaSNV analysis and output a count matrix

#### Usage
To use metaSNV, execute the following command in the command line:

`python metaSNV_organizer.py -i "called_SNPs.best_split_*" -s "all_samples.txt" -o "count_matrix.csv"`

Command-line Arguments
* -i specifies the input file pattern (e.g., "called_SNPs.best_split_*").
* -s specifies the path to the samples file.
* -o specifies the name of the output file.
