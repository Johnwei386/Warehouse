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
### 使用:号创建多元素向量
v <- 5:13
print(v)
### 使用seq创建序列，指定元素间隔
print(seq(5, 9, by = 0.4))
### 通过索引访问向量
t <- c("Sun","Mon","Tue","Wed","Thurs","Fri","Sat")
u <- t[c(2,3,6)]
print(u)
### 负数索引表示不选中这个元素
x <- t[c(-2,-5)]
print(x)
### 向量排序
v <- c(3,8,4,5,0,11,-9,304)
print(sort(v))

# List(列表)
### List数据类型的元素可以是不同的类型的数据，如向量甚至是列一个列表
list1 <- list(c(2,3,5), 3.14, sin)
print(list1)
print(class(list1))
### 命名列表元素
list_data <- list(c('Jan', 'Feb', 'Mar'), martix(c(3,9,5,1,-2,8), nrow = 2), list('green', 12, 3))
names(list_data) <- c("1st Quarter", "A_Matrix", "A Inner list")
print(list_data)
print(list_data[1]) # 通过索引访问元素
print(list_data$A_Matrix) # 通过命名访问元素
list_data[4] <- "New element" # 添加新元素到列表中
list_data[4] <- NULL # 移除最后一个元素
### 合并列表
list1 <- list(1, 2, 3)
list2 <- list('a', 'b', 'c')
merged.list <- c(list1, list2) #合并两个列表
### 将列表转化为向量
list1 <- list(1:5)
v1 <- unlist(list1)

# Matrices(矩阵)
M = matrix(c('a','b','c','d','e','f'), nrow=2, ncol=3, byrow=TRUE)
print(M)
print(class(M))
### 创建矩阵，按行排列，且为行列分配名称
rownames = c("row1", "row2", "row3", "row4")
colnames = c("col1", "col2", "col3")
P <- matrix(c(3:14), nrow = 4, byrow = TRUE, dimnames = list(rownames, colnames))
print(P)
### 通过索引来访问矩阵
print(P[1,3]) # 得到第1行第3列的值
print(P[2,]) # 访问第二行一整行
print(P[,3]) # 访问第三列一整列

# Arrays(数组)
### Array可以指定一个dim属性创建所需的维数
### 创建一个包含两个元素的数组，每个元素为一个3×3的矩阵
### 创建一个维度为(2 , 3, 4)的数组，则它创建4个矩阵，每个矩阵具有2行3列
a <- array(c('green', 'yellow'), dim = c(3,3,2))
print(a)
print(class(a))
### 使用命名来创建矩阵
vec1 <- c(5, 9, 3)
vec2 <- c(10, 11, 12, 13, 14, 15)
column.names <- c('Col1', 'Col2', 'Col3')
row.names <- c('Row1', 'Row2', 'Row3')
matrix.names <- c('Matrix1', 'Matrix2')
arr = array(c(vec1, vec2), dim = c(3,3,2), dimnames = list(row.names, column.names, matrix.names))
print(result)
### 通过索引来访问矩阵
print(arr[3,,2]) # 访问第2个矩阵的第3行一整行
print(arr[1,3,1]) # 访问第1个矩阵的第1行第3个元素
print(arr[,,2]) # 访问第2个矩阵，一整个矩阵
### 由于数组由多维构成一个矩阵，所以对数组元素的操作通过访问矩阵的元素来执行
matrix1 <- arr[,,2]
### 跨数组元素的计算apply，它有三个参数，参数2指定所使用数据集的名称，参数3是函数名
### 计算数组中所有行的和
result <- apply(arr, c(1), sum)

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
### 数据帧按列存储数据，每一列可以是不同的数据类型
BMI <- 	data.frame(
   gender = c("Male", "Male","Female"), 
   height = c(152, 171.5, 165), 
   weight = c(81,93, 78),
   Age = c(42,38,26)
)
print(BMI)
print(class(BMI))
### 得到数据帧的结构
str(BMI)
### 获取数据帧中数据的统计摘要和性质
summary(BMI)
### 使用列名称提取特定列
result <- data.frame(BMI$gender, BMI$Age)
### 只提取前两行
result <- BMI[1:2,]
### 提取3至5行且只有2到4列
result <- BMI[c(3,5), c(2,4)]
### 添加列
BMI$dept <- c('IT', 'Operations', 'HR')


