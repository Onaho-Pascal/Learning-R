getwd()
setwd("C:/Users/user/Documents/Hackbio Internship Materials/Stage 4")

install.packages("BiocManager")
BiocManager::install("TCGAbiolinks")
library(TCGAbiolinks)

library(caret)
library(DALEX)
library(pROC)
set.seed(1234)
# Load the main and meta data
lgg.data <- read.csv(file = "glioma_rawcounts.csv", header = TRUE)
lgg.meta <- read.csv(file = "glioma_metadata.csv", header = TRUE)
dim(lgg.data)
rownames(lgg.data) <- lgg.data$X

lgg.data$X <- NULL

colnames(lgg.data) <- gsub("\\.", "-", colnames(lgg.data))
lgg.data <- log10(lgg.data + 1)

lgg.data <- data.frame(t(lgg.data))


SDs = apply(lgg.data, 2, sd)
# This line calculates the standard deviation for each column (each gene) in lgg.data and stores the results in the vector SDs. 
# A higher standard deviation indicates greater variability in the gene expression levels.

topPredicts = order(SDs, decreasing = T)[1:3000]
#After calculating the standard deviation, this lines ensures that the top 2000 genes with the highest SD are selected, and in descending order.


lgg.data = lgg.data[, topPredicts]
#The trans_data is now reduced to only include the top 3000 genes that have the highest variability, 
# which are often more informative for subsequent analyses like classification

rownames(lgg.meta) <- lgg.meta$barcode

lgg.meta$barcode <- NULL

merge.data <- merge(lgg.data, lgg.meta, by = "row.names")

rownames(merge.data) <- merge.data$Row.names

merge.data$Row.names <- NULL

dim(merge.data)

anyNA(merge.data)
sum(is.na(merge.data))



# To remove near zero variation

zero <- preProcess(merge.data, method = "nzv", uniqueCut = 15)
merge.data <- predict(zero, merge.data)


# center. Centering helps to stabilize numerical computations 
#and can be particularly important for algorithms sensitive to the scale of the data (like PCA, KNN, etc.).
center <- preProcess(merge.data, method = "center")
merge.data <- predict(center, merge.data)



# to remove highly correlated values.
#Reduce Multicollinearity: High correlations between features can lead to issues in model training, 
#such as inflated standard errors and difficulties in interpreting coefficients. 
#Removing redundant features helps create a more stable model.
# Improve Model Performance: By reducing the number of features, 
# you can improve the efficiency and performance of certain machine learning algorithms, especially those sensitive to multicollinearity.

corr <-preProcess(merge.data, method = "corr", cutoff = 0.5)
merge.data <- predict(corr, merge.data)

dim(merge.data)

lgg.train <- createDataPartition(y = merge.data$IDH.status, p = 0.7)[[1]]

train.lgg <- merge.data[lgg.train,]
test.lgg <- merge.data[-lgg.train,]


ctrl.lgg <- trainControl(method = "cv", number = 10)


knn.lgg <- train(IDH.status~., #the levels of classification
                   data = train.lgg, #the training dataset
                   method = "knn", # the knn method
                   trControl = ctrl.lgg, #the training control
                   tuneGrid = expand.grid(k = seq(1, 50, by = 2)))

#the best K is:
knn.lgg$bestTune



#predict
trainPred.lgg <- predict(knn.lgg, newdata = train.lgg)
testPred.lgg <- predict(knn.lgg, newdata = test.lgg)

trainPred.lgg <- as.factor(trainPred.lgg)
train.lgg$IDH.status <- as.factor(train.lgg$IDH.status)
testPred.lgg <- as.factor(testPred.lgg)
test.lgg$IDH.status <- as.factor(test.lgg$IDH.status)

levels(trainPred.lgg) <- levels(train.lgg$IDH.status)
levels(testPred.lgg) <- levels(test.lgg$IDH.status)
# Interpretation
# confusion matrix
confusionMatrix(trainPred.lgg, train.lgg$IDH.status)
confusionMatrix(testPred.lgg, test.lgg$IDH.status)

install.packages("iml")
library(iml)

explainer.lgg <- explain(knn.lgg, 
                               label = "knn",
                               data = train.lgg,
                               y = as.numeric(train.lgg$IDH.status))


importance.lgg <- feature_importance(explainer.lgg, n_sample = 30, type = "difference")
head(importance.lgg$variable)
tail(importance.lgg$variable)
