%option noyywrap

%{ 
#include <iostream>
#include "parser.tab.h"
using namespace std;


%}

%x ENV_TABULAR
$x TABLE_ARGUMENTS

%% 

[ \t]+						; /* skip whitespace */ 

\n 							;

"\\begin{itemize}" 				{return BEGIN_ITEMIZE;}

"\\end{itemize}" 				{return END_ITEMIZE;}

"\\begin{enumerate}"			{return BEGIN_ENUMERATE;}

"\\end{enumerate}"				{return END_ENUMERATE;}

"\\begin{document}"				{return BEGIN_DOCUMENT;}

"\\end{document}"				{return END_DOCUMENT;}

"\\section"						{return SECTION;}

\\subsection					{return SUBSECTION;}

\\item 							{return ITEM;}

\\par 							{return PAR;}

\\textbf 						{return T_BF;}

\\textit						{return T_IT;}

\\underline						{return T_U;}

"}"								{return END_CURLY;}

"\\begin{tabular}"				{
									BEGIN(TABLE_ARGUMENTS);
									return BEGIN_TABULAR;
								}

"\\end{tabular}"				{	return END_TABULAR;}

<TABLE_ARGUMENTS>"{"			{
									return BEGIN_CURLY;
								}

<TABLE_ARGUMENTS>"[lcr][ lcr|]*"{
									char *res = new char[strlen(yytext) + 1];
									strcpy(res, yytext);
									yylval.sval = res; // take this value when creating node
									return TABLE_ARGS;
								}


<TABLE_ARGUMENTS>"}"			{
									BEGIN(INITIAL);
									return END_CURLY;
								}

[a-zA-Z0-9 ]*					{
									char *res = new char[strlen(yytext) + 1];
									strcpy(res, yytext);
									yylval.sval = res;
									return STRING;
								}

.								;

%% 
