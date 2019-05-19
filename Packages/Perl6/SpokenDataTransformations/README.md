# Spoken data transformations

...*aka* **"Spoken dplyr commands"** 

## In brief

This Raku Perl 6 package has grammar classes and action classes for the parsing and
interpretation of spoken command that specify data transformations as described and
implemented in the R/RStudio library [dplyr](https://dplyr.tidyverse.org).

It is envisioned that the interpreters (actions) are going to target different
programming languages: R, Mathematica, Python, etc.

## Examples

Change the 'use' line with the proper location of the package.

    #use lib './lib';
    use SpokenDataTransformations;

    say to_dplyr("select mass & height");
    # dplyr::select(mass, height) 
    
    say to_dplyr("select mass & height; mutate mass1 = mass; arrange by the variable mass & height descending");
    # dplyr::select(mass, height) %>% dplyr::mutate(mass1 = mass) %>% dplyr::arrange(desc(mass, height))



