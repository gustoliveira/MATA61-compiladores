%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "node.h"

extern FILE *yyin;

Node *root;

int yylex();
void yyerror(const char *s);
%}

%union {
    char* str;
    int num;
    Node *node;
}

%token <str> IDENTIFICADOR LITERAL_STRING
%token <num> NUMERO
%token INT STRING VOID RETURN IF ELSE FOR WHILE PUBLIC PRIVATE STATIC
%token IGUAL IGUAL_IGUAL MAIS MENOS MULTIPLICACAO DIVISAO
%token ABRE_PARENTESES FECHA_PARENTESES ABRE_CHAVES FECHA_CHAVES
%token PONTO_VIRGULA VIRGULA PONTO ABRE_COLCHETES FECHA_COLCHETES

%type <node> program statement statement_list expression attribution if_statement type declaration condition loop return_statement

%start program

%%

program:
    statement_list { root = create_node("program", 1, $1); }
    ;

statement_list:
    statement { $$ = create_node("statement_list", 1, $1); }
    | statement_list statement { $$ = create_node("statement_list", 2, $1, $2); }
    ;

statement:
    declaration { $$ = create_node("statement", 1, $1); }
    | attribution { $$ = create_node("statement", 1, $1); }
    | if_statement { $$ = create_node("statement", 1, $1); }
    | loop { $$ = create_node("statement", 1, $1); }
    | return_statement { $$ = create_node("statement", 1, $1); }
    ;

declaration:
    type IDENTIFICADOR PONTO_VIRGULA { $$ = create_node("declaration", 2, $1, create_node($2, 0)); }
    ;

type:
    INT { $$ = create_node("INT", 0); }
    | STRING { $$ = create_node("STRING", 0); }
    | VOID { $$ = create_node("VOID", 0); }
    ;

attribution:
    IDENTIFICADOR IGUAL expression PONTO_VIRGULA { $$ = create_node("attribution", 2, create_node($1, 0), $3); }
    ;

if_statement:
    IF ABRE_PARENTESES condition FECHA_PARENTESES ABRE_CHAVES statement_list FECHA_CHAVES ELSE ABRE_CHAVES statement_list FECHA_CHAVES { $$ = create_node("if_statement", 3, $3, $6, $10); }
    | IF ABRE_PARENTESES condition FECHA_PARENTESES ABRE_CHAVES statement_list FECHA_CHAVES { $$ = create_node("if_statement", 2, $3, $6); }
    ;

loop:
    WHILE ABRE_PARENTESES condition FECHA_PARENTESES ABRE_CHAVES statement_list FECHA_CHAVES { $$ = create_node("while_loop", 2, $3, $6); }
    | FOR ABRE_PARENTESES attribution condition PONTO_VIRGULA attribution FECHA_PARENTESES ABRE_CHAVES statement_list FECHA_CHAVES { $$ = create_node("for_loop", 4, $3, $4, $6, $9); }
    ;

return_statement:
    RETURN expression PONTO_VIRGULA { $$ = create_node("return", 1, $2); }
    ;

condition:
    expression IGUAL_IGUAL expression { $$ = create_node("condition", 3, $1, create_node("==", 0), $3); }
    ;

expression:
    NUMERO { 
        char buffer[20]; 
        sprintf(buffer, "%d", $1);
        $$ = create_node(buffer, 0); 
    }
    | IDENTIFICADOR { $$ = create_node($1, 0); }
    | LITERAL_STRING { $$ = create_node($1, 0); }
    | expression MAIS expression { $$ = create_node("+", 2, $1, $3); }
    | expression MENOS expression { $$ = create_node("-", 2, $1, $3); }
    | expression MULTIPLICACAO expression { $$ = create_node("*", 2, $1, $3); }
    | expression DIVISAO expression { $$ = create_node("/", 2, $1, $3); }
    ;


%%

Node *create_node(char *label, int child_count, ...) {
    Node *node = malloc(sizeof(Node));
    node->label = strdup(label);
    node->child_count = child_count;
    node->children = malloc(child_count * sizeof(Node *));

    va_list args;
    va_start(args, child_count);
    for (int i = 0; i < child_count; i++) {
        node->children[i] = va_arg(args, Node *);
    }
    va_end(args);

    return node;
}

void print_tree(Node *node, int depth) {
    if (!node) return;
    
    for (int i = 0; i < depth; i++) {
        printf("\t");
    }
    printf("%s\n", node->label);
    
    for (int i = 0; i < node->child_count; i++) {
        print_tree(node->children[i], depth + 1);
    }
}

void yyerror(const char *s) {
    fprintf(stderr, "Erro de sintaxe: %s\n", s);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror("Erro ao abrir o arquivo");
            return 1;
        }
        yyin = file;
    }

    if (yyparse() == 0) {
        print_tree(root, 0);
    } else {
        printf("Erro: a arvore sintática nao foi construida corretamente.\n");
    }

    return 0;
}
