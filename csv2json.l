%option noyywrap
%{
#include "y.tab.h" //includem fisierul y.tab.h pentru a putea folosi constantele definite in el
%}

%%
","        { return COMMA; } //recunoastem virgula
\n         { return EOL; } //recunoastem linie noua
[^,\n\t' ']+    { yylval.str = strdup(yytext); return VALUE; } //recunoastem valoarea (string/numar) si o salvam in yylval pentru a o putea folosi in parser (strdup este folosit pentru a aloca memorie pentru string)
.          {} //ignoram caracterele nerecunoscute
%%
