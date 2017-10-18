#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
   int count = 0;
   pid_t pid;
   pid = fork();
   if(pid < 0){
      printf("执行fork时出错！退出\n");
      exit(-1);
   }

   if(pid == 0)
	printf("我是子进程！,count: %d, pid: %d\n", count, getpid());
   else
	printf("我是父进程!, count: %d, pid: %d\n", ++count, getpid());

   return 0;
}
