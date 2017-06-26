#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h> // 为了使编译的程序更准确，兼容性更好，推荐 使用这个文件上的int类型定义
#include "include/Status.h"
#define INIT_SIZE 32       // 定义哈希表的初始表长
#define FACTOR 0.7         // 定义装填因子阀值

typedef int32_t Data;
typedef int64_t KeyIndex;

typedef struct ConfLink{
    char*  key;
    Data   value;
    struct ConfLink *next;
}ConfLink;

typedef struct{
    int index;
    ConfLink *list;
}HashNode;

typedef struct{
    int                  current_size;
    int                  capcity;
    HashNode             *node_array;
}HashTable;

int getModVal(int cap)
{// 得到cap以内最大的素数
   if(cap <= 1) return ERROR;

   Boolean state;
   for(int i=cap; i >= 2; i--)
   {
      state = FALSE;
      for(int j=2; j < i; j++)
      {// 使用试除法检验i是否为素数
         if((i % j) == 0){
            state = TRUE;
            break;
         }
      }

      // 当i是素数时，返回i，此时i即为小于cap的最大的素数
      if(!state) return i;
   }

   return ERROR;
}

KeyIndex getIndex(char *s, int length)
{// 传入key，key为字符串，返回key对应的索引，使用时要控制key的大小
   int64_t val = 0; // 推荐使用长整型，但val是阶乘式增加，key的字符过多还是会是val溢出
   char* key = s;
   int modval = getModVal(length);
   if(modval == ERROR) return ERROR;
   for(val = 0; *key != '\0'; key++)
	val = *key + (length * val);
   val = val % modval;
   return val;
}

Status initHashTable(HashTable *H)
{// 为避免内存泄露，将在外部定义H并分配内存后再传进来
   H->node_array = (HashNode*)malloc(sizeof(HashNode) * INIT_SIZE);
   H->current_size = 0;
   H->capcity = INIT_SIZE;

   for(int i = 0; i < INIT_SIZE; i++)
   {
       H->node_array[i].index = i;
       H->node_array[i].list = NULL;
   }

   return OK;
}

Status put(HashTable *H, char* key, Data val)
{// 按键插入元素，若已经存在则修改
   KeyIndex i = getIndex(key, H->capcity);
   ConfLink *C = H->node_array[i].list;
   if(!C)
   {// 若C为空
      H->node_array[i].list = (ConfLink*)malloc(sizeof(ConfLink));
	// 且不可直接对key进行赋值，赋值为外面传进来的这个key，只是一个地址，由于
	// 你传的是在字符串池的字符指针，它不存在于堆栈中，还是要初始化这个key的地址，
	// 然后复制字符串指针指向的字符串
      (H->node_array[i].list)->key = (char*)malloc(strlen(key)+1);
      strcpy((H->node_array[i].list)->key, key);
      (H->node_array[i].list)->value = val;
      (H->node_array[i].list)->next = NULL;
      (H->current_size)++;
   } else{
      while(C->next)
      {// 遍历链表，查找key，若key已经存在，则修改它的值
         if(!strcmp(key, C->key))
         {// 找到key所在的位置
	    C->value = val;
	    return OK;
         }
	 C = C->next;
      }

      // 找不到key，则创建一个新的结点来保存新key
      ConfLink *N = (ConfLink*)malloc(sizeof(ConfLink));
      N->key = (char*)malloc(strlen(key)+1);
      strcpy(N->key, key);
      N->value = val;
      N->next = C->next;
      C->next = N;
   }

   return OK;
}

Data rmValue(HashTable *H, char* key)
{
   int i = getIndex(key, H->capcity);
   Data val = 0; //定义返回值
   ConfLink *Cp = H->node_array[i].list;
   ConfLink *pre = Cp; //定义Cp的上一个链节点

   if(!Cp) return ERROR; // 若C为空，则i所在数组节点尚未被使用

   if(!(Cp->next))
   {// 若C只有一个链节点，将在判断键值是否相等后决定是否删除这个node数组结点
      if(!strcmp(key, Cp->key))
      {// 键值相等才删除这个node节点，并将表的当前大小减1
         val = Cp->value;
	   free(Cp);
         (H->current_size)--;
         H->node_array[i].list = NULL; //删除这个node数组节点
         return val;
      }
   }

   if(!strcmp(key, Cp->key))
   {// 判断第一个链节点是否就是所要寻找的那个键，是则删除第一个链节点并返回其值
      H->node_array[i].list = Cp->next;
      val = Cp->value;
      free(Cp);
      return val;
   }

   Cp = Cp->next; //已确认第一个链节点不会是所要删除的那个键
   while(Cp)
   {// 冲突链上不只一个链节点,搜索这条链
      if(!strcmp(key, Cp->key))
       {// 找到了需要移除的键值
         pre->next = Cp->next; //删除这个链节点，摘链
         val = Cp->value;
         free(Cp);
         return val;
       }
      pre = pre->next;
      Cp = Cp->next;
   }

   return ERROR;
}

