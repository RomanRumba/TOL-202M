/*
    This file will be a lot less commented because this is esentially copy-paste rules from our
	last project.
*/

%%

%public
%class NanoMorphoLexer
%byaccj
%line
%column 
%unicode

%{

public NanoMorphoParser yyparser;

public NanoMorphoLexer(java.io.Reader r, NanoMorphoParser yyparser )
{
	this(r);
	this.yyparser = yyparser;
}

%}

_DIGIT=[0-9]
_FLOAT={_DIGIT}+\.{_DIGIT}+([eE][+-]?{_DIGIT}+)?
_INT={_DIGIT}+
_STRING=\"([^\"\\]|\\b|\\t|\\n|\\f|\\r|\\\"|\\\'|\\\\|(\\[0-3][0-7][0-7])|\\[0-7][0-7]|\\[0-7])*\"
_CHAR=\'([^\'\\]|\\b|\\t|\\n|\\f|\\r|\\\"|\\\'|\\\\|(\\[0-3][0-7][0-7])|(\\[0-7][0-7])|(\\[0-7]))\'
_DELIM=[(){},;=]
_NAME=([:letter:]|\_|{_DIGIT})+
_OPNAME=[\+\-*/!%&=><\:\^\~&|?]+

%%

{_DELIM} {
	yyparser.yylval = new NanoMorphoParserVal(yytext());
	return yycharat(0);
}

{_STRING} | {_FLOAT} | {_CHAR} | {_INT} | null | true | false {
	yyparser.yylval = new NanoMorphoParserVal(yytext());
	return NanoMorphoParser.LITERAL;
}

"if" {
	return NanoMorphoParser.IF;
}

"elsif" {
	return NanoMorphoParser.ELSIF;
}

"else" {
	return NanoMorphoParser.ELSE;
}

"while" {
	return NanoMorphoParser.WHILE;
}

"return" {
	return NanoMorphoParser.RETURN;
}

"var" {
	return NanoMorphoParser.VAR;
}

{_NAME} {
	yyparser.yylval = new NanoMorphoParserVal(yytext());
	return NanoMorphoParser.NAME;
}

{_OPNAME} {
	return NanoMorphoParser.OPNAME;
}

";;;".*$ {
}

[ \t\r\n\f] {
}

. {
	return NanoMorphoParser.YYERRCODE;
}
