/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output, and Bison version.  */
#define YYBISON 30802

/* Bison version string.  */
#define YYBISON_VERSION "3.8.2"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 1 "parser.y"

#include<bits/stdc++.h>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <vector>
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
int makenode( string name){
    countnode++;
    vector<int> childs;
    tree[countnode] = {name, childs};
    return countnode;
}
int makenode( string name, string type){
    countnode++;
    vector<int> childs;
    tree[countnode] = {name, childs};
    additionalInfo[countnode] = type;
    LineNumber[countnode] = line;
    return countnode;
}


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

int getSize(string id){
  if(id == "char") return sizeof(char);
  if(id == "short") return sizeof(short);
  if(id == "int") return sizeof(int);
  if(id == "float") return sizeof(float);
  if(id == "double") return sizeof(double);

  return 8; // for any ptr
}


string stname = "program";
string mname;
string sttype;
int stline;
ull stsize = 8;
ull stoffset;
vector<string> stmodifiers;
string stwhat;
vector<string> parameters;
int flag = 0;

typedef struct sym_entry{
	string type;
    int line = 0;
	ull size = 0;
	ull offset = 0;
    vector<string> modifiers;
    string what;
    string scope;
}sym_entry;


typedef map<string, sym_entry* > sym_table;
string curr_table = "null";
map<string, sym_table> table;
map<string, string> parent_table;
vector<string> key_words = {"abstract","continue","for","new","switch","assert","default","if","package","synchronized","boolean","do","goto","private","this","break","double","implements","protected","throw","byte","else","import","public","throws","case","enum","instanceof","return","transient","catch","extends","int","short","try","String","char","final","interface","static","void","class","finally","long","strictfp","volatile","const","float","native","super","while","_","exports","opens","requires","uses","module","permit","sealed","var","non-sealed","provides","to","with","open","record","transitive","yield"}; 
map<string, int> keywords;

void printSymbolTable(string curr_table){
  	for(auto it: (table[curr_table])){
        cout << it.first.c_str() << " ";
        for(auto j : (it.second)->modifiers){
            cout << j << " ";
        }
        cout << it.second->type.c_str() << " " << (it.second)->line << " " << (it.second)->size << " " << (it.second)->offset << " " << (it.second)->what << " " << (it.second)->scope << "." << endl;
  }
}

void createEntry(string name, string temp, vector<string> modifiers, string type, int line, ull size, ull offset, string what, string scope){
    
    sym_entry* ent = new sym_entry();
        ent->modifiers = modifiers;
	    ent->type = type;
        ent->line = line;
	    ent->size = size;
	    ent->offset = offset;
	    ent->what = what;
        ent->scope = scope;
        table[name].insert(make_pair(temp, ent));
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

bool lookup(string id){
	string temp = curr_table;

	while(temp != "null"){
		if((table[temp]).find(id)!=(table[temp]).end()) return 1;
		temp = parent_table[temp];
	}
	return 0;
}

void symTable(int n){

    vector<int> temp = (tree[n].second);
    if(temp.size() == 0)  {

        if(additionalInfo[n] == "modifier"){
            stmodifiers.push_back(tree[n].first);
        }
        else if(additionalInfo[n] == "type"){
            sttype = tree[n].first;
            stsize = getSize(tree[n].first);
            if(flag == 1){
                parameters.push_back(sttype);
            }
        }
        else if(additionalInfo[n] == "identifier" && (tree[parent[n]].first == "VariableDeclarator" || tree[parent[n]].first == "VariableDeclarators" || tree[parent[n]].first == "ConstructorDeclarator" || tree[parent[n]].first == "MethodDeclarator" || tree[parent[n]].first == "ClassDeclaration" || tree[parent[n]].first == "FormalParameter" || tree[parent[n]].first == "LocalVariableDeclaration" || tree[parent[n]].first == "FieldDeclaration")){
            stname = tree[n].first;
            createEntry(curr_table, stname, stmodifiers, sttype, LineNumber[n], stsize, 0, stwhat, curr_table);
            stmodifiers.clear();
        }
        if(tree[n].first == "{" && (tree[parent[n]].first == "ClassBody")){
            makeSymbolTable(stname);
        }
        else if(tree[n].first == "{" && (tree[parent[parent[n]]].first == "forStmt")){
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
        else if(tree[n].first == "(" && (tree[parent[n]].first == "ConstructorDeclarator" || tree[parent[n]].first == "MethodDeclarator")){
            flag = 1;
            mname = stname;
            makeSymbolTable(stname);
        }
        else if(tree[n].first == ")" && (tree[parent[n]].first == "ConstructorDeclarator" || tree[parent[n]].first == "MethodDeclarator")){
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
            parameters.clear();
            table.insert(make_pair(mname, new_table));
            for(auto it : table[mname]){
                (it.second)->scope = mname;
            }

            string par = parent_table[oname];
            parent_table.erase(oname);
            parent_table.insert(make_pair(mname,par));
            // string parpar = parent_table[par];
            // sym_table ptable = table[par];
            
            // if(ptable.find(oname) != ptable.end()){
            //     sym_entry* newentry = ptable[oname];
                // ptable.erase(oname);
                // ptable.insert(make_pair(mname, newentry));
            // }
            // table.erase(par);
            // table.insert(make_pair(par,ptable));
            // parent_table.erase(oname);
            // parent_table.insert(make_pair(mname,par));
            // parent_table.erase(par);
            // parent_table.insert(make_pair(par, parpar));

            curr_table = mname;
            flag2 = 0;
            change(parent[n]);

        }
        // else if(tree[n].first == "}" && (tree[parent[parent[n]]].first == "forStmt")){
        //     curr_table = parent_table[curr_table];
        // }
        else if(tree[n].first == "}" && (tree[parent[n]].first == "ClassBody" || tree[parent[n]].first == "Block" || tree[parent[n]].first == "ConstructorBody")){
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
        else if(tree[n].first == "FieldDeclaration"){
            stwhat = "variable";
        }
        else if(tree[n].first == "ConstructorDeclaration"){
            stwhat = "constructor";
        }
        symTable(temp[i]);  
    }
}

void checkScope(int n){
    // cout << tree[n].first << endl;
    
    vector<int> temp = (tree[n].second);
    if(temp.size() == 0)  {
        
        if(tree[n].first == "{" && (tree[parent[n]].first == "ClassBody")){
            curr_table = scope[n];
        }
        else if(tree[n].first == "(" && (tree[parent[n]].first == "ConstructorDeclarator" || tree[parent[n]].first == "MethodDeclarator")){
            curr_table = scope[n];
        }
        else if(tree[n].first == "}" && (tree[parent[n]].first == "ClassBody" || tree[parent[n]].first == "Block" || tree[parent[n]].first == "ConstructorBody")){
            curr_table = scope[n];
        }
        else if(tree[n].first == "{" && (tree[parent[parent[n]]].first == "forStmt")){
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
            
            if(!(lookup(tree[n].first))){
                cout << tree[n].first << " not declared!!" << endl;}
        }
    }

    for(int i = 0; i < temp.size(); i++){
        checkScope(temp[i]);  
    }
}

void print(){
    symTable(root);
    curr_table = "program";
    checkScope(root);
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



#line 406 "parser.tab.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

#include "parser.tab.h"
/* Symbol kind.  */
enum yysymbol_kind_t
{
  YYSYMBOL_YYEMPTY = -2,
  YYSYMBOL_YYEOF = 0,                      /* "end of file"  */
  YYSYMBOL_YYerror = 1,                    /* error  */
  YYSYMBOL_YYUNDEF = 2,                    /* "invalid token"  */
  YYSYMBOL_keywordT = 3,                   /* keywordT  */
  YYSYMBOL_newlineT = 4,                   /* newlineT  */
  YYSYMBOL_identifierT = 5,                /* identifierT  */
  YYSYMBOL_IntegerLiteralT = 6,            /* IntegerLiteralT  */
  YYSYMBOL_FloatingPointLiteralT = 7,      /* FloatingPointLiteralT  */
  YYSYMBOL_BooleanLiteralT = 8,            /* BooleanLiteralT  */
  YYSYMBOL_CharacterLiteralT = 9,          /* CharacterLiteralT  */
  YYSYMBOL_StringLiteralT = 10,            /* StringLiteralT  */
  YYSYMBOL_NullLiteralT = 11,              /* NullLiteralT  */
  YYSYMBOL_TextBlockT = 12,                /* TextBlockT  */
  YYSYMBOL_NEWT = 13,                      /* NEWT  */
  YYSYMBOL_TRYT = 14,                      /* TRYT  */
  YYSYMBOL_CATCHT = 15,                    /* CATCHT  */
  YYSYMBOL_SYNCHRONIZEDT = 16,             /* SYNCHRONIZEDT  */
  YYSYMBOL_FINALLYT = 17,                  /* FINALLYT  */
  YYSYMBOL_THROWT = 18,                    /* THROWT  */
  YYSYMBOL_THROWST = 19,                   /* THROWST  */
  YYSYMBOL_RETURNT = 20,                   /* RETURNT  */
  YYSYMBOL_BREAKT = 21,                    /* BREAKT  */
  YYSYMBOL_CONTINUET = 22,                 /* CONTINUET  */
  YYSYMBOL_IFT = 23,                       /* IFT  */
  YYSYMBOL_ELSET = 24,                     /* ELSET  */
  YYSYMBOL_SWITCHT = 25,                   /* SWITCHT  */
  YYSYMBOL_CASET = 26,                     /* CASET  */
  YYSYMBOL_FORT = 27,                      /* FORT  */
  YYSYMBOL_WHILET = 28,                    /* WHILET  */
  YYSYMBOL_DOTT = 29,                      /* DOTT  */
  YYSYMBOL_CLASST = 30,                    /* CLASST  */
  YYSYMBOL_INSTANCEOFT = 31,               /* INSTANCEOFT  */
  YYSYMBOL_THIST = 32,                     /* THIST  */
  YYSYMBOL_SUPERT = 33,                    /* SUPERT  */
  YYSYMBOL_ABSTRACTT = 34,                 /* ABSTRACTT  */
  YYSYMBOL_ASSERTT = 35,                   /* ASSERTT  */
  YYSYMBOL_BOOLEANT = 36,                  /* BOOLEANT  */
  YYSYMBOL_BYTET = 37,                     /* BYTET  */
  YYSYMBOL_SHORTT = 38,                    /* SHORTT  */
  YYSYMBOL_INTT = 39,                      /* INTT  */
  YYSYMBOL_LONGT = 40,                     /* LONGT  */
  YYSYMBOL_CHART = 41,                     /* CHART  */
  YYSYMBOL_STRINGT = 42,                   /* STRINGT  */
  YYSYMBOL_FLOATT = 43,                    /* FLOATT  */
  YYSYMBOL_DOUBLET = 44,                   /* DOUBLET  */
  YYSYMBOL_EXTENDST = 45,                  /* EXTENDST  */
  YYSYMBOL_PACKAGET = 46,                  /* PACKAGET  */
  YYSYMBOL_IMPORTT = 47,                   /* IMPORTT  */
  YYSYMBOL_STATICT = 48,                   /* STATICT  */
  YYSYMBOL_MODULET = 49,                   /* MODULET  */
  YYSYMBOL_REQUIREST = 50,                 /* REQUIREST  */
  YYSYMBOL_EXPORTST = 51,                  /* EXPORTST  */
  YYSYMBOL_OPENST = 52,                    /* OPENST  */
  YYSYMBOL_OPENT = 53,                     /* OPENT  */
  YYSYMBOL_USEST = 54,                     /* USEST  */
  YYSYMBOL_PROVIDEST = 55,                 /* PROVIDEST  */
  YYSYMBOL_WITHT = 56,                     /* WITHT  */
  YYSYMBOL_TRANSITIVET = 57,               /* TRANSITIVET  */
  YYSYMBOL_PROTECTEDT = 58,                /* PROTECTEDT  */
  YYSYMBOL_PRIVATET = 59,                  /* PRIVATET  */
  YYSYMBOL_PUBLICT = 60,                   /* PUBLICT  */
  YYSYMBOL_FINALT = 61,                    /* FINALT  */
  YYSYMBOL_SEALEDT = 62,                   /* SEALEDT  */
  YYSYMBOL_NONSEALEDT = 63,                /* NONSEALEDT  */
  YYSYMBOL_TRANSIENTT = 64,                /* TRANSIENTT  */
  YYSYMBOL_VOLATILET = 65,                 /* VOLATILET  */
  YYSYMBOL_STRICTFPT = 66,                 /* STRICTFPT  */
  YYSYMBOL_IMPLEMENTST = 67,               /* IMPLEMENTST  */
  YYSYMBOL_PERMITST = 68,                  /* PERMITST  */
  YYSYMBOL_VOIDT = 69,                     /* VOIDT  */
  YYSYMBOL_ENUMT = 70,                     /* ENUMT  */
  YYSYMBOL_DEFAULTT = 71,                  /* DEFAULTT  */
  YYSYMBOL_VART = 72,                      /* VART  */
  YYSYMBOL_TOT = 73,                       /* TOT  */
  YYSYMBOL_YIELDT = 74,                    /* YIELDT  */
  YYSYMBOL_INTERFACET = 75,                /* INTERFACET  */
  YYSYMBOL_RECORDT = 76,                   /* RECORDT  */
  YYSYMBOL_NATIVET = 77,                   /* NATIVET  */
  YYSYMBOL_OPEN_BRACKETST = 78,            /* OPEN_BRACKETST  */
  YYSYMBOL_CLOSE_BRACKETST = 79,           /* CLOSE_BRACKETST  */
  YYSYMBOL_OPEN_CURLYT = 80,               /* OPEN_CURLYT  */
  YYSYMBOL_CLOSE_CURLYT = 81,              /* CLOSE_CURLYT  */
  YYSYMBOL_OPEN_SQT = 82,                  /* OPEN_SQT  */
  YYSYMBOL_CLOSE_SQT = 83,                 /* CLOSE_SQT  */
  YYSYMBOL_SEMICOLT = 84,                  /* SEMICOLT  */
  YYSYMBOL_COMMAT = 85,                    /* COMMAT  */
  YYSYMBOL_DOOT = 86,                      /* DOOT  */
  YYSYMBOL_TDOTT = 87,                     /* TDOTT  */
  YYSYMBOL_ATRT = 88,                      /* ATRT  */
  YYSYMBOL_DCOLT = 89,                     /* DCOLT  */
  YYSYMBOL_EQUALT = 90,                    /* EQUALT  */
  YYSYMBOL_LESST = 91,                     /* LESST  */
  YYSYMBOL_GREATERT = 92,                  /* GREATERT  */
  YYSYMBOL_EXCLAMATORYT = 93,              /* EXCLAMATORYT  */
  YYSYMBOL_TILDAT = 94,                    /* TILDAT  */
  YYSYMBOL_QUET = 95,                      /* QUET  */
  YYSYMBOL_COLONT = 96,                    /* COLONT  */
  YYSYMBOL_IMPLIEST = 97,                  /* IMPLIEST  */
  YYSYMBOL_DEQUALT = 98,                   /* DEQUALT  */
  YYSYMBOL_LET = 99,                       /* LET  */
  YYSYMBOL_NEQUALT = 100,                  /* NEQUALT  */
  YYSYMBOL_DANDT = 101,                    /* DANDT  */
  YYSYMBOL_DORT = 102,                     /* DORT  */
  YYSYMBOL_DPLUST = 103,                   /* DPLUST  */
  YYSYMBOL_DMINUST = 104,                  /* DMINUST  */
  YYSYMBOL_GET = 105,                      /* GET  */
  YYSYMBOL_PLUST = 106,                    /* PLUST  */
  YYSYMBOL_MINUST = 107,                   /* MINUST  */
  YYSYMBOL_MULT = 108,                     /* MULT  */
  YYSYMBOL_DIVIDET = 109,                  /* DIVIDET  */
  YYSYMBOL_ANDT = 110,                     /* ANDT  */
  YYSYMBOL_HATT = 111,                     /* HATT  */
  YYSYMBOL_MODULOT = 112,                  /* MODULOT  */
  YYSYMBOL_DLESST = 113,                   /* DLESST  */
  YYSYMBOL_DGREATERT = 114,                /* DGREATERT  */
  YYSYMBOL_TGREATERT = 115,                /* TGREATERT  */
  YYSYMBOL_PLUS_EQUALT = 116,              /* PLUS_EQUALT  */
  YYSYMBOL_MINUS_EQUALT = 117,             /* MINUS_EQUALT  */
  YYSYMBOL_MUL_EQUALT = 118,               /* MUL_EQUALT  */
  YYSYMBOL_DIVIDE_EQUALT = 119,            /* DIVIDE_EQUALT  */
  YYSYMBOL_AND_EQUALT = 120,               /* AND_EQUALT  */
  YYSYMBOL_OR_EQUALT = 121,                /* OR_EQUALT  */
  YYSYMBOL_HAT_EQUALT = 122,               /* HAT_EQUALT  */
  YYSYMBOL_MODULO_EQUALT = 123,            /* MODULO_EQUALT  */
  YYSYMBOL_DLESS_EQUALT = 124,             /* DLESS_EQUALT  */
  YYSYMBOL_DGREATER_EQUALT = 125,          /* DGREATER_EQUALT  */
  YYSYMBOL_TGREATER_EQUALT = 126,          /* TGREATER_EQUALT  */
  YYSYMBOL_ORT = 127,                      /* ORT  */
  YYSYMBOL_LGT = 128,                      /* LGT  */
  YYSYMBOL_YYACCEPT = 129,                 /* $accept  */
  YYSYMBOL_input = 130,                    /* input  */
  YYSYMBOL_Program = 131,                  /* Program  */
  YYSYMBOL_CompilationUnit = 132,          /* CompilationUnit  */
  YYSYMBOL_PackageDeclaration2 = 133,      /* PackageDeclaration2  */
  YYSYMBOL_ImportDeclarations2 = 134,      /* ImportDeclarations2  */
  YYSYMBOL_TypeDeclarations2 = 135,        /* TypeDeclarations2  */
  YYSYMBOL_ImportDeclarations = 136,       /* ImportDeclarations  */
  YYSYMBOL_TypeDeclarations = 137,         /* TypeDeclarations  */
  YYSYMBOL_PackageDeclaration = 138,       /* PackageDeclaration  */
  YYSYMBOL_ImportDeclaration = 139,        /* ImportDeclaration  */
  YYSYMBOL_SingleTypeImportDeclaration = 140, /* SingleTypeImportDeclaration  */
  YYSYMBOL_TypeImportOnDemandDeclaration = 141, /* TypeImportOnDemandDeclaration  */
  YYSYMBOL_TypeDeclaration = 142,          /* TypeDeclaration  */
  YYSYMBOL_ClassDeclaration = 143,         /* ClassDeclaration  */
  YYSYMBOL_Interfaces2 = 144,              /* Interfaces2  */
  YYSYMBOL_Interfaces = 145,               /* Interfaces  */
  YYSYMBOL_InterfaceTypeList = 146,        /* InterfaceTypeList  */
  YYSYMBOL_SuperClass = 147,               /* SuperClass  */
  YYSYMBOL_ClassType = 148,                /* ClassType  */
  YYSYMBOL_TypeName = 149,                 /* TypeName  */
  YYSYMBOL_PackageName = 150,              /* PackageName  */
  YYSYMBOL_ClassBody = 151,                /* ClassBody  */
  YYSYMBOL_ClassBodyDeclarations = 152,    /* ClassBodyDeclarations  */
  YYSYMBOL_ClassBodyDeclaration = 153,     /* ClassBodyDeclaration  */
  YYSYMBOL_ConstructorDeclaration = 154,   /* ConstructorDeclaration  */
  YYSYMBOL_ConstructorDeclarator = 155,    /* ConstructorDeclarator  */
  YYSYMBOL_ConstructorBody = 156,          /* ConstructorBody  */
  YYSYMBOL_FormalParameterList2 = 157,     /* FormalParameterList2  */
  YYSYMBOL_FormalParameterList = 158,      /* FormalParameterList  */
  YYSYMBOL_FormalParameter = 159,          /* FormalParameter  */
  YYSYMBOL_StaticInitializer = 160,        /* StaticInitializer  */
  YYSYMBOL_ClassMemberDeclaration = 161,   /* ClassMemberDeclaration  */
  YYSYMBOL_MethodDeclaration = 162,        /* MethodDeclaration  */
  YYSYMBOL_MethodHeader = 163,             /* MethodHeader  */
  YYSYMBOL_MethodDeclarator = 164,         /* MethodDeclarator  */
  YYSYMBOL_MethodBody = 165,               /* MethodBody  */
  YYSYMBOL_FieldDeclaration = 166,         /* FieldDeclaration  */
  YYSYMBOL_Modifiers1 = 167,               /* Modifiers1  */
  YYSYMBOL_Modifier = 168,                 /* Modifier  */
  YYSYMBOL_VariableDeclarators = 169,      /* VariableDeclarators  */
  YYSYMBOL_VariableDeclarator = 170,       /* VariableDeclarator  */
  YYSYMBOL_VariableDeclaratorId = 171,     /* VariableDeclaratorId  */
  YYSYMBOL_VariableInitializer = 172,      /* VariableInitializer  */
  YYSYMBOL_Type = 173,                     /* Type  */
  YYSYMBOL_Block = 174,                    /* Block  */
  YYSYMBOL_BlockStatements2 = 175,         /* BlockStatements2  */
  YYSYMBOL_BlockStatements = 176,          /* BlockStatements  */
  YYSYMBOL_BlockStatement = 177,           /* BlockStatement  */
  YYSYMBOL_LocalVariableDeclarationStatement = 178, /* LocalVariableDeclarationStatement  */
  YYSYMBOL_LocalVariableDeclaration = 179, /* LocalVariableDeclaration  */
  YYSYMBOL_Statement = 180,                /* Statement  */
  YYSYMBOL_StatementNoShortIf = 181,       /* StatementNoShortIf  */
  YYSYMBOL_StatementWithoutTrailingSubstatement = 182, /* StatementWithoutTrailingSubstatement  */
  YYSYMBOL_EmptyStatement = 183,           /* EmptyStatement  */
  YYSYMBOL_LabeledStatement = 184,         /* LabeledStatement  */
  YYSYMBOL_AssertStatement = 185,          /* AssertStatement  */
  YYSYMBOL_LabeledStatementNoShortIf = 186, /* LabeledStatementNoShortIf  */
  YYSYMBOL_IfThenStatement = 187,          /* IfThenStatement  */
  YYSYMBOL_IfThenElseStatement = 188,      /* IfThenElseStatement  */
  YYSYMBOL_IfThenElseStatementNoShortIf = 189, /* IfThenElseStatementNoShortIf  */
  YYSYMBOL_WhileStatement = 190,           /* WhileStatement  */
  YYSYMBOL_WhileStatementNoShortIf = 191,  /* WhileStatementNoShortIf  */
  YYSYMBOL_ForStatement = 192,             /* ForStatement  */
  YYSYMBOL_ForStatementNoShortIf = 193,    /* ForStatementNoShortIf  */
  YYSYMBOL_ForInit2 = 194,                 /* ForInit2  */
  YYSYMBOL_ForUpdate2 = 195,               /* ForUpdate2  */
  YYSYMBOL_Expression2 = 196,              /* Expression2  */
  YYSYMBOL_ForInit = 197,                  /* ForInit  */
  YYSYMBOL_ForUpdate = 198,                /* ForUpdate  */
  YYSYMBOL_StatementExpressionList = 199,  /* StatementExpressionList  */
  YYSYMBOL_BreakStatement = 200,           /* BreakStatement  */
  YYSYMBOL_ContinueStatement = 201,        /* ContinueStatement  */
  YYSYMBOL_ReturnStatement = 202,          /* ReturnStatement  */
  YYSYMBOL_SynchronizedStatement = 203,    /* SynchronizedStatement  */
  YYSYMBOL_ArrayInitializer = 204,         /* ArrayInitializer  */
  YYSYMBOL_VariableInitializers2 = 205,    /* VariableInitializers2  */
  YYSYMBOL_VariableInitializers = 206,     /* VariableInitializers  */
  YYSYMBOL_ExpressionStatement = 207,      /* ExpressionStatement  */
  YYSYMBOL_StatementExpression = 208,      /* StatementExpression  */
  YYSYMBOL_PreIncrementExpression = 209,   /* PreIncrementExpression  */
  YYSYMBOL_PreDecrementExpression = 210,   /* PreDecrementExpression  */
  YYSYMBOL_PostIncrementExpression = 211,  /* PostIncrementExpression  */
  YYSYMBOL_PostDecrementExpression = 212,  /* PostDecrementExpression  */
  YYSYMBOL_UnaryExpression = 213,          /* UnaryExpression  */
  YYSYMBOL_UnaryExpressionNotPlusMinus = 214, /* UnaryExpressionNotPlusMinus  */
  YYSYMBOL_CastExpression = 215,           /* CastExpression  */
  YYSYMBOL_PostfixExpression = 216,        /* PostfixExpression  */
  YYSYMBOL_Assignment = 217,               /* Assignment  */
  YYSYMBOL_AssignmentOperator = 218,       /* AssignmentOperator  */
  YYSYMBOL_LeftHandSide = 219,             /* LeftHandSide  */
  YYSYMBOL_AssignmentExpression = 220,     /* AssignmentExpression  */
  YYSYMBOL_Expression = 221,               /* Expression  */
  YYSYMBOL_ConditionalExpression = 222,    /* ConditionalExpression  */
  YYSYMBOL_ConditionalOrExpression = 223,  /* ConditionalOrExpression  */
  YYSYMBOL_ConditionalAndExpression = 224, /* ConditionalAndExpression  */
  YYSYMBOL_InclusiveOrExpression = 225,    /* InclusiveOrExpression  */
  YYSYMBOL_ExclusiveOrExpression = 226,    /* ExclusiveOrExpression  */
  YYSYMBOL_AndExpression = 227,            /* AndExpression  */
  YYSYMBOL_EqualityExpression = 228,       /* EqualityExpression  */
  YYSYMBOL_RelationalExpression = 229,     /* RelationalExpression  */
  YYSYMBOL_ShiftExpression = 230,          /* ShiftExpression  */
  YYSYMBOL_AdditiveExpression = 231,       /* AdditiveExpression  */
  YYSYMBOL_MultiplicativeExpression = 232, /* MultiplicativeExpression  */
  YYSYMBOL_PrimitiveType = 233,            /* PrimitiveType  */
  YYSYMBOL_NumericType = 234,              /* NumericType  */
  YYSYMBOL_IntegerType = 235,              /* IntegerType  */
  YYSYMBOL_FloatingPointType = 236,        /* FloatingPointType  */
  YYSYMBOL_Name = 237,                     /* Name  */
  YYSYMBOL_SimpleName = 238,               /* SimpleName  */
  YYSYMBOL_QualifiedName = 239,            /* QualifiedName  */
  YYSYMBOL_FieldAccess = 240,              /* FieldAccess  */
  YYSYMBOL_ArrayAccess = 241,              /* ArrayAccess  */
  YYSYMBOL_Primary = 242,                  /* Primary  */
  YYSYMBOL_PrimaryNoNewArray = 243,        /* PrimaryNoNewArray  */
  YYSYMBOL_Literal = 244,                  /* Literal  */
  YYSYMBOL_ClassInstanceCreationExpression = 245, /* ClassInstanceCreationExpression  */
  YYSYMBOL_MethodInvocation = 246,         /* MethodInvocation  */
  YYSYMBOL_ArgumentList2 = 247,            /* ArgumentList2  */
  YYSYMBOL_ArgumentList = 248,             /* ArgumentList  */
  YYSYMBOL_ReferenceType = 249,            /* ReferenceType  */
  YYSYMBOL_ArrayType = 250,                /* ArrayType  */
  YYSYMBOL_ArrayCreationExpression = 251,  /* ArrayCreationExpression  */
  YYSYMBOL_Dims2 = 252,                    /* Dims2  */
  YYSYMBOL_Dims = 253,                     /* Dims  */
  YYSYMBOL_DimExprs = 254,                 /* DimExprs  */
  YYSYMBOL_DimExpr = 255,                  /* DimExpr  */
  YYSYMBOL_InterfaceDeclaration = 256,     /* InterfaceDeclaration  */
  YYSYMBOL_ExtendsInterfaces2 = 257,       /* ExtendsInterfaces2  */
  YYSYMBOL_ExtendsInterfaces = 258,        /* ExtendsInterfaces  */
  YYSYMBOL_InterfaceBody = 259,            /* InterfaceBody  */
  YYSYMBOL_InterfaceMemberDeclarations2 = 260, /* InterfaceMemberDeclarations2  */
  YYSYMBOL_InterfaceMemberDeclarations = 261, /* InterfaceMemberDeclarations  */
  YYSYMBOL_InterfaceMemberDeclaration = 262, /* InterfaceMemberDeclaration  */
  YYSYMBOL_ConstantDeclaration = 263,      /* ConstantDeclaration  */
  YYSYMBOL_AbstractMethodDeclaration = 264, /* AbstractMethodDeclaration  */
  YYSYMBOL_InterfaceType = 265,            /* InterfaceType  */
  YYSYMBOL_identifier = 266,               /* identifier  */
  YYSYMBOL_IntegerLiteral = 267,           /* IntegerLiteral  */
  YYSYMBOL_FloatingPointLiteral = 268,     /* FloatingPointLiteral  */
  YYSYMBOL_BooleanLiteral = 269,           /* BooleanLiteral  */
  YYSYMBOL_CharacterLiteral = 270,         /* CharacterLiteral  */
  YYSYMBOL_StringLiteral = 271,            /* StringLiteral  */
  YYSYMBOL_NullLiteral = 272,              /* NullLiteral  */
  YYSYMBOL_TextBlock = 273,                /* TextBlock  */
  YYSYMBOL_NEW = 274,                      /* NEW  */
  YYSYMBOL_SYNCHRONIZED = 275,             /* SYNCHRONIZED  */
  YYSYMBOL_RETURN = 276,                   /* RETURN  */
  YYSYMBOL_BREAK = 277,                    /* BREAK  */
  YYSYMBOL_CONTINUE = 278,                 /* CONTINUE  */
  YYSYMBOL_IF = 279,                       /* IF  */
  YYSYMBOL_ELSE = 280,                     /* ELSE  */
  YYSYMBOL_FOR = 281,                      /* FOR  */
  YYSYMBOL_WHILE = 282,                    /* WHILE  */
  YYSYMBOL_CLASS = 283,                    /* CLASS  */
  YYSYMBOL_INSTANCEOF = 284,               /* INSTANCEOF  */
  YYSYMBOL_THIS = 285,                     /* THIS  */
  YYSYMBOL_SUPER = 286,                    /* SUPER  */
  YYSYMBOL_ABSTRACT = 287,                 /* ABSTRACT  */
  YYSYMBOL_ASSERT = 288,                   /* ASSERT  */
  YYSYMBOL_BOOLEAN = 289,                  /* BOOLEAN  */
  YYSYMBOL_BYTE = 290,                     /* BYTE  */
  YYSYMBOL_SHORT = 291,                    /* SHORT  */
  YYSYMBOL_INT = 292,                      /* INT  */
  YYSYMBOL_LONG = 293,                     /* LONG  */
  YYSYMBOL_CHAR = 294,                     /* CHAR  */
  YYSYMBOL_STRING = 295,                   /* STRING  */
  YYSYMBOL_FLOAT = 296,                    /* FLOAT  */
  YYSYMBOL_DOUBLE = 297,                   /* DOUBLE  */
  YYSYMBOL_EXTENDS = 298,                  /* EXTENDS  */
  YYSYMBOL_PACKAGE = 299,                  /* PACKAGE  */
  YYSYMBOL_IMPORT = 300,                   /* IMPORT  */
  YYSYMBOL_STATIC = 301,                   /* STATIC  */
  YYSYMBOL_PROTECTED = 302,                /* PROTECTED  */
  YYSYMBOL_PRIVATE = 303,                  /* PRIVATE  */
  YYSYMBOL_PUBLIC = 304,                   /* PUBLIC  */
  YYSYMBOL_FINAL = 305,                    /* FINAL  */
  YYSYMBOL_TRANSIENT = 306,                /* TRANSIENT  */
  YYSYMBOL_VOLATILE = 307,                 /* VOLATILE  */
  YYSYMBOL_IMPLEMENTS = 308,               /* IMPLEMENTS  */
  YYSYMBOL_VOID = 309,                     /* VOID  */
  YYSYMBOL_INTERFACE = 310,                /* INTERFACE  */
  YYSYMBOL_NATIVE = 311,                   /* NATIVE  */
  YYSYMBOL_OPEN_BRACKETS = 312,            /* OPEN_BRACKETS  */
  YYSYMBOL_CLOSE_BRACKETS = 313,           /* CLOSE_BRACKETS  */
  YYSYMBOL_OPEN_CURLY = 314,               /* OPEN_CURLY  */
  YYSYMBOL_CLOSE_CURLY = 315,              /* CLOSE_CURLY  */
  YYSYMBOL_OPEN_SQ = 316,                  /* OPEN_SQ  */
  YYSYMBOL_CLOSE_SQ = 317,                 /* CLOSE_SQ  */
  YYSYMBOL_SEMICOL = 318,                  /* SEMICOL  */
  YYSYMBOL_COMMA = 319,                    /* COMMA  */
  YYSYMBOL_DOT = 320,                      /* DOT  */
  YYSYMBOL_EQUAL = 321,                    /* EQUAL  */
  YYSYMBOL_LESS = 322,                     /* LESS  */
  YYSYMBOL_GREATER = 323,                  /* GREATER  */
  YYSYMBOL_EXCLAMATORY = 324,              /* EXCLAMATORY  */
  YYSYMBOL_TILDA = 325,                    /* TILDA  */
  YYSYMBOL_QUE = 326,                      /* QUE  */
  YYSYMBOL_COLON = 327,                    /* COLON  */
  YYSYMBOL_DEQUAL = 328,                   /* DEQUAL  */
  YYSYMBOL_LE = 329,                       /* LE  */
  YYSYMBOL_GE = 330,                       /* GE  */
  YYSYMBOL_NEQUAL = 331,                   /* NEQUAL  */
  YYSYMBOL_DAND = 332,                     /* DAND  */
  YYSYMBOL_DOR = 333,                      /* DOR  */
  YYSYMBOL_DPLUS = 334,                    /* DPLUS  */
  YYSYMBOL_DMINUS = 335,                   /* DMINUS  */
  YYSYMBOL_PLUS = 336,                     /* PLUS  */
  YYSYMBOL_MINUS = 337,                    /* MINUS  */
  YYSYMBOL_MUL = 338,                      /* MUL  */
  YYSYMBOL_DIVIDE = 339,                   /* DIVIDE  */
  YYSYMBOL_AND = 340,                      /* AND  */
  YYSYMBOL_HAT = 341,                      /* HAT  */
  YYSYMBOL_MODULO = 342,                   /* MODULO  */
  YYSYMBOL_DLESS = 343,                    /* DLESS  */
  YYSYMBOL_DGREATER = 344,                 /* DGREATER  */
  YYSYMBOL_TGREATER = 345,                 /* TGREATER  */
  YYSYMBOL_PLUS_EQUAL = 346,               /* PLUS_EQUAL  */
  YYSYMBOL_MINUS_EQUAL = 347,              /* MINUS_EQUAL  */
  YYSYMBOL_MUL_EQUAL = 348,                /* MUL_EQUAL  */
  YYSYMBOL_DIVIDE_EQUAL = 349,             /* DIVIDE_EQUAL  */
  YYSYMBOL_AND_EQUAL = 350,                /* AND_EQUAL  */
  YYSYMBOL_OR_EQUAL = 351,                 /* OR_EQUAL  */
  YYSYMBOL_HAT_EQUAL = 352,                /* HAT_EQUAL  */
  YYSYMBOL_MODULO_EQUAL = 353,             /* MODULO_EQUAL  */
  YYSYMBOL_DLESS_EQUAL = 354,              /* DLESS_EQUAL  */
  YYSYMBOL_DGREATER_EQUAL = 355,           /* DGREATER_EQUAL  */
  YYSYMBOL_TGREATER_EQUAL = 356,           /* TGREATER_EQUAL  */
  YYSYMBOL_OR = 357,                       /* OR  */
  YYSYMBOL_STRICTFP = 358                  /* STRICTFP  */
};
typedef enum yysymbol_kind_t yysymbol_kind_t;




#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

/* Work around bug in HP-UX 11.23, which defines these macros
   incorrectly for preprocessor constants.  This workaround can likely
   be removed in 2023, as HPE has promised support for HP-UX 11.23
   (aka HP-UX 11i v2) only through the end of 2022; see Table 2 of
   <https://h20195.www2.hpe.com/V2/getpdf.aspx/4AA4-7673ENW.pdf>.  */
#ifdef __hpux
# undef UINT_LEAST8_MAX
# undef UINT_LEAST16_MAX
# define UINT_LEAST8_MAX 255
# define UINT_LEAST16_MAX 65535
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))


/* Stored state numbers (used for stacks). */
typedef yytype_int16 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif


#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YY_USE(E) ((void) (E))
#else
# define YY_USE(E) /* empty */
#endif

/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
#if defined __GNUC__ && ! defined __ICC && 406 <= __GNUC__ * 100 + __GNUC_MINOR__
# if __GNUC__ * 100 + __GNUC_MINOR__ < 407
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")
# else
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# endif
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if !defined yyoverflow

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* !defined yyoverflow */

#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  8
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   1630

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  129
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  230
/* YYNRULES -- Number of rules.  */
#define YYNRULES  392
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  566

/* YYMAXUTOK -- Last valid token kind.  */
#define YYMAXUTOK   383


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK                     \
   ? YY_CAST (yysymbol_kind_t, yytranslate[YYX])        \
   : YYSYMBOL_YYUNDEF)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,    83,    84,
      85,    86,    87,    88,    89,    90,    91,    92,    93,    94,
      95,    96,    97,    98,    99,   100,   101,   102,   103,   104,
     105,   106,   107,   108,   109,   110,   111,   112,   113,   114,
     115,   116,   117,   118,   119,   120,   121,   122,   123,   124,
     125,   126,   127,   128
};

