=begin pod

=head1 SpokenDataTransformations

C<SpokenDataTransformations> package has grammar classes and action classes for the parsing and
interpretation of spoken command that specify data transformations as described and
implemented in the R/RStudio library [dplyr](https://dplyr.tidyverse.org).

=head1 Synopsis

    use SpokenDataTransformations;
    my $rcode = to-dplyr("select height & mass; arrange by height descending");

=end pod

unit module SpokenDataTransformations;

use DataTransformationWorkflowsGrammar;
use Spoken-dplyr-actions;

sub has-semicolon (Str $word) {
    return defined index $word, ";";
}

proto to-dplyr($) is export {*}

multi to-dplyr ( Str $command where not has-semicolon($command) ) {
  #say DataTransformationWorkflowsGrammar::Spoken-dplyr-command.parse($command);
  my $match = DataTransformationWorkflowGrammar::Spoken-dplyr-command.parse($command, actions => Spoken-dplyr-actions::Spoken-dplyr-actions );
  die "Cannot parse input given command." unless $match;
  return $match.made;
}

multi to-dplyr ( Str $command where has-semicolon($command) ) {

  my @commandLines = $command.split(/ ';' \s* /); say map { "'" ~ $_ ~ "'" }, @commandLines;

  my @dplyrLines =
  map { to-dplyr($_) }, @commandLines;

  return @dplyrLines.join(" %>% ");
}
