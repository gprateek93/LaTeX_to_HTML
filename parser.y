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


stack<c_ptrs> content_stack;
stack<c_ptrs> r_content_stack;
stack<c_ptrs> list_stack;

void init_content_children(){
	content_children = new vector<ast_node*>();
}

void adopt_content_children(ast_node* current){
	//cout<<"Parent"<<current->node_type<<" Size "<<content_children->size()<<endl;
	current->children = *content_children;
	if(!content_stack.empty()){
		*content_children = content_stack.top();
		content_stack.pop();
	}
}

void make_new_content(){
	//cout<<"New content children\n";
	content_stack.push(*content_children);
	init_content_children();
}

void init_list_children(){
	list_children = new vector<ast_node*>();
}

void adopt_list_children(ast_node* current){
	//cout<<"Parent list "<<current->node_type<<" Size "<<list_children->size()<<endl;
	current->children = *list_children;
	if(!list_stack.empty()){
		*list_children = list_stack.top();
		list_stack.pop();
	}
}

void make_new_list(){
	//cout<<"New list \n";
	list_stack.push(*list_children);
	init_list_children();
}

void adopt_section_children(ast_node* current){
	current->children = *section_children;
}

void init_section_children(){
	section_children = new vector<ast_node*>();
}

void adopt_subsection_children(ast_node* current){
	current->children = *subsection_children;
}

void init_subsection_children(){
	subsection_children = new vector<ast_node*>();
}

void adopt_rows_children(ast_node* current){
	current->children = *rows_children;
}

void init_rows_children(){
	rows_children = new vector<ast_node*>();
}

void adopt_cell_children(ast_node* current){
	current->children = *cell_children;
}

void init_cell_children(){
	cell_children = new vector<ast_node*>();
}

void print(ast_node* root, int tabs){
	if(root == NULL){
		return;
	}
	for(int i=0; i<tabs; i++){
		cout<<"  ";
	}
	cout<<root->node_type<<endl;
	for(int i=0; i<root->children.size(); i++){
		print(root->children.at(i), tabs+1);
	}
}

void init_r_content_children(){
	r_content_children = new vector<ast_node*>();
}

void adopt_r_content_children(ast_node* current){
	current->children = *r_content_children;
	if(!r_content_stack.empty()){
		*r_content_children = r_content_stack.top();
		r_content_stack.pop();
	}
}

void make_new_r_content(){
	//cout<<"New content children\n";
	r_content_stack.push(*r_content_children);
	init_r_content_children();
}

%}

%union {
	char* sval;
	ast_node* node;
}

%start START

%type <node> S LIST UNDERLINE TEXTIT TEXTBF TABLE SEC OL UL RESTRICTED_TEXTBF RESTRICTED_TEXTIT RESTRICTED_UNDERLINE ROW DOW
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
%token DOLLAR SUMMATION MATH_STRING INTEGRAL FRACTION SQUARE_ROOT SUPERSCRIPT SUBSCRIPT

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
		{
			$$ = new_node();
			$$->node_type = DOCUMENT_H;
			adopt_section_children($$);
		}	
		;

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
SEC:
<<<<<<< HEAD
		SECTION HEADING CONTENT {/*cout<<"Sec reduced\n";*/ ;}
		| SECTION HEADING CONTENT SUBSEC {/*cout<<"SEC SUBSEC\n";*/ ;}
=======
		SECTION CONTENT
