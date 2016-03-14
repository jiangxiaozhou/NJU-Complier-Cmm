%{
	#include "TreeNode.h"
	#include "lex.yy.c"
	TreeNode* root;
	int hasError = 0;
%}
%union {
	TreeNode* node;
}

%token<node> INT FLOAT ID TYPE
%token<node> SEMI COMMA ASSIGNOP RELOP
%token<node> PLUS MINUS DIV STAR
%token<node> AND OR DOT NOT
%token<node> STRUCT RETURN IF ELSE WHILE
%token<node> LP RP LB RB LC RC 

%right ASSIGNOP NOT
%left PLUS MINUS DIV DOT STAR
%left LP RP LB RB RELOP AND OR
%nonassoc ELSE WHILE RETURN STRUCT 
%nonassoc LOWER_THAN_ELSE

%type <node> Program ExtDefList ExtDef Args ExtDecList
%type <node> Specifier FunDec CompSt Def Dec DefList
%type <node> VarDec StructSpecifier OptTag Tag DecList
%type <node> ParamDec VarList StmtList Stmt Exp

%%
Program : ExtDefList {
//		printf("haha\n");
		$$ = newNode("Program", NULL);
		insertChild(1,$$,$1);
		root = $$;
		}
		;

ExtDefList : ExtDef ExtDefList {
		   $$ = newNode("ExtDefList", NULL);
		   insertChild(2,$$,$1,$2);
		   }
		   | { //$$ = newNode("ExtDefList", NULL); 
		   $$ = NULL;
		   } 
		   ;

ExtDef : Specifier ExtDecList SEMI {
	   $$ = newNode("ExtDef", NULL);
	   insertChild(3,$$,$1,$2,$3);
	   }
     | Specifier SEMI {
	 $$ = newNode("ExtDef", NULL); 
	 insertChild(2,$$,$1,$2);
	 }
	 | Specifier FunDec CompSt {
	 $$ = newNode("ExtDef", NULL);
     insertChild(3,$$,$1,$2,$3);
	 }
	 ;

ExtDecList : VarDec {
		   $$ = newNode("ExtDecList", NULL);
		   insertChild(1,$$,$1);
		   }
     | VarDec COMMA ExtDecList {
	 $$ = newNode("ExtDecList", NULL);
	 insertChild(3,$$,$1,$2,$3);
	 }
	 ;

Specifier : TYPE {
		  $$ = newNode("Specifier", NULL);
		  insertChild(1,$$,$1);
		  }
		  | StructSpecifier {
		  $$ = newNode("Specifier", NULL);
		  insertChild(1,$$,$1);
		  }
		  ;

StructSpecifier : STRUCT OptTag LC DefList RC {
				$$ = newNode("StructSpecifier", NULL);
				insertChild(5,$$,$1,$2,$3,$4,$5);
				}
				| STRUCT Tag {
				$$ = newNode("StructSpecifier", NULL);
				insertChild(2,$$,$1,$2);
				}
				;

OptTag : ID {
	   $$ = newNode("OptTag", NULL);
	   insertChild(1,$$,$1);
	   }
	| { //$$ = newNode("OptTag", NULL);
	$$ = NULL;
	}
	;

Tag : ID {
	$$ = newNode("Tag", NULL);
	insertChild(1,$$,$1);
	}
	;

VarDec : ID {
	   $$ = newNode("VarDec", NULL);
	   insertChild(1,$$,$1);
	   }
	| VarDec LB INT RB {
	$$ = newNode("VarDec", NULL);
	insertChild(4,$$,$1,$2,$3,$4);
	}
	;

FunDec : ID LP VarList RP {
	   $$ = newNode("FunDec", NULL);
	   insertChild(4,$$,$1,$2,$3,$4);
	   }
	   | ID LP RP {
	   $$ = newNode("FunDec", NULL);
	   insertChild(3,$$,$1,$2,$3);
	   }
	   ;

VarList : ParamDec COMMA VarList {
		$$ = newNode("VarList", NULL);
		insertChild(3,$$,$1,$2,$3);
		}
		| ParamDec {
		$$ = newNode("VarList", NULL);
		insertChild(1,$$,$1);
		}
		;

ParamDec : Specifier VarDec {
		 $$ = newNode("ParamDec", NULL);
		 insertChild(2,$$,$1,$2);
		 }
		 ;

CompSt : LC DefList StmtList RC {
	   $$ = newNode("CompSt", NULL);
	   insertChild(4,$$,$1,$2,$3,$4);
	   }
	   ;

StmtList : Stmt StmtList {
		 $$ = newNode("StmtList", NULL);
		 insertChild(2,$$,$1,$2);
		 }
		 | { //$$ = newNode("StmtList", NULL); 
		 $$ = NULL;
		 }
		 ;

