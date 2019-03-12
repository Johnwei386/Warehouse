#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#define RAII_VARIABLE(vartype,varname,initval,dtor) \
 void _dtor_## varname(vartype *v){dtor(*v);}\
 vartype varname __attribute__((cleanup(_dtor_## varname))) = (initval)

/*
* 使用RAII扩展宏实现资源获取即初始化，这种技术保证资源的初始化和后续的释放
* 这样，分配的资源最终总会得到释放。
* __attribute__((属性)) 为函数、变量、结构指定属性
* vartype varname __attribute__((cleanup(_dtor_## varname))) = (initval)这为每一个
* 创建char*变量的表达式指定一个释放内存的表达式
* 宏定义函数:
* #define MALLOC（n, type） \
*（ (type *) malloc（（n）* sizeof（type）））这个函数将参数类型传递给宏函数
* 并分配内存，
*/
int main()
{
 RAII_VARIABLE(char*,name,(char*)malloc(32),free);
 strcpy(name,"RAII Example");
 printf("%s\n",name);
}
