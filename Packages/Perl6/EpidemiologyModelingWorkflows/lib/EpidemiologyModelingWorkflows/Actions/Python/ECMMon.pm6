=begin comment
#==============================================================================
#
#   ECMMon-Py actions in Raku Perl 6
#   Copyright (C) 2020  Anton Antonov
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
#   antononcube @ gmail . com,
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
#     EpidemiologyModelingWorkflows::Grammar::WorkflowCommand
#
#   and a possible software monad ECMMon-Py.
#
#==============================================================================
=end comment

use v6;

use EpidemiologyModelingWorkflows::Grammar;

class EpidemiologyModelingWorkflows::Actions::Python::ECMMon {
    # Top
    method TOP($/) { make $/.values[0].made; }

    # General
    method dataset-name($/) { make $/.values[0].made; }
    method variable-name($/) { make $/.Str; }
    method list-separator($/) { make ','; }
    method variable-names-list($/) { make '[' ~ $<variable-name>>>.made.join(', ') ~ ']'; }
    method integer-value($/) { make $/.Str; }
    method number-value($/) { make $/.Str; }
    method number-value-list($/) { make '[' ~ $<number-value>>>.made.join(', ') ~ ']'; }
    method r-range-spec($/) { make 'seq' ~ $<number-value-list>.made.substr(1); }
    method wl-range-spec($/) { make 'seq' ~ $<number-value-list>.made.substr(1); }
    method r-numeric-list-spec($/) { make $<number-value-list>.made; }
    method wl-numeric-list-spec($/) { make $<number-value-list>.made; }

    # Range spec
    method range-spec($/) {
        if $<range-spec-step> {
            make 'seq(' ~ $<range-spec-from>.made ~ ', ' ~ $<range-spec-to>.made ~ ', ' ~ $<range-spec-step>.made ~ ')';
        } else {
            make 'seq(' ~ $<range-spec-from>.made ~ ', ' ~ $<range-spec-to>.made ~ ')';
        }
    }
    method range-spec-from($/) { make $<number-value>.made; }
    method range-spec-to($/) { make $<number-value>.made; }
    method range-spec-step($/) { make $<number-value>.made; }

    # Trivial
    method trivial-parameter($/) { make $/.values[0].made; }
    method trivial-parameter-none($/) { make 'NA'; }
    method trivial-parameter-empty($/) { make '[]'; }
    method trivial-parameter-automatic($/) { make 'NULL'; }
    method trivial-parameter-false($/) { make 'False'; }
    method trivial-parameter-true($/) { make 'True'; }

      # Data load commands
    method data-load-command($/) { make $/.values[0].made; }
    method use-object($/) { make $<variable-name>.made; }

    # Creation
    method create-command($/) { make $/.values[0].made; }
    method create-simple($/) { make 'obj = ECMMonUnit()'; }
    method create-by-single-site-model($/) {
        make 'obj = ECMMonUnit( model = ' ~ $<single-site-model-spec>.made ~ ')';
    }

    # Single site model spec
    method single-site-model-spec($/) { make $/.values[0].made; }
    method SIR-spec($/) { make 'SIRModel()'; }
    method SEIR-spec($/) { make 'SEIRModel()'; }
    method SEI2R-spec($/) { make 'SEI2RModel()'; }
    method SEI2HR-spec($/) { make 'SEI2HRModel()'; }
    method SEI2HREcon-spec($/) { make 'SEI2HREconModel()'; }

    # Stock specification
    method stock-spec($/) { make $/.values[0].made; }
    method total-population-spec($/) { make 'TPt'; }
    method susceptible-population-spec($/) { make 'SPt'; }
    method exposed-population-spec($/) { make 'EPt'; }
    method infected-normally-symptomatic-population-spec($/) { make 'INSPt'; }
    method infected-severely-symptomatic-population-spec($/) { make 'ISSPt'; }
    method recovered-population-spec($/) { make 'RPt'; }
    method money-of-lost-productivity-spec($/) { make 'MLPt'; }
    method hospitalized-population-spec($/) { make 'HPt'; }
    method deceased-infected-population-spec($/) { make 'DIPt'; }
    method medical-supplies-spec($/) { make 'MSt'; }
    method medical-supplies-demand-spec($/) { make 'MSDt'; }
    method hospital-beds-spec($/) { make 'HBt'; }
    method money-for-medical-supplies-production-spec($/) { make 'MMSPt'; }
    method money-for-hospital-services-spec($/) { make 'MHSt'; }
    method hospital-medical-supplies-spec($/) { make 'HMSt'; }

