all: final
final: lex.yy.c parser.tab.h parser.tab.c
	g++ -o final parser.tab.c lex.yy.c
lex.yy.c: lexer.l parser.tab.h
	flex lexer.l
parser.tab.h parser.tab.c: parser.y
	bison -d -t -v parser.y
clean:
<<<<<<< HEAD:Source Code/src/makefile
	rm final parser.tab.c parser.tab.h lex.yy.c  out.dot parser.output a.out out.s  3ac.txt SymbolTable.csv
=======
	rm final parser.tab.c parser.tab.h lex.yy.c  out.dot parser.output a.out out.s  3ac.txt
>>>>>>> df6d538a3acfd528791d8988f6d7f95ebac1a219:cs335_project_200530/src/makefile
