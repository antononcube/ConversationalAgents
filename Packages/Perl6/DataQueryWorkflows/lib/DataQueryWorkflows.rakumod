=begin pod

=head1 DataQueryWorkflows

C<DataQueryWorkflows> package has grammar and action classes for the parsing and
interpretation of natural language commands that specify data queries in the style of
Standard Query Language (SQL) or RStudio's library dplyr.

=head1 Synopsis

    use DataQueryWorkflows;
    my $rcode = to_dplyr("select height & mass; arrange by height descending");

=end pod

unit module DataQueryWorkflows;

use DataQueryWorkflows::Grammar;
use DataQueryWorkflows::Actions::dplyr;

sub has-semicolon (Str $word) {
    return defined index $word, ';';
}

#-----------------------------------------------------------
proto to_dplyr($) is export {*}

multi to_dplyr ( Str $command where not has-semicolon($command) ) {

  my $match = DataQueryWorkflows::Grammar.parse($command, actions => DataQueryWorkflows::Actions::dplyr );
  die 'Cannot parse the given command.' unless $match;
  return $match.made;
}

multi to_dplyr ( Str $command where has-semicolon($command) ) {

  my @commandLines = $command.trim.split(/ ';' \s* /);

  @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

  my @smrLines =
  map { to_dplyr($_) }, @commandLines;

  return @smrLines.join(" %>%\n");
}

