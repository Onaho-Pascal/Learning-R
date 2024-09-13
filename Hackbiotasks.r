a <- 99
print(a)
b <- "String"
print (a+b)
x <- 4i
typeof(x)

class(3L+6i)
d <- as.character(a)
print(d)
print(typeof(a))
print(typeof(d))

# paste0 is used to join 2 characters
h <- "Hello world "
j <- ' R programming'
z <- paste0(h, j)
print(z)

# vectors are created with the function "c" and "as.vector"
Pascal <- c(1,2,3,4,5)

print(Pascal)

Peniel <- c("o","p","q")
print(Peniel)


print (length(Peniel))

numbers <- 1:100
print(numbers[15])


print(runif(100)[23])

print(LETTERS[7:18])
print(length(LETTERS[7:18]))
print(seq(0, 60, 3))


# Matrix and Arrays: Matrix are two dimensional data (rows and columns), and it can be called by the function "matrix"
test <- c("Uche","Chimsom","David","Fafa","Oge", "Pascal")

students <- array(test, dim=c(3, 2))
students
students[3, 2]

#scores <- c(34, 28, 39)
onaho <- matrix(data=test, nrow = 3, ncol = 2, dim=) 
print(onaho)
# Matrix are 2-d, while arrays can be 3-d
# Making a 3-d
