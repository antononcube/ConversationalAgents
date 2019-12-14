use v6;

unit module RecommenderWorkflows::Grammar::FuzzyMatch;

# All edits that are one edit from `word`
sub edits1(Str $word) {
    my @letters = 'a'..'z';
    my @splits = (|($word.substr(0..$_-1), $word.substr($_)) for 0..$word.chars);
    my @deletes = do for @splits -> $L, $R { if $R {$L ~ $R.substr(1)} };
    my @transposes = do for @splits -> $L, $R { if $R.chars > 1 {$L ~ $R.substr(1,1) ~ $R.substr(0,0) ~ $R.substr(2)}}
    my @replaces = do for @splits -> $L, $R {@letters.map: {$L~$_~$R.substr(1)} if $R}
    my @inserts = do for @splits -> $L, $R {@letters.map: {$L ~ $_ ~ $R}}
    return (gather (@deletes, @transposes, @replaces, @inserts).deepmap: *.take).unique;
}

# All edits that are two edits from `word`
sub edits2(Str $word) {
    return ( for edits1($word) -> $e1 { $_ for edits1($e1) } )
}

# Generate possible spelling corrections for word
sub candidates(Str $word) {
    if $word.chars < 5 {
        edits1($word) || ($word,);
    } else {
        edits1($word) || edits2($word) || ($word,);
    }
}

proto is-fuzzy-match( $c, $a ) is export {*};

multi is-fuzzy-match( Str $candidate, Str $actual ) {
    if  candidates($actual).contains($candidate) {
        say "Possible misspelling of '$actual' as '$candidate'.";
        return True;
    }
    return False;
}