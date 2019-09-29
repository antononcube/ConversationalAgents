#==============================================================================
#
#   Data transformation workflows grammar in Raku Perl 6
#   Copyright (C) 2018-2019  Anton Antonov
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
#   antononcube @ gmail . com,
#   Windermere, Florida, USA.
#
#==============================================================================
#
#   The first version of the grammar was made in 2018 for work-shop at
#   Data Science Salon Miami November 2018. See
#
#     https://github.com/antononcube/ConversationalAgents/tree/master/Projects/DataScienceSalon-Miami-Nov-2018-Workshop
#
#   That grammar was adopted as the first version of the core workflows grammar
#   for a specialized Raku Perl 6 package in September 2019.
#
#==============================================================================

use v6;
unit module DataTransformationWorkflowsGrammar;

# This role class has common command parts.
role DataTransformationWorkflowsGrammar::CommonParts {

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
  token column { 'column' }
  token columns { 'columns' }
  rule group-by { 'group' ( <by-preposition> | <using-preposition> ) }
  rule arrange { ( 'arrange' | 'order' | 'sort' ) ( <by-preposition> | <using-preposition> )? }
  token ascending { 'ascending' | 'asc' }
  token descending { 'descending' | 'desc' }
  token variables { 'variable' | 'variables' }
  token list-separator-symbol { ',' | '&' | 'and' }
  token list-separator { <.ws>? <list-separator-symbol> <.ws>? }
  token variable-name { ([\w | '_' | '.']+) <!{ $0 eq 'and' }> }
  rule variable-names-list { <variable-name>+ % <list-separator> }
  token assign-to-symbol { '=' | ':=' | '<-' }
}

# Here we model the transformation natural language commands after R/RStudio's library "dplyr".
# For more details see: https://dplyr.tidyverse.org/ .
grammar DataTransformationWorkflowsGrammar::Data-transformation-workflow-commmand does CommonParts {

  # TOP
  rule TOP { <load-data> | <select-command> | <mutate-command> | <group-command> | <statistics-command> | <arrange-command> }

  # Load data
  rule load-data { <.load-data-directive> <data-location-spec> }
  rule data-location-spec { .* }

  # Select command
  rule select-command { <select> <.the-determiner>? [ <columns> | <variables> ]? <variable-names-list> }

  # Mutate command
  rule mutate-command { ( <mutate> | <assign> ) <.by-preposition>? <assign-pairs-list> }
  rule assign-pair { <variable-name> <.assign-to-symbol> <variable-name> }
  rule assign-pairs-list { <assign-pair>+ % <.list-separator> }

  # Group command
  rule group-command { <group-by> <variable-names-list> }

  # Arrange command
  rule arrange-command { <arrange-command-descending> | <arrange-command-ascending> }
  rule arrange-command-simple { <arrange> <.the-determiner>? <.variables>? <variable-names-list> }
  rule arrange-command-ascending { <arrange-command-simple> <.ascending>? }
  rule arrange-command-descending { <arrange-command-simple> <descending> }

  # Statistics command
  rule statistics-command { <count-command> | <summarize-all-command> }
  rule count-command { <compute-directive> <.the-determiner>? ( 'count' | 'counts' ) }
  rule summarize-all-command { ( 'summarize' | 'summarise' ) 'them'? 'all'? }
}
