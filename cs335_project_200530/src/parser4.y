%{
#include<bits/stdc++.h>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <vector>
#include <iostream>
#include <fstream>
#include "./argparse/argparse.hpp"
using namespace std;
#define ull unsigned long long

extern int yylex();
extern int yyparse();
int line = 0;
int root = -1;
void yyerror(const char* s);
int fornum = 1, whilenum = 1, ifelse = 1;

uint countnode = 0;
string OutputFileName = "out.dot";
map<int, pair<string, vector<int> >> tree;
map<int, string> additionalInfo;
map<int, int> LineNumber;
map<int, int> parent;
map<int, string> scope;
map<int, vector<int>> backlist;


string var = "";

string stname = "program";
string mname;
string sttype;
int stline;
ull stsize = 8;
ull stoffset = 0;
ull prevoffset = 0;
vector<string> stmodifiers;
string stwhat;
vector<string> parameters;
int stisArray = 0;
vector<int> stndim;
int flag = 0;

typedef struct sym_entry{
	string type;
    int line = 0;
	ull size = 0;
	ull offset = 0;
    vector<string> modifiers;
    string what;
    string scope;
    int isArray;
    vector<int> ndim;
    vector<string> parameters;
}sym_entry;


typedef map<string, sym_entry* > sym_table;
string curr_table = "null";
map<string, sym_table> table;
map<string, string> parent_table;
vector<string> key_words = {"abstract","continue","for","new","switch","assert","default","if","package","synchronized","boolean","do","goto","private","this","break","double","implements","protected","throw","byte","else","import","public","throws","case","enum","instanceof","return","transient","catch","extends","int","short","try","String","char","final","interface","static","void","class","finally","long","strictfp","volatile","const","float","native","super","while","_","exports","opens","requires","uses","module","permit","sealed","var","non-sealed","provides","to","with","open","record","transitive","yield"}; 
map<string, int> keywords;

int makenode( string name){
    countnode++;
    vector<int> childs;
    tree[countnode] = {name, childs};
    backlist[countnode] = {};
    return countnode;
}
int makenode( string name, string type){
    countnode++;
    vector<int> childs;
    tree[countnode] = {name, childs};
    additionalInfo[countnode] = type;
    LineNumber[countnode] = line;
    backlist[countnode] = {};
    return countnode;
}

string customtypeof(int id){
    
    string temp = scope[id];
	while(temp != "null"){
        auto it = table[temp].find(tree[id].first);
        if(it!=table[temp].end()) return table[temp][tree[id].first]->type;
		else{
		temp = parent_table[temp];}
	}
    return "null";
}

int getLineOf(int id){
    
    string temp = scope[id];
	while(temp != "null"){
        auto it = table[temp].find(tree[id].first);
        if(it!=table[temp].end()) return table[temp][tree[id].first]->line;
		else{
		temp = parent_table[temp];}
	}
    return 0;
}

vector<string> getParamsOf(int id){
    
    string temp = scope[id];
	while(temp != "null"){
        auto it = table[temp].find(tree[id].first);
        if(it!=table[temp].end()) return table[temp][tree[id].first]->parameters;
		else{
		temp = parent_table[temp];}
	}
    return vector<string>();
}

vector<int> getDim(int id){
    string temp = scope[id];
    while(temp != "null"){
        auto it = table[temp].find(tree[id].first);
        if(it!=table[temp].end()) return table[temp][tree[id].first]->ndim;
        else{
        temp = parent_table[temp];}
    }
    return {};
}

int getSize(string id){
  if(id == "char") return sizeof(char);
  if(id == "short") return sizeof(short);
  if(id == "int") return sizeof(int);
  if(id == "float") return sizeof(float);
  if(id == "double") return sizeof(double);

  return 8; // for any ptr
}

// ******************************* THREE AC CODE **********************************************
typedef struct ThreeAC {
    string op;
    string arg1;
    string arg2;
    string res;

    bool isGoto = false;
    string gotoLabel;
    string arg;
    string g = "goto";
    string label = "";
} tac;
// vector<tac*> tacVector;
map<string,  vector<tac*>> tacMap;
string currTacVec = "";
string currTacClass = "";
stack<int> loopStart;
stack<int> loopId;
stack<string> tacVecId;


string createArg(int id){
    if(tree[id].first == "FieldAccess"){
        return "_v" + to_string(id);
    }
    if(additionalInfo.find(id) != additionalInfo.end()){
        return tree[id].first ;
    }
    else return "_v" + to_string(id);
}

string createArg3(int id){
    if(additionalInfo.find(id) != additionalInfo.end()){
        return "_"+ tree[id].first ;
    }
    else return "_v" + to_string(id);
}

string createArg4(int id){
    if(additionalInfo.find(id) != additionalInfo.end()){
        return "SymbolEntry( "+ currTacClass + ", "  + tree[id].first  + ")";
    }
    else return "_v" + to_string(id);
}



void printThreeAC(){
    std::ofstream myfile;
      myfile.open ("3ac.csv");
      
     
      
    int uid = 1;
    for(auto i = tacMap.begin(); i != tacMap.end(); i++){
        currTacVec =  i->first ;
        myfile << ","+ currTacVec + ": \n";
        uid++;
        for(int i = 0; i < tacMap[currTacVec].size(); i++){
            if(tacMap[currTacVec][i] -> isGoto == true){
               myfile <<"      t" + to_string(uid) + "_" +  to_string(i)  + ": ," + tacMap[currTacVec][i] -> gotoLabel + ",  " + tacMap[currTacVec][i] -> arg+ ",  " << tacMap[currTacVec][i] -> g +",  " + "t"  + to_string(uid) + "_" + tacMap[currTacVec][i] -> label + "\n";
                continue;
            }
            myfile <<"      t" + to_string(uid) + "_" +  to_string(i)  + ": ," + tacMap[currTacVec][i] -> op + ",  " + tacMap[currTacVec][i] -> arg1 + "  " + tacMap[currTacVec][i] -> arg2 + " , " +tacMap[currTacVec][i] -> res + "\n";
        }
    }
     myfile.close();
}

tac* createTac2(int id){
    vector<int> temp = tree[id].second;
    tac *t = new tac();
    t -> op = tree[temp[1]].first;
    t -> res = "_v" + to_string(id);
    t -> arg1 = createArg(temp[0]);
    t -> arg2 = createArg(temp[2]);
    return t;
}

tac* createTac1(int id){
    vector<int> temp = tree[id].second;
    tac* t = new tac();
    t -> op = tree[temp[1]].first;
    t -> res = createArg(temp[0]);
    t -> arg1 = createArg(temp[2]);
    return  t;
}

tac* createTacCustom(string op, string arg1, string arg2, string res){
    tac* t = new tac();
    t -> op = op;
    t -> arg1 = arg1;
    t -> arg2 = arg2;
    t -> res = res;
    return t;
}

tac* createTac1Dplus(int id){
    vector<int> temp = tree[id].second;
    tac* t1 = new tac();
    t1 -> op = tree[temp[0]].first;
    t1 -> arg1 = createArg(temp[1]);
    t1 -> res = createArg(temp[1]);
    tacMap[currTacVec].push_back(t1);
    tac* t = new tac();
    t -> op = "=";
    t -> arg1 = createArg(temp[1]);
    t -> res = createArg(id);
    return  t;
}

void createTac2Dplus(int id){
    vector<int> temp = tree[id].second;
    tac* t = new tac();
    t -> op = "=";
    t -> arg1 = createArg(temp[0]);
    t -> res = createArg(id);
    tacMap[currTacVec].push_back(t);
    tac* t1 = new tac();
    t1 -> op = tree[temp[1]].first;
    t1 -> arg1 = createArg(temp[0]);
    t1 -> res = createArg(temp[0]);
    tacMap[currTacVec].push_back(t1);
    return ;
}

tac* createTacGoto(string label){
    tac* t = new tac();
    t -> isGoto = true;
    t -> label = label;
    tacMap[currTacVec].push_back(t);
    return  t;
}

tac* createTacGotoL(string gotoLabel, string arg, string label){
    tac* t = new tac();
    t -> isGoto = true;
    t -> gotoLabel = "ifFalse";
    t -> arg = arg;
    t -> label = label;
    tacMap[currTacVec].push_back(t);
    return  t;
}


void backpatch(int n, int id){
    
    for(auto i : backlist[id]){
        tacMap[currTacVec][i]->label = to_string(n);
    }
    return;
}

void ThreeACHelperFunc(int id){
    // cout << tree[id].first << " " << id << endl;
    int childcallistrue = 1;
    vector<int> temp = tree[id].second;
    if(tree[id].first == "ClassDeclaration"){
        currTacClass = tree[temp[2]].first;
        tacVecId.push(currTacClass + ".");
        currTacVec = tacVecId.top();
    }
    if(tree[id].first == "ConstructorDeclaration"){
        childcallistrue = 0;
        currTacVec = currTacClass + ".Constructor";
        tacVecId.push(currTacVec);
        ThreeACHelperFunc(temp[1]);
        ThreeACHelperFunc(temp[2]);
         tac* t = createTacCustom("EndConstructor", "", "",tree[temp[0]].first);
        tacMap[currTacVec].push_back(t);     
    }
    if(tree[id].first == "ConstructorDeclarator"){
        if(tree[temp[1]].first == "("){
            childcallistrue = 0;
            tac* t = createTacCustom("BeginFunc", "", "","");
            tacMap[currTacVec].push_back(t);
            tac* t1 = createTacCustom("=", "popparam", "",createArg(id));
            tacMap[currTacVec].push_back(t1);
            ThreeACHelperFunc(temp[2]);
        }
    }
    if(tree[id].first == "FieldAccess"){
        if(tree[temp[1]].first == "."){
            childcallistrue = 0;
            ThreeACHelperFunc(temp[2]);
            tac* t = createTacCustom("=", createArg4(temp[2]), "", "_v" + to_string(id));
            tacMap[currTacVec].push_back(t);
        }
    }
    if(tree[id].first == "FormalParameterList"){
        childcallistrue = 0;
        if(tree[temp[0]].first == "FormalParameterList"){
            ThreeACHelperFunc(temp[2]);
            vector<int> temp1 = tree[temp[2]].second;
            tac* t = createTacCustom("popparam", "", "", createArg3(temp1[2]));
            tacMap[currTacVec].push_back(t);
            ThreeACHelperFunc(temp[0]);
        }
        else{
            ThreeACHelperFunc(temp[2]);
             vector<int> temp1 = tree[temp[2]].second;
            tac* t = createTacCustom("=","popparam", "", createArg3(temp1[2]));
            tacMap[currTacVec].push_back(t);
            ThreeACHelperFunc(temp[0]);
            temp1 = tree[temp[0]].second;
            tac* t1 = createTacCustom("=","popparam",  "", createArg3(temp1[2]));
            tacMap[currTacVec].push_back(t1);
        }
    }

    if(tree[id].first == "ReturnStatement"){
        childcallistrue = 0;
        ThreeACHelperFunc(temp[1]);
        tac* t = new tac();
        t -> op = "Return";
        t -> arg1 = createArg(temp[1]);
        tacMap[currTacVec].push_back(t);
        return;        
    }
    if(tree[id].first == "assertStatement"){
        childcallistrue = 0;
        ThreeACHelperFunc(temp[1]);
        tac* t = new tac();
        t -> op = "Assert";
        t -> arg1 = createArg(temp[1]);
        tacMap[currTacVec].push_back(t);
        return;        
    }
    if(tree[id].first == "forStmt" || tree[id].first == "forStmtNoShortIf"){
        childcallistrue = 0;
        int blockId = -1, incId = -1, forStatelabel = -1;
        for(int i = 0; i < temp.size(); i++){
            if(tree[temp[i]].first == "(" && tree[temp[i+2]].first == ";"){ThreeACHelperFunc(temp[i+1]);}
            if(tree[temp[i]].first == ";" && tree[temp[i+2]].first == ";" && tree[temp[i+1]].first != ""){ 
                ThreeACHelperFunc(temp[i+1]);
                forStatelabel = tacMap[currTacVec].size()-1;
                createTacGotoL("ifFalse", tacMap[currTacVec][forStatelabel] -> res, "");
                backlist[id].push_back(tacMap[currTacVec].size()-1);
            }
            if(tree[temp[i]].first == ")") blockId = temp[i+1];
            if(tree[temp[i]].first == ";" && tree[temp[i+2]].first == ")") incId = temp[i+1];
        }
        if(forStatelabel == -1) forStatelabel = tacMap[currTacVec].size(); // if there is no condition  in for loop goto block
        loopStart.push(forStatelabel); loopId.push(id);
        if(blockId != -1) ThreeACHelperFunc(blockId);
        if(incId != -1) ThreeACHelperFunc(incId);
        createTacGoto(to_string(forStatelabel));
        loopStart.pop(); loopId.pop();
        // backpatch End of for loop
        backpatch(tacMap[currTacVec].size(), id);
    }
    if(tree[id].first == "whileStmt" || tree[id].first == "whileStmtNoShortIf"){
        childcallistrue = 0;
        int blockId = -1, incId = -1, whileStatelabel = -1;
        for(int i = 0; i < temp.size(); i++){
            if(tree[temp[i]].first == "(" && tree[temp[i+2]].first == ")" && tree[temp[i+1]].first != ""){ 
                ThreeACHelperFunc(temp[i+1]);
                whileStatelabel = tacMap[currTacVec].size()-1;
                createTacGotoL("ifFalse", tacMap[currTacVec][whileStatelabel] -> res, "");
                backlist[id].push_back(tacMap[currTacVec].size()-1);
            }
            if(tree[temp[i]].first == ")") blockId = temp[i+1];
        }
        if(whileStatelabel == -1) whileStatelabel = tacMap[currTacVec].size(); // if there is no condition  in for loop goto block
        loopStart.push(whileStatelabel); loopId.push(id);
        if(blockId != -1) ThreeACHelperFunc(blockId);
        createTacGoto(to_string(whileStatelabel));
        loopStart.pop(); loopId.pop();
        // backpatch End of for loop
        backpatch(tacMap[currTacVec].size(), id);
    }
    if(tree[id].first == "continue"){
        childcallistrue = 0;
        createTacGoto(to_string(loopStart.top()));
    } 
    if(tree[id].first == "break"){
        childcallistrue = 0;
        createTacGoto("");
        backlist[loopId.top()].push_back(tacMap[currTacVec].size() - 1);
    } 
    if(tree[id].first == "ifThenElseStmt" || tree[id].first == "ifThenStmt" || tree[id].first == "ifThenElseStmtNoShortIf"){
        childcallistrue = 0;
         int blockId1 = -1, ifStatelabel = -1, blockId2 = -1;
         for(int i = 0; i < temp.size(); i++){
            if(tree[temp[i]].first == "(" && tree[temp[i+2]].first == ")" && tree[temp[i+1]].first != ""){
                ThreeACHelperFunc(temp[i+1]);
                ifStatelabel = tacMap[currTacVec].size()-1;
                createTacGotoL("ifFalse", tacMap[currTacVec][ifStatelabel] -> res, "");
                backlist[id].push_back(tacMap[currTacVec].size()-1);
            }
            if(tree[temp[i]].first == ")" && tree[temp[i]].first != "") blockId1 = temp[i+1];
            if(tree[temp[i]].first == "else" && tree[temp[i]].first != "") blockId2 = temp[i+1];
        }
        if(blockId1 != -1) ThreeACHelperFunc(blockId1);
        int elseid = tacMap[currTacVec].size()-1;
        createTacGoto("");
        backlist[elseid].push_back(tacMap[currTacVec].size()-1);
        backpatch(tacMap[currTacVec].size(), id);
        if(blockId2 != -1) ThreeACHelperFunc(blockId2);
        backpatch(tacMap[currTacVec].size(), elseid);
    }
    if(tree[id].first == "ConditionalExpression"){
        childcallistrue = 0;
        int blockId1 = -1, ifStatelabel = -1, blockId2 = -1;
         for(int i = 0; i < temp.size(); i++){
            if(tree[temp[i]].first == "?"  && tree[temp[i-1]].first != ""){
                ThreeACHelperFunc(temp[i-1]);
                ifStatelabel = tacMap[currTacVec].size()-1;
                createTacGotoL("ifFalse", tacMap[currTacVec][ifStatelabel] -> res, "");
                backlist[id].push_back(tacMap[currTacVec].size()-1);
            }
            if(tree[temp[i]].first == "?" && tree[temp[i+1]].first != "") blockId1 = temp[i+1];
            if(tree[temp[i]].first == ":" && tree[temp[i+1]].first != "") blockId2 = temp[i+1];
        }
        if(blockId1 != -1) ThreeACHelperFunc(blockId1);
        tac* t = createTacCustom("=", createArg(temp[2]), "", createArg(id));
        tacMap[currTacVec].push_back(t);

        int elseid = tacMap[currTacVec].size()-1;
        createTacGoto("");
        backlist[elseid].push_back(tacMap[currTacVec].size()-1);
        backpatch(tacMap[currTacVec].size(), id);
        if(blockId2 != -1) ThreeACHelperFunc(blockId2);
        tac* t1 = createTacCustom("=", createArg(temp[4]), "", createArg(id));
        tacMap[currTacVec].push_back(t1);
        backpatch(tacMap[currTacVec].size(), elseid);

    }
    if(tree[id].first == "ArrayAccess"){
        childcallistrue = 0;
        vector<string> tempVec;
        string ArrayName = "";
        int nodeNum = id;
        int tempId = -1;
        while(tree[nodeNum].first == "ArrayAccess"){
            vector<int> ArrayAccessChild = tree[nodeNum].second;
            tempId = ArrayAccessChild[2];
            if(tree[ArrayAccessChild[0]].first == "ArrayAccess"){
                ThreeACHelperFunc(ArrayAccessChild[2]);
                 tempVec.push_back(createArg(ArrayAccessChild[2]));
            }
            else{
                ArrayName = tree[ArrayAccessChild[0]].first;
                ThreeACHelperFunc(ArrayAccessChild[2]);
                tempVec.push_back(createArg(ArrayAccessChild[2]));
            }
            nodeNum = ArrayAccessChild[0];
        }
        string tempIds = "_v" + to_string(tempId);
        //ToBeChecked
        vector<int> dims ;
        tac* t = createTacCustom("=", tempVec[tempVec.size()-1], "",tempIds);
        tacMap[currTacVec].push_back(t);
        for(int l = dims.size()-1; l > 0; l--){
            tac* t = createTacCustom("*", tempIds, to_string(dims[l]),tempIds);
            tacMap[currTacVec].push_back(t);
            tac* t1 = createTacCustom("+", tempIds, tempVec[l-1],tempIds);
            tacMap[currTacVec].push_back(t1);
        }
        tac* t2 = createTacCustom( "=" ,ArrayName + "[" + tempIds + "]","", createArg(id));
        tacMap[currTacVec].push_back(t2);

    }
    if(tree[id].first == "ArrayInitializer"){
        childcallistrue = 0;


    }
    if(tree[id].first == "UnaryExpression"){
        childcallistrue = 0;
        if(temp.size() == 2){
            ThreeACHelperFunc(temp[1]);
            tac* t = createTacCustom(tree[temp[0]].first, createArg(temp[1]), "", createArg(id));
            tacMap[currTacVec].push_back(t);
        }
    }
    if(tree[id].first == "UnaryExpressionNot+-"){
        childcallistrue = 0;
        if(temp.size() == 2){
            ThreeACHelperFunc(temp[1]);
            tac* t = createTacCustom(tree[temp[0]].first, createArg(temp[1]), "", createArg(id));
            tacMap[currTacVec].push_back(t);
        }
    }
    if(tree[id].first == "MethodDeclaration"){
        childcallistrue = 0;
        if(temp.size() >= 2){
            ThreeACHelperFunc(temp[0]);
            ThreeACHelperFunc(temp[1]);
            tac* t = createTacCustom("EndFunc", "", "","");
            tacMap[currTacVec].push_back(t);
            tacVecId.pop();
            currTacVec = tacVecId.top();
            
        }
    }
    if(tree[id].first == "MethodDeclarator"){
        if(tree[temp[1]].first == "("){
            childcallistrue = 0;
            currTacVec = currTacClass + "."+ tree[temp[0]].first;
            tacVecId.push(currTacVec);
            string paraOffSet = "n";
            tac* t = createTacCustom("BeginFunc", "", "","");
            tacMap[currTacVec].push_back(t);
            if(tree[temp[2]].first != ")"){
                ThreeACHelperFunc(temp[2]);
            }
        }
    }
    
    if(tree[id].first == "MethodInvocation"){
        childcallistrue = 0;
        for(int i = 0; i < temp.size(); i++){
            if(tree[temp[i]].first == "(") {
                if(tree[temp[i+1]].first != ""){
                    ThreeACHelperFunc(temp[i+1]);
                }
                tac* t = createTacCustom("=", "LCall", tree[temp[i-1]].first, createArg(id));
                tacMap[currTacVec].push_back(t);

                 
            }
        }
    }
    if(tree[id].first == "ClassInstanceCreationExpression"){
        childcallistrue = 0;
        for(int i = 0; i < temp.size(); i++){
            if(tree[temp[i]].first == "(") {
                if(tree[temp[i+1]].first != ""){
                    ThreeACHelperFunc(temp[i+1]);
                }
                tac* t = createTacCustom("=", "PopParam", "", "t1");
                tacMap[currTacVec].push_back(t);
                tac* t1 = createTacCustom("PushParam", "", "", "t1");
                tacMap[currTacVec].push_back(t1);
                tac* t2 = createTacCustom("=", "LCall", tree[temp[i-1]].first + ".Constructor", createArg(id));
                tacMap[currTacVec].push_back(t2);

                 
            }
        }
    }
    if(tree[id].first == "ArgumentList"){
        childcallistrue = 0;
        if(tree[temp[0]].first == "ArgumentList"){
            tac* t = createTacCustom("PushParam", "", "", createArg(temp[2]));
            tacMap[currTacVec].push_back(t);
            ThreeACHelperFunc(temp[0]);
        }
        else{
            tac* t = createTacCustom("PushParam", "", "", createArg(temp[2]));
            tacMap[currTacVec].push_back(t);
            tac* t1 = createTacCustom("PushParam", "", "", createArg(temp[0]));
            tacMap[currTacVec].push_back(t1);
        }
    }
    if(tree[id].first == "LabeledStatement" || tree[id].first == "LabeledStatementNoShortIf"){
        childcallistrue = 0;
        ThreeACHelperFunc(temp[2]);
    }

    if(childcallistrue){         
        for(int i = 0; i < temp.size(); i++){
            ThreeACHelperFunc(temp[i]);
        }
    }
    if(tree[id].first == "Expression")  tacMap[currTacVec].push_back(createTacCustom("=", createArg(temp[0]), "", createArg(id)));
    if(tree[id].first == "Assignment") tacMap[currTacVec].push_back(createTac1(id));
    if(tree[id].first == "PreIncExpression") tacMap[currTacVec].push_back(createTac1Dplus(id));
    if(tree[id].first == "PreDecExpression") tacMap[currTacVec].push_back(createTac1Dplus(id));
    if(tree[id].first == "PostIncExpression") {createTac2Dplus(id);}
    if(tree[id].first == "PostDecExpression") {createTac2Dplus(id);}
    if(tree[id].first == "ConditionalOrExpression"){tacMap[currTacVec].push_back(createTac2(id));}
    if(tree[id].first == "ConditionalAndExpression"){tacMap[currTacVec].push_back(createTac2(id));}
    if(tree[id].first == "AdditiveExpression"){tacMap[currTacVec].push_back(createTac2(id)); }
    if(tree[id].first == "MultiplicativeExpression"){tacMap[currTacVec].push_back(createTac2(id)); }
    if(tree[id].first == "RelationalExpression"){tacMap[currTacVec].push_back(createTac2(id)); }
    if(tree[id].first == "EqualityExpression"){tacMap[currTacVec].push_back(createTac2(id));}
    if(tree[id].first == "AssignmentExpression"){tacMap[currTacVec].push_back(createTac1(id));}
    if(tree[id].first == "PrimaryExpression"){tacMap[currTacVec].push_back(createTac1(id));}
    if(tree[id].first == "VariableDeclarator"){tacMap[currTacVec].push_back(createTac1(id));}
    if(tree[id].first == "InclusiveOrExpression"){tacMap[currTacVec].push_back(createTac2(id));}
    if(tree[id].first == "ExclusiveOrExpression"){tacMap[currTacVec].push_back(createTac2(id));}
    if(tree[id].first == "AndExpression"){tacMap[currTacVec].push_back(createTac2(id));}
    if(tree[id].first == "ShiftExpression"){tacMap[currTacVec].push_back(createTac2(id));} 
}
// ****************************************************************

void tempfunc1(ofstream& fout, unordered_map<int,int> &visited, int id){
    if(id == -1) return;
    if(visited.find(id)==visited.end()){
        visited[id] = 1;
        string OutL = tree[id].first;
        if(tree[id].first[0]=='"'){
            OutL.pop_back();
            OutL = '\\'+OutL + "\\" + "\"";

        }
        fout << "n"<< id << " [label=\"" << OutL << "\"]" << endl;
        vector<int> temp = tree[id].second;
        for(int i = temp.size()-1; i >=0; i--){
            if(temp[i]!=-1)
            fout << "n"<< id << "->" << "n" << temp[i] << ";" << endl;
        }
        for(int i = temp.size()-1; i >=0; i--){
            tempfunc1(fout, visited,temp[i]);
            
        }
    }
   

}




// void printSymbolTable(string curr_table){
//   	for(auto it: (table[curr_table])){
//         cout << it.first.c_str() << " ";
//         for(auto j : (it.second)->modifiers){
//             cout << j << " ";
//         }
//         cout << it.second->type.c_str() << " " << (it.second)->line << " " << (it.second)->size << " " << (it.second)->offset << " " << (it.second)->what << " " << (it.second)->isArray << " " << (it.second)->scope << "." << endl;
//   }
// }

void createEntry(string name, string temp, vector<string> modifiers, string type, int line, ull size, ull offset, string what, string scope, int isArray, vector<int> ndim){
    
    sym_entry* ent = new sym_entry();
        ent->modifiers = modifiers;
	    ent->type = type;
        ent->line = line;
	    ent->size = size;
	    ent->offset = offset;
	    ent->what = what;
        ent->scope = scope;
        ent->isArray = isArray;
        ent->ndim = ndim;
        table[name].insert(make_pair(temp, ent));
    stisArray = 0;
}

void makeSymbolTable(string name){

    sym_table new_table;
    table.insert(make_pair(name, new_table));
    parent_table.insert(make_pair(name, curr_table));
	curr_table = name;
}
int flag2 = 0;
void change(int n){
    vector<int> temp = (tree[n].second);
    
    if(temp.size() == 0){
        if(tree[n].first == "(") flag2 = 1;
        if(flag2){
        scope[n] = curr_table;}
    }
    for(int i = 0; i < temp.size(); i++){
        change(temp[i]);  
    }
}

string lookup(string id){
	string temp = curr_table;

	while(temp != "null"){
		if((table[temp]).find(id)!=(table[temp]).end()) return temp;
		temp = parent_table[temp];
	}
	return "null";
}

bool curr_lookup(string id){
    string temp = curr_table;
    if((table[temp]).find(id)!=(table[temp]).end()) return 1;
    return 0;
}

bool scope_lookup(string id, string scope){
    string temp = scope;
    if((table[temp]).find(id)!=(table[temp]).end()) return 1;
    return 0;
}

void setSize(string id, int len){
    string temp = curr_table;
	while(temp != "null"){
		if((table[temp]).find(id)!=(table[temp]).end()){
            table[temp][id]->size = len;
            return;
        }
        else{
		temp = parent_table[temp];}
	}
	return;
}

void assignSize(int n, int flag){
    vector<int> temp = tree[n].second;
    if(additionalInfo[temp[0]] == "identifier"){
    string type = customtypeof(temp[0]);
    if(flag == 0){
    if(type == "String"){
        int len = (tree[temp[2]].first).length()-2;
        setSize(tree[temp[0]].first,len);
    }
    string scope = lookup(tree[temp[0]].first);
    vector<string> mod = table[scope][tree[temp[0]].first]->modifiers;
    auto it = find(mod.begin(), mod.end(), "final");
    if(it != mod.end()) {
        cout << "cannot assign a value to a final variable " << tree[temp[0]].first << endl;
        exit(1);
    }
    }
    else if(flag == 1){
       if(type == "String"){
        int len = (tree[(tree[temp[2]].second)[0]].first).length()-2;
        setSize(tree[(tree[temp[2]].second)[0]].first,len);
    } 
    }
    }
}

void arraySize(int n){
    // cout << var << endl;
    int count = 1;
    int n1 = n;
    while(tree[n1].first == "VariableInitializers"){
        n1 = (tree[n1].second)[0];
        count++;
    }
    (table[curr_table][var])->ndim.push_back(count);
    if(tree[n1].first == "ArrayInitializer"){
        arraySize((tree[n1].second)[1]);
    }
    return;
}

void symTable(int n){

    vector<int> temp = (tree[n].second);
    if(temp.size() == 0)  {

        if(additionalInfo[n] == "modifier"){
            stmodifiers.push_back(tree[n].first);
        }
        else if(additionalInfo[n] == "type" || additionalInfo[n] == "referencetype"){
            if(tree[parent[n]].first == "ArrayType"){
                stisArray = 1;
                sttype = tree[n].first;
                int n1 = n;
                while(tree[parent[n1]].first == "ArrayType"){
                sttype += "[]";
                n1 = parent[n1];
                }
            }
            else{
                sttype = tree[n].first;
            }
            
            stsize = getSize(tree[n].first);
            if(flag == 1){
                parameters.push_back(sttype);
            }
        }
        else if(additionalInfo[n] == "identifier" && (tree[parent[n]].first == "VariableDeclarator" || tree[parent[n]].first == "VariableDeclarators"  || tree[parent[n]].first == "MethodDeclarator" || tree[parent[n]].first == "ClassDeclaration" || tree[parent[n]].first == "FormalParameter" || tree[parent[n]].first == "LocalVariableDeclaration" || tree[parent[n]].first == "FieldDeclaration" || tree[parent[n]].first == "VariableDeclaratorId")){
            stname = tree[n].first;
            if(!scope_lookup(stname, curr_table)){
                if(tree[parent[n]].first == "VariableDeclaratorId"){
                    stisArray = 1;
                int n1 = n;
                while(tree[parent[n1]].first == "VariableDeclaratorId"){
                sttype += "[]";
                n1 = parent[n1];
                }
                }
            createEntry(curr_table, stname, stmodifiers, sttype, LineNumber[n], stsize, stoffset, stwhat, curr_table, stisArray, stndim);
            stisArray = 0;
            }
            else{
                cout << "Variable " << stname << " already declared !!" << endl;
                exit(1);
            }
            stmodifiers.clear();
        }
        if(tree[n].first == "{" && (tree[parent[n]].first == "ClassBody")){
            makeSymbolTable(stname);
        }
        else if(tree[n].first == "(" && (tree[parent[n]].first == "forStmt")){
            stname = "for" + to_string(fornum);
            fornum++;
            makeSymbolTable(stname);
        }
        else if(tree[n].first == "{" && (tree[parent[parent[n]]].first == "whileStmt")){
            stname = "while" + to_string(whilenum);
            whilenum++;
            makeSymbolTable(stname);
        }
        else if(tree[n].first == "{" && (tree[parent[parent[n]]].first == "ifThenElseStmt")){
            stname = "ifelse" + to_string(ifelse);
            ifelse++;
            makeSymbolTable(stname);
        }
        else if(tree[n].first == "(" && ( tree[parent[n]].first == "MethodDeclarator")){
            flag = 1;
            mname = stname;
            makeSymbolTable(stname);
        }
        else if(tree[n].first == ")" && ( tree[parent[n]].first == "MethodDeclarator")){
            flag = 0;
            string oname = mname;
            sym_table new_table = table[mname];

            table.erase(mname);

            mname += "( ";
            for(auto i : parameters){
                mname += i;
                mname += ",";
            }
            mname.pop_back();
            mname += ")";
           
            if(table.find(mname) != table.end()){
                cout << "Method " << mname << " already declared !!" << endl;
                exit(1);
            }
            else{
            table.insert(make_pair(mname, new_table));}
            for(auto it : table[mname]){
                (it.second)->scope = mname;
            }

            string par = parent_table[oname];
            parent_table.erase(oname);
            parent_table.insert(make_pair(mname,par));

            table[par][oname]->parameters = parameters;

            curr_table = mname;
            flag2 = 0;
            change(parent[n]);
            parameters.clear();

        }
        else if(tree[n].first == "}" && (tree[parent[n]].first == "ClassBody" || tree[parent[n]].first == "Block" )){
            curr_table = parent_table[curr_table];
        }
    
        scope[n] = curr_table;
    }
    for(int i = 0; i < temp.size(); i++){
        if(tree[n].first == "ClassDeclaration"){
            stwhat = "class";
        }
        else if(tree[n].first == "MethodDeclaration"){
            stwhat = "method";
        }
        else if(tree[n].first == "FieldDeclaration" || tree[n].first == "LocalVariableDeclaration" || tree[n].first == "FormalParameter"){
            stwhat = "variable";
        }
        

        symTable(temp[i]);  
    }
}

void checkMethodCall(int n){
    vector<int> temp = (tree[n].second);
    // if(tree[temp[0]].first == "QualifiedName"){
    //     if(tree[(tree[temp[0]].second)[0]].first!= "QualifiedName" && !scope_lookup(tree[(tree[temp[0]].second)[2]].first)){
    //         cout << "Method " << tree[(tree[temp[0]].second)[0]].first << " not declared in line " << LineNumber[temp[0]] << "!!" << endl;
    //     }
    // }
    if(additionalInfo[temp[0]] == "identifier"){
    if(lookup(tree[temp[0]].first) == "null") 
    {
        cout << "Method " << tree[temp[0]].first << " not declared in line " << LineNumber[temp[0]] << "!!" << endl;
        exit(1);
    }
    }
    return;
}


void checkScope(int n){
    vector<int> temp = (tree[n].second);
    // cout << tree[n].first << endl;
    if(temp.size() == 0)  {
        
        if(tree[n].first == "{" && (tree[parent[n]].first == "ClassBody")){
            curr_table = scope[n];
        }
        else if(tree[n].first == "(" && tree[parent[n]].first == "MethodDeclarator"){
            curr_table = scope[n];
        }
        else if(tree[n].first == "}" && (tree[parent[n]].first == "ClassBody" || tree[parent[n]].first == "Block" )){
            curr_table = scope[n];
        }
        else if(tree[n].first == "(" && (tree[parent[n]].first == "forStmt")){
            curr_table = scope[n];
        }
        else if(tree[n].first == "{" && (tree[parent[parent[n]]].first == "whileStmt")){
            curr_table = scope[n];
        }
        else if(tree[n].first == "{" && (tree[parent[parent[n]]].first == "ifThenElseStmt")){
            curr_table = scope[n];
        }
        // printSymbolTable(curr_table);
        if(additionalInfo[n] == "identifier" && tree[n].first != "System" && tree[n].first != "out" && tree[n].first != "println"){
            
            if((lookup(tree[n].first)) == "null"){
                cout << tree[n].first << " not declared!!" << endl;
                exit(1);
            }
            
        }
        if(additionalInfo[n] == "referencetype"){
            if(!scope_lookup(tree[n].first, "program")){
                cout << "class " << tree[n].first << " not defined!!" << endl;
                exit(1);
            }
        }
    }
    else{
    if(tree[n].first == "MethodInvocation"){
        checkMethodCall(n);
        return;
    }
    if(tree[n].first == "Assignment"){
        assignSize(n, 0);
    }
    if(tree[n].first == "VariableDeclarator"){
        assignSize(n, 1);
        int n1 = n;
        while((tree[n1].second).size() != 0){
            n1 = (tree[n1].second)[0];
        }
        var = tree[n1].first;
    }
    if(tree[n].first == "ArrayInitializer"){
        arraySize((tree[n].second)[1]);
        int count = 1;
        // cout << (table[curr_table][var]->ndim).size() << endl;
        for(auto i : table[curr_table][var]->ndim){
            count *= i;
        }
        table[curr_table][var]->size *= count;
    }
    else if(tree[n].first == "DimExprs"){
        for(auto i : (tree[n].second)){
            int j = stoi(tree[(tree[i].second)[1]].first);
            // cout << j << endl;
        table[curr_table][var]->ndim.push_back(j);
        }
        int count = 1;
        for(auto i : table[curr_table][var]->ndim){
            count *= i;
        }
        table[curr_table][var]->size *= count;
    }
    else{
        for(int i = 0; i < temp.size(); i++){
            checkScope(temp[i]);  
        }
    }
    }
}

void setOffset(){
    for(auto i : table){
        for(auto j : i.second){
            j.second->offset = stoffset;
            stoffset += j.second->size;
        }
        stoffset = 0;
    }
}

void print(){
    symTable(root);
    curr_table = "program";
    checkScope(root);
    setOffset();
    // ***************************
    cout << "******************** Three AC Printing**************" << endl;
    ThreeACHelperFunc(root);
    printThreeAC();
    // ****************************
    ofstream fout;
    fout.open(OutputFileName);
    fout << "digraph G {" << endl;
    unordered_map<int,int> visited;
    for(auto i = tree.begin(); i!= tree.end(); i++){
        tempfunc1( fout, visited, i->first);
    }
    
   
    fout << "}" << endl; 
}

void addChild(int p, int c){
    tree[p].second.push_back(c);
    parent[c] = p;
}


void printast(struct ast* temp);


%}

