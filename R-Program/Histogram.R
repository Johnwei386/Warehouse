# R创建直方图
# hist(v,main,xlab,xlim,ylim,breaks,col,border)
# v是包含直方图中使用的数值的向量。
# main表示图表的标题。
# col用于设置条的颜色。
# border用于设置每个条的边框颜色。
# xlab用于给出x轴的描述。
# xlim用于指定x轴上的值的范围。
# ylim用于指定y轴上的值的范围。
# break用于提及每个条的宽度。 
v <- c(9,13,21,8,36,22,12,41,31,33,19)
png(file = 'histogram.png')
hist(v, xlab = "Weight", col = "yellow", border = 'blue')
dev.off()

# R创建折线图
# plot(v,type,col,xlab,ylab)
# v是包含数值的向量。
# type采用值“p”仅绘制点，“l”仅绘制线和“o”绘制点和线。
# xlab是x轴的标签。
# ylab是y轴的标签。
# main是图表的标题。
# col用于给点和线的颜色。 
v <- c(7, 12, 28, 3, 41)
t <- c(14, 7, 6, 19, 21)
png(file = 'line_chart.png')
plot(v,type = "o", col = "0x303030", xlab = "Month", ylab = "Rain fall",
   main = "Rain fall chart")
lines(t, type = "o", col = "red") # 画第二条线
dev.off()

# R创建散点图
# plot(x, y, main, xlab, ylab, xlim, ylim, axes)
# x是其值为水平坐标的数据集。
# y是其值是垂直坐标的数据集。
# main要是图形的图块。
# xlab是水平轴上的标签。
# ylab是垂直轴上的标签。
# xlim是用于绘图的x的值的极限。
# ylim是用于绘图的y的值的极限。
# axes指示是否应在绘图上绘制两个轴。 
input <- mtcars[,c('wt','mpg')]
png(file = "scatterplot.png")
plot(x = input$wt,y = input$mpg,
   xlab = "Weight",
   ylab = "Milage",
   xlim = c(2.5,5),
   ylim = c(15,30),		 
   main = "Weight vs Milage"
)
dev.off()

# R绘制散点图矩阵
# pairs(formula, data)
# formula表示成对使用的一系列变量。
# data表示将从其获取变量的数据集。 
png(file = "scatterplot_matrices.png")
pairs(~wt+mpg+disp+cyl,data = mtcars,
   main = "Scatterplot Matrix")
dev.off()
