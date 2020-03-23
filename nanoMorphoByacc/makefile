NanoMorphoParser.class NanoMorphoLexer.class NanoMorphoParserVal.class: NanoMorphoParser.java NanoMorphoParserVal.java
	@echo ""
	@echo ""
	@echo "Compiling to java"
	javac NanoMorphoParser.java NanoMorphoLexer.java NanoMorphoParserVal.java

clear:
	clear

NanoMorpho.java:
	@echo "Jflex result: "
	java -jar jflex-full-1.7.0.jar nanoMorpho.jflex

NanoMorphoParser.java NanoMorphoParserVal.java: NanoMorpho.java
	@echo ""
	@echo ""
	@echo "Byacc result: "
	byaccj -Jclass=NanoMorphoParser nanoMorpho.byaccj

test: NanoMorphoParser.class NanoMorphoLexer.class NanoMorphoParserVal.class
	@echo ""
	@echo ""
	@echo "Testing parser"
	java NanoMorphoParser test_success.s

Generate_morpho: NanoMorphoParser.class NanoMorphoLexer.class NanoMorphoParserVal.class
	@echo ""
	@echo ""
	@echo "Generating morpho from the test file"
	java NanoMorphoParser test_success.s | java -jar morpho.jar -c

Test_morpho_generated_code: Generate_morpho
	@echo ""
	@echo ""
	@echo "Executing the morpho code"
	java -jar morpho.jar test_success

gen_ava: NanoMorphoParser.class NanoMorphoLexer.class NanoMorphoParserVal.class
	@echo ""
	@echo ""
	@echo "Generating ava7's nanomorpho"
	java NanoMorphoParser ava7.nm | java -jar morpho.jar -c

test_ava: gen_ava
	@echo ""
	@echo ""
	@echo "Testing ava7's nanomorpho"
	java -jar morpho.jar ava7

clean:
	rm -rf *.class *~ *.mexe *.bak yacc.* *.java
