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

use RecommenderWorkflows::Grammar;
use RecommenderWorkflows::Actions::Python::SMRMon;
use RecommenderWorkflows::Actions::R::SMRMon;
use RecommenderWorkflows::Actions::WL::SMRMon;

my %targetToAction =
    "Python"           => RecommenderWorkflows::Actions::Python::SMRMon,
    "Python-SMRMon"    => RecommenderWorkflows::Actions::Python::SMRMon,
    "R"                => RecommenderWorkflows::Actions::R::SMRMon,
    "R-SMRMon"         => RecommenderWorkflows::Actions::R::SMRMon,
    "Mathematica"      => RecommenderWorkflows::Actions::WL::SMRMon,
    "WL"               => RecommenderWorkflows::Actions::WL::SMRMon,
    "WL-SMRMon"        => RecommenderWorkflows::Actions::WL::SMRMon;

my %targetToSeparator{Str} =
    "R"                => " %>%\n",
    "R-SMRMon"         => " %>%\n",
    "Mathematica"      => " ==>\n",
    "Python"           => "\n",
    "Python-SMRMon"    => "\n",
    "WL"               => " ==>\n",
    "WL-SMRMon"        => " ==>\n";


#-----------------------------------------------------------
sub has-semicolon (Str $word) {
    return defined index $word, ';';
}

#-----------------------------------------------------------
proto ToRecommenderWorkflowCode(Str $command, Str $target = "R-SMRMon" ) is export {*}

multi ToRecommenderWorkflowCode ( Str $command where not has-semicolon($command), Str $target = "R-SMRMon" ) {

    die 'Unknown target.' unless %targetToAction{$target}:exists;

    my $match = RecommenderWorkflows::Grammar::WorkflowCommand.parse($command, actions => %targetToAction{$target} );
    die 'Cannot parse the given command.' unless $match;
    return $match.made;
}

multi ToRecommenderWorkflowCode ( Str $command where has-semicolon($command), Str $target = 'R-SMRMon' ) {

    die 'Unknown target.' unless %targetToAction{$target}:exists;

    my @commandLines = $command.trim.split(/ ';' \s* /);

    @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

    my @cmdLines = map { ToRecommenderWorkflowCode($_, $target) }, @commandLines;

    return @cmdLines.join( %targetToSeparator{$target} ).trim;
}

#-----------------------------------------------------------
proto to_SMRMon_Python($) is export {*}

multi to_SMRMon_Python ( Str $command ) {
    return ToRecommenderWorkflowCode( $command, 'Python-SMRMon' );
}

#-----------------------------------------------------------
proto to_SMRMon_R($) is export {*}

multi to_SMRMon_R ( Str $command ) {
    return ToRecommenderWorkflowCode( $command, 'R-SMRMon' );
}

#-----------------------------------------------------------
proto to_SMRMon_WL($) is export {*}

multi to_SMRMon_WL ( Str $command ) {
    return ToRecommenderWorkflowCode( $command, 'WL-SMRMon' );
}
