;;; Bunch of tests that were obtained from the morpho workbench
;;; Note : since this is nanoMorpho some things had to be modified to work here

;;; TESTS :
;;; - variable assignment (in different orders)
;;; - printing out string variables
;;; - changing the value of an already assigned variable
;;; - String concatenation of strings and string variables
string_Tests()
{
	var x,y;
	y = " Hi Back at you";
	x = "Hello world";	
	writeln(x);			
	x = "Hello again";			
	writeln(x);	
	
	writeln("ABC"++"DEF");
	writeln(x++y);
	newLine();
}

;;; TESTS :
;;; - variable assignment
;;; - Adding integers and variables 
;;; - concatenation of string and integers
;;; - floating point math 
math_Tests()
{
	var a,b,c;
	a = 1;
	b = 2;
	c = 3;
	writeln("Adding integers " ++ (1+2+3));
	writeln("Adding variables " ++ (a+b+c));
	writeln(1.0+2.0+3.0);
	writeln(1.0+2.0+3.0+1.0/3.0);
	newLine();
}

;;; TESTS :
;;; - variable assignment
;;; - creating list with integers and null 
;;; - creating list with integers
;;; - creating list with strings
;;; - creating list from from variable values
;;; - creating list from functions that return values 
list_Tests()
{
	var x,y,z,m;
	y = 1;
	x = 2;
	writeln(1:2+3*(4+5):null);
	writeln(1:null);
	writeln(1:2:3);
	writeln(y:2);
	writeln(y:x);
	writeln(head(y:x));
	writeln(tail(y:x));
	writeln(head(y:x):tail(y:x));
	z = "a";
	m = "b";
	writeln("a":"b");
	writeln(z:m);
	writeln(head(z:m));
	writeln(tail(z:m));
	writeln(head(z:m):tail(z:m));
	newLine();
}


newLine()
{
	writeln("");
}

main()
{
	string_Tests();
	math_Tests();
	list_Tests();
}