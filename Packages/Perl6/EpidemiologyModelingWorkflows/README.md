# Epidemiology Modeling Workflows

## In brief

This Raku Perl 6 package has grammar classes and action classes for the parsing and
interpretation of spoken commands that specify epidemiology modeling workflows.

It is envisioned that the interpreters (actions) are going to target different
programming languages: R, WL, Python, etc.

In the first version(s) the workflows targeted are
Epidemiology Compartmental Modeling workflows, \[AAr1, AAr2\].

## Installation

**1.** Install Raku (Perl 6) : https://raku.org/downloads . 

**2.** Install Zef Module Installer : https://github.com/ugexe/zef .

**3.** Open a command line program. (E.g. Terminal on Mac OS X.)

**4.** Download or clone this repository,
[ConversationalAgents at GitHub](https://github.com/antononcube/ConversationalAgents). E.g.

```
git clone https://github.com/antononcube/ConversationalAgents.git
```

**5.** Go to the directory "ConversationalAgents/Packages/Perl6/EpidemiologyModelingWorkflows". E.g.

```
cd ConversationalAgents/Packages/Perl6/EpidemiologyModelingWorkflows
```

**6.** Execute the command:
 
```
zef install . --force-install --force-test
```

## Examples

Change the 'use' line with the proper location of the package.

```raku
use EpidemiologyModelingWorkflows;

say to_ECMMon_R('
     create with SEI2HR;
     assign 100000 to total population;
     set infected normally symptomatic population to be 0;
     set infected severely symptomatic population to be 1;
     assign 0.56 to contact rate of infected normally symptomatic population;
     assign 0.58 to contact rate of infected severely symptomatic population;
     assign 0.1 to contact rate of the hospitalized population;
     simulate for 240 days;
     plot results;
');
```

The command above should print out code of `ECMMon-R` :

```r
ECMMonUnit( model = SEI2HRModel()) %>%
ECMMonAssignInitialConditions( initConds = c(TPt = 100000) ) %>%
ECMMonAssignInitialConditions( initConds = c(INSPt = 0) ) %>%
ECMMonAssignInitialConditions( initConds = c(ISSPt = 1) ) %>%
ECMMonAssignRateValues( rateValues = c(contactRateINSP = 0.56) ) %>%
ECMMonAssignRateValues( rateValues = c(contactRateISSP = 0.58) ) %>%
ECMMonAssignRateValues( rateValues = c(contactRateHP = 0.1) ) %>%
ECMMonSimulate(maxTime = 240) %>%
ECMMonPlotSolutions()
```

## References 

\[AAr1\] Anton Antonov, 
[Coronavirus-propagation-dynamics](../../Projects/Coronavirus-propagation-dynamics), 
(2020),
[SystemModeling at GitHub](https://github.com/antononcube/SystemModeling).
 
\[AAr2\] Anton Antonov, 
[Epidemiology Compartmental Modeling Monad in R](https://github.com/antononcube/ECMMon-R), 
(2020),
[ECMMon-R at GitHub](https://github.com/antononcube/ECMMon-R). 
 