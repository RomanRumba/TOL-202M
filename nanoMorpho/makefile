NanoMorpho.class: NanoMorpho.java
	javac NanoMorpho.java
NanoMorpho.java: nanomorhpo.jflex
	java -jar jflex-full-1.7.0.jar nanomorhpo.jflex
clean:
	rm -Rf *~ NanoMorpho*.class NanoMorpho.java
test: NanoMorpho.class test.s
	java NanoMorpho test.s