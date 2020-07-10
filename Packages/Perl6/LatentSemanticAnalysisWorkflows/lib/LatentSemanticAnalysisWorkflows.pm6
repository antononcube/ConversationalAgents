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
use LatentSemanticAnalysisWorkflows::Actions::Python::LSAMon;
use LatentSemanticAnalysisWorkflows::Actions::R::LSAMon;
use LatentSemanticAnalysisWorkflows::Actions::WL::LSAMon;

my %targetToAction =
    "Python"           => LatentSemanticAnalysisWorkflows::Actions::Python::LSAMon,
    "Python-LSAMon"    => LatentSemanticAnalysisWorkflows::Actions::Python::LSAMon,
    "R"                => LatentSemanticAnalysisWorkflows::Actions::R::LSAMon,
    "R-LSAMon"         => LatentSemanticAnalysisWorkflows::Actions::R::LSAMon,
    "Mathematica"      => LatentSemanticAnalysisWorkflows::Actions::WL::LSAMon,
    "WL"               => LatentSemanticAnalysisWorkflows::Actions::WL::LSAMon,
    "WL-LSAMon"        => LatentSemanticAnalysisWorkflows::Actions::WL::LSAMon;

my %targetToSeparator{Str} =
    "R"                => " %>%\n",
    "R-LSAMon"         => " %>%\n",
    "Mathematica"      => " ==>\n",
    "Python"           => "\n",
    "Python-LSAMon"    => "\n",
    "WL"               => " ==>\n",
    "WL-LSAMon"        => " ==>\n";


#-----------------------------------------------------------
sub has-semicolon (Str $word) {
    return defined index $word, ';';
}

#-----------------------------------------------------------
proto ToLatentSemanticAnalysisWorkflowCode(Str $command, Str $target = "R-LSAMon" ) is export {*}

multi ToLatentSemanticAnalysisWorkflowCode ( Str $command where not has-semicolon($command), Str $target = "R-LSAMon" ) {

    die 'Unknown target.' unless %targetToAction{$target}:exists;

    my $match = LatentSemanticAnalysisWorkflows::Grammar::WorkflowCommand.parse($command, actions => %targetToAction{$target} );
    die 'Cannot parse the given command.' unless $match;
    return $match.made;
}

multi ToLatentSemanticAnalysisWorkflowCode ( Str $command where has-semicolon($command), Str $target = 'R-LSAMon' ) {

    die 'Unknown target.' unless %targetToAction{$target}:exists;

    my @commandLines = $command.trim.split(/ ';' \s* /);

    @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

    my @cmdLines = map { ToLatentSemanticAnalysisWorkflowCode($_, $target) }, @commandLines;

    return @cmdLines.join( %targetToSeparator{$target} ).trim;
}

#-----------------------------------------------------------
proto to_LSAMon_Python($) is export {*}

multi to_LSAMon_Python ( Str $command ) {
    return ToLatentSemanticAnalysisWorkflowCode( $command, 'Python-LSAMon' );
}

#-----------------------------------------------------------
proto to_LSAMon_R($) is export {*}

multi to_LSAMon_R ( Str $command ) {
    return ToLatentSemanticAnalysisWorkflowCode( $command, 'R-LSAMon' );
}

#-----------------------------------------------------------
proto to_LSAMon_WL($) is export {*}

multi to_LSAMon_WL ( Str $command ) {
    return ToLatentSemanticAnalysisWorkflowCode( $command, 'WL-LSAMon' );
}
