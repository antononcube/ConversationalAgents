=begin comment
#==============================================================================
#
#   Data Query Workflows WL-System actions in Raku (Perl 6)
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
#   antononcube @ gmai l . c om,
#   Windermere, Florida, USA.
#
#==============================================================================
#
#   For more details about Raku (Perl6) see https://raku.org/ .
#
#==============================================================================
=end comment

use v6;
use DataQueryWorkflows::Grammar;
use DataQueryWorkflows::Actions::WL::Predicate;

unit module DataQueryWorkflows::Actions::WL::System;

class DataQueryWorkflows::Actions::WL::System
        is DataQueryWorkflows::Actions::WL::Predicate {

  method TOP($/) { make $/.values[0].made; }

  # General
  method dataset-name($/) { make $/.Str; }
  method variable-name($/) { make $/.Str; }
  method list-separator($/) { make ','; }
  method variable-names-list($/) { make $<variable-name>>>.made; }
  method quoted-variable-names-list($/) { make $<quoted-variable-name>>>.made.join(', '); }
  method integer-value($/) { make $/.Str; }
  method number-value($/) { make $/.Str; }
  method wl-expr($/) { make $/.Str; }
  method quoted-variable-name($/) {  make $/.values[0].made; }
  method single-quoted-variable-name($/) { make '\"' ~ $<variable-name>.made ~ '\"'; }
  method double-quoted-variable-name($/) { make '\"' ~ $<variable-name>.made ~ '\"'; }

  # Trivial
  method trivial-parameter($/) { make $/.values[0].made; }
  method trivial-parameter-none($/) { make 'None'; }
  method trivial-parameter-empty($/) { make '{}'; }
  method trivial-parameter-automatic($/) { make 'Automatic'; }
  method trivial-parameter-false($/) { make 'False'; }
  method trivial-parameter-true($/) { make 'True'; }

  # Load data
  method data-load-command($/) { make $/.values[0].made; }
  method load-data-table($/) { make 'obj = ExampleData[' ~ $<data-location-spec>.made ~ '];'; }
  method data-location-spec($/) { make '\'' ~ $/.Str ~ '\''; }
  method use-data-table($/) { make 'obj = ' ~ $<variable-name>.made ~ ';'; }

  # Select command
  method select-command($/) {
    make 'obj = Map[ KeyTake[ #, {' ~ map( { '"' ~ $_ ~ '"' }, $<variable-names-list>.made ).join(', ') ~ '} ]&, obj];';
  }

  # Filter commands
  method filter-command($/) { make 'obj = Select[ obj, ' ~ $<filter-spec>.made ~ ' & ];'; }
  method filter-spec($/) { make $<predicates-list>.made; }

  # Mutate command
  method mutate-command($/) { make 'obj = Map[ Join[ #, <|' ~ $<assign-pairs-list>.made ~ '|> ]&, obj]' ; }
  method assign-pairs-list($/) { make $<assign-pair>>>.made.join(', '); }
  method assign-pair($/) { make '"' ~ $<assign-pair-lhs>.made ~ '" -> ' ~ $<assign-pair-rhs>.made; }
  method assign-pair-lhs($/) { make $/.values[0].made; }
  method assign-pair-rhs($/) { make $/.values[0].made; }

  # Group command
  method group-command($/) {
    make 'obj = GroupBy[ obj, {' ~ map( { '#["' ~ $_ ~ '"]' }, $<variable-names-list>.made ).join(', ') ~ '} ]';
  }

  # Ungroup command
  method ungroup-command($/) { make $/.values[0].made; }
  method ungroup-simple-command($/) { make 'obj = Join @@ Values[obj]'; }

  # Arrange command
  method arrange-command($/) { make $/.values[0].made; }
  method arrange-simple-spec($/) { make '{' ~ map( { '#["' ~ $_ ~ '"]' }, $<variable-names-list>.made ).join(', ') ~ '}'; }
  method arrange-command-ascending($/) { make 'obj = SortBy[ obj, ' ~ $<arrange-simple-spec>.made ~ ']'; }
  method arrange-command-descending($/) { make 'obj = ReverseSortBy[ obj, ' ~ $<arrange-simple-spec>.made ~ ']'; }

  # Statistics command
  method statistics-command($/) { make $/.values[0].made; }
  method count-command($/) { make 'obj = Tally[obj]'; }
  method summarize-data($/) { make '( function(x) { print(summary(x)); x } )'; }
  method glimpse-data($/) { make 'dplyr::glimpse()'; }
  method summarize-all-command($/) { make 'dplyr::summarise_all(mean)'; }

  # Join command
  method join-command($/) { make $/.values[0].made; }

  method join-by-spec($/) { make '{' ~ $/.values[0].made ~ '}'; }

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
  method cross-tabulation-command($/) { make $/.values[0].made; }
  method cross-tabulate-command($/) { $<cross-tabulation-formula>.made }
  method contingency-matrix-command($/) { $<cross-tabulation-formula>.made }
  method cross-tabulation-formula($/) {
    if $<values-variable-name> {
      make 'obj = GroupBy[ obj, { #[' ~ $<rows-variable-name>.made ~ '], #[' ~ $<columns-variable-name>.made ~  '] }&, Total[ #[' ~ $<values-variable-name>.made ~ '] & /@ # ]& ]';;
    } else {
      make 'obj = GroupBy[ obj, { #[' ~ $<rows-variable-name>.made ~ '], #[' ~ $<columns-variable-name>.made ~  '] }&, Length ]';
    }
  }
  method rows-variable-name($/) { make '"' ~ $<variable-name>.made ~ '"'; }
  method columns-variable-name($/) { make '"' ~ $<variable-name>.made ~ '"'; }
  method values-variable-name($/) { make '"' ~ $<variable-name>.made ~ '"'; }
}
