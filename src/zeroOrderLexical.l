%{ 
/* Definition section */
#include<stdio.h> 
#include "zeroOrderParser.tab.h"
int find(char*);
void initArray();
int installID();
int symbolTable_index = 0;
extern char* nombres[100000];
extern double values[100000];
extern FILE *yyin, *yyout;
double values[100000];
char* nombres[100000];
int inicializado = 0;
%} 
ws [ \t]
digito [0-9]+
digitosOpcional {digito}?{digito}?{digito}?{digito}?{digito}?
natural {digito}+
real -?{natural}\.{natural}(E-?{natural})?
numero {natural}|{real}
letraArit [pqrt]
letraAlg [xyz]
identificadorAlg {letraAlg}{digitosOpcional}
identificadorArit {letraArit}{digitosOpcional}
menorIgual <=
mayorIgual >=
dosPuntosIgual :=
dosPuntos :
puntoComa ;
/* Rule Section */
%% 
{ws} ;
{numero} { 
          yylval.real=atof(yytext); 
          return NUMERO; 
       }
{identificadorAlg} {yylval.entero = installID(); return(ID_ALG);}
{identificadorArit} {yylval.entero = installID(); return(ID_ARIT);}
{dosPuntosIgual} {return(DOS_PUNTOS_IGUAL);}
{puntoComa} {return(PUNTO_COMA);} 
{dosPuntos} {return(DOS_PUNTOS);}
{menorIgual} {return(MENOR_IGUAL);}
{mayorIgual} {return(MAYOR_IGUAL);}
!= {return(DIFERENTE);}
true {return(VERDADERO);}
false {return(FALSO);}
not {return(NOT);}
and {return(AND);}
or {return(OR);}
then {return(IMPLICACION);}
iff {return(DOBLE_IMPLICACION);}

[\n] ; 
  
. return yytext[0]; 
  
%% 
  
int yywrap() 
{ 
 return 1; 
}

int installID(){
	if(!inicializado){
		initArray();
		inicializado = 1;	
	} 
	int f = find(yytext);
	if(f == -1){
		for(int i=0; i<yyleng; i++){
			nombres[symbolTable_index][i] = yytext[i];
		}
		return symbolTable_index++;
	} 
	return f;
}
void initArray(){
	for(int i=0; i<100000; i++){
		nombres[i] = malloc(6*sizeof(char));
	}
}

int find(char* id){
	for(int i=0;i<symbolTable_index;i++){
		if(strcmp(id, nombres[i])==0){
			return i;
		}
	}
	return -1;
}