#if YYDEBUG
/* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,   588,   588,   590,   592,   600,   601,   603,   604,   606,
     607,   609,   610,   612,   613,   615,   623,   624,   626,   634,
     644,   645,   646,   649,   660,   661,   663,   670,   671,   679,
     680,   687,   689,   690,   698,   699,   708,   716,   717,   719,
     720,   721,   722,   724,   726,   728,   731,   732,   734,   735,
     737,   739,   741,   742,   743,   747,   749,   750,   752,   753,
     755,   756,   759,   761,   762,   769,   770,   771,   772,   773,
     774,   775,   776,   777,   778,   779,   781,   782,   784,   785,
     787,   788,   790,   791,   793,   794,   798,   806,   807,   809,
     810,   812,   813,   815,   817,   820,   821,   822,   823,   824,
     825,   827,   828,   829,   830,   831,   833,   834,   835,   836,
     837,   838,   839,   840,   842,   844,   846,   848,   850,   860,
     872,   884,   894,   904,   919,   933,   934,   937,   938,   940,
     941,   943,   944,   946,   948,   949,   951,   952,   955,   956,
     958,   960,   971,   973,   974,   976,   977,   980,   982,   983,
     984,   985,   986,   987,   988,   990,   992,   994,   996,   998,
     999,  1000,  1001,  1002,  1004,  1005,  1006,  1007,  1009,  1018,
    1027,  1037,  1038,  1039,  1040,  1042,  1050,  1051,  1052,  1053,
    1054,  1055,  1056,  1057,  1058,  1059,  1060,  1061,  1063,  1064,
    1065,  1067,  1068,  1070,  1072,  1073,  1083,  1084,  1092,  1093,
    1101,  1102,  1110,  1111,  1119,  1120,  1128,  1129,  1136,  1144,
    1145,  1152,  1159,  1166,  1173,  1181,  1182,  1189,  1196,  1204,
    1205,  1212,  1220,  1221,  1228,  1235,  1244,  1245,  1247,  1248,
    1250,  1251,  1252,  1253,  1254,  1255,  1257,  1258,  1260,  1261,
    1263,  1265,  1273,  1280,  1289,  1297,  1306,  1307,  1309,  1310,
    1311,  1318,  1319,  1320,  1321,  1323,  1324,  1325,  1326,  1327,
    1328,  1329,  1331,  1341,  1349,  1359,  1370,  1371,  1373,  1374,
    1382,  1383,  1385,  1392,  1399,  1407,  1415,  1424,  1425,  1427,
    1428,  1435,  1436,  1438,  1446,  1456,  1457,  1459,  1460,  1467,
    1475,  1476,  1478,  1479,  1486,  1487,  1489,  1491,  1492,  1494,
    1496,  1497,  1498,  1499,  1500,  1501,  1502,  1503,  1504,  1505,
    1506,  1507,  1508,  1509,  1510,  1511,  1512,  1513,  1514,  1515,
    1516,  1517,  1518,  1519,  1520,  1521,  1522,  1523,  1524,  1525,
    1526,  1527,  1528,  1529,  1530,  1531,  1532,  1533,  1534,  1535,
    1536,  1537,  1538,  1539,  1540,  1541,  1542,  1543,  1544,  1545,
    1546,  1547,  1548,  1549,  1550,  1551,  1552,  1553,  1554,  1555,
    1556,  1557,  1558,  1559,  1560,  1561,  1562,  1563,  1564,  1565,
    1566,  1567,  1568,  1569,  1570,  1571,  1572,  1573,  1574,  1575,
    1576,  1577,  1578,  1579,  1580,  1581,  1582,  1583,  1584,  1585,
    1586,  1587,  1588
};
#endif

/** Accessing symbol of state STATE.  */
#define YY_ACCESSING_SYMBOL(State) YY_CAST (yysymbol_kind_t, yystos[State])

#if YYDEBUG || 0
/* The user-facing name of the symbol whose (internal) number is
   YYSYMBOL.  No bounds checking.  */
static const char *yysymbol_name (yysymbol_kind_t yysymbol) YY_ATTRIBUTE_UNUSED;

/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "\"end of file\"", "error", "\"invalid token\"", "keywordT", "newlineT",
  "identifierT", "IntegerLiteralT", "FloatingPointLiteralT",
  "BooleanLiteralT", "CharacterLiteralT", "StringLiteralT", "NullLiteralT",
  "TextBlockT", "NEWT", "TRYT", "CATCHT", "SYNCHRONIZEDT", "FINALLYT",
  "THROWT", "THROWST", "RETURNT", "BREAKT", "CONTINUET", "IFT", "ELSET",
  "SWITCHT", "CASET", "FORT", "WHILET", "DOTT", "CLASST", "INSTANCEOFT",
  "THIST", "SUPERT", "ABSTRACTT", "ASSERTT", "BOOLEANT", "BYTET", "SHORTT",
  "INTT", "LONGT", "CHART", "STRINGT", "FLOATT", "DOUBLET", "EXTENDST",
  "PACKAGET", "IMPORTT", "STATICT", "MODULET", "REQUIREST", "EXPORTST",
  "OPENST", "OPENT", "USEST", "PROVIDEST", "WITHT", "TRANSITIVET",
  "PROTECTEDT", "PRIVATET", "PUBLICT", "FINALT", "SEALEDT", "NONSEALEDT",
  "TRANSIENTT", "VOLATILET", "STRICTFPT", "IMPLEMENTST", "PERMITST",
  "VOIDT", "ENUMT", "DEFAULTT", "VART", "TOT", "YIELDT", "INTERFACET",
  "RECORDT", "NATIVET", "OPEN_BRACKETST", "CLOSE_BRACKETST", "OPEN_CURLYT",
  "CLOSE_CURLYT", "OPEN_SQT", "CLOSE_SQT", "SEMICOLT", "COMMAT", "DOOT",
  "TDOTT", "ATRT", "DCOLT", "EQUALT", "LESST", "GREATERT", "EXCLAMATORYT",
  "TILDAT", "QUET", "COLONT", "IMPLIEST", "DEQUALT", "LET", "NEQUALT",
  "DANDT", "DORT", "DPLUST", "DMINUST", "GET", "PLUST", "MINUST", "MULT",
  "DIVIDET", "ANDT", "HATT", "MODULOT", "DLESST", "DGREATERT", "TGREATERT",
  "PLUS_EQUALT", "MINUS_EQUALT", "MUL_EQUALT", "DIVIDE_EQUALT",
  "AND_EQUALT", "OR_EQUALT", "HAT_EQUALT", "MODULO_EQUALT", "DLESS_EQUALT",
  "DGREATER_EQUALT", "TGREATER_EQUALT", "ORT", "LGT", "$accept", "input",
  "Program", "CompilationUnit", "PackageDeclaration2",
  "ImportDeclarations2", "TypeDeclarations2", "ImportDeclarations",
  "TypeDeclarations", "PackageDeclaration", "ImportDeclaration",
  "SingleTypeImportDeclaration", "TypeImportOnDemandDeclaration",
  "TypeDeclaration", "ClassDeclaration", "Interfaces2", "Interfaces",
  "InterfaceTypeList", "SuperClass", "ClassType", "TypeName",
  "PackageName", "ClassBody", "ClassBodyDeclarations",
  "ClassBodyDeclaration", "ConstructorDeclaration",
  "ConstructorDeclarator", "ConstructorBody", "FormalParameterList2",
  "FormalParameterList", "FormalParameter", "StaticInitializer",
  "ClassMemberDeclaration", "MethodDeclaration", "MethodHeader",
  "MethodDeclarator", "MethodBody", "FieldDeclaration", "Modifiers1",
  "Modifier", "VariableDeclarators", "VariableDeclarator",
  "VariableDeclaratorId", "VariableInitializer", "Type", "Block",
  "BlockStatements2", "BlockStatements", "BlockStatement",
  "LocalVariableDeclarationStatement", "LocalVariableDeclaration",
  "Statement", "StatementNoShortIf",
  "StatementWithoutTrailingSubstatement", "EmptyStatement",
  "LabeledStatement", "AssertStatement", "LabeledStatementNoShortIf",
  "IfThenStatement", "IfThenElseStatement", "IfThenElseStatementNoShortIf",
  "WhileStatement", "WhileStatementNoShortIf", "ForStatement",
  "ForStatementNoShortIf", "ForInit2", "ForUpdate2", "Expression2",
  "ForInit", "ForUpdate", "StatementExpressionList", "BreakStatement",
  "ContinueStatement", "ReturnStatement", "SynchronizedStatement",
  "ArrayInitializer", "VariableInitializers2", "VariableInitializers",
  "ExpressionStatement", "StatementExpression", "PreIncrementExpression",
  "PreDecrementExpression", "PostIncrementExpression",
  "PostDecrementExpression", "UnaryExpression",
  "UnaryExpressionNotPlusMinus", "CastExpression", "PostfixExpression",
  "Assignment", "AssignmentOperator", "LeftHandSide",
  "AssignmentExpression", "Expression", "ConditionalExpression",
  "ConditionalOrExpression", "ConditionalAndExpression",
  "InclusiveOrExpression", "ExclusiveOrExpression", "AndExpression",
  "EqualityExpression", "RelationalExpression", "ShiftExpression",
  "AdditiveExpression", "MultiplicativeExpression", "PrimitiveType",
  "NumericType", "IntegerType", "FloatingPointType", "Name", "SimpleName",
  "QualifiedName", "FieldAccess", "ArrayAccess", "Primary",
  "PrimaryNoNewArray", "Literal", "ClassInstanceCreationExpression",
  "MethodInvocation", "ArgumentList2", "ArgumentList", "ReferenceType",
  "ArrayType", "ArrayCreationExpression", "Dims2", "Dims", "DimExprs",
  "DimExpr", "InterfaceDeclaration", "ExtendsInterfaces2",
  "ExtendsInterfaces", "InterfaceBody", "InterfaceMemberDeclarations2",
  "InterfaceMemberDeclarations", "InterfaceMemberDeclaration",
  "ConstantDeclaration", "AbstractMethodDeclaration", "InterfaceType",
  "identifier", "IntegerLiteral", "FloatingPointLiteral", "BooleanLiteral",
  "CharacterLiteral", "StringLiteral", "NullLiteral", "TextBlock", "NEW",
  "SYNCHRONIZED", "RETURN", "BREAK", "CONTINUE", "IF", "ELSE", "FOR",
  "WHILE", "CLASS", "INSTANCEOF", "THIS", "SUPER", "ABSTRACT", "ASSERT",
  "BOOLEAN", "BYTE", "SHORT", "INT", "LONG", "CHAR", "STRING", "FLOAT",
  "DOUBLE", "EXTENDS", "PACKAGE", "IMPORT", "STATIC", "PROTECTED",
  "PRIVATE", "PUBLIC", "FINAL", "TRANSIENT", "VOLATILE", "IMPLEMENTS",
  "VOID", "INTERFACE", "NATIVE", "OPEN_BRACKETS", "CLOSE_BRACKETS",
  "OPEN_CURLY", "CLOSE_CURLY", "OPEN_SQ", "CLOSE_SQ", "SEMICOL", "COMMA",
  "DOT", "EQUAL", "LESS", "GREATER", "EXCLAMATORY", "TILDA", "QUE",
  "COLON", "DEQUAL", "LE", "GE", "NEQUAL", "DAND", "DOR", "DPLUS",
  "DMINUS", "PLUS", "MINUS", "MUL", "DIVIDE", "AND", "HAT", "MODULO",
  "DLESS", "DGREATER", "TGREATER", "PLUS_EQUAL", "MINUS_EQUAL",
  "MUL_EQUAL", "DIVIDE_EQUAL", "AND_EQUAL", "OR_EQUAL", "HAT_EQUAL",
  "MODULO_EQUAL", "DLESS_EQUAL", "DGREATER_EQUAL", "TGREATER_EQUAL", "OR",
  "STRICTFP", YY_NULLPTR
};

