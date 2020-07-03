=begin comment
#==============================================================================
#
#   Data transformation workflows grammar in Raku Perl 6
#   Copyright (C) 2018  Anton Antonov
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
=end comment

use v6;

use DataQueryWorkflows::Grammar::DataQueryPhrases;
use DataQueryWorkflows::Grammar::PipelineCommand;
use DataQueryWorkflows::Grammar::ErrorHandling;

grammar DataQueryWorkflows::Grammar
        does DataQueryWorkflows::Grammar::ErrorHandling
        does DataQueryWorkflows::Grammar::DataQueryPhrases
        does DataQueryWorkflows::Grammar::PipelineCommand {

    # TOP
    rule TOP {
        <load-data> |
        <select-command> |
        <filter-command> |
        <mutate-command> |
        <group-command> |
        <statistics-command> |
        <arrange-command> |
        <pipeline-command> }

    # Load data
    rule load-data { <.load-data-directive> <data-location-spec> }
    rule data-location-spec { .* }

    # Select command
    rule select-command { <select> <.the-determiner>? <.variables>? <variable-names-list> }

    # Filter command
    rule filter-command { <filter> <.the-determiner>? <.rows>? ( <.for-which-phrase>? | <by-preposition> )  <filter-spec> }
    rule filter-spec { <predicates-list> }

    # Mutate command
    rule mutate-command { ( <mutate> | <assign> ) <.by-preposition>? <assign-pairs-list> }
    rule assign-pair { <variable-name> <.assign-to-symbol> <variable-name> }
    rule assign-pairs-list { <assign-pair>+ % <.list-separator> }

    # Group command
    rule group-command { <group-by> <variable-names-list> }

    # Arrange command
    rule arrange-command { <arrange-command-descending> | <arrange-command-ascending> }
    rule arrange-command-simple { <arrange> <.the-determiner>? <.variables>? <variable-names-list> }
    rule arrange-command-ascending { <arrange-command-simple> <.ascending>? }
    rule arrange-command-descending { <arrange-command-simple> <descending> }

    # Statistics command
    rule statistics-command { <count-command> | <summarize-all-command> }
    rule count-command { <compute-directive> <.the-determiner>? [ <count-verb> | <counts-noun> ] }
    rule summarize-all-command { [ <summarize-verb> | <summarise-verb> ] <them-pronoun>? <all-determiner>? }
}
