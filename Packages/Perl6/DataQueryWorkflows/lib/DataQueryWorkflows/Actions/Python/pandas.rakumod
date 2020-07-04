=begin comment
#==============================================================================
#
#   pandas actions in Raku (Perl 6)
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

unit module DataQueryWorkflows::Actions::Python::pandas;

class DataQueryWorkflows::Actions::Python::pandas {

  method TOP($/) { make $/.values[0].made; }

  # General
  method dataset-name($/) { make $/.values[0].made; }
  method variable-name($/) { make $/.Str; }
  method list-separator($/) { make ','; }
  method variable-names-list($/) { make $<variable-name>>>.made.join(', '); }
  method integer-value($/) { make $/.Str; }
  method number-value($/) { make $/.Str; }
  method wl-expr($/) { make $/.Str; }

  # Trivial
  method trivial-parameter($/) { make $/.values[0].made; }
  method trivial-parameter-none($/) { make 'None'; }
  method trivial-parameter-empty($/) { make '[]'; }
  method trivial-parameter-automatic($/) { make 'None'; }
  method trivial-parameter-false($/) { make 'false'; }
  method trivial-parameter-true($/) { make 'true'; }

  # Load data
  method data-load-command($/) { make $/.values[0].made; }
  method load-data-table($/) { make 'data(' ~ $<data-location-spec>.made ~ ')'; }
  method data-location-spec($/) { make '\'' ~ $/.Str ~ '\''; }
  method use-data-table($/) { make $<variable-name>.made; }

  # Select command
  method select-command($/) { make 'select(' ~ $<variable-names-list>.made ~ ')'; }

  # Filter commands
  method filter-command($/) { make 'filter(' ~ $<filter-spec> ~ ')'; }
  method filter-spec($/) { make $<predicates-list>.made; }
  method predicate($/) { make $/>>.made.join(' '); }
  method predicate-symbol($/) { make $/.Str; }
  method predicate-value($/) { make $/.values[0].made; }

  # Mutate command
  method mutate-command($/) { make 'mutate(' ~ $<assign-pairs-list>.made ~ ')'; }
  method assign-pairs-list($/) { make $<assign-pair>>>.made.join(', '); }
  method assign-pair($/) { make $<variable-name>.made ~ ' = ' ~ $<assign-pair-rhs>.made; }
  method assign-pair-rhs($/) { make $/.values[0].made; }

  # Group command
  method group-command($/) { make 'group_by(' ~ $<variable-names-list>.made ~ ')'; }

  # Arrange command
  method arrange-command($/) { make $/.values[0].made; }
  method arrange-command-simple($/) { make $<variable-names-list>.made; }
  method arrange-command-ascending($/) { make 'arrange(' ~ $<arrange-command-simple>.made ~ ')'; }
  method arrange-command-descending($/) { make 'arrange(desc(' ~ $<arrange-command-simple>.made ~ '))'; }

  # Statistics command
  method statistics-command($/) { make $/.values[0].made; }
  method count-command($/) { make 'count()'; }
  method summarize-data($/) { make 'summary()'; }
  method glimpse-data($/) { make 'glimpse()'; }
  method summarize-all-command($/) { make 'summarise_all(mean)'; }
}
