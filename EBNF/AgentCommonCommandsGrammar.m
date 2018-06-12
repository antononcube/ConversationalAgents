(*
    Latent semantic analysis workflows grammar in EBNF
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

(* :Title: AgentCommonCommandsGrammar *)
(* :Context: AgentCommonCommandsGrammar` *)
(* :Author: Anton Antonov *)
(* :Date: 2018-06-11 *)

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

      Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/EBNF/AgentCommonCommandsGrammar.m"]
      Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/FunctionalParsers.m"]

      Names["ebnf*"]

*)


If[Length[DownValues[FunctionalParsers`ParseToEBNFTokens]] == 0,
  Echo["FunctionalParsers.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/FunctionalParsers.m"]
];


BeginPackage["AgentCommonCommandsGrammar`"]
(* Exported symbols added here with SymbolName::usage *)


pAGENTCOMMONCOMMAND::usage = "Parses common conversational agent natural language commands."

AgentCommonCommandsSubGrammars::usage = "Gives an association of the EBNF sub-grammars for parsing natural language commands \
commonly used in conversational agents."

AgentCommonCommandsGrammar::usage = "Gives as a string an EBNF grammar for parsing natural language commands \
commonly used in conversational agents."


Begin["`Private`"]

Needs["FunctionalParsers`"];

(************************************************************)
(* Common commands                                          *)
(************************************************************)

ebnfCommand = "
  <agent-common-command> = <help> | <start-over> | <forget> | <clear-state> | <load-file> | <random-sentences> <@ AgentCommonCommand ;
  <load-file> = ( 'load' , [ 'data' ] , 'file'  ) &> ( '_String' ) <@ CommonCommandLoadFile ;
  <start-over> = 'start' , 'over' | 'clear' , 'all' | 'cancel' <@ CommonCommandStartOver@*Flatten@*List ;
  <clear-graphics> = ( 'clear' | 'clean' ) , ( 'plots' | 'plots' | 'graphics' ) <@ CommonCommandClearGraphics ;
  <clear-state> = ( 'clear' | 'clean' ) , ( 'state' | 'plots' | 'graphics' ) <@ CommonCommandClearState ;
  <forget-verb> = 'forget' | 'drop' | 'delete' | 'ignore' ;
  <command> = 'command' | 'order' | 'thing' , 'i' , 'said' ;
  <forget> = ( <forget-verb> , [ 'the' ] ) &>  <forget-spec> <& [ <command> ] <@ CommonCommandForget ;
  <forget-spec> =  { '_String' } <@ CommonCommandForgetSpec ;
  <operations> = 'operations' | 'commands' ;
  <operation> = 'operation' | 'command' ;
  <what-operations> = 'what' , ( ( <operations> , 'are'  |  [ 'are' ] , [ 'the' ] , <operations> ) , [ 'implemented' | 'in' ] ) |
                      [ 'what' ] , ( <operation> | <operations> ) , ( 'can' , 'i' | 'i' , 'can' | 'to' ) , ( 'use' | 'do' ) <@ CommonCommandWhatOperations@*Flatten ;
  <help-all> = 'help' | [ 'all' ] , 'commands' <@ CommonCommandHelp@*Flatten@*List ;
  <help> = <help-all> | <what-operations> ;
  <random-sentences> = <display-directive> &> ( 'some' | '_?IntegerQ' ) <& ( 'random' , ( 'sentences' | 'commands' ) ) <@ CommandCommandRandomSentences ;
  <display-directive> = 'show' | 'display' | 'give' ;
";


(************************************************************)
(* Generate parsers                                         *)
(************************************************************)

res =
    GenerateParsersFromEBNF[ParseToEBNFTokens[#]] & /@
        {ebnfCommand};
(* LeafCount /@ res *)


(************************************************************)
(* Modify parsers                                           *)
(************************************************************)

(* No parser modification. *)

(************************************************************)
(* Grammar exposing functions                               *)
(************************************************************)

Clear[AgentCommonCommandsSubGrammars]

Options[AgentCommonCommandsSubGrammars] = { "Normalize" -> False };

AgentCommonCommandsSubGrammars[opts:OptionsPattern[]] :=
    Block[{ normalizeQ = TrueQ[OptionValue[AgentCommonCommandsSubGrammars, "Normalize"]], res},

      res =
          Association[
            Map[
              StringReplace[#, "AgentCommonCommandsGrammar`Private`"->"" ] -> ToExpression[#] &,
              Names["AgentCommonCommandsGrammar`Private`ebnf*"]
            ]
          ];

      If[ normalizeQ,
        Map[StringReplace[#, {"&>" -> ",", "<&" -> ",", ("<@" ~~ (Except[{">", "<"}] ..) ~~ ";") :> ";"}]&, res],
        res
      ]
    ];


Clear[AgentCommonCommandsGrammar]

Options[AgentCommonCommandsGrammar] = Options[AgentCommonCommandsSubGrammars];

AgentCommonCommandsGrammar[opts:OptionsPattern[]] :=
    Block[{ normalizeQ = TrueQ[OptionValue[AgentCommonCommandsGrammar, "Normalize"]], res},

      res = AgentCommonCommandsSubGrammars[ opts ];

      res =
          StringRiffle[
            Prepend[ Values[KeyDrop[res, "ebnfCommand"]], res["ebnfCommand"]],
            "\n"
          ];

      If[ normalizeQ,
        StringReplace[res, {"&>" -> ",", "<&" -> ",", ("<@" ~~ (Except[{">", "<"}] ..) ~~ ";") :> ";"}],
        res
      ]
    ];


End[] (* `Private` *)

EndPackage[]