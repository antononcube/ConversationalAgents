(*
    OpenAI-Raku Mode Mathematica package

    BSD 3-Clause License

    Copyright (c) 2023, Anton Antonov
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
    ʇǝu˙oǝʇsod@ǝqnɔuouoʇuɐ,
    Windermere, Florida, USA.
*)

(*
    Mathematica is (C) Copyright 1988-2023 Wolfram Research, Inc.

    Protected by copyright law and international treaties.

    Unauthorized reproduction or distribution subject to severe civil
    and criminal penalties.

    Mathematica is a registered trademark of Wolfram Research, Inc.
*)

(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)

(* :Title: OpenAIRakuMode *)
(* :Context: OpenAIRakuMode` *)
(* :Author: Anton Antonov *)
(* :Date: 2021-05-28 *)

(* :Package Version: 1.0 *)
(* :Mathematica Version: 13.2 *)
(* :Copyright: (c) 2023 Anton Antonov *)
(* :Keywords: OpenAI, ChatGPT, Raku, Perl6, style, options, notebook, WL *)
(* :Discussion:


*)


(***********************************************************)
(* Load packages                                           *)
(***********************************************************)

If[ Length[DownValues[RakuCommand`RakuCommand]] == 0,
  Echo["RakuCommand.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/Packages/WL/RakuCommand.m"];
];

If[ Length[DownValues[RakuMode`StartRakuProcess]] == 0,
  Echo["RakuMode.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/Packages/WL/RakuMode.m"];
];

Needs["AntonAntonov`OpenAIMode`"];

(***********************************************************)
(* Package definitions                                     *)
(***********************************************************)

BeginPackage["OpenAIRakuMode`"];

OpenAIRakuMode::usage = "Restyle notebooks to use the OpenAI and Raku external execution themes.";

CellPrintRaku::usage = "CellPrintRaku[s_String]";

CellPrintAndRunRaku::usage = "CellPrintAndRunRaku[s_String]";

Begin["`Private`"];

Needs["AntonAntonov`OpenAIMode`"];
Needs["OpenAIRakuMode`"];

(***********************************************************)
(* Input execution                                         *)
(***********************************************************)

nbOpenAIRakuStyle =
    With[{
      nbOpenAIMode = Sequence @@ Cases[AntonAntonov`OpenAIMode`OpenAIModeNotebookStyle[], Cell[StyleData[x_String], ___] /; StringStartsQ[x, "OpenAI"], Infinity],
      nbRakuMode = Sequence @@ Cases[RakuMode`RakuModeNotebookStyle[], Cell[StyleData[x_String], ___] /; StringStartsQ[x, "Raku"], Infinity]
    },

      Notebook[{
        Cell[StyleData[StyleDefinitions -> "Default.nb"]],

        Cell[StyleData["Input"],
          StyleKeyMapping -> {
            "?" -> "OpenAIInputExecuteToText",
            "|" -> "RakuInputExecute",
            "=" -> "WolframAlphaShort",
            ">" -> "ExternalLanguage",
            "Tab" -> "RakuInputExecute"}],

        nbOpenAIMode,

        nbRakuMode,

        Cell[StyleData["Code"],
          MenuSortingValue -> 10000,
          MenuCommandKey :> None
        ]
      },
        WindowSize -> {857, 887},
        WindowMargins -> {{373, Automatic}, {Automatic, 219}},
        FrontEndVersion -> "12.3.0 for Mac OS X x86 (64-bit) (May 10, 2021)",
        StyleDefinitions -> "PrivateStylesheetFormatting.nb"
      ]
    ];


(***********************************************************)
(* Notebook style                                          *)
(***********************************************************)

Clear[OpenAIRakuModeNotebookStyle];
OpenAIRakuModeNotebookStyle[] := nbOpenAIRakuStyle;

(***********************************************************)
(* OpenAIRakuMode function                                 *)
(***********************************************************)

Clear[OpenAIRakuMode] ;
OpenAIRakuMode[True] = OpenAIRakuMode[];

OpenAIRakuMode[] := OpenAIRakuMode[EvaluationNotebook[]];

OpenAIRakuMode[nb_NotebookObject, True] := OpenAIRakuMode[nb];

OpenAIRakuMode[nb_NotebookObject] :=
    Block[{},
      If[ Length[DownValues[RakuCommand`RakuCommand]] == 0,
        Echo["RakuCommand.m", "Importing from GitHub:"];
        Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/Packages/WL/RakuCommand.m"];
      ];
      SetOptions[nb, StyleDefinitions -> BinaryDeserialize[BinarySerialize[nbOpenAIRakuStyle]]]
    ];

OpenAIRakuMode[ False] := SetOptions[EvaluationNotebook[], StyleDefinitions -> "Default.nb"];

OpenAIRakuMode[nb_NotebookObject, False] := SetOptions[nb, StyleDefinitions -> "Default.nb"];

(***********************************************************)
(* Cell print                                              *)
(***********************************************************)

Clear[CellPrintRaku];
CellPrintRaku[s_String] :=
    NotebookWrite[EvaluationNotebook[], Cell[s, "RakuInputExecute"]];

Clear[CellPrintAndRunRaku];
CellPrintAndRunRaku[s_String] := (
  NotebookWrite[EvaluationNotebook[], Cell[s, "RakuInputExecute"], All];
  SelectionEvaluateCreateCell[EvaluationNotebook[]]
);


End[]; (* `Private` *)

EndPackage[]