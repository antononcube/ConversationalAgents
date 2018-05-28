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
   to monadic pipelines of the monad [2].

   The translation process is fairly direct (simple) -- a natural language command is translated to pipeline operator(s).

   # How to use

   # References

   [1] Anton Antonov, Classifier workflows grammar in EBNF, 2018, ConversationalAgents at GitHub,
       https://github.com/antononcube/ConversationalAgents/blob/master/EBNF/ClassifierWorkflowsGrammar.m

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


If[Length[DownValues[ClassifierWorkflowsGrammar`pCLCONCOMMAND]] == 0,
  Echo["ClassifierWorkflowsGrammar.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/EBNF/ClassifierWorkflowsGrammar.m"]
];

(*
If I want all these functions to be in a package, I have to explicitly state the (global) context of the
ClassifierWorkflowsGrammar function heads given in parsing. Or pass it as an argument.
I decided I am fine with this not being a package.
*)

(*BeginPackage["ClConTranslator`"]*)

(*TranslateToClCon::usage = "Translates an expression with parsing outcomes by giving implementations to function heads."*)

(*ToClConPipelineFunction::usage = "Translates a string or a sequence of strings to a ClCon pipeline."*)

(*Begin["`Private`"]*)

(*Needs["FunctionalParsers`"]*)
(*Needs["ClassifierWorkflowsGrammar`"]*)

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
    Block[{pctVal = None, valPctVal = None, splitPart = None},

      Which[
        FreeQ[parsed, NumericValue],
        { pctVal, valPctVal } = { 75, 10 },

        !FreeQ[parsed, SplitDataRatioSpec],
        pctVal = TGetValue[First@TGetValue[parsed, SplitDataRatioSpec], NumericValue],

        True,
        pctVal = TGetValue[TGetValue[parsed, PercentValue], NumericValue];
        splitPart = TGetValue[parsed, SplitPart];
        If[ splitPart == "testing", pctVal = 100 - pctVal]

      ];

      If[ !FreeQ[parsed, SplitPart["validation"]],
        valPctVal = Cases[parsed, SplitDataSpec[{PercentValue[NumericValue[x_]], SplitPart["validation"]}] :> x, Infinity];
        If[ Length[valPctVal] == 0,
          Echo["Unexpected specification of validation part.", "TSplitData:"];
          valPctVal = 0,
          (*ELSE*)
          valPctVal = First[valPctVal]
        ]
      ];

      If[ TrueQ[valPctVal === None],
        ClConSplitData[pctVal/100.],
        ClConSplitData[pctVal/100., valPctVal/100.]
      ]
    ];


(***********************************************************)
(* Data statistics                                         *)
(***********************************************************)

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


Clear[TCrossTabulateData]
TCrossTabulateData[parsed_] := parsed;


Clear[TCrossTabulateVars]
TCrossTabulateVars[parsed_] :=
    Block[{},

      Echo["TCrossTabulateVars is not implemented yet"];
      $ClConFailure

    ];

(***********************************************************)
(* Classifier creation                                     *)
(***********************************************************)

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
        "sampleFraction" -> rsFraction, "numberOfClassifiers" -> nClassifiers,
        "samplingFunction" -> RandomSample|>}]

    ];


(***********************************************************)
(* Classifier queries                                      *)
(***********************************************************)

Clear[TClassifierQuery]
TClassifierQuery[parsed_] := parsed;

