use v6;

# This role class has common command parts.
role LatentSemanticAnalysisWorkflows::Grammar::CommonParts {

    # Speech parts
    token a-determiner { 'a' | 'an'}
    token and-conjunction { 'and' }
    token apply-verb { 'apply' }
    token assign { 'assign' | 'set' }
    token by-preposition { 'by' | 'with' | 'using' }
    token do-verb { 'do' }
    token for-preposition { 'for' | 'with' }
    token from-preposition { 'from' }
    token get-verb { 'obtain' | 'get' | 'take' }
    token object { 'object' }
    token of-preposition { 'of' }
    token per { 'per' }
    token plot { 'plot' }
    token plots { 'plot' | 'plots' }
    token results { 'results' }
    token simple { 'simple' | 'direct' }
    token the-determiner { 'the' }
    token to-preposition { 'to' | 'into' }
    token transform-verb { 'transform' }
    token use-verb { 'use' | 'utilize' }
    token using-preposition { 'using' | 'with' | 'over' }
    token with-preposition { 'using' | 'with' | 'by' }

    rule for-which-phrase { 'for' 'which' | 'that' 'adhere' 'to' }
    rule number-of { [ 'number' | 'count' ] 'of' }

    # Data
    token dataset-name { ([ \w | '_' | '-' | '.' | \d ]+) <!{ $0 eq 'and' }> }
    token records { 'rows' | 'records' }
    token variable-name { ([ \w | '_' | '-' | '.' | \d ]+) <!{ $0 eq 'and' }> }

    rule data { <data-frame> | 'data' | 'dataset' }
    rule data-frame { 'data' 'frame' }
    rule time-series-data { 'time' 'series' 'data'? }

    # Directives
    token classify { 'classify' }
    token compute-directive { 'compute' | 'find' | 'calculate' }
    token create-directive { 'create' | 'make' }
    token diagram { 'plot' | 'plots' | 'graph' | 'chart' }
    token display-directive { 'display' | 'show' | 'echo' }
    token generate-directive { 'generate' | 'create' | 'make' }
    token represent-directive { <represent> | 'render' | 'reflect' }

    rule compute-and-display { <compute-directive> [ 'and' <display-directive> ]? }
    rule load-data-directive { ( 'load' | 'ingest' ) <.the-determiner>? <data> }
    rule plot-directive { 'plot' | 'chart' | <display-directive> <diagram> }
    rule use-directive { [ <get-verb> <and-conjunction>? ]? <use-verb> }

    # Value types
    token number-value { (\d+ ['.' \d*]?  [ [e|E] \d+]?) }
    token integer-value { \d+ }
    token percent { '%' | 'percent' }
    token percent-value { <number-value> <.percent> }
    token boolean-value { 'True' | 'False' | 'true' | 'false' | 'TRUE' | 'FALSE' }

    # LSA specific
    token analysis { 'analysis' }
    token document { 'document' }
    token entries { 'entries' }
    token identifier { 'identifier' }
    token indexing { 'indexing' }
    token ingest { 'ingest' | 'load' | 'use' | 'get' }
    token item { 'item' } # For some reason using <item> below gives the error: "Too many positionals passed; expected 1 argument but got 2".
    token latent { 'latent' }
    token matrix { 'matrix' }
    token represent { 'represent' }
    token semantic { 'semantic' }
    token term { 'term' }
    token threshold { 'threshold' }
    token topic { 'topic' }
    token topics { 'topics' }
    token query { 'query' }
    token weight { 'weight' }
    token word { 'word' }

    rule lsa-object { <lsa-phrase>? 'object' }
    rule lsa-phrase { <latent> <semantic> <analysis> | 'lsa' | 'LSA' }
    rule lsi-phrase { <latent> <semantic> <indexing> | 'lsi' | 'LSI' }
    rule doc-term-mat { [ <document> | 'item' ] [ <term> | <word> ] <matrix> }
    rule matrix-entries { [ <doc-term-mat> | <matrix> ]? <entries> }
    rule the-outliers { <the-determiner> <outliers> }

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