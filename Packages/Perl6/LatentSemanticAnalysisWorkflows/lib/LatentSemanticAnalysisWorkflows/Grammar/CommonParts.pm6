use v6;

# This role class has common command parts.
role LatentSemanticAnalysisWorkflows::Grammar::CommonParts {

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
    token apply-verb { 'apply' }
    token transform-verb { 'transform' }
    token get-verb { 'obtain' | 'get' | 'take' }
    token object { 'object' }
    token plot { 'plot' }
    token plots { 'plot' | 'plots' }

    # Data
    token records { 'rows' | 'records' }
    rule time-series-data { 'time' 'series' 'data'? }
    rule data-frame { 'data' 'frame' }
    rule data { <data-frame> | 'data' | 'dataset' }
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
    token number-value { (\d+ ['.' \d*]?  [ [e|E] \d+]?) }
    token integer-value { \d+ }
    token percent { '%' | 'percent' }
    token percent-value { <number-value> <.percent> }
    token boolean-value { 'True' | 'False' | 'true' | 'false' | 'TRUE' | 'FALSE' }

    # LSA specific
    token document { 'document' }
    token latent { 'latent' }
    token semantic { 'semantic' }
    token analysis { 'analysis' }
    token indexing { 'indexing' }
    token ingest { 'ingest' | 'load' | 'use' | 'get' }
    token threshold { 'threshold' }
    token identifier { 'identifier' }
    token weight { 'weight' }
    token term { 'term' }
    token word { 'word' }
    token item { 'item' } # For some reason using <item> below gives the error: "Too many positionals passed; expected 1 argument but got 2".
    token entries { 'entries' }
    token matrix { 'matrix' }

    rule lsa-object { <lsa-phrase>? 'object' }
    rule lsa-phrase { <latent> <semantic> <analysis> | 'lsa' | 'LSA' }
    rule lsi-phrase { <latent> <semantic> <indexing> | 'lsi' | 'LSI' }
    rule doc-term-mat { [ <document> | 'item' ] [ <term> | <word> ] <matrix> }
    rule matrix-entries { [ <doc-term-mat> | <matrix> ]? <entries> }
    rule the-outliers { <the-determiner> <outliers> }

    # LSI specific
    token normalization { 'normalization' }
    token normalizing { 'normalizing' }
    token normalizer { 'normalizer' }
    token global { 'global' }
    token local { 'local' }
    token function { 'function' }
    token functions { 'function' | 'functions' }
    token frequency { 'frequency' }
    rule global-function-phrase { <global> <term> ?<weight>? <function> }
    rule local-function-phrase { <local> <term>? <weight>? <function> }
    rule normalizer-function-phrase { [ <normalizer> | <normalizing> | <normalization> ] <term>? <weight>? <function>? }

    # Lists of things
    token list-separator-symbol { ',' | '&' | 'and' | ',' \h* 'and' }
    token list-separator { <.ws>? <list-separator-symbol> <.ws>? }
    token list { 'list' }

    # Number list
    rule number-value-list { <number-value>+ % <list-separator>? }

    rule range-spec-step { <with-preposition>? 'step' | <with-preposition> }
    rule range-spec { [ <.from-preposition> <number-value> ] [ <.to-preposition> <number-value> ] [ <.range-spec-step> <number-value> ]? }

    # Expressions
    token wl-expr { \S+ }

}