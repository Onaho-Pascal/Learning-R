# Define the RNA sequence
rna_seq <- "UCUCCCAACCCUUGUACCAGUG"

# Convert RNA to DNA by replacing "U" with "T"
dna_seq <- chartr("U", "T", rna_seq)

# Print the resulting DNA sequence
print(dna_seq)


 
# Load Biostrings 

library(Biostrings)

# Define an RNA sequence
rna_seq <- RNAString("UCUCCCAACCCUUGUACCAGUG")

# Convert to DNAStringSet
dna_seq <- RNAStringSet(rna_seq)
dna_seq <- chartr("U", "T", as.character(dna_seq))

print(dna_seq)

# Define the DNA sequence
dna_seq <- "TCTCCCAACCCTTGTACCAGTG"

# Convert DNA to RNA by replacing "T" with "U"
rna_seq <- chartr("T", "U", dna_seq)

# Print the resulting RNA sequence
print(rna_seq)


# Define a DNA sequence
dna_seq <- DNAString("TCTCCCAACCCTTGTACCAGTG")

# Transcribe DNA to RNA
rna_seq <- RNAString(dna_seq)

print(rna_seq)
