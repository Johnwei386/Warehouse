#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*******************************************************************************
* 给定一个字符串,找出不含有重复字符的最长子串的长度
* 输入: abcabcbb
* 输出: 3
****************************************************************/

int lenOfSubstring(char *s)
{
    int lenstr = strlen(s);
    if(lenstr <= 1) return lenstr;
    int start = 0, length_max = 0, length = 0, j = 0;
    int mark[256];
    for(int i = 0; i < 256; i++) mark[i] = -1;
    for(; j < lenstr; j++) {
            if(mark[s[j]] != -1 && mark[s[j]] >= start) 
            {
                length_max = length_max > j - start ? length_max : j - start;
                start = mark[s[j]] + 1;
            }
            mark[s[j]] = j;
        }
        length_max = length_max > lenstr - start ? length_max : lenstr - start;
    return length_max;
}

int main(void)
{
    int maxsublen = 0;
    char *s = (char*)malloc(sizeof(char) * 256);
    scanf("%s", s);
    maxsublen = lenOfSubstring(s);
    printf("%d", maxsublen);   

    return 0;
}
