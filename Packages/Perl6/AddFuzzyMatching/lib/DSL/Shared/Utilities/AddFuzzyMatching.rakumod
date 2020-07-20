
=begin pod

=head1 AddFuzzMatching

C<AddFuzzMatching> package has grammar classes and action classes for the parsing
Raku Perl 6 grammar files and making a file with token grammar rules that are
extented to have fuzzy matching function calls.

=head1 Synopsis

    use AddFuzzMatching;
    makeModifiedGrammarFile( $file1 $fromMonPrefix $toMonPrefix );

=end pod

unit module DSL::Shared::Utilities::AddFuzzyMatching;

use DSL::Shared::Utilities::AddFuzzyMatching::Grammar;
use DSL::Shared::Utilities::AddFuzzyMatching::Actions;

##===========================================================
## The function
##===========================================================

sub addFuzzyMatch( Str $fileName ) is export {

  my $program = slurp($fileName);

  # my $newProgram = AddFuzzyMatching::Grammar.parse($program, actions => AddFuzzyMatching::Actions.new );
  #
  # unless $newProgram {
  #   die "Cannot parse the provided file."
  # }
  #
  # $newProgram = $newProgram.made;

  my @lines = $program.split( "\n");

  my @parseRes = map( { DSL::Shared::Utilities::AddFuzzyMatching::Grammar.parse( $_ ~ "\n", actions => DSL::Shared::Utilities::AddFuzzyMatching::Actions.new ).made },  @lines );

  my $newProgram = @parseRes.join();

  my $newFileName = $fileName ~ "-fuzzy-matching.rakumod";

  spurt $newFileName, $newProgram;

  say "The fuzzy matching file name is:\"", $newFileName ~ "\"";
}
