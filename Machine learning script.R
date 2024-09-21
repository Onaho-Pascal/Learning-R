#######
# Predicitng Tumor status as either methylated or non-methylated
#######
getwd()
setwd("C:/Users/user/Documents/Hackbio Internship Materials/Machine learning Test Data")

install.packages("caret")
install.packages("DALEX")
install.packages("pROC")

library(caret)
library(DALEX)
library(pROC)
set.seed(34567)

# To Load my RDS files
lgg_data <- readRDS("LGGrnaseq.rds")
meta <- readRDS("patient2LGGsubtypes.rds")

## Unsupervised Machine Learning
# K-nearest neighbour
## How many samples do we have under each subset?

table(meta$subtype)
boxplot(lgg_data[,1:50], col = "lightblue")
#par(oma = c(bottom, left, top, right))
#par(oma = c(10,0,0,0)) 
#In R, the par() function is used to set or query graphical parameters. 
#The oma parameter in par() stands for outer margins, which controls the size of the margins outside the entire plotting region. 
#This is useful when you want to leave extra space around your plots, for example, to add annotations or titles that span multiple plots.

log_lggdata <- log2(lgg_data + 1)
boxplot(log_lggdata[, 1:50], col = "lightblue")

head(log_lggdata)
head(meta)
