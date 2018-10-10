(*
    SMRMon translator Mathematica package
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


(* :Title: SMRMonTranslator *)
(* :Context: SMRMonTranslator` *)
(* :Author: Anton Antonov *)
(* :Date: 2018-09-17 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: 11.3 *)
(* :Copyright: (c) 2018 Anton Antonov *)
(* :Keywords: *)
(* :Discussion: *)


If[Length[DownValues[RecommenderWorkflowsGrammar`pSMRMONCOMMAND]] == 0,
  Echo["RecommenderWorkflowsGrammar.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/EBNF/RecommenderWorkflowsGrammar.m"]
];


(*BeginPackage["SMRMonTranslator`"]*)
(* Exported symbols added here with SymbolName::usage *)

(*Begin["`Private`"]*)


Clear[TGetValue]
TGetValue[parsed_, head_] :=
    If[FreeQ[parsed, head[___]], None, First@Cases[parsed, head[n___] :> n, {0, Infinity}]];


(***********************************************************)
(* Data statistics                                         *)
(***********************************************************)

Clear[TDataStatisticsCommand]
TDataStatisticsCommand[parsed_] := parsed;

Clear[TSummarizeData]
TSummarizeData[parsed_] :=
    Block[{},
      (*Fold[ SMRMonBind, SMRMonUnit[##], {SMRMonGetData, SMRMonEchoDataSummary}]&*)
      Function[{x, c},
        SMRMonUnit[x,c]\[DoubleLongRightArrow]SMRMonGetData\[DoubleLongRightArrow]SMRMonEchoDataSummary]
    ];


Clear[TCrossTabulateData]
TCrossTabulateData[parsed_] := parsed;


Clear[TCrossTabulateVars]
TCrossTabulateVars[parsed_] :=
    Block[{},

      Echo["TCrossTabulateVars is not implemented yet"];
      $SMRMonFailure

    ];


(***********************************************************)
(* Regression                                              *)
(***********************************************************)

ClearAll[TNumberValueList]
TNumberValueList[parsed_] :=
    Map[TGetValue[#,NumericValue]&, parsed];

ClearAll[TRangeSpec]
TRangeSpec[parsed_] :=
    Range @@ Map[TGetValue[#,NumericValue]&, parsed];

ClearAll[TComputeRegression]
TComputeRegression[parsed_] :=
    Block[{knots=6, intOrder=2, qs = {0.25, 0.5, 0.75} },

      If[!FreeQ[parsed, KnotsSpec],
        knots = TGetValue[ parsed, KnotsSpec]
      ];

      If[!FreeQ[parsed, InterpolationOrderSpec],
        intOrder = TGetValue[ parsed, InterpolationOrderSpec]
      ];

      If[!FreeQ[parsed, QuantilesSpec],
        qs = TGetValue[ parsed, QuantilesSpec];
      ];

      SMRMonQuantileRegression[ knots, qs, InterpolationOrder->intOrder]

    ];


(***********************************************************)
(* Data and regression functions plot                      *)
(***********************************************************)

ClearAll[TDataAndRegressionFunctionsPlot]
TDataAndRegressionFunctionsPlot[parsed_] :=
    Block[{diagramType = None, dateListPlotQ = False},

      If[!FreeQ[parsed, DiagramType],
        diagramType = TGetValue[parsed, DiagramType];
      ];

      If[!FreeQ[parsed, DateListDiagram],
        dateListPlotQ = True;
      ];

      Which[

        diagramType === None && !dateListPlotQ,
        SMRMonPlot,

        diagramType === None && dateListPlotQ,
        SMRMonDateListPlot,

        ( diagramType == "error" || diagramType == "errors" ) && !dateListPlotQ,
        SMRMonErrorPlots,

        ( diagramType == "error" || diagramType == "errors" ) && dateListPlotQ,
        SMRMonErrorPlots["DateListPlot" -> True],

        ( diagramType == "outlier" || diagramType == "outliers" ) && !dateListPlotQ,
        SMRMonOutliersPlot,

        ( diagramType == "outlier" || diagramType == "outliers" ) && dateListPlotQ,
        SMRMonOutliersPlot["DateListPlot" -> True],

        True,
        Echo["Cannot translate data and regression functions plot command.", "TDataAndRegressionFunctionsPlot:"];
        Return[$SMRMonFailure]
      ]
    ];


(***********************************************************)
(* General pipeline commands                               *)
(***********************************************************)

Clear[TPipelineCommand]
TPipelineCommand[parsed_] := parsed;


Clear[TGetPipelineValue]
TGetPipelineValue[parsed_] := SMRMonEchoValue;


Clear[TGetPipelineContext]
TGetPipelineContext[parsed_] :=
    Block[{},

      Which[

        !FreeQ[parsed, _PipelineContextKeys ],
        SMRMonEchoFunctionContext["context keys:", Keys[#]& ],

        !FreeQ[parsed, _PipelineContextValue ],
        TPipelineContextRetrieve[parsed]

      ]
    ];


Clear[TPipelineContextRetrieve]
TPipelineContextRetrieve[parsed_] :=
    Block[{cvKey},

      cvKey = TGetValue[parsed, ContextKey];

      With[{k=cvKey}, SMRMonEchoFunctionContext["context value for:", #[k]& ]]

    ];


Clear[TPipelineContextAdd]
TPipelineContextAdd[parsed_] :=
    Block[{cvKey},

      cvKey = TGetValue[parsed, ContextKey];

      With[{k=cvKey}, SMRMonAddToContext[k] ]

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

      ToSMRMonPipelineFunction[{
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

ClearAll[TranslateToSMRMon]

Options[TranslateToSMRMon] = { "TokenizerFunction" -> (ParseToTokens[#, {",", "'"}, {" ", "\t", "\n"}]&) };

TranslateToSMRMon[commands_String, parser_Symbol:pQRMONCOMMAND, opts:OptionsPattern[]] :=
    TranslateToSMRMon[ StringSplit[commands, {".", ";"}], parser, opts ];

TranslateToSMRMon[commands:{_String..}, parser_Symbol:pQRMONCOMMAND, opts:OptionsPattern[]] :=
    Block[{parsedSeq, tokenizerFunc },

      tokenizerFunc = OptionValue[ToSMRMonPipelineFunction, "TokenizerFunction"];

      parsedSeq = ParseShortest[parser][tokenizerFunc[#]] & /@ commands;

      TranslateToSMRMon[ parsedSeq ]
    ];

TranslateToSMRMon[pres_] :=
    Block[{
      LoadData = TLoadData,
      DataStatisticsCommand = TDataStatisticsCommand,
      SummarizeData = TSummarizeData,
      DataAndRegressionFunctionsPlot = TDataAndRegressionFunctionsPlot,
      NumberValueList = TNumberValueList,
      RangeSpec = TRangeSpec,
      ComputeRegression = TComputeRegression,
      PipelineCommand = TPipelineCommand,
      GetPipelineValue = TGetPipelineValue,
      GetPipelineContext = TGetPipelineContext,
      PipelineContextRetrieve = TPipelineContextRetrieve,
      PipelineContextAdd = TPipelineContextAdd,
      GeneratePipeline = TGeneratePipeline,
      SecondOrderCommand = TSecondOrderCommand},

      pres
    ];


ClearAll[ToSMRMonPipelineFunction]

Options[ToSMRMonPipelineFunction] =
    { "Trace" -> False,
      "TokenizerFunction" -> (ParseToTokens[#, {",", "'", "%", "-", "/"}, {" ", "\t", "\n"}]&),
      "Flatten" -> True };

ToSMRMonPipelineFunction[commands_String, parser_Symbol:pQRMONCOMMAND, opts:OptionsPattern[] ] :=
    ToSMRMonPipelineFunction[ StringSplit[commands, {";"}], parser, opts ];

ToSMRMonPipelineFunction[commands:{_String..}, parser_Symbol:pQRMONCOMMAND, opts:OptionsPattern[] ] :=
    Block[{parsedSeq, tokenizerFunc, res},

      tokenizerFunc = OptionValue[ToSMRMonPipelineFunction, "TokenizerFunction"];

      parsedSeq = ParseShortest[parser][tokenizerFunc[#]] & /@ commands;

      parsedSeq = Select[parsedSeq, Length[#] > 0& ];

      If[ Length[parsedSeq] == 0,
        Echo["Cannot parse command(s).", "ToSMRMonPipelineFunction:"];
        Return[$SMRMonFailure]
      ];

      res =
          If[ TrueQ[OptionValue[ToSMRMonPipelineFunction, "Trace"]],

            ToSMRMonPipelineFunction[ AssociationThread[ commands, parsedSeq[[All,1,2]] ] ],
            (*ELSE*)
            ToSMRMonPipelineFunction[ parsedSeq[[All,1,2]] ]
          ];

      If[ TrueQ[OptionValue[ToSMRMonPipelineFunction, "Flatten"] ],
        res //. DoubleLongRightArrow[DoubleLongRightArrow[x__], y__] :> DoubleLongRightArrow[x, y],
        (*ELSE*)
        res
      ]
    ];

ToSMRMonPipelineFunction[pres_List] :=
    Block[{t, parsedSeq=pres},

      If[ Head[First[pres]] === LoadData, parsedSeq = Rest[pres]];

      t = TranslateToSMRMon[parsedSeq];

      (* Note that we can use:
         Fold[SMRMonBind[#1,#2]&,First[t],Rest[t]] *)
      Function[{x, c},
        Evaluate[DoubleLongRightArrow @@ Prepend[t, SMRMonUnit[x, c]]]]
    ];

ToSMRMonPipelineFunction[pres_Association] :=
    Block[{t, parsedSeq=Values[pres], comments = Keys[pres]},

      If[ Head[First[pres]] === LoadData, parsedSeq = Rest[parsedSeq]; comments = Rest[comments] ];

      t = TranslateToSMRMon[parsedSeq];

      (* Note that we can use:
         Fold[SMRMonBind[#1,#2]&,First[t],Rest[t]] *)
      Function[{x, c},
        Evaluate[
          DoubleLongRightArrow @@
              Prepend[Riffle[t,comments], TraceMonadUnit[SMRMonUnit[x, c]]]]
      ]
    ];


(*End[] * `Private` *)

(*EndPackage[]*)