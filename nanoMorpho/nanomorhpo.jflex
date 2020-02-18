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
// Switches line counting on (the current line number can be accessed via the variable yyline)
%line
// Switches column counting on (the current column is accessed via yycolumn)
%column 

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
    // By default 0 is end of file but we want to have it as a constant
    final static int ENDOFFILE = 0;
    final static int VAR = 1001;
    final static int LITERAL = 1002;
    final static int IF = 1003;
    final static int ELSIF = 1004;
    final static int ELSE = 1005;
    final static int WHILE = 1006;
    final static int RETURN = 1007;
    final static int NAME = 1008;
    final static int AND = 1010;
    final static int OR = 1011;
    
    //Different operations have different priorities, so we have 7 groups of priorities.
    final static int OPTNAME1 = 1012;
    final static int OPTNAME2 = 1013;
    final static int OPTNAME3 = 1014;
    final static int OPTNAME4 = 1015;
    final static int OPTNAME5 = 1016;
    final static int OPTNAME6 = 1017;
    final static int OPTNAME7 = 1018;

    /*
        Variables that will contain tokens, lexemes and their position in the text (line, column) as they are recognized.
        We will need to store the current token and lexeme, also the next token and lexeme
        due to some ambiguity that would appear if we would only track one token and lexeme at a time. 
    */
    private static int currentToken;
    private static int nextToken;
    private static String currentLexeme;
    private static String nextLexeme;
    private static int currentLine;
    private static int nextLine;
    private static int currentColumn;
    private static int nextColumn;

    private static NanoMorpho lexer;

    public static void main( String[] args ) throws Exception
    {
        lexer = new NanoMorpho(new FileReader(args[0]));
        lexer.init();
        lexer.beginParse();
       
      /*
        // For debuggin purposes 
        while(lexer.getToken() != ENDOFFILE )
        {
            System.out.println("(line,column): ("+(lexer.getLine() + 1) +","+(lexer.getColumn()+ 1) +") | "+lexer.getToken()+": \'"+lexer.getLexeme()+"\'");
            lexer.advance();
        }
      */
    }

    /*
        Usage : init()
          For : nothing
        After : fetches the first token,lexeme, line and column and calls the advance function
       Throws : can throw an Exception not sure which one, since we specified that we are using byaccj
                JFlex implements the functions that byaccj has such as yylex() which could throw Exceptions  
    */
    private void init() throws Exception
    {
        nextToken = lexer.yylex();
        nextLexeme = yytext();
        nextLine = yyline;
        nextColumn = yycolumn;
        lexer.advance();
    }

    /*
        Usage : advance()
          For : nothing
        After : sets the current token, lexeme, line and column values and fetches the next token only
                if we have not reached end of file
    */
    private int advance() throws Exception
    {
        currentToken = nextToken;
        currentLexeme = nextLexeme;
        currentLine = nextLine;
        currentColumn = nextColumn;
	
        if(currentToken != ENDOFFILE)
        {
            nextToken = lexer.yylex();
            nextLexeme = yytext();
            nextLine = yyline;
            nextColumn = yycolumn;
        }

        return currentToken;
    }

    //--------------------------- GETTERS : START ----------------------------------
    private int getToken() 
    {
        return currentToken;
    }

    private int getNextToken()
    {
        return nextToken;
    }

    private String getLexeme()
    {
        return currentLexeme;
    }

    private String getNextLexeme()
    {
        return nextLexeme;
    }

    private int getLine()
    {
        return currentLine;
    }

    private int getNextLine()
    {
        return nextLine;
    }

    private int getColumn()
    {
        return currentColumn;
    }

    private int getNextColumn()
    {
        return nextColumn;
    }
    //--------------------------- GETTERS : END ----------------------------------

    //--------------------------- PARSER : START ---------------------------------
    private void beginParse() throws Exception
    {
        while(lexer.getToken() != lexer.ENDOFFILE)
        {
            lexer.functionDescrition();
        }
    }
    
    private void functionDescrition() throws Exception
    {
        /* Function descrition : 
            - starts with NAME 
            - followed by '(' 
            - then with 0 or more NAME's that are seperated by ',' 
            - ending with ')'
            - then followed by the function BODY
        */
        
        lexer.checkIfCurrentTokenIsName("name of function");

        lexer.checkIfCurrentLexemeIsSingleChar("(");

        if(lexer.getToken() == lexer.NAME)
        {
            while(lexer.checkIfCurrentTokenIsName(null))
            {
                if(lexer.getLexeme().equals(","))
                {
                    lexer.advance();
                }
                else if(lexer.getLexeme().equals(")"))
                {
                    break;
                }
                else 
                {
                    lexer.throwParserException(" ',' or ')' ");
                }
            }
        }

        lexer.checkIfCurrentLexemeIsSingleChar(")");

        functionBody();
    }

    private void functionBody() throws Exception
    {
        /*
         * Function body definition : 
         *   - starts with '{'
         *   - followed by 0 or more declarations
         *   - followed by 1 or more expressions
         *   - ending with '}'
         */
        lexer.checkIfCurrentLexemeIsSingleChar("{");

        // A declaration starts with the keyword var and is followed by 1 or more Name's 
        if(lexer.getToken() == lexer.VAR)
        {
            lexer.advance();

            while(lexer.checkIfCurrentTokenIsName(null))
            {
                if(lexer.getLexeme().equals(","))
                {
                    lexer.advance();
                }
                else if(lexer.getLexeme().equals(";"))
                {
                    lexer.advance();
                    break;
                }
                else 
                {
                    lexer.throwParserException(" ',' or ';' ");
                }
            }
        }

        lexer.checkForExpressionLoop();

        lexer.checkIfCurrentLexemeIsSingleChar("}");
    }
    
    private void expressionDefinition() throws Exception
    {
        /*
         * Expression can be one of these things : 
         *   - can start with Name that can be followed up by 3 different scenarios
                1. NAME followed by nothing
                2. NAME followed by '=' then by another expression
                3. NAME followed by '(' then by 1 or more comma seperated expressions and ending with ')'
             - can start with keyword return followed by an expressions
             - can start with Opname followed by an expression
             - can start with expression followed by an opname then followed by another expression
             - can be only a litteral
             - can start with '(' followed by an expression then ending with ')'
             - can start with the keyword IF followed by
                * '('
                * then followed by an expression
                * then by ')'
                * then followed by a body then by optional Elsif or else 
             - cant start with keyword while 
                * followed by '('
                * then by an expression
                * then followed by ')'
                * then by followed by body
         */
       
        if(lexer.getNextToken() == lexer.OPTNAME1 || lexer.getNextToken() == lexer.OPTNAME2 || lexer.getNextToken() == lexer.OPTNAME3 ||
           lexer.getNextToken() == lexer.OPTNAME4 || lexer.getNextToken() == lexer.OPTNAME5 || lexer.getNextToken() == lexer.OPTNAME6 || lexer.getNextToken() == lexer.OPTNAME7)
        {
           /*
              This is something that we have decided, if we next token is an OPERATION
              then we allow only Names,Litterals, ')' or other OPNAMES 
           */
           if(lexer.getToken() == lexer.NAME){
                lexer.advance();    
           }
           else if(lexer.getToken() == lexer.LITERAL)
           {
               lexer.advance();
           }
           else if(lexer.getLexeme().equals(")"))
           {
               lexer.advance();
           }
           else if(lexer.getToken() == lexer.OPTNAME1 || lexer.getToken() == lexer.OPTNAME2 || lexer.getToken() == lexer.OPTNAME3 ||
                   lexer.getToken() == lexer.OPTNAME4 || lexer.getToken() == lexer.OPTNAME5 || lexer.getToken() == lexer.OPTNAME6 || lexer.getToken() == lexer.OPTNAME7)
           {
               lexer.advance();
           }
           else 
           {
               lexer.throwParserException("variable name, litteral, ')' or an operation");
           }
           /*
             if we have made it to this point it means we are currently on the
             OPNAME token that was the result of this condition being met so 
             no need to check it its an OPNAME since we already know it is
             but we still Advance for the OPNAME
            */
           lexer.advance();
           /*
             if we call expressionDefinition at this point this allows us to create
             infite amount of "expr OPNAME expr" 
           */
           expressionDefinition(); 
        }
        else if(lexer.getToken() == lexer.NAME)
        {
           lexer.advance();

           if(lexer.getLexeme().equals("="))
           {
               lexer.advance();
               expressionDefinition();
           }
           else if(lexer.getLexeme().equals("("))
           {
               lexer.advance();
               while(true)
               {
                   expressionDefinition();
                   if(lexer.getLexeme().equals(","))
                   {
                       lexer.advance();
                   }
                   else if(lexer.getLexeme().equals(")"))
                   {
                     break;
                   }
               }
               lexer.checkIfCurrentLexemeIsSingleChar(")"); 
           }
           
        }
        else if(lexer.getToken() == lexer.RETURN)
        {
            lexer.advance();
            expressionDefinition();
        }
        else if(lexer.getToken() == lexer.OPTNAME1 || lexer.getToken() == lexer.OPTNAME2 || lexer.getToken() == lexer.OPTNAME3 ||
                lexer.getToken() == lexer.OPTNAME4 || lexer.getToken() == lexer.OPTNAME5 || lexer.getToken() == lexer.OPTNAME6 || lexer.getToken() == lexer.OPTNAME7)
        {
            lexer.advance();
            expressionDefinition();
        }
        else if(lexer.getToken() == lexer.LITERAL) 
        {
            lexer.advance();
        }
        else if(lexer.getLexeme().equals("("))
        {
            lexer.advance();
            expressionDefinition();
            lexer.checkIfCurrentLexemeIsSingleChar(")"); 

            /*
                like Snorri says needs some chewing gum and ducktape, i forgot to 
                think of what happens when you encounter (expr) OPNAME or (expr) OPNAME (expr)  
            */
            if(lexer.getToken() == lexer.OPTNAME1 || lexer.getToken() == lexer.OPTNAME2 || lexer.getToken() == lexer.OPTNAME3 ||
               lexer.getToken() == lexer.OPTNAME4 || lexer.getToken() == lexer.OPTNAME5 || lexer.getToken() == lexer.OPTNAME6 || lexer.getToken() == lexer.OPTNAME7)
            {
                expressionDefinition();
            }
        }
        else if(lexer.getToken() == lexer.IF)
        {
            checkIfDefinitionAfterWhileOrIfHolds();
            while(lexer.getToken() == lexer.ELSIF)
            {
              checkIfDefinitionAfterWhileOrIfHolds();
            }
          
            if(lexer.getToken() == lexer.ELSE)
            {
                lexer.advance();
                bodyDefinition();
            }
        }
        else if(lexer.getToken() == lexer.WHILE)
        {
            checkIfDefinitionAfterWhileOrIfHolds();
        }
        else 
        {
            lexer.throwParserException("an expression");
        }
    }

    public void bodyDefinition() throws Exception
    {
        /*
         * Body definition :
         *   - starts with '{'
         *   - followed by 1 or more expressions
         *   - ending with '}'
        */
        lexer.checkIfCurrentLexemeIsSingleChar("{");
        lexer.checkForExpressionLoop();
        lexer.checkIfCurrentLexemeIsSingleChar("}"); 
    }

    /*
     * this sequence of functions appears 3 times i just figured
     * it would look cleaner if i extract it to a method of its own.
     */
    private void checkIfDefinitionAfterWhileOrIfHolds() throws Exception
    {
        lexer.advance();
        lexer.checkIfCurrentLexemeIsSingleChar("(");
        expressionDefinition(); 
        lexer.checkIfCurrentLexemeIsSingleChar(")");
        bodyDefinition();
    }

    /* 
     * Usage : checkForExpressionLoop()
     *   For : nothing
     * After : performs a check wheather the expression loop is 
     *         of a valid form or not if not then calls throwParserException to throw a parser exception
    */
    private void checkForExpressionLoop() throws Exception
    {
        /* Expression loop :
         *   - 1 or more expressions 
         *   - after each expression ';' should be seen
        */
        while(true)
        {
            expressionDefinition();
            lexer.checkIfCurrentLexemeIsSingleChar(";");
          
            if(lexer.getLexeme().equals("}"))
            {
                break;
            }
        }
    }

    /* 
     * Usage : checkIfCurrentLexemeIsSingleChar(charToCheck)
     *   For : charToCheck is a string of lenght 1 
     * After : checks if the current lexeme is equal to charToCheck if its not then it calls 
     *         the throwParserException to throw a parser exception else it advances to the next lexeme
     */
    private void checkIfCurrentLexemeIsSingleChar(String charToCheck) throws Exception
    {
        // the naming is a bit confusing since equals accepts strings
        if(!lexer.getLexeme().equals(charToCheck))
        {
            lexer.throwParserException("'"+charToCheck+"'");
        }
        lexer.advance();
    }

    /*
     * Usage : checkIfCurrentTokenIsName(customMsg)
     *   For : customMsg is a custom message that can be thrown if result is not true (CAN BE NULL)
     * After : checks if the current token is NAME if true advance and return true
     *         else call throwParserException to throw a parser exception
     */
    private boolean checkIfCurrentTokenIsName(String customMsg) throws Exception
    {
        if(lexer.getToken() != lexer.NAME)
        {
            lexer.throwParserException((customMsg == null)? "name declaration" : customMsg);
        }
        lexer.advance();
        return true;
    }

    //--------------------------- PARSER : END -----------------------------------
    
    //-------------------------- HELPER FUNCTIONS --------------------------------

    /* 
     * Usage : throwParserException(expectedToSee)
         For : expectedToSee is a string containing information of what was expected to see
       After : Throws a ParserException while passing to it line and column numbers, the lexeme and the expectedToSee message.
     */
    private static void throwParserException(String expectedToSee) throws Exception
    {
        // the reason why i add 1 to the line and column is because their count starts at 0 and IDE's start from 1.
        throw new ParserException(lexer.getLine() + 1, lexer.getColumn() + 1, lexer.getLexeme() , expectedToSee);
    }

    // A Custom exeption that our parser can throw. 
    private static class ParserException extends Exception 
    { 
        public ParserException(int line, int column, String saw, String expectedToSee) 
        {
            super("Parser encountered an error found on line: "+ line +" column: "+ column + 
                  " expected to see "+ expectedToSee + " but instead saw " + saw);
        }

        // just in case if we want to throw a custom message
        public ParserException(String errorMessage) 
        {
            super(errorMessage);
        }
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
_OPNAME=[<>%+\-*\/\^:$|!=\~]+

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

"&&" {
	return AND;
}

"||" {
	return OR;
}

{_NAME} {
	return NAME;
}

{_OPNAME} {
    String current = yytext();
    if(current.charAt(0) == '*' || current.charAt(0) == '/' || current.charAt(0) == '%'){
        return OPTNAME7;
    }
    else if(current.charAt(0) == '+' || current.charAt(0) == '-' ){
        return OPTNAME6;
    }
    else if(current.charAt(0) == '>' || current.charAt(0) == '<' || current.charAt(0) == '!' || current.charAt(0) == '=' ){
        return OPTNAME5;
    }
    else if(current.charAt(0) == '&' ){
        return OPTNAME4;
    }
    else if(current.charAt(0) == '|'){
        return OPTNAME3;
    }
    else if(current.charAt(0) == ':'){
        return OPTNAME2;
    }
    else if(current.charAt(0) == '?' || current.charAt(0) == '^' || current.charAt(0) == '~'){
        return OPTNAME1;
    }
    else 
    {
        return ERROR;
    }
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