#==============================================================================
#
#   LSAMon-R actions in Raku Perl 6
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
#     LatentSemanticAnalysisWorkflowsGrammar::Latent-semantic-analysis-workflow-commmand
#
#   in the file :
#
#     https://github.com/antononcube/ConversationalAgents/blob/master/Packages/Perl6/LatentSemanticAnalysisWorkflows/lib/LatentSemanticAnalysisWorkflowsGrammar.pm6
#
#==============================================================================

use v6;
#use lib '.';
#use lib '../../../EBNF/English/RakuPerl6/';
use LatentSemanticAnalysisWorkflowsGrammar;

unit module LSAMon-R-actions;

class LSAMon-R-actions::LSAMon-R-actions {

  # Top
  # method TOP($/) { make $/.values[0].made; }
  method TOP($/) { make "Not implemented"; }

}
