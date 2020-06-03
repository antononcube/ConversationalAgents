use v6;

use RecommenderWorkflows::Grammar::FuzzyMatch;

# This role class has common command parts.
role RecommenderWorkflows::Grammar::CommonParts {
    # Speech parts
    token a-determiner { 'a' | 'an' }
    token and-conjunction { 'and' }
    token apply-verb { 'apply' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'apply') }>}
    token assign { 'assign' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'assign') }> | 'set' }
    token by-preposition { 'by' | 'with' | 'using' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'using') }> }
    token do-verb { 'do' }
    token for-preposition { 'for' | 'with' }
    token from-preposition { 'from' }
    token get-verb { 'obtain' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'obtain') }> | 'get' | 'take' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'take') }> }
    token object { 'object' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'object') }> }
    token of-preposition { 'of' }
    token over-preposition { 'over' }
    token per { 'per' }
    token results { 'results' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'results') }> }
    token simple { 'simple' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'simple') }> | 'direct' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'direct') }> }
    token system { 'system' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'system') }> }
    token the-determiner { 'the' }
    token to-preposition { 'to' | 'into' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'into') }> }
    token transform-verb { 'transform' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'transform') }>}
    token use-verb { 'use' | 'utilize' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'utilize') }> }
    token using-preposition { 'using' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'using') }> | 'with' | 'over' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'over') }> }
    token with-preposition { 'using' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'using') }> | 'with' | 'by' }

    rule for-which-phrase { 'for' 'which' | 'that' 'adhere' 'to' }
    rule number-of { [ 'number' | 'count' ] 'of' }

    # Data
    token dataset { 'dataset' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'dataset') }> }
    token dataset-name { ([ \w | '_' | '-' | '.' | \d ]+) <!{ $0 eq 'and' }> }
    token variable-name { ([ \w | '_' | '-' | '.' | \d ]+) <!{ $0 eq 'and' }> }

    rule data { <data-frame> | 'data' | <dataset> | <time-series-data> }
    rule data-frame { 'data' 'frame' }
    rule records { 'rows' | 'records' }
    rule time-series-data { 'time' 'series' [ 'data' ]? }

    # Directives
    token classify { 'classify' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'classify') }> }
    token compute-directive { 'compute' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'compute') }> | 'find' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'find') }> | 'calculate' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'calculate') }> }
    token create-directive { 'create' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'create') }> | 'make' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'make') }> }
    token diagram { 'plot' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'plot') }> | 'plots' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'plots') }> | 'graph' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'graph') }> | 'chart' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'chart') }> }
    token display-directive { 'display' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'display') }> | 'show' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'show') }> | 'echo' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'echo') }> }
    token generate-directive { 'generate' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'generate') }> | 'create' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'create') }> | 'make' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'make') }> }

    rule compute-and-display { <compute-directive> [ 'and' <display-directive> ]? }
    rule load-data-directive { ( 'load' | 'ingest' ) <.the-determiner>? <data> }
    rule plot-directive { 'plot' | 'chart' | <display-directive> <diagram> }
    rule use-directive { [ <get-verb> <and-conjunction>? ]? <use-verb> }

    # Value types
    token boolean-value { 'True' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'True') }> | 'False' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'False') }> | 'true' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'true') }> | 'false' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'false') }> }
    token integer-value { \d+ }
    token number-value { (\d+ ['.' \d+]?  [ [e|E] \d+]?) }
    token percent { '%' | 'percent' }
    token percent-value { <number-value> <.percent> }

    # Lists of things
    token list-separator-symbol { ',' | '&' | 'and' | ',' \h* 'and' }
    token list-separator { <.ws>? <list-separator-symbol> <.ws>? }
    token list { 'list' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'list') }> }

    # Variables list
    rule variable-names-list { <variable-name>+ % <list-separator> }

    # Number list
    rule number-value-list { <number-value>+ % <list-separator> }

    # Range
    rule range-spec-step { <with-preposition> | <with-preposition>? 'step' }
    rule range-spec { [ <.from-preposition> <number-value> ] [ <.to-preposition> <number-value> ] [ <.range-spec-step> <number-value> ]? }
}
