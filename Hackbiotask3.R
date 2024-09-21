# Set the working directory

getwd()
setwd("C:/Users/user/Documents/Hackbio Internship Materials/Task 3")

# Load the ML packages and set seed (for the random number generator. 
#This ensures that the sequence of random numbers generated will be the same each time you run the code. 
#This is crucial for reproducibility in statistical analysis and simulations, allowing others (or yourself at a later time) to obtain the same results.)

library(caret)
library(DALEX)
library(pROC)
set.seed(42)

# Load the main and meta data
colon_data <- read.csv(file = "raw expression data tcga-coad.csv", header = TRUE)
colon_meta <- read.csv(file = "metadata tcga-coad0.csv", header = TRUE)

install.packages("dplyr")
install.packages("tidyr")
library(dplyr)
library(tidyr)



# check for missing values and remove if any
anyNA(colon_meta)
sum(is.na(colon_meta))
colon_meta_clean <- colon_meta %>% drop_na()
anyNA(colon_meta_clean)


# View data and normalize variance using log transformation
boxplot(colon_data, col = "green")
log_colon_data <- log10(colon_data + 1)
boxplot(log_colon_data, col = "green")



dim(log_colon_data)

dim(colon_meta_clean)

colnames(colon_meta_clean)

# correct the column names to be in tune with that of the meta data's column names
colnames(log_colon_data) <- gsub("\\.", "-", colnames(log_colon_data))

View(log_colon_data)

# Transpose the main data
trans_data <- data.frame(t(log_colon_data))
dim(trans_data)
View(trans_data)


# From this point, I will be using "trans_data" and "colon_meta_clean"

SDs = apply(trans_data, 2, sd)
# This line calculates the standard deviation for each column (each gene) in trans_data and stores the results in the vector SDs. 
# A higher standard deviation indicates greater variability in the gene expression levels.

topPredicts = order(SDs, decreasing = T)[1:2000]
#After calculating the standard deviation, this lines ensures that the top 2000 genes with the highest SD are selected, and in descending order.


trans_data = trans_data[, topPredicts]
#The trans_data is now reduced to only include the top 2000 genes that have the highest variability, 
# which are often more informative for subsequent analyses like classification

rownames(trans_data)


rownames(colon_meta_clean) <- colon_meta_clean$barcode #changed the rownames from numerical "1, 2, 3, 4, 5...." to the Barcode

rownames(trans_data)
rownames(colon_meta_clean)

colon_meta_clean$barcode <- NULL #to remove the row name duplicate
View(colon_meta_clean)
merge_data <- merge(trans_data, colon_meta_clean, by = "row.names") #merging of both main and meta data
dim(merge_data)
View(merge_data)


# Splitting into training and Data Sets

coltrain <- createDataPartition(y = merge_data$gender, p = 0.7)[[1]]

train_colon <- merge_data[coltrain,]
test_colon <- merge_data[-coltrain,]

dim(train_colon)
dim(test_colon)
View(train_colon)
View(test_colon)

if ("Row.names" %in% colnames(train_colon)) {
  train_colon$Row.names <- NULL
}

if ("Row.names" %in% colnames(test_colon)) {
  test_colon$Row.names <- NULL
}

#for (column_name in names(test_colon)) {
  #if (is.factor(test_colon[[column_name]])) {
   # levels(test_colon[[column_name]]) <- levels(train_colon[[column_name]])
  #}
#}

# Perform the training

ctrl_colon <- trainControl(method = "cv", number = 10)


knn_colon <- train(gender~., #the levels of classification
                 data = train_colon, #the training dataset
                 method = "knn", # the knn method
                 trControl = ctrl_colon, #the training control
                 tuneGrid = expand.grid(k = seq(1, 50, by = 2)))

#the best K is:
knn_colon$bestTune
colnames(train_colon)
colnames(test_colon)

str(train_colon)
str(test_colon)
#predict
trainPred_colon <- predict(knn_colon, newdata = train_colon)
testPred_colon <- predict(knn_colon, newdata = test_colon)

trainPred_colon <- as.factor(trainPred_colon)
train_colon$gender <- as.factor(train_colon$gender)
testPred_colon <- as.factor(testPred_colon)
test_colon$gender <- as.factor(test_colon$gender)

levels(trainPred_colon) <- levels(train_colon$gender)
levels(testPred_colon) <- levels(test_colon$gender)
# Interpretation
# confusion matrix
confusionMatrix(trainPred_colon, train_colon$gender)
confusionMatrix(testPred_colon, test_colon$gender)
View(knn_colon)

