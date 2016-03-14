#include <stdarg.h>
#include <assert.h>
#include "TreeNode.h"

extern int yylineno;

TreeNode* newNode(char* typeName, char* value) {
//	printf("TypeName: %s value: %s\n", typeName, value);
//	printf("yylineno: %d\n", yylineno);
	TreeNode* result = malloc(sizeof(TreeNode));
	result->row = yylineno;
	strcpy(result->typeName, typeName);
	if (value != NULL)
		strcpy(result->value, value);
	result->child = NULL;
	result->next = NULL;
	return result;
}

void insertChild(int childNum, TreeNode* father, ...) {
	int i = 0;
	va_list args;
	if (childNum == 0) return;
	va_start(args, father);
	if (father->child == NULL) {
		TreeNode* temp = va_arg(args, TreeNode*);
//		printf("%s\n", temp->typeName);
		if (temp != NULL) {
			father->child = temp;
			i++;
		}
	}
	TreeNode* p = father->child;
	if (p != NULL) {
		for (; i < childNum; i++) {
			TreeNode* temp = va_arg(args, TreeNode*);
//			printf("%s\n", temp->typeName);
			if (temp != NULL) {
				p->next = temp;
				p = p->next;
			}
		}
	}
	va_end(args);
}

void printTree(TreeNode* root, int depth) {
	if (root == NULL) return;
	TreeNode* p = root;
	int i = 0;
	for (; i < depth; i++) {
		printf("  ");
	}
	if (p->child != NULL) {
		printf("%s (%d)\n", p->typeName, p->row);
	}
	else {
		if (strcmp(p->typeName, "TYPE") == 0||
				strcmp(p->typeName, "FLOAT") == 0||
				strcmp(p->typeName, "INT") == 0||
				strcmp(p->typeName, "ID") == 0)
			printf("%s :%s\n", p->typeName, p->value);
		else
			printf("%s\n", p->typeName);
	}
	printTree(p->child, depth + 1);
	printTree(p->next, depth);
}
