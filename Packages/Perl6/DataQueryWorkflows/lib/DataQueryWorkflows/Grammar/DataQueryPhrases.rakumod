use v6;

#use DataQueryWorkflows::Grammar::FuzzyMatch;
use DataQueryWorkflows::Grammar::CommonParts;

# Data query specific phrases
role DataQueryWorkflows::Grammar::DataQueryPhrases
        does DataQueryWorkflows::Grammar::CommonParts {
    # Tokens
    token arrange-verb { 'arrange' }
    token ascending-adjective { 'ascending' }
    token descending-adjective { 'descending' }
    token filter-verb { 'filter' }
    token group-verb { 'group' }
    token mutate-verb { 'mutate' }
    token order-verb { 'order' }
    token select-verb { 'select' }
    token sort-verb { 'sort' }

    rule for-which-phrase { <for-preposition> 'which' | <that-pronoun> 'adhere' <to-preposition> }

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
    rule predicate { <variable-name> <predicate-symbol> <predicate-value> }
    token predicate-symbol { "==" | "<" | "<=" | ">" | ">=" }
    rule predicate-value { <variable-name> }
    # rule predicate-value { <number> | <string> | <variable-name> }
    # token number { (\d*) }
    # token string { "'" \w* "'" }
}
