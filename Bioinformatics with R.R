# Simple operation
## This is how R does addition

12+10

## This is how R does subtraction

12 - 10

# This is how we store data as variables in R language.
# we will start by storing days of the week

days <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")

#let's find different entries in this stored value

days[1]
days[7]
days[5]
days[3]

#let's get a range of entries

days[1:6]
days[2:5]
days[1:4]

#let's get specific days in the range


days[c(1,3,5,7)]

#let's create a subset of our existing range

weekdays <- days[1:5]

weekdays

print(weekdays)