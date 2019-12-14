#==============================================================================
#
#   SMRMon-R actions in Raku Perl 6
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
#   The actions are implemented for the grammar:
#
#     RecommenderWorkflows::Grammar::WorkflowCommand
#
#   and the software monad SMRMon-R:
#
#     https://github.com/antononcube/R-packages/tree/master/SMRMon-R
#
#==============================================================================


use v6;

use RecommenderWorkflows::Grammar;

class RecommenderWorkflows::Actions::SMRMon-R {

  # Top
  method TOP($/) { make $/.values[0].made; }

  # General
  method variable-name($/) { make $/.Str; }
  method list-separator($/) { make ','; }
  method variable-names-list($/) { make 'c(' ~ $<variable-name>>>.made.join(', ') ~ ')'; }
  method integer-value($/) { make $/.Str; }
  method number-value($/) { make $/.Str; }

  # (Scored) item lists
  method item-id($/) { make '\"' ~ $/.Str ~ '\"'; }
  method item-ids-list($/) { make 'c(' ~ $<item-id>>>.made.join(', ') ~ ')'; }
  method scored-item-id($/) { make '\"' ~ $<item-id> ~ '\"' ~ '=' ~ $<number-value>; }
  method scored-item-ids-list($/) { make 'c(' ~ $<scored-item-id>>>.made.join(', ') ~ ')'; }

  # (Scored) tag lists
  method tag-id($/) { make '\"' ~ $/.Str ~ '\"'; }
  method tag-ids-list($/) { make 'c(' ~ $<tag-id>>>.made.join(', ') ~ ')'; }
  method scored-tag-id($/) { make '\"' ~ $<tag-id> ~ '\"' ~ '=' ~ $<number-value>; }
  method scored-tag-ids-list($/) { make 'c(' ~ $<scored-tag-id>>>.made.join(', ') ~ ')'; }
  method tag-type-id($/) { make '\"' ~ $/.Str ~ '\"'; }

  # Data load commands
  method data-load-command($/) { make $/.values[0].made; }
  method load-data($/) { make 'SMRMonSetData( data = ' ~ $<data-location-spec>.made ~ ')'; }
  method data-location-spec($/) { make $<dataset-name>.made; }
  method use-recommender($/) { make $<variable-name>.made; }
  method dataset-name($/) { make $/.Str; }

  # Create commands
  method create-command($/) { make $/.values[0].made; }
  method create-simple($/) { make 'SMRMonCreate()'; }
  method create-by-dataset($/) { make 'SMRMonCreate( data = ' ~ $<dataset-name>.made ~ ')'; }
  method create-by-matrices($/) { make 'SMRMonCreateFromMatrices( matrices = ' ~ $<variable-names-list>.made ~ ')'; }

  # Data statistics command
  method statistics-command($/) { make $/.values[0].made; }
  method show-data-summary($/) { make 'SMRMonEchoDataSummary()'; }
  method summarize-data($/) { make 'SMRMonEchoDataSummary()'; }
  method items-per-tag($/) { make 'SMRMonItemsPerTagDistribution()'; }
  method tags-per-items($/) { make 'SMRMonTagsPerItemDistribution()'; }

  # Recommend by history command
  method recommend-by-history-command($/) { make $/.values[0].made; }
  method recommend-by-history($/) { make 'SMRMonRecommend( history = ' ~ $<history-spec>.made ~ ')'; }
  method top-recommendations($/) { make 'SMRMonGetTopRecommendations( spec = NULL, nrecs = ' ~ $<integer-value>.made ~ ')'; }
  method top-recommendations-by-history($/) { make 'SMRMonRecommend( history = ' ~ $<history-spec>.made ~ ', nrecs = ' ~ $<top-recommendations><integer-value>.made ~ ')'; }
  method history-spec($/) { make $/.values[0].made; }

