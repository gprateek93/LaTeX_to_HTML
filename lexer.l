%option noyywrap

%{ 
#include <iostream>
#include "parser.tab.h"
using namespace std;


%}


%% 

[ \t]+						; /* skip whitespace */ 

\n 							;

"\\begin{itemize}" 			{return BEGIN_ITEMIZE;}

"\\end{itemize}" 			{return END_ITEMIZE;}

"\\begin{enumerate}"		{return BEGIN_ENUMERATE;}

"\\end{enumerate}"			{return END_ENUMERATE;}

"\\begin{document}"			{return BEGIN_DOCUMENT;}

"\\end{document}"			{return END_DOCUMENT;}

"\\section"					{return SECTION;}

\\subsection				{return SUBSECTION;}

\\item 						{return ITEM;}

\\par 						{return PAR;}

[a-zA-Z0-9 ]*	{
					char *res = new char[strlen(yytext) + 1];
					strcpy(res, yytext);
					yylval.sval = res;
					return STRING;
				}

.				;

%% 
