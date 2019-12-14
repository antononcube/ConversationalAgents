use v6;

use RecommenderWorkflows::Grammar::FuzzyMatch;

# This role class has common command parts.
role RecommenderWorkflows::Grammar::CommonParts {
    # Speech parts
    token do-verb { 'do' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'do') }> }
    token with-preposition { 'using' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'using') }> | 'with' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'with') }> | 'by' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'by') }> }
    token using-preposition { 'using' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'using') }> | 'with' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'with') }> | 'over' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'over') }> }
    token by-preposition { 'by' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'by') }> | 'with' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'with') }> | 'using' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'using') }> }
    token for-preposition { 'for' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'for') }> | 'with' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'with') }> }
    token of-preposition { 'of' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'of') }> }
    token from-preposition { 'from' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'from') }> }
    token to-preposition { 'to' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'to') }> | 'into' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'into') }> }
    token assign { 'assign' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'assign') }> | 'set' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'set') }> }
    token a-determiner { 'a' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'a') }> | 'an' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'an') }> }
    token and-conjuction { 'and' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'and') }> }
    token the-determiner { 'the' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'the') }> }
    rule for-which-phrase { 'for' 'which' | 'that' 'adhere' 'to' }
    rule number-of { [ 'number' | 'count' ] 'of' }
    token per { 'per' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'per') }> }
    token results { 'results' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'results') }> }
    token simple { 'simple' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'simple') }> | 'direct' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'direct') }> }
    token use-verb { 'use' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'use') }> | 'utilize' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'utilize') }> }
    token get-verb { 'obtain' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'obtain') }> | 'get' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'get') }> | 'take' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'take') }> }
    token object { 'object' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'object') }> }
    token system { 'system' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'system') }> }

    # Data
    rule records { 'rows' | 'records' }
    rule time-series-data { 'time' 'series' [ 'data' ]? }
    rule data-frame { 'data' 'frame' }
    token dataset { 'dataset' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'dataset') }> }
    rule data { <data-frame> | 'data' | <dataset> | <time-series-data> }
    token dataset-name { ([ \w | '_' | '-' | '.' | \d ]+) <!{ $0 eq 'and' }> }
    token variable-name { ([ \w | '_' | '-' | '.' | \d ]+) <!{ $0 eq 'and' }> }

    # Directives
    rule load-data-directive { ( 'load' | 'ingest' ) <.the-determiner>? <data> }
    token create-directive { 'create' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'create') }> | 'make' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'make') }> }
    token generate-directive { 'generate' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'generate') }> | 'create' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'create') }> | 'make' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'make') }> }
    token compute-directive { 'compute' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'compute') }> | 'find' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'find') }> | 'calculate' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'calculate') }> }
    token display-directive { 'display' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'display') }> | 'show' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'show') }> | 'echo' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'echo') }> }
    rule compute-and-display { <compute-directive> [ 'and' <display-directive> ]? }
    token diagram { 'plot' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'plot') }> | 'plots' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'plots') }> | 'graph' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'graph') }> | 'chart' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'chart') }> }
    rule plot-directive { 'plot' | 'chart' | <display-directive> <diagram> }
    rule use-directive { [ <get-verb> <and-conjuction>? ]? <use-verb> }
    token classify { 'classify' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'classify') }> }

    # Value types
    token number-value { (\d+ ['.' \d+]?  [ [e|E] \d+]?) }
    token integer-value { \d+ }
    token percent { '%' | 'percent' }
    token percent-value { <number-value> <.percent> }
    token boolean-value { 'True' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'True') }> | 'False' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'False') }> | 'true' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'true') }> | 'false' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'false') }> }

    # Lists of things
    token list-separator-symbol { ',' | '&' | 'and' }
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
