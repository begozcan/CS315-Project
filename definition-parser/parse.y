// Declare the tokens
%token LOWERCASE
%token UPPERCASE
%token LETTER
%token DIGIT
%token LPARAN
%token RPARAN
%token LBRACK
%token RBRACK
%token LCURLY
%token RCURLY
%token COMMA
%token COL
%token PERCENT

%token CARET
%token DCARET

%token PP
%token SP

%token NEWLINE

%token INTEGER_TOKEN
%token FLOAT_TOKEN
%token STRING_TOKEN

%token ID

%token ASSIGNMENT
%token INSERT
%token REMOVE

%token LESS
%token GREATER
%token LESSEQUAL
%token GREATEREQUAL
%token EQUAL
%token NOTEQUAL

%token CONCAT
%token ALTER
%token REP

%token ALL
%token NOT

%token INTDECLARATION
%token FLOATDECLARATION
%token STRINGDECLARATION
%token BOOLEANDECLARATION

%token PAIRDECLARATION
%token LISTDECLARATION
%token MAPDECLARATION
%token SETDECLARATION

%token POINTDECLARATION
%token ONEWAYSTREETDECLARATION
%token TWOWAYSTREETDECLARATION

%token ONEWAYSTREETNETWORKDECLARATION
%token TWOWAYSTREETNETWORKDECLARATION

%token FINDROUTE
%token SORT
%token LIMIT

%token LIMITORS

%token BOOLEANTRUE
%token BOOLEANFALSE

%token ERROR_CHAR
%token SETINDICATOR

%union
{
  char * string;
  int integer;
  float fp;
}

%{
    #include <unordered_map>
    #include <iostream>
    using namespace std;
    // forward declarations
    void yyerror(char *);
    int yylex(void);
    // symbol table to hold variable values
    unordered_map<string, int> symbols;
    %}

%%

STMT: { cout << "FINISHED" << endl;} | EXPR NEWLINE STMT | error{cerr << "Error at program level" << endl;}

EXPR: | STREETNETWORK | STREET | POINT | LIST
| SET | MAP | PAIR | INTEGER | FLOAT
| STRING | BOOLEAN | MODIFY
| error{cerr << "Error at expression level" << endl;}

// DECLERATIONS

STREETNETWORK: ONEWAYSTREETNETWORK | TWOWAYSTREETNETWORK

ONEWAYSTREETNETWORK: ONEWAYSTREETNETWORKDECLARATION ID ONEWAYSTREETNETWORKTAIL

TWOWAYSTREETNETWORK: TWOWAYSTREETNETWORKDECLARATION ID TWOWAYSTREETNETWORKTAIL

STREET: ONEWAYSTREET | TWOWAYSTREET

ONEWAYSTREET: ONEWAYSTREETDECLARATION ID ONEWAYSTREETTAIL

TWOWAYSTREET: TWOWAYSTREETDECLARATION ID TWOWAYSTREETTAIL

POINT: POINTDECLARATION ID POINTTAIL

LIST: LISTDECLARATION ID LISTTAIL

SET: SETDECLARATION ID SETTAIL

MAP: MAPDECLARATION ID MAPTAIL

PAIR: PAIRDECLARATION ID PAIRTAIL

INTEGER: INTDECLARATION ID INTTAIL

FLOAT: FLOATDECLARATION ID FLOATTAIL

STRING: STRINGDECLARATION ID STRINGTAIL

BOOLEAN: BOOLEANDECLARATION ID BOOLTAIL

MODIFY: MODIFYHEAD OP DATA

// TAILS

TWOWAYSTREETNETWORKTAIL: | ASSIGNMENT LIST_TOKEN
| error{cerr << "Error at Two Way Street Network Tail level" << endl;};

ONEWAYSTREETNETWORKTAIL: | ASSIGNMENT LIST_TOKEN
| error{cerr << "Error at One Way Street Network Tail level" << endl;};

TWOWAYSTREETTAIL: | ASSIGNMENT MAP_TOKEN
| error{cerr << "Error at Two Way Street Tail level" << endl;};

ONEWAYSTREETTAIL: | ASSIGNMENT MAP_TOKEN
| error{cerr << "Error at One Way Street Tail level" << endl;};

POINTTAIL: | ASSIGNMENT MAP_TOKEN
| error{cerr << "Error at Point Tail level" << endl;};

LISTTAIL: | ASSIGNMENT LIST_TOKEN
| error{cerr << "Error at List Tail level" << endl;};

LIST_TOKEN: LCURLY DATA LISTBODY RCURLY

LISTBODY: | COMMA DATA LISTBODY
| error{cerr << "Error at List Body level" << endl;};

SETTAIL: | ASSIGNMENT SET_TOKEN
| error{cerr << "Error at Set Tail level" << endl;};

SET_TOKEN: SETINDICATOR DATA SETBODY RBRACK

SETBODY: | COMMA DATA SETBODY
| error{cerr << "Error at Set Body level" << endl;};

MAPTAIL: | ASSIGNMENT MAP_TOKEN
| error{cerr << "Error at Map Tail level" << endl;};

MAP_TOKEN: LBRACK PAIR_TOKEN MAPBODY RBRACK | LBRACK ID MAPBODY RBRACK

MAPBODY: | MAPBODY COMMA PAIR_TOKEN | MAPBODY COMMA ID
| error{cerr << "Error at Map Body level" << endl;};

PAIRTAIL: | ASSIGNMENT PAIR_TOKEN
| error{cerr << "Error at Pair Tail level" << endl;};

PAIR_TOKEN: LPARAN DATA COMMA DATA RPARAN

INTTAIL: | ASSIGNMENT INTEGER_TOKEN
| error{cerr << "Error at Integer Tail level" << endl;};

FLOATTAIL: | ASSIGNMENT FLOAT_TOKEN
| error{cerr << "Error at Float Tail level" << endl;};

STRINGTAIL: | ASSIGNMENT STRING_TOKEN
| error{cerr << "Error at String Tail level" << endl;};

BOOLTAIL: | ASSIGNMENT BOOLEANTRUE | ASSIGNMENT BOOLEANFALSE
| error{cerr << "Error at Boolean Tail level" << endl;};

// TERMINALS

DATA: MODIFYHEAD | INTEGER_TOKEN | STRING_TOKEN | FLOAT_TOKEN | BOOLEANTRUE
| BOOLEANFALSE | PAIR_TOKEN | SET_TOKEN | LIST_TOKEN | MAP_TOKEN

MODIFYHEAD: RETRIEVAL | ID
| error{cerr << "Error at Modify Head level" << endl;};

RETRIEVAL: ID LBRACK RETRIEVALBODY RBRACK

RETRIEVALBODY: STRING_TOKEN | INTEGER_TOKEN | INTEGER_TOKEN COL INTEGER_TOKEN
| error{cerr << "Error at Retrival Body level" << endl;};

OP: ASSIGNMENT | REMOVE | INSERT
| error{cerr << "Error at Operator level" << endl;};

%%
// report errors

void yyerror(char *s)
{
    cerr << s << endl;
}