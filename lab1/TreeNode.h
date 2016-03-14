#ifndef TREENODE_H
#define TREENODE_H

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
//#include "syntax.tab.h"

typedef struct treeNode {
	int row;
	//enum yytokentype type;
	char typeName[32];
	char value[32];
	struct treeNode* child;
	struct treeNode* next;
} TreeNode ;

TreeNode* newNode(char* typeName, char* value);
void insertChild(int childNum, TreeNode* father, ...);
void printTree(TreeNode* root, int depth);


#endif
