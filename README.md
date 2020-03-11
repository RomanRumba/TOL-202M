# TÖL-202M Þýðendur

## Verkefni 4 - Assigned: 03.06.2020 Due: 03.27.2020
Bottom-up compiler. Counts three steps. The compiler should parse, generate intermediate code and then generare final code so there are three steps being performed and each may get a separate grade, but more likely they all get the same grade.

## Verkefni 3 - Assigned: 02.21.2020 Due: 03.06.2020
Code generator. Counts two steps. Estimated two weeks. The code generator contains both an intermediate code
generator and a final code generator. Note that the final code generator can be reused
in the later compiler. Separate grades may be given for the intermediate code generator
and the final code generator, as described in weekly 1, but more likely the two steps get
the same grade. The intermediate code generator is embedded in the parser whereas the
final code generator can be a separate class, if desired.

Snorri said its okay to to return this all in one file we don't need to seperate it.

## Verkefni 2 - Assigned: 02.07.2020 Due: 02.21.2020
Create a Top-down parser. The parser needs only recognize input that is syntactically correct and show
appropriate error messages for inputs that are grammatically incorrect.

We need to add to our scanner %line %colum so we could keep track of our line number and colum number and
implement functions that keep track of the current line/colum numbers and next line/colum numbers.


## Verkefni 1 - Assigned: 01.23.2020 Due: 02.07.2020
Create a scanner. Estimated two weeks. The scanner should be turned in on February 7th. The
scanner should only read a text file and write out a sequence of tokens and lexemes, one
pair per line. Note that the scanner will be used in two different compilers, probably with
minor changes in between, such as adding new keywords. I suggest that the language
used for the first compiler be NanoMorpho, as described in markmid.pdf. You will
also want to define the format of comments in your language.

Málrit fyrir NanoMorpho er i kafla 10.3 markmid.pdf

