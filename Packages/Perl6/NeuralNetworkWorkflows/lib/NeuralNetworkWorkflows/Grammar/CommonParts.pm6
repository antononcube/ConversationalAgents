use v6;

# This role class has common command parts.
role NeuralNetworkWorkflows::Grammar::CommonParts {
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
    rule list-directive {[ 'list' | <display-directive> ]}

    # Value types
    token number-value { (\d+ ['.' \d*]?  [ [e|E] \d+]?) }
    token integer-value { \d+ }
    token percent { '%' | 'percent' }
    token percent-value { <number-value> <.percent> }
    token boolean-value { 'True' | 'False' | 'true' | 'false' | 'TRUE' | 'FALSE' }

    # Neural Network specific
    rule train-directive { 'train' | 'drill' }
    rule set-directive { 'set' | 'assign' }
    rule class-label { <variable-name> }
    rule neural-network {[ 'neural' ]? [ 'net' | 'network' | 'model' ]}
    rule neural-networks {[ 'neural' ]? [ 'nets' | 'networks' | 'models' ]}
    rule neural-network-chain {[ <neural-network> ]? 'chain'}
    rule neural-network-graph {[ <neural-network> ]? 'graph'}
    rule filler { <variable-name>+ }

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