# R数据帧操作
### 在数据帧中加入行和列
### 创建矢量对象
city <- c("Tampa","Seattle","Hartford","Denver")
state <- c("FL","WA","CT","CO")
zipcode <- c(33602,98104,16161,80294)

### 组合三个矢量到一个数据帧
addresses <- cbind(city,state,zipcode)
print(addresses)

### 用同样的列结构创建一个数据帧
new.address <- data.frame(
   city = c("Lowry","Charlotte"),
   state = c("CO","FL"),
   zipcode = c("80230","33949"),
   stringsAsFactors = FALSE
)
print(new.address)

### 将新生成的数据添加到原本的数据帧中
all.addresses <- rbind(addresses,new.address)
print(all.addresses)

### 合并数据帧
### 基于血压（“bp”）和体重指数（“bmi”）的值合并两个数据集。
### 两个变量的值在两个数据集中匹配的记录被组合在一起以形成单个数据帧。
library(MASS)
merged.Pima <- merge(x = Pima.te, y = Pima.tr,
   by.x = c("bp", "bmi"),
   by.y = c("bp", "bmi")
)
print(merged.Pima)
nrow(merged.Pima)
