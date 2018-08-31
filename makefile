compiler: main.cpp lex.yy.c parser.tab.c
	@g++ main.cpp lex.yy.c parser.tab.c -o compiler
parser.tab.c parser.tab.h: parser.y
	@bison -d parser.y
lex.yy.c: lexer.l parser.tab.h
	@flex lexer.l
clean:
	@rm -f compiler parser.tab.c parser.tab.h lex.yy.c parser.output
