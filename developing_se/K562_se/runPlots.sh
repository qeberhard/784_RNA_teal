#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH -t 7-

#SBATCH -n 8
#SBATCH --mem=80g

module load r


infile1=$1


Rscript ${infile1}
