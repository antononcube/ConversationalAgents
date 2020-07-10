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
use QuantileRegressionWorkflows::Actions::Python::QRMon;
use QuantileRegressionWorkflows::Actions::R::QRMon;
use QuantileRegressionWorkflows::Actions::WL::QRMon;

my %targetToAction =
    "Python"           => QuantileRegressionWorkflows::Actions::Python::QRMon,
    "Python-QRMon"     => QuantileRegressionWorkflows::Actions::Python::QRMon,
    "R"                => QuantileRegressionWorkflows::Actions::R::QRMon,
    "R-QRMon"          => QuantileRegressionWorkflows::Actions::R::QRMon,
    "Mathematica"      => QuantileRegressionWorkflows::Actions::WL::QRMon,
    "WL"               => QuantileRegressionWorkflows::Actions::WL::QRMon,
    "WL-QRMon"         => QuantileRegressionWorkflows::Actions::WL::QRMon;

my %targetToSeparator{Str} =
    "R"                => " %>%\n",
    "R-QRMon"          => " %>%\n",
    "Mathematica"      => " ==>\n",
    "Python"           => "\n",
    "Python-QRMon"     => "\n",
    "WL"               => " ==>\n",
    "WL-QRMon"         => " ==>\n";


#-----------------------------------------------------------
sub has-semicolon (Str $word) {
    return defined index $word, ';';
}

#-----------------------------------------------------------
proto ToQuantileRegressionWorkflowCode(Str $command, Str $target = "R-QRMon" ) is export {*}

multi ToQuantileRegressionWorkflowCode ( Str $command where not has-semicolon($command), Str $target = "dplyr" ) {

    die 'Unknown target.' unless %targetToAction{$target}:exists;

    my $match = QuantileRegressionWorkflows::Grammar::WorkflowCommand.parse($command, actions => %targetToAction{$target} );
    die 'Cannot parse the given command.' unless $match;
    return $match.made;
}

multi ToQuantileRegressionWorkflowCode ( Str $command where has-semicolon($command), Str $target = 'dplyr' ) {

    die 'Unknown target.' unless %targetToAction{$target}:exists;

    my @commandLines = $command.trim.split(/ ';' \s* /);

    @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

    my @cmdLines = map { ToQuantileRegressionWorkflowCode($_, $target) }, @commandLines;

    return @cmdLines.join( %targetToSeparator{$target} ).trim;
}

#-----------------------------------------------------------
proto to_QRMon_Python($) is export {*}

multi to_QRMon_Python ( Str $command ) {
    return ToQuantileRegressionWorkflowCode( $command, 'Python-QRMon' );
}

#-----------------------------------------------------------
proto to_QRMon_R($) is export {*}

multi to_QRMon_R ( Str $command ) {
    return ToQuantileRegressionWorkflowCode( $command, 'R-QRMon' );
}

#-----------------------------------------------------------
proto to_QRMon_WL($) is export {*}

multi to_QRMon_WL ( Str $command ) {
    return ToQuantileRegressionWorkflowCode( $command, 'WL-QRMon' );
}
