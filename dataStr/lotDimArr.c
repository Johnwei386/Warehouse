#include<stdio.h>
#include<stdlib.h>
#include<stdarg.h> //提供函数处理变元的机制

 //动态创建一个多维数组的具体实现

typedef struct{
	char *base;//数组基地址
	int dim;//数组维度
	int *bound;//索引0-n对应数组的n-1维
	int *cons;//用来返回n-1维的大小，用来得到数组的偏移
}Array;

/*
 * 创建一个动态内存数组
 * 传入参数数目需在调用时确定，需要用到处理变元的技术
* dim:数组维度，也是变元的项数
*/
void initArr(Array *array,int dim, ...)
{
	array->bound = (int*)malloc(dim*sizeof(int)); //创建维度信息数组
	array->dim = dim;

	//获得数组的大小并初始化维度数组
	int elemtotal;//数组的大小
	va_list ap;//声明变元数组
	va_start(ap,dim);//使用前需初始化变元数组，将函数参数列表的最后一个值传给ap
	for(int i=0;i<dim;i++)
	{
		array->bound[i] = va_arg(ap,int);
		elemtotal *= array->bound[i];
	}
	va_end(ap);

	//创建数组
	array->base = (char *)malloc(elemtotal*sizeof(char));

	//初始化n-1维数组的大小
	array->cons = (int *)malloc(dim*sizeof(int));
	array->cons[dim-1] = 1;//初始化最后一位为1，用于初始化赋值
	for(int i=dim-2;i>=0;i--){
 	/*
	* 数组若为3维，则:
	* cons[1] = 1维大小
	* cons[0] = 2维×1维
 	*/
 		array->cons[i] = array->bound[i+1]*array->cons[i+1];
	}
}

/*
 * 获得数组元素的索引
*/
int locateArr(Array *arr,va_list ap)
{
	int offset=0;//保存偏移，迭代增加
	int dim = arr->dim;
	for(int i=0;i<dim;i++){
		int ind = va_arg(ap,int);//得到维度索引,从高到低
		offset += arr->cons[i]*ind;
	}
	return offset;
}

void setValue(Array *arr,char e, ...)
{
	va_list ap;
	va_start(ap,e);
	int off = locateArr(arr,ap);
	*(arr->base+off)=e;
	va_end(ap);
}

char getValue(Array *arr, ...)
{
	va_list ap;
	va_start(ap,arr);
	int off = locateArr(arr,ap);
	va_end(ap);
	return *(arr->base+off);
}

int main(void)
{
	Array *arr = (Array*)malloc(sizeof(Array));
	//创建二维数组,3行2列，数组大小为3*2=6
	initArr(arr,2,3,2);
	char a[3] = {'a','b','c'};
	for(int i=0;i<3;i++){
		for(int j=0;j<2;j++) setValue(arr,a[i],i,j);
	}
	printf("%c\n",getValue(arr,1,1));
}
