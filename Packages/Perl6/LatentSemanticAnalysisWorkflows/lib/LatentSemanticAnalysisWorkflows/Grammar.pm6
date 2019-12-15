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
use LatentSemanticAnalysisWorkflows::Grammar::CommonParts;
use LatentSemanticAnalysisWorkflows::Grammar::PipelineCommand;


# LSI command should be programmed as a role in order to use in SMRMon.
# grammar LatentSemanticAnalysisWorkflowsGrammar::LSIFunctionsApplicationCommand {
# ...
# }

grammar LatentSemanticAnalysisWorkflows::Grammar::WorkflowCommmand does LatentSemanticAnalysisWorkflows::Grammar::PipelineCommand does LatentSemanticAnalysisWorkflows::Grammar::CommonParts {
    # TOP
    regex TOP {
        <data-load-command> | <create-command> |
        <make-doc-term-matrix-command> | <data-transformation-command> |
        <data-statistics-command> | <lsi-apply-command> |
        <topics-extraction-command> | <thesaurus-extraction-command> |
        <show-topics-command> | <show-thesaurus-command> |
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
    rule make-doc-term-matrix-command { [ <compute-directive> | <generate-directive> ] [ <.the-determiner> | <.a-determiner> ]? <doc-term-mat> <doc-term-matrix-parameters-spec>? }

    rule doc-term-matrix-parameters-spec { <.using-preposition> <doc-term-matrix-parameters-list> }
    rule doc-term-matrix-parameters-list { <doc-term-matrix-parameter>+ % <list-separator> }
    rule doc-term-matrix-parameter { <doc-term-matrix-stemming-rules> | <doc-term-matrix-stop-words> }

    rule stemming-rules-phrase { 'stemming' ['rules']? }
    rule doc-term-matrix-stemming-rules { <.stemming-rules-phrase> <stemming-rules-spec> | <stemming-rules-spec> <.stemming-rules-phrase> }
    rule stemming-rules-spec { <variable-name> | <trivial-parameter> }

    rule stop-words-phrase { 'stop' 'words' }
    rule doc-term-matrix-stop-words { <.stop-words-phrase> <stop-words-spec> | <stop-words-spec> <.stop-words-phrase> }
    rule stop-words-spec { <variable-name> | <trivial-parameter> }

    rule trivial-parameter { <trivial-parameter-none> | <trivial-parameter-empty> | <trivial-parameter-automatic> | <trivial-parameter-false> | <trivial-parameter-true> }
    rule trivial-parameter-none { 'none' | 'no' | 'NA' }
    rule trivial-parameter-empty { 'empty' | '{}' | 'c()' }
    rule trivial-parameter-automatic { 'automatic' | 'NULL' }
    rule trivial-parameter-false { 'False' | 'FALSE' | 'F' | 'false' }
    rule trivial-parameter-true { 'True' | 'TRUE' | 'T' | 'true' }

    # Data transformation command
    rule data-transformation-command { <data-partition> }
    rule data-partition {'partition' [ <data-reference> ]? [ 'to' | 'into' ] <data-elements>}
    rule data-element { 'sentence' | 'paragraph' | 'section' | 'chapter' | 'word' }
    rule data-elements { 'sentences' | 'paragraphs' | 'sections' | 'chapters' | 'words' }
    rule data-spec-opening {<transform-verb>}
    rule data-type-filler { 'data' | 'records' }

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

    # Show topics table commands
    rule show-topics-command { <show-topics-table-command> }
    rule show-topics-table-command { <display-directive> <.the-determiner>? 'topics' 'table' <topics-table-parameters-spec>? }
    rule topics-table-parameters-spec { <.using-preposition> <topics-table-parameters-list> }
    rule topics-table-parameters-list { <topics-table-parameter>+ % <list-separator> }
    rule topics-table-parameter { <topics-table-number-of-table-columns> | <topics-table-number-of-terms> }

    rule number-of-table-columns-phrase { ['number' 'of']? ['table']? 'columns' }
    rule topics-table-number-of-table-columns { <.number-of-table-columns-phrase> <integer-value> | <integer-value> <.number-of-table-columns-phrase> }

    rule number-of-terms-phrase { ['number' 'of']? [ 'terms' | 'words' ] }
    rule topics-table-number-of-terms {  <.number-of-terms-phrase> <integer-value> | <integer-value> <.number-of-terms-phrase> }

    rule show-thesaurus-command { <show-thesaurus-table-command> | <what-are-the-term-nns> }
    rule show-thesaurus-table-command { [ <compute-and-display> | <display-directive> ] ['statistical']? 'thesaurus' ['table']? <thesaurus-words-spec>? }
    rule what-are-the-term-nns { 'what' 'are' <.the-determiner>? ['top']? [ 'nearest' 'neighbors' | 'nns' ] <thesaurus-words-spec> }
    rule thesaurus-words-spec { [ <.for-preposition> | <.of-preposition> ] <thesaurus-words-list>}
    rule thesaurus-words-list { <variable-name>+ % <list-separator> }

}
