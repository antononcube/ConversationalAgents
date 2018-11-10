(*
    Classifier workflows grammar Mathematica unit tests
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
    antononcube @ gmai l . c om,
    Windermere, Florida, USA.
*)

(*
    Mathematica is (C) Copyright 1988-2018 Wolfram Research, Inc.

    Protected by copyright law and international treaties.

    Unauthorized reproduction or distribution subject to severe civil
    and criminal penalties.

    Mathematica is a registered trademark of Wolfram Research, Inc.
*)

(* :Title: ClassificationWorkflowsGrammarUnitTests *)
(* :Context: ClassificationWorkflowsGrammarUnitTests` *)
(* :Author: Anton Antonov *)
(* :Date: 2018-02-05 *)

(* :Package Version: 0.4 *)
(* :Mathematica Version: *)
(* :Copyright: (c) 2018 Anton Antonov *)
(* :Keywords: *)
(* :Discussion:

   Before running the tests examine the test with TestID->"LoadPackage".

*)

BeginTestSection["ClassificationWorkflowsGrammarUnitTests.wlt"]

VerificationTest[(* 1 *)
  CompoundExpression[
    Import["~/ConversationalAgents/EBNF/English/Mathematica/ClassifierWorkflowsGrammar.m"],
    StringQ[ClConCommandsGrammar[]] && StringLength[ClConCommandsGrammar[]] > 15000
  ]
  ,
  True
  ,
  TestID->"LoadPackage"
]

VerificationTest[(* 2 *)
  TClConTokenizer = (ParseToTokens[#, {",", "'", "%", "-", "/"}, {" ", "\t", "\n"}] &);
  TestFunc = ParseShortest[pCLCONCOMMAND][TClConTokenizer[#]] &;
  ,
  Null
  ,
  TestID->"DefineTestFunc"
]

VerificationTest[(* 3 *)
  TestFunc["load the data for Titanic"]
  ,
  List[List[List[], LoadData[List[DataKind["data"], LocationSpec[DatabaseName["Titanic"]]]]]]
  ,
  TestID->"LoadData-1"
]

VerificationTest[(* 4 *)
  TestFunc["load the titanic data"]
  ,
  List[List[List[], LoadData[LocationSpec[DatabaseName["titanic"]]]]]
  ,
  TestID->"LoadData-2"
]

VerificationTest[(* 5 *)
  TestFunc["transform numerical columns into categorical"]
  ,
  List[List[List[], DataTransform[TransformColumns[List[TypeNumeric["numerical"], TypeString["categorical"]]]]]]
  ,
  TestID->"TransformData-1"
]

VerificationTest[(* 6 *)
  TestFunc["split data with 70 percent for training"]
  ,
  {{{}, SplitData[{SplitDataSpec[{PercentValue[NumericValue[70]], SplitPart["training"]}]}]}}
  ,
  TestID->"SplitData-1"
]

VerificationTest[(* 6 *)
  TestFunc["split data with 40% for testing"]
  ,
  {{{}, SplitData[{SplitDataSpec[{PercentValue[NumericValue[40]], SplitPart["testing"]}]}]}}
  ,
  TestID->"SplitData-2"
]

VerificationTest[(* 7 *)
  TestFunc["show data summary"]
  ,
  List[List[List[], SummarizeData[List[DisplayDirective["show"], List[]]]]]
  ,
  TestID->"DataSummary=1"
]

VerificationTest[(* 8 *)
  TestFunc["show test data summary"]
  ,
  List[List[List[], SummarizeData[List[DisplayDirective["show"], SplitPartList[List[SplitPart["test"]]]]]]]
  ,
  TestID->"TestDataSummary-1"
]

VerificationTest[(* 9 *)
  TestFunc["find data outliers per class"]
  ,
  List[List[List[], OutlierHandling[FindOutliers[FindOutliersPerClass[List[Outliers[List["outliers"]], List["per", List["class", List[]]]]]]]]]
  ,
  TestID->"FindOutliersPerClass-1"
]

VerificationTest[(* 10 *)
  TestFunc["show the outliers"]
  ,
  List[List[List[], OutlierHandling[ShowOutliers[List[DisplayDirective["show"], Outliers[List["outliers"]]]]]]]
  ,
  TestID->"ShowOutliers-1"
]

VerificationTest[(* 11 *)
  TestFunc["remove the outliers"]
  ,
  List[List[List[], OutlierHandling[RemoveOutliers[List["remove", Outliers[List["outliers"]]]]]]]
  ,
  TestID->"RemoveOutliers-1"
]

VerificationTest[
  TestFunc["show roc plots"],

  {{{}, ROCCurvesPlot[{DisplayDirective["show"], {ROCDiagram[Diagram["plots"]], {}}}]}},

  TestID -> "show-roc-plots"
]

VerificationTest[
  TestFunc["display roc plots over tpr and fpr"],

  {{{},
    ROCCurvesPlot[{DisplayDirective["display"], {ROCDiagram[Diagram["plots"]],ROCFunctionList[{ROCFunctionName["tpr"],ROCFunctionName["fpr"]}]}}]}},

  TestID -> "display-roc-plots-over-tpr-and-fpr"]


VerificationTest[

  TestFunc["display roc plots over SPC and FOR"],

  {{{},
    ROCCurvesPlot[{DisplayDirective["display"], {ROCDiagram[Diagram["plots"]], ROCFunctionList[{ROCFunction["SPC"], ROCFunction["FOR"]}]}}]}},

  TestID -> "display-roc-plots-over-SPC-and-FOR"]

VerificationTest[

  TestFunc["display roc list line plot for tpr, fpr and accuracy"],

  {{{}, ROCCurvesPlot[{DisplayDirective["display"],
    {ROCDiagram[ListLineDiagram[{"list", "line", Diagram["plot"]}]],
      ROCFunctionList[{ROCFunctionName["tpr"], ROCFunctionName["fpr"], ROCFunctionName["accuracy"]}]}}]}},

  TestID -> "display-roc-list-line-plot-for-tpr--fpr-and-accuracy"
]

VerificationTest[

  TestFunc["show list line roc plot for tpr, fpr, accuracy"],

  {{{},
    ROCCurvesPlot[{DisplayDirective["show"], {ROCDiagram[ListLineDiagram[{"list", "line", "roc", Diagram["plot"]}]],
      ROCFunctionList[{ROCFunctionName["tpr"], ROCFunctionName["fpr"],
        ROCFunctionName["accuracy"]}]}}]}},

  TestID -> "show-list-line-roc-plot-for-tpr--fpr--accuracy"
]

VerificationTest[

  t = Cases[TestFunc["train a gradient boosted trees classifier"], ClassifierAlgorithmName[x_] :> x, Infinity];
  Length[t] > 0 && Length[First@t] == 3,

  True,

  TestID -> "parse-longer-classifier-names"
]

VerificationTest[

  TestFunc["train an ensemble of 3 logistic regression classifiers"],

  {{{}, ClassifierEnsembleCreation[{{NumberOfClassifiers[
    NumericValue[3]],
    ClassifierAlgorithm[{ClassifierAlgorithmName[{"logistic", "regression"}], {}}]}, {}}]}},

  TestID -> "parse-classifier-ensemble"
]

EndTestSection[]
