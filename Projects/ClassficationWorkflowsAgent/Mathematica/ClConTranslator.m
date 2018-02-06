(*
    ClCon translator Mathematica package
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


(* :Title: ClConTranslator *)
(* :Context: ClConTranslator` *)
(* :Author: Anton Antonov *)
(* :Date: 2018-01-30 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: *)
(* :Copyright: (c) 2018 Anton Antonov *)
(* :Keywords: *)
(* :Discussion:


   # In brief

   This package has functions for translation of natural language commands of the grammar [1]
   to monadic pipelines or the monad [2].

   The translation process is fairly direct (simple) -- a natural language command is translated to pipeline operator(s).

   # How to use

   # References

   [1] Anton Antonov, Classifier workflows grammar in EBNF, 2018, ConversationalAgents at GitHub,
       https://github.com/antononcube/ConversationalAgents/blob/master/EBNF/ClassifierWorkflowsGrammar.ebnf

   [2] Anton Antonov, Monadic contextual classification Mathematica package, 2017, MathematicaForPrediction at GitHub,
       https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicContextualClassification.m


   This file was created by Mathematica Plugin for IntelliJ IDEA.

   Anton Antonov
   Florida, USA
   2018-01-30
*)

(* TODO

   1. [ ] Make a real package
   2. [ ] Complete implementation for the grammar in [1]
   3. [ ] Better explanations
   4. [ ] Re-write DoubleLongRightArrow with Fold

*)

(*BeginPackage["ClConTranslator`"]*)
(* Exported symbols added here with SymbolName::usage *)

(*Begin["`Private`"]*)

Clear[TGetValue]
TGetValue[parsed_, head_] :=
    If[FreeQ[parsed, head[___]], None, First@Cases[parsed, head[n___] :> n, {0, Infinity}]];


Clear[TLoadData]
TLoadData[parsed_] :=
    Block[{exampleGroup, dataName, data, ds, varNames},
      exampleGroup = "MachineLearning";
      dataName = Cases[parsed, (DatabaseName | DatasetName)[x_String] :> x, Infinity];

      If[Length[dataName] == 0, Return[$ClConFailure]];
      data = ExampleData[{exampleGroup, dataName[[1]]}, "Data"];
      If[Head[data] === ExampleData, Return[$ClConFailure]];
      ds = Dataset[Flatten@*List @@@ data];
      varNames =
          Flatten[List @@ ExampleData[{exampleGroup, dataName[[1]]}, "VariableDescriptions"]];
      If[dataName == "FisherIris", varNames = Most[varNames]];
      If[dataName == "Satellite",
        varNames =
            Append[Table[
              "Spectral-" <> ToString[i], {i, 1, Dimensions[ds][[2]] - 1}], "Type Of Land Surface"]];
      varNames =
          StringReplace[varNames,
            "edibility of mushroom (either edible or poisonous)" ~~ (WhitespaceCharacter ...) -> "edibility"];
      varNames =
          StringReplace[varNames,
            "wine quality (score between 1-10)" ~~ (WhitespaceCharacter ...) -> "wine quality"];
      varNames =
          StringJoin[
            StringReplace[
              StringSplit[#], {WordBoundary ~~ x_ :> ToUpperCase[x]}]] & /@ varNames;
      varNames = StringReplace[varNames, {StartOfString ~~ x_ :> ToLowerCase[x]}];
      ds = ds[All, AssociationThread[varNames -> #] &];
      ClConUnit[ds]
    ];


Clear[TSplitData]
TSplitData[parsed_] :=
    Block[{pctVal = None, splitPart = None},
      pctVal = TGetValue[TGetValue[parsed, PercentValue], NumericValue];
      splitPart = TGetValue[parsed, SplitPart];
      ClConSplitData[pctVal/100.]
    ];


Clear[TSummarizeData]
TSummarizeData[parsed_] :=
    Block[{},
      If[FreeQ[parsed, _SplitPartList | _SplitPart],
        ClConEchoFunctionValue["summaries:",
          Multicolumn[#, 5] & /@ (RecordsSummary /@ #) &],
        ClConEchoFunctionValue["summaries:",
          Multicolumn[#, 5] & /@ (RecordsSummary /@ #) &]
      ]
    ];


Clear[TClassifierNameRetrieval]
TClassifierNameRetrieval[parsed_] :=
    Block[{clName, clMethodNames},

      clMethodNames = {"DecisionTree", "GradientBoostedTrees",
        "LogisticRegression", "NaiveBayes", "NearestNeighbors", "NeuralNetwork",
        "RandomForest", "SupportVectorMachine"};

      clName = TGetValue[parsed, ClassifierAlgorithmName];

      If[clName === None,
        clName = TGetValue[parsed, ClassifierMethod],
        clName = StringJoin@StringReplace[clName, WordBoundary ~~ x_ :> ToUpperCase[x]]
      ];

      If[! MemberQ[clMethodNames, clName],
      (*This is redundant if the parsers for ClassifierMethod and ClassifierAlgorithmName use concrete names (not general string patterns.)*)

        Echo["Unknown classifier name:" <> ToString[clName] <> ". The classifier name should be one of " <> ToString[clMethodNames],
          "TClassifierCreation"];
        Return[$ClConFailure]
      ];

      clName
    ];


Clear[TClassifierCreation]
TClassifierCreation[parsed_] :=
    Block[{clName, clMethodNames},

      clName = TClassifierNameRetrieval[parsed];

      ClConMakeClassifier[clName]
    ];


Clear[TClassifierEnsembleCreation]
TClassifierEnsembleCreation[parsed_] :=
    Block[{clName, rsFraction, nClassifiers, rsFunc},

      clName = TClassifierNameRetrieval[parsed];
      If[ clName === $ClConFailure, Return[$ClConFailure]];

      rsFraction = TGetValue[parsed, PercentValue];
      If[ rsFraction === None,
        rsFraction = 0.9,
        rsFraction = TGetValue[rsFraction, NumericValue]
      ];

      nClassifiers = TGetValue[parsed, NumberOfClassifiers];
      If[ nClassifiers === None,
        nClassifiers = 3,
        nClassifiers = TGetValue[nClassifiers, NumericValue]
      ];

      ClConMakeClassifier[{<|"method" -> clName,
        "samplingFraction" -> rsFraction, "nClassifiers" -> nClassifiers,
        "samplingFunction" -> RandomSample|>}]

    ];


Clear[TClassifierTesting]
TClassifierTesting[parsed_] := parsed;


Clear[TTestResults]
TTestResults[parsed_] :=
    Block[{tms},
      If[FreeQ[parsed, TestMeasureList],
        Echo["No implementation for the given test specification.", "TTestResults:"]
      ];
      tms = TGetValue[parsed, TestMeasureList];
      Function[{x, c},
        ClConUnit[x,c]\[DoubleLongRightArrow]ClConClassifierMeasurements[{"Accuracy", "Precision", "Recall"}]\[DoubleLongRightArrow]ClConEchoValue]
    ];


Clear[TAccuraciesByVariableShuffling]
TAccuraciesByVariableShuffling[parsed_] :=
    Block[{},
      Function[{x, c},
        ClConUnit[x,c]\[DoubleLongRightArrow]ClConAccuracyByVariableShuffling[]\[DoubleLongRightArrow]ClConEchoValue]
    ];


(***********************************************************)
(* General pipeline commands                               *)
(***********************************************************)

Clear[TPipelineCommand]
TPipelineCommand[parsed_] := parsed;


Clear[TGetPipelineValue]
TGetPipelineValue[parsed_] := ClConEchoValue;


Clear[TGetPipelineContext]
TGetPipelineContext[parsed_] :=
    Block[{},

      Which[

        !FreeQ[parsed, _PipelineContextKeys ],
        ClConEchoFunctionContext["context keys:", Keys[#]& ],

        !FreeQ[parsed, _PipelineContextValue ],
        TPipelineContextRetrieve[parsed]

      ]
    ];


Clear[TPipelineContextRetrieve]
TPipelineContextRetrieve[parsed_] :=
    Block[{cvKey},

      cvKey = TGetValue[parsed, ContextKey];

      With[{k=cvKey}, ClConEchoFunctionContext["context value for:", #[k]& ]]

    ];


Clear[TPipelineContextAdd]
TPipelineContextAdd[parsed_] :=
    Block[{cvKey},

      cvKey = TGetValue[parsed, ContextKey];

      With[{k=cvKey}, ClConAddToContext[k] ]

    ];

(***********************************************************)
(* Main translation functions                              *)
(***********************************************************)

Clear[TranslateToClCon]

TranslateToClCon[commands_String, parser_Symbol:pCOMMAND] :=
    TranslateToClCon[ StringSplit[commands, {".", ";"}], parser ];

TranslateToClCon[commands:{_String..}, parser_Symbol:pCOMMAND] :=
    Block[{parsedSeq},
      parsedSeq = ParseShortest[parser][ToTokens[#]] & /@ commands;
      TranslateToClCon[ parsedSeq ]
    ];

TranslateToClCon[pres_] :=
    Block[{
      LoadData = TLoadData,
      SplitData = TSplitData,
      SummarizeData = TSummarizeData,
      ClassifierCreation = TClassifierCreation,
      ClassifierTesting = TClassifierTesting,
      TestResults = TTestResults,
      AccuraciesByVariableShuffling = TAccuraciesByVariableShuffling,
      ClassifierEnsembleCreation = TClassifierEnsembleCreation,
      PipelineCommand = TPipelineCommand,
      GetPipelineValue = TGetPipelineValue,
      GetPipelineContext = TGetPipelineContext,
      PipelineContextRetrieve = TPipelineContextRetrieve,
      PipelineContextAdd = TPipelineContextAdd},

      pres
    ];


Clear[ToClConPipelineFunction]

Options[ToClConPipelineFunction] = { "Trace"-> False };

ToClConPipelineFunction[commands_String, parser_Symbol:pCOMMAND, opts:OptionsPattern[] ] :=
    ToClConPipelineFunction[ StringSplit[commands, {".", ";"}], parser, opts ];

ToClConPipelineFunction[commands:{_String..}, parser_Symbol:pCOMMAND, opts:OptionsPattern[] ] :=
    Block[{parsedSeq},

      parsedSeq = ParseShortest[parser][ToTokens[#]] & /@ commands;

      If[ TrueQ[OptionValue[ToClConPipelineFunction, "Trace"]],

        ToClConPipelineFunction[ AssociationThread[ commands, parsedSeq[[All,1,2]] ] ],

        ToClConPipelineFunction[ parsedSeq[[All,1,2]] ]
      ]
    ];

ToClConPipelineFunction[pres_List] :=
    Block[{t, parsedSeq=pres},

      If[ Head[First[pres]] === LoadData, parsedSeq = Rest[pres]];

      t = TranslateToClCon[parsedSeq];

      (* Note that we can use:
         Fold[ClConBind[#1,#2]&,First[t],Rest[t]] *)
      Function[{x, c},
        Evaluate[DoubleLongRightArrow @@ Prepend[t, ClConUnit[x, c]]]]
    ];

ToClConPipelineFunction[pres_Association] :=
    Block[{t, parsedSeq=Values[pres], comments = Keys[pres]},

      If[ Head[First[pres]] === LoadData, parsedSeq = Rest[parsedSeq]; comments = Rest[comments] ];

      t = TranslateToClCon[parsedSeq];

      (* Note that we can use:
         Fold[ClConBind[#1,#2]&,First[t],Rest[t]] *)
      Function[{x, c},
        Evaluate[
          DoubleLongRightArrow @@
            Prepend[Riffle[t,comments], TraceMonadUnit[ClConUnit[x, c]]]]
      ]
    ];

(*End[] * `Private` *)

(*EndPackage[]*)