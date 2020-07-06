=begin comment
#==============================================================================
#
#   Data Query Workflows R-base actions in Raku (Perl 6)
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
use DataQueryWorkflows::Actions::R::Predicate;

unit module DataQueryWorkflows::Actions::R::base;

class DataQueryWorkflows::Actions::R::base
        is DataQueryWorkflows::Actions::R::Predicate {

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
  method single-quoted-variable-name($/) {  make '\"' ~ $<variable-name>.made ~ '\"'; }
  method double-quoted-variable-name($/) {  make '\"' ~ $<variable-name>.made ~ '\"'; }

  # Trivial
  method trivial-parameter($/) { make $/.values[0].made; }
  method trivial-parameter-none($/) { make 'NA'; }
  method trivial-parameter-empty($/) { make 'c()'; }
  method trivial-parameter-automatic($/) { make 'NULL'; }
  method trivial-parameter-false($/) { make 'FALSE'; }
  method trivial-parameter-true($/) { make 'TRUE'; }

  # Load data
  method data-load-command($/) { make $/.values[0].made; }
  method load-data-table($/) { make '{ data(' ~ $<data-location-spec>.made ~ '); obj =' ~ $<data-location-spec>.made ~ ' }'; }
  method data-location-spec($/) { make '\'' ~ $/.Str ~ '\''; }
  method use-data-table($/) { make 'obj <- ' ~ $<variable-name>.made; }

  # Select command
  method select-command($/) { make 'obj <- obj[, ' ~ $<variable-names-list>.made ~ ']'; }

  # Filter commands
  method filter-command($/) { make 'obj <- obj[' ~ $<filter-spec>.made ~ ', ]'; }
  method filter-spec($/) { make $<predicates-list>.made; }

  # Mutate command
  method mutate-command($/) { make 'dplyr::mutate(' ~ $<assign-pairs-list>.made ~ ')'; }
  method assign-pairs-list($/) { make $<assign-pair>>>.made.join(', '); }
  method assign-pair($/) { make $<assign-pair-lhs>.made ~ ' = ' ~ $<assign-pair-rhs>.made; }
  method assign-pair-lhs($/) { make $/.values[0].made; }
  method assign-pair-rhs($/) { make $/.values[0].made; }

  # Group command
  method group-command($/) { make 'obj <- by( data = obj, ' ~ $<variable-names-list>.made ~ ')'; }

  # Ungroup command
  method ungroup-command($/) { make $/.values[0].made; }
  method ungroup-simple-command($/) { make 'obj <- as.data.frame(ungroup(obj),stringsAsFactors=FALSE)'; }

  # Arrange command
  method arrange-command($/) { make $/.values[0].made; }
  method arrange-command-simple($/) { make $<variable-names-list>.made; }
  method arrange-command-ascending($/) { make 'obj <- obj[ order(' ~ $<arrange-command-simple>.made ~ '), ]'; }
  method arrange-command-descending($/) { make 'obj <- obj[ rev(order(' ~ $<arrange-command-simple>.made ~ ')), ]'; }

  # Statistics command
  method statistics-command($/) { make $/.values[0].made; }
  method count-command($/) { make 'dplyr::count()'; }
  method summarize-data($/) { make 'print(summary(obj))'; }
  method glimpse-data($/) { make 'head(obj)'; }
  method summarize-all-command($/) { make 'summary(obj)'; }

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
      make 'obj <- merge( x = obj, y = ' ~ $<dataset-name>.made ~ ', by = ' ~ $<join-by-spec>.made ~ ')';
    } else {
      make 'obj <- merge( x = obj, y = ' ~ $<dataset-name>.made ~ ')';
    }
  }

  method left-join-spec($/)  {
    if $<join-by-spec> {
      make 'obj <- merge( x = obj, y = ' ~ $<dataset-name>.made ~ ', by = ' ~ $<join-by-spec>.made ~ ', all.x = TRUE )';
    } else {
      make 'obj <- merge( x = obj, y = ' ~ $<dataset-name>.made ~ ', , all.x = TRUE )';
    }
  }

  method right-join-spec($/)  {
    if $<join-by-spec> {
      make 'obj <- merge( x = obj, y = ' ~ $<dataset-name>.made ~ ', by = ' ~ $<join-by-spec>.made ~ ', all.y = TRUE )';
    } else {
      make 'obj <- merge( x = obj, y = ' ~ $<dataset-name>.made ~ ', , all.y = TRUE )';
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
      make 'obj <- xtabs( formula = ' ~ $<values-variable-name>.made ~ ' ~ ' ~ $<rows-variable-name>.made ~ ' + ' ~ $<columns-variable-name>.made ~ ', data = x )';
    } else {
      make 'obj <- xtabs( formula = ~ ' ~ $<rows-variable-name>.made ~ ' + ' ~ $<columns-variable-name>.made ~ ', data = x )';
    }
  }
  method rows-variable-name($/) { make $<variable-name>.made; }
  method columns-variable-name($/) { make $<variable-name>.made; }
  method values-variable-name($/) { make $<variable-name>.made; }
}
