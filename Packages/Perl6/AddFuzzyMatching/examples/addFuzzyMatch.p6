#!/usr/bin/env perl6
use DSL::Shared::Utilities::AddFuzzyMatching;

sub MAIN( Str $filename ) {
    say addFuzzyMatch( $filename );
}
