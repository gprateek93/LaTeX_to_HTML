#ifndef _AST_H
#define _AST_H

#include <iostream>
#include <vector>
#include <string>

using namespace std;

enum AST_Node_Type{
	SECTION_H, SUBSECTION_H, ITEMIZE_H, ENUMERATE_H, ITEM_H, TEXTBF_H, TEXTIT_H, UNDERLINE_H,
	PAR_H, LABEL_H, REF_H, TABULAR_H, FIGURE_H, INCLUDE_GRAPHICS_H, CAPTION_H, STRING_H, DOCUMENT_H
};

typedef struct ast_node{
	AST_Node_Type node_type;
	string data;
	vector<ast_node*> children;
}ast_node;

ast_node* new_node();
ast_node* new_node(string data);

#endif
