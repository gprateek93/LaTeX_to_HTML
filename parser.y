%{
#define YYDEBUG 1
#include <iostream>
#include <vector>
#include <stack>
#include <cstring>
#include "ast.h"

using namespace std;

typedef vector<ast_node*> c_ptrs;

extern int yylex();
extern void yyerror(const char*);
extern ast_node* root;
vector<string> labels;

c_ptrs* section_children;
c_ptrs* subsection_children;
c_ptrs* list_children;
c_ptrs* content_children;
c_ptrs* r_content_children;
c_ptrs* rows_children;
c_ptrs* cell_children;
c_ptrs* figure_children;
c_ptrs* math_children;

stack<c_ptrs> content_stack;
stack<c_ptrs> r_content_stack;
stack<c_ptrs> list_stack;

%}

%union {
	char* sval;
	ast_node* node;
}

%start START

%type <node> S LIST UNDERLINE TEXTIT TEXTBF TABLE SEC OL UL RESTRICTED_TEXTBF RESTRICTED_TEXTIT RESTRICTED_UNDERLINE ROW DOW FIGURE MATH INC_GR CAP SUM INTG FRAC SQRT LABEL REF
%type <sval> FIGURE_PATH FIGURE_SPECS HEADING
%token <sval> STRING MATH_STRING FIG_ARGS
%token BEGIN_ITEMIZE END_ITEMIZE
%token BEGIN_ENUMERATE END_ENUMERATE
%token BEGIN_DOCUMENT END_DOCUMENT PREAMBLE
%token SECTION SUBSECTION
%token PAR
%token ITEM
%token ENDL
%token T_BF T_IT T_U
%token BEGIN_CURLY END_CURLY
%token BEGIN_TABULAR END_TABULAR
%token TABLE_ARGS HLINE
%token AMPERSAND DSLASH
%token BEGIN_FIGURE BEGIN_SQUARE END_FIGURE END_SQUARE INCLUDE_GRAPHICS CAPTION COMMA
%token DOLLAR SUMMATION INTEGRAL FRACTION SQUARE_ROOT SUPERSCRIPT SUBSCRIPT
%token LABEL_TAG REF_TAG

%%

START:
		PREAMBLE BEGIN_DOCUMENT S END_DOCUMENT
		{
			root = $3;
		}
		;

S:
		CONTENT
		{
			$$ = new_node();
			$$->node_type = DOCUMENT_H;
			adopt_content_children($$);
		}
		| S SEC
		{
			$$ = new_node();
			$$->node_type = DOCUMENT_H;
			adopt_section_children($$);
		}
		;


NC:		{
			make_new_content();
		}
		;

NL:
		{
			make_new_list();
		}
		;

NRC:
		{
			make_new_r_content();
		}

SEC:
		SECTION HEADING NC CONTENT
		{
			ast_node* temp = new_node();
			adopt_content_children(temp);
			temp->node_type = SECTION_H;
			temp->data = $2;
			section_children->push_back(temp);
		}
		| SECTION HEADING NC CONTENT SUBSEC
		{
			ast_node* temp = new_node();
			adopt_content_children(temp);
			temp->node_type = SECTION_H;
			temp->data = $2;
			for(int i=0; i<subsection_children->size();i++){
				temp->children.push_back(subsection_children->at(i));
			}
			section_children->push_back(temp);
			init_subsection_children();
		}
		;

HEADING:
		BEGIN_CURLY STRING END_CURLY
		{
			$$ = $2;
		}
		|
		{
			string s = "";
			$$ = strdup(s.c_str());
		}
		;

SUBSEC:
		SUBSEC SUBSECTION HEADING NC CONTENT
		{
			ast_node* temp = new_node();
			temp->node_type = SUBSECTION_H;
			adopt_content_children(temp);
			temp->data = $3;
			subsection_children->push_back(temp);
		}
		| SUBSECTION HEADING NC CONTENT
		{
			ast_node* temp = new_node();
			temp->node_type = SUBSECTION_H;
			adopt_content_children(temp);
			temp->data = $2;
			subsection_children->push_back(temp);
		}
		;

LIST:
		OL
		| UL
		;

OL:
		BEGIN_ENUMERATE NL ITEMS END_ENUMERATE
		{
			$$ = new_node();
			$$->node_type = ENUMERATE_H;
			adopt_list_children($$);
		}
		;

