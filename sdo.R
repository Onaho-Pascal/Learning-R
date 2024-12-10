paste("Here we go", "again!") #the paste() function can be used to concatenate or combine character types

paste("look", "here", sep="_") # The default separator is a space, but you can declare your desired separator by using the "sep" parameter:

# Setting the quote parameter to FALSE removes the quotes from the output.

print("Let's print some R!", quote = FALSE)

# Using the noquote() function prevents quotes from being output.

noquote("Let's print some R!")

#The cat() function can be used to concatenate and format character output.

# Format output (spaces are automatically added between items)

men <- 32
women <- 27

# Assigning the sum of the variables men and women to the variable num_participants.
num_participants <- men+women


# Concatenating the variable num_participants with two character strings and returning the output.
cat("There are", num_participants, "individuals currently participating in the study.")

# Create a vector of numbers beginning from 5 and counting down through (and including) -5:

seq1 <- 5:-5
print(seq1)

#The seq() ("sequence") function can be used to construct a vector from a sequence of numbers:

# Create a vector of 20 numbers, evenly spaced between the numbers 1 through 10:

seq(1, 10, length=20)  

# Create a vector of numbers from 1 through 10, stepping every 0.1:

seq(from = 1, to = 10, by = 0.1)

# Test each value in a vector as to whether it is missing or not:

x <- c("a", NA, "c", "d", "e")

# x is the variable containing a vector with a missing value
is.na(x)

x <- c("a", NA, "c", "d", "e")

# x is the variable containing a vector with a misssing value
anyNA(x)

v = c(25, 9, 16, 4)
sort(v)
sort(v, decreasing=TRUE)

# Count the frequency of occurrence for each element in a vector:

table(c(20,30,50,20,40,10,40,20))

# Test each value in the vector v as to whether it is greater than 10 or not (returns TRUE or FALSE):

v = c(25, 9, 16, 4)

v > 10

# any() returns TRUE if any of the logicals are TRUE:

any(v > 10)

# all() returns TRUE if all of the logicals are TRUE:

all(v > 10)

# which() returns the indices/locations of the TRUE values (interpreted as as "Which index positions are TRUE?"):

which(v > 10)


items <- c(5,10,15,20,25,30,35,40)

# A negative value means to exclude the index position.
# Return a vector with everything except the third element:

items[-3]

# Create the vector "v":

v = c(25, 9, 16, 4)

# Test whether a value in the vector v is either less than 5 or (|) greater than 20:
(v < 5) | (v > 20)

nums  <- c(1:10)
nums[(nums < 4 | nums > 8)]

# The unique() function will display the unique values within a column:
unique(df$sex)

# Another way that we can import data is by using read.table(). 
# This reads a file in table format and creates a data frame from it. We can set its sep parameter to indicate how the data is separated (e.g., sep="," for comma separated values). 
# Setting the header parameter to TRUE indicates that the first row contains the names of the columns.

age <- 25

if(age < 50) {
  print(paste("Pascal is", age))
}

name ="Pascal"
password = "denim105"

if(name == "Pascal") {
  if (password == "denim105"){
    cat("welcome", name, "!")
  }
    
}
# Using the vector's index:

vec = c(5,10,15,20)

for(i in 1:length(vec)) {
  cat("Item at index", i, "is", vec[i], "\n")  # "\n" is the new-line character. Try delete it to see what it does.
}

vec = c(5,10,15,20)

# An alternative to the above is to use the function seq_along() which returns the index of each item in the vector:
for(i in seq_along(vec)){
  cat("Item at index", i, "is", vec[i], "\n")
}


# Create a vector with the following numbers: 63, 81, 72, 56, 92, 75.
# Loop through each number in the vector.
# If the number is less than 75 print "Fail". If the number is 75 or greater print "Pass".


greeting <- function(word, num_times) {
  for(i in 1:num_times) {
    print(word)
  }
}

greeting("Howdy!", 5)


odd_or_even <- function(numbers, para) {
  if (para == 0) {
    print(numbers[numbers %% 2 == 0])
  }
  else if (para == 1) {
    print (numbers[numbers %% 2 != 0])
  }
}

dan <- c(1:10)
odd_or_even(dan, 0)
odd_or_even(dan, 1)


greetings <- function(words) {
  for (word in words) {
    if(word == "Bye"){
      return("Bye")
    } else {
      print(word)
    }
  }
}

greetings( c("Hello", "Howdy", "Hi", "Hola") )

greetings( c("Hello", "Bye", "Howdy", "Hi", "Hola") )

#sapply()
#We can apply a function to each element in a vector by using the sapply() function.

#For example, we will define a square_num() function to square the values passed to it:
  
  square_num <- function(x){
    return(x^2)
  }
  sapply(c(2,4,6,8), FUN = square_num)  
  apply()
  
  #We can also apply a function to a matrix by using the apply() function. 
  #Since a matrix is two dimensional, there's an additional required parameter called MARGIN which indicates whether you would like for the function to be applied over the rows (indicated by a 1) or over the columns (indicated by a 2). 
  
  # Create a matrix:
  
  mat <- matrix(1:12, 6, 2)
  mat
  apply(mat, MARGIN=2, FUN=mean)

  v <- c(1, 2, 3, 4, 5)  

  v[c(2,4)]  
v[-2:-4]  
v[2,4]
