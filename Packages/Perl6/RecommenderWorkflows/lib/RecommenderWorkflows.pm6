=begin pod

=head1 RecommenderWorkflows

C<RecommenderWorkflows> package has grammar classes and action classes for the parsing and
interpretation of English natural speech commands that specify recommender workflows.

=head1 Synopsis

    use RecommenderWorkflows;
    my $rcode = to_SMRMon_R("recommend for history r1->1, r2->2, and r3->5; explain the first recommendation");
    my $wlcode = to_SMRMon_WL("recommend for history r1->1, r2->2, and r3->5; explain the first recommendation");

=end pod

unit module RecommenderWorkflows;

use RecommenderWorkflowsGrammar;
use SMRMon-R-actions;
use SMRMon-WL-actions;

sub has-semicolon (Str $word) {
    return defined index $word, ';';
}

proto to_SMRMon_R($) is export {*}

multi to_SMRMon_R ( Str $command where not has-semicolon($command) ) {
  #say DataTransformationWorkflowsGrammar::Spoken-dplyr-command.parse($command);
  my $match = RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse($command, actions => SMRMon-R-actions::SMRMon-R-actions );
  die 'Cannot parse input given command.' unless $match;
  return $match.made;
}

multi to_SMRMon_R ( Str $command where has-semicolon($command) ) {

  my @commandLines = $command.trim.split(/ ';' \s* /);

  @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

  my @smrLines =
  map { to_SMRMon_R($_) }, @commandLines;

  return @smrLines.join(" %>%\n");
}

proto to_SMRMon_WL($) is export {*}

multi to_SMRMon_WL ( Str $command where not has-semicolon($command) ) {
  #say DataTransformationWorkflowsGrammar::Spoken-dplyr-command.parse($command);
  my $match = RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse($command, actions => SMRMon-WL-actions::SMRMon-WL-actions );
  die 'Cannot parse input given command.' unless $match;
  return $match.made;
}

multi to_SMRMon_WL ( Str $command where has-semicolon($command) ) {

  my @commandLines = $command.trim.split(/ ';' \s* /);

  @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

  my @smrLines =
  map { to_SMRMon_WL($_) }, @commandLines;

  return @smrLines.join(" ==>\n");
}
