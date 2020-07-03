use v6;

#use DataQueryWorkflows::Grammar::FuzzyMatch;
use DataQueryWorkflows::Grammar::CommonParts;

# Data query specific phrases
role DataQueryWorkflows::Grammar::DataQueryPhrases
        does DataQueryWorkflows::Grammar::CommonParts {
    # Tokens
    rule for-which-phrase { 'for' 'which' | 'that' 'adhere' 'to' }

    # True dplyr; see comments below.
    token ascending { 'ascending' | 'asc' }
    token descending { 'descending' | 'desc' }
    token mutate { 'mutate' }
    token variables { 'variable' | 'variables' }

    rule arrange { ( 'arrange' | 'order' | 'sort' ) ( <by-preposition> | <using-preposition> )? }
    rule data { 'the'? 'data' }
    rule filter { 'filter' | <select> }
    rule group-by { 'group' ( <by-preposition> | <using-preposition> ) }
    rule select { 'select' | 'keep' 'only'? }

    # Predicates
    rule predicates-list { <predicate>+ % <list-separator> }
    rule predicate { <variable-name> <predicate-symbol> <predicate-value> }
    token predicate-symbol { "==" | "<" | "<=" | ">" | ">=" }
    rule predicate-value { <variable-name> }
    # rule predicate-value { <number> | <string> | <variable-name> }
    # token number { (\d*) }
    # token string { "'" \w* "'" }
}
