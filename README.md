# BIOS/BCB 784 Final Project 2022, Teal, RNA
Quinn Eberhard, Anastacia Wienecke, Kwame Forbes, and Chenghao Wang

### Our Data and Constructing the SummarizedExperiments
Here we are conducting an analysis on two human cell types: K562 and HEPG2 cells.
K562 are erythroleukemia cancer cells from a 52 year old female and HEPG2 are hepatocellular carcinoma cells from a 15 year old boy. Both have been thoroughly studied for biological analyses but here we study them in the context of eCLIP asays.

eCLIP stands for enhanced cross-linking immunoprecipitation, which is an assay where the RNA of a cell is screened against a singular target protein to identify the location and frequency of RNA-protein binding. This can be performed as many independent experiments, varying the target protein each time, to develop a rather large RBP dataset. One scientist particularly renown for this process is Gene Yeo, whose data we further analyze here - accessed through ENCODE. He and his lab have performed eCLIP for K562 cells on (137?) different target proteins and in HEPG2 cells on (???) proteins.

ENCODE provides these datasets for easy processed-file downloads, so we downloaded the bam files for all experiments for each cell type:
xargs -L 1 curl -O -J -L < download_K562_files.txt
Note that all downloaded .bam files and merged .bam files have been excluded from the repository, however, the downloaded metadata_K562.tsv file is included in the developing_se/ directory of this repository. This includes information on all the file types that were downloaded for each experiment which was later used to develop the colData() of the summarized experiments.

The file "bam_file_mappings.tsv" was generated from the python script `map_bam_replicates.py`

There were two replicates for each experiment, so we merged the bam files using `samtools merge` for each replicate, then ran featurecounts to determine the RBP counts (script in serial_bam_merge.sh)


The gencode.v39.basic.annotation.gtf genome was downloaded from GENCODE for the GRCh38.p13 and was used for featureCount runs. This genome/gtf file informed the development of the rowData() of the summarized experiments.

Another component of the rowData() development was to determine the subcellular localization of different RNAs. Although this data is not readily derived from the eCLIP experiments of Gene Yeo, we instead used the total and fractionated rna-seq experiments of Thomas Gingeras, the file download information is found in developing_se/localization/ directory as download_polyA_plus_cytosol.txt, and download_total_rnaseq_nucleoplasmic.txt. From this data, we performed an alignment in the localization/...sh file and constructed tables using localization/...py. The sub-cellular location was decided by calculating the ...? for each RNA in the genome. This is included in the `sub-cellular localization (nuclear)` section of the rowData.

The SummarizedExperiment was developed by the code in load_se.R and the object is stored in the K562_se.Rda to be easily accessed. The individual matrices of the asssay(), colData(), and rowData() are also included in the files K562_assay.tsv, K562_colData.tsv, and K562_rowData.tsv. 

This process was repeated with the developing_se/HEPG2_se/ directory.

### Data Analysis
