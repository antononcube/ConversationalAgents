use v6;

# This role class has common command parts.
role DataQueryWorkflows::Grammar::CommonParts {

    # Speech parts
    token a-determiner { 'a' | 'an'}
    token all-determiner { 'all' }
    token and-conjunction { 'and' }
    token apply-verb { 'apply' }
    token assign { 'assign' | 'set' }
    token automatic { 'automatic' }
    token axes-noun { 'axes' }
    token axis-noun { 'axis' }
    token both-determiner { 'both' }
    token bottom-noun { 'bottom' }
    token by-preposition { 'by' | 'with' | 'using' }
    token calculation { 'calculation' }
    token columns { 'columns' }
    token count-verb { 'count' }
    token counts-noun { 'counts' }
    token create { 'create' }
    token data-noun { 'data' }
    token dataset-noun { 'dataset' }
    token default { 'default' }
    token difference { 'difference' }
    token directly-adverb { 'directly' }
    token do-verb { 'do' }
    token element { 'element' }
    token elements { 'elements' }
    token for-preposition { 'for' | 'with' }
    token frame-noun { 'frame' }
    token from-preposition { 'from' }
    token function { 'function' }
    token functions { 'functions' }
    token get-verb { 'obtain' | 'get' | 'take' }
    token histogram { 'histogram' }
    token histograms { 'histograms' }
    token in-preposition { 'in' }
    token is-verb { 'is' }
    token missing-adjective { 'missing' }
    token model { 'model' }
    token object { 'object' }
    token of-preposition { 'of' }
    token over-preposition { 'over' }
    token per-preposition { 'per' }
    token plot { 'plot' }
    token plots { 'plot' | 'plots' }
    token results { 'results' }
    token rows { 'rows' }
    token run-verb { 'run' | 'runs' }
    token running-verb { 'running' }
    token simple { 'simple' | 'direct' }
    token simply-adverb { 'simply' }
    token simulate { 'simulate' }
    token simulation { 'simulation' }
    token smallest { 'smallest' }
    token step-noun { 'step' }
    token summaries { 'summaries' }
    token summary { 'summary' }
    token that-pronoun { 'that' }
    token them-pronoun { 'them' }
    token time-noun { 'time' }
    token the-determiner { 'the' }
    token this-pronoun { 'this' }
    token to-preposition { 'to' | 'into' }
    token top-noun { 'top' }
    token transform-verb { 'transform' }
    token use-verb { 'use' | 'utilize' }
    token using-preposition { 'using' | 'with' | 'over' }
    token value-noun { 'value' }
    token values-noun { 'values' }
    token variable-noun { 'variable' }
    token variables-noun { 'variables' }
    token way-noun { 'way' }
    token weight { 'weight' }
    token weights { 'weights' }
    token with-preposition { 'using' | 'with' | 'by' }

    rule creation { 'creation' | 'making' <of-preposition>? }
    rule for-which-phrase { 'for' 'which' | 'that' 'adhere' 'to' }
    rule missing-values-phrase { <missing-adjective> <values-noun>? }
    rule number-of { [ 'number' | 'count' ] 'of' }
    rule simple-way-phrase { 'simple' [ 'way' | 'manner' ] }

    # Data
    token records { 'rows' | 'records' }
    rule time-series-data { 'time' 'series' <data-noun>? }
    rule data-frame { <data-noun> <frame-noun> }
    rule data { <data-frame> | <data-noun> | <dataset-noun> | <time-series-data> }
    token dataset-name { ([ \w | '_' | '-' | '.' | \d ]+) <!{ $0 eq 'and' }> }
    token variable-name { ([ \w | '_' | '-' | '.' | \d ]+) <!{ $0 eq 'and' }> }
    token date-spec { [ \d ** 4 ] '-' [ \d ** 2 ] '-' [ \d ** 2 ] }

    # Directives
    token classify { 'classify' }
    token compute-directive { 'compute' | 'find' | 'calculate' }
    token create-directive { 'create' | 'make' }
    token delete-directive { 'delete' | 'drop' | 'erase' }
    token diagram { <plot> | 'plots' | 'graph' | 'chart' }
    token display-directive { 'display' | 'show' | 'echo' }
    token generate-directive { 'generate' | 'create' | 'make' }
    token summarize-directive { 'summarize' }

    rule compute-and-display { <compute-directive> [ <and-conjunction> <display-directive> ]? }
    rule load-data-directive { ( 'load' | 'ingest' ) <.the-determiner>? <data> }
    rule plot-directive { <plot> | 'chart' | <display-directive> <diagram> }
    rule use-directive { [ <get-verb> <and-conjunction>? ]? <use-verb> }


    # Value types
    token number-value { (\d+ ['.' \d*]?  [ [e|E] \d+]?) }
    token integer-value { \d+ }
    token percent { '%' | 'percent' }
    token percent-value { <number-value> <.percent> }
    token boolean-value { 'True' | 'False' | 'true' | 'false' | 'TRUE' | 'FALSE' }

    # Lists of things
    token list-separator-symbol { ',' | '&' | 'and' | ',' \h* 'and' }
    token list-separator { <.ws>? <list-separator-symbol> <.ws>? }
    token list-noun { 'list' }

    # Number list
    rule number-value-list { <number-value>+ % <list-separator>? }

    # Variable names list
    rule variable-names-list { <variable-name>+ % <list-separator> }

    # Range spec
    rule range-spec { <range-spec-from> <range-spec-to> <range-spec-step>? }
    rule range-spec-from { <.from-preposition> <number-value> }
    rule range-spec-to { <.to-preposition> <number-value> }
    rule range-spec-step { <.range-spec-step-phrase> <number-value> }
    rule range-spec-step-phrase { <with-preposition>? <step-noun> | <with-preposition> }

    # Programming languages ranges
    rule wl-range-spec { [ 'Range' '[' | 'Range[' ] <number-value-list> ']' }
    rule r-range-spec { [ 'seq' '(' | 'seq(' ] <number-value-list> ')' }
    rule wl-numeric-list-spec { '{' <number-value-list> '}' }
    rule r-numeric-list-spec { [ [ 'c' | 'list' ] '(' | 'c(' | 'list(' ] <number-value-list> ')' }

    # Operators
    token equal-symbol { '=' }
    token equal2-symbol { '==' }
    token assign-to-symbol { "=" | ':=' | '<-' }

    # Expressions
    token wl-expr { \S+ }
}