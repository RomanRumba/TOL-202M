/**
	JFlex scanner example based on a scanner for NanoMorhpo.
	Author: Páll Ásgeir Björnsson, 2020 - 2020

	This stand-alone scanner/lexical analyzer can be built and run using:
		java -jar JFlex-full-1.7.0.jar nanolexermorp.jflex
		javac NanoLexerMorp.java
		java NanoLexerMorp inputfile > outputfile
	Also, the program 'make' can be used with the proper 'makefile':
		make test
 */

import java.io.*;

%%

%public
%class NanoLexerMorp
%unicode
%byaccj

%{

// This part becomes a verbatim part of the program text inside
// the class, NanoLexer.java, that is generated.

// Definitions of tokens:
final static int ERROR = -1;
final static int IF = 1001;
final static int DEFINE = 1002;
final static int NAME = 1003;
final static int LITERAL = 1004;
final static int var = 1005;
final static int RETURN = 1006;
final static int OPNAME = 1007;
final static int WHILE = 1008;
final static int ELSIF = 1009;
final static int ELSE = 1010;
final static int COMMENT = 1011;

// A variable that will contain lexemes as they are recognized:
private static String lexeme;

// This runs the scanner:
public static void main( String[] args ) throws Exception
{
	NanoLexerMorp lexer = new NanoLexerMorp(new FileReader(args[0]));
	int token = lexer.yylex();
	while( token!=0 )
	{
		System.out.println(""+token+": \'"+lexeme+"\'");
		token = lexer.yylex();
	}
}

%}

  /* Reglulegar skilgreiningar */

  /* Regular definitions */

_DIGIT=[0-9]
_FLOAT={_DIGIT}+\.{_DIGIT}+([eE][+-]?{_DIGIT}+)?
_INT={_DIGIT}+
_STRING=\"([^\"\\]|\\b|\\t|\\n|\\f|\\r|\\\"|\\\'|\\\\|(\\[0-3][0-7][0-7])|\\[0-7][0-7]|\\[0-7])*\"
_CHAR=\'([^\'\\]|\\b|\\t|\\n|\\f|\\r|\\\"|\\\'|\\\\|(\\[0-3][0-7][0-7])|(\\[0-7][0-7])|(\\[0-7]))\'
_DELIM=[(){};,]
_NAME=([:letter:]|{_DIGIT})+
_OPNAME=([\+\-*/!%=><\:\^\~&|?])+

%%

  /* Lesgreiningarreglur */
  /* Scanning rules */

{_DELIM} {
	lexeme = yytext();
	return yycharat(0);
}

{_STRING} | {_FLOAT} | {_CHAR} | {_INT} | null | true | false {
	lexeme = yytext();
	return LITERAL;
}

"return" {
    lexeme = yytext();
    return RETURN;
}

{_OPNAME} {
    lexeme = yytext();
    return OPNAME;
}

"if" {
	lexeme = yytext();
	return IF;
}

"elsif" {
    lexeme = yytext();
    return ELSIF;
}

"else" {
    lexeme = yytext();
    return ELSE;
}

"define" {
	lexeme = yytext();
	return DEFINE;
}

"var" {
    lexeme = yytext();
    return var;
}

{_NAME} {
	lexeme = yytext();
	return NAME;
}

";;;" {
    lexeme = yytext();
    return COMMENT;
}

[ \t\r\n\f] {
}

. {
	lexeme = yytext();
	return ERROR;
}
