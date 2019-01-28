# Quantile Regression Workflows 

## In brief

This Raku Perl 6 package has grammar classes and action classes for the parsing and
interpretation of spoken commands that specify Quantile Regression workflows.

It is envisioned that the interpreters (actions) are going to target different
programming languages: R, Mathematica, Python, etc.

## Examples

Change the 'use' line with the proper location of the package.

    #use lib './lib';
    use QuantileRegressionWorkflows;

    say to_QRMon("quantile regression with 12 degrees of freedom over the quantile 0.25, 0.5 and 0.75");
    # QRMonQuantileRegression( df = 12, quantiles = c(0.25, 0.5, 0.75) ) 
    
    


