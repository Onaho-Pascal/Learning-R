install.packages("gcookbook")
install.packages("readr")
library(dplyr)


data <- read.csv("C:/Users/user/Desktop/R-files/Testexcel/study.csv", header = TRUE, stringsAsFactors = FALSE)

# data$Sex <- factor(data$Sex)

# Scattered plot: plot(nameofdata$valuetobeplacedinXaxis, nameofdata$valuetobeplacedinYaxis)
plot(data$CGPA, data$Grade)

library(ggplot2)
ggplot(data, aes( x = CGPA, y = Grade)) +
geom_point()
