# Trim and Assemble Paired-End FastQ 

## Objective of this workflow (besides just for a homework assignment)
This Nextflow workflow is designed to trim paired-end reads using Trimmomatic and then assemble them using SPAdes. The script takes paired-end reads in fastq.gz format as input, applies trimming parameters, and performs assembly to generate fasta format output files.

## WHAT YOU NEED ON YOUR MACHINE/ENVIRONMENT
1. Nextflow
2. Trimmomatic
3. Spades

## THE FILES GOING IN
Paired-end reads in fastq.gz format. Naming conventions of these files should be:
1.`{sample}_1.fastq.gz`
2.`{sample}_2.fastq.gz`

## WHAT TO SPECIFY
1. `params.reads`: the input paired-end reads in fastq.gz format.
2. `params.outdir`: the output directory where the assembled fasta files will be put

## THE FLOW
To execute the workflow, follow these steps:
1. Install Nextflow, Trimmomatic, and SPAdes on your system.
2. Execute the workflow using the following command:
   ```
   nextflow run hw1_nextflow.nf --reads "(sample)_{1,2}.fastq.gz" --outdir .
   ```

## WHATS COMING OUT
The workflow will produce trimmed and assembled fasta files for each pair of reads. These files can be found in the specified output directory.
