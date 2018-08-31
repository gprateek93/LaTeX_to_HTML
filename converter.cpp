#include <iostream>
#include "ast.h"
#include "converter.h"
#include <fstream>
#include <set>
using namespace std;

converter :: converter(){
    myMapping[0] = "h1";
    myMapping[1] = "h3";
    myMapping[2] = "ul";
    myMapping[3] = "ol";
    myMapping[4] = "li";
    myMapping[5] = "strong";
    myMapping[6] = "em";
    myMapping[7] = "u";
    myMapping[8] = "p";
    myMapping[9] = ""
    myMapping[10] =
    myMapping[11] = "table";
    myMapping[12] = "figure";
    myMapping[13] = "img";
    myMapping[14] = "caption";
    myMapping[15] = "";
    myMapping[16] = "body";
    myMapping[17] = "tr";
    myMapping[18] = "td";
    emptyTags.insert(13);
}

string converter :: traversal(ast_node *root){
    string s = "";
    if(root){
        int type = root->node_type;
        string attributes = root->attr;
        string data = root->data;
        //opening
        if(!attributes){
            s += "<"+myMapping[type]+">";
        }
        else if(attributes && emptyTags.find(type)!=emptyTags.end()){
            s+="<"+myMapping[type];
        }
        else if(attributes && emptyTags.find(type)==emptyTags.end()){
            s+="<"+myMapping[type]+" id = #"+attributes+">";
        }
        for(int i = 0; i<root->children.size(); i++){
            s+=traversal(root->children[i]);
        }
        switch(type){
            case 13:
                s+=" src="+attributes;
                break;
            case 15:
                s+=data;
                break;
            default:
                //chirag will tell :P
        }
        //ending
        if(emptyTags.find(type)==emptyTags.end()){
            if(type!=15)
            s+="</"+myMapping[type]+">";
        }
        else{
            s+=">";
        }
    }
    return s;
}

void converter :: printHTML(string s){
    ofstream cout("output.html");
    cout<<"!DOCTYPE html>\n";
    cout<<"<html>\n";
    cout<<s;
    cout<<"</html>";
}
