#include<stdio.h>

#define hash_hash # ## #
#define mkstr(a) # a
#define in_between(a) mkstr(a)
#define join(c,d) in_between(c hash_hash d)

/*
* 我们使用#把宏参数变为一个字符串,用##把两个宏参数贴合在一起. 
* 构串操作符#只能修饰带参数的宏的形参，它将实参的字符序列（而非实参所代表的值）转换成字符串常量。
* 合并操作符##将出现在其左右的字符序列合并成一个新的标识符（注意！不是字符串）。
*/
int main()
{
 char p[]=mkstr(x);
 printf("%s\n",p);
 printf("%s\n",join(n,f));
 return 0;
}
