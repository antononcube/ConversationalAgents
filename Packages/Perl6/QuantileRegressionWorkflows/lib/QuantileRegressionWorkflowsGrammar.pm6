#==============================================================================
#
#   Quantile Regression workflows grammar in Raku Perl 6
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
#    https://github.com/antononcube/ConversationalAgents/blob/master/EBNF/English/Mathematica/QuantileRegressionWorkflowsGrammar.m
#
#==============================================================================

use v6;
unit module QuantileRegressionWorkflowsGrammar;

        # This role class has common command parts.
role QuantileRegressionWorkflowsGrammar::CommonParts {
    token do-verb { 'do' }
    token using-preposition { 'using' | 'with' | 'over' }
    token by-preposition { 'by' | 'with' | 'using' }
    token for-preposition { 'for' | 'with' }
    token from-preposition { 'from' }
    token to-preposition { 'to' | 'into' }
    token with-preposition { 'with' | 'using' }
    token assign { 'assign' | 'set' }
    token a-determiner { 'a' | 'an' }
    token the-determiner { 'the' }
    token rows { 'rows' | 'records' }
    rule for-which-phrase { 'for' 'which' | 'that' 'adhere' 'to' }
    rule load-data-directive { ( 'load' | 'ingest' ) <.the-determiner>? 'data' }
    token create-directive { 'create' | 'make' }
    token compute-directive { 'compute' | 'find' | 'calculate' }
    token display-directive { 'display' | 'show' }
    rule compute-and-display { <compute-directive> ['and' <display-directive>]? }
    token diagram { 'plot' | 'plots' | 'graph' | 'chart' }

    # Value types
    token number-value { (\d+ ['.' \d*]?  [ [e|E] \d+]?) }
    token integer-value { \d+ }
    token percent { '%' | 'percent' }
    token percent-value { <number-value> <.percent> }
    token boolean-value { 'True' | 'False' | 'true' | 'false' }

    # Time series and regression specific
    rule data { 'data' | 'dataset' | 'time' 'series' }
    rule time-series-data { 'time' 'series' 'data'? }
    token error { 'error' | 'errors' }
    token outliers { 'outliers' | 'outlier' }
    rule the-outliers { <the-determiner> <outliers> }
    token ingest { 'ingest' | 'load' | 'use' | 'get' }
    token fit { 'fit' | 'fitting' }
    token quantile { 'quantile' }
    token quantiles { 'quantiles' }
    token probability { 'probability' }
    token probabilities { 'probabilities' }

    # Lists of things
    token list-separator-symbol { ',' | '&' | 'and' }
    token list-separator { <.ws>? <list-separator-symbol> <.ws>? }
    token list { 'list' }

    # Number list
    rule number-value-list { <number-value>+ % <list-separator>? }

    rule range-spec-step { <with-preposition>? 'step' | <with-preposition> }
    rule range-spec { [ <.from-preposition> <number-value> ] [ <.to-preposition> <number-value> ] [ <.range-spec-step> <number-value> ]? }

    # Expressions
    token wl-expr { \S+ }
}

