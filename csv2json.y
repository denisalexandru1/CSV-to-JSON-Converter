//Convertor din CSV in JSON
//Inputul va fi un fisier CSV
//Outputul va fi un fisier JSON
//Totul se va face cu compila si rula cu ajutorul unui Makefile
//Fisierul CSV va fi de forma:
//a, b, c, d
//1, 2, 3, 4
//5, 6, 7, 8
//11, 23, 4, 6
//12, 54, 66, 11

//iar fisierul JSON va fi de forma:
/* 
[
  {
    "a": 1,
    "b": 2,
    "c": 3,
    "d": 4
  },
  {
    "a": 5,
    "b": 6,
    "c": 7,
    "d": 8
  },
  {
    "a": 11,
    "b": 23,
    "c": 4,
    "d": 6
  },
  {
    "a": 12,
    "b": 54,
    "c": 66,
    "d": 11
  }
] */
//formatul acesta a fost luat de pe https://www.csvjson.com/csv2json

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
char* headerValues[100]; //in acest vector vom retine headerul pentru a putea face legatura dintre coloane si valori
int counter = 0; //in acest contor vom retine numarul coloanei curente in timpul parsarii fisierului
%}

%union {
    char *str; //folosim un union pentru a putea retine atat stringuri cat si numere
}

%token <str> COMMA EOL VALUE //tokenii vor fi virgula, sfarsit de linie si valoarea curenta
%type <str> file header rows row //tipurile vor fi fisierul, headerul, randurile si randul

%%

file: header EOL {printf("[\n");} rows {printf("\n]");}//consideram ca fisierul va avea un header si cel putin un rand
//inainte de randuri vom afisa un [ si dupa randuri vom afisa un ]

//in continuare vom parsa headerul si randurile cu ajutorul unor reguli de tipul:
header: VALUE { 
    headerValues[counter] = strdup($1); //stocam valoarea recunoscuta in vectorul headerValues
    counter++; //incrementam counterul pentru a putea retine urmatoarea valoare
}
| header COMMA VALUE {//presupunem ca headerul va fi format din cel putin o valoare, iar intre valori va fi o virgula
    headerValues[counter] = strdup($3); //stocam valoarea recunoscuta in vectorul headerValues
    counter++; //incrementam counterul pentru a putea retine urmatoarea valoare
}
//in acest mod vom retine headerul in vectorul headerValues, iar counterul va retine numarul de coloane

//in continuare vom parsa randurile cu ajutorul unor reguli de tipul: 
rows: { printf("\t{\n"); counter = 0; } row EOL { printf("\n\t}"); } //inainte de fiecare rand vom afisa un { si dupa fiecare rand vom afisa un }
| rows { printf(",\n\t{\n"); counter = 0; } row EOL { printf("\n\t}"); } //presupunem ca fisierul va avea cel putin un rand si intre randuri va fi un sfarsit de linie

//in continuare vom parsa fiecare rand cu ajutorul unor reguli de tipul:
row: VALUE { printf("\t\t\"%s\": %s", headerValues[counter], $1); counter++; } //in acest mod vom afisa valoarea curenta si headerul corespunzator
| row COMMA VALUE { printf(",\n\t\t\"%s\": %s", headerValues[counter], $3); counter++; } //presupunem ca fiecare rand va avea cel putin o valoare, iar intre valori va fi o virgula

%%


void yyerror(char *s) {
    fprintf(stderr, "error: %s\n", s); //in caz de eroare vom afisa un mesaj de eroare
}

int main(int argc, char **argv) {
    for(int i = 0; i < 100; i++){
        headerValues[i] = NULL; //initializam vectorul cu NULL
    }
    yyparse(); //parsam fisierul
    return 0;
}