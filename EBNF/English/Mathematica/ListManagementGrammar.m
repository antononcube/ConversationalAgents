(*
    List management grammar in EBNF
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

(* :Title: ListManagementGrammar *)
(* :Context: ListManagementGrammar` *)
(* :Author: Anton Antonov *)
(* :Date: 2018-05-27 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: *)
(* :Copyright: (c) 2018 Anton Antonov *)
(* :Keywords: *)
(* :Discussion: *)

If[Length[DownValues[FunctionalParsers`ParseToEBNFTokens]] == 0,
  Echo["FunctionalParsers.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/FunctionalParsers.m"]
];

BeginPackage["ListManagementGrammar`"]

pLISTMANAGEMENTCOMMAND::usage = "Parser for list management natural language commands."

ListManagementCommandsSubGrammars::usage = "Gives an association of the EBNF sub-grammars for parsing natural language commands \
for list management."

ListManagementCommandsGrammar::usage = "Gives as a string an EBNF grammar for parsing natural language commands \
for list management."

Begin["`Private`"]

Needs["FunctionalParsers`"];

(************************************************************)
(* Main sub-grammar                                         *)
(************************************************************)

ebnfCommand = "
    <list-management-command> = <replace-part> | <drop> | <take> | <assignment> | <clear> |
                                <position-query> | <position-spec> <@ ListManagementCommand ;
    <assignment> = ( 'set' &> <variable-name> , ( 'to' | 'as' ) &> <value> ) | ( 'assign' &> <value> , 'to' &> <variable-name> ) <@ ListAssignment ;
    <take> = ( 'take' | 'get' ) &> ( <position-query> | <position-spec> ) <@ ListTake ;
    <drop> = ( 'drop' | 'delete' | 'erase' ) &> ( <position-query> | <position-spec> ) <@ ListDrop ;
    <replace-part> = 'replace' &> <position-spec> , ( 'with' | 'by' ) &> ( <position-spec> | [ 'the' ] &> <value> ) <@ ListReplacePart ;
    <clear> = ( 'clear' | 'empty' ) , [ 'list' ] |
              ( 'drop' | 'delete' ), 'all' , [ 'list' ] , [ 'elements' ] , [ <list-phrase> ] <@ ListClear ;
    <variable-name> = [ 'variable' ] &> '_WordString' <@ ListVariable ;
    <value> = [ 'value' ] &> '_String' <@ ListValue ;
    <list-phrase> = ( 'in' | 'of' ) , 'the' , 'list' ;
    <position-query> = ( 'element' &> <position-index> |
                         [ 'the' ] &> <position-ordinal> <& ( 'element' | 'one' ) |
                         [ 'the' ] &> <position-reference> <& [ 'element' | 'one' ] ) ,
                       ('in' | 'of' ) &> ( <position-query> | [ 'the' ] &> <variable-name> ) <@ ListPositionQuery ;
    <position-spec> = ( [ 'the' ] , [ 'element' ] ) &> ( <position-index> | <position-word> ) <&
                      ( [ 'one' | 'element' ] , [ <list-phrase> ] ) <@ ListPositionSpec ;
    <position-index> = 'Range[0,1000]' <@ ListPositionIndex ;
    <position-word> =  <position-ordinal> | <position-reference> <@ ListPositionWord ;
    <position-reference> = 'head' | 'rest' | 'last' | 'one' , 'before' , [ 'the' ] , 'last' | 'former' | 'later' <@ ListPositionReference ;
    <position-ordinal> = 'first' | 'second' | 'third' | 'fourth' | 'fifth' | 'sixth' | 'seventh' | 'eight' | 'ninth' | 'tenth' |
                         '1st' | '2nd' | '3rd' | '4th' | '5th' | '6th' | '7th' | '8th' | '9th' | '10th' |
                          ( <position-index> <& ( 'st' | 'nd' | 'rd' | 'th' ) ) <@ ListPositionOrdinal ;
";


(************************************************************)
(* Generate parsers                                         *)
(************************************************************)

res =
    GenerateParsersFromEBNF[ParseToEBNFTokens[#]] & /@
        {ebnfCommand};



(************************************************************)
(* Grammar exposing functions                               *)
(************************************************************)

(* Almost the same as the code at the end of ClassifierWorkflowsGrammar.m . *)

Clear[ListManagementCommandsSubGrammars]

Options[ListManagementCommandsSubGrammars] = { "Normalize" -> False };

ListManagementCommandsSubGrammars[opts:OptionsPattern[]] :=
    Block[{ normalizeQ = TrueQ[OptionValue[ListManagementCommandsSubGrammars, "Normalize"]], res},

      res =
          Association[
            Map[
              StringReplace[#, "ListManagementGrammar`Private`"->"" ] -> ToExpression[#] &,
              Names["ListManagementGrammar`Private`ebnf*"]
            ]
          ];

      If[ normalizeQ, Map[GrammarNormalize, res], res ]
    ];


Clear[ListManagementCommandsGrammar]

Options[ListManagementCommandsGrammar] = Options[ListManagementCommandsSubGrammars];

ListManagementCommandsGrammar[opts:OptionsPattern[]] :=
    Block[{ normalizeQ = TrueQ[OptionValue[ListManagementCommandsGrammar, "Normalize"]], res},

      res = ListManagementCommandsSubGrammars[ opts ];

      res =
          StringRiffle[
            Prepend[ Values[KeyDrop[res, "ebnfCommand"]], res["ebnfCommand"]],
            "\n"
          ];

      If[ normalizeQ, GrammarNormalize[res], res ]
    ];


End[] (* `Private` *)

EndPackage[]