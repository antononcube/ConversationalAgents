(*
    Random data generation grammar in EBNF
    Copyright (C) 2021  Anton Antonov

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Written by Anton Antonov,
    antononcube @@@ posteo . net,
    Windermere, Florida, USA.
*)

(* Version 0.3 *)

(*

   # In brief

   The grammar is intended to interface the creation and testing of random data generation commands.

   The grammar is partitioned into separate sub-grammars, each sub-grammar corresponding to a conceptual set of
   functionalities. (The intent is to facilitate understanding and further development.)


   # How to use

   This grammar is intended to be parsed by the functions in the Mathematica package FunctionalParses.m at GitHub,
   see https://github.com/antononcube/MathematicaForPrediction/blob/master/FunctionalParsers.m .

   (The file can be run in Mathematica with Get or Import.)


   # Example

   The following sequence of commands are parsed by the parsers generated with the grammar.

      Clear["ebnf*"]

      Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/EBNF/RandomDataGenerationGrammar.m"]
      Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/FunctionalParsers.m"]

      Names["ebnf*"]

*)


If[Length[DownValues[FunctionalParsers`ParseToEBNFTokens]] == 0,
  Echo["FunctionalParsers.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/FunctionalParsers.m"]
];

BeginPackage["RandomDataGenerationGrammar`"];

pRANDOMDATAGENERATIONCOMMAND::usage = "Parses natural language commands for random data generation.";

RandomDataGenerationSubGrammars::usage = "Gives an association of the EBNF sub-grammars for parsing natural language commands \
specifying random data generation commands construction.";

RandomDataGenerationGrammars::usage = "Gives as a string an EBNF grammar for parsing natural language commands \
specifying random data generation commands construction.";

Begin["`Private`"];

Needs["FunctionalParsers`"];

(************************************************************)
(* Common parts                                             *)
(************************************************************)

ebnfCommonParts = "
  <wl-expr> = '_?StringQ' <@ WLExpression;
  <and-conjunction> = 'and' ;
  <with-preposition> =  'using' | 'by' | 'with' ;
  <using-preposition> = 'using' | 'with' | 'over' | 'for' ;
  <for-preposition> = 'for' ;
  <a-determiner> = 'a' | 'an' ;
  <the-determiner> = 'the' ;
  <list-delimiter> = 'and' | ',' | ',' , 'and' | 'together' , 'with' <@ ListDelimiter ;
  <integer-value> = '_?IntegerQ' <@ IntegerValue ;
  <number-value> = '_?NumberQ' <@ NumericValue ;
  <percent-value> = <number-value> <& ( '%' | 'percent' ) <@ PercentValue ;
  <boolean-value> = 'True' | 'False' | 'true' | 'false' <@ BooleanValue ;
  <display-directive> = 'show' | 'give' | 'display' <@ DisplayDirective ;
  <compute-directive> = 'compute' | 'calculate' | 'find' <@ ComputeDirective ;
  <generate-directive> = 'generate' | 'make' | 'create' <@ GenerateDirective ;
  <compute-and-display> = <compute-directive> , [ 'and' &> <display-directive> ] <@ ComputeAndDisplay ;
  <generate-directive> = 'make' | 'create' | 'generate' <@ GenerateDirective ;
  <class-label> = '_String' <@ ClassLabel ;
  <filler-separator> =  ',' | <and-conjunction> | <using-preposition> | <for-preposition> ;
  <data-reference> = 'data' | 'dataset' ;
  <dataset-name> = '_WordString' <@ DatasetName ;
  <database-name> = '_WordString' <@ DatabaseName ;
  <data-kind> = '_String' <@ DataKind ;
  <rows-noun> = 'rows' ;
  <columns-noun> = 'columns' | 'variables' ;
  <column-noun> = 'column' | 'variable' ;
  <generators-noun> = 'generator' | 'generators' ;
  <tabular-adjective> = 'tabular' ;
  <random-adjective> = 'random' ;
  <names-noun> = 'names' ;
";

ebnfColumnSpec = "
  <column-specs-list> = <column-spec> , [ { <list-delimiter> , <column-spec> } ]  ;
  <column-spec> = <column-name-spec> | <wl-expr> ;
  <column-name-spec> = '_String' ;
";

ebnfPhrases = "
  <column-names-phrase> = <columns-noun> , <names-noun> ;
  <column-generators-phrase> = <column-noun> , <generators-noun> ;
  <number-of-columns-phrase> = 'number' , 'of' , <columns-noun> ;
  <number-of-rows-phrase> = 'number' , 'of' , 'rows' ;
  <dataset-phrase> = <data-reference> | 'data' , 'set' | 'data' , 'frame' ;
  <number-of-values-phrase> = 'number' , 'of' , 'values' ;
";

ebnfGenerators = "
   <generator> = 'Normal' | 'Poisson' | 'RandomReal' | 'RandomString' ;
   <generators-list> = <generator> , [ { <list-delimiter> , <generator> } ];
";


(************************************************************)
(* random-tabular-dataset-argument                          *)
(************************************************************)

ebnfRandomTabularDatasetArgument = "
  <random-tabular-dataset-argument> =
     <random-tabular-dataset-nrows-spec> |
     <random-tabular-dataset-ncols-spec> |
     <random-tabular-dataset-colnames-spec> |
     <random-tabular-dataset-form-spec> |
     <random-tabular-dataset-col-generators-spec> |
     <random-tabular-dataset-max-number-of-values-spec> |
     <random-tabular-dataset-min-number-of-values-spec> ;

 <random-tabular-dataset-nrows-spec> = <integer-value> , ( <number-of-rows-phrase> | <rows-noun> ) ;

 <random-tabular-dataset-ncols-spec> = <integer-value> , ( <number-of-columns-phrase> | <columns-noun> ) ;

 <random-tabular-dataset-colnames-spec> = <the-determiner> , <column-names-phrase> , <column-specs-list> ;

 <random-tabular-dataset-form-spec> = 'in' , ( 'long' | 'wide' ) , ( 'form' | 'format' ) ;

 <random-tabular-dataset-col-generators-spec> = [ <the-determiner> ] , [ <column-generators-phrase> ] , <generators-list> ;

 <random-tabular-dataset-max-number-of-values-spec> = 'max' , <number-of-values-phrase> , <integer-value> ;

 <random-tabular-dataset-min-number-of-values-spec> = 'min' , <number-of-values-phrase> , <integer-value> ;

";

ebnfRandomTabularDatasetArgumentList = "
   <random-tabular-dataset-arguments-list> =
     <random-tabular-dataset-argument> , [ { <filler-separator> , <random-tabular-dataset-argument> } ] ;
";

ebnfRandomTabularDataGenerationCommand = "
   <random-tabular-data-generation-command> =
     [ <generate-directive> ] , [ <a-determiner> ] , <random-adjective> , [ <tabular-adjective> ] , <dataset-phrase> , <filler-separator> , [ <random-tabular-dataset-arguments-list> ] ;
";


(************************************************************)
(* Combination                                              *)
(************************************************************)

ebnfCommand = "
  <random-data-generation-command> = <random-tabular-data-generation-command> ;
";


(************************************************************)
(* Generate parsers                                         *)
(************************************************************)

res =
    GenerateParsersFromEBNF[ParseToEBNFTokens[#]] & /@
        {ebnfCommonParts,
          ebnfColumnSpec,
          ebnfPhrases,
          ebnfGenerators,
          ebnfRandomTabularDatasetArgument,
          ebnfRandomTabularDatasetArgumentList,
          ebnfRandomTabularDataGenerationCommand,
          ebnfCommand};

Print[LeafCount /@ res];


(************************************************************)
(* Modify parsers                                           *)
(************************************************************)

(* No parser modification. *)

(************************************************************)
(* Grammar exposing functions                               *)
(************************************************************)

Clear[RandomDataGenerationSubGrammars];

Options[RandomDataGenerationSubGrammars] = { "Normalize" -> False };

RandomDataGenerationSubGrammars[opts:OptionsPattern[]] :=
    Block[{ normalizeQ = TrueQ[OptionValue[RandomDataGenerationSubGrammars, "Normalize"]], res},

      res =
          Association[
            Map[
              StringReplace[#, "RandomDataGenerationGrammar`Private`"->"" ] -> ToExpression[#] &,
              Names["RandomDataGenerationGrammar`Private`ebnf*"]
            ]
          ];

      If[ normalizeQ, Map[GrammarNormalize, res], res ]
    ];


Clear[RandomDataGenerationGrammars];

Options[RandomDataGenerationGrammars] = Options[RandomDataGenerationSubGrammars];

RandomDataGenerationGrammars[opts:OptionsPattern[]] :=
    Block[{ normalizeQ = TrueQ[OptionValue[RandomDataGenerationGrammars, "Normalize"]], res},

      res = RandomDataGenerationSubGrammars[ opts ];

      res =
          StringRiffle[
            Prepend[ Values[KeyDrop[res, "ebnfCommand"]], res["ebnfCommand"]],
            "\n"
          ];

      If[ normalizeQ, GrammarNormalize[res], res ]
    ];

End[]; (* `Private` *)

EndPackage[]