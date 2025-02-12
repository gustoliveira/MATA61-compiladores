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
