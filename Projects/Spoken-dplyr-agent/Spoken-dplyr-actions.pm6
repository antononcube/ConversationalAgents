#==============================================================================
#
#   Spoken dplyr actions in Raku Perl 6
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
#
#   The actions are implemented for the grammar:
#
#     DataTransformationWorkflowGrammar::Spoken-dplyr-command
#
#   in the file :
#
#     https://github.com/antononcube/ConversationalAgents/blob/master/EBNF/English/RakuPerl6/DataTransformationWorkflowsGrammar.pm6
#
#==============================================================================


use v6;
# use lib '.';
# use lib '../../../English/RakuPerl6/';
use DataTransformationWorkflowsGrammar;

unit module Spoken-dplyr-actions;

class Spoken-dplyr-actions::Spoken-dplyr-actions {
  method TOP($/) { make $/.values[0].made; }
  # General
  method variable-name($/) { make $/; }
  method list-separator($/) { make ','; }
  method variable-names-list($/) { make $<variable-name>>>.made.join(", "); }
  # Load data
  method load-data($/) { make "starwars"; }
  # Select command
  method select-command($/) { make "dplyr::select(" ~ $<variable-names-list>.made ~ ")"; }
  # Mutate command
  method mutate-command($/) { make "dplyr::mutate(" ~ $<assign-pairs-list>.made ~ ") "; }
  method assign-pairs-list($/) { make $<assign-pair>>>.made.join(", "); }
  method assign-pair($/) { make $/.values[0].made ~ " = " ~ $/.values[1].made; }
  # Group command
  method group-command($/) { make "dplyr::group_by(" ~ $<variable-names-list>.made ~ ")"; }
  # Arrange command
  method arrange-command($/) { make "dplyr::arrange(desc(" ~ $<variable-names-list>.made ~ "))"; }
  # Statistics command
  method statistics-command($/) { make $/.values[0].made; }
  method count-command($/) { make "dplyr::count()"; }
  method summarize-all-command($/) { make "dplyr::summarise_all(mean)"}
}