static const char *
yysymbol_name (yysymbol_kind_t yysymbol)
{
  return yytname[yysymbol];
}
#endif

#define YYPACT_NINF (-478)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-292)

#define yytable_value_is_error(Yyn) \
  0

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
static const yytype_int16 yypact[] =
{
      25,  -478,    76,  -478,  -478,    73,  -478,    94,  -478,  -478,
    1420,    73,  -478,  -478,  -478,    94,  -478,    20,  -478,  -478,
    -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,
    -478,  -478,  -478,  -478,  1453,  -478,  -478,    12,   795,  -478,
    -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,
    -478,  -478,  -478,    20,  -478,  -478,    94,  -478,  -478,  -478,
      94,    94,  -478,  -478,    27,  -478,   122,   122,  -478,    47,
    -478,    79,    94,    69,    87,    94,  -478,  -478,    69,  -478,
      94,  -478,  -478,   125,   160,  -478,  -478,  1475,  -478,    94,
    -478,  -478,  -478,  1036,    87,  -478,    94,  -478,  -478,   273,
     124,  1509,  -478,  -478,  -478,  -478,  -478,   124,  1036,  -478,
    -478,  -478,  -478,     8,  -478,   273,  -478,    69,  1297,  -478,
      94,   180,  -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,
    -478,  -478,    94,   131,  -478,  -478,  -478,    26,  -478,   131,
    -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,    94,
    -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,    69,   137,
    -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,
    -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,
    -478,    94,  -478,   124,  1297,  -478,  -478,    47,  -478,  -478,
    -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,
    -478,  -478,    47,  -478,  -478,   -41,    39,   104,  -478,  1481,
      41,  1492,  1504,   125,   131,  -478,   101,   109,  -478,   123,
    -478,  -478,  -478,  -478,  -478,  -478,  -478,   663,   137,  1194,
      34,    34,   137,   137,   137,  -478,   125,  1194,  1194,  -478,
    1194,  1194,  -478,   131,   141,  -478,   -21,   137,  -478,   148,
     148,   148,   131,   137,  -478,  1297,   554,    87,  -478,  -478,
    -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,
    -478,  -478,  -478,  -478,  -478,  -478,  -478,  1194,  -478,  -478,
    -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,
    1194,   943,    94,  1194,  -478,  1337,   131,    52,  1194,  -478,
    -478,  -478,  -478,    47,  -478,  -478,  -478,  -478,  -478,  -478,
    -478,   104,  -478,  -478,  -478,  -478,    -6,   138,   111,   130,
     134,    60,    10,    61,   121,    53,  1326,  -478,  -478,   654,
    1194,  1194,  1194,  1194,    47,  -478,    47,  -478,  1194,  1386,
    1194,    94,    47,   166,  -478,    52,  -478,  -478,  -478,   148,
    -478,    94,   148,  1177,   554,  -478,  -478,  -478,  -478,   124,
     166,    87,  -478,   663,  -478,  -478,   166,    87,   148,   137,
     148,  -478,   131,  -478,  1194,   131,  1194,   166,  -478,  -478,
    -478,  1194,  1194,  -478,  1194,  -478,  1194,  -478,  1194,  -478,
    1194,  -478,  -478,  1194,  1194,  -478,  -478,  -478,  -478,  -478,
     663,  1194,  1194,  1194,  1194,  -478,  -478,  -478,  1194,  1194,
    1194,  1194,  1194,  -478,  -478,  1194,  1194,  1194,  1194,   166,
     131,  1326,  -478,  -478,  -478,  -478,  -478,  -478,   166,  -478,
      47,  -478,    87,  -478,   166,   137,  -478,  -478,  -478,  -478,
    -478,  -478,  -478,  -478,  -478,  1177,   166,  -478,  -478,   795,
      94,  -478,  1194,  -478,  1194,  -478,  -478,   131,  -478,   943,
     148,  -478,   166,    69,   123,   138,   111,   130,   134,    60,
      10,    10,   131,  -478,    61,    61,    61,    61,   121,   121,
     121,    53,    53,  -478,  -478,  -478,  1377,   166,   148,    46,
     943,  1337,  1194,   902,  1337,  1194,  -478,   124,    87,  -478,
    -478,   131,  -478,   166,   148,  -478,  -478,  -478,  -478,  1194,
    -478,  1194,  1377,  -478,   225,   227,  -478,  -478,  -478,  -478,
     123,   137,   137,   137,    47,  -478,  -478,   166,  -478,  1177,
    -478,  -478,  -478,  -478,  -478,  -478,  1337,  1337,  1194,  1386,
    1194,   902,  -478,  -478,  -478,  -478,   166,    47,   166,   166,
    -478,    87,  1337,  1194,  1337,  1337,   225,    47,  -478,  -478,
    1337,   902,  -478,   166,  1337,  -478
};

/* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE does not specify something else to do.  Zero
   means the default is an error.  */
static const yytype_int16 yydefact[] =
{
       5,   333,     0,     2,     3,     7,     6,     0,     1,   334,
      63,     8,    11,    16,    17,     0,   300,     0,   238,   239,
     240,   309,   321,   335,   336,   337,   338,   339,   340,   341,
     392,   345,   352,     4,    63,    13,    20,     0,    63,    21,
      72,    69,    68,    66,    67,    65,    70,    73,    74,    71,
      22,    75,    12,     0,   354,    15,     0,    14,   317,   344,
       0,     0,    64,    18,     0,   241,    29,   285,   372,     0,
     332,    24,     0,     0,   286,     0,    19,   342,     0,    25,
       0,    30,    31,     0,    32,   348,   284,    63,   353,     0,
     299,   287,    23,    63,    26,    27,     0,   297,   296,     0,
       0,    63,   292,   294,   295,   298,   288,     0,    63,    41,
      40,    39,    53,     0,    52,     0,    42,    68,    87,    54,
       0,    33,   323,   324,   325,   326,   327,   328,   329,   330,
     331,   343,     0,    84,   226,   228,   229,   270,    85,   271,
     227,   230,   231,   232,   233,   234,   235,   236,   237,     0,
     349,   289,   293,    36,    38,    55,    60,    61,     0,   238,
      51,   301,   302,   303,   304,   305,   306,   307,   308,   310,
     311,   312,   313,   315,   316,   319,   320,   322,   346,   368,
     369,     0,   106,     0,    88,    89,    91,     0,    92,    95,
     107,    96,   113,    97,    98,    99,   100,   109,   110,   111,
     112,   108,     0,   149,   150,   151,   152,     0,   148,     0,
     188,   252,   254,   172,   246,   248,   251,   253,   247,   240,
     255,   256,   257,   258,   259,   261,   260,     0,     0,   129,
       0,     0,     0,     0,     0,   249,     0,     0,     0,   114,
       0,     0,    28,    56,     0,    76,    78,    80,   350,     0,
       0,     0,    57,     0,    43,    87,    63,    94,    80,    86,
      90,    93,   147,   157,   158,   355,   380,   381,   382,   383,
     384,   385,   386,   387,   388,   389,   390,     0,   176,   180,
     181,   177,   178,   185,   187,   186,   179,   182,   183,   184,
     266,     0,     0,     0,   361,     0,     0,     0,     0,   358,
     359,   370,   371,     0,   161,   162,   173,   174,   222,   163,
     167,   164,   192,   193,   130,   191,   194,   196,   198,   200,
     202,   204,   206,   209,   215,   219,   171,   251,   253,     0,
       0,     0,     0,     0,     0,   137,     0,   138,     0,   125,
       0,     0,     0,     0,   155,   171,   252,   254,   156,     0,
      62,     0,     0,     0,    63,   351,   272,   273,   274,     0,
       0,    47,    48,     0,   175,   268,     0,   267,     0,   243,
       0,   115,   277,   281,     0,   277,   266,     0,   140,   360,
     367,     0,     0,   366,     0,   391,     0,   375,     0,   374,
       0,   362,   365,     0,     0,   318,   356,   357,   363,   364,
       0,     0,     0,     0,     0,   377,   378,   379,     0,     0,
       0,     0,     0,   373,   376,     0,     0,     0,     0,     0,
     277,   171,   166,   165,   159,   160,   136,   139,     0,   132,
       0,   126,   131,   134,     0,   242,   116,   347,   250,    59,
      77,    81,    79,    83,    82,   143,     0,    45,    44,    63,
       0,   263,     0,   244,   266,   245,   275,   278,   282,     0,
       0,   276,     0,     0,     0,   197,   199,   201,   203,   205,
     207,   208,     0,   214,   210,   211,   212,   213,   216,   217,
     218,   220,   221,   223,   224,   225,   250,     0,     0,     0,
       0,     0,   129,     0,     0,   266,   145,     0,   144,    58,
      49,    50,   269,     0,     0,   279,   283,   262,   141,     0,
     169,     0,     0,   118,     0,    95,   102,   103,   104,   105,
     240,     0,     0,     0,     0,   135,   121,     0,   142,     0,
     264,   280,   195,   168,   170,   314,     0,     0,     0,   125,
       0,   127,   265,   146,   119,   117,     0,     0,     0,     0,
     128,   133,     0,   129,     0,     0,     0,     0,   122,   123,
       0,   127,   120,     0,     0,   124
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,
     241,  -478,  -478,   219,  -478,  -478,  -478,  -478,  -478,  -478,
     183,  -478,  -478,   146,  -478,  -478,  -478,  -478,   -95,  -478,
    -191,  -478,  -478,  -478,   -36,   113,  -478,   -35,    40,  -478,
      88,   -83,  -179,  -412,   -96,   -77,    18,  -478,    92,  -478,
    -322,  -280,  -204,  -401,  -478,  -478,  -478,  -478,  -478,  -478,
    -478,  -478,  -478,  -478,  -478,  -262,  -279,  -447,  -478,  -478,
    -477,  -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,  -329,
     -89,    86,   117,   182,  -193,  -430,  -478,   235,   261,  -478,
    -478,    13,   589,  -226,  -478,   -91,   -90,   -84,   -93,   -94,
    -164,  -205,  -208,  -175,  -216,  -478,  -478,  -478,     6,   188,
    -478,   600,   757,  -478,  -478,  -478,   310,   340,  -338,  -478,
    -103,  -478,  -478,  -308,  -117,     9,  -261,  -478,  -478,  -478,
    -478,  -478,  -478,   204,  -478,  -478,    67,   -52,  -478,  -478,
    -478,  -478,  -478,  -478,  -478,  -478,    -8,  -478,  -478,  -478,
    -203,  -248,  -169,   -59,  -478,  -478,  -478,  -478,  -478,  -478,
    -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,   252,
    -478,  -478,   -33,  -478,  -478,  -478,  -478,  -478,  -478,  -478,
    -478,  -478,  -478,    32,   691,   -72,   -73,   571,  -197,   -10,
     -69,   -18,    74,  -478,  -478,  -478,  -478,  -478,  -413,  -478,
    -478,  -478,  -478,  -478,  -478,  -189,  -185,  -310,  -297,   257,
    -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,
    -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478,  -478
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
       0,     2,     3,     4,     5,    10,    33,    11,    34,     6,
      12,    13,    14,    35,    36,    78,    79,    94,    71,    81,
      90,    83,    92,   107,   108,   109,   158,   254,   360,   361,
     362,   110,   111,   112,    97,   243,   155,    98,   363,    38,
     244,   245,   246,   442,   181,   182,   183,   184,   185,   186,
     187,   188,   514,   189,   190,   191,   192,   516,   193,   194,
     517,   195,   518,   196,   519,   430,   549,   303,   431,   550,
     432,   197,   198,   199,   200,   443,   497,   498,   201,   202,
     304,   305,   306,   307,   308,   309,   310,   311,   312,   277,
     209,   313,   365,   315,   316,   317,   318,   319,   320,   321,
     322,   323,   324,   325,   133,   134,   135,   136,   326,    18,
      19,   211,   212,   213,   214,   215,   327,   328,   366,   367,
     138,   139,   218,   456,   457,   372,   373,    39,    73,    74,
      86,   100,   101,   102,   103,   104,    91,    20,   220,   221,
     222,   223,   224,   225,   226,   227,   228,   229,   230,   231,
     232,   536,   233,   234,    60,   400,   235,   236,    41,   237,
     140,   141,   142,   143,   144,   145,   146,   147,   148,    72,
       7,    15,    42,    43,    44,    45,    46,    47,    48,    80,
     149,    61,    49,   329,   438,   118,   151,   249,   505,   239,
     351,    56,   278,   401,   402,   330,   331,   381,   295,   393,
     403,   404,   394,   384,   382,   240,   241,   332,   333,   415,
     416,   390,   388,   417,   408,   409,   410,   279,   280,   281,
     282,   283,   284,   285,   286,   287,   288,   289,   386,    51
};

/* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule whose
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      50,    87,    40,   132,    65,    89,    93,    55,    66,    67,
     433,   296,    65,    17,   411,   371,   116,   429,   263,   132,
      84,    53,   264,    84,    50,   120,    40,   412,    84,   203,
      40,   116,    16,   496,   153,    64,   156,    84,   462,    16,
     160,   395,    58,    63,   121,   524,  -270,   344,   348,    54,
      37,   509,   356,   357,   358,    54,   510,   113,   114,    76,
     117,   248,  -173,  -173,   551,    96,   219,   461,    84,   265,
      54,     1,   113,   114,    37,   117,     8,   105,    62,    40,
     247,    54,   534,   119,   551,    40,   255,    59,    85,   379,
     515,   105,    32,    40,   357,   203,   380,   253,   119,    16,
      40,   396,   397,   157,    32,   137,   557,   537,   248,   398,
     259,   458,   487,   420,   458,   399,   503,   543,    32,   178,
       9,   137,   263,   248,   210,   437,   264,    99,   248,   258,
     178,    32,   219,   115,   248,    68,   515,   422,   423,   424,
     425,    99,  -174,  -174,  -171,  -171,    77,    95,   115,    85,
     238,   515,   439,   515,    54,   441,   106,   527,   391,   515,
     392,    68,   413,   515,   525,   414,   203,    70,   411,   411,
     411,   453,    88,   455,   405,   406,   407,   261,   334,   336,
    -154,   412,   412,   412,   472,  -154,  -154,   242,  -153,   -34,
     210,   256,   262,  -153,  -153,   292,   474,   475,   476,   477,
     478,   479,   480,   219,   204,   150,   203,   179,   180,   -35,
     433,   513,   433,   248,   526,   178,   238,   429,   341,   294,
     335,   337,   483,   484,   485,    32,    88,   301,   302,   470,
     471,   355,   433,   297,   350,   205,   481,   482,   385,   383,
     369,   387,   290,   219,   389,   437,   345,   345,    40,   535,
     203,  -101,    52,    57,   154,    82,   544,   371,   500,   446,
     298,   210,   252,   506,   338,   339,   340,   450,   440,   257,
     204,   501,   513,   359,   526,   559,   260,   547,    16,   354,
     544,   445,   563,   532,   559,   354,   447,   238,   521,   435,
     364,   465,   449,   378,   466,   468,   469,   473,   452,   258,
     206,   205,   467,   159,   489,   152,   375,   531,   560,   122,
     123,   124,   125,   126,   127,   128,   129,   130,   533,    75,
     353,    69,   522,     0,   426,     0,   427,   238,     0,   376,
       0,     0,   436,   545,   521,   421,   345,   345,   345,   345,
       0,   204,   131,     0,     0,   210,    40,     0,   556,   521,
     558,   521,     0,   207,     0,     0,   562,   521,   290,     0,
     565,   521,     0,   493,     0,     0,   206,     0,   522,   137,
       0,   238,   205,   445,     0,     0,     0,   290,     0,   208,
       0,   204,     0,   522,     0,   522,   508,     0,   345,     0,
     345,   522,   345,     0,   345,   522,   345,     0,   258,   345,
     345,   454,   203,     0,   203,   203,   137,   345,   345,   345,
     345,     0,   205,     0,   345,   345,   345,   345,   345,   207,
     492,   345,   345,   345,   528,   204,     0,     0,   216,   529,
       0,     0,   523,     0,     0,     0,     0,   206,     0,   520,
       0,    40,   219,     0,     0,   208,     0,   203,   203,     0,
     203,     0,   203,   290,     0,     0,   205,   445,   217,     0,
       0,     0,     0,   203,     0,   203,   203,   495,     0,     0,
       0,   203,   203,     0,     0,   203,     0,   206,   523,     0,
       0,     0,   493,     0,   219,   520,     0,     0,     0,     0,
     207,     0,   345,   523,   216,   523,     0,     0,     0,     0,
     520,   523,   520,   219,     0,   523,     0,     0,   520,     0,
       0,     0,   520,     0,   541,   345,   208,   345,   345,     0,
       0,   206,     0,   238,   217,   238,   238,     0,     0,     0,
     207,     0,     0,     0,     0,     0,     0,   553,     0,     0,
       0,     0,     0,     0,     0,   210,     0,   561,     0,     0,
       0,     0,     0,   538,   539,   540,   208,     0,     0,     0,
       0,     0,     0,     0,     0,   216,     0,     0,   238,   238,
      21,   238,     0,   238,   207,     0,     0,   204,     0,   204,
     204,     0,     0,     0,   238,     0,   238,   238,    22,     0,
       0,     0,   238,   238,     0,   217,   238,     0,     0,     0,
     208,     0,    23,     0,     0,   216,     0,     0,   205,     0,
     205,   205,    24,    25,    26,    27,     0,     0,    28,    29,
      30,     0,   204,   204,     0,   204,     0,   204,     0,     0,
       0,    31,     0,   -46,     0,   217,     0,     0,   204,     0,
     204,   204,     0,     0,     0,     0,   204,   204,     0,   216,
     204,     0,     0,   205,   205,     0,   205,     0,   205,    16,
     161,   162,   163,   164,   165,   166,   167,   168,    16,   205,
       0,   205,   205,   206,     0,   206,   206,   205,   205,   217,
       0,   205,     0,     0,     0,     0,   175,   176,     0,     0,
     122,   123,   124,   125,   126,   127,   128,   129,   130,   122,
     123,   124,   125,   126,   127,   128,   129,   130,   250,     0,
     251,     0,     0,     0,     0,     0,     0,     0,   206,   206,
       0,   206,     0,   206,     0,     0,   207,     0,   207,   207,
       0,     0,   178,     0,   206,     0,   206,   206,     0,     0,
       0,     0,   206,   206,     0,     0,   206,   299,   300,     0,
       0,     0,   208,     0,   208,   208,     0,   179,   180,     0,
     301,   302,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   207,   207,     0,   207,     0,   207,     0,     0,     0,
       0,   291,     0,     0,     0,   293,     0,   207,     0,   207,
     207,     0,     0,     0,     0,   207,   207,   208,   208,   207,
     208,   216,   208,   216,   216,     0,     0,     0,     0,     0,
       0,    21,     0,   208,   349,   208,   208,   352,   314,     0,
       0,   208,   208,   349,     0,   208,   342,   343,     0,    22,
       0,   217,     0,   217,   217,     0,     0,     0,     0,     0,
     346,   346,     0,    23,     0,     0,   216,   216,     0,   216,
       0,   216,     0,    24,    25,    26,    27,     0,     0,    28,
      29,    30,   216,     0,   216,   216,     0,   374,   374,     0,
     216,   216,    31,     0,   216,     0,   217,   217,     0,   217,
     368,   217,   370,     0,     0,     0,     0,   377,     0,     0,
       0,     0,   217,     0,   217,   217,     0,   418,     0,     0,
     217,   217,     0,     0,   217,     0,     0,    16,   161,   162,
     163,   164,   165,   166,   167,   168,   418,     0,   419,     0,
       0,     0,     0,     0,     0,     0,     0,   428,     0,   434,
     346,   346,   346,   346,   175,   176,     0,     0,     0,     0,
       0,     0,   444,   459,     0,     0,   459,     0,    16,   161,
     162,   163,   164,   165,   166,   167,   168,     0,     0,     0,
       0,     0,     0,   460,     0,     0,     0,     0,     0,     0,
     464,     0,     0,     0,     0,   175,   176,     0,     0,     0,
     178,     0,   346,     0,   346,     0,   346,     0,   346,     0,
     346,   488,   490,   346,   346,     0,     0,   347,   347,     0,
       0,   346,   346,   346,   346,   179,   180,   368,   346,   346,
     346,   346,   346,     0,     0,   346,   346,   346,     0,     0,
       0,   178,     0,     0,     0,     0,   355,     0,   504,     0,
       0,     0,     0,     0,   444,     0,   299,   300,     0,     0,
       0,   502,     0,     0,     0,     0,   179,   180,   460,   301,
     302,   448,    21,     0,     0,     0,     0,   451,     0,     0,
     504,     0,     0,     0,     0,     0,     0,     0,   463,     0,
      22,     0,   352,     0,     0,     0,     0,     0,     0,   368,
       0,   314,     0,     0,    23,     0,   346,   347,   347,   347,
     347,     0,     0,     0,    24,    25,    26,    27,     0,     0,
      28,    29,    30,     0,     0,     0,     0,     0,     0,   346,
     486,   346,   346,    31,     0,     0,    85,   -37,   444,   491,
      32,     0,     0,     0,     0,   494,     0,   546,     0,   548,
       0,     0,     0,     0,     0,     0,     0,   499,     0,   347,
       0,   347,   314,   347,     0,   347,     0,   347,     0,     0,
     347,   347,     0,   507,     0,     0,     0,     0,   347,   347,
     347,   347,     0,     0,     0,   347,   347,   347,   347,   347,
       0,     0,   347,   347,   347,     0,     0,     0,   511,     0,
     512,     0,    16,   161,   162,   163,   164,   165,   166,   167,
     168,     0,     0,     0,   530,     0,     0,     0,     0,    16,
     161,   162,   163,   164,   165,   166,   167,   168,     0,   175,
     176,     0,     0,     0,     0,     0,     0,     0,   542,     0,
       0,     0,     0,     0,     0,     0,   175,   176,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   552,     0,   554,
     555,     0,     0,   347,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   564,   178,     0,    85,     0,     0,
       0,     0,     0,     0,     0,     0,   347,     0,   347,   347,
     299,   300,   178,     0,     0,     0,     0,     0,     0,     0,
     179,   180,     0,   301,   302,     0,     0,   299,   300,     0,
       0,     0,     0,     0,     0,     0,     0,   179,   180,     0,
     301,   302,    16,   161,   162,   163,   164,   165,   166,   167,
     168,     0,     0,    21,     0,     0,     0,   169,   170,   171,
     172,     0,     0,     0,   173,   174,     0,     0,     0,   175,
     176,     0,   177,   122,   123,   124,   125,   126,   127,   128,
     129,   130,    16,   161,   162,   163,   164,   165,   166,   167,
     168,     0,     0,    21,     0,    54,     0,   169,   170,   171,
     172,     0,     0,     0,   173,   174,     0,     0,     0,   175,
     176,     0,   177,     0,     0,   178,     0,    85,     0,     0,
       0,    32,    16,   161,   162,   163,   164,   165,   166,   167,
     168,    16,   161,   162,   163,   164,   165,   166,   167,   168,
     179,   180,     0,     0,   178,     0,     0,     0,   248,   175,
     176,     0,     0,     0,     0,   178,  -188,    85,   175,   176,
      -9,    32,   122,   123,   124,   125,   126,   127,   128,   129,
     130,     0,     0,     0,     0,     0,    21,     0,     0,     0,
     179,   180,  -188,  -188,  -188,  -188,  -188,  -188,  -188,  -188,
    -188,  -188,  -188,   -10,    22,   178,     0,     0,     0,     0,
       0,     0,     0,     0,   178,     0,     0,     0,    23,    21,
     299,   300,     0,     0,     0,     0,     0,     0,    24,    25,
      26,    27,     0,     0,    28,    29,    30,    22,     0,   179,
     180,    21,     0,     0,     0,     0,     0,    31,     0,     0,
       0,    23,     0,     0,    32,     0,     0,     0,     0,    22,
       0,    24,    25,    26,    27,     0,     0,    28,    29,    30,
       0,     0,     0,    23,     0,    21,     0,     0,     0,     0,
      31,     0,     0,    24,    25,    26,    27,    32,     0,    28,
      29,    30,     0,    22,     0,     0,     0,     0,     0,     0,
       0,     0,    31,     0,     0,     0,  -290,    23,     0,    32,
       0,     0,     0,     0,     0,     0,     0,    24,    25,    26,
      27,   265,     0,    28,    29,    30,     0,     0,     0,     0,
       0,     0,  -189,     0,     0,     0,    31,     0,     0,     0,
    -291,     0,     0,    32,  -190,     0,     0,   266,   267,   268,
     269,   270,   271,   272,   273,   274,   275,   276,  -189,  -189,
    -189,  -189,  -189,  -189,  -189,  -189,  -189,  -189,  -189,     0,
    -190,  -190,  -190,  -190,  -190,  -190,  -190,  -190,  -190,  -190,
    -190
};

static const yytype_int16 yycheck[] =
{
      10,    73,    10,    99,    56,    74,    78,    17,    60,    61,
     339,   227,    64,     7,   324,   295,    93,   339,   207,   115,
      72,    15,   207,    75,    34,    94,    34,   324,    80,   118,
      38,   108,     5,   445,   107,    53,   113,    89,   376,     5,
     117,    31,    30,    53,    96,   492,     5,   240,   241,    29,
      10,   464,   249,   250,   251,    29,   486,    93,    93,    69,
      93,    82,   103,   104,   541,    83,   118,   375,   120,    90,
      29,    46,   108,   108,    34,   108,     0,    87,    38,    87,
     132,    29,   512,    93,   561,    93,   158,    75,    80,    95,
     491,   101,    84,   101,   291,   184,   102,   149,   108,     5,
     108,    91,    92,   113,    84,    99,   553,   520,    82,    99,
     183,   372,   420,   329,   375,   105,   454,   529,    84,    78,
      47,   115,   311,    82,   118,    79,   311,    87,    82,   181,
      78,    84,   184,    93,    82,   108,   537,   330,   331,   332,
     333,   101,   103,   104,   103,   104,    67,    80,   108,    80,
     118,   552,   349,   554,    29,   352,    89,   495,    98,   560,
     100,   108,   109,   564,   493,   112,   255,    45,   478,   479,
     480,   368,    85,   370,   113,   114,   115,   187,   230,   231,
      79,   478,   479,   480,   400,    84,    85,   120,    79,    29,
     184,   159,   202,    84,    85,   213,   401,   402,   403,   404,
     408,   409,   410,   255,   118,    81,   295,   103,   104,    29,
     539,   491,   541,    82,   494,    78,   184,   539,   236,    96,
     230,   231,   415,   416,   417,    84,    85,   106,   107,   393,
     394,    83,   561,   227,   244,   118,   411,   412,   127,   101,
     292,   111,   210,   295,   110,    79,   240,   241,   256,    24,
     339,    24,    11,    34,   108,    72,   536,   537,   449,   354,
     228,   255,   149,   460,   232,   233,   234,   363,   351,   181,
     184,   450,   552,   255,   554,   555,   184,   539,     5,   247,
     560,   353,   561,   509,   564,   253,   359,   255,   491,   341,
     277,   382,   361,   303,   384,   388,   390,   400,   367,   351,
     118,   184,   386,   115,   421,   101,   297,   504,   556,    36,
      37,    38,    39,    40,    41,    42,    43,    44,   511,    67,
     246,    64,   491,    -1,   334,    -1,   336,   295,    -1,   297,
      -1,    -1,   342,   537,   537,   329,   330,   331,   332,   333,
      -1,   255,    69,    -1,    -1,   339,   354,    -1,   552,   552,
     554,   554,    -1,   118,    -1,    -1,   560,   560,   326,    -1,
     564,   564,    -1,   432,    -1,    -1,   184,    -1,   537,   363,
      -1,   339,   255,   445,    -1,    -1,    -1,   345,    -1,   118,
      -1,   295,    -1,   552,    -1,   554,   463,    -1,   382,    -1,
     384,   560,   386,    -1,   388,   564,   390,    -1,   450,   393,
     394,   369,   491,    -1,   493,   494,   400,   401,   402,   403,
     404,    -1,   295,    -1,   408,   409,   410,   411,   412,   184,
     430,   415,   416,   417,   497,   339,    -1,    -1,   118,   498,
      -1,    -1,   491,    -1,    -1,    -1,    -1,   255,    -1,   491,
      -1,   449,   494,    -1,    -1,   184,    -1,   536,   537,    -1,
     539,    -1,   541,   421,    -1,    -1,   339,   529,   118,    -1,
      -1,    -1,    -1,   552,    -1,   554,   555,   435,    -1,    -1,
      -1,   560,   561,    -1,    -1,   564,    -1,   295,   537,    -1,
      -1,    -1,   551,    -1,   536,   537,    -1,    -1,    -1,    -1,
     255,    -1,   486,   552,   184,   554,    -1,    -1,    -1,    -1,
     552,   560,   554,   555,    -1,   564,    -1,    -1,   560,    -1,
      -1,    -1,   564,    -1,   524,   509,   255,   511,   512,    -1,
      -1,   339,    -1,   491,   184,   493,   494,    -1,    -1,    -1,
     295,    -1,    -1,    -1,    -1,    -1,    -1,   547,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   539,    -1,   557,    -1,    -1,
      -1,    -1,    -1,   521,   522,   523,   295,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   255,    -1,    -1,   536,   537,
      16,   539,    -1,   541,   339,    -1,    -1,   491,    -1,   493,
     494,    -1,    -1,    -1,   552,    -1,   554,   555,    34,    -1,
      -1,    -1,   560,   561,    -1,   255,   564,    -1,    -1,    -1,
     339,    -1,    48,    -1,    -1,   295,    -1,    -1,   491,    -1,
     493,   494,    58,    59,    60,    61,    -1,    -1,    64,    65,
      66,    -1,   536,   537,    -1,   539,    -1,   541,    -1,    -1,
      -1,    77,    -1,    79,    -1,   295,    -1,    -1,   552,    -1,
     554,   555,    -1,    -1,    -1,    -1,   560,   561,    -1,   339,
     564,    -1,    -1,   536,   537,    -1,   539,    -1,   541,     5,
       6,     7,     8,     9,    10,    11,    12,    13,     5,   552,
      -1,   554,   555,   491,    -1,   493,   494,   560,   561,   339,
      -1,   564,    -1,    -1,    -1,    -1,    32,    33,    -1,    -1,
      36,    37,    38,    39,    40,    41,    42,    43,    44,    36,
      37,    38,    39,    40,    41,    42,    43,    44,   137,    -1,
     139,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   536,   537,
      -1,   539,    -1,   541,    -1,    -1,   491,    -1,   493,   494,
      -1,    -1,    78,    -1,   552,    -1,   554,   555,    -1,    -1,
      -1,    -1,   560,   561,    -1,    -1,   564,    93,    94,    -1,
      -1,    -1,   491,    -1,   493,   494,    -1,   103,   104,    -1,
     106,   107,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   536,   537,    -1,   539,    -1,   541,    -1,    -1,    -1,
      -1,   210,    -1,    -1,    -1,   214,    -1,   552,    -1,   554,
     555,    -1,    -1,    -1,    -1,   560,   561,   536,   537,   564,
     539,   491,   541,   493,   494,    -1,    -1,    -1,    -1,    -1,
      -1,    16,    -1,   552,   243,   554,   555,   246,   229,    -1,
      -1,   560,   561,   252,    -1,   564,   237,   238,    -1,    34,
      -1,   491,    -1,   493,   494,    -1,    -1,    -1,    -1,    -1,
     240,   241,    -1,    48,    -1,    -1,   536,   537,    -1,   539,
      -1,   541,    -1,    58,    59,    60,    61,    -1,    -1,    64,
      65,    66,   552,    -1,   554,   555,    -1,   296,   297,    -1,
     560,   561,    77,    -1,   564,    -1,   536,   537,    -1,   539,
     291,   541,   293,    -1,    -1,    -1,    -1,   298,    -1,    -1,
      -1,    -1,   552,    -1,   554,   555,    -1,   326,    -1,    -1,
     560,   561,    -1,    -1,   564,    -1,    -1,     5,     6,     7,
       8,     9,    10,    11,    12,    13,   345,    -1,   329,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,   338,    -1,   340,
     330,   331,   332,   333,    32,    33,    -1,    -1,    -1,    -1,
      -1,    -1,   353,   372,    -1,    -1,   375,    -1,     5,     6,
       7,     8,     9,    10,    11,    12,    13,    -1,    -1,    -1,
      -1,    -1,    -1,   374,    -1,    -1,    -1,    -1,    -1,    -1,
     381,    -1,    -1,    -1,    -1,    32,    33,    -1,    -1,    -1,
      78,    -1,   382,    -1,   384,    -1,   386,    -1,   388,    -1,
     390,   420,   421,   393,   394,    -1,    -1,   240,   241,    -1,
      -1,   401,   402,   403,   404,   103,   104,   418,   408,   409,
     410,   411,   412,    -1,    -1,   415,   416,   417,    -1,    -1,
      -1,    78,    -1,    -1,    -1,    -1,    83,    -1,   457,    -1,
      -1,    -1,    -1,    -1,   445,    -1,    93,    94,    -1,    -1,
      -1,   452,    -1,    -1,    -1,    -1,   103,   104,   459,   106,
     107,   360,    16,    -1,    -1,    -1,    -1,   366,    -1,    -1,
     489,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   377,    -1,
      34,    -1,   501,    -1,    -1,    -1,    -1,    -1,    -1,   490,
      -1,   492,    -1,    -1,    48,    -1,   486,   330,   331,   332,
     333,    -1,    -1,    -1,    58,    59,    60,    61,    -1,    -1,
      64,    65,    66,    -1,    -1,    -1,    -1,    -1,    -1,   509,
     419,   511,   512,    77,    -1,    -1,    80,    81,   529,   428,
      84,    -1,    -1,    -1,    -1,   434,    -1,   538,    -1,   540,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,   446,    -1,   382,
      -1,   384,   553,   386,    -1,   388,    -1,   390,    -1,    -1,
     393,   394,    -1,   462,    -1,    -1,    -1,    -1,   401,   402,
     403,   404,    -1,    -1,    -1,   408,   409,   410,   411,   412,
      -1,    -1,   415,   416,   417,    -1,    -1,    -1,   487,    -1,
     489,    -1,     5,     6,     7,     8,     9,    10,    11,    12,
      13,    -1,    -1,    -1,   503,    -1,    -1,    -1,    -1,     5,
       6,     7,     8,     9,    10,    11,    12,    13,    -1,    32,
      33,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   527,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    32,    33,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,   546,    -1,   548,
     549,    -1,    -1,   486,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,   563,    78,    -1,    80,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   509,    -1,   511,   512,
      93,    94,    78,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     103,   104,    -1,   106,   107,    -1,    -1,    93,    94,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,   103,   104,    -1,
     106,   107,     5,     6,     7,     8,     9,    10,    11,    12,
      13,    -1,    -1,    16,    -1,    -1,    -1,    20,    21,    22,
      23,    -1,    -1,    -1,    27,    28,    -1,    -1,    -1,    32,
      33,    -1,    35,    36,    37,    38,    39,    40,    41,    42,
      43,    44,     5,     6,     7,     8,     9,    10,    11,    12,
      13,    -1,    -1,    16,    -1,    29,    -1,    20,    21,    22,
      23,    -1,    -1,    -1,    27,    28,    -1,    -1,    -1,    32,
      33,    -1,    35,    -1,    -1,    78,    -1,    80,    -1,    -1,
      -1,    84,     5,     6,     7,     8,     9,    10,    11,    12,
      13,     5,     6,     7,     8,     9,    10,    11,    12,    13,
     103,   104,    -1,    -1,    78,    -1,    -1,    -1,    82,    32,
      33,    -1,    -1,    -1,    -1,    78,    90,    80,    32,    33,
       0,    84,    36,    37,    38,    39,    40,    41,    42,    43,
      44,    -1,    -1,    -1,    -1,    -1,    16,    -1,    -1,    -1,
     103,   104,   116,   117,   118,   119,   120,   121,   122,   123,
     124,   125,   126,     0,    34,    78,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    78,    -1,    -1,    -1,    48,    16,
      93,    94,    -1,    -1,    -1,    -1,    -1,    -1,    58,    59,
      60,    61,    -1,    -1,    64,    65,    66,    34,    -1,   103,
     104,    16,    -1,    -1,    -1,    -1,    -1,    77,    -1,    -1,
      -1,    48,    -1,    -1,    84,    -1,    -1,    -1,    -1,    34,
      -1,    58,    59,    60,    61,    -1,    -1,    64,    65,    66,
      -1,    -1,    -1,    48,    -1,    16,    -1,    -1,    -1,    -1,
      77,    -1,    -1,    58,    59,    60,    61,    84,    -1,    64,
      65,    66,    -1,    34,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    77,    -1,    -1,    -1,    81,    48,    -1,    84,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    58,    59,    60,
      61,    90,    -1,    64,    65,    66,    -1,    -1,    -1,    -1,
      -1,    -1,    90,    -1,    -1,    -1,    77,    -1,    -1,    -1,
      81,    -1,    -1,    84,    90,    -1,    -1,   116,   117,   118,
     119,   120,   121,   122,   123,   124,   125,   126,   116,   117,
     118,   119,   120,   121,   122,   123,   124,   125,   126,    -1,
     116,   117,   118,   119,   120,   121,   122,   123,   124,   125,
     126
};

/* YYSTOS[STATE-NUM] -- The symbol kind of the accessing symbol of
   state STATE-NUM.  */
static const yytype_int16 yystos[] =
{
       0,    46,   130,   131,   132,   133,   138,   299,     0,    47,
     134,   136,   139,   140,   141,   300,     5,   237,   238,   239,
     266,    16,    34,    48,    58,    59,    60,    61,    64,    65,
      66,    77,    84,   135,   137,   142,   143,   167,   168,   256,
     275,   287,   301,   302,   303,   304,   305,   306,   307,   311,
     318,   358,   139,   237,    29,   318,   320,   142,    30,    75,
     283,   310,   167,   318,   320,   266,   266,   266,   108,   338,
      45,   147,   298,   257,   258,   298,   318,    67,   144,   145,
     308,   148,   149,   150,   266,    80,   259,   314,    85,   319,
     149,   265,   151,   314,   146,   265,   320,   163,   166,   167,
     260,   261,   262,   263,   264,   318,   265,   152,   153,   154,
     160,   161,   162,   163,   166,   167,   174,   301,   314,   318,
     319,   266,    36,    37,    38,    39,    40,    41,    42,    43,
      44,    69,   173,   233,   234,   235,   236,   237,   249,   250,
     289,   290,   291,   292,   293,   294,   295,   296,   297,   309,
      81,   315,   262,   315,   152,   165,   174,   318,   155,   238,
     174,     6,     7,     8,     9,    10,    11,    12,    13,    20,
      21,    22,    23,    27,    28,    32,    33,    35,    78,   103,
     104,   173,   174,   175,   176,   177,   178,   179,   180,   182,
     183,   184,   185,   187,   188,   190,   192,   200,   201,   202,
     203,   207,   208,   209,   210,   211,   212,   216,   217,   219,
     237,   240,   241,   242,   243,   244,   245,   246,   251,   266,
     267,   268,   269,   270,   271,   272,   273,   274,   275,   276,
     277,   278,   279,   281,   282,   285,   286,   288,   312,   318,
     334,   335,   265,   164,   169,   170,   171,   266,    82,   316,
     316,   316,   164,   266,   156,   314,   312,   169,   266,   315,
     177,   318,   318,   334,   335,    90,   116,   117,   118,   119,
     120,   121,   122,   123,   124,   125,   126,   218,   321,   346,
     347,   348,   349,   350,   351,   352,   353,   354,   355,   356,
     312,   316,   320,   316,    96,   327,   233,   237,   312,    93,
      94,   106,   107,   196,   209,   210,   211,   212,   213,   214,
     215,   216,   217,   220,   221,   222,   223,   224,   225,   226,
     227,   228,   229,   230,   231,   232,   237,   245,   246,   312,
     324,   325,   336,   337,   266,   318,   266,   318,   312,   312,
     312,   320,   221,   221,   213,   237,   240,   241,   213,   316,
     318,   319,   316,   321,   312,    83,   317,   317,   317,   175,
     157,   158,   159,   167,   220,   221,   247,   248,   221,   266,
     221,   180,   254,   255,   316,   254,   312,   221,   318,    95,
     102,   326,   333,   101,   332,   127,   357,   111,   341,   110,
     340,    98,   100,   328,   331,    31,    91,    92,    99,   105,
     284,   322,   323,   329,   330,   113,   114,   115,   343,   344,
     345,   336,   337,   109,   112,   338,   339,   342,   316,   221,
     233,   237,   213,   213,   213,   213,   318,   318,   221,   179,
     194,   197,   199,   208,   221,   266,   318,    79,   313,   317,
     170,   317,   172,   204,   221,   314,   157,   315,   313,   319,
     173,   313,   319,   317,   312,   317,   252,   253,   255,   316,
     221,   252,   247,   313,   221,   224,   225,   226,   227,   228,
     229,   229,   233,   249,   230,   230,   230,   230,   231,   231,
     231,   232,   232,   213,   213,   213,   313,   252,   316,   253,
     316,   313,   318,   319,   313,   312,   172,   205,   206,   313,
     159,   171,   221,   247,   316,   317,   317,   313,   174,   327,
     214,   313,   313,   180,   181,   182,   186,   189,   191,   193,
     266,   279,   281,   282,   196,   208,   180,   247,   315,   319,
     313,   317,   222,   213,   214,    24,   280,   327,   312,   312,
     312,   318,   313,   172,   180,   181,   221,   194,   221,   195,
     198,   199,   313,   318,   313,   313,   181,   196,   181,   180,
     280,   318,   181,   195,   313,   181
};

/* YYR1[RULE-NUM] -- Symbol kind of the left-hand side of rule RULE-NUM.  */
static const yytype_int16 yyr1[] =
{
       0,   129,   130,   131,   132,   133,   133,   134,   134,   135,
     135,   136,   136,   137,   137,   138,   139,   139,   140,   141,
     142,   142,   142,   143,   144,   144,   145,   146,   146,   147,
     147,   148,   149,   149,   150,   150,   151,   152,   152,   153,
     153,   153,   153,   154,   155,   156,   157,   157,   158,   158,
     159,   160,   161,   161,   161,   162,   163,   163,   164,   164,
     165,   165,   166,   167,   167,   168,   168,   168,   168,   168,
     168,   168,   168,   168,   168,   168,   169,   169,   170,   170,
     171,   171,   172,   172,   173,   173,   174,   175,   175,   176,
     176,   177,   177,   178,   179,   180,   180,   180,   180,   180,
     180,   181,   181,   181,   181,   181,   182,   182,   182,   182,
     182,   182,   182,   182,   183,   184,   185,   186,   187,   188,
     189,   190,   191,   192,   193,   194,   194,   195,   195,   196,
     196,   197,   197,   198,   199,   199,   200,   200,   201,   201,
     202,   203,   204,   205,   205,   206,   206,   207,   208,   208,
     208,   208,   208,   208,   208,   209,   210,   211,   212,   213,
     213,   213,   213,   213,   214,   214,   214,   214,   215,   215,
     215,   216,   216,   216,   216,   217,   218,   218,   218,   218,
     218,   218,   218,   218,   218,   218,   218,   218,   219,   219,
     219,   220,   220,   221,   222,   222,   223,   223,   224,   224,
     225,   225,   226,   226,   227,   227,   228,   228,   228,   229,
     229,   229,   229,   229,   229,   230,   230,   230,   230,   231,
     231,   231,   232,   232,   232,   232,   233,   233,   234,   234,
     235,   235,   235,   235,   235,   235,   236,   236,   237,   237,
     238,   239,   240,   240,   241,   241,   242,   242,   243,   243,
     243,   243,   243,   243,   243,   244,   244,   244,   244,   244,
     244,   244,   245,   246,   246,   246,   247,   247,   248,   248,
     249,   249,   250,   250,   250,   251,   251,   252,   252,   253,
     253,   254,   254,   255,   256,   257,   257,   258,   258,   259,
     260,   260,   261,   261,   262,   262,   263,   264,   264,   265,
     266,   267,   268,   269,   270,   271,   272,   273,   274,   275,
     276,   277,   278,   279,   280,   281,   282,   283,   284,   285,
     286,   287,   288,   289,   290,   291,   292,   293,   294,   295,
     296,   297,   298,   299,   300,   301,   302,   303,   304,   305,
     306,   307,   308,   309,   310,   311,   312,   313,   314,   315,
     316,   317,   318,   319,   320,   321,   322,   323,   324,   325,
     326,   327,   328,   329,   330,   331,   332,   333,   334,   335,
     336,   337,   338,   339,   340,   341,   342,   343,   344,   345,
     346,   347,   348,   349,   350,   351,   352,   353,   354,   355,
     356,   357,   358
};

/* YYR2[RULE-NUM] -- Number of symbols on the right-hand side of rule RULE-NUM.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     1,     1,     3,     0,     1,     0,     1,     0,
       1,     1,     2,     1,     2,     3,     1,     1,     3,     5,
       1,     1,     1,     6,     0,     1,     2,     1,     3,     0,
       2,     1,     1,     3,     1,     3,     3,     0,     2,     1,
       1,     1,     1,     3,     4,     3,     0,     1,     1,     3,
       3,     2,     1,     1,     1,     2,     3,     3,     4,     3,
       1,     1,     4,     0,     2,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     3,     1,     3,
       1,     3,     1,     1,     1,     1,     3,     0,     1,     1,
       2,     1,     1,     2,     2,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     3,     3,     3,     5,     7,
       7,     5,     5,     9,     9,     0,     1,     0,     1,     0,
       1,     1,     1,     1,     1,     3,     3,     2,     2,     3,
       3,     5,     3,     0,     1,     1,     3,     2,     1,     1,
       1,     1,     1,     1,     1,     2,     2,     2,     2,     2,
       2,     1,     1,     1,     1,     2,     2,     1,     5,     4,
       5,     1,     1,     1,     1,     3,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     5,     1,     3,     1,     3,
       1,     3,     1,     3,     1,     3,     1,     3,     3,     1,
       3,     3,     3,     3,     3,     1,     3,     3,     3,     1,
       3,     3,     1,     3,     3,     3,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     3,     3,     3,     4,     4,     1,     1,     1,     1,
       3,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     5,     4,     6,     6,     0,     1,     1,     3,
       1,     1,     3,     3,     3,     4,     4,     0,     1,     2,
       3,     1,     2,     3,     5,     0,     1,     2,     3,     3,
       0,     1,     1,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1
};


enum { YYENOMEM = -2 };

#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab
#define YYNOMEM         goto yyexhaustedlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Backward compatibility with an undocumented macro.
   Use YYerror or YYUNDEF. */
