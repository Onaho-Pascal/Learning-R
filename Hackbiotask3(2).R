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
carcinoma_data <- read.csv(file = "raw expression data tcga-coad.csv", header = TRUE)
carcinoma_meta <- read.csv(file = "metadata tcga-coad0.csv", header = TRUE)

install.packages("dplyr")
install.packages("tidyr")
library(dplyr)
library(tidyr)



# check for missing values and remove if any
anyNA(carcinoma_meta)
sum(is.na(carcinoma_meta))
carcinoma_meta_clean <- carcinoma_meta %>% drop_na()
anyNA(carcinoma_meta_clean)


# View data and normalize variance using log transformation
boxplot(carcinoma_data, col = "green")
log_carcinoma_data <- log10(carcinoma_data + 1)
boxplot(log_carcinoma_data, col = "green")



dim(log_carcinoma_data)

dim(carcinoma_meta_clean)

colnames(carcinoma_meta_clean)

# correct the column names to be in tune with that of the meta data's column names
colnames(log_carcinoma_data) <- gsub("\\.", "-", colnames(log_carcinoma_data))

View(log_carcinoma_data)

# Transpose the main data
trans_carc_data <- data.frame(t(log_carcinoma_data))
dim(trans_carc_data)
View(trans_data)


# From this point, I will be using "trans_data" and "colon_meta_clean"

SDs = apply(trans_carc_data, 2, sd)
# This line calculates the standard deviation for each column (each gene) in trans_data and stores the results in the vector SDs. 
# A higher standard deviation indicates greater variability in the gene expression levels.

topPredicts = order(SDs, decreasing = T)[1:2000]
#After calculating the standard deviation, this lines ensures that the top 2000 genes with the highest SD are selected, and in descending order.


trans_carc_data = trans_carc_data[, topPredicts]
#The trans_data is now reduced to only include the top 2000 genes that have the highest variability, 
# which are often more informative for subsequent analyses like classification

rownames(trans_carc_data)


rownames(carcinoma_meta_clean) <- carcinoma_meta_clean$barcode #changed the rownames from numerical "1, 2, 3, 4, 5...." to the Barcode

rownames(trans_carc_data)
rownames(carcinoma_meta_clean)
View(carcinoma_meta_clean)

carcinoma_meta_clean$barcode <- NULL #to remove the row name duplicate
View(carcinoma_meta_clean)
carcinoma_merged_data <- merge(trans_carc_data, carcinoma_meta_clean, by = "row.names") #merging of both main and meta data
dim(carcinoma_merged_data)
View(carcinoma_merged_data)

# To remove near zero variation

all_zero <- preProcess(carcinoma_merged_data, method = "nzv", uniqueCut = 15)
carcinoma_merged_data <- predict(all_zero, carcinoma_merged_data)

dim(carinoma_merged_data)

# center. Centering helps to stabilize numerical computations 
#and can be particularly important for algorithms sensitive to the scale of the data (like PCA, KNN, etc.).
all_center <- preProcess(carcinoma_merged_data, method = "center")
carcinoma_merged_data <- predict(all_center, carcinoma_merged_data)

dim(carcinoma_merged_data)

# to remove highly correlated values.
#Reduce Multicollinearity: High correlations between features can lead to issues in model training, 
#such as inflated standard errors and difficulties in interpreting coefficients. 
#Removing redundant features helps create a more stable model.
# Improve Model Performance: By reducing the number of features, 
# you can improve the efficiency and performance of certain machine learning algorithms, especially those sensitive to multicollinearity.

all_corr <-preProcess(carcinoma_merged_data, method = "corr", cutoff = 0.5)
carcinoma_merged_data <- predict(all_corr, carcinoma_merged_data)


dim(carcinoma_merged_data)


# Splitting into training and Data Sets

carcinomatrain <- createDataPartition(y = carcinoma_merged_data$gender, p = 0.7)[[1]]

train_carcinoma <- carcinoma_merged_data[carcinomatrain,]
test_carcinoma <- carcinoma_merged_data[-carcinomatrain,]

dim(train_carcinoma)
dim(test_carcinoma)
View(train_carcinoma)
View(test_carcinoma)

if ("Row.names" %in% colnames(train_carcinoma)) {
  train_carcinoma$Row.names <- NULL
}

if ("Row.names" %in% colnames(test_carcinoma)) {
  test_carcinoma$Row.names <- NULL
}

#for (column_name in names(test_colon)) {
#if (is.factor(test_colon[[column_name]])) {
# levels(test_colon[[column_name]]) <- levels(train_colon[[column_name]])
#}
#}

# Perform the training

ctrl_carcinoma <- trainControl(method = "cv", number = 5)


knn_carcinoma <- train(gender~., #the levels of classification
                   data = train_carcinoma, #the training dataset
                   method = "knn", # the knn method
                   trControl = ctrl_carcinoma, #the training control
                   tuneGrid = data.frame(k = 1:10))

#the best K is:
knn_carcinoma$bestTune
colnames(train_carcinoma)
colnames(test_carcinoma)

str(train_carcinoma)
str(test_carcinoma)
#predict
trainPred_carcinoma <- predict(knn_carcinoma, newdata = train_carcinoma)
testPred_carcinoma <- predict(knn_carcinoma, newdata = test_carcinoma)

trainPred_carcinoma <- as.factor(trainPred_carcinoma)
train_carcinoma$gender <- as.factor(train_carcinoma$gender)
testPred_carcinoma <- as.factor(testPred_carcinoma)
test_carcinoma$gender <- as.factor(test_carcinoma$gender)

levels(trainPred_carcinoma) <- levels(train_carcinoma$gender)
levels(testPred_carcinoma) <- levels(test_carcinoma$gender)
# Interpretation
# confusion matrix
confusionMatrix(trainPred_carcinoma, train_carcinoma$gender)
confusionMatrix(testPred_carcinoma, test_carcinoma$gender)
View(knn_carcinoma)

