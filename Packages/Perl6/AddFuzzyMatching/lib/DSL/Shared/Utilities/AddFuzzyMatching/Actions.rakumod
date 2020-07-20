use v6;

unit module DSL::Shared::Utilities::AddFuzzyMatching::Actions;

##===========================================================
## Actions
##===========================================================

class DSL::Shared::Utilities::AddFuzzyMatching::Actions {

  # method reduce($op, @list) {
  #   return @list[0] if @list.elems == 1;
  #   return [$op, |@list];
  # }

  # method TOP($/) { make self.reduce('\n', $/.values».made); }

  method TOP($/) { make $/.values>>.made.flat.join() }

  method empty-line($/) { make $/.Str; }

  method comment-line($/) { make $/.Str; }

  method leading-space($/) { make $/.Str; }

  method code-line($/) { make $/.Str }

  method token-definition-end($/) { make $/.Str }

  method token($/) { make $/.Str; }

  method token-name-spec($/) { make $/.Str;  }

  method token-spec($/) {

    my @dont = [ 'a', 'an', 'and', 'by', 'do', 'for', 'from', 'get', 'load', 'of', 'per', 'set', 'that', 'the', 'to', 'use', 'with' ];

    my Str $term = substr( $/.Str, 1, $/.Str.chars - 2);

    if @dont.contains($term) {
      make $/.Str;
    } else {
      make $/.Str ~ ' | ' ~  '([\w]+) <?{ is-fuzzy-match( $0.Str, ' ~ $/.Str ~ ') }>';
    }
  }

  method token-body($/) {
    make ($/.values>>.made).join(' | ');
  }
  method token-rule-definition($/) {
    make $<leading-space>.made ~ $<token>.made ~ ' ' ~ $<token-name-spec>.made ~ ' { ' ~ $<token-body>.made ~ ' }' ~ "\n";
  }

}
