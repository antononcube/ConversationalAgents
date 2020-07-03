# Data Query Workflows 

Possible alternative name: *"Spoken dplyr commands"*.  

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

    say to_dplyr("select mass & height");
    # dplyr::select(mass, height) 
    
    say to_dplyr('
      select mass & height; 
      mutate mass1 = mass; 
      arrange descending by the variable mass & height
    ');
    
    # dplyr::select(mass, height) %>% 
    # dplyr::mutate(mass1 = mass) %>% 
    # dplyr::arrange(desc(mass, height))



