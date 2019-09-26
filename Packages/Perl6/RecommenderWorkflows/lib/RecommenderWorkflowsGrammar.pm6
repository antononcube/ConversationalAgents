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
  rule number-of { [ 'number' | 'count' ] 'of' }
  token per { 'per' }
  token results { 'results' }
  token simple { 'simple' | 'direct' }
  token use-verb { 'use' | 'utilize' }
  token get-verb { 'obtain' | 'get' | 'take' }
  token object { 'object' }
  token system { 'system' }

  # Data
  rule records { 'rows' | 'records' }
  rule time-series-data { 'time' 'series' [ 'data' ]? }
  rule data-frame { 'data' 'frame' }
  token dataset { 'dataset' }
  rule data { <data-frame> | 'data' | <dataset> | <time-series-data> }
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
  rule plot-directive { 'plot' | 'chart' | <display-directive> <diagram> }
  rule use-directive { [ <get-verb> <and-conjuction>? ]? <use-verb> }
  token classify { 'classify' }

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

}

# Recommender specific phrases
role RecommenderWorkflowsGrammar::RecommenderPhrases {

  # Proto tokens
  proto token item-slot { * }
  token item-slot:sym<item> { 'item' }

  proto token items-slot { * }
  token items-slot:sym<items> { 'items' }

  proto token consumption-slot { * }
  token consumption-slot:sym<consumption> { 'consumption' }


  proto token history-slot { * }
  token history-slot:sym<history> { 'history' }

  # Regular tokens / rules
  rule history-phrase { [ <item-slot> ]? <history-slot> }
  rule consumption-profile { <consumption-slot>? 'profile' }
  rule consumption-history { <consumption-slot>? <history-slot> }
  token profile { 'profile' }
  token recommend-directive { 'recommend' | 'suggest' }
  token recommendation { 'recommendation' }
  token recommendations { 'recommendations' }
  rule recommender { 'recommender' | 'smr' }
  rule recommender-object { <recommender> [ <object> | <system> ]? }
  rule recommended-items { 'recommended' 'items' | [ 'recommendations' | 'recommendation' ]  <.results>?  }
  rule recommendation-results { [ <recommendation> | <recommendations> | 'recommendation\'s' ] <results> }
  rule recommendation-matrix { [ <recommendation> | <recommender> ]? 'matrix' }
  rule recommendation-matrices { [ <recommendation> | <recommender> ]? 'matrices' }
  rule sparse-matrix { 'sparse' 'matrix' }
  token column { 'column' }
  token columns { 'columns' }
  token row { 'row' }
  token rows { 'rows' }
  token dimensions { 'dimensions' }
  token density  { 'density' }
  rule most-relevant { 'most' 'relevant' }
  rule tag-type { 'tag' 'type' }
  rule tag-types { 'tag' 'types' }
  rule nearest-neighbors { 'nearest' [ 'neighbors' | 'neighbours' ] | 'nns' }
  token outlier { 'outlier' }
  token outliers { 'outliers' | 'outlier' }
  token anomaly { 'anomaly' }
  token anomalies { 'anomalies' }
  token threshold { 'threshold' }
  token identifier { 'identifier' }
  token proximity { 'proximity' }
  token aggregation { 'aggregation' }
  token aggregate { 'aggregate' }
  token function { 'function' }
  token property { 'property' }

}

# This role class has pipeline commands.
role RecommenderWorkflowsGrammar::PipelineCommand {

  rule pipeline-command { <get-pipeline-value> }
  rule get-pipeline-value { <display-directive> <pipeline-value> }
  rule pipeline-value { <.pipeline-filler-phrase>? 'value'}
  rule pipeline-filler-phrase { <the-determiner>? [ 'current' ]? 'pipeline' }

}

