# load necessary libraries 
library(tidyverse)
 
#read the frequency table file
 freq <- read.table("C:/Users/user/Documents/Bioinformatics Projects/mini_sample_freq.frq", 
                    header = TRUE,
                    row.names = NULL,
                    check.names = FALSE,
                    sep = "\t",
                    quote = "")
 
 # Tidy column names and data
 freq <- freq[, 1:5]  # Keep only the first 5 columns
 colnames(freq) <- c("CHROM", "POS", "N_ALLELES", "N_CHR", "ALLELE_FREQ")
 
 
 # Separate alleles and frequencies
 allele_freqs <- freq %>%
   separate_rows(ALLELE_FREQ, sep = ",") %>%
   separate(ALLELE_FREQ, into = c("ALLELE", "FREQ"), sep = ":", convert = TRUE) %>%
   filter(!is.na(FREQ))
 
 # Plot
 ggplot(allele_freqs, aes(x = factor(POS), y = FREQ, fill = ALLELE)) +
   geom_bar(stat = "identity", position = "dodge") +
   labs(title = "Allele Frequencies at Each SNP Position",
        x = "SNP Position",
        y = "Frequency",
        fill = "Allele") +
   theme_minimal()
 