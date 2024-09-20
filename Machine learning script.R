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
