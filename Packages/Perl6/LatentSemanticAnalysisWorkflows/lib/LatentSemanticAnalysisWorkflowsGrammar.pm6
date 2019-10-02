#==============================================================================
#
#   Latent Semantic Analysis workflows grammar in Raku Perl 6
#   Copyright (C) 2019  Anton Antonov
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#   Written by Anton Antonov,
#   antononcube @ gmai l . c om,
#   Windermere, Florida, USA.
#
#==============================================================================
#
#   For more details about Raku Perl6 see https://perl6.org/ .
#
#==============================================================================
#
#  The grammar design in this file follows very closely the EBNF grammar
#  for Mathematica in the GitHub file:
#    https://github.com/antononcube/ConversationalAgents/blob/master/EBNF/English/Mathematica/LatentSemanticAnalysisWorkflowsGrammar.m
#
#==============================================================================

use v6;
unit module LatentSemanticAnalysisWorkflowsGrammar;

# This role class has common command parts.
role LatentSemanticAnalysisWorkflowsGrammar::CommonParts {

    # Speech parts
    token do-verb { 'do' }
    token with-preposition { 'using' | 'with' | 'by' }
    token using-preposition { 'using' | 'with' | 'over' }
    token by-preposition { 'by' | 'with' | 'using' }
    token for-preposition { 'for' | 'with' }
    token of-preposition { 'of' }
    token from-preposition { 'from' }
    token to-preposition { 'to' | 'into' }
    token assign { 'assign' | 'set' }
    token a-determiner { 'a' | 'an'}
    token and-conjuction { 'and' }
    token the-determiner { 'the' }
    rule for-which-phrase { 'for' 'which' | 'that' 'adhere' 'to' }
    rule number-of { [ 'number' | 'count' ] 'of' }
    token per { 'per' }
    token results { 'results' }
    token simple { 'simple' | 'direct' }
    token use-verb { 'use' | 'utilize' }
    token get-verb { 'obtain' | 'get' | 'take' }
    token object { 'object' }
    token plot { 'plot' }
    token plots { 'plot' | 'plots' }

    # Data
    token records { 'rows' | 'records' }
    rule time-series-data { 'time' 'series' 'data'? }
    rule data-frame { 'data' 'frame' }
    rule data { <data-frame> | 'data' | 'dataset' | <time-series-data> }
    token dataset-name { ([ \w | '_' | '-' | '.' | \d ]+) <!{ $0 eq 'and' }> }
    token variable-name { ([ \w | '_' | '-' | '.' | \d ]+) <!{ $0 eq 'and' }> }

    # Directives
    rule load-data-directive { ( 'load' | 'ingest' ) <.the-determiner>? <data> }
    token create-directive { 'create' | 'make' }
    token generate-directive { 'generate' | 'create' | 'make' }
    token compute-directive { 'compute' | 'find' | 'calculate' }
    token display-directive { 'display' | 'show' | 'echo' }
    rule compute-and-display { <compute-directive> [ 'and' <display-directive> ]? }
    token diagram { 'plot' | 'plots' | 'graph' | 'chart' }
    rule plot-directive { 'plot' | 'chart' | <display-directive> <diagram> }
    rule use-directive { [ <get-verb> <and-conjuction>? ]? <use-verb> }
    token classify { 'classify' }

    # Value types
    token number-value { (\d+ ['.' \d*]?  [ [e|E] \d+]?) }
    token integer-value { \d+ }
    token percent { '%' | 'percent' }
    token percent-value { <number-value> <.percent> }
    token boolean-value { 'True' | 'False' | 'true' | 'false' }

    # Time series and regression specific
    token error { 'error' }
    token errors { 'error' | 'errors' }
    token outlier { 'outlier' }
    token outliers { 'outliers' | 'outlier' }
    rule the-outliers { <the-determiner> <outliers> }
    token ingest { 'ingest' | 'load' | 'use' | 'get' }
    token fit { 'fit' | 'fitting' }
    token quantile { 'quantile' }
    token quantiles { 'quantiles' }
    token probability { 'probability' }
    token probabilities { 'probabilities' }
    rule lsa-object { [ 'lsa' | 'latent' 'semanatic' 'analysis' ]? 'object' }
    token anomaly { 'anomaly' }
    token anomalies { 'anomalies' }
    token threshold { 'threshold' }
    token identifier { 'identifier' }
    token residuals { 'residuals' }

    # Lists of things
    token list-separator-symbol { ',' | '&' | 'and' | ',' 'and' }
    token list-separator { <.ws>? <list-separator-symbol> <.ws>? }
    token list { 'list' }

    # Number list
    rule number-value-list { <number-value>+ % <list-separator>? }

    rule range-spec-step { <with-preposition>? 'step' | <with-preposition> }
    rule range-spec { [ <.from-preposition> <number-value> ] [ <.to-preposition> <number-value> ] [ <.range-spec-step> <number-value> ]? }

    # Expressions
    token wl-expr { \S+ }

    # Error message
    # method error($msg) {
    #   my $parsed = self.target.substr(0, self.pos).trim-trailing;
    #   my $context = $parsed.substr($parsed.chars - 15 max 0) ~ '⏏' ~ self.target.substr($parsed.chars, 15);
    #   my $line-no = $parsed.lines.elems;
    #   die "Cannot parse code: $msg\n" ~ "at line $line-no, around " ~ $context.perl ~ "\n(error location indicated by ⏏)\n";
    # }

    method ws() {
      if self.pos > $*HIGHWATER {
        $*HIGHWATER = self.pos;
        $*LASTRULE = callframe(1).code.name;
      }
      callsame;
    }

    method parse($target, |c) {
      my $*HIGHWATER = 0;
      my $*LASTRULE;
      my $match = callsame;
      self.error_msg($target) unless $match;
      return $match;
    }

    method error_msg($target) {
      my $parsed = $target.substr(0, $*HIGHWATER).trim-trailing;
      my $un-parsed = $target.substr($*HIGHWATER, $target.chars).trim-trailing;
      my $line-no = $parsed.lines.elems;
      my $msg = "Cannot parse the command";
      # say 'un-parsed : ', $un-parsed;
      # say '$*LASTRULE : ', $*LASTRULE;
      $msg ~= "; error in rule $*LASTRULE at line $line-no" if $*LASTRULE;
      $msg ~= "; target '$target' position $*HIGHWATER";
      $msg ~= "; parsed '$parsed', un-parsed '$un-parsed'";
      $msg ~= ' .';
      say $msg;
    }

}

