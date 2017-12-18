# R语言 基础语句
# 条件判断语句(R的决策)
x <- 30L
if(is.interger(x)){
	print("X is an integer")
}

x <- c("what","is","truth")
if("Truth" %in% x) {
   print("Truth is found the first time")
} else if ("truth" %in% x) {
   print("truth is found the second time")
} else {
   print("No truth found")
}

# switch语句
x <- switch(
   	3,
   "first",
   "second",
   "third",
   "fourth"
)
print(x)

# repeat循环
v <- c("Hello", "loop")
cnt <- 2
repeat {
	print(v)
	cnt <- cnt+1
	if(cnt > 5){
		break
	}
}

# while循环
v <- c("Hello","while loop")
cnt <- 2
while (cnt < 7) {
   print(v)
   cnt = cnt + 1
}

# for循环
v <- LETTERS[1:4] #得到A,B,C,D
for ( i in v) {
   print(i)
}

# next语句
v <- LETTERS[1:6]
for ( i in v) {   
   if (i == "D") {
      next # 同continue
   }
   print(i)
}

# R函数
# 内置函数示例
print(seq(1,32)) #创建一个从1到32的数列
print(mean(25:83)) #得到[25,26,...,82]这个数列的平均值
print(sum(41:68)) #得到序列的和值
# 用户定义的函数
function <- function(arg1, arg2=6){
	for(i in 1:arg1){
		b <- i^2
		if(i == arg2){
			next
		}
		print(b)
	}
} 
function(6)

# 连接字符串操作
a <- "Hello"
b <- 'How'
c <- "are you? "
print(paste(a,b,c))
print(paste(a,b,c, seq = '-'))
print(paste(a,b,c, seq = '', collapse = ''))
# 字符串截取
result <- substring("Extract", 5, 7)
print(result)


