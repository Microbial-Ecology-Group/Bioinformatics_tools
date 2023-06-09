library(dada2)
library(optparse)

# Define the command line arguments
option_list <- list(
  make_option(c("-F", "--filtered-path"), type = "character", default = NULL, 
              help = "Path to the directory containing filtered fastq files"),
  make_option(c("-O", "--output-path"), type = "character", default = NULL, 
              help = "Path to save the sequence table")
)

# Parse the command line arguments
opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

# File parsing
filtpathF <- opt$filtered_path
filtpathR <- opt$filtered_path
filtFs <- list.files(filtpathF, pattern = "fastq.gz", full.names = TRUE)
filtRs <- list.files(filtpathR, pattern = "fastq.gz", full.names = TRUE)
sample.names <- sapply(strsplit(basename(filtFs), "_"), `[`, 1)
sample.namesR <- sapply(strsplit(basename(filtRs), "_"), `[`, 1)
if (!identical(sample.names, sample.namesR)) {
  stop("Forward and reverse files do not match.")
}
names(filtFs) <- sample.names
names(filtRs) <- sample.names
set.seed(100)

# Learn forward error rates
errF <- learnErrors(filtFs, nbases = 1e8, multithread = TRUE)

# Learn reverse error rates
errR <- learnErrors(filtRs, nbases = 1e8, multithread = TRUE)

# Sample inference and merger of paired-end reads
mergers <- vector("list", length(sample.names))
names(mergers) <- sample.names

for (sam in sample.names) {
  cat("Processing:", sam, "\n")
  derepF <- derepFastq(filtFs[[sam]])
  ddF <- dada(derepF, err = errF, multithread = TRUE)
  derepR <- derepFastq(filtRs[[sam]])
  ddR <- dada(derepR, err = errR, multithread = TRUE)
  merger <- mergePairs(ddF, derepF, ddR, derepR)
  mergers[[sam]] <- merger
}

rm(derepF)
rm(derepR)

# Construct sequence table and remove chimeras
seqtab <- makeSequenceTable(mergers)

# Save sequence table
output_file <- file.path(opt$output_path, "seqtab.rds")
saveRDS(seqtab, output_file)

# Commandline Prompt
Rscript Error.R --filtered-path /path/to/FWD/filtered --output-path /path/to/run1/output