    # Rate specification
    method rate-spec($/){ make $/.values[0].made; }
    method population-death-rate-spec($/) { make 'deathRateTP'; }
    method infected-normally-symptomatic-population-death-rate-spec($/) { make 'deathRateINSP'; }
    method infected-severely-symptomatic-population-death-rate-spec($/) { make 'deathRateISSP'; }
    method severely-symptomatic-population-fraction-spec($/) { make 'sspf'; }
    method contact-rate-for-the-normally-symptomatic-population-spec($/) { make 'contactRateINSP'; }
    method contact-rate-for-the-severely-symptomatic-population-spec($/) { make 'contactRateISSP'; }
    method average-infectious-period-spec($/) { make 'aip'; }
    method average-incubation-period-spec($/) { make 'aincp'; }
    method lost-productivity-cost-rate-spec($/) { make 'lpcr'; }
    method hospitalized-population-death-rate-spec($/) { make 'deathRateHP'; }
    method contact-rate-for-the-hospitalized-population-spec($/) { make 'contactRateHP'; }
    method number-of-hospital-beds-rate-spec($/) { make 'nhbrTP'; }
    method hospital-services-cost-rate-spec($/) { make 'hscr'; }
    method number-of-hospital-beds-change-rate-spec($/) { make 'nhbcr'; }
    method hospitalized-population-medical-supplies-consumption-rate-spec($/) { make  'hpmscr'; }
    method un-hospitalized-population-medical-supplies-consumption-rate-spec($/) { make 'upmscr'; }
    method medical-supplies-production-rate-spec($/) { make  'msprHB'; }
    method medical-supplies-production-cost-rate-spec($/) { make  'mspcrHB'; }
    method medical-supplies-delivery-rate-spec($/) { make 'msdrHB'; }
    method medical-supplies-delivery-period-spec($/) { make  'msdpHB'; }
    method medical-supplies-consumption-rate-tp-spec($/) { make 'mscrTP'; }
    method medical-supplies-consumption-rate-insp-spec($/) { make 'mscrINSP'; }
    method medical-supplies-consumption-rate-issp-spec($/) { make 'mscrISSP'; }
    method medical-supplies-consumption-rate-hp-spec($/) { make 'mscrHP'; }
    method capacity-to-store-hospital-medical-supplies-spec($/) { make 'capacityHMS'; }
    method capacity-to-store-produced-medical-supplies-spec($/) { make 'capacityMS'; }
    method capacity-to-transport-produced-medical-supplies-spec($/) { make 'capacityMSD'; }

    # Assign parameters command
    method assign-parameters-command($/) { make $/.values[0].made; }

    # Assign initial conditions command
    method assign-initial-conditions-command ($/) { make $/.values[0].made; }
    method assign-value-to-stock($/) { make 'obj = ECMMonAssignInitialConditions( ecmObj = obj, initConds = [' ~ $<stock-spec>.made ~ ' = ' ~ $<number-value>.made ~ '])';}

    # Assign rates command
    method assign-rate-values-command ($/) { make $/.values[0].made; }
    method assign-value-to-rate($/) { make 'obj = ECMMonAssignRateValues( ecmObj = obj, rateValues = [' ~ $<rate-spec>.made ~ ' = ' ~ $<number-value>.made ~ '])';}

    # Simulate
    method simulate-command($/) { make $/.values[0].made; }
    method simulate-simple-spec($/) { make 'obj = ECMMonSimulate( )'; }
    method simulate-over-time-range($/) { make 'obj = ECMMonSimulate( ecmObj = obj, ' ~ $<time-range-spec-command-part>.made ~ ')'; }

    # Time range specification
    method time-range-spec-command-part($/) { make $<time-range-spec>.made; }
    method time-range-spec($/) { make $/.values[0].made; }

