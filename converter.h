#ifndef CONVERTER_H
#define CONVERTER_H

#include "ast.h"
#include <map>
#include <set>
using namespace std;


class converter{
    private:
        map<int,string> myMapping;
        set<int> emptyTags
    public:
        converter();
        string traversal(ast_node * root);
        void printHTML(string s);
};

#endif
