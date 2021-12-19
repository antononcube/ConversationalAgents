##===========================================================
## DSL web service functions
##
## BSD 3-Clause License
##
## Copyright (c) 2021, Anton Antonov
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


#' DSL interpretation URL
#' @description Gives interpreter web service URL of a DSL command.
#' @param command The command to be interpreted.
#' @param query A character vector with named elements.
#' @param url The web service URL.
#' @param sub Sub-service name.
#' If NULL then only the \code{url} is used.
#' @family DSLWebService
#' @export
DSLWebServiceInterpretationURL <- function(command = NULL, query = NULL, url = "http://accendodata.net:5040/translate", sub = NULL ) {

  if( is.character(sub) ) {
    res <- paste0(url, sub, "/")
  } else {
    res <- url
  }

  url2 <- httr::parse_url( url )

  if( !( is.null(command) || is.character(command) && length(command) == 1) ) {
    stop( "The argument command is expected to be string or NULL.", call. = TRUE )
  }

  if( is.character(command) ) {
    url2$query <- list("command"=URLencode(command))
  }

  if( !( is.null(query) || ( is.character(query) || is.list(query) ) && !is.null(names(query)) && !is.null(names(query))) ) {
    stop( "The argument query is expected to be character vector with named elements or NULL.", call. = TRUE )
  }

  if( !is.null(query) ) {
    query <- setNames( as.list(query), names(query) )
    url2$query <- c(url2$query, query)
  }

  httr::build_url(url2)
}


#' DSL interpretation
#' @description Gives interpreter web service URL of a DSL command.
#' @param command The command to be interpreted.
#' @param query A character vector with named elements.
#' @param url The web service URL.
#' @param sub Sub-service name.
#' If NULL then only the \code{url} is used.
#' @family DSLWebService
#' @export
DSLWebServiceInterpretation <- function(command, query = NULL, url = "http://accendodata.net:5040/translate", sub = NULL ) {
  jsonlite::fromJSON(DSLWebServiceInterpretationURL(command, query = query, url = url, sub = sub))
}


#' Make DSL web service URL
#' @description Gives interpreter web service URL of a DSL command.
#' @param command The command to be interpreted.
#' @param scheme Scheme, string.
#' @param hostname Hostname, string.
#' @param port Port, string or integer.
#' @param path Path, string.
#' @param query A list with named elements of URL query specs.
#' @details The function \{code\link{httr::build_url}} is used.
#' This function is a more tunable and robust version of \code{\link{DSLWebServiceInterpretationURL}}.
#' @return A URL string.
#' @family DSLWebService
#' @export
MakeDSLWebServiceURL <- function(command = NULL, scheme = "http", hostname = "accendodata.net", port = "5040", path = "translate", query = NULL ) {

  if( !is.null(command) ) {
    command <- URLencode(command)
  }

  urlSpec <- list( scheme = scheme, hostname = hostname, port = port, path = path, params = command, query = query)

  class(urlSpec) <- "url"
  httr::build_url( url = urlSpec)
}


#' Interpret by DSL web service
#' @description Gives interpreter web service URL of a DSL command.
#' @param command The command to be interpreted.
#' @param query A list with named elements of URL query specs.
#' @param scheme Scheme, string.
#' @param hostname Hostname, string.
#' @param port Port, string or integer.
#' @param path Path, string.
#' @param url URL, string.
#' If NULL then the URL is composed with the arguments \code{scheme, hostname, port, path}.
#' @param sub Sub-service name.
#' @details The function \{code\link{httr::build_url}} is used.
#' This function is a more tunable and robust version of \code{\link{DSLWebServiceInterpretation}}.
#' If the argument \code{url} is a string then the web services URL is created with the function
#' \code{\link{DSLWebServiceInterpretationURL}};
#' otherwise, the function \code{\link{MakeDSLWebServiceURL}} is used.
#' @return Returns a list of the form \code{list( Success = <logical>, Response = <httr::GET result>, Content = <content>)}.
#' @family DSLWebService
#' @export
InterpretByDSLWebService <- function(command, query = NULL, scheme = "http", hostname = "accendodata.net", port = "5040", path = "translate", url = NULL, sub = NULL ) {

  # Make the URL
  if ( is.character(url) ) {
    urlLocal <- DSLWebServiceInterpretationURL( command, query = query, url = url, sub = sub )
  } else {
    urlLocal <- MakeDSLWebServiceURL(command = command, scheme = scheme, hostname = hostname, port = port, path = path, query = query )
  }

  # Attempt to get a response
  resp <- httr::GET(url = urlLocal)

  # Check response
  if( httr::http_error(resp) ) {
    return( list( Success = FALSE, Response = resp, Content = NULL ) )
  }

  # Get the content
  res <- httr::content(resp, type = "application/json" )

  # Result
  return( list( Success = TRUE, Response = resp, Content = res ) )

}



