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
    token apply-verb { 'apply' }
    token transform-verb { 'transform' }
    token get-verb { 'obtain' | 'get' | 'take' }
    token object { 'object' }
    token plot { 'plot' }
    token plots { 'plot' | 'plots' }

    # Data
    token records { 'rows' | 'records' }
    rule time-series-data { 'time' 'series' 'data'? }
    rule data-frame { 'data' 'frame' }
    rule data { <data-frame> | 'data' | 'dataset' }
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

    # LSA and LSI specific
    rule the-outliers { <the-determiner> <outliers> }
    rule lsa-phrase { 'latent' 'semantic' 'analysis' | 'lsa' | 'LSA' }
    rule lsi-phrase { 'latent' 'semantic' 'indexing' | 'lsi' | 'LSI' }
    token ingest { 'ingest' | 'load' | 'use' | 'get' }
    rule lsa-object { <lsa-phrase>? 'object' }
    token threshold { 'threshold' }
    token identifier { 'identifier' }
    token weight { 'weight' }
    token term { 'term' }
    token entries { 'entries' }
    token matrix { 'matrix' }
    rule doc-term-mat {[ 'document' | 'item' ] [ 'term' | 'word' ] <matrix> }
    rule matrix-entries { [ <matrix> | <doc-term-mat> ]? <entries> }

    token normalization { 'normalization' }
    token normalizing { 'normalizing' }
    token normalizer { 'normalizer' }
    token global { 'global' }
    token local { 'local' }
    token function { 'function' }
    token functions { 'function' | 'functions' }
    token frequency { 'frequency' }
    rule global-function-phrase { <global> <term> ?<weight>? <function> }
    rule local-function-phrase { <local> <term>? <weight>? <function> }
    rule normalizer-function-phrase { [ <normalizer> | <normalizing> | <normalization> ] <term>? <weight>? <function>? }

    # Lists of things
    token list-separator-symbol { ',' | '&' | 'and' | ',' \h* 'and' }
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
  rule lsa-general-phrase {<lsa-phrase-word> [ [ <lsa-phrase-word> ]+ ]?}
  rule lsa-phrase-word {[ 'text' | 'latent' | 'semantic' | 'analysis' ]}

}

# LSI command should be programmed as a role in order to use in SMRMon.
# grammar LatentSemanticAnalysisWorkflowsGrammar::LSIFunctionsApplicationCommand {
# ...
# }

