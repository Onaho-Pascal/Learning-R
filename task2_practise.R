install.packages("readr")
library(readr)
glioblastoma_data <- read.csv("https://raw.githubusercontent.com/HackBio-Internship/public_datasets/main/Cancer2024/glioblastoma.csv")
head(glioblastoma_data)
str(glioblastoma_data)
summary(gliobastoma_data)

#to check for missing data
any(is.na(glioblastoma_data))

#to normalize the data
normalized_data <- scale(glioblastoma_data)
print(normalized_data)

# An error: Error in colMeans(x, na.rm = TRUE) : 'x' must be numeric. This error means hat some columns in your dataset are not numeric, 
# and the colMeans function (used internally by many normalization functions) can only operate on numeric data.
#first step is to identify the non-numeric columns

# After identification, we can see the column with characters is the column with gene names. so we have to separate it first.
gene_names <- glioblastoma_data[, 1]
numeric_data <- glioblastoma_data[, -1]

# Step 2: Ensure the numeric data is actually numeric
numeric_data <- as.data.frame(lapply(numeric_data, as.numeric))
# Step 3: Apply Z-score normalization
z_normalized_data <- scale(numeric_data)
# Step 4: Recombine the gene names with the normalized data
final_data <- cbind(Gene = gene_names, z_normalized_data)
# View the final normalized data
head(final_data)

row_means <- rowMeans(z_normalized_data)
head(row_means)
row_means
quantile_threshold <- quantile(row_means, 0.25)
filtered_data <- final_data[row_means > quantile_threshold, ]
 dim(z_normalized_data)
 dim(filtered_data)
install.packages("pheatmap")
install.packages("RColorBrewer")
install.packages("ComplexHeatmap")
