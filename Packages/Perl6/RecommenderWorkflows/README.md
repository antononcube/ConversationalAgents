# Recommender Workflows

## In brief

This Raku Perl 6 package has grammar classes and action classes for the parsing and
interpretation of spoken commands that specify recommendation system workflows.

It is envisioned that the interpreters (actions) are going to target different
programming languages: R, Mathematica, Python, etc.

In the first version(s) the recommender workflows targeted are
Sparse Matrix Recommender (SMR) workflows.

## Examples

Change the 'use' line with the proper location of the package.

    #use lib './lib';
    use RecommenderWorkflows;

    say to_SMRMon_R("recommend with history id.2 : 3 and id.13 : 4");