Stmt : Exp SEMI {
	 $$ = newNode("Stmt", NULL);
	 insertChild(2,$$,$1,$2);
	 }
     | CompSt {
	 $$ = newNode("Stmt", NULL);
	 insertChild(1,$$,$1);
	 }
     | RETURN Exp SEMI {
	 $$ = newNode("Stmt", NULL);
	 insertChild(3,$$,$1,$2,$3);
	 }
     | IF LP Exp RP Stmt {
	 $$ = newNode("Stmt", NULL);
	 insertChild(5,$$,$1,$2,$3,$4,$5);
	 }
     | IF LP Exp RP Stmt ELSE Stmt {
	 $$ = newNode("Stmt", NULL);
	 insertChild(7,$$,$1,$2,$3,$4,$5,$6,$7);
	 }
     | WHILE LP Exp RP Stmt {
	 $$ = newNode("Stmt", NULL);
	 insertChild(5,$$,$1,$2,$3,$4,$5);
	 }
	 ;

DefList : Def DefList {
		$$ = newNode("DefList", NULL);
	    insertChild(2,$$,$1,$2);
		}
		| { //$$ = newNode("DefList", NULL); 
		$$ = NULL;
		}
		;

Def : Specifier DecList SEMI {
	$$ = newNode("Def", NULL);
	insertChild(3,$$,$1,$2,$3);
	}
	;

DecList : Dec {
		$$ = newNode("DecList", NULL);
	    insertChild(1,$$,$1);
		}
		| Dec COMMA DecList {
		$$ = newNode("DecList", NULL);
	    insertChild(3,$$,$1,$2,$3);
		}
		;

Dec : VarDec {
	$$ = newNode("Dec", NULL);
	insertChild(1,$$,$1);
	}
	| VarDec ASSIGNOP Exp {
	$$ = newNode("Dec", NULL);
	insertChild(3,$$,$1,$2,$3);
	}
	;

Exp : Exp ASSIGNOP Exp {
	$$ = newNode("Exp", NULL);
	insertChild(3,$$,$1,$2,$3);
	}
	| Exp AND Exp {	
	$$ = newNode("Exp", NULL);
	insertChild(3,$$,$1,$2,$3);
	}
	| Exp OR Exp {
	$$ = newNode("Exp", NULL);
	insertChild(3,$$,$1,$2,$3);
	}
	| Exp RELOP Exp {
	$$ = newNode("Exp", NULL);
	insertChild(3,$$,$1,$2,$3);
	}
    | Exp PLUS Exp {
	$$ = newNode("Exp", NULL);
	insertChild(3,$$,$1,$2,$3);
	}
    | Exp MINUS Exp {
	$$ = newNode("Exp", NULL);
	insertChild(3,$$,$1,$2,$3);
	}
    | Exp STAR Exp {
	$$ = newNode("Exp", NULL);
	insertChild(3,$$,$1,$2,$3);
	}
    | Exp DIV Exp {
	$$ = newNode("Exp", NULL);
	insertChild(3,$$,$1,$2,$3);
	}
    | LP Exp RP {
	$$ = newNode("Exp", NULL);
	insertChild(3,$$,$1,$2,$3);
	}
    | MINUS Exp {
	$$ = newNode("Exp", NULL);
	insertChild(2,$$,$1,$2);
	}
    | NOT Exp {
	$$ = newNode("Exp", NULL);
	insertChild(2,$$,$1,$2);
	}
    | ID LP Args RP {
	$$ = newNode("Exp", NULL);
	insertChild(4,$$,$1,$2,$3,$4);
	}
    | ID LP RP {
	$$ = newNode("Exp", NULL);
	insertChild(3,$$,$1,$2,$3);
	}
    | Exp LB Exp RB {
	$$ = newNode("Exp", NULL);
	insertChild(4,$$,$1,$2,$3,$4);
	}
    | Exp DOT ID {
	$$ = newNode("Exp", NULL);
	insertChild(3,$$,$1,$2,$3);
	}
    | ID {
	$$ = newNode("Exp", NULL);
	insertChild(1,$$,$1);
	}
    | INT {
	$$ = newNode("Exp", NULL);
	insertChild(1,$$,$1);
	}
    | FLOAT {
	$$ = newNode("Exp", NULL);
	insertChild(1,$$,$1);
	}
	;

Args : Exp COMMA Args {
	 $$ = newNode("Args", NULL);
	 insertChild(3,$$,$1,$2,$3);
	 }
	 | Exp {
	 $$ = newNode("Exp", NULL);
	 insertChild(1,$$,$1);
	 }
	 ;


%%


int main(int argc, char** argv) {
	if (argc <= 1) return 1;
	FILE *f = fopen(argv[1], "r");
	if (!f) {
		perror(argv[1]);
		return 1;
	}
	root = NULL;
	yylineno = 1;
	yyrestart(f);
	yyparse();
	if (!hasError) 
		printTree(root, 0);
	return 0;
}

yyerror(char* msg) {
	printf("Error type B at line %d: %s\n", yylineno, msg);
}
