compiler: main.cpp lex.yy.c parser.tab.c converter.cpp
	@g++ main.cpp lex.yy.c parser.tab.c ast.cpp converter.cpp -o compiler
parser.tab.c parser.tab.h: ast.cpp parser.y
	@bison -dv parser.y
lex.yy.c: lexer.l parser.tab.h
	@flex lexer.l
clean:
	@rm -f compiler parser.tab.c parser.tab.h lex.yy.c parser.output
