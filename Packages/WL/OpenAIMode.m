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
OpenAIInputExecuteToText[boxData_String, opts : OptionsPattern[]] :=
    OpenAIInputExecute[boxData, Function -> ChristopherWolfram`OpenAILink`OpenAITextComplete, opts];

Clear[OpenAIInputExecuteToImage];
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
1:eJztnE2uJUcVhJ89YhvsgilDpmYFtmSYGckgIXYP7XbTr9+9dSvznPjLqvwk
kBB9T0Z8UUK2BPzxp3/88Lfv397e/vmH//3TDz/++8+//vrjf/766V/85Zd/
/fz3n3/900+f/u237z//47vNZrPZbDabzWaz2Ww2m4V5+x13jo2Qt5e4022I
vJ5+fwRXZnT7/Q1cj9nt9zdwIarj70/gAvTG35/A2iDW31/AoqDG35/AimDX
31/AWuDX31/AOnDW31/AGvDW31/AAnDn3x9ANuz19xeQjGL9/QXEopp/fwCJ
6NbfX0Ag2vn3BxCGev79ASShX39/AUF45t8fQAiu+fcHEIFv/v0B+HGuv78A
O+759wdgxT3+J9wObox7+s+4LdwW9/BfcHu4Ke7Zv+I2cUvco7/H7eKGuCf/
FreN2+Ee/CNuH3fDvfdH3D5uhnvuR9xGboV77Ge4ndwI99TPcVu5De6hj3B7
uQvunY9we7kJ7pmPcZu5Be6RX+F2cwPcE7/Gbef6uBd+jdvO5XEPfIbbz8Vx
z3uO29C1ca97jtvQpXGPO4Lb0ZVxbzuC29GFcU87htvSZXEPOwqyGlziwggn
bIEvRRK6FuTVgHAKUeUuAGUqCrQ2bMXJgDciwq0iUB0JaBw+/CIK3Wn0rWnQ
1JAojwIkjoywhMR6DEhzPLQVROojgMsjoC8gkh8ARR8UT3yRfjc0fyh88TUD
mGEKRGANL9rACNtgE3d20Qo+BA7rJCQX7eBCZLFCSHDNDiZkFufJyS3awoHU
4wxRqUVjGFCbHCQus2gONQ6V5yRm1uyhxuPyhMzEokW02Gwek5tXtIkSq89n
RKcVjaLDLfSB8LSiWWS4fX4gP6toFxVund+wRFLRMCLcNt+xSlDNMBrcLt+x
Ss5LfQBulf9njZS/IxpHgNvk76yQ8T2idfi4Rf7GAhE/olmHj9vjJ+IDPkO0
Dxm3xbdF13+7yAfglrjs+m/X+ACiFZrDnaFZiEuwQW+0EUQbMYnV5ww2jGgk
IqHufLHmEK3EI9OcLdU0oploJGozZSohmolGnjRLojqinVjEGTME6qHZiUSa
L0OeLqKlOGTZkqeBIJqKQpIqcRYcoq0YBHmSRoGimYpCjCZlEDiisQiEONLF
oCAai0CEIVUIHqK18CTo0WTgolkLj1+OJAEd0Vxw3GoE72sQ7YXG64X+ug7R
XmisWtiPSxENBsbohPu0HNFg87zMaTPCfNgDccIaIzFdOnjv2uANOc9wTI8N
2qtOiHNOMRXT4YL0ph3ipqNMp9SLoLwYAXHXISop5RoID8bAm3aAWkixBPxz
SRDXPaEcUqoA/VgaxIFxXhs/7QnAPhUJcWOYV+IoyJhLQlwZppW2CjbmmhCH
Rmkl7YKOuSbEqVFaKcvgY64JcWyUVsY2jJxLQpwbpRU/DiXmohAHB2lFz0OK
uSjEyUFesQPRYi4Kb3KUVuxCtJirwtwd4hW7ESvlsnCnhy/Gqtu9uyzp82v2
b6dclvT5Ffv3Q65L+vz8/QEZVyZ8fvb+iIhLk70+e39EwrUJn5+6PyJfK4w5
wCfC57/u/gERvsaInf+q+0eE+DZI5PzX3D8jxZMscfNfcn+irn6YrPkvuD/b
GCBOzvyX218iDRFo709AZQ0TKWD+a+2vFIfJNA81Xta11uMCd6BUU3DjZV1r
PK3Sh8o1Cjle1rXyw0qBsGSe+NjzLtdWhbhohuzY+x7TfovAcOLg2AccnkNE
IuMJU2Nf0FsOUgkNqAqNfUEuOUsmNqEkMfYJseJTXXqfcxlnUMTLujb12HNd
BqNTKSdQxMu6NvPWoSyD0/GYE0jiZV0bf+mlK4fWwdfH0cTLujb6zpkqj9mh
x4fRxMu6NvbKiCmL2pGwo4jiZV0bemRQlMfu2cPDiOJlXRt4YkKTxy9mf1W8
rGunD8xZ8igurK0Lt9j+XUkOx4W1VdEe42Vde3295EivubK3JNizeFnXXt0u
GxKLrszNT3WUL+va8eWOIK3qyt70UIf5sq4d3e36UcouzE1O9Cpf1rWDswA9
Ot+VwZl5XufLuvb0KEiOynhlcFqY03xZ156cxLkROa8szspyni/r2sNBrBqF
9cLenCBjAbOu0Sfii68sTogxGjD5mn4e+gMjAEKMB0y6prFCfqWyOKfoUMCc
azorzIcKgxObnieMuSZ1wnussji36+uEIdfURmgTFAanl32VMOKawwjpycLi
iraHCROumXwwnq0srur7NKL/mtEG/unK4sLCjxHd17wy4K9XJtdWjtrf7QL9
BRQGl3fGvte6ZjaBD1FZXN0a+17jmtnDWA5gpRFIFY8z2q65NTCyVBaXF8c+
WLxmtzCTB3NlCGLF5yE919wOSJEqi8u7Yx+sXHMbKKQailXY21Ae+yLYUjdO
i26yyuL6+tgXZ68lGCima/14DH1H8bUMBdWAjZ+OoW8ovZYjoZqx/MOc6tgX
J65laSjmLP4sqDj2xeFreSKKWUs/CmqNfXL0WqSKYtz5XySVxj45di1WxiHT
0SoVLZWxT45ci9ZxyFy0akd9YeyT59fihRwyEa1TUlwX++TptQWMHDKerddS
2hb75Mm1RZwcMhitX1PXFfvky2sLWTlkKBqm6NX2B1nJ/3vBpYpinzy+hpIi
E3PIWba1amKfPLoGc6JUc8jraGuVhD55UABmRC3nEEYjT0Xok88LLGznGE4p
fUPok88KLO5ntOuq/aBPPha4gKHRtmu2gz75sQDb0LW/AEMF6DEJEAmZjQ0F
oMdEQDQkVjbkhx6TARGRV9qQHnpMB8REXG1DdugxJRAXYb0N0aHHtEBsRDU3
BIceUwPxEdTdEBt6TA5ESE57Q2joMQMQJSn1DZmhxyxApIQI0CeGHjMB0RKh
QJ8XeswFxEuCBH1a6DEfEDN+C/qw0GNOIG7cHvRRocesQOSYReiTQo+Zgejx
qpDnhB6zAxHkdCGPCT0WAESRz4Y8JPRYAhBHNh3yjNBjGUAsmXzII0KPpQDx
5BGiTgg9lgPElEOJOh/0WBAQVQYn6njQY1FAZOmliNNBj4UB0aW2Ig4HPZYG
xJdYizgb9JiD0f+LHi2NPtpo0GMOzkIglEnFaJNBjzk4j9FXJjWjDQY95mAg
R1uZVo04F/SYnqEkbWlKN+pY0GNyBrN0rQnl6FNBj4kZDdP2prNjCAU9JmU8
TtucSo8lE/SYkJlAbXcaPZ5M0GM65iJ15Wn8mCJBj6mYzNTWpxBkSwQ9pmE6
VVugwJAtEPSYBEHJFsBSkkjAUxIEJXtAWykywQ5J4HfsAm0lCQU6I4HfsQu6
liAV5ooEQcku8FqCWIgbEvgd++B7CXL1L0jgd+xDKUYP1j4gQVCyD6cYPVnz
5xIEJfvQmrGztX4sgd8RAa0ZPVzjpxL4HSEQq5HD1X8pQVASAbcbN171dxJA
HcX/tVt0N3K+2q8k8DtioJfjBkS2ggIs2VZYf9oTaSYhsBQUQUkMknbMjLBS
UKAd2wKrD3sSzYYEdYIC7djWV3sW3I+XEtQJCbRkV17pUUZBWk5MJyDQkl11
lTdZDVlBEZWAQDu2zc0/yWtIi9qvBATase1t+kVuRVLUdiMg0JJda7PvCTpy
wnYb4YB2bEube05TkhO32QgGtGNb2dRrupaUuK1CMKAVAc4mXhPWpARuFUIB
LYhQNvGcsCcn8d6/9ZyyqCWzAGg5iK/x56RNPaHpQLtBdI0/p63qis0F2gwi
a+I9bVdbbibQXhBVE++JyxqT04C2goiaeE/d1hmdBLQUxNPEe/q+3vAEoJUg
lmYe1Bc2p4cDLQRxNPOgobE7PhhoH4iimQctnf0FgEDbQATNPOgpnVABBbQL
RM/Ui6baER0gQJtA5Ey96OqdUQIAtAjEzdSLvuYpNZpAa0DMTL1orJ5TpAO0
BMTL1IvW8klVqkArQKxMvWiuH9WlBLQBRMrck24BWWXk9aHHKk/aDaTV0baH
Hqs8GeAgro+wO/RY5ckIC4GNRM2hxypPhniI7CToDT1WeTJFRGgrdm3oscqT
OSpSa1FLQ49VnkySkVuMVtngL1lHcjVKYYO9aB/Z5b57/J+cQfNCFMw9STBk
hd4NW9agjmtIVsPQ78l5bNh29/kneaJ8UEthmxq8cew8l2WC2Qjb02ANZ2TI
lwdYyYc22JYGZ0Ano84cwGp+aILtaDAGlTKszQCq6HcvrmIzdq8VnmxLGTcn
B1v06VFsxO61wpMALTP2xCBrPj2JDdi9VngS4WXSoBRcy6cHsfG61wpPYszM
ShSCK/nsHjZd91rhSZSZaY86YB2fXMNm614rPIlzU3CpAtTwyS1ssu61wpM1
Cocl3Q6BFHxyCZure23+xRql24pyx2AKPhzCxupem3+xRvG6ol4x2nhObCW9
oHENNUF1s3T65R6OYCN1r82/WKLxgKJhNdtYQGwfvZ3JrSuOeoKpdKvt/YdS
dn/Po50M20VvprJ411LlAgVAKmwTuZfC3rXxEDfAQCJhi8i1VBYvhsRcgUFp
hQ3VvTb9YAXUY7SK3CzYEnIllcXrGYGnerAqYXN1r82+VwH5IKUiOQS2gdpH
ZfFmRuy1CtAE2PxqG5XF2xHhB52vY9OLXXj2d/5lAPxlbHahicfnKjAehlZk
P4uNrhLx9LkCpKdxDelvYoNLNBw9V4D2Nqzi4IOgq9iM3Wtzr1XgPQ+qSH8M
m5rr4PVrFZgBIBVHHmq9hM3MM3D+WgFyhP55/ivYxKT+I49VoIcAPED+xpKv
TT1WgR9jsfNZ16Yeq6AIQjyN/8+vrGszb1UQZQm8e/RC1rWZtyrIwjCOUoJn
XZt4qoQuT8TBgVeyrk08VUKZCFuPFTrr2vhLNbShTJemHsq6Nv5SDXEq+Zn5
p7KuDT9UQx9MdqKaN+va8EM1HNG6zchps66NvlPEk474237WrGuj7xQxxaP8
EBQ169rgM1Vo8c4SQn8EDZp1bfCZKrR45xlBv4DHzLo29koZVryhlHN/XJUy
69rYK2VY8cZylv8oM2PWtaFH6pDiDUcdbSRMmHVt5I0GnHgzaSf+jCZf1rWR
Nxpw4s3FPfsD4nhZ1wae6ECJB00sD5d17fyFFox40ND6aFnXzl9owYgHjO0I
lnXt9IEehHi44J5cWdfO7jfBx4Nld6XKunZ2vwk+Hiq9LVPWtZPzXeDxQPmN
kbKuvb7eBh0PU8EaKOvay+N9wPEgLcxxsq69ug0AGw9SxB0m69qL0wig8RBV
/Fmyrr04vfT+z8skJMm6dnx59f0f+2TkyLp2ePgC+3+olJEidn/G/EEfQESI
4P0587v3/9IrIEL2/qT5/ft/qmYPEL8/a363+gDQRgh+aevv/R/dYg9SIu79
URCMwP0y57/3B0ARgtbLnf/G+5OEgPWS57/v/iwh0Gvs9W+7P08I8hp3ekjd
JWEKAV5j7g7rux5cH7BrvMmhfZeDbAN1jzg5uPFS0F1gLhIHZ5ReBYEIyE3i
3KTaS6DwADhKHJvXOx+NhfZZ4tTc5tmoHDQPE4cWlI9FZ6B1mTeyqH0owv6N
28SNX4IVkIe0fPk6ceAT0AqyEFev3Seuew5eQg7y5oUHeMsOQtAQgr729BPE
XUehiAjAUXrqEeKmU5BcePE0Hn6GOOc0NBs+XIVH3uENWYSnw4Wt7suXiBP2
YBoxYOwqGgwM14kYa1PRYGjYWoR4e4r2QkP3osLdUrQXHIEaAf6KorngSOSQ
SWioWYuARg+TiHqitQioDJEI6SYai4DOEYGYZqKxGCg1YQnqpZmKgtQTkqRW
oq0oiFWByKokmoqD3FaftD6ipTgYfDVJqyMaioXBWIe8LqKdaFikFUksIpqJ
hklbgcwempWIuMTNElpCtBIRn7sJYhuIRmLi1DdGcHzRRlS8Bk+JDq9ZiItZ
4QnZ0UUTcXFLfEF6btFCZNwWj4gPLdqHjtvjUxaIrFlHgFvkE1bIK1pHgNvk
R9YIKxpHgVvlN6ySVLSNBLfLd1wi53K4bX5hiZC/IRpGhVvnb+Qn/IpoFxlu
n0v8Pd87NKsIiRbqDveAaBQluT6tyZ4j2kRLpk1bqleIFhGT6NKT6QzNHnLi
VDoCDSCaw0CUSXWYYURjOMjxKE0yh2gLDyEWZTHm0exgI8GiKEMN0Q4+3A4F
73cQrWDEa5D9ehPNBGZ8ApkvQ9AMYMfjj/YqDJH+APT6KC+CEcmPQCwP/hwD
jfkUhOaQT/GQWI9CIw70Ch2J8jD41voviFDoToTrDLUOH77pXGjCwBsRYStO
h6OLMhUFqtxVwJsirwaDJHRJkJKEE7aAS9x8xj3sGG5LF8Y97QhuR1fGve0I
bkeXxj3uOW5D18a97jluQxfHPe8Zbj+Xxz3wa9x2ro974de47dwA98SvcLu5
Be6Rj3GbuQnumY9we7kL7p2PcHu5De6hn+O2ciPcUz/D7eRWuMd+xG3kZrjn
/ojbx91w7/0Rt4/b4R78W9w2boh78ve4XdwS9+hfcZu4Ke7Zv+D2cFvcw3/G
beHGuKf/hNvBrXGPv+c3s9e/O3v+m7Pnvzl7/puz5785e/27s+e/OXv+u7PX
vzl7/ruz1787e/2bs+e/O3v9u7PXvzt7/buz1789e/y7s9e/PXv827PH3+zt
N3v7zclH4E63EbJH32w2m81ms9lsNpvNZnMF/guq/PNq
    "], {{0, 512.}, {512., 0}}, {0, 1},
        ColorFunction -> GrayLevel],
        BoxForm`ImageTag["Bit", ColorSpace -> Automatic, Interleaving -> None],
        Selectable -> False],
      DefaultBaseStyle -> "ImageGraphics",
      ImageSizeRaw -> {22., 22.},
      PlotRange -> {{0, 512.}, {0, 512.}}];



End[]; (* `Private` *)

EndPackage[]