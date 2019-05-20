#==============================================================================
#
#   Recommender workflows grammar in Raku Perl 6
#   Copyright (C) 2019  Anton Antonov
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
#
#  The grammar design in this file follows very closely the EBNF grammar
#  for Mathematica in the GitHub file:
#    https://github.com/antononcube/ConversationalAgents/blob/master/EBNF/English/Mathematica/RecommenderWorkflowsGrammar.m
#
#==============================================================================

use v6;
unit module RecommenderWorkflowsGrammar;

# This role class has common command parts.
role RecommenderWorkflowsGrammar::CommonParts {

  # Speech parts
  token do-verb { 'do' }
  token with-preposition { 'using' | 'with' | 'by' }
  token using-preposition { 'using' | 'with' | 'over' }
  token by-preposition { 'by' | 'with' | 'using' }
  token for-preposition { 'for' | 'with' }
  token of-preposition { 'of' }
  token from-preposition { 'from' }
  token to-preposition { 'to' | 'into' }
  token assign { 'assign' | 'set' }
  token a-determiner { 'a' | 'an'}
  token and-conjuction { 'and' }
  token the-determiner { 'the' }
  rule for-which-phrase { 'for' 'which' | 'that' 'adhere' 'to' }
  token number-of { [ 'number' | 'count' ] 'of' }
  token per { 'per' }
  token results { 'results' }
  token simple { 'simple' | 'direct' }
  token use-verb { 'use' | 'utilize' }
  token get-verb { 'obtain' | 'get' | 'take' }
  token object { 'object' }

  # Data
  token rows { 'rows' | 'records' }
  token time-series-data { 'time' 'series' 'data'? }
  token data { 'data' | 'dataset' | <time-series-data> }
  token dataset-name { ([ \w | '_' | '-' | '.' | \d ]+) <!{ $0 eq 'and' }> }
  token variable-name { ([ \w | '_' | '-' | '.' | \d ]+) <!{ $0 eq 'and' }> }

  # Directives
  rule load-data-directive { ( 'load' | 'ingest' ) <.the-determiner>? <data> }
  token create-directive { 'create' | 'make' }
  token generate-directive { 'generate' | 'create' | 'make' }
  token compute-directive { 'compute' | 'find' | 'calculate' }
  token display-directive { 'display' | 'show' | 'echo' }
  rule compute-and-display { <compute-directive> [ 'and' <display-directive> ]? }
  token diagram { 'plot' | 'plots' | 'graph' | 'chart' }
  token plot-directive { 'plot' | 'chart' | <display-directive> <diagram> }
  rule use-directive { [ <get-verb> <and-conjuction>? ]? <use-verb> }

  # Value types
  token number-value { (\d+ ['.' \d+]?  [ [e|E] \d+]?) }
  token integer-value { \d+ }
  token percent { '%' | 'percent' }
  token percent-value { <number-value> <.percent> }
  token boolean-value { 'True' | 'False' | 'true' | 'false' }

  # Lists of things
  token list-separator-symbol { ',' | '&' | 'and' }
  token list-separator { <.ws>? <list-separator-symbol> <.ws>? }
  token list { 'list' }

  # Variables list
  rule variable-names-list { <variable-name>+ % <list-separator> }

  # Number list
  rule number-value-list { <number-value>+ % <list-separator> }

  # Range
  rule range-spec-step { <with-preposition> | <with-preposition>? 'step' }
  rule range-spec { [ <.from-preposition> <number-value> ] [ <.to-preposition> <number-value> ] [ <.range-spec-step> <number-value> ]? }

  # Recommender specific
  token recommendation { 'recommendation' }
  token recommendations { 'recommendations' }
  token history { 'history' }
  rule history-phrase { [ 'item' ]? <history> }
  token profile { 'profile' }
  token recommend-directive { 'recommend' | 'suggest' }
  token consumption { 'consumption' }
  token item { 'item' }
  token items { 'item' | 'items' }
  token recommender { 'recommender' | 'smr' }
  rule recommender-object { <recommender> [ 'object' | 'system' ]? }
  token recommended-items { 'recommended' 'items' | [ 'recommendations' | 'recommendation' ]  <.results>?  }
  rule consumption-profile { <consumption>? 'profile' }
  rule consumption-history { <consumption>? 'history' }
  token recommendation-results { [ <recommendation> | <recommendations> | 'recommendation\'s' ] <results> }

}

