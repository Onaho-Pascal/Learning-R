getwd()
setwd("C:/Users/user/Documents/Hackbio Internship Materials/Task 3")
merged_data <- read.csv("log_transformed__merged_final_data.csv")
View(merged_data)

rownames(merged_data) <- merged_data$barcode
View(merged_data)
merged_data$barcode <- NULL
View(merged_data)
rownames(merged_data) <- gsub("\\.", "-", rownames(merged_data))
View(merged_data)

carcinoma.data <- merged_data

View(carcinoma.data)
carcinoma_meta <- read.csv(file = "metadata tcga-coad0.csv", header = TRUE)
library(dplyr)
library(tidyr)

anyNA(carcinoma_meta)
sum(is.na(carcinoma_meta))
carcinoma_meta_clean <- carcinoma_meta %>% drop_na()
anyNA(carcinoma_meta_clean)




rownames(carcinoma_meta_clean) <- carcinoma_meta_clean$barcode

carcinoma_meta_clean$barcode <- NULL
View(carcinoma_meta_clean)

carcinoma.meta <- carcinoma_meta_clean
View(carcinoma.meta)




#####################
# New Working Directory
#####################


setwd("C:/Users/user/Documents/Hackbio Internship Materials/Task 3/Report/")

saveRDS(carcinoma.data, file = "carcinoma_data.rds")

saveRDS(carcinoma.meta, file = "carcinoma_meta.rds")


carcinoma.data <- readRDS("carcinoma_data.rds")

carcinoma.meta <- readRDS("carcinoma_meta.rds")

View(carcinoma.data)
View(carcinoma.meta)

SDs = apply(carcinoma.data, 2, sd)
topPredicts = order(SDs, decreasing = T)[1:3000]
carcinoma.data = carcinoma.data[, topPredicts]

carcinoma_merged_data <- merge(carcinoma.data, carcinoma.meta, by = "row.names")

View(carcinoma_merged_data)


rownames(carcinoma_merged_data) <- carcinoma_merged_data$Row.names
carcinoma_merged_data$Row.names <- NULL

library(caret)
library(DALEX)
library(pROC)

# To remove near zero variation
all_zero <- preProcess(carcinoma_merged_data, method = "nzv", uniqueCut = 15)
carcinoma_merged_data <- predict(all_zero, carcinoma_merged_data)
dim(carcinoma_merged_data)
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
# Assuming your data is already loaded in the variable carcinoma_merged_data
data <- carcinoma_merged_data
# One-hot encoding the gender (convert gender into 0 and 1)
data$gender <- ifelse(data$gender == "female", 0, 1)
# Encode tumor stage using label encoding (you can use one-hot encoding if preferred)

# Select only the gene expression columns (assuming columns starting with 'ENSG' are gene expression data)
gene_expression_columns <- grep("^ENSG", colnames(data), value = TRUE)
X <- data[, gene_expression_columns]
y <- data$gender
# Split the data into training and testing sets
set.seed(123)  # For reproducibility
trainIndex <- createDataPartition(y, p = 0.7, list = FALSE)
X_train <- X[trainIndex, ]
X_test <- X[-trainIndex, ]
y_train <- y[trainIndex]
y_test <- y[-trainIndex]
# Train a KNN model
knn_model <- train(X_train, as.factor(y_train), method = "knn", tuneLength = 5)
# Predict on the test set
y_pred <- predict(knn_model, X_test)
x_pred <- predict(knn_model, X_train)
# Evaluate the model using confusion matrix
conf_matrix <- confusionMatrix(y_pred, as.factor(y_test))
conf_matrix1 <- confusionMatrix(x_pred, as.factor(y_train))
print(conf_matrix)
print(conf_matrix1)
# Calculate accuracy
accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)

print(paste("Accuracy: ", accuracy))
# Now perform permutation importance
set.seed(123)  # For reproducibility
importance <- varImp(knn_model, scale = FALSE)
print(importance)