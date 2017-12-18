# 统计学R作业，数据分析代码示例=
# 数据集使用R内置的AirPassengers
# 该数据集记录了1949-1960年每个月国际航空的乘客数量，单位为千人次

# 1. 箱型图分析
png(file = 'BoxPlotAnalysis.png')
boxplot(AirPassengers~cycle(AirPassengers), xlab = "月份",
   ylab = "乘客数(单位：千人)")
dev.off()

# 2.时间序列分析
# 对每年的月乘客数取均值
# 按均值生成一张按年分布的乘客数量变化趋势图
getMeanOfPassengers <- function(){
	meanList = NULL
	for(i in 1949:1960){
		tsPerYear <- window(AirPassengers, c(i, 1), c(i, 12))
		meanPerYear <- mean(tsPerYear)
		meanList <- c(meanList, meanPerYear)
	}
	return(meanList)
}
meanSeq <- getMeanOfPassengers()
meanTimeseries <- ts(meanSeq, 1949, 1960, 1)
png(file = 'meanPassenger.png')
plot(meanTimeseries, main="1949-1960间国际航空的乘客数量平滑趋势图",  xlab="年份",  ylab="乘客数(单位：千人)")
dev.off()

png(file = 'Passenger.png')
plot(AirPassengers, main="1949-1960间国际航空的乘客数量变化图",  xlab="年份",  ylab="乘客数(单位：千人)")
abline(reg=lm(AirPassengers~time(AirPassengers))) # 按时间序列添加一条拟合直线
dev.off()

# 3.一元线性回归分析和预测
# 从AirPassengers数据集中选出1960年的数据作为Y
# 附加一个数据集x，x表示当月的平均机票价格
# 对Y与x的关系进行一元线性回归分析
# 当x取特定值时，用这个分析模型来预测Y
Y <- window(AirPassengers, c(1960, 1), c(1960, 12))
Y <- unlist(Y)
x <- c(250,220,230,298,300,200,198,190,240,230,256,247)
relation <- lm(Y~x)
png(file = 'linearregression.png')
plot(x,Y, abline(lm(Y~x)), xlab = "平均票价", ylab = "乘客数(单位：千人)")
dev.off() # 生成散点图
# 得到回归分析摘要信息
print(summary(relation))
reSquareSum <- deviance(relation)
print(reSquareSum) # 得到残差的平方和
# 残差分析，残差是必须服从正态分布N(0,o^2)的，对其进行正态分布检验
y.res <- residuals(relation)
shapiro.test(y.res) # 正态分布检测
png(file = 'residualsDistribute.png')
plot(y.res) # 残差散点图
dev.off()
png(file = 'residualsAnalysis.png')
par(mfrow = c(2, 2), mar = c(2.5, 2.5, 1.5, 1.2), mgp = c(1.2, 0.2, 0))
plot(relation) # 四副残差分析图
dev.off()
# 用得到的回归模型进行预测，当票价是180时，乘客数是多少？
new <- data.frame(x=180)
result <- predict(relation, new)
print(result)
