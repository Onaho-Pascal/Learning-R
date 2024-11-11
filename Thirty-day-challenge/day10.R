library(seqinr)
library(Biostrings)
dna <- readDNAStringSet("C:/Users/user/Documents/30-day Challenge/Day 1/sequence.fasta")


find_orfs <- function(dna) {
  start_codons <- c("ATG")
  stop_codons <- c("TAA", "TAG", "TGA")
  
  orfs <- list()
  
  for (frame in 1:3) {
    seq <- substr(dna, frame, nchar(dna))
    triplets <- substring(seq, seq(1, nchar(seq)-2, by=3), seq(3, nchar(seq), by=3))
    
    in_orf <- FALSE
    orf_start <- 0
    
    for (i in 1:length(triplets)) {
      codon <- triplets[i]
      if (codon %in% start_codons && !in_orf) {
        orf_start <- i
        in_orf <- TRUE
      }
      if (codon %in% stop_codons && in_orf) {
        orfs <- append(orfs, list(c(frame, orf_start, i)))
        in_orf <- FALSE
      }
    }
  }
  
  return(orfs)
}

# Apply to your sequence
orfs <- find_orfs(dna)
print(orfs)

class(orfs)
str(orfs)

orfs <- as.data.frame(orfs)
print(orfs)

library(tidyverse)

# Assuming `orfs` is a data frame where each column represents an ORF start and end position pair
orfs_long <- as.data.frame(t(orfs)) # Transpose the data to get ORFs as rows
colnames(orfs_long) <- c("frame", "start", "end") # Rename columns

# Convert to a tibble for easier handling
orfs_long <- as_tibble(orfs_long)

# Check the reshaped data
print(orfs_long)


library(ggplot2)


ggplot(orfs_long, aes(x = start, xend = end, y = frame, yend = frame)) +
  geom_segment(color = "blue", size = 1.5) +
  labs(title = "Open Reading Frames (ORFs)", x = "Sequence Position", y = "Reading Frame") +
  theme_minimal()


# Sample data
orfs_ln <- data.frame(
  orf_id = factor(c("ORF 1", "ORF 2", "ORF 3", "ORF 4", "ORF 5", "ORF 6")), # Unique identifier for each ORF
  start = c(1, 46, 103, 151, 176, 224),
  end = c(50, 92, 149, 169, 179, 240),
  frame = c(1, 2, 3, 1, 2, 3)
)

# Plot with different colors for each ORF
ggplot(orfs_ln, aes(x = start, xend = end, y = frame, yend = frame, color = orf_id)) +
  geom_segment(size = 1.5) +
  labs(title = "Open Reading Frames (ORFs)", x = "Sequence Position", y = "Reading Frame") +
  theme_minimal() +
  scale_color_brewer(palette = "Set1") # Or use another palette from RColorBrewer

