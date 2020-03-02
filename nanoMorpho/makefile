NanoMorpho.java: nanomorhpo.jflex
	java -jar jflex-full-1.7.0.jar nanomorhpo.jflex
NanoMorpho.class: NanoMorpho.java
	javac NanoMorpho.java
clear_all:
	clear
test_success: NanoMorpho.class test_success.s
	java NanoMorpho test_success_basic.s