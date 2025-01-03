install.packages("gcookbook")
install.packages("readr")
library(dplyr)


data <- read.csv("C:/Users/user/Desktop/R-files/Testexcel/study.csv", header = TRUE, stringsAsFactors = FALSE)

# data$Sex <- factor(data$Sex)

# Scattered plot

#plot(nameofdata$valuetobeplacedinXaxis, nameofdata$valuetobeplacedinYaxis)
plot(data$CGPA, data$Grade)

library(ggplot2)
ggplot(data, aes( x = CGPA, y = Grade)) + 
  geom_point()

#line plot
plot(data$CGPA, data$Grade, type = "l")
points(data$CGPA, data$Grade)

ggplot(data, aes(x = CGPA, y = Grade)) + 
  geom_line() +
  geom_point()

# Bar plot
ggplot(data, aes(x = CGPA, y = Grade)) + 
  geom_col(width = 0.8)
