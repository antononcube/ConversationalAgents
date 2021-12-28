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
    antononcube@posteo.net,
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
(* :Date: 2021-05-28 *)

(* :Package Version: 1.0 *)
(* :Mathematica Version: 12.1 *)
(* :Copyright: (c) 2021 Anton Antonov *)
(* :Keywords: Raku, Perl6, style, options, notebook, WL *)
(* :Discussion:

For the icon derivation see the explanations in the package "HexCameliaIcons.m":

  https://github.com/antononcube/ConversationalAgents/blob/master/Packages/WL/HexCameliaIcons.m

*)


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

$RakuZMQSocket::usage = "Raku ZMQ socket.";

$RakuProcess::usage = "Raku process.";

KillRakuProcess::usage = "Kill the process assigned to $RakuProcess";

KillRakuSockets::usage = "Kill the Raku (ZMQ) sockets found by the Shell command: 'ps -ax | grep -i \"raku.*zmq\"'.";

StartRakuProcess::usage = "Start Raku with a ZMQ sockets and assign the process to $RakuProcess";

RakuMode::usage = "Restyle notebooks to use the Raku external execution theme.";

RakuInputExecute::usage = "Execution function for the cell style \"RakuInputExecute\".";

DeleteCells::usage = "Delete cells of a specified style.";

Begin["`Private`"];

(***********************************************************)
(* Icon                                                    *)
(***********************************************************)

