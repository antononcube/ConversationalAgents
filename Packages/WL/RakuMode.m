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
        StyleHints -> <|
          "CodeFont" -> "Source Code Pro",
          "GroupOpener" -> "Inline",
          "OperatorRenderings" -> <|"|->" -> "\[Function]", "->" -> "\[Rule]", ":>" -> "\[RuleDelayed]", "<=" -> "\[LessEqual]", ">=" -> "\[GreaterEqual]", "!=" -> "\[NotEqual]", "==" -> "\[Equal]", "<->" -> "\[TwoWayRule]", "[[" -> "\[LeftDoubleBracket]", "]]" -> "\[RightDoubleBracket]", "<|" -> "\[LeftAssociation]", "|>" -> "\[RightAssociation]"|>
        |>,
        CellLabelTemplate -> <|"In" -> "In[`1`]`2`:=", "InExpired" -> "In[\:f759\:f363]`2`:=", "Out" -> "Out[`1`]`2`=", "OutExpired" -> "Out[\:f759\:f363]`2`="|>,
        AutoQuoteCharacters -> {},
        FormatType -> InputForm,
        FontFamily -> Dynamic[AbsoluteCurrentValue[EvaluationCell[], {StyleHints, "CodeFont"}]],
        FontWeight -> "Plain",
        Magnification -> 1.15 * Inherited,
        FontColor -> GrayLevel[0.05],
        FontOpacity -> 1.,
        Background -> RGBColor[0.99, 0.975, 0.975, 1],
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
        (* ToExpression is needed to convert Mathematica symbols like \[OpenCurlyQuote] into UTF-8 characters. *)
        (* Note that ToExpression is run here on strings only. *)
        (* Quiet is needed to suppress certain messages ToExpression might issue for Raku code like '\v' or '\s'. *)
        ff = Quiet @ ToExpression @ StringReplace[ToString[ff], "\\\\" -> "\\"];
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


(***********************************************************)
(* Icon                                                    *)
(***********************************************************)

rbCameliaHex24 = GraphicsBox[
  TagBox[RasterBox[CompressedData["
1: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
    "], {{0, 200.}, {226., 0}}, {0, 255},
    ColorFunction -> GrayLevel,
    ImageResolution -> 72.],
    BoxForm`ImageTag["Byte", ColorSpace -> "Grayscale", Interleaving -> None],
    Selectable -> False],
  DefaultBaseStyle -> "ImageGraphics",
  ImageSizeRaw -> {27., 24.},
  PlotRange -> {{0, 226.}, {0, 200.}}
];


End[]; (* `Private` *)

EndPackage[]