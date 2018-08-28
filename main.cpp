#include <iostream>
#include "ast.h"

// stuff from lex that yacc needs to know about:
using namespace std;

extern int yyparse();
extern FILE *yyin;
extern void init_content_children();
extern void init_list_children();

void yyerror(const char *s) {
	cout<<"Parse error!  Message:"<<s<<endl;
	// might as well halt now:
	exit(-1);
}

int main(int argc, char *argv[]) {
	yyin = fopen(argv[1], "r");
	init_content_children();
	init_list_children();
	// parse through the input until there is no more:
	do {
		yyparse();
	} while (!feof(yyin));

}
