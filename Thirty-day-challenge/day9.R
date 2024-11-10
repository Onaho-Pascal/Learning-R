#load the seqinr package

library(seqinr)

# Set the desired sequence length
sequence_length <- 200

# Define the DNA bases
bases <- c("A", "T", "G", "C")

# Generate a random DNA sequence
random_dna <- sample(bases, sequence_length, replace = TRUE)
random_dna



# Calculate codon frequencies
codon_counts <- uco(random_dna, frame = 0, index = "eff")
codon_counts

# Visualize the codon frequencies
barplot(codon_counts, main="Codon Usage Frequencies", col="yellow", las=2)

pie(codon_counts, main="Codon Usage Frequencies", col=rainbow(length(codon_counts)))


# Filter out codons with zero counts
codon_counts <- codon_counts[codon_counts > 0]

# Create the pie chart without zeros
pie(codon_counts, labels = names(codon_counts), main="Codon Usage Frequencies", col=rainbow(length(codon_counts)))

