# Data Query Workflows 

***This Raku package directory is obsolete.***

***The package was moved to:*** https://github.com/antononcube/Raku-DSL-English-DataQueryWorkflows .

## In brief

This Raku (Perl 6) package has grammar and action classes for the parsing and
interpretation of natural language commands that specify data queries in the style of
Standard Query Language (SQL) or 
[RStudio](https://rstudio.com)'s
library [`dplyr`](https://dplyr.tidyverse.org).

It is envisioned that the interpreters (actions) are going to target different
programming languages: Python, SQL, R, WL, or others.

## Examples

Change the 'use' line with the proper location of the package.

    use DataQueryWorkflows;

    say ToDataQueryWorkflowCode('select mass & height', 'R-dplyr');
    
    # dplyr::select(mass, height) 
    
    #------
    
    ToDataQueryWorkflowCode('
      use starwars;
      select mass & height; 
      mutate bmi = mass/height^2; 
      arrange by the variable bmi descending;
    ', 'R-dplyr');

    # starwars %>%
    # dplyr::select(mass, height) %>%
    # dplyr::mutate(bmi = mass/height^2) %>%
    # dplyr::arrange(desc(bmi))
    

## On naming of translation packages

WL has a `System` context where usually the built-in functions reside. WL adepts know this, but not that much the rest.
(All WL packages provide a context for their functions.)

The thing is that my naming convention for the translation files so far is `<programming language>::<package name>`.
And I do not want to break that invariant.

Knowing the package is not essential when invoking the functions. 
For example `ToDataQueryWorkflowCode[_,"R"]` produces same results as `ToDataQueryWorkflowCode[_,"R-base"]`, etc.