%union {
    char* tit;
    struct ast* a;
    int id;
    } 


%token <tit> keywordT
%token <tit> newlineT
%token <tit> identifierT
%token <tit> IntegerLiteralT
%token <tit> FloatingPointLiteralT
%token <tit> BooleanLiteralT
%token <tit> CharacterLiteralT
%token <tit> StringLiteralT
%token <tit> NullLiteralT
%token <tit> TextBlockT
%token <tit> NEWT
%token <tit> TRYT
%token <tit> CATCHT
%token <tit> SYNCHRONIZEDT
%token <tit> FINALLYT
%token <tit> THROWT
%token <tit> THROWST
%token <tit> RETURNT
%token <tit> BREAKT
%token <tit> CONTINUET
%token <tit> IFT
%token <tit> ELSET
%token <tit> SWITCHT
%token <tit> CASET
%token <tit> FORT
%token <tit> WHILET
%token <tit> DOTT
%token <tit> CLASST
%token <tit> INSTANCEOFT
%token <tit> THIST
%token <tit> SUPERT
%token <tit> ABSTRACTT
%token <tit> ASSERTT
%token <tit> BOOLEANT
%token <tit> BYTET
%token <tit> SHORTT
%token <tit> INTT
%token <tit> LONGT
%token <tit> CHART
%token <tit> STRINGT
%token <tit> FLOATT
%token <tit> DOUBLET
%token <tit> EXTENDST
%token <tit> PACKAGET
%token <tit> IMPORTT
%token <tit> STATICT
%token <tit> MODULET
%token <tit> REQUIREST
%token <tit> EXPORTST
%token <tit> OPENST
%token <tit> OPENT
%token <tit> USEST
%token <tit> PROVIDEST
%token <tit> WITHT
%token <tit> TRANSITIVET
%token <tit> PROTECTEDT
%token <tit> PRIVATET
%token <tit> PUBLICT
%token <tit> FINALT
%token <tit> SEALEDT
%token <tit> NONSEALEDT
%token <tit> TRANSIENTT
%token <tit> VOLATILET
%token <tit> STRICTFPT
%token <tit> IMPLEMENTST
%token <tit> PERMITST
%token <tit> VOIDT
%token <tit> ENUMT
%token <tit> DEFAULTT
%token <tit> VART
%token <tit> TOT
%token <tit> YIELDT
%token <tit> INTERFACET
%token <tit> RECORDT
%token <tit> NATIVET

