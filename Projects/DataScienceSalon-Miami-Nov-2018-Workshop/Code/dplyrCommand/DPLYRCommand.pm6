unit module DPLYRCommand;

role DPLYRCommand::Common-parts {
  rule load-data-directive { 'load' 'data' }
  token create-directive { 'create' | 'make' }
  token compute-directive { 'compute' | 'find' | 'calculate' }
  token display-directive { 'display' | 'show' }
  token using-preposition { 'using' | 'with' | 'over' }
  token by-preposition { 'by' | 'with' | 'using' }
  token for-preposition { 'for' | 'with' }
  token assign { 'assign' | 'set' }
  token a-determiner { 'a' | 'an'}
  token the-determiner { 'the' }
  # True dplyr
  rule data { 'the'? 'data' }
  rule select { 'select' | 'keep' 'only'? }
  token mutate { 'mutate' }
  rule group-by { 'group' ( <by-preposition> | <using-preposition> ) }
  rule arrange { ( 'arrange' | 'order' ) <by-preposition>? }
  token ascending { 'ascending' }
  token descending { 'descending' }
  token variables { 'variable' | 'variables' }
  token list-separator { <.ws>? ',' <.ws>? | <.ws>? '&' <.ws>? }
  token variable-name { [\w | '_' | '.']+ }
  rule variable-names-list { <variable-name>+ % <list-separator> }
  token assign-to-symbol { '=' | ':=' | '<-' }
}

grammar DPLYRCommand::DPLYR-command does Common-parts {
  rule TOP { <load-data> | <select-command> | <mutate-command> | <group-command> | <statistics-command> | <arrange-command> }
  # Load data
  rule load-data { <.load-data-directive> <data-location-spec> }
  rule data-location-spec { .* }
  # Select command
  rule select-command { <select> <.the-determiner>? <.variables>? <variable-names-list> }
  # Mutate command
  rule mutate-command { ( <mutate> | <assign> ) <.by-preposition>? <assign-pairs-list> }
  rule assign-pair { <variable-name> <.assign-to-symbol> <variable-name> }
  rule assign-pairs-list { <assign-pair>+ % <.list-separator> }
  # Group command
  rule group-command { <group-by> <variable-names-list> }
  # Arrange command
  rule arrange-command { <arrange> <variable-names-list> <arrange-direction>? }
  rule arrange-direction { <ascending> | <descending> }
  # Statistics command
  rule statistics-command { <count-command> | <summarize-all-command> }
  rule count-command { <compute-directive> <.the-determiner>? ( 'count' | 'counts' ) }
  rule summarize-all-command { ( 'summarize' | 'summarise' ) 'them'? 'all'? }
}

class DPLYRCommand::DPLYR-command-actions {
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
