out.txt: parser input.csv
	./parser <input.csv> out.json

parser: y.tab.o lex.yy.o
	gcc y.tab.o lex.yy.o -o parser

y.tab.o: y.tab.c
	gcc -c y.tab.c

y.tab.c: csv2json.y
	yacc csv2json.y

lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

lex.yy.c: csv2json.l
	flex csv2json.l