(*
    DSL Mode Mathematica package

    BSD 3-Clause License

    Copyright (c) 2020, Anton Antonov
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
    Mathematica is (C) Copyright 1988-2020 Wolfram Research, Inc.

    Protected by copyright law and international treaties.

    Unauthorized reproduction or distribution subject to severe civil
    and criminal penalties.

    Mathematica is a registered trademark of Wolfram Research, Inc.
*)

(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)

(* :Title: DSLMode *)
(* :Context: DSLMode` *)
(* :Author: Anton Antonov *)
(* :Date: 2020-09-15 *)

(* :Package Version: 1.0 *)
(* :Mathematica Version: 12.1 *)
(* :Copyright: (c) 2020 Anton Antonov *)
(* :Keywords: DSL, style, options, notebook, WL *)
(* :Discussion: *)


(***********************************************************)
(* Load packages                                           *)
(***********************************************************)

If[ Length[DownValues[ExternalParsersHookup`ToDSLCode]] == 0,
  Echo["ExternalParsersHookup.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/Packages/WL/ExternalParsersHookup.m"];
];

(***********************************************************)
(* Package definitions                                     *)
(***********************************************************)

BeginPackage["DSLMode`"];

DSLMode::usage = "Restyle notebooks to use the DSL theme.";

DSLInputExecute::usage = "Execution function for the cell style \"DSLInputExecute\".";

DSLInputParse::usage = "Execution function for the cell style \"DSLInputParse\".";

DeleteCells::usage = "Delete cells of a specified style.";

Begin["`Private`"];

Clear[DSLInputExecute];
Options[DSLInputExecute] = {Method -> "Execute"};
DSLInputExecute[boxData_String, opts : OptionsPattern[]] := ExternalParsersHookup`ToDSLCode[boxData, Sequence @@ Options @ DSLInputExecute];

Clear[DSLInputParse];
Options[DSLInputParse] = {Method -> "Print"};
DSLInputParse[boxData_String, opts : OptionsPattern[]] := ExternalParsersHookup`ToDSLCode[boxData, Sequence @@ Options @ DSLInputParse];

nbDSLStyle =
    Notebook[{
      Cell[StyleData[StyleDefinitions -> "Default.nb"]],

      Cell[StyleData["Input"],
        StyleKeyMapping -> {
          "=" -> "WolframAlphaShort",
          "*" -> "DSLInputParse",
          ">" -> "ExternalLanguage",
          "Tab" -> "DSLInputExecute"}],

      Cell[StyleData["DSLInputExecute"],
        CellFrame -> True,
        CellMargins -> {{66, 10}, {5, 10}},
        StyleKeyMapping -> {"Tab" -> "DSLInputParse"},
        Evaluatable -> True,
        CellEvaluationFunction -> (DSLMode`DSLInputExecute[ToString[#1], Options[DSLMode`DSLInputExecute]] &),
        CellFrameColor -> GrayLevel[0.92],
        CellFrameLabels -> {{"DSL", None}, {None, None}},
        AutoQuoteCharacters -> {}, FormatType -> InputForm,
        MenuCommandKey :> "8", FontFamily -> "Courier",
        FontWeight -> Bold, Magnification -> 1.15` Inherited,
        FontColor -> GrayLevel[0.4], Background -> RGBColor[1, 1, 0.97]
      ],

      Cell[StyleData["DSLInputParse"], CellFrame -> True,
        CellMargins -> {{66, 10}, {5, 10}},
        StyleKeyMapping -> {"Tab" -> "Input"}, Evaluatable -> True,
        CellEvaluationFunction -> (DSLMode`DSLInputParse[ToString[#1], Options[DSLMode`DSLInputParse]] &),
        CellFrameColor -> GrayLevel[0.97],
        CellFrameLabels -> {{Cell[BoxData[StyleBox["DSL", FontSlant -> "Italic"]]], None}, {None, None}}, AutoQuoteCharacters -> {},
        FormatType -> InputForm, FontFamily -> "Courier",
        FontWeight -> Bold, Magnification -> 1.15` Inherited,
        FontColor -> GrayLevel[0.4], Background -> RGBColor[0.97, 1, 1]
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

Clear[DSLMode] ;
DSLMode[True] = DSLMode[];

DSLMode[] := DSLMode[EvaluationNotebook[]];

DSLMode[nb_NotebookObject, True] := DSLMode[nb];

DSLMode[nb_NotebookObject] :=
    Block[{},
      If[Length[
        DownValues[ExternalParsersHookup`ToDSLCode]] == 0,
        Echo["ExternalParsersHookup.m", "Importing from GitHub:"];
        Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/Packages/WL/ExternalParsersHookup.m"]
      ];
      SetOptions[nb, StyleDefinitions -> BinaryDeserialize[BinarySerialize[nbDSLStyle]]]
    ];

DSLMode[ False] := SetOptions[EvaluationNotebook[], StyleDefinitions -> "Default.nb"];

DSLMode[nb_NotebookObject, False] := SetOptions[nb, StyleDefinitions -> "Default.nb"];


Clear[DeleteCells];
DeleteCells[style_String] := NotebookDelete[Cells[CellStyle -> style]];
DeleteCells[] := DeleteCells["Output"];

End[]; (* `Private` *)

EndPackage[]