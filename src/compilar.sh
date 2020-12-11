flex zeroOrderLexical.l
bison zeroOrderParser.y -d
gcc lex.yy.c zeroOrderParser.tab.c -w
