(*
    OpenAI Mode Mathematica package

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
    Mathematica is (C) Copyright 1988-2021 Wolfram Research, Inc.

    Protected by copyright law and international treaties.

    Unauthorized reproduction or distribution subject to severe civil
    and criminal penalties.

    Mathematica is a registered trademark of Wolfram Research, Inc.
*)

(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)

(* :Title: OpenAIMode *)
(* :Context: OpenAIMode` *)
(* :Author: Anton Antonov *)
(* :Date: 2023-04-01 *)

(* :Package Version: 1.0 *)
(* :Mathematica Version: 13.2 *)
(* :Copyright: (c) 2023 Anton Antonov *)
(* :Keywords: OpenAI, ChatGPT, OpenAILink, style, options, notebook, WL *)
(* :Discussion:

For the icon derivation see the explanations in the package "HexCameliaIcons.m":

  https://github.com/antononcube/ConversationalAgents/blob/master/Packages/WL/HexCameliaIcons.m

*)


(***********************************************************)
(* Package definitions                                     *)
(***********************************************************)

BeginPackage["OpenAIMode`"];

OpenAIMode::usage = "Restyle notebooks to use the OpenAI external execution theme.";

OpenAIInputExecute::usage = "Umbrella execution function for OpenAILink functions. \
Used OpenAIInputExecuteToText and OpenAIInputExecuteToImage.";

OpenAIInputExecuteToText::usage = "Execution function for the cell style \"OpenAIInputExecuteToText\".";

OpenAIInputExecuteToImage::usage = "Execution function for the cell style \"OpenAIInputExecuteToImage\".";

(* OpenAICellPrompt::usage = "Controls the display of functionality hint on top or bottom of OpenAI cells.";*)

DeleteCells::usage = "Delete cells of a specified style.";

Begin["`Private`"];

Needs["ChristopherWolfram`OpenAILink`"];

cellPromptQ = False;
cellPromptTopQ = True;

Clear[OpenAICellPrompt];

OpenAICellPrompt[] := OpenAICellPrompt[True, Top];

OpenAICellPrompt[should : (True | False)] := OpenAICellPrompt[should, Top];

OpenAICellPrompt[should : (True | False), location : (Bottom | Top)] :=
    Block[{},
      cellPromptQ = TrueQ[should];
      cellPromptTopQ = If[ TrueQ[location] === Bottom, False, True];
    ];

(***********************************************************)
(* Input execution                                         *)
(***********************************************************)

nnOpenAIStyle =
    Notebook[{
      Cell[StyleData[StyleDefinitions -> "Default.nb"]],

      Cell[StyleData["Input"],
        StyleKeyMapping -> {
          "|" -> "OpenAIInputExecuteToText",
          "=" -> "WolframAlphaShort",
          ">" -> "ExternalLanguage",
          "Tab" -> "OpenAIInputExecuteToText"}],

      Cell[StyleData["OpenAIInputExecuteToText"],
        CellFrame -> True,
        CellMargins -> {{66, 10}, {5, 10}},
        StyleKeyMapping -> {"Tab" -> "OpenAIInputExecuteToImage"},
        Evaluatable -> True,
        CellEvaluationFunction -> (OpenAIMode`OpenAIInputExecuteToText[ToString[#1], Options[OpenAIMode`OpenAIInputExecuteToText]] &),
        CellFrameColor -> GrayLevel[0.92],
        CellFrameLabels -> {{Cell[BoxData[rbOpenAI]], None}, {None, None}},
        AutoQuoteCharacters -> {}, FormatType -> InputForm,
        MenuCommandKey :> "8", FontFamily -> "Courier",
        FontWeight -> Bold, Magnification -> 1.15` Inherited,
        FontColor -> GrayLevel[0.4], Background -> RGBColor[0.97, 1, 0.95]
      ],

      Cell[StyleData["OpenAIInputExecuteToText", "SlideShow"], FontSize -> 20],

      Cell[StyleData["OpenAIInputExecuteToImage"], CellFrame -> True,
        CellMargins -> {{66, 10}, {5, 10}},
        StyleKeyMapping -> {"Tab" -> "OpenAIInputExecuteToText"}, Evaluatable -> True,
        CellEvaluationFunction -> (OpenAIMode`OpenAIInputExecuteToImage[ToString[#1], Options[OpenAIMode`OpenAIInputExecuteToImage]] &),
        CellFrameColor -> GrayLevel[0.97],
        CellFrameLabels -> {{Cell[BoxData[rbOpenAI]], None}, {None, None}},
        FormatType -> InputForm, FontFamily -> "Courier",
        FontWeight -> Bold, Magnification -> 1.15` Inherited,
        FontColor -> GrayLevel[0.4], Background -> RGBColor[0.97, 0.97, 1]
      ],

      Cell[StyleData["OpenAIInputExecuteToImage", "SlideShow"], FontSize -> 20],

      Cell[StyleData["Code"],
        MenuSortingValue -> 10000,
        MenuCommandKey :> None
      ]
    },
      WindowSize -> {857, 887},
      WindowMargins -> {{373, Automatic}, {Automatic, 219}},
      FrontEndVersion -> "13.2.1 for Mac OS X ARM (64-bit) (January 27, 2023)",
      StyleDefinitions -> "PrivateStylesheetFormatting.nb"
    ];


(***********************************************************)
(* Input execution                                         *)
(***********************************************************)

Clear[FullFunctionName];
FullFunctionName[func_Symbol] :=
    Which[
      MemberQ[{OpenAITextComplete, "OpenAITextComplete"}, func],
      ChristopherWolfram`OpenAILink`OpenAITextComplete,

      MemberQ[{OpenAIGenerateImage, "OpenAIGenerateImage"}, func],
      ChristopherWolfram`OpenAILink`OpenAIGenerateImage

      _,
      ChristopherWolfram`OpenAILink`OpenAITextComplete
    ];

Clear[OpenAIInputExecute];
Options[OpenAIInputExecute] = {
  Function -> OpenAITextComplete,
  Epilog -> Identity,
  OpenAIKey :> $OpenAIKey,
  OpenAIUser :> $OpenAIUser,
  OpenAIModel -> Automatic,
  OpenAITemperature -> Automatic,
  OpenAITopProbability -> Automatic,
  OpenAITokenLimit -> Automatic,
  OpenAIStopTokens -> Automatic,
  ImageSize -> Automatic
};

OpenAIInputExecute[boxData_String, opts : OptionsPattern[]] :=
    Block[{epilogFunc = OptionValue[OpenAIInputExecute, Epilog],
      func = OptionValue[OpenAIInputExecute, Function]},
      epilogFunc @ func[boxData, FilterRules[{opts}, Options[func]]]
    ];

(***********************************************************)
(* Delegation of execution                                 *)
(***********************************************************)

Clear[OpenAIInputExecuteToText];
Options[OpenAIInputExecuteToText] = Options[ChristopherWolfram`OpenAILink`OpenAITextComplete];
OpenAIInputExecuteToText[boxData_String, opts : OptionsPattern[]] :=
    OpenAIInputExecute[boxData, Function -> ChristopherWolfram`OpenAILink`OpenAITextComplete, opts];

Clear[OpenAIInputExecuteToImage];
Options[OpenAIInputExecuteToImage] = Options[ChristopherWolfram`OpenAILink`OpenAIGenerateImage];
OpenAIInputExecuteToImage[boxData_String, opts : OptionsPattern[]] :=
    OpenAIInputExecute[boxData, Function -> ChristopherWolfram`OpenAILink`OpenAIGenerateImage, opts];

(***********************************************************)
(* OpenAIMode function                                       *)
(***********************************************************)

Clear[OpenAIMode] ;
Options[OpenAIMode] := {"CellPrompt" -> False, "CellPromptLocation" -> Top};

OpenAIMode[True] := OpenAIMode[];

OpenAIMode[] := OpenAIMode[EvaluationNotebook[]];

OpenAIMode[nb_NotebookObject, True] := OpenAIMode[nb];

OpenAIMode[nb_NotebookObject] :=
    Block[{},
      (*It does not seem to have effect*)
      (*OpenAICellPrompt[OptionValue[OpenAIMode, "CellPrompt"], OptionValue[OpenAIMode, "CellPromptLocation"]];*)
      SetOptions[nb, StyleDefinitions -> BinaryDeserialize[BinarySerialize[nnOpenAIStyle]]]
    ];

OpenAIMode[False] := SetOptions[EvaluationNotebook[], StyleDefinitions -> "Default.nb"];

OpenAIMode[nb_NotebookObject, False] := SetOptions[nb, StyleDefinitions -> "Default.nb"];


(***********************************************************)
(* Icon                                                    *)
(***********************************************************)

rbOpenAI =
      GraphicsBox[
        TagBox[RasterBox[CompressedData["
1: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
EiF/RTSMCrfOX8lP+AnRLjLcPpf4Z77P0KwiJFqoO9wDolGU5Pq0JnuOaBMt
mTZtqV4hWkRMoktPpjM0e8iJU+kINIBoDgNRJtVhhhGN4SDHozTJHKItPIRY
lMWYR7ODjQSLogw1RDv4cDsUvN9BtIIRr0H26000E5jxCWS+DEEzgB2PP9qr
MET6A9Dro7wIRiQ/ArE8+HMMNOZTEJpDPsVDYj0KjTjQK3QkysPgW+u/IEKh
OxGuM9Q6fPimc6EJA29EhK04HY4uylQUqHJXAW+KvBoMktAlQUoSTtgCLnHz
AfewY7gtXRj3tCO4HV0Z97YjuB1dGve457gNXRv3uue4DV0c97xnuP1cHvfA
r3HbuT7uhV/jtnMD3BO/wu3mFrhHPsZt5ia4Zz7C7eUuuHc+wu3lNriHfo7b
yo1wT/0Mt5Nb4R77EbeRm+Ge+y1uH3fDvfdb3D5uh3vwL3HbuCHuyT/H7eKW
uEf/hNvETXHP/hG3h9viHv4Dbgs3xj39e9wObo17/D2/mb3+3dnz35w9/83Z
89+cPf/N2evfnT3/zdnz3529/s3Z89+dvf7d2evfnD3/3dnr3529/t3Z69+d
vf7t2ePfnb3+7dnj3549/mZvv9nbb04+Ane6jZA9+maz2Ww2m81ms9lsNpsr
8F+5aLRB
    "], {{0, 512.}, {512., 0}}, {0, 255},
          ColorFunction->GrayLevel],
          BoxForm`ImageTag["Byte", ColorSpace -> "Grayscale", Interleaving -> None],
          Selectable->False],
        DefaultBaseStyle->"ImageGraphics",
        ImageSizeRaw->{22., 22.},
        PlotRange->{{0, 512.}, {0, 512.}}];



End[]; (* `Private` *)

EndPackage[]