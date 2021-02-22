%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <math.h>
#include "types.h"
extern FILE * yyin;

nodeType *opr(int oper, int nops, ...);
nodeType *id(int i);
nodeType *con(int value);
int ex(nodeType *p) ;
void freeNode(nodeType *p);
void yyerror(char *s);int x=0;int y=0; int a=0;int b=0;
int sym[26]; //symbol table

%}

%union {
  int iValue;      /* integer value */
  char sIndex;     /* symbol table index */
  nodeType *nPtr;  /* node pointer */
};

%token <iValue> INTEGER 
%token <sIndex> VARIABLE
%token WHILE IF WRITELN WRITE THEN ELSE ASSIGN DO BEGINN END REPEAT UNTIL FOR TO DOWNTO SQRT SQR 
%nonassoc IFX
%nonassoc ELSE

%left GE LE EQ NE '>' '<'
%left CMMDC CMMMC INC DEC MOD DIV '+' '-'
%left '*' '/' 
%left AND OR NOT

%type <nPtr> statement expr stmt_list /*statement_for*/

%start      program

%%
	
program   : function '.'          { exit(0); }
          ;
		  
function  : function statement    { ex($2); freeNode($2); }
          | /* NULL */
          ;

statement : ';'                   		{	$$ = opr(';', 2, NULL, NULL); }
          | expr ';'              		{ $$ = $1; }
          | WRITE '(' expr ')' ';'      { $$ = opr(WRITE, 1, $3); }
		  | WRITELN '(' expr ')' ';'    { $$ = opr(WRITELN, 1, $3); }
          | VARIABLE ASSIGN expr ';' 	{ $$ = opr(ASSIGN, 2, id($1), $3); }
          | WHILE expr DO statement
										{ $$ = opr(WHILE, 2, $2, $4); }
		  | REPEAT statement UNTIL expr ';'
										{ $$ = opr(REPEAT, 2, $4, $2); }
		  /*| FOR statement_for TO expr DO statement*/
				/*{ $$ = opr(FOR+, 3,$2, $4, $6); }*/
          | IF expr THEN statement %prec IFX
										{ $$ = opr(IF, 2, $2, $4); }
          | IF expr THEN statement ELSE statement
										{ $$ = opr(IF, 3, $2, $4, $6); }
          | BEGINN stmt_list END ';' 	{ $$ = $2; }
          ;

stmt_list : statement
          | stmt_list statement   { $$ = opr(';', 2, $1, $2); }
          ;
/*statement_for	: { $$ = opr(ASSIGN, 2, id($1), $3); }*/	  	
	
expr      : INTEGER               { $$ = con($1); }
          | VARIABLE              { $$ = id($1); }
		  | NOT expr              {$$=opr(NOT,1,$2);}   
		  | expr AND expr         {$$=opr(AND,2,$1,$3);}
		  | expr OR expr		  {$$=opr(OR,2,$1,$3);}
          | '-' expr %prec UMINUS { $$ = opr(UMINUS, 1, $2); }
		  | CMMDC '(' expr ',' expr ')'   {$$ = opr(CMMDC,2,$3,$5);}
		  | CMMMC '(' expr ',' expr ')'	  {$$=opr('/',2,opr('*',2,$3,$5),opr(CMMDC,2,$3,$5));}
		  | INC '(' expr ',' expr ')' 	{ $$ = opr('+',2,$3,$5);}
		  | INC '(' expr ')' 	  { $$ = opr(INC,1,$3);}
		  | DEC '(' expr ',' expr ')' 	{ $$ = opr('-',2,$3,$5);}
		  | DEC '(' expr ')' 	  { $$ = opr(DEC,1,$3);}
		  | expr MOD expr		  { $$ = opr(MOD,2,$1,$3);}
		  | expr DIV expr		  { $$ = opr(DIV,2,$1,$3);}
          | expr '+' expr         { $$ = opr('+', 2, $1, $3); }
          | expr '-' expr         { $$ = opr('-', 2, $1, $3); }
          | expr '*' expr         { $$ = opr('*', 2, $1, $3); }
          | expr '/' expr         { $$ = opr('/', 2, $1, $3); }
          | expr '<' expr         { $$ = opr('<', 2, $1, $3); }
          | expr '>' expr         { $$ = opr('>', 2, $1, $3); }
          | expr GE expr          { $$ = opr(GE, 2, $1, $3); }
          | expr LE expr          { $$ = opr(LE, 2, $1, $3); }
          | expr NE expr          { $$ = opr(NE, 2, $1, $3); }
          | expr EQ expr          { $$ = opr(EQ, 2, $1, $3); }
		  | SQRT '(' expr ')'     { $$ = opr(SQRT, 1, $3); }
		  | SQR '(' expr ')'     { $$ = opr(SQR, 1, $3); }
          | '(' expr ')'          { $$ = $2; }
          ;
	
%%

