rm(list = ls())
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path))

library(dplyr)
library(ggplot2)

outPath <- "./out"
dir.create(outPath, showWarnings = F)

data.k562 <- read.csv("../working3/out/K562_zinb.csv", stringsAsFactors = FALSE)
data.hepg2 <- read.csv("../working3.1/out/HEPG2_zinb.csv", stringsAsFactors = FALSE)

### add the col for the experiment target
load("../data/se_K562.rda")

data.k562$target <- colData(se)$Experiment.target

load("../data/se_HEPG2.rda")

data.hepg2$target <- colData(se)$Experiment.target

data.joint <- inner_join(data.k562, data.hepg2, by = "target", suffix = c(".k", ".h"))

### violin plot
data.k562$cell_line <- "K562"
data.hepg2$cell_line <- "HEPG2"
data.merged <- bind_rows(data.k562, data.hepg2)

ggplot(data = data.merged, aes(x = cell_line, y = log2fc, fill = cell_line)) +
  geom_violin(trim = FALSE) +
  geom_jitter(height = 0) +
  scale_x_discrete(labels = c("HEPG2" = "HEPG2\nn_protein = 103",
                              "K562" = "K562\nn_protein = 135")) +
  labs(x="", y="log2 fold change") +
  theme_bw() +
  theme(text=element_text(size=50), legend.position = "none")

ggsave(file.path(outPath, "violin_log2fc.png"), width=4, height=5, units="in", scale=3)

### scatter plot

ggplot(data = data.joint, aes(x = log2fc.k, y = log2fc.h)) +
  geom_point(color = "navy", alpha = .9) +
  geom_abline(slope = 1, intercept = 0) +
  geom_smooth(method = "loess", se = F) +
  annotate("text", x=-4, y=-1, label = paste0("corr = ",round(cor(data.joint$log2fc.k, data.joint$log2fc.h), digits = 3)), size = 20) +
  theme_bw() +
  theme(text=element_text(size=50)) +
  labs(x = "K562", y = "HEPG2", subtitle = paste0("log2 fold change (n_protein = ",nrow(data.joint),")") ) 

ggsave(file.path(outPath, "scatter_log2fc.png"), width=4, height=4, units="in", scale=3)


### why some target proteins have log2fc around 0, but still 0 pvals?


data.merged2 <- data.merged[order(data.merged$log2fc, decreasing = T),]
data.merged2[1:5,]

# protein p.val      log2fc       target cell_line
# 76  ENCSR943MHU     0  0.04569017  SAFB2-human      K562
# 164 ENCSR965DLL     0  0.02477489   SFPQ-human     HEPG2
# 215 ENCSR267UCX     0  0.01848052 HNRNPM-human     HEPG2

###
nc_labels <- c("bidirectional_promoter_lncRNA", "macro_lncRNA", "3prime_overlapping_ncRNA", 
               "lincRNA", "processed_transcript", "lncRNA", "sense_intronic","sense_overlapping")

c_labels <- c("protein_coding")
###

load("../data/se_K562.rda")

rowTotal = 11
keep <- rowSums(assay(se)) > rowTotal
se <- se[keep,]

# SAFB2-human      K562

# select the protein of interest
se.x <- se[, se$Experiment.target == "SAFB2-human"]

se.nc <- se.x[rowData(se.x)$Gene_type %in% nc_labels, ]

se.c <- se.x[rowData(se.x)$Gene_type %in% c_labels, ]

logrowsums.nc <- log1p(rowSums(assay(se.nc)))
logrowsums.c <- log1p(rowSums(assay(se.c)))

mean(logrowsums.nc)
# [1] 1.552147
mean(logrowsums.c)
# [1] 3.108747

ggplot(data = data.frame( x = c(logrowsums.nc, logrowsums.c), 
                          label = c( rep("non-coding", length(logrowsums.nc)), rep("coding", length(logrowsums.c)) ) ),
       aes(x = x, fill = label)) +
  geom_histogram(binwidth = 0.1, color="purple", alpha=0.6, position = 'identity') +
  scale_fill_manual(values=c("red", "turquoise")) +
  labs(x = "log(RNA count + 1)", fill="", y = "", subtitle = "SAFB2-human  K562") +
  scale_x_continuous(n.breaks = 20) +
  theme_bw() +
  theme(text=element_text(size=50), axis.text.x = element_text(angle = 90))

ggsave(file.path(outPath, "hist_SAFB2_K562.png"), width=6, height=3, units="in", scale=3)


###

load("../data/se_HEPG2.rda")

rowTotal = 11
keep <- rowSums(assay(se)) > rowTotal
se <- se[keep,]

#SFPQ-human     HEPG2

se.x <- se[, se$Experiment.target == "SFPQ-human"]

se.nc <- se.x[rowData(se.x)$Gene_type %in% nc_labels, ]

se.c <- se.x[rowData(se.x)$Gene_type %in% c_labels, ]

logrowsums.nc <- log1p(rowSums(assay(se.nc)))
logrowsums.c <- log1p(rowSums(assay(se.c)))

ggplot(data = data.frame( x = c(logrowsums.nc, logrowsums.c), 
                          label = c( rep("non-coding", length(logrowsums.nc)), rep("coding", length(logrowsums.c)) ) ),
       aes(x = x, fill = label)) +
  geom_histogram(binwidth = 0.1, color="purple", alpha=0.6, position = 'identity') +
  scale_fill_manual(values=c("red", "turquoise")) +
  labs(x = "log(RNA count + 1)", fill="", y = "", subtitle = "SFPQ-human  HEPG2") +
  scale_x_continuous(n.breaks = 20) +
  theme_bw() +
  theme(text=element_text(size=50), axis.text.x = element_text(angle = 90))

ggsave(file.path(outPath, "hist_SFPQ_HEPG2.png"), width=6, height=3, units="in", scale=3)



#HNRNPM-human     HEPG2

se.x <- se[, se$Experiment.target == "HNRNPM-human"]

se.nc <- se.x[rowData(se.x)$Gene_type %in% nc_labels, ]

se.c <- se.x[rowData(se.x)$Gene_type %in% c_labels, ]

logrowsums.nc <- log1p(rowSums(assay(se.nc)))
logrowsums.c <- log1p(rowSums(assay(se.c)))

ggplot(data = data.frame( x = c(logrowsums.nc, logrowsums.c), 
                          label = c( rep("non-coding", length(logrowsums.nc)), rep("coding", length(logrowsums.c)) ) ),
       aes(x = x, fill = label)) +
  geom_histogram(binwidth = 0.1, color="purple", alpha=0.6, position = 'identity') +
  scale_fill_manual(values=c("red", "turquoise")) +
  labs(x = "log(RNA count + 1)", fill="", y = "", subtitle = "HNRNPM-human  HEPG2") +
  scale_x_continuous(n.breaks = 20) +
  theme_bw() +
  theme(text=element_text(size=50), axis.text.x = element_text(angle = 90))

ggsave(file.path(outPath, "hist_HNRNPM_HEPG2.png"), width=6, height=3, units="in", scale=3)
