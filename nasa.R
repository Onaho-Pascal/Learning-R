library(dplyr)
library(ggplot2)



nasa_data <- read.csv("C:/Users/user/Downloads/nasa-annual-budget/nasa-annual-budget.csv", header = TRUE)
View(nasa_data)

install.packages("scales")
install.packages("formattable")

library(scales)
library(formattable)

nasa_data$Budget <- currency(nasa_data$Budget)


ggplot(nasa_data, aes(x = Year, y = Budget)) +
  geom_col(width = 0.8)