Status extendHashTable(HashTable *H)
{// 扩展hash表,每次扩展当前表容量的1/3
   float factor = (float)(H->current_size) / (float)(H->capcity);
   int inc_size = (int)(H->capcity / 3);
   if(factor < FACTOR)
   {
      printf("装填因子未超过70%%的预定阀值，不扩展hash表\n");
   } else{
      H->node_array = (HashNode*)realloc(H->node_array, sizeof(HashNode)*(H->capcity + inc_size));
      H->capcity = H->capcity + inc_size;
   }

   return OK;
}

int getLength(HashTable *H)
{
   int size = 0;
   int capcity = H->capcity;
   ConfLink *Cp;
   for(int i=0; i < capcity; i++)
   {
       Cp = H->node_array[i].list;
       while(Cp)
       {
          size++;
          Cp = Cp->next;
       }
   }
   return size;
}

char** getKeys(HashTable *H)
{
   int keySize = getLength(H);
   int cap = H->capcity;
   char** keys = (char**)malloc(sizeof(char*) * keySize);
   ConfLink *Cp; int index = 0;
   for(int j=0; j < cap; j++)
   {
      Cp = H->node_array[j].list;
      while(Cp)
      {
         keys[index] = (char*)malloc(strlen(Cp->key)+1);
         strcpy(keys[index], Cp->key);
         index++;
         Cp = Cp->next;
      }
   }
   return keys;
}

int* getValues(HashTable *H)
{
   int valueSize = getLength(H);
   int cap = H->capcity;
   int* values = (int*)malloc(sizeof(int) * valueSize);
   ConfLink *Cp; int index = 0;
   for(int j=0; j < cap; j++)
   {
      Cp = H->node_array[j].list;
      while(Cp)
      {
         values[index] = Cp->value;
         index++;
         Cp = Cp->next;
      }
   }
   return values;
}

Boolean hasKey(HashTable *H, char *key)
{
   int index = getIndex(key, H->capcity);
   ConfLink *Cp = H->node_array[index].list;
   while(Cp)
   {
      if(!strcmp(key, Cp->key))
	  return TRUE;
      Cp = Cp->next;
   }
   return FALSE;
}

Data getValue(HashTable *H, char *key)
{
   int index = getIndex(key, H->capcity);
   ConfLink *Cp = H->node_array[index].list;
   while(Cp)
   {
      if(!strcmp(key, Cp->key))
	   return Cp->value;
      Cp = Cp->next;
   }
   return ERROR;
}

Status main(void)
{
  HashTable *Hash = (HashTable*)malloc(sizeof(HashTable));
  initHashTable(Hash);
  put(Hash, "age", 18);
  put(Hash, "year", 2013);
  put(Hash, "numble", 201);
  int size = getLength(Hash);
  printf("所有键值的个数为:%d\n", size);

  int* vals; char** keys;
  keys = getKeys(Hash);
  vals = getValues(Hash);
  printf("打印所有的键值对:\n");
  for(int i=0; i < size; i++)
  {
     printf("%s => %d\n", keys[i], vals[i]);
  }

  if(hasKey(Hash, "age")) printf("哈希表存在键age\n");
  else printf("哈希表不存在键age\n");
  printf("键year的值为:%d\n", getValue(Hash, "year"));

  extendHashTable(Hash);
  printf("删除键 numble => %d\n", rmValue(Hash, "numble"));
  printf("键numble的值为:%d\n", getValue(Hash, "numble"));
  printf("所有键值的个数为: %d\n", getLength(Hash));
  keys = getKeys(Hash);
  vals = getValues(Hash);
  printf("打印所有的键值对:\n");
  for(int i=0; i < size; i++)
  {
     printf("%s => %d\n", keys[i], vals[i]);
  }

  return OK;
}
