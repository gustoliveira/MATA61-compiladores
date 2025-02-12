%{
#include <stdio.h>
#include <string.h>
#include "node.h"  
#include "parser.tab.h"
%}


%%

[0-9]+      { yylval.num= strdup(yytext); return NUM; }
"int"        { return INT; }
"string"     { return STRING; }
"void"       { return VOID; }
"return"     { return RETURN; }
"if"         { return IF; }
"else"       { return ELSE; }
"for"        { return FOR; }
"while"      { return WHILE; }
"public"     { return PUBLIC; }
"private"    { return PRIVATE; }
"static"     { return STATIC; }
"Program"    {  return PROGRAM; }
"class"      {  return CLASS; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.id = strdup(yytext); return ID; }
"("          { return ABRE_PARENTESES; }
")"          { return FECHA_PARENTESES; }
"{"          {  return ABRE_CHAVES; }
"}"          { return FECHA_CHAVES; }
"="          { return IGUAL; }
"=="         { return IGUAL_IGUAL; }
"+"          { return MAIS; }
"-"          { return MENOS; }
"*"          { return MULTIPLICACAO; }
"/"          { return DIVISAO; }
";"          { return PONTO_VIRGULA; }
","          { return VIRGULA; }
"."          { return PONTO; }
"["          { return ABRE_COLCHETES; }
"]"          { return FECHA_COLCHETES; }

\"[^\"]*\" { yylval.str = strdup(yytext); return LITERAL_STRING; }

[ \t\n]+    { /* Ignora espaços em branco */ }
.           { printf("Caractere desconhecido: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}
