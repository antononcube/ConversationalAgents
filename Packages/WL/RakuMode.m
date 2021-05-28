(*
    Raku Mode Mathematica package

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
    antononcube @ gmail . com,
    Windermere, Florida, USA.
*)

(*
    Mathematica is (C) Copyright 1988-2021 Wolfram Research, Inc.

    Protected by copyright law and international treaties.

    Unauthorized reproduction or distribution subject to severe civil
    and criminal penalties.

    Mathematica is a registered trademark of Wolfram Research, Inc.
*)

(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)

(* :Title: RakuMode *)
(* :Context: RakuMode` *)
(* :Author: Anton Antonov *)
(* :Date: 2020-09-15 *)

(* :Package Version: 1.0 *)
(* :Mathematica Version: 12.1 *)
(* :Copyright: (c) 2021 Anton Antonov *)
(* :Keywords: Raku, Perl6, style, options, notebook, WL *)
(* :Discussion: *)


(***********************************************************)
(* Load packages                                           *)
(***********************************************************)

If[ Length[DownValues[RakuCommand`RakuCommand]] == 0,
  Echo["RakuCommand.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/Packages/WL/RakuCommand.m"];
];

(***********************************************************)
(* Package definitions                                     *)
(***********************************************************)

BeginPackage["RakuMode`"];

RakuMode::usage = "Restyle notebooks to use the Raku external execution theme.";

RakuInputExecute::usage = "Execution function for the cell style \"RakuInputExecute\".";

DeleteCells::usage = "Delete cells of a specified style.";

Begin["`Private`"];

Clear[RakuInputExecute];
Options[RakuInputExecute] = {"ModuleDirectory" -> "", "ModuleName" -> ""};
RakuInputExecute[boxData_String, opts : OptionsPattern[]] :=
    RakuCommand`RakuCommand[boxData, OptionValue[RakuInputExecute, "ModuleDirectory"], OptionValue[RakuInputExecute, "ModuleName"]];

nbRakuStyle =
    Notebook[{
      Cell[StyleData[StyleDefinitions -> "Default.nb"]],

      Cell[StyleData["Input"],
        StyleKeyMapping -> {
          "|" -> "RakuInputExecute",
          "=" -> "WolframAlphaShort",
          ">" -> "ExternalLanguage",
          "Tab" -> "RakuInputExecute"}],

      Cell[StyleData["RakuInputExecute"], CellFrame -> True,
        CellMargins -> {{66, 10}, {5, 10}},
        StyleKeyMapping -> {"Tab" -> "Input"}, Evaluatable -> True,
        CellEvaluationFunction -> (RakuInputExecute[ToString[#1], Options[RakuMode'RakuInputExecute]]&),
        CellFrameColor -> GrayLevel[0.97],
        CellFrameLabels -> {{Cell[BoxData[StyleBox["Raku", FontWeight -> "Bold"]]], None}, {None, None}}, AutoQuoteCharacters -> {},
        FormatType -> InputForm, FontFamily -> "Courier",
        FontWeight -> Bold, Magnification -> 1.15` Inherited,
        FontColor -> GrayLevel[0.4], Background -> RGBColor[1, 1, 0.95]
      ],

      Cell[StyleData["Code"],
        MenuSortingValue -> 10000,
        MenuCommandKey :> None
      ]
    },
      WindowSize -> {857, 887},
      WindowMargins -> {{373, Automatic}, {Automatic, 219}},
      FrontEndVersion -> "12.1 for Mac OS X x86 (64-bit) (June 19, 2020)",
      StyleDefinitions -> "PrivateStylesheetFormatting.nb"
    ];

Clear[RakuMode] ;
RakuMode[True] = RakuMode[];

RakuMode[] := RakuMode[EvaluationNotebook[]];

RakuMode[nb_NotebookObject, True] := RakuMode[nb];

RakuMode[nb_NotebookObject] :=
    Block[{},
      If[ Length[DownValues[RakuCommand`RakuCommand]] == 0,
        Echo["RakuCommand.m", "Importing from GitHub:"];
        Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/Packages/WL/RakuCommand.m"];
      ];
      SetOptions[nb, StyleDefinitions -> BinaryDeserialize[BinarySerialize[nbRakuStyle]]]
    ];

RakuMode[ False] := SetOptions[EvaluationNotebook[], StyleDefinitions -> "Default.nb"];

RakuMode[nb_NotebookObject, False] := SetOptions[nb, StyleDefinitions -> "Default.nb"];

End[]; (* `Private` *)

EndPackage[]