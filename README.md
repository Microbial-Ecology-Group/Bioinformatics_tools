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

### DADA2
There are 3 scrpits which can be used to run the DADA2 library on Big Data.

**1. For filtering and trimming use script filter.R**

Use the following command to run the script

`Rscript script.R --forward-path /path/to/FWD --reverse-path /path/to/REV --trunc-len 240 200 --max-ee 2 --trunc-q 11 --max-n 0 --rm-phix TRUE --compress TRUE --verbose TRUE --multithread TRUE`

**2. To Infer Sequence Variants use script Error.R**

Use the following command to run the script

`Rscript Error.R --filtered-path /path/to/FWD/filtered --output-path /path/to/run1/output`

**3. To Merge Runs, Remove Chimeras, Assign Taxonomy**

Use the following command to run the script

`Rscript Taxonomy.R --run1-seqtab /path/to/run1/output/seqtab.rds --run2-seqtab /path/to/run2/output/seqtab.rds --run3-seqtab /path/to/run3/output/seqtab.rds --taxonomy-file /path/to/silva_nr_v128_train_set.fa.gz --output-path /path/to/study`

### megares-update

Find new resistance genes in databases, cluster and annotate them, and add them
to MEGARes.