UL:
		BEGIN_ITEMIZE NL ITEMS END_ITEMIZE
		{
			$$ = new_node();
			$$->node_type = ITEMIZE_H;
			adopt_list_children($$);
		}
		;

ITEMS:
		ITEMS ITEM NC CONTENT
		{
			ast_node* temp = new_node();
			temp->node_type = ITEM_H;
			adopt_content_children(temp);
			list_children->push_back(temp);
		}
		| ITEM NC CONTENT
		{
			ast_node* temp = new_node();
			temp->node_type = ITEM_H;
			adopt_content_children(temp);
			list_children->push_back(temp);
		}
		;

TEXTBF:
		T_BF BEGIN_CURLY NC CONTENT END_CURLY
		{
			$$ = new_node();
			$$->node_type = TEXTBF_H;
			adopt_content_children($$);
		}
		;

TEXTIT:
		T_IT BEGIN_CURLY NC CONTENT END_CURLY
		{
			$$ = new_node();
			$$->node_type = TEXTIT_H;
			adopt_content_children($$);
		}
		;

UNDERLINE:
		T_U BEGIN_CURLY NC CONTENT END_CURLY
		{
			$$ = new_node();
			$$->node_type = UNDERLINE_H;
			adopt_content_children($$);
		}
		;

CONTENT:
		CONTENT LIST 				{
										content_children->push_back($2);
									}
 		| CONTENT STRING			{
										ast_node* temp = new_node();
										string str($2);
										temp->data = str;
										temp->node_type = STRING_H;
										content_children->push_back(temp);
									}
		| CONTENT PAR				{
										ast_node* temp = new_node();
										temp->node_type = PAR_H;
										content_children->push_back(temp);
									}
		| CONTENT TEXTBF 			{
										content_children->push_back($2);
									}
		| CONTENT TEXTIT 			{
										content_children->push_back($2);
									}
		| CONTENT UNDERLINE 		{
										content_children->push_back($2);
									}
		| CONTENT TABLE 			{
										content_children->push_back($2);
									}
		| CONTENT FIGURE 			{
										content_children->push_back($2);
									}
		| CONTENT MATH 				{
										content_children->push_back($2);
									}
		| CONTENT REF 				{
										content_children->push_back($2);
									}
		| CONTENT LABEL 			{
										content_children->push_back($2);
									}
		|
		;

LABEL:
		LABEL_TAG BEGIN_CURLY STRING END_CURLY
		{
			$$ = new_node();
			$$->node_type = LABEL_H;
			$$->data = $3;
		}
		;

REF:
		REF_TAG BEGIN_CURLY STRING END_CURLY
		{
			$$ = new_node();
			$$->node_type = REF_H;
			$$->data = $3;
		}
		;

TABLE:
		BEGIN_TABULAR BEGIN_CURLY TABLE_ARGS END_CURLY HLINE ROWS END_TABULAR
		{
			$$ = new_node();
			$$->node_type = TABULAR_H;
			adopt_rows_children($$);
			init_rows_children();
		}
		;

ROWS:
		ROWS ROW
		{
			rows_children->push_back($2);
		}
		| ROW
		{
			rows_children->push_back($1);
		}
		;

ROW:
		DOW NRC RESTRICTED_CONTENT DSLASH HLINE
		{
			ast_node* temp = new_node();
			temp->node_type = CELL_H;
			adopt_r_content_children(temp);
			cell_children->push_back(temp);
			$$ = new_node();
			$$->node_type = ROW_H;
			adopt_cell_children($$);
			init_cell_children();

		}
		;

DOW:
		DOW NRC RESTRICTED_CONTENT AMPERSAND
		{
			ast_node* temp = new_node();
			temp->node_type = CELL_H;
			adopt_r_content_children(temp);
			cell_children->push_back(temp);
		}
		|
		{
			;
		}
		;

RESTRICTED_CONTENT:
		RESTRICTED_CONTENT MATH                     {
														r_content_children->push_back($2);
													}
		| RESTRICTED_CONTENT STRING 				{
														ast_node* temp = new_node();
														string str($2);
														temp->data = str;
														temp->node_type = STRING_H;
														r_content_children->push_back(temp);
													}
		| RESTRICTED_CONTENT RESTRICTED_TEXTBF		{
														r_content_children->push_back($2);
													}
		| RESTRICTED_CONTENT RESTRICTED_TEXTIT		{
														r_content_children->push_back($2);
													}

		| RESTRICTED_CONTENT RESTRICTED_UNDERLINE	{
														r_content_children->push_back($2);
													}
		|
		;

