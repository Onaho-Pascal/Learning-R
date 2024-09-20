
# Data Wrangling with R

library(tidyverse)

my_data <- nycflights13::flights

head(my_data)
tail(my_data)

# first we will just look at the data on the October 14th.

filter(my_data, month == 10, day == 14)

filter(my_data, month == 10, day == 14, sched_dep_time == 600)

# if we want to subset this into a new variable, we do the following:

oct_14_flight <- filter(my_data, month == 10, day == 14)

# TO print and save the variable

(name <- "Pascal")

print(name)


# If you want to filter based on different operators, you can use the following:

# Equals ==
# Not equal to !=
# greater than >
# lesser than <
# greater than or equal to >=
# lesser than or equal to <=

(flight_through_september <- filter(my_data, month < 10, day == 14))

# You can also use logical operators to be more selective

# and &
# or | 
# not !

# Let's use the "or" function in March and April

(march_april_flights <- filter(my_data, month == 3 | month == 4))

non_jan_flighs <- filter(my_data, month != 1)

##############################
# Arrange
##############################

# Arrange allows us to arrange the data set based on the variables we desire.

arrange(my_data, year, day, month)
descending <- arrange(my_data, desc(year), desc(day), desc(month))
print(descending)


# Missing values will always be placed at the end of the dataframe 
# regardless of ascending or descending.

###################
# Select
##################

# WE can also select specific columns that we want to look at.

calendar <- select(my_data, year, month, day)
print(calendar)


james = list(4, 5, 12, 30)
peter = list(8, 10, 24, 60)
dim(james) = c(2, 2)
james
john = list(james, peter)
#dim(john) = c(2, 1)
john
