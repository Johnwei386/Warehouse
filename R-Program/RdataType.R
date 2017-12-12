# My first program in R Programming
str <- "你好，世界!"
print(str)

# R的6种原子向量数据类型，其他R对象建立在原子向量之上
# R原子向量数据类型
### Logical(逻辑布尔型数据)
v <- TRUE
print(class(v)) #打印数据类型

### Numeric(浮点型)
v <- 3.14159265359
print(class(v))

### Integer(整型)
v <- 2L
print(class(v))

### Complex(复数)
v <- 2+5i
print(class(v))

### Character(字符型)
v <- "Hello World!"
print(class(v))

### Raw(原型)
v <- charToRaw("Hello")
print(class(v))

# Vectors 向量数据类型
apple <- c('red', 'green', "yellow")
print(apple)
print(class(apple))

# List(列表)
### List数据类型的元素可以是不同的类型的数据，如向量甚至是列一个列表
list1 <- list(c(2,3,5), 3.14, sin)
print(list1)
print(class(list1))

# Matrices(矩阵)
M = matrix(c('a','b','c','d','e','f'), nrow=2, ncol=3, byrow=TRUE)
print(M)
print(class(M))

# Arrays(数组)
### Array可以指定一个dim属性创建所需的维数
### 创建一个包含两个元素的数组，每个元素为一个3×3的矩阵
a <- array(c('green', 'yellow'), dim = c(3,3,2))
print(a)
print(class(a))

# Factors(因子)
### Factors接收一个向量，对向量中的元素进行去重操作，然后将不同的元素存储为标签
### 标签总是字符
### 创建向量
apple_colors <- c('green', 'green', 'yellow', 'red', 'red', 'red', 'green')
### 创建因子
factor_apple <- factor(apple_colors)
### 打印因子
print(factor_apple)
print(class(factor_apple))
### 打印因子层级，有多少个独立元素
print(nlevels(factor_apple))

# Data Frames数据帧
### 数据帧按列存储数据，没一列可以是不同的数据类型
BMI <- 	data.frame(
   gender = c("Male", "Male","Female"), 
   height = c(152, 171.5, 165), 
   weight = c(81,93, 78),
   Age = c(42,38,26)
)
print(BMI)
print(class(BMI))



