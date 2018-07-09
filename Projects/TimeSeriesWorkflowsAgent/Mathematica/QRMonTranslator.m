(*
    QRMon translator Mathematica package
    Copyright (C) 2018  Anton Antonov

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
	  antononcube @@@ gmail ... com,
	  Windermere, Florida, USA.
*)


(* :Title: QRMonTranslator *)
(* :Context: QRMonTranslator` *)
(* :Author: Anton Antonov *)
(* :Date: 2018-07-08 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: 11.3 *)
(* :Copyright: (c) 2018 Anton Antonov *)
(* :Keywords: *)
(* :Discussion: *)


If[Length[DownValues[TimeSeriesWorkflowsGrammar`pQRMONCOMMAND]] == 0,
  Echo["TimeSeriesWorkflowsGrammar.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/EBNF/TimeSeriesWorkflowsGrammar.m"]
];


(*BeginPackage["QRMonTranslator`"]*)
(* Exported symbols added here with SymbolName::usage *)

(*Begin["`Private`"]*)


Clear[TGetValue]
TGetValue[parsed_, head_] :=
    If[FreeQ[parsed, head[___]], None, First@Cases[parsed, head[n___] :> n, {0, Infinity}]];


(***********************************************************)
(* Data statistics                                         *)
(***********************************************************)

