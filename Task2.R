# first step is to set the working directory. That is, set the path from which R would read the desired file.
getwd()
setwd("C:/Users/user/Documents/Hackbio Internship Materials")

# load the data into R and view the different sessions (Head, structure, dim, and check for missing values)
glio_data <- read.csv(file = 'glioblastoma.csv', header = TRUE, row.names = 1)
head(glio_data)
str(glio_data)
dim(glio_data)
any(is.na(glio_data))
table(is.na(glio_data))

library(gplots)
library(RColorBrewer)
div_color_palette <- rev(brewer.pal(11, "RdBu"))
seq_color_palette <- brewer.pal(9, "Blues")

boxplot(glio_data, xlab = "samples", ylab = "counts", las = 2, col = "lightblue") # las = 2 is to rotate the x-axis labels 
hist(glio_data[, "TCGA.19.4065.02A.11R.2005.01"], 
     main = "distribution of Raw Counts for Sample 1", 
     xlab = "counts", 
     col = "lightgreen", 
     breaks = 50)



# Normalization of Data
# using log transformation
log_glio_data <- log2(glio_data + 1)
boxplot(log_glio_data, xlab = "samples", ylab = "counts", las = 2, col = "lightblue") # las = 2 is to rotate the x-axis labels 
hist(log_glio_data[, "TCGA.19.4065.02A.11R.2005.01"], 
     main = "distribution of Raw Counts for Sample 1", 
     xlab = "counts",
     col = "lightgreen", 
     breaks = 50)
#using Zeta transformation
zscoreglio_data <- t(scale(t(log_glio_data)))
boxplot(zscoreglio_data, xlab = "samples", ylab = "counts", las = 2, col = "yellow")
boxplot(glio_data, xlab = "samples", ylab = "counts", las = 2, col = "lightblue") # las = 2 is to rotate the x-axis labels 
hist(zscoreglio_data[, "TCGA.19.4065.02A.11R.2005.01"], 
     main = "distribution of Raw Counts for Sample 1", 
     xlab = "counts", 
     col = "lightgreen", 
     breaks = 50)

# Heatmap with Sequential Palette
# Original data
heatmap.2(as.matrix(glio_data),
          col = seq_color_palette,
          Rowv = F, Colv = F, dendrogram = "none",
          sepcolor = "black",
          trace = "none",
          key = T,
          key.title = "Expression",
          density.info = "none",
          main = "Heatmap of top 500+ differentially expressed genes in Glioblastoma",
          cexRow = 0.9, cexCol = 0.7, margins = c(11,10))
# log data
heatmap.2(as.matrix(log_glio_data),
          col = seq_color_palette,
          Rowv = F, Colv = F, dendrogram = "none",
          sepcolor = "black",
          trace = "none",
          key = T,
          key.title = "Expression",
          density.info = "none",
          main = "Heatmap of top 500+ differentially expressed genes in Glioblastoma",
          cexRow = 0.9, cexCol = 0.7, margins = c(11,10))
# Zeta score data
heatmap.2(as.matrix(zscoreglio_data),
          col = seq_color_palette,
          Rowv = F, Colv = F, dendrogram = "none",
          sepcolor = "black",
          trace = "none",
          key = T,
          key.title = "Expression",
          density.info = "none",
          main = "Heatmap of top 500+ differentially expressed genes in Glioblastoma",
          cexRow = 0.9, cexCol = 0.7, margins = c(11,10))

# Heatmap with diverging palette
# Original Data
heatmap.2(as.matrix(glio_data),
          col = div_color_palette,
          Rowv = F, Colv = F, dendrogram = "none",
          sepcolor = "black",
          trace = "none",
          key = T,
          key.title = "Expression",
          density.info = "none",
          main = "Heatmap of top 500+ differentially expressed genes in Glioblastoma",
          cexRow = 0.9, cexCol = 0.7, margins = c(11,10))

# Log data
heatmap.2(as.matrix(log_glio_data),
          col = div_color_palette,
          Rowv = F, Colv = F, dendrogram = "none",
          sepcolor = "black",
          trace = "none",
          key = T,
          key.title = "Expression",
          density.info = "none",
          main = "Heatmap of top 500+ differentially expressed genes in Glioblastoma",
          cexRow = 0.9, cexCol = 0.7, margins = c(11,10))
