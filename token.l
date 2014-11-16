%{
/**
 * @File token.l
 * Flex file: produce calculator scanner.
 * @Author Jiewei Wei
 * @Student ID 12330318
 * @Mail weijieweijerry@163.com
 * @Github https://github.com/JieweiWei
 * @Date 2014.11.12
 *
 */

  #include "calculator.tab.h"
%}
%option noyywrap
%option yylineno

%%

[0-9]+ {
  yylval.node.type = "int";
  yylval.node.element = atoi(yytext);
  return NUMBER;
}
"True" {
  yylval.node.type = "bool";
  yylval.node.element = 1;
  return TRUE;
}
"False" {
  yylval.node.type = "bool";
  yylval.node.element = 0;
  return FALSE;
}

"(" { return LP; }
")" { return RP; }

"not" { return NOT; }

"*" { return MUL; }
"/" { return DIV; }
"%" { return MOD; }

"+" { return ADD; }
"-" { return SUB; }

"<<" { return LS; }
">>" { return RS; }

"<" { return LT; }
">" { return GT; }
"<=" { return LE; }
">=" { return GE; }

"!=" { return NE; }
"==" { return EQ; }

"or" { return OR; }
"xor" { return XOR; }
"and" { return AND; }

"?" { return CON; }
":" { return SEL; }

\n { return EOL; }
[ \t] { /* Ingore the whitespace. */ }
. { fprintf(stderr, "Mystery character %c\n", *yytext); }

%%
