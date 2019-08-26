=begin pod

=head1 QuantileRegressionWorkflows

C<QuantileRegressionWorkflows> package has grammar classes and action classes for the parsing and
interpretation of English natural speech commands that specify Quantile Regression (QR) workflows.

=head1 Synopsis

    use QuantileRegressionWorkflows;
    my $rcode = to_QRMon_R("compute quantile regression with 0.1 amd 0.9; show outliers");

=end pod

unit module QuantileRegressionWorkflows;

use QuantileRegressionWorkflowsGrammar;
use QRMon-R-actions;
use QRMon-WL-actions;

sub has-semicolon (Str $word) {
    return defined index $word, ';';
}

proto to_QRMon_R($) is export {*}

multi to_QRMon_R ( Str $command where not has-semicolon($command) ) {
  #say QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse($command);
  my $match = QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse($command, actions => QRMon-R-actions::QRMon-R-actions );
  die 'Cannot parse the given command.' unless $match;
  return $match.made;
}

multi to_QRMon_R ( Str $command where has-semicolon($command) ) {

  my @commandLines = $command.split(/ ';' \s* /);

  @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

  my @smrLines =
  map { to_QRMon_R($_) }, @commandLines;

  return @smrLines.join(" %>%\n");
}

proto to_QRMon_WL($) is export {*}

multi to_QRMon_WL ( Str $command where not has-semicolon($command) ) {
  my $match = QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse($command, actions => QRMon-WL-actions::QRMon-WL-actions );
  die 'Cannot parse the given command.' unless $match;
  return $match.made;
}

multi to_QRMon_WL ( Str $command where has-semicolon($command) ) {

  my @commandLines = $command.split(/ ';' \s* /);

  @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

  my @smrLines =
  map { to_QRMon_WL($_) }, @commandLines;

  return @smrLines.join(" ==>\n");
}
