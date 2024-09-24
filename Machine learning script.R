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


View(lgg_data)
View(meta)

dim(lgg_data)
dim(meta)
## Unsupervised Machine Learning
# K-nearest neighbour
## How many samples do we have under each subset?
print(lgg_data)
dim(lgg_data)
rownames(lgg_data)
colnames(lgg_data)
View(lgg_data)
dim(meta)
print(meta)
colnames(meta)
anyNA(meta)
table(meta$subtype)
View(meta)
boxplot(lgg_data[,1:50], col = "lightblue")
#par(oma = c(bottom, left, top, right))
#par(oma = c(10,0,0,0)) 
#In R, the par() function is used to set or query graphical parameters. 
#The oma parameter in par() stands for outer margins, which controls the size of the margins outside the entire plotting region. 
#This is useful when you want to leave extra space around your plots, for example, to add annotations or titles that span multiple plots.

log_lggdata <- log10(lgg_data + 1)
boxplot(log_lggdata[, 1:50], col = "lightblue")

head(log_lggdata)
head(meta)

is.data.frame(log_lggdata)
all_trans <- data.frame(t(log_lggdata))
is.data.frame(all_trans)

SDs = apply(all_trans, 2, sd)
topPreds = order(SDs, decreasing = T)[1:1000]
all_trans = all_trans[, topPreds]

colnames(all_trans)
dim(all_trans)
View(all_trans)
all_trans <- merge(all_trans, meta, by = "row.names")
dim(all_trans)
View(all_trans)
all_trans[1:5, 1:5]
rownames(all_trans) <- all_trans$Row.names
all_trans[1:5, 1:5]
all_trans <- all_trans[,-1]
all_trans[1:5, 1:5]

# Splitting into training and Data Sets

intrain <- createDataPartition(y = all_trans$subtype, p = 0.7)[[1]]

train.lgg <- all_trans[intrain,]
test.lgg <- all_trans[-intrain,]

dim(train.lgg)
dim(test.lgg)

# Perform the training

ctrl_lgg <- trainControl(method = "cv", number = 5)

knn_lgg <- train(subtype~., #the levels of classification
                 data = train.lgg, #the training dataset
                 method = "knn", # the knn method
                 trControl = ctrl_lgg, #the training control
                 tuneGrid = data.frame(k=1:20))

#the best K is:
knn_lgg$bestTune

#predict
trainPred <- predict(knn_lgg, newdata = train.lgg)
testPred <- predict(knn_lgg, newdata = test.lgg)

# Interpretation
# confusion matrix
confusionMatrix(trainPred, train.lgg$subtype)
confusionMatrix(testPred, test.lgg$subtype)


#determine variable importance