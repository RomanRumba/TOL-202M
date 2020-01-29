NanoMorpho.class: NanoMorpho.java
	javac NanoMorpho.java
NanoMorpho.java: nanomorhpo.jflex
	java -jar jflex-full-1.7.0.jar nanomorhpo.jflex
clean:
	rm -Rf *~ NanoMorpho*.class NanoMorpho.java
test_success: NanoMorpho.class test_success.s
	java NanoMorpho test_success.s
test_fail: NanoMorpho.class test_fail.s
	java NanoMorpho test_fail.s