Clear[TSummarizeData]
TSummarizeData[parsed_] :=
    Block[{},
      If[FreeQ[parsed, _SplitPartList | _SplitPart],
        QRMonEchoFunctionValue["summaries:",
          Multicolumn[#, 5] & /@ (RecordsSummary /@ #) &],
        QRMonEchoFunctionValue["summaries:",
          Multicolumn[#, 5] & /@ (RecordsSummary /@ #) &]
      ]
    ];


Clear[TCrossTabulateData]
TCrossTabulateData[parsed_] := parsed;


Clear[TCrossTabulateVars]
TCrossTabulateVars[parsed_] :=
    Block[{},

      Echo["TCrossTabulateVars is not implemented yet"];
      $QRMonFailure

    ];



(***********************************************************)
(* General pipeline commands                               *)
(***********************************************************)

Clear[TPipelineCommand]
TPipelineCommand[parsed_] := parsed;


Clear[TGetPipelineValue]
TGetPipelineValue[parsed_] := QRMonEchoValue;


Clear[TGetPipelineContext]
TGetPipelineContext[parsed_] :=
    Block[{},

      Which[

        !FreeQ[parsed, _PipelineContextKeys ],
        QRMonEchoFunctionContext["context keys:", Keys[#]& ],

        !FreeQ[parsed, _PipelineContextValue ],
        TPipelineContextRetrieve[parsed]

      ]
    ];


Clear[TPipelineContextRetrieve]
TPipelineContextRetrieve[parsed_] :=
    Block[{cvKey},

      cvKey = TGetValue[parsed, ContextKey];

      With[{k=cvKey}, QRMonEchoFunctionContext["context value for:", #[k]& ]]

    ];


Clear[TPipelineContextAdd]
TPipelineContextAdd[parsed_] :=
    Block[{cvKey},

      cvKey = TGetValue[parsed, ContextKey];

      With[{k=cvKey}, QRMonAddToContext[k] ]

    ];


(***********************************************************)
(* Generate pipeline commands                              *)
(***********************************************************)

TGeneratePipeline[parsed_] :=
    Block[{clName},

      clName = TGetValue[parsed, ClassifierAlgorithmName];

      If[clName === None,
        clName = TGetValue[parsed, ClassifierMethod],
        clName = StringJoin@StringReplace[clName, WordBoundary ~~ x_ :> ToUpperCase[x]]
      ];

      If[clName === None, clName = "quantile regression"];

      ToQRMonPipelineFunction[{
        "show data summary",
        "quantile regression with 0.25, 0.5, and 0.75 quantiles",
        "display plot"
      }]

    ];


(***********************************************************)
(* Second order commands                                   *)
(***********************************************************)

TSecondOrderCommand[parsed_] := parsed;

(***********************************************************)
(* Main translation functions                              *)
(***********************************************************)

ClearAll[TranslateToQRMon]

Options[TranslateToQRMon] = { "TokenizerFunction" -> (ParseToTokens[#, {",", "'"}, {" ", "\t", "\n"}]&) };

TranslateToQRMon[commands_String, parser_Symbol:pQRMONCOMMAND, opts:OptionsPattern[]] :=
    TranslateToQRMon[ StringSplit[commands, {".", ";"}], parser, opts ];

TranslateToQRMon[commands:{_String..}, parser_Symbol:pQRMONCOMMAND, opts:OptionsPattern[]] :=
    Block[{parsedSeq, tokenizerFunc },

      tokenizerFunc = OptionValue[ToQRMonPipelineFunction, "TokenizerFunction"];

      parsedSeq = ParseShortest[parser][tokenizerFunc[#]] & /@ commands;

      TranslateToQRMon[ parsedSeq ]
    ];

TranslateToQRMon[pres_] :=
    Block[{
      LoadData = TLoadData,
      SummarizeData = TSummarizeData,
      PipelineCommand = TPipelineCommand,
      GetPipelineValue = TGetPipelineValue,
      GetPipelineContext = TGetPipelineContext,
      PipelineContextRetrieve = TPipelineContextRetrieve,
      PipelineContextAdd = TPipelineContextAdd,
      GeneratePipeline = TGeneratePipeline,
      SecondOrderCommand = TSecondOrderCommand},

      pres
    ];


ClearAll[ToQRMonPipelineFunction]

Options[ToQRMonPipelineFunction] =
    { "Trace" -> False,
      "TokenizerFunction" -> (ParseToTokens[#, {",", "'", "%", "-", "/"}, {" ", "\t", "\n"}]&),
      "Flatten" -> True };

ToQRMonPipelineFunction[commands_String, parser_Symbol:pQRMONCOMMAND, opts:OptionsPattern[] ] :=
    ToQRMonPipelineFunction[ StringSplit[commands, {";"}], parser, opts ];

ToQRMonPipelineFunction[commands:{_String..}, parser_Symbol:pQRMONCOMMAND, opts:OptionsPattern[] ] :=
    Block[{parsedSeq, tokenizerFunc, res},

      tokenizerFunc = OptionValue[ToQRMonPipelineFunction, "TokenizerFunction"];

      parsedSeq = ParseShortest[parser][tokenizerFunc[#]] & /@ commands;

      parsedSeq = Select[parsedSeq, Length[#] > 0& ];

      If[ Length[parsedSeq] == 0,
        Echo["Cannot parse command(s).", "ToQRMonPipelineFunction:"];
        Return[$QRMonFailure]
      ];

      res =
          If[ TrueQ[OptionValue[ToQRMonPipelineFunction, "Trace"]],

            ToQRMonPipelineFunction[ AssociationThread[ commands, parsedSeq[[All,1,2]] ] ],
          (*ELSE*)
            ToQRMonPipelineFunction[ parsedSeq[[All,1,2]] ]
          ];

      If[ TrueQ[OptionValue[ToQRMonPipelineFunction, "Flatten"] ],
        res //. DoubleLongRightArrow[DoubleLongRightArrow[x__], y__] :> DoubleLongRightArrow[x, y],
      (*ELSE*)
        res
      ]
    ];

ToQRMonPipelineFunction[pres_List] :=
    Block[{t, parsedSeq=pres},

      If[ Head[First[pres]] === LoadData, parsedSeq = Rest[pres]];

      t = TranslateToQRMon[parsedSeq];

      (* Note that we can use:
         Fold[QRMonBind[#1,#2]&,First[t],Rest[t]] *)
      Function[{x, c},
        Evaluate[DoubleLongRightArrow @@ Prepend[t, QRMonUnit[x, c]]]]
    ];

ToQRMonPipelineFunction[pres_Association] :=
    Block[{t, parsedSeq=Values[pres], comments = Keys[pres]},

      If[ Head[First[pres]] === LoadData, parsedSeq = Rest[parsedSeq]; comments = Rest[comments] ];

      t = TranslateToQRMon[parsedSeq];

      (* Note that we can use:
         Fold[QRMonBind[#1,#2]&,First[t],Rest[t]] *)
      Function[{x, c},
        Evaluate[
          DoubleLongRightArrow @@
              Prepend[Riffle[t,comments], TraceMonadUnit[QRMonUnit[x, c]]]]
      ]
    ];


(*End[] * `Private` *)

(*EndPackage[]*)