%{
/**
 * @File calculator.y
 * Bison file: produce calculator parser.
 * @Author Jiewei Wei
 * @Student ID 12330318
 * @Mail weijieweijerry@163.com
 * @Github https://github.com/JieweiWei
 * @Date 2014.11.12
 *
 */

  #include <stdio.h>
  #include <string.h>

  void yyerror(char const*);
  int yylex(void);
  extern int yylineno;
  void yyrestart (FILE*);
%}

%union {
  struct {
    int element;
    const char* type;
  } node;
}

%right CON SEL
%left OR
%left XOR
%left AND
%left EQ NE
%left LT LE GT GE
%left LS RS
%left ADD SUB
%left MUL DIV MOD
%right NOT
%left LP RP
%type <node> term expr
%token <node> NUMBER TRUE FALSE
%token EOL

%%

statement:
  | statement EOL {}
  | statement expr EOL {
      if (!strcmp($2.type, "int")) {
        printf("%d\n", $2.element);
      } else {
        printf("%s\n", $2.element ? "True" : "False");
      }
    }
  ;

expr: term { $$ = $1; }
  | expr CON expr SEL expr { $$ = $1.element ? $3 : $5; }
  | expr OR expr { $$.type = "bool"; $$.element = $1.element || $3.element; }
  | expr XOR expr { $$.type = "bool"; $$.element = !$1.element && $3.element || $1.element && !$3.element; }
  | expr AND expr { $$.type = "bool"; $$.element = $1.element && $3.element; }
  | expr EQ expr { $$.type = "bool"; $$.element = $1.element == $3.element; }
  | expr NE expr { $$.type = "bool"; $$.element = $1.element != $3.element; }
  | expr LT expr { $$.type = "bool"; $$.element = $1.element < $3.element; }
  | expr LE expr { $$.type = "bool"; $$.element = $1.element <= $3.element; }
  | expr GT expr { $$.type = "bool"; $$.element = $1.element > $3.element; }
  | expr GE expr { $$.type = "bool"; $$.element = $1.element >= $3.element; }
  | expr LS expr { $$.type = "int"; $$.element = $1.element << $3.element;}
  | expr RS expr { $$.type = "int"; $$.element = $1.element >> $3.element;}
  | expr ADD expr { $$.type = "int"; $$.element = $1.element + $3.element; }
  | expr SUB expr { $$.type = "int"; $$.element = $1.element - $3.element; }
  | expr MUL expr { $$.type = "int"; $$.element = $1.element * $3.element; }
  | expr DIV expr {
      if ($3.element != 0) {
        $$.type = "int";
        $$.element = $1.element / $3.element;
      } else {
        yyerror("integer division by zero");
        exit(0);
      }
    }
  | expr MOD expr {
      if ($3.element != 0) {
        $$.type = "int";
        $$.element = $1.element % $3.element;
      } else {
        yyerror("integer modulo by zero");
        exit(0);
      }
    }
  ;

term: NUMBER
 | TRUE
 | FALSE { $$ = $1; }
 | LP expr RP { $$ = $2; }
 | NOT expr { $$.type = $2.type; $$.element = !$2.element; }
 ;

%%

int main(int argc, char **argv) {
  if (argc == 1) {
    yyparse();
  } else {
    for (int i = 1; i < argc; ++i) {
      FILE *f = fopen(argv[i], "r");
      yyrestart(f);
      yyparse();
      fclose(f);
    }
  }
  return 0;
}

void yyerror(char const *s) {
  fprintf(stderr, "Error: %s LN %d\n", s, yylineno);
}