# Zeta score data
heatmap.2(as.matrix(zscoreglio_data),
          col = div_color_palette,
          Rowv = F, Colv = F, dendrogram = "none",
          sepcolor = "black",
          trace = "none",
          key = T,
          key.title = "Expression",
          density.info = "none",
          main = "Heatmap of top 500+ differentially expressed genes in Glioblastoma",
          cexRow = 0.9, cexCol = 0.7, margins = c(11,10))

# Heat Map clustering by Genes
# Original Data
heatmap.2(as.matrix(glio_data),
          col = div_color_palette,
          Rowv = T, Colv = F, dendrogram = "row",
          sepcolor = "black",
          trace = "none",
          key = T,
          key.title = "Expression",
          density.info = "none",
          main = "Heatmap of top 500+ differentially expressed genes in Glioblastoma",
          cexRow = 0.9, cexCol = 0.7, margins = c(11,10))
# Log Data
heatmap.2(as.matrix(log_glio_data),
          col = div_color_palette,
          Rowv = T, Colv = F, dendrogram = "row",
          sepcolor = "black",
          trace = "none",
          key = T,
          key.title = "Expression",
          density.info = "none",
          main = "Heatmap of top 500+ differentially expressed genes in Glioblastoma",
          cexRow = 0.9, cexCol = 0.7, margins = c(11,10))
# Zeta Score Data
heatmap.2(as.matrix(zscoreglio_data),
          col = div_color_palette,
          Rowv = T, Colv = F, dendrogram = "row",
          sepcolor = "black",
          trace = "none",
          key = T,
          key.title = "Expression",
          density.info = "none",
          main = "Heatmap of top 500+ differentially expressed genes in Glioblastoma",
          cexRow = 0.9, cexCol = 0.7, margins = c(11,10))

# Heatmap clustering by sample
# Original Data
heatmap.2(as.matrix(glio_data),
          col = div_color_palette,
          Rowv = F, Colv = T, dendrogram = "column",
          sepcolor = "black",
          trace = "none",
          key = T,
          key.title = "Expression",
          density.info = "none",
          main = "Heatmap of top 500+ differentially expressed genes in Glioblastoma",
          cexRow = 0.9, cexCol = 0.7, margins = c(11,10))

# Log Data
heatmap.2(as.matrix(log_glio_data),
          col = div_color_palette,
          Rowv = F, Colv = T, dendrogram = "column",
          sepcolor = "black",
          trace = "none",
          key = T,
          key.title = "Expression",
          density.info = "none",
          main = "Heatmap of top 500+ differentially expressed genes in Glioblastoma",
          cexRow = 0.9, cexCol = 0.7, margins = c(11,10))

# Zeta Score Data
heatmap.2(as.matrix(zscoreglio_data),
          col = div_color_palette,
          Rowv = F, Colv = T, dendrogram = "column",
          sepcolor = "black",
          trace = "none",
          key = T,
          key.title = "Expression",
          density.info = "none",
          main = "Heatmap of top 500+ differentially expressed genes in Glioblastoma",
          cexRow = 0.9, cexCol = 0.7, margins = c(11,10))

# Heatmap clustering by both samples and gene
# Original Data
heatmap.2(as.matrix(glio_data),
          col = div_color_palette,
          Rowv = T, Colv = T, dendrogram = "both",
          sepcolor = "black",
          trace = "none",
          key = T,
          key.title = "Expression",
          density.info = "none",
          main = "Heatmap of top 500+ differentially expressed genes in Glioblastoma",
          cexRow = 0.9, cexCol = 0.7, margins = c(11,10))

# Log Data
heatmap.2(as.matrix(log_glio_data),
          col = div_color_palette,
          Rowv = T, Colv = T, dendrogram = "both",
          sepcolor = "black",
          trace = "none",
          key = T,
          key.title = "Expression",
          density.info = "none",
          main = "Heatmap of top 500+ differentially expressed genes in Glioblastoma",
          cexRow = 0.9, cexCol = 0.7, margins = c(11,10))

# Zeta score data
heatmap.2(as.matrix(zscoreglio_data),
          col = div_color_palette,
          Rowv = T, Colv = T, dendrogram = "both",
          sepcolor = "black",
          trace = "none",
          key = T,
          key.title = "Expression",
          density.info = "none",
          main = "Heatmap of top 500+ differentially expressed genes in Glioblastoma",
          cexRow = 0.9, cexCol = 0.7, margins = c(11,10))
