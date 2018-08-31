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

c_ptrs* section_children;
c_ptrs* subsection_children;
c_ptrs* list_children;

c_ptrs* content_children;
c_ptrs* r_content_children;
stack<c_ptrs> st;

void init_content_children(){
	content_children = new vector<ast_node*>();
}

void adopt_content_children(ast_node* current){
	current->children = *content_children;
	if(!st.empty()){
		*content_children = st.top();
		st.pop();
	}
}

void make_new_content(){
	st.push(*content_children);
	init_content_children();
}

void init_list_children(){
	list_children = new vector<ast_node*>();
}

void adopt_list_children(ast_node* current){
	current->children = *list_children;
	init_list_children();
}

void print(ast_node* root){
	if(root == NULL){
		return;
	}
	cout<<root->node_type<<endl;
	for(int i=0; i<root->children.size(); i++){
		print(root->children.at(i));
	}
}

%}

%union {
	char* sval;
	ast_node* node;
}

%start START

%type <node> S LIST UNDERLINE TEXTIT TEXTBF TABLE SEC OL UL
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
%token BEGIN_TABULAR END_TABULAR
%token TABLE_ARGS HLINE
%token AMPERSAND DSLASH
%token BEGIN_FIGURE BEGIN_SQUARE END_FIGURE END_SQUARE INCLUDE_GRAPHICS FIG_ARGS CAPTION COMMA CENTERING

%%

START:
		S
		{
			root = $1;
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
		;

DUMMY:	{
			make_new_content();
		}
		;


SEC:	
		SECTION DUMMY CONTENT
		{
			ast_node* temp = new_node();
			adopt_content_children(temp);
			temp->node_type = SECTION_H;
			//section_children->push_back(temp);
		}
		| SECTION DUMMY CONTENT SUBSEC
		{
			ast_node* temp = new_node();
			adopt_content_children(temp);
			temp->node_type = SECTION_H;
			//section_children->push_back(temp); add subsection part
		}
		;
SUBSEC:
		SUBSEC SUBSECTION DUMMY CONTENT
		{
			//Code to add content in Subsec
		}
		| SUBSECTION DUMMY CONTENT
		{
			//Code to add content in Subsec
		}
		;

LIST:
		OL
		| UL
		;

OL:
		BEGIN_ENUMERATE ITEMS END_ENUMERATE 
		{	
			$$ = new_node();
			$$->node_type = ENUMERATE_H;
			adopt_list_children($$);
		}
		;

UL:
		BEGIN_ITEMIZE ITEMS END_ITEMIZE
		{	
			$$ = new_node();
			$$->node_type = ITEMIZE_H;
			adopt_list_children($$);
		}
		;

ITEMS:
		ITEMS ITEM DUMMY CONTENT
		{
			ast_node* temp = new_node();
			adopt_content_children(temp);
			temp->node_type = ITEM_H;
			list_children->push_back(temp);
		}
		| ITEM DUMMY CONTENT
		{
			ast_node* temp = new_node();
			adopt_content_children(temp);
			temp->node_type = ITEM_H;
			list_children->push_back(temp);
		}
		;

TEXTBF:
		T_BF BEGIN_CURLY DUMMY CONTENT END_CURLY
		{
			$$ = new_node();
			$$->node_type = TEXTBF_H;
			adopt_content_children($$);
		}
		;

TEXTIT:
		T_IT BEGIN_CURLY DUMMY CONTENT END_CURLY
		{
			$$ = new_node();
			$$->node_type = TEXTIT_H;
			adopt_content_children($$);
		}
		;

UNDERLINE:
		T_U BEGIN_CURLY DUMMY CONTENT END_CURLY
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
		| CONTENT PAR
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
		| CONTENT FIGURE
		| CONTENT CENTERING
		|
		;

TABLE:
		BEGIN_TABULAR BEGIN_CURLY TABLE_ARGS END_CURLY HLINE ROWS END_TABULAR
		{
			$$ = new_node();
			$$->node_type = TABULAR_H;
		}
		;


ROWS:
		ROWS ROW
		| ROW
		;

ROW:
		DOW RESTRICTED_CONTENT DSLASH HLINE
		;

DOW:
		DOW RESTRICTED_CONTENT AMPERSAND
		|
		;

RESTRICTED_CONTENT:
		RESTRICTED_CONTENT STRING
		| RESTRICTED_CONTENT RESTRICTED_TEXTBF
		| RESTRICTED_CONTENT RESTRICTED_TEXTIT
		| RESTRICTED_CONTENT RESTRICTED_UNDERLINE
		|
		;

RESTRICTED_TEXTBF:
		T_BF BEGIN_CURLY RESTRICTED_CONTENT END_CURLY
		;

RESTRICTED_TEXTIT:
		T_IT BEGIN_CURLY RESTRICTED_CONTENT END_CURLY
		;

RESTRICTED_UNDERLINE:
		T_U BEGIN_CURLY RESTRICTED_CONTENT END_CURLY
		;

FIGURE:
		BEGIN_FIGURE FIG_CONTENT END_FIGURE
		;

FIG_CONTENT:
		FIG_CONTENT INC_GR
		| FIG_CONTENT CAP
		| FIG_CONTENT CENTERING
		|
		;

CAP:
		CAPTION BEGIN_CURLY STRING END_CURLY
		;

INC_GR:
		INCLUDE_GRAPHICS FIGURE_SPECS FIGURE_PATH
		;

FIGURE_SPECS:
		BEGIN_SQUARE DIM END_SQUARE
		|
		;

DIM:
		DIM_R FIG_ARGS
		;

DIM_R:
		DIM_R FIG_ARGS COMMA
		|
		;

FIGURE_PATH:
		BEGIN_CURLY STRING END_CURLY
		;

%%
