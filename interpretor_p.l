%{
#include <stdlib.h>
#include "types.h"
#include "y.tab.h"
%}
%option caseless
%%
 
  /* variables */
[a-z]           {
                   yylval.sIndex = *yytext - 'a';
                   return VARIABLE;
                }

  /* integers */                 
[0-9]+          {
                   yylval.iValue = atoi(yytext);
                   return INTEGER;
                }

  /* operators */
  
  "="             return EQ;

">="            return GE;
"<="            return LE;
":="			return ASSIGN;
"<>"            return NE;

"begin"			return BEGINN;
"end"			return END; 
"do"			return DO;
"while"         return WHILE;
"repeat"		return REPEAT;
"until"			return UNTIL;
"for"			return FOR;
"to"			return TO;
"downto"		return DOWNTO;
"if"            return IF;
"then"			return THEN;
"else"          return ELSE;
"sqrt"			return SQRT;
"sqr"			return SQR;
"mod"			return MOD;
"div"			return DIV;
"inc"			return INC;
"dec"			return DEC;
"and"			return AND;
"or"			return OR;
"not"			return NOT;
"cmmmc"			return CMMMC;
"cmmdc"			return CMMDC;
"writeln"		return WRITELN;
"write"         return WRITE;

[-()<>=+/*;{}.,] return *yytext;

[ \t\n]+        ;      // Skip whitespaces.

%%

int yywrap(void)
{
    return 1;
}
