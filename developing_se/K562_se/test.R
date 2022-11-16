rm(list = ls())
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path))

library(ggplot2)
library(SummarizedExperiment)
library(dplyr)
library(readr)
library(tibble)
library(patchwork)
#library(pscl)
library(glmmTMB)

outPath <- "./out"
dir.create(outPath, showWarnings = F)

load("../data/se_K562.rda")

rowTotal = 11
keep <- rowSums(assay(se)) > rowTotal
se <- se[keep,]

nc_labels <- c("bidirectional_promoter_lncRNA", "macro_lncRNA", "3prime_overlapping_ncRNA", 
               "lincRNA", "processed_transcript", "lncRNA", "sense_intronic","sense_overlapping")

c_labels <- c("protein_coding")

se.nc <- se[rowData(se)$Gene_type %in% nc_labels, ]

se.c <- se[rowData(se)$Gene_type %in% c_labels, ]

mtx.nc <- assay(se.nc)

mtx.c <- assay(se.c)

### wilcoxon test

data.result.wilcox <- data.frame(protein = colnames(se), p.val = NA, log2fc = NA)

for (i in 1:ncol(se)) {
  test <- wilcox.test(mtx.nc[,i], mtx.c[,i], alternative = "two.sided")
  
  data.result.wilcox$p.val[i] <- test$p.value
  
  fc <- mean(mtx.nc[,i])/mean(mtx.c[,i])
  
  data.result.wilcox$log2fc[i] <- log2(fc)
  
}

data.result.wilcox <- data.result.wilcox %>% mutate(p.val.adj = p.adjust(p.val, method = "BH"))

# all p-values < 2.2e-16

### ZINB

data.result.zinb <- data.frame(protein = colnames(se), p.val = NA, log2fc = NA)

for (i in 1:ncol(se)) {
  
  dat <- data.frame( count = c(mtx.nc[,i], mtx.c[,i]),
              label = c( rep(1, nrow(mtx.nc)), rep(0, nrow(mtx.c)) ) )
  
  #m1 <- zeroinfl(count ~ label | label, data = dat, dist = "negbin", link = "log", control = zeroinfl.control(count = c(2,2), zero = -1.7))
  m1 <- glmmTMB(count ~ label, data = dat, ziformula = ~., family = nbinom2(link = "log"))
  
  # null model
  
  m0 <- update(m1, . ~ 1)
  
  pval = pchisq(2 * (logLik(m1) - logLik(m0)), df = 2, lower.tail=FALSE)
  pval = as.numeric(pval)
  
  data.result.zinb$p.val <- pval

  fc <- mean(mtx.nc[,i])/mean(mtx.c[,i])
  
  data.result.zinb$log2fc[i] <- log2(fc)
  
  print(i)
}

write.csv(data.result.zinb, file = file.path(outPath, "K562_zinb.csv"), row.names = FALSE)

