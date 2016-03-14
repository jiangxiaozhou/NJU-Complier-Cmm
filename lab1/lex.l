%{
    #include "syntax.tab.h"
    #include "TreeNode.h"
	extern int hasError;
%}
letter [_a-zA-Z]
digit1 [0-9]
digit2 [1-9]
digit3 [0-7]
digit4 [1-7]
digit5 [0-9a-fA-F]
digit6 [1-9a-fA-F]
delim [ \n\t\r]
ws {delim}+
id {letter}({letter}|{digit1})*
tenBaseNumber ({digit2}{digit1}*)|0
eightBaseNumber 0{digit4}{digit3}*
hexNumber 0x{digit6}{digit5}*
%option yylineno

%%
{ws} { }
if {yylval.node = newNode("IF", NULL); return IF;}
else {yylval.node = newNode("ELSE", NULL); return ELSE;}
int {yylval.node = newNode("TYPE", "int"); return TYPE;}
float {yylval.node = newNode("TYPE", "float"); return TYPE;}
return {yylval.node = newNode("RETURN", NULL); return RETURN;}
while {yylval.node = newNode("WHILE", NULL); return WHILE;}
struct {yylval.node = newNode("STRUCT", NULL); return STRUCT;}
{tenBaseNumber} { yylval.node = newNode("INT", yytext); return INT; }
{eightBaseNumber} { yylval.node = newNode("INT", yytext); return INT;}
{hexNumber} { yylval.node = newNode("INT", yytext); return INT;}
{id} {yylval.node = newNode("ID",yytext); return ID;}
"+"  {yylval.node = newNode("PLUS",NULL);return PLUS;}
"-"  {yylval.node = newNode("MINUS",NULL);return MINUS;}
"*"  {yylval.node = newNode("STAR",NULL);return STAR;}
"/"  {yylval.node = newNode("DIV",NULL);return DIV;}
"&&" {yylval.node = newNode("AND",NULL);return AND;}
"||" {yylval.node = newNode("OR",NULL);return OR;}
"="  {yylval.node = newNode("ASSIGNOP",NULL);return ASSIGNOP;}
"<"  {yylval.node = newNode("RELOP",yytext);return RELOP;}
">"  {yylval.node = newNode("RELOP",yytext);return RELOP;}
"==" {yylval.node = newNode("RELOP",yytext);return RELOP;}
"!=" {yylval.node = newNode("RELOP",yytext);return RELOP;}
"<=" {yylval.node = newNode("RELOP",yytext);return RELOP;}
">=" {yylval.node = newNode("RELOP",yytext);return RELOP;}
"("  {yylval.node = newNode("LP",NULL);return LP;}
")"  {yylval.node = newNode("RP",NULL);return RP;}
"["  {yylval.node = newNode("LB",NULL);return LB;}
"]"  {yylval.node = newNode("RB",NULL);return RB;}
"{"  {yylval.node = newNode("LC",NULL);return LC;}
"}"  {yylval.node = newNode("RC",NULL);return RC;}
"."  {yylval.node = newNode("DOT",NULL);return DOT;}
","  {yylval.node = newNode("COMMA",NULL);return COMMA;}
";"  {yylval.node = newNode("SEMI",NULL);return SEMI;}
.    { 
	hasError = 1;
	printf("Error type A at line %d: Mysterious characters \'%s\'",
		yylineno, yytext);
}

%%

