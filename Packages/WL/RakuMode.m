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
(* Icons                                                   *)
(***********************************************************)

rbCameliaHex16 = GraphicsBox[
  TagBox[RasterBox[CompressedData["
1:eJyVk+9LU1EYx8/VYdGrKImC3vTCPyEINmIRGEYRaaJvFU164RQVNEGiIrer
+3HvhmbqrQ1swiY2V6PIQjQMUoZx2xA1agYiuut+ZUnuuqfnzFGx5qbP4Rzu
PZzP85zn+zznTHVD6c08QkjzYVxKq1ovNDVV3S47ij/lmuZbdZramhJNS21d
bdO56nzcPIXzNE6KpJuUYS+3BQuCBTGyeuKg3NAnHVhCLLzi+pb3T5mBk3Vg
BBYM4K0M5YUyJZLBeneMwCU4OhM6sHkjRGJyUxyYKJMaetCBrySEOmVXaqqd
w9slmR0az7Klg3dtEYVEpKxsjJhjbIozJNBDzOV0OSOKIA6JwbhMOAO1rgiT
b0Vuqwl4VOb5mLC4qJorX1KtFK4UBhVhRYj4L4UYb2U6F8yP5IUZp4eLc3Hk
XoxqOn6yqKtt1jb7nbhGkt8zOuj78tL8LxUlolpUOz0G1NHtEbSC9tr24CqP
6rCwdP7jDazqFi9zeH8WVk/GUhTlfCp9gpf1CRY8z6z3y+TWJcs8D/Sc+xEf
MyBHc+dlI0y2TbZRnSQSJX6lQTbIVEnh81xJMRRDOdQvPhVdPmFT2Fw4+1jk
UjUyYn2ChyglMRLjV2rRF624Hsw/Brsr5PrASMC1YIehXx/uuvpZ0CfQKyVl
Mwz5SDKeRN439KwZKZkwweS96esVcs3GSGAYbPJMx0zH6BN212syXu/OX2Wi
ZO2YDlUwb5u3H4DjrckxPmyP2+MD4G0ZtVKKcrxsSjyU02sxrhV8LNgn+gMS
EyMhMn/lzZ35i4Ofxvq6gItbIkhv0o76v/ri1TCxTywoacYDXzuhE0/qMTM+
7vA4PG7rctFU+179FsZsN5gN5Ng/vcrHu0FUh7GrYnv26a5SNC6L2VL1aVV9
KlEdyVtXZMVSccXL9C0ZcRhknyqK/ZGboiaIgvi6q2d9utGvjJL9c9TWjkfJ
dGPwyMGoXcv1crOz6fYbZYzyAg==
    "], {{0, 18.75}, {21., 0}}, {0, 255},
    ColorFunction -> GrayLevel,
    ImageResolution -> {96, 96}],
    BoxForm`ImageTag[
      "Byte", ColorSpace -> "Grayscale", Interleaving -> False, Magnification -> Automatic, MetaInformation ->
        Association["Comments" -> Association["Software" -> "www.inkscape.org"]]],
    Selectable -> False],
  DefaultBaseStyle -> "ImageGraphics",
  ImageSizeRaw -> {21., 18.75},
  PlotRange -> {{0, 21.}, {0, 18.75}}
];

rbCameliaHex24 = GraphicsBox[
  TagBox[RasterBox[CompressedData["
1:eJytlW1MU1ccxumtQUl8mU63L3vJZtz0w+KHfZhzyZxfpmSJcTjMKrpNAijL
xIlO51tidNO59r61hVaoCkhpoU5gGKQKq0iFOaCzUiyFRQGRyn1pYVCB9t5z
d3pLXenQyctzcpu0vfd3n/85z/+cN5J3J6QhMTExe+fAj4TtB9ZmZm4/uOkF
+CUxY2/6jozUlPiMfak7UjNXJUvhj2/BawW8go88Tcwz/puKGCkrYRB2Jonz
Hiz1SLuXsXEzwzPdMNSYyoqqL17UX79UmNs+faIKoEAh4AFUwP0KQc3WHKPm
T4d3hidAxBBQoGJtMg/CSKbG0woqAROIyAHw0fI8agE7RaYGYAIeTeTVlDWT
nkdLmEmnSisoQZRDkakQDOYHb7IicXJUzTDK/4cnkDzOZ/XV7Wdg3ZNj9rxa
Vkg8JkE0EedRTks71jGzIOsJ83mo3hibjBzExBUeGzwOyFH0sZquzKHmuBe6
F0CfQSrkwllFmGc1cvAO6cPXKjXKAXKschzgoNh8Fbt+uO5Iz9vUgp6X3IvY
2L65bAyLeJBHi72z+uZ7Y6l5E/PEOiReyV/vnmtEw9UCJdcaf/vjusPWfTcO
NaRfP2j7rHdJ72IqzrW6UmNW/JpnPl2hqz5RkfN0IivpXH7ttLo/xCMEc3bN
V2ilxikfUfVjo+q+s382J7oX0bNNZlW/ApBDckCMyHlyUF/tiJ+AB0fn62a0
sIH0QRqsOLe7a+UpU/LDkx0ab9AvDn4WKnT0Qts27SOUU/oJsbtgEoCcu6Km
FrKSaCIdc/UHJYP5IY8POqw7UvrdLsdm7oBLd0c5DJ/mCU7b05RsPYQOwpT9
mzPYA+daHOtYhJaOd+h8T3dXvFN0WFTv+OjotaShLfyXg8ddagrlcQ4VFH59
tT2h5DLBjcsXUABTefeycPeHHZafU7Fj2YGdc+vrgh9T78v4bZxM+MZ93pLv
ONue59TdK7S51lgzVANEZG6hA21nU5JHEumwOSGnAwVjtQClz3LMuj6le6v/
C34LyOwsqilrL+241HbxXvmtprTGRDwwjgj7SgH0v0fwYBbLCvBBnHtyHzBa
GmUnKzaDrUDGK2uNjFEw+PXA8PcVa8dyQxURICI7Ibi7AO1QZG765jfszO4h
n7wZrl/ArK5L/NYlCxxuy7ebhCJg5PR8WVvzzro0cjhIiPSIChp+/Ep7JI8W
/VKiEFM41n98/h9347Waz325VaYBAzAGirhipqak60VdK8GNd4gJSkErRPUg
QsU1J2X34tzY3g1X9qeRKnXt5ly98WbxUDF1wW+gSp32TeYTxGi0Q0zQRPFC
YmdfPYUNwdXh4IoH5NyZ+/V7hpDWDxzpd1Jse+xpzXudG5wrlQN4KF/BemDW
SIDxaqAFE3d37X7dnfybWb15tiz3+UaDxb2EhntCy0bLEcvRa6d/O36FKK4g
AkESpHhRn4rBfSovMZgzMjEvJPuGzhWu1fffafuwayk8W6Tulw0WrB8bxkfw
xwSHi/OHgyymzHD705u7bFvqdzfJnsULyQP3DA9MAI2wklspmk7UT3BkRLKg
R5/lqHuxF2HivBJm9v8Tgwrt1nSs632dHfcTkacFjwF1X5Uc/isNvvX5eCIT
DnhazTWjEakSOw4fOW/remXy51hQNJzJ9lUFDfhouD8JHgXaLms6PSVeSF6k
fifhwcRqYbI4st94mUKm5jAs+yclpbl3MZ+mR85lP9B02zZOx2FYtd871zQn
taxv2uZcOz1/keoXTzc6Nnxqz4zoac7gRJp5Yoj6NP0DdKhBTA==
    "], {{0, 28.5}, {30.75, 0}}, {0, 255},
    ColorFunction -> GrayLevel,
    ImageResolution -> {96, 96}],
    BoxForm`ImageTag[
      "Byte", ColorSpace -> "Grayscale", Interleaving -> False, Magnification -> Automatic, MetaInformation ->
        Association["Comments" -> Association["Software" -> "www.inkscape.org"]]],
    Selectable -> False],
  DefaultBaseStyle -> "ImageGraphics",
  ImageSizeRaw -> {30.75, 28.5},
  PlotRange -> {{0, 30.75}, {0, 28.5}}
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
        StyleKeyMapping -> {"Tab" -> "Input"}, Evaluatable -> True,
        CellEvaluationFunction -> (RakuInputExecute[#1, Options[RakuMode'RakuInputExecute]]&),
        CellFrameColor -> GrayLevel[0.85],
        (* CellFrameLabels -> {{Cell[BoxData[StyleBox["Raku", FontWeight -> "Bold"]]], None}, {None, None}}, *)
        CellFrameLabels -> {{Cell[BoxData[rbCameliaHex16]], None}, {None, None}},
        AutoQuoteCharacters -> {},
        FormatType -> InputForm, FontFamily -> "Courier",
        FontWeight -> Bold, Magnification -> 1.15` Inherited,
        FontColor -> GrayLevel[0.4], Background -> RGBColor[0.976471, 0.964706, 0.960784, 1]
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
    Block[{proc, ff, epilogFunc=OptionValue[RakuInputExecute, Epilog]},

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