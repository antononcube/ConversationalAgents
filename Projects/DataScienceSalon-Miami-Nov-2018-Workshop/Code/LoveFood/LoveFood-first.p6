use v6;

# This grammar is the same as the grammar in this Mathematica Stackexchange answer:
# https://mathematica.stackexchange.com/a/110129/34008 .

grammar LoveFood {
  rule TOP { <subject> <loveverb> <object-spec> }
  rule loveverb { 'love' | 'crave' | 'demand' | 'want' }
  rule object-spec { <object-list> | <object> | <objects> | <objects-mult> }
  rule subject { 'i' | 'we' | 'you' }
  rule object { 'sushi' | 'a'? 'chocolate' | 'milk' | 'an'? 'ice' 'cream' | 'a'? 'tangerine' }
  rule objects { 'sushi' | 'chocolates' | 'milks' | 'ice' 'creams' | 'ice-creams' | 'tangerines' }
  rule objects-mult { <integer> <objects> }
  rule object-list { ( <object> | <objects> | <objects-mult> )* % <.and> }
  token and { 'and' }
  token integer { \d+ }
}

say "\n==================";
my $match = LoveFood.parse(lc("I demand 2 ice creams"));
say $match;

say "\n==================";
$match = LoveFood.parse(lc("We want 2 chocolates and a tangerine"));
say $match;
