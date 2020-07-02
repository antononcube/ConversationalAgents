=begin comment
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
#   For more details about Raku Perl6 see https://raku.org/ (https://perl6.org/) .
#
#==============================================================================
#
#  The grammar design in this file follows very closely the EBNF grammar
#  for Mathematica in the GitHub file:
#    https://github.com/antononcube/ConversationalAgents/blob/master/EBNF/English/Mathematica/RecommenderWorkflowsGrammar.m
#
#==============================================================================
=end comment

use v6;
unit module RecommenderWorkflows::Grammar;

use RecommenderWorkflows::Grammar::CommonParts;
use RecommenderWorkflows::Grammar::LSIApplyCommand;
use RecommenderWorkflows::Grammar::RecommenderPhrases;
use RecommenderWorkflows::Grammar::PipelineCommand;
use RecommenderWorkflows::Grammar::ErrorHandling;

grammar RecommenderWorkflows::Grammar::WorkflowCommand
        does RecommenderWorkflows::Grammar::LSIApplyCommand
        does RecommenderWorkflows::Grammar::PipelineCommand
        does RecommenderWorkflows::Grammar::RecommenderPhrases
        does RecommenderWorkflows::Grammar::ErrorHandling {
    # TOP
    rule TOP {
        <pipeline-command> |
        <data-load-command> |
        <create-command> |
        <data-transformation-command> |
        <lsi-apply-command> |
        <data-statistics-command> |
        <recommend-by-profile-command> |
        <recommend-by-history-command> |
        <make-profile-command> |
        <extend-recommendations-command> |
        <prove-recommendations-command> |
        <classify-command> |
        <smr-query-command> |
        <find-anomalies-command> |
        <make-metadata-recommender-command> }

    # Load data
    rule data-load-command { <load-data> | <use-recommender> }
    rule data-location-spec { <dataset-name> }
    rule load-data { <.load-data-directive> <data-location-spec> }
    rule use-recommender { [<.use-verb> | <.using-preposition>] <.the-determiner>? <.recommender-object> <variable-name> }

    # Create command
    rule create-command { <create-by-matrices> | <create-by-dataset> | <create-simple> }
    rule create-preamble-phrase { <generate-directive> [ <.a-determiner> | <.the-determiner> ]? <recommender-object> }
    rule simple-way-phrase { <in-preposition> <a-determiner> <simple> <way-noun> | <directly-adeverb> | <simply-adverb> }
    rule create-simple { <create-preamble-phrase> <simple-way-phrase>? | <simple> <recommender-object> [ 'creation' | 'making' ] }
    rule create-by-dataset { [ <create-preamble-phrase> | <generate-directive> ] [ <.with-preposition> | <.from-preposition> ] <.the-determiner>? <dataset>? <dataset-name> }
    rule create-by-matrices { [ <create-preamble-phrase> | <generate-directive> ] [ <.with-preposition> | <.from-preposition> ] <.the-determiner>? <matrices> <creation-matrices-spec> }
    rule creation-matrices-spec { <variable-name> | <variable-names-list> }

    # Data transformation command
    rule data-transformation-command { <cross-tabulate-command> }
    rule cross-tabulate-command { 'cross' 'tabulate' <.data>? }

    # Data statistics command
    rule data-statistics-command { <show-data-summary> | <summarize-data> | <items-per-tag> | <tags-per-item> }
    rule show-data-summary { <display-directive> <data>? 'summary' }
    rule summarize-data { 'summarize' <.the-determiner>? <data> | <display-directive> <data>? ( 'summary' | 'summaries' ) }
    rule items-per-tag { <number-of> <items-slot> <per-preposition> <tag> }
    rule tags-per-item { <number-of> <tags> <per-preposition> <item-slot> }

    # (Scored) items lists
    token score-association-symbol { '=' | '->' | '→' }
    token score-association-separator { <.ws>? <score-association-symbol> <.ws>? }
    regex item-id { ([ \w | '-' | '_' | '.' | ':' | \d ]+) <!{ $0 eq 'and' }> }
    rule item-ids-list { <item-id>+ % <list-separator> }
    regex scored-item-id { <item-id> <.score-association-separator> <number-value> }
    rule scored-item-ids-list { <scored-item-id>+ % <list-separator> }

    # (Scored) tags lists
    regex tag-id { ([ \w | '-' | '_' | '.' | ':' | \d ]+) <!{ $0 eq 'and' }> }
    rule tag-ids-list { <tag-id>+ % <list-separator> }
    regex scored-tag-id { <tag-id> <.score-association-separator> <number-value> }
    rule scored-tag-ids-list { <scored-tag-id>+ % <list-separator> }
    token tag-type-id { ([ \w | '-' | '_' | '.' | ':' | \d ]+) <!{ $0 eq 'and' }> }
    rule tag-type-ids-list { <tag-type-id>+ % <list-separator> }

    # History spec
    rule history-spec { <item-ids-list> | <scored-item-ids-list> }

    # Profile spec
    rule profile-spec { <tag-ids-list> | <scored-tag-ids-list> }

    # Recommend by history
    rule recommend-by-history-command { <recommend-by-history> | <top-recommendations-by-history> | <top-recommendations> | <simple-recommend> }
    rule recommend-by-history { <.recommend-directive>
                              [ <.using-preposition> | <.by-preposition> | <.for-preposition> ] <.the-determiner>? <.history-phrase>?
                              <history-spec> }
    rule top-recommendations { <compute-directive> <.the-determiner>? <.most-relevant-phrase>? <integer-value>? <.recommendations> }
    rule top-recommendations-by-history { <top-recommendations>
                                        [ <.using-preposition> | <.by-preposition> | <.for-preposition> ] <.the-determiner>? <.history-phrase>?
                                        <history-spec> }
    rule most-relevant-phrase { <most-relevant> | 'top' <most-relevant>? }
    rule simple-recommend { <.recommend-directive> | <compute-directive> <recommendations> }

    # Recommend by profile
    rule recommend-by-profile-command { <recommend-by-profile> | <top-profile-recommendations> | <top-recommendations-by-profile> }
    rule recommend-by-profile { <.recommend-directive>
                              [ <.using-preposition> | <.by-preposition> | <.for-preposition> ] <.the-determiner>? <.profile-slot>
                              <profile-spec> }
    rule top-profile-recommendations { <compute-directive> <.the-determiner>? <.most-relevant-phrase>? <integer-value>? <.profile-slot> <.recommendations> }
    rule top-recommendations-by-profile { <top-recommendations>
                                        [ <.using-preposition> | <.by-preposition> | <.for-preposition> ] <.the-determiner>? <.profile-slot>
                                        <profile-spec> }

    # Make profile
    rule make-profile-command {  <make-profile-command-opening> <.the-determiner>? [ <history-phrase> <.list>? | <items-slot> ] <history-spec> }
    rule make-profile-command-opening { <compute-directive> [ <a-determiner> | <the-determiner> ]? <profile-slot>
                                      [ <using-preposition> | <by-preposition> | <for-preposition> ] }

    # Recommendations processing command
    rule extend-recommendations-command { [ 'extend' | 'join' [ 'across' ]? ] <recommendations>? <.with-preposition> <.the-determiner>? <.data>? <dataset-name> }

    # Prove command
    rule prove-recommendations-command { <prove-by-metadata> | <prove-by-history> }
    rule proof-item-spec { <item-id> | <item-ids-list> }
    rule recommendation-items-phrase { [ <recommendation> | <recommended> ] [ <item-slot> | <items-slot> ]? }
    rule prove-by-metadata {
        <prove-directive> <.the-determiner>? <recommendation-items-phrase> <proof-item-spec>? <.by-preposition> [ <metadata> | <.the-determiner>? <profile-slot> ] <profile-spec>? |
        <prove-directive> <.by-preposition> [ <metadata> | <profile-slot> ] <.the-determiner>? <recommendation-items-phrase> <proof-item-spec>
  }
    rule prove-by-history {
        <prove-directive> <.the-determiner>? <recommendation-items-phrase> <proof-item-spec>? [ <.by-preposition> | <.for-preposition> ] <.the-determiner>? <consumption-history> <history-spec>? |
        <prove-directive> <.by-preposition> <consumption-history> <.the-determiner>? <recommendation-items-phrase> <proof-item-spec>
  }

    # Classifications command
    rule classify-command { <classify-by-profile> | <classify-by-profile-rev> }
    rule ntop-nns { [ 'top' ]? <integer-value> [ 'top' ]? <.nearest-neighbors> }
    rule classify-by-profile { <.classify> <.the-determiner>? <.profile-slot>? <profile-spec>
                             <.to-preposition> <.tag-type>? <tag-type-id>
                             [ <.using-preposition> <ntop-nns> ]? }
    rule classify-by-profile-rev { <.classify> [ <.for-preposition> | <.to-preposition>] <.the-determiner>? <.tag-type>? <tag-type-id>
                                 [ <.by-preposition> | <.for-preposition> | <.using-preposition> ]? <.the-determiner>? <.profile-slot>?
                                 <profile-spec>
                                 [ <.and-conjunction>? <.using-preposition>? <ntop-nns> ]? }

    # Plot command
    rule plot-command { <plot-recommendation-scores> }
    rule plot-recommendation-scores { <plot-directive> <.the-determiner>? <recommendation-results> }

    # SMR query command
    rule smr-query-command { <smr-recommender-matrix-query>  | <smr-recommender-query> | <smr-filter-matrix> }
    rule smr-recommender-matrix-query { <display-directive> <.the-determiner>? <.smr-matrix-property-spec-openning> <smr-matrix-property-spec> }
    rule smr-recommender-query { <display-directive> <.the-determiner>? <.recommender>? <smr-property-spec> }
    rule smr-property-spec { <smr-context-property-spec> | <smr-matrix-property-spec> | <smr-sub-matrix-property-spec> }

    token smr-property-id { ([ \w | '-' | '_' | '.' | ':' | \d ]+) <!{ $0 eq 'and' || $0 eq 'pipeline' }> }

    rule smr-context-property-spec { <smr-tag-types> | <smr-item-column-name> | <smr-sub-matrices> | <smr-recommendation-matrix> | <properties> }
    rule smr-tag-types { <tag-types> }
    rule smr-item-column-name { <item-slot> <column> 'name' | 'itemColumnName' }
    rule smr-sub-matrices { [ 'sparse' ]? [ 'contingency' ]? [ 'sub-matrices' | [ 'sub' ]? <matrices> ] }
    rule smr-recommendation-matrix { <recommendation-matrix> }

    rule smr-matrix-property-spec-openning { <recommendation-matrix> | <sparse-matrix> | <matrix> }
    rule smr-matrix-property-spec { <.smr-matrix-property-spec-openning>? <smr-matrix-property> }

    rule smr-sub-matrix-property-spec-openning { 'sub-matrix' | 'sub' <matrix> | <tag-type> }
    rule smr-sub-matrix-property-spec { <.smr-sub-matrix-property-spec-openning>? <tag-type-id> <smr-matrix-property> }

    rule smr-matrix-property { <columns> | <rows> | <dimensions> | <density> | <number-of-columns> | <number-of-rows> | <smr-property-id> | <properties> }
    rule number-of-columns { <number-of> <columns> }
    rule number-of-rows { <number-of> <rows> }

    rule smr-filter-matrix { [ 'filter' | 'reduce' ] <.the-determiner>? <.smr-matrix-property-spec-openning>
                           [ <.using-preposition> | <.with-preposition> | <.by-preposition> ] <.the-determiner>? <profile-slot>?
                           <profile-spec> }

    # Find anomalies command
    rule find-anomalies-command { <find-proximity-anomalies> | <find-proximity-anomalies-simple> }
    rule find-proximity-anomalies-simple { <find-proximity-anomalies-preamble> }
    rule find-proximity-anomalies-preamble { <compute-directive> [ <.anomalies> [ <.by-preposition> <.proximity> ]? | <.proximity> <.anomalies> ] }
    rule find-proximity-anomalies { <find-proximity-anomalies-preamble> <.using-preposition> <proximity-anomalies-spec-list> }
    rule proximity-anomalies-spec-list { <proximity-anomalies-spec>* % <.list-separator> }
    rule proximity-anomalies-spec { <proximity-anomalies-nns-spec> | <proximity-anomalies-outlier-identifier-spec> | <proximity-anomalies-aggr-func-spec> | <proximity-anomalies-property-spec> }
    rule proximity-anomalies-nns-spec { <integer-value> <nearest-neighbors> }
    rule proximity-anomalies-aggr-func-spec {
        <.the-determiner>? <.aggregation> <.function> <variable-name> |
        <.aggregate> [ <.by-preposition> | <.using-preposition> ] <.the-determiner>? <.function> <variable-name> }
    rule proximity-anomalies-outlier-identifier-spec { <.the-determiner>? [ <.outlier> <.identifier> <variable-name> | <variable-name> <.outlier> <.identifier> ]}
    rule proximity-anomalies-property-spec { <.the-determiner>? <.property> <variable-name> }

    # Metadata recommender making command
    rule make-metadata-recommender-command { <make-metadata-recommender-full> | <make-metadata-recommender-simple> }
    rule make-metadata-recommender-preamble { <create-directive> <a-determiner>? [ <metadata> | <tag-type> ] <recommender> }
    rule make-metadata-recommender-simple { <.make-metadata-recommender-preamble> <.for-preposition> <.the-determiner>? <.tag-type>? <tag-type-id> }
    rule make-metadata-recommender-full {
        <.make-metadata-recommender-preamble> <.for-preposition> <.the-determiner>? <.tag-type>? <tag-type-id> <.over-preposition> <.the-determiner>? <.tag-types>? <tag-type-ids-list> }
}
