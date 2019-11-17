#==============================================================================
#
#   QRMon-R actions in Raku Perl 6
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
#   The actions are implemented for the grammar:
#
#     QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand
#
#   in the file :
#
#     https://github.com/antononcube/ConversationalAgents/blob/master/Packages/Perl6/QuantileRegressionWorkflows/lib/QuantileRegressionWorkflowsGrammar.pm6
#
#==============================================================================


use v6;
#use lib '.';
#use lib '../../../EBNF/English/RakuPerl6/';
use QuantileRegressionWorkflowsGrammar;

unit module QRMon-R-actions;

class QRMon-R-actions::QRMon-R-actions {

  # Top
  method TOP($/) { make $/.values[0].made; }

  # General
  method variable-name($/) { make $/.Str; }
  method list-separator($/) { make ','; }
  method integer-value($/) { make $/.Str; }
  method number-value($/) { make $/.Str; }
  method percent-value($/) { make $<number-value> ~ "/100"; }

  method number-value-list($/) { make 'c(' ~ $<number-value>>>.made.join(', ') ~ ')'; }
  method range-spec($/) { make 'seq(' ~ $/.values[0].made ~ ")"; }

  # Load data
  method data-load-command($/) { make $/.values[0].made; }
  method load-data($/) { make 'QRMonSetData( data = ' ~ $<data-location-spec>.made ~ ')'; }
  method data-location-spec($/) { make $<dataset-name>.made; }
  method use-qr-object($/) { make $<variable-name>.made; }
  method dataset-name($/) { make $/.Str; }

  # Create commands
  method create-command($/) { make $/.values[0].made; }
  method create-simple($/) { make 'QRMonUnit()'; }
  method create-by-dataset($/) { make 'QRMonUnit( data = ' ~ $<dataset-name>.made ~ ')'; }

  # Data transform command
  method data-transformation-command($/) { make $/.values[0].made; }

  method delete-missing($/) { make 'QRMonDeleteMissing()'; }

  method rescale-command($/) { make 'QRMonRescale(' ~ make $/.values[0].made ~ ')'; }
  method rescale-axis($/) { make $/.values[0].made; }
  method axis-spec($/) { make $/.values[0].made; }
  method regressor-axis-spec($/) { make 'regressorAxisQ = TRUE'; }
  method value-axis-spec($/) { make 'valueAxisQ = TRUE'; }

  method rescale-both-axes($/) { make 'QRMonRescale( regressorAxisQ = TRUE, valueAxisQ = TRUE )'; }

  method resample-command($/) { make 'QRMonFailure( \"Resampling is not implemented in QRMon-R.\" )'; }

  method moving-func-command($/) { make 'QRMonFailure( \"Moving mapping is not implemented in QRMon-R.\" )'; }

  # Data statistics command
  method data-statistics-command($/) { make $/.values[0].made; }
  method summarize-data($/) { make 'QRMonEchoDataSummary()'; }

  # Quantile Regression
  method regression-command($/) { make $/.values[0].made; }
  method quantile-regression-spec($/) { make $/.values[0].made; }
  method quantile-regression-spec-simple($/) { make "QRMonQuantileRegression()"; }
  method quantile-regression-spec-full($/) {  make "QRMonQuantileRegression(" ~ $<quantile-regression-spec-element-list>.made ~ ")"; }

  method quantile-regression-spec-element-list($/) {

    my $res = $<quantile-regression-spec-element>>>.made.join(', ');

    my @ks = $<quantile-regression-spec-element>>>.keys;

    if @ks.first('knots-spec-phrase') {
      make $res;
    } else {
      make 'df = 12, ' ~ $res ;
    }
  }

  method quantile-regression-spec-element($/) { make $/.values[0].made; }

  # QR element - list of probabilities.
  method probabilities-spec-phrase($/) { make "probabilities = " ~ $<probabilities-spec>.made ; }
  method probabilities-spec($/) { make $/.values[0].made; }

  # QR element - knots.
  method knots-spec-phrase($/) { make "df = " ~ $<knots-spec>.made; }
  method knots-spec($/) { make $/.values[0].made; }

  # QR element - interpolation order.
  method interpolation-order-spec-phrase($/) { make "degree = " ~ $/.values[0].made; }
  method interpolation-order-spec($/) { make $/.values[0].made; } # make $.<integer-value>.made;

  # Find outliers command
  method find-outliers-command($/) { make $/.values[0].made; }
  method find-outliers-simple($/) { make "QRMonOutliers() %>% QRMonOutliersPlot()"; }

  method find-type-outliers($/) { make "QRMonOutliers() %>% QRMonOutliersPlot()"; }
  method find-outliers-spec($/) { make "QRMonOutliers() %>% QRMonOutliersPlot()"; }

  # Find anomalies command
  method find-anomalies-command($/) { make $/.values[0].made; }

  method find-anomalies-by-residuals-threshold($/) { make 'QRMonFindAnomaliesByResiduals( threshold = ' ~ $<number-value> ~ ')'; }
  method find-anomalies-by-residuals-outliers($/) { make 'QRMonFindAnomaliesByResiduals( outlierIdentifier = ' ~ $<variable-name> ~ ')'; }

  # Plot command
  method plot-command($/) {
    my Str $opts = 'datePlotQ = FALSE';
    if $/.keys.contains(<date-list-diagram>) { $opts = $<date-list-diagram>.made; }
    make 'QRMonPlot( ' ~ $opts ~ ')';
  }

  method date-list-diagram($/) {
    my Str $opts = '';
    if $/.keys.contains(<date-origin>) { $opts = ', ' ~ $<date-origin>.made; }
    make 'datePlotQ = TRUE' ~ $opts;
  }
  method date-origin($/) { make 'dateOrigin = ' ~ $<date-spec>.made; }
  method date-spec($/) { make "'" ~ $/.Str ~ "'"; }

  # Error plot command
  method plot-errors-command($/) { make $/.values[0].made; }
  method plot-errors-with-directive($/) {
    my $err_type = 'TRUE';
    if $<errors-type> && $<errors-type>.trim eq 'absolute' { $err_type = 'FALSE'  }
    make 'QRMonErrorsPlot( relativeErrorsQ = ' ~ $err_type ~ ')';
  }

  # Pipeline command
  method pipeline-command($/) { make $/.values[0].made; }
  method take-pipeline-value($/) { make 'QRMonTakeValue'; }
  method echo-pipeline-value($/) { make 'QRMonEchoValue'; }
}