%token <tit> OPEN_BRACKETST
%token <tit> CLOSE_BRACKETST
%token <tit> OPEN_CURLYT
%token <tit> CLOSE_CURLYT
%token <tit> OPEN_SQT
%token <tit> CLOSE_SQT
%token <tit> SEMICOLT
%token <tit> COMMAT
%token <tit> DOOT
%token <tit> TDOTT
%token <tit> ATRT
%token <tit> DCOLT
%token <tit>  EQUALT
%token <tit>  LESST
%token <tit>  GREATERT
%token <tit>  EXCLAMATORYT
%token <tit>  TILDAT
%token <tit>  QUET
%token <tit>  COLONT
%token <tit>  IMPLIEST
%token <tit>  DEQUALT
%token <tit>  LET
%token <tit>  NEQUALT
%token <tit>  DANDT
%token <tit>  DORT
%token <tit>  DPLUST
%token <tit>  DMINUST
%token <tit>  GET
%token <tit>  PLUST
%token <tit>  MINUST
%token <tit>  MULT
%token <tit>  DIVIDET
%token <tit>  ANDT
%token <tit>  HATT
%token <tit>  MODULOT
%token <tit>  DLESST
%token <tit>  DGREATERT
%token <tit>  TGREATERT
%token <tit>  PLUS_EQUALT
%token <tit>  MINUS_EQUALT
%token <tit>  MUL_EQUALT
%token <tit>  DIVIDE_EQUALT
%token <tit>  AND_EQUALT
%token <tit>  OR_EQUALT
%token <tit>  HAT_EQUALT
%token <tit>  MODULO_EQUALT
%token <tit>  DLESS_EQUALT
%token <tit>  DGREATER_EQUALT
%token <tit>  TGREATER_EQUALT
%token <tit>  ORT
%token <tit>  LGT



