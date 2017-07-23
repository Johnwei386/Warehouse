# include "include/MatrixGraph.h"
# include "include/Queue.h"
# define ROOT_VAL -1

/*****************************************************************************
 * Kruskal算法描述：
 * 1. 创建森林F，图G中的每一个顶点都是这个森林中的一棵树
 * 2. 创建集合S，S包含图G中所有的边(在本程序中用一个队列来代替S,并使S有序)
 * 3. 若S非空则：
      ① ：从S中移除一条最小权值的边。
      ② ：若移除的边连接两棵不同的树，则将该边添加到最小生成树上
           并将这两棵树合并为一棵树，添加到F上
****************************************************************************/

VertexType find(VertexType m, VertexType parent[])
{//在森林F(parent数组)中寻找顶点m所在树的根节点
   while(parent[m] != ROOT_VAL) m = parent[m];
   return m;
}

Boolean uni(VertexType u, VertexType v, VertexType parent[])
{//判断树u和树v是否相连，u,v分别为树的根节点，不相连则合并为一棵树并返回真
   if(u != v)
   {//u,v不相等则它们不在同一棵树上，它俩不想连
     parent[v] = u; //合并u，v两棵树为一棵树并加到森林F中
     return TRUE;
   } else{
     return FALSE;
   }
}

Status kruskal(MGraph *G)
{
   int vexnum = G->vexnum;        //获取顶点数
   int minicost = 0;              //定义最小生成树的生成代价
   VertexType parent[vexnum];     //定义森林F
   VRType power[vexnum][vexnum];  //定义权值的辅助二维数组
   LinkQueue *Q = (LinkQueue*)malloc(sizeof(LinkQueue));//定义集合S，S=队列Q
   initQueue(Q);

   //初始化每一个顶点为F中的一棵树
   for(int v = 0; v < vexnum; v++) parent[v] = ROOT_VAL;

   //初始化权值数组
   for(int i = 0; i < vexnum; i++)
   {
       for(int j = 0; j< vexnum; j++)
       {
          power[i][j] = G->arcs[i][j].adj;
       }
   }

   int a,b,u,v,min,sqVex,ne=0;
   sqVex = vexnum*vexnum; //sqVex = vexnum^2
   while(ne != sqVex)
   {//不断寻找最小边，并使最小边有序(asc)，即使S有序，通过ne来判断是否还有最小边
      min=INFINITY;
      for(int i=0; i<vexnum; i++)
      {//找到拥有最小权值的那条边
	 for(int j=0; j<vexnum; j++)
         {
	    if(power[i][j] < min)
	    {
		min = power[i][j];
		a = i;
		b = j;
            }

	    if(power[i][j] == INFINITY) ne++;
         }
      }

      if(ne != sqVex)
      {//将找到的最小边的顶点入队列
	    enQueue(Q, a);
	    enQueue(Q, b);
	    ne = 0;
      }
      power[a][b] = power[b][a] = INFINITY; //将当前已找到的最小边删除，再重新寻找最小边
   }

   while(!isQueueEmpty(Q))
   {//判断S是否非空
      a = u = deQueue(Q);
      b = v = deQueue(Q);  //从S中移除一条最小边<a, b>
      u = find(u, parent); //在F森林中找到u顶点所在的树的根节点
      v = find(v, parent);
      //printf("边<%d, %d> =%d\n", a, b, G->arcs[a][b].adj);
      if(uni(u, v, parent))
      {//这条最小边是否连接两棵树，是则合并这两棵树并输出这条边
         printf("边<%d, %d> =%d\n", a, b, G->arcs[a][b].adj);
         minicost += G->arcs[a][b].adj;
      }
    }

   free(Q);
   printf("最小生成树的生成代价: %d\n", minicost);
   return OK;
}

Status main(void)
{
   MGraph *G = (MGraph*)malloc(sizeof(MGraph));
   createGraph(G, UDN);
   kruskal(G);

   return OK;
}
