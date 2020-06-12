=begin comment
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
=end comment

use v6;
use QuantileRegressionWorkflows::Grammar::TimeSeriesAndRegressionPhrases;
use QuantileRegressionWorkflows::Grammar::PipelineCommand;

grammar QuantileRegressionWorkflows::Grammar::WorkflowCommmand
        does QuantileRegressionWorkflows::Grammar::PipelineCommand
        does QuantileRegressionWorkflows::Grammar::TimeSeriesAndRegressionPhrases {
    # TOP

    regex TOP {
        <data-load-command> |
        <create-command> |
        <data-transformation-command> |
        <data-statistics-command> |
        <regression-command> |
        <find-outliers-command> |
        <find-anomalies-command> |
        <plot-command> |
        <plot-errors-command> |
        <pipeline-command> }

    # Load data
    rule data-load-command { <load-data> | <use-qr-object> }
    rule data-location-spec { <dataset-name> }
    rule load-data { <.load-data-directive> <data-location-spec> }
    rule use-qr-object { <.use-verb> <.the-determiner>? <.qr-object> <variable-name> }

    # Create command
    rule create-command { <create-by-dataset> }
    rule simple-way-phrase { <in-preposition> <a-determiner> <simple> <way-noun> | <directly-adverb> | <simply-adverb> }
    rule create-simple { <.create-directive> <.a-determiner>? <object> <simple-way-phrase> | <simple> <object> <creation> }
    rule create-by-dataset { [ <.create-simple> | <.create-directive> ] [ <.by-preposition> | <.with-preposition> | <.from-preposition> ]? <dataset-name> }

    # Data transform command
    rule data-transformation-command { <delete-missing> | <rescale-command> | <resample-command> | <moving-func-command> }

    rule delete-missing { <delete-directive> [ <rows> <.with-preposition> ]? <missing-values-phrase> }

    rule rescale-command { <rescale-axis> | <rescale-both-axes> }
    rule rescale-axis { <.rescale-directive> <.the-determiner>? <axis-spec> <axis>}
    rule axis-spec { <regressor-axis-spec> | <value-axis-spec> }
    rule regressor-axis-spec { <x-symbol> | <regressor> }
    rule value-axis-spec { <y-symbol> | <value-noun> }
    rule rescale-both-axes { <rescale-directive> [ <the-determiner> | <both-determiner> ]? <axes>}

    rule resample-command {<resample-directive> <.the-determiner>? [ <time-series-data> ]? [ <using-preposition> <resampling-method-spec> ]? [ <using-preposition> <sampling-step-spec> ]?}
    rule sampling-step-spec { <default-sampling-step> | <step-noun> <number-value> }
    rule default-sampling-step { [ <smallest> <difference> | <default> | <automatic> ] <step-noun> }
    rule resampling-method-spec { <resampling-method> | <resampling-method-name> }
    rule resampling-method { 'LinearInterpolation' | 'HoldValueFromLeft' }
    rule resampling-method-name { <linear> <interpolation> | <hold-verb> <value-from-left-phrase> }

    rule moving-func-command { [ <.compute-directive>? <moving-func-spec> <.using-preposition> ] [ <number-value> <elements>? | <the-determiner>? <weights>? <number-value-list> <weights>? ] }
    rule moving-func-name { <moving> [ <average> | <median> | 'Mean' | 'Median' ] }
    rule moving-map-func { [<moving> <map-noun>] <wl-expr>}
    rule moving-func-spec { <moving-func-name> | <moving-map-func> }

    # Data statistics command
    rule data-statistics-command { <summarize-data> }
    rule summarize-data { <summarize-directive> <the-determiner>? <data> | <display-directive> <data>? [ <summary> | <summaries> ] }

    # Regression command
    rule regression-command { [ <.compute-directive> | <.compute-and-display> | <.do-verb> ] <quantile-regression-spec> }
    rule quantile-regression-phrase-ext { <quantile-regression-phrase> | 'QuantileRegression' }
    rule quantile-regression-preamble { <a-determiner>? <quantile-regression-phrase-ext> <fit>? }
    rule quantile-regression-spec { <quantile-regression-spec-full> | <quantile-regression-spec-simple> }
    rule quantile-regression-spec-simple { <quantile-regression-preamble> }
    rule quantile-regression-spec-full { <.quantile-regression-preamble> [ <.using-preposition> | <.for-preposition> ] <quantile-regression-spec-element-list> }
    rule quantile-regression-spec-element-list { <quantile-regression-spec-element>+ % <spec-list-delimiter> }
    rule quantile-regression-spec-element { <probabilities-spec-subcommand> | <knots-spec-subcommand> | <interpolation-order-spec-subcommand> }

    token spec-list-delimiter { <list-separator> <.ws>? <using-preposition>? }

    # QR element - list of probabilities.
    rule probabilities-spec-subcommand { <.the-determiner>? [ <.probabilities-list-phrase> <probabilities-spec> | <probabilities-spec> <.probabilities-list-phrase>? ] }
    rule probabilities-list-phrase { <probabilities> | <probability> <list-noun>? | <probability> }
    rule probabilities-spec { <number-value-list> | <range-spec> }

    # QR element -- knots.
    rule knots-spec-subcommand { <.knots-phrase> <knots-spec> | <knots-spec> <.knots-phrase> }
    rule knots-phrase { <the-determiner>? <knots> }
    rule knots-spec { <integer-value> | <number-value-list> | <range-spec> }

    # QR element -- interpolation order.
    rule interpolation-order-spec-subcommand { <.interpolation-order-phrase> <interpolation-order-spec> | <interpolation-order-spec> <.interpolation-order-phrase> }
    rule interpolation-order-phrase { <interpolation> [ <order> | <degree> ] }
    rule interpolation-order-spec { <integer-value> }

    # Find outliers command
    rule find-outliers-command { <find-type-outliers> | <find-outliers-spec> | <find-outliers-simple> }
    rule outliers-phrase { <the-determiner>? <data>? <outliers> }
    rule find-outliers-simple { <compute-and-display> <.outliers-phrase> }

    rule outlier-type { [ <.the-determiner>? <.data>? ] [ <top-noun> | <bottom-noun> ] }

    rule the-quantile { <the-determiner>? <quantile> }
    rule the-quantiles { <the-determiner>? <quantiles> }

    rule the-probability { <the-determiner>? <probability> }
    rule the-probabilities { <the-determiner>? <probabilities> }

    rule find-type-outliers { <.compute-and-display> <outlier-type> <.outliers-phrase> [ <.with-preposition> [ <probabilities-spec-subcommand> | <probabilities-spec-subcommand> ] ]? }
    rule find-outliers-spec { <.compute-and-display> <.outliers-phrase> <.with-preposition> [ <probabilities-spec-subcommand> | <probabilities-spec-subcommand> ] }

    # Find anomalies command
    rule find-anomalies-command { <find-anomalies-by-residuals-threshold> | <find-anomalies-by-residuals-outliers> }
    rule find-anomalies-by-residuals-preamble { <.compute-directive> <.anomalies> [ <.by-preposition> <.residuals> ]? }
    rule find-anomalies-by-residuals-threshold { <.find-anomalies-by-residuals-preamble> <.with-preposition> <.the-determiner>? <.threshold> <number-value> }
    rule find-anomalies-by-residuals-outliers { <.find-anomalies-by-residuals-preamble> <.with-preposition> <.the-determiner>? [ <.outlier> <.identifier> <variable-name> | <variable-name> <.outlier> <.identifier> ]}

    # Plot command
    rule plot-command { <.display-directive> <plot-elements-list>? [ <date-list-diagram> | <diagram> ] | <diagram> };
    rule plot-elements-list { [ <diagram-type> | <data> ]+  % <list-separator> }
    rule diagram-type { <regression-curve-spec> | <error> | <outliers> };
    rule regression-curve-spec { <fitted>? [ <regression-function> | <regression-function-name> ] [ <curve> | <curves> | <function> | <functions> ]? }
    rule date-list-phrase { [ <date> | <dates> ]  <list-noun>? }
    rule date-list-diagram { [ <date-list-phrase> <diagram> | <diagram> [ <with-preposition> [ <dates> | <date> <axis> ] ] ] [ <.with-preposition>? <date-origin> ]? }
    rule date-origin { [<date> <origin>] <date-spec> }

    rule regression-function-list { [ <regression-function> | <regression-function-name> ]+ % <list-separator> }
    rule regression-function { 'QuantileRegression' | 'QuantileRegressionFit' | 'LeastSquares' }
    rule regression-function-name { <quantile> [<regression>]? | <least-squares-phrase> [<regression>]? }

    # Plot errors command
    rule plot-errors-command { <plot-errors-with-directive> }
    rule plot-errors-with-directive { [ <.display-directive> | <.plot-directive> ] <.the-determiner>? <errors-type>? <.errors> <plots>? }
    rule errors-type { <absolute> | <relative> }

    # Expressions
    token wl-expr { \S+ }
    # token word-spec { \w+ }

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

    method subparse($target, |c) {
        my $*HIGHWATER = 0;
        my $*LASTRULE;
        my $match = callsame;
        self.error_msg($target) unless $match;
        return $match;
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
