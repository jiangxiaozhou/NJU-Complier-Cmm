play:
	flex lex.l
	bison -d syntax.y
	gcc -g TreeNode.c syntax.tab.c -lfl -ly -o parser

run:
	./parser sample 
