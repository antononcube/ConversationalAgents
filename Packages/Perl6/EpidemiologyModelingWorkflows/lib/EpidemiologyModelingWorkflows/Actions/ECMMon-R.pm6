=begin comment
#==============================================================================
#
#   ECMMon-R actions in Raku Perl 6
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
#   and a possible software monad ECMMon-R.
#
#==============================================================================
#
#   The code below is derived from the code for ECMMon-R by simple
#   unfolding of the monadic pipeline into assignment.
#
#==============================================================================
=end comment

use v6;

use EpidemiologyModelingWorkflows::Grammar;

class EpidemiologyModelingWorkflows::Actions::ECMMon-R {
    # Top
    method TOP($/) {
        make $/.values[0].made;
    }

    # General
    method dataset-name($/) { make $/.values[0].made; }
    method variable-name($/) { make $/.Str; }
    method list-separator($/) { make ','; }
    method variable-names-list($/) { make 'c(' ~ $<variable-name>>>.made.join(', ') ~ ')'; }
    method integer-value($/) { make $/.Str; }
    method number-value($/) { make $/.Str; }

    # Trivial
    method trivial-parameter($/) { make $/.values[0].made; }
    method trivial-parameter-none($/) { make 'NA'; }
    method trivial-parameter-empty($/) { make 'c()'; }
    method trivial-parameter-automatic($/) { make 'NULL'; }
    method trivial-parameter-false($/) { make 'FALSE'; }
    method trivial-parameter-true($/) { make 'TRUE'; }

    # Creation
    method create-command($/) { make $/.values[0].made; }
    method create-simple($/) { make 'ECMMonUnit()'; }
    method create-by-single-site-model($/) {
        make 'ECMMonUnit(' ~ $<single-site-model-spec>.made ~ ')';
    }

    # Single site model spec
    method single-site-model-spec($/) { make $/.values[0].made; }
    method SIR-spec($/) { make 'SIRModel()'; }
    method SEIR-spec($/) { make 'SEIRModel()'; }
    method SEI2R-spec($/) { make 'SEI2RMode()'; }
    method SEI2HR-spec($/) { make 'SEI2HRModel()'; }
    method SEI2HREcon-spec($/) { make 'SEI2HREconModel()'; }

    # Stock specification

    # Rate specification

    # Assign parameters command

    # Assign initial conditions command

    # Assign rates command

    # Simulate
    method simulate-command($/) { make $/.values[0].made; }
    method simulate-simple-spec($/) { make 'ECMMonSimulate()'; }
    method simulate-over-time-range($/) { make 'ECMMonSimulate(' ~ $<time-range-spec>.made ~ ')'; }

    # Time range specification
    method time-range-spec($/) { make $/.values[0].made; }

    method time-range-simple-spec($/) { make 'maxTime = ' ~ $<number-value>.made; }

    method time-range-element-list($/) {
        make '' ~ $<variable-range-element>>>.made.join(', ');
    }

    method time-range-max($/) { make 'maxTime = ' ~ $<number-value>.made; }
    method time-range-min($/) { make 'minTime = ' ~ $<number-value>.made; }
    method time-range-step($/) { make 'step = ' ~ $<number-value>.made; }

    method max-time($/) { make 'maxTime = ' ~ $<number-value>.made; }

    # Plot command
    method plot-command($/) { make $/.values[0].made; }
    method plot-solutions($/) { make 'ECMMonPlotSolutions()'; }
    method plot-population-solutions($/) { make 'ECMMonPlotSolutions( stocksSpec = ".*Population")'; }
    method plot-solution-histograms($/) { make 'ECMMonPlotSolutionHistograms()'; }


    # Pipeline command
    method pipeline-command($/) { make  $/.values[0].made; }
    method get-pipeline-value($/) { make 'ECMMonEchoValue()'; }
}
