=begin pod

=head1 LatentSemanticAnalysisWorkflows

C<LatentSemanticAnalysisWorkflows> package has grammar classes and action classes for the parsing and
interpretation of English natural speech commands that specify Latent Semantic Analysis (LSA) workflows.

=head1 Synopsis

    use LatentSemanticAnalysisWorkflows;
    my $rcode = to_LSAMon_R("make the document term matrix");

=end pod

unit module LatentSemanticAnalysisWorkflows;

use LatentSemanticAnalysisWorkflows::Grammar;
use LatentSemanticAnalysisWorkflows::Actions::LSAMon-Py;
use LatentSemanticAnalysisWorkflows::Actions::LSAMon-R;
use LatentSemanticAnalysisWorkflows::Actions::LSAMon-WL;


sub has-semicolon (Str $word) {
    return defined index $word, ';';
}

#-----------------------------------------------------------
proto to_LSAMon_Py($) is export {*}

multi to_LSAMon_Py ( Str $command where not has-semicolon($command) ) {

  my $match = LatentSemanticAnalysisWorkflows::Grammar::WorkflowCommmand.parse($command, actions => LatentSemanticAnalysisWorkflows::Actions::LSAMon-Py );
  die 'Cannot parse the given command.' unless $match;
  return $match.made;
}

multi to_LSAMon_Py ( Str $command where has-semicolon($command) ) {

  my @commandLines = $command.trim.split(/ ';' \s* /);

  @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

  my @smrLines =
  map { to_LSAMon_Py($_) }, @commandLines;

  return @smrLines.join(";\n");
}

#-----------------------------------------------------------
proto to_LSAMon_R($) is export {*}

multi to_LSAMon_R ( Str $command where not has-semicolon($command) ) {
  #say LatentSemanticAnalysisWorkflowsGrammar::Latent-semantic-analysis-commmand.parse($command);
  my $match = LatentSemanticAnalysisWorkflows::Grammar::WorkflowCommmand.parse($command, actions => LatentSemanticAnalysisWorkflows::Actions::LSAMon-R );
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

#-----------------------------------------------------------
proto to_LSAMon_WL($) is export {*}

multi to_LSAMon_WL ( Str $command where not has-semicolon($command) ) {
  my $match = LatentSemanticAnalysisWorkflows::Grammar::WorkflowCommmand.parse($command, actions => LatentSemanticAnalysisWorkflows::Actions::LSAMon-WL );
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
