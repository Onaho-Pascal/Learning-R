####################################
## Phylogenetic Tree Construction
####################################

setwd("C:/Users/user/Documents/30-day Challenge")


install.packages(c("ape", "seqinr", "phangorn"))
BiocManager::install("msa")

library(Biostrings)
library(ape)
library(seqinr)
library(phangorn)
library(msa)
# Replace "your_protein_sequences.txt" with the path to your file
protein_sequences <- readAAStringSet("Ms.txt", format = "fasta")

# Multiple sequence alignment
alignment <- msa(protein_sequences, method = "ClustalW")
alignment_phylo <- as.phyDat(alignment, type = "AA")

# Computing the distance matrix
dist_matrix <- dist.ml(alignment_phylo, model = "JTT")
# Tree construction
tree_nj <- nj(dist_matrix)
plot(tree_nj, main = "Neighbor-Joining Phylogenetic Tree")
