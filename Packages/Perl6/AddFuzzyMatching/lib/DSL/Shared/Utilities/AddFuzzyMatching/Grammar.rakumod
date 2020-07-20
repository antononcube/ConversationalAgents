use v6;

unit module DSL::Shared::Utilities::AddFuzzyMatching::Grammar;

##===========================================================
## Grammar
##===========================================================

grammar DSL::Shared::Utilities::AddFuzzyMatching::Grammar  {

  rule TOP { [ <token-rule-definition> | <empty-line> | <comment-line> | <code-line> ]+ }

  token empty-line { \h* \n }

  token code-line { \h* \N* \n }

  token comment-line { '#' \N* \n }

  token token-name-spec { [\w | '-' | ':' | '<' | '>' ]+ }

  token token { 'token' }

  token token-spec { '\'' \w+  '\'' }

  token delim { \s* '|' \s* }

  token token-body { <token-spec>+ % <.delim> }

  token token-definition-end { '}' \h* \n }

  token leading-space { \h* }

  token token-rule-definition {
    <leading-space>
    <token> \s* <token-name-spec> \s*
    [ '{' || <error( "cannot find \{" )> ]
    [ \s* ]
    [ <token-body> || <error( "cannot parse token body" )> ]
    [ \s* ]
    [ <token-definition-end> || <error( "cannot find <token-token-definition-end>" )> ] }

  method error($msg) {
    my $parsed = self.target.substr(0, self.pos).trim-trailing;
    my $context = $parsed.substr($parsed.chars - 15 max 0) ~ '⏏' ~ self.target.substr($parsed.chars, 15);
    my $line-no = $parsed.lines.elems;
    die "Cannot parse code: $msg\n" ~ "at line $line-no, around " ~ $context.perl ~ "\n(error location indicated by ⏏)\n";
  }
}
