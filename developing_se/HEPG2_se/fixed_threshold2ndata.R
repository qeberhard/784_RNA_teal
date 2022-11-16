rm(list = ls())
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path))

library(ggplot2)
library(SummarizedExperiment)
library(dplyr)
library(readr)
library(tibble)
library(patchwork)

load("../data/se_HEPG2.rda")

outPath <- "./out"
dir.create(outPath, showWarnings = F)


nc_labels <- c("bidirectional_promoter_lncRNA", "macro_lncRNA", "3prime_overlapping_ncRNA", 
               "lincRNA", "processed_transcript", "lncRNA", "sense_intronic","sense_overlapping")

c_labels <- c("protein_coding")

####################################
# without filtering
####################################

dim(se)

#[1] 61533   103

se.nc <- se[rowData(se)$Gene_type %in% nc_labels, ]

se.c <- se[rowData(se)$Gene_type %in% c_labels, ]

dim(se.nc)

#[1] 17755   103

dim(se.c)

#[1] 19982   103

### MA plot
### M = log2 fold change
### A = average of log2 mean counts

ggplot(data = data.frame(M = log2( colMeans(assay(se.nc))/colMeans(assay(se.c)) ),
                         A = .5*(log2(colMeans(assay(se.nc))) + log2(colMeans(assay(se.c))) )
                           ), aes(x = A, y = M)) +
  geom_point(shape = 1, color = "navy") +
  geom_hline(yintercept = 0) +
  labs(title = "Witout filtering") +
  geom_smooth(method = "loess", se = F) +
  theme(text=element_text(size=20))


####################################
# filter out genes with total counts = 0
####################################

rowTotal = 0
keep <- rowSums(assay(se)) > rowTotal
se0 <- se[keep,]

dim(se0)

#[1] 48329   103

se0.nc <- se0[rowData(se0)$Gene_type %in% nc_labels, ]

se0.c <- se0[rowData(se0)$Gene_type %in% c_labels, ]

dim(se0.nc)

# [1] 13980   103

dim(se0.c)

# [1] 18764   103

ggplot(data = data.frame(M = log2( colMeans(assay(se0.nc))/colMeans(assay(se0.c)) ),
                         A = .5*(log2(colMeans(assay(se0.nc))) + log2(colMeans(assay(se0.c))) )
), aes(x = A, y = M)) +
  geom_point(shape = 1, color = "navy") +
  geom_hline(yintercept = 0) +
  labs(title = "filter out genes with total counts = 0") +
  geom_smooth(method = "loess", se = F) +
  theme(text=element_text(size=20))

####################################
# filter out genes with a threshold > 0
####################################

logrowsums <- log1p(rowSums(assay(se)))

ggplot(data = data.frame( x = logrowsums ), aes(x = x)) +
  geom_histogram(binwidth = 0.1, fill = "green4") +
  labs(x = "log(total RNA count + 1)", y = "") +
  scale_x_continuous(n.breaks = 20) +
  theme_bw() +
  theme(text=element_text(size=50), axis.text.x = element_text(angle = 90))

ggsave(file.path(outPath, "hist_noFiltering.png"), width=6, height=3, units="in", scale=3)

logcolsums <- log1p(colSums(assay(se)))

ggplot(data = data.frame( x = logcolsums ), aes(x = x)) +
  geom_histogram(binwidth = 0.1, fill = "blue3") +
  labs(x = "log(total RNA count + 1)  (for each protein)", y = "") +
  scale_x_continuous(n.breaks = 10) +
  theme_bw() +
  theme(text=element_text(size=50), axis.text.x = element_text(angle = 90))

ggsave(file.path(outPath, "hist_logcolsum.png"), width=6, height=3, units="in", scale=3)

###

logrowsums.nc <- log1p(rowSums(assay(se.nc)))
logrowsums.c <- log1p(rowSums(assay(se.c)))

ggplot(data = data.frame( x = c(logrowsums.nc, logrowsums.c), 
                          label = c( rep("non-coding", length(logrowsums.nc)), rep("coding", length(logrowsums.c)) ) ),
       aes(x = x, fill = label)) +
  geom_histogram(binwidth = 0.1, color="purple", alpha=0.6, position = 'identity') +
  scale_fill_manual(values=c("red", "turquoise")) +
  labs(x = "log(total RNA count + 1)", fill="", y = "") +
  scale_x_continuous(n.breaks = 20) +
  theme_bw() +
  theme(text=element_text(size=50), axis.text.x = element_text(angle = 90))

