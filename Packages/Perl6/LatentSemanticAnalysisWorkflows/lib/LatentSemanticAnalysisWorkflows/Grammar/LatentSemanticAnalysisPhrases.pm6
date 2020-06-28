use v6;

use LatentSemanticAnalysisWorkflows::Grammar::CommonParts;

# Latent Semantic Analysis (LSA) phrases
role LatentSemanticAnalysisWorkflows::Grammar::LatentSemanticAnalysisPhrases
        does LatentSemanticAnalysisWorkflows::Grammar::CommonParts {

    # For some reason using <item> below gives the error: "Too many positionals passed; expected 1 argument but got 2".

    # LSA specific
    token analysis { 'analysis' }
    token document { 'document' }
    token documents { 'documents' }
    token entries { 'entries' }
    token identifier { 'identifier' }
    token indexing { 'indexing' }
    token ingest { 'ingest' | 'load' | 'use' | 'get' }
    token item { 'item' }
    token latent { 'latent' }
    token matrix { 'matrix' }
    token partition { 'partition' }
    token represent { 'represent' }
    token semantic { 'semantic' }
    token table-noun { 'table' }
    token term { 'term' }
    token threshold { 'threshold' }
    token thesaurus { 'thesaurus' }
    token topic { 'topic' }
    token topics { 'topics' }
    token query { 'query' }
    token weight { 'weight' }
    token word { 'word' }
    token synonyms { 'synonyms' }
    token synonym { 'synonym' }

    rule lsa-object { <lsa-phrase>? 'object' }
    rule lsa-phrase { <latent> <semantic> <analysis> | 'lsa' | 'LSA' }
    rule lsi-phrase { <latent> <semantic> <indexing> | 'lsi' | 'LSI' }
    rule doc-term-mat { [ <document> | 'item' ] [ <term> | <word> ] <matrix> }
    rule matrix-entries { [ <doc-term-mat> | <matrix> ]? <entries> }
    rule the-outliers { <the-determiner> <outliers> }
    rule number-of-terms-phrase { <number-of>? <terms> }

    # Document term matrix creation related
    rule data-element { 'sentence' | 'paragraph' | 'section' | 'chapter' | 'word' }
    rule data-elements { 'sentences' | 'paragraphs' | 'sections' | 'chapters' | 'words' }

    rule docs { 'document' | 'documents' | 'item' | 'items' }
    rule terms { 'word' | 'words' | 'term' | 'terms' }

    rule stemming-rules-phrase { 'stemming' ['rules']? }
    rule stop-words-phrase { 'stop' 'words' }

    rule text-corpus-thrase { 'texts' | 'text' [ 'corpus' | 'collection' ]? }

    # Topics and thesaurus
    rule statistical-thesaurus-phrase { <statistical>? <thesaurus> }
    rule topics-table-phrase { 'topics' 'table' }

    # LSI specific
    token frequency { 'frequency' }
    token function { 'function' }
    token functions { 'function' | 'functions' }
    token global { 'global' }
    token local { 'local' }
    token normalization { 'normalization' }
    token normalizer { 'normalizer' }
    token normalizing { 'normalizing' }

    rule global-function-phrase { <global> <term> ?<weight>? <function> }
    rule local-function-phrase { <local> <term>? <weight>? <function> }
    rule normalizer-function-phrase { [ <normalizer> | <normalizing> | <normalization> ] <term>? <weight>? <function>? }

    # Matrix factorization specific
    rule SVD-phrase { 'singular' 'value' 'decomposition' }
    rule PCA-phrase { 'principal' 'component' 'analysis' }
    rule NNMF-phrase { [ 'non' 'negative' | 'non-negative' | 'nonnegative' ] 'matrix' 'facotrization' }
    rule ICA-phrase { 'independent' 'component' 'analysis' }
}