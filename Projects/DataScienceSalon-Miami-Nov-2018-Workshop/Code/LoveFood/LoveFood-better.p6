use v6;

# This grammar is the same as the grammar in this Mathematica Stackexchange answer:
# https://mathematica.stackexchange.com/a/110129/34008 .

role CommonTokens {
  token and { 'and' }
  token integer { \d+ }
}

grammar LoveFood does CommonTokens {
  rule TOP { <subject> <loveverb> <object-spec> }
  rule subject { 'i' | 'we' | 'you' }
  rule loveverb { 'love' | 'crave' | 'demand' | 'want' }
  rule object-spec { <object-list> | <object-list-elem> }
  rule object-list-elem { <object> | <objects> | <objects-mult> }
  rule object-list { <object-list-elem>+ % <.and> }
  rule object { 'sushi' | 'a'? 'chocolate' | 'milk' | 'an'? 'ice' 'cream' | 'a'? 'tangerine' }
  rule objects { 'sushi' | 'chocolates' | 'milks' | 'ice' 'creams' | 'ice-creams' | 'tangerines' }
  rule objects-mult { <integer> <objects> }
}

class LoveFood-actions {
  method TOP($/) { make "you gain " ~ $<object-spec>.made ~ " calories."; }
  method subject($/) { make $/; }
  method loveverb($/) { make $/; }
  method object-spec($/) { make $/.values[0].made; }
  method objects-mult($/) { make $<integer>.made * $<objects>.made; }
  method object($/) { make (10..30).rand.round; }
  method objects($/) { make (10..30).rand.round; }
  method integer($/) { make $/.Int; }
  method object-list($/) { make [+] $<object-list-elem>>>.made; }
  method object-list-elem($/) { make $/.values[0].made; }
}

# say "\n==================";
# my $match = LoveFood.parse(lc("I demand 2 ice creams"));
# say $match;

say "\n==================";
my $match = LoveFood.parse(lc("I demand 2 ice creams"), actions => LoveFood-actions);
say $match.made;

say "\n==================";
$match = LoveFood.parse(lc("we want 30 chocolates and 2 ice creams"), actions => LoveFood-actions);
say $match.made;

# say "\n==================";
# $match = LoveFood.parse(lc("We want 2 chocolates and a tangerine"));
# say $match;
