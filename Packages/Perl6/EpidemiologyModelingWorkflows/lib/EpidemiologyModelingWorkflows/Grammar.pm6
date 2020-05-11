=begin comment
#==============================================================================
#
#   Epidemiology Modeling workflows grammar in Raku Perl 6
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
#   For more details about Raku Perl6 see https://raku.org/ (https://perl6.org/) .
#
#==============================================================================
=end comment

use v6;
unit module EpidemiologyModelingWorkflows::Grammar;

use EpidemiologyModelingWorkflows::Grammar::CommonParts;
use EpidemiologyModelingWorkflows::Grammar::EpidemiologyPhrases;
use EpidemiologyModelingWorkflows::Grammar::PipelineCommand;

grammar EpidemiologyModelingWorkflows::Grammar::WorkflowCommand
        does EpidemiologyModelingWorkflows::Grammar::PipelineCommand
        does EpidemiologyModelingWorkflows::Grammar::EpidemiologyPhrases {
    # TOP
    rule TOP { <pipeline-command> |
    <create-command> |
    <assign-parameters-command> |
    <assign-initial-conditions-command> |
    <extend-command> |
    <simulate-command> |
    <show-results-command> |
    <sensitivity-analysis-command> }

    # Create command
    rule create-command { <create-by-single-site-model> | <create-simple> }
    rule create-preamble-phrase { <generate-directive> [ <.a-determiner> | <.the-determiner> ]? <simulation-object> }
    rule create-simple { <create-preamble-phrase> <simple-way-phrase>? | <simple> <simulation-object> [ 'creation' | 'making' ] }
    rule create-by-single-site-model { [ <create-preamble-phrase> | <create> ] <.by-preposition> <single-site-model-spec> }

    # Single-site model spec
    rule single-site-model-spec { <SIR-spec> | <SEIR-spec> | <SEI2R-spec> | <SEI2HR-spec> | <SEI2HREcon-spec> }
    rule SIR-spec { 'SIR' | 'sir' | <susceptible> <infected> <recovered> }
    rule SEIR-spec { 'SEIR' | 'seir' | <susceptible> <exposed> <infected> <recovered> }
    rule SEI2R-spec { 'SEI2R' | 'sei2r' | <susceptible> <exposed> <infected> [ 'two' | '2' ] <recovered> }
    rule SEI2HR-spec { 'SEI2HR' | 'sei2hr' | <susceptible> <exposed> <infected> [ 'two' | '2' ] <hospitalized> <recovered>  }
    rule SEI2HREcon-spec {
        'SEI2REcon' | 'sei2hrecon' |
        <susceptible> <exposed> <infected> [ 'two' | '2' ] <hospitalized> <recovered> <economics> |
        <economics> <SEI2HR-spec>
  }

    # Data statistics command

    # Simulate
    rule simulate-command { <simulate-simple-spec> | <simulate-over-time-range> }
    rule simulate-simple-spec { <simulate> }
    rule simulate-over-time-range { <simulate> <over> <the-determiner>? <time-range> <time-range-spec> }

    # Plot command
    rule plot-command { <plot-recommendation-scores> }
    rule plot-populations-command { <plot-directive> <.the-determiner>? <simulation-results> }

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
