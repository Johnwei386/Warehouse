# R中创建条形图的基本语法是
# barplot(H, xlab, ylab, main, names.arg, col)
# H是包含在条形图中使用的数值的向量或矩阵。
# xlab是x轴的标签。
# ylab是y轴的标签。
# main是条形图的标题。
# names.arg是在每个条下出现的名称的向量。
# col用于向图中的条形提供颜色，默认为灰色。
### 创建条形图
H <- c(7, 12, 28, 3, 41) # 基本数据集
M <- c('Mar', 'Apr', 'May', 'Jun', 'Jul')
png(file = "barchart.png") # 生成图表的名称
barplot(H,names.arg = M,xlab = "Month",ylab = "Revenue",col = "blue",
main = "Revenue chart",border = "red")
dev.off() # 保存文件

### 创建组合的条形图
colors <- c('green', 'orange', 'brown')
months <- c('Mar', 'Apr', 'May', 'Jun', 'Jul')
regions <- c('East', 'West', 'North')

### 创建赋值矩阵
Values <- matrix(c(2,9,3,11,9,4,8,7,3,12,5,2,8,10,11), nrow = 3, ncol = 5, byrow = TRUE)
png(file = "barchart_stacked.png")
barplot(Values,main = "total revenue",names.arg = months,xlab = "month",ylab = "revenue",col = colors)
legend("topleft", regions, cex = 1.3, fill = colors) # 不同的颜色块标示
dev.off()
