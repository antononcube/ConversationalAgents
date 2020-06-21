# Quantile Regression Workflows 

## In brief

This Raku Perl 6 package has grammar classes and action classes for the parsing and
interpretation of spoken commands that specify Quantile Regression (QR) workflows.

It is envisioned that the interpreters (actions) are going to target different
programming languages: R, Mathematica, Python, etc.

The generated pipelines are for the software monads 
[`QRMon-R`](https://github.com/antononcube/QRMon-R) 
and
[`QRMon-WL`](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicQuantileRegression.m),
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

**5.** Go to the directory "ConversationalAgents/Packages/Perl6/QuantileRegressionWorkflows". E.g.

```
cd ConversationalAgents/Packages/Perl6/QuantileRegressionWorkflows
```

**6.** Execute the command:
 
```
zef install . --force-install --force-test
```

## Examples

Open a Raku IDE or type `raku` in the command line program. Try this Raku code:

```raku
use QuantileRegressionWorkflows;

say to_QRMon_R("compute quantile regression with 16 knots and probabilities 0.25, 0.5 and 0.75");
# QRMonQuantileRegression(df = 16, probabilities = c(0.25, 0.5, 0.75))
``` 
    
Here is a more complicated pipeline specification:

```raku
say to_QRMon_R(
    "create from dfTemperatureData;
     compute quantile regression with 16 knots and probability 0.5;
     show date list plot with date origin 1900-01-01;
     show absolute errors plot;
     echo text anomalies finding follows;
     find anomalies by the threshold 5;
     take pipeline value;")
```

The command above should print out R code for the R package `QRMon-R`, \[AA1\]:

```r
QRMonUnit( data = dfTemperatureData) %>%
QRMonQuantileRegression(df = 16, probabilities = c(0.5)) %>%
QRMonPlot( datePlotQ = TRUE, dateOrigin = '1900-01-01') %>%
QRMonErrorsPlot( relativeErrorsQ = FALSE) %>%
QRMonEcho( "anomalies finding follows" ) %>%
QRMonFindAnomaliesByResiduals( threshold = 5) %>%
QRMonTakeValue
```    

## References

\[AA1\] Anton Antonov,
[Quantile Regression Monad in R](https://github.com/antononcube/QRMon-R), 
(2019),
[QRMon-R at GitHub](https://github.com/antononcube/QRMon-R).

\[AA2\] Anton Antonov,
[Monadic Quantile Regression Mathematica package](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicQuantileRegression.m), 
(2018),
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction).
