############################################ 
# Loading Data from your local device into R
############################################



### FASTA and FASTQ Files

install.packages("BiocManager")
BiocManager::install("Biostrings")
BiocManager::install("ShortRead")

library(Biostrings)
library(ShortRead)

Tp3_data <- readDNAStringSet("C:/Users/user/Documents/30-day Challenge/Day 1/sequence.fasta")  #FASTA
View(Tp3_data)

Srr_data <- readFastq("C:/Users/user/Documents/30-day Challenge/Day 1/SRR000062.fastq") #FASTQ
View(Srr_data)


### CSV Files

coad_merged_data <- read.csv("C:/Users/user/Documents/Hackbio Internship Materials/Task 3/merged.csv")
View(coad_merged_data)


### RDS Files

raw_data <- readRDS("C:/Users/user/Downloads/Data Files/raw_expression_data_tcga-coad.rds")
View(raw_data)


### GTF Files

BiocManager::install("rtracklayer")

library(rtracklayer)

genome_data <- import("C:/Users/user/Documents/30-day Challenge/Day 1/Data.gtf")



### VCF Files

BiocManager::install("VariantAnnotation")

library(VariantAnnotation)

vcf_data <- readVcf("C:/Users/user/Documents/30-day Challenge/Day 1/dt.vcf", "hg15")













