use v6;

# This role class has common command parts.
role DataQueryWorkflows::Grammar::PredicateSpecification {

    # Predicate expression
    rule predicates-list { <predicate>+ % <list-separator> }
    rule predicate { <predicate-sum> }
    rule predicate-sum { <predicate-product>+ % <or-operator> }
    rule predicate-product { <predicate-term>+ % <and-operator> }
    rule predicate-term { <predicate-simple> | <predicate-group> }
    rule predicate-group { '(' <predicate-term> ')' }

    # Simple predicate
    rule predicate-simple { <lhs=predicate-value> [ 'is' ]? <predicate-relation> <rhs=predicate-value> }
    rule predicate-value { <quoted-variable-name> | <number-value> }
    rule predicate-operator { <logical-connective> | <predicate-relation> }
    rule logical-connective { <and-operator> | <or-operator> }
    token and-operator { 'and' | '&&' | '&' }
    token or-operator { 'or' | '||' | '|' }

    # Predicate relations
    rule predicate-relation {
        <equal-relation> | <not-equal-relation> |
        <less-relation> | <less-equal-relation> |
        <greater-relation> | <greater-equal-relation> |
        <same-relation> | <not-same-relation>
        <in-relation> | <not-in-relation> |
        <like-relation> }
    rule equal-relation { '=' | '==' | 'eq' | 'equals' | 'equal' 'to'? | 'is' }
    rule not-equal-relation { '!=' | 'neq' | 'not' 'equal' 'to'? | 'is' 'not' }
    rule less-relation { '<' | 'lt' | 'less' 'than'? }
    rule less-equal-relation { '<=' | 'lte' | 'less' 'or'? 'equal' 'than'? }
    rule greater-relation { '>' | 'gt' | 'greater' 'than'? }
    rule greater-equal-relation { '>=' | 'gte' | 'greater' 'or'? 'equal' 'than'? }
    rule same-relation { '===' | 'same' 'as'? }
    rule not-same-relation { '=!=' | 'not' 'same' 'as'? }
    rule in-relation { 'in' | 'belongs' 'to' }
    rule not-in-relation { '!in' | 'not' 'in' | [ 'does' 'not' | 'doesn\'t' ] 'belong' 'to' }
    rule like-relation { 'like' | 'similar' 'to' }
}