# This role class has pipeline commands.
role LatentSemanticAnalysisWorkflowsGrammar::PipelineCommand {

  rule pipeline-command { <get-pipeline-value> | <generate-pipeline> }
  rule get-pipeline-value { <display-directive> <pipeline-value> }
  rule pipeline-value { <.pipeline-filler-phrase>? 'value'}
  rule pipeline-filler-phrase { <the-determiner>? [ 'current' ]? 'pipeline' }

  rule generate-pipeline {<generate-pipeline-phrase> [ <using-preposition> <topics-spec> ]?}
  rule generate-pipeline-phrase {<generate-directive> [ [ 'an' | 'a' | 'the' ] ]? [ 'standard' ]? <lsa-phrase> 'pipeline'}
  rule lsa-phrase {<lsa-phrase-word> [ [ <lsa-phrase-word> ]+ ]?}
  rule lsa-phrase-word {[ 'text' | 'latent' | 'semantic' | 'analysis' ]}

}

# LSI command should be programmed as a role in order to use in SMRMon.
# grammar LatentSemanticAnalysisWorkflowsGrammar::LSIFunctionsApplicationCommand {
# ...
# }

grammar LatentSemanticAnalysisWorkflowsGrammar::Latent-semantic-analysis-workflow-commmand does PipelineCommand does CommonParts {
    # TOP
    regex TOP {
        <load-data> | <data-transformation> | <make-doc-term-mat> |
        <statistics-command> | <lsi-apply-command> |
        <topics-extraction-command> | <thesaurus-extraction-command> |
        <pipeline-command> }

    # Load data
    rule data-reference {[ 'data' | [ 'texts' | 'text' [ [ 'corpus' | 'collection' ] ]? [ 'data' ]? ] ]}
    rule load-data-opening {[ 'load' | 'get' | 'consider' ] [ 'the' ]? <data-reference>}
    rule load-preposition { 'for' | 'of' | 'at' | 'from' }
    rule load-data {[ <load-data-opening> [ 'the' ]? <data-kind> [ [ 'data' ]? <load-preposition> ]? <location-specification> | <load-data-opening> [ 'the' ]? <location-specification> [ 'data' ]? ]}
    rule location-specification {[ <dataset-name> | <web-address> | <database-name> ]}
    rule web-address { <variable-name> }
    rule dataset-name { <variable-name> }
    rule database-name { <variable-name> }
    rule data-kind { <variable-name> }

    # Create command
    rule create-command { <create-by-dataset> }
    rule create-simple { <create-directive> <.a-determiner>? <object> <simple-way-phrase> | <simple> <object> [ 'creation' | 'making' ] }
    rule create-by-dataset { [ <create-simple> | <create-directive> ] [ <.by-preposition> | <.with-preposition> | <.from-preposition> ]? <dataset-name> }

    # Data transform command
    rule data-transformation {<data-partition>}
    rule data-partition {'partition' [ <data-reference> ]? [ 'to' | 'into' ] <data-elements>}
    rule data-element {[ 'sentence' | 'paragraph' | 'section' | 'chapter' | 'word' ]}
    rule data-elements {[ 'sentences' | 'paragraphs' | 'sections' | 'chapters' | 'words' ]}
    rule data-spec-opening {'transform'}
    rule data-type-filler {[ 'data' | 'records' ]}

    # Data statistics command
    rule data-statistics-command { <summarize-data> }
    rule summarize-data { 'summarize' <.the-determiner>? <data> | <display-directive> <data>? ( 'summary' | 'summaries' ) }

    # Make document-term matrix command
    rule make-doc-term-mat { [ <compute-directive> | <generate-directive> ] [ 'the' | 'a' ]? <doc-term-mat> }
    rule doc-term-mat {[ 'document' | 'item' ] [ 'term' | 'word' ] 'matrix'}

    # LSI command is programmed as a role.
    rule lsi-apply-command {<lsi-apply-phrase> <lsi-funcs-list>}
    rule lsi-apply-verb {[ 'apply' 'to' | 'transform' ]}
    rule lsi-apply-phrase {<lsi-apply-verb> [ 'the' ]? [ [ 'matrix' | <doc-term-mat> ] 'entries' ]? [ 'the' ]? [ 'lsi' ]? [ 'functions' ]?}
    rule lsi-funcs-list {<lsi-func> [ [ <list-separator> <lsi-func> ]+ ]?}
    rule lsi-func {[ <lsi-global-func> | <lsi-local-func> | <lsi-normal-func> ]}
    rule lsi-global-func {[ <lsi-global-func-idf> | <lsi-global-func-entropy> ]}
    rule lsi-global-func-idf {[ 'IDF' | 'idf' | 'inverse' 'document' 'frequency' ]}
    rule lsi-global-func-entropy {[ 'Entropy' | 'entropy' ]}
    rule lsi-local-func {[ <lsi-local-func-frequency> | <lsi-local-func-binary> ]}
    rule lsi-local-func-frequency {'frequency'}
    rule lsi-local-func-binary {'binary' [ 'frequency' ]?}
    rule lsi-normal-func {[ <lsi-normal-func-sum> | <lsi-normal-func-max> | <lsi-normal-func-cosine> ] [ 'normalization' ]?}
    rule lsi-normal-func-sum {'sum'}
    rule lsi-normal-func-max {'max' | 'maximum' }
    rule lsi-normal-func-cosine {'cosine'}

    # Statistics command
    rule statistics-command {<statistics-preamble> [ <docs-per-term> | <terms-per-doc> ] [ <statistic-spec> ]?}
    rule statistics-preamble {[ <compute-and-display> | <display-directive> ] [ [ 'the' | 'a' | 'some' ] ]?}
    rule docs-per-term {<docs> [ 'per' ]? <terms>}
    rule terms-per-doc {<terms> [ 'per' ]? <docs>}
    rule docs { 'document' | 'documents' | 'item' | 'items' }
    rule terms { 'word' | 'words' | 'term' | 'terms' }
    rule statistic-spec { <diagram-spec> | <summary-spec> }
    rule diagram-spec {'histogram'}
    rule summary-spec { 'summary' | 'statistics' }

    # Thesaurus command
    rule thesaurus-extraction-command {[ <compute-directive> | 'extract' ] <thesaurus-spec>}
    rule thesaurus-spec { [ [ 'statistical' ]? 'thesaurus' ] [ <with-preposition> <thesaurus-parameters-spec> ]? }
    rule thesaurus-parameters-spec {<thesaurus-number-of-nns>}
    rule thesaurus-number-of-nns {<number-value> [ [ 'number' 'of' ]? [ [ 'nearest' ]? 'neighbors' | 'synonyms' | 'synonym' [ 'words' | 'terms' ] ] [ 'per' [ 'word' | 'term' ] ]?] }

    # Topics extraction
    rule topics-extraction-command {[ <compute-directive> | 'extract' ] <topics-spec> [ <topics-parameters-spec> ]?}
    rule topics-spec {<number-value> 'topics'}
    rule topics-parameters-spec {<with-preposition> <topics-parameters-list>}
    rule topics-parameters-list {<topics-parameter> [ [ <list-separator> <topics-parameter> ]+ ]?}
    rule topics-parameter {[ <topics-max-iterations> | <topics-initialization> | <topics-method> ]}
    rule topics-max-iterations {[ <max-iterations-phrase> <number-value> | <number-value> <max-iterations-phrase> ]}
    rule max-iterations-phrase {[ 'max' | 'maximum' ] [ 'iterations' | 'steps' ]}
    rule topics-initialization {[ 'random' ]? <number-value> 'columns' 'clusters'}
    rule topics-method {[ [ 'the' ]? 'method' ]? [ 'svd' | 'SVD' | 'pca' | 'PCA' | 'nnmf' | 'NNMF' | 'nmf' | 'NMF' ]}

}
