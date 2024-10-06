# Set the working directory

getwd()
setwd("C:/Users/user/Documents/Hackbio Internship Materials/Task 3")

# Load the ML packages and set seed (for the random number generator. 
#This ensures that the sequence of random numbers generated will be the same each time you run the code. 
#This is crucial for reproducibility in statistical analysis and simulations, allowing others (or yourself at a later time) to obtain the same results.)

library(caret)
library(DALEX)
library(pROC)
library(DALEXtra)

library(dplyr) 
library(tidyr)

set.seed(42)

# Load the main and meta data
carcinoma_data <- read.csv(file = "raw_expression_data_tcga-coad.csv", header = TRUE)
carcinoma_meta <- read.csv(file = "metadata tcga-coad0.csv", header = TRUE)




# Preprocessing the main data


rownames(carcinoma_data) <- carcinoma_data$X # Making column "X" the row names, rather than numerical "1", "2", "3"...
carcinoma_data$X <- NULL # Removing duplicate columns as row names


boxplot(carcinoma_data, col = "lightblue")
carcinoma_data <- log2(carcinoma_data + 1) # A log transformation to normalize the data
boxplot(carcinoma_data, col = "lightblue")


colnames(carcinoma_data) <- gsub("\\.", "-", colnames(carcinoma_data)) # Editing the format of the main data so it becomes similar to the rownames of the meta data

# Transpose the main data
carcinoma_data <- data.frame(t(carcinoma_data))

SDs = apply(carcinoma_data, 2, sd)
# This line calculates the standard deviation for each column (each gene) in carcinoma_data and stores the results in the vector SDs. 
# A higher standard deviation indicates greater variability in the gene expression levels.

topPredicts = order(SDs, decreasing = T)[1:3000]
#After calculating the standard deviation, this lines ensures that the top 3000 genes with the highest SD are selected, and in descending order.


carcinoma_data = carcinoma_data[, topPredicts]
#The trans_data is now reduced to only include the top 3000 genes that have the highest variability, which are often more informative for subsequent analyses like classification



# Preprocessing the meta data
anyNA(carcinoma_meta)
sum(is.na(carcinoma_meta))
carcinoma_meta <- carcinoma_meta %>% drop_na()
anyNA(carcinoma_meta)



rownames(carcinoma_meta) <- carcinoma_meta_$barcode #changed the rownames from numerical "1, 2, 3, 4, 5...." to the Barcode

carcinoma_meta_clean$barcode <- NULL #to remove the row name duplicate


# Merge both data
carcinoma_merged_data <- merge(carcinoma_data, carcinoma_meta, by = "row.names") #merging of both main and meta data


View(carcinoma_merged_data)
# To remove near zero variation

all_zero <- preProcess(carcinoma_merged_data, method = "nzv", uniqueCut = 15)
carcinoma_merged_data <- predict(all_zero, carcinoma_merged_data)


# center. Centering helps to stabilize numerical computations 
#and can be particularly important for algorithms sensitive to the scale of the data (like PCA, KNN, etc.).
all_center <- preProcess(carcinoma_merged_data, method = "center")
carcinoma_merged_data <- predict(all_center, carcinoma_merged_data)



# to remove highly correlated values.
#Reduce Multicollinearity: High correlations between features can lead to issues in model training, 
#such as inflated standard errors and difficulties in interpreting coefficients. 
#Removing redundant features helps create a more stable model.
# Improve Model Performance: By reducing the number of features, 
# you can improve the efficiency and performance of certain machine learning algorithms, especially those sensitive to multicollinearity.

all_corr <-preProcess(carcinoma_merged_data, method = "corr", cutoff = 0.5)
carcinoma_merged_data <- predict(all_corr, carcinoma_merged_data)




# Splitting into training and Data Sets

carcinomatrain <- createDataPartition(y = carcinoma_merged_data$gender, p = 0.7)[[1]]

train_carcinoma <- carcinoma_merged_data[carcinomatrain,]
test_carcinoma <- carcinoma_merged_data[-carcinomatrain,]

if ("Row.names" %in% colnames(train_carcinoma)) {
  train_carcinoma$Row.names <- NULL
}

if ("Row.names" %in% colnames(test_carcinoma)) {
  test_carcinoma$Row.names <- NULL
}



# Perform the training

ctrl_carcinoma <- trainControl(method = "cv", number =5)


knn_carcinoma <- train(gender~., #the levels of classification
                   data = train_carcinoma, #the training dataset
                   method = "knn", # the knn method
                   trControl = ctrl_carcinoma, #the training control
                   tuneGrid = data.frame(k = 1:5))

#the best K is:
knn_carcinoma$bestTune

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

library(caret)
library(DALEX)


explainer_carcinoma <- explain(
  model = knn_carcinoma,
  data = train_carcinoma[, -which(names(train_carcinoma) == "gender")], # Exclude gender column
  y = as.numeric(train_carcinoma$gender),
  label = "knn",
  type = "classification"  # Specify the model type
)


#determine the variable importance
explainer_carcinoma <- explain(fitted_model, 
                               label = "knn",
                               data = train_carcinoma,
                               y = as.numeric(train_carcinoma$gender))

explainer_carcinoma <- explain(knn_carcinoma, 
                               label = "knn",
                               data = train_carcinoma,
                               y = as.numeric(train_carcinoma$gender))


importance_carcinoma <- feature_importance(explainer_carcinoma, n_sample = 40, type = "difference")
                              
