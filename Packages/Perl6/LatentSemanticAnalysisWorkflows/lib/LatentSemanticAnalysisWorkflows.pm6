=begin pod

=head1 LatentSemanticAnalysisWorkflows

C<LatentSemanticAnalysisWorkflows> package has grammar classes and action classes for the parsing and
interpretation of English natural speech commands that specify Latent Semantic Analysis (LSA) workflows.

=head1 Synopsis

    use LatentSemanticAnalysisWorkflows;
    my $rcode = to_LSAMon_R("make the document term matrix");

=end pod

unit module LatentSemanticAnalysisWorkflows;

use LatentSemanticAnalysisWorkflowsGrammar;
use LSAMon-R-actions;
use LSAMon-WL-actions;

sub has-semicolon (Str $word) {
    return defined index $word, ';';
}

proto to_LSAMon_R($) is export {*}

multi to_LSAMon_R ( Str $command where not has-semicolon($command) ) {
  #say LatentSemanticAnalysisWorkflowsGrammar::Latent-semantic-analysis-commmand.parse($command);
  my $match = LatentSemanticAnalysisWorkflowsGrammar::Latent-semantic-analysis-workflow-commmand.parse($command, actions => LSAMon-R-actions::LSAMon-R-actions );
  die 'Cannot parse the given command.' unless $match;
  return $match.made;
}

multi to_LSAMon_R ( Str $command where has-semicolon($command) ) {

  my @commandLines = $command.trim.split(/ ';' \s* /);

  @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

  my @smrLines =
  map { to_LSAMon_R($_) }, @commandLines;

  return @smrLines.join(" %>%\n");
}

proto to_LSAMon_WL($) is export {*}

multi to_LSAMon_WL ( Str $command where not has-semicolon($command) ) {
  my $match = LatentSemanticAnalysisWorkflowsGrammar::Latent-semantic-analysis-commmand.parse($command, actions => LSAMon-WL-actions::LSAMon-WL-actions );
  die 'Cannot parse the given command.' unless $match;
  return $match.made;
}

multi to_LSAMon_WL ( Str $command where has-semicolon($command) ) {

  my @commandLines = $command.trim.split(/ ';' \s* /);

  @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

  my @smrLines =
  map { to_LSAMon_WL($_) }, @commandLines;

  return @smrLines.join(" ==>\n");
}
