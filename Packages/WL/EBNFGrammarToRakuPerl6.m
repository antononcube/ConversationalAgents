(*
    EBNF grammar conversion to Raku Perl 6 Wolfram Language package
    Copyright (C) 2019  Anton Antonov

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
   	antononcube @ gmail . com,
	  Windermere, Florida, USA.
*)

(*
    Mathematica is (C) Copyright 1988-2019 Wolfram Research, Inc.

    Protected by copyright law and international treaties.

    Unauthorized reproduction or distribution subject to severe civil
    and criminal penalties.

    Mathematica is a registered trademark of Wolfram Research, Inc.
*)

(* This file was created with the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ . *)

(* :Title: EBNFGrammarToRakuPerl6 *)
(* :Context: EBNFGrammarToRakuPerl6` *)
(* :Author: Anton Antonov *)
(* :Date: 2019-08-20 *)

(* :Package Version: 0.8 *)
(* :Mathematica Version: 12.0 *)
(* :Copyright: (c) 2019 Anton Antonov *)
(* :Keywords: functional parsers, Raku Perl 6, grammar, class *)
(* :Discussion: *)

(* For new style packages see: https://mathematica.stackexchange.com/a/176489) *)
(* Declare package context *)
Package["EBNFGrammarToRakuPerl6`"]

(* Import other packages *)
(*PackageImport["GeneralUtilities`"]*)

If[Length[DownValues[FunctionalParsers`ParseEBNF]] == 0,
  Echo["FunctionalParsers.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/FunctionalParsers.m"]
];

Needs["FunctionalParsers`"];


(************************************************************)
(* Private functions                                        *)
(************************************************************)

PackageScope["Perl6EBNF"]
Clear[Perl6EBNF];
Perl6EBNF[rules : {_EBNFRule ..}, name_String : "SomeGrammar", topRule_String : ""] :=
    Block[{},
      "grammar " <> name <> " {\n" <> StringRiffle[Map["  " <> Perl6Rule[#, topRule] &, rules], "\n"] <> "\n}"
    ];

PackageScope["Perl6Rule"]
Clear[Perl6Rule];
Perl6Rule[rule_EBNFRule, topRule_String : ""] :=
    Block[{res, lhs},
      res = rule[[1, 1]];
      If[res[[1]] == topRule,
        lhs = "TOP",
        lhs = StringReplace[res[[1]], {StartOfString ~~ "<" -> "", ">" ~~ EndOfString -> ""}]
      ];
      "rule " <> lhs <> " {" <> res[[2]] <> "}"
    ];

PackageScope["Perl6NonTerminal"]
Clear[Perl6NonTerminal];
Perl6NonTerminal[x_String] := x;

PackageScope["Perl6Terminal"]
Clear[Perl6Terminal];
Perl6Terminal[t_String] :=
    Which[
      StringMatchQ[t, "'Range[" ~~ __ ~~ "]'"], "[\\d+]",
      True, t
    ];

PackageScope["Perl6Sequence"]
Clear[Perl6Sequence];
Perl6Sequence[s_String] := s;
Perl6Sequence[","[seq__]] := StringRiffle[{seq}, " "];
Perl6Sequence[","[p1_, ","[seq__]]] := p1 <> " " <> Perl6Sequence[","[seq]];

PackageScope["Perl6Alternatives"]
Clear[Perl6Alternatives];
Perl6Alternatives[alts_List] :=
    Block[{},
      If[Length[alts] == 1,
        alts,
        StringRiffle[alts, {"[ ", " | ", " ]"}]
      ]
    ];

PackageScope["Perl6Option"]
Clear[Perl6Option];
Perl6Option[s_] := "[ " <> s <> " ]?";

PackageScope["Perl6Repetition"]
Clear[Perl6Repetition];
Perl6Repetition[seq_] := "[ " <> seq <> " ]+";

PackageScope["ValidRuleLHS"]
Clear[ValidRuleLHS];
ValidRuleLHS[s_String] :=
    StringMatchQ[s, StartOfString ~~ "<" ~~ __ ~~ ">" ~~ EndOfString];
ValidRuleLJS[___] := False;


(************************************************************)
(* Export functions                                         *)
(************************************************************)

PackageExport["ToRakuPerl6"]

Clear[ToRakuPerl6];

ToRakuPerl6::usage = "ToRakuPerl6[ebnfCode_String, opts] converts the EBNF grammar string ebnfCode into a Raku Perl 6 grammar class definition.";

ToRakuPerl6::notgn = "The value of the option \"GrammarName\" is expected to be a string. \
Proceeding by ignoring it.";

ToRakuPerl6::nottop = "The value of the option \"TopRule\" is not valid left hand side non-terminal. \
Proceeding by ignoring it.";

Options[ToRakuPerl6] = {"GrammarName" -> "SomeGrammar", "TopRule" -> None};

ToRakuPerl6[ebnfCode_String, opts : OptionsPattern[]] :=
    Block[{res, grammarName, topRule},

      grammarName = OptionValue[ToRakuPerl6, "GrammarName"];
      topRule = OptionValue[ToRakuPerl6, "TopRule"];

      If[! StringQ[grammarName],
        Message[ToRakuPerl6::notgn];
        grammarName = "SomeGrammar";
      ];

      Which[
        TrueQ[topRule === None],
        topRule = "",

        ! (ValidRuleLHS[topRule] && Length[StringCases[ebnfCode, topRule]] > 0),
        Message[ToRakuPerl6::nottop];
        topRule = "";
      ];

      res = ParseEBNF[ParseToTokens[GrammarNormalize[ebnfCode]]];

      res = Cases[res, EBNF[___], Infinity];
      If[Length[res] == 0, Return[$Failed]];

      res = First[res];

      Block[{
        EBNF = Perl6EBNF[#, grammarName, topRule] &,
        EBNFTerminal = Perl6Terminal,
        EBNFNonTerminal = Perl6NonTerminal,
        EBNFSequence = Perl6Sequence,
        EBNFAlternatives = Perl6Alternatives,
        EBNFOption = Perl6Option,
        EBNFRepetition = Perl6Repetition},
        res
      ]
    ];

