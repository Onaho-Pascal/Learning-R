################################################
## Introduction to Bioconductor and Installation
################################################


# Installation of Bioconductor
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install()


# To install specific packages in the Bioconductor
BiocManager::install("airway")
BiocManager::install("TCGAbiolinks")
BiocManager::install("preprocessCore")
BiocManager::install("GenomicRanges")
BiocManager::install("IRanges")
BiocManager::install("SummarizedExperiment")
BiocManager::install("DESeq2")
BiocManager::install("edgeR")
BiocManager::install("TxDb.Hsapiens.UCSC.hg19.knownGene")



# To load packages
library(airway)
library(TCGAbiolinks)
library(preprocessCore)
library(GenomicRanges)
library(IRanges)
library(SummarizedExperiment)
library(DESeq2)
library(edgeR)