# This role class has pipeline commands.
role RecommenderWorkflowsGrammar::Pipeline-command {

  rule pipeline-command { <get-pipeline-value> }
  rule get-pipeline-value { <display-directive> <pipeline-value> }
  rule pipeline-value { <.pipeline-filler-phrase>? 'value'}
  rule pipeline-filler-phrase { <the-determiner>? [ 'current' ]? 'pipeline' }

}

grammar RecommenderWorkflowsGrammar::Recommender-workflow-commmand does CommonParts does Pipeline-command {

  # TOP
  rule TOP { <data-load-command> | <create-command> |
             <data-transformation-command> | <data-statistics-command> |
             <recommend-by-profile-command> | <recommend-by-history-command> |
             <make-profile-command> |
             <extend-recommendations-command> |
             <pipeline-command> }

  # Load data
  rule data-load-command { <load-data> | <use-recommender> }
  rule data-location-spec { <dataset-name> }
  rule load-data { <.load-data-directive> <data-location-spec> }
  rule use-recommender { <.use-verb> <.the-determiner>? <recommender-object> <variable-name> }

  # Create command
  rule create-command { <create-by-matrices> | <create-by-dataset> }
  rule simple-way { <simple> 'way' | 'directly' | 'simply' }
  rule simple-way-phrase { 'in' <a-determiner> <simple-way> }
  rule create-simple { <create-directive> <.a-determiner>? <recommender> <simple-way-phrase> | <simple> <recommender> [ 'creation' | 'making' ] }
  rule create-by-dataset { [ <create-simple> | <create-directive> ] [ <.by-preposition> | <.with-preposition> | <.from-preposition> ]? <dataset-name> }
  rule create-by-matrices { <create-directive> [ <.by-preposition> | <.with-preposition> | <.from-preposition> ]? 'matrices' <variable-names-list> }

  # Data transformation command
  rule data-transformation-command { <cross-tabulate-command> }
  rule cross-tabulate-command { 'cross' 'tabulate' <.data>? }

  # Data statistics command
  rule data-statistics-command { <show-data-summary> | <summarize-data> | <items-per-tag> | <tags-per-item> }
  rule show-data-summary { <display-directive> <data>? 'summary' }
  rule summarize-data { 'summarize' <.the-determiner>? <data> | <display-directive> <data>? ( 'summary' | 'summaries' ) }
  rule items-per-tag { <number-of> <items> 'per' <tag> }
  rule tags-per-item { <number-of> <tags> 'per' <item> }

  # (Scored) items lists
  token score-association-symbol { '=' | '->' | ':' }
  token score-association-separator { <.ws>? <score-association-symbol> <.ws>? }
  token item-id { ([ \w | '-' | '_' | '.' | \d ]+) <!{ $0 eq 'and' }> }
  rule item-ids-list { <item-id>+ % <list-separator> }
  token scored-item-id { <item-id> <.score-association-separator> <number-value> }
  rule scored-item-ids-list { <scored-item-id>+ % <list-separator> }

  # (Scored) tags lists
  token tag-id { ([ \w | '-' | '_' | '.' | \d ]+) <!{ $0 eq 'and' }> }
  rule tag-ids-list { <tag-id>+ % <list-separator> }
  token scored-tag-id { <tag-id> <.score-association-separator> <number-value> }
  rule scored-tag-ids-list { <scored-tag-id>+ % <list-separator> }

  # History spec
  rule history-spec { <item-ids-list> | <scored-item-ids-list> }

  # Profile spec
  rule profile-spec { <tag-ids-list> | <scored-tag-ids-list> }

  # Recommend by history
  rule recommend-by-history-command { <.recommend-directive>
                                      [ <.using-preposition> | <.by-preposition> | <.for-preposition> ] <.the-determiner>? <.history-phrase>?
                                      <history-spec> }

  rule recommend-by-profile-command { <.recommend-directive> [ <.using-preposition> | <.by-preposition> ] <.the-determiner>? <.profile> <profile-spec> }

  # Recommend by profile
  rule make-profile-command {  <make-profile-command-opening> <.the-determiner>? [ <history-phrase> <.list>? | <items> ] <history-spec> }
  rule make-profile-command-opening { <compute-directive> [ <a-determiner> | <the-determiner> ]? <profile>
                                      [ <using-preposition> | <by-preposition> | <for-preposition> ] }

  # Extend recommendations commands
  rule extend-recommendations-command { [ 'extend' <recommendations>? | 'join' [ 'across' ]? ] <.with-preposition> <dataset-name>  }

  # Plot command
  rule plot-command { <plot-recommendation-scores> }
  rule plot-recommendation-scores { <plot-directive> <.the-determiner>? <recommendation-results> }

}