=======
DUMMY:	{
=======
NC:		{
>>>>>>> AST now includes- Section, Subsection, List, Content
=======
NC:		
		{
>>>>>>> AST now includes Tabular
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
<<<<<<< HEAD
		SECTION DUMMY CONTENT
>>>>>>> Fixed bugs, Limited Working AST complete
=======
		SECTION NC CONTENT
>>>>>>> AST now includes- Section, Subsection, List, Content
		{
			ast_node* temp = new_node();
			adopt_content_children(temp);
			temp->node_type = SECTION_H;
			section_children->push_back(temp);
		}
		| SECTION NC CONTENT SUBSEC
		{
			ast_node* temp = new_node();
			adopt_content_children(temp);
			temp->node_type = SECTION_H;	
			for(int i=0; i<subsection_children->size();i++){
				temp->children.push_back(subsection_children->at(i));
			}
			section_children->push_back(temp);
			init_subsection_children();
		}
>>>>>>> Added AST files. Added AST actions for List, Content, Items. Updated Main and makefile
		;
SUBSEC:
<<<<<<< HEAD
<<<<<<< HEAD
		SUBSEC SUBSECTION HEADING CONTENT
		| SUBSECTION HEADING CONTENT
		;
HEADING:
		BEGIN_CURLY RESTRICTED_CONTENT END_CURLY {/*cout << "heading" << endl;*/;}
		| 										{/*cout << "no heading" << endl;*/; }
=======
		SUBSEC SUBSECTION DUMMY CONTENT
=======
		SUBSEC SUBSECTION NC CONTENT
>>>>>>> AST now includes- Section, Subsection, List, Content
		{
			ast_node* temp = new_node();
			temp->node_type = SUBSECTION_H;
			adopt_content_children(temp);
			subsection_children->push_back(temp);
		}
		| SUBSECTION NC CONTENT
		{
			ast_node* temp = new_node();
			temp->node_type = SUBSECTION_H;
			adopt_content_children(temp);
			subsection_children->push_back(temp);
		}
>>>>>>> Fixed bugs, Limited Working AST complete
		;

LIST:
		OL
		| UL
		;

OL:
<<<<<<< HEAD
<<<<<<< HEAD
		BEGIN_ENUMERATE {/*cout<<"Begin OL\n";*/;}
		ITEMS
		END_ENUMERATE {/*cout<<"End OL\n";*/ ;}
		;

UL:
		BEGIN_ITEMIZE {/*cout<<"Begin UL\n";*/;}
		ITEMS
		END_ITEMIZE {/*cout<<"End UL\n";*/ ;}
=======
		BEGIN_ENUMERATE ITEMS END_ENUMERATE 
=======
		BEGIN_ENUMERATE NL ITEMS END_ENUMERATE 
>>>>>>> AST now includes- Section, Subsection, List, Content
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
>>>>>>> Added AST files. Added AST actions for List, Content, Items. Updated Main and makefile
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
										//cout<<"Pushed "<<str<<endl;
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
		| CONTENT MATH
		|
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
		;

RESTRICTED_CONTENT:
<<<<<<< HEAD
		RESTRICTED_CONTENT STRING
		| RESTRICTED_CONTENT RESTRICTED_TEXTBF
		| RESTRICTED_CONTENT RESTRICTED_TEXTIT
		| RESTRICTED_CONTENT RESTRICTED_UNDERLINE
		| RESTRICTED_CONTENT MATH
=======
		RESTRICTED_CONTENT STRING 					{
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

>>>>>>> AST now includes Tabular
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
		;

FIG_CONTENT:
		FIG_CONTENT INC_GR
		| FIG_CONTENT CAP
		| FIG_CONTENT CENTERING
		|
		;

CAP:
		CAPTION BEGIN_CURLY RESTRICTED_CONTENT END_CURLY
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

MATH:
		DOLLAR MATH_CONTENT DOLLAR {/*cout << " We Love Math!" << endl;*/;}
		;

MATH_CONTENT:
		MATH_CONTENT MATH_STRING
		| MATH_CONTENT SUM
		| MATH_CONTENT INTG
		| MATH_CONTENT FRAC
		| MATH_CONTENT SQRT
		|
		;
SUM:
		SUMMATION SUBSCRIPT BEGIN_CURLY MATH_CONTENT END_CURLY SUPERSCRIPT BEGIN_CURLY MATH_CONTENT END_CURLY
		;
INTG:
		INTEGRAL SUBSCRIPT BEGIN_CURLY MATH_CONTENT END_CURLY SUPERSCRIPT BEGIN_CURLY MATH_CONTENT END_CURLY
		;
FRAC:
		FRACTION BEGIN_CURLY MATH_CONTENT END_CURLY BEGIN_CURLY MATH_CONTENT END_CURLY
		;
SQRT:
		SQUARE_ROOT BEGIN_CURLY MATH_CONTENT END_CURLY
		;
%%
