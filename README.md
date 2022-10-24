# 784_RNA_teal
BIOS/BCB 784 Final Project 2022, Teal, RNA
**Potential Projects?**

**BRAIN**
The Genotype-Tissue Expression (GTEx) project is an ongoing effort to build a comprehensive public resource to study tissue-specific gene expression and regulation. Samples were collected from 54 non-diseased tissue sites across nearly 1000 individuals, primarily for molecular assays including WGS, WES, and RNA-Seq. Remaining samples are available from the GTEx Biobank. The GTEx Portal provides open access to data including gene expression, QTLs, and histology images. Check <https://gtexportal.org/> for more information on the GTEx project.

n = 2931
BRAIN:
recount3::create_rse_manual(
    project = "BRAIN",
    project_home = "data_sources/gtex",
    organism = "human",
    annotation = "gencode_v26",
    type = "gene"
)
``````
````````````````````````````````````````````````````````````

HEART: n=942
recount3::create_rse_manual(
    project = "HEART",
    project_home = "data_sources/gtex",
    organism = "human",
    annotation = "gencode_v26",
    type = "gene"
)

MUSCLE: n=881
recount3::create_rse_manual(
    project = "HEART",
    project_home = "data_sources/gtex",
    organism = "human",
    annotation = "gencode_v26",
    type = "gene"
)

LUNG: n=655
recount3::create_rse_manual(
    project = "LUNG",
    project_home = "data_sources/gtex",
    organism = "human",
    annotation = "gencode_v26",
    type = "gene"
)

SPLEEN: n=255
recount3::create_rse_manual(
    project = "SPLEEN",
    project_home = "data_sources/gtex",
    organism = "human",
    annotation = "gencode_v26",
    type = "gene"
)

MUSCLE:

