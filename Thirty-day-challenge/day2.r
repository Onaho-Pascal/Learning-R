#################################
## Data Exploration and Cleaning
#################################


# Loading the data into R
raw_data <- readRDS("C:/Users/user/Downloads/Data Files/raw_expression_data_tcga-coad.rds")
rownames(raw_data) <- raw_data$X

raw_data$X <- NULL


# Checking for missing values
any(is.na(raw_data))
sum(is.na(raw_data))

# Checking for duplicates

library(dplyr)
duplicates <- raw_data[duplicated(raw_data),]
View(duplicates)

# Normalization of Data

normalized_data <- scale(raw_data) # Z-score normalization

normalized_data <- log2(normalized_data + 1) # Long transformation (+1 is added to account for 0 values)
