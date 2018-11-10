#==============================================================================
#
#   Data transformation workflows grammar in Raku Perl 6
#   Copyright (C) 2018  Anton Antonov
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#   Written by Anton Antonov,
#   antononcube @ gmai l . c om,
#   Windermere, Florida, USA.
#
#==============================================================================
#
#   For more details about Raku Perl6 see https://perl6.org/ .
#
#==============================================================================

use v6;
unit module DataTransformationWorkflowGrammar;

# This role class has common command parts.
role DataTransformationWorkflowGrammar::CommonParts {

  rule load-data-directive { 'load' 'data' }
  token create-directive { 'create' | 'make' }
  token compute-directive { 'compute' | 'find' | 'calculate' }
  token display-directive { 'display' | 'show' }
  token using-preposition { 'using' | 'with' | 'over' }
  token by-preposition { 'by' | 'with' | 'using' }
  token for-preposition { 'for' | 'with' }
  token assign { 'assign' | 'set' }
  token a-determiner { 'a' | 'an'}
  token the-determiner { 'the' }

  # True dplyr; see comments below.
  rule data { 'the'? 'data' }
  rule select { 'select' | 'keep' 'only'? }
  token mutate { 'mutate' }
  rule group-by { 'group' ( <by-preposition> | <using-preposition> ) }
  rule arrange { ( 'arrange' | 'order' ) <by-preposition>? }
  token ascending { 'ascending' }
  token descending { 'descending' }
  token variables { 'variable' | 'variables' }
  token list-separator { <.ws>? ',' <.ws>? | <.ws>? '&' <.ws>? }
  token variable-name { [\w | '_' | '.']+ }
  rule variable-names-list { <variable-name>+ % <list-separator> }
  token assign-to-symbol { '=' | ':=' | '<-' }
}

# Here we model the transformation natural language commands after R/RStudio's library "dplyr".
# For more details see: https://dplyr.tidyverse.org/ .
grammar DataTransformationWorkflowGrammar::Spoken-dplyr-command does CommonParts {

  # TOP
  rule TOP { <load-data> | <select-command> | <mutate-command> | <group-command> | <statistics-command> | <arrange-command> }

  # Load data
  rule load-data { <.load-data-directive> <data-location-spec> }
  rule data-location-spec { .* }

  # Select command
  rule select-command { <select> <.the-determiner>? <.variables>? <variable-names-list> }

  # Mutate command
  rule mutate-command { ( <mutate> | <assign> ) <.by-preposition>? <assign-pairs-list> }
  rule assign-pair { <variable-name> <.assign-to-symbol> <variable-name> }
  rule assign-pairs-list { <assign-pair>+ % <.list-separator> }

  # Group command
  rule group-command { <group-by> <variable-names-list> }

  # Arrange command
  rule arrange-command { <arrange> <variable-names-list> <arrange-direction>? }
  rule arrange-direction { <ascending> | <descending> }

  # Statistics command
  rule statistics-command { <count-command> | <summarize-all-command> }
  rule count-command { <compute-directive> <.the-determiner>? ( 'count' | 'counts' ) }
  rule summarize-all-command { ( 'summarize' | 'summarise' ) 'them'? 'all'? }
}