%type <id> input Program ClassDeclaration SuperClass ClassType ClassBody ClassBodyDeclarations ClassBodyDeclaration 
             
%type <id> identifier          
%type <id> IntegerLiteral       
%type <id> FloatingPointLiteral 
%type <id> BooleanLiteral       
%type <id> CharacterLiteral     
%type <id> StringLiteral        
%type <id> NullLiteral          
%type <id> TextBlock  
%type <id> STRICTFP          
%type <id> NEW                                
%type <id> SYNCHRONIZED                      
%type <id> RETURN               
%type <id> BREAK                
%type <id> CONTINUE             
%type <id> IF                   
%type <id> ELSE                               
%type <id> FOR                  
%type <id> WHILE                                   
%type <id> CLASS                
%type <id> INSTANCEOF           
%type <id> THIS                 
%type <id> SUPER                
%type <id> ABSTRACT             
%type <id> ASSERT               
%type <id> BOOLEAN              
%type <id> BYTE                 
%type <id> SHORT                
%type <id> INT                  
%type <id> LONG                 
%type <id> CHAR    
%type <id> STRING               
%type <id> FLOAT                
%type <id> DOUBLE               
%type <id> EXTENDS              
%type <id> PACKAGE              
%type <id> IMPORT               
%type <id> STATIC                        
%type <id> PROTECTED            
%type <id> PRIVATE              
%type <id> PUBLIC               
%type <id> FINAL                          
%type <id> TRANSIENT            
%type <id> VOLATILE                         
%type <id> IMPLEMENTS                        
%type <id> VOID                                
%type <id> INTERFACE                         
%type <id> NATIVE               
%type <id> OPEN_BRACKETS        
%type <id> CLOSE_BRACKETS       
%type <id> OPEN_CURLY           
%type <id> CLOSE_CURLY          
%type <id> OPEN_SQ              
%type <id> CLOSE_SQ             
%type <id> SEMICOL              
%type <id> COMMA                
%type <id> DOT                                  
%type <id> EQUAL                
%type <id>  LESS                
%type <id>  GREATER             
%type <id>  EXCLAMATORY         
%type <id>  TILDA               
%type <id>  QUE                 
%type <id>  COLON                          
%type <id>  DEQUAL              
%type <id>  LE                  
%type <id>  GE                  
%type <id>  NEQUAL              
%type <id>  DAND                
%type <id>  DOR                 
%type <id>  DPLUS               
%type <id>  DMINUS              
%type <id>  PLUS                
%type <id>  MINUS               
%type <id>  MUL                 
%type <id>  DIVIDE              
%type <id>  AND                 
%type <id>  HAT                 
%type <id>  MODULO              
%type <id>  DLESS               
%type <id>  DGREATER            
%type <id>  TGREATER            
%type <id>  PLUS_EQUAL          
%type <id>  MINUS_EQUAL         
%type <id>  MUL_EQUAL           
%type <id>  DIVIDE_EQUAL        
%type <id>  AND_EQUAL           
%type <id>  OR_EQUAL            
%type <id>  HAT_EQUAL           
%type <id>  MODULO_EQUAL        
%type <id>  DLESS_EQUAL         
%type <id>  DGREATER_EQUAL      
%type <id>  TGREATER_EQUAL      
%type <id>  OR                   
%type <id> TypeName PackageName
%type <id> ExpressionStatement StatementExpression PreDecrementExpression PreIncrementExpression PostDecrementExpression PostIncrementExpression UnaryExpression UnaryExpressionNotPlusMinus CastExpression PostfixExpression Assignment AssignmentOperator LeftHandSide 
%type <id> AssignmentExpression Expression ConditionalExpression ConditionalOrExpression ConditionalAndExpression InclusiveOrExpression ExclusiveOrExpression AndExpression EqualityExpression RelationalExpression 
%type <id> ShiftExpression AdditiveExpression MultiplicativeExpression PrimitiveType NumericType IntegerType FloatingPointType Name SimpleName QualifiedName FieldAccess ArrayAccess Primary PrimaryNoNewArray
%type <id> Literal ClassInstanceCreationExpression MethodInvocation ArgumentList2 ArgumentList ReferenceType ArrayType ArrayCreationExpression Dims2 Dims DimExprs DimExpr
%type <id> ClassMemberDeclaration FieldDeclaration Modifiers1 Modifier Type VariableDeclarator VariableDeclarators VariableDeclaratorId VariableInitializer
%type <id> Block
%type <id> BlockStatements2 StaticInitializer Interfaces2 Interfaces InterfaceTypeList
%type <id> BlockStatements BlockStatement EmptyStatement LabeledStatement LabeledStatementNoShortIf AssertStatement
%type <id> Statement LocalVariableDeclaration LocalVariableDeclarationStatement 
%type <id> StatementNoShortIf StatementWithoutTrailingSubstatement IfThenStatement IfThenElseStatement IfThenElseStatementNoShortIf
%type <id> WhileStatement WhileStatementNoShortIf ForStatement ForStatementNoShortIf ForInit2 ForInit ForUpdate2 ForUpdate Expression2 StatementExpressionList BreakStatement ContinueStatement
%type <id>  ReturnStatement SynchronizedStatement ArrayInitializer VariableInitializers2 VariableInitializers 
%type <id> ConstructorBody ConstructorDeclaration ConstructorDeclarator FormalParameterList2 FormalParameterList FormalParameter 
%type <id> MethodDeclaration MethodHeader MethodDeclarator MethodBody
%type <id> InterfaceDeclaration ExtendsInterfaces ExtendsInterfaces2 InterfaceBody InterfaceMemberDeclarations2 InterfaceMemberDeclarations InterfaceMemberDeclaration ConstantDeclaration AbstractMethodDeclaration InterfaceType
%type <id> CompilationUnit PackageDeclaration2 ImportDeclarations2 TypeDeclarations2 ImportDeclarations TypeDeclarations PackageDeclaration ImportDeclaration SingleTypeImportDeclaration TypeImportOnDemandDeclaration TypeDeclaration
%start input
%%

input                   : Program {print();}
                        ;
Program                 : CompilationUnit   {int uid = makenode("Program"); root=uid; int child = makenode(""); addChild(uid,$1); addChild(uid, child); $$=$1;}
                        ;
CompilationUnit         : PackageDeclaration2 ImportDeclarations2 TypeDeclarations2     {
                                int uid = makenode("CompilationUnit"); 
                                addChild(uid, $1); 
                                addChild(uid, $2);
                                addChild(uid, $3);
                                $$=uid;
}
                        ;
PackageDeclaration2     :   {$$=-1;}
                        | PackageDeclaration {$$=$1;}
                        ;
ImportDeclarations2     :   {$$=-1;}
                        | ImportDeclarations    {$$=$1;}
                        ;
TypeDeclarations2       :   {$$=-1;}
                        | TypeDeclarations    {$$=$1;}
                        ;
ImportDeclarations      : ImportDeclaration {$$=$1;}
                        | ImportDeclarations ImportDeclaration  {int uid = makenode("ImportDeclarations"); addChild(uid, $1); addChild(uid, $2); $$=uid;}
                        ;
TypeDeclarations        : TypeDeclaration   {$$=$1;}
                        | TypeDeclarations TypeDeclaration  {int uid = makenode("TypeDeclarations"); addChild(uid, $1); addChild(uid, $2); $$=uid;}
                        ;
PackageDeclaration      : PACKAGE Name SEMICOL  {
                                int uid = makenode("PackageDeclaration"); 
                                addChild(uid, $1); 
                                addChild(uid, $2);
                                addChild(uid, $3);
                                $$=uid;
                        }
                        ;
ImportDeclaration       : SingleTypeImportDeclaration   {$$=$1;}
                        | TypeImportOnDemandDeclaration {$$=$1;}
                        ;
SingleTypeImportDeclaration   : IMPORT Name SEMICOL {
                                int uid = makenode("SingleTypeImportDeclaration"); 
                                addChild(uid, $1); 
                                addChild(uid, $2);
                                addChild(uid, $3);
                                $$=uid;
                        }
                        ;
TypeImportOnDemandDeclaration : IMPORT Name DOT MUL SEMICOL {
                                int uid = makenode("TypeImportOnDemandDeclaration"); 
                                addChild(uid, $1); 
                                addChild(uid, $2);
                                addChild(uid, $3);
                                addChild(uid, $4);
                                addChild(uid, $5);
                                $$=uid;
                        }
                        ;
TypeDeclaration         : ClassDeclaration          {$$=$1;}
                        | InterfaceDeclaration      {$$=$1;}
                        | SEMICOL                   {$$=$1;}
                        ;

ClassDeclaration        : Modifiers1 CLASS identifier SuperClass Interfaces2 ClassBody {
                                int uid = makenode("ClassDeclaration"); 
                                addChild(uid, $1); 
                                addChild(uid, $2);
                                addChild(uid, $3);
                                addChild(uid, $4);
                                addChild(uid, $5);
                                addChild(uid, $6);
                                $$=uid;
                        }
                        ;
Interfaces2             : {$$ = -1;}
                        | Interfaces {$$=$1;}
                        ;
Interfaces              : IMPLEMENTS InterfaceTypeList {
                                int uid = makenode("Interfaces"); 
                                addChild(uid, $1);
                                addChild(uid, $2);
                                $$=uid;
                        }
                        ;
InterfaceTypeList       : InterfaceType {$$=$1;}
                        | InterfaceTypeList COMMA InterfaceType {
                                int uid = makenode("InterfaceTypeList"); 
                                addChild(uid, $1);
                                addChild(uid, $2);
                                addChild(uid, $3);
                                $$=uid;
                        }
                        ;
SuperClass              : {$$ = -1;}
                        | EXTENDS ClassType {
                                int uid = makenode("SuperClass"); 
                                addChild(uid, $1);
                                addChild(uid, $2);
                                $$=uid;
                        }
                        ;
ClassType               : TypeName {$$=$1;}
                        ;
TypeName                :  identifier { $$ = $1;}
                        |  PackageName DOT identifier  {
                             int uid = makenode("TypeName");
                             addChild(uid,$1);
                             addChild(uid, $2);
                             addChild(uid, $3);
                             $$ = uid;
                        }
                        ;
PackageName             :  identifier { $$ = $1;}
                        |  PackageName DOT identifier  {
                             int uid = makenode("PackageName");
                             addChild(uid,$1);
                             addChild(uid, $2);
                             addChild(uid, $3);
                             $$ = uid;
                        }
                        ;

ClassBody               : OPEN_CURLY ClassBodyDeclarations CLOSE_CURLY {
                                int uid = makenode("ClassBody"); 
                                addChild(uid, $1);
                                addChild(uid, $2);
                                addChild(uid, $3);
                                $$=uid;
                        }
                        ;
ClassBodyDeclarations   :  {$$ = -1;}
                        | ClassBodyDeclaration ClassBodyDeclarations {int uid = makenode("ClassBodyDeclarations"); addChild(uid, $1); addChild(uid, $2); $$=uid;}
                        ;
ClassBodyDeclaration    : ClassMemberDeclaration {$$ = $1;}
                        | StaticInitializer   {$$ = $1;}
                        | ConstructorDeclaration {$$ = $1;}
                        | Block {$$ = $1;}
                        ;
ConstructorDeclaration  : Modifiers1 ConstructorDeclarator  ConstructorBody {int uid = makenode("ConstructorDeclaration"); addChild(uid, $1); addChild(uid, $2); addChild(uid, $3);  $$ = uid;}
                        ;
ConstructorDeclarator   : SimpleName OPEN_BRACKETS FormalParameterList2  CLOSE_BRACKETS         {int uid = makenode("ConstructorDeclarator"); addChild(uid, $1); addChild(uid, $2);addChild(uid, $3);addChild(uid, $4); $$ = uid;}
                        ;
