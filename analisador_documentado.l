
/*
 * MATA61 - Compiladores
 * Trabalho 1 - Análise Léxica
 * Linguagem: C#
 * Autores: José Alberto Ramos de Santana, Gustavo de Oliveira Ferreira, Cláudio José Nunes Vieira Filho, Júlia Santos de Santana
 *
 * Descrição:
 * Este analisador léxico em Flex identifica os tokens de um código-fonte em C#. 
 * Ele reconhece palavras-chave, identificadores, literais, operadores e delimitadores.
 * Além disso, erros léxicos são reportados, e identificadores são adicionados a uma 
 * tabela de símbolos, com as posições (linha e coluna) sendo registradas.
 *
 * PASSOS PARA EXECUÇÃO: 
 * flex analisador.l
 * gcc lex.yy.c -o analisador
 * .\a.exe codigo_helloworld.cs # Windows
 * ./analisador codigo_helloworld.cs # Linux
 */

%{
#include <stdio.h>
#include <string.h>

// Definindo a estrutura para armazenar informações sobre os símbolos (nome, linha, coluna)
#define MAX_SIMBOLOS 1000  // Tamanho máximo da tabela de símbolos

typedef struct {
    char nome[100];   // Nome do símbolo (identificador)
    int linha;        // Linha onde o símbolo foi encontrado
    int coluna;       // Coluna onde o símbolo foi encontrado
} Simbolo;

// Definindo a tabela de símbolos e a quantidade de símbolos na tabela
Simbolo tabela_de_simbolos[MAX_SIMBOLOS];
int quantidade_de_simbolos = 0;

// Função que adiciona um símbolo à tabela de símbolos
// Ela verifica se o símbolo já existe, evitando duplicatas.
void adicionar_na_tabela_de_simbolos(char *nome, int linha, int coluna) {
    for (int i = 0; i < quantidade_de_simbolos; i++) {
        if (strcmp(tabela_de_simbolos[i].nome, nome) == 0) {
            return;  // O símbolo já existe, não será adicionado novamente
        }
    }

    // Se o símbolo não existir, ele é adicionado à tabela
    strcpy(tabela_de_simbolos[quantidade_de_simbolos].nome, nome);
    tabela_de_simbolos[quantidade_de_simbolos].linha = linha;
    tabela_de_simbolos[quantidade_de_simbolos].coluna = coluna;
    quantidade_de_simbolos++;  // Incrementa a quantidade de símbolos na tabela
}

// Variáveis para controlar a linha e a coluna durante a análise léxica
int linha = 1;
int coluna = 1;
%}

%%

/* Regras léxicas para os tokens da linguagem */

/* Palavras reservadas - as palavras-chave da linguagem, como "int", "string", "return" */
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

/* Operadores e delimitadores - os operadores matemáticos e outros delimitadores da linguagem */
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
","          { printf("<,>"); coluna += yyleng; }
"."          { printf("<.>"); coluna += yyleng; }
"["          { printf("<[>"); coluna += yyleng; }
"]"          { printf("<]>"); coluna += yyleng; }

/* Identificadores gerais (nomes de variáveis, funções, etc.) - qualquer identificador que não seja palavra reservada */
[a-zA-Z_][a-zA-Z0-9_]* {
    adicionar_na_tabela_de_simbolos(yytext, linha, coluna);  // Adiciona o identificador à tabela de símbolos
    printf("<id,%d>", quantidade_de_simbolos);  // Imprime o identificador
    coluna += yyleng;  // Atualiza a coluna
}

/* Números inteiros - reconhece números compostos apenas por dígitos */
[0-9]+     { printf("<num,%s>", yytext); coluna += yyleng; }

/* Strings entre aspas - reconhece strings delimitadas por aspas duplas */
\"[^\"]*\" { printf("<string,%s>", yytext); coluna += yyleng; }

/*
 * Nova linha - reseta a coluna e incrementa a linha
 * Considera diferentes tipos de quebra de linha: \n (linux), \r\n (windows)
 * https://stackoverflow.com/questions/1761051/difference-between-n-and-r/1761086#1761086
 */
\n|\r\n|\r { linha++; coluna = 1; }

/* Espaços em branco e tabs - apenas atualizam a coluna */
[ \t]+     { coluna += yyleng; }

/* Qualquer caractere inesperado que cause erro léxico - para caracteres inválidos */
.          { printf("\nERRO LEXICO IDENTIFICADO EM linha %d: (%s)\n",linha, yytext); coluna += yyleng; }
%%

/* Função principal - função principal do programa que chama o scanner */
int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *arquivo = fopen(argv[1], "r");  // Abre o arquivo de entrada
        if (!arquivo) {
            perror("Erro ao abrir arquivo");  // Exibe erro caso o arquivo não seja encontrado
            return 1;
        }
        yyin = arquivo;  // Atribui o arquivo de entrada ao scanner
    }

    yylex();  // Inicia a análise léxica

    // Exibe a tabela de símbolos gerada
    printf("\nTabela de Simbolos:\n");
    for (int i = 0; i < quantidade_de_simbolos; i++) {
        printf("ID %d: %s\n", i+1, tabela_de_simbolos[i].nome);
    }

    return 0;
}

/* Função que indica o fim da análise léxica */
int yywrap() {
    return 1;  // Retorna 1 quando não houver mais tokens
}