nodeType *con(int value) 
{ 
  nodeType *p; 
  
  /* allocate node */ 
  if ((p = malloc(sizeof(conNodeType))) == NULL) 
    yyerror("out of memory"); 
  /* copy information */ 
  p->type = typeCon; 
  p->con.value = value; 
  return p; 
} 

nodeType *id(int i) 
{ 
  nodeType *p; 
  /* allocate node */ 
  if ((p = malloc(sizeof(idNodeType))) == NULL) 
    yyerror("out of memory"); 
  /* copy information */ 
  p->type = typeId; 
  p->id.i = i; 
  return p; 
} 

nodeType *opr(int oper, int nops, ...) 
{ 
  va_list ap; 
  nodeType *p; 
  size_t size; 
  int i; 

  /* allocate node */ 
  size = sizeof(oprNodeType) + (nops - 1) * sizeof(nodeType*); 
  if ((p = malloc(size)) == NULL) 
    yyerror("out of memory"); 
  /* copy information */
  p->type = typeOpr; 
  p->opr.oper = oper; 
  p->opr.nops = nops; 
  va_start(ap, nops); 
  for (i = 0; i < nops; i++) 
    p->opr.op[i] = va_arg(ap, nodeType*); 
  va_end(ap); 
  
  return p; 
}

void freeNode(nodeType *p) 
{ 
  int i; 

  if (!p) 
    return; 
  if (p->type == typeOpr) { 
    for (i = 0; i < p->opr.nops; i++) 
      freeNode(p->opr.op[i]); 
  } 
  free (p); 
} 

void yyerror(char *s) 
{ 
  fprintf(stdout, "%s\n", s); 
}

int ex(nodeType *p) 
{ 
	if (!p) 
		return 0; 
		
	switch(p->type) 
    { 
		case typeCon: return p->con.value; 
		case typeId: return sym[p->id.i]; 
		case typeOpr: switch(p->opr.oper) 
                    { 
		    case WHILE: while(ex(p->opr.op[0])) 
		                   ex(p->opr.op[1]); 
		                return 0;
			case REPEAT: do ex(p->opr.op[1]);
						while(!ex(p->opr.op[0]));
		                return 0;
			
		    case IF: if (ex(p->opr.op[0])) 
		                ex(p->opr.op[1]); 
		             else if (p->opr.nops > 2) 
			             ex(p->opr.op[2]); 
		             return 0; 
		    case WRITE: printf("%d", ex(p->opr.op[0])); 
		                return 0; 
			case WRITELN: printf("%d\n", ex(p->opr.op[0])); 
		                return 0;
		    case ';': ex(p->opr.op[0]); 
		              return ex(p->opr.op[1]); 
		    case ASSIGN:
						return sym[p->opr.op[0]->id.i] = ex(p->opr.op[1]); 
		    case UMINUS: return -ex(p->opr.op[0]);	
			case CMMDC: a=ex(p->opr.op[0]); b=ex(p->opr.op[1]);
						while(a!=b)
							if(a>b)
								a=a-b;
							else b=b-a;
						return a;
			case NOT: return (!(ex(p->opr.op[0])));
			case AND: return ex(p->opr.op[0]) && ex(p->opr.op[1]);
			case OR: return ex(p->opr.op[0]) || ex(p->opr.op[1]);			
			case INC: return ex(p->opr.op[0])+1;
			case DEC: return ex(p->opr.op[0])-1;
			case MOD: return ex(p->opr.op[0]) % ex(p->opr.op[1]);
			case DIV: return ex(p->opr.op[0]) / ex(p->opr.op[1]) - ex(p->opr.op[0]) % ex(p->opr.op[1]);
		    case '+': return ex(p->opr.op[0]) + ex(p->opr.op[1]); 
		    case '-': return ex(p->opr.op[0]) - ex(p->opr.op[1]); 
		    case '*': return ex(p->opr.op[0]) * ex(p->opr.op[1]); 
		    case '/': return ex(p->opr.op[0]) / ex(p->opr.op[1]); 
		    case '<': return ex(p->opr.op[0]) < ex(p->opr.op[1]); 
		    case '>': return ex(p->opr.op[0]) > ex(p->opr.op[1]); 
		    case GE: return ex(p->opr.op[0]) >= ex(p->opr.op[1]); 
		    case LE: return ex(p->opr.op[0]) <= ex(p->opr.op[1]); 
		    case NE: return ex(p->opr.op[0]) != ex(p->opr.op[1]); 
		    case EQ: return ex(p->opr.op[0]) == ex(p->opr.op[1]); 
			case SQRT: return sqrt(ex(p->opr.op[0]));
			case SQR: return ex(p->opr.op[0]) * ex(p->opr.op[0]);
			
		    } 
    } 
}

int main(void) 
{
FILE *f = fopen("test.txt", "r");
yyin = f;

  return(yyparse());
}