ConstructorBody         : OPEN_CURLY  BlockStatements2 CLOSE_CURLY         {int uid = makenode("ConstructorBody"); addChild(uid, $1); addChild(uid, $2); addChild(uid, $3);  $$ = uid;}
                        ;

FormalParameterList2    :                                           {$$ = -1;}
                        | FormalParameterList                       {$$ = $1;}
                        ;
FormalParameterList     : FormalParameter                           {$$ = $1;}
                        | FormalParameterList COMMA FormalParameter {int uid = makenode("FormalParameterList"); addChild(uid, $1); addChild(uid, $2); addChild(uid, $3); $$ = uid;}
                        ;
FormalParameter         : Modifiers1 Type VariableDeclaratorId            {int uid = makenode("FormalParameter"); addChild(uid, $1); addChild(uid, $2);addChild(uid, $3); $$ = uid;}
                        ;
StaticInitializer       : STATIC Block                        {int uid = makenode("StaticInitializer"); addChild(uid, $1); addChild(uid, $2); $$ = uid;}
                        ; 
ClassMemberDeclaration  : FieldDeclaration {$$ = $1;} 
                        | MethodDeclaration {$$ = $1;}
                        | SEMICOL
                        ; 


MethodDeclaration       : MethodHeader MethodBody                  {int uid = makenode("MethodDeclaration"); addChild(uid, $1); addChild(uid, $2); $$ = uid;}
                        ;
MethodHeader            : Modifiers1 Type MethodDeclarator {int uid = makenode("MethodHeader"); addChild(uid, $1); addChild(uid, $2); addChild(uid, $3);  $$ = uid;}
                        | Modifiers1 VOID MethodDeclarator {int uid = makenode("MethodHeader"); addChild(uid, $1); addChild(uid, $2); addChild(uid, $3);  $$ = uid;}
                        ;
MethodDeclarator        : identifier OPEN_BRACKETS FormalParameterList2 CLOSE_BRACKETS {int uid = makenode("MethodDeclarator"); addChild(uid, $1); addChild(uid, $2); addChild(uid, $3); addChild(uid, $4); $$ = uid;}
                        | MethodDeclarator OPEN_SQ CLOSE_SQ                            {int uid = makenode("MethodDeclarator"); addChild(uid, $1); addChild(uid, $2); addChild(uid, $3); $$ = uid;}
                        ;
MethodBody              : Block                                {$$ = $1;}
                        | SEMICOL                                   {$$ = $1;}
                        ;

FieldDeclaration        : Modifiers1 Type VariableDeclarators SEMICOL       {int uid = makenode("FieldDeclaration"); addChild(uid, $1); addChild(uid,$2); addChild(uid,$3); addChild(uid,$4); $$ = uid;}
                        ;
Modifiers1              :                   {$$ = -1;}
                        | Modifier Modifiers1 {
                                int uid = makenode("Modifiers"); 
                                addChild(uid, $1);
                                addChild(uid, $2);
                                $$=uid;
                        }
                        ;
Modifier                : PUBLIC            {$$ = $1;}
                        | PROTECTED         {$$ = $1;}
                        | PRIVATE           {$$ = $1;}
                        | STATIC            {$$ = $1;}
                        | ABSTRACT          {$$ = $1;}
                        | FINAL             {$$ = $1;}
                        | NATIVE            {$$ = $1;}
                        | SYNCHRONIZED      {$$ = $1;}
                        | TRANSIENT         {$$ = $1;}
                        | VOLATILE          {$$ = $1;}
                        | STRICTFP          {$$ = $1;}
                        ;
VariableDeclarators     : VariableDeclarator                            {$$ = $1;}
                        | VariableDeclarators COMMA VariableDeclarator  {int uid = makenode("VariableDeclarators"); addChild(uid, $1); addChild(uid, $2), addChild(uid, $3); $$ = uid;}
                        ;
VariableDeclarator      : VariableDeclaratorId                           {$$ = $1;}
                        | VariableDeclaratorId EQUAL VariableInitializer {int uid = makenode("VariableDeclarator"); addChild(uid, $1); addChild(uid, $2), addChild(uid, $3); $$ = uid;}
                        ;
VariableDeclaratorId    : identifier        {$$ = $1;}
                        | VariableDeclaratorId OPEN_SQ CLOSE_SQ          {int uid = makenode("VariableDeclaratorId"); addChild(uid, $1); addChild(uid, $2), addChild(uid, $3); $$ = uid;}
                        ;
VariableInitializer     : Expression        {int uid = makenode("Expression"); addChild(uid, $1); $$ = uid;}
                        | ArrayInitializer  {$$ = $1;}
                        ;
Type                    : PrimitiveType     {$$ = $1;}
                        | ReferenceType     {$$ = $1; additionalInfo[$1] = "referencetype";}
                        ;
 

Block                   : OPEN_CURLY BlockStatements2 CLOSE_CURLY       {
                                int uid = makenode("Block"); 
                                addChild(uid, $1);
                                addChild(uid, $2);
                                addChild(uid, $3);
                                $$=uid;
}
                        ;
BlockStatements2        :                {$$ = -1;}
                        | BlockStatements   {$$ = $1;}
                        ;
BlockStatements         : BlockStatement                    {$$ = $1;}
                        | BlockStatements BlockStatement    {int uid = makenode("BlockStatements"); addChild(uid, $1); addChild(uid, $2); $$ = uid;}
                        ;
BlockStatement          : LocalVariableDeclarationStatement {$$ = $1;}
                        | Statement                         {$$ = $1;}
                        ;
LocalVariableDeclarationStatement : LocalVariableDeclaration SEMICOL    { int uid = makenode("LocalVariableDeclarationStatement"); addChild(uid, $1); addChild(uid, $2); $$ = uid;}
                        ;
LocalVariableDeclaration : Type VariableDeclarators     { int uid = makenode("LocalVariableDeclaration"); addChild(uid, $1); addChild(uid, $2); $$ = uid;}
                        ;

Statement               : StatementWithoutTrailingSubstatement  {$$ = $1;}
                        | LabeledStatement                      {$$ = $1;}
                        | IfThenStatement                       {$$ = $1;}
                        | IfThenElseStatement                   {$$ = $1;}
                        | WhileStatement                        {$$ = $1;}
                        | ForStatement                          {$$ = $1;}
                        ;
StatementNoShortIf      : StatementWithoutTrailingSubstatement  {$$ = $1;}
                        | LabeledStatementNoShortIf             {$$ = $1;}
                        | IfThenElseStatementNoShortIf          {$$ = $1;}
                        | WhileStatementNoShortIf               {$$ = $1;}
                        | ForStatementNoShortIf                 {$$ = $1;}
                        ;
StatementWithoutTrailingSubstatement : Block                {$$ = $1;}
	                    | EmptyStatement                    {$$ = $1;}
	                    | ExpressionStatement               {$$ = $1;}
	                    | BreakStatement                    {$$ = $1;}
	                    | ContinueStatement                 {$$ = $1;}
	                    | ReturnStatement                   {$$ = $1;}
	                    | SynchronizedStatement             {$$ = $1;}
                        | AssertStatement             {$$ = $1;}
                        ;
EmptyStatement          : SEMICOL                           {$$ = $1;}
                        ;
LabeledStatement        : identifier COLON Statement        { int uid = makenode("LabeledStatement"); addChild(uid, $1); addChild(uid, $2); addChild(uid, $3); $$ = uid;}
                        ;
AssertStatement         : ASSERT Expression SEMICOL        { int uid = makenode("assertStatement"); addChild(uid, $1); addChild(uid, $2); addChild(uid, $3); $$ = uid;}
                        ;
LabeledStatementNoShortIf : identifier COLON StatementNoShortIf { int uid = makenode("LabeledStatementNoShortIf"); addChild(uid, $1); addChild(uid, $2); addChild(uid, $3); $$ = uid;}
                        ;
IfThenStatement         : IF OPEN_BRACKETS Expression CLOSE_BRACKETS Statement  {
                                                        int uid =  makenode("ifThenStmt");
                                                        addChild(uid, $1);
                                                        addChild(uid, $2);
                                                        addChild(uid, $3);
                                                        addChild(uid, $4);
                                                        addChild(uid, $5);
                                                        $$ = uid;
}
                        ;
IfThenElseStatement     : IF OPEN_BRACKETS Expression CLOSE_BRACKETS StatementNoShortIf ELSE Statement {
                                                        int uid =  makenode("ifThenElseStmt");
                                                        addChild(uid, $1);
                                                        addChild(uid, $2);
                                                        addChild(uid, $3);
                                                        addChild(uid, $4);
                                                        addChild(uid, $5);
                                                        addChild(uid, $6);
                                                        addChild(uid, $7);
                                                        $$ = uid;
}
                        ;  
IfThenElseStatementNoShortIf     : IF OPEN_BRACKETS Expression CLOSE_BRACKETS StatementNoShortIf ELSE StatementNoShortIf    {
                                                        int uid =  makenode("ifThenElseStmtNoShortIf");
                                                        addChild(uid, $1);
                                                        addChild(uid, $2);
                                                        addChild(uid, $3);
                                                        addChild(uid, $4);
                                                        addChild(uid, $5);
                                                        addChild(uid, $6);
                                                        addChild(uid, $7);
                                                        $$ = uid;
}
                        ;  
WhileStatement          : WHILE OPEN_BRACKETS Expression CLOSE_BRACKETS Statement {
                                                        int uid =  makenode("whileStmt");
                                                        addChild(uid, $1);
                                                        addChild(uid, $2);
                                                        addChild(uid, $3);
                                                        addChild(uid, $4);
                                                        addChild(uid, $5);
                                                        $$ = uid;
}
                        ;
WhileStatementNoShortIf : WHILE OPEN_BRACKETS Expression CLOSE_BRACKETS StatementNoShortIf  {
                                                        int uid =  makenode("whileStmtNoShortIf");
                                                        addChild(uid, $1);
                                                        addChild(uid, $2);
                                                        addChild(uid, $3);
                                                        addChild(uid, $4);
                                                        addChild(uid, $5);
                                                        $$ = uid;
}
                        ;
ForStatement            : FOR OPEN_BRACKETS  ForInit2 SEMICOL Expression2 SEMICOL ForUpdate2 CLOSE_BRACKETS Statement {
                                                        int uid =  makenode("forStmt");
                                                        addChild(uid, $1);
                                                        addChild(uid, $2);
                                                        addChild(uid, $3);
                                                        addChild(uid, $4);
                                                        addChild(uid, $5);
                                                        addChild(uid, $6);
                                                        addChild(uid, $7);
                                                        addChild(uid, $8);
                                                        addChild(uid, $9);
                                                        $$ = uid;
}
                        ;

ForStatementNoShortIf   : FOR OPEN_BRACKETS ForInit2 SEMICOL Expression2 SEMICOL ForUpdate2 CLOSE_BRACKETS StatementNoShortIf   {
                                                        int uid =  makenode("forStmtNoShortIf");
                                                        addChild(uid, $1);
                                                        addChild(uid, $2);
                                                        addChild(uid, $3);
                                                        addChild(uid, $4);
                                                        addChild(uid, $5);
                                                        addChild(uid, $6);
                                                        addChild(uid, $7);
                                                        addChild(uid, $8);
                                                        addChild(uid, $9);
                                                        $$ = uid;
}   
                        ;
ForInit2                :      { $$ = -1; }
                        | ForInit           { $$ = $1; }
                        /* | PrimitiveType ForInit { int uid = makenode("Forinit2"); addChild(uid, $1); addChild(uid, $2);$$=uid;} */
                        ;
ForUpdate2              :   { $$ = -1; }
                        | ForUpdate        { $$ = $1; }
                        ;
Expression2             :   { $$ = -1; }
                        | Expression    { $$ = $1; }
                        ;
ForInit                 : StatementExpressionList   {$$ = $1;}
                        | LocalVariableDeclaration  {$$ = $1;}
                        ;   
ForUpdate               : StatementExpressionList   {$$ = $1;}
                        ;
StatementExpressionList : StatementExpression       {$$ = $1;}
                        | StatementExpressionList COMMA StatementExpression { int uid = makenode("StatementExpressionList"); addChild(uid, $1); addChild(uid, $2); addChild(uid, $3); $$ = uid;}
                        ;
BreakStatement          : BREAK identifier SEMICOL      { int uid = makenode("BreakStatement"); addChild(uid, $1); addChild(uid, $2); addChild(uid, $3); $$ = uid;}
                        | BREAK SEMICOL                 { int uid = makenode("BreakStatement"); addChild(uid, $1); addChild(uid, $2); $$ = uid;}
                        ;

ContinueStatement       : CONTINUE SEMICOL              { int uid = makenode("ContinueStatement"); addChild(uid, $1); addChild(uid, $2); $$ = uid;}
                        | CONTINUE identifier SEMICOL       { int uid = makenode("ContinueStatement"); addChild(uid, $1); addChild(uid, $2); addChild(uid, $3); $$ = uid;}
                        ;
ReturnStatement         : RETURN Expression2 SEMICOL    { int uid = makenode("ReturnStatement"); addChild(uid, $1); addChild(uid, $2); addChild(uid, $3); $$ = uid;}
                        ;
SynchronizedStatement   : SYNCHRONIZED OPEN_BRACKETS Expression CLOSE_BRACKETS Block    {
                                                        int uid =  makenode("SynchronizedStatement");
                                                        addChild(uid, $1);
                                                        addChild(uid, $2);
                                                        addChild(uid, $3);
                                                        addChild(uid, $4);
                                                        addChild(uid, $5);
                                                        $$ = uid;
                        }
                        ;

