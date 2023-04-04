%{
#include<bits/stdc++.h>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <vector>
#include "./argparse/argparse.hpp"
using namespace std;

extern int yylex();
extern int yyparse();
int line = 0;
int root = -1;
void yyerror(const char* s);

uint countnode = 0;
string OutputFileName = "out.dot";
map<int, pair<string, vector<int> >> tree;

/*--------------------- MileStone 2 --------------------------*/
map<int, string> additionalInfo;
map<int, int> LineNumber;
map<int, int> parent;
map<int, vector<int>> backlist;
/*------------------------------------------------------------*/

int makenode( string name){
    countnode++;
    vector<int> childs;
    tree[countnode] = {name, childs};
    return countnode;
}

/*--------------------- MileStone 2 --------------------------*/
int makenode( string name, string type){
    countnode++;
    vector<int> childs;
    tree[countnode] = {name, childs};
    additionalInfo[countnode] = type;
    LineNumber[countnode] = line;
    backlist[countnode] = {};
    return countnode;
}

int getSize(string id){
  if(id == "char") return sizeof(char);
  if(id == "short") return sizeof(short);
  if(id == "int") return sizeof(int);
  if(id == "float") return sizeof(float);
  if(id == "double") return sizeof(double);

  return 0; // for any ptr
}
/*------------------------------------------------------------*/

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

/*--------------------- MileStone 2 --------------------------*/



string stname;
string sttype;
string iswhat;
int stline;
int stsize = 4;
int stoffset = 0;
int prevoffset = 0;
vector<string> stmodifiers;
string stwhat;
vector<string> parameters;
int stisArray = 0;
vector<int> stndim;
string prevname;
int flag = 0;
int fornum = 1, whilenum = 1, ifelsenum = 1, blocknum = 1;

typedef struct sym_entry{
	string type;
    int line = 0;
	int size = 0;
	int offset = 0;
    int isArray;
    string what;
    vector<int> ndim;
    vector<string> parameters;
}sym_entry;

typedef unordered_map<string, sym_entry* > sym_table;
typedef map<string, sym_table> table;
typedef map<string, string> parent_table;
map<string, table> class_table, class_table1;
map<string, parent_table> class_parent_table;
vector<string> key_words = {"abstract","continue","for","new","switch","assert","default","if","package","synchronized","boolean","do","goto","private","this","break","double","implements","protected","throw","byte","else","import","public","throws","case","enum","instanceof","return","transient","catch","extends","int","short","try","String","char","final","interface","static","void","class","finally","long","strictfp","volatile","const","float","native","super","while","_","exports","opens","requires","uses","module","permit","sealed","var","non-sealed","provides","to","with","open","record","transitive","yield"}; 
string curr_class, curr_table;
map<string, vector<string>> modifiers;
map<int, string> scope;
map<string, vector<string>> classMap;
map<string, int> classOffset;

void createEntry(string currTableName, string temp, string type, int line, int size, int offset, int isArray, string what, vector<int> ndim, vector<string> parameters){
    if(find(key_words.begin(), key_words.end(), temp) != key_words.end()){
        cout << "Keyword cannot be declared as a variable"<< endl;
        exit(0);
    }
    if(class_table[curr_class][currTableName].find(temp) != class_table[curr_class][currTableName].end()) {
        cout << temp << " Already declared " << line << endl;
        exit(1);
    }
    if(type == "String"){
        size = 8;
    }
    sym_entry* ent = new sym_entry();
	    ent->type = type;
        ent->line = line;
	    ent->size = size;
	    ent->offset = offset;
        ent->isArray = isArray;
        ent->what = what;
        ent->ndim = ndim;
        ent->parameters = parameters;
        class_table[curr_class][currTableName].insert(make_pair(temp, ent));
        stisArray = 0;
        stoffset += size;
}

void makeSymbolTable(string name){
    sym_table new_table;
    class_table[curr_class].insert(make_pair(name, new_table));
    class_parent_table[curr_class].insert(make_pair(name, curr_table));
	curr_table = name;
    prevoffset = stoffset;
    stoffset = 0;
}

string lookup(string id){
	string temp = curr_table;
	while(temp != "null" && temp != ""){
		if((class_table[curr_class][temp]).find(id)!=(class_table[curr_class][temp]).end()) return temp;
		temp = class_parent_table[curr_class][temp];
	}
    vector<string> mod = classMap[curr_class];
    if(find(mod.begin(), mod.end(), id) != mod.end()) return curr_class;
	return "null";
}
string lookup2(string id, string tbl){
     vector<string> mod = classMap[tbl];
    if(find(mod.begin(), mod.end(), id) != mod.end()) return tbl;
	return "null";
	
}

void ParamList(int id){
    vector<int> child = tree[id].second;
    if(tree[id].first == "FormalParameter"){
        parameters.push_back(tree[child[1]].first);
    }
    for(int i = 0; i < child.size(); i++){
        ParamList(child[i]);
    }
}

map<int, string> nodeClass;
string customtypeof(int id){

    // string find_it  = tree[id].first;
    string myCurrClass = nodeClass[id];
    string temp = scope[id];
	while(temp != "null" && temp != ""){
        auto it = class_table[myCurrClass][temp].find(tree[id].first);
        if(it!=class_table[myCurrClass][temp].end()){
            string typet = class_table[myCurrClass][temp][tree[id].first]->type;
            string typeans = "";
            for(int i=0; i<typet.length(); i++){
                if(typet[i] == '['){
                    break;
                }
                typeans += typet[i];
            }
            return typeans;
        } 
		else{
		temp = class_parent_table[myCurrClass][temp];}
	}
    return "null";
}


void ForClass(int id){
    vector<int> child = tree[id].second;
    string nodeName = tree[id].first;
    if(nodeName == "Block"){
        return;
    }
    if(nodeName == "FieldDeclaration"){
        if(additionalInfo.find(child[2]) != additionalInfo.end()){
            classMap[curr_class].push_back(tree[child[2]].first);
        }
    }
    if(nodeName == "ConstructorBody"){
        return;
    }
     
    if(nodeName == "ClassDeclaration"){
        curr_class = tree[child[2]].first;
        classMap[curr_class].push_back(curr_class);
        ForClass(child[5]);
        return;
    }
    if(nodeName == "ConstructorDeclarator"){
        classMap[curr_class].push_back(tree[child[0]].first + ".constr");
        return;
    }
    if(nodeName == "MethodDeclarator"){
        classMap[curr_class].push_back(tree[child[0]].first);
        return;
    }
    if(nodeName == "VariableDeclarators"){
        if(tree[child[0]].first == "VariableDeclarator" || tree[child[0]].first == "VariableDeclarators" ){
            ForClass(child[0]);
        }
        else{
            classMap[curr_class].push_back(tree[child[0]].first);
        }
        if(tree[child[2]].first == "VariableDeclarator" || tree[child[2]].first == "VariableDeclarators" ){
            ForClass(child[2]);
        }
        else{
            classMap[curr_class].push_back(tree[child[0]].first);
        }
        return;
    }
    if(nodeName == "VariableDeclarator"){
        if(tree[child[0]].first != "VariableDeclaratorId"){
            classMap[curr_class].push_back(tree[child[0]].first);
            return; 
        }
        return;
    }
    for(int i = 0; i < child.size(); i++){
        ForClass(child[i]);
    }
    return;
   
}


void symTable(int id){
    vector<int> child = tree[id].second;
    string nodeName = tree[id].first;
    classOffset[curr_class] = max(stoffset, classOffset[curr_class]);
    if(child.size() == 0){
        nodeClass[id] = curr_class;
        scope[id] = curr_table;
    } 
    if(nodeName == "ClassDeclaration"){
        symTable(child[2]);
        curr_class = tree[child[2]].first;
        table t;
        class_table[curr_class] = t;
        curr_table = "null";
        makeSymbolTable(curr_class);
        int tempid = child[0];
        while(tree[tempid].first == "Modifiers"){
            vector<int> child1 = tree[tempid].second;
            modifiers[tree[child[2]].first].push_back(tree[child1[0]].first);
            tempid = child1[1];
        }
        
        symTable(child[5]);
        
        return;
    }
     if(nodeName == "ConstructorDeclaration"){
        int tempid = child[0];
        vector<int> child2 = tree[child[1]].second;
        while(tree[tempid].first == "Modifiers"){
            vector<int> child1 = tree[tempid].second;
            modifiers[tree[child2[0]].first + ".constr"].push_back(tree[child1[0]].first);
            tempid = child1[1];
        }
        symTable(child[1]);
        symTable(child[2]);
        curr_table = class_parent_table[curr_class][curr_table];
        stoffset = prevoffset;
        return;
    }
    if(nodeName == "ConstructorDeclarator"){
        stwhat = "constructor";
        ParamList(child[2]);
        createEntry(curr_table,tree[child[0]].first+".constr","",LineNumber[child[0]],4,stoffset,0,"constructor",stndim,parameters);
        parameters.clear();
        symTable(child[0]);
        makeSymbolTable(tree[child[0]].first+".constr");
        symTable(child[2]);
        return;
    }
    if(nodeName == "MethodDeclarator"){
        stwhat = "method";
        ParamList(child[2]);
        createEntry(curr_table,tree[child[0]].first,sttype,LineNumber[child[0]],getSize(sttype),stoffset,0,"method",stndim,parameters);
        parameters.clear();
        symTable(child[0]);
        makeSymbolTable(tree[child[0]].first);
        symTable(child[2]);
        return;
    }
    if(nodeName == "MethodHeader"){
        int tempid = child[0];
        vector<int> child2 = tree[child[2]].second;
        while(tree[tempid].first == "Modifiers"){
            vector<int> child1 = tree[tempid].second;
            modifiers[curr_class + "." + tree[child2[0]].first].push_back(tree[child1[0]].first);
            tempid = child1[1];
        }
        sttype = tree[child[1]].first;
        symTable(child[2]);
        return;
        
    }
    if(nodeName == "FormalParameter"){
        int tempid = child[0];
        
        while(tree[tempid].first == "Modifiers"){
            vector<int> child1 = tree[tempid].second;
            modifiers[tree[child[2]].first].push_back(tree[child1[0]].first);
            tempid = child1[1];
        }
        if(tree[child[1]].first == "ArrayType"){
            stisArray = 1;
            vector<int> child1 = tree[child[1]].second;
            int n1 = child1[0];
            sttype = "[]";
            while(tree[n1].first == "ArrayType"){
                vector<int> child1 = tree[n1].second;
                sttype += "[]";
                n1 = child1[0];
            }
            sttype = tree[n1].first + sttype;
        }
        else{
            sttype = tree[child[1]].first;
        }
        createEntry(curr_table, tree[child[2]].first, sttype, LineNumber[child[2]], getSize(tree[child[1]].first), stoffset, 0, "variable", stndim, parameters);
        symTable(child[2]);
        return;
    }
    if(nodeName == "FieldDeclaration"){
        int tempid = child[0];
        stmodifiers.clear();
        while(tree[tempid].first == "Modifiers"){
            vector<int> child1 = tree[tempid].second;
            stmodifiers.push_back(tree[child1[0]].first);
            tempid = child1[1];
        }
        if(tree[child[1]].first == "ArrayType"){
            stisArray = 1;
            vector<int> child1 = tree[child[1]].second;
            int n1 = child1[0];
            sttype = "[]";
            while(tree[n1].first == "ArrayType"){
                vector<int> child1 = tree[n1].second;
                sttype += "[]";
                n1 = child1[0];
            }
            sttype = tree[n1].first + sttype;
        }
        else{
        sttype = tree[child[1]].first;}
        if(additionalInfo.find(child[2]) != additionalInfo.end() && additionalInfo[child[2]] == "identifier"){
            createEntry(curr_table, tree[child[2]].first, sttype, LineNumber[child[2]], getSize(sttype), stoffset, stisArray, "variable", stndim, parameters);
            stisArray = 0;
        }
        symTable(child[2]);
        return;
    }
    if(nodeName == "VariableDeclarators"){
        stwhat = "variable";
        if(tree[child[0]].first == "VariableDeclarator" || tree[child[0]].first == "VariableDeclarators" ){
            symTable(child[0]);
        }
        else{
            createEntry(curr_table, tree[child[0]].first, sttype, LineNumber[child[0]], getSize(sttype), stoffset, 0, "variable", stndim, parameters);
            modifiers[tree[child[0]].first] = stmodifiers;
            stmodifiers.clear();
            symTable(child[0]);
        }
        if(tree[child[2]].first == "VariableDeclarator" || tree[child[2]].first == "VariableDeclarators" ){
            symTable(child[2]);
        }
        else{
            
            createEntry(curr_table, tree[child[2]].first, sttype, LineNumber[child[2]], getSize(sttype), stoffset, 0, "variable", stndim, parameters);
            modifiers[tree[child[2]].first] = stmodifiers;
            stmodifiers.clear();
            symTable(child[2]);
        }
        return;
    }
    if(nodeName == "VariableDeclarator"){
        stwhat = "variable";
        stndim.clear();
        int count = 1;
        if(tree[child[2]].first == "ArrayCreationExpr"){
            vector<int> ch = tree[child[2]].second;  // ch are children of ArrayCreationExpr
            // vector<int> ch1 = tree[ch[2]].second; // ch1 are children of dimeprs;
            int temp = ch[2]; // temp is dimeprs
            if(tree[temp].first == "DimExpr"){
                vector<int> ch3 = tree[temp].second;
                stndim.push_back(stoi(tree[ch3[1]].first));
                count *= stoi(tree[ch3[1]].first);
            }
            while(tree[temp].first == "DimExprs"){
                vector<int> ch2 = tree[temp].second;
                if(tree[ch2[1]].first == "DimExpr"){
                    vector<int> ch3 = tree[ch2[1]].second;
                    stndim.push_back(stoi(tree[ch3[1]].first));
                    count *= stoi(tree[ch3[1]].first);
                }
                if(tree[ch2[0]].first == "DimExpr"){
                    vector<int> ch3 = tree[ch2[0]].second;
                    stndim.push_back(stoi(tree[ch3[1]].first));
                    count *= stoi(tree[ch3[1]].first);
                    break;
                }
                else{
                    temp = ch2[0];
                }
            }
            stsize = count * getSize(sttype);
            reverse(stndim.begin(),stndim.end());
        }
        if(tree[child[0]].first != "VariableDeclaratorId"){
            
            if(stisArray){
                createEntry(curr_table, tree[child[0]].first, sttype, LineNumber[child[0]], stsize, stoffset, 1, "variable", stndim, parameters);
                modifiers[tree[child[0]].first] = stmodifiers;
                stmodifiers.clear();
            }
            else{
                createEntry(curr_table, tree[child[0]].first, sttype, LineNumber[child[0]], getSize(sttype), stoffset, 0, "variable", stndim, parameters);
                modifiers[tree[child[0]].first] = stmodifiers;
                stmodifiers.clear();
            }
            stisArray = 0;
            
            symTable(child[0]);
            symTable(child[2]);
        }
        else if(tree[child[0]].first == "VariableDeclaratorId"){
            vector<int> child1 = tree[child[0]].second;
            int n1 = child1[0];
            sttype += "[]";
            while(tree[n1].first == "VariableDeclaratorId"){
                vector<int> child1 = tree[n1].second;
                sttype += "[]";
                n1 = child1[0];
            }
            createEntry(curr_table, tree[n1].first, sttype, LineNumber[n1], stsize, stoffset, 1, "variable", stndim, parameters);
            modifiers[tree[n1].first] = stmodifiers;
            stmodifiers.clear();

            symTable(child[0]);
        }
        return;
    }
    if(nodeName == "forStmt"){
        stname = "for" + to_string(fornum);
        fornum++;
        makeSymbolTable(stname);
        symTable(child[2]);
        symTable(child[8]);
        if(tree[child[8]].first != "Block"){
            curr_table = class_parent_table[curr_class][curr_table];
            stoffset = prevoffset;
        }
        return;
    }
    if(nodeName == "whileStmt"){
        stname = "while" + to_string(whilenum);
        whilenum++;
        makeSymbolTable(stname);
        symTable(child[4]);
        if(tree[child[4]].first != "Block"){
            curr_table = class_parent_table[curr_class][curr_table];
            stoffset = prevoffset;
        }
        return;
    }
    if(nodeName == "LocalVariableDeclaration"){
        if(tree[child[0]].first == "ArrayType"){
            stisArray = 1;
            vector<int> child1 = tree[child[0]].second;
            int n1 = child1[0];
            sttype = "[]";
            while(tree[n1].first == "ArrayType"){
                vector<int> child1 = tree[n1].second;
                sttype += "[]";
                n1 = child1[0];
            }
            sttype = tree[n1].first + sttype;
        }
        else{
        sttype = tree[child[0]].first;
        if(additionalInfo.find(child[1]) != additionalInfo.end()){
            createEntry(curr_table, tree[child[1]].first, sttype, LineNumber[child[1]], getSize(sttype), stoffset, 0, "variable", stndim, parameters);
        }
        }
        symTable(child[1]);
        return;
    }
    if(nodeName == "Block"){
        symTable(child[1]);
        curr_table = class_parent_table[curr_class][curr_table];
        stoffset = prevoffset;
        return;
        
    }
    if(nodeName == "ifThenStmt"){
        stname = "ifelse" + to_string(ifelsenum);
        ifelsenum++;
        makeSymbolTable(stname);
        symTable(child[4]);
        if(tree[child[4]].first != "Block"){
            curr_table = class_parent_table[curr_class][curr_table];
            stoffset = prevoffset;
        }
        return;
    }
    if(nodeName == "ifThenElseStmt"){
        stname = "ifelse" + to_string(ifelsenum);
        ifelsenum++;
        makeSymbolTable(stname);
        symTable(child[4]);
        if(tree[child[4]].first != "Block"){
            curr_table = class_parent_table[curr_class][curr_table];
            stoffset = prevoffset;
        }
        stname = "ifelse" + to_string(ifelsenum);
        ifelsenum++;
        makeSymbolTable(stname);
        symTable(child[6]);
        if(tree[child[6]].first != "Block"){
            curr_table = class_parent_table[curr_class][curr_table];
            stoffset = prevoffset;
        }
        return;
    }
    if(nodeName == "Assignment"){
        vector<string> mod = modifiers[tree[child[0]].first];
        if(find(mod.begin(), mod.end(), "final") != mod.end()){
            cout << "cannot assign a value to a final variable " << endl;
            exit(1); 
        }
    }

    if(additionalInfo.find(id)!= additionalInfo.end() && additionalInfo[id] == "identifier" && tree[parent[id]].first != "ClassDeclaration"){
        if(tree[parent[id]].first == "ClassInstanceCreationExpression"){
            ;
        }
        else if(tree[parent[id]].first == "QualifiedName" ){
            int pid = parent[id];
            vector<int> ch = tree[pid].second;
            if(lookup(tree[ch[0]].first) == "null"){
                cout << "Variable " << tree[ch[0]].first << " Not declared at line number: " << LineNumber[ch[0]] << endl; 
                exit(1);
            }
            string ttt = class_table[curr_class][curr_table][tree[ch[0]].first]->type ;
            if(lookup2(tree[ch[2]].first, ttt) == "null"){
                cout << "Variable " << nodeName << " Not declared at line number*: " << LineNumber[id] << endl; 
                exit(1);
            }
          
           
        }
        else if(lookup(nodeName) == "null"){
            cout << "Variable " << nodeName << " Not declared at line number: " << LineNumber[id] << endl; 
            exit(1);
        }

    }

    for(int i = 0; i < child.size(); i++){
        symTable(child[i]);
    }
    
}
void printSymbolTable(string curr_table){
  	for(auto it: (class_table[curr_class][curr_table])){
        cout << it.first.c_str() << " ";
        cout << it.second->type.c_str() << " " << (it.second)->line << " " << (it.second)->size << " " << (it.second)->offset << " "  << " " << (it.second)->isArray << " " << "." << endl;
  }
}
void PrintSymTable(){
    ofstream fout;
    fout.open("SymbolTable.csv");
    fout << "Variable,Type,Line,Size,Offset" << '\n';
        for(auto id : class_table){
        curr_class = id.first;
        fout << "Class : " << id.first << endl << endl;
        for(auto id2 : (id.second)){
            fout <<"\n";
            fout << "Printing " << id2.first << " Symbol Table" <<endl ;
            for(auto itr : id2.second){
            // for(auto itr : it.second){
        fout << itr.first.c_str() << "," << itr.second->type.c_str() << "," << (itr.second)->line << "," << (itr.second)->size << "," << (itr.second)->offset << "," << (itr.second)->what << endl;
        // }
        }
        }
    }
    fout.close();
    // cout << "**********Printing symbol table ********"<< endl;
    
    // cout << "Printing Modifers"<< endl;
    // for(auto id : modifiers){
    //     cout << "name: "<< id.first << endl;
    //     for(auto it : id.second){
    //         cout << it << " ";
    //     }
    //     cout << endl;
    // }
}
/*------------------------------------------------------------*/

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
        return ""+ tree[id].first ;
    }
    else return "_v" + to_string(id);
}