grammar RecommenderWorkflowsGrammar::Recommender-workflow-commmand does PipelineCommand does RecommenderPhrases does CommonParts {

  # TOP
  rule TOP { <pipeline-command> |
             <data-load-command> | <create-command> |
             <data-transformation-command> | <data-statistics-command> |
             <recommend-by-profile-command> | <recommend-by-history-command> |
             <make-profile-command> |
             <extend-recommendations-command> |
             <classify-command> |
             <smr-query-command> |
             <find-anomalies-command> }

  # Load data
  rule data-load-command { <load-data> | <use-recommender> }
  rule data-location-spec { <dataset-name> }
  rule load-data { <.load-data-directive> <data-location-spec> }
  rule use-recommender { <.use-verb> <.the-determiner>? <.recommender-object> <variable-name> }

  # Create command
  rule create-command { <create-by-dataset> | <create-by-matrices> | <create-simple> }
  rule create-preamble-phrase { <generate-directive> [ <.a-determiner> | <.the-determiner> ]? <recommender-object> }
  rule simple-way-phrase { 'in' <a-determiner> <simple> 'way' | 'directly' | 'simply' }
  rule create-simple { <create-preamble-phrase> <simple-way-phrase>? | <simple> <recommender-object> [ 'creation' | 'making' ] }
  rule create-by-dataset { [ <generate-directive> | <create-preamble-phrase> ] [ <.by-preposition> | <.with-preposition> | <.from-preposition> ] <.the-determiner>? <dataset>? <dataset-name> }
  rule create-by-matrices { [ <generate-directive> | <create-preamble-phrase> ] [ <.by-preposition> | <.with-preposition> | <.from-preposition> ] <.the-determiner>? 'matrices' <variable-names-list> }

  # Data transformation command
  rule data-transformation-command { <cross-tabulate-command> }
  rule cross-tabulate-command { 'cross' 'tabulate' <.data>? }

  # Data statistics command
  rule data-statistics-command { <show-data-summary> | <summarize-data> | <items-per-tag> | <tags-per-item> }
  rule show-data-summary { <display-directive> <data>? 'summary' }
  rule summarize-data { 'summarize' <.the-determiner>? <data> | <display-directive> <data>? ( 'summary' | 'summaries' ) }
  rule items-per-tag { <number-of> <items-slot> 'per' <tag> }
  rule tags-per-item { <number-of> <tags> 'per' <item-slot> }

  # (Scored) items lists
  token score-association-symbol { '=' | '->' }
  token score-association-separator { <.ws>? <score-association-symbol> <.ws>? }
  token item-id { ([ \w | '-' | '_' | '.' | ':' | \d ]+) <!{ $0 eq 'and' }> }
  rule item-ids-list { <item-id>+ % <list-separator> }
  token scored-item-id { <item-id> <.score-association-separator> <number-value> }
  rule scored-item-ids-list { <scored-item-id>+ % <list-separator> }

  # (Scored) tags lists
  token tag-id { ([ \w | '-' | '_' | '.' | ':' | \d ]+) <!{ $0 eq 'and' }> }
  rule tag-ids-list { <tag-id>+ % <list-separator> }
  token scored-tag-id { <tag-id> <.score-association-separator> <number-value> }
  rule scored-tag-ids-list { <scored-tag-id>+ % <list-separator> }
  token tag-type-id { ([ \w | '-' | '_' | '.' | ':' | \d ]+) <!{ $0 eq 'and' }> }

  # History spec
  rule history-spec { <item-ids-list> | <scored-item-ids-list> }

  # Profile spec
  rule profile-spec { <tag-ids-list> | <scored-tag-ids-list> }

  # Recommend by history
  rule recommend-by-history-command { <recommend-by-history> | <top-recommendations-by-history> | <top-recommendations> | <simple-recommend> }
  rule recommend-by-history { <.recommend-directive>
                              [ <.using-preposition> | <.by-preposition> | <.for-preposition> ] <.the-determiner>? <.history-phrase>?
                              <history-spec> }
  rule top-recommendations { <compute-directive> <.the-determiner>? <.most-relevant-phrase>? <integer-value> <.recommendations> }
  rule top-recommendations-by-history { <top-recommendations>
                                        [ <.using-preposition> | <.by-preposition> | <.for-preposition> ] <.the-determiner>? <.history-phrase>?
                                        <history-spec> }
  rule most-relevant-phrase { <most-relevant> | 'top' <most-relevant>? }
  rule simple-recommend { <.recommend-directive> | <compute-directive> <recommendations> }


  # Recommend by profile
  rule recommend-by-profile-command { <recommend-by-profile> | <top-profile-recommendations> | <top-recommendations-by-profile> }
  rule recommend-by-profile { <.recommend-directive>
                              [ <.using-preposition> | <.by-preposition> | <.for-preposition> ] <.the-determiner>? <.profile>
                              <profile-spec> }
  rule top-profile-recommendations { <compute-directive> <.the-determiner>? <.most-relevant-phrase>? <integer-value> <.profile> <.recommendations> }
  rule top-recommendations-by-profile { <top-recommendations>
                                        [ <.using-preposition> | <.by-preposition> | <.for-preposition> ] <.the-determiner>? <.profile>
                                        <profile-spec> }

  # Make profile
  rule make-profile-command {  <make-profile-command-opening> <.the-determiner>? [ <history-phrase> <.list>? | <items-slot> ] <history-spec> }
  rule make-profile-command-opening { <compute-directive> [ <a-determiner> | <the-determiner> ]? <profile>
                                      [ <using-preposition> | <by-preposition> | <for-preposition> ] }

  # Recommendations processing command
  rule extend-recommendations-command { [ 'extend' | 'join' [ 'across' ]? ] <recommendations>? <.with-preposition> <.the-determiner>? <.data>? <dataset-name> }

  # Classifications command
  rule classify-command { <classify-by-profile> | <classify-by-profile-rev> }
  rule ntop-nns { [ 'top' ]? <integer-value> [ 'top' ]? <.nearest-neighbors> }
  rule classify-by-profile { <.classify> <.the-determiner>? <.profile>? <profile-spec>
                             <.to-preposition> <.tag-type>? <tag-type-id>
                             [ <.using-preposition> <ntop-nns> ]? }
  rule classify-by-profile-rev { <.classify> [ <.for-preposition> | <.to-preposition>] <.the-determiner>? <.tag-type>? <tag-type-id>
                                 [ <.by-preposition> | <.for-preposition> | <.using-preposition> ]? <.the-determiner>? <.profile>?
                                 <profile-spec>
                                 [ <.and-conjuction>? <.using-preposition>? <ntop-nns> ]? }

  # Plot command
  rule plot-command { <plot-recommendation-scores> }
  rule plot-recommendation-scores { <plot-directive> <.the-determiner>? <recommendation-results> }

  # SMR query command
  rule smr-query-command { <smr-recommender-query> | <smr-filter-matrix> }
  rule smr-recommender-query { <display-directive> <.the-determiner>? <.recommender>? <smr-property-spec> }
  rule smr-property-spec { <smr-context-property-spec> | <smr-matrix-property-spec> | <smr-sub-matrix-property-spec> }

  token smr-property-id { ([ \w | '-' | '_' | '.' | ':' | \d ]+) <!{ $0 eq 'and' || $0 eq 'pipeline' }> }

  rule smr-context-property-spec { <smr-tag-types> | <smr-item-column-name> | <smr-sub-matrices> | <smr-recommendation-matrix> }
  rule smr-tag-types { <tag-types> }
  rule smr-item-column-name { <item-slot> <column> 'name' | 'itemColumnName' }
  rule smr-sub-matrices { [ 'sparse' ]? [ 'contingency' ]? [ 'sub-matrices' | [ 'sub' ]? 'matrices' ] }
  rule smr-recommendation-matrix { <recommendation-matrix> }

  rule smr-matrix-property-spec-openning { <recommendation-matrix> | <sparse-matrix> | 'matrix' }
  rule smr-matrix-property-spec { <.smr-matrix-property-spec-openning>? <smr-matrix-property> }

  rule smr-sub-matrix-property-spec-openning { 'sub-matrix' | 'sub' 'matrix' | <tag-type> }
  rule smr-sub-matrix-property-spec { <.smr-sub-matrix-property-spec-openning>? <tag-type-id> <smr-matrix-property> }

  rule smr-matrix-property { <columns> | <rows> | <dimensions> | <density> | <number-of-columns> | <number-of-rows> | <smr-property-id> }
  rule number-of-columns { <number-of> <columns> }
  rule number-of-rows { <number-of> <rows> }

  rule smr-filter-matrix { [ 'filter' | 'reduce' ] <.the-determiner>? <.smr-matrix-property-spec-openning>
                           [ <.using-preposition> | <.with-preposition> | <.by-preposition> ]
                           <profile-spec> }

  # Find anomalies command
  rule find-anomalies-command { <find-proximity-anomalies> | <find-proximity-anomalies-simple> }
  rule find-proximity-anomalies-simple { <find-proximity-anomalies-preamble> }
  rule find-proximity-anomalies-preamble { <compute-directive> [ <.anomalies> [ <.by-preposition> <.proximity> ]? | <.proximity> <.anomalies> ] }
  rule find-proximity-anomalies { <find-proximity-anomalies-preamble> <.using-preposition> <proximity-anomalies-spec-list> }
  rule proximity-anomalies-spec-list { <proximity-anomalies-spec>* % <.list-separator> }
  rule proximity-anomalies-spec { <proximity-anomalies-nns-spec> | <proximity-anomalies-outlier-identifier-spec> | <proximity-anomalies-aggr-func-spec> | <proximity-anomalies-property-spec> }
  rule proximity-anomalies-nns-spec { <integer-value> <nearest-neighbors> }
  rule proximity-anomalies-aggr-func-spec { <.the-determiner>? <.aggregation> <.function> <variable-name> |
                                            <.aggregate> [ <.by-preposition> | <.using-preposition> ] <.the-determiner>? <.function> <variable-name> }
  rule proximity-anomalies-outlier-identifier-spec { <.the-determiner>? [ <.outlier> <.identifier> <variable-name> | <variable-name> <.outlier> <.identifier> ]}
  rule proximity-anomalies-property-spec { <.the-determiner>? <.property> <variable-name> }

   # Error message
   # method error($msg) {
   #   my $parsed = self.target.substr(0, self.pos).trim-trailing;
   #   my $context = $parsed.substr($parsed.chars - 15 max 0) ~ '⏏' ~ self.target.substr($parsed.chars, 15);
   #   my $line-no = $parsed.lines.elems;
   #   die "Cannot parse code: $msg\n" ~ "at line $line-no, around " ~ $context.perl ~ "\n(error location indicated by ⏏)\n";
   # }

   method ws() {
     if self.pos > $*HIGHWATER {
       $*HIGHWATER = self.pos;
       $*LASTRULE = callframe(1).code.name;
     }
     callsame;
   }

   method parse($target, |c) {
     my $*HIGHWATER = 0;
     my $*LASTRULE;
     my $match = callsame;
     self.error_msg($target) unless $match;
     return $match;
   }

   method error_msg($target) {
     my $parsed = $target.substr(0, $*HIGHWATER).trim-trailing;
     my $un-parsed = $target.substr($*HIGHWATER, $target.chars).trim-trailing;
     my $line-no = $parsed.lines.elems;
     my $msg = "Cannot parse the command";
     # say 'un-parsed : ', $un-parsed;
     # say '$*LASTRULE : ', $*LASTRULE;
     $msg ~= "; error in rule $*LASTRULE at line $line-no" if $*LASTRULE;
     $msg ~= "; target '$target' position $*HIGHWATER";
     $msg ~= "; parsed '$parsed', un-parsed '$un-parsed'";
     $msg ~= ' .';
     say $msg;
   }

}
