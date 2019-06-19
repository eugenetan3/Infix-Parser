
%{
    #define YYSTYPE double
    #include <math.h>
%}

%token NUM
%left '-' '+'
%left '*' '/'
%left NEG
%right '^'

%%
input:      /* empty string */
        | input line
;

line:       '\n'
        | exp '\n'  { printf ("%.10g\n", $1); }
;

exp:        NUM             { $$ = $1;         }
        | exp '+' exp       { $$ = $1 + $3;    }
        | exp '-' exp       { $$ = $1 - $3;    }
        | exp '*' exp       { $$ = $1 * $3;    }
        | exp '/' exp       { $$ = $1 / $3;    }
        | '-' exp %prec NEG { $$ = -$2;        }
        | '(' exp ')'       { $$ = $2;         }
;
%%

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>

yylex() {
    int c;

    while ((c = getchar()) == ' ' || c == '\t');

    if (c == '.' || isdigit(c)) {
        ungetc(c, stdin);
        scanf("%lf", &yylval);
        return NUM;
    }

    if (c == EOF) {
        return 0;
    }
    return c;
}

main() {
    yyparse();
}

yyerror (s)
    char *s;
{
    printf("%s\n", s);
}
