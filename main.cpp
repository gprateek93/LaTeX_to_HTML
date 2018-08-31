#include <iostream>
#include "ast.h"

// stuff from lex that yacc needs to know about:
using namespace std;

extern int yyparse();
extern FILE *yyin;
extern void init_content_children();
extern void init_list_children();
extern void init_section_children();
extern void init_subsection_children();
extern void init_rows_children();
extern void init_r_content_children();
extern void init_cell_children();
extern void print(ast_node*, int);

ast_node* root;

void yyerror(const char *s) {
	cout<<"Parse error!  Message:"<<s<<endl;
	// might as well halt now:
	exit(-1);
}

int main(int argc, char *argv[]) {
	yyin = fopen(argv[1], "r");
	init_content_children();
	init_list_children();
	init_section_children();
	init_subsection_children();
	init_rows_children();
	init_r_content_children();
	init_cell_children();

	// parse through the input until there is no more:
	do {
		yyparse();
	} while (!feof(yyin));
	print(root,0);
	
}
