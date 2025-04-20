%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "node.h"

extern FILE *yyin; 
extern char *yytext;

Node *root;

int yylex();
void yyerror(const char *s);
%}

%union {
    char* str;
    char* num;
    char *id;
    Node *node;
}

%token <str> LITERAL_STRING
%token <id> ID NUM 
%token FLOAT INT STRING VOID RETURN IF ELSE FOR WHILE PUBLIC PRIVATE STATIC PROGRAM CLASS
%token IGUAL IGUAL_IGUAL MAIS MENOS MULTIPLICACAO DIVISAO MAIOR_QUE MAIOR_IGUAL_QUE MENOR_QUE MENOR_IGUAL_QUE
%token ABRE_PARENTESES FECHA_PARENTESES ABRE_CHAVES FECHA_CHAVES
%token PONTO_VIRGULA VIRGULA PONTO ABRE_COLCHETES FECHA_COLCHETES
%type <node> program statement statement_list expression attribution if_statement type declaration condition loop return_statement function parameter_list parameter function_call argument_list argument array_access array_assignment

%left IGUAL_IGUAL MAIOR_QUE MAIOR_IGUAL_QUE MENOR_QUE MENOR_IGUAL_QUE // menor precedência
%left MAIS MENOS
%left MULTIPLICACAO DIVISAO  // maior precedência

%start program

%%

program:
    CLASS PROGRAM ABRE_CHAVES statement_list FECHA_CHAVES { root = create_node("program", 1, $4); }
    ;

statement_list:
    statement { $$ = create_node("statement_list", 1, $1); }
    | statement_list statement { $$ = create_node("statement_list", 2, $1, $2); }
    ;

statement:
    attribution { $$ = create_node("statement", 1, $1); }
    | if_statement { $$ = create_node("statement", 1, $1); }
    | declaration { $$ = create_node("statement", 1, $1); }
    | function { $$ = create_node("statement", 1, $1); }
    | function_call { $$ = create_node("statement", 1, $1); }
    | loop { $$ = create_node("statement", 1, $1); }
    | return_statement { $$ = create_node("statement", 1, $1); }
    | array_assignment PONTO_VIRGULA { $$ = create_node("statement", 1, $1); }
    ;

declaration:
    type ID PONTO_VIRGULA { $$ = create_node("declaration", 2, $1, create_node($2, 0)); }
    | type ID ABRE_COLCHETES NUM FECHA_COLCHETES PONTO_VIRGULA { $$ = create_node("array_declaration", 3, $1, create_node($2, 0), create_node($4, 0)); }
    | type ID IGUAL expression PONTO_VIRGULA { $$ = create_node("declaration_with_init", 3, $1, create_node($2, 0), $4); }
    ;
type:
     STATIC INT { $$ = create_node("STATIC_INT", 0); }
    | STATIC STRING { $$ = create_node("STATIC_STRING", 0); }
    | STATIC VOID { $$ = create_node("STATIC_VOID", 0); }
    | STATIC FLOAT { $$ = create_node("STATIC_FLOAT", 0); }
    | PRIVATE { $$ = create_node("private", 0); }
    | PUBLIC { $$ = create_node("public", 0); }
    | STATIC { $$ = create_node("static", 0); }
    | INT { $$ = create_node("INT", 0); }
    | STRING { $$ = create_node("STRING", 0); }
    | VOID { $$ = create_node("VOID", 0); }
    | FLOAT { $$ = create_node("FLOAT", 0); }
    ;

attribution:
    ID IGUAL expression PONTO_VIRGULA { $$ = create_node("attribution", 2, create_node($1, 0), $3); }
    | ID IGUAL function_call { $$ = create_node("attribution", 2, create_node($1, 0), $3); }
    ;

array_access:
    ID ABRE_COLCHETES expression FECHA_COLCHETES { $$ = create_node("array_access", 2, create_node($1, 0), $3); }
    ;

array_assignment:
    array_access IGUAL expression { $$ = create_node("array_assignment", 2, $1, $3); }
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
    | expression MAIOR_QUE expression { $$ = create_node("condition", 3, $1, create_node(">", 0), $3); }
    | expression MAIOR_IGUAL_QUE expression { $$ = create_node("condition", 3, $1, create_node(">=", 0), $3); }
    | expression MENOR_QUE expression { $$ = create_node("condition", 3, $1, create_node("<", 0), $3); }
    | expression MENOR_IGUAL_QUE expression { $$ = create_node("condition", 3, $1, create_node("<=", 0), $3); }
    ;

expression:
    NUM { $$ = create_node($1, 0); }
    | ID { $$ = create_node($1, 0); }
    | LITERAL_STRING { $$ = create_node($1, 0); }
    | array_access { $$ = $1; }
    | expression MAIS expression { $$ = create_node("+", 2, $1, $3); }
    | expression MENOS expression { $$ = create_node("-", 2, $1, $3); }
    | expression MULTIPLICACAO expression { $$ = create_node("*", 2, $1, $3); }
    | expression DIVISAO expression { $$ = create_node("/", 2, $1, $3); }
    | expression IGUAL_IGUAL expression { $$ = create_node("==", 2, $1, $3); }
    ;

parameter_list:
    { $$ = create_node("params", 0); }
    | parameter { $$ = create_node("params", 1, $1); }
    | parameter_list VIRGULA parameter { $$ = create_node("params", 2, $1, $3); }
    ;

parameter:
    type ID { $$ = create_node("param", 2, $1, create_node($2, 0)); }
    ;

function:
    type ID ABRE_PARENTESES parameter_list FECHA_PARENTESES ABRE_CHAVES statement_list FECHA_CHAVES
    { $$ = create_node("function", 4, $1, create_node($2, 0), $4, $7); }
    ;

argument_list:
    { $$ = create_node("args", 0); }
    | argument { $$ = create_node("args", 1, $1); }
    | argument_list VIRGULA argument { $$ = create_node("args", 2, $1, $3); }
    ;

argument:
    expression { $$ = $1; }
    ;

function_call:
    ID ABRE_PARENTESES argument_list FECHA_PARENTESES PONTO_VIRGULA
    { $$ = create_node("function_call", 2, create_node($1, 0), $3); }
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
    fprintf(stderr, "\tToken que causou o erro: '%s'\n", yytext);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror("ERRO: Nao foi possivel abrir o arquivo");
            return 1;
        }
        yyin = file;
    }

    if (yyparse() == 0) {
        print_tree(root, 0);
    } else {
        printf("ERRO: A arvore sintática nao foi construida corretamente.\n");
    }

    return 0;
}
