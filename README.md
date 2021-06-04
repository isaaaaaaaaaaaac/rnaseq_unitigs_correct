# rnaseq_unitigs_correct

## Introduction

This repository contains a simple script that uses both minia and kat to do the following:

 * Takes an `unitigs.fa` file as the input
 * Uses [Minia](https://github.com/GATB/minia) to remove the tips
 * Returns a `contigs.fa` file
 * Creates a plot comparing the frequencies of the k-mers of the `unitigs.fa` file with those of the `contigs.fa` file.

## Installation & Use

To install `rnaseq_unitigs_correct`, simply do the following:

    # get a local copy of the repository
    git clone https://github.com/isaac-nivet/rnaseq_unitigs_correct


The script to run is `src\rnaseq_unitigs_correct.sh`. Here is an simple example of a run, from the root of the repository:
    
    cd rnaseq_unitigs_correct
    bash src/run.sh -in ../SRR066468.unitigs.fa.gz -minia ../minia -kat ../miniconda3/bin/kat -k 31


The script's parameters are the following ones:
 * `-in`: the input file, an `unitigs.fa` file
 * `-minia`: [Minia](https://github.com/GATB/minia)'s directory
 * `-kat`:  [KAT](https://kat.readthedocs.io/en/latest/index.html)'s executable
 * `-python`: Python's executable. _Default: python3_.
 * `-output`: output directory for KAT's output. _Default: the root of the git repository_.
 * `-t`: the number of threads to use. _Default: 8_.
 * `-k`: the size of the k-mers to be considered by both Minia and KAT.

## Requirements

You will need [Minia](https://github.com/GATB/minia) and [KAT](https://kat.readthedocs.io/en/latest/index.html) for the script to work. You also must have Python installed.