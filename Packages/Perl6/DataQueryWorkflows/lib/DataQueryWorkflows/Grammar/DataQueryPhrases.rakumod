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
    token formula-noun { 'formula' }
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
    rule contingency-matrix-phrase { <contingency-noun> [ <matrix-noun> | <table-noun> ] }
    rule with-formula-phrase { <with-preposition> <the-determiner>? <formula-noun> }

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

}