ArrayInitializer        : OPEN_CURLY VariableInitializers2 CLOSE_CURLY  { int uid = makenode("ArrayInitializer"); addChild(uid, $1); addChild(uid, $2); addChild(uid, $3); $$ = uid;}
                        ;
VariableInitializers2   :       { $$ = -1; }
                        | VariableInitializers  { $$ = $1; }
                        ;
VariableInitializers    : VariableInitializer   {$$ = $1;}
                        | VariableInitializers COMMA VariableInitializer    { int uid = makenode("VariableInitializers"); addChild(uid, $1); addChild(uid, $2); addChild(uid, $3); $$ = uid;}
                        ;

ExpressionStatement     : StatementExpression SEMICOL {int uid = makenode("ExStatement"); addChild(uid, $1); addChild(uid, $2);$$=uid;}
                        ;
StatementExpression     : Assignment                {$$ = $1;}
                        | PreIncrementExpression    {$$ = $1;}
                        | PreDecrementExpression    {$$ = $1;}
                        | PostIncrementExpression   {$$ = $1;}
                        | PostDecrementExpression   {$$ = $1;}
                        | MethodInvocation          {$$ = $1;}
                        | ClassInstanceCreationExpression   {$$ = $1;}
                        ;
PreIncrementExpression  : DPLUS UnaryExpression         {int uid = makenode("PreIncExpression"); addChild(uid, $1); addChild(uid, $2); $$=uid;}
                        ;
PreDecrementExpression  : DMINUS UnaryExpression        {int uid = makenode("PreDecExpression"); addChild(uid, $1); addChild(uid, $2); $$=uid;}
                        ;
PostIncrementExpression : PostfixExpression DPLUS       {int uid = makenode("PostIncExpression"); addChild(uid, $1); addChild(uid, $2); $$=uid;}
                        ;
PostDecrementExpression : PostfixExpression DMINUS      {int uid = makenode("PostDecExpression"); addChild(uid, $1); addChild(uid, $2); $$=uid;}
                        ;
UnaryExpression         : PLUS UnaryExpression          {int uid = makenode("UnaryExpression"); addChild(uid, $1); addChild(uid, $2); $$=uid;}
                        | MINUS UnaryExpression          {int uid = makenode("UnaryExpression"); addChild(uid, $1); addChild(uid, $2); $$=uid;}
                        | PreIncrementExpression         {$$ = $1;}
                        | PreDecrementExpression         {$$ = $1;}
                        | UnaryExpressionNotPlusMinus    {$$ = $1;}
                        ;
UnaryExpressionNotPlusMinus : PostfixExpression          {$$ = $1;}
                        | TILDA UnaryExpression         {int uid = makenode("UnaryExpressionNot+-"); addChild(uid, $1); addChild(uid, $2); $$=uid;}
                        | EXCLAMATORY UnaryExpression       {int uid = makenode("UnaryExpressionNot+-"); addChild(uid, $1);  addChild(uid, $2); $$=uid;}
                        | CastExpression                   {$$ = $1;}
                        ;
CastExpression          : OPEN_BRACKETS PrimitiveType Dims2 CLOSE_BRACKETS UnaryExpression  {
                                                        int uid = makenode("CastExpression");
                                                        addChild(uid,$1);
                                                        addChild(uid,$2);
                                                        addChild(uid, $3);
                                                        addChild(uid, $4);
                                                        addChild(uid, $5);
                                                        $$ = uid;
}
                        | OPEN_BRACKETS Expression CLOSE_BRACKETS UnaryExpressionNotPlusMinus   {
                                                        int uid = makenode("CastExpression");
                                                        addChild(uid,$1);
                                                        addChild(uid,$2);
                                                        addChild(uid, $3);
                                                        addChild(uid, $4);
                                                        
                                                        $$ = uid;
                        }
                        | OPEN_BRACKETS Name Dims CLOSE_BRACKETS UnaryExpressionNotPlusMinus {
                                                        int uid = makenode("CastExpression");
                                                        addChild(uid,$1);
                                                        addChild(uid,$2);
                                                        addChild(uid, $3);
                                                        addChild(uid, $4);
                                                        addChild(uid, $5);
                                                        $$ = uid;
                        }
                        ;
PostfixExpression       : Name                         {$$ = $1;}      
                        | Primary                     {$$ = $1;}
                        | PostIncrementExpression     {$$ = $1;}
                        | PostDecrementExpression     {$$ = $1;}
                        ;
Assignment              : LeftHandSide AssignmentOperator AssignmentExpression {
                                                        int uid = makenode("Assignment");
                                                        addChild(uid,$1);
                                                        addChild(uid,$2);
                                                        addChild(uid, $3);
                                                        $$ = uid;
}
                        ;
AssignmentOperator      : EQUAL                 {$$ = $1;}
                        | MUL_EQUAL             {$$ = $1;}
                        | DIVIDE_EQUAL          {$$ = $1;}
                        | MODULO_EQUAL          {$$ = $1;}
                        | PLUS_EQUAL            {$$ = $1;}
                        | MINUS_EQUAL           {$$ = $1;}
                        | DLESS_EQUAL           {$$ = $1;}
                        | DGREATER_EQUAL        {$$ = $1;}
                        | TGREATER_EQUAL        {$$ = $1;}
                        | AND_EQUAL             {$$ = $1;}
                        | HAT_EQUAL             {$$ = $1;}
                        | OR_EQUAL              {$$ = $1;}
                        ;
LeftHandSide            : Name                  {$$ = $1;}
                        | FieldAccess            {$$ = $1;}
                        | ArrayAccess           {$$ = $1;}
                        ;
AssignmentExpression    : ConditionalExpression {$$ = $1;}
                        | Assignment            {$$ = $1;}
                        ;
Expression              : AssignmentExpression  {$$ = $1;}
                        ;
ConditionalExpression   : ConditionalOrExpression   {$$ = $1;}
                        | ConditionalOrExpression QUE Expression COLON ConditionalExpression    {
                            int uid = makenode("ConditionalExpression");
                            addChild(uid, $1);
                            addChild(uid, $2);
                            addChild(uid, $3);
                            addChild(uid, $4);
                            addChild(uid, $5);
                            $$ = uid;
                        }
                        ; 
