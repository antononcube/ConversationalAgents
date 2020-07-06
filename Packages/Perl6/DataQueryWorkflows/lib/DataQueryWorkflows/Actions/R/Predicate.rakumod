
use v6;
use DataQueryWorkflows::Grammar;

unit module DataQueryWorkflows::Actions::R::Predicate;

class DataQueryWorkflows::Actions::R::Predicate {

  # Predicates
  method predicates-list($/) { make $<predicate>>>.made.join(', '); }
  method predicate($/) { make $/.values>>.made.join(' '); }
  method predicate-sum($/) { make $<predicate-product>>>.made.join(' | '); }
  method predicate-product($/) { make $<predicate-term>>>.made.join(' & '); }
  method predicate-term($/) { make $/.values[0].made; }
  method predicate-group($/) { make '(' ~ $/<predicate-term>.made ~ ')'; }

  method predicate-simple($/) {
    if $<predicate-relation>.made eq '%!in%' {
      make '!(' ~ $<lhs>.made ~ ' %in% ' ~ $<rhs>.made ~ ')';
    } elsif $<predicate-relation>.made eq 'like' {
      make 'grepl( pattern = ' ~ $<rhs>.made ~ ', x = ' ~ $<lhs>.made ~ ')';
    } else {
      make $<lhs>.made ~ ' ' ~ $<predicate-relation>.made ~ ' ' ~ $<rhs>.made;
    }
  }
  method logical-connective($/) { make $/.values[0].made; }
  method and-operator($/) { make '&'; }
  method or-operator($/) { make '|'; }
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
  method in-relation($/) { make '%in%'; }
  method not-in-relation($/) { make '%!in%'; }
  method like-relation($/) { make 'like'; }

}