Clear[TClassifierInfo]
TClassifierInfo[parsed_]:=
    Block[{},
      ClConEchoFunctionContext["classifier info:",
        If[ AssociationQ[#["classifier"]],
          Map[ClassifierInformation, #["classifier"] ],
          ClassifierInformation[ #["classifier"] ]] &]
    ];


Clear[TClassifierPropertyNameRetrieval]
TClassifierPropertyNameRetrieval[parsed_] :=
    Block[{propName, clPropNames},

      clPropNames = {"Accuracy", "Classes", "ClassNumber", "EvaluationTime",
      "ExampleNumber", "FeatureNumber", "FunctionMemory",
      "FunctionProperties", "LearningCurve", "MaxTrainingMemory",
      "MeanCrossEntropy", "MethodDescription", "MethodOption",
      "Properties", "TrainingClassPriors", "TrainingTime", "ClassPriors",
      "FeatureNames", "FeatureTypes", "IndeterminateThreshold", "Method",
      "PerformanceGoal", "UtilityFunction"};

      propName = TGetValue[parsed, ClassifierInfoPropertyName];

      If[propName === None,
        propName = TGetValue[parsed, ClassifierInfoProperty],
        propName = StringJoin@StringReplace[propName, WordBoundary ~~ x_ :> ToUpperCase[x]]
      ];

      If[! MemberQ[clPropNames, propName],
      (*This is redundant if the parsers for ClassifierMethod and ClassifierAlgorithmName use concrete names (not general string patterns.)*)

        Echo["Unknown classifier property name:" <> ToString[propName] <> ". The classifier property name should be one of " <> ToString[clPropNames],
          "TClassifierGetInfoProperty"];
        Return[$ClConFailure]
      ];

      propName
    ];

Clear[TClassifierGetInfoProperty]
TClassifierGetInfoProperty[parsed_] :=
    Block[{propName},

      propName = TClassifierPropertyNameRetrieval[parsed];

      With[{pn=propName},
        ClConEchoFunctionContext["classifier property \"" <> propName <>"\" :",
        If[ AssociationQ[#["classifier"]],
          Map[ClassifierInformation[#,pn]&, #["classifier"] ],
          ClassifierInformation[ #["classifier"], pn ] ] &]
      ]

    ];


(***********************************************************)
(* Classifier testing                                      *)
(***********************************************************)

Clear[TTestMeasureNameRetrieval]
TTestMeasureNameRetrieval[parsed_] :=
    Block[{clmPropNames, propName, origPropName},

      clmPropNames = {"Accuracy", "AccuracyRejectionPlot", "AreaUnderROCCurve",
        "BestClassifiedExamples", "ClassifierFunction",
        "ClassMeanCrossEntropy", "ClassRejectionRate", "CohenKappa",
        "ConfusionFunction", "ConfusionMatrix", "ConfusionMatrixPlot",
        "CorrectlyClassifiedExamples", "DecisionUtilities", "Error",
        "Examples", "F1Score", "FalseDiscoveryRate", "FalseNegativeExamples",
        "FalseNegativeRate", "FalsePositiveExamples", "FalsePositiveRate",
        "GeometricMeanProbability", "IndeterminateExamples",
        "LeastCertainExamples", "Likelihood", "LogLikelihood",
        "MatthewsCorrelationCoefficient", "MeanCrossEntropy",
        "MeanDecisionUtility", "MisclassifiedExamples",
        "MostCertainExamples", "NegativePredictedValue", "Perplexity",
        "Precision", "Probabilities", "ProbabilityHistogram", "Properties",
        "Recall", "RejectionRate", "ROCCurve", "ScottPi", "Specificity",
        "TopConfusions", "TrueNegativeExamples", "TruePositiveExamples",
        "WorstClassifiedExamples"};

      propName = TGetValue[parsed, TestMeasureName];

      If[propName === None,
        propName = TGetValue[parsed, TestMeasure],
        (*ELSE*)
        origPropName = propName;
        propName = StringJoin@StringReplace[propName, WordBoundary ~~ x_ :> ToUpperCase[x]];
        propName = Pick[ clmPropNames, # == ToLowerCase[propName] & /@ ToLowerCase[clmPropNames] ];
        propName = If[ Length[propName] == 0, origPropName, First[propName] ]
      ];

      If[! MemberQ[ clmPropNames, propName ],
      (*This is redundant if the parsers for ClassifierMethod and ClassifierAlgorithmName use concrete names (not general string patterns.)*)

        Echo["Unknown classifier measurements property name:" <> ToString[propName] <>
             ". The classifier measurements property name should be one of " <> ToString[clmPropNames],
             "TTestMeasureNameRetrieval"];
        Return[$ClConFailure]
      ];

      propName
    ];


Clear[TClassifierTesting]
TClassifierTesting[parsed_] := parsed;


Clear[TTestResults]
TTestResults[parsed_] :=
    Block[{propNames, clTh, clLbl},

      If[FreeQ[parsed, TestMeasureList],
        Echo["No implementation for the given test specification.", "TTestResults:"]
      ];

      propNames = TGetValue[parsed, TestMeasureList];
      propNames = TTestMeasureNameRetrieval[#] & /@ propNames;

      clTh = TGetValue[parsed, ClassificationThreshold ];
      clLbl= TGetValue[clTh, ClassLabel ];
      clTh = TGetValue[clTh, NumericValue ];

      Which[

        FreeQ[parsed, DisplayDirective ] && FreeQ[ parsed, ClassificationThreshold ],
        ClConClassifierMeasurements[propNames],

        FreeQ[parsed, DisplayDirective ],
        ClConClassifierMeasurementsByThreshold[propNames, clLbl -> clTh],

        FreeQ[ parsed, ClassificationThreshold ],
        With[{cmArg = propNames},
          Function[{x, c},
            ClConUnit[x,c]\[DoubleLongRightArrow]ClConClassifierMeasurements[cmArg]\[DoubleLongRightArrow]ClConEchoValue]
        ],

        True,
        With[{cmArg = propNames, thArg = clTh, lblArg = clLbl },
          Function[{x, c},
            ClConUnit[x,c]\[DoubleLongRightArrow]ClConClassifierMeasurementsByThreshold[cmArg, lblArg -> thArg]\[DoubleLongRightArrow]ClConEchoValue]
        ]
      ]
    ];


Clear[TTestClassifier]
TTestClassifier[parsed_] :=
    ToClConPipelineFunction[ {"compute accuracy, precision, and recall", "show roc plots"} ];


(***********************************************************)
(* ROC plots                                               *)
(***********************************************************)

(* Note that this code is very similar / almost the same as the code of TTestMeasureNameRetrieval (above.) *)
Clear[TROCFunctionNameRetrieval]
TROCFunctionNameRetrieval[parsed_] :=
    Block[{rocFuncNames, funcName, origFuncName},

      rocFuncNames = {
        "TPR", "TNR", "SPC", "PPV", "NPV", "FPR", "FDR", "FNR", "ACC", "AUROC", "FOR", "F1",
        "Recall", "Sensitivity", "Precision", "Accuracy", "Specificity",
        "FalsePositiveRate", "TruePositiveRate", "FalseNegativeRate", "TrueNegativeRate", "FalseDiscoveryRate",
        "FalseOmissionRate", "F1Score", "AreaUnderROCCurve"};

      funcName = TGetValue[parsed, ROCFunctionName];

      If[funcName === None,
        funcName = TGetValue[parsed, ROCFunction],
      (*ELSE*)
        origFuncName = funcName;
        funcName = StringJoin@StringReplace[funcName, WordBoundary ~~ x_ :> ToUpperCase[x]];
        funcName = Pick[ rocFuncNames, # == ToLowerCase[funcName] & /@ ToLowerCase[rocFuncNames] ];
        funcName = If[ Length[funcName] == 0, origFuncName, First[funcName] ]
      ];

      If[! MemberQ[ rocFuncNames, funcName ],
      (*This is redundant if the parsers for ClassifierMethod and ClassifierAlgorithmName use concrete names (not general string patterns.)*)

        Echo["Unknown ROC function name:" <> ToString[funcName] <>
            ". The ROC function name should be one of " <> ToString[rocFuncNames],
          "TTestMeasureNameRetrieval"];
        Return[$ClConFailure]
      ];

      funcName
    ];

ClearAll[TROCCurvesPlot]
TROCCurvesPlot[parsed_] :=
    Block[{rocFuncNames},

      If[FreeQ[parsed, ROCFunctionList],
        (*Echo["No implementation for the given ROC specification.", "TROCCurvesPlot:"]*)
        rocFuncNames = { "FPR", "TPR"},
      (*ELSE*)
        rocFuncNames = TGetValue[parsed, ROCFunctionList];
        rocFuncNames = TROCFunctionNameRetrieval[#] & /@ rocFuncNames;
      ];

      Which[

        !FreeQ[ parsed, ListLineDiagram[__]],
        ClConROCListLinePlot[rocFuncNames],

        !FreeQ[ parsed, Diagram[__]] && Length[rocFuncNames] >= 2,
        ClConROCPlot[Sequence @@ Take[rocFuncNames, 2] ],

        True,
        Echo["Cannot translate ROC plot command.", "TROCCurvesPlot:"];
        Return[$ClConFailure]
      ]
];


(***********************************************************)
(* Classifier information                                  *)
(***********************************************************)

Clear[TClassifierGetInfoProperty]
TClassifierGetInfoProperty[parsed_] :=
    Block[{propName},

      propName = TClassifierPropertyNameRetrieval[parsed];

      With[{pn=propName},
        ClConEchoFunctionContext["classifier property \"" <> propName <>"\" :",
          If[ AssociationQ[#["classifier"]],
            Map[ClassifierInformation[#,pn]&, #["classifier"] ],
            ClassifierInformation[ #["classifier"], pn ] ] &]
      ]

    ];


(***********************************************************)
(* Importance of variables                                 *)
(***********************************************************)

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
(* Generate pipeline commands                              *)
(***********************************************************)

TGeneratePipeline[parsed_] :=
    Block[{clName},

      clName = TGetValue[parsed, ClassifierAlgorithmName];

      If[clName === None,
        clName = TGetValue[parsed, ClassifierMethod],
        clName = StringJoin@StringReplace[clName, WordBoundary ~~ x_ :> ToUpperCase[x]]
      ];

      If[clName === None, clName = "logistic regression"];

      ToClConPipelineFunction[{
        "split data with 70 percent for training",
        "show data summary",
        "create a " <> clName <> " classifier",
        "show classifier classes",
        "show classifier training time",
        "show accuracy and precision and recall",
        "show roc plot of FPR and TPR"
      }]

    ];


(***********************************************************)
(* Second order commands                                   *)
(***********************************************************)

TSecondOrderCommand[parsed_] := parsed;

(***********************************************************)
(* Main translation functions                              *)
(***********************************************************)

ClearAll[TranslateToClCon]

Options[TranslateToClCon] = { "TokenizerFunction" -> (ParseToTokens[#, {",", "'"}, {" ", "\t", "\n"}]&) };

TranslateToClCon[commands_String, parser_Symbol:pCLCONCOMMAND, opts:OptionsPattern[]] :=
    TranslateToClCon[ StringSplit[commands, {".", ";"}], parser, opts ];

TranslateToClCon[commands:{_String..}, parser_Symbol:pCLCONCOMMAND, opts:OptionsPattern[]] :=
    Block[{parsedSeq, tokenizerFunc },

      tokenizerFunc = OptionValue[ToClConPipelineFunction, "TokenizerFunction"];

      parsedSeq = ParseShortest[parser][tokenizerFunc[#]] & /@ commands;

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
      TestClassifier = TTestClassifier,
      ROCCurvesPlot = TROCCurvesPlot,
      AccuraciesByVariableShuffling = TAccuraciesByVariableShuffling,
      ClassifierEnsembleCreation = TClassifierEnsembleCreation,
      ClassifierQuery = TClassifierQuery,
      ClassifierInfo = TClassifierInfo,
      ClassifierGetInfoProperty = TClassifierGetInfoProperty,
      PipelineCommand = TPipelineCommand,
      GetPipelineValue = TGetPipelineValue,
      GetPipelineContext = TGetPipelineContext,
      PipelineContextRetrieve = TPipelineContextRetrieve,
      PipelineContextAdd = TPipelineContextAdd,
      GeneratePipeline = TGeneratePipeline,
      SecondOrderCommand = TSecondOrderCommand},

      pres
    ];


ClearAll[ToClConPipelineFunction]

Options[ToClConPipelineFunction] =
    { "Trace" -> False,
      "TokenizerFunction" -> (ParseToTokens[#, {",", "'", "%", "-", "/"}, {" ", "\t", "\n"}]&),
      "Flatten" -> True };

ToClConPipelineFunction[commands_String, parser_Symbol:pCLCONCOMMAND, opts:OptionsPattern[] ] :=
    ToClConPipelineFunction[ StringSplit[commands, {";"}], parser, opts ];

ToClConPipelineFunction[commands:{_String..}, parser_Symbol:pCLCONCOMMAND, opts:OptionsPattern[] ] :=
    Block[{parsedSeq, tokenizerFunc, res},

      tokenizerFunc = OptionValue[ToClConPipelineFunction, "TokenizerFunction"];

      parsedSeq = ParseShortest[parser][tokenizerFunc[#]] & /@ commands;

      parsedSeq = Select[parsedSeq, Length[#] > 0& ];

      If[ Length[parsedSeq] == 0,
        Echo["Cannot parse command(s).", "ToClConPipelineFunction:"];
        Return[$ClConFailure]
      ];

      res =
          If[ TrueQ[OptionValue[ToClConPipelineFunction, "Trace"]],

            ToClConPipelineFunction[ AssociationThread[ commands, parsedSeq[[All,1,2]] ] ],
          (*ELSE*)
            ToClConPipelineFunction[ parsedSeq[[All,1,2]] ]
          ];

      If[ TrueQ[OptionValue[ToClConPipelineFunction, "Flatten"] ],
        res //. DoubleLongRightArrow[DoubleLongRightArrow[x__], y__] :> DoubleLongRightArrow[x, y],
      (*ELSE*)
        res
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