    method time-range-simple-spec($/) { make 'maxTime = ' ~ $<number-value>.made; }

    method time-range-element-list($/) { make $<time-range-element>>>.made.join(', '); }

    method time-range-element($/) { make $/.values[0].made; }
    method time-range-max($/) { make 'maxTime = ' ~ $<number-value>.made; }
    method time-range-min($/) { make 'minTime = ' ~ $<number-value>.made; }
    method time-range-step($/) { make 'step = ' ~ $<number-value>.made; }

    method max-time($/) { make 'maxTime = ' ~ $<number-value>.made; }

    # Batch Simulate
    method batch-simulate-command($/) { make $/.values[0].made; }
    method batch-simulate-over-parameters($/) { make 'obj = ECMMonBatchSimulate( ecmObj = obj, ' ~ $<batch-simulation-parameters-spec>.made ~ ', ' ~ $<time-range-spec>.made ~ ')'; }

    method batch-simulation-parameters-spec($/) { make $/.values[0].made; }
    method batch-parameters-data-frame-spec($/) { make 'params = ' ~ $<dataset-name>.made; }
    method batch-parameter-outer-form-spec($/) { make 'params = ' ~ $<parameter-range-spec-list>.made; }
    method parameter-range-spec-list($/) { make '{' ~ $<parameter-range-spec>>>.made.join(', ') ~ '}'; }
    method parameter-spec($/) { make $/.values[0].made; }
    method parameter-values($/) { make $/.values[0].made; }
    method parameter-range-spec($/) { make $<parameter-spec>.made ~ ' = ' ~ $<parameter-values>.made; }

    # Plot command
    method plot-command($/) { make $/.values[0].made; }
    method plot-solutions($/) {
        if $<time-range-spec-command-part> {
            make 'obj = ECMMonPlotSolutions( ecmObj = obj, ' ~ $<time-range-spec-command-part>.made ~ ')';
        } else {
            make 'obj = ECMMonPlotSolutions( ecmObj = obj )';
        }
    }
    method plot-population-solutions($/) {
        if $<time-range-spec-command-part> {
            make 'obj = ECMMonPlotSolutions( ecmObj = obj, stocksSpec = ".*Population", ' ~ $<time-range-spec-command-part>.made ~ ')';
        } else {
            make 'obj = ECMMonPlotSolutions( ecmObj = obj, stocksSpec = ".*Population")';
        }
    }
    method plot-solution-histograms($/) {
        if $<time-range-spec-command-part> {
            make 'obj = ECMMonPlotSolutionHistograms( ecmObj = obj, ' ~ $<time-range-spec-command-part>.made ~ ')';
        } else {
            make 'obj = ECMMonPlotSolutionHistograms( ecmObj = obj )';
        }
    }

    # Extend single site model command
    method extend-single-site-model-command($/) { make $/.values[0].made; }

    method extend-by-matrix($/) {
        if $<migrating-stocks-subcommand> {
            make 'obj = ECMMonExtendByAdjacencyMatrix( ecmObj = obj, mat = ' ~ $<variable-name>.made ~ ', migratingStocks = ' ~ $<migrating-stocks-subcommand>.made ~ ')';
        } else {
            make 'obj = ECMMonExtendByAdjacencyMatrix( ecmObj = obj, mat = ' ~ $<variable-name>.made ~ ')';
        }
    }

    method extend-by-traveling-patterns-dataframe($/) { make 'obj = ECMMonExtendByDataFrame( ecmObj = obj, data = ' ~ $<dataset-name>.made ~ ')'; }
    method extend-by-country-spec($/) { make 'obj = ECMMonExtendByCountry( ecmObj = obj, country = ' ~ $<country-spec>.made ~ ')'; }
    method country-spec($/) { make $<variable-name>; }

    method migrating-stocks-subcommand($/) { make $<stock-specs-list>.made; }
    method stock-specs-list($/) { make '["' ~ $<stock-spec>>>.made.join('", "') ~ '"]'; }

    # Pipeline command
    method pipeline-command($/) { make  $/.values[0].made; }
    method get-pipeline-value($/) { make 'obj = ECMMonEchoValue( ecmObj = obj )'; }
}