ConditionalOrExpression : ConditionalAndExpression          {$$ = $1;}
                        | ConditionalOrExpression DOR ConditionalAndExpression {
                                    int uid = makenode("ConditionalOrExpression");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
                        ;  
ConditionalAndExpression : InclusiveOrExpression             {$$ = $1;}
                        | ConditionalAndExpression DAND InclusiveOrExpression  {
                                    int uid = makenode("ConditionalAndExpression");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
                        ;    
InclusiveOrExpression   : ExclusiveOrExpression            {$$ = $1;}
                        | InclusiveOrExpression OR ExclusiveOrExpression  {
                                    int uid = makenode("InclusiveOrExpression");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
                        ;
ExclusiveOrExpression   : AndExpression                     {$$ = $1;}
                        | ExclusiveOrExpression HAT AndExpression   {
                                    int uid = makenode("ExclusiveOrExpression");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
                        ;
AndExpression           : EqualityExpression               {$$ = $1;}
                        | AndExpression AND EqualityExpression  {
                                    int uid = makenode("AndExpression");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
                        ;
EqualityExpression      : RelationalExpression             {$$ = $1;}
                        | EqualityExpression DEQUAL RelationalExpression   {
                                    int uid = makenode("EqualityExpression");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
                        | EqualityExpression NEQUAL RelationalExpression  {
                                    int uid = makenode("EqualityExpression");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
                        ;
RelationalExpression    : ShiftExpression                   {$$ = $1;}
                        | RelationalExpression LESS ShiftExpression     {
                                    int uid = makenode("RelationalExpression");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
                        | RelationalExpression GREATER ShiftExpression   {
                                    int uid = makenode("RelationalExpression");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
                        | RelationalExpression LE ShiftExpression   {
                                    int uid = makenode("RelationalExpression");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
                        | RelationalExpression GE ShiftExpression       {
                                    int uid = makenode("RelationalExpression");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
                        | RelationalExpression INSTANCEOF ReferenceType {
                                    int uid = makenode("RelationalExpression");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
                        ;
ShiftExpression         : AdditiveExpression                {$$ = $1;}
                        | ShiftExpression DLESS AdditiveExpression      {
                                    int uid = makenode("ShiftExpression");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
                        | ShiftExpression DGREATER AdditiveExpression       {
                                    int uid = makenode("ShiftExpression");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
                        | ShiftExpression TGREATER AdditiveExpression       {
                                    int uid = makenode("ShiftExpression");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
                        ;
AdditiveExpression      : MultiplicativeExpression          {$$ = $1;}
                        | AdditiveExpression PLUS MultiplicativeExpression      {
                                    int uid = makenode("AdditiveExpression");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
                        | AdditiveExpression MINUS MultiplicativeExpression     {
                                    int uid = makenode("AdditiveExpression");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
                        ;
MultiplicativeExpression : UnaryExpression                  {$$ = $1;}
                        | MultiplicativeExpression MUL UnaryExpression      {
                                    int uid = makenode("MultiplicativeExpression");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
                        | MultiplicativeExpression DIVIDE UnaryExpression       {
                                    int uid = makenode("MultiplicativeExpression");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
                        | MultiplicativeExpression MODULO UnaryExpression       {
                                    int uid = makenode("MultiplicativeExpression");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
                        ; 

PrimitiveType           : NumericType                       {$$ = $1;}
                        | BOOLEAN                           {$$ = $1;}
                        ;
NumericType             : IntegerType                       {$$ = $1;}
                        | FloatingPointType                 {$$ = $1;}
                        ;
IntegerType             : BYTE                  {$$ = $1;}
                        | SHORT                  {$$ = $1;}
                        | INT                    {$$ = $1;}
                        | LONG                   {$$ = $1;}
                        | CHAR                   {$$ = $1;}
                        | STRING                 {$$ = $1;}
                        ;
FloatingPointType       : FLOAT                  {$$ = $1;}
                        | DOUBLE                     {$$ = $1;}
                        ;                   
Name                    : SimpleName             {$$ = $1;}
                        | QualifiedName          {$$ = $1;}
                        ;
SimpleName              : identifier             {$$ = $1;}
                        ;
QualifiedName           : Name DOT identifier       {
                                    int uid = makenode("QualifiedName");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
                        ;
FieldAccess             : SUPER DOT identifier      {
                                    int uid = makenode("FieldAccess");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
                        | Primary DOT identifier  {
                                    int uid = makenode("FieldAccess");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
                        ;

ArrayAccess             : Name OPEN_SQ Expression CLOSE_SQ      {
                                    int uid = makenode("ArrayAccess");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    addChild(uid, $4);
                                    $$ = uid;
}
	                    | PrimaryNoNewArray OPEN_SQ Expression CLOSE_SQ {
                                    int uid = makenode("ArrayAccess");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    addChild(uid, $4);
                                    $$ = uid;
                        }
                        ;
Primary                 : PrimaryNoNewArray              {$$ = $1;}
                        | ArrayCreationExpression        {$$ = $1;}
                        ;
PrimaryNoNewArray       : Literal                        {$$ = $1;}
                        | THIS                           {$$ = $1;}
                        | OPEN_BRACKETS Expression CLOSE_BRACKETS {
                                                        int uid = makenode("PrimaryNoNewArray");
                                                        addChild(uid, $1);
                                                        addChild(uid, $2);
                                                        addChild(uid, $3);
                                                        $$ = uid;
                        }
                        | ClassInstanceCreationExpression    {$$ = $1;}
                        | FieldAccess                        {$$ = $1;}
                        | MethodInvocation                   {$$ = $1;}
                        | ArrayAccess                        {$$ = $1;}
                        ;
Literal                 : IntegerLiteral                     {$$ = $1;}   
                        | FloatingPointLiteral               {$$ = $1;}
                        | BooleanLiteral                     {$$ = $1;}
                        | CharacterLiteral                   {$$ = $1;}
                        | StringLiteral                      {$$ = $1;}
                        | TextBlock                          {$$ = $1;}
                        | NullLiteral                        {$$ = $1;}
                        ;
ClassInstanceCreationExpression : NEW Name OPEN_BRACKETS ArgumentList2 CLOSE_BRACKETS   {
                                    int uid = makenode("ClassInstanceCreationExpression");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    addChild(uid, $4);
                                    addChild(uid, $5);
                                    $$ = uid;
}
                        ;
MethodInvocation        : Name OPEN_BRACKETS ArgumentList2 CLOSE_BRACKETS      {
                                    int uid = makenode("MethodInvocation");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    addChild(uid, $4);
                                    $$ = uid;
}
                        | Primary DOT identifier OPEN_BRACKETS ArgumentList2 CLOSE_BRACKETS     {
                                    int uid = makenode("MethodInvocation");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    addChild(uid, $4);
                                    addChild(uid, $5);
                                    addChild(uid, $6);
                                    $$ = uid;
                        }
                        | SUPER DOT identifier OPEN_BRACKETS ArgumentList2 CLOSE_BRACKETS       {
                                    int uid = makenode("MethodInvocation");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    addChild(uid, $4);
                                    addChild(uid, $5);
                                    addChild(uid, $6);
                                    $$ = uid;
                        }
                        ;
ArgumentList2           : {$$ = -1;}
                        | ArgumentList           {$$=$1;}
                        ;       
ArgumentList            : Expression             {$$ = $1;}
                        | ArgumentList COMMA Expression {
                                                int uid = makenode("ArgumentList");
                                                addChild(uid, $1);
                                                addChild(uid, $2);
                                                addChild(uid, $3);
                                                $$ = uid;
                        }
                        ;   
ReferenceType           : Name                  {$$ = $1;}
                        | ArrayType             {$$ = $1;}
                        ;
ArrayType               : PrimitiveType OPEN_SQ CLOSE_SQ    {
                                    int uid = makenode("ArrayType");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
    	                | Name OPEN_SQ CLOSE_SQ             {
                                    int uid = makenode("ArrayType");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
                    	| ArrayType OPEN_SQ CLOSE_SQ        {
                                    int uid = makenode("ArrayType");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
                        ;
ArrayCreationExpression : NEW PrimitiveType DimExprs Dims2 {
                                    int uid = makenode("ArrayCreationExpr");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    addChild(uid, $4);
                                    $$ = uid;
}
                        | NEW Name DimExprs Dims2       {
                                    int uid = makenode("ArrayCreationExpr");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    addChild(uid, $4);
                                    $$ = uid;
                        }
                        ;
Dims2                   :  {$$ = -1;}
                        | Dims                   {$$=$1;}
                        ;
Dims                    : OPEN_SQ CLOSE_SQ      {int uid = makenode("Dims"); addChild(uid, $1); addChild(uid, $2); $$=uid;}
                        | Dims OPEN_SQ CLOSE_SQ   {
                                    int uid = makenode("Dims");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
DimExprs                : DimExpr                {$$ = $1;}
                        | DimExprs DimExpr          {int uid = makenode("DimExprs"); addChild(uid, $1); addChild(uid, $2); $$=uid;}
                        ;     
DimExpr                 : OPEN_SQ Expression CLOSE_SQ   {
                                    int uid = makenode("DimExpr");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
}                        
                        ;                
InterfaceDeclaration    : Modifiers1 INTERFACE identifier ExtendsInterfaces2 InterfaceBody {
                                    int uid = makenode("InterfaceDeclaration");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    addChild(uid, $4);
                                    addChild(uid, $5);
                                    $$ = uid;
}
                        ;
ExtendsInterfaces2      :   {$$ = -1;}
                        | ExtendsInterfaces {$$ = $1;}
                        ;
ExtendsInterfaces       : EXTENDS InterfaceType { int uid = makenode("ExtendsInterfaces"); addChild(uid, $1); addChild(uid, $2);}
                        | ExtendsInterfaces COMMA InterfaceType {
                                    int uid = makenode("ExtendsInterfaces");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
                        }
InterfaceBody           : OPEN_CURLY InterfaceMemberDeclarations2 CLOSE_CURLY   {
                                    int uid = makenode("InterfaceBody");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    addChild(uid, $3);
                                    $$ = uid;
}
                        ;
InterfaceMemberDeclarations2    :   {$$ = -1;}
                        | InterfaceMemberDeclarations   {$$ = $1;}
                        ;
InterfaceMemberDeclarations     : InterfaceMemberDeclaration    {$$ = $1;}
                        | InterfaceMemberDeclarations InterfaceMemberDeclaration    {
                                    int uid = makenode("InterfaceMemberDeclarations");
                                    addChild(uid, $1);
                                    addChild(uid, $2);
                                    $$ = uid;
                        }
                        ;
InterfaceMemberDeclaration      : ConstantDeclaration       {$$ = $1;}
                        | AbstractMethodDeclaration         {$$ = $1;}
                        ;
ConstantDeclaration     : FieldDeclaration                  {$$ = $1;}
                        ;
AbstractMethodDeclaration       : MethodHeader              {$$ = $1;}
                        | SEMICOL                           {$$ = $1;}
                        ;
InterfaceType           : TypeName                          {$$ = $1;}
                        ;
identifier                                                              :   identifierT {$$ = makenode($1, "identifier");} ;
IntegerLiteral                                                          :   IntegerLiteralT {$$ = makenode($1, "IntegerLiteral");} ;
FloatingPointLiteral                                                    :   FloatingPointLiteralT {$$ = makenode($1, "FloatingPointLiteral");} ;
BooleanLiteral                                                          :   BooleanLiteralT {$$ = makenode($1, "BooleanLiteral");} ;
CharacterLiteral                                                        :   CharacterLiteralT {$$ = makenode($1, "CharacterLiteral");} ;
StringLiteral                                                           :   StringLiteralT {$$ = makenode($1, "StringLiteral");} ;
NullLiteral                                                             :   NullLiteralT {$$ = makenode($1, "NullLiteral");} ;
TextBlock                                                               :   TextBlockT {$$ = makenode($1, $1);} ;
NEW                                                                     :   NEWT {$$ = makenode($1, $1);} ;
SYNCHRONIZED                                                            :   SYNCHRONIZEDT {$$ = makenode($1, "modifier");} ;
RETURN                                                                  :   RETURNT {$$ = makenode($1, $1);} ;
BREAK                                                                   :   BREAKT {$$ = makenode($1, $1);} ;
CONTINUE                                                                :   CONTINUET {$$ = makenode($1, $1);} ;
IF                                                                      :   IFT {$$ = makenode($1,$1); } ;
ELSE                                                                    :   ELSET {$$ = makenode($1,$1); } ;
FOR                                                                     :   FORT {$$ = makenode($1,$1); } ;
WHILE                                                                   :   WHILET {$$ = makenode($1,$1); } ;
CLASS                                                                   :   CLASST {$$ = makenode($1,$1); } ;
INSTANCEOF                                                              :   INSTANCEOFT {$$ = makenode($1,$1); } ;
THIS                                                                    :   THIST {$$ = makenode($1,$1); } ;
SUPER                                                                   :   SUPERT {$$ = makenode($1,$1); } ;
ABSTRACT                                                                :   ABSTRACTT {$$ = makenode($1,"modifier"); } ;
ASSERT                                                                  :   ASSERTT {$$ = makenode($1,$1); } ;
BOOLEAN                                                                 :   BOOLEANT {$$ = makenode($1,"type"); } ;
BYTE                                                                    :   BYTET {$$ = makenode($1,"type"); } ;
SHORT                                                                   :   SHORTT {$$ = makenode($1,"type"); } ;
INT                                                                     :   INTT {$$ = makenode($1,"type"); } ;
LONG                                                                    :   LONGT {$$ = makenode($1,"type"); } ;
CHAR                                                                    :   CHART {$$ = makenode($1,"type"); } ;
STRING                                                                  :   STRINGT {$$ = makenode($1,"type"); } ;
FLOAT                                                                   :   FLOATT {$$ = makenode($1,"type"); } ;
DOUBLE                                                                  :   DOUBLET {$$ = makenode($1,"type"); } ;
EXTENDS                                                                 :   EXTENDST {$$ = makenode($1,$1); } ;
PACKAGE                                                                 :   PACKAGET {$$ = makenode($1,$1); } ;
IMPORT                                                                  :   IMPORTT {$$ = makenode($1,$1); } ;
STATIC                                                                  :   STATICT {$$ = makenode($1,"modifier"); } ;
PROTECTED                                                               :   PROTECTEDT {$$ = makenode($1,"modifier"); } ;
PRIVATE                                                                 :   PRIVATET {$$ = makenode($1,"modifier"); } ;
PUBLIC                                                                  :   PUBLICT {$$ = makenode($1,"modifier"); } ;
FINAL                                                                   :   FINALT {$$ = makenode($1,"modifier"); } ;
TRANSIENT                                                               :   TRANSIENTT {$$ = makenode($1,"modifier"); } ;
VOLATILE                                                                :   VOLATILET {$$ = makenode($1,"modifier"); } ;
IMPLEMENTS                                                              :   IMPLEMENTST {$$ = makenode($1,$1); } ;
VOID                                                                    :   VOIDT {$$ = makenode($1,"type"); } ;
INTERFACE                                                               :   INTERFACET {$$ = makenode($1,$1); } ;
NATIVE                                                                  :   NATIVET {$$ = makenode($1,"modifier"); } ;
OPEN_BRACKETS                                                           :   OPEN_BRACKETST {$$ = makenode($1,$1); } ;
CLOSE_BRACKETS                                                          :   CLOSE_BRACKETST {$$ = makenode($1,$1); } ;
OPEN_CURLY                                                              :   OPEN_CURLYT {$$ = makenode($1,$1); } ;
CLOSE_CURLY                                                             :   CLOSE_CURLYT {$$ = makenode($1,$1); } ;
OPEN_SQ                                                                 :   OPEN_SQT {$$ = makenode($1,$1); } ;
CLOSE_SQ                                                                :   CLOSE_SQT {$$ = makenode($1,$1); } ;
SEMICOL                                                                 :   SEMICOLT {$$ = makenode($1,$1); } ;
COMMA                                                                   :   COMMAT {$$ = makenode($1,$1); } ;
DOT                                                                     :   DOTT {$$ = makenode($1,$1); } ;
EQUAL                                                                   :   EQUALT {$$ = makenode($1,$1); } ;
LESS                                                                   :   LESST {$$ = makenode($1,$1); } ;
GREATER                                                                :   GREATERT {$$ = makenode($1,$1); } ;
EXCLAMATORY                                                            :   EXCLAMATORYT {$$ = makenode($1,$1); } ;
TILDA                                                                  :   TILDAT {$$ = makenode($1,$1); } ;
QUE                                                                    :   QUET {$$ = makenode($1,$1); } ;
COLON                                                                  :   COLONT {$$ = makenode($1,$1); } ;
DEQUAL                                                                 :   DEQUALT {$$ = makenode($1,$1); } ;
LE                                                                     :   LET {$$ = makenode($1,$1); } ;
GE                                                                     :   GET {$$ = makenode($1,$1); } ;
NEQUAL                                                                 :   NEQUALT {$$ = makenode($1,$1); } ;
DAND                                                                   :   DANDT {$$ = makenode($1,$1); } ;
DOR                                                                    :   DORT {$$ = makenode($1,$1); } ;
DPLUS                                                                  :   DPLUST {$$ = makenode($1,$1); } ;
DMINUS                                                                 :   DMINUST {$$ = makenode($1,$1); } ;
PLUS                                                                   :   PLUST {$$ = makenode($1,$1); } ;
MINUS                                                                  :   MINUST {$$ = makenode($1,$1); } ;
MUL                                                                    :   MULT {$$ = makenode($1,$1); } ;
DIVIDE                                                                 :   DIVIDET {$$ = makenode($1,$1); } ;
AND                                                                    :   ANDT {$$ = makenode($1,$1); } ;
HAT                                                                    :   HATT {$$ = makenode($1,$1); } ;
MODULO                                                                 :   MODULOT {$$ = makenode($1,$1); } ;
DLESS                                                                  :   DLESST {$$ = makenode($1,$1); } ;
DGREATER                                                               :   DGREATERT {$$ = makenode($1,$1); } ;
TGREATER                                                               :   TGREATERT {$$ = makenode($1,$1); } ;
PLUS_EQUAL                                                             :   PLUS_EQUALT {$$ = makenode($1,$1); } ;   
MINUS_EQUAL                                                            :   MINUS_EQUALT {$$ = makenode($1,$1); } ;
MUL_EQUAL                                                              :   MUL_EQUALT {$$ = makenode($1,$1); } ;
DIVIDE_EQUAL                                                           :   DIVIDE_EQUALT {$$ = makenode($1,$1); } ;
AND_EQUAL                                                              :   AND_EQUALT {$$ = makenode($1,$1); } ;
OR_EQUAL                                                               :   OR_EQUALT {$$ = makenode($1,$1); } ;
HAT_EQUAL                                                              :   HAT_EQUALT {$$ = makenode($1,$1); } ;
MODULO_EQUAL                                                           :   MODULO_EQUALT {$$ = makenode($1,$1); } ;
DLESS_EQUAL                                                            :   DLESS_EQUALT {$$ = makenode($1,$1); } ;
DGREATER_EQUAL                                                         :   DGREATER_EQUALT {$$ = makenode($1,$1); } ;
TGREATER_EQUAL                                                         :   TGREATER_EQUALT {$$ = makenode($1,$1); } ;
OR                                                                     :   ORT {$$ = makenode($1,$1); } ;
STRICTFP                                                               :   STRICTFPT{$$ = makenode($1, "modifier");};
%% 


int main(int argc, char *argv[]) {
    makeSymbolTable("program");
    argparse::ArgumentParser program("final");
    program.set_prefix_chars("-+/");
    program.set_assign_chars("=:");

  program.add_argument("-i","--input")
  .help("Specify the input File Path (e.g. '/test/test.java')")
  ;
  program.add_argument("-o","--output")
  .help("Specify the output File Path (e.g. './output/out.dot')");
  
  program.add_description("To execute the program, run the following command\n./final -i=\"../testcases/reverse.java\" -o=\"out.dot\"");
  program.add_epilog("Possible things include betingalw, chiz, and res.");
   
    program.add_argument("--verbose")
  .help("Verbose Prints ")
  .default_value(false)
  .implicit_value(true)
  ;

  
  

  try {
    program.parse_args(argc, argv);
  }
  catch (const std::runtime_error& err) {
    std::cerr << err.what() << std::endl;
    std::cerr << program;
    std::exit(1);
  }
  if(program["--verbose"]==true){
    cout << "The Dot file for the given input java program is generated by passing the input\nfrom the lexer and then from the parser. The tree is generated from the parser\nand stored in the dot file mentioned in the command." << endl;
  }

	/* yyparse();	 */
    extern FILE *yyin, *yyout;
    int ntoken;
    string InputFile1 = program.get("--input");
    string OutPutFile1 = program.get("--output");
    OutputFileName = OutPutFile1;
    const char *InputFile = InputFile1.c_str();
    yyin = fopen(InputFile, "r");
    if( yyin == NULL ) {
        fprintf(stderr, "Couldn't open %s: %s\n", InputFile, strerror(errno));
        exit(1);
    }
    ntoken = yyparse();
    while(ntoken){
            ntoken = yyparse();

    }
    fclose(yyin);

    /* for(auto it : table){
        printSymbolTable(it.first);
        cout << "*******" << endl;
    }  */
    ofstream fout;
    fout.open("SymbolTable.csv");
    fout << "Variable,Type,Line,Size,Offset" << '\n';
        for(auto it : table){
            for(auto itr : it.second){
        fout << itr.first.c_str() << "," << itr.second->type.c_str() << "," << (itr.second)->line << "," << (itr.second)->size << "," << (itr.second)->offset << endl;
        }
        }
    fout.close();

    // my addition *********** TYPE CHECKING **********************
    /* map<int, pair<string, vector<int> >> typeCheck; */
    unordered_map <int,bool> visitedType;
    unordered_map <int, bool>terminal;
    unordered_map<string, pair<int, vector<string>>> methodParams;
    cout<<"**********  TREE   ********************\n";
    map<int, string> whtIsType;
    for(auto itr = tree.begin();itr!=tree.end();itr++){
        visitedType[itr->first]=  false;
        terminal[itr->first] = false;
        whtIsType[itr->first]=  "x";
        /* cout<<itr->first<<" [ "<< (itr->second).first<<" ]    -> ";
         cout<<"{ "<<additionalInfo[itr->first]<<" }";
        for(int j=0; j<(itr->second).second.size();j++){
            
            cout<<(itr->second).second[j]<<" ";
        }
        cout<<"\n"; */
    }
    
    /* cout<<visitedType.size(); */

    /* typeCheck = tree; */
    int typeErrorFlag = 0;

        cout<<"**********  Typecheck  ********************\n";
        // consider float and double as same

    stack <int> nodeStack;
    /* cout<<root<<endl; */
    nodeStack.push(root);
    int again = 0;
    int node,child;
    while(!nodeStack.empty() && !again){
        node = nodeStack.top();
        nodeStack.pop();
        bool allChildrenVisited = true;
        int childNum = tree[node].second.size();
        if(childNum==0){
            terminal[node] = true;
            // leaf node
            if (additionalInfo[node]=="identifier") {
                whtIsType[node] = customtypeof(node);
                if (whtIsType[node]=="double") whtIsType[node]="float";}
            else if(additionalInfo[node]=="type") {
                whtIsType[node] = tree[node].first;
                if (whtIsType[node]=="double") whtIsType[node]="float";
                }
            else if(additionalInfo[node]=="IntegerLiteral")  whtIsType[node] = "int";
            else if(additionalInfo[node]=="CharacterLiteral")  whtIsType[node] = "char";
            else if(additionalInfo[node]=="FloatingPointLiteral")  whtIsType[node] = "float";
            else if(additionalInfo[node]=="BooleanLiteral")  whtIsType[node] = "boolean";
            else if(additionalInfo[node]=="StringLiteral")  whtIsType[node] = "String";
            else if(additionalInfo[node]=="NullLiteral")  whtIsType[node] = "null";
        }
        for(int i=0; i<childNum;i++){
            child = (tree[node].second)[i];
            if(!visitedType[child]){
                allChildrenVisited = false;
                if(child!=-1 &&
                /* additionalInfo[child]=="modifier" && */
                    tree[child].first!="="   &&
                    tree[child].first!="<"   &&
                    tree[child].first!=">"   &&
                    tree[child].first!="!"   &&
                    tree[child].first!="~"   &&
                    tree[child].first!="?"   &&
                    tree[child].first!=":"   &&
                    tree[child].first!="->"  &&
                    tree[child].first!="=="  &&
                    tree[child].first!=">="  &&
                    tree[child].first!="<="  &&
                    tree[child].first!="!="  &&
                    tree[child].first!="&&"  &&
                    tree[child].first!="||"  &&
                    tree[child].first!="++"  &&
                    tree[child].first!="--"  &&
                    tree[child].first!="+"   &&
                    tree[child].first!="-"   &&
                    tree[child].first!="*"   &&
                    tree[child].first!="/"   &&
                    tree[child].first!="&"   &&
                    tree[child].first!="^"   &&
                    tree[child].first!="%"   &&
                    tree[child].first!="<<"  &&
                    tree[child].first!=">>"  &&
                    tree[child].first!=">>>" &&
                    tree[child].first!="+="  &&
                    tree[child].first!="-="  &&
                    tree[child].first!="*="  &&
                    tree[child].first!="/="  &&
                    tree[child].first!="&="  &&
                    tree[child].first!="|="  &&
                    tree[child].first!="^="  &&
                    tree[child].first!="%="  &&
                    tree[child].first!="<<=" &&
                    tree[child].first!=">>=" &&
                    tree[child].first!=">>>="&&
                    tree[child].first!="|"   &&
                    tree[child].first!="<>" &&
                    tree[child].first!="("  &&
                    tree[child].first!=")"  &&
                    tree[child].first!="{"  &&
                    tree[child].first!="}"  &&
                    tree[child].first!="["  &&
                    tree[child].first!="]"  &&
                    tree[child].first!=";"  &&
                    tree[child].first!=","  &&
                    tree[child].first!="."  &&
                    tree[child].first!="..."&&
                    tree[child].first!="@"  &&
                    tree[child].first!="::"  

            ) {
                /* cout<<"88888 "<<whtIsType[child]<<endl; */
                nodeStack.push(child);
                /* cout<<child<<" "<<whtIsType[child]<<" "; */

                
                
                }
            else{
                visitedType[child] = true;
            }
                
            }
        }
        if(allChildrenVisited){
            
            string is_type = "";
            childNum = tree[node].second.size();

            if(terminal[node]==false){
                // finding type of nonTerminal
                if( tree[node].first == "LocalVariableDeclarationStatement"||
                    tree[node].first == "ExStatement"  ||
                    tree[node].first == "MethodHeader"  ||
                    tree[node].first == "forStmt" ||
                    tree[node].first == "whileStmt" ||
                    tree[node].first == "BlockStatements" ||
                    tree[node].first == "ifThenStmt" ||
                    tree[node].first == "ifThenElseStmt" ||
                    tree[node].first == "ClassDeclaration" ||
                    tree[node].first == "ClassBodyDeclarations" ||
                    tree[node].first == "Block" ) {
                    // no need to store type
                    whtIsType[node] = "x";

                    }

                else if( tree[node].first =="ClassInstanceCreationExpression" ) {
                    // no need to store type
                    is_type = tree[(tree[node].second)[1]].first;


                    }
                else if(tree[node].first =="VariableDeclarator")
                {
                    if(whtIsType[(tree[node].second)[0]]=="float" && (whtIsType[(tree[node].second)[2]] == "float" || whtIsType[(tree[node].second)[2]] == "int")){
                        is_type = "float";

                    }
                    else if(whtIsType[(tree[node].second)[0]]=="int" && (whtIsType[(tree[node].second)[2]] == "int" || whtIsType[(tree[node].second)[2]] == "char")){
                        is_type = "int";

                    }
                    else if(whtIsType[(tree[node].second)[0]]== whtIsType[(tree[node].second)[2]] ){
                        is_type = whtIsType[(tree[node].second)[0]];

                    }
                    else{
                        for(int i=0; i<childNum;i++)
                    {
                        child = (tree[node].second)[i];
                        /* cout<<"child : "<<child<<endl; */
                        if(is_type=="" && whtIsType[child]!="x") is_type = whtIsType[child];
                        else if(is_type != whtIsType[child] && whtIsType[child]!="x") 
                        {
                            cout<<" error seems here ";
                            typeErrorFlag = 1;
                            cout<<node <<": " <<tree[node].first<<" at line:"<<getLineOf((tree[node].second)[0])<<endl;
                            is_type = "error";
                            exit(1);
                        }
                    }
                    }


                    
                }

                
                else if(tree[node].first =="AdditiveExpression" || tree[node].first =="RelationalExpression"

                )
                {
                    if((whtIsType[(tree[node].second)[0]]=="float" && (whtIsType[(tree[node].second)[2]] == "float" || whtIsType[(tree[node].second)[2]] == "int")) 
                    || 
                    (whtIsType[(tree[node].second)[0]]=="float" || (whtIsType[(tree[node].second)[0]] == "int" && whtIsType[(tree[node].second)[2]] == "float")))
                    {
                        is_type = "float";

                    }
                    else if(
                        (whtIsType[(tree[node].second)[0]]=="int" && (whtIsType[(tree[node].second)[2]] == "int" || whtIsType[(tree[node].second)[2]] == "char"))
                         || 
                         (whtIsType[(tree[node].second)[0]]=="char" || (whtIsType[(tree[node].second)[0]] == "int" && whtIsType[(tree[node].second)[2]] == "int")))
                        {
                        is_type = "int";

                    }
                    else{
                        for(int i=0; i<childNum;i++)
                    {
                        child = (tree[node].second)[i];
                        /* cout<<"child : "<<child<<endl; */
                        if(is_type=="" && whtIsType[child]!="x") is_type = whtIsType[child];
                        else if(is_type != whtIsType[child] && whtIsType[child]!="x") 
                        {
                            cout<<" error seems here ";
                            typeErrorFlag = 1;
                            cout<<node <<": " <<tree[node].first<<" at line:"<<getLineOf((tree[node].second)[0])<<endl;
                            is_type = "error";
                            exit(1);
                        }
                    }

                    }

                    
                }
                
                else if(tree[node].first =="ConditionalExpression" )
                {
                    if(childNum==5){
                        if(whtIsType[(tree[node].second)[2]] == whtIsType[(tree[node].second)[4]]){
                            is_type = whtIsType[(tree[node].second)[2]];
                        }
                    }
                }
                else if(tree[node].first =="QualifiedName" )
                {
                    is_type = whtIsType[tree[parent[node]].second[2]];

                }
                else if(tree[node].first =="ArgumentList")
                {
                    for(int i=0; i<childNum;i++){
                        child = (tree[node].second)[i];
                        if(whtIsType[child]!="x") is_type = is_type + whtIsType[child];
                    }
                    
                    /* cout<<compare<<"balle?\n";           */
                    

                }

                else if(tree[node].first =="FormalParameterList" )
                {

                    for(int i=0; i<childNum;i++){
                        child = (tree[node].second)[i];
                        if(whtIsType[child]!="x") is_type = is_type + whtIsType[child];
                    }
                }
                else if(tree[node].first =="ArgumentList")
                {
                    for(int i=0; i<childNum;i++){
                        child = (tree[node].second)[i];
                        if(whtIsType[child]!="x") is_type = is_type + whtIsType[child];
                    }
                    
                    /* cout<<compare<<"balle?\n";           */
                    

                }
                
                else if(tree[node].first =="MethodInvocation")
                {
                    // type is the type of method name + type of params
                    is_type = whtIsType[(tree[node].second)[0]]+ whtIsType[(tree[node].second)[2]];
                    cout<<is_type<<endl;

                    int to_go = (tree[node].second)[0];
                    vector <string> params = getParamsOf(to_go);
                    string compare = customtypeof((tree[node].second)[0]);
                    for(int i=0; i<params.size();i++){
                        compare = compare + params[i];
                    }
                    cout<<compare<<endl;
                    if(compare!=is_type){
                        cout<<" error seems here ";
                        typeErrorFlag = 1;
                        cout<<node <<": " <<tree[node].first<<" at line:"<<getLineOf((tree[node].second)[0])<<endl;
                        is_type = "error";
                        exit(1);
                    }

                    is_type = whtIsType[(tree[node].second)[0]];

                    
                    
                }
                else if(tree[node].first =="MethodDeclarator")
                {
                    // type is the type of method name
                    is_type = whtIsType[(tree[node].second)[0]];
 
                }
                else if(tree[node].first =="MethodDeclarator")
                {
                    // type is the type of method name
                    is_type = whtIsType[(tree[node].second)[0]];
 
                }
                else
                {
                    for(int i=0; i<childNum;i++)
                    {
                        child = (tree[node].second)[i];
                        /* cout<<"child : "<<child<<endl; */
                        if(is_type=="" && whtIsType[child]!="x") is_type = whtIsType[child];
                        else if(is_type != whtIsType[child] && whtIsType[child]!="x") 
                        {
                            cout<<" error seems here ";
                            typeErrorFlag = 1;
                            cout<<node <<": " <<tree[node].first<<" at line:"<<getLineOf((tree[node].second)[0])<<endl;
                            is_type = "error";
                            exit(1);
                        }
                    }

                }
                
            whtIsType[node] = is_type;
            }

            

            if (node == root) again=1;
            /* cout<<node <<": " <<tree[node].first<<" "<<whtIsType[node]<<endl; */
            visitedType[node] = true;
            if(parent.count(node)>0 && !visitedType[parent[node]]){
                nodeStack.push(parent[node]);
            }
        }
    }
    if(typeErrorFlag == 0) cout<<"No Type Error Found\n";
    exit(1);
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s %s at line %d\n", s, yylval, line);
	exit(1);
}
