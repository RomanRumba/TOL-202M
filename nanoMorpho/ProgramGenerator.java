
public class ProgramGenerator
{
    /*
        ["RETURN",expr]
        ["STORE",pos,expr]
        ["OR",expr,expr]
        ["AND",expr,expr]
        ["NOT",expr]
        ["CALL",name,args]
        ["FETCH",pos]
        ["LITERAL",string]
        ["IF",expr,expr,expr]
        ["WHILE",expr,expr]
        ["BODY",exprs]
    */
    public final static String EXPRESSION_RETURN = "RETURN";
    public final static String EXPRESSION_STORE = "STORE";
    public final static String EXPRESSION_OR = "OR";
    public final static String EXPRESSION_AND = "AND";
    public final static String EXPRESSION_NOT = "NOT";
    public final static String EXPRESSION_CALL = "CALL";
    public final static String EXPRESSION_FETCH = "FETCH";
    public final static String EXPRESSION_LITERAL = "LITERAL";
    public final static String EXPRESSION_IF = "IF";
    public final static String EXPRESSION_WHILE = "WHILE";
    public final static String EXPRESSION_BODY = "BODY";
    
    /*
        We need some types of unique labels to jump to in our generated code
        the easiest and most simple one is auto incremented integers with '_' prefix
        _1, _2, _3 ... 
     */
    private static int nextLabel = 1;


    public void main(String[] args) {
        
    }

    /*
       Just to avoid writing System.out.println(line); 10 quintillion times
       we create a function with a small name that prints out whatever we need.
    */ 
	private static void emit(String line )
	{
		System.out.println(line);
    }
    
    /*
        Usage: newLabel
          For: nothing
        After: Returns nextLabel integer value and increments it by 1.
     */
	private static int newLabel()
	{
		return nextLabel++;
    }
    
    public void generateProgram(String filename, Object[] funs)
    {
        String programname = filename.substring(0,filename.indexOf('.'));
        System.out.println("\""+programname+".mexe\" = main in");
        System.out.println("!");
        System.out.println("{{");
        for(int i = 0; i < funs.length; i++){
            generateFunction((Object[])funs[i]);
        }
        System.out.println("}}");
        System.out.println("*");
        System.out.println("BASIS;");
    }

    private void generateFunction(Object[] f)
    {
        // f = {fname, argcount, varcount ,exprs}
        /*
            Example of the desired result

            This:
                f = fun(x1 ,..., xN)
                {
                   var y1=g1 ,..., yM=gM;
                    s1;
                    ...
                    sP;
                };
            Translates to this:
                #"f [fN]" =
                    [
                        Þ[g1]
                        (Push)
                        ...
                        Þ[gM]
                        (Push)
                        Þ[s1]
                        ...
                        Þ[sP]
                        (Return)
                    ]
        */
        String fname = (String)f[0];
        int argCount = (Integer)f[1];
        int varCount = (Integer)f[2];
		emit("#\""+fname+"[f"+argCount+"]\" =");
        emit("[");
        for (Object expr : (Object[])f[3])
        {
            generateExpr((Object[])expr);
        }
        emit("(Return)");
		emit("];");
    }

    private void generateExpr(Object[] expr)
    {
           switch ((String)((Object[])expr)[0])
           {
              case EXPRESSION_RETURN: // Dont know if return should be here
                //["RETURN",expr]
                generateExprP((Object[])((Object[])expr)[1]);
                emit("(Return)");
                break;
              case EXPRESSION_CALL:
                //["CALL",name,args]
                Object[] args = (Object[])((Object[])expr)[2];
                int i;
                for(i=0; i != args.length; i++)
                {
                    if(i==0)
                    {
                        generateExpr((Object[])args[i]);
                    }
                    else
                    {
                        generateExprP((Object[])args[i]);
                    }
                }
                
                emit("(Call #\""+(String)((Object[])expr)[1]+"[f"+i+"]\" "+i+")");
                break;
              case EXPRESSION_FETCH:
                //["FETCH",pos]
                emit("(Fetch "+(int)((Object[])expr)[1]+")");
                break;
              case EXPRESSION_LITERAL:
                //["LITERAL",string]
                emit("(MakeVal "+(String)((Object[])expr)[1]+")");
                break;
              case EXPRESSION_IF:
                //["IF",expr,expr,expr]
                 break;
              case EXPRESSION_WHILE:
                //["WHILE",expr,expr]
                 break;
              case EXPRESSION_STORE:
                //["STORE",pos,expr]
                generateExprP((Object[])((Object[])expr)[2]);
                emit("(Store "+(int)((Object[])expr)[1]+")");
                break;
              default:
                throw new Error("Unknown intermediate code type: \""+(String)((Object[])expr)[0]+"\"");
           }
        
    }

    private void generateExprP(Object[] expr)
    {
        switch ((String)((Object[])expr)[0])
        {
            case EXPRESSION_RETURN:
                //["RETURN",expr]
                break;
            case EXPRESSION_STORE:
                //["STORE",pos,expr]
                break;
            case EXPRESSION_OR:
                //["OR",expr,expr]
                break;
            case EXPRESSION_AND:
                //["AND",expr,expr]
                break;
            case EXPRESSION_NOT:
                //["NOT",expr]
                break;
            case EXPRESSION_CALL:
                Object[] args = (Object[])((Object[])expr)[2];
                int i;
                for(i=0; i != args.length; i++)
                {
                    generateExprP((Object[])args[i]);
                }
                if( i==0 )
                { 
                    emit("(Push)");
                }
                emit("(Call #\""+(String)((Object[])expr)[1]+"[f"+i+"]\" "+i+")");
                break;
            case EXPRESSION_FETCH:
                //["FETCH",pos]
                emit("(FetchP "+(int)((Object[])expr)[1]+")");
                break;
            case EXPRESSION_LITERAL:
                //["LITERAL",string]
                emit("(MakeValP "+(String)((Object[])expr)[1]+")");
                break;
            case EXPRESSION_IF:
                //["IF",expr,expr,expr]
                break;
            case EXPRESSION_WHILE:
                //["WHILE",expr,expr]
                 break;
            case EXPRESSION_BODY:
                //["BODY",exprs]
                break;
            default:
               break;
		}
    }
}