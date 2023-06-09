library(dada2)
library(optparse)

# Define the command line arguments
option_list <- list(
  make_option(c("-F", "--forward-path"), type = "character", default = NULL, 
              help = "Path to the directory containing demultiplexed forward-read fastq files"),
  make_option(c("-R", "--reverse-path"), type = "character", default = NULL, 
              help = "Path to the directory containing demultiplexed reverse-read fastq files"),
  make_option(c("-t", "--trunc-len"), type = "numeric", default = c(240, 200),
              help = "Truncation lengths for forward and reverse reads (default: 240, 200)"),
  make_option(c("-e", "--max-ee"), type = "numeric", default = 2,
              help = "Maximum expected errors (default: 2)"),
  make_option(c("-q", "--trunc-q"), type = "integer", default = 11,
              help = "Truncation quality threshold (default: 11)"),
  make_option(c("-n", "--max-n"), type = "integer", default = 0,
              help = "Maximum number of N bases (default: 0)"),
  make_option(c("--rm-phix"), type = "logical", default = TRUE,
              help = "Remove PhiX sequences (default: TRUE)"),
  make_option(c("--compress"), type = "logical", default = TRUE,
              help = "Compress output files (default: TRUE)"),
  make_option(c("--verbose"), type = "logical", default = TRUE,
              help = "Enable verbose output (default: TRUE)"),
  make_option(c("--multithread"), type = "logical", default = TRUE,
              help = "Enable multithreading (default: TRUE)")
)

# Parse the command line arguments
opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

# File parsing
pathF <- opt$forward_path
pathR <- opt$reverse_path
filtpathF <- file.path(pathF, "filtered")
filtpathR <- file.path(pathR, "filtered")
fastqFs <- sort(list.files(pathF, pattern = "fastq.gz"))
fastqRs <- sort(list.files(pathR, pattern = "fastq.gz"))
if (length(fastqFs) != length(fastqRs)) {
  stop("Forward and reverse files do not match.")
}

# Filtering parameters
truncLen <- opt$trunc_len
maxEE <- opt$max_ee
truncQ <- opt$trunc_q
maxN <- opt$max_n
rm.phix <- opt$rm_phix
compress <- opt$compress
verbose <- opt$verbose
multithread <- opt$multithread

# Filtering
filterAndTrim(fwd = file.path(pathF, fastqFs), filt = file.path(filtpathF, fastqFs),
              rev = file.path(pathR, fastqRs), filt.rev = file.path(filtpathR, fastqRs),
              truncLen = truncLen, maxEE = maxEE, truncQ = truncQ, maxN = maxN,
              rm.phix = rm.phix, compress = compress, verbose = verbose, multithread = multithread)



