# R绘制饼状图
# pie(x, labels, radius, main, col, clockwise)
# x是包含饼图中使用的数值的向量。
# labels用于给出切片的描述。
# radius表示饼图圆的半径（值-1和+1之间）。
# main表示图表的标题。
# col表示调色板。
# clockwise是指示片段是顺时针还是逆时针绘制的逻辑值。 

# 使用输入向量和标签来创建一个非常简单的饼图
x <- c(21, 62, 10, 53)
lables <- c("London", "New York", "Singapore", "Mumbai")
png(file = 'city.png')
pie(x, lables)
dev.off()

# 为饼图添加标题和颜色
x <- c(21, 62, 10, 53)
labels <- c("London", "New York", "Singapore", "Mumbai")
png(file = "city_title_colours.png")
pie(x, labels, main = "City pie chart", col = rainbow(length(x)))
dev.off()

# 加上百分比和图标示例
x <-  c(21, 62, 10,53)
labels <-  c("London","New York","Singapore","Mumbai")
piepercent<- round(100*x/sum(x), 1)
png(file = "city_percentage_legends.png")
pie(x, labels = piepercent, main = "City pie chart",col = rainbow(length(x)))
legend("topright", c("London","New York","Singapore","Mumbai"), cex = 0.8,
   fill = rainbow(length(x)))
dev.off()
