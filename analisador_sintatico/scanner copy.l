%{
#include <stdio.h>
#include <string.h>
#include "parser.tab.h"

#define MAX_SIMBOLOS 1000

typedef struct {
    char nome[100];
    int linha;
    int coluna;
} Simbolo;

Simbolo tabela_de_simbolos[MAX_SIMBOLOS];
int quantidade_de_simbolos = 0;

void adicionar_na_tabela_de_simbolos(char *nome, int linha, int coluna) {
    for (int i = 0; i < quantidade_de_simbolos; i++) {
        if (strcmp(tabela_de_simbolos[i].nome, nome) == 0) {
            return;
        }
    }
    strcpy(tabela_de_simbolos[quantidade_de_simbolos].nome, nome);
    tabela_de_simbolos[quantidade_de_simbolos].linha = linha;
    tabela_de_simbolos[quantidade_de_simbolos].coluna = coluna;
    quantidade_de_simbolos++;
}

int linha = 1;
int coluna = 1;

%}

%%

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
"Program"   { return PROGRAM; }

"("          { return ABRE_PARENTESES; }
")"          { return FECHA_PARENTESES; }
"{"          { return ABRE_CHAVES; }
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

[a-zA-Z_][a-zA-Z0-9_]* {
    adicionar_na_tabela_de_simbolos(yytext, linha, coluna);
    yylval.str = strdup(yytext);
    return IDENTIFICADOR;
}

[0-9]+     { yylval.num = atoi(yytext); return NUMERO; }
\"[^\"]*\" { yylval.str = strdup(yytext); return LITERAL_STRING; }

\n         { linha++; coluna = 1; }
[ \t]+     { coluna += yyleng; }
.          { printf("\nERRO LEXICO IDENTIFICADO EM linha %d: (%s)\n", linha, yytext); coluna += yyleng; }

%%

int yywrap() {
    return 1;
}
