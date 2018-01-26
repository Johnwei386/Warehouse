Test_data <- data.frame(
	year = c(
				2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 
				2011, 2012, 2013, 2014, 2015
	),
	grain = c(
				46217.5, 45263.7, 45705.8, 43069.5, 46947.0, 48402.2, 49804.2, 50160.3, 52870.9, 53082.1,
				54647.7, 57120.9, 58958.0, 60193.8, 60702.6, 62143.9
	),
	homeCons = c(
					3721, 3987, 4301, 4606, 5138, 5771, 6416, 7572, 8707, 9514, 10919,
					13134, 14699, 16190, 17778, 19308
	),
	coal = c(
				13.84, 14.72, 15.50, 18.35, 21.23, 23.65, 25.70, 27.60, 29.03, 31.15, 34.28,
				37.64, 39.45, 39.74, 38.74, 37.47
	),
	CPI = c(
				100.4, 100.7, 99.2, 101.2, 103.9, 101.8, 101.5, 104.8, 105.9, 99.3, 103.3,
				105.4, 102.6, 102.6, 102.0, 101.4
	)
)



# 生成四副子图
Time_serial <- ts(Test_data, start=2000)
# print(Time_serial)
png(file = '/tmp/test_1.png', width=400*3, height=400*3, res=72*3)
par(mfrow=c(2,2), mai=c(0.6, 0.6, 0.12, 0.1), cex=0.7)
plot(Time_serial[,2], type='o', ylab="粮食产量")
plot(Time_serial[,3], type='o', ylab="居民消费水平")
plot(Time_serial[,4], type='o', ylab="原煤产量")
plot(Time_serial[,5], type='o', ylab="CPI")
dev.off()



# 使用简单指数平滑拟合CPI变化值
# 历史数据拟合值
cpiforecast <- HoltWinters(Time_serial[,5], beta=FALSE, gamma=FALSE)
# print(cpiforecast$fitted) 

# 绘制实际观测值和由拟合值图
year <- Time_serial[,1]
pdf(file = '/tmp/test_2.pdf')
plot(Time_serial[,5], type='o', xlab="Time", ylab="CPI")
lines(year[-1], cpiforecast$fitted[,1], type='o', lty=2, col='blue')
legend(x="topleft", legend=c("observed-value","fitted-value"), lty=1:2, col=c(1,4))
dev.off()

# 预测2016年的CPI值
predata <- predict(cpiforecast)
# print(predata)



# 使用Holt指数平滑模型拟合谷物生产
# 加入趋势进行预测的Holt指数平滑模型
grainforecast <- HoltWinters(Time_serial[,2], gamma=FALSE)
# print(grainforecast)

# 生成拟合图
pdf(file='/tmp/test_3.pdf')
plot(Time_serial[,2], type='o', xlab='Years', ylab="GrainProduces")
lines(year[-1:-2], grainforecast$fitted[,1], type='o', lty=2, col='blue')
legend(x='topleft', legend=c("observed-value", "fitted-value"), lty=1:2)
dev.off()



# 使用Winter指数平滑模型拟合某饮料企业的季度生产状况
# 预测含趋势、季节和随机变化成分的Winter指数平滑模型
drinkproduce <- c(123, 132, 137, 126, 130, 138, 142, 132, 138, 141, 150, 137, 143, 147, 158, 143, 147, 153, 166, 151, 159, 163, 174, 161)
ts_serial_drink <- ts(drinkproduce, start=2010, frequency=4)
# print(ts_serial_drink)

# 确定模型系数 α、β、γ 以及模型系数a, b和s
saleforecast <- HoltWinters(ts_serial_drink)
# print(saleforecast)

# Winter模型的拟合图
pdf(file = '/tmp/test_4.pdf')
plot(ts_serial_drink, type='o', xlab='year', ylab='saleNum')
lines(saleforecast$fitted[,1], type='o', lty=2, col='blue')
legend(x='topleft', legend=c("observed-value", "fitted-value"), lty=1:2, col=c(1,4))
dev.off()



# 使用一元线性回归模型拟合谷物生产，谷物生产呈现明显的线性变化趋势
# 回归系数b_1为1260，表示时间每变动一年，粮食产量平均变动1260万吨
# 拟合一元线性回归模型
fit <- lm(grain~year, data=Test_data)
# print(summary(fit))

