rm(list = ls())
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path))

library(ggplot2)
library(SummarizedExperiment)
library(dplyr)
library(readr)
library(tibble)
library(patchwork)

load("../data/se_K562.rda")

outPath <- "./out"
dir.create(outPath, showWarnings = F)


nc_labels <- c("bidirectional_promoter_lncRNA", "macro_lncRNA", "3prime_overlapping_ncRNA", 
               "lincRNA", "processed_transcript", "lncRNA", "sense_intronic","sense_overlapping")

c_labels <- c("protein_coding")

####################################
# without filtering
####################################

dim(se)

#[1] 61533   135

se.nc <- se[rowData(se)$Gene_type %in% nc_labels, ]

se.c <- se[rowData(se)$Gene_type %in% c_labels, ]

dim(se.nc)

#[1] 17755   135

dim(se.c)

#[1] 19982   135

### MA plot
### M = log2 fold change
### A = average of log2 mean counts

ggplot(data = data.frame(M = log2( colMeans(assay(se.nc))/colMeans(assay(se.c)) ),
                         A = .5*(log2(colMeans(assay(se.nc))) + log2(colMeans(assay(se.c))) )
                           ), aes(x = A, y = M)) +
  geom_point(shape = 1, color = "navy") +
  geom_hline(yintercept = 0) +
  labs(title = "Witout filtering") +
  geom_smooth(method = "loess", se = F)


####################################
# filter out genes with total counts = 0
####################################

rowTotal = 0
keep <- rowSums(assay(se)) > rowTotal
se0 <- se[keep,]

dim(se0)

#[1] 53488   135

se0.nc <- se0[rowData(se0)$Gene_type %in% nc_labels, ]

se0.c <- se0[rowData(se0)$Gene_type %in% c_labels, ]

dim(se0.nc)

# [1] 15782   135

dim(se0.c)

# [1] 19179   135

ggplot(data = data.frame(M = log2( colMeans(assay(se0.nc))/colMeans(assay(se0.c)) ),
                         A = .5*(log2(colMeans(assay(se0.nc))) + log2(colMeans(assay(se0.c))) )
), aes(x = A, y = M)) +
  geom_point(shape = 1, color = "navy") +
  geom_hline(yintercept = 0) +
  labs(title = "filter out genes with total counts = 0") +
  geom_smooth(method = "loess", se = F)

####################################
# filter out genes with a threshold > 0
####################################

logrowsums <- log1p(rowSums(assay(se)))

ggplot(data = data.frame( x = logrowsums ), aes(x = x)) +
  geom_histogram(binwidth = 0.1) +
  labs(x = "log(rowSum + 1)") +
  scale_x_continuous(n.breaks = 30) 

###

logrowsums.nc <- log1p(rowSums(assay(se.nc)))
logrowsums.c <- log1p(rowSums(assay(se.c)))

ggplot(data = data.frame( x = c(logrowsums.nc, logrowsums.c), 
                          label = c( rep("non-coding", length(logrowsums.nc)), rep("coding", length(logrowsums.c)) ) ),
       aes(x = x, fill = label)) +
  geom_histogram(binwidth = 0.1, color="purple", alpha=0.6, position = 'identity') +
  scale_fill_manual(values=c("red", "turquoise")) +
  labs(x = "log(rowSum + 1)") +
  scale_x_continuous(n.breaks = 30) +
  labs(fill="")


Count <- 0:30
data.frame(x = paste0("log(",Count,"+1)"), y = round(log1p(Count), digits = 2))

### for each gene, how many protein does it bind to?

proteinCount <- rowSums(assay(se)!=0)

ggplot(data = data.frame( x = proteinCount ), aes(x = x)) +
  geom_histogram(binwidth = 1) +
  labs(x = "protein count") +
  scale_x_continuous(n.breaks = 30) 


### relation between logrowsum and protein counts

ggplot(data = data.frame(x = logrowsums, y = proteinCount), aes(x = x, y = y)) +
  geom_point(shape = 1, color = "navy") +
  annotate("text", x=12, y=100, label = paste0("corr = ",round(cor(logrowsums, proteinCount), digits = 3)), size = 8)


###
### cutoff: rowsums > 11 or logrowSums > 2.5

cutoff = 2.5

ggplot(data = data.frame( x = logrowsums ), aes(x = x)) +
  geom_histogram(binwidth = 0.1) +
  labs(x = "log(rowSum + 1)") +
  scale_x_continuous(n.breaks = 30) +
  geom_vline(xintercept = cutoff, color = "red", linetype = "longdash")

############

rowTotal = 11
keep <- rowSums(assay(se)) > rowTotal
se1 <- se[keep,]

dim(se1)

#[1] 36400   135

se1.nc <- se1[rowData(se1)$Gene_type %in% nc_labels, ]

se1.c <- se1[rowData(se1)$Gene_type %in% c_labels, ]

dim(se1.nc)

#[1] 9309  135

dim(se1.c)

#[1] 16889   135

ggplot(data = data.frame(M = log2( colMeans(assay(se1.nc))/colMeans(assay(se1.c)) ),
                         A = .5*(log2(colMeans(assay(se1.nc))) + log2(colMeans(assay(se1.c))) )
), aes(x = A, y = M)) +
  geom_point(shape = 1, color = "navy") +
  geom_hline(yintercept = 0) +
  labs(title = "filter out genes with a threshold > 0") +
  geom_smooth(method = "loess", se = F)




