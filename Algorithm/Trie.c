#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TREE_WIDTH 256
#define WORDLENMAX 128

/***********************************************
* Trie: 前缀树
* 利用Trie树实现词频统计
*************************************/

struct trie_node_st {
    int count;
    // add a count for the part-include,
    // for example 'this is' then the 'is' is hited two times
    int pass;  
    struct trie_node_st *next[TREE_WIDTH];
};

static struct trie_node_st root={0, 0, {NULL}};

static const char *spaces=" \t\n/.\"\'()";

void myfree(struct trie_node_st *rt)
{ // 释放Trie树
    for(int i=0; i<TREE_WIDTH; i++){
	    if(rt->next[i] != NULL){
		    myfree(rt->next[i]);
		    rt->next[i] = NULL;
	    }
    }

    free(rt);
	return;
}

static int insert(const char *word)
{
    int i;
    struct trie_node_st *curr, *newnode;

    if (word[0] == '\0'){
        return 0;
    }

    curr = &root;
    for (i=0; ; ++i) {
        if (word[i] == '\0') {
            break;
        }

        curr->pass++; //count

        if (curr->next[ word[i] ] == NULL) {
            newnode = (struct trie_node_st*)malloc(sizeof(struct trie_node_st));
            memset(newnode, 0, sizeof(struct trie_node_st));
            curr->next[ word[i] ] = newnode;
        } 
        curr = curr->next[ word[i] ];
    }

    curr->count ++;
    return 0;
}

static void printword(const char *str, int n)
{
    printf("%s\t%d\n", str, n);
}

static int do_travel(struct trie_node_st *rootp)
{
    static char worddump[WORDLENMAX+1];
    static int pos=0;
    int i;

    if (rootp == NULL) {
        return 0;
    }

    if (rootp->count) {
        worddump[pos]='\0';
        printword(worddump, rootp->count+rootp->pass);
    }

    for (i=0;i<TREE_WIDTH;++i) {
        worddump[pos++]=i;
        do_travel(rootp->next[i]);
        pos--;
    }

    return 0;
}

int main(void)
{
    char *linebuf=NULL, *line, *word;
    size_t bufsize=0;
    int ret;

    while (1) {
        ret = getline(&linebuf, &bufsize, stdin);
        if (ret == -1) {
            break;
        }

        line = linebuf;
        while (1) {
            word = strsep(&line, spaces);
            if (word == NULL) {
                break;
            }

            if (word[0] == '\0') {
                continue;
            }

            insert(word);
        }
    }

    do_travel(&root);

    free(linebuf);

	for(int i=0; i<TREE_WIDTH; i++){
		if(root.next[i] != NULL){
			myfree(root.next[i]);
		}
	}

    exit(0);
}
