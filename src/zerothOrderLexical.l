%{
#define ID 3
#define OPERADOR_LOG 8
#define PARENTESIS 10
#define SEPARADOR 11
#define PARENTESIS_CA 22
#define PARENTESIS_CC 23
#define PARENTESIS_A 24
#define PARENTESIS_C 25
#define COMA 26
#define NOT 27
#define AND 28
#define OR 29
#define OR_EXCLUSIVE 30
#define IMPLICACION 31
#define DOBLE_IMPLICACION 32
#define DOS_PUNTOS 33
#define DOS_PUNTOS_IGUAL 34
#define PUNTO_COMA 35


const char* token_to_string(int);
int find(char*);
int installID();
void initArray();
void operacionAritmetica();
void operacionRelacional();
void operacionLogica();
void operacionAsignacion();
void parentesis();
void separador();

int symbolTable_index = 0;
char* nombres[100000];
int yylval;
%}

%option noyywrap

/*Definiciones Regulares*/
ws [ \n\t]+
separador [,;]
parentesis \(|\)|\[|\]
digito [0-9]
digitosOpcional {digito}?{digito}?{digito}?{digito}?{digito}?
letraArit [pqrt]
conjuncion and | ^ | & 
disyuncion or | \|
negacion not | \~ | ! 
implicacion then | -> 
bicondiconal iff | <->
identificadorArit {letraArit}{digitosOpcional}
numero {digito}+


%%
{ws} {/*ASDASD NO HAGO NADA*/}
{identificadorArit} {yylval = installID(); fprintf(yyout,"%s es: %s\n", yytext,token_to_string(ID)); return(ID);}
{conjuncion} {return(AND);}
{disyuncion} {return(OR);}
{negacion} {return(NOT);}
{implicacion} {return(IMPLICACION);}
{bicondiconal} {return(DOBLE_IMPLICACION);}
{parentesis} {parentesis(); fprintf(yyout,"%s es: %s yylval = %d\n",yytext, token_to_string(PARENTESIS),yylval); return(PARENTESIS);}
{separador} {separador(); fprintf(yyout,"%s es: %s yylval = %d\n",yytext, token_to_string(SEPARADOR),yylval); return(SEPARADOR);}
%%


int main()
{
initArray();

extern FILE *yyin, *yyout; 
  
    yyin = fopen("input.txt", "r"); 
  
    yyout = fopen("Output.txt", "w"); 
  
	while(yylex());

	fprintf(yyout, "\nTABLA DE SIMBOLOS:\n");
	for(int i=0; i<symbolTable_index; i++){
		fprintf(yyout, "%d %s\n", i, nombres[i]);
	}

    return 0; 
}

int installID(){
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

const char* token_to_string(int n){
	else if(n==ID_ARIT) return "Identificador";
	else if(n==NUMERO) return "Numero";
	else if(n==OPERADOR_LOG) return "Operador Logico";
	else if(n==PARENTESIS) return "Parentesis";
	else  return "Separador";
}


void operacionLogica(){
	if(strcmp(yytext, "and")==0) yylval = AND;
	else if(strcmp(yytext, "or")==0) yylval = OR;
	else if(strcmp(yytext, "xor")==0) yylval = OR_EXCLUSIVE;
	else if(strcmp(yytext, "then")==0) yylval = IMPLICACION;
	else  yylval = DOBLE_IMPLICACION;
}

void parentesis(){
	if(strcmp(yytext, "(")==0) yylval = PARENTESIS_A;
	else if(strcmp(yytext, ")")==0) yylval = PARENTESIS_C;
	else if(strcmp(yytext, "[")==0) yylval = PARENTESIS_CA;
	else yylval = PARENTESIS_CC;
}

void separador(){
	if(strcmp(yytext, ",")==0) yylval = COMA;
	else  yylval = PUNTO_COMA;
}