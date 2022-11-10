library(pheatmap)
library(scrime)
library("DESeq2")

load("~/BCB784_proj/784_RNA_teal/developing_se/K562_se/se2_K562.rda")

se_assay <- as.data.frame(assay(se2))
gene_type <- as.data.frame(se2@elementMetadata@listData$Gene_type)
se_assay <- cbind(se_assay,gene_type)

Anno <- data.frame(GeneType = se_assay$`se2@elementMetadata@listData$Gene_type`)

rownames(se_assay) <- row.names(se_assay)
rownames(Anno) <- row.names(se_assay)

se_assay <- se_assay[order(se_assay$`se2@elementMetadata@listData$Gene_type`),]





png(file="~/BCB784_proj/784_RNA_teal/developing_se/K562_se/PheatMap_lncRNA_v_proteinCoding_wClustering_plot.png",
    width=2000, height=1200)
pheatmap(se_assay[1:135], cluster_rows=F, show_rownames=F,
         cluster_cols=T, main = "Pheat map of K562", border_color = T,annotation_row = Anno,
         color =colorRampPalette(c('red','white','blue'))(100), scale = "row",fontsize = 8, cellwidth = 10)
dev.off()   