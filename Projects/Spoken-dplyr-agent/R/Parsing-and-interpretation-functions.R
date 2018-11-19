#---
# Title: Parsing and interpretation functions
# Author: Anton Antonov
# Date: 2018-11-18
#---

##===========================================================
## Parsing and interpretation functions
##===========================================================

## Change the directory names with the correct paths.
## The paths below assume Mac OS X and the GitHub repository ConversationalAgents being 
## in the current user directory.
localUserDirName <- file.path( "/", "Users", Sys.info()["user"])
perl6ParsingLib <- file.path( localUserDirName, "ConversationalAgents", "Packages", "Perl6", "SpokenDataTransformations", "lib") 

#' @description Parses a command by directly invoking a Raku Perl6 parser class.
#' @param cmd a natural language command
DPLYRParse <- 
  function(cmd) { 
    Perl6Parse(command = cmd, 
               moduleDirectory = perl6ParsingLib,
               moduleName = "DataTransformationWorkflowsGrammar",
               grammarClassName = "Spoken-dplyr-command",
               actionsClassName = NULL)
  }

#' @description Parses and interprets a command by directly invoking a pair of Raku Perl6 parser and actions classes.
#' @param cmd a natural language command
DPLYRInterpret <- 
  function(cmd) { 
    Perl6Parse(command = cmd, 
               moduleDirectory = perl6ParsingLib, 
               moduleName = "Spoken-dplyr-actions",
               grammarClassName = "DataTransformationWorkflowsGrammar",
               actionsClassName = "Spoken-dplyr-actions")
  }

#' @description Calls Raku Perl 6 module function `to_dplyr` in order to get 
#' interpretation of a spoken command or a list spoken commands separated with ";".
#' @param cmd a string with a command or a list of commands separted with ";"
#' @param parse a boolean should the result be parsed as an R expression
#' @details Produces a character vector or an expression depending on \param parse.
to_dplyr_command <- function(cmd, parse=TRUE) {
  pres <- Perl6Command( command = paste0( "say to_dplyr(\"", cmd, "\")"),
                        moduleDirectory = perl6ParsingLib, 
                        moduleName = "SpokenDataTransformations" )
  if(parse) { parse(text = pres) }
  else { pres }
}

##===========================================================
## Load data function
##===========================================================

#' @description Returns as a result the dataset that corresponds to a given name.
#' @param datasetName a dataset name
#' @details 
loadData <- function(datasetName) {
  dnames <- data()$results[,"Item"]
  if ( datasetName %in% dnames ) {
    data(list=datasetName)
    get(datasetName)
  } else {
    NA
  }
}

##===========================================================
## Echo functions
##===========================================================

echoColumnNames <- function(x) { cat("\n\tColumn names:\n"); cat( "\t\t", paste0( "\"", colnames(x), "\""), "\n" ); x } 

echoDimensions <- function(x) { cat("\n\tDimensions:\n"); cat( "\t\t", "nrow =", nrow(x), ", ncol =", ncol(x), "\n" ); x } 

echoHead <- function(x, ...) { cat("\n\tHead:\n"); print(head(x, ...)); x } 

echoSummary <- function(x, ...) { cat("\n\tSummary:\n"); print(summary(x, ...)); x } 


