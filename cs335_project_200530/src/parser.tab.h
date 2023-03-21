/* A Bison parser, made by GNU Bison 3.8.  */

/* Bison interface for Yacc-like parsers in C

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

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    keywordT = 258,                /* keywordT  */
    newlineT = 259,                /* newlineT  */
    identifierT = 260,             /* identifierT  */
    IntegerLiteralT = 261,         /* IntegerLiteralT  */
    FloatingPointLiteralT = 262,   /* FloatingPointLiteralT  */
    BooleanLiteralT = 263,         /* BooleanLiteralT  */
    CharacterLiteralT = 264,       /* CharacterLiteralT  */
    StringLiteralT = 265,          /* StringLiteralT  */
    NullLiteralT = 266,            /* NullLiteralT  */
    TextBlockT = 267,              /* TextBlockT  */
    NEWT = 268,                    /* NEWT  */
    TRYT = 269,                    /* TRYT  */
    CATCHT = 270,                  /* CATCHT  */
    SYNCHRONIZEDT = 271,           /* SYNCHRONIZEDT  */
    FINALLYT = 272,                /* FINALLYT  */
    THROWT = 273,                  /* THROWT  */
    THROWST = 274,                 /* THROWST  */
    RETURNT = 275,                 /* RETURNT  */
    BREAKT = 276,                  /* BREAKT  */
    CONTINUET = 277,               /* CONTINUET  */
    IFT = 278,                     /* IFT  */
    ELSET = 279,                   /* ELSET  */
    SWITCHT = 280,                 /* SWITCHT  */
    CASET = 281,                   /* CASET  */
    FORT = 282,                    /* FORT  */
    WHILET = 283,                  /* WHILET  */
    DOTT = 284,                    /* DOTT  */
    CLASST = 285,                  /* CLASST  */
    INSTANCEOFT = 286,             /* INSTANCEOFT  */
    THIST = 287,                   /* THIST  */
    SUPERT = 288,                  /* SUPERT  */
    ABSTRACTT = 289,               /* ABSTRACTT  */
    ASSERTT = 290,                 /* ASSERTT  */
    BOOLEANT = 291,                /* BOOLEANT  */
    BYTET = 292,                   /* BYTET  */
    SHORTT = 293,                  /* SHORTT  */
    INTT = 294,                    /* INTT  */
    LONGT = 295,                   /* LONGT  */
    CHART = 296,                   /* CHART  */
    STRINGT = 297,                 /* STRINGT  */
    FLOATT = 298,                  /* FLOATT  */
    DOUBLET = 299,                 /* DOUBLET  */
    EXTENDST = 300,                /* EXTENDST  */
    PACKAGET = 301,                /* PACKAGET  */
    IMPORTT = 302,                 /* IMPORTT  */
    STATICT = 303,                 /* STATICT  */
    MODULET = 304,                 /* MODULET  */
    REQUIREST = 305,               /* REQUIREST  */
    EXPORTST = 306,                /* EXPORTST  */
    OPENST = 307,                  /* OPENST  */
    OPENT = 308,                   /* OPENT  */
    USEST = 309,                   /* USEST  */
    PROVIDEST = 310,               /* PROVIDEST  */
    WITHT = 311,                   /* WITHT  */
    TRANSITIVET = 312,             /* TRANSITIVET  */
    PROTECTEDT = 313,              /* PROTECTEDT  */
    PRIVATET = 314,                /* PRIVATET  */
    PUBLICT = 315,                 /* PUBLICT  */
    FINALT = 316,                  /* FINALT  */
    SEALEDT = 317,                 /* SEALEDT  */
    NONSEALEDT = 318,              /* NONSEALEDT  */
    TRANSIENTT = 319,              /* TRANSIENTT  */
    VOLATILET = 320,               /* VOLATILET  */
    STRICTFPT = 321,               /* STRICTFPT  */
    IMPLEMENTST = 322,             /* IMPLEMENTST  */
    PERMITST = 323,                /* PERMITST  */
    VOIDT = 324,                   /* VOIDT  */
    ENUMT = 325,                   /* ENUMT  */
    DEFAULTT = 326,                /* DEFAULTT  */
    VART = 327,                    /* VART  */
    TOT = 328,                     /* TOT  */
    YIELDT = 329,                  /* YIELDT  */
    INTERFACET = 330,              /* INTERFACET  */
    RECORDT = 331,                 /* RECORDT  */
    NATIVET = 332,                 /* NATIVET  */
    OPEN_BRACKETST = 333,          /* OPEN_BRACKETST  */
    CLOSE_BRACKETST = 334,         /* CLOSE_BRACKETST  */
    OPEN_CURLYT = 335,             /* OPEN_CURLYT  */
    CLOSE_CURLYT = 336,            /* CLOSE_CURLYT  */
    OPEN_SQT = 337,                /* OPEN_SQT  */
    CLOSE_SQT = 338,               /* CLOSE_SQT  */
    SEMICOLT = 339,                /* SEMICOLT  */
    COMMAT = 340,                  /* COMMAT  */
    DOOT = 341,                    /* DOOT  */
    TDOTT = 342,                   /* TDOTT  */
    ATRT = 343,                    /* ATRT  */
    DCOLT = 344,                   /* DCOLT  */
    EQUALT = 345,                  /* EQUALT  */
    LESST = 346,                   /* LESST  */
    GREATERT = 347,                /* GREATERT  */
    EXCLAMATORYT = 348,            /* EXCLAMATORYT  */
    TILDAT = 349,                  /* TILDAT  */
    QUET = 350,                    /* QUET  */
    COLONT = 351,                  /* COLONT  */
    IMPLIEST = 352,                /* IMPLIEST  */
    DEQUALT = 353,                 /* DEQUALT  */
    LET = 354,                     /* LET  */
    NEQUALT = 355,                 /* NEQUALT  */
    DANDT = 356,                   /* DANDT  */
    DORT = 357,                    /* DORT  */
    DPLUST = 358,                  /* DPLUST  */
    DMINUST = 359,                 /* DMINUST  */
    GET = 360,                     /* GET  */
    PLUST = 361,                   /* PLUST  */
    MINUST = 362,                  /* MINUST  */
    MULT = 363,                    /* MULT  */
    DIVIDET = 364,                 /* DIVIDET  */
    ANDT = 365,                    /* ANDT  */
    HATT = 366,                    /* HATT  */
    MODULOT = 367,                 /* MODULOT  */
    DLESST = 368,                  /* DLESST  */
    DGREATERT = 369,               /* DGREATERT  */
    TGREATERT = 370,               /* TGREATERT  */
    PLUS_EQUALT = 371,             /* PLUS_EQUALT  */
    MINUS_EQUALT = 372,            /* MINUS_EQUALT  */
    MUL_EQUALT = 373,              /* MUL_EQUALT  */
    DIVIDE_EQUALT = 374,           /* DIVIDE_EQUALT  */
    AND_EQUALT = 375,              /* AND_EQUALT  */
    OR_EQUALT = 376,               /* OR_EQUALT  */
    HAT_EQUALT = 377,              /* HAT_EQUALT  */
    MODULO_EQUALT = 378,           /* MODULO_EQUALT  */
    DLESS_EQUALT = 379,            /* DLESS_EQUALT  */
    DGREATER_EQUALT = 380,         /* DGREATER_EQUALT  */
    TGREATER_EQUALT = 381,         /* TGREATER_EQUALT  */
    ORT = 382,                     /* ORT  */
    LGT = 383                      /* LGT  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 495 "parser.y"

    char* tit;
    struct ast* a;
    int id;
    

#line 199 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