stack<string> memoryLoc;

string createArg4(int id){
    if(additionalInfo.find(id) != additionalInfo.end()){
        return "*(" + memoryLoc.top() + " + " + tree[id].first + ")";
        // return "SymbolEntry( "+ currTacClass + ", "  + tree[id].first  + ")";
    }
    else return "_v" + to_string(id);
}
string createArg5(int id){
    if(additionalInfo.find(id) != additionalInfo.end()){
        // return "*(" + memoryLoc.top() + " + " + tree[id].first + ")";
        return "SymbolEntry( "+ currTacClass + ", "  + tree[id].first  + ")";
    }
    else return "_v" + to_string(id);
}



// void printThreeAC(){
//     std::ofstream myfile;
//       myfile.open ("3ac.csv");
//     int uid = 1;
//     for(auto i = tacMap.begin(); i != tacMap.end(); i++){
//         currTacVec =  i->first ;
//         myfile << ","+ currTacVec + ": \n";
//         uid++;
//         for(int i = 0; i < tacMap[currTacVec].size(); i++){
//             if(tacMap[currTacVec][i] -> isGoto == true){
//                myfile <<"      t" + to_string(uid) + "_" +  to_string(i)  + ": ," + tacMap[currTacVec][i] -> gotoLabel + ",  " + tacMap[currTacVec][i] -> arg+ ",  " << tacMap[currTacVec][i] -> g +",  " + "t"  + to_string(uid) + "_" + tacMap[currTacVec][i] -> label + "\n";
//                 continue;
//             }
//             myfile <<"      t" + to_string(uid) + "_" +  to_string(i)  + ": ," + tacMap[currTacVec][i] -> op + ",  " + tacMap[currTacVec][i] -> arg1 + "  " + tacMap[currTacVec][i] -> arg2 + " , " +tacMap[currTacVec][i] -> res + "\n";
//         }
//     }
//      myfile.close();
// }


