
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
    

    public void main(String[] args) {
        
    }

    public void generateProgram(String filename, Object[] funs)
    {
        String programname = filename.substring(0,filename.indexOf('.'));
        System.out.println("\""+programname+".mexe\" = main in");
        System.out.println("!");
        System.out.println("{{");
        for(int i = 0; i < funs.length; i++){
            System.out.println("------------------------");
            System.out.println("Name of function: "+(String)((Object[])funs[i])[0]);
            System.out.println("Nr of arguments: "+(int)((Object[])funs[i])[1]);
            System.out.println("Nr of variables: "+((int)((Object[])funs[i])[2] - (int)((Object[])funs[i])[1]));
            System.out.println("Nr of expressions: "+((Object[])((Object[])funs[i])[3]).length );
            System.out.println("------------------------");    
        }
        System.out.println("}}");
        System.out.println("*");
        System.out.println("BASIS;");
    }
}