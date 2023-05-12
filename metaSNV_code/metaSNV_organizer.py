__author__ = "Anish Rahul Talwelkar"

import argparse
import glob
import pandas as pd
import numpy as np
import os
import re

def process_file(file_path, samples_file):
    # Read the input file as df
    df = pd.read_csv(file_path, sep='\t', header=None)
    df = df.drop(columns=[5])
    df = df[4].str.split('|', expand=True)
    
    # Read the input file as df1
    df1 = pd.read_csv(file_path, sep='\t', header=None)
    new_df = df1.drop(columns=[4, 5])

    # Read the samples file and extract relevant lines
    with open(samples_file) as f:
        lines = f.readlines()
    new_lines = []
    for line in lines:
        match = re.search(r'[ms]\d+\.\w+\.\w+\.\w+\.\w+', line)
        if match:
            new_lines.append(match.group())

    # Set the columns of df using new_lines
    df.columns = new_lines

    # Create the 'variant_accession' column
    new_df['variant_accession'] = new_df.apply(lambda row: '|'.join([str(row[0]), str(row[1]), str(row[2]), str(row[3])]), axis=1)

    # Create a new DataFrame with only the 'variant_accession' column
    new_df = new_df[['variant_accession']]

    # Concatenate new_df and df
    final_df = pd.concat([new_df, df], axis=1)
    final_df = final_df.set_index(['variant_accession'])

    return final_df

# Parse command-line arguments
parser = argparse.ArgumentParser()
parser.add_argument('-i', '--input', help='Input file pattern (e.g., "called_SNPs.best_split_*")')
parser.add_argument('-s', '--samples', help='Samples file path')
parser.add_argument('-o', '--output', help='Output file name')
args = parser.parse_args()

# Process the input files
if args.input:
    file_paths = glob.glob(args.input)
    if file_paths:
        concatenated_df = pd.DataFrame()  # Create an empty DataFrame
        for file_path in file_paths:
            df = process_file(file_path, args.samples)
            concatenated_df = pd.concat([concatenated_df, df])
        
        # Save the concatenated DataFrame to a single output file
        concatenated_df.to_csv(args.output, index=True)
        print(f"{args.output} created.")
    else:
        print(f"No files found matching the pattern: {args.input}")
else:
    print("No input files found.")
