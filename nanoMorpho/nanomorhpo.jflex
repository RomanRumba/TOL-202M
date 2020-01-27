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

%public
// Tells JFlex to generate a class named NanoMorpho
%class NanoMorpho
// defines the set of characters the scanner will work on. 
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
        Definitions of our tokens. 0 is end of file.
        Note : token values should be high so they do not interfere with ASCII values
    */
    // Return this token in an event of an error
    final static int ERROR = -1;
    final static int IF = 1001;

    /* 
        Variables that will contain lexemes as they are recognized,
        we will need 2 because nanoMorpho has some definitions that cannot be 
        correctly resolved by just using one.
    */
    private final static String lexemeCurrent;
    private final static String lexemeNext;
%}

/* Regular definitions */


%%


/*

*/