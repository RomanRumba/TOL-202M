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
import java.util.Vector;
import java.util.HashMap;

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
    final static int OPNAME = 1009;

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
    private static ProgramGenerator progGenerator = new ProgramGenerator();
    
    /*
        The symbol table consists of the following two variables.
        Where string is the name of the variable which is also the key
        and the interger value is the location of that variable.
    */
	private static int varCount;
	private static HashMap<String,Integer> varTable;

    public static void main( String[] args ) throws Exception
    {
        lexer = new NanoMorpho(new FileReader(args[0]));
        lexer.init();
        Object[] generatedCode = lexer.beginParse();
        progGenerator.generateProgram(args[0],generatedCode);
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

    /*
       Adds a new variable to the symbol table.
       Throws Error if the variable already exists.
    */
	private static void addVar( String name ) throws Exception
	{
		if( varTable.get(name) != null )
        {
            throw new Error("Variable "+name+" already exists, near line "+lexer.getNextLine());
        }
		varTable.put(name, varCount++);
	}

    /* 
       Finds the location of an existing variable.
       Throws Error if the variable does not exist.
    */
	private static int findVar( String name ) throws Exception
	{
		Integer res = varTable.get(name);
		if( res == null )
        {
			throw new Error("Variable "+name+" does not exist, near line "+lexer.getNextLine());
        }
		return res;
	}
    //--------------------------- GETTERS : END ----------------------------------

    //--------------------------- PARSER : START ---------------------------------
    private Object[] beginParse() throws Exception
    {
        Vector<Object> code = new Vector<Object>();
        try {
            while(lexer.getToken() != lexer.ENDOFFILE)
            {
                code.add(lexer.function());
            }
        }
        catch( Throwable e )
        {
            System.out.println(e.getMessage());
        }

        return code.toArray();
    }
    
    private Object[] function() throws Exception
    {
        // Each new function creates a new symbol table
        varCount = 0;
        varTable = new HashMap<String,Integer>();
        // To store function name and the amount of arguments the function has
        String currentFunctionName = "";
        int argcount = 0;

        /* 
           Function head description : 
            - starts with NAME 
            - followed by '(' 
            - then with 0 or more NAME's that are seperated by ',' 
            - ending with ')'
            - then followed by the function BODY
        */
        if(lexer.getToken() != lexer.NAME)
        {
            lexer.throwParserException("name of function");
        }
        currentFunctionName = lexer.getLexeme();
        lexer.advance();

        lexer.over("(");
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
        lexer.over(")");
        argcount = varCount;
        
        /*
         * Function body definition : 
         *   - starts with '{'
         *   - followed by 0 or more declarations
         *   - followed by 1 or more expressions
         *   - ending with '}'
         */
        lexer.over("{");

        // A declaration starts with the keyword var and is followed by 1 or more Name's 
        if(lexer.getToken() == lexer.VAR)
        {
            lexer.advance();
            while(lexer.checkIfCurrentTokenIsName("name declaration for a variable"))
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

        Vector<Object> expressions = new Vector<Object>();
        while(!lexer.getLexeme().equals("}"))
        {
            expressions.add(lexer.expr());
            lexer.over(";");
        }

        lexer.over("}");

        return (new Object[]{currentFunctionName, argcount, varCount, expressions.toArray()});
    }
    
    private Object[] expr() throws Exception
    {
        Object[] res;
        if(lexer.getToken() == lexer.RETURN)
        {
            lexer.over(lexer.RETURN);
            res = new Object[]{progGenerator.EXPRESSION_RETURN, lexer.expr()};
        }
        else if(lexer.getToken() == lexer.NAME && lexer.getNextLexeme().equals("="))
        {
            int namePos = lexer.findVar(lexer.getLexeme());
            lexer.over(lexer.NAME);
            lexer.over("=");
            res = new Object[]{progGenerator.EXPRESSION_STORE, namePos, lexer.expr()};
        }
        else 
        {
            return lexer.binopexpr(0); // er ekki viss um þetta hvort þetta á að vera 0
        }

        return res;
    }

    private Object[] binopexpr(int pri) throws Exception
    {
        if(pri > 7)
        {
            return lexer.smallexpr();
        }
        else if(pri == 2)
        {
            Object[] e = lexer.binopexpr(3);
            if(lexer.getToken() == lexer.OPNAME && lexer.priority(lexer.getLexeme()) == 2)
            {
                String op = lexer.getLexeme();
                lexer.advance();
                e = new Object[]{progGenerator.EXPRESSION_CALL,op,new Object[]{e, lexer.binopexpr(2)}};
            }
            return e;
        }
        else 
        {
            Object[] e = binopexpr(pri+1);
            while(lexer.getToken() == lexer.OPNAME && lexer.priority(lexer.getLexeme()) == pri )
            {
                String op = lexer.getLexeme();
                lexer.advance();
                e = new Object[]{progGenerator.EXPRESSION_CALL, op, new Object[]{e, lexer.binopexpr(pri+1)}};
            }
            return e;
        }
    }

    private Object[] smallexpr() throws Exception
    {
        Object[] res = null; // remove null when you done
        switch(lexer.getToken())
        {
            case NAME:
                String currName = lexer.getLexeme();
                lexer.over(lexer.NAME);
                if(lexer.getLexeme().equals("("))
                {
                    lexer.over("(");
                    Vector<Object> args = new Vector<Object>();
                    if(!lexer.getLexeme().equals(")"))
                    {
                        for(;;)
                        {
                            args.add(lexer.expr());
                            if(lexer.getLexeme().equals(")") ) break;
                            lexer.over(",");
                        }
                    }
                    lexer.over(")");
                    res = new Object[]{progGenerator.EXPRESSION_CALL, currName, args.toArray()};
                }
                else
                {
                    res = new Object[]{progGenerator.EXPRESSION_FETCH, lexer.findVar(currName)};
                }
                break;
            case WHILE:
                lexer.over(lexer.WHILE);
                res = new Object[]{progGenerator.EXPRESSION_WHILE, lexer.expr(), lexer.body()};
                break;
            case IF:
                Object[] cond, thenCond;
                Vector<Object> elseexpresions = new Vector<Object>();
                lexer.over(lexer.IF);
                cond = lexer.expr();
                thenCond = lexer.body();
                res = new Object[]{progGenerator.EXPRESSION_IF, cond, thenCond, null};

                while(lexer.getToken() == lexer.ELSIF)
                {
                    Object[] lastObj;
                    if(elseexpresions.size() == 0)
                    {
                       lastObj = res;
                    }
                    else
                    {
                        lastObj = (Object[])elseexpresions.lastElement();
                    }
                    lexer.over(lexer.ELSIF);
                    elseexpresions.add(new Object[]{progGenerator.EXPRESSION_IF, lexer.expr(), lexer.body(), lastObj});
                }

                if(lexer.getToken() == lexer.ELSE)
                {
                    Object[] lastObj;
                    if(elseexpresions.size() == 0)
                    {
                       lastObj = res;
                    }
                    else
                    {
                        lastObj = (Object[])elseexpresions.lastElement();
                    }
                    lexer.over(lexer.ELSE);
                    elseexpresions.add(new Object[]{progGenerator.EXPRESSION_IF,
                                                    new Object[]{progGenerator.EXPRESSION_LITERAL, "true"},
                                                    lexer.body(), 
                                                    null});
                }
                break;
            case LITERAL:
                res = new Object[]{progGenerator.EXPRESSION_LITERAL, lexer.getLexeme()};
                lexer.over(lexer.LITERAL);
                break;
            case OPNAME:
                lexer.over(lexer.OPNAME);
                return lexer.smallexpr();
            case '(':
                lexer.over("(");
                res = lexer.expr();
                lexer.over(")");
                break;
            default:
                lexer.throwParserException("an expression");
        }
        return res;
    }

    private Object[] body() throws Exception
    {
        Vector<Object> res = new Vector<Object>();
        lexer.over("{");
        while(!lexer.getLexeme().equals("}"))
        {
            res.add(lexer.expr());
            lexer.over(";");
        }
        lexer.over("}");
        return new Object[]{progGenerator.EXPRESSION_BODY, res.toArray()};
    }

    /* 
     * Usage : over(charToCheck)
     *   For : charToCheck is a string of lenght 1 
     * After : checks if the current lexeme is equal to charToCheck if its not then it calls 
     *         the throwParserException to throw a parser exception else it advances to the next lexeme
     */
    private void over(String charToCheck) throws Exception
    {
        // the naming is a bit confusing since equals accepts strings
        if(!lexer.getLexeme().equals(charToCheck))
        {
            lexer.throwParserException("'"+charToCheck+"'");
        }
        lexer.advance();
    }

    /* 
     * Usage : over(tokenToCheck)
     *   For : tokenToCheck is a integer value
     * After : checks if the current token is equal to tokenToCheck if its not then it calls 
     *         the throwParserException to throw a parser exception else it advances to the next lexeme
     */
    private void over(int tokenToCheck) throws Exception
    {
        if(lexer.getToken() != tokenToCheck)
        {
            lexer.throwParserException("'"+lexer.TokenToName(tokenToCheck)+"'");
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
        lexer.addVar(lexer.getLexeme());
        lexer.advance();
        return true;
    }

    //--------------------------- PARSER : END -----------------------------------
    
    //-------------------------- HELPER FUNCTIONS --------------------------------
    private static int priority(String opname )
    {
        switch( opname.charAt(0) )
        {
        case '^':
        case '?':
        case '~':
            return 1;
        case ':':
            return 2;
        case '|':
            return 3;
        case '&':
            return 4;
        case '!':
        case '=':
        case '<':
        case '>':
            return 5;
        case '+':
        case '-':
            return 6;
        case '*':
        case '/':
        case '%':
            return 7;
        default:
            throw new Error("Invalid opname");
        }
    }

    private static String TokenToName(int token) throws Exception
    {
        if( token < 1000 ) return ""+(char)token;
        switch( token )
        {
            case IF:
                return "if";
            case ELSE:
                return "else";
            case ELSIF:
                return "elsif";
            case WHILE:
                return "while";
            case VAR:
                return "var";
            case RETURN:
                return "return";
            case NAME:
                return "name";
            case LITERAL:
                return "literal";
            case OPNAME:
                return "opname";
        }
        throw new Error();
    }

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
_OPNAME=[\+\-*/!%&=><\:\^\~&|?]+

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