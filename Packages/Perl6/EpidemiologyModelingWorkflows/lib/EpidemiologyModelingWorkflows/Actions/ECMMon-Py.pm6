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
#
#   The code below is derived from the code for ECMMon-Py by simple
#   unfolding of the monadic pipeline into assignment.
#
#==============================================================================
=end comment

use v6;

use EpidemiologyModelingWorkflows::Grammar;

class EpidemiologyModelingWorkflows::Actions::ECMMon-Py {

  # Top
  method TOP($/) { make $/.values[0].made; }

}
