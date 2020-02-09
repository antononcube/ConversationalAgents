use v6;

use RecommenderWorkflows::Grammar::FuzzyMatch;
use RecommenderWorkflows::Grammar::CommonParts;

# Recommender specific phrases
role RecommenderWorkflows::Grammar::RecommenderPhrases does RecommenderWorkflows::Grammar::CommonParts {
    token word-spec { \w+ }

    # Proto tokens
    token recommend-slot { 'recommend' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'recommend') }> | 'suggest' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'suggest') }> }

    proto token item-slot { * }
    token item-slot:sym<item> { 'item' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'item') }> }

    proto token items-slot { * }
    token items-slot:sym<items> { 'items' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'items') }> }

    proto token consumption-slot { * }
    token consumption-slot:sym<consumption> { 'consumption' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'consumption') }> }

    proto token history-slot { * }
    token history-slot:sym<history> { 'history' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'history' ) }> }

    proto token profile-slot { * }
    token profile-slot:sym<profile> { 'profile' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'profile' ) }> }

    # Regular tokens / rules
    token aggregate { 'aggregate' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'aggregate') }> }
    token aggregation { 'aggregation' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'aggregation') }> }
    token anomalies { 'anomalies' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'anomalies') }> }
    token anomaly { 'anomaly' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'anomaly') }> }
    token column { 'column' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'column') }> }
    token columns { 'columns' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'columns') }> }
    token density { 'density' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'density') }> }
    token dimensions { 'dimensions' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'dimensions') }> }
    token explain { 'explain' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'explain') }> }
    token explanations { 'explanation' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'explanation') }> | 'explanations' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'explanations') }> }
    token function { 'function' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'function') }> }
    token identifier { 'identifier' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'identifier') }> }
    token matrices { 'matrices' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'matrices') }> }
    token matrix { 'matrix' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'matrix') }> }
    token metadata { 'metadata' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'metadata') }> }
    token nearest { 'nearest' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'nearest') }> }
    token neighbors { 'neighbors' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'neighbors') }> }
    token outlier { 'outlier' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'outlier') }> }
    token outliers { 'outliers' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'outliers') }> | 'outlier' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'outlier') }> }
    token properties { 'properties' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'properties') }> }
    token property { 'property' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'property') }> }
    token proofs { 'proof' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'proof') }> | 'proofs' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'proofs') }> }
    token prove { 'prove' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'prove') }> }
    token proximity { 'proximity' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'proximity') }> }
    token recommend-directive { <recommend-slot> }
    token recommendation { 'recommendation' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'recommendation') }> }
    token recommendations { 'recommendations' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'recommendations') }> }
    token recommended { 'recommended' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'recommended') }> }
    token recommender { 'recommender' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'recommender') }> }
    token row { 'row' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'row') }> }
    token rows { 'rows' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'rows') }> }
    token sparse { 'sparse' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'sparse') }> }
    token threshold { 'threshold' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'threshold') }> }

    rule prove-directive { <prove> | <explain> }
    rule consumption-history { <consumption-slot>? <history-slot> }
    rule consumption-profile { <consumption-slot>? 'profile' }
    rule history-phrase { [ <item-slot> ]? <history-slot> }
    rule most-relevant { 'most' 'relevant' }
    rule nearest-neighbors { <nearest> <neighbors> | 'nns' }
    rule recommendation-matrices { [ <recommendation> | <recommender> ]? <matrices> }
    rule recommendation-matrix { [ <recommendation> | <recommender> ]? <matrix> }
    rule recommendation-results { [ <recommendation> | <recommendations> | 'recommendation\'s' ] <results> }
    rule recommended-items { <recommended> <items-slot> | [ <recommendations> | <recommendation> ]  <.results>?  }
    rule recommender-object { <recommender> [ <object> | <system> ]? | 'smr' }
    rule sparse-matrix { <sparse> <matrix> }
    rule tag-type { 'tag' 'type' }
    rule tag-types { 'tag' 'types' }

    # LSA specific
    token analysis { 'analysis' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'analysis') }> }
    token document { 'document' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'document') }> }
    token entries { 'entries' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'entries') }> }
    # token identifier { 'identifier' }
    token indexing { 'indexing' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'indexing') }> }
    token ingest { 'ingest' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'ingest') }> | 'load' | 'use' | 'get' }
    token item { 'item' }
    # For some reason using <item> below gives the error: "Too many positionals passed; expected 1 argument but got 2".
    token latent { 'latent' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'latent') }> }
    # token matrix { 'matrix' }
    token semantic { 'semantic' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'semantic') }> }
    token term { 'term' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'term') }> }
    # token threshold { 'threshold' }
    token weight { 'weight' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'weight') }> }
    token word { 'word' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'word') }> }

    rule doc-term-mat { [ <document> | 'item' ] [ <term> | <word> ] <matrix> }
    rule lsa-object { <lsa-phrase>? 'object' }
    rule lsa-phrase { <latent> <semantic> <analysis> | 'lsa' | 'LSA' }
    rule lsi-phrase { <latent> <semantic> <indexing> | 'lsi' | 'LSI' }
    rule matrix-entries { [ <doc-term-mat> | <matrix> ]? <entries> }
    rule the-outliers { <the-determiner> <outliers> }

    # LSI specific
    token frequency { 'frequency' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'frequency') }> }
    # token function { 'function' }
    token functions { 'function' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'function') }> | 'functions' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'functions') }> }
    token global { 'global' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'global') }> }
    token local { 'local' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'local') }> }
    token normalization { 'normalization' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'normalization') }> }
    token normalizer { 'normalizer' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'normalizer') }> }
    token normalizing { 'normalizing' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'normalizing') }> }

    rule global-function-phrase { <global> <term> ?<weight>? <function> }
    rule local-function-phrase { <local> <term>? <weight>? <function> }
    rule normalizer-function-phrase { [ <normalizer> | <normalizing> | <normalization> ] <term>? <weight>? <function>? }
}
