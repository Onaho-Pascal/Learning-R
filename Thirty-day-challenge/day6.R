fasta_file <- "C:/Users/user/Documents/30-day Challenge/Day 1/sequence.fasta"

library(Biostrings)
fasta_data <- readDNAStringSet(fasta_file)

class(fasta_data)
sequences <- as.character(fasta_data)
print(sequences)


# Function to validate and format sequences to max 80 characters per line
customCheckSequences <- function(sequences) {
  
  # Step 1: Convert all sequences to uppercase
  sequences <- toupper(sequences)
  
  # Step 2: Define IUPAC symbols for nucleotides
  iupac_symbols <- c("A", "C", "G", "T", "R", "Y", "S", "W", "K", "M", "B", "D", "H", "V", "N")
  
  # Step 3: Check for valid IUPAC symbols and enforce 80-character line limit
  validated_sequences <- sapply(sequences, function(seq) {
    # Check for invalid characters
    if (!all(strsplit(seq, NULL)[[1]] %in% iupac_symbols)) {
      stop("Error: Sequence contains invalid IUPAC characters.")
    }
    
    # Split sequence into lines of max 80 characters
    if (nchar(seq) > 80) {
      seq <- paste(strwrap(seq, width = 80), collapse = "\n")
    }
    return(seq)
  })
  
  message("All sequences are valid and formatted.")
  return(validated_sequences)
}

# Usage Example
# Run the validation and formatting on your sequences
validated_sequences <- customCheckSequences(sequences)
cat(validated_sequences, sep = "\n\n")  # Print with spacing between sequences



