install.packages("ggplot2")
install.packages("dplyr")
install.packages("factoextra")

setwd("C:/Users/user/Documents/Hackbio Internship Materials/Stage 4")

library(ggplot2)
library(dplyr)
library(factoextra)
library(caret)
library(pROC)


lowgrade.data <- read.csv(file = "glioma_rawcounts.csv", header = TRUE)
rownames(lowgrade.data) <- lowgrade.data$X

lowgrade.data$X <- NULL

colnames(lowgrade.data) <- gsub("\\.", "-", colnames(lowgrade.data))
lowgrade.data <- log10(lowgrade.data + 1)

lowgrade.data <- data.frame(t(lowgrade.data))


SDs = apply(lowgrade.data, 2, sd)
topPredicts = order(SDs, decreasing = T)[1:3000]
lowgrade.data = lowgrade.data[, topPredicts]

zer <- preProcess(lowgrade.data, method = "nzv", uniqueCut = 15)
lowgrade.data <- predict(zer, lowgrade.data)
cent <- preProcess(lowgrade.data, method = "center")
lowgrade.data <- predict(cent, lowgrade.data)
cor <- preProcess(lowgrade.data, method = "corr", cutoff = 0.5)
lowgrade.data <- predict(cor, lowgrade.data)


scaled.data <- scale(lowgrade.data)  # Scaling the data

# Perform K-Means clustering
set.seed(123)
kmeans_result <- kmeans(scaled.data, centers = 2, nstart = 25)

fviz_cluster(kmeans_result, data = scaled.data)



# Create a dataframe from scaled data
scaled_data_df <- as.data.frame(scaled.data)

# Add cluster assignments to the dataframe
scaled_data_df$Cluster <- kmeans_result$cluster

# View the updated dataframe
head(scaled_data_df)


lowgrade.meta <- read.csv(file = "glioma_metadata.csv", header = TRUE)

rownames(lowgrade.meta) <- lowgrade.meta$barcode

lowgrade.meta$barcode <- NULL

combined_data <- merge(scaled_data_df, lowgrade.meta, by = "row.names")

Cluster.plot <- fviz_cluster(kmeans_result, 
             data = scaled.data,  # Use the original scaled data
             geom = "point",       # You can also use "text" to label points
             pointsize = 2,        # Adjust point size for better visibility
             ggtheme = theme_minimal()) +
  # Add colors based on IDH status from the combined_data
  geom_point(aes(color = combined_data$IDH.status)) + 
  labs(color = "IDH Status") +  # Label for the legend
  scale_color_manual(values = c("Mutant" = "blue", "WT" = "red"))
ggsave("cluster_plot.png", plot = Cluster.plot, width = 20, height = 15)
print(Cluster.plot)