#define YYERRCODE YYUNDEF


/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)




# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Kind, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo,
                       yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YY_USE (yyoutput);
  if (!yyvaluep)
    return;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo,
                 yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yykind < YYNTOKENS ? "token" : "nterm", yysymbol_name (yykind));

  yy_symbol_value_print (yyo, yykind, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp,
                 int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       YY_ACCESSING_SYMBOL (+yyssp[yyi + 1 - yynrhs]),
                       &yyvsp[(yyi + 1) - (yynrhs)]);
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args) ((void) 0)
# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif






/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg,
            yysymbol_kind_t yykind, YYSTYPE *yyvaluep)
{
  YY_USE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yykind, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/* Lookahead token kind.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;




/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate = 0;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus = 0;

    /* Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* Their size.  */
    YYPTRDIFF_T yystacksize = YYINITDEPTH;

    /* The state stack: array, bottom, top.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss = yyssa;
    yy_state_t *yyssp = yyss;

    /* The semantic value stack: array, bottom, top.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs = yyvsa;
    YYSTYPE *yyvsp = yyvs;

  int yyn;
  /* The return value of yyparse.  */
  int yyresult;
  /* Lookahead symbol kind.  */
  yysymbol_kind_t yytoken = YYSYMBOL_YYEMPTY;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;



#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yychar = YYEMPTY; /* Cause a token to be read.  */

  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END
  YY_STACK_PRINT (yyss, yyssp);

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    YYNOMEM;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        YYNOMEM;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          YYNOMEM;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */


  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either empty, or end-of-input, or a valid lookahead.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token\n"));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = YYEOF;
      yytoken = YYSYMBOL_YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else if (yychar == YYerror)
    {
      /* The scanner already issued an error message, process directly
         to error recovery.  But do not keep the error token as
         lookahead, it is too special and may lead us to an endless
         loop in error recovery. */
      yychar = YYUNDEF;
      yytoken = YYSYMBOL_YYerror;
      goto yyerrlab1;
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 2: /* input: Program  */
#line 588 "parser.y"
                                  {print();}
#line 2485 "parser.tab.c"
    break;

  case 3: /* Program: CompilationUnit  */
#line 590 "parser.y"
                                            {int uid = makenode("Program"); root=uid; int child = makenode(""); addChild(uid,(yyvsp[0].id)); addChild(uid, child); (yyval.id)=(yyvsp[0].id);}
#line 2491 "parser.tab.c"
    break;

  case 4: /* CompilationUnit: PackageDeclaration2 ImportDeclarations2 TypeDeclarations2  */
#line 592 "parser.y"
                                                                                        {
                                int uid = makenode("CompilationUnit"); 
                                addChild(uid, (yyvsp[-2].id)); 
                                addChild(uid, (yyvsp[-1].id));
                                addChild(uid, (yyvsp[0].id));
                                (yyval.id)=uid;
}
#line 2503 "parser.tab.c"
    break;

  case 5: /* PackageDeclaration2: %empty  */
#line 600 "parser.y"
                            {(yyval.id)=-1;}
#line 2509 "parser.tab.c"
    break;

  case 6: /* PackageDeclaration2: PackageDeclaration  */
#line 601 "parser.y"
                                             {(yyval.id)=(yyvsp[0].id);}
#line 2515 "parser.tab.c"
    break;

  case 7: /* ImportDeclarations2: %empty  */
#line 603 "parser.y"
                            {(yyval.id)=-1;}
#line 2521 "parser.tab.c"
    break;

  case 8: /* ImportDeclarations2: ImportDeclarations  */
#line 604 "parser.y"
                                                {(yyval.id)=(yyvsp[0].id);}
#line 2527 "parser.tab.c"
    break;

  case 9: /* TypeDeclarations2: %empty  */
#line 606 "parser.y"
                            {(yyval.id)=-1;}
#line 2533 "parser.tab.c"
    break;

  case 10: /* TypeDeclarations2: TypeDeclarations  */
#line 607 "parser.y"
                                              {(yyval.id)=(yyvsp[0].id);}
#line 2539 "parser.tab.c"
    break;

  case 11: /* ImportDeclarations: ImportDeclaration  */
#line 609 "parser.y"
                                            {(yyval.id)=(yyvsp[0].id);}
#line 2545 "parser.tab.c"
    break;

  case 12: /* ImportDeclarations: ImportDeclarations ImportDeclaration  */
#line 610 "parser.y"
                                                                {int uid = makenode("ImportDeclarations"); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id)=uid;}
#line 2551 "parser.tab.c"
    break;

  case 13: /* TypeDeclarations: TypeDeclaration  */
#line 612 "parser.y"
                                            {(yyval.id)=(yyvsp[0].id);}
#line 2557 "parser.tab.c"
    break;

  case 14: /* TypeDeclarations: TypeDeclarations TypeDeclaration  */
#line 613 "parser.y"
                                                            {int uid = makenode("TypeDeclarations"); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id)=uid;}
#line 2563 "parser.tab.c"
    break;

  case 15: /* PackageDeclaration: PACKAGE Name SEMICOL  */
#line 615 "parser.y"
                                                {
                                int uid = makenode("PackageDeclaration"); 
                                addChild(uid, (yyvsp[-2].id)); 
                                addChild(uid, (yyvsp[-1].id));
                                addChild(uid, (yyvsp[0].id));
                                (yyval.id)=uid;
                        }
#line 2575 "parser.tab.c"
    break;

  case 16: /* ImportDeclaration: SingleTypeImportDeclaration  */
#line 623 "parser.y"
                                                        {(yyval.id)=(yyvsp[0].id);}
#line 2581 "parser.tab.c"
    break;

  case 17: /* ImportDeclaration: TypeImportOnDemandDeclaration  */
#line 624 "parser.y"
                                                        {(yyval.id)=(yyvsp[0].id);}
#line 2587 "parser.tab.c"
    break;

  case 18: /* SingleTypeImportDeclaration: IMPORT Name SEMICOL  */
#line 626 "parser.y"
                                                    {
                                int uid = makenode("SingleTypeImportDeclaration"); 
                                addChild(uid, (yyvsp[-2].id)); 
                                addChild(uid, (yyvsp[-1].id));
                                addChild(uid, (yyvsp[0].id));
                                (yyval.id)=uid;
                        }
#line 2599 "parser.tab.c"
    break;

  case 19: /* TypeImportOnDemandDeclaration: IMPORT Name DOT MUL SEMICOL  */
#line 634 "parser.y"
                                                            {
                                int uid = makenode("TypeImportOnDemandDeclaration"); 
                                addChild(uid, (yyvsp[-4].id)); 
                                addChild(uid, (yyvsp[-3].id));
                                addChild(uid, (yyvsp[-2].id));
                                addChild(uid, (yyvsp[-1].id));
                                addChild(uid, (yyvsp[0].id));
                                (yyval.id)=uid;
                        }
#line 2613 "parser.tab.c"
    break;

  case 20: /* TypeDeclaration: ClassDeclaration  */
#line 644 "parser.y"
                                                    {(yyval.id)=(yyvsp[0].id);}
#line 2619 "parser.tab.c"
    break;

  case 21: /* TypeDeclaration: InterfaceDeclaration  */
#line 645 "parser.y"
                                                    {(yyval.id)=(yyvsp[0].id);}
#line 2625 "parser.tab.c"
    break;

  case 22: /* TypeDeclaration: SEMICOL  */
#line 646 "parser.y"
                                                    {(yyval.id)=(yyvsp[0].id);}
#line 2631 "parser.tab.c"
    break;

  case 23: /* ClassDeclaration: Modifiers1 CLASS identifier SuperClass Interfaces2 ClassBody  */
#line 649 "parser.y"
                                                                                       {
                                int uid = makenode("ClassDeclaration"); 
                                addChild(uid, (yyvsp[-5].id)); 
                                addChild(uid, (yyvsp[-4].id));
                                addChild(uid, (yyvsp[-3].id));
                                addChild(uid, (yyvsp[-2].id));
                                addChild(uid, (yyvsp[-1].id));
                                addChild(uid, (yyvsp[0].id));
                                (yyval.id)=uid;
                        }
#line 2646 "parser.tab.c"
    break;

  case 24: /* Interfaces2: %empty  */
#line 660 "parser.y"
                          {(yyval.id) = -1;}
#line 2652 "parser.tab.c"
    break;

  case 25: /* Interfaces2: Interfaces  */
#line 661 "parser.y"
                                     {(yyval.id)=(yyvsp[0].id);}
#line 2658 "parser.tab.c"
    break;

  case 26: /* Interfaces: IMPLEMENTS InterfaceTypeList  */
#line 663 "parser.y"
                                                       {
                                int uid = makenode("Interfaces"); 
                                addChild(uid, (yyvsp[-1].id));
                                addChild(uid, (yyvsp[0].id));
                                (yyval.id)=uid;
                        }
#line 2669 "parser.tab.c"
    break;

  case 27: /* InterfaceTypeList: InterfaceType  */
#line 670 "parser.y"
                                        {(yyval.id)=(yyvsp[0].id);}
#line 2675 "parser.tab.c"
    break;

  case 28: /* InterfaceTypeList: InterfaceTypeList COMMA InterfaceType  */
#line 671 "parser.y"
                                                                {
                                int uid = makenode("InterfaceTypeList"); 
                                addChild(uid, (yyvsp[-2].id));
                                addChild(uid, (yyvsp[-1].id));
                                addChild(uid, (yyvsp[0].id));
                                (yyval.id)=uid;
                        }
#line 2687 "parser.tab.c"
    break;

  case 29: /* SuperClass: %empty  */
#line 679 "parser.y"
                          {(yyval.id) = -1;}
#line 2693 "parser.tab.c"
    break;

  case 30: /* SuperClass: EXTENDS ClassType  */
#line 680 "parser.y"
                                            {
                                int uid = makenode("SuperClass"); 
                                addChild(uid, (yyvsp[-1].id));
                                addChild(uid, (yyvsp[0].id));
                                (yyval.id)=uid;
                        }
#line 2704 "parser.tab.c"
    break;

  case 31: /* ClassType: TypeName  */
#line 687 "parser.y"
                                   {(yyval.id)=(yyvsp[0].id);}
#line 2710 "parser.tab.c"
    break;

  case 32: /* TypeName: identifier  */
#line 689 "parser.y"
                                      { (yyval.id) = (yyvsp[0].id);}
#line 2716 "parser.tab.c"
    break;

  case 33: /* TypeName: PackageName DOT identifier  */
#line 690 "parser.y"
                                                       {
                             int uid = makenode("TypeName");
                             addChild(uid,(yyvsp[-2].id));
                             addChild(uid, (yyvsp[-1].id));
                             addChild(uid, (yyvsp[0].id));
                             (yyval.id) = uid;
                        }
#line 2728 "parser.tab.c"
    break;

  case 34: /* PackageName: identifier  */
#line 698 "parser.y"
                                      { (yyval.id) = (yyvsp[0].id);}
#line 2734 "parser.tab.c"
    break;

  case 35: /* PackageName: PackageName DOT identifier  */
#line 699 "parser.y"
                                                       {
                             int uid = makenode("PackageName");
                             addChild(uid,(yyvsp[-2].id));
                             addChild(uid, (yyvsp[-1].id));
                             addChild(uid, (yyvsp[0].id));
                             (yyval.id) = uid;
                        }
#line 2746 "parser.tab.c"
    break;

  case 36: /* ClassBody: OPEN_CURLY ClassBodyDeclarations CLOSE_CURLY  */
#line 708 "parser.y"
                                                                       {
                                int uid = makenode("ClassBody"); 
                                addChild(uid, (yyvsp[-2].id));
                                addChild(uid, (yyvsp[-1].id));
                                addChild(uid, (yyvsp[0].id));
                                (yyval.id)=uid;
                        }
#line 2758 "parser.tab.c"
    break;

  case 37: /* ClassBodyDeclarations: %empty  */
#line 716 "parser.y"
                           {(yyval.id) = -1;}
#line 2764 "parser.tab.c"
    break;

  case 38: /* ClassBodyDeclarations: ClassBodyDeclaration ClassBodyDeclarations  */
#line 717 "parser.y"
                                                                     {int uid = makenode("ClassBodyDeclarations"); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id)=uid;}
#line 2770 "parser.tab.c"
    break;

  case 39: /* ClassBodyDeclaration: ClassMemberDeclaration  */
#line 719 "parser.y"
                                                 {(yyval.id) = (yyvsp[0].id);}
#line 2776 "parser.tab.c"
    break;

  case 40: /* ClassBodyDeclaration: StaticInitializer  */
#line 720 "parser.y"
                                              {(yyval.id) = (yyvsp[0].id);}
#line 2782 "parser.tab.c"
    break;

  case 41: /* ClassBodyDeclaration: ConstructorDeclaration  */
#line 721 "parser.y"
                                                 {(yyval.id) = (yyvsp[0].id);}
#line 2788 "parser.tab.c"
    break;

  case 42: /* ClassBodyDeclaration: Block  */
#line 722 "parser.y"
                                {(yyval.id) = (yyvsp[0].id);}
#line 2794 "parser.tab.c"
    break;

  case 43: /* ConstructorDeclaration: Modifiers1 ConstructorDeclarator ConstructorBody  */
#line 724 "parser.y"
                                                                            {int uid = makenode("ConstructorDeclaration"); addChild(uid, (yyvsp[-2].id)); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id));  (yyval.id) = uid;}
#line 2800 "parser.tab.c"
    break;

  case 44: /* ConstructorDeclarator: SimpleName OPEN_BRACKETS FormalParameterList2 CLOSE_BRACKETS  */
#line 726 "parser.y"
                                                                                                {int uid = makenode("ConstructorDeclarator"); addChild(uid, (yyvsp[-3].id)); addChild(uid, (yyvsp[-2].id));addChild(uid, (yyvsp[-1].id));addChild(uid, (yyvsp[0].id)); (yyval.id) = uid;}
#line 2806 "parser.tab.c"
    break;

  case 45: /* ConstructorBody: OPEN_CURLY BlockStatements2 CLOSE_CURLY  */
#line 728 "parser.y"
                                                                           {int uid = makenode("ConstructorBody"); addChild(uid, (yyvsp[-2].id)); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id));  (yyval.id) = uid;}
#line 2812 "parser.tab.c"
    break;

  case 46: /* FormalParameterList2: %empty  */
#line 731 "parser.y"
                                                                    {(yyval.id) = -1;}
#line 2818 "parser.tab.c"
    break;

  case 47: /* FormalParameterList2: FormalParameterList  */
#line 732 "parser.y"
                                                                    {(yyval.id) = (yyvsp[0].id);}
#line 2824 "parser.tab.c"
    break;

  case 48: /* FormalParameterList: FormalParameter  */
#line 734 "parser.y"
                                                                    {(yyval.id) = (yyvsp[0].id);}
#line 2830 "parser.tab.c"
    break;

  case 49: /* FormalParameterList: FormalParameterList COMMA FormalParameter  */
#line 735 "parser.y"
                                                                    {int uid = makenode("FormalParameterList"); addChild(uid, (yyvsp[-2].id)); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id) = uid;}
#line 2836 "parser.tab.c"
    break;

  case 50: /* FormalParameter: Modifiers1 Type VariableDeclaratorId  */
#line 737 "parser.y"
                                                                          {int uid = makenode("FormalParameter"); addChild(uid, (yyvsp[-2].id)); addChild(uid, (yyvsp[-1].id));addChild(uid, (yyvsp[0].id)); (yyval.id) = uid;}
#line 2842 "parser.tab.c"
    break;

  case 51: /* StaticInitializer: STATIC Block  */
#line 739 "parser.y"
                                                              {int uid = makenode("StaticInitializer"); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id) = uid;}
#line 2848 "parser.tab.c"
    break;

  case 52: /* ClassMemberDeclaration: FieldDeclaration  */
#line 741 "parser.y"
                                           {(yyval.id) = (yyvsp[0].id);}
#line 2854 "parser.tab.c"
    break;

  case 53: /* ClassMemberDeclaration: MethodDeclaration  */
#line 742 "parser.y"
                                            {(yyval.id) = (yyvsp[0].id);}
#line 2860 "parser.tab.c"
    break;

  case 55: /* MethodDeclaration: MethodHeader MethodBody  */
#line 747 "parser.y"
                                                                   {int uid = makenode("MethodDeclaration"); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id) = uid;}
#line 2866 "parser.tab.c"
    break;

  case 56: /* MethodHeader: Modifiers1 Type MethodDeclarator  */
#line 749 "parser.y"
                                                           {int uid = makenode("MethodHeader"); addChild(uid, (yyvsp[-2].id)); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id));  (yyval.id) = uid;}
#line 2872 "parser.tab.c"
    break;

  case 57: /* MethodHeader: Modifiers1 VOID MethodDeclarator  */
#line 750 "parser.y"
                                                           {int uid = makenode("MethodHeader"); addChild(uid, (yyvsp[-2].id)); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id));  (yyval.id) = uid;}
#line 2878 "parser.tab.c"
    break;

  case 58: /* MethodDeclarator: identifier OPEN_BRACKETS FormalParameterList2 CLOSE_BRACKETS  */
#line 752 "parser.y"
                                                                                       {int uid = makenode("MethodDeclarator"); addChild(uid, (yyvsp[-3].id)); addChild(uid, (yyvsp[-2].id)); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id) = uid;}
#line 2884 "parser.tab.c"
    break;

  case 59: /* MethodDeclarator: MethodDeclarator OPEN_SQ CLOSE_SQ  */
#line 753 "parser.y"
                                                                                       {int uid = makenode("MethodDeclarator"); addChild(uid, (yyvsp[-2].id)); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id) = uid;}
#line 2890 "parser.tab.c"
    break;

  case 60: /* MethodBody: Block  */
#line 755 "parser.y"
                                                               {(yyval.id) = (yyvsp[0].id);}
#line 2896 "parser.tab.c"
    break;

  case 61: /* MethodBody: SEMICOL  */
#line 756 "parser.y"
                                                                    {(yyval.id) = (yyvsp[0].id);}
#line 2902 "parser.tab.c"
    break;

  case 62: /* FieldDeclaration: Modifiers1 Type VariableDeclarators SEMICOL  */
#line 759 "parser.y"
                                                                            {int uid = makenode("FieldDeclaration"); addChild(uid, (yyvsp[-3].id)); addChild(uid,(yyvsp[-2].id)); addChild(uid,(yyvsp[-1].id)); addChild(uid,(yyvsp[0].id)); (yyval.id) = uid;}
#line 2908 "parser.tab.c"
    break;

  case 63: /* Modifiers1: %empty  */
#line 761 "parser.y"
                                            {(yyval.id) = -1;}
#line 2914 "parser.tab.c"
    break;

  case 64: /* Modifiers1: Modifier Modifiers1  */
#line 762 "parser.y"
                                              {
                                int uid = makenode("Modifiers"); 
                                addChild(uid, (yyvsp[-1].id));
                                addChild(uid, (yyvsp[0].id));
                                (yyval.id)=uid;
                        }
#line 2925 "parser.tab.c"
    break;

  case 65: /* Modifier: PUBLIC  */
#line 769 "parser.y"
                                            {(yyval.id) = (yyvsp[0].id);}
#line 2931 "parser.tab.c"
    break;

  case 66: /* Modifier: PROTECTED  */
#line 770 "parser.y"
                                            {(yyval.id) = (yyvsp[0].id);}
#line 2937 "parser.tab.c"
    break;

  case 67: /* Modifier: PRIVATE  */
#line 771 "parser.y"
                                            {(yyval.id) = (yyvsp[0].id);}
#line 2943 "parser.tab.c"
    break;

  case 68: /* Modifier: STATIC  */
#line 772 "parser.y"
                                            {(yyval.id) = (yyvsp[0].id);}
#line 2949 "parser.tab.c"
    break;

  case 69: /* Modifier: ABSTRACT  */
#line 773 "parser.y"
                                            {(yyval.id) = (yyvsp[0].id);}
#line 2955 "parser.tab.c"
    break;

  case 70: /* Modifier: FINAL  */
#line 774 "parser.y"
                                            {(yyval.id) = (yyvsp[0].id);}
#line 2961 "parser.tab.c"
    break;

  case 71: /* Modifier: NATIVE  */
#line 775 "parser.y"
                                            {(yyval.id) = (yyvsp[0].id);}
#line 2967 "parser.tab.c"
    break;

  case 72: /* Modifier: SYNCHRONIZED  */
#line 776 "parser.y"
                                            {(yyval.id) = (yyvsp[0].id);}
#line 2973 "parser.tab.c"
    break;

  case 73: /* Modifier: TRANSIENT  */
#line 777 "parser.y"
                                            {(yyval.id) = (yyvsp[0].id);}
#line 2979 "parser.tab.c"
    break;

  case 74: /* Modifier: VOLATILE  */
#line 778 "parser.y"
                                            {(yyval.id) = (yyvsp[0].id);}
#line 2985 "parser.tab.c"
    break;

  case 75: /* Modifier: STRICTFP  */
#line 779 "parser.y"
                                            {(yyval.id) = (yyvsp[0].id);}
#line 2991 "parser.tab.c"
    break;

  case 76: /* VariableDeclarators: VariableDeclarator  */
#line 781 "parser.y"
                                                                        {(yyval.id) = (yyvsp[0].id);}
#line 2997 "parser.tab.c"
    break;

  case 77: /* VariableDeclarators: VariableDeclarators COMMA VariableDeclarator  */
#line 782 "parser.y"
                                                                        {int uid = makenode("VariableDeclarators"); addChild(uid, (yyvsp[-2].id)); addChild(uid, (yyvsp[-1].id)), addChild(uid, (yyvsp[0].id)); (yyval.id) = uid;}
#line 3003 "parser.tab.c"
    break;

  case 78: /* VariableDeclarator: VariableDeclaratorId  */
#line 784 "parser.y"
                                                                         {(yyval.id) = (yyvsp[0].id);}
#line 3009 "parser.tab.c"
    break;

  case 79: /* VariableDeclarator: VariableDeclaratorId EQUAL VariableInitializer  */
#line 785 "parser.y"
                                                                         {int uid = makenode("VariableDeclarator"); addChild(uid, (yyvsp[-2].id)); addChild(uid, (yyvsp[-1].id)), addChild(uid, (yyvsp[0].id)); (yyval.id) = uid;}
#line 3015 "parser.tab.c"
    break;

  case 80: /* VariableDeclaratorId: identifier  */
#line 787 "parser.y"
                                            {(yyval.id) = (yyvsp[0].id);}
#line 3021 "parser.tab.c"
    break;

  case 81: /* VariableDeclaratorId: VariableDeclaratorId OPEN_SQ CLOSE_SQ  */
#line 788 "parser.y"
                                                                         {int uid = makenode("VariableDeclaratorId"); addChild(uid, (yyvsp[-2].id)); addChild(uid, (yyvsp[-1].id)), addChild(uid, (yyvsp[0].id)); (yyval.id) = uid;}
#line 3027 "parser.tab.c"
    break;

  case 82: /* VariableInitializer: Expression  */
#line 790 "parser.y"
                                            {int uid = makenode("Expression"); addChild(uid, (yyvsp[0].id)); (yyval.id) = uid;}
#line 3033 "parser.tab.c"
    break;

  case 83: /* VariableInitializer: ArrayInitializer  */
#line 791 "parser.y"
                                            {(yyval.id) = (yyvsp[0].id);}
#line 3039 "parser.tab.c"
    break;

  case 84: /* Type: PrimitiveType  */
#line 793 "parser.y"
                                            {(yyval.id) = (yyvsp[0].id);}
#line 3045 "parser.tab.c"
    break;

  case 85: /* Type: ReferenceType  */
