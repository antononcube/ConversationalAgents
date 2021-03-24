(*
    Worded numbers grammar in EBNF
    Copyright (C) 2018  Anton Antonov

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
	  antononcube@gmail.com,
	  Windermere, Florida, USA.
*)


(* :Title: WordedNumbersGrammar *)
(* :Context: WordedNumbersGrammar` *)
(* :Author: Anton Antonov *)
(* :Date: 2018-07-17 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: 11.3 *)
(* :Copyright: (c) 2018 Anton Antonov *)
(* :Keywords: *)
(* :Discussion:

    # In brief

    This package parses and interprets numbers given in word for into numbers.

    # Examples

    Here is an example:

      ParseShortest[pWORDEDNUMBER][ToTokens["one million six hundred ninety thousand one hundred forty four"]]
      (* {{{}, WordedNumber[1690144]}} *)

    This form is parsed:

      ParseShortest[pWORDEDNUMBER][ToTokens["fifteen hundred and five"]]
      (* {{{}, WordedNumber[1505]}} *)

    This is also parsed:

      ParseShortest[pWORDEDNUMBER][ ToTokens["zero thousand and seven hundred and five"]]
      (* {{{}, WordedNumber[705]}} *)


*)

If[Length[DownValues[FunctionalParsers`ParseToEBNFTokens]] == 0,
  Echo["FunctionalParsers.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/FunctionalParsers.m"]
];


BeginPackage["WordedNumbersGrammar`"];
(* Exported symbols added here with SymbolName::usage *)

pWORDEDNUMBER::usage = "Parses (and interprets) numbers in word form into numbers.";

WordedNumbersSubGrammars::usage = "Gives an association of the EBNF sub-grammars for parsing numbers in word form.";

WordedNumbersGrammar::usage = "Gives as a string an EBNF grammar for parsing numbers in word form.";

TimesFlatten::usage = "Flattens and applies Times.";

TotalFlatten::usage = "Flattens and applies Total.";

Begin["`Private`"];

Needs["FunctionalParsers`"];

(************************************************************)
(* Generate rules                                           *)
(************************************************************)

nRules = Table[
  "<" <> "name-of-" <> ToString[i] <> "> = '" <>
      StringReplace[IntegerName[i], {"1 " -> "", "one " -> ""}] <>
      "' <@ Function[" <> ToString[i] <> "] ;", {i, Join[Range[0, 19], Range[20, 100, 10], {1000, 10^6}]}]

nRulesLHS =
    Table["<" <> "name-of-" <> ToString[i] <> ">", {i, Join[Range[0, 19], Range[20, 100, 10], {1000, 10^6}]}]

ebnfNumberNameRules = StringRiffle[nRules, "\n"];

ebnfNumberName1To19Rule =
    "<name-1-to-19> = " <> StringRiffle[Take[nRulesLHS, {2, 20}], " | "] <> " ;";

ebnfNumberNameUpTo19Rule = "<name-up-to-19> = <name-of-0> | <name-1-to-19> ;";

ebnfNumberNameM10Rule =
    "<name-of-10s> = " <> StringRiffle[Take[nRulesLHS, {21, -4}], " | "] <> " ;";

ebnfNumberName1To10Rule =
    "<name-1-to-10> = " <> StringRiffle[Take[nRulesLHS, {2, 11}], " | "] <> " ;";

TimesFlatten = Function[Apply[Times, Flatten[List[#]]]];
TotalFlatten = Function[Total[Flatten[List[#]]]];

ebnfWordedNumberRule = "
  <worded-number> = <worded-number-up-to-bil> |
                    <worded-number-up-to-1000000> |
                    <worded-number-up-to-1000> |
                    <worded-number-up-to-100> <@ WordedNumber@*TotalFlatten ;
  <worded-number-100s> = <name-1-to-19> , <name-of-100> <@ TimesFlatten ;
  <worded-number-up-to-100> = <name-up-to-19> | <name-of-10s> , [ '\[Hyphen]' ] &> [ <name-1-to-10> ] <@ TotalFlatten ;
  <worded-number-1000s> = <worded-number-up-to-1000> , <name-of-1000> <@ TimesFlatten ;
  <worded-number-up-to-1000> = <worded-number-up-to-100> |
                                <worded-number-100s> , [ [ 'and' | ',' ] &> <worded-number-up-to-100> ] <@ TotalFlatten ;
  <worded-number-up-to-1000000> = <worded-number-up-to-1000> |
                                   <worded-number-1000s> , [ [ 'and' | ',' ] &> <worded-number-up-to-1000> ] <@ TotalFlatten ;
  <worded-number-1000000s> = <worded-number-up-to-1000000> , <name-of-1000000> <@ TimesFlatten ;
  <worded-number-up-to-bil> = <worded-number-up-to-1000000> |
                               <worded-number-1000000s> , [ [ 'and' | ',' ] &> <worded-number-up-to-1000000> ] <@ TotalFlatten ;
  ";

allRules =
    StringRiffle[{ebnfWordedNumberRule, ebnfNumberNameM10Rule, ebnfNumberName1To10Rule,
      ebnfNumberName1To19Rule, ebnfNumberNameUpTo19Rule, ebnfNumberNameRules}, "\n"];

(************************************************************)
(* Generate parsers                                         *)
(************************************************************)

res = GenerateParsersFromEBNF[ToTokens[allRules]];


(************************************************************)
(* Grammar exposing functions                               *)
(************************************************************)

Clear[WordedNumbersSubGrammars];

Options[WordedNumbersSubGrammars] = { "Normalize" -> False };

WordedNumbersSubGrammars[opts:OptionsPattern[]] :=
    Block[{ normalizeQ = TrueQ[OptionValue[WordedNumbersSubGrammars, "Normalize"]], res},

      res =
          Association[
            Map[
              StringReplace[#, "WordedNumbersGrammar`Private`"->"" ] -> ToExpression[#] &,
              Names["WordedNumbersGrammar`Private`ebnf*"]
            ]
          ];

      If[ normalizeQ, Map[GrammarNormalize, res], res ]
    ];


Clear[WordedNumbersGrammar];

Options[WordedNumbersGrammar] = Options[WordedNumbersSubGrammars];

WordedNumbersGrammar[opts:OptionsPattern[]] :=
    Block[{ normalizeQ = TrueQ[OptionValue[WordedNumbersGrammar, "Normalize"]], res},

      res = WordedNumbersSubGrammars[ opts ];

      res =
          StringRiffle[
            Prepend[ Values[KeyDrop[res, "ebnfWordedNumberRule"]], res["ebnfWordedNumberRule"]],
            "\n"
          ];

      If[ normalizeQ, GrammarNormalize[res], res ]
    ];



End[]; (* `Private` *)

EndPackage[]