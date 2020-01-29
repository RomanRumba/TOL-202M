/*
   Authors : Ágúst Logi Pétursson, Páll Ásgeir Björnsson And Róman Rumba

   What is JFlex ?
    JFlex is a lexical analyser generator that takes a input specification with a set of regular expressions and corresponding actions.
    It generates a program (a lexer) that reads input, matches the input against the regular expressions in the spec file,
    and runs the corresponding action if a regular expression matched. Lexers usually are the first front-end step in compilers,
    matching keywords, comments, operators, etc, and generating an input token stream for parsers. 
    They can also be used for many other purposes.

   About This Project.
    For this project we will use JFlex to create a scanner for the language NanoMorpho.
*/

import java.io.*;

// %% means the start of declarations
%%

// Tells JFlex that the generated class is public
%public
// Tells JFlex to generate a class named NanoMorpho
%class NanoMorpho
/*
 defines the set of characters the scanner will work on. 
 For scanning text files %unicode should always be used
*/
%unicode
/*
JFlex has built-in support for the Java extension BYacc/J,
BYacc/J expects a function int yylex() in the parser class that returns each next token. 
Semantic values are expected in a field yylval of type parserval where parser is the name of the generated parser class.
*/
%byaccj 

/* 
   Everything inside %{ %} will be inserted in the generated class, here you can
   define your tokens, lexemes, how the scanner works and more
*/
%{
    /*
        Definitions of our tokens.
        Note : token values should be high so they do not conflict with ASCII values
    */
    final static int ERROR = -1;
    // By default 0 is end of file but i want to have it as a constant
    final static int ENDOFFILE = 0;
    final static int VAR = 1001;
    final static int LITERAL = 1002;
    final static int IF = 1003;
    final static int ELSIF = 1004;
    final static int ELSE = 1005;
    final static int WHILE = 1006;
    final static int RETURN = 1007;
    final static int NAME = 1008;
    final static int OPTNAME = 1009;

    /*
        Variables that will contain tokens and lexemes as they are recognized.
        We will need to store the current token, lexeme and also the next token and lexeme
        due to some ambiguity that would appear if we would only track on token and lexeme at a time. 
    */
    private static int currentToken;
    private static int nextToken;
    private static String currentLexeme;
    private static String nextLexeme;

    private static NanoMorpho lexer;

    public static void main( String[] args ) throws Exception
    {
        lexer = new NanoMorpho(new FileReader(args[0]));

        int token = advance();
        while(token != ENDOFFILE)
        {
            System.out.println(""+token+": \'"+currentLexeme+"\'");
            token =  advance();
        }
    }
    /*
        * Need to implement advance to check for next token t = lexer.advance()
        * Need to implement getToken() (does not advance the token) t= lexer.getToken()
        * Need to implement getNextToken (does not advance but gets next token) t = lexer.getNextToken()
        * Need to implment getlexeme t = lexer.getLexeme() 

        þarf 4 breytur

        p int t1,t2
        p string l1,l2
    */

    private static int advance() throws Exception
    {
        return lexer.yylex();
    }

 
    
%}

/* 
   ------------------------- Regular definitions ------------------------- 
*/

_DIGIT=[0-9]
_FLOAT={_DIGIT}+\.{_DIGIT}+([eE][+-]?{_DIGIT}+)?
_INT={_DIGIT}+
_STRING=\"([^\"\\]|\\b|\\t|\\n|\\f|\\r|\\\"|\\\'|\\\\|(\\[0-3][0-7][0-7])|\\[0-7][0-7]|\\[0-7])*\"
_CHAR=\'([^\'\\]|\\b|\\t|\\n|\\f|\\r|\\\"|\\\'|\\\\|(\\[0-3][0-7][0-7])|(\\[0-7][0-7])|(\\[0-7]))\'
_DELIM=[(){},;=]
_NAME=([:letter:]|\_|{_DIGIT})+
_OPNAME=[<>+\-*\/\^:]
%%

/* 
    ------------------------- Scanning rules -------------------------

    The way this is going to work is that JFlex will take all these rules
    and combine them into an NFA then it will take that NFA and convert it
    into a DFA. The string will be fed to the DFA and it will traverse 
    the DFA until it cant get any further at which point we backtrack to the 
    last accepting state that we found. Its important to know that the order
    of the scanning rules here matters since the rules that are defined
    first have a higher precedence over the rules that are defined later.
    If you dont follow this correctly, you can wind up with something like
    a keyword IF beeing a valid variable or function name.
*/

{_DELIM} {
	currentLexeme = yytext();
	return yycharat(0);
}

{_STRING} | {_FLOAT} | {_CHAR} | {_INT} | null | true | false {
	currentLexeme = yytext();
	return LITERAL;
}

"if" {
	currentLexeme = yytext();
	return IF;
}

"elsif" {
	currentLexeme = yytext();
	return ELSIF;
}

"else" {
	currentLexeme = yytext();
	return ELSE;
}

"while" {
	currentLexeme = yytext();
	return WHILE;
}

"return" {
	currentLexeme = yytext();
	return RETURN;
}

"var" {
	currentLexeme = yytext();
	return VAR;
}

{_NAME} {
	currentLexeme = yytext();
	return NAME;
}

{_OPNAME} {
	currentLexeme = yytext();
	return OPTNAME;
}

// # are our comments if # is the found character then we do nothing since it's a comment.
"#".*$ {
}

// If its a space, tab, carrige return, line or form feed we do nothing 
[ \t\r\n\f] {
}

/*
  If we made it here that means none of the rules above have worked meaning
  we have no idea what this is so we return an ERROR.
*/
. {
    currentLexeme = yytext();
	return ERROR;
}