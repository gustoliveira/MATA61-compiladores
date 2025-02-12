%{
#include <stdio.h>
#include <string.h>

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

"int"        { printf("<int>"); coluna += yyleng; }
"string"     { printf("<string>"); coluna += yyleng; }
"void"       { printf("<void>"); coluna += yyleng; }
"return"     { printf("<return>"); coluna += yyleng; }
"if"         { printf("<if>"); coluna += yyleng; }
"else"       { printf("<else>"); coluna += yyleng; }
"for"        { printf("<for>"); coluna += yyleng; }
"while"      { printf("<while>"); coluna += yyleng; }
"public"     { printf("<public>"); coluna += yyleng; }
"private"    { printf("<private>"); coluna += yyleng; }
"static"     { printf("<static>"); coluna += yyleng; }

"("          { printf("<(>"); coluna += yyleng; }
")"          { printf("<)>"); coluna += yyleng; }
"{"          { printf("<{>"); coluna += yyleng; }
"}"          { printf("<}>"); coluna += yyleng; }
"="          { printf("<=>"); coluna += yyleng; }
"=="         { printf("<==>"); coluna += yyleng; }
"+"          { printf("<+>"); coluna += yyleng; }
"-"          { printf("<->"); coluna += yyleng; }
"*"          { printf("<*>"); coluna += yyleng; }
"/"          { printf("</>"); coluna += yyleng; }
";"          { printf("<;>"); coluna += yyleng; }
","          { printf("<;>"); coluna += yyleng; }
"."          { printf("<.>"); coluna += yyleng; }
"["          { printf("<[>"); coluna += yyleng; }
"]"          { printf("<]>"); coluna += yyleng; }

[a-zA-Z_][a-zA-Z0-9_]* {
    adicionar_na_tabela_de_simbolos(yytext, linha, coluna);
    printf("<id,%d>", quantidade_de_simbolos); 
    coluna += yyleng;
}

[0-9]+     { printf("<num,%s>", yytext); coluna += yyleng; }
\"[^\"]*\" { printf("<string,%s>", yytext); coluna += yyleng; }

\n|\r\n|\r { linha++; coluna = 1; }
[ \t]+     { coluna += yyleng; }
.          { printf("\n ERRO LEXICO IDENTIFICADO EM linha %d coluna %d: (%s)\n", linha, coluna, yytext); coluna += yyleng; }

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *arquivo = fopen(argv[1], "r");
        if (!arquivo) {
            perror("Erro ao abrir arquivo");
            return 1;
        }
        yyin = arquivo;
    }

    yylex();

    printf("\nTabela de Simbolos:\n");
    for (int i = 0; i < quantidade_de_simbolos; i++) {
        printf("ID %d: %s\n", i+1, tabela_de_simbolos[i].nome);
    }

    return 0;
}

int yywrap() {
    return 1;
}
