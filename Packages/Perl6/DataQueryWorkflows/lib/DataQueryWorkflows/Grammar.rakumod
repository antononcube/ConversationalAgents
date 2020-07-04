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
        <pipeline-command> |
        <data-load-command> |
        <select-command> |
        <filter-command> |
        <mutate-command> |
        <group-command> |
        <arrange-command> |
        <statistics-command> |
        <join-command> |
        <cross-tabulate-command> }

    # Load data
    rule data-load-command { <load-data-table> | <use-data-table> }
    rule data-location-spec { <dataset-name> }
    rule load-data-table { <.load-data-directive> <data-location-spec> }
    rule use-data-table { [ <.use-verb> | <.using-preposition> ] <.the-determiner>? <.data>? <variable-name> }

    # Select command
    rule select-command { <select> <.the-determiner>? [ <.variables-noun> | <.variable-noun> ]? <variable-names-list> }

    # Filter command
    rule filter-command { <filter> <.the-determiner>? <.rows>? [ <.for-which-phrase>? | <.by-preposition> ] <filter-spec> }
    rule filter-spec { <predicates-list> }

    # Mutate command
    rule mutate-command { ( <mutate> | <assign> ) <.by-preposition>? <assign-pairs-list> }
    rule assign-pair { <assign-pair-lhs> <.assign-to-symbol> <assign-pair-rhs> }
    rule assign-pair-lhs { <quoted-variable-name> | <variable-name> }
    rule assign-pair-rhs { <variable-name> | <wl-expr> }
    rule assign-pairs-list { <assign-pair>+ % <.list-separator> }

    # Group command
    rule group-command { <group-by> <variable-names-list> }

    # Arrange command
    rule arrange-command { <arrange-command-descending> | <arrange-command-ascending> }
    rule arrange-command-simple { <arrange> <.the-determiner>? [ <.variables-noun> | <.variable-noun> ]? <variable-names-list> }
    rule arrange-command-ascending { <arrange-command-simple> <.ascending>? }
    rule arrange-command-descending { <arrange-command-simple> <descending> }

    # Statistics command
    rule statistics-command { <count-command> | <glimpse-data> | <summarize-data> | <summarize-all-command> }
    rule count-command { <compute-directive> <.the-determiner>? [ <count-verb> | <counts-noun> ] }
    rule glimpse-data { <.display-directive>? <.a-determiner>? <.glimpse-verb> <.at-preposition>? <.the-determiner>? <data>  }
    rule summarize-data { [ <summarize-verb> | <summarise-verb> ] <data> }
    rule summarize-all-command { [ <summarize-verb> | <summarise-verb> ] <them-pronoun>? <all-determiner>? }

    # Join command
    rule join-command { <inner-join-spec> | <left-join-spec> | <right-join-spec> | <semi-join-spec> | <full-join-spec> }
    rule join-by-spec { <assign-pairs-list> | <quoted-variable-names-list> }
    rule full-join-spec  { <.full-adjective>  <.join-noun> <.with-preposition>? <dataset-name> [ [ <.by-preposition> | <.using-preposition> ] <join-by-spec> ]? }
    rule inner-join-spec { <.inner-adjective> <.join-noun> <.with-preposition>? <dataset-name> [ [ <.by-preposition> | <.using-preposition> ] <join-by-spec> ]? }
    rule left-join-spec  { <.left-adjective>  <.join-noun> <.with-preposition>? <dataset-name> [ [ <.by-preposition> | <.using-preposition> ] <join-by-spec> ]? }
    rule right-join-spec { <.right-adjective> <.join-noun> <.with-preposition>? <dataset-name> [ [ <.by-preposition> | <.using-preposition> ] <join-by-spec> ]? }
    rule semi-join-spec  { <.semi-adjective>  <.join-noun> <.with-preposition>? <dataset-name> [ [ <.by-preposition> | <.using-preposition> ] <join-by-spec> ]? }

    # Cross tabulate command
    rule cross-tabulate-command { <.cross-tabulate-phrase> <.variable-noun>? <rows-variable-name> [ <.and-conjunction> | <.with-preposition> ] <.variable-noun>? <columns-variable-name> [ <.over-preposition> <values-variable-name> ]? }
    rule rows-variable-name { <variable-name> }
    rule columns-variable-name { <variable-name> }
    rule values-variable-name { <variable-name> }

    # To wide form command

    # To long form command
}
