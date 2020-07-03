##===========================================================
## Raku Perl 6 hook-up for spoken dplyr
##
## BSD 3-Clause License
##
## Copyright (c) 2019, Anton Antonov
## All rights reserved.
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are met:
##
## * Redistributions of source code must retain the above copyright notice, this
## list of conditions and the following disclaimer.
##
## * Redistributions in binary form must reproduce the above copyright notice,
## this list of conditions and the following disclaimer in the documentation
## and/or other materials provided with the distribution.
##
## * Neither the name of the copyright holder nor the names of its
## contributors may be used to endorse or promote products derived from
## this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
## AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
## IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
## DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
## FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
## DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
## SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
## CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
## OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
## OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
##
## Written by Anton Antonov,
## antononcube @@@ gmail ... com,
## Windermere, Florida, USA.
##===========================================================


## Change the directory names with the correct paths.
## The paths below assume Mac OS X and the GitHub repository ConversationalAgents being
## in the current user directory.

#' Raku Perl 6 parser library
#' @return A string
#' @export
Perl6dplyrParsingLib <- function() {
  #file.path( LocalUserDirName(), "ConversationalAgents", "Packages", "Perl6", "DataQueryWorkflows", "lib")
  "DataQueryWorkflows"
}

#' Parse dplyr natural speech command.
#' @description Parses a command by directly invoking a Raku Perl6 parser class.
#' @param command A natural language command.
#' @return A character vector
#' @family Spoken dplyr
#' @export
dplyrParse <-
  function(command) {
    Perl6Parse(command = command,
               moduleDirectory = Perl6dplyrParsingLib(),
               moduleName = "DataQueryWorkflows",
               grammarClassName = "DataQueryWorkflows",
               actionsClassName = NULL)
  }

#' Interpret dplyr natural speech command.
#' @description Parses and interprets a command by directly invoking a pair of Raku Perl6 parser and actions classes.
#' @param cmd A natural language command.
#' @return A character vector
#' @family Spoken dplyr
#' @export
dplyrInterpret <-
  function(command) {
    Perl6Parse(command = command,
               moduleDirectory = Perl6dplyrParsingLib(),
               moduleName = "DataQueryWorkflows",
               grammarClassName = "DataQueryWorkflows",
               actionsClassName = "dplyr")
  }

#' Interpret a dplyr natural language command.
#' @description Calls Raku Perl 6 module function `to_dplyr_R_command` in order to get
#' interpretation of a natural language command or a list spoken commands separated with ";".
#' @param command A string with a command or a list of commands separated with ";".
#' @param parse A boolean should the result be parsed as an R expression.
#' @details Produces a character vector or an expression depending on \code{parse}.
#' @return A string or an R expression
#' @family Spoken dplyr
#' @export
to_dplyr_command <- function(command, parse=TRUE) {
  pres <- Perl6Command( command = paste0( "say to_dplyr(\"", command, "\")"),
                        moduleDirectory = Perl6dplyrParsingLib(),
                        moduleName = "DataQueryWorkflows" )
  messageInds <- grep( "^Possible", pres )
  if( length(messageInds) > 0 ) {
    messageLines <- pres[messageInds]
    print(messageLines)
    pres <- pres[setdiff(1:length(pres), messageInds)]
  }
  pres <- gsub( "\\\"", "\"", pres, fixed = T)
  if(parse) { parse(text = pres) }
  else { pres }
}
