# Simple operation
## This is how R does addition

12 + 10

## This is how R does subtraction

12 - 10

# This is how we store data as variables in R language.
# we will start by storing days of the week

days <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday",
          "Sunday")

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


days[c(1, 3, 5, 7)]

#let's create a subset of our existing range

weekdays <- days[1:5]

weekdays

print(weekdays)



#Functions
## f(argument1,_argument2...)
# F is the name of the function and the contents of the parenthesis
# are the conditions we are asking the function to evaluate

example_function <- function(x, y)

{
  c(x + 2, y + 15)
}

example_function(10, 20)

#There are built-in functions in R and some examples are shown below

log(20)
sin(20)
exp(20)
tan(20)
tan(2)
tan(200)


# Data structures
# Let's start with the array function and compare it with the
# simple list function.

months <- array(c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
                  "Aug", "Sep", "Oct", "Nov", "Dec"), dim = c(3, 4))

months

months1 <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
             "Aug", "Sep", "Oct", "Nov", "Dec")

months1

# Let's look at Matrix

months2 <- matrix(data = c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                           "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"),
                  ncol = 4, nrow = 3)

months2

#making a 3d array
array3d <- array(data = c(2, 4, 6, 8, 10, 12, 14, 16, 18, 20,
                          22, 24, 26, 28, 30, 32, 34, 36), dim = c(3, 3, 2))

array3d

print(array3d[2, 1, 2])


# To pull an entire row or column

print(array3d[1, , 2])

print(array3d[, 3, 2])
