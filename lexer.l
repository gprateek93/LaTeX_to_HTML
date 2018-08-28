%option noyywrap

%{
#include <iostream>
#include "ast.h"
#include "parser.tab.h"
using namespace std;


%}
%x ENV_TABULAR
%x TABLE_ARGUMENTS
%x ENV_FIGURE
%x FIGURE_ARGUMENTS

%%

<*>[ \t]+                                           ; /* skip whitespace */

<INITIAL,ENV_TABULAR,ENV_FIGURE>\n                  ;

"\\begin{itemize}"                                  {
                                                        return BEGIN_ITEMIZE;
                                                    }

"\\end{itemize}"                                    {
                                                        return END_ITEMIZE;
                                                    }

"\\begin{enumerate}"			                    {
                                                        return BEGIN_ENUMERATE;
                                                    }

"\\end{enumerate}"				                    {
                                                        return END_ENUMERATE;
                                                    }

"\\begin{document}"                                 {
                                                        return BEGIN_DOCUMENT;
                                                    }

"\\end{document}"                                   {
                                                        return END_DOCUMENT;
                                                    }

"\\section"                                         {
                                                        return SECTION;
                                                    }

"\\subsection"                                      {
                                                        return SUBSECTION;
                                                    }

"\\item"                                            {
                                                        return ITEM;
                                                    }

"\\par"                                             {
                                                        return PAR;
                                                    }

<INITIAL,ENV_TABULAR>"\\textbf"                     {
                                                        return T_BF;
                                                    }

<INITIAL,ENV_TABULAR>"\\textit"                     {
                                                        return T_IT;
                                                    }

<INITIAL,ENV_TABULAR>"\\underline"                  {
                                                        return T_U;
                                                    }

<INITIAL,ENV_TABULAR>"{"                            {
                                                        return BEGIN_CURLY;
                                                    }

<INITIAL,ENV_TABULAR>"}"                            {
                                                        return END_CURLY;
                                                    }

"\\begin{tabular}"                                  {
                    									cout<<"Begin tabular\n";
                                                        BEGIN(TABLE_ARGUMENTS);
                                                        return BEGIN_TABULAR;
                                                    }

<ENV_TABULAR>"\\end{tabular}"                       {
                                                        BEGIN(INITIAL);
                                                        return END_TABULAR;
                								    }

<TABLE_ARGUMENTS>\{				                    {
                                                        return BEGIN_CURLY;
                                                    }

<TABLE_ARGUMENTS>[ lcr|]*	                        {
                                                    	char *resTemp = new char[strlen(yytext) + 1];
                                                        strcpy(resTemp, yytext);
                                                        char *res = new char[strlen(yytext) + 1];
                                                        int i=0, k=0;
                                                        while(resTemp[i]){
                                                            if(resTemp[i] == 'l' || resTemp[i] == 'c' || resTemp[i] == 'r'){
                                                                res[k++] = resTemp[i];
                                                            }
                                                            i++;
                                                        }
                                                        res[k] = 0;
                                                        yylval.sval = res;
                                                        return TABLE_ARGS;
                                                    }

<TABLE_ARGUMENTS>"}"                                {
                                                        BEGIN(ENV_TABULAR);
                                                        return END_CURLY;
                                                    }

<ENV_TABULAR>"&"                                    {
                								        return AMPERSAND;
                								    }

<INITIAL,ENV_TABULAR>\\\\			                {
                                                        return DSLASH;
                                                    }

<ENV_TABULAR>"\\hline"                              {
                                                        return HLINE;
                                                    }

<INITIAL,ENV_TABULAR,ENV_FIGURE>[a-zA-Z0-9 ,]*      {
                    									char *res = new char[strlen(yytext) + 1];
                    									strcpy(res, yytext);
                    									yylval.sval = res;
                    									return STRING;
                								    }

"\\begin{figure}"                                   {
                                                        cout<<"begin figure"<<endl;
                                                        BEGIN(ENV_FIGURE);
                                                        return BEGIN_FIGURE;
                                                    }

<ENV_FIGURE>"\\end{figure}"                         {
                                                        BEGIN(INITIAL);
                                                        return END_FIGURE;
                                                    }

<INITIAL,ENV_FIGURE>"\\includegraphics"             {
                                                        return INCLUDE_GRAPHICS;
                                                    }

<INITIAL,ENV_FIGURE>"["                             {
                                                        BEGIN(FIGURE_ARGUMENTS);
                                                        return BEGIN_SQUARE;
                                                    }

<INITIAL,ENV_FIGURE>"{"                             {
                                                        return BEGIN_CURLY;
                                                    }

<INITIAL,ENV_FIGURE>"}"                             {
                                                        return END_CURLY;
                                                    }

<ENV_FIGURE>"\\caption"                             {
                                                        return CAPTION;
                                                    }

<INITIAL,ENV_FIGURE>"\\centering"                   {
                                                        return CENTERING;
                                                    }

<FIGURE_ARGUMENTS>[a-z=. 0-9]+                      {
                                                        char *res = new char[strlen(yytext)+1];
                                                        strcpy(res, yytext);
                                                        string test = "";
                                                        int i = 0;
                                                        while(res[i]==' '){
                                                            i++;
                                                        }
                                                        while(res[i]!='=' && res[i]!=' '){
                                                            test+=res[i++];
                                                        }
                                                        if(test == "width" || test == "height" || test == "scale" || test == "angle"){
                                                            return FIG_ARGS;
                                                        }
                                                    }

<FIGURE_ARGUMENTS>,                                 {
                                                        return COMMA;
                                                    }

<FIGURE_ARGUMENTS>"]"                               {
                                                        BEGIN(ENV_FIGURE);
                                                        return END_SQUARE;
                                                    }

.                                                   {cout<<"...";}

%%
