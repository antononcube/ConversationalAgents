#---
# Title: R Perl6 parsing function
# Author: Anton Antonov
#         ConversationalAgents at GitHub:
#         https://github.com/antononcube/ConversationalAgents/
# Date: 2018-11-03
#---

#' @description Parses a string with a given Raku Perl 6 module directory, module name,
#' grammar class, and grammar actions class.
#' @param command command to be parsed
#' @param moduleDirectory the directory for the parsing module
#' @param grammarClassName the name of the grammar class
#' @param actionsClassName the name of the actions class; if NULL just parsing is done
#' @param perl6Location location of perl6
#' @details Most likely this function is going to be used inside a function with a simpler signature.
Perl6Parse <- function(command, 
                       moduleDirectory,
                       moduleName,
                       grammarClassName,
                       actionsClassName = NULL,
                       perl6Location = "/Applications/Rakudo/bin/perl6") { 
  
  if( !is.character(command) ) {
    stop( "A string is expected as a first argument.", call. = T)
  }
  
  p6CommandPart <- paste0("-I\"", moduleDirectory, "\" -M'", moduleName, "' -e \"say ", moduleName, "::", grammarClassName, ".parse('XXXX'")

  if( is.null(actionsClassName) || nchar(actionsClassName) == 0 ) {
    p6CommandPart <- paste0( p6CommandPart, ")\"")
  } else {
    p6CommandPart <- paste0( p6CommandPart, ", actions => ", moduleName, "::", actionsClassName, ".new).made\"" )
  }
  
  pres <-
    system(
      command = paste( perl6Location, gsub( "XXXX", command, p6CommandPart ) ), 
      intern = TRUE )
  pres
}

