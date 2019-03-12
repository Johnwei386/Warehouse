#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Status.h"
#define Max_Record_Num 8

typedef struct lineNode{
	int index;
	char *pro;
	int gen;
	char *sch;
	int sco;
}lineNode;

typedef struct scoreTable{
	int total;
	int cur_num;
	lineNode *node[Max_Record_Num];
}scoreTable;

Status main(void)
{
	char* is_out = (char*)malloc(sizeof(char)*255);
	scoreTable *ST = (scoreTable*)malloc(sizeof(scoreTable));
	ST->total = Max_Record_Num;
	ST->cur_num = 0;
	for(int i = 0; i < Max_Record_Num; i++)
	{
		printf("Do you have any data to enter? yes to confirm or no to deny.\n");
		scanf("%s", is_out);
		if(!strcmp(is_out, "no"))
		{
			printf("out off the loop of record\n");
			break;
		}
		ST->node[i] = (lineNode*)malloc(sizeof(lineNode));
		ST->node[i]->pro = (char*)malloc(sizeof(char)*255);
		ST->node[i]->sch = (char*)malloc(sizeof(char)*255);
		printf("please enter a record, the format is i pro gen sch sco");
		scanf("%d %s %d %s %d", &(ST->node[i]->index), ST->node[i]->pro, \
				&(ST->node[i]->gen), ST->node[i]->sch, &(ST->node[i]->sco));	
		(ST->cur_num)++;	
	}

	return OK;
}
