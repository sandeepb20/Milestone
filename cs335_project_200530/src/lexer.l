%option yylineno

%{
#include <bits/stdc++.h>
using namespace std;
#include "parser.tab.h"
extern YYSTYPE yylval;
extern int line;
int yylex();
%}

InputCharacter    [^\n\r]

Keyword           {ReservedKeyword}|{ContextualKeyword}

ReservedKeyword   abstract|continue|for|new|switch|assert|default|if|package|synchronized|boolean|do|goto|private|this|break|double|implements|protected|throw|byte|else|import|public|throws|case|enum|instanceof|return|transient|catch|extends|int|short|try|String|char|final|interface|static|void|class|finally|long|strictfp|volatile|const|float|native|super|while|_

ContextualKeyword exports|opens|requires|uses|module|permit|sealed|var|non-sealed|provides|to|with|open|record|transitive|yield

Literal               {IntegerLiteral}|{FloatingPointLiteral}|{BooleanLiteral}|{CharacterLiteral}|{StringLiteral}|{TextBlock}|{NullLiteral}

IntegerLiteral        {DecimalIntegerLiteral}|{HexIntegerLiteral}|{OctalIntegerLiteral}|{BinaryIntegerLiteral}
DecimalIntegerLiteral {DecimalNumeral}{IntegerTypeSuffix}?
HexIntegerLiteral     {HexNumeral}{IntegerTypeSuffix}?
OctalIntegerLiteral   {OctalNumeral}{IntegerTypeSuffix}?
BinaryIntegerLiteral  {BinaryNumeral}{IntegerTypeSuffix}?
IntegerTypeSuffix     [lL]

DecimalNumeral        0|{NonZeroDigit}{Digits}?|{NonZeroDigit}{Underscores}{Digits}
NonZeroDigit          [1-9]
Digits                {Digit}|{Digit}{DigitsAndUnderscores}?{Digit}
Digit                 [0]|{NonZeroDigit}
DigitsAndUnderscores  {DigitOrUnderscore}{DigitOrUnderscore}*
DigitOrUnderscore     {Digit}|_
Underscores           _*

HexNumeral                [0][x]{HexDigits}|[0][X]{HexDigits}
HexDigits                 {HexDigit}|{HexDigit}{HexDigitsAndUnderscores}?{HexDigit}
HexDigit                  [0-9a-fA-F]
HexDigitsAndUnderscores   {HexDigitOrUnderscore}{HexDigitOrUnderscore}*
HexDigitOrUnderscore      {HexDigit}|[_]

OctalNumeral              [0]{OctalDigits}|[0]{Underscores}{OctalDigits}
OctalDigits               {OctalDigit}|{OctalDigit}{OctalDigitsAndUnderscores}?{OctalDigit}
OctalDigit                [0-7]
OctalDigitsAndUnderscores {OctalDigitOrUnderscore}{OctalDigitOrUnderscore}*
OctalDigitOrUnderscore    {OctalDigit}|[_]

BinaryNumeral               [0][b]{BinaryDigits}|[0][B]{BinaryDigits}
BinaryDigits                {BinaryDigit}|{BinaryDigit}{BinaryDigitsAndUnderscores}?{BinaryDigit}
BinaryDigit                 [0-1]
BinaryDigitsAndUnderscores  {BinaryDigitOrUnderscore}{BinaryDigitOrUnderscore}*
BinaryDigitOrUnderscore     {BinaryDigit}|[_]

FloatingPointLiteral        {DecimalFloatingPointLiteral}|{HexadecimalFloatingPointLiteral}
DecimalFloatingPointLiteral {Digits}"."{Digits}?{ExponentPart}?{FloatTypeSuffix}?|"."{Digits}{ExponentPart}?{FloatTypeSuffix}?|{Digits}{ExponentPart}{FloatTypeSuffix}?|{Digits}{ExponentPart}?{FloatTypeSuffix}
ExponentPart                {ExponentIndicator}{SignedInteger}
ExponentIndicator           [eE]
SignedInteger               {Sign}?{Digits}
Sign                        "+"|"-"
FloatTypeSuffix             [fFdD]

