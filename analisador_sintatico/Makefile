COLOR_GREEN=\033[32m
COLOR_RESET=\033[0m

INPUT ?= input.cs
run:
	@echo "${COLOR_GREEN}RODANDO BISON...${COLOR_RESET}"
	@bison -d parser.y

	@echo "${COLOR_GREEN}RODANDO FLEX...${COLOR_RESET}"
	@flex scanner.l

	@echo "${COLOR_GREEN}COMPILANDO...${COLOR_RESET}"
	@gcc -o compilador parser.tab.c lex.yy.c

	@echo "${COLOR_GREEN}RODANDO COMPILADOR COM: ${INPUT}...${COLOR_RESET}"
	@./compilador $(INPUT)

clean:
	@echo "${COLOR_GREEN}LIMPANDO ARQUIVOS GERADOS...${COLOR_RESET}"
	@rm -f parser.tab.c parser.tab.h lex.yy.c compilador compilador.exe compilador.zip analisador_sintatico.zip

zip:
	@echo "ZIPANDO ARQUIVOS..."
	@rm -f parser.tab.c parser.tab.h lex.yy.c compilador compilador.exe compilador.zip analisador_sintatico.zip
	@zip -r analisador_sintatico.zip . -x .git/\* .gitignore

.PHONY: run, clean, zip

