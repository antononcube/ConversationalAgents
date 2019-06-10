(* Food-love example *)

(* Below is the code from: https://mathematica.stackexchange.com/a/110129/34008 .*)
(* Note that WolframAlpha is prevented from evaluation in order LoveObjectsCalories,
   in order the evaluation results faster. *)

(*
Load the package:
*)

Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/FunctionalParsers.m"]

(*
Give an EBNF description of a DSL for food cravings:
*)

ebnfCode = "
  <lovefood> = <subject> , <loveverb> , <object-spec> <@ LoveFood[Flatten[#]]& ;
  <loveverb> = ( 'love' | 'crave' | 'demand' ) <@ LoveType ;
  <object-spec> = ( <object-list> | <object> | <objects> | <objects-mult> ) <@ LoveObjects[Flatten[{#}]]& ;
  <subject> = 'i' | 'we' | 'you' <@ Who ;
  <object> = 'sushi' | [ 'a' ] , 'chocolate' | 'milk' | [ 'an' , 'ice' ] , 'cream' | 'a' , 'tangerine' ;
  <objects> = 'sushi' | 'chocolates' | 'milks' | 'ice' , 'creams' | 'ice-creams' | 'tangerines' ;
  <objects-mult> = 'Range[2,100]' , <objects> <@ Mult ;
  <object-list> = ( <object> | <objects> | <objects-mult> ) , { 'and' &> ( <object> | <objects> | <objects-mult> ) } ; ";


(*
Generate parsers from the EBNF string:
*)

GenerateParsersFromEBNF[ParseToTokens@ebnfCode];

(*
Test the parser pLOVEFOOD for the highest level rule <lovefood> with a list of sentences:
*)

sentences = {"I love milk", "We demand 2 ice creams",
  "I crave 2 ice creams and 5 chocolates",
  "You crave chocolate and milk"};
ParsingTestTable[pLOVEFOOD, ToLowerCase@sentences, "Layout" -> "Vertical"]

(*
Generate random sentences from the grammar:
*)

GrammarRandomSentences[GrammarNormalize[ebnfCode], 12]

(* {"i love milks", "we demand 75 ice creams", "you crave milks", "we crave 67 sushi",
     "you demand cream and cream and 89 ice creams and chocolate and 89 milks and 89 tangerines",
     "we crave tangerines", "you crave ice-creams and ice-creams and 23 ice-creams",
     "i demand tangerines and ice creams and a tangerine and 40 ice-creams and a tangerine and 40 milks",
     "i crave 47 chocolates", "we love 13 ice-creams", "you demand tangerines",
     "you demand a tangerine"} *)

(*
Note the EBNF rule wrappers -- those are symbols specified at the ends of some of the rules.
Next we implement interpreters. I am using WolframAlpha to get the calories.
I gave up figuring out how to use EntityValue["Food",___], etc.
(Since using WolframAlpha is slow it can be overridden inside Block.)
*)

Clear[LoveObjectsCalories]
LoveObjectsCalories[parsed_] :=
    Block[{res, wares, WolframAlpha={}&},
      res = (StringJoin @@
          Flatten[Riffle[parsed, " and "] /.
              Mult[{x_, y_}] :> (StringJoin @@ Riffle[Flatten[{ToString[x], y}], " "])]);
      wares = WolframAlpha[res <> " calories", "DataRules", TimeConstraint -> 60];
      {{"Result", 1}, "ComputableData"} /.
          wares /. {{"Result", 1}, "ComputableData"} ->
          Quantity[RandomInteger[{20, 1200}], "LargeCalories"]
    ];

Clear[LoveFoodCalories]
LoveFoodCalories[parsed_] :=
    Block[{who, type},
      who = Cases[parsed, Who[id_] :> id, \[Infinity]][[1]];
      type = Cases[parsed, LoveType[id_] :> id, \[Infinity]][[1]];
      Which[
        who == "you", Row[{"No, I do not. I am a machine."}],
        type == "love", Row[{"you gain ", Sqrt[1*10.] parsed[[-1]], " per day"}],
        True, Row[{"you will gain ", parsed[[-1]]}]]
    ];

(*
Here the parsing tests are done by changing the definitions of the wrapping symbols LoveFood and LoveObjects:
*)

Block[{LoveFood = LoveFoodCalories, LoveObjects = LoveObjectsCalories},
  ParsingTestTable[pLOVEFOOD, ToLowerCase@sentences, "Layout" -> "Vertical"]]

(*WolframAlpha["milk calories", "DataRules", TimeConstraint -> 60]*)
