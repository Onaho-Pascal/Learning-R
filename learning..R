tinytex::install_tinytex()

a <- 3
b <- "gene"
c <- FALSE
print(a + c)
print(1 + TRUE)

pharmacology_scoreline <- c("uche"=89, "chimsom"=74, "pascal"=86, "fafa"=80, "oge"=81)
pharmacology_scoreline
?(relevel)
?(class)
test <- factor(c('a','C','d','b',1,'!'))
levels(test)

score = 50
print(score)
ls()
x = 1:20
x
#attr(x, "game") = 11
#print(x)
methods("mean")

#The Poisson distribution is a good model for rare events such as mutations. 
dpois(x = 3, lambda = 5)
dpois(0:12, 5)
barplot(dpois(x = 0:12, lambda = 5), names.arg = 0:12, col = "red")
