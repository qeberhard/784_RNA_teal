library(AnnotationDbi)
library(org.Hs.eg.db)
library(tidyverse)
library(data.table)
library(dplyr)


#load Filtered RDAs
load('developing_se/HEPG2_se/se2_HEPG2.rda')
load('developing_se/K562_se/se2_K562.rda')


#K562 Cell Line
se_assay <- as.data.frame(assay(se2))
#Getting gene name
se_assay$ensem = gsub("\\..*","",row.names(se_assay))
se_assay$symbol = mapIds(org.Hs.eg.db,
                           keys = se_assay$ensem,
                           column = "SYMBOL",
                           keytype="ENSEMBL",
                           multiVals = "first")

se_assay <- subset(se_assay, select = c(136:137,1:135))
#Getting genetype
GeneType <- data.frame(GeneType = se2@elementMetadata@listData$Gene_type)

se_assay = cbind(se_assay,GeneType)

k562 <- (se_assay)
#changing colnames to the experiment target
targets2 <- as.data.frame(se2$Experiment.target)
colnames(k562)[3:137] <- targets2$`se2$Experiment.target`
#labeling cell line
CellLine = as.data.frame(rep("k562",dim(k562)[1]))
names(CellLine)[names(CellLine) == 'rep("k562", dim(k562)[1])'] <- "CellLine"
k562 = cbind(k562,CellLine)




#HEPG2 Cell Lines
se2_Hep_assay <- as.data.frame(assay(se2_Hep))
#Getting gene name
se2_Hep_assay$ensem = gsub("\\..*","",row.names(se2_Hep_assay))
se2_Hep_assay$symbol = mapIds(org.Hs.eg.db,
                         keys = se2_Hep_assay$ensem,
                         column = "SYMBOL",
                         keytype="ENSEMBL",
                         multiVals = "first")
se2_Hep_assay <- subset(se2_Hep_assay, select = c(104:105,1:103))
#Getting genetype
GeneType <- data.frame(GeneType = se2_Hep@elementMetadata@listData$Gene_type)

se2_Hep_assay = cbind(se2_Hep_assay,GeneType)

hepg2 <- (se2_Hep_assay)
#changing colnames to the experiment target
targets <- as.data.frame(se2_Hep$Experiment.target)
colnames(hepg2)[3:105] <- targets$`se2_Hep$Experiment.target`
#labeling cell line
CellLine = as.data.frame(rep("hepg2",dim(hepg2)[1]))
names(CellLine)[names(CellLine) == 'rep("hepg2", dim(hepg2)[1])'] <- "CellLine"
hepg2 = cbind(hepg2,CellLine)

#Seeing where they intersect
bL <- as.data.frame(intersect(names(k562), names(hepg2)))
bL <- as.character(intersect(names(k562), names(hepg2)))

#Extracting common colnames from both lines
hepg2 <- hepg2 %>% dplyr::select(bL)

k562 <- k562 %>% dplyr::select(bL)

#combining both lines
bothLines <- rbind(k562,hepg2)

write.csv(bothLines,"Both-CellLines.csv")



