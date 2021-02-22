
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     INTEGER = 258,
     VARIABLE = 259,
     WHILE = 260,
     IF = 261,
     WRITELN = 262,
     WRITE = 263,
     THEN = 264,
     ELSE = 265,
     ASSIGN = 266,
     DO = 267,
     BEGINN = 268,
     END = 269,
     REPEAT = 270,
     UNTIL = 271,
     FOR = 272,
     TO = 273,
     DOWNTO = 274,
     SQRT = 275,
     SQR = 276,
     IFX = 277,
     NE = 278,
     EQ = 279,
     LE = 280,
     GE = 281,
     DIV = 282,
     MOD = 283,
     DEC = 284,
     INC = 285,
     CMMMC = 286,
     CMMDC = 287,
     NOT = 288,
     OR = 289,
     AND = 290,
     UMINUS = 291
   };
#endif
/* Tokens.  */
#define INTEGER 258
#define VARIABLE 259
#define WHILE 260
#define IF 261
#define WRITELN 262
#define WRITE 263
#define THEN 264
#define ELSE 265
#define ASSIGN 266
#define DO 267
#define BEGINN 268
#define END 269
#define REPEAT 270
#define UNTIL 271
#define FOR 272
#define TO 273
#define DOWNTO 274
#define SQRT 275
#define SQR 276
#define IFX 277
#define NE 278
#define EQ 279
#define LE 280
#define GE 281
#define DIV 282
#define MOD 283
#define DEC 284
#define INC 285
#define CMMMC 286
#define CMMDC 287
#define NOT 288
#define OR 289
#define AND 290
#define UMINUS 291




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 19 "interpretor_p.y"

  int iValue;      /* integer value */
  char sIndex;     /* symbol table index */
  nodeType *nPtr;  /* node pointer */



/* Line 1676 of yacc.c  */
#line 132 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


