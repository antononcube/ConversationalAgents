##===========================================================
## Raku Perl 6 command (line) functions
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
##
## This file has couple of functions that show one way of hooking-up
## to parsers and grammars made with Raku Perl 6.
##
## The first version of this file was created and posted at
## ConversationalAgents at GitHub:
##   https://github.com/antononcube/ConversationalAgents/
## Date: 2018-11-19
##===========================================================


#' Raku Perl 6 command
#' @description Parses a string with a given Raku Perl 6 module directory and
#' name, grammar, and grammar actions.
#' @param command A command string to be parsed.
#' @param moduleDirectory The directory name for the parsing module.
#' @param moduleName The name of the module to be loaded.
#' @param perl6Location Location of (path to) perl6..
#' @details Most likely this function is going to be used inside a function with a simpler signature.
#' @return A string.
#' @export
Perl6Command <- function(command,
                         moduleDirectory,
                         moduleName,
                         perl6Location = "/Applications/Rakudo/bin/raku") {

  if( !is.character(command) ) {
    stop( "A string is expected as a first argument.", call. = T)
  }

  p6CommandPart <- paste0("-I\"", moduleDirectory, "\" -M'", moduleName, "' -e 'XXXX'")

  pres <-
    system(
      command = paste( perl6Location, gsub( "XXXX", command, p6CommandPart ) ),
      intern = TRUE )

  # lsArgs <- c( '-I', moduleDirectory, '-M', moduleName, '-e', paste0('\'', command, '\'') )
  #
  # pres <- system2( command = perl6Location, args = lsArgs, stdout = TRUE )

  pres
}


#' Raku Perl 6 parsing
#' @description Parses a string with a given Raku Perl 6 module directory, module name,
#' grammar class, and grammar actions class.
#' @param command A command string to be parsed.
#' @param moduleDirectory The directory name for the parsing module.
#' @param grammarClassName The name of the grammar class.
#' @param actionsClassName The name of the actions class; if NULL just parsing is done.
#' @param perl6Location Location of (path to) perl6.
#' @details Most likely this function is going to be used inside a function with a simpler signature.
#' @return A string
#' @export
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


#' Local user directory name
#' @details Mac OS X centric user directory at this point.
#' @return A string
#' @export
LocalUserDirName <- function() { file.path( "/", "Users", Sys.info()["user"]) }

