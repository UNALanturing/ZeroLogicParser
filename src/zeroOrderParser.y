%{
//Codigo C
#include<stdio.h>
int flag = 0;
extern char* nombres[100000];
extern double values[100000];
extern FILE *yyin, *yyout;
%}
//Declaracion de Tokens
%union{
	double real;
	int entero;
}

%token <real> NUMERO
%token <entero> ID_ALG
%token <entero> ID_ARIT
%token <entero> DOS_PUNTOS_IGUAL
%token <entero> PUNTO_COMA
%token <entero> DOS_PUNTOS
%token <entero> MENOR_IGUAL
%token <entero> MAYOR_IGUAL
%token <entero> DIFERENTE
%token <entero> VERDADERO
%token <entero> FALSO
%token <entero> NOT
%token <entero> AND
%token <entero> OR
%token <entero> IMPLICACION
%token <entero> DOBLE_IMPLICACION 


%left DOBLE_IMPLICACION
%left IMPLICACION
%left OR
%left AND
%left NOT

%left '<' '>' MENOR_IGUAL MAYOR_IGUAL DIFERENTE '='

%left '+' '-'  
%left '*' '/'

%left '(' ')' '[' ']'
%%
//Reglas
Start : Instruccion
	  | Start Instruccion
	  ;

Instruccion : InstruccionPred
			| InstruccionAlg
			;

InstruccionAlg : ID_ALG DOS_PUNTOS_IGUAL ExpArit PUNTO_COMA {values[$<entero>1] = $<real>3; printf("%s := %f It's a valid arithmetic/algebraic expression \n",nombres[$<entero>1], values[$<entero>1]);}
			   ;

InstruccionPred : ID_ARIT DOS_PUNTOS ExpLog PUNTO_COMA {values[$<entero>1] = $<real>3; printf("%s : %f It's a valid logical expression\n",nombres[$<entero>1], values[$<entero>1]);}
				;

ExpLog  : NOT ExpLog {$<real>$ = !$<real>2;}
		| ExpLog AND ExpLog {$<real>$ = $<real>1 && $<real>3;}
		| ExpLog OR ExpLog {$<real>$ = $<real>1 || $<real>3;}
		| ExpLog IMPLICACION ExpLog {$<real>$ = !$<real>1 || $<real>3;}
		| ExpLog DOBLE_IMPLICACION ExpLog {$<real>$ = (!$<real>1 || $<real>3) && (!$<real>3 || $<real>1);}
		| '(' ExpLog ')' {$<real>$ = $<real>2;}
		| '[' ExpLog ']' {$<real>$ = $<real>2;}
		| ID_ARIT {$<real>$ = values[$<entero>1];}
		| VERDADERO {$<real>$ = 1;}
		| FALSO {$<real>$ = 0;}
		| ExpRel {$<real>$ = $<real>1;}
		;

ExpRel : ExpArit '>' ExpArit {$<real>$ = $<real>1 > $<real>3;}
	   | ExpArit '<' ExpArit {$<real>$ = $<real>1 < $<real>3;}
	   | ExpArit MENOR_IGUAL ExpArit {$<real>$ = $<real>1 <= $<real>3;}
	   | ExpArit MAYOR_IGUAL ExpArit {$<real>$ = $<real>1 >= $<real>3;}
	   | ExpArit '=' ExpArit {$<real>$ = $<real>1 == $<real>3;}
	   | ExpArit DIFERENTE ExpArit {$<real>$ = $<real>1 != $<real>3;}
	   ;

ExpArit : ExpArit '+' ExpArit {$<real>$=$<real>1+$<real>3;} 
 		| ExpArit '-' ExpArit {$<real>$=$<real>1-$<real>3;} 
 		| ExpArit '*' ExpArit {$<real>$=$<real>1*$<real>3;} 
 		| ExpArit '/' ExpArit {$<real>$=$<real>1/$<real>3;} 
 		| '(' ExpArit ')' {$<real>$=$<real>2;}
 		| '[' ExpArit ']' {$<real>$=$<real>2;}
 		| ID_ALG {$<real>$=values[$<entero>1];} 
 		| NUMERO {$<real>$=$<real>1;} 
 		;


%%
//Funciones auxiliares
void main() 
{
	initArray();
	//yyin = fopen("input.txt", "r"); 
	printf("\nEnter Any Expression\n"); 
	while(yyparse());
	/*
	
	yyparse(); 
	if(flag==0) 
	printf("\nEntered expression is Valid\n\n");
	*/ 
} 
  
void yyerror() 
{ 
   printf("\nEntered expression is Invalid\n\n"); 
   flag=1; 
} 
