##############################
## Exploratory Data Analysis
##############################



raw_data <- readRDS("C:/Users/user/Downloads/Data Files/raw_expression_data_tcga-coad.rds")

library(caret)
library(DALEX)
library(pROC)



rownames(raw_data) <- raw_data$X
raw_data$X <- NULL

raw_data <- data.frame(t(raw_data))

SDs = apply(raw_data, 2, sd)
topPredicts = order(SDs, decreasing = T)[1:3000]
raw_data = raw_data[, topPredicts]

normalized_data <- log2(raw_data + 1)



# Applying the summary function
summary(normalized_data)

### Applying visualization distributions

library(ggplot2)
ggplot(normalized_data, aes(x = TCGA.AD.6899.01A.11R.1928.07)) +
  geom_histogram(binwidth = 0.5, fill = "skyblue", color = "white") +
  labs(title = "Distribution of Gene Expression Levels", x = "Expression Level", y = "Frequency")

boxplot(normalized_data, xlab = "samples", ylab = "counts", las = 2, col = "lightblue") # las = 2 is to rotate the x-axis labels 
hist(normalized_data[, "TCGA.19.4065.02A.11R.2005.01"], 
     main = "distribution of Raw Counts for Sample 1", 
     xlab = "counts", 
     col = "lightgreen", 
     breaks = 50)

library(gplots)
seq_color_palette <- colorRampPalette(c("blue", "white", "red"))(n = 100)
heatmap.2(as.matrix(normalized_data),
          col = seq_color_palette,
          Rowv = F, Colv = F, dendrogram = "none",
          sepcolor = "black",
          trace = "none",
          key = T,
          key.title = "Expression",
          density.info = "none",
          main = "Heatmap of top 500+ differentially expressed genes in Colonadenocarcinoma",
          cexRow = 0.9, cexCol = 0.7, margins = c(11,10))




pca_data <- normalized_data[, sapply(normalized_data, is.numeric)]
pca_result <- prcomp(pca_data, scale. = TRUE)
biplot(pca_result, main = "PCA Biplot")
