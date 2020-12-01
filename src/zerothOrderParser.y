%{
	//Seccion de definiciones :v
	#include<stdio.h>
	int isValid = 0;
%}
//Seccion de declaracion de tokens
%TOKEN ID 3
%TOKEN NOT 27
%TOKEN AND 28
%TOKEN OR 29
%TOKEN OR_EXCLUSIVE 30
%TOKEN IMPLICACION 31
%TOKEN DOBLE_IMPLICACION 32
%TOKEN PARENTESIS 10
%TOKEN SEPARADOR 11


%%
//Seccion de reglas
Bicondicional : Condicional DOBLE_IMPLICACION Bicondicional {}
	| Condicional {}

Condicional : Disyuncion IMPLICACION Condicional {}
	| Disyuncion {}

Disyuncion : Conjuncion OR Disyuncion {}
	| Conjuncion {}

Conjuncion : Literal AND Conjuncion {}
	| Literal {}

Literal : Atomo {}
	| NOT Atomo {}

Atomo : True {}
	| False {}
	| ID {}
	| Agrupacion {}

Agrupacion : (Bicondicional)
| [Bicondicional]
| {Bicondicional}
%%
//Seccion de funciones auxiliares
//driver code 
void main() 
{ 
  printf("\nIngrese cualquier expresion de la logica proposicional que contenga: negación (not), conjunción (and), disyunción (or), condicional (then), bicondicional (iff), valores de verdad (true / false), identificadores de variables con las letras pqrt seguidas por 5 o menos digitos. Tambien puede utilizar paréntesis cuadrados y redondos.\n"); 
  
  yyparse(); 
  if(isValid==0) 
  printf("\nLa expresion lógica ingresada es válida\n\n"); 
} 
  
void yyerror() 
{ 
  printf("\nLa expresión lógica ingresada es inválida\n\n"); 
  isValid=1; 
} 
