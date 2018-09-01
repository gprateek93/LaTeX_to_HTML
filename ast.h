#ifndef _AST_H
#define _AST_H

#include <iostream>
#include <vector>
#include <string>

using namespace std;

enum AST_Node_Type{
	SECTION_H, SUBSECTION_H, ITEMIZE_H, ENUMERATE_H, ITEM_H, TEXTBF_H, TEXTIT_H, UNDERLINE_H,
	PAR_H, LABEL_H, REF_H, TABULAR_H, FIGURE_H, INCLUDE_GRAPHICS_H, CAPTION_H, STRING_H, 
	DOCUMENT_H, ROW_H, CELL_H, MATH_H, SQRT_H, FRAC_H, SUM_H, INTG_H
};

typedef struct ast_node{
	AST_Node_Type node_type;
	string data;
	string attributes;
	vector<ast_node*> children;
}ast_node;

ast_node* new_node();
ast_node* new_node(string data);
void init_content_children();
void adopt_content_children(ast_node*);
void make_new_content();
void init_list_children();
void adopt_list_children(ast_node*);
void make_new_list();
void adopt_section_children(ast_node*);
void init_section_children();
void adopt_math_children(ast_node*);
void init_math_children();
void adopt_subsection_children(ast_node*);
void init_subsection_children();
void adopt_rows_children(ast_node*);
void init_rows_children();
void adopt_cell_children(ast_node*);
void init_cell_children();
void print(ast_node* ,int );
void init_r_content_children();
void adopt_r_content_children(ast_node*);
void make_new_r_content();
void init_figure_children();
void adopt_figure_children(ast_node*);

#endif
