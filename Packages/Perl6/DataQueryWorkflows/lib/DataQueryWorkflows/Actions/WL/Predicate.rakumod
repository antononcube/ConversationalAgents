
use v6;
use DataQueryWorkflows::Grammar;

unit module DataQueryWorkflows::Actions::WL::Predicate;

class DataQueryWorkflows::Actions::WL::Predicate {

  # Predicates
  method predicates-list($/) { make $<predicate>>>.made.join(', '); }
  method predicate($/) { make $/.values>>.made.join(' '); }
  method predicate-sum($/) { make $<predicate-product>>>.made.join(' || '); }
  method predicate-product($/) { make $<predicate-term>>>.made.join(' && '); }
  method predicate-term($/) { make $/.values[0].made; }
  method predicate-group($/) { make '(' ~ $/<predicate-term>.made ~ ')'; }

  method predicate-simple($/) {
    if $<predicate-relation>.made eq 'like' {
      make 'MatchQ[ #["' ~ $<lhs>.made ~ '"], ' ~ $<rhs>.made ~ ']';
    } else {
      make '#["' ~ $<lhs>.made ~ '"] ' ~ $<predicate-relation>.made ~ ' ' ~ $<rhs>.made;
    }
  }
  method logical-connective($/) { make $/.values[0].made; }
  method and-operator($/) { make '&&'; }
  method or-operator($/) { make '||'; }
  method predicate-symbol($/) { make $/.Str; }
  method predicate-value($/) { make $/.values[0].made; }
  method predicate-relation($/) { make $/.values[0].made; }
  method equal-relation($/) { make '=='; }
  method not-equal-relation($/) { make '!='; }
  method less-relation($/) { make '<'; }
  method less-equal-relation($/) { make '<='; }
  method greater-relation($/) { make '>'; }
  method greater-equal-relation($/) { make '>='; }
  method same-relation($/) { make '=='; }
  method not-same-relation($/) { make '!='; }
  method in-relation($/) { make '\[Element]'; }
  method not-in-relation($/) { make '\[NotElement]'; }
  method like-relation($/) { make 'like'; }

}

