=begin pod

=head1 DataQueryWorkflows

C<DataQueryWorkflows> package has grammar and action classes for the parsing and
interpretation of natural language commands that specify data queries in the style of
Standard Query Language (SQL) or RStudio's library dplyr.

=head1 Synopsis

    use DataQueryWorkflows;
    my $rcode = to_dplyr("select height & mass; arrange by height descending");

=end pod

unit module DataQueryWorkflows;

use DataQueryWorkflows::Grammar;
use DataQueryWorkflows::Actions::R::dplyr;
use DataQueryWorkflows::Actions::R::base;
use DataQueryWorkflows::Actions::Python::pandas;

#-----------------------------------------------------------

#my %targetToAction := {
#    "dplyr"         => DataQueryWorkflows::Actions::R::dplyr,
#    "R-dplyr"       => DataQueryWorkflows::Actions::R::dplyr,
#    "R"             => DataQueryWorkflows::Actions::R::base,
#    "R-base"        => DataQueryWorkflows::Actions::R::base,
#    "pandas"        => DataQueryWorkflows::Actions::Python::pandas,
#    "Python-pandas" => DataQueryWorkflows::Actions::Python::pandas,
#    "WL"            => DataQueryWorkflows::Actions::WL::Dataset,
#    "WL-SQL"        => DataQueryWorkflows::Actions::WL::SQL
#};

my %targetToAction =
    "dplyr"         => DataQueryWorkflows::Actions::R::dplyr,
    "R-dplyr"       => DataQueryWorkflows::Actions::R::dplyr,
    "R"             => DataQueryWorkflows::Actions::R::base,
    "R-base"        => DataQueryWorkflows::Actions::R::base,
    "pandas"        => DataQueryWorkflows::Actions::Python::pandas,
    "Python-pandas" => DataQueryWorkflows::Actions::Python::pandas;

my %targetToSeparator{Str} =
    "dplyr"         => " %>%\n",
    "R-dplyr"       => " %>%\n",
    "R"             => "\n",
    "R-base"        => "\n",
    "pandas"        => ".\n",
    "Python-pandas" => ".\n";


#-----------------------------------------------------------
sub has-semicolon (Str $word) {
    return defined index $word, ';';
}

#-----------------------------------------------------------
proto ToDataQueryCode($, $) is export {*}

multi ToDataQueryCode ( Str $command where not has-semicolon($command), Str $target = "dplyr" ) {

    die 'Unknown target.' unless %targetToAction{$target}:exists;

    my $match = DataQueryWorkflows::Grammar.parse($command, actions => %targetToAction{$target} );
    die 'Cannot parse the given command.' unless $match;
    return $match.made;
}

multi ToDataQueryCode ( Str $command where has-semicolon($command), Str $target = "dplyr" ) {

    die 'Unknown target.' unless %targetToAction{$target}:exists;

    my @commandLines = $command.trim.split(/ ';' \s* /);

    @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

    my @dqLines = map { ToDataQueryCode($_, $target) }, @commandLines;

    return @dqLines.join( %targetToSeparator{$target} );
}

#-----------------------------------------------------------
proto to_dplyr($) is export {*}

multi to_dplyr ( Str $command ) {
    return ToDataQueryCode( $command, 'R-dplyr' );
}

#-----------------------------------------------------------
proto to_pandas($) is export {*}

multi to_pandas ( Str $command ) {
    return ToDataQueryCode( $command, 'Python-pandas' );
}
