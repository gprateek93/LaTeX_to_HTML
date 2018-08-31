%option noyywrap

%{
#include <iostream>
#include "ast.h"
#include "parser.tab.h"
using namespace std;
int prev_state = 0;
/*0. INITIAL
1. ENV_TABULAR
2. ENV_FIGURE
*/

%}
%x ENV_TABULAR
%x TABLE_ARGUMENTS
%x ENV_FIGURE
%x FIGURE_ARGUMENTS
%x MATHMODE

OPERATORS [+*\-/^=]

%%

<*>[ \t]+ ; /* skip whitespace */

<INITIAL,ENV_TABULAR,ENV_FIGURE>\n  ;

"\\begin{itemize}"                  {
                                        return BEGIN_ITEMIZE;
                                    }

"\\end{itemize}"                    {
                                        return END_ITEMIZE;
                                    }

"\\begin{enumerate}"			    {
                                        return BEGIN_ENUMERATE;
                                    }

"\\end{enumerate}"				    {
                                        return END_ENUMERATE;
                                    }

"\\begin{document}"                 {
                                        return BEGIN_DOCUMENT;
                                    }

"\\end{document}"                   {
                                        return END_DOCUMENT;
                                    }

"\\section"                         {
                                        return SECTION;
                                    }

"\\subsection"                      {
                                        return SUBSECTION;
                                    }

"\\item"                            {
                                        return ITEM;
                                    }

"\\par"                             {
                                        return PAR;
                                    }
"\\label"                           {
                                        return LABEL_TAG;
                                    }
"\\ref"                             {
                                        return REF_TAG;
                                    }

<INITIAL,ENV_TABULAR>"\\textbf"     {
                                        return T_BF;
                                    }

<INITIAL,ENV_TABULAR>"\\textit"     {
                                        return T_IT;
                                    }

<INITIAL,ENV_TABULAR>"\\underline"  {
                                        return T_U;
                                    }

<INITIAL,ENV_TABULAR,MATHMODE>"{"   {
                                        return BEGIN_CURLY;
                                    }

<INITIAL,ENV_TABULAR,MATHMODE>"}"   {
                                        return END_CURLY;
                                    }

"\\begin{tabular}"                  {
    									/*cout<<"Begin tabular\n";*/
                                        BEGIN(TABLE_ARGUMENTS);
                                        prev_state = -1;
                                        return BEGIN_TABULAR;
                                    }

<ENV_TABULAR>"\\end{tabular}"       {
                                        BEGIN(INITIAL);
                                        prev_state = 0;
                                        return END_TABULAR;
								    }

<TABLE_ARGUMENTS>\{				    {
                                        return BEGIN_CURLY;
                                    }

<TABLE_ARGUMENTS>[ lcr|]*	        {
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

<TABLE_ARGUMENTS>"}"                {
                                        BEGIN(ENV_TABULAR);
                                        prev_state = 1;
                                        return END_CURLY;
                                    }

<ENV_TABULAR>"&"                    {
									   return AMPERSAND;
								    }

<INITIAL,ENV_TABULAR>\\\\			{
                                    	return DSLASH;
                                    }

<ENV_TABULAR>"\\hline"              {
                                        return HLINE;
                                    }

<INITIAL,ENV_TABULAR,ENV_FIGURE>[a-zA-Z0-9 ]*  {
    									char *res = new char[strlen(yytext) + 1];
    									strcpy(res, yytext);
    									yylval.sval = res;
    									return STRING;
								    }
"\\begin{figure}"                   {
                                        /*cout << "begin figure" << endl;*/
                                        BEGIN(ENV_FIGURE);
                                        prev_state = 2;
                                        return BEGIN_FIGURE;
                                    }

<ENV_FIGURE>"\\end{figure}"         {
                                        BEGIN(INITIAL);
                                        prev_state = 4;
                                        return END_FIGURE;
                                    }

<INITIAL,ENV_FIGURE>"\\includegraphics" {
                                        return INCLUDE_GRAPHICS;
                                    }

<INITIAL,ENV_FIGURE>"["             {
                                        BEGIN(FIGURE_ARGUMENTS);
                                        prev_state = -1;
                                        return BEGIN_SQUARE;
                                    }
<INITIAL,ENV_FIGURE>"{"             {
                                        return BEGIN_CURLY;
                                    }

<INITIAL,ENV_FIGURE>"}"             {
                                        return END_CURLY;
                                    }

<ENV_FIGURE>"\\caption"             {
                                        return CAPTION;
                                    }

<FIGURE_ARGUMENTS>[a-z=. 0-9,]+       {
                                        char *res = new char[strlen(yytext)+1];
                                        strcpy(res, yytext);
                                        yylval.sval = res;
                                        return FIG_ARGS;
                                        /*
                                        string test = "";
                                        int i = 0;
                                        while(res[i]==' '){
                                            i++;
                                        }
                                        while(res[i] != '=' && res[i]!=' '){
                                            test+=res[i++];
                                        }
                                        if(test == "width" || test == "height" || test == "scale" || test == "angle"){
                                            yylval.sval = res;
                                            return FIG_ARGS;
                                        }
                                        */

                                    }

<FIGURE_ARGUMENTS>"]"               {
                                        BEGIN(ENV_FIGURE);
                                        prev_state = 2;
                                        return END_SQUARE;
                                    }

<INITIAL,ENV_TABULAR,ENV_FIGURE>"$" {
                                        BEGIN(MATHMODE);
                                        /*cout << "entered mathmode" << endl;*/
                                        return DOLLAR;
                                    }

<MATHMODE>"\\sum"                   {
                                        return SUMMATION;
                                    }

<MATHMODE>"\\int"                   {
                                        return INTEGRAL;
                                    }

<MATHMODE>"\\frac"                  {
                                        return FRACTION;
                                    }

<MATHMODE>"\\sqrt"                  {
                                        return SQUARE_ROOT;
                                    }

<MATHMODE>\^                        {
                                        /*it means superscript in latex
                                          but current it is used only
                                          for \int and \sum tags in this grammar */
                                        return SUPERSCRIPT;
                                    }

<MATHMODE>\_                        {
                                        /*it means subscript in latex
                                          but current it is used only
                                          for \int and \sum tags in this grammar*/
                                        return SUBSCRIPT;
                                    }
<MATHMODE>([A-Za-z.0-9]|{OPERATORS})*   {
                                            char *res = new char[strlen(yytext) + 1];
                                            strcpy(res, yytext);/* You still have to take care of spacing*/
                                            yylval.sval = res;
                                            /*cout << "Mathstring found!!  " << res << endl;*/
                                            return MATH_STRING;
                                        }

<MATHMODE>"$"                       {
                                        /*cout << "prev State = " << prev_state << endl;
                                        cout << "leaving math mode" << endl;*/
                                        switch(prev_state)
                                        {
                                            case 0: BEGIN(INITIAL); prev_state = 0; break;
                                            case 1: BEGIN(ENV_TABULAR); prev_state = 1; break;
                                            case 2: BEGIN(ENV_FIGURE); prev_state = 2; break;
                                            default: cout << "Error, You shouldn't have entered math mode from here!!" << endl; BEGIN(INITIAL);
                                        }

                                        return DOLLAR;
                                    }



.                                   {cout<<"...";}

%%
