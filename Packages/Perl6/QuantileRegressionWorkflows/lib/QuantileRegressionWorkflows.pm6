=begin pod

=head1 QuantileRegressionWorkflows

C<QuantileRegressionWorkflows> package has grammar classes and action classes for the parsing and
interpretation of English natural speech commands that specify Quantile Regression (QR) workflows.

=head1 Synopsis

    use QuantileRegressionWorkflows;
    my $rcode = to_QRMon_R("compute quantile regression with 0.1 amd 0.9; show outliers");

=end pod

unit module QuantileRegressionWorkflows;

use QuantileRegressionWorkflows::Grammar;
use QuantileRegressionWorkflows::Actions::QRMon-Py;
use QuantileRegressionWorkflows::Actions::QRMon-R;
use QuantileRegressionWorkflows::Actions::QRMon-WL;

sub has-semicolon (Str $word) {
    return defined index $word, ';';
}

#-----------------------------------------------------------
proto to_QRMon_Py($) is export {*}

multi to_QRMon_Py ( Str $command where not has-semicolon($command) ) {

  my $match = QuantileRegressionWorkflows::Grammar::WorkflowCommmand.parse($command, actions => QuantileRegressionWorkflows::Actions::QRMon-Py );
  die 'Cannot parse the given command.' unless $match;
  return $match.made;
}

multi to_QRMon_Py ( Str $command where has-semicolon($command) ) {

  my @commandLines = $command.trim.split(/ ';' \s* /);

  @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

  my @smrLines =
  map { to_QRMon_Py($_) }, @commandLines;

  return @smrLines.join("\n");
}

#-----------------------------------------------------------
proto to_QRMon_R($) is export {*}

multi to_QRMon_R ( Str $command where not has-semicolon($command) ) {

  my $match = QuantileRegressionWorkflows::Grammar::WorkflowCommmand.parse($command, actions => QuantileRegressionWorkflows::Actions::QRMon-R );
  die 'Cannot parse the given command.' unless $match;
  return $match.made;
}

multi to_QRMon_R ( Str $command where has-semicolon($command) ) {

  my @commandLines = $command.trim.split(/ ';' \s* /);

  @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

  my @smrLines =
  map { to_QRMon_R($_) }, @commandLines;

  return @smrLines.join(" %>%\n");
}

#-----------------------------------------------------------
proto to_QRMon_WL($) is export {*}

multi to_QRMon_WL ( Str $command where not has-semicolon($command) ) {

  my $match = QuantileRegressionWorkflows::Grammar::WorkflowCommmand.parse($command, actions => QuantileRegressionWorkflows::Actions::QRMon-WL );
  die 'Cannot parse the given command.' unless $match;
  return $match.made;
}

multi to_QRMon_WL ( Str $command where has-semicolon($command) ) {

  my @commandLines = $command.trim.split(/ ';' \s* /);

  @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

  my @smrLines =
  map { to_QRMon_WL($_) }, @commandLines;

  return @smrLines.join(" ==>\n");
}
