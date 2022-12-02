#!/bin/bash

#SBATCH -t 1:00:00
#SBATCH --mem=50G
#SBATCH -n 8



featureCounts  -F GTF --countReadPairs -a gencode.v39.basic.annotation.gtf -o featcounts/ENCSR004VIR.out ../784_proj/K562/merged_bamfile/ENCSR004VIR.bam
featureCounts  -F GTF --countReadPairs -a gencode.v39.basic.annotation.gtf -o featcounts/ENCSR090LNQ.out ../784_proj/K562/merged_bamfile/ENCSR090LNQ.bam
featureCounts  -F GTF --countReadPairs -a gencode.v39.basic.annotation.gtf -o featcounts/ENCSR248TXP.out ../784_proj/K562/merged_bamfile/ENCSR248TXP.bam
featureCounts  -F GTF --countReadPairs -a gencode.v39.basic.annotation.gtf -o featcounts/ENCSR256NCI.out ../784_proj/K562/merged_bamfile/ENCSR256NCI.bam
featureCounts  -F GTF --countReadPairs -a gencode.v39.basic.annotation.gtf -o featcounts/ENCSR381VNR.out ../784_proj/K562/merged_bamfile/ENCSR381VNR.bam
featureCounts  -F GTF --countReadPairs -a gencode.v39.basic.annotation.gtf -o featcounts/ENCSR391BBA.out ../784_proj/K562/merged_bamfile/ENCSR391BBA.bam
featureCounts  -F GTF --countReadPairs -a gencode.v39.basic.annotation.gtf -o featcounts/ENCSR448GXJ.out ../784_proj/K562/merged_bamfile/ENCSR448GXJ.bam
featureCounts  -F GTF --countReadPairs -a gencode.v39.basic.annotation.gtf -o featcounts/ENCSR497XZI.out ../784_proj/K562/merged_bamfile/ENCSR497XZI.bam
featureCounts  -F GTF --countReadPairs -a gencode.v39.basic.annotation.gtf -o featcounts/ENCSR554UVB.out ../784_proj/K562/merged_bamfile/ENCSR554UVB.bam
featureCounts  -F GTF --countReadPairs -a gencode.v39.basic.annotation.gtf -o featcounts/ENCSR631HUN.out ../784_proj/K562/merged_bamfile/ENCSR631HUN.bam
featureCounts  -F GTF --countReadPairs -a gencode.v39.basic.annotation.gtf -o featcounts/ENCSR720BJU.out ../784_proj/K562/merged_bamfile/ENCSR720BJU.bam
featureCounts  -F GTF --countReadPairs -a gencode.v39.basic.annotation.gtf -o featcounts/ENCSR767OEY.out ../784_proj/K562/merged_bamfile/ENCSR767OEY.bam
featureCounts  -F GTF --countReadPairs -a gencode.v39.basic.annotation.gtf -o featcounts/ENCSR937RSF.out ../784_proj/K562/merged_bamfile/ENCSR937RSF.bam
featureCounts  -F GTF --countReadPairs -a gencode.v39.basic.annotation.gtf -o featcounts/ENCSR953ZOA.out ../784_proj/K562/merged_bamfile/ENCSR953ZOA.bam
featureCounts  -F GTF --countReadPairs -a gencode.v39.basic.annotation.gtf -o featcounts/ENCSR100ARZ.out ../784_proj/K562/merged_bamfile/ENCSR100ARZ.bam

