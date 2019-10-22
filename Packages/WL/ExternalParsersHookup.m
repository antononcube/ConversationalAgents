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
(* :Discussion: *)

BeginPackage["ExternalParsersHookup`"];
(* Exported symbols added here with SymbolName::usage *)

Perl6Command::usage = "Raku Perl 6 command invocation.";

ToQRMonWLCommand::usage = "Translates a natural language command into a QRMon-WL pipeline.";

ToSMRMonWLCommand::usage = "Translates a natural language command into a SMRMon-WL pipeline.";

Begin["`Private`"];

(*===========================================================*)
(* Perl6Command                                              *)
(*===========================================================*)

Clear[Perl6Command];

Perl6Command::nostr = "All arguments are expected to be strings.";

Perl6Command[command_String, moduleDirectory_String, moduleName_String, perl6Location_String : "/Applications/Rakudo/bin/perl6"] :=
    Block[{p6CommandPart, p6Command, pres},
      (*p6CommandPart=StringJoin["-I\"",moduleDirectory,"\" -M'",
      moduleName,"' -e 'XXXX'"];
      p6Command=perl6Location<>" "<>StringReplace[p6CommandPart,"XXXX"->
      command];*)
      p6Command = {
        perl6Location,
        StringJoin["-I\"", moduleDirectory, "\""],
        StringJoin["-M'", moduleName, "'"],
        StringJoin["-e \"" <> command <> "\""]
      };
      (*pres=RunProcess[p6Command];*)

      p6Command = StringRiffle[p6Command, " "];

      pres = Import["! " <> p6Command, "String"];
      StringReplace[pres, "==>" -> "\[DoubleLongRightArrow]"]
    ];

Perl6Command[___] :=
    Block[{},
      Message[Perl6Command::nostr];
      $Failed
    ];


(*===========================================================*)
(* ToQRMonWLCommand                                          *)
(*===========================================================*)

Clear[ToQRMonWLCommand];

Options[ToQRMonWLCommand] = {
  "Perl6QRMonParsingLib" -> FileNameJoin[{"/", "Volumes", "Macintosh HD", "Users", "antonov", "ConversationalAgents", "Packages", "Perl6", "QuantileRegressionWorkflows", "lib"}],
  "StringResult" -> False
};

ToQRMonWLCommand[command_, parse : (True | False) : True, opts : OptionsPattern[] ] :=
    Block[{pres, lib, stringResultQ},

      lib = OptionValue[ ToQRMonWLCommand, "Perl6QRMonParsingLib" ];
      stringResultQ = TrueQ[ OptionValue[ ToQRMonWLCommand, "StringResult" ] ];

      pres =
          Perl6Command[
            StringJoin["say to_QRMon_WL('", command, "')"],
            lib,
            "QuantileRegressionWorkflows"];

      Which[
        parse, ToExpression[pres],

        !stringResultQ, ToExpression[pres, StandardForm, Hold],

        True, pres
      ]
    ];


(*===========================================================*)
(* ToSMRMonWLCommand                                         *)
(*===========================================================*)

Clear[ToSMRMonWLCommand];

Options[ToSMRMonWLCommand] = {
  "Perl6SMRMonParsingLib" -> FileNameJoin[{"/", "Volumes", "Macintosh HD", "Users", "antonov", "ConversationalAgents", "Packages", "Perl6", "RecommenderWorkflows", "lib"}],
  "StringResult" -> False
};

ToSMRMonWLCommand[command_, parse : (True | False) : True, opts : OptionsPattern[] ] :=
    Block[{pres, lib, stringResultQ},

      lib = OptionValue[ ToSMRMonWLCommand, "Perl6SMRMonParsingLib" ];
      stringResultQ = TrueQ[ OptionValue[ ToSMRMonWLCommand, "StringResult" ] ];

      pres =
          Perl6Command[
            StringJoin["say to_SMRMon_WL('", command, "')"],
            lib,
            "RecommenderWorkflows"];

      pres = StringReplace[ pres, "\\\"" -> "\""];

      Which[
        parse, ToExpression[pres],

        !stringResultQ, ToExpression[pres, StandardForm, Hold],

        True, pres
      ]
    ];

End[]; (* `Private` *)

EndPackage[]