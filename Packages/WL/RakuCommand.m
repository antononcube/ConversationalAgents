(*
    Raku Command Mathematica package

    BSD 3-Clause License

    Copyright (c) 2021, Anton Antonov
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this
      list of conditions and the following disclaimer.

    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

    * Neither the name of the copyright holder nor the names of its
      contributors may be used to endorse or promote products derived from
      this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
    SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
    OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

    Written by Anton Antonov,
    antononcube @@ @ poste o .. .. n e t,
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

(* :Title: RakuCommand *)
(* :Context: RakuCommand` *)
(* :Author: Anton Antonov *)
(* :Date: 2021-05-28 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: 12.1 *)
(* :Copyright: (c) 2021 Anton Antonov *)
(* :Keywords: raku, command line interface, command line, CLI, perl6 *)
(* :Discussion: *)

BeginPackage["RakuCommand`"];

RakuCommand::usage = "Raku (Perl 6) command invocation.";

Begin["`Private`"];

(*===========================================================*)
(* RakuCommand                                              *)
(*===========================================================*)

Clear[RakuCommand];

RakuCommand::nostr = "All arguments are expected to be strings.";

RakuCommand[command_String, moduleDirectory_String, moduleName_String, rakuLocation_String : "/Applications/Rakudo/bin/raku"] :=
    RakuCommand[command, moduleDirectory, {moduleName}, rakuLocation];

RakuCommand[command_String, moduleDirectory_String, moduleNamesArg : {_String ..}, rakuLocation_String : "/Applications/Rakudo/bin/raku"] :=
    Block[{moduleNames = moduleNamesArg, rakuCommand, aRes, pres},
      (*rakuCommandPart=StringJoin["-I\"",moduleDirectory,"\" -M'",
      moduleName,"' -e 'XXXX'"];
      rakuCommand=rakuLocation<>" "<>StringReplace[rakuCommandPart,"XXXX"->
      command];*)
      moduleNames = Select[StringTrim[moduleNames], StringLength[#] > 0 &];

      If[ Length[moduleNames] > 0,
        rakuCommand = Join[ {rakuLocation, "-I", moduleDirectory, "-M"}, Riffle[moduleNames, "-M"], {"-e", command}],
        (*ELSE*)
        rakuCommand = {rakuLocation, "-I", moduleDirectory, "-e", command}
      ];

      (*
      rakuCommand = StringRiffle[rakuCommand, " "];
      pres = Import["! " <> rakuCommand, "String"];
      *)

      aRes = RunProcess[rakuCommand];

      If[ aRes["ExitCode" ] != 0 || StringLength[ aRes["StandardError"] ] > 0,
        Echo[StringTrim @ aRes["StandardError"], "RunProcess stderr:"];
      ];

      pres = aRes["StandardOutput"]
    ];

RakuCommand[___] :=
    Block[{},
      Message[RakuCommand::nostr];
      $Failed
    ];

End[]; (* `Private` *)

EndPackage[]