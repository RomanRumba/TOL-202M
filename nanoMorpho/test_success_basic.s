;;; Comment
;;; Comment
;;; Comment
fibo(n)
{
	var i,f1,f2,tmp;
	i = 0;
	f1 = 1;
	f2 = 1;
	while( i !=n )
	{
		tmp = f1+f2;
		f1 = f2;
		f2 = tmp;
		i = i+1;
	};
	f1;
}
main()
{
   writeln("fibo(35)="++fibo(35));
}
