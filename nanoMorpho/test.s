writeln([1]);
writeln(1:[]);
writeln([1$null]);
writeln(1:[]);
writeln(["a",3]);
writeln("a":[3]);
writeln(["a",3$null]);
writeln("a":[3]);
writeln(["a",3$null]);

startMachine(
	fun()
	{
		var i;
		for( i=0 ; i!=10 ; i=inc(i) )
		{
			sleep(1.0);
			writeln(i);
		};
	}
);