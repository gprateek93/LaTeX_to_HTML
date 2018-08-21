#include<iostream>

// stuff from lex that yacc needs to know about:
using namespace std;

extern int yyparse();
extern FILE *yyin;

int main(int argc, char *argv[]) {
	yyin = fopen(argv[1], "r");

	// parse through the input until there is no more:
	do {
		yyparse();
	} while (!feof(yyin));

}