rbCameliaHex24 = GraphicsBox[
  TagBox[RasterBox[CompressedData["
1:eJxlUs1PE0EUbzx59Gjiyf/CEwkHo4STNXryArE0Xrak7e7sV7czb5f4Qe1F
D3LAr0CNVRsbtGiIVMUQhRgNxUI0QqIBaf0CjdBadp+zXWLc9Ze8yZu8+b2Z
9/vN/t5YuG9XKBRK7OZLuId0xuM9ytE9fHNMSJyKCpGTXUIyEo3ED/S6x/by
2McD0cH660pl/tVXngXg/M72S6IUu2gHSzY+JRYAWGSG5z4OblhpysGMs7/8
LR2nIINbokBKAdoP6oEBtTZ9NHuHxVRZKG633DZteHeZBqNMGx67h3bTT8MX
MjA9+3mqPHF/Zr356croyOjVcfeM03p7xjDFhUyfLhFxyRlKqIqiioto2/gk
CYyMzHWeOM8GtMt1jc8Ipn6h5eC6mWY0tSQe7EqaqhGfLRJoTzKNWCDA5Juz
HUe6w7ncjWsTKxprCzCwsaryLG2+ix4+RCZLD4urJU8BIB+/AZcJxDvTHcfv
lsYKUx90Txo5h/hYMrkS8oKkjOdv579c35GN1tFpZpV0iiae1Z4vVudWKsTt
QkF64D5+3hocPH2pgY1H5XI5k6LAi6nMZlurxlZjaxvtfIxIksGMc8u12tpP
n9cZwwTgaupr/1rGyTa+9GaVb3E3nICnQxr/CBS+//d9bFwWRYkIkwGrPbyv
VN9UW385fwDg3Pmk
    "], {{0, 24.}, {27., 0}}, {0, 255},
    ColorFunction -> GrayLevel,
    ImageResolution -> 72.],
    BoxForm`ImageTag["Byte", ColorSpace -> "Grayscale", Interleaving -> None],
    Selectable -> False],
  DefaultBaseStyle -> "ImageGraphics",
  ImageSizeRaw -> {27., 24.},
  PlotRange -> {{0, 27.}, {0, 24.}}
];


(***********************************************************)
(* Input execution                                         *)
(***********************************************************)

nbRakuStyle =
    Notebook[{
      Cell[StyleData[StyleDefinitions -> "Default.nb"]],

      Cell[StyleData["Input"],
        StyleKeyMapping -> {
          "|" -> "RakuInputExecute",
          "=" -> "WolframAlphaShort",
          ">" -> "ExternalLanguage",
          "Tab" -> "RakuInputExecute"}],

      Cell[StyleData["RakuInputExecute"],
        CellFrame -> True,
        CellMargins -> {{66, 10}, {5, 10}},
        StyleKeyMapping -> {"Tab" -> "Input"},
        Evaluatable -> True,
        CellEvaluationFunction -> (RakuMode`RakuInputExecute[#1, Options[RakuMode`RakuInputExecute]]&),
        CellFrameColor -> GrayLevel[0.85],
        (* CellFrameLabels -> {{Cell[BoxData[StyleBox["Raku", FontWeight -> "Bold"]]], None}, {None, None}}, *)
        CellFrameLabels -> {{Cell[BoxData[rbCameliaHex24]], None}, {None, None}},
        AutoQuoteCharacters -> {},
        FormatType -> InputForm,
        FontFamily -> "Courier",
        FontWeight -> Bold,
        Magnification -> 1.15` Inherited,
        FontColor -> GrayLevel[0.4],
        Background -> RGBColor[0.976471, 0.964706, 0.960784, 1],
        IgnoreSpellCheck -> True
      ],

      Cell[StyleData["RakuInputExecute", "SlideShow"], FontSize -> 20],

      Cell[StyleData["Code"],
        MenuSortingValue -> 10000,
        MenuCommandKey :> None
      ]
    },
      WindowSize -> {857, 887},
      WindowMargins -> {{373, Automatic}, {Automatic, 219}},
      FrontEndVersion -> "12.3.0 for Mac OS X x86 (64-bit) (May 10, 2021)",
      StyleDefinitions -> "PrivateStylesheetFormatting.nb"
    ];


(***********************************************************)
(* Input execution                                         *)
(***********************************************************)

Clear[RakuInputExecute];
Options[RakuInputExecute] = {"ModuleDirectory" -> "", "ModuleName" -> "", "Process" -> Automatic, Epilog -> Identity};
RakuInputExecute[boxData_String, opts : OptionsPattern[]] :=
    Block[{proc, ff, epilogFunc = OptionValue[RakuInputExecute, Epilog]},

      proc = OptionValue[RakuInputExecute, "Process"];
      If[ TrueQ[proc === Automatic], proc = $RakuProcess];

      If[ TrueQ[ Head[proc] === ProcessObject ] && ProcessStatus[proc] == "Running",
        ff = FullForm[boxData];
        ff = ToExpression@StringReplace[ToString[ff], "\\\\" -> "\\"];
        BinaryWrite[$RakuZMQSocket, StringToByteArray[ff, $SystemCharacterEncoding]];
        epilogFunc @ ByteArrayToString[SocketReadMessage[$RakuZMQSocket]],
        (* ELSE *)
        epilogFunc @ RakuCommand`RakuCommand[boxData, OptionValue[RakuInputExecute, "ModuleDirectory"], OptionValue[RakuInputExecute, "ModuleName"]]
      ]
    ];


(***********************************************************)
(* RakuMode function                                       *)
(***********************************************************)

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


(***********************************************************)
(* Raku process functions                                  *)
(***********************************************************)

Clear[StartRakuProcess];

Options[StartRakuProcess] = {
  "Raku" -> "/Applications/Rakudo/bin/raku",
  "URL" -> "tcp://127.0.0.1",
  "Port" -> "5555",
  "OutputPrompt" -> "",
  "ErrorPrompt" -> "#ERROR: "};

StartRakuProcess[opts : OptionsPattern[]] :=
    Block[{raku, url, port, aPars},

      raku = OptionValue[StartRakuProcess, "Raku"];
      url = OptionValue[StartRakuProcess, "URL"];
      port = ToString[OptionValue[StartRakuProcess, "Port"]];

      aPars = <|
        "URL" -> url,
        "Port" -> port,
        "OutputPrompt" -> OptionValue[StartRakuProcess, "OutputPrompt"],
        "ErrorPrompt" -> OptionValue[StartRakuProcess, "ErrorPrompt"] |>;

      $RakuProcess = StartProcess[ {raku, "-e", zmqScript[aPars]} ];
      $RakuZMQSocket = SocketConnect[url <> ":" <> port, "ZMQ_REQ"];
      <|"Process" -> $RakuProcess, "Socket" -> $RakuZMQSocket|>
    ];


Clear[KillRakuProcess];

KillRakuProcess[] :=
    Block[{},
      If[ TrueQ[ Head[$RakuZMQSocket] === SocketObject], Close[$RakuZMQSocket] ];
      If[ TrueQ[ Head[$RakuProcess] === ProcessObject], KillProcess[$RakuProcess] ];
      $RakuZMQSocket = Null;
      $RakuProcess = Null;
    ];


Clear[KillRakuSockets];

KillRakuSockets::nscks = "No Raku sockets found.";

KillRakuSockets[] :=
    Block[{aRes, lsIDs},
      aRes = Quiet @ ExternalEvaluate[<|"System" -> "Shell", "ReturnType" -> "Association"|>, "ps -ax | grep -i \"raku.*zmq\""];

      lsIDs = StringCases[aRes["StandardOutput"], StartOfLine ~~ id : (DigitCharacter ..) ~~ WhitespaceCharacter :> id];

      If[ Length[lsIDs] == 1,
        Message[KillRakuSockets::nscks],
        (*ELSE*)
        ExternalEvaluate["Shell", "kill -9 " <> StringRiffle[Most@lsIDs, " "]]
      ]
    ];


(***********************************************************)
(* ZMQ script                                              *)
(***********************************************************)

zmqScript =
    StringTemplate[
      "
use v6;

use Net::ZMQ4;
use Net::ZMQ4::Constants;
use Text::CodeProcessing::REPLSandbox;
use Text::CodeProcessing;

sub MAIN(Str :$url = '`URL`', Str :$port = '`Port`', Str :$rakuOutputPrompt = '`OutputPrompt`', Str :$rakuErrorPrompt = '`ErrorPrompt`') {

    # Socket to talk to clients
    my Net::ZMQ4::Context $context .= new;
    my Net::ZMQ4::Socket $responder .= new($context, ZMQ_REP);
    $responder.bind(\"$url:$port\");

    ## Create a sandbox
    my $sandbox = Text::CodeProcessing::REPLSandbox.new();

    while (1) {
        my $message = $responder.receive();
        say \"Received : { $message.data-str }\";
        my $res = CodeChunkEvaluate($sandbox, $message.data-str, $rakuOutputPrompt, $rakuErrorPrompt);
        $responder.send($res);
    }
}
"];

End[]; (* `Private` *)

EndPackage[]