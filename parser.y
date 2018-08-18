%{ 
#define YYDEBUG 1
#include <iostream>
using namespace std;

extern int yylex();
int item_no = 0;
void yyerror(const char *s) {
	cout<<"Parse error!  Message:"<<s<<endl;
	// might as well halt now:
	exit(-1);
}

%}

%union {
	int ival;
	float fval;
	char *sval;
}

%start S

%token <ival> INT
%token <fval> FLOAT
%token <sval> STRING
%token BEGIN_ITEMIZE END_ITEMIZE 
%token BEGIN_ENUMERATE END_ENUMERATE
%token BEGIN_DOCUMENT END_DOCUMENT
%token SECTION SUBSECTION
%token PAR
%token ITEM
%token ENDL
%token T_BF T_IT T_U
%token BEGIN_CURLY END_CURLY

%%

S:
		CONTENT
		| S SEC 
		;
SEC:
		SECTION CONTENT {cout<<"Sec reduced\n";}
		| SECTION CONTENT SUBSEC {cout<<"SEC SUBSEC\n";}
		;
SUBSEC:
		SUBSEC SUBSECTION CONTENT
		| SUBSECTION CONTENT
		;

LIST:	
		OL
		| UL
		;

OL: 
		BEGIN_ENUMERATE {cout<<"Begin OL\n";} 
		ITEMS 
		END_ENUMERATE {cout<<"End OL\n";}
		;

UL: 
		BEGIN_ITEMIZE {cout<<"Begin UL\n";} 
		ITEMS 
		END_ITEMIZE {cout<<"End UL\n";}
		;

ITEMS: 
		ITEMS ITEM CONTENT 
		| ITEM CONTENT 
		;

TEXTBF:
		T_BF CONTENT END_CURLY
		;

TEXTIT:
		T_IT CONTENT END_CURLY
		;

UNDERLINE:
		T_U CONTENT END_CURLY

CONTENT:  
		CONTENT LIST 
 		| CONTENT STRING
		| CONTENT PAR
		| CONTENT TEXTBF
		| CONTENT TEXTIT
		| CONTENT UNDERLINE
		|
		;

%%
#include <iostream>

// stuff from lex that yacc needs to know about:
extern int yyparse();
extern FILE *yyin;

int main(int argc, char *argv[]) { 
	yyin = fopen(argv[1], "r");
	
	// parse through the input until there is no more:
	do {
		yyparse();
	} while (!feof(yyin));
	
}