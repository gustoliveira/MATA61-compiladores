# Compilador para a Linguagem C-Sharp

## Integrantes
- Júlia Santos de Santana
- José Alberto Ramos de Santana
- Cláudio José Nunes Vieira Filho
- Gustavo de Oliveira Ferreira

## Documentação da Mini Linguagem C#-Like

### Visão Geral
Esta é uma implementação simplificada de um compilador para uma linguagem inspirada em C#, desenvolvida usando Flex (analisador léxico) e Bison (analisador sintático). A linguagem implementa um subconjunto básico de funcionalidades similares ao C#.

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
- Comparação: ==
- Atribuição: =

5. Funções
- Suporte a declaração de funções
- Parâmetros não são suportados na implementação atual
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
compilador.exe input.cs
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
./compilador input.cs
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