void printThreeAC(){
    std::ofstream myfile;
      myfile.open ("3ac.txt");
    int uid = 1;
    for(auto i = tacMap.begin(); i != tacMap.end(); i++){
        currTacVec =  i->first ;
        myfile << " "+ currTacVec + ": \n";
        uid++;
        for(int i = 0; i < tacMap[currTacVec].size(); i++){
            if(tacMap[currTacVec][i] -> isGoto == true){
               myfile <<"      t" + to_string(uid) + "" +  to_string(i)  + ": " + tacMap[currTacVec][i] -> gotoLabel + "  " + tacMap[currTacVec][i] -> arg+ "  " << tacMap[currTacVec][i] -> g +"  " + "t"  + to_string(uid) + "" + tacMap[currTacVec][i] -> label + "\n";
                continue;
            }
            myfile <<"      t" + to_string(uid) + "_" +  to_string(i)  + ": " + tacMap[currTacVec][i] -> op + "  " + tacMap[currTacVec][i] -> arg1 + "  " + tacMap[currTacVec][i] -> arg2 + "  " +tacMap[currTacVec][i] -> res + "\n";
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
map<string, string> objRef;

vector<int> getDim(string cclass, string ArrayName){
    for(auto it : class_table[cclass]){
        for(auto itr : it.second){
            if(itr.first == ArrayName){
                return itr.second -> ndim;
            }
        }
    }
    return {};
}
int getSizeOfArray(int id){
    string ArrayName = tree[id].first;
    for(auto it : class_table[nodeClass[id]]){
        for(auto itr : it.second){
            if(itr.first == ArrayName){
                return itr.second -> size;
            }
        }
    }
    return -1;
}


map<int, string> whtIsType;

vector<string> getParamsOf(int id){
    int temp = parent[id];
    string cclass;
    if(tree[temp].first == "QualifiedName"){
        cclass = customtypeof((tree[temp].second)[0]);
    }
    else{
        cclass = nodeClass[id];
    }
    string name = tree[id].first;
    vector<string> param;
    for(auto it : class_table[cclass]){
        for(auto it1 : it.second){
            if(it1.first == name){
                return (it1.second -> parameters);
            }
        }
    }
      
    return {};
}

int paramSize(vector<string> param){
    int ssize = 0;
    for(auto i : param){
        ssize += getSize(i);
    }
    return ssize;
}

int funcSize(int id){
    int temp = parent[id];
    string cclass;
    int ssize = 0;
    sym_table t;
    if(tree[temp].first == "QualifiedName"){
        cclass = customtypeof((tree[temp].second)[0]);
    }
    else{
        cclass = nodeClass[id];
    }
    string name = tree[id].first;
    vector<string> param;
    for(auto it : class_table[cclass]){
            if(it.first == name){
                t = class_table[cclass][name];
                break;
            }
    }
    for(auto it : t) {
        ssize += (it.second)->size;
    }
    return ssize;
}

vector<string> getParameters(int id){
    vector<string> params;
    while(tree[id].first == "ArgumentList"){
        vector<int> child1 = tree[id].second;
        params.push_back(whtIsType[child1[2]]);
        id = child1[0];
    }
    params.push_back(whtIsType[id]);
    return params;
}



void ThreeACHelperFunc(int id){
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
            tac* t = createTacCustom("BeginConstructor", "", "","");
            tacMap[currTacVec].push_back(t);
            tac* t1 = createTacCustom("=", "getparam", "",createArg(id));
            memoryLoc.push(createArg(id));
            tacMap[currTacVec].push_back(t1);
            ThreeACHelperFunc(temp[2]);
        }
    }
    if(tree[id].first == "FieldAccess"){
        if(tree[temp[1]].first == "."){
            childcallistrue = 0;
            ThreeACHelperFunc(temp[2]);
            tac* t1 = createTacCustom("=", createArg5(temp[2]), "",  tree[temp[2]].first);
            tacMap[currTacVec].push_back(t1);
            tac* t = createTacCustom("=", createArg4(temp[2]), "", "_v" + to_string(id));
            tacMap[currTacVec].push_back(t);
        }
    }
    if(tree[id].first == "QualifiedName"){
        if(tree[temp[1]].first == "."){
            memoryLoc.push(objRef[createArg(temp[0])]);
            childcallistrue = 0;
            ThreeACHelperFunc(temp[2]);
            tac* t1 = createTacCustom("=", createArg5(temp[2]), "",  tree[temp[2]].first);
            tacMap[currTacVec].push_back(t1);
            tac* t = createTacCustom("=", createArg4(temp[2]), "", "_v" + to_string(id));
            tacMap[currTacVec].push_back(t);
            memoryLoc.pop();
        }
    }
    if(tree[id].first == "FormalParameterList"){
        childcallistrue = 0;
        if(tree[temp[0]].first == "FormalParameterList"){
            ThreeACHelperFunc(temp[0]);
            ThreeACHelperFunc(temp[2]);
            vector<int> temp1 = tree[temp[2]].second;
            tac* t = createTacCustom("=","getparam", "", createArg3(temp1[2]));
            tacMap[currTacVec].push_back(t);
            
        }
        else{
           
            ThreeACHelperFunc(temp[0]);
             vector<int>  temp1 = tree[temp[0]].second;
            tac* t1 = createTacCustom("=","getparam",  "", createArg3(temp1[2]));
            tacMap[currTacVec].push_back(t1);
             ThreeACHelperFunc(temp[2]);
            temp1 = tree[temp[2]].second;
            tac* t = createTacCustom("=","getparam", "", createArg3(temp1[2]));
            tacMap[currTacVec].push_back(t);
        }
    }

    if(tree[id].first == "ReturnStatement"){
        childcallistrue = 0;
        ThreeACHelperFunc(temp[1]);
        tac* t = new tac();
        t -> op = "Return";
        t -> arg1 = createArg(temp[1]);
        t -> arg2 = "// load return value to return register";
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
        int arrId = -1;
        while(tree[nodeNum].first == "ArrayAccess"){
            vector<int> ArrayAccessChild = tree[nodeNum].second;
            tempId = ArrayAccessChild[2];
            if(tree[ArrayAccessChild[0]].first == "ArrayAccess"){
                ThreeACHelperFunc(ArrayAccessChild[2]);
                 tempVec.push_back(createArg(ArrayAccessChild[2]));
            }
            else{
                ArrayName = tree[ArrayAccessChild[0]].first;
                arrId = ArrayAccessChild[0];
                ThreeACHelperFunc(ArrayAccessChild[2]);
                tempVec.push_back(createArg(ArrayAccessChild[2]));
            }
            nodeNum = ArrayAccessChild[0];
        }
        string tempIds = "_v" + to_string(tempId);
        vector<int> dims = getDim(nodeClass[arrId], ArrayName);
        // cout << "here1" << endl;
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
    if(tree[id].first == "ArrayCreationExpr"){
        childcallistrue = 0;
        vector<int> temp2 = tree[parent[id]].second;
        int arrayId = temp2[0];
        while(tree[arrayId].first == "VariableDeclaratorId"){
            vector<int> temp3 = tree[arrayId].second;
            arrayId = temp3[0];
        }
        int sizeOfArr = getSizeOfArray(arrayId);
        cout << "size of array " << tree[arrayId].first << "  " << sizeOfArr << endl;
        tac* t = createTacCustom("=", to_string(sizeOfArr), "", "t1");
        tacMap[currTacVec].push_back(t);
        tac* t1 = createTacCustom("param", "t1", "", "");
        tacMap[currTacVec].push_back(t1);
        tac *t2 = createTacCustom("call", "allocmem", "1", "_v" + to_string(id));
        tacMap[currTacVec].push_back(t2);

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
            int funcSize1 = funcSize(temp[0]);
            // cout << "Funcsize " << funcSize1 << endl; 
            t = createTacCustom("stackPointer -= ", to_string(funcSize1), "// Manipulating stack (equal to size of function)","");
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
                tac* t = createTacCustom("LCall", tree[temp[i-1]].first, "", "");
                tacMap[currTacVec].push_back(t);
                t = createTacCustom("=", "returnRegister", "", createArg(id));
                tacMap[currTacVec].push_back(t);
                t = createTacCustom("stackPointer", "=", "basePointer", "");
                tacMap[currTacVec].push_back(t);
                t = createTacCustom("Adjust Base Pointer to previous base pointer", "", "", "");
                tacMap[currTacVec].push_back(t);
                
                vector<string> param = getParamsOf(temp[0]);
                int paramSize1 = paramSize(param);
                // cout << paramSize1 << endl; 
                 t = createTacCustom("stackpointer +=", to_string(paramSize1), "// Remove parameters passed into stack", "");
                tacMap[currTacVec].push_back(t);
                 
            }
        }
    }
    if(tree[id].first == "ClassInstanceCreationExpression"){
        int classmem = classOffset[curr_class];
        // cout << classmem << endl;
        childcallistrue = 0;
        for(int i = 0; i < temp.size(); i++){
            if(tree[temp[i]].first == "(") {
                if(tree[temp[i+1]].first != ""){
                    ThreeACHelperFunc(temp[i+1]);
                }
                tac *t5 = createTacCustom("=",  to_string(classmem), "", "_v" + to_string(temp[i]));
                tacMap[currTacVec].push_back(t5);
                tac* t4 = createTacCustom("=", "param", "_v" + to_string(temp[i]), "");
                tacMap[currTacVec].push_back(t4);
                tac* t3 = createTacCustom("call", "allocmem", "", "1");
                tac* t = createTacCustom("=", "PopParam", "// Store Object ref", "_v" + to_string(temp[i+2]));
                tacMap[currTacVec].push_back(t);
                tac* t1 = createTacCustom("PushParam", "", "", "_v" + to_string(temp[i+2]));
                tacMap[currTacVec].push_back(t1);
                tac* t2 = createTacCustom("=", "LCall", tree[temp[i-1]].first + ".Constructor", "");
                tacMap[currTacVec].push_back(t2);

                /************** */
                 t = createTacCustom("=", "ConstructorValReturned", "", createArg(id));
                tacMap[currTacVec].push_back(t);
                t = createTacCustom("stackPointer", "=", "basePointer", "");
                tacMap[currTacVec].push_back(t);
                t = createTacCustom("Adjust Base Pointer to previous base pointer", "", "", "");
                tacMap[currTacVec].push_back(t);
                
                vector<string> param = getParamsOf(temp[0]);
                int paramSize1 = paramSize(param);
                // cout << paramSize1 << endl; 
                 t = createTacCustom("stackpointer +=", to_string(paramSize1), "// Remove parameters passed into stack", "");
                tacMap[currTacVec].push_back(t);


                int t9 = parent[id];
                vector<int> t10 = tree[t9].second;
                string t11 = createArg(t10[0]);
                objRef[t11] = "_v" + to_string(temp[i+2]);
                 
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

    // if(tree[id].first == "VariableDeclarator"){
    //     int child1 = temp[0];
    //     while(tree[child1].first == "VariableDeclaratorId"){
    //         vector<int> temp1 = tree[child1].second;
    //         child1 = temp1[0];
    //     }
    //     tac* t = createTacCustom("=", createArg(temp[2]), "", createArg(child1));
    //     tacMap[currTacVec].push_back(t);
    // }

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
    // if(tree[id].first == "VariableDeclarator"){tacMap[currTacVec].push_back(createTac1(id));}
    if(tree[id].first == "InclusiveOrExpression"){tacMap[currTacVec].push_back(createTac2(id));}
    if(tree[id].first == "ExclusiveOrExpression"){tacMap[currTacVec].push_back(createTac2(id));}
    if(tree[id].first == "AndExpression"){tacMap[currTacVec].push_back(createTac2(id));}
    if(tree[id].first == "ShiftExpression"){tacMap[currTacVec].push_back(createTac2(id));} 
     if(tree[id].first == "VariableDeclarator"){
        int child1 = temp[0];
        while(tree[child1].first == "VariableDeclaratorId"){
            vector<int> temp1 = tree[child1].second;
            child1 = temp1[0];
        }
        tac* t = createTacCustom("=", createArg(temp[2]), "", createArg(child1));
        tacMap[currTacVec].push_back(t);
    }
}
// ****************************************************************

/*------------------------------------------------------------*/

/* ------------------------------------------------------------------*/
void typeChecker(){
    // my addition **** TYPE CHECKING *********
    /* map<int, pair<string, vector<int> >> typeCheck; */
    unordered_map <int,bool> visitedType;
    unordered_map <int, bool>terminal;
    unordered_map<string, pair<int, vector<string>>> methodParams;
    cout << "****TREE********" << endl;
    map<int, string> whtIsType;
    for(auto itr = tree.begin();itr!=tree.end();itr++){
        visitedType[itr->first]=  false;
        terminal[itr->first] = false;
        whtIsType[itr->first]=  "x";
         cout<<itr->first<<" [ "<< (itr->second).first<<" ]    -> ";
         cout<<"{ "<<additionalInfo[itr->first]<<" }";
        for(int j=0; j<(itr->second).second.size();j++){
            
            cout<<(itr->second).second[j]<<" ";
        }
        cout<<"\n"; 
    }
    
    /* cout<<visitedType.size(); */

    /* typeCheck = tree; */
    int typeErrorFlag = 0;

        cout << "****  Typecheck  ********" << endl;
        // consider float and double as same


}
/* ------------------------------------------------------------*/


void tpc(int id){
    bool allVisited = true;
    // if(tree[id].first == "MethodInvocation"){
    //     // cout << "im in methoid"<< endl;
    //     string is_type = whtIsType[tree[id]]
    // }
    vector<int> child = tree[id].second;
    if(child.size() == 0 && id !=-1  && tree[parent[id]].first != "ClassDeclaration"){
        if(additionalInfo[id] == "identifier"){
            whtIsType[id] = customtypeof(id);
            // whtIsType[id] = "int";
            if (whtIsType[id]=="double") whtIsType[id]="float";
        }
        else if(additionalInfo[id] == "type"){
            whtIsType[id] = tree[id].first;
            if (whtIsType[id]=="double") whtIsType[id]="float";
        }

        else if(additionalInfo[id]=="IntegerLiteral")  whtIsType[id] = "int";
        else if(additionalInfo[id]=="CharacterLiteral")  whtIsType[id] = "char";
        else if(additionalInfo[id]=="FloatingPointLiteral")  whtIsType[id] = "float";
        else if(additionalInfo[id]=="BooleanLiteral")  whtIsType[id] = "boolean";
        else if(additionalInfo[id]=="StringLiteral")  whtIsType[id] = "String";
        else if(additionalInfo[id]=="NullLiteral")  whtIsType[id] = "null";
    }
    int ischildcallistrue = 1;
    for(int i = 0; i < child.size(); i++){
        
        tpc(child[i]);
    }
    
     if(tree[id].first == "MethodInvocation"){
        
        vector<int> child1 = tree[id].second;
        int s;
        vector<string> params, parameters;
        if(tree[child1[0]].first != "QualifiedName"){
            params = getParamsOf(child1[0]);
            parameters = getParameters(child1[2]);
            whtIsType[id] = customtypeof(child1[0]);
        }
        else{
            vector<int> child2 = tree[child1[0]].second;
            params = getParamsOf(child2[2]);
            parameters = getParameters(child1[2]);
        }
            if(parameters.size() != params.size()){
                cout << "Error: actual and formal argument lists differ in length" << endl;
                // exit(0);
            }
            else{
                for(int i=0; i<params.size(); i++){
                    if(params[i] != parameters[i]){
                        if(parameters[i] == "int" && params[i] == "float"){
                            ;
                        }
                        else if(parameters[i] == "char" && params[i] == "int"){
                            ;
                        }
                        else if(parameters[i] == "char" && params[i] == "float"){
                            ;
                        }
                        else if(parameters[i] == "int" && (params[i] == "boolean" || params[i] == "bool")){
                            ;
                        }
                        else{
                        cout << "Error: incompatible types, " << parameters[i] << " and " << params[i] << endl;}
                        // exit(0);
                    }
                }
            }
        }
    if(tree[id].first == "ArrayCreationExpr"){
        
        string typel, typer,  boxl = "", boxr = "";
        int diml = 0, dimr = 0;
        
        vector<int> ch0 = tree[id].second;
        typer = tree[ch0[1]].first;
        
        if(tree[ch0[2]].first == "DimExpr"){
            boxr = "[]";
            dimr = 1;
        }
        else{
            int temp = ch0[2];
            while(tree[temp].first == "DimExprs"){
                vector<int> ch1 = tree[temp].second;
                dimr += 1;
                boxr += "[]";
                temp = ch1[0];
            }
            dimr += 1;
            boxr += "[]";
        }
        
        int id1 = parent[parent[id]];
        vector<int> ch = tree[id1].second;
        if(tree[id1].first == "FieldDeclaration"){
        if(tree[ch[1]].first == "ArrayType"){
            int temp = ch[1];
            while(tree[temp].first == "ArrayType"){
                vector<int> ch1 = tree[temp].second;
                diml += 1;
                boxl += "[]";
                temp = ch1[0];
            }
            typel = tree[temp].first;
        }
        else{
            typel = tree[ch[1]].first;
            int temp1 = ch[2];
            vector<int> ch1 = tree[temp1].second;
            int temp = ch1[0];
            while(tree[temp].first == "VariableDeclaratorId"){
                vector<int> ch1 = tree[temp].second;
                diml += 1;
                boxl += "[]";
                temp = ch1[0];
            }
        }
        }
        else if(tree[id1].first == "LocalVariableDeclaration"){
            if(tree[ch[0]].first == "ArrayType"){
            int temp = ch[0];
            while(tree[temp].first == "ArrayType"){
                vector<int> ch1 = tree[temp].second;
                diml += 1;
                boxl += "[]";
                temp = ch1[0];
            }
            typel = tree[temp].first;
        }
        else{
            typel = tree[ch[0]].first;
            int temp1 = ch[1];
            vector<int> ch1 = tree[temp1].second;
            int temp = ch1[0];
            while(tree[temp].first == "VariableDeclaratorId"){
                vector<int> ch1 = tree[temp].second;
                diml += 1;
                boxl += "[]";
                temp = ch1[0];
            }
        }
        }
        if(typel != typer || diml != dimr){
            cout << "error: incompatible types: " << typer + boxr << " cannot be converted to " << typel + boxl << endl;
        }
    }
    if(tree[id].first == "ArrayAccess"){
        int childnum = (tree[id].second)[0];
        if(additionalInfo.find(childnum) != additionalInfo.end()){
            whtIsType[id] = customtypeof(childnum);
        }
        else{
            whtIsType[id] = whtIsType[childnum];
        }
        if(tree[parent[id]].first != "ArrayAccess"){
        int temp = id;
        string typer, typel;
        vector<int> dims;
        while(tree[temp].first == "ArrayAccess"){
            vector<int> ch = tree[temp].second;
            temp = ch[0];
            dims.push_back(stoi(tree[ch[2]].first));
        }
        string arrname = tree[temp].first;
        typer = whtIsType[temp];
        string cclass = nodeClass[temp];
        vector<int> dimensions = getDim(cclass, arrname);
        reverse(dimensions.begin(), dimensions.end());
        if(dims.size() != dimensions.size()){
            cout << "error: array required, but int found" << endl;
        }
        else{
            for(int i=0; i<dims.size(); i++){
                if(dims[i] < 0 || dims[i] >= dimensions[i]){
                    cout << "Index " << dims[i] << " out of bounds for length " << dimensions[i] << endl;
                }
            }
        }
        int id1 = parent[parent[id]];
        int id2 = parent[id];
        if(tree[id].first == "FieldDeclaration" || tree[id].first == "LocalVariableDeclaration"){
        if(tree[id1].first == "FieldDeclaration"){
            vector<int> ch = tree[id1].second;
            typel = tree[ch[1]].first;
        }
        else if(tree[id1].first == "LocalVariableDeclaration"){
            vector<int> ch = tree[id1].second;
            typel = tree[ch[0]].first;
        }
        if(typel != typer){
            cout << "error: incompatible types: possible lossy conversion from " << typer << " to " << typel << endl;
        }
        }
    }
    }
    if(tree[id].first == "Assignment"){
        // if(tree[child[0]].first == "ArrayAccess" || tree[child[2]].first == "ArrayAccess"){
        //     cout << whtIsType[child[0]] << endl;
        // }
        if(whtIsType[child[0]] == whtIsType[child[2]]){
            whtIsType[id] = whtIsType[child[0]];
            tree[child[1]].first += "_" + whtIsType[child[0]];
        }
        else if((whtIsType[child[0]]=="int" && whtIsType[child[2]]=="float") ){
            whtIsType[id] = "error";
            cout << "Type Error at line " << LineNumber[child[0]] << ". Incompatible types: possible lossy conversion from double to int"  << endl;
            exit(1);
        }
        else if((whtIsType[child[2]]=="int" && whtIsType[child[0]]=="float") ){
            whtIsType[child[0]]="float";
            whtIsType[child[2]]="float";
            whtIsType[id] =  "float";
            tree[child[1]].first += "_float";
        }
        else if((whtIsType[child[0]]=="int" && whtIsType[child[2]]=="char") ||
        (whtIsType[child[2]]=="int" && whtIsType[child[0]]=="char") ){
            whtIsType[child[0]]="int";
            whtIsType[child[2]]="int";
            whtIsType[id] =  "int";
            tree[child[1]].first += "_int";
        }
        else if((whtIsType[child[0]]=="float" && whtIsType[child[2]]=="char") ||
        (whtIsType[child[2]]=="float" && whtIsType[child[0]]=="char") ){
            whtIsType[child[0]]="float";
            whtIsType[child[2]]="float";
            whtIsType[id] =  "float";
            tree[child[1]].first += "_float";
        }
        else{
            whtIsType[id] = "error";
            cout << "Type Error at line " << LineNumber[child[0]] << endl;
            exit(1);
        }
    }
    if(tree[id].first == "MultiplicativeExpression" || tree[id].first == "AdditiveExpression"){
        if(whtIsType[child[0]]  == whtIsType[child[2]]){
            whtIsType[id] =  whtIsType[child[0]];
            tree[child[1]].first += "_" + whtIsType[child[0]];
        }
        else if((whtIsType[child[0]]=="int" && whtIsType[child[2]]=="float") ||
        (whtIsType[child[2]]=="int" && whtIsType[child[0]]=="float") ){
            whtIsType[child[0]]="float";
            whtIsType[child[2]]="float";
            whtIsType[id] =  "float";
            tree[child[1]].first += "_float";
        }
        else if((whtIsType[child[0]]=="int" && whtIsType[child[2]]=="char") ||
        (whtIsType[child[2]]=="int" && whtIsType[child[0]]=="char") ){
            whtIsType[child[0]]="int";
            whtIsType[child[2]]="int";
            whtIsType[id] =  "int";
            tree[child[1]].first += "_int";
        }
        else if((whtIsType[child[0]]=="float" && whtIsType[child[2]]=="char") ||
        (whtIsType[child[2]]=="float" && whtIsType[child[0]]=="char") ){
            whtIsType[child[0]]="float";
            whtIsType[child[2]]="float";
            whtIsType[id] =  "float";
            tree[child[1]].first += "_float";
        }
        else{
            whtIsType[id] = "error";
            cout << "Type Error at line " << LineNumber[child[0]] << endl;
            exit(1);
        }
    }

    else if(tree[id].first == "ShiftExpression" ){
        if(whtIsType[child[0]]  == whtIsType[child[2]] && (whtIsType[child[1]]!="String" ||whtIsType[child[1]]!="float")){
            whtIsType[id] =  whtIsType[child[0]];
            tree[child[1]].first += "_" + whtIsType[child[0]];
        }
        else if((whtIsType[child[0]]=="int" && whtIsType[child[2]]=="char") ||
        (whtIsType[child[2]]=="int" && whtIsType[child[0]]=="char") ){
            whtIsType[child[0]]="int";
            whtIsType[child[2]]="int";
            whtIsType[id] =  "int";
            tree[child[1]].first += "_int";
        }
        else{
            whtIsType[id] = "error";
            cout << "Type Error at line " << LineNumber[child[0]] << endl;
            exit(1);
        }
    }

    else if(tree[id].first == "RelationalExpression" ){
        if(whtIsType[child[0]]  == whtIsType[child[2]] && whtIsType[child[1]]!="String"){
            whtIsType[id] =  whtIsType[child[0]];
            tree[child[1]].first += "_" + whtIsType[child[0]];
        }
        else if((whtIsType[child[0]]=="int" && whtIsType[child[2]]=="float") ||
        (whtIsType[child[2]]=="int" && whtIsType[child[0]]=="float") ){
            whtIsType[child[0]]="float";
            whtIsType[child[2]]="float";
            whtIsType[id] =  "float";
            tree[child[1]].first += "_float";
        }
        else if((whtIsType[child[0]]=="int" && whtIsType[child[2]]=="char") ||
        (whtIsType[child[2]]=="int" && whtIsType[child[0]]=="char") ){
            whtIsType[child[0]]="int";
            whtIsType[child[2]]="int";
            whtIsType[id] =  "int";
            tree[child[1]].first += "_int";
        }
        else if((whtIsType[child[0]]=="float" && whtIsType[child[2]]=="char") ||
        (whtIsType[child[2]]=="float" && whtIsType[child[0]]=="char") ){
            whtIsType[child[0]]="float";
            whtIsType[child[2]]="float";
            whtIsType[id] =  "float";
            tree[child[1]].first += "_float";
        }
        else if(whtIsType[child[0]]!="null" || whtIsType[child[2]]=="null"){
            whtIsType[id] = "error";
            cout << "Type Error at line " << LineNumber[child[0]] << endl;
            // exit(1);
        }
    }
    else if(tree[id].first == "VariableDeclarator" && (tree[(tree[id].second)[2]].first != "ArrayCreationExpr" && tree[(tree[id].second)[2]].first != "ArrayAccess")){
        if(whtIsType[child[0]]  == whtIsType[child[2]]){
            whtIsType[id] =  whtIsType[child[0]];
            tree[child[1]].first += "_" + whtIsType[child[0]];
        }
        else if((whtIsType[child[2]]=="int" && whtIsType[child[0]]=="float") ){
            whtIsType[child[0]]="float";
            whtIsType[child[2]]="float";
            whtIsType[id] =  "float";
            tree[child[1]].first += "_float";
        }
        else if((whtIsType[child[0]]=="int" && whtIsType[child[2]]=="char") ||
        (whtIsType[child[2]]=="int" && whtIsType[child[0]]=="char") ){
            whtIsType[child[0]]="int";
            whtIsType[child[2]]="int";
            whtIsType[id] =  "int";
            tree[child[1]].first += "_int";
        }
        else if((whtIsType[child[0]]=="float" && whtIsType[child[2]]=="char") ){
            whtIsType[child[0]]="float";
            whtIsType[child[2]]="float";
            whtIsType[id] =  "float";
            tree[child[1]].first += "_float";
        }
        else{
            // cout << whtIsType[child[0]] << ' ' << whtIsType[child[2]] << endl;
            whtIsType[id] = "error";
            cout << "Type Error at line " << LineNumber[child[0]] << endl;
            exit(1);
        }
        
    }
    
}


void print(){
    ForClass(root);
    symTable(root);      //fills all the class name in the class_table
    // for(auto it : scope){
    //     cout << tree[it.first].first << " " << it.second << endl;
    // }
    // for(auto i : classOffset){
    //     cout << i.first << " " << i.second << endl;
    // }
    PrintSymTable();

    // tpc(root);
    // for(auto itr = whtIsType.begin();itr!=whtIsType.end();itr++){
    //     cout<<itr->first<<": [ "<<tree[itr->first].first<<" ]   "<<itr->second<<endl;
    // }
    // ***************************
    cout << "******************** Three AC Printing**************" << endl;
    ThreeACHelperFunc(root);
    printThreeAC();
    // ****************************
    // typeChecker();
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
VariableInitializer     : Expression        {$$ = $1;}
                        | ArrayInitializer  {$$ = $1;}
                        ;
Type                    : PrimitiveType     {$$ = $1;}
                        | ReferenceType     {$$ = $1;}
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
                        | TILDA UnaryExpression         {int uid = makenode("UnaryExpressionNot+-"); addChild(uid, $1);  $$=uid;}
                        | EXCLAMATORY UnaryExpression       {int uid = makenode("UnaryExpressionNot+-"); addChild(uid, $1);  $$=uid;}
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
ReferenceType           : Name                   {$$ = $1;}
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
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s %s at line %d\n", s, yylval, line);
	exit(1);
}