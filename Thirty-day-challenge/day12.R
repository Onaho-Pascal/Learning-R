setwd("C:/Users/user/Documents/30-day Challenge")
library(Biostrings)
library(ape)
library(seqinr)
library(phangorn)
library(msa)

protein_sequences <- readAAStringSet("Ms.txt", format = "fasta")

alignment <- msa(protein_sequences, method = "ClustalOmega")
print(alignment)


# Save the alignment to a PDF file
msaPrettyPrint(alignment, output="pdf", file="alignment_visualization.pdf")

# Convert the alignment to a `phangorn` phyDat object
alignment_phangorn <- as.phyDat(alignment, type="AA")

# Plot the alignment using `phangorn`
image(as.matrix(alignment_phangorn), main="Protein Sequence Alignment")

library(ggplot2)
library(reshape2)

# Convert alignment to a matrix
alignment_matrix <- as.matrix(alignment)

# Melt the matrix for ggplot
alignment_df <- melt(alignment_matrix)
colnames(alignment_df) <- c("Position", "Sequence", "AA")

# Plot using ggplot2
ggplot(alignment_df, aes(x=Position, y=Sequence, fill=AA)) +
  geom_tile() +
  scale_fill_viridis_d() + # You can choose a different color palette if you prefer
  theme_minimal() +
  labs(title="Multiple Sequence Alignment", x="Position", y="Sequence")



