# Code

## Installations

For the 20% of the hands-on workshop activities you have to have installed at least one 
of the language-IDE-library combinations below.

### Java: ANTLR

My original intentions were to use 
[ANTLR](http://www.antlr.org)
to show production level specifying and generating of parsers.

For the purposes of this workshop I think it is better to use 
[Perl6](https://perl6.org)
.

### R and RStudtio

1. Download and install R from 
[https://www.r-project.org](https://www.r-project.org)
.

   - Choose downloads from here: https://cran.r-project.org/mirrors.html . 
   
2. Download and install the 
[RStudio IDE](https://www.rstudio.com/products/rstudio/download/)
.

3. Here is the source code that allows functional parsers programming in R:
[FunctionalParsers.R](https://github.com/antononcube/MathematicaForPrediction/blob/master/R/FunctionalParsers/FunctionalParsers.R)
.

> I would rather user R than Python. 
  At this point, though, in R I use parsers generated with Perl6. 

### Perl6

You can follow the installation instructions in
["Perl 6 Introduction"](https://perl6intro.com/#_installing_perl_6)
, or can follow the steps below.

Here is a short version of those instructions:

1. Install [Rakudo Star](https://rakudo.org/files/) for your OS.
 
   - *(The most faithful Perl6 compiler targeting JVM.)* 
 
2. Install the editor [Atom](https://atom.io).

3. From within Atom install the Atom package 
[language-perl6](https://atom.io/packages/language-perl6)
.

4. Review the steps in
["Perl 6 Introduction"](https://perl6intro.com/#_installing_perl_6)
.

My motivation for using Perl 6 is that:
 
> Grammar parsers programming and generation is baked-in.

### Python: Lark

You most likely have Python installed on your OS. 
(Otherwise figure out how to do it.) 

Follow the installation instructions in the 
[Lark library GitHub repository](https://github.com/lark-parser/lark).

I plan to use Python very little in the workshop through the Atom editor.

My motivation to use the Lark library is given in the first paragraphs of this 
[README.md](/https://github.com/lark-parser/lark/blob/master/README.md) file:

> Parse any context-free grammar, FAST and EASY!
   
> Beginners: Lark is not just another parser. It can parse any grammar you throw at it, no matter how complicated or ambiguous, and do so efficiently. It also constructs a parse-tree for you, without additional code on your part.
   
> Experts: Lark lets you choose between Earley and LALR(1), to trade-off power and speed. It also contains a CYK parser and unique features such as a contextual-lexer.
   
>   Lark can:
   
>   Parse all context-free grammars, and handle all ambiguity
   Build a parse-tree automagically, no construction code required
   Outperform all other Python libraries when using LALR(1) (Yes, including PLY)
   Run on every Python interpreter (it's pure-python)
   Generate a stand-alone parser (for LALR(1) grammars)
   
### Wolfram Language (Mathematica)

This is very optional.

1. Download and install Wolfram Mathematica from this 
[page](http://www.wolfram.com/mathematica/?source=nav)
.

2. Here is the package that allows functional parsers programming in WL / Mathematica:
[FunctionalParsers.m](https://github.com/antononcube/MathematicaForPrediction/blob/master/FunctionalParsers.m)
.

> In my opinion Mathematica is the best system for doing Artificial Intelligence. 
(And yes, I am a very biased power user of Mathematica and a former kernel developer at Wolfram Reserch, Inc.)