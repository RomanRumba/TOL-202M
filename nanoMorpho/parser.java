package nanoMorpho;

import nanoMorpho.*;
import java.io.*;

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


public class parser
{

    private static NanoMorpho lexer;


    public static Object[] program()
    {
        return new Object[]{function()};
    }

    public static Object[] function()
    {
        String name = lexer.getLexeme();

        return new Object[] {name,'(', new Object[]{name,new Object[]{',',name}},')'};
    }



    // Usage: Object[] code = binopexpr(k);
    // Pre:   The lexer is positioned at the beginning
    //        of a binopexpr with priority k.
    //        1 <= k <= 8.
    //        Note that a binopexpr with priority 8 is
    //        considered to be a smallexpr.
    // Post:  The compiler has advanced over the
    //        binopexpr with priority k and code now
    //        contains the intermediate code for that
    //        expression.
    // Note:  If an error occurs we may either write
    //        an error message and stop the program or
    //        we might throw an Error("...") and let
    //        the catcher of the Error write the error
    //        message.
    public static Object[] binopexpr( int k )
    {
        //if( k == 8 ) return smallexpr();

        Object[] res = binopexpr(k+1);
        
        // Handle right associative binary operators
        if( k == 2 )
        {
            if( !isOp(lexer.getToken(),k) ) return res;
            String name = lexer.getLexeme();
            lexer.advance();
            Object[] right = binopexpr(k);
            return new Object[]{"CALL",name,new Object[]{res,right}};
        }

        // Handle left associative binary operators
        while( isOp(lexer.getToken(),k) )
        {
            String name = lexer.getLexeme();
            lexer.advance();
            Object[] right = binopexpr(k+1);
            res = new Object[]{"CALL",name,new Object[]{res,right}};
        }
        return res;
    }

    // Usage: boolean b = isOp(tok,k);
    // Pre:   tok is a token, 1<=k<=7.
    // Post:  b is true if and only if tok
    //        is a token which can be a
    //        binary operation of priority
    //        k.
    public static boolean isOp( int tok, int k )
    {
        switch( tok )
        {
        case OPNAME1:	return k==1;
        case OPNAME2:	return k==2;
        case OPNAME3:	return k==3;
        case OPNAME4:	return k==4;
        case OPNAME5:	return k==5;
        case OPNAME6:	return k==6;
        case OPNAME7:	return k==7;
        default:		return false;
        }
    }
}