#line 794 "parser.y"
                                            {(yyval.id) = (yyvsp[0].id);}
#line 3051 "parser.tab.c"
    break;

  case 86: /* Block: OPEN_CURLY BlockStatements2 CLOSE_CURLY  */
#line 798 "parser.y"
                                                                        {
                                int uid = makenode("Block"); 
                                addChild(uid, (yyvsp[-2].id));
                                addChild(uid, (yyvsp[-1].id));
                                addChild(uid, (yyvsp[0].id));
                                (yyval.id)=uid;
}
#line 3063 "parser.tab.c"
    break;

  case 87: /* BlockStatements2: %empty  */
#line 806 "parser.y"
                                         {(yyval.id) = -1;}
#line 3069 "parser.tab.c"
    break;

  case 88: /* BlockStatements2: BlockStatements  */
#line 807 "parser.y"
                                            {(yyval.id) = (yyvsp[0].id);}
#line 3075 "parser.tab.c"
    break;

  case 89: /* BlockStatements: BlockStatement  */
#line 809 "parser.y"
                                                            {(yyval.id) = (yyvsp[0].id);}
#line 3081 "parser.tab.c"
    break;

  case 90: /* BlockStatements: BlockStatements BlockStatement  */
#line 810 "parser.y"
                                                            {int uid = makenode("BlockStatements"); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id) = uid;}
#line 3087 "parser.tab.c"
    break;

  case 91: /* BlockStatement: LocalVariableDeclarationStatement  */
#line 812 "parser.y"
                                                            {(yyval.id) = (yyvsp[0].id);}
#line 3093 "parser.tab.c"
    break;

  case 92: /* BlockStatement: Statement  */
#line 813 "parser.y"
                                                            {(yyval.id) = (yyvsp[0].id);}
#line 3099 "parser.tab.c"
    break;

  case 93: /* LocalVariableDeclarationStatement: LocalVariableDeclaration SEMICOL  */
#line 815 "parser.y"
                                                                        { int uid = makenode("LocalVariableDeclarationStatement"); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id) = uid;}
#line 3105 "parser.tab.c"
    break;

  case 94: /* LocalVariableDeclaration: Type VariableDeclarators  */
#line 817 "parser.y"
                                                        { int uid = makenode("LocalVariableDeclaration"); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id) = uid;}
#line 3111 "parser.tab.c"
    break;

  case 95: /* Statement: StatementWithoutTrailingSubstatement  */
#line 820 "parser.y"
                                                                {(yyval.id) = (yyvsp[0].id);}
#line 3117 "parser.tab.c"
    break;

  case 96: /* Statement: LabeledStatement  */
#line 821 "parser.y"
                                                                {(yyval.id) = (yyvsp[0].id);}
#line 3123 "parser.tab.c"
    break;

  case 97: /* Statement: IfThenStatement  */
#line 822 "parser.y"
                                                                {(yyval.id) = (yyvsp[0].id);}
#line 3129 "parser.tab.c"
    break;

  case 98: /* Statement: IfThenElseStatement  */
#line 823 "parser.y"
                                                                {(yyval.id) = (yyvsp[0].id);}
#line 3135 "parser.tab.c"
    break;

  case 99: /* Statement: WhileStatement  */
#line 824 "parser.y"
                                                                {(yyval.id) = (yyvsp[0].id);}
#line 3141 "parser.tab.c"
    break;

  case 100: /* Statement: ForStatement  */
#line 825 "parser.y"
                                                                {(yyval.id) = (yyvsp[0].id);}
#line 3147 "parser.tab.c"
    break;

  case 101: /* StatementNoShortIf: StatementWithoutTrailingSubstatement  */
#line 827 "parser.y"
                                                                {(yyval.id) = (yyvsp[0].id);}
#line 3153 "parser.tab.c"
    break;

  case 102: /* StatementNoShortIf: LabeledStatementNoShortIf  */
#line 828 "parser.y"
                                                                {(yyval.id) = (yyvsp[0].id);}
#line 3159 "parser.tab.c"
    break;

  case 103: /* StatementNoShortIf: IfThenElseStatementNoShortIf  */
#line 829 "parser.y"
                                                                {(yyval.id) = (yyvsp[0].id);}
#line 3165 "parser.tab.c"
    break;

  case 104: /* StatementNoShortIf: WhileStatementNoShortIf  */
#line 830 "parser.y"
                                                                {(yyval.id) = (yyvsp[0].id);}
#line 3171 "parser.tab.c"
    break;

  case 105: /* StatementNoShortIf: ForStatementNoShortIf  */
#line 831 "parser.y"
                                                                {(yyval.id) = (yyvsp[0].id);}
#line 3177 "parser.tab.c"
    break;

  case 106: /* StatementWithoutTrailingSubstatement: Block  */
#line 833 "parser.y"
                                                            {(yyval.id) = (yyvsp[0].id);}
#line 3183 "parser.tab.c"
    break;

  case 107: /* StatementWithoutTrailingSubstatement: EmptyStatement  */
#line 834 "parser.y"
                                                                {(yyval.id) = (yyvsp[0].id);}
#line 3189 "parser.tab.c"
    break;

  case 108: /* StatementWithoutTrailingSubstatement: ExpressionStatement  */
#line 835 "parser.y"
                                                                {(yyval.id) = (yyvsp[0].id);}
#line 3195 "parser.tab.c"
    break;

  case 109: /* StatementWithoutTrailingSubstatement: BreakStatement  */
#line 836 "parser.y"
                                                                {(yyval.id) = (yyvsp[0].id);}
#line 3201 "parser.tab.c"
    break;

  case 110: /* StatementWithoutTrailingSubstatement: ContinueStatement  */
#line 837 "parser.y"
                                                                {(yyval.id) = (yyvsp[0].id);}
#line 3207 "parser.tab.c"
    break;

  case 111: /* StatementWithoutTrailingSubstatement: ReturnStatement  */
#line 838 "parser.y"
                                                                {(yyval.id) = (yyvsp[0].id);}
#line 3213 "parser.tab.c"
    break;

  case 112: /* StatementWithoutTrailingSubstatement: SynchronizedStatement  */
#line 839 "parser.y"
                                                                {(yyval.id) = (yyvsp[0].id);}
#line 3219 "parser.tab.c"
    break;

  case 113: /* StatementWithoutTrailingSubstatement: AssertStatement  */
#line 840 "parser.y"
                                                      {(yyval.id) = (yyvsp[0].id);}
#line 3225 "parser.tab.c"
    break;

  case 114: /* EmptyStatement: SEMICOL  */
#line 842 "parser.y"
                                                            {(yyval.id) = (yyvsp[0].id);}
#line 3231 "parser.tab.c"
    break;

  case 115: /* LabeledStatement: identifier COLON Statement  */
#line 844 "parser.y"
                                                            { int uid = makenode("LabeledStatement"); addChild(uid, (yyvsp[-2].id)); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id) = uid;}
#line 3237 "parser.tab.c"
    break;

  case 116: /* AssertStatement: ASSERT Expression SEMICOL  */
#line 846 "parser.y"
                                                           { int uid = makenode("assertStatement"); addChild(uid, (yyvsp[-2].id)); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id) = uid;}
#line 3243 "parser.tab.c"
    break;

  case 117: /* LabeledStatementNoShortIf: identifier COLON StatementNoShortIf  */
#line 848 "parser.y"
                                                                { int uid = makenode("LabeledStatementNoShortIf"); addChild(uid, (yyvsp[-2].id)); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id) = uid;}
#line 3249 "parser.tab.c"
    break;

  case 118: /* IfThenStatement: IF OPEN_BRACKETS Expression CLOSE_BRACKETS Statement  */
#line 850 "parser.y"
                                                                                {
                                                        int uid =  makenode("ifThenStmt");
                                                        addChild(uid, (yyvsp[-4].id));
                                                        addChild(uid, (yyvsp[-3].id));
                                                        addChild(uid, (yyvsp[-2].id));
                                                        addChild(uid, (yyvsp[-1].id));
                                                        addChild(uid, (yyvsp[0].id));
                                                        (yyval.id) = uid;
}
#line 3263 "parser.tab.c"
    break;

  case 119: /* IfThenElseStatement: IF OPEN_BRACKETS Expression CLOSE_BRACKETS StatementNoShortIf ELSE Statement  */
#line 860 "parser.y"
                                                                                                       {
                                                        int uid =  makenode("ifThenElseStmt");
                                                        addChild(uid, (yyvsp[-6].id));
                                                        addChild(uid, (yyvsp[-5].id));
                                                        addChild(uid, (yyvsp[-4].id));
                                                        addChild(uid, (yyvsp[-3].id));
                                                        addChild(uid, (yyvsp[-2].id));
                                                        addChild(uid, (yyvsp[-1].id));
                                                        addChild(uid, (yyvsp[0].id));
                                                        (yyval.id) = uid;
}
#line 3279 "parser.tab.c"
    break;

  case 120: /* IfThenElseStatementNoShortIf: IF OPEN_BRACKETS Expression CLOSE_BRACKETS StatementNoShortIf ELSE StatementNoShortIf  */
#line 872 "parser.y"
                                                                                                                            {
                                                        int uid =  makenode("ifThenElseStmtNoShortIf");
                                                        addChild(uid, (yyvsp[-6].id));
                                                        addChild(uid, (yyvsp[-5].id));
                                                        addChild(uid, (yyvsp[-4].id));
                                                        addChild(uid, (yyvsp[-3].id));
                                                        addChild(uid, (yyvsp[-2].id));
                                                        addChild(uid, (yyvsp[-1].id));
                                                        addChild(uid, (yyvsp[0].id));
                                                        (yyval.id) = uid;
}
#line 3295 "parser.tab.c"
    break;

  case 121: /* WhileStatement: WHILE OPEN_BRACKETS Expression CLOSE_BRACKETS Statement  */
#line 884 "parser.y"
                                                                                  {
                                                        int uid =  makenode("whileStmt");
                                                        addChild(uid, (yyvsp[-4].id));
                                                        addChild(uid, (yyvsp[-3].id));
                                                        addChild(uid, (yyvsp[-2].id));
                                                        addChild(uid, (yyvsp[-1].id));
                                                        addChild(uid, (yyvsp[0].id));
                                                        (yyval.id) = uid;
}
#line 3309 "parser.tab.c"
    break;

  case 122: /* WhileStatementNoShortIf: WHILE OPEN_BRACKETS Expression CLOSE_BRACKETS StatementNoShortIf  */
#line 894 "parser.y"
                                                                                            {
                                                        int uid =  makenode("whileStmtNoShortIf");
                                                        addChild(uid, (yyvsp[-4].id));
                                                        addChild(uid, (yyvsp[-3].id));
                                                        addChild(uid, (yyvsp[-2].id));
                                                        addChild(uid, (yyvsp[-1].id));
                                                        addChild(uid, (yyvsp[0].id));
                                                        (yyval.id) = uid;
}
#line 3323 "parser.tab.c"
    break;

  case 123: /* ForStatement: FOR OPEN_BRACKETS ForInit2 SEMICOL Expression2 SEMICOL ForUpdate2 CLOSE_BRACKETS Statement  */
#line 904 "parser.y"
                                                                                                                      {
                                                        int uid =  makenode("forStmt");
                                                        addChild(uid, (yyvsp[-8].id));
                                                        addChild(uid, (yyvsp[-7].id));
                                                        addChild(uid, (yyvsp[-6].id));
                                                        addChild(uid, (yyvsp[-5].id));
                                                        addChild(uid, (yyvsp[-4].id));
                                                        addChild(uid, (yyvsp[-3].id));
                                                        addChild(uid, (yyvsp[-2].id));
                                                        addChild(uid, (yyvsp[-1].id));
                                                        addChild(uid, (yyvsp[0].id));
                                                        (yyval.id) = uid;
}
#line 3341 "parser.tab.c"
    break;

  case 124: /* ForStatementNoShortIf: FOR OPEN_BRACKETS ForInit2 SEMICOL Expression2 SEMICOL ForUpdate2 CLOSE_BRACKETS StatementNoShortIf  */
#line 919 "parser.y"
                                                                                                                                {
                                                        int uid =  makenode("forStmtNoShortIf");
                                                        addChild(uid, (yyvsp[-8].id));
                                                        addChild(uid, (yyvsp[-7].id));
                                                        addChild(uid, (yyvsp[-6].id));
                                                        addChild(uid, (yyvsp[-5].id));
                                                        addChild(uid, (yyvsp[-4].id));
                                                        addChild(uid, (yyvsp[-3].id));
                                                        addChild(uid, (yyvsp[-2].id));
                                                        addChild(uid, (yyvsp[-1].id));
                                                        addChild(uid, (yyvsp[0].id));
                                                        (yyval.id) = uid;
}
#line 3359 "parser.tab.c"
    break;

  case 125: /* ForInit2: %empty  */
#line 933 "parser.y"
                               { (yyval.id) = -1; }
#line 3365 "parser.tab.c"
    break;

  case 126: /* ForInit2: ForInit  */
#line 934 "parser.y"
                                            { (yyval.id) = (yyvsp[0].id); }
#line 3371 "parser.tab.c"
    break;

  case 127: /* ForUpdate2: %empty  */
#line 937 "parser.y"
                            { (yyval.id) = -1; }
#line 3377 "parser.tab.c"
    break;

  case 128: /* ForUpdate2: ForUpdate  */
#line 938 "parser.y"
                                           { (yyval.id) = (yyvsp[0].id); }
#line 3383 "parser.tab.c"
    break;

  case 129: /* Expression2: %empty  */
#line 940 "parser.y"
                            { (yyval.id) = -1; }
#line 3389 "parser.tab.c"
    break;

  case 130: /* Expression2: Expression  */
#line 941 "parser.y"
                                        { (yyval.id) = (yyvsp[0].id); }
#line 3395 "parser.tab.c"
    break;

  case 131: /* ForInit: StatementExpressionList  */
#line 943 "parser.y"
                                                    {(yyval.id) = (yyvsp[0].id);}
#line 3401 "parser.tab.c"
    break;

  case 132: /* ForInit: LocalVariableDeclaration  */
#line 944 "parser.y"
                                                    {(yyval.id) = (yyvsp[0].id);}
#line 3407 "parser.tab.c"
    break;

  case 133: /* ForUpdate: StatementExpressionList  */
#line 946 "parser.y"
                                                    {(yyval.id) = (yyvsp[0].id);}
#line 3413 "parser.tab.c"
    break;

  case 134: /* StatementExpressionList: StatementExpression  */
#line 948 "parser.y"
                                                    {(yyval.id) = (yyvsp[0].id);}
#line 3419 "parser.tab.c"
    break;

  case 135: /* StatementExpressionList: StatementExpressionList COMMA StatementExpression  */
#line 949 "parser.y"
                                                                            { int uid = makenode("StatementExpressionList"); addChild(uid, (yyvsp[-2].id)); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id) = uid;}
#line 3425 "parser.tab.c"
    break;

  case 136: /* BreakStatement: BREAK identifier SEMICOL  */
#line 951 "parser.y"
                                                        { int uid = makenode("BreakStatement"); addChild(uid, (yyvsp[-2].id)); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id) = uid;}
#line 3431 "parser.tab.c"
    break;

  case 137: /* BreakStatement: BREAK SEMICOL  */
#line 952 "parser.y"
                                                        { int uid = makenode("BreakStatement"); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id) = uid;}
#line 3437 "parser.tab.c"
    break;

  case 138: /* ContinueStatement: CONTINUE SEMICOL  */
#line 955 "parser.y"
                                                        { int uid = makenode("ContinueStatement"); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id) = uid;}
#line 3443 "parser.tab.c"
    break;

  case 139: /* ContinueStatement: CONTINUE identifier SEMICOL  */
#line 956 "parser.y"
                                                            { int uid = makenode("ContinueStatement"); addChild(uid, (yyvsp[-2].id)); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id) = uid;}
#line 3449 "parser.tab.c"
    break;

  case 140: /* ReturnStatement: RETURN Expression2 SEMICOL  */
#line 958 "parser.y"
                                                        { int uid = makenode("ReturnStatement"); addChild(uid, (yyvsp[-2].id)); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id) = uid;}
#line 3455 "parser.tab.c"
    break;

  case 141: /* SynchronizedStatement: SYNCHRONIZED OPEN_BRACKETS Expression CLOSE_BRACKETS Block  */
#line 960 "parser.y"
                                                                                        {
                                                        int uid =  makenode("SynchronizedStatement");
                                                        addChild(uid, (yyvsp[-4].id));
                                                        addChild(uid, (yyvsp[-3].id));
                                                        addChild(uid, (yyvsp[-2].id));
                                                        addChild(uid, (yyvsp[-1].id));
                                                        addChild(uid, (yyvsp[0].id));
                                                        (yyval.id) = uid;
}
#line 3469 "parser.tab.c"
    break;

  case 142: /* ArrayInitializer: OPEN_CURLY VariableInitializers2 CLOSE_CURLY  */
#line 971 "parser.y"
                                                                        { int uid = makenode("ArrayInitializer"); addChild(uid, (yyvsp[-2].id)); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id) = uid;}
#line 3475 "parser.tab.c"
    break;

  case 143: /* VariableInitializers2: %empty  */
#line 973 "parser.y"
                                { (yyval.id) = -1; }
#line 3481 "parser.tab.c"
    break;

  case 144: /* VariableInitializers2: VariableInitializers  */
#line 974 "parser.y"
                                                { (yyval.id) = (yyvsp[0].id); }
#line 3487 "parser.tab.c"
    break;

  case 145: /* VariableInitializers: VariableInitializer  */
#line 976 "parser.y"
                                                {(yyval.id) = (yyvsp[0].id);}
#line 3493 "parser.tab.c"
    break;

  case 146: /* VariableInitializers: VariableInitializers COMMA VariableInitializer  */
#line 977 "parser.y"
                                                                            { int uid = makenode("VariableInitializers"); addChild(uid, (yyvsp[-2].id)); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id) = uid;}
#line 3499 "parser.tab.c"
    break;

  case 147: /* ExpressionStatement: StatementExpression SEMICOL  */
#line 980 "parser.y"
                                                      {int uid = makenode("ExStatement"); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id));(yyval.id)=uid;}
#line 3505 "parser.tab.c"
    break;

  case 148: /* StatementExpression: Assignment  */
#line 982 "parser.y"
                                                    {(yyval.id) = (yyvsp[0].id);}
#line 3511 "parser.tab.c"
    break;

  case 149: /* StatementExpression: PreIncrementExpression  */
#line 983 "parser.y"
                                                    {(yyval.id) = (yyvsp[0].id);}
#line 3517 "parser.tab.c"
    break;

  case 150: /* StatementExpression: PreDecrementExpression  */
#line 984 "parser.y"
                                                    {(yyval.id) = (yyvsp[0].id);}
#line 3523 "parser.tab.c"
    break;

  case 151: /* StatementExpression: PostIncrementExpression  */
#line 985 "parser.y"
                                                    {(yyval.id) = (yyvsp[0].id);}
#line 3529 "parser.tab.c"
    break;

  case 152: /* StatementExpression: PostDecrementExpression  */
#line 986 "parser.y"
                                                    {(yyval.id) = (yyvsp[0].id);}
#line 3535 "parser.tab.c"
    break;

  case 153: /* StatementExpression: MethodInvocation  */
#line 987 "parser.y"
                                                    {(yyval.id) = (yyvsp[0].id);}
#line 3541 "parser.tab.c"
    break;

  case 154: /* StatementExpression: ClassInstanceCreationExpression  */
#line 988 "parser.y"
                                                            {(yyval.id) = (yyvsp[0].id);}
#line 3547 "parser.tab.c"
    break;

  case 155: /* PreIncrementExpression: DPLUS UnaryExpression  */
#line 990 "parser.y"
                                                        {int uid = makenode("PreIncExpression"); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id)=uid;}
#line 3553 "parser.tab.c"
    break;

  case 156: /* PreDecrementExpression: DMINUS UnaryExpression  */
#line 992 "parser.y"
                                                        {int uid = makenode("PreDecExpression"); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id)=uid;}
#line 3559 "parser.tab.c"
    break;

  case 157: /* PostIncrementExpression: PostfixExpression DPLUS  */
#line 994 "parser.y"
                                                        {int uid = makenode("PostIncExpression"); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id)=uid;}
#line 3565 "parser.tab.c"
    break;

  case 158: /* PostDecrementExpression: PostfixExpression DMINUS  */
#line 996 "parser.y"
                                                        {int uid = makenode("PostDecExpression"); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id)=uid;}
#line 3571 "parser.tab.c"
    break;

  case 159: /* UnaryExpression: PLUS UnaryExpression  */
#line 998 "parser.y"
                                                        {int uid = makenode("UnaryExpression"); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id)=uid;}
#line 3577 "parser.tab.c"
    break;

  case 160: /* UnaryExpression: MINUS UnaryExpression  */
#line 999 "parser.y"
                                                         {int uid = makenode("UnaryExpression"); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id)=uid;}
#line 3583 "parser.tab.c"
    break;

  case 161: /* UnaryExpression: PreIncrementExpression  */
#line 1000 "parser.y"
                                                         {(yyval.id) = (yyvsp[0].id);}
#line 3589 "parser.tab.c"
    break;

  case 162: /* UnaryExpression: PreDecrementExpression  */
#line 1001 "parser.y"
                                                         {(yyval.id) = (yyvsp[0].id);}
#line 3595 "parser.tab.c"
    break;

  case 163: /* UnaryExpression: UnaryExpressionNotPlusMinus  */
#line 1002 "parser.y"
                                                         {(yyval.id) = (yyvsp[0].id);}
#line 3601 "parser.tab.c"
    break;

  case 164: /* UnaryExpressionNotPlusMinus: PostfixExpression  */
#line 1004 "parser.y"
                                                         {(yyval.id) = (yyvsp[0].id);}
#line 3607 "parser.tab.c"
    break;

  case 165: /* UnaryExpressionNotPlusMinus: TILDA UnaryExpression  */
#line 1005 "parser.y"
                                                        {int uid = makenode("UnaryExpressionNot+-"); addChild(uid, (yyvsp[-1].id));  (yyval.id)=uid;}
#line 3613 "parser.tab.c"
    break;

  case 166: /* UnaryExpressionNotPlusMinus: EXCLAMATORY UnaryExpression  */
#line 1006 "parser.y"
                                                            {int uid = makenode("UnaryExpressionNot+-"); addChild(uid, (yyvsp[-1].id));  (yyval.id)=uid;}
#line 3619 "parser.tab.c"
    break;

  case 167: /* UnaryExpressionNotPlusMinus: CastExpression  */
#line 1007 "parser.y"
                                                           {(yyval.id) = (yyvsp[0].id);}
#line 3625 "parser.tab.c"
    break;

  case 168: /* CastExpression: OPEN_BRACKETS PrimitiveType Dims2 CLOSE_BRACKETS UnaryExpression  */
#line 1009 "parser.y"
                                                                                            {
                                                        int uid = makenode("CastExpression");
                                                        addChild(uid,(yyvsp[-4].id));
                                                        addChild(uid,(yyvsp[-3].id));
                                                        addChild(uid, (yyvsp[-2].id));
                                                        addChild(uid, (yyvsp[-1].id));
                                                        addChild(uid, (yyvsp[0].id));
                                                        (yyval.id) = uid;
}
#line 3639 "parser.tab.c"
    break;

  case 169: /* CastExpression: OPEN_BRACKETS Expression CLOSE_BRACKETS UnaryExpressionNotPlusMinus  */
#line 1018 "parser.y"
                                                                                                {
                                                        int uid = makenode("CastExpression");
                                                        addChild(uid,(yyvsp[-3].id));
                                                        addChild(uid,(yyvsp[-2].id));
                                                        addChild(uid, (yyvsp[-1].id));
                                                        addChild(uid, (yyvsp[0].id));
                                                        
                                                        (yyval.id) = uid;
                        }
#line 3653 "parser.tab.c"
    break;

  case 170: /* CastExpression: OPEN_BRACKETS Name Dims CLOSE_BRACKETS UnaryExpressionNotPlusMinus  */
