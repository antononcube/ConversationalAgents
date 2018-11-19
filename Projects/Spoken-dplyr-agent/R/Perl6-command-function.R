#---
# Title: Perl6 command (line) function
# Author: Anton Antonov
#         ConversationalAgents at GitHub:
#         https://github.com/antononcube/ConversationalAgents/
# Date: 2018-11-03
#---

#' @description Parses a string with a given Raku Perl 6 module directory and name, grammar, and grammar actions.
#' @param command command to be parsed
#' @param moduleDirectory the directory for the parsing module
#' @param moduleName the name of the module to be loaded
#' @param perl6Location location of perl6
#' @details Most likely this function is going to be used inside a function with a simpler signature.
Perl6Command <- function(command, 
                       moduleDirectory,
                       moduleName,
                       perl6Location = "/Applications/Rakudo/bin/perl6") { 
  
  if( !is.character(command) ) {
    stop( "A string is expected as a first argument.", call. = T)
  }
  
  p6CommandPart <- paste0("-I\"", moduleDirectory, "\" -M'", moduleName, "' -e 'XXXX'")
  
  pres <-
    system(
      command = paste( perl6Location, gsub( "XXXX", command, p6CommandPart ) ), 
      intern = TRUE )
  pres
}