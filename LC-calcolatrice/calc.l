%%

%byaccj

%{
  private Parser yyparser;

  public Yylex(java.io.Reader r, Parser yyparser) {
    this(r);
    this.yyparser = yyparser;
  }
%}

NUM = [0-9]+ ("." [0-9]+)?
NL  = \n | \r | \r\n
LOG10 = ("log10" | "LOG10")
LN = ("ln" | "LN")

%%

/* operators */
"+" | 
"-" | 
"*" | 
"/" | 
"^" | 
"%" |
"(" | 
")"   { return (int) yycharat(0); }

/* newline */
{NL}   { return Parser.NL; }

/* float */
{NUM}  { yyparser.yylval = new ParserVal(yytext());
         return Parser.NUM; }

{LOG10} { return Parser.LOG10; }

{LN} { return Parser.LN; }

/* whitespace */
[ \t]+ { }

\b     { System.err.println("Sorry, backspace doesn't work"); }

/* error fallback */
[^]    { System.err.println("Error: unexpected character '"+yytext()+"'"); return -1; }