#line 1027 "parser.y"
                                                                                             {
                                                        int uid = makenode("CastExpression");
                                                        addChild(uid,(yyvsp[-4].id));
                                                        addChild(uid,(yyvsp[-3].id));
                                                        addChild(uid, (yyvsp[-2].id));
                                                        addChild(uid, (yyvsp[-1].id));
                                                        addChild(uid, (yyvsp[0].id));
                                                        (yyval.id) = uid;
                        }
#line 3667 "parser.tab.c"
    break;

  case 171: /* PostfixExpression: Name  */
#line 1037 "parser.y"
                                                       {(yyval.id) = (yyvsp[0].id);}
#line 3673 "parser.tab.c"
    break;

  case 172: /* PostfixExpression: Primary  */
#line 1038 "parser.y"
                                                      {(yyval.id) = (yyvsp[0].id);}
#line 3679 "parser.tab.c"
    break;

  case 173: /* PostfixExpression: PostIncrementExpression  */
#line 1039 "parser.y"
                                                      {(yyval.id) = (yyvsp[0].id);}
#line 3685 "parser.tab.c"
    break;

  case 174: /* PostfixExpression: PostDecrementExpression  */
#line 1040 "parser.y"
                                                      {(yyval.id) = (yyvsp[0].id);}
#line 3691 "parser.tab.c"
    break;

  case 175: /* Assignment: LeftHandSide AssignmentOperator AssignmentExpression  */
#line 1042 "parser.y"
                                                                               {
                                                        int uid = makenode("Assignment");
                                                        addChild(uid,(yyvsp[-2].id));
                                                        addChild(uid,(yyvsp[-1].id));
                                                        addChild(uid, (yyvsp[0].id));
                                                        (yyval.id) = uid;
}
#line 3703 "parser.tab.c"
    break;

  case 176: /* AssignmentOperator: EQUAL  */
#line 1050 "parser.y"
                                                {(yyval.id) = (yyvsp[0].id);}
#line 3709 "parser.tab.c"
    break;

  case 177: /* AssignmentOperator: MUL_EQUAL  */
#line 1051 "parser.y"
                                                {(yyval.id) = (yyvsp[0].id);}
#line 3715 "parser.tab.c"
    break;

  case 178: /* AssignmentOperator: DIVIDE_EQUAL  */
#line 1052 "parser.y"
                                                {(yyval.id) = (yyvsp[0].id);}
#line 3721 "parser.tab.c"
    break;

  case 179: /* AssignmentOperator: MODULO_EQUAL  */
#line 1053 "parser.y"
                                                {(yyval.id) = (yyvsp[0].id);}
#line 3727 "parser.tab.c"
    break;

  case 180: /* AssignmentOperator: PLUS_EQUAL  */
#line 1054 "parser.y"
                                                {(yyval.id) = (yyvsp[0].id);}
#line 3733 "parser.tab.c"
    break;

  case 181: /* AssignmentOperator: MINUS_EQUAL  */
#line 1055 "parser.y"
                                                {(yyval.id) = (yyvsp[0].id);}
#line 3739 "parser.tab.c"
    break;

  case 182: /* AssignmentOperator: DLESS_EQUAL  */
#line 1056 "parser.y"
                                                {(yyval.id) = (yyvsp[0].id);}
#line 3745 "parser.tab.c"
    break;

  case 183: /* AssignmentOperator: DGREATER_EQUAL  */
#line 1057 "parser.y"
                                                {(yyval.id) = (yyvsp[0].id);}
#line 3751 "parser.tab.c"
    break;

  case 184: /* AssignmentOperator: TGREATER_EQUAL  */
#line 1058 "parser.y"
                                                {(yyval.id) = (yyvsp[0].id);}
#line 3757 "parser.tab.c"
    break;

  case 185: /* AssignmentOperator: AND_EQUAL  */
#line 1059 "parser.y"
                                                {(yyval.id) = (yyvsp[0].id);}
#line 3763 "parser.tab.c"
    break;

  case 186: /* AssignmentOperator: HAT_EQUAL  */
#line 1060 "parser.y"
                                                {(yyval.id) = (yyvsp[0].id);}
#line 3769 "parser.tab.c"
    break;

  case 187: /* AssignmentOperator: OR_EQUAL  */
#line 1061 "parser.y"
                                                {(yyval.id) = (yyvsp[0].id);}
#line 3775 "parser.tab.c"
    break;

  case 188: /* LeftHandSide: Name  */
#line 1063 "parser.y"
                                                {(yyval.id) = (yyvsp[0].id);}
#line 3781 "parser.tab.c"
    break;

  case 189: /* LeftHandSide: FieldAccess  */
#line 1064 "parser.y"
                                                 {(yyval.id) = (yyvsp[0].id);}
#line 3787 "parser.tab.c"
    break;

  case 190: /* LeftHandSide: ArrayAccess  */
#line 1065 "parser.y"
                                                {(yyval.id) = (yyvsp[0].id);}
#line 3793 "parser.tab.c"
    break;

  case 191: /* AssignmentExpression: ConditionalExpression  */
#line 1067 "parser.y"
                                                {(yyval.id) = (yyvsp[0].id);}
#line 3799 "parser.tab.c"
    break;

  case 192: /* AssignmentExpression: Assignment  */
#line 1068 "parser.y"
                                                {(yyval.id) = (yyvsp[0].id);}
#line 3805 "parser.tab.c"
    break;

  case 193: /* Expression: AssignmentExpression  */
#line 1070 "parser.y"
                                                {(yyval.id) = (yyvsp[0].id);}
#line 3811 "parser.tab.c"
    break;

  case 194: /* ConditionalExpression: ConditionalOrExpression  */
#line 1072 "parser.y"
                                                    {(yyval.id) = (yyvsp[0].id);}
#line 3817 "parser.tab.c"
    break;

  case 195: /* ConditionalExpression: ConditionalOrExpression QUE Expression COLON ConditionalExpression  */
#line 1073 "parser.y"
                                                                                                {
                            int uid = makenode("ConditionalExpression");
                            addChild(uid, (yyvsp[-4].id));
                            addChild(uid, (yyvsp[-3].id));
                            addChild(uid, (yyvsp[-2].id));
                            addChild(uid, (yyvsp[-1].id));
                            addChild(uid, (yyvsp[0].id));
                            (yyval.id) = uid;
                        }
#line 3831 "parser.tab.c"
    break;

  case 196: /* ConditionalOrExpression: ConditionalAndExpression  */
#line 1083 "parser.y"
                                                            {(yyval.id) = (yyvsp[0].id);}
#line 3837 "parser.tab.c"
    break;

  case 197: /* ConditionalOrExpression: ConditionalOrExpression DOR ConditionalAndExpression  */
