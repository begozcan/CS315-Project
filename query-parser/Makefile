CC     = g++
CXX    = g++
LEX    = flex
YACC   = bison -y
YFLAGS = -d
PROGRAM = query_parser

OBJECTS = $(PROGRAM).o scan.o parse.o

all: $(PROGRAM)

$(PROGRAM): $(OBJECTS)
scan.o: scan.l parse.c
parse.o: parse.y
$(PROGRAM).o: $(PROGRAM).cpp

clean:
	-rm -f $(OBJECTS)
	-rm -f y.tab.h
	-rm -f parse.c
	-rm -f $(PROGRAM)
