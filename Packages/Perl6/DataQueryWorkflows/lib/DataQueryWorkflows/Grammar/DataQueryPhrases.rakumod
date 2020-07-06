use v6;

#use DataQueryWorkflows::Grammar::FuzzyMatch;
use DataQueryWorkflows::Grammar::CommonParts;

# Data query specific phrases
role DataQueryWorkflows::Grammar::DataQueryPhrases
        does DataQueryWorkflows::Grammar::CommonParts {
    # Tokens
    token arrange-verb { 'arrange' }
    token ascending-adjective { 'ascending' }
    token combine-verb { 'combine' }
    token descending-adjective { 'descending' }
    token filter-verb { 'filter' }
    token full-adjective { 'full' }
    token glimpse-verb { 'glimpse' }
    token group-verb { 'group' }
    token join-noun { 'join' }
    token inner-adjective { 'inner' }
    token left-adjective { 'left' }
    token mutate-verb { 'mutate' }
    token order-verb { 'order' }
    token right-adjective { 'right' }
    token select-verb { 'select' }
    token semi-adjective { 'semi' }
    token sort-verb { 'sort' }
    token summarise-verb { 'summarise' }
    token summarize-verb { 'summarize' }
    token ungroup-verb { 'ungroup' }

    rule for-which-phrase { <for-preposition> 'which' | <that-pronoun> 'adhere' <to-preposition> }
    rule cross-tabulate-phrase { 'cross' 'tabulate' }

    # True dplyr; see comments below.
    token ascending { <ascending-adjective> | 'asc' }
    token descending { <descending-adjective> | 'desc' }
    token mutate { <mutate-verb> }
    token order { <order-verb> }

    rule arrange { [ <arrange-verb> | <order-verb> | <sort-verb> ] [ <by-preposition> | <using-preposition> ]? }
    rule data-phrase { <.the-determiner>? <data> }
    rule filter { <filter-verb> | <select-verb> }
    rule group-by { <group-verb> [ <by-preposition> | <using-preposition> ] }
    rule select { <select-verb> | 'keep' 'only'? }

    # Predicates
    rule predicates-list { <predicate>+ % <list-separator> }
    #rule predicate { <predicate-simple> [ <logical-connective> <predicate-simple> ]* }
    rule predicate { <predicate-sum> }
    rule predicate-sum { <predicate-product>+ % <or-operator> }
    rule predicate-product { <predicate-term>+ % <and-operator> }
    rule predicate-term { <predicate-simple> | <predicate-group> }
    rule predicate-group { '(' <predicate-term> ')' }

    rule predicate-simple { <lhs=predicate-value> [ 'is' ]? <predicate-relation> <rhs=predicate-value> }
    rule predicate-value { <quoted-variable-name> | <number-value> }
    rule predicate-operator { <logical-connective> | <predicate-relation> }
    rule logical-connective { <and-operator> | <or-operator> }
    token and-operator { <and-conjunction> | '&&' | '&' }
    token or-operator { <or-conjunction> | '||' | '|' }
    rule predicate-relation {
        <equal-relation> | <not-equal-relation> |
        <less-relation> | <less-equal-relation> |
        <greater-relation> | <greater-equal-relation> |
        <same-relation> | <not-same-relation>
        <in-relation> | <not-in-relation> |
        <like-relation> }
    rule equal-relation { '=' | '==' | 'equals' | 'equal' 'to'? | 'is' }
    rule not-equal-relation { '!=' | 'not' 'equal' 'to'? | 'is' 'not' }
    rule less-relation { '<' | 'less' 'than'? }
    rule less-equal-relation { '<=' | 'less' 'or'? 'equal' 'than'? }
    rule greater-relation { '>' | 'greater' 'than'? }
    rule greater-equal-relation { '>=' | 'greater' 'or'? 'equal' 'than'? }
    rule same-relation { '===' | 'same' 'as'? }
    rule not-same-relation { '=!=' | 'not' 'same' 'as'? }
    rule in-relation { 'in' | 'belongs' 'to' }
    rule not-in-relation { '!in' | 'not' 'in' | [ 'does' 'not' | 'doesn\'t' ] 'belong' 'to' }
    rule like-relation { 'like' | 'similar' 'to' }
}
