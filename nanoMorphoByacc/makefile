NanoMorpho.java:
	java -jar jflex-full-1.7.0.jar nanoMorpho.jflex

NanoMorphoParser.java NanoMorphoParserVal.java:
	./byacc -Jclass=NanoMorphoParser nanoMorpho.byaccj

NanoMorphoParser.class NanoMorphoLexer.class NanoMorphoParserVal.class:
	javac NanoMorphoParser.java NanoMorphoLexer.java NanoMorphoParserVal.java

test:
	java NanoMorphoParser test_success.s

clean:
	rm -rf *.class *~ *.java *.bak yacc.*