# Task 3
getwd()
setwd("C:/Users/user/Documents/Hackbio Internship Materials/Task 3")
library(caret)
library(DALEX)
library(pROC)
set.seed(42)

colon_data <- read.csv(file = "raw expression data tcga-coad.csv", header = TRUE)
colon_meta <- read.csv(file = "metadata tcga-coad0.csv", header = TRUE)

install.packages("dplyr")
install.packages("tidyr")
library(dplyr)
library(tidyr)
print(colon_meta)
dim(colon_meta)
colon_meta$barcode
dim(colon_data)
rownames(colon_data)
colnames(colon_data)
View(colon_data)
dim(colon_meta)
is.data.frame(colon_meta)
is.data.frame(colon_data)

# Battling with column names
######
#names(colon_meta)

#to check if there are any missing values
anyNA(colon_meta)
sum(is.na(colon_meta))

colon_meta_clean <- colon_meta %>% drop_na()


anyNA(colon_meta_clean)


# rows_with_na <- which(apply(colon_meta, 1, function(row) any(is.na(row))))
# colnames(colon_meta)
#####

boxplot(colon_data, col = "green")
log_colon_data <- log10(colon_data + 1)
boxplot(log_colon_data, col = "green")

length(colon_data)
table(colon_meta$gender)
table(colon_meta_clean$gender)

View(colon_meta_clean)
is.data.frame(colon_meta_clean)
# Sort a data frame in ascending order by a specific column (e.g., "column_name")
# colon_meta_sorted_asc <- colon_meta[order(colon_meta$gender), ]
# View(colon_meta_sorted_asc)
# table(colon_meta_sorted_asc$gender)
dim(log_colon_data)
dim(colon_meta_clean)
colnames(colon_meta_clean)
# transpose the data
colnames(log_colon_data) <- gsub("\\.", "-", colnames(log_colon_data))

View(log_colon_data)
trans_data <- data.frame(t(log_colon_data))
dim(trans_data)
View(trans_data)
# trans_meta = data.frame(t(colon_meta_clean))
#colnames(trans_data)

# From this point, I will be using "trans_data" and "colon_meta_clean"

SDs = apply(trans_data, 2, sd)
topPredicts = order(SDs, decreasing = T)[1:2000]
trans_data = trans_data[, topPredicts]


rownames(trans_data)


rownames(colon_meta_clean) <- colon_meta_clean$barcode

rownames(trans_data)
rownames(colon_meta_clean)
View(colon_meta_clean)
colon_meta_clean$barcode <- NULL
View(colon_meta_clean)
merge_data <- merge(trans_data, colon_meta_clean, by = "row.names")
dim(merge_data)
View(merge_data)
#trans_data[1:5, 1:5]
#rownames(all_trans) <- all_trans$Row.names
#all_trans[1:5, 1:5]
#all_trans <- all_trans[,-1]
#all_trans[1:5, 1:5]

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

for (column_name in names(test_colon)) {
  if (is.factor(test_colon[[column_name]])) {
    levels(test_colon[[column_name]]) <- levels(train_colon[[column_name]])
  }
}
# Perform the training

ctrl_colon <- trainControl(method = "cv", number = 5)
rownames(train_colon) <- NULL
rownames(test_colon) <- NULL

knn_colon <- train(gender~., #the levels of classification
                 data = train_colon, #the training dataset
                 method = "knn", # the knn method
                 trControl = ctrl_colon, #the training control
                 tuneGrid = data.frame(k=1:20))

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