grammar QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand does CommonParts {
    # TOP
    rule TOP { <data-load-command> | <data-transformation-command> | <data-statistics-command> |
    <regression-command> | <find-outliers-command> | <plot-command> }

    # Load data
    rule data-load-command { <.load-data-directive> <data-location-spec> }
    rule data-location-spec { \S* }

    # Data transform command
    rule data-transformation-command {[ <rescale-command> | <resample-command> | <moving-func-command> ]}

    rule rescale-command { <rescale-axis> | <rescale-both-axes> }
    rule rescale-axis {'rescale' <.the-determiner>? [ 'x' | 'y' ]? 'axis'}
    rule rescale-both-axes {'rescale' [ <the-determiner> | 'both' ]? 'axes'}
    rule resample-command {'resample' <.the-determiner>? [ <time-series-data> ]? [ <using-preposition> <resampling-method-spec> ]? [ <using-preposition> <sampling-step-spec> ]?}

    rule sampling-step-spec { <default-sampling-step> | 'step' <number-value> }
    rule default-sampling-step { [ 'smallest' 'difference' | 'default' | 'automatic' ] 'step'}
    rule resampling-method-spec { <resampling-method> | <resampling-method-name> }
    rule resampling-method {[ 'LinearInterpolation' | 'HoldValueFromLeft' ]}
    rule resampling-method-name { 'linear' 'interpolation' | 'hold' 'value' 'from' 'left' }

    rule moving-func-command { [ <.compute-directive>? <moving-func-spec> <.using-preposition> ] [ <number-value> [ 'elements' ]? | [ 'the' ]? [ 'weights' ]? <number-value-list> [ 'weights' ]? ]}
    rule moving-func-name { 'moving' [ 'average' | 'median' | 'Mean' | 'Median' ] }
    rule moving-map-func { ['moving' 'map'] <wl-expr>}
    rule moving-func-spec { <moving-func-name> | <moving-map-func> }

    # Data statistics command
    rule data-statistics-command { <summarize-data> }
    rule summarize-data { 'summarize' <.the-determiner>? <data> | <display-directive> <data>? ( 'summary' | 'summaries' ) }

    # Regression command
    rule regression-command { [ <.compute-directive> | <.compute-and-display> | <.do-verb> ] <quantile-regression-spec> }
    rule quantile-regression { 'quantile' 'regression' | 'QuantileRegression' }
    rule quantile-regression-phrase { <.a-determiner>? <quantile-regression> <.fit>? }
    rule quantile-regression-spec { <quantile-regression-phrase> [ <using-preposition> <quantile-regression-spec-element-list> ]? }
    rule quantile-regression-spec-element-list { <quantile-regression-spec-element>+ % <spec-list-delimiter> }
    rule quantile-regression-spec-element { <probabilities-spec-phrase> | <knots-spec-phrase> | <interpolation-order-spec-phrase> }

    token spec-list-delimiter { <list-separator> | <list-separator> <.ws> <.using-preposition>? }

    # QR elenent - list of probabilities.
    rule probabilities-list { <.the-determiner>? [ <probabilities> | <probability> <list>? | <probability> ] }
    rule probabilities-spec-phrase { <.probabilities-list> <probabilities-spec> |
    <.the-determiner>? <probabilities-spec> <.probabilities-list> }
    rule probabilities-spec { <number-value-list> | <range-spec> }

    # This is probably not needed.
    rule quantiles-list { <.the-determiner>? [ <quantiles> | <quantile> <list>? | <quantile> ] }
    rule quantiles-spec-phrase { <.quantiles-list> <quantiles-spec> |
    <.the-determiner>? <quantiles-spec> <.quantiles-list> }
    rule quantiles-spec { <number-value-list> | <range-spec> }

    # QR element -- knots.
    rule knots { <the-determiner>? 'knots' }
    rule knots-spec-phrase { <.knots> <knots-spec> | <knots-spec> <.knots> }
    rule knots-spec { <integer-value> | <number-value-list> | <range-spec> }

    # QR element -- interpolation order.
    rule interpolation-order { 'interpolation' [ 'order' | 'degree' ] }
    rule interpolation-order-spec-phrase { <.interpolation-order> <interpolation-order-spec> |
    <interpolation-order-spec> <.interpolation-order> }
    rule interpolation-order-spec { <integer-value> }

    # Find outliers command
    rule find-outliers-command { <find-outliers-simple> | <find-type-outliers> | <find-outliers-spec> }
    rule outliers-phrase { <the-determiner>? <data>? <outliers> }
    rule find-outliers-simple { <compute-and-display> <.outliers-phrase> }

    rule outlier-type { [ <.the-determiner>? <.data>? ] ( 'top' | 'bottom' ) }

    rule the-quantile { <the-determiner>? <quantile> }
    rule the-quantiles { <the-determiner>? <quantiles> }

    rule the-probability { <the-determiner>? <probability> }
    rule the-probabilities { <the-determiner>? <probabilities> }

    rule find-type-outliers { <compute-and-display> [ <outlier-type> <.outliers-phrase> ]
    [ <with-preposition> <.the-probability>? <number-value> <probability>? ]? }
    rule find-outliers-spec { <compute-and-display> <outliers-phrase> <with-preposition> <.the-proabilities>? <probabilities-spec> <probability>? }

    # Plot command
    rule plot-command { <display-directive> <plot-elements-list>? [ <date-list-diagram> | <diagram> ] | <diagram> };
    rule plot-elements-list { [ <diagram-type> | <data> ]+  % <list-separator> }
    rule diagram-type { <regression-curve-spec> | <error> | <outliers> };
    rule regression-curve-spec { ['fitted']? ( <regression-function> | <regression-function-name> ) [ 'curve' | 'curves' | 'function' | 'functions' ]? }
    rule date-list-phrase { [ 'date' | 'dates' ]  ['list']? }
    rule date-list-diagram { ( <date-list-phrase>?  <diagram> ) | <diagram> [ <with-preposition> [ 'dates' | 'date' 'axis' ] ] }
    rule regression-function-list { [ <regression-function> | <regression-function-name> ]+ % <list-separator> }
    rule regression-function { 'QuantileRegression' | 'QuantileRegressionFit' | 'LeastSquares' }
    rule regression-function-name { 'quantile' ['regression']? | 'least' 'squares' ['regression']? }
}
