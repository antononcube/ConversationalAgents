=begin pod

=head1 DataTransformationWorkflows

C<DataTransformationWorkflows> package has grammar classes and action classes for the parsing and
interpretation of English natural speech commands that specify SQL-like data transformation workflows.

=head1 Synopsis

    use DataTransformationWorkflows;
    my $rcode = to_dplyr("use mcars; summarize data; group by cyl; summarize mpg with mean");

=end pod

unit module DataTransformationWorkflows;

use DataTransformationWorkflowsGrammar;
use dplyr-R-actions;
use Dataset-WL-actions;

sub has-semicolon (Str $word) {
    return defined index $word, ';';
}

proto to_dplyr($) is export {*}

multi to_dplyr ( Str $command where not has-semicolon($command) ) {
  #say DataTransformationWorkflowsGrammar::Data-transformation-workflow-commmand.parse($command);
  my $match = DataTransformationWorkflowsGrammar::Data-transformation-workflow-commmand.parse($command, actions => dplyr-actions::dplyr-actions );
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

proto to_Dataset_Query($) is export {*}

multi to_Dataset_Query ( Str $command where not has-semicolon($command) ) {
  my $match = DataTransformationWorkflowsGrammar::Data-transformation-workflow-commmand.parse($command, actions => Dataset-query-actions::Dataset-query-actions );
  die 'Cannot parse the given command.' unless $match;
  return $match.made;
}

multi to_Dataset_Query ( Str $command where has-semicolon($command) ) {

  my @commandLines = $command.trim.split(/ ';' \s* /);

  @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

  my @smrLines =
  map { to_Dataset_Query($_) }, @commandLines;

  return @smrLines.join(" ==>\n");
}
