__author__ = "Anish Rahul Talwelkar, Enrique Doster"

import argparse
import glob
import pandas as pd
import numpy as np
import os
import re

# Take as input the result files from metaSNV for called_SNPs

# Example command:
# python metaSNV_organizer.py -i "Output_metaSNV_results/snpCaller/called_SNPs" -s "metaSNV_sample_names.txt" -o "metaSNV_AMR_analytic_matrix.csv"

def process_file(file_path, samples_file):
    # Read the input file as df
    df = pd.read_csv(file_path, sep='\t', header=None)
    df = df.drop(columns=[5])
    df = df[4].str.split('|', expand=True)
    
    # Read the input file as df1
    df1 = pd.read_csv(file_path, sep='\t', header=None)
    new_df = df1.drop(columns=[4, 5])

    # Extract the filenames from the samples file paths
    with open(samples_file) as f:
        lines = f.readlines()
    
    samples_filenames = [os.path.basename(path.strip()) for path in lines]
    
    # Set the columns of df using the extracted filenames
    df.columns = samples_filenames

    # Create the 'variant_accession' column
    new_df['variant_accession'] = new_df.apply(lambda row: '|'.join([str(row[0]), str(row[1]), str(row[2]), str(row[3])]), axis=1)

    # Create a new DataFrame with only the 'variant_accession' column
    new_df = new_df[['variant_accession']]

    # Concatenate new_df and df
    final_df = pd.concat([new_df, df], axis=1)
    final_df = final_df.set_index(['variant_accession'])

    return final_df
    
    
def create_annotations(concatenated_df):
    # Split the 'variant_accession' column to create annotations
    annotations = concatenated_df.index.to_series().str.split('|', expand=True)

    # Assign columns based on the split, shifted by one column
    annotations.columns = ["variant_accession", "type", "class", "mechanism", "group", "snp"] + [f"extra_{i}" for i in range(annotations.shape[1] - 6)]
    
    # Concatenate the last two sections for the 'variant' column
    annotations['variant'] = annotations.iloc[:, -2:].apply(lambda x: '|'.join(x.dropna().astype(str)), axis=1)

    # Keep only the required columns
    annotations = annotations[["variant_accession", "type", "class", "mechanism", "group", "snp", "variant"]]

    return annotations 


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

        # Create and save annotations
        annotations = create_annotations(concatenated_df)
        annotation_output = f"annotations_{args.output}"
        annotations.to_csv(annotation_output, index=False)
        print(f"{annotation_output} created.")
        
    else:
        print(f"No files found matching the pattern: {args.input}")
else:
    print("No input files found.")
