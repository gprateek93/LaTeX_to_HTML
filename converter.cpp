#include "ast.h"
#include "converter.h"
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>

using namespace std;

int section_no = 0;
int subsection_no = 0;

string myString(int n){
    stringstream ss;
    ss<<n;
    return ss.str();
}

string headTitle = "<head>\n<style>\ntable {\n\tborder-collapse: collapse;\n}\ntable, th, td {\n\tborder: 1px solid black;\n}\n</style>\n<title>Latex to HTML</title>\n</head>";

converter :: converter(){
    myMapping[0] = "h1";
    myMapping[1] = "h3";
    myMapping[2] = "ul";
    myMapping[3] = "ol";
    myMapping[4] = "li";
    myMapping[5] = "strong";
    myMapping[6] = "em";
    myMapping[7] = "u";
    myMapping[8] = "br";
    myMapping[9] = "";
    myMapping[10] = "";
    myMapping[11] = "table";
    myMapping[12] = "figure";
    myMapping[13] = "img";
    myMapping[14] = "caption";
    myMapping[15] = "";
    myMapping[16] = "body";
    myMapping[17] = "tr";
    myMapping[18] = "td";
}

string converter :: traverseSection(ast_node * root, int type){
    section_no++;
    subsection_no = 0;
    string s = "";
    s+="<"+getMapping(type)+">";
    s+=myString(section_no)+" "+root->data;
    s+="</"+getMapping(type)+">";
    s+=traverseChildren (root);
    return s;
}

string converter :: traverseSubSection(ast_node * root, int type){
    subsection_no++;
    string s = "";
    s+="<"+getMapping(type)+">";
    s+=myString(section_no)+"."+myString(subsection_no)+" "+root->data;
    s+="</"+getMapping(type)+"/>";
    s+=traverseChildren(root);
    return s;
}

string converter :: traverseList(ast_node * root, int type){
    return traverseDefault(root,type);
}

string converter :: traverseFont(ast_node * root, int type){
    return traverseDefault(root,type);
}
string converter :: traversePara(ast_node * root, int type){
    string s = "";
    s+="<"+getMapping(type)+">";
    s+="&nbsp;&nbsp;&nbsp;&nbsp;";
    s+=traverseChildren(root);
    return s;
}
string converter :: traverseAnchor(ast_node * root, int type){
    string s = "";
    return s;
}

string converter :: traverseTable(ast_node * root, int type){
    return traverseDefault(root,type);
}

string converter :: traverseImage(ast_node * root, int type){
    string s = "";
    if(type == 13){
        s+="<"+ getMapping(type)+" src = "+"\""+root->data+"\" alt = \"Image Here\" "+root->attributes+">";
        s+=traverseChildren(root);
    }
    else{
        s+=traverseDefault(root,type);
    }
    return s;
}

string converter :: traverseContent(ast_node * root, int type){
    return root->data;
}

string converter :: traverseDefault(ast_node * root, int type){
    string s = "";
    s+="<"+getMapping(type)+">";
    s+=traverseChildren(root);
    s+="</"+getMapping(type)+">";
    return s;
}

string converter :: traverseChildren(ast_node * root){
    string s = "";
    for(int i = 0; i<root->children.size(); i++){
        s+=traversal(root->children[i]);
    }
    return s;
}

string converter :: traversal(ast_node *root){
    string s = "";
    if(root){
        int type = root->node_type;
        string attributes = root->attributes;
        string data = root->data;
        switch (type) {
            case 0:
                s+= traverseSection(root,type);
                break;
            case 1:
                s+=traverseSubSection(root,type);
                break;
            case 2:
            case 3:
            case 4:
                s+=traverseList(root,type);
                break;
            case 5:
            case 6:
            case 7:
                s+=traverseFont(root,type);
                break;
            case 8:
                s+=traversePara(root,type);
                break;
            case 9:
            case 10:
                s+=traverseAnchor(root,type);
                break;
            case 11:
            case 17:
            case 18:
                s+=traverseTable(root,type);
                break;
            case 12:
            case 13:
            case 14:
                s+=traverseImage(root,type);
                break;
            case 15:
                s+=traverseContent(root,type);
                break;
            default:
                s+=traverseDefault(root,type);
        }
        //opening
        /*if(attributes.empty()){
            //cout<<f
            if(type!=15){
                s += "<"+myMapping[type]+">";
            }
        }
        else if(!attributes.empty() && emptyTags.find(type)!=emptyTags.end()){
            s+="<"+myMapping[type];
        }
        else if(!attributes.empty() && emptyTags.find(type)==emptyTags.end()){
            s+="<"+myMapping[type]+" id = #"+attributes+">";
        }
        if(type==0 || type == 1){
            if(type == 0){
                section_no++;
                subsection_no = 0;
                s+=myString(section_no);
            }
            if(type == 1){
                subsection_no++;
                s+=myString(section_no)+"."+myString(subsection_no);
            }
            s+="</"+myMapping[type]+">";
        }
        for(int i = 0; i<root->children.size(); i++){
            s += traversal(root->children[i]);
        }
        switch(type){
            case 13:
                s+=" src="+attributes;
                break;
            case 15:
                s+=data;
                break;
            default:
                ;
        }
        //ending
        if(emptyTags.find(type)==emptyTags.end()){
            if(type!=15 && type!=0 && type!=1)
            s+="</"+myMapping[type]+">";
        }
        else{
            s+=">";
        }
    }*/
    }
    return s;
 }

string converter :: getMapping(int type){
    return myMapping[type];
}

void converter :: printHTML(string s){
    ofstream cout("output.html");
    cout<<"<!DOCTYPE html>\n";
    cout<<"<html>\n";
    cout<<headTitle;
    cout<<s;
    cout<<"\n</html>";
}
