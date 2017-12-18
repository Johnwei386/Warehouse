# R创建箱型图
# boxplot(x, data, notch, varwidth, names, main)
# x是向量或公式，它用来筛选数据帧到不同的值
# data是数据帧。
# notch是逻辑值。 设置为TRUE以绘制凹口。
# varwidth是一个逻辑值。 设置为true以绘制与样本大小成比例的框的宽度。
# names是将打印在每个箱线图下的组标签。
# main用于给图表标题。 

#input <- mtcars[,c('mpg', 'cyl')] # 指定列提取内置数据集mtcars
#print(head(input))

# 创建箱型图
png(file = "boxplot.png")
# ~左边的变量是因变量，右边的变量是自变量，代表一个公式的描述
# 这里表示按cyl来筛选mpg的值，相同的cyl值下的mpg项用来做箱型图
boxplot(mpg ~ cyl, data = mtcars, xlab = "Number of Cylinders",
   ylab = "Miles Per Gallon", main = "Mileage Data")
dev.off()
