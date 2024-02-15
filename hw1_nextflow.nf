#!/usr/bin/env nextflow

//Ths workflow takes paired-end reads in fastq.gz format and trims the reads (assuming fastqc has already been completed)
//The trimming is done using trimmomatic, which parameters can be changed as necessary
//The trimmed reads are appended with "".trimmed" and passed on to spades for assembly
//Execution of spades will provide a fasta format output

// DSL2 allows for us to use multiple channels more than once. DSL1 does not allow that unless there is forking
nextflow.enable.dsl=2

//define the parameters. Reads are the fastq.qz paired-end files... can be named accordingly
params.reads = "*_{1,2}.fastq.gz"

//output directory specified as current directory for ease
params.outdir = '.'

//define the process. The paired end reads are assigned unique identifier "id" for processing, the input is also defined as a tuple through the workflow
//Output is specified with assembly name which is the name of a folder to which spades will create
//the tuple-ing is used to represent the read pairs as a pair rather than two completely separate entities
process TrimAndAssemble {
    tag "${id}"

    input:
    tuple val(id), path(read1), path(read2)

    output:
    path("${id}.fasta")
    
    //HEADCROP trims the beginning reads by 10 bp
    //SLIDINGWINDOW trims bases from the ends of the reads where the quality dips below a certain a certain value
    //MINLEN  minimum length that a read must have after trimming in order to be kept

    //for spades, the usage is spades.py -1 <first read trimmed> -2 <second read trimmed> -o <output directory name>
    script:
    """
    trimmomatic PE -phred33 \\
        $read1 $read2 \\
        ${id}_R1.trimmed.fastq.gz ${id}_R1.unpaired.fastq.gz \\
        ${id}_R2.trimmed.fastq.gz ${id}_R2.unpaired.fastq.gz \\
        HEADCROP:10 SLIDINGWINDOW:4:10 MINLEN:30

    spades.py -1 ${id}_R1.trimmed.fastq.gz -2 ${id}_R2.trimmed.fastq.gz -o ${id}.fasta
    """
}

//define workflow of the two (already) combined steps
//"channel" creates a channel that can be referenced througout the workflow based on the parameter reads
//"fromFilePairs" is a method from Nextflow to make the channel from pairs of files
//"size:2" means that there are two file (each of the pair)
//"flat: true" this flattens the channel
workflow {
    read_pairs = Channel.fromFilePairs(params.reads, size: 2, flat: true)
    
    //read_pairs (input pre-processed) are passed to the actual process for 
    trimmed_assembled = read_pairs
        | TrimAndAssemble
}
