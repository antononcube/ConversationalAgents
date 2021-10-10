(*
    Data acquisition dialogs grammar in EBNF Mathematica code
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
    antononcube @@@ posteo ... net,
    Windermere, Florida, USA.
*)

(* Version 1.0 *)

(* This grammar is intended to be parsed by the functions in the Mathematica package FunctionalParses.m at GitHub,
   see https://github.com/antononcube/MathematicaForPrediction/blob/master/FunctionalParsers.m .

   In order to parse this grammar specification the file can be imported in Mathematica copy all of the grammar rule lines and paste them within
   a pair of string quotes.
*)

(*

Below is the Mathematica code for parsing the EBNF.

    tokens = ToTokens[ebnfDADCommand];

    res = GenerateParsersFromEBNF[tokens];

    res // LeafCount
    (* 1985 *)

    stopWords = Complement[#, DeleteStopwords[#]] &@DictionaryLookup["*"];

    pDADTITLE[xs$_] :=
     ParseApply[ToExpression["DADTitle[#]&"],
       ParsePredicate[StringMatchQ[#1, LetterCharacter ..] && !MemberQ[stopWords, #1] &]][xs$]

    pDADPACKAGE[xs$_] :=
     ParseApply[ToExpression["DADPackage[#]&"],
       ParsePredicate[StringMatchQ[#1, LetterCharacter ..] && !MemberQ[stopWords, #1] &]][xs$]

    pFROMPACKAGE[xs$_] :=
     ParseApply[ToExpression["DADFromPackage[#]&"],
       ParseSequentialCompositionPickRight[
        ParseAlternativeComposition[ParseSymbol["from"], ParseSymbol["of"]],
        ParsePredicate[StringMatchQ[#1, LetterCharacter ..] && !  MemberQ[stopWords, #1] &]]][xs$]

*)

If[Length[DownValues[FunctionalParsers`ParseToEBNFTokens]] == 0,
  Echo["FunctionalParsers.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/FunctionalParsers.m"]
];

BeginPackage["DataAcquisitionDialogsGrammar`"];

pDADCOMMAND::usage = "Parses natural language commands for data acquisition dialogs.";

DADCommandsSubGrammars::usage = "Gives an association of the EBNF sub-grammars for parsing natural language commands \
specifying data acquisition dialogs.";

DADCommandsGrammar::usage =  "Gives an association of the EBNF grammar for parsing natural language commands \
specifying data acquisition dialogs.";

Begin["`Private`"];

Needs["FunctionalParsers`"];

ebnfDADCommand = "
<dad-command> = <dad-request-command> | <dad-filter> ;
<dad-request-command> = <dad-global> | <dad-preamble> &> <dataset-spec> | ( 'find' | 'put' | 'get' | 'obtain' ) &> <dataset-spec> <& ( ( 'on' | 'in' | 'to' ) , 'the' , <dad-environment> ) ;
<dad-preamble> = 'procure' | 'obtain' | 'i' , ( 'wanna' | 'want' , 'to' ) , ( 'investigate' | 'work' ) , 'with' | 'get' | 'find' ;
<dataset-spec> = [ 'the' | 'a' | 'an' ] &> ( <dad-package> , [ <dad-from-package> ] ) | <dad-title> | { <dad-title> } | ( 'some'  | [ 'a' ] , <dataset-phrase> ) &> <dad-from-package> ;
<dad-title> = '_LetterString' <@ DADTitle[#]& ;
<dad-package> = '_LetterString' <@ DADPackage[#]& ;
<dad-from-package> = ( 'from' | 'of' ) &> '_LetterString' <@ DADFromPackage[#]& ;
<dad-filter> = <dad-global> | [ <dad-preamble> ] &> ( <dad-list-pos-spec> | <dad-filter-package> | <dad-filter-occupation> , [ <dad-from-package> ] | <dad-filter-row-size> | <dad-filter-nrow> | <dad-filter-col-size> | <dad-filter-ncol> | <dad-title> | { <dad-title> } ) ;
<dad-filter-package> =  ( ( 'it' | 'that' ) , 'is' ) &> <dad-from-package>  | [ 'the' , 'one' ] &> <dad-from-package>  ;
<dad-filter-occupation> = ( [ <dad-preamble> ] | [ ( 'it' | 'that' ) , 'is' ] , [ 'from' | 'in' ] , ( 'a' | 'an' | 'the' ) ) &> <dad-package> ;
<dad-filter-row-size> = [ 'the' ] &> ( 'larger' | 'largest' | 'shorter' | 'shortest' ) <& [ 'one' ] <@ DADNRowSize[#]& ;
<dad-filter-nrow> = ( [ 'the' ] , [ 'one' ] , [ 'that' ] , [ 'has' | 'is' , 'with' ] , [ 'with' ] ) &> '_?IntegerQ' <& ( [ 'number' , 'of' ] , 'rows' , [ 'one' ] ) <@ DADNRow[#]& ;
<dad-filter-col-size> = [ 'the' ] &> ( 'wider' | 'widest' | 'narrower' | 'narrowest' ) <& [ 'one' ] <@ DADNColSize[#]& ;
<dad-filter-ncol> = ( [ 'the' ] , [ 'one' ] , [ 'that' ] , [ 'has' | 'is' , 'with' ] , [ 'with' ] ) &> '_?IntegerQ' <& ( [ 'number' , 'of' ] , 'columns' , [ 'one' ] ) <@ DADNCol[#]& ;
<dad-list-pos-spec> = [ 'the' ] &> ( <dad-list-num-pos> | 'last' | 'former' | 'later' ) <& ( [ 'one' ] | [ [ 'one' ] , 'in' , 'the' , 'list' ] ) <@ ListPosition[#]& ;
<dad-list-num-pos> = 'first' | 'second' | 'third' | 'fourth' | 'fifth' | 'sixth' | 'seventh' | 'eighth' | 'ninth' | 'tenth' | 'Range[1,100]' ;
<dad-usage-spec>  = 'my' , 'next' , <data-analysis-phrase> | 'the' , <data-analysis-phrase> , [ 'i' , 'have' , 'now' ] ;
<dad-global> = <dad-global-help> | <dad-global-cancel> | <dad-global-priority-list> ;
<dad-global-help> = 'help' <@ DADGlobal[\"help\"]& ;
<dad-global-cancel> = 'start' , 'over' | 'cancel' <@ DADGlobal[\"cancel\"]& ;
<dad-global-priority-list> = 'priority' , ( 'order' | 'list' ) | 'order' , 'by' , 'priority' <@ DADGlobal[\"priority\"]& ;
<dataset-phrase> = 'dataset' | [ 'data' ] , 'table' | [ 'tabular' ] , 'data' ;
<data-analysis-phrase> = <dataset-phrase> , [ 'investigation' | 'analysis' | 'research' ] ;
<dad-environment> = 'environment' | 'notebook' ;
";

(************************************************************)
(* Generate parsers                                         *)
(************************************************************)

(*res = GenerateParsersFromEBNF[ParseToEBNFTokens[#]] & /@ {ebnfDADCommand};*)
res = GenerateParsersFromEBNF[ToTokens[#]] & /@ {ebnfDADCommand};
(* LeafCount /@ res *)

(************************************************************)
(* Modify parsers                                           *)
(************************************************************)

stopWords = Complement[#, DeleteStopwords[#]] & @ DictionaryLookup["*"];

pDADTITLE[xs$_] :=
    ParseApply[ToExpression["DADTitle[#]&"],
      ParsePredicate[StringMatchQ[#1, LetterCharacter ..] && !MemberQ[stopWords, #1] &]][xs$];

pDADPACKAGE[xs$_] :=
    ParseApply[ToExpression["DADPackage[#]&"],
      ParsePredicate[StringMatchQ[#1, LetterCharacter ..] && !MemberQ[stopWords, #1] &]][xs$];

pFROMPACKAGE[xs$_] :=
    ParseApply[ToExpression["DADFromPackage[#]&"],
      ParseSequentialCompositionPickRight[
        ParseAlternativeComposition[ParseSymbol["from"], ParseSymbol["of"]],
        ParsePredicate[StringMatchQ[#1, LetterCharacter ..] && !  MemberQ[stopWords, #1] &]]][xs$];


(************************************************************)
(* Grammar exposing functions                               *)
(************************************************************)

Clear[DADCommandsSubGrammars];

Options[DADCommandsSubGrammars] = { "Normalize" -> False };

DADCommandsSubGrammars[opts:OptionsPattern[]] :=
    Block[{ normalizeQ = TrueQ[OptionValue[DADCommandsSubGrammars, "Normalize"]], res},

      res =
          Association[
            Map[
              StringReplace[#, "DataAcquisitionDialogsGrammar`Private`"->"" ] -> ToExpression[#] &,
              Names["DataAcquisitionDialogsGrammar`Private`ebnf*"]
            ]
          ];

      If[ normalizeQ, Map[GrammarNormalize, res], res ]
    ];


Clear[DADCommandsGrammar];

Options[DADCommandsGrammar] = Options[DADCommandsSubGrammars];

DADCommandsGrammar[opts:OptionsPattern[]] :=
    Block[{ normalizeQ = TrueQ[OptionValue[DADCommandsGrammar, "Normalize"]], res},

      res = DADCommandsSubGrammars[ opts ];

      res =
          StringRiffle[
            Prepend[ Values[KeyDrop[res, "ebnfCommand"]], res["ebnfCommand"]],
            "\n"
          ];

      If[ normalizeQ, GrammarNormalize[res], res ]
    ];

End[]; (* `Private` *)

EndPackage[]