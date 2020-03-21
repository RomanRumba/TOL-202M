clear:
	clear
	
NanoMorpho.java:
	echo "Jflex result: "
	java -jar jflex-full-1.7.0.jar nanoMorpho.jflex

NanoMorphoParser.java NanoMorphoParserVal.java:
	echo ""
	echo ""
	echo "Byacc result: "
	./byacc -Jclass=NanoMorphoParser nanoMorpho.byaccj


NanoMorphoParser.class NanoMorphoLexer.class NanoMorphoParserVal.class:
	echo ""
	echo ""
	echo "Compiling to java"
	javac NanoMorphoParser.java NanoMorphoLexer.java NanoMorphoParserVal.java

test:
	echo ""
	echo ""
	echo "Testing parser"
	java NanoMorphoParser test_success.s



clean:
	rm -rf *.class *~ *.java *.bak yacc.* *.mexe