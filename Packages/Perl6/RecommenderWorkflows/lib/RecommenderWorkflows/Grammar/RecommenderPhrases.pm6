use v6;

# All edits that are one edit from `word`
sub edits1(Str $word) {
    my @letters = 'a'..'z';
    my @splits = (|($word.substr(0..$_-1), $word.substr($_)) for 0..$word.chars);
    my @deletes = do for @splits -> $L, $R { if $R {$L ~ $R.substr(1)} };
    my @transposes = do for @splits -> $L, $R { if $R.chars > 1 {$L ~ $R.substr(1,1) ~ $R.substr(0,0) ~ $R.substr(2)}}
    my @replaces = do for @splits -> $L, $R {@letters.map: {$L~$_~$R.substr(1)} if $R}
    my @inserts = do for @splits -> $L, $R {@letters.map: {$L ~ $_ ~ $R}}
    return (gather (@deletes, @transposes, @replaces, @inserts).deepmap: *.take).unique;
}

# All edits that are two edits from `word`
sub edits2(Str $word) {
    return ( for edits1($word) -> $e1 { $_ for edits1($e1) } )
}

# Generate possible spelling corrections for word
sub candidates(Str $word) {
    edits1($word) || edits2($word) || ($word,);
}

sub is-fuzzy-match( Str $candidate, Str $actual ) {
  if  candidates($actual).contains($candidate) {
    say "Possible misspelling of '$actual' as '$candidate'.";
    return True;
  }
  return False;
}


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
