#!/bin/bash

#SBATCH -t 24:00:00
#SBATCH --mem=50G

bam_maps="bam_file_mappings.tsv"

while IFS='\t' read -r -a files; do
        samtools merge -o ${files[0]} ${files[1]} ${files[2]}
done < $bam_maps
