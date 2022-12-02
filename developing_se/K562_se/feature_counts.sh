#!/bin/bash

#SBATCH -t 48:00:00
#SBATCH --mem=50G
#SBATCH -n 8

bamfiles='../784_proj/K562/merged_bamfile/*.bam'


for FILE in $bamfiles; do
	exp_name="$(basename $FILE .bam)"
	featureCounts  -F GTF -p --countReadPairs -s 2 -a gencode.v39.basic.annotation.gtf -o featcounts/$exp_name.out $FILE

done