ggsave(file.path(outPath, "hist_noFiltering_nc&c.png"), width=6, height=3, units="in", scale=3)

Count <- 0:30
log.table <- data.frame(x = paste0("log(",Count,"+1)"), y = round(log1p(Count), digits = 2))
View(log.table)
MASS::write.matrix(t(log.table), file = file.path(outPath,"logtable.csv"), sep = ",")

### for each gene, how many protein does it bind to?

proteinCount <- rowSums(assay(se)!=0)

ggplot(data = data.frame( x = proteinCount ), aes(x = x)) +
  geom_histogram(binwidth = 1, fill = "red4") +
  labs(x = "no. of binding proteins", y = "") +
  scale_x_continuous(n.breaks = 10) +
  theme_bw() +
  theme(text=element_text(size=50), axis.text.x = element_text(angle = 90))

ggsave(file.path(outPath, "hist_noFiltering_proteinCount.png"), width=6, height=3, units="in", scale=3)

### relation between logrowsum and protein counts

ggplot(data = data.frame(x = logrowsums, y = proteinCount), aes(x = x, y = y)) +
  geom_jitter(shape = 1, color = "navy", alpha = 0.1) +
  annotate("text", x=13, y=60, label = paste0("corr = ",round(cor(logrowsums, proteinCount), digits = 3)), size = 20) +
  theme_bw() +
  theme(text=element_text(size=50)) +
  labs(x = "log(total RNA count + 1)", y = "no. of binding proteins") 

ggsave(file.path(outPath, "scatter_logRowSums_proteinCount.png"), width=4, height=4, units="in", scale=3)

# ggplot(data = data.frame(x = logrowsums, y = proteinCount), aes(x=x, y=y) ) +
#   geom_hex(bins = 70) +
#   scale_fill_continuous(type = "viridis") +
#   theme_bw()

###
### cutoff: rowsums > 11 or logrowSums > 2.5

cutoff = 2.5

ggplot(data = data.frame( x = logrowsums ), aes(x = x)) +
  geom_histogram(binwidth = 0.1, fill = "green4") +
  labs(x = "log(total RNA count + 1)") +
  scale_x_continuous(n.breaks = 20) +
  geom_vline(xintercept = cutoff, color = "chocolate", linetype = "longdash") +
  theme_bw() +
  theme(text=element_text(size=50), axis.text.x = element_text(angle = 90))

ggsave(file.path(outPath, "hist_filtered.png"), width=6, height=3, units="in", scale=3)

ggplot(data = data.frame( x = c(logrowsums.nc, logrowsums.c), 
                          label = c( rep("non-coding", length(logrowsums.nc)), rep("coding", length(logrowsums.c)) ) ),
       aes(x = x, fill = label)) +
  geom_histogram(binwidth = 0.1, color="purple", alpha=0.6, position = 'identity') +
  scale_fill_manual(values=c("red", "turquoise")) +
  labs(x = "log(total RNA count + 1)", fill="", y = "") +
  scale_x_continuous(n.breaks = 20) +
  geom_vline(xintercept = cutoff, color = "chocolate", linetype = "longdash") +
  theme_bw() +
  theme(text=element_text(size=50), axis.text.x = element_text(angle = 90))

ggsave(file.path(outPath, "hist_filtered_nc&c.png"), width=6, height=3, units="in", scale=3)

############

rowTotal = 11
keep <- rowSums(assay(se)) > rowTotal
se1 <- se[keep,]

dim(se1)

#[1] 30355   103

se1.nc <- se1[rowData(se1)$Gene_type %in% nc_labels, ]

se1.c <- se1[rowData(se1)$Gene_type %in% c_labels, ]

dim(se1.nc)

#[1] 7310  103

dim(se1.c)

#[1] 15653   103

ggplot(data = data.frame(M = log2( colMeans(assay(se1.nc))/colMeans(assay(se1.c)) ),
                         A = .5*(log2(colMeans(assay(se1.nc))) + log2(colMeans(assay(se1.c))) )
), aes(x = A, y = M)) +
  geom_point(shape = 1, color = "navy") +
  geom_hline(yintercept = 0) +
  labs(title = "filter out genes with a threshold > 0") +
  geom_smooth(method = "loess", se = F) +
  theme(text=element_text(size=20))