# 各年的预测值
predata <- predict(fit, data.frame(year = 2000:2016))
# print(predata)

# 各年的预测残差
# res1 <- residuals(fit)
res1 <- fit$residuals
# print(res)

# 各年观测值和预测值比较图
pdf(file = '/tmp/test_5.pdf')
plot(2000:2016, predata, type='o', lty=2, col='blue', xlab='year', ylab='grain-yield')
lines(Time_serial[,2], type='o', pch=19)
legend(x="topleft", legend=c("observed-value", "fitted-value"), lty=1:2, col=c(1,4))
abline(v=2015, lty=6, col="gray")
dev.off()



# 一元线性回归预测与Holt模型预测的残差比较
res2 <- residuals(grainforecast) # Holt模型预测残差
png(file = '/tmp/test_6.png', width=400*3, height=400*3, res=72*3)
plot(as.numeric(res2), ylim=c(-3000, 3000), xlab='', ylab="残差", pch=1)
points(res1, pch=2, col='red')
abline(h=0)
legend(x='topright', legend=c("Holt模型预测的残差","一元线性回归预测的残差"), pch=1:2, col=c('black','red'), cex=0.8)
dev.off()



# 居民消费水平的指数曲线预测
# 指数曲线拟合
y <- log(Time_serial[,3]) # 对居民消费指数数据作对数处理
x <- 1:16
fit2 <- lm(y~x)
# print(fit2) # 获取常量值后对其求指数形式的拟合, Y_t=b_0*exp(b_1*x)
# print(exp(8.008)) # Y_t = 3004.901exp(0.118x)

# 历史数据及2016年居民消费水平预测
predata <- exp(predict(fit2, data.frame(x=1:17)))
# print(predata)

# 各年的预测残差
predata <- exp(predict(fit2, data.frame(x=1:16)))
predata <- ts(predata, start=2000)
residuals <- Time_serial[,3]-predata
# print(residuals)

# 实际值和预测值的比较图
predata <- exp(predict(fit2, data.frame(x=1:17)))
png(file = '/tmp/test_7.png', width=400*3, height=400*3, res=72*3)
plot(2000:2016, predata, type='o', lty=2, col='blue', xlab='时间', ylab='居民消费水平')
points(Time_serial[,3], type='o', pch=19)
legend(x='topleft', legend=c("观察值","预测值"), lty=1:2)
abline(v=2015, lty=6, col='gray')
dev.off()

# 残差图
png(file = '/tmp/test_8.png', width=400*3, height=400*3, res=72*3)
plot(2000:2015, residuals, type='o', lty=2, xlab="时间", ylab="residuals")
abline(h=0)
dev.off()



# 原煤产量二阶与三阶曲线预测
# 拟合二阶曲线预测模型
y <- Time_serial[,4]
x <- 1:16
fit3 <- lm(y~x+I(x^2))
# print(fit3)

# 二阶曲线预测值
predata1 <- predict(fit3, data.frame(x=1:17))
# print(predata1)

# 二阶曲线预测值的残差
residual1 <- fit3$residuals
# print(residual1)

# 拟合三阶曲线预测模型
fit4 <- lm(y~x+I(x^2)+I(x^3))
# print(fit4)

# 三阶曲线预测值
predata2 <- predict(fit4, data.frame(x=1:17))
# print(predata2)

# 三阶曲线预测的残差
residual2 <- fit4$residuals
# print(residual2)

# 观察值和预测值曲线
png(file = '/tmp/test_9.png', width=400*3, height=400*3, res=72*3)
plot(2000:2016, predata1, type='o', lty=2, col='red', xlab='时间', ylim=c(10,45),ylab="原煤产量")
lines(2000:2016, predata2, type='o', lty=3, col='blue')
points(Time_serial[,4], type='o', pch=19)
legend(x='topleft', legend=c("观察值","二阶曲线","三阶曲线"),lty=1:3, col=c('black','red','blue'))
abline(v=2015, lty=6)
dev.off()

# 二阶曲线和三阶曲线预测残差的比较
png(file = '/tmp/test_10.png', width=400*3, height=400*3, res=72*3)
plot(residual1, ylab="预测残差",  xlab='', pch=0)
points(residual2, col='red', pch=1)
abline(h=0)
legend(x='top', legend=c("二阶曲线残差","三阶曲线残差"), pch=0:1, col=c('black','red'))
