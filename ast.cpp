#include <string>
#include <vector>
#include <stack>
#include "ast.h"

using namespace std;

extern vector<ast_node*>* content_children;
extern vector<ast_node*>* section_children;
extern vector<ast_node*>* subsection_children;
extern vector<ast_node*>* list_children;
extern vector<ast_node*>* content_children;
extern vector<ast_node*>* r_content_children;
extern vector<ast_node*>* rows_children;
extern vector<ast_node*>* cell_children;
extern vector<ast_node*>* figure_children;
extern vector<ast_node*>* math_children;

extern stack<vector<ast_node*>> content_stack;
extern stack<vector<ast_node*>> r_content_stack;
extern stack<vector<ast_node*>> list_stack;

ast_node* new_node(){
	ast_node* temp = new ast_node;
	return temp;
}

ast_node* new_node(string data){
	ast_node* temp = new ast_node;
	temp->data = data;
	return temp;
}

void init_content_children(){
	content_children = new vector<ast_node*>();
}

void adopt_content_children(ast_node* current){
	current->children = *content_children;
	if(!content_stack.empty()){
		*content_children = content_stack.top();
		content_stack.pop();

	}
}

void make_new_content(){
	content_stack.push(*content_children);
	init_content_children();
}

void init_list_children(){
	list_children = new vector<ast_node*>();
}

void adopt_list_children(ast_node* current){
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

void adopt_math_children(ast_node* current){
	current->children = *math_children;
}

void init_math_children(){
	math_children = new vector<ast_node*>();
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

void init_figure_children(){
	figure_children = new vector<ast_node*>();
}

void adopt_figure_children(ast_node* current){
	current->children = *figure_children;
}