#line 1084 "parser.y"
                                                                               {
                                    int uid = makenode("ConditionalOrExpression");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 3849 "parser.tab.c"
    break;

  case 198: /* ConditionalAndExpression: InclusiveOrExpression  */
#line 1092 "parser.y"
                                                             {(yyval.id) = (yyvsp[0].id);}
#line 3855 "parser.tab.c"
    break;

  case 199: /* ConditionalAndExpression: ConditionalAndExpression DAND InclusiveOrExpression  */
#line 1093 "parser.y"
                                                                               {
                                    int uid = makenode("ConditionalAndExpression");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 3867 "parser.tab.c"
    break;

  case 200: /* InclusiveOrExpression: ExclusiveOrExpression  */
#line 1101 "parser.y"
                                                           {(yyval.id) = (yyvsp[0].id);}
#line 3873 "parser.tab.c"
    break;

  case 201: /* InclusiveOrExpression: InclusiveOrExpression OR ExclusiveOrExpression  */
#line 1102 "parser.y"
                                                                          {
                                    int uid = makenode("InclusiveOrExpression");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 3885 "parser.tab.c"
    break;

  case 202: /* ExclusiveOrExpression: AndExpression  */
#line 1110 "parser.y"
                                                            {(yyval.id) = (yyvsp[0].id);}
#line 3891 "parser.tab.c"
    break;

  case 203: /* ExclusiveOrExpression: ExclusiveOrExpression HAT AndExpression  */
#line 1111 "parser.y"
                                                                    {
                                    int uid = makenode("ExclusiveOrExpression");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 3903 "parser.tab.c"
    break;

  case 204: /* AndExpression: EqualityExpression  */
#line 1119 "parser.y"
                                                           {(yyval.id) = (yyvsp[0].id);}
#line 3909 "parser.tab.c"
    break;

  case 205: /* AndExpression: AndExpression AND EqualityExpression  */
#line 1120 "parser.y"
                                                                {
                                    int uid = makenode("AndExpression");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 3921 "parser.tab.c"
    break;

  case 206: /* EqualityExpression: RelationalExpression  */
#line 1128 "parser.y"
                                                           {(yyval.id) = (yyvsp[0].id);}
#line 3927 "parser.tab.c"
    break;

  case 207: /* EqualityExpression: EqualityExpression DEQUAL RelationalExpression  */
#line 1129 "parser.y"
                                                                           {
                                    int uid = makenode("EqualityExpression");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 3939 "parser.tab.c"
    break;

  case 208: /* EqualityExpression: EqualityExpression NEQUAL RelationalExpression  */
#line 1136 "parser.y"
                                                                          {
                                    int uid = makenode("EqualityExpression");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 3951 "parser.tab.c"
    break;

  case 209: /* RelationalExpression: ShiftExpression  */
#line 1144 "parser.y"
                                                            {(yyval.id) = (yyvsp[0].id);}
#line 3957 "parser.tab.c"
    break;

  case 210: /* RelationalExpression: RelationalExpression LESS ShiftExpression  */
#line 1145 "parser.y"
                                                                        {
                                    int uid = makenode("RelationalExpression");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 3969 "parser.tab.c"
    break;

  case 211: /* RelationalExpression: RelationalExpression GREATER ShiftExpression  */
#line 1152 "parser.y"
                                                                         {
                                    int uid = makenode("RelationalExpression");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 3981 "parser.tab.c"
    break;

  case 212: /* RelationalExpression: RelationalExpression LE ShiftExpression  */
#line 1159 "parser.y"
                                                                    {
                                    int uid = makenode("RelationalExpression");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 3993 "parser.tab.c"
    break;

  case 213: /* RelationalExpression: RelationalExpression GE ShiftExpression  */
#line 1166 "parser.y"
                                                                        {
                                    int uid = makenode("RelationalExpression");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 4005 "parser.tab.c"
    break;

  case 214: /* RelationalExpression: RelationalExpression INSTANCEOF ReferenceType  */
#line 1173 "parser.y"
                                                                        {
                                    int uid = makenode("RelationalExpression");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 4017 "parser.tab.c"
    break;

  case 215: /* ShiftExpression: AdditiveExpression  */
#line 1181 "parser.y"
                                                            {(yyval.id) = (yyvsp[0].id);}
#line 4023 "parser.tab.c"
    break;

  case 216: /* ShiftExpression: ShiftExpression DLESS AdditiveExpression  */
#line 1182 "parser.y"
                                                                        {
                                    int uid = makenode("ShiftExpression");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 4035 "parser.tab.c"
    break;

  case 217: /* ShiftExpression: ShiftExpression DGREATER AdditiveExpression  */
#line 1189 "parser.y"
                                                                            {
                                    int uid = makenode("ShiftExpression");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 4047 "parser.tab.c"
    break;

  case 218: /* ShiftExpression: ShiftExpression TGREATER AdditiveExpression  */
#line 1196 "parser.y"
                                                                            {
                                    int uid = makenode("ShiftExpression");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 4059 "parser.tab.c"
    break;

  case 219: /* AdditiveExpression: MultiplicativeExpression  */
#line 1204 "parser.y"
                                                            {(yyval.id) = (yyvsp[0].id);}
#line 4065 "parser.tab.c"
    break;

  case 220: /* AdditiveExpression: AdditiveExpression PLUS MultiplicativeExpression  */
#line 1205 "parser.y"
                                                                                {
                                    int uid = makenode("AdditiveExpression");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 4077 "parser.tab.c"
    break;

  case 221: /* AdditiveExpression: AdditiveExpression MINUS MultiplicativeExpression  */
#line 1212 "parser.y"
                                                                                {
                                    int uid = makenode("AdditiveExpression");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 4089 "parser.tab.c"
    break;

  case 222: /* MultiplicativeExpression: UnaryExpression  */
#line 1220 "parser.y"
                                                            {(yyval.id) = (yyvsp[0].id);}
#line 4095 "parser.tab.c"
    break;

  case 223: /* MultiplicativeExpression: MultiplicativeExpression MUL UnaryExpression  */
#line 1221 "parser.y"
                                                                            {
                                    int uid = makenode("MultiplicativeExpression");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 4107 "parser.tab.c"
    break;

  case 224: /* MultiplicativeExpression: MultiplicativeExpression DIVIDE UnaryExpression  */
#line 1228 "parser.y"
                                                                                {
                                    int uid = makenode("MultiplicativeExpression");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 4119 "parser.tab.c"
    break;

  case 225: /* MultiplicativeExpression: MultiplicativeExpression MODULO UnaryExpression  */
#line 1235 "parser.y"
                                                                                {
                                    int uid = makenode("MultiplicativeExpression");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 4131 "parser.tab.c"
    break;

  case 226: /* PrimitiveType: NumericType  */
#line 1244 "parser.y"
                                                            {(yyval.id) = (yyvsp[0].id);}
#line 4137 "parser.tab.c"
    break;

  case 227: /* PrimitiveType: BOOLEAN  */
#line 1245 "parser.y"
                                                            {(yyval.id) = (yyvsp[0].id);}
#line 4143 "parser.tab.c"
    break;

  case 228: /* NumericType: IntegerType  */
#line 1247 "parser.y"
                                                            {(yyval.id) = (yyvsp[0].id);}
#line 4149 "parser.tab.c"
    break;

  case 229: /* NumericType: FloatingPointType  */
#line 1248 "parser.y"
                                                            {(yyval.id) = (yyvsp[0].id);}
#line 4155 "parser.tab.c"
    break;

  case 230: /* IntegerType: BYTE  */
#line 1250 "parser.y"
                                                {(yyval.id) = (yyvsp[0].id);}
#line 4161 "parser.tab.c"
    break;

  case 231: /* IntegerType: SHORT  */
#line 1251 "parser.y"
                                                 {(yyval.id) = (yyvsp[0].id);}
#line 4167 "parser.tab.c"
    break;

  case 232: /* IntegerType: INT  */
#line 1252 "parser.y"
                                                 {(yyval.id) = (yyvsp[0].id);}
#line 4173 "parser.tab.c"
    break;

  case 233: /* IntegerType: LONG  */
#line 1253 "parser.y"
                                                 {(yyval.id) = (yyvsp[0].id);}
#line 4179 "parser.tab.c"
    break;

  case 234: /* IntegerType: CHAR  */
#line 1254 "parser.y"
                                                 {(yyval.id) = (yyvsp[0].id);}
#line 4185 "parser.tab.c"
    break;

  case 235: /* IntegerType: STRING  */
#line 1255 "parser.y"
                                                 {(yyval.id) = (yyvsp[0].id);}
#line 4191 "parser.tab.c"
    break;

  case 236: /* FloatingPointType: FLOAT  */
#line 1257 "parser.y"
                                                 {(yyval.id) = (yyvsp[0].id);}
#line 4197 "parser.tab.c"
    break;

  case 237: /* FloatingPointType: DOUBLE  */
#line 1258 "parser.y"
                                                     {(yyval.id) = (yyvsp[0].id);}
#line 4203 "parser.tab.c"
    break;

  case 238: /* Name: SimpleName  */
#line 1260 "parser.y"
                                                 {(yyval.id) = (yyvsp[0].id);}
#line 4209 "parser.tab.c"
    break;

  case 239: /* Name: QualifiedName  */
#line 1261 "parser.y"
                                                 {(yyval.id) = (yyvsp[0].id);}
#line 4215 "parser.tab.c"
    break;

  case 240: /* SimpleName: identifier  */
#line 1263 "parser.y"
                                                 {(yyval.id) = (yyvsp[0].id);}
#line 4221 "parser.tab.c"
    break;

  case 241: /* QualifiedName: Name DOT identifier  */
#line 1265 "parser.y"
                                                    {
                                    int uid = makenode("QualifiedName");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 4233 "parser.tab.c"
    break;

  case 242: /* FieldAccess: SUPER DOT identifier  */
#line 1273 "parser.y"
                                                    {
                                    int uid = makenode("FieldAccess");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 4245 "parser.tab.c"
    break;

  case 243: /* FieldAccess: Primary DOT identifier  */
#line 1280 "parser.y"
                                                  {
                                    int uid = makenode("FieldAccess");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 4257 "parser.tab.c"
    break;

  case 244: /* ArrayAccess: Name OPEN_SQ Expression CLOSE_SQ  */
#line 1289 "parser.y"
                                                                {
                                    int uid = makenode("ArrayAccess");
                                    addChild(uid, (yyvsp[-3].id));
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
}
#line 4270 "parser.tab.c"
    break;

  case 245: /* ArrayAccess: PrimaryNoNewArray OPEN_SQ Expression CLOSE_SQ  */
#line 1297 "parser.y"
                                                                            {
                                    int uid = makenode("ArrayAccess");
                                    addChild(uid, (yyvsp[-3].id));
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 4283 "parser.tab.c"
    break;

  case 246: /* Primary: PrimaryNoNewArray  */
#line 1306 "parser.y"
                                                         {(yyval.id) = (yyvsp[0].id);}
#line 4289 "parser.tab.c"
    break;

  case 247: /* Primary: ArrayCreationExpression  */
#line 1307 "parser.y"
                                                         {(yyval.id) = (yyvsp[0].id);}
#line 4295 "parser.tab.c"
    break;

  case 248: /* PrimaryNoNewArray: Literal  */
#line 1309 "parser.y"
                                                         {(yyval.id) = (yyvsp[0].id);}
#line 4301 "parser.tab.c"
    break;

  case 249: /* PrimaryNoNewArray: THIS  */
#line 1310 "parser.y"
                                                         {(yyval.id) = (yyvsp[0].id);}
#line 4307 "parser.tab.c"
    break;

  case 250: /* PrimaryNoNewArray: OPEN_BRACKETS Expression CLOSE_BRACKETS  */
#line 1311 "parser.y"
                                                                  {
                                                        int uid = makenode("PrimaryNoNewArray");
                                                        addChild(uid, (yyvsp[-2].id));
                                                        addChild(uid, (yyvsp[-1].id));
                                                        addChild(uid, (yyvsp[0].id));
                                                        (yyval.id) = uid;
                        }
#line 4319 "parser.tab.c"
    break;

  case 251: /* PrimaryNoNewArray: ClassInstanceCreationExpression  */
#line 1318 "parser.y"
                                                             {(yyval.id) = (yyvsp[0].id);}
#line 4325 "parser.tab.c"
    break;

  case 252: /* PrimaryNoNewArray: FieldAccess  */
#line 1319 "parser.y"
                                                             {(yyval.id) = (yyvsp[0].id);}
#line 4331 "parser.tab.c"
    break;

  case 253: /* PrimaryNoNewArray: MethodInvocation  */
#line 1320 "parser.y"
                                                             {(yyval.id) = (yyvsp[0].id);}
#line 4337 "parser.tab.c"
    break;

  case 254: /* PrimaryNoNewArray: ArrayAccess  */
#line 1321 "parser.y"
                                                             {(yyval.id) = (yyvsp[0].id);}
#line 4343 "parser.tab.c"
    break;

  case 255: /* Literal: IntegerLiteral  */
#line 1323 "parser.y"
                                                             {(yyval.id) = (yyvsp[0].id);}
#line 4349 "parser.tab.c"
    break;

  case 256: /* Literal: FloatingPointLiteral  */
#line 1324 "parser.y"
                                                             {(yyval.id) = (yyvsp[0].id);}
#line 4355 "parser.tab.c"
    break;

  case 257: /* Literal: BooleanLiteral  */
#line 1325 "parser.y"
                                                             {(yyval.id) = (yyvsp[0].id);}
#line 4361 "parser.tab.c"
    break;

  case 258: /* Literal: CharacterLiteral  */
#line 1326 "parser.y"
                                                             {(yyval.id) = (yyvsp[0].id);}
#line 4367 "parser.tab.c"
    break;

  case 259: /* Literal: StringLiteral  */
#line 1327 "parser.y"
                                                             {(yyval.id) = (yyvsp[0].id);}
#line 4373 "parser.tab.c"
    break;

  case 260: /* Literal: TextBlock  */
#line 1328 "parser.y"
                                                             {(yyval.id) = (yyvsp[0].id);}
#line 4379 "parser.tab.c"
    break;

  case 261: /* Literal: NullLiteral  */
#line 1329 "parser.y"
                                                             {(yyval.id) = (yyvsp[0].id);}
#line 4385 "parser.tab.c"
    break;

  case 262: /* ClassInstanceCreationExpression: NEW Name OPEN_BRACKETS ArgumentList2 CLOSE_BRACKETS  */
#line 1331 "parser.y"
                                                                                        {
                                    int uid = makenode("ClassInstanceCreationExpression");
                                    addChild(uid, (yyvsp[-4].id));
                                    addChild(uid, (yyvsp[-3].id));
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
}
#line 4399 "parser.tab.c"
    break;

  case 263: /* MethodInvocation: Name OPEN_BRACKETS ArgumentList2 CLOSE_BRACKETS  */
#line 1341 "parser.y"
                                                                               {
                                    int uid = makenode("MethodIncovation");
                                    addChild(uid, (yyvsp[-3].id));
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
}
#line 4412 "parser.tab.c"
    break;

  case 264: /* MethodInvocation: Primary DOT identifier OPEN_BRACKETS ArgumentList2 CLOSE_BRACKETS  */
#line 1349 "parser.y"
                                                                                                {
                                    int uid = makenode("MethodIncovation");
                                    addChild(uid, (yyvsp[-5].id));
                                    addChild(uid, (yyvsp[-4].id));
                                    addChild(uid, (yyvsp[-3].id));
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 4427 "parser.tab.c"
    break;

  case 265: /* MethodInvocation: SUPER DOT identifier OPEN_BRACKETS ArgumentList2 CLOSE_BRACKETS  */
#line 1359 "parser.y"
                                                                                                {
                                    int uid = makenode("MethodIncovation");
                                    addChild(uid, (yyvsp[-5].id));
                                    addChild(uid, (yyvsp[-4].id));
                                    addChild(uid, (yyvsp[-3].id));
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 4442 "parser.tab.c"
    break;

  case 266: /* ArgumentList2: %empty  */
#line 1370 "parser.y"
                          {(yyval.id) = -1;}
#line 4448 "parser.tab.c"
    break;

  case 267: /* ArgumentList2: ArgumentList  */
#line 1371 "parser.y"
                                                 {(yyval.id)=(yyvsp[0].id);}
#line 4454 "parser.tab.c"
    break;

  case 268: /* ArgumentList: Expression  */
#line 1373 "parser.y"
                                                 {(yyval.id) = (yyvsp[0].id);}
#line 4460 "parser.tab.c"
    break;

  case 269: /* ArgumentList: ArgumentList COMMA Expression  */
#line 1374 "parser.y"
                                                        {
                                                int uid = makenode("ArgumentList");
                                                addChild(uid, (yyvsp[-2].id));
                                                addChild(uid, (yyvsp[-1].id));
                                                addChild(uid, (yyvsp[0].id));
                                                (yyval.id) = uid;
                        }
#line 4472 "parser.tab.c"
    break;

  case 270: /* ReferenceType: Name  */
#line 1382 "parser.y"
                                                 {(yyval.id) = (yyvsp[0].id);}
#line 4478 "parser.tab.c"
    break;

  case 271: /* ReferenceType: ArrayType  */
#line 1383 "parser.y"
                                                {(yyval.id) = (yyvsp[0].id);}
#line 4484 "parser.tab.c"
    break;

  case 272: /* ArrayType: PrimitiveType OPEN_SQ CLOSE_SQ  */
#line 1385 "parser.y"
                                                            {
                                    int uid = makenode("ArrayType");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 4496 "parser.tab.c"
    break;

  case 273: /* ArrayType: Name OPEN_SQ CLOSE_SQ  */
#line 1392 "parser.y"
                                                            {
                                    int uid = makenode("ArrayType");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 4508 "parser.tab.c"
    break;

  case 274: /* ArrayType: ArrayType OPEN_SQ CLOSE_SQ  */
#line 1399 "parser.y"
                                                            {
                                    int uid = makenode("ArrayType");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 4520 "parser.tab.c"
    break;

  case 275: /* ArrayCreationExpression: NEW PrimitiveType DimExprs Dims2  */
#line 1407 "parser.y"
                                                           {
                                    int uid = makenode("ArrayCreationExpr");
                                    addChild(uid, (yyvsp[-3].id));
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
}
#line 4533 "parser.tab.c"
    break;

  case 276: /* ArrayCreationExpression: NEW Name DimExprs Dims2  */
#line 1415 "parser.y"
                                                        {
                                    int uid = makenode("ArrayCreationExpr");
                                    addChild(uid, (yyvsp[-3].id));
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 4546 "parser.tab.c"
    break;

  case 277: /* Dims2: %empty  */
#line 1424 "parser.y"
                           {(yyval.id) = -1;}
#line 4552 "parser.tab.c"
    break;

  case 278: /* Dims2: Dims  */
#line 1425 "parser.y"
                                                 {(yyval.id)=(yyvsp[0].id);}
#line 4558 "parser.tab.c"
    break;

  case 279: /* Dims: OPEN_SQ CLOSE_SQ  */
#line 1427 "parser.y"
                                                {int uid = makenode("Dims"); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id)=uid;}
#line 4564 "parser.tab.c"
    break;

  case 280: /* Dims: Dims OPEN_SQ CLOSE_SQ  */
#line 1428 "parser.y"
                                                  {
                                    int uid = makenode("Dims");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 4576 "parser.tab.c"
    break;

  case 281: /* DimExprs: DimExpr  */
#line 1435 "parser.y"
                                                 {(yyval.id) = (yyvsp[0].id);}
#line 4582 "parser.tab.c"
    break;

  case 282: /* DimExprs: DimExprs DimExpr  */
#line 1436 "parser.y"
                                                    {int uid = makenode("DimExprs"); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id)); (yyval.id)=uid;}
#line 4588 "parser.tab.c"
    break;

  case 283: /* DimExpr: OPEN_SQ Expression CLOSE_SQ  */
#line 1438 "parser.y"
                                                        {
                                    int uid = makenode("DimExpr");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
}
#line 4600 "parser.tab.c"
    break;

  case 284: /* InterfaceDeclaration: Modifiers1 INTERFACE identifier ExtendsInterfaces2 InterfaceBody  */
#line 1446 "parser.y"
                                                                                           {
                                    int uid = makenode("InterfaceDeclaration");
                                    addChild(uid, (yyvsp[-4].id));
                                    addChild(uid, (yyvsp[-3].id));
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
}
#line 4614 "parser.tab.c"
    break;

  case 285: /* ExtendsInterfaces2: %empty  */
#line 1456 "parser.y"
                            {(yyval.id) = -1;}
#line 4620 "parser.tab.c"
    break;

  case 286: /* ExtendsInterfaces2: ExtendsInterfaces  */
#line 1457 "parser.y"
                                            {(yyval.id) = (yyvsp[0].id);}
#line 4626 "parser.tab.c"
    break;

  case 287: /* ExtendsInterfaces: EXTENDS InterfaceType  */
#line 1459 "parser.y"
                                                { int uid = makenode("ExtendsInterfaces"); addChild(uid, (yyvsp[-1].id)); addChild(uid, (yyvsp[0].id));}
#line 4632 "parser.tab.c"
    break;

  case 288: /* ExtendsInterfaces: ExtendsInterfaces COMMA InterfaceType  */
#line 1460 "parser.y"
                                                                {
                                    int uid = makenode("ExtendsInterfaces");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 4644 "parser.tab.c"
    break;

  case 289: /* InterfaceBody: OPEN_CURLY InterfaceMemberDeclarations2 CLOSE_CURLY  */
#line 1467 "parser.y"
                                                                                {
                                    int uid = makenode("InterfaceBody");
                                    addChild(uid, (yyvsp[-2].id));
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
}
#line 4656 "parser.tab.c"
    break;

  case 290: /* InterfaceMemberDeclarations2: %empty  */
#line 1475 "parser.y"
                                    {(yyval.id) = -1;}
#line 4662 "parser.tab.c"
    break;

  case 291: /* InterfaceMemberDeclarations2: InterfaceMemberDeclarations  */
#line 1476 "parser.y"
                                                        {(yyval.id) = (yyvsp[0].id);}
#line 4668 "parser.tab.c"
    break;

  case 292: /* InterfaceMemberDeclarations: InterfaceMemberDeclaration  */
#line 1478 "parser.y"
                                                                {(yyval.id) = (yyvsp[0].id);}
#line 4674 "parser.tab.c"
    break;

  case 293: /* InterfaceMemberDeclarations: InterfaceMemberDeclarations InterfaceMemberDeclaration  */
#line 1479 "parser.y"
                                                                                    {
                                    int uid = makenode("InterfaceMemberDeclarations");
                                    addChild(uid, (yyvsp[-1].id));
                                    addChild(uid, (yyvsp[0].id));
                                    (yyval.id) = uid;
                        }
#line 4685 "parser.tab.c"
    break;

  case 294: /* InterfaceMemberDeclaration: ConstantDeclaration  */
#line 1486 "parser.y"
                                                            {(yyval.id) = (yyvsp[0].id);}
#line 4691 "parser.tab.c"
    break;

  case 295: /* InterfaceMemberDeclaration: AbstractMethodDeclaration  */
#line 1487 "parser.y"
                                                            {(yyval.id) = (yyvsp[0].id);}
#line 4697 "parser.tab.c"
    break;

  case 296: /* ConstantDeclaration: FieldDeclaration  */
#line 1489 "parser.y"
                                                            {(yyval.id) = (yyvsp[0].id);}
#line 4703 "parser.tab.c"
    break;

  case 297: /* AbstractMethodDeclaration: MethodHeader  */
#line 1491 "parser.y"
                                                            {(yyval.id) = (yyvsp[0].id);}
#line 4709 "parser.tab.c"
    break;

  case 298: /* AbstractMethodDeclaration: SEMICOL  */
#line 1492 "parser.y"
                                                            {(yyval.id) = (yyvsp[0].id);}
#line 4715 "parser.tab.c"
    break;

  case 299: /* InterfaceType: TypeName  */
#line 1494 "parser.y"
                                                            {(yyval.id) = (yyvsp[0].id);}
#line 4721 "parser.tab.c"
    break;

  case 300: /* identifier: identifierT  */
#line 1496 "parser.y"
                                                                                        {(yyval.id) = makenode((yyvsp[0].tit), "identifier");}
#line 4727 "parser.tab.c"
    break;

  case 301: /* IntegerLiteral: IntegerLiteralT  */
#line 1497 "parser.y"
                                                                                            {(yyval.id) = makenode((yyvsp[0].tit), "IntegerLiteral");}
#line 4733 "parser.tab.c"
    break;

  case 302: /* FloatingPointLiteral: FloatingPointLiteralT  */
#line 1498 "parser.y"
                                                                                                  {(yyval.id) = makenode((yyvsp[0].tit), "FloatingPointLiteral");}
#line 4739 "parser.tab.c"
    break;

  case 303: /* BooleanLiteral: BooleanLiteralT  */
#line 1499 "parser.y"
                                                                                            {(yyval.id) = makenode((yyvsp[0].tit), "BooleanLiteral");}
#line 4745 "parser.tab.c"
    break;

  case 304: /* CharacterLiteral: CharacterLiteralT  */
#line 1500 "parser.y"
                                                                                              {(yyval.id) = makenode((yyvsp[0].tit), "CharacterLiteral");}
#line 4751 "parser.tab.c"
    break;

  case 305: /* StringLiteral: StringLiteralT  */
#line 1501 "parser.y"
                                                                                           {(yyval.id) = makenode((yyvsp[0].tit), "StringLiteral");}
#line 4757 "parser.tab.c"
    break;

  case 306: /* NullLiteral: NullLiteralT  */
#line 1502 "parser.y"
                                                                                         {(yyval.id) = makenode((yyvsp[0].tit), "NullLiteral");}
#line 4763 "parser.tab.c"
    break;

  case 307: /* TextBlock: TextBlockT  */
#line 1503 "parser.y"
                                                                                       {(yyval.id) = makenode((yyvsp[0].tit), (yyvsp[0].tit));}
#line 4769 "parser.tab.c"
    break;

  case 308: /* NEW: NEWT  */
#line 1504 "parser.y"
                                                                                 {(yyval.id) = makenode((yyvsp[0].tit), (yyvsp[0].tit));}
#line 4775 "parser.tab.c"
    break;

  case 309: /* SYNCHRONIZED: SYNCHRONIZEDT  */
#line 1505 "parser.y"
                                                                                          {(yyval.id) = makenode((yyvsp[0].tit), "modifier");}
#line 4781 "parser.tab.c"
    break;

  case 310: /* RETURN: RETURNT  */
#line 1506 "parser.y"
                                                                                    {(yyval.id) = makenode((yyvsp[0].tit), (yyvsp[0].tit));}
#line 4787 "parser.tab.c"
    break;

  case 311: /* BREAK: BREAKT  */
#line 1507 "parser.y"
                                                                                   {(yyval.id) = makenode((yyvsp[0].tit), (yyvsp[0].tit));}
#line 4793 "parser.tab.c"
    break;

  case 312: /* CONTINUE: CONTINUET  */
#line 1508 "parser.y"
                                                                                      {(yyval.id) = makenode((yyvsp[0].tit), (yyvsp[0].tit));}
#line 4799 "parser.tab.c"
    break;

  case 313: /* IF: IFT  */
#line 1509 "parser.y"
                                                                                {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 4805 "parser.tab.c"
    break;

  case 314: /* ELSE: ELSET  */
#line 1510 "parser.y"
                                                                                  {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 4811 "parser.tab.c"
    break;

  case 315: /* FOR: FORT  */
#line 1511 "parser.y"
                                                                                 {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 4817 "parser.tab.c"
    break;

  case 316: /* WHILE: WHILET  */
#line 1512 "parser.y"
                                                                                   {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 4823 "parser.tab.c"
    break;

  case 317: /* CLASS: CLASST  */
#line 1513 "parser.y"
                                                                                   {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 4829 "parser.tab.c"
    break;

  case 318: /* INSTANCEOF: INSTANCEOFT  */
#line 1514 "parser.y"
                                                                                        {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 4835 "parser.tab.c"
    break;

  case 319: /* THIS: THIST  */
#line 1515 "parser.y"
                                                                                  {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 4841 "parser.tab.c"
    break;

  case 320: /* SUPER: SUPERT  */
#line 1516 "parser.y"
                                                                                   {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 4847 "parser.tab.c"
    break;

  case 321: /* ABSTRACT: ABSTRACTT  */
#line 1517 "parser.y"
                                                                                      {(yyval.id) = makenode((yyvsp[0].tit),"modifier"); }
#line 4853 "parser.tab.c"
    break;

  case 322: /* ASSERT: ASSERTT  */
#line 1518 "parser.y"
                                                                                    {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 4859 "parser.tab.c"
    break;

  case 323: /* BOOLEAN: BOOLEANT  */
#line 1519 "parser.y"
                                                                                     {(yyval.id) = makenode((yyvsp[0].tit),"type"); }
#line 4865 "parser.tab.c"
    break;

  case 324: /* BYTE: BYTET  */
#line 1520 "parser.y"
                                                                                  {(yyval.id) = makenode((yyvsp[0].tit),"type"); }
#line 4871 "parser.tab.c"
    break;

  case 325: /* SHORT: SHORTT  */
#line 1521 "parser.y"
                                                                                   {(yyval.id) = makenode((yyvsp[0].tit),"type"); }
#line 4877 "parser.tab.c"
    break;

  case 326: /* INT: INTT  */
#line 1522 "parser.y"
                                                                                 {(yyval.id) = makenode((yyvsp[0].tit),"type"); }
#line 4883 "parser.tab.c"
    break;

  case 327: /* LONG: LONGT  */
#line 1523 "parser.y"
                                                                                  {(yyval.id) = makenode((yyvsp[0].tit),"type"); }
#line 4889 "parser.tab.c"
    break;

  case 328: /* CHAR: CHART  */
#line 1524 "parser.y"
                                                                                  {(yyval.id) = makenode((yyvsp[0].tit),"type"); }
#line 4895 "parser.tab.c"
    break;

  case 329: /* STRING: STRINGT  */
#line 1525 "parser.y"
                                                                                    {(yyval.id) = makenode((yyvsp[0].tit),"type"); }
#line 4901 "parser.tab.c"
    break;

  case 330: /* FLOAT: FLOATT  */
#line 1526 "parser.y"
                                                                                   {(yyval.id) = makenode((yyvsp[0].tit),"type"); }
#line 4907 "parser.tab.c"
    break;

  case 331: /* DOUBLE: DOUBLET  */
#line 1527 "parser.y"
                                                                                    {(yyval.id) = makenode((yyvsp[0].tit),"type"); }
#line 4913 "parser.tab.c"
    break;

  case 332: /* EXTENDS: EXTENDST  */
#line 1528 "parser.y"
                                                                                     {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 4919 "parser.tab.c"
    break;

  case 333: /* PACKAGE: PACKAGET  */
#line 1529 "parser.y"
                                                                                     {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 4925 "parser.tab.c"
    break;

  case 334: /* IMPORT: IMPORTT  */
#line 1530 "parser.y"
                                                                                    {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 4931 "parser.tab.c"
    break;

  case 335: /* STATIC: STATICT  */
#line 1531 "parser.y"
                                                                                    {(yyval.id) = makenode((yyvsp[0].tit),"modifier"); }
#line 4937 "parser.tab.c"
    break;

  case 336: /* PROTECTED: PROTECTEDT  */
#line 1532 "parser.y"
                                                                                       {(yyval.id) = makenode((yyvsp[0].tit),"modifier"); }
#line 4943 "parser.tab.c"
    break;

  case 337: /* PRIVATE: PRIVATET  */
#line 1533 "parser.y"
                                                                                     {(yyval.id) = makenode((yyvsp[0].tit),"modifier"); }
#line 4949 "parser.tab.c"
    break;

  case 338: /* PUBLIC: PUBLICT  */
#line 1534 "parser.y"
                                                                                    {(yyval.id) = makenode((yyvsp[0].tit),"modifier"); }
#line 4955 "parser.tab.c"
    break;

  case 339: /* FINAL: FINALT  */
#line 1535 "parser.y"
                                                                                   {(yyval.id) = makenode((yyvsp[0].tit),"modifier"); }
#line 4961 "parser.tab.c"
    break;

  case 340: /* TRANSIENT: TRANSIENTT  */
#line 1536 "parser.y"
                                                                                       {(yyval.id) = makenode((yyvsp[0].tit),"modifier"); }
#line 4967 "parser.tab.c"
    break;

  case 341: /* VOLATILE: VOLATILET  */
#line 1537 "parser.y"
                                                                                      {(yyval.id) = makenode((yyvsp[0].tit),"modifier"); }
#line 4973 "parser.tab.c"
    break;

  case 342: /* IMPLEMENTS: IMPLEMENTST  */
#line 1538 "parser.y"
                                                                                        {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 4979 "parser.tab.c"
    break;

  case 343: /* VOID: VOIDT  */
#line 1539 "parser.y"
                                                                                  {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 4985 "parser.tab.c"
    break;

  case 344: /* INTERFACE: INTERFACET  */
#line 1540 "parser.y"
                                                                                       {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 4991 "parser.tab.c"
    break;

  case 345: /* NATIVE: NATIVET  */
#line 1541 "parser.y"
                                                                                    {(yyval.id) = makenode((yyvsp[0].tit),"modifier"); }
#line 4997 "parser.tab.c"
    break;

  case 346: /* OPEN_BRACKETS: OPEN_BRACKETST  */
#line 1542 "parser.y"
                                                                                           {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5003 "parser.tab.c"
    break;

  case 347: /* CLOSE_BRACKETS: CLOSE_BRACKETST  */
#line 1543 "parser.y"
                                                                                            {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5009 "parser.tab.c"
    break;

  case 348: /* OPEN_CURLY: OPEN_CURLYT  */
#line 1544 "parser.y"
                                                                                        {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5015 "parser.tab.c"
    break;

  case 349: /* CLOSE_CURLY: CLOSE_CURLYT  */
#line 1545 "parser.y"
                                                                                         {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5021 "parser.tab.c"
    break;

  case 350: /* OPEN_SQ: OPEN_SQT  */
#line 1546 "parser.y"
                                                                                     {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5027 "parser.tab.c"
    break;

  case 351: /* CLOSE_SQ: CLOSE_SQT  */
#line 1547 "parser.y"
                                                                                      {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5033 "parser.tab.c"
    break;

  case 352: /* SEMICOL: SEMICOLT  */
#line 1548 "parser.y"
                                                                                     {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5039 "parser.tab.c"
    break;

  case 353: /* COMMA: COMMAT  */
#line 1549 "parser.y"
                                                                                   {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5045 "parser.tab.c"
    break;

  case 354: /* DOT: DOTT  */
#line 1550 "parser.y"
                                                                                 {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5051 "parser.tab.c"
    break;

  case 355: /* EQUAL: EQUALT  */
#line 1551 "parser.y"
                                                                                   {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5057 "parser.tab.c"
    break;

  case 356: /* LESS: LESST  */
#line 1552 "parser.y"
                                                                                 {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5063 "parser.tab.c"
    break;

  case 357: /* GREATER: GREATERT  */
#line 1553 "parser.y"
                                                                                    {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5069 "parser.tab.c"
    break;

  case 358: /* EXCLAMATORY: EXCLAMATORYT  */
#line 1554 "parser.y"
                                                                                        {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5075 "parser.tab.c"
    break;

  case 359: /* TILDA: TILDAT  */
#line 1555 "parser.y"
                                                                                  {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5081 "parser.tab.c"
    break;

  case 360: /* QUE: QUET  */
#line 1556 "parser.y"
                                                                                {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5087 "parser.tab.c"
    break;

  case 361: /* COLON: COLONT  */
#line 1557 "parser.y"
                                                                                  {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5093 "parser.tab.c"
    break;

  case 362: /* DEQUAL: DEQUALT  */
#line 1558 "parser.y"
                                                                                   {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5099 "parser.tab.c"
    break;

  case 363: /* LE: LET  */
#line 1559 "parser.y"
                                                                               {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5105 "parser.tab.c"
    break;

  case 364: /* GE: GET  */
#line 1560 "parser.y"
                                                                               {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5111 "parser.tab.c"
    break;

  case 365: /* NEQUAL: NEQUALT  */
#line 1561 "parser.y"
                                                                                   {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5117 "parser.tab.c"
    break;

  case 366: /* DAND: DANDT  */
#line 1562 "parser.y"
                                                                                 {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5123 "parser.tab.c"
    break;

  case 367: /* DOR: DORT  */
#line 1563 "parser.y"
                                                                                {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5129 "parser.tab.c"
    break;

  case 368: /* DPLUS: DPLUST  */
#line 1564 "parser.y"
                                                                                  {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5135 "parser.tab.c"
    break;

  case 369: /* DMINUS: DMINUST  */
#line 1565 "parser.y"
                                                                                   {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5141 "parser.tab.c"
    break;

  case 370: /* PLUS: PLUST  */
#line 1566 "parser.y"
                                                                                 {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5147 "parser.tab.c"
    break;

  case 371: /* MINUS: MINUST  */
#line 1567 "parser.y"
                                                                                  {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5153 "parser.tab.c"
    break;

  case 372: /* MUL: MULT  */
#line 1568 "parser.y"
                                                                                {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5159 "parser.tab.c"
    break;

  case 373: /* DIVIDE: DIVIDET  */
#line 1569 "parser.y"
                                                                                   {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5165 "parser.tab.c"
    break;

  case 374: /* AND: ANDT  */
#line 1570 "parser.y"
                                                                                {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5171 "parser.tab.c"
    break;

  case 375: /* HAT: HATT  */
#line 1571 "parser.y"
                                                                                {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5177 "parser.tab.c"
    break;

  case 376: /* MODULO: MODULOT  */
#line 1572 "parser.y"
                                                                                   {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5183 "parser.tab.c"
    break;

  case 377: /* DLESS: DLESST  */
#line 1573 "parser.y"
                                                                                  {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5189 "parser.tab.c"
    break;

  case 378: /* DGREATER: DGREATERT  */
#line 1574 "parser.y"
                                                                                     {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5195 "parser.tab.c"
    break;

  case 379: /* TGREATER: TGREATERT  */
#line 1575 "parser.y"
                                                                                     {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5201 "parser.tab.c"
    break;

  case 380: /* PLUS_EQUAL: PLUS_EQUALT  */
#line 1576 "parser.y"
                                                                                       {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5207 "parser.tab.c"
    break;

  case 381: /* MINUS_EQUAL: MINUS_EQUALT  */
#line 1577 "parser.y"
                                                                                        {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5213 "parser.tab.c"
    break;

  case 382: /* MUL_EQUAL: MUL_EQUALT  */
#line 1578 "parser.y"
                                                                                      {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5219 "parser.tab.c"
    break;

  case 383: /* DIVIDE_EQUAL: DIVIDE_EQUALT  */
#line 1579 "parser.y"
                                                                                         {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5225 "parser.tab.c"
    break;

  case 384: /* AND_EQUAL: AND_EQUALT  */
#line 1580 "parser.y"
                                                                                      {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5231 "parser.tab.c"
    break;

  case 385: /* OR_EQUAL: OR_EQUALT  */
#line 1581 "parser.y"
                                                                                     {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5237 "parser.tab.c"
    break;

  case 386: /* HAT_EQUAL: HAT_EQUALT  */
#line 1582 "parser.y"
                                                                                      {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5243 "parser.tab.c"
    break;

  case 387: /* MODULO_EQUAL: MODULO_EQUALT  */
#line 1583 "parser.y"
                                                                                         {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5249 "parser.tab.c"
    break;

  case 388: /* DLESS_EQUAL: DLESS_EQUALT  */
#line 1584 "parser.y"
                                                                                        {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5255 "parser.tab.c"
    break;

  case 389: /* DGREATER_EQUAL: DGREATER_EQUALT  */
#line 1585 "parser.y"
                                                                                           {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5261 "parser.tab.c"
    break;

  case 390: /* TGREATER_EQUAL: TGREATER_EQUALT  */
#line 1586 "parser.y"
                                                                                           {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5267 "parser.tab.c"
    break;

  case 391: /* OR: ORT  */
#line 1587 "parser.y"
                                                                               {(yyval.id) = makenode((yyvsp[0].tit),(yyvsp[0].tit)); }
#line 5273 "parser.tab.c"
    break;

  case 392: /* STRICTFP: STRICTFPT  */
#line 1588 "parser.y"
                                                                                    {(yyval.id) = makenode((yyvsp[0].tit), "modifier");}
#line 5279 "parser.tab.c"
    break;


#line 5283 "parser.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", YY_CAST (yysymbol_kind_t, yyr1[yyn]), &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYSYMBOL_YYEMPTY : YYTRANSLATE (yychar);
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
      yyerror (YY_("syntax error"));
    }

  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;
  ++yynerrs;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  /* Pop stack until we find a state that shifts the error token.  */
  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYSYMBOL_YYerror;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYSYMBOL_YYerror)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  YY_ACCESSING_SYMBOL (yystate), yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", YY_ACCESSING_SYMBOL (yyn), yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturnlab;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturnlab;


/*-----------------------------------------------------------.
| yyexhaustedlab -- YYNOMEM (memory exhaustion) comes here.  |
`-----------------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  goto yyreturnlab;


/*----------------------------------------------------------.
| yyreturnlab -- parsing is finished, clean up and return.  |
`----------------------------------------------------------*/
yyreturnlab:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  YY_ACCESSING_SYMBOL (+*yyssp), yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif

  return yyresult;
}

#line 1589 "parser.y"
 


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
    for(auto it : table){
        printSymbolTable(it.first);
        cout << "***" << endl;
    }
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s %s at line %d\n", s, yylval, line);
	exit(1);
}
