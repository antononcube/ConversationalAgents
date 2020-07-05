=begin comment
#==============================================================================
#
#   Data Query Workflows R-dplyr actions in Raku (Perl 6)
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
#   For more details about Raku (Perl6) see https://raku.org/ .
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
=end comment

use v6;
use DataQueryWorkflows::Grammar;

unit module DataQueryWorkflows::Actions::R::dplyr;

class DataQueryWorkflows::Actions::R::dplyr {

  method TOP($/) { make $/.values[0].made; }

  # General
  method dataset-name($/) { make $/.Str; }
  method variable-name($/) { make $/.Str; }
  method list-separator($/) { make ','; }
  method variable-names-list($/) { make $<variable-name>>>.made.join(', '); }
  method quoted-variable-names-list($/) { make $<quoted-variable-name>>>.made.join(', '); }
  method integer-value($/) { make $/.Str; }
  method number-value($/) { make $/.Str; }
  method wl-expr($/) { make $/.Str; }
  method quoted-variable-name($/) {  make $/.values[0].made; }
  method single-quoted-variable-name($/) { make '\"' ~ $<variable-name>.made ~ '\"'; }
  method double-quoted-variable-name($/) { make '\"' ~ $<variable-name>.made ~ '\"'; }

  # Trivial
  method trivial-parameter($/) { make $/.values[0].made; }
  method trivial-parameter-none($/) { make 'NA'; }
  method trivial-parameter-empty($/) { make 'c()'; }
  method trivial-parameter-automatic($/) { make 'NULL'; }
  method trivial-parameter-false($/) { make 'FALSE'; }
  method trivial-parameter-true($/) { make 'TRUE'; }

  # Load data
  method data-load-command($/) { make $/.values[0].made; }
  method load-data-table($/) { make '{ data(' ~ $<data-location-spec>.made ~ '); ' ~ $<data-location-spec>.made ~ ' }'; }
  method data-location-spec($/) { make '\'' ~ $/.Str ~ '\''; }
  method use-data-table($/) { make $<variable-name>.made; }

  # Select command
  method select-command($/) { make 'dplyr::select(' ~ $<variable-names-list>.made ~ ')'; }

  # Filter commands
  method filter-command($/) { make 'dplyr::filter(' ~ $<filter-spec>.made ~ ')'; }
  method filter-spec($/) { make $<predicates-list>.made; }
  method predicates-list($/) { make $<predicate>>>.made.join(', '); }
  method predicate($/) { make $<variable-name>.made ~ ' ' ~ $<predicate-symbol>.made ~ ' ' ~ $<predicate-value>.made; }
  method predicate-symbol($/) { make $/.Str; }
  method predicate-value($/) { make $/.values[0].made; }

  # Mutate command
  method mutate-command($/) { make 'dplyr::mutate(' ~ $<assign-pairs-list>.made ~ ')'; }
  method assign-pairs-list($/) { make $<assign-pair>>>.made.join(', '); }
  method assign-pair($/) { make $<assign-pair-lhs>.made ~ ' = ' ~ $<assign-pair-rhs>.made; }
  method assign-pair-lhs($/) { make $/.values[0].made; }
  method assign-pair-rhs($/) { make $/.values[0].made; }

  # Group command
  method group-command($/) { make 'dplyr::group_by(' ~ $<variable-names-list>.made ~ ')'; }

  # Ungroup command
  method ungroup-command($/) { make $/.values[0].made; }
  method ungroup-simple-command($/) { make 'ungroup() %>% as.data.frame(stringsAsFactors=FALSE)'; }

  # Arrange command
  method arrange-command($/) { make $/.values[0].made; }
  method arrange-command-simple($/) { make $<variable-names-list>.made; }
  method arrange-command-ascending($/) { make 'dplyr::arrange(' ~ $<arrange-command-simple>.made ~ ')'; }
  method arrange-command-descending($/) { make 'dplyr::arrange(desc(' ~ $<arrange-command-simple>.made ~ '))'; }

  # Statistics command
  method statistics-command($/) { make $/.values[0].made; }
  method count-command($/) { make 'dplyr::count()'; }
  method summarize-data($/) { make '( function(x) { print(summary(x)); x } )'; }
  method glimpse-data($/) { make 'dplyr::glimpse()'; }
  method summarize-all-command($/) { make 'dplyr::summarise_all(mean)'; }

  # Join command
  method join-command($/) { make $/.values[0].made; }

  method join-by-spec($/) { make 'c(' ~ $/.values[0].made ~ ')'; }

  method full-join-spec($/)  {
    if $<join-by-spec> {
      make 'full_join(' ~ $<dataset-name>.made ~ ', by = ' ~ $<join-by-spec>.made ~ ')';
    } else {
      make 'full_join(' ~ $<dataset-name>.made ~ ')';
    }
  }

  method inner-join-spec($/)  { 
    if $<join-by-spec> {
      make 'inner_join(' ~ $<dataset-name>.made ~ ', by = ' ~ $<join-by-spec>.made ~ ')';
    } else {
      make 'inner_join(' ~ $<dataset-name>.made ~ ')';
    }
  }

  method left-join-spec($/)  {
    if $<join-by-spec> {
      make 'left_join(' ~ $<dataset-name>.made ~ ', by = ' ~ $<join-by-spec>.made ~ ')';
    } else {
      make 'left_join(' ~ $<dataset-name>.made ~ ')';
    }
  }

  method right-join-spec($/)  {
    if $<join-by-spec> {
      make 'right_join(' ~ $<dataset-name>.made ~ ', by = ' ~ $<join-by-spec>.made ~ ')';
    } else {
      make 'right_join(' ~ $<dataset-name>.made ~ ')';
    }
  }

  method semi-join-spec($/)  {
    if $<join-by-spec> {
      make 'semi_join(' ~ $<dataset-name>.made ~ ', by = ' ~ $<join-by-spec>.made ~ ')';
    } else {
      make 'semi_join(' ~ $<dataset-name>.made ~ ')';
    }
  }

  # Cross tabulate command
  method cross-tabulate-command($/) {
    if $<values-variable-name> {
      make '(function(x) as.data.frame(xtabs( formula = ' ~ $<values-variable-name>.made ~ ' ~ ' ~ $<rows-variable-name>.made ~ ' + ' ~ $<columns-variable-name>.made ~ ', data = x ), stringsAsFactors=FALSE ))';
    } else {
      make '(function(x) as.data.frame(xtabs( formula = ~ ' ~ $<rows-variable-name>.made ~ ' + ' ~ $<columns-variable-name>.made ~ ', data = x ), stringsAsFactors=FALSE ))';
    }
  }
  method rows-variable-name($/) { make $<variable-name>.made; }
  method columns-variable-name($/) { make $<variable-name>.made; }
  method values-variable-name($/) { make $<variable-name>.made; }
}
