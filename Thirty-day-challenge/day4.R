#######################
## Data Normalization
#######################


raw_data <- read.csv("C:/Users/user/Downloads/glioblastoma_rawcounts.csv")

library(caret)
library(DALEX)
library(pROC)


rownames(raw_data) <- raw_data$X
raw_data$X <- NULL



library(gplots)
library(RColorBrewer)
div_color_palette <- rev(brewer.pal(11, "RdBu"))
seq_color_palette <- brewer.pal(9, "Blues")


## Visualization before Data Normalization
boxplot(raw_data, xlab = "samples", ylab = "counts", las = 2, col = "lightblue") # las = 2 is to rotate the x-axis labels 
hist(raw_data[, "TCGA.19.4065.02A.11R.2005.01"], 
     main = "distribution of Raw Counts for Sample 1", 
     xlab = "counts", 
     col = "lightgreen", 
     breaks = 50)


## Normalization of Data

# Log Normalization
log_data <- log2(raw_data + 1)
boxplot(log_data, xlab = "samples", ylab = "counts", las = 2, col = "lightblue") # las = 2 is to rotate the x-axis labels 
hist(log_data[, "TCGA.19.4065.02A.11R.2005.01"], 
     main = "distribution of Raw Counts for Sample 1", 
     xlab = "counts",
     col = "lightgreen", 
     breaks = 50)

# Z Normalization
z_data <- t(scale(t(raw_data)))
boxplot(z_data, xlab = "samples", ylab = "counts", las = 2, col = "yellow")
hist(z_data[, "TCGA.19.4065.02A.11R.2005.01"], 
     main = "distribution of Raw Counts for Sample 1", 
     xlab = "counts", 
     col = "lightgreen", 
     breaks = 50)

# Quantile Normalization
BiocManager::install("preprocessCore")
library(preprocessCore)

# Example data matrix
expression_data <- matrix(rnorm(20), nrow = 5)

# Apply quantile normalization
quantile_normalized_data <- normalize.quantiles(expression_data)
quantile_normalized_data
