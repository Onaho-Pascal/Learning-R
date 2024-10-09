

setwd("C:/Users/user/Documents/Hackbio Internship Materials/Stage 4")

library(ggplot2)
library(dplyr)
library(factoextra)
library(caret)
library(pROC)


pca.data <- read.csv(file = "glioma_rawcounts.csv", header = TRUE)
rownames(pca.data) <- pca.data$X

pca.data$X <- NULL

colnames(pca.data) <- gsub("\\.", "-", colnames(pca.data))
pca.data <- log10(pca.data + 1)

pca.data <- data.frame(t(pca.data))

SDs = apply(pca.data, 2, sd)
topPredicts = order(SDs, decreasing = T)[1:3000]
pca.data = pca.data[, topPredicts]

ze <- preProcess(pca.data, method = "nzv", uniqueCut = 15)
pca.data <- predict(ze, pca.data)
cen <- preProcess(pca.data, method = "center")
pca.data <- predict(cen, pca.data)
co <- preProcess(pca.data, method = "corr", cutoff = 0.5)
pca.data <- predict(co, pca.data)


methylation_data_scaled <- scale(pca.data)
pca_result <- prcomp(methylation_data_scaled, center = TRUE, scale. = TRUE)

# Visualize the proportion of variance explained by each principal component
plot(pca_result)

# Select the first few principal components that explain the most variance
pca_data <- pca_result$x[, 1:10]  # Use the first 10 principal components






  # Scaling the data

# Perform K-Means clustering
set.seed(123)
kmeans_result <- kmeans(pca_data, centers = 4, nstart = 25)

fviz_cluster(kmeans_result, data = pca_data)



# Create a dataframe from scaled data
scaled_data_df <- as.data.frame(pca_data)

# Add cluster assignments to the dataframe
scaled_data_df$Cluster <- kmeans_result$cluster

# View the updated dataframe
head(scaled_data_df)


pca.meta <- read.csv(file = "glioma_metadata.csv", header = TRUE)

rownames(pca.meta ) <- pca.meta $barcode

pca.meta$barcode <- NULL

combined_data <- merge(scaled_data_df, pca.meta, by = "row.names")

Cluster.plot <- fviz_cluster(kmeans_result, 
                             data = pca_data,  # Use the original scaled data
                             geom = "point",       # You can also use "text" to label points
                             pointsize = 2,        # Adjust point size for better visibility
                             ggtheme = theme_minimal()) +
  # Add colors based on IDH status from the combined_data
  geom_point(aes(color = combined_data$IDH.status)) + 
  labs(color = "IDH Status") +  # Label for the legend
  scale_color_manual(values = c("Mutant" = "blue", "WildType" = "red"))
ggsave("cluster_plot.png", plot = Cluster.plot, width = 20, height = 15)
print(Cluster.plot)


