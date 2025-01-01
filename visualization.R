install.packages("gcookbook")
library(ggplot2)
library(dplyr)


data <- read.csv("C:/Users/user/Desktop/R-files/Testexcel/study.csv",  stringsAsFactors = FALSE)
data$Sex <- factor(data$Sex)
