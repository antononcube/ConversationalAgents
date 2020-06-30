(*
    External Parsers Hookup Mathematica package
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

(* Created with the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ . *)

(* :Title: ExternalParsersHookup *)
(* :Context: ExternalParsersHookup` *)
(* :Author: Anton Antonov *)
(* :Date: 2019-08-27 *)

(* :Package Version: 0.5 *)
(* :Mathematica Version: 12.0 *)
(* :Copyright: (c) 2019 Anton Antonov *)
(* :Keywords: *)
(* :Discussion:

   [X] Needs refactoring!
*)

BeginPackage["ExternalParsersHookup`"];
(* Exported symbols added here with SymbolName::usage *)

RakuCommand::usage = "Raku (Perl 6) command invocation.";

ToMonadicCommand::usage = "Translates a natural language commands into a monadic pipeline.";

ToQRMonCommand::usage = "Translates a natural language commands into a QRMon-WL pipeline.";

ToSMRMonCommand::usage = "Translates a natural language commands into a SMRMon-WL pipeline.";

ToLSAMonCommand::usage = "Translates a natural language commands into a LSAMon-WL pipeline.";

ToECMMonCommand::usage = "Translates a natural language commands into a ECMMon-WL pipeline.";

ToQRMonWLCommand::usage = "Translates a natural language commands into a QRMon-WL pipeline. Obsolete.";

ToSMRMonWLCommand::usage = "Translates a natural language commands into a SMRMon-WL pipeline. Obsolete.";

ToLSAMonWLCommand::usage = "Translates a natural language commands into a LSAMon-WL pipeline. Obsolete.";

ToECMMonWLCommand::usage = "Translates a natural language commands into a ECMMon-WL pipeline. Obsolete.";

Begin["`Private`"];

(*===========================================================*)
(* RakuCommand                                              *)
(*===========================================================*)

Clear[RakuCommand];

RakuCommand::nostr = "All arguments are expected to be strings.";

RakuCommand[command_String, moduleDirectory_String, moduleName_String, rakuLocation_String : "/Applications/Rakudo/bin/raku"] :=
    Block[{rakuCommandPart, rakuCommand, pres},
      (*rakuCommandPart=StringJoin["-I\"",moduleDirectory,"\" -M'",
      moduleName,"' -e 'XXXX'"];
      rakuCommand=rakuLocation<>" "<>StringReplace[rakuCommandPart,"XXXX"->
      command];*)
      rakuCommand = {
        rakuLocation,
        StringJoin["-I\"", moduleDirectory, "\""],
        StringJoin["-M'", moduleName, "'"],
        StringJoin["-e \"" <> command <> "\""]
      };
      (*pres=RunProcess[rakuCommand];*)

      rakuCommand = StringRiffle[rakuCommand, " "];

      pres = Import["! " <> rakuCommand, "String"];
      StringReplace[pres, "==>" -> "\[DoubleLongRightArrow]"]
    ];

RakuCommand[___] :=
    Block[{},
      Message[RakuCommand::nostr];
      $Failed
    ];


(*===========================================================*)
(* ToMonadicCommand                                          *)
(*===========================================================*)

Clear[ToMonadicCommand];

SyntaxInformation[ToMonadicCommand] = { "ArgumentsPattern" -> { _, _, OptionsPattern[] } };

ToMonadicCommand::nmon = "Unknown monad name: `1`. The known monad names are `2`.";

Options[ToMonadicCommand] = {
  "Target" -> "WL",
  "Parse" -> Automatic,
  "StringResult" -> Automatic
};

aRakuModules = <|
  "QRMon" -> "QuantileRegressionWorkflows",
  "SMRMon" -> "RecommenderWorkflows",
  "LSAMon" -> "LatentSemanticAnalysisWorkflows",
  "ECMMon" -> "EpidemiologyModelingWorkflows" |>;

ToMonadicCommand[command_, monadName_String, opts : OptionsPattern[] ] :=
    Block[{pres, parseQ, target, stringResultQ, res},

      parseQ = OptionValue[ ToMonadicCommand, "Parse" ];

      target = OptionValue[ ToMonadicCommand, "Target" ];

      stringResultQ = OptionValue[ ToMonadicCommand, "StringResult" ];

      If[ TrueQ[parseQ===Automatic],
        parseQ = If[ target == "WL", True, False, False]
      ];
      parseQ = TrueQ[parseQ];

      If[ TrueQ[stringResultQ===Automatic],
        stringResultQ = If[ target == "WL", False, True, True]
      ];
      stringResultQ = TrueQ[stringResultQ];

      If[ !KeyExistsQ[aRakuModules, monadName],
        Message[ToMonadicCommand::nmon, monadName, Keys[aRakuModules] ];
        Return[$Failed]
      ];

      pres =
          RakuCommand[
            StringJoin["say to_" <> monadName <> "_" <> target <> "('", command, "')"],
            aRakuModules[monadName],
            aRakuModules[monadName]];

      pres = StringReplace[ pres, "\\\"" -> "\""];

      Which[
        parseQ, ToExpression[pres],

        !stringResultQ,
        res = ToExpression[pres, StandardForm, Hold];
        If[ TrueQ[res === $Failed], pres, res],

        True, pres
      ]
    ];


(*===========================================================*)
(* ToQRMonCommand                                            *)
(*===========================================================*)

Clear[ToQRMonCommand];

SyntaxInformation[ToQRMonCommand] = { "ArgumentsPattern" -> { _, OptionsPattern[] } };

Options[ToQRMonCommand] = Options[ToMonadicCommand];

ToQRMonCommand[ command_, opts : OptionsPattern[] ] := ToMonadicCommand[ command, "QRMon", opts];

ToQRMonCommand[___] := $Failed;

(*----*)

Clear[ToQRMonWLCommand];

Options[ToQRMonWLCommand] = Options[ToMonadicCommand];

ToQRMonWLCommand::obs = "Obsolete function; use ToQRMonCommand instead.";

ToQRMonWLCommand[ command_, parse_:True, opts : OptionsPattern[] ] :=
    Block[{},
      Message[ToQRMonWLCommand::obs];
      ToMonadicCommand[ command, "QRMon", Append[ DeleteCases[{opts}, HoldPattern["Parse" -> _] ], "Parse" -> parse ] ]
    ];


(*===========================================================*)
(* ToSMRMonCommand                                           *)
(*===========================================================*)

Clear[ToSMRMonCommand];

SyntaxInformation[ToSMRMonCommand] = { "ArgumentsPattern" -> { _, OptionsPattern[] } };

Options[ToSMRMonCommand] = Options[ToMonadicCommand];

ToSMRMonCommand[ command_, opts : OptionsPattern[] ] := ToMonadicCommand[ command, "SMRMon", opts];

ToSMRMonCommand[___] := $Failed;

(*----*)

Clear[ToSMRMonWLCommand];

Options[ToSMRMonWLCommand] = Options[ToMonadicCommand];

ToSMRMonWLCommand::obs = "Obsolete function; use ToSMRMonCommand instead.";

ToSMRMonWLCommand[ command_, parse_:True, opts : OptionsPattern[] ] :=
    Block[{},
      Message[ToSMRMonWLCommand::obs];
      ToMonadicCommand[ command, "SMRMon", Append[ DeleteCases[{opts}, HoldPattern["Parse" -> _] ], "Parse" -> parse ] ]
    ];


(*===========================================================*)
(* ToLSAMonCommand                                           *)
(*===========================================================*)

Clear[ToLSAMonCommand];

SyntaxInformation[ToLSAMonCommand] = { "ArgumentsPattern" -> { _, OptionsPattern[] } };

Options[ToLSAMonCommand] = Options[ToMonadicCommand];

ToLSAMonCommand[ command_, opts : OptionsPattern[] ] := ToMonadicCommand[ command, "LSAMon", opts];

ToLSAMonCommand[___] := $Failed;

(*----*)

Clear[ToLSAMonWLCommand];

Options[ToLSAMonWLCommand] = Options[ToMonadicCommand];

ToLSAMonWLCommand::obs = "Obsolete function; use ToLSAMonCommand instead.";

ToLSAMonWLCommand[ command_, parse_:True, opts : OptionsPattern[] ] :=
    Block[{},
      Message[ToLSAMonWLCommand::obs];
      ToMonadicCommand[ command, "LSAMon", Append[ DeleteCases[{opts}, HoldPattern["Parse" -> _] ], "Parse" -> parse ] ]
    ];


(*===========================================================*)
(* ToECMMonCommand                                           *)
(*===========================================================*)

Clear[ToECMMonCommand];

SyntaxInformation[ToECMMonCommand] = { "ArgumentsPattern" -> { _, OptionsPattern[] } };

Options[ToECMMonCommand] = Options[ToMonadicCommand];

ToECMMonCommand[ command_, opts : OptionsPattern[] ] :=
    ToMonadicCommand[ command, "ECMMon", opts];

ToECMMonCommand[___] := $Failed;

(*----*)

Clear[ToECMMonWLCommand];

Options[ToECMMonWLCommand] = Options[ToMonadicCommand];

ToECMMonWLCommand::obs = "Obsolete function; use ToECMMonCommand instead.";

ToECMMonWLCommand[ command_, parse_:True, opts : OptionsPattern[] ] :=
    Block[{},
      Message[ToECMMonWLCommand::obs];
      ToMonadicCommand[ command, "ECMMon", Append[ DeleteCases[{opts}, HoldPattern["Parse" -> _] ], "Parse" -> parse ] ]
    ];


End[]; (* `Private` *)

EndPackage[]