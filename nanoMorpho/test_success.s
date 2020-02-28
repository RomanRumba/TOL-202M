;;; Comment
;;; Comment
;;; Comment
realworldtest(arg) {
  ;;; 2 variables to store values in
  var variable1, variable2;
  
  if(arg == 1)
  {
	variable1 = 1;
	variable2 = variable1 * 10;
  }
  elsif(arg == 2)
  {
    variable1 = 2;
	variable2 = variable1 * 10;
  }
  else
  {
    return false;
  };
  
  while(variable2 > variable1)
  {
	variable1 = (variable1 * 2) + variable2;
	variable2 = variable2 - 1;
  };
  
  return variable1;
}
fibo(n)
{
	var i,f1,f2,tmp;
	f1 = 1;
	f2 = 1;
	i = 0;
	while( i!=n )
	{
		tmp = f1+f2;
		f1 = f2;
		f2 = tmp;
		i = i+1;
	};
	f1;
}

f(n)
{
	if( n<2 )
	{
		1;
	}
	else
	{
		f(n-1)| f(n-2);
	};
}

main()
{
	writeln(1:2:3:null);
	writeln("fibo(35)="++fibo(35));
	writeln("fibo(35)="++f(35));
}









