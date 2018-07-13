(*
    Agent common commands grammar in EBNF
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
  	antononcube @@@ gmail ... com,
  	Windermere, Florida, USA.
*)

(* :Title: DateTimeSpecificationsGrammar *)
(* :Context: DateTimeSpecificationsGrammar` *)
(* :Author: Anton Antonov *)
(* :Date: 2018-03-13 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: 11.3 *)
(* :Copyright: (c) 2018 Anton Antonov *)
(* :Keywords: common command, functional parsers, EBNF *)
(* :Discussion:


   # In brief

   The grammar is intended to interface the creation and testing of text latent semantic analysis workflows.

   The grammar is partitioned into separate sub-grammars, each sub-grammar corresponding to a conceptual set of
   functionalities. (The intent is to facilitate understanding and further development.)


   # How to use

   This grammar is intended to be parsed by the functions in the Mathematica package FunctionalParses.m at GitHub,
   see https://github.com/antononcube/MathematicaForPrediction/blob/master/FunctionalParsers.m .

   (The file can be run in Mathematica with Get or Import.)


   # Example

   The following sequence of commands are parsed by the parsers generated with the grammar.

      Clear["ebnf*"]

      Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/EBNF/DateTimeSpecificationsGrammar.m"]
      Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/FunctionalParsers.m"]

      Names["ebnf*"]

*)


If[Length[DownValues[FunctionalParsers`ParseToEBNFTokens]] == 0,
  Echo["FunctionalParsers.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/FunctionalParsers.m"]
];


BeginPackage["DateTimeSpecificationsGrammar`"]
(* Exported symbols added here with SymbolName::usage *)


pDATETIMESPEC::usage = "Parses common date-time specifications."

pDATESPEC::usage = "Parses common date specifications."

DateTimeSpecificationsSubGrammars::usage = "Gives an association of the EBNF sub-grammars for date-time specifications."

DateTimeSpecificationsGrammar::usage = "Gives as a string an EBNF grammar for parsing date-time specifications."


Begin["`Private`"]

Needs["FunctionalParsers`"];

(************************************************************)
(* Date-time spec                                           *)
(************************************************************)

ebnfDateTimeSpec = "
  <date-time-spec> = [ [ 'on' ] &> <date-spec> ] , ( [ 'at' ] &> <time-spec> ) <@ DateTimeSpec@*Flatten ;
  <date-spec> = <date-full> | <day-name-relative> <@ DateSpec ;
  <month> = 'Range[1,12]' <@ Month ;
  <day> = 'Range[1,31]' <@ Day ;
  <year> = 'Range[1900,2100]' <@ Year ;
  <hour> = 'Range[0,24]' <@ Hour ;
  <hour-spec> = [ 'hour' | 'hours' ] &> <hour> | <hour> <& [ 'hour' | 'hours' ] ;
  <minute> = 'Range[0,60]' <@ Minute ;
  <minute-spec> = [ 'minute' | 'minutes' ] &> <minute> | <minute> <& [ 'minute' | 'minutes' ] ;
  <date-full> = <year> , <month> , <day> | <day> , <month> , <year> |
                <month-name> , <day> , [ <year> ] | <day> , <month-name> , [ <year> ] <@ DateFull@*Flatten ;
  <time-spec> = <hour-spec> , <minute-spec> | <right-now>  <@ TimeSpec ;
  <month-name-long> = 'january' | 'february' | 'march' | 'april' | 'may' | 'june' |
                      'july' | 'august' | 'september' | 'october' | 'november' | 'december' ;
  <month-name-abbr> = 'jan' | 'feb' | 'mar' | 'apr' | 'may' | 'jun' | 'jul' | 'aug' | 'sep' | 'oct' | 'nov' | 'dec' ;
  <month-name> = <month-name-long> | <month-name-abbr> <@ MonthName ;
  <right-now> = 'now' | 'right' , 'now' | 'just' , 'now' <@ RightNow ;
  <day-name-relative> = 'today' | 'yesterday' | 'tomorrow' | 'the' , 'day' , 'before' , 'yesterday' ;
";


(************************************************************)
(* Generate parsers                                         *)
(************************************************************)

res =
    GenerateParsersFromEBNF[ParseToEBNFTokens[#]] & /@
        {ebnfDateTimeSpec};
(* LeafCount /@ res *)


(************************************************************)
(* Modify parsers                                           *)
(************************************************************)

(* No parser modification. *)

(************************************************************)
(* Grammar exposing functions                               *)
(************************************************************)

Clear[DateTimeSpecificationsSubGrammars]

Options[DateTimeSpecificationsSubGrammars] = { "Normalize" -> False };

DateTimeSpecificationsSubGrammars[opts:OptionsPattern[]] :=
    Block[{ normalizeQ = TrueQ[OptionValue[DateTimeSpecificationsSubGrammars, "Normalize"]], res},

      res =
          Association[
            Map[
              StringReplace[#, "DateTimeSpecificationsGrammar`Private`"->"" ] -> ToExpression[#] &,
              Names["DateTimeSpecificationsGrammar`Private`ebnf*"]
            ]
          ];

      If[ normalizeQ, Map[GrammarNormalize, res], res ]
    ];


Clear[DateTimeSpecificationsGrammar]

Options[DateTimeSpecificationsGrammar] = Options[DateTimeSpecificationsSubGrammars];

DateTimeSpecificationsGrammar[opts:OptionsPattern[]] :=
    Block[{ normalizeQ = TrueQ[OptionValue[DateTimeSpecificationsGrammar, "Normalize"]], res},

      res = DateTimeSpecificationsSubGrammars[ opts ];

      res =
          StringRiffle[
            Prepend[ Values[KeyDrop[res, "ebnfCommand"]], res["ebnfCommand"]],
            "\n"
          ];

      If[ normalizeQ, GrammarNormalize[res], res ]
    ];


End[] (* `Private` *)

EndPackage[]