grammar LatentSemanticAnalysisWorkflowsGrammar::Latent-semantic-analysis-workflow-commmand does PipelineCommand does CommonParts {
    # TOP
    regex TOP {
        <data-load-command> | <create-command> |
        <make-doc-term-matrix-command> | <data-transformation-command> |
        <statistics-command> | <lsi-apply-command> |
        <topics-extraction-command> | <thesaurus-extraction-command> |
        <show-table-command> |
        <pipeline-command> }

    # Load data
    rule data-load-command { <load-data> | <use-lsa-object> }

    rule load-data { <load-data-opening> <the-determiner>? <data-kind> [ <data>? <load-preposition> ]? <location-specification> | <load-data-opening> [ <the-determiner> ]? <location-specification> <data>? }
    rule data-reference {[ 'data' | [ 'texts' | 'text' [ [ 'corpus' | 'collection' ] ]? [ 'data' ]? ] ]}
    rule load-data-opening {[ 'load' | 'get' | 'consider' ] [ 'the' ]? <data-reference>}
    rule load-preposition { 'for' | 'of' | 'at' | 'from' }
    rule location-specification {[ <dataset-name> | <web-address> | <database-name> ]}
    rule web-address { <variable-name> }
    rule dataset-name { <variable-name> }
    rule database-name { <variable-name> }
    rule data-kind { <variable-name> }

    rule use-lsa-object { <.use-verb> <.the-determiner>? <.lsa-object> <dataset-name> }

    # Create command
    rule create-command { <create-simple> | <create-by-dataset> }
    rule simple-way-phrase { 'in' <a-determiner>? <simple> 'way' | 'directly' | 'simply' }
    rule create-simple { <create-directive> <.a-determiner>? <simple>? <object> <simple-way-phrase>? | <simple> <object> [ 'creation' | 'making' ] }
    rule create-by-dataset { [ <create-simple> | <create-directive> ] [ <.by-preposition> | <.with-preposition> | <.from-preposition> ]? <dataset-name> }

    # Make document-term matrix command
    rule make-doc-term-matrix-command { [ <compute-directive> | <generate-directive> ] [ <the-determiner> | <a-determiner> ]? <doc-term-mat> }

    # Data transformation command
    rule data-transformation-command {<data-partition>}
    rule data-partition {'partition' [ <data-reference> ]? [ 'to' | 'into' ] <data-elements>}
    rule data-element {[ 'sentence' | 'paragraph' | 'section' | 'chapter' | 'word' ]}
    rule data-elements {[ 'sentences' | 'paragraphs' | 'sections' | 'chapters' | 'words' ]}
    rule data-spec-opening {<transform-verb>}
    rule data-type-filler {[ 'data' | 'records' ]}

    # Data statistics command
    rule data-statistics-command { <summarize-data> }
    rule summarize-data { 'summarize' <.the-determiner>? <data> | <display-directive> <data>? ( 'summary' | 'summaries' ) }

    # LSI command is programmed as a role.
    regex lsi-apply-command { <.lsi-apply-phrase> [ <lsi-funcs-list> | <lsi-funcs-simple-list> ] }

    rule lsi-funcs-simple-list { <lsi-global-func> <lsi-local-func> <lsi-normalizer-func> }

    rule lsi-apply-verb { <apply-verb> 'to'? | <transform-verb> | <use-verb> }
    rule lsi-apply-phrase { <lsi-apply-verb> <the-determiner>? [ <matrix> | <matrix-entries> ]? <the-determiner>? <lsi-phrase>? <functions>? }

    rule lsi-funcs-list { <lsi-func>+ % <list-separator> }

    rule lsi-func { <lsi-global-func> | <lsi-local-func> | <lsi-normalizer-func> }

    rule lsi-func-none { 'None' | 'none' }

    rule lsi-global-func { <.global-function-phrase>? [ <lsi-global-func-idf> | <lsi-global-func-entropy> | <lsi-global-func-sum> | <lsi-func-none> ] }
    rule lsi-global-func-idf { 'IDF' | 'idf' | 'inverse' 'document' <frequency> }
    rule lsi-global-func-entropy { 'Entropy' | 'entropy' }
    rule lsi-global-func-sum {  'sum' | 'Sum' }

    rule lsi-local-func { <.local-function-phrase>? [ <lsi-local-func-frequency> | <lsi-local-func-binary> | <lsi-local-func-log> | <lsi-func-none> ] }
    rule lsi-local-func-frequency {  <term>? <frequency> }
    rule lsi-local-func-binary { 'binary' <frequency>? | 'Binary' }
    rule lsi-local-func-log { 'log' | 'logarithmic' | 'Log' }

    rule lsi-normalizer-func { <.normalizer-function-phrase>? [ <lsi-normalizer-func-sum> | <lsi-normalizer-func-max> | <lsi-normalizer-func-cosine> | <lsi-func-none> ] <.normalization>? }
    rule lsi-normalizer-func-sum {'sum' | 'Sum' }
    rule lsi-normalizer-func-max {'max' | 'maximum' | 'Max' }
    rule lsi-normalizer-func-cosine {'cosine' | 'Cosine' }

    # Statistics command
    rule statistics-command {<statistics-preamble> [ <statistic-spec> | [ <docs-per-term> | <terms-per-doc> ] [ <statistic-spec> ]? ] }
    rule statistics-preamble {[ <compute-and-display> | <display-directive> ] [ 'the' | 'a' | 'some' ]?}
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
    rule topics-spec { <number-value> 'topics' | 'topics' <number-value> }
    rule topics-parameters-spec { <.with-preposition> <topics-parameters-list>}
    rule topics-parameters-list { <topics-parameter>+ % <list-separator> }

    rule topics-parameter { <topics-max-iterations> | <topics-initialization> | <min-number-of-documents-per-term> | <topics-method>}
    rule topics-max-iterations { <max-iterations-phrase> <number-value> | <number-value> <max-iterations-phrase> }
    rule max-iterations-phrase { [ 'max' | 'maximum' ]? [ 'iterations' | 'steps' ] }
    rule topics-initialization {[ 'random' ]? <number-value> 'columns' 'clusters'}
    rule min-number-of-documents-per-term { <min-number-of-documents-per-term-phrase> <number-value> | <number-value> <min-number-of-documents-per-term-phrase> }
    rule min-number-of-documents-per-term-phrase { [ 'min' | 'minimum' ] 'number' 'of' 'documents' 'per' [ 'term' | 'word' ]}
    rule topics-method {[ [ 'the' ]? 'method' ]? <topics-method-name> }

    ## May be this should be slot?
    ## Also, note that the method names are hard-coded.
    rule topics-method-name { <topics-method-SVD> | <topics-method-PCA> | <topics-method-NNMF> | <topics-method-ICA> }
    rule topics-method-SVD { 'svd' | 'SVD' | 'SingularValueDecomposition' | 'singular' 'value' 'decomposition' }
    rule topics-method-PCA { 'pca' | 'PCA' | 'PrincipalComponentAnalysis' | 'principal' 'component' 'analysis' }
    rule topics-method-NNMF { 'nmf' | 'nnmf' | 'NonNegativeMatrixFactorization' | 'NonnegativeMatrixFactorization' | 'NMF' | 'NNMF' | [ 'non' 'negative' | 'non-negative' | 'nonnegative' ] 'matrix' 'facotrization' }
    rule topics-method-ICA { 'ica' | 'ICA' | 'IndependentComponentAnalysis' | 'independent' 'component' 'analysis' }

    # Show tables commands
    rule show-table-command { <show-topics-table-command> | <show-thesaurus-table-command> }

    rule show-topics-table-command { <display-directive> 'topics' 'table' <topics-table-parameters-spec>? }
    rule topics-table-parameters-spec { <.using-preposition> <topics-table-parameters-list> }
    rule topics-table-parameters-list { <topics-table-parameter>+ % <list-separator> }
    rule topics-table-parameter { <topics-table-number-of-table-columns> | <topics-table-number-of-terms> }

    rule number-of-table-columns-phrase { ['number' 'of']? ['table']? 'columns' }
    rule topics-table-number-of-table-columns { <.number-of-table-columns-phrase> <integer-value> | <integer-value> <.number-of-table-columns-phrase> }

    rule number-of-terms-phrase { ['number' 'of']? [ 'terms' | 'words' ] }
    rule topics-table-number-of-terms {  <.number-of-terms-phrase> <integer-value> | <integer-value> <.number-of-terms-phrase> }

    rule show-thesaurus-table-command { [ <compute-and-display> | <display-directive> ] ['statistical']? 'thesaurus' ['table']? <thesaurus-words-spec>? }
    rule thesaurus-words-spec { <.for-preposition> <thesaurus-words-list>}
    rule thesaurus-words-list { <variable-name>+ % <list-separator> }

}
