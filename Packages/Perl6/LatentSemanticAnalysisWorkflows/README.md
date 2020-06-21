# Latent Semantic Analysis Workflows 

## In brief

This Raku Perl 6 package has grammar classes and action classes for the parsing and
interpretation of spoken commands that specify Latent Semantic Analysis (LSA) workflows.

It is envisioned that the interpreters (actions) are going to target different
programming languages: R, Mathematica, Python, etc.

The generated pipelines are for the software monads 
[`LSAMon-R`](https://github.com/antononcube/R-packages/tree/master/LSAMon-R) 
and
[`LSAMon-WL`](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicLatentSemanticAnalysis.m),
\[AA1, AA2\].

## Installation

**1.** Install Raku (Perl 6) : https://raku.org/downloads . 

**2.** Install Zef Module Installer : https://github.com/ugexe/zef .

**3.** Open a command line program. (E.g. Terminal on Mac OS X.)

**4.** Download or clone this repository,
[ConversationalAgents at GitHub](https://github.com/antononcube/ConversationalAgents). E.g.

```
git clone https://github.com/antononcube/ConversationalAgents.git
```

**5.** Go to the directory "ConversationalAgents/Packages/Perl6/LatentSemanticAnalysisWorkflows". E.g.

```
cd ConversationalAgents/Packages/Perl6/LatentSemanticAnalysisWorkflows
```

**6.** Execute the command:
 
```
zef install . --force-install --force-test
```

## Examples

Open a Raku IDE or type `raku` in the command line program. Try this Raku code:

```raku
use LatentSemanticAnalysisWorkflows;

say to_LSAMon_R("extract 12 topics using method NNMF and max steps 12");
# LSAMonExtractTopics( numberOfTopics = 12, method = "NNMF",  maxSteps = 12)
``` 
    
Here is a more complicated pipeline specification:

```raku
say to_LSAMon_R(
  "create from textHamlet;
   make document term matrix with stemming FALSE and automatic stop words;
   apply LSI functions global weight function IDF, local term weight function TermFrequency, normalizer function Cosine;
   extract 12 topics using method NNMF and max steps 12 and 20 min number of documents per term;
   show topics table with 12 terms;
   show thesaurus table for king, castle, denmark;")
```

The command above should print out R code for the R package `LSAMon-R`, \[AA1\]:

```r
LSAMonUnit(textHamlet) %>%
LSAMonMakeDocumentTermMatrix( stemWordsQ = FALSE, stopWords = NULL) %>%
LSAMonApplyTermWeightFunctions(globalWeightFunction = "IDF", localWeightFunction = "None", normalizerFunction = "Cosine") %>%
LSAMonExtractTopics( numberOfTopics = 12, method = "NNMF",  maxSteps = 12, minNumberOfDocumentsPerTerm = 20) %>%
LSAMonEchoTopicsTable(numberOfTerms = 12) %>%
LSAMonEchoStatisticalThesaurus( words = c("king", "castle", "denmark"))
```    

## References

\[AA1\] Anton Antonov,
[Latent Semantic Analysis Monad in R](https://github.com/antononcube/R-packages/tree/master/LSAMon-R),
(2019),
[R-packages at GitHub](https://github.com/antononcube/R-packages).

\[AA2\] Anton Antonov,
[Monadic Latent Semantic Analysis Mathematica package](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicLatentSemanticAnalysis.m),
(2017),
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction).

