all: final
final: lex.yy.c parser.tab.h parser.tab.c
	g++ -o final parser.tab.c lex.yy.c
lex.yy.c: lexer.l parser.tab.h
	flex lexer.l
parser.tab.h parser.tab.c: parser.y
	bison -d -t -v parser.y
clean:
	rm final parser.tab.c parser.tab.h lex.yy.c graph.ps out.dot parser.output
