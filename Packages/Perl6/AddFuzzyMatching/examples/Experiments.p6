use v6;

#use lib './lib';
#use lib '.';

use DSL::Shared::Utilities::AddFuzzyMatching;

##===========================================================
## Experiments
##===========================================================
#
my $packageDir = "./corpus/";

addFuzzyMatch( $packageDir ~ "/testFile-template" );

##===========================================================
## Data
##===========================================================

my $rfile0 = q:to/EOI/;
role Simple {

  token recommend { 'recommend' }
  token nearest-neighbors { 'nearest' 'neighbours' }
  rule recommend-nns { <recommend> <nearest-neighbors> }

}
EOI

# say $rfile0;

my $rfile1 = q:to/EOI/;
# Simple grammar role.

role Simple::Role {

  token history { 'history'  }
  token recommend { 'recommend' | 'suggest' }
  token with-preposition { 'with' | 'using' | 'by' }
  token nearest-neighbors { 'nearest' 'neighbours' }
  token items-slot:sym<items> { 'items' }
  rule recommend-nns { <recommend> <nearest-neighbors> }

}
EOI



##===========================================================
## Experiments
##===========================================================

# say AddFuzzyMatching::Grammar.parse( "token rec \{ 'rec' \} \n", rule => <token-rule-definition> );

# my $parseRes = AddFuzzyMatching::Grammar.parse($rfile1);
# say $parseRes;


# my $parseRes = AddFuzzyMatching::Grammar.parse($rfile0, actions => AddFuzzyMatching::Actions.new ).made;
#
# say $parseRes;

# say $rfile0.split('\n') ;

# my @lines = $rfile1.split( "\n");
#
# my @parseRes = map( { say "here:", $_, "\n"; AddFuzzyMatching::Grammar.parse( $_ ~ "\n", actions => AddFuzzyMatching::Actions.new ).made },  @lines );
# #
#
# say "\n=========\n";
# say @parseRes.join();
