#==============================================================================
#
#   LSAMon-WL actions in Raku Perl 6
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

unit module LSAMon-WL-actions;

class LSAMon-WL-actions::LSAMon-WL-actions {

  # Top
  method TOP($/) { make $/.values[0].made; }
  # method TOP($/) { make "Not implemented"; }

  # General
  method dataset-name($/) { make $/.values[0].made; }
  method variable-name($/) { make $/.Str; }
  method list-separator($/) { make ','; }
  method variable-names-list($/) { make '{' ~ $<variable-name>>>.made.join(', ') ~ '}'; }
  method integer-value($/) { make $/.Str; }
  method number-value($/) { make $/.Str; }


  # Data load commands
  method data-load-command($/) { make $/.values[0].made; }
  method load-data($/) { make 'LSAMonSetData[' ~ $/.values[0].made ~ ']'; }
  method data-location-spec($/) { make $<dataset-name>.made; }
  method use-lsa-object($/) { make $<variable-name>.made; }

  # Create command
  method make-doc-term-matrix-command($/) { make $/.values[0].made; }
  method create-by-dataset($/) { make 'LSAMonMakeDocumentTermMatrix[]'; }

  # Data transformation commands
  method data-transformation-command($/) { make 'LSMonFailure["Not implemented yet."]'; }

  # LSI command is programmed as a role.
  method lsi-apply-command($/) { make 'LSAMonApplyTermWeightFunctions[' ~ $/.values[0].made ~ ']'; }
  method lsi-funcs-simple-list($/) { say 'simple'; make $<lsi-global-func>.made ~ ", " ~ $<lsi-local-func>.made ~ ", " ~ $<lsi-normalizer-func>; }
  method lsi-funcs-list($/) { make $<lsi-func>>>.made.join(', '); }
  method lsi-func($/) { make $/.values[0].made; }
  method lsi-global-func($/) { make '"GlobalWeightFunction" -> ' ~  $/.values[0].made; }
  method lsi-global-func-idf($/) { make '"IDF"'; }
  method lsi-global-func-entropy($/) { make '"Entropy"'; }
  method lsi-global-func-sum($/) { make '"ColummStochastic"'; }
  method lsi-func-none($/) { make '"None"';}

  method lsi-local-func($/) { make '"LocalWeightFunction" -> ' ~  $/.values[0].made; }
  method lsi-local-func-frequency($/) { make '"None"'; }
  method lsi-local-func-binary($/) { make '"Binary"'; }
  method lsi-local-func-log($/) { make '"Log"'; }

  method lsi-normalizer-func($/) { make '"NormalizerFunction" -> ' ~  $/.values[0].made; }
  method lsi-normalizer-func-sum($/) { make '"Sum"'; }
  method lsi-normalizer-func-max($/) { make '"Max"'; }
  method lsi-normalizer-func-cosine($/) { make '"Cosine"'; }



}
