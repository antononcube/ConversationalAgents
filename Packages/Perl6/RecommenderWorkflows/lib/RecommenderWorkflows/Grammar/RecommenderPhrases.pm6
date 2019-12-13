use v6;

use RecommenderWorkflows::Grammar::FuzzyMatch;

# Recommender specific phrases
role RecommenderWorkflows::Grammar::RecommenderPhrases {

  token word-spec { \w+ }

  # Proto tokens
  token recommend-slot { 'recommend' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'recommend' ) }> }

  proto token item-slot { * }
  token item-slot:sym<item> { 'item' }

  proto token items-slot { * }
  token items-slot:sym<items> { 'items' }

  proto token consumption-slot { * }
  token consumption-slot:sym<consumption> { 'consumption' }

  proto token history-slot { * }
  token history-slot:sym<history> { 'history' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'history' ) }> }

  # Regular tokens / rules
  rule history-phrase { [ <item-slot> ]? <history-slot> }
  rule consumption-profile { <consumption-slot>? 'profile' }
  rule consumption-history { <consumption-slot>? <history-slot> }
  token profile { 'profile' }
  token recommend-directive { <recommend-slot> | 'suggest' }
  token recommendation { 'recommendation' }
  token recommendations { 'recommendations' }
  rule recommender { 'recommender' }
  rule recommender-object { <recommender> [ <object> | <system> ]? | 'smr' }
  rule recommended-items { 'recommended' 'items' | [ <recommendations> | <recommendation> ]  <.results>?  }
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
