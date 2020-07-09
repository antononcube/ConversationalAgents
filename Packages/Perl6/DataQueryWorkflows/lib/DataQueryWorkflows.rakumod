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
use DataQueryWorkflows::Actions::Julia::DataFrames;
use DataQueryWorkflows::Actions::Python::pandas;
use DataQueryWorkflows::Actions::R::base;
use DataQueryWorkflows::Actions::R::dplyr;
use DataQueryWorkflows::Actions::WL::System;

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
    "Julia"            => DataQueryWorkflows::Actions::Julia::DataFrames,
    "Julia-DataFrames" => DataQueryWorkflows::Actions::Julia::DataFrames,
    "R"                => DataQueryWorkflows::Actions::R::base,
    "R-base"           => DataQueryWorkflows::Actions::R::base,
    "R-dplyr"          => DataQueryWorkflows::Actions::R::dplyr,
    "dplyr"            => DataQueryWorkflows::Actions::R::dplyr,
    "Python-pandas"    => DataQueryWorkflows::Actions::Python::pandas,
    "pandas"           => DataQueryWorkflows::Actions::Python::pandas,
    "Mathematica"      => DataQueryWorkflows::Actions::WL::System,
    "WL"               => DataQueryWorkflows::Actions::WL::System,
    "WL-System"        => DataQueryWorkflows::Actions::WL::System;

my %targetToSeparator{Str} =
    "Julia"            => "\n",
    "Julia-DataFrames" => "\n",
    "R"                => "\n",
    "R-base"           => "\n",
    "R-dplyr"          => " %>%\n",
    "dplyr"            => " %>%\n",
    "Mathematica"      => "\n",
    "Python-pandas"    => ".\n",
    "pandas"           => ".\n",
    "WL"               => "\n",
    "WL-System"        => "\n";


#-----------------------------------------------------------
sub has-semicolon (Str $word) {
    return defined index $word, ';';
}

#-----------------------------------------------------------
proto ToDataQueryCode(Str $command, Str $target = "dplyr" ) is export {*}

multi ToDataQueryCode ( Str $command where not has-semicolon($command), Str $target = "dplyr" ) {

    die 'Unknown target.' unless %targetToAction{$target}:exists;

    my $match = DataQueryWorkflows::Grammar::WorkflowCommad.parse($command, actions => %targetToAction{$target} );
    die 'Cannot parse the given command.' unless $match;
    return $match.made;
}

multi ToDataQueryCode ( Str $command where has-semicolon($command), Str $target = 'dplyr' ) {

    die 'Unknown target.' unless %targetToAction{$target}:exists;

    my @commandLines = $command.trim.split(/ ';' \s* /);

    @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

    my @dqLines = map { ToDataQueryCode($_, $target) }, @commandLines;

    return @dqLines.join( %targetToSeparator{$target} ).trim;
}

#-----------------------------------------------------------
proto to_DataQuery_Julia($) is export {*}

multi to_DataQuery_Julia ( Str $command ) {
    return ToDataQueryCode( $command, 'Julia-DataFrames' );
}

#-----------------------------------------------------------
proto to_DataQuery_dplyr($) is export {*}

multi to_DataQuery_dplyr ( Str $command ) {
    return ToDataQueryCode( $command, 'R-dplyr' );
}

#-----------------------------------------------------------
proto to_DataQuery_pandas($) is export {*}

multi to_DataQuery_pandas ( Str $command ) {
    return ToDataQueryCode( $command, 'Python-pandas' );
}

#-----------------------------------------------------------
proto to_DataQuery_WL(Str $) is export {*}

multi to_DataQuery_WL ( Str $command ) {
    return ToDataQueryCode( $command, 'WL-System' );
}