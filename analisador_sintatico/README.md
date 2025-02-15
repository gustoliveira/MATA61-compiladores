# Compilador para a Linguagem C-Sharp

## Integrantes
- Júlia Santos de Santana
- José Alberto Ramos de Santana
- Cláudio José Nunes Vieira Filho
- Gustavo de Oliveira Ferreira

## Documentação da Mini Linguagem C#-Like

### Visão Geral

Este projeto é uma implementação simplificada de um compilador para uma linguagem inspirada em C#. Utiliza Flex para análise léxica e Bison para análise sintática, com um modelo de árvore sintática construída em C. O compilador lê arquivos com extensão “.cs” (emular código C# simplificado) e constrói uma árvore sintática que pode ser utilizada para posteriores fases de compilação ou análise.

## Estrutura do Projeto

A estrutura de arquivos do projeto é a seguinte:

| Arquivo/Caminho              | Descrição                                                                               |
| ---------------------------- | --------------------------------------------------------------------------------------- |
| Makefile                     | Automação da compilação e execução do compilador.                                       |
| README.md                    | Documentação do projeto (este arquivo).                                                 |
| parser.y                     | Definição das regras de gramática e ações semânticas para o compilador.                 |
| scanner.l                    | Definição dos padrões lexicais para identificar tokens.                                 |
| node.h                       | Definição do nó utilizado para a árvore sintática.                                      |
| input.cs                     | Exemplo de arquivo fonte de entrada para testar o compilador.                           |
| exemplos/\*.cs               | Diversos exemplos de código para testes, incluindo casos de atribuição, funções, etc.     |


### Estrutura Básica
Todo programa deve seguir a estrutura básica:

```csharp
    class Program {
        static void Main() {
            // Código
        }
    }
```

### Features Implementadas

1. Tipos de Dados
- int: números inteiros
- float: números de ponto flutuante (exemplo: 1.0, 2.5, 3.05)
- string: cadeias de caracteres
- void: tipo para funções sem retorno

2. Modificadores de Acesso
- public
- private
- static

3. Estruturas de Controle
- if/else: controle condicional
- for: loop com contador
- while: loop com condição

4. Operadores
- Aritméticos: +, -, *, /
- Atribuição: =

5. Operadores de Comparação
- Igualdade: ==
- Diferença: !=
- Maior que: >
- Menor que: <
- Maior ou igual: >=
- Menor ou igual: <=

6. Funções
- Possivel declarar funções com ou sem retorno
- Chamada de funções com ou sem parâmetros
- Chamar funcao atribuindo a uma variável
- Retorno de valores (return)

### Limitações

1. Escopo Restrito
- Não há suporte para múltiplas classes
- Não há suporte para namespaces

2. Tipos de Dados
- Não suporta tipos complexos ou definidos pelo usuário
- Sem suporte para arrays
- Sem suporte para ponto flutuante

3. Funções
- Não suporta parâmetros em funções
- Não suporta sobrecarga de métodos
- Sem suporte para recursão

4. Operadores
- Conjunto limitado de operadores
- Sem operadores lógicos (&&, ||)
- Sem operadores de incremento/decremento

5. Orientação a Objetos
- Não suporta herança
- Sem suporte para interfaces
- Sem suporte para polimorfismo

## Exemplo de Código Válido


```csharp
class Program {
    static void Main() {        
        x = 1 + 1;        
        if(x == 2){
            return true;
        }
        else {
            return false;
        }        
    }
}
```

## Regras de Produção (Gramática)

As regras de produção definidas no arquivo parser.y representam a estrutura sintática da linguagem. Algumas das principais produções são:

| Produção                           | Descrição                                                                                           |
| ---------------------------------- | --------------------------------------------------------------------------------------------------- |
| `program: CLASS PROGRAM { ... }`   | Define a estrutura principal de um programa, encapsulando uma lista de instruções entre chaves.     |
| `statement_list: statement ...`    | Concatena uma ou mais instruções para formar o corpo do programa.                                  |
| `statement: attribution | if_statement | declaration | function | loop | return_statement` | Cada instrução pode ser uma atribuição, uma estrutura condicional, declaração de variável, função, laço ou retorno de função. |
| `declaration: type ID PONTO_VIRGULA` | Define a declaração de uma variável associada a um tipo específico.                               |
| `if_statement: IF ( condition ) { statement_list } [ELSE { statement_list }]` | Estrutura condicional, permitindo condições com ou sem a parte “else”.                         |
| `loop: WHILE ( condition ) { statement_list }` | Estrutura para laços de repetição.                                                                |
| `expression: NUM | ID | LITERAL_STRING | expression MAIS expression` | Expressões aritméticas e comparações.                                                           |

## Casos de Teste

Para verificar o correto funcionamento do compilador, foram criados diversos casos de teste, distribuídos nos arquivos da pasta *exemplos/*. Alguns casos incluem:

- **Testes de Tipos e Atribuições:**  
  Exemplo: *exemplos/number_types.cs* testa a declaração e atribuição de variáveis mesmo quando há incompatibilidades implícitas (por exemplo, atribuir valores do tipo float a variáveis do tipo int).

- **Testes de Operações Matemáticas:**  
  Exemplo: *exemplos/operacoes_matematicas.cs* realiza operações de soma, subtração, multiplicação e divisão, verificando se as expressões são corretamente avaliadas.

- **Testes de Estruturas Condicionais:**  
  Exemplo: *exemplos/condional_aninhada.cs* demonstra o uso de estruturas if/else simples e aninhadas, assegurando que a árvore sintática represente corretamente as condições e os blocos de código.

- **Testes de Funções e Chamadas:**  
  Exemplo: *exemplos/funcao.cs* avalia declarações de funções (com e sem retorno) e suas chamadas, validando o correto emparelhamento dos parâmetros e a criação dos nós correspondentes.

- **Testes de Estruturas de Laço:**  
  Exemplo: *exemplos/while_loop.cs* testa estruturas de repetição (while), verificando a geração recorrente dos nós associados à condição e à lista de instruções.

Para executar os testes, basta utilizar o Makefile informando o arquivo de entrada desejado, ou substituir o parâmetro INPUT para apontar para os arquivos de exemplos. Os resultados podem ser visualizados imprimindo a árvore sintática gerada, permitindo ao desenvolvedor confirmar se os nós representam o código corretamente[1].


## Como Executar o Compilador

### Pré-requisitos

- Flex (Fast Lexical Analyzer)
- Bison (GNU Parser Generator)
- GCC (GNU Compiler Collection)

### Windows

1. Instalar dependências:
- Instalar MinGW (inclui GCC)
- Instalar Flex e Bison para Windows
- Adicionar os binários ao PATH do sistema

2. Gerar os arquivos do compilador:
```cmd
bison -d parser.y
flex scanner.l
gcc -o compilador.exe parser.tab.c lex.yy.c
```

3. Executar o compilador:
```cmd
compilador.exe path/to/input.cs
```

### Linux

1. Instalar dependências:
```bash
sudo apt install flex bison gcc make
```

2. Gerar os arquivos do compilador:
```bash
bison -d parser.y
flex scanner.l
gcc -o compilador parser.tab.c lex.yy.c
```

3. Executar o compilador:
```bash
./compilador path/to/input.cs
```

Opcionalmente, você pode usar o Makefile:
```bash
make run    # Compila e executa
make clean  # Remove arquivos gerados
```

### Observações

- Os arquivos parser.tab.c, parser.tab.h e lex.yy.c são gerados automaticamente
- Não é necessário incluí-los no controle de versão
- O Makefile é opcional, mas facilita o processo de compilação
