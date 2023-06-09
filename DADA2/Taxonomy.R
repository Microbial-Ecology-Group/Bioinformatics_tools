library(dada2)
library(optparse)

# Define the command line arguments
option_list <- list(
  make_option(c("-R1", "--run1-seqtab"), type = "character", default = NULL,
              help = "Path to the seqtab.rds file from run 1"),
  make_option(c("-R2", "--run2-seqtab"), type = "character", default = NULL,
              help = "Path to the seqtab.rds file from run 2"),
  make_option(c("-R3", "--run3-seqtab"), type = "character", default = NULL,
              help = "Path to the seqtab.rds file from run 3"),
  make_option(c("-T", "--taxonomy-file"), type = "character", default = NULL,
              help = "Path to the SILVA taxonomy file"),
  make_option(c("-O", "--output-path"), type = "character", default = NULL,
              help = "Path to save the final seqtab.rds and tax.rds files")
)

# Parse the command line arguments
opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

# Merge multiple runs (if necessary)
st1 <- readRDS(opt$run1_seqtab)
st2 <- readRDS(opt$run2_seqtab)
st3 <- readRDS(opt$run3_seqtab)
st.all <- mergeSequenceTables(st1, st2, st3)

# Remove chimeras
seqtab <- removeBimeraDenovo(st.all, method = "consensus", multithread = TRUE)

# Assign taxonomy
tax <- assignTaxonomy(seqtab, opt$taxonomy_file, multithread = TRUE)

# Write to disk
seqtab_file <- file.path(opt$output_path, "seqtab_final.rds")
tax_file <- file.path(opt$output_path, "tax_final.rds")
saveRDS(seqtab, seqtab_file)
saveRDS(tax, tax_file)

# Command line prompt
Rscript Taxonomy.R --run1-seqtab /path/to/run1/output/seqtab.rds --run2-seqtab /path/to/run2/output/seqtab.rds --run3-seqtab /path/to/run3/output/seqtab.rds --taxonomy-file /path/to/silva_nr_v128_train_set.fa.gz --output-path /path/to/study
