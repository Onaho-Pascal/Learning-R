install.packages("gcookbook")
install.packages("readr")
library(ggplot2)
library(dplyr)


data <- read.csv("C:/Users/user/Desktop/R-files/Testexcel/study.csv", header = TRUE, stringsAsFactors = FALSE)

# data$Sex <- factor(data$Sex)

# Scattered plot: plot(nameofdata$valuetobeplacedinYaxis, nameofdata$valuetobeplacedinXaxis)
plot(data$CGPA, data$Grade)
