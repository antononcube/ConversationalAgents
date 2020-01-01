=begin pod

=head1 NeuralNetworkWorkflows

C<NeuralNetworkWorkflows> package has grammar classes and action classes for the parsing and
interpretation of English natural speech commands that specify Neural network workflows.

=head1 Synopsis

    use NeuralNetworkWorkflows;
    my $rcode = to_NetMon_R("chain using the reshape layer");

=end pod

unit module NeuralNetworkWorkflows;

use NeuralNetworkWorkflows::Grammar;
use NeuralNetworkWorkflows::Actions::NetMon-Py;
use NeuralNetworkWorkflows::Actions::NetMon-R;
use NeuralNetworkWorkflows::Actions::NetMon-WL;


sub has-semicolon (Str $word) {
    return defined index $word, ';';
}

#-----------------------------------------------------------
proto to_NetMon_Py($) is export {*}

multi to_NetMon_Py ( Str $command where not has-semicolon($command) ) {

  my $match = NeuralNetworkWorkflows::Grammar::WorkflowCommmand.parse($command, actions => NeuralNetworkWorkflows::Actions::NetMon-Py );
  die 'Cannot parse the given command.' unless $match;
  return $match.made;
}

multi to_NetMon_Py ( Str $command where has-semicolon($command) ) {

  my @commandLines = $command.trim.split(/ ';' \s* /);

  @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

  my @smrLines =
  map { to_NetMon_Py($_) }, @commandLines;

  return @smrLines.join(";\n");
}

#-----------------------------------------------------------
proto to_NetMon_R($) is export {*}

multi to_NetMon_R ( Str $command where not has-semicolon($command) ) {
  #say LatentSemanticAnalysisWorkflowsGrammar::Latent-semantic-analysis-commmand.parse($command);
  my $match = NeuralNetworkWorkflows::Grammar::WorkflowCommmand.parse($command, actions => NeuralNetworkWorkflows::Actions::NetMon-R );
  die 'Cannot parse the given command.' unless $match;
  return $match.made;
}

multi to_NetMon_R ( Str $command where has-semicolon($command) ) {

  my @commandLines = $command.trim.split(/ ';' \s* /);

  @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

  my @smrLines =
  map { to_NetMon_R($_) }, @commandLines;

  return @smrLines.join(" %>%\n");
}

#-----------------------------------------------------------
proto to_NetMon_WL($) is export {*}

multi to_NetMon_WL ( Str $command where not has-semicolon($command) ) {
  my $match = NeuralNetworkWorkflows::Grammar::WorkflowCommmand.parse($command, actions => NeuralNetworkWorkflows::Actions::NetMon-WL );
  die 'Cannot parse the given command.' unless $match;
  return $match.made;
}

multi to_NetMon_WL ( Str $command where has-semicolon($command) ) {

  my @commandLines = $command.trim.split(/ ';' \s* /);

  @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

  my @smrLines =
  map { to_NetMon_WL($_) }, @commandLines;

  return @smrLines.join(" ==>\n");
}
