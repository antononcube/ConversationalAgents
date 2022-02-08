##===========================================================
## Raku DSL modules hook-up
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
## antononcube @@@ posteo ... net,
## Windermere, Florida, USA.
##===========================================================


#' @import httr
#' @import jsonlite
NULL


#' Interpret search engine query commands.
#' @description Invokes the Raku module DSL::English::SearchEngineQueries in order to get
#' interpretation of a natural language command or a list spoken commands separated with ";".
#' @param command A string with a command or a list of commands separated with ";".
#' @param parse A Boolean should the result be parsed as an R expression.
#' @param target Target of the interpretation.
#' One of "base", "data.table", "SMRMon", "sqldf", "tidyverse".
#' @param rakuLocation Location of (path to) raku.
#' @details Produces a character vector or an expression depending on \code{parse}.
#' @return A string or an R expression
#' @family Spoken dplyr
#' @export
ToSearchEngineQueryCode <- function(command, parse = TRUE, target = "tidyverse", rakuLocation = "/Applications/Rakudo/bin/raku") {

  command <- gsub( '`', '\\\\`', command)
  command <- gsub( "\'", "\\\\'", command)
  command <- gsub( "\"", "\\\\'", command)

  if( target %in% c( "base", "data.table", "SMRMon", "sqldf", "tidyverse" ) ) {
    target <- paste0( "R-", target )
  }

  pres <- RakuCommand( command = paste0( "say ToSearchEngineQueryCode('", command, "', '", target, "')" ),
                       moduleDirectory = "",
                       moduleName = "DSL::English::SearchEngineQueries",
                       rakuLocation = rakuLocation )

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


#' Interpret data query workflow natural language commands.
#' @description Invokes the Raku module DSL::English::DataQueryWorkflows in order to get
#' interpretation of a natural language command or a list spoken commands separated with ";".
#' @param command A string with a command or a list of commands separated with ";".
#' @param parse A Boolean should the result be parsed as an R expression.
#' @param target Target of the interpretation.
#' One of "base", "data.table", "SMRMon", "sqldf", "tidyverse".
#' @param rakuLocation Location of (path to) raku.
#' @details Produces a character vector or an expression depending on \code{parse}.
#' @return A string or an R expression
#' @family Spoken dplyr
#' @export
ToDataQueryWorkflowCode <- function(command, parse = TRUE, target = "tidyverse", rakuLocation = "/Applications/Rakudo/bin/raku") {

  command <- gsub( '`', '\\\\`', command)
  command <- gsub( "\'", "\\\\'", command)
  command <- gsub( "\"", "\\\\'", command)

  if( target %in% c( "base", "data.table", "SMRMon", "sqldf", "tidyverse" ) ) {
    target <- paste0( "R-", target )
  }

  pres <- RakuCommand( command = paste0( "say ToDataQueryWorkflowCode('", command, "', '", target, "')" ),
                       moduleDirectory = "",
                       moduleName = "DSL::English::DataQueryWorkflows",
                       rakuLocation = rakuLocation )

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


#' Interpret recommender workflow natural language commands.
#' @description Invokes the Raku module DSL::English::RecommenderWorkflows in order to get
#' interpretation of a natural language command or a list spoken commands separated with ";".
#' @param command A string with a command or a list of commands separated with ";".
#' @param parse A Boolean should the result be parsed as an R expression.
#' @param rakuLocation Location of (path to) raku.
#' @details Produces a character vector or an expression depending on \code{parse}.
#' @return A string or an R expression
#' @family Spoken dplyr
#' @export
ToRecommenderWorkflowCode <- function(command, parse = TRUE, rakuLocation = "/Applications/Rakudo/bin/raku") {

  pres <- RakuCommand( command = paste0( "say ToRecommenderWorkflowCode('", command, "')"),
                       moduleDirectory = "",
                       moduleName = "DSL::English::RecommenderWorkflows",
                       rakuLocation = rakuLocation )

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


#' Interpret Quantile regression workflow natural language commands.
#' @description Invokes the Raku module DSL::English::QuantileRegressionWorkflows in order to get
#' interpretation of a natural language command or a list spoken commands separated with ";".
#' @param command A string with a command or a list of commands separated with ";".
#' @param parse A Boolean should the result be parsed as an R expression.
#' @param rakuLocation Location of (path to) raku.
#' @details Produces a character vector or an expression depending on \code{parse}.
#' @return A string or an R expression
#' @family Spoken dplyr
#' @export
ToQuantileRegressionWorkflowCode <- function(command, parse = TRUE, rakuLocation = "/Applications/Rakudo/bin/raku") {

  pres <- RakuCommand( command = paste0( "say ToQuantileRegressionWorkflowCode('", command, "')"),
                       moduleDirectory = "",
                       moduleName = "DSL::English::QuantileRegressionWorkflows",
                       rakuLocation = rakuLocation )

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


#' Interpret Latent semantic analysis workflow natural language commands.
#' @description Invokes the Raku module DSL::English::LatentSemanticAnalysisWorkflows in order to get
#' interpretation of a natural language command or a list spoken commands separated with ";".
#' @param command A string with a command or a list of commands separated with ";".
#' @param parse A Boolean should the result be parsed as an R expression.
#' @param rakuLocation Location of (path to) raku.
#' @details Produces a character vector or an expression depending on \code{parse}.
#' @return A string or an R expression
#' @family Spoken dplyr
#' @export
ToLatentSemanticAnalysisWorkflowCode <- function(command, parse = TRUE, rakuLocation = "/Applications/Rakudo/bin/raku") {

  pres <- RakuCommand( command = paste0( "say ToLatentSemanticAnalysisWorkflowCode('", command, "')"),
                       moduleDirectory = "",
                       moduleName = "DSL::English::LatentSemanticAnalysisWorkflows",
                       rakuLocation = rakuLocation )

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



#' Interpret Latent semantic analysis workflow natural language commands.
#' @description Invokes the Raku module DSL::English::EpidemiologyModelingWorkflows in order to get
#' interpretation of a natural language command or a list spoken commands separated with ";".
#' @param command A string with a command or a list of commands separated with ";".
#' @param parse A Boolean should the result be parsed as an R expression.
#' @param rakuLocation Location of (path to) raku.
#' @details Produces a character vector or an expression depending on \code{parse}.
#' @return A string or an R expression
#' @family Spoken dplyr
#' @export
ToEpidemiologyModelingWorkflowCode <- function(command, parse = TRUE, rakuLocation = "/Applications/Rakudo/bin/raku") {

  pres <- RakuCommand( command = paste0( "say ToEpidemiologyModelingWorkflowCode('", command, "')"),
                       moduleDirectory = "",
                       moduleName = "DSL::English::EpidemiologyModelingWorkflows",
                       rakuLocation = rakuLocation )

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
