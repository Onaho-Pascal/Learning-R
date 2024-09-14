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

heatmap.2(as.matrix(glio_data),
          col = seq_color_palette,
          Rowv = F, Colv = F, dendrogram = "none",
          sepcolor = "black",
          trace = "none",
          key = T,
          key.title = "Expression",
          density.info = "none",
          main = "Heatmap of top 500+ differentially expressed genes in Glioblastoma",
          cexRow = 0.9, cexCol = 0.7, margins = c(10,10))
View(glio_data)