  # Recommend by profile command
  method recommend-by-profile-command($/) { make $/.values[0].made; }
  method recommend-by-profile($/) { make 'SMRMonRecommendByProfile( profile = ' ~ $<profile-spec>.made ~ ')'; }
  method top-profile-recommendations($/) { make 'SMRMonGetTopRecommendations( spec = NULL, nrecs = ' ~ $<integer-value>.made ~ ')'; }
  method top-recommendations-by-profile($/) { make 'SMRMonRecommendByProfile( profile = ' ~ $<profile-spec>.made ~ ', nrecs = ' ~ $<top-recommendations><integer-value>.made ~ ')'; }
  method profile-spec($/) { make $/.values[0].made; }

  # Make profile
  method make-profile-command($/) { make 'SMRMonProfile( history = ' ~ $<history-spec>.made ~ ')'; }

  # Process recommendations command
  method extend-recommendations-command($/) { make 'SMRMonJoinAcross( data = ' ~ $<dataset-name>.made ~ ')' }

  # Classifications command
  method classify-command($/) { make $/.values[0].made; }
  method classify-by-profile($/) {
    if $<ntop-nns> {
      make 'SMRMonClassifyByProfile( tagType = ' ~ $<tag-type-id>.made ~ ', profile = ' ~ $<profile-spec>.made ~ ', nTopNNs = ' ~ $<ntop-nns>.made ~ ')';
    } else {
      make 'SMRMonClassifyByProfile( tagType = ' ~ $<tag-type-id>.made ~ ', profile = ' ~ $<profile-spec>.made ~ ')';
    }
  }
  method classify-by-profile-rev($/) {
    if $<ntop-nns> {
      make 'SMRMonClassifyByProfile( tagType = ' ~ $<tag-type-id>.made ~ ', profile = ' ~ $<profile-spec>.made ~ ', nTopNNs = ' ~ $<ntop-nns>.made ~ ')';
    } else {
      make 'SMRMonClassifyByProfile( tagType = ' ~ $<tag-type-id>.made ~ ', profile = ' ~ $<profile-spec>.made ~ ')';
    }
  }
  method ntop-nns($/) { make $<integer-value>.Str; }
  method classify($/) { make 'classify'; }

  # Plot command
  method plot-command($/) { make $/.values[0].made; }
  method plot-recommendation-scores($/) { make 'SMRPlotScores()'; }

  # SMR query command
  method smr-query-command($/) { make $/.values[0].made; }

  method smr-recommender-query($/) { make $<smr-property-spec>.made; }
  method smr-recommender-matrix-query($/) { make $<smr-matrix-property-spec>.made; }

  method smr-property-spec($/) { make $/.values[0].made; }
  method smr-context-property-spec($/) { make 'SMRMonGetProperty(' ~ $/.values[0].made ~ ') %>% SMRMonEchoValue()'; }
  method smr-recommendation-matrix($/) { make '\"sparseMatrix\"'; }
  method smr-tag-types($/) { make '\"tagTypes\"'; }
  method smr-item-column-name($/) { make '\"itemColumnName\"'; }
  method smr-sub-matrices($/) { make '\"subMatrices\"'; }
  method smr-matrix-property-spec($/) { make 'SMRMonGetMatrixProperty(' ~ $<smr-matrix-property>.made ~ ', tagType = NULL ) %>% SMRMonEchoValue()'; }
  method smr-sub-matrix-property-spec($/) { make 'SMRMonGetMatrixProperty(' ~ $<smr-matrix-property>.made ~ ', tagType = ' ~ $<tag-type-id>.made ~ ' ) %>% SMRMonEchoValue()'; }
  method smr-matrix-property($/) { make $/.values[0].made(); }
  method smr-property-id($/) { make '\"' ~ $/.Str ~ '\"'; }
  method number-of-columns($/) { make '\"numberOfColumns\"'; }
  method number-of-rows($/) { make '\"numberOfRows\"'; }
  method rows($/) { make '\"rows\"'; }
  method columns($/) { make '\"columns\"'; }
  method dimensions($/) { make '\"dimensions\"'; }
  method density($/) { make '\"density\"'; }
  method properties($/) { make '\"properties\"';}

  method smr-filter-matrix($/) { make 'SMRMonFilterMatrix( profile = ' ~ $<profile-spec>.made ~ ')';  }

  # Pipeline command
  method pipeline-command($/) { make  $/.values[0].made; }
  method get-pipeline-value($/) { make 'SMRMonEchoValue()'; }

}