RESTRICTED_TEXTBF:
		T_BF BEGIN_CURLY NRC RESTRICTED_CONTENT END_CURLY
		{
			$$ = new_node();
			$$->node_type = TEXTBF_H;
			adopt_r_content_children($$);
		}
		;

RESTRICTED_TEXTIT:
		T_IT BEGIN_CURLY NRC RESTRICTED_CONTENT END_CURLY
		{
			$$ = new_node();
			$$->node_type = TEXTIT_H;
			adopt_r_content_children($$);
		}
		;

RESTRICTED_UNDERLINE:
		T_U BEGIN_CURLY NRC RESTRICTED_CONTENT END_CURLY
		{
			$$ = new_node();
			$$->node_type = UNDERLINE_H;
			adopt_r_content_children($$);
		}
		;

FIGURE:
		BEGIN_FIGURE FIG_CONTENT END_FIGURE
		{
			$$ = new_node();
			$$->node_type = FIGURE_H;
			adopt_figure_children($$);
		}
		;

FIG_CONTENT:
		FIG_CONTENT INC_GR 			{
										figure_children->push_back($2);
									}
		| FIG_CONTENT CAP
									{
										figure_children->push_back($2);
									}
		|
		;

CAP:
		CAPTION BEGIN_CURLY NRC RESTRICTED_CONTENT END_CURLY
		{
			$$ = new_node();
			$$->node_type = CAPTION_H;
			adopt_r_content_children($$);
		}
		;

INC_GR:
		INCLUDE_GRAPHICS FIGURE_SPECS FIGURE_PATH
		{
			$$ = new_node();
			$$->node_type = INCLUDE_GRAPHICS_H;
			$$->attributes = $2;
			$$->data = $3;
		}
		;

FIGURE_SPECS:
		BEGIN_SQUARE FIG_ARGS END_SQUARE
		{
			$$ = $2;
		}
		|
		{
			string s = "";
			$$ = strdup(s.c_str());
		}
		;

FIGURE_PATH:
		BEGIN_CURLY STRING END_CURLY
		{
			$$ = $2;
		}
		;

MATH:
		DOLLAR MATH_CONTENT DOLLAR
		{
			$$ = new_node();
			$$->node_type = MATH_H;
			adopt_math_children($$);
			init_math_children();
		}
		;

MATH_CONTENT:
		MATH_CONTENT MATH_STRING	{
										ast_node* temp = new_node();
										string str($2);
										temp->data = str;
										temp->node_type = STRING_H;
										math_children->push_back(temp);
									}
		| MATH_CONTENT SUM          {
										math_children->push_back($2);
									}
		| MATH_CONTENT INTG 		{
										math_children->push_back($2);
									}
		| MATH_CONTENT FRAC{
										math_children->push_back($2);
									}
		| MATH_CONTENT SQRT{
										math_children->push_back($2);
									}
		|
		;
SUM:
		SUMMATION SUBSCRIPT BEGIN_CURLY MATH_STRING END_CURLY SUPERSCRIPT BEGIN_CURLY MATH_STRING END_CURLY
		{
			$$ = new_node();
			$$->node_type = SUM_H;
			$$->data = $4;
			$$->attributes = $8;

		}
		;
INTG:
		INTEGRAL SUBSCRIPT BEGIN_CURLY MATH_STRING END_CURLY SUPERSCRIPT BEGIN_CURLY MATH_STRING END_CURLY
		{
			$$ = new_node();
			$$->node_type = INTG_H;
			$$->data = $4;
			$$->attributes = $8;

		}
		;
FRAC:
		FRACTION BEGIN_CURLY MATH_STRING END_CURLY BEGIN_CURLY MATH_STRING END_CURLY
		{
			$$ = new_node();
			$$->node_type = FRAC_H;
			$$->data = $3;
			$$->attributes = $6;

		}
		;
SQRT:
		SQUARE_ROOT BEGIN_CURLY MATH_STRING END_CURLY
		{
			$$ = new_node();
			$$->node_type = SQRT_H;
			$$->data = $3;
		}
		;
%%
