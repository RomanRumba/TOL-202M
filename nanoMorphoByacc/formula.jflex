/**/

%%

%public
%class ExprLexer
%byaccj
%line
%column 
%unicode

%{

public ExprParser yyparser;

public ExprLexer( java.io.Reader r, ExprParser yyparser )
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
	return yycharat(0);
}

{_STRING} | {_FLOAT} | {_CHAR} | {_INT} | null | true | false {
	return LITERAL;
}

"if" {
	return IF;
}

"elsif" {
	return ELSIF;
}

"else" {
	return ELSE;
}

"while" {
	return WHILE;
}

"return" {
	return RETURN;
}

"var" {
	return VAR;
}

{_NAME} {
	return NAME;
}

{_OPNAME} {
	return OPNAME;
}

/*
  The reason to why comments, spaces,tabs and carrige returns do not return a lexeme is because, 
  we do not care about it, this type of information should have no impact on the code.
*/

// ;;; are our comments, if the line starts with ;;; and is followed by zero or more characters its a comment.
";;;".*$ {
}

// If its a space, tab, carrige return, line or form feed we do nothing 
[ \t\r\n\f] {
}

/*
  If we made it here that means none of the rules above have worked meaning
  we have no idea what this is so we return an ERROR.
*/
. {
	return ERROR;
}