HexadecimalFloatingPointLiteral {HexSignificand}{BinaryExponent}{FloatTypeSuffix}?
HexSignificand                  {HexNumeral}[.]?|[0][x]{HexDigits}?[.]{HexDigits}|[0][X]{HexDigits}?[.]{HexDigits}
BinaryExponent                  {BinaryExponentIndicator}{SignedInteger}
BinaryExponentIndicator         [pP]

BooleanLiteral      true|false

CharacterLiteral    '{SingleCharacter}'
SingleCharacter     [^\n\r\'\\]

StringLiteral       \"{StringCharacter}*\"
StringCharacter     [^\n\r\"\\]

TextBlock           ["]["]["]([^"]|["]([^"]|["][^"]))*["]["]["]

WhiteSpace          [ \t\f]|{LineTerminator}
LineTerminator      \n|\r|\r\n

NullLiteral         null
%%


"("                           {yylval.tit = yytext; line=yylineno; return OPEN_BRACKETST;}
")"                           {yylval.tit = yytext; line=yylineno; return CLOSE_BRACKETST;}
"{"                           {yylval.tit = yytext; line=yylineno; return OPEN_CURLYT;}
"}"                           {yylval.tit = yytext; line=yylineno; return CLOSE_CURLYT;}
"["                           {yylval.tit = yytext; line=yylineno; return OPEN_SQT;}
"]"                           {yylval.tit = yytext; line=yylineno; return CLOSE_SQT;}
";"                           {yylval.tit = yytext; line=yylineno; return SEMICOLT;}
","                           {yylval.tit = yytext; line=yylineno; return COMMAT;}
"."                           {yylval.tit = yytext; line=yylineno; return DOTT;}
"..."                         {yylval.tit = yytext; line=yylineno; return TDOTT;}
"@"                           {yylval.tit = yytext; line=yylineno; return ATRT;}
"::"                          {yylval.tit = yytext; line=yylineno; return DCOLT;}



"="                           {yylval.tit = yytext; line=yylineno; return EQUALT;}
"<"                           {yylval.tit = yytext; line=yylineno; return LESST;}
">"                           {yylval.tit = yytext; line=yylineno; return GREATERT;}
"!"                           {yylval.tit = yytext; line=yylineno; return EXCLAMATORYT;}
"~"                           {yylval.tit = yytext; line=yylineno; return TILDAT;}
"?"                           {yylval.tit = yytext; line=yylineno; return QUET;}
":"                           {yylval.tit = yytext; line=yylineno; return COLONT;}
"->"                          {yylval.tit = yytext; line=yylineno; return IMPLIEST;}
"=="                          {yylval.tit = yytext; line=yylineno; return DEQUALT;}                                
">="                          {yylval.tit = yytext; line=yylineno; return GET;}                                
"<="                          {yylval.tit = yytext; line=yylineno; return LET;}                                
"!="                          {yylval.tit = yytext; line=yylineno; return NEQUALT;}                                
"&&"                          {yylval.tit = yytext; line=yylineno; return DANDT;}                                
"||"                          {yylval.tit = yytext; line=yylineno; return DORT;}                                
"++"                          {yylval.tit = yytext; line=yylineno; return DPLUST;}                                
"--"                          {yylval.tit = yytext; line=yylineno; return DMINUST;}                                
"+"                           {yylval.tit = yytext; line=yylineno; return PLUST;}                          
"-"                           {yylval.tit = yytext; line=yylineno; return MINUST;}                          
"*"                           {yylval.tit = yytext; line=yylineno; return MULT;}                          
"/"                           {yylval.tit = yytext; line=yylineno; return DIVIDET;}                          
"&"                           {yylval.tit = yytext; line=yylineno; return ANDT;}                          
"^"                           {yylval.tit = yytext; line=yylineno; return HATT;}                          
"%"                           {yylval.tit = yytext; line=yylineno; return MODULOT;}                          
"<<"                          {yylval.tit = yytext; line=yylineno; return DLESST;}
">>"                          {yylval.tit = yytext; line=yylineno; return DGREATERT;}
">>>"                         {yylval.tit = yytext; line=yylineno; return TGREATERT;}
"+="                          {yylval.tit = yytext; line=yylineno; return PLUS_EQUALT;}
"-="                          {yylval.tit = yytext; line=yylineno; return MINUS_EQUALT;}
"*="                          {yylval.tit = yytext; line=yylineno; return MUL_EQUALT;}
"/="                          {yylval.tit = yytext; line=yylineno; return DIVIDE_EQUALT;}
"&="                          {yylval.tit = yytext; line=yylineno; return AND_EQUALT;}
"|="                          {yylval.tit = yytext; line=yylineno; return OR_EQUALT;}
"^="                          {yylval.tit = yytext; line=yylineno; return HAT_EQUALT;}
"%="                          {yylval.tit = yytext; line=yylineno; return MODULO_EQUALT;}
"<<="                         {yylval.tit = yytext; line=yylineno; return DLESS_EQUALT;}
">>="                         {yylval.tit = yytext; line=yylineno; return DGREATER_EQUALT;}
">>>="                        {yylval.tit = yytext; line=yylineno; return TGREATER_EQUALT;}
"|"                           {yylval.tit = yytext; line=yylineno; return ORT;}
"<>"                          {yylval.tit = yytext; line=yylineno; return LGT;}

"new"                         {yylval.tit = yytext; line=yylineno; return NEWT;}
"try"                         {yylval.tit = yytext; line=yylineno; return TRYT;}
"catch"                       {yylval.tit = yytext; line=yylineno; return CATCHT;}
"synchronized"                {yylval.tit = yytext; line=yylineno; return SYNCHRONIZEDT;}
"finally"                     {yylval.tit = yytext; line=yylineno; return FINALLYT;}
"throw"                       {yylval.tit = yytext; line=yylineno; return THROWT;}
"throws"                      {yylval.tit = yytext; line=yylineno; return THROWST;}
"return"                      {yylval.tit = yytext; line=yylineno; return RETURNT;}
"break"                       {yylval.tit = yytext; line=yylineno; return BREAKT;}
"continue"                    {yylval.tit = yytext; line=yylineno; return CONTINUET;}
"if"                          {yylval.tit = yytext; line=yylineno; return IFT;}
"else"                        {yylval.tit = yytext; line=yylineno; return ELSET;}
"switch"                      {yylval.tit = yytext; line=yylineno; return SWITCHT;}
"case"                        {yylval.tit = yytext; line=yylineno; return CASET;}
"default"                     {yylval.tit = yytext; line=yylineno; return DEFAULTT;}
"for"                         {yylval.tit = yytext; line=yylineno; return FORT;}
"while"                       {yylval.tit = yytext; line=yylineno; return WHILET;}
"do"                          {yylval.tit = yytext; line=yylineno; return DOOT;}
"instanceof"                  {yylval.tit = yytext; line=yylineno; return INSTANCEOFT;}
"this"                        {yylval.tit = yytext; line=yylineno; return THIST;}
"super"                       {yylval.tit = yytext; line=yylineno; return SUPERT;}
"abstract"                    {yylval.tit = yytext; line=yylineno; return ABSTRACTT;}
"assert"                      {yylval.tit = yytext; line=yylineno; return ASSERTT;}
"boolean"                     {yylval.tit = yytext; line=yylineno; return BOOLEANT;}
"byte"                        {yylval.tit = yytext; line=yylineno; return BYTET;}
"class"                       {yylval.tit = yytext; line=yylineno; return CLASST;}
"short"                       {yylval.tit = yytext; line=yylineno; return SHORTT;}
"int"                         {yylval.tit = yytext; line=yylineno; return INTT;}
"long"                        {yylval.tit = yytext; line=yylineno; return LONGT;}
"char"                        {yylval.tit = yytext; line=yylineno; return CHART;}
"String"                      {yylval.tit = yytext; line=yylineno; return STRINGT;}
"float"                       {yylval.tit = yytext; line=yylineno; return FLOATT;}
"double"                      {yylval.tit = yytext; line=yylineno; return DOUBLET;}
"extends"                     {yylval.tit = yytext; line=yylineno; return EXTENDST;}
"package"                     {yylval.tit = yytext; line=yylineno; return PACKAGET;}
"import"                      {yylval.tit = yytext; line=yylineno; return IMPORTT;}
"static"                      {yylval.tit = yytext; line=yylineno; return STATICT;}
"module"                      {yylval.tit = yytext; line=yylineno; return MODULET;}
"requires"                    {yylval.tit = yytext; line=yylineno; return REQUIREST;}
"exports"                     {yylval.tit = yytext; line=yylineno; return EXPORTST;}
"opens"                       {yylval.tit = yytext; line=yylineno; return OPENST;}
"open"                        {yylval.tit = yytext; line=yylineno; return OPENT;}
"uses"                        {yylval.tit = yytext; line=yylineno; return USEST;}
"provides"                    {yylval.tit = yytext; line=yylineno; return PROVIDEST;}
"with"                        {yylval.tit = yytext; line=yylineno; return WITHT;}
"transitive"                  {yylval.tit = yytext; line=yylineno; return TRANSITIVET;}
"protected"                   {yylval.tit = yytext; line=yylineno; return PROTECTEDT;}
"private"                     {yylval.tit = yytext; line=yylineno; return PRIVATET;}
"public"                      {yylval.tit = yytext; line=yylineno; return PUBLICT;}
"final"                       {yylval.tit = yytext; line=yylineno; return FINALT;}
"sealed"                      {yylval.tit = yytext; line=yylineno; return SEALEDT;}
"non-sealed"                  {yylval.tit = yytext; line=yylineno; return NONSEALEDT;}
"transient"                   {yylval.tit = yytext; line=yylineno; return TRANSIENTT;}
"volatile"                    {yylval.tit = yytext; line=yylineno; return VOLATILET;}
"strictfp"                    {yylval.tit = yytext; line=yylineno; return STRICTFPT;}
"implements"                  {yylval.tit = yytext; line=yylineno; return IMPLEMENTST;}
"permits"                     {yylval.tit = yytext; line=yylineno; return PERMITST;}
"void"                        {yylval.tit = yytext; line=yylineno; return VOIDT;}
"enum"                        {yylval.tit = yytext; line=yylineno; return ENUMT;}
"var"                         {yylval.tit = yytext; line=yylineno; return VART;}
"to"                          {yylval.tit = yytext; line=yylineno; return TOT;}
"yield"                       {yylval.tit = yytext; line=yylineno; return YIELDT;}
"interface"                   {yylval.tit = yytext; line=yylineno; return INTERFACET;}
"record"                      {yylval.tit = yytext; line=yylineno; return RECORDT;}
"native"                      {yylval.tit = yytext; line=yylineno; return NATIVET;}
{Keyword}                     {yylval.tit = yytext; line=yylineno; return keywordT;}
{LineTerminator}              /*skip*/
{WhiteSpace}                  /* Skip WhiteSpace */
[/][*]([^*]|[*][*]*[^*/])*[*][*]*[/]|("//"[^\n\r]*)  /* Skip Comment */
{IntegerLiteral}             {yylval.tit = yytext; line=yylineno; return IntegerLiteralT;}
{FloatingPointLiteral}       {yylval.tit = yytext; line=yylineno; return FloatingPointLiteralT;}
{BooleanLiteral}             {yylval.tit = yytext; line=yylineno; return BooleanLiteralT;}
{CharacterLiteral}           {yylval.tit = yytext; line=yylineno; return CharacterLiteralT;}
{StringLiteral}              {yylval.tit = yytext; line=yylineno; return StringLiteralT;}
{NullLiteral}                {yylval.tit = yytext; line=yylineno; return NullLiteralT;}
{TextBlock}                  {yylval.tit = yytext; line=yylineno; return TextBlockT;}
[A-Za-z_][A-Za-z0-9_]*       {yylval.tit = yytext; line=yylineno; return identifierT; }

.                             {  }

%%

int yywrap (void) {return 1;}