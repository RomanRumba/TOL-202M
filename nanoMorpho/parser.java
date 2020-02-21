package nanoMorpho;

import java.io.FileReader;


/*
program		=	{ function }
			;
function	= 	NAME, '(', [ NAME, { ',', NAME } ] ')'
				'{', { decl, ';' }, { expr, ';' }, '}'
			;
decl		=	'var', NAME, { ',', NAME }
			;
expr		=	'return', expr
			|	NAME, '=', expr
			|	orexpr
			;
orexpr		=	andexpr, [ '||', orexpr ]
			;
andexpr		=	notexpr, [ '&&', andexpr ]
			;
notexpr		=	'!', notexpr | binopexpr1
			;
binopexpr1	=	binopexpr2, { OPNAME1 binopexpr2 }
			;
binopexpr2	=	binopexpr3, [ OPNAME2, binopexpr2 ]
			;
binopexpr3	=	binopexpr4, { OPNAME3, binopexpr4 }
			;
binopexpr4	=	binopexpr5, { OPNAME4, binopexpr5 }
			;
binopexpr5	=	binopexpr6, { OPNAME5, binopexpr6 }
			;
binopexpr6	=	binopexpr7, { OPNAME6, binopexpr7 }
			;
binopexpr7	=	smallexpr, { OPNAME7, smallexpr }
			;
smallexpr	=	NAME
			|	NAME, '(', [ expr, { ',', expr } ], ')'
			|	opname, smallexpr
			| 	LITERAL 
			|	'(', expr, ')'
			|	ifexpr
			|	'while', '(', expr, ')', body
			;
opname		=	OPNAME1
			|	OPNAME2
			|	OPNAME3
			|	OPNAME4
			|	OPNAME5
			|	OPNAME6
			|	OPNAME7
			;
ifexpr 		=	'if', '(', expr, ')' body, 
				{ 'elsif', '(', expr, ')', body }, 
				[ 'else', body ]
			;
body		=	'{', { expr, ';' }, '}'
            ;
            
            */

public class parser {
  
    private static NanoMorpho lexer;

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
  final static int NOT = 1111;

  //Different operations have different priorities, so we have 7 groups of priorities.
  final static int OPTNAME1 = 1012;
  final static int OPTNAME2 = 1013;
  final static int OPTNAME3 = 1014;
  final static int OPTNAME4 = 1015;
  final static int OPTNAME5 = 1016;
  final static int OPTNAME6 = 1017;
  final static int OPTNAME7 = 1018;
  public static void main(final String[] args) throws Exception 
  {

    lexer = new NanoMorpho(new FileReader(args[0])); 
    lexer.init();
    parse(); 

  }

  public static void parse() 
  {
    try 
    {
      function();
      while (lexer.getToken() != 0) 
      {
        System.out.println("call function again");
        function();
      }
    } catch (Exception e) {
    
      e.printStackTrace();
    }
  }

  private static void function() 
  {
        try
        {
            if (lexer.getToken() != NAME) {
                throw new Error("name");
            }
            lexer.advance();
            if (lexer.getToken() != 44) {

                // error, expected (
                return;
            }
            
            lexer.advance();

            if (name()) {
                lexer.advance();
                while (lexer.getToken() == 44) { // 44 er ','
                    lexer.advance();
                    if (lexer.getToken()!= NAME) {
                        // error expected name
                        return;
                    }
                    lexer.advance();
                }
            }
            if (lexer.getToken() != 41) {
                // error, expected )
                return;
            }

            if (lexer.getToken() != 123) { //token 123 er "{"
                // error expected {
                return;
            }
            
            lexer.advance();
            if (lexer.getToken() == 123) 
            { 
              lexer.advance();
              if (decl()) 
              {
                lexer.advance();
                if (lexer.getToken() == 59) { //token 59 er ";"
                  lexer.advance();
                } else {
                  //error expected ";"
                  return;
                }
              }

              if (expr()) 
              {
                lexer.advance();
                if (lexer.getToken() == 59) { //token 59 er ";"
                  lexer.advance();
                } else 
        
                  System.out.println("Expected ;");
                  return;
                }
              }
              if (lexer.getToken() == 125) { //token 125 er "}"
                lexer.advance();
              }else {
                
                System.out.println("Expected }");
                return;
              }
            

        } catch(Exception e)
        {
        }
      }
/*
    } catch (Exception e) 
    {
        if (lexer.getToken() == NAME)
        {
            throw new Error("Expected name. ");
                } else
        {
            return false;
        }
    } catch (Exception e)
        {
            
        }
        return false;
    }

    */


  private static boolean name() 
  {
    try 
    {
      if (lexer.getToken() == NAME) 
      {
        return true;
      } else 
      {
        return false;
      }
    } catch (Exception e) 
    {
      
    }
    return false;
  }

  private static boolean expr(){
     // TODO
    return true;
  }
  private static boolean decl() 
  {
    try 
    {
      if (lexer.getToken() == 1008) 
      {
        lexer.advance();
        if (name()) 
        {
          lexer.advance();
          if (lexer.getToken() == 44) { //token 44 er ","
            lexer.advance();
            if (name()) 
            {
              lexer.advance();
            } else 
            {
              // expected name after ","
            }
          }
          return true;
        } else 
        {
          //expected name after var
        }
      } else 
      {
        return false;
      }
    } catch (Exception e) 
    {
      
    }
    return false;
  }

    private static void orexpr()
    {
        System.out.println("in orexpr");
        andexpr();
        if (lexer.getToken() == OR){
            lexer.advance();
            orexpr();
        }
        
    }

    private static void andexpr()
    {
        System.out.println("in andexpr");
        notexpr();
        if (lexer.getToken() == AND){
            lexer.advance();
            andexpr();
        }
  }

    private static void notexpr()
    {
        System.out.println("in notexpr");
            if (lexer.getToken() == NOT){
                lexer.advance();
                notexpr();
            }  
            else{ 
            binopexpr1();
            }
  }

    private static void binopexpr1()
    {
        binopexpr2();
        while(lexer.getToken() == OPTNAME1){
            lexer.advance();
            binopexpr2();
        }
    }
                    

  private static void binopexpr2() 
  {     
    binopexpr3();
    if(lexer.getToken() == OPTNAME2){
        lexer.advance();
        binopexpr2();
    }
  }

    private static void binopexpr3()
    {
        binopexpr4();
        while(lexer.getToken() == OPTNAME3){
            lexer.advance();
            binopexpr4();
        } 
    }

    private static void binopexpr4()
    {
        binopexpr5();
        while(lexer.getToken() == OPTNAME4){
            lexer.advance();
            binopexpr5();
        } 
    }
    
    private static void binopexpr5()
    {
        binopexpr6();
        while(lexer.getToken() == OPTNAME5){
            lexer.advance();
            binopexpr6();
        } 
  }

    private static void binopexpr6()
    {
        binopexpr7();
        while(lexer.getToken() == OPTNAME6){
            lexer.advance();
            binopexpr7();
        } 
    }

    private static void binopexpr7()
    {
        smallexpr();
        while(lexer.getToken() == OPTNAME7){
            lexer.advance();
            smallexpr();
        } 
  }

  private static boolean smallexpr() 
  {
    System.out.println("in smallexpr");
    try 
    {
      if (lexer.getToken() == NAME) 
      {
        lexer.advance();
        if (lexer.getNextToken() == 40) 
        {
          lexer.advance();
          if (!(lexer.getToken() == 41)) 
          {
            if (expr()) 
            {
              lexer.advance();
              if (lexer.getToken() == 44) 
              {
                return expr();
              } else if (lexer.getToken() == 41) 
              {
                return true;
              } else 
              {
                return false;
              }
            }
            return false;
          }
          if (lexer.getToken() == 41) 
          {
            return true;
          }
        }
        return true;
      } else if (opname()) 
      {
        lexer.advance();
        return smallexpr();
      } else if (lexer.getToken() == 1004) 
      {
        return true;
      } else if (lexer.getToken() == 40) 
      {
        lexer.advance();
        if (expr()) 
        {
          lexer.advance();
          if (lexer.getToken() == 41) 
          {
            return true;
          } else 
          {
            return false;
          }
        } else 
        {
          return false;
        }
      } else if (ifexpr()) 
      {
        return true;
      } else if (lexer.getToken() == 1009) 
      {
        lexer.advance();
        if (lexer.getToken() == 40) 
        {
          lexer.advance();
          if (expr()) 
          {
            lexer.advance();
            if (lexer.getToken() == 41) 
            {
              return true;
            } else 
            {
              return false;
            }
          } else 
          {
            return false;
          }
        } else 
        { 
          return false;
        }
      }
    } catch (Exception e) 
    {
      
    }
    return false;
  }

  private static boolean opname() 
  {
    System.out.println("in opname");
    try 
    {
      if (lexer.getToken() == (1101 | 1102 | 1103 | 1104 | 1105 | 1106 | 1107)) 
      {
        return true;
      } else 
      {
        return false;
      }
    } catch (Exception e) 
    {
    }
    return false;
  }

  private static boolean ifexpr() 
  {
    System.out.println("in ifexpr");
    try 
    {
      if (lexer.getToken() == 1001) 
      {
        lexer.advance();
        if (lexer.getToken() == 40) 
        {
          lexer.advance();
          if (expr()) 
          {
            lexer.advance();
            if (lexer.getToken() == 41) 
            {
              lexer.advance();
              if (body()) 
              {
                lexer.advance();
                if (elsepart()) 
                {
                  return true;
                } else 
                {
                  return false;
                } 
              } else 
              {
                return false;
              }
            } else 
            {
              return false;
            }
          } else 
          {
            return false;
          }

        } else 
        {
          return false;
        }
      } else 
      {
        return false;
      }
    } catch (Exception e) 
    {

    }
    return false;
  }

  private static boolean elsepart() 
  {
    System.out.println("in elsepart");
    try 
    {
      if (lexer.getToken() == ELSE) 
      {
        lexer.advance();
        if (body()) 
        {
          return true;
        } else 
        {
          return false;
        }
      } else if (lexer.getToken() == ELSIF) 
      { 
        lexer.advance();
        if (lexer.getToken() == 40) 
        {
          lexer.advance();
          if (expr()) 
          {
            lexer.advance();
            if (lexer.getToken() == 41) 
            {
              lexer.advance();
              if (body()) 
              {
                lexer.advance();
                if (elsepart()) 
                {
                  return true;
                } else 
                {
                  return false;
                }
              } else 
              {
                return false;
              }
            } else 
            {  
              return false;
            }
          } else 
          {
            return false;
          }
        } else 
        {
          return false;
        }
      } else 
      {
        return true;
      }

    } catch (Exception e) 
    {
    }
    return true;
  }

  private static boolean body() 
  {
    System.out.println("in body");
    try 
    {
      if (lexer.getToken() == 123) 
      {
        lexer.advance();
        if (expr()) 
        {
          lexer.advance();
          if (lexer.getToken() == 59) 
          {
            lexer.advance();
            if (lexer.getToken() == 125) 
            {
              return true;
            } else 
            {
              return false;
            }
          } else 
          {
            return false;
          }
        } else 
        {
          return false;
        }
      } else 
      {
        return false;
      }
    } catch (Exception e) 
    {
    }
    return false;
  }
}