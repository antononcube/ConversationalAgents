(*
    External Parsers Hookup Mathematica package
    Copyright (C) 2019  Anton Antonov

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
   	antononcube @ gmail . com,
	  Windermere, Florida, USA.
*)

(*
    Mathematica is (C) Copyright 1988-2019 Wolfram Research, Inc.

    Protected by copyright law and international treaties.

    Unauthorized reproduction or distribution subject to severe civil
    and criminal penalties.

    Mathematica is a registered trademark of Wolfram Research, Inc.
*)

(* Created with the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ . *)

(* :Title: ExternalParsersHookup *)
(* :Context: ExternalParsersHookup` *)
(* :Author: Anton Antonov *)
(* :Date: 2019-08-27 *)

(* :Package Version: 0.5 *)
(* :Mathematica Version: 12.0 *)
(* :Copyright: (c) 2019 Anton Antonov *)
(* :Keywords: *)
(* :Discussion:

   [X] Needs refactoring!
   [ ] Should the corresponding monadic packages be loaded or not?
*)

(***********************************************************)
(* Load packages                                           *)
(***********************************************************)

If[ Length[DownValues[RakuCommand`RakuCommand]] == 0,
  Echo["RakuCommand.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/Packages/WL/RakuCommand.m"];
];

If[ Length[DownValues[MonadicContextualClassification`ClConUnit]] == 0,
  Echo["MonadicContextualClassification.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/MonadicProgramming/MonadicContextualClassification.m"];
];

If[ Length[DownValues[MonadicQuantileRegression`QRMonUnit]] == 0,
  Echo["MonadicQuantileRegression.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/MonadicProgramming/MonadicQuantileRegression.m"];
];

If[ Length[DownValues[MonadicStructuralBreaksFinder`QRMonFindChowTestLocalMaxima]] == 0,
  Echo["MonadicStructuralBreaksFinder.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/MonadicProgramming/MonadicStructuralBreaksFinder.m"];
];

If[ Length[DownValues[MonadicLatentSemanticAnalysis`LSAMonUnit]] == 0,
  Echo["MonadicLatentSemanticAnalysis.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/MonadicProgramming/MonadicLatentSemanticAnalysis.m"];
];

If[ Length[DownValues[MonadicSparseMatrixRecommender`SMRMonUnit]] == 0,
  Echo["MonadicSparseMatrixRecommender.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/MonadicProgramming/MonadicSparseMatrixRecommender.m"];
];

If[ Length[DownValues[MonadicEpidemiologyCompartmentalModeling`ECMMonUnit]] == 0,
  Echo["MonadicEpidemiologyCompartmentalModeling.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/SystemModeling/master/Projects/Coronavirus-propagation-dynamics/WL/MonadicEpidemiologyCompartmentalModeling.m"];
];

If[ Length[DownValues[DataReshape`ToLongForm]] == 0,
  Echo["DataReshape.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/DataReshape.m"];
];

If[ Length[DownValues[RakuMode`RakuInputExecute]] == 0,
  Echo["RakuMode.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/Packages/WL/RakuMode.m"];
];

(***********************************************************)
(* Package definitions                                     *)
(***********************************************************)

BeginPackage["ExternalParsersHookup`"];
(* Exported symbols added here with SymbolName::usage *)

$DSLUserIdentifier::usage = "DSL user identifier.";

ToDSLCode::usage = "Raku DSL comprehensive translation.";

ToMonadicCommand::usage = "Translates a natural language commands into a monadic pipeline.";

ToClassificationWorkflowCode::usage = "Translates a natural language commands into a ClCon pipeline.";

ToQuantileRegressionWorkflowCode::usage = "Translates a natural language commands into a QRMon pipeline.";

ToRecommenderWorkflowCode::usage = "Translates a natural language commands into a SMRMon pipeline.";

ToLatentSemanticAnalysisWorkflowCode::usage = "Translates a natural language commands into a LSAMon pipeline.";

ToEpidemiologyModelingWorkflowCode::usage = "Translates a natural language commands into a ECMMon pipeline.";

ToDataQueryWorkflowCode::usage = "Translates a natural language commands into a Data Query Workflow code.";

ToSearchEngineQueryCode::usage = "Translates a natural language commands into a Search Engine Query code.";

ToFoodPreparationWorkflowCode::usage = "Translates a natural language commands into a Food Preparation Workflow code.";

ToDataAcquisitionWorkflowCode::usage = "Translates a natural language commands into a Data Acquisition Workflow code.";

ToQRMonWLCommand::usage = "Translates a natural language commands into a QRMon-WL pipeline. Obsolete.";

ToSMRMonWLCommand::usage = "Translates a natural language commands into a SMRMon-WL pipeline. Obsolete.";

ToLSAMonWLCommand::usage = "Translates a natural language commands into a LSAMon-WL pipeline. Obsolete.";

ToECMMonWLCommand::usage = "Translates a natural language commands into a ECMMon-WL pipeline. Obsolete.";

CellPrintWL::usage = "CellPrintWL[s_String]";

CellPrintAndRunWL::usage = "CellPrintAndRunWL[s_String]";

CellPrintJulia::usage = "CellPrintJulia[s_String]";

CellPrintAndRunJulia::usage = "CellPrintAndRunJulia[s_String]";

CellPrintR::usage = "CellPrintR[s_String]";

CellPrintAndRunR::usage = "CellPrintAndRunR[s_String]";

CellPrintPython::usage = "CellPrintPython[s_String]";

CellPrintAndRunPython::usage = "CellPrintAndRunPython[s_String]";

DSLWebServiceInterpretationURL::usage = "Give DSL web service URL of a DSL command.";

DSLWebServiceInterpretation::usage = "Get the DSL web service interpretation of DSL command.";

Begin["`Private`"];

(*===========================================================*)
(* $DSLUserIdentifier                                        *)
(*===========================================================*)

$DSLUserIdentifier = None;


(*===========================================================*)
(* CellPrint                                                 *)
(*===========================================================*)

Clear[CellPrintWL];
CellPrintWL[s_String] := NotebookWrite[EvaluationNotebook[], Cell[s, "Input"], All];

Clear[CellPrintAndRunWL];
CellPrintAndRunWL[s_String] := (
  NotebookWrite[EvaluationNotebook[], Cell[s, "Input"], All];
  SelectionEvaluateCreateCell[EvaluationNotebook[]]
);

Clear[CellPrintJulia];
CellPrintJulia[s_String] :=
    NotebookWrite[EvaluationNotebook[], Cell[s, "ExternalLanguage", CellEvaluationLanguage -> "Julia"]];

Clear[CellPrintAndRunJulia];
CellPrintAndRunJulia[s_String] := (
  NotebookWrite[EvaluationNotebook[], Cell[s, "ExternalLanguage", CellEvaluationLanguage -> "Julia"], All];
  SelectionEvaluateCreateCell[EvaluationNotebook[]]
);

Clear[CellPrintR];
CellPrintR[s_String] :=
    NotebookWrite[EvaluationNotebook[], Cell["{\n" <> s <> "\n}", "ExternalLanguage", CellEvaluationLanguage -> "R"]];

Clear[CellPrintAndRunR];
CellPrintAndRunR[s_String] := (
  NotebookWrite[EvaluationNotebook[], Cell["{\n" <> s <> "\n}", "ExternalLanguage", CellEvaluationLanguage -> "R"], All];
  SelectionEvaluateCreateCell[EvaluationNotebook[]]);

Clear[CellPrintPython];
CellPrintPython[s_String] :=
    NotebookWrite[EvaluationNotebook[], Cell[s, "ExternalLanguage", CellEvaluationLanguage -> "Python"]];

Clear[CellPrintAndRunPython];
CellPrintAndRunPython[s_String] := (
  NotebookWrite[EvaluationNotebook[], Cell[s, "ExternalLanguage", CellEvaluationLanguage -> "Python"], All];
  SelectionEvaluateCreateCell[EvaluationNotebook[]]
);

aTargetLanguageToCellPrintFunc =
    <| "R" -> CellPrintR, "Python" -> CellPrintPython, "Julia" -> CellPrintJulia, "WL" -> CellPrintWL |>;

aTargetLanguageToCellPrintAndRunFunc =
    <| "R" -> CellPrintAndRunR, "Python" -> CellPrintAndRunPython, "Julia" -> CellPrintAndRunJulia, "WL" -> CellPrintAndRunWL |>;

(*===========================================================*)
(* ToDSLCode                                                 *)
(*===========================================================*)

Clear[ToDSLCode];

SyntaxInformation[ToDSLCode] = { "ArgumentsPattern" -> { _, OptionsPattern[] } };

ToDSLCode::nargs = "One string argument is expected.";

ToDSLCode::nmeth = "The value of the option Method is expected to be one of: `1`.";

Options[ToDSLCode] = {
  "UserIdentifier" -> Automatic,
  Method -> "PrintAndEvaluate"
};

ToDSLCode[commandArg_, opts : OptionsPattern[] ] :=
    Module[{command = commandArg, userID, method, pres, lsExpectedMethods, aRes, lang},

      userID = OptionValue[ ToDSLCode, "UserIdentifier" ];
      If[ TrueQ[ userID === Automatic ], userID = $DSLUserIdentifier ];
      If[ MemberQ[ {Anonymous, None}, userID ] || !StringQ[userID], userID = ""];

      method = OptionValue[ ToDSLCode, Method ];
      If[ TrueQ[ method === Automatic], method = "PrintAndEvaluate"];

      lsExpectedMethods = {"Automatic", "Print", "Evaluate", "PrintAndEvaluate", "Execute", "PrintAndExecute"};
      If[ !MemberQ[ ToLowerCase @ lsExpectedMethods, ToLowerCase @ method ],
        Message[ToDSLCode::nmeth, Prepend[ ToString[lsExpectedMethods], Automatic] ];
        Return[$Failed]
      ];

      method = ToLowerCase[method];

      If[ StringQ[userID] && StringLength[userID] > 0,
        command = "USER ID " <> userID <> " ;" <> command;
      ];

      If[ TrueQ[ Head[RakuMode`$RakuProcess] === ProcessObject ],

        (* Hoping that every time loading is not too slow. *)
        pres =
            RakuMode`RakuInputExecute[
              StringJoin[
                "use DSL::Shared::Utilities::ComprehensiveTranslation;",
                "say dsl-translate(\"",
                command,
                "\", defaultTargetsSpec => 'WL' )"]
            ],
        (*ELSE*)
        pres =
            RakuCommand`RakuCommand[
              StringJoin["say dsl-translate(\"", StringReplace[command, "\"" -> "\\\""], "\", defaultTargetsSpec => 'WL' )"],
              "",
              "DSL::Shared::Utilities::ComprehensiveTranslation"];
      ];

      (*      pres = StringTrim @ StringReplace[ pres, "\\\"" -> "\""];*)
      aRes = Association @ ImportString[ pres, "JSON"];

      If[ !AssociationQ[aRes],
        Return[$Failed]
      ];

      aRes["CODE"] = StringReplace[aRes["CODE"] , "==>" -> "\[DoubleLongRightArrow]"];

      lang = StringSplit[aRes["DSLTARGET"], "-"][[1]];

      If[ lang == "WL" && StringTake[command, -1] == ";" && StringTake[ aRes["CODE"], -1] != ";",
        aRes["CODE"] = aRes["CODE"] <> ";"
      ];

      $DSLUserIdentifier = aRes["USERID"];

      Which[
        MemberQ[ ToLowerCase @ { "Print" }, method] &&
            KeyExistsQ[aTargetLanguageToCellPrintFunc, lang],
        aTargetLanguageToCellPrintFunc[lang][aRes["CODE"]],

        MemberQ[ ToLowerCase @ { "PrintAndExecute", "PrintAndEvaluate" }, method] &&
            KeyExistsQ[aTargetLanguageToCellPrintAndRunFunc, lang],
        aTargetLanguageToCellPrintAndRunFunc[lang][aRes["CODE"]],

        MemberQ[ ToLowerCase @ { "Execute", "Evaluate" }, method] && lang == "WL",
        ToExpression[aRes["CODE"]],

        MemberQ[ ToLowerCase @ { "Execute", "Evaluate" }, method] &&
            KeyExistsQ[aTargetLanguageToCellPrintAndRunFunc, lang],
        ExternalEvaluate[lang, aRes["CODE"]],

        True,
        aRes
      ]
    ];

ToDSLCode[___] :=
    Block[{},
      Message[ToDSLCode::nargs];
      $Failed
    ];


(*===========================================================*)
(* ToMonadicCommand                                          *)
(*===========================================================*)

Clear[ToMonadicCommand];

SyntaxInformation[ToMonadicCommand] = { "ArgumentsPattern" -> { _, _, OptionsPattern[] } };

ToMonadicCommand::nmon = "Unknown monad name: `1`. The known monad names are `2`.";

ToMonadicCommand::ntgt = "The value of the option \"Target\" is expected to be a string.";

Options[ToMonadicCommand] = {
  "Target" -> "WL",
  "Execute" -> Automatic,
  "StringResult" -> Automatic
};

aRakuModules = <|
  "ClCon" -> "DSL::English::ClassificationWorkflows",
  "QRMon" -> "DSL::English::QuantileRegressionWorkflows",
  "SMRMon" -> "DSL::English::RecommenderWorkflows",
  "LSAMon" -> "DSL::English::LatentSemanticAnalysisWorkflows",
  "ECMMon" -> "DSL::English::EpidemiologyModelingWorkflows",
  "DataQuery" -> "DSL::English::DataQueryWorkflows",
  "SearchEngineQuery" -> "DSL::English::SearchEngineQueries",
  "FoodPreparation" -> "DSL::English::FoodPreparationWorkflows",
  "DataAcquisition" -> "DSL::English::DataAcquisitionWorkflows"
|>;
aRakuModules = Join[ aRakuModules, AssociationThread[Values[aRakuModules], Values[aRakuModules]] ];

aRakuFunctions = <|
  "ClCon" -> "ToClassificationWorkflowCode",
  "DSL::English::ClassificationWorkflows" -> "ToClassificationWorkflowCode",
  "QRMon" -> "ToQuantileRegressionWorkflowCode",
  "DSL::English::QuantileRegressionWorkflows" -> "ToQuantileRegressionWorkflowCode",
  "SMRMon" -> "ToRecommenderWorkflowCode",
  "DSL::English::RecommenderWorkflows" -> "ToRecommenderWorkflowCode",
  "LSAMon" -> "ToLatentSemanticAnalysisWorkflowCode",
  "DSL::English::LatentSemanticAnalysisWorkflows" -> "ToLatentSemanticAnalysisWorkflowCode",
  "ECMMon" -> "ToEpidemiologyModelingWorkflowCode",
  "DSL::English::EpidemiologyModelingWorkflows" -> "ToEpidemiologyModelingWorkflowCode",
  "DataQuery" -> "ToDataQueryWorkflowCode",
  "DSL::English::DataQueryWorkflows" -> "ToDataQueryWorkflowCode",
  "SearchEngineQuery" -> "ToSearchEngineQueryCode",
  "DSL::English::SearchEngineQueries" -> "ToSearchEngineQueryCode",
  "FoodPrep" -> "ToFoodPreparationWorkflowCode",
  "FoodPreparation" -> "ToFoodPreparationWorkflowCode",
  "DSL::English::FoodPreparationWorkflows" -> "ToFoodPreparationWorkflowCode",
  "DataAcquirer" -> "ToDataAcquisitionWorkflowCode",
  "DataAcquisition" -> "ToDataAcquisitionWorkflowCode",
  "DSL::English::DataAcquisitionWorkflows" -> "ToDataAcquisitionWorkflowCode"
|>;

ToMonadicCommand[command_, monadName_String, opts : OptionsPattern[] ] :=
    Block[{pres, executeQ, target, stringResultQ, res},

      executeQ = OptionValue[ ToMonadicCommand, "Execute" ];

      target = OptionValue[ ToMonadicCommand, "Target" ];
      If[ !StringQ[target],
        Message[ToMonadicCommand::ntgt];
        target = "WL";
      ];

      stringResultQ = OptionValue[ ToMonadicCommand, "StringResult" ];

      If[ TrueQ[executeQ === Automatic],
        executeQ = If[ target == "WL", True, False, False]
      ];
      executeQ = TrueQ[executeQ];

      If[ TrueQ[stringResultQ === Automatic],
        stringResultQ = If[ target == "WL", False, True, True]
      ];
      stringResultQ = TrueQ[stringResultQ];

      If[ !KeyExistsQ[aRakuModules, monadName],
        Message[ToMonadicCommand::nmon, monadName, Union @ Join[ Keys[aRakuModules], Values[aRakuModules] ] ];
        Return[$Failed]
      ];

      If[ TrueQ[ Head[RakuMode`$RakuProcess] === ProcessObject ],
        pres =
            RakuMode`RakuInputExecute[
              StringJoin["use " <> aRakuModules[monadName] <> "; say " <> aRakuFunctions[monadName] <> "(\"", command, "\", \"", target, "\")"]
            ],

        (*ELSE*)
        pres =
            RakuCommand`RakuCommand[
              StringJoin["say " <> aRakuFunctions[monadName] <> "(\"", command, "\", \"", target, "\")"],
              "",
              aRakuModules[monadName]]
      ];

      pres = StringReplace[pres, "==>" -> "\[DoubleLongRightArrow]"];
      pres = StringTrim @ StringReplace[ pres, "\\\"" -> "\""];

      Which[
        executeQ, ToExpression[pres],

        !stringResultQ,
        res = ToExpression[pres, StandardForm, Hold];
        If[ TrueQ[res === $Failed], pres, res],

        True, pres
      ]
    ];



(*===========================================================*)
(* ToClassificationWorkflowCode                              *)
(*===========================================================*)

Clear[ToClassificationWorkflowCode];

SyntaxInformation[ToClassificationWorkflowCode] = { "ArgumentsPattern" -> { _, OptionsPattern[] } };

Options[ToClassificationWorkflowCode] = Options[ToMonadicCommand];

ToClassificationWorkflowCode[ command_, opts : OptionsPattern[] ] := ToMonadicCommand[ command, "DSL::English::ClassificationWorkflows", opts];

ToClassificationWorkflowCode[___] := $Failed;


(*===========================================================*)
(* ToQuantileRegressionWorkflowCode                          *)
(*===========================================================*)

Clear[ToQuantileRegressionWorkflowCode];

SyntaxInformation[ToQuantileRegressionWorkflowCode] = { "ArgumentsPattern" -> { _, OptionsPattern[] } };

Options[ToQuantileRegressionWorkflowCode] = Options[ToMonadicCommand];

ToQuantileRegressionWorkflowCode[ command_, opts : OptionsPattern[] ] := ToMonadicCommand[ command, "DSL::English::QuantileRegressionWorkflows", opts];

ToQuantileRegressionWorkflowCode[___] := $Failed;

(*----*)

Clear[ToQRMonWLCommand];

Options[ToQRMonWLCommand] = Options[ToMonadicCommand];

ToQRMonWLCommand::obs = "Obsolete function; use ToQuantileRegressionWorkflowCode instead.";

ToQRMonWLCommand[ command_, execute_ : True, opts : OptionsPattern[] ] :=
    Block[{},
      Message[ToQRMonWLCommand::obs];
      ToMonadicCommand[ command, "DSL::English::QuantileRegressionWorkflows", Append[ DeleteCases[{opts}, HoldPattern["Execute" -> _] ], "Execute" -> execute ] ]
    ];


(*===========================================================*)
(* ToRecommenderWorkflowCode                                 *)
(*===========================================================*)

Clear[ToRecommenderWorkflowCode];

SyntaxInformation[ToRecommenderWorkflowCode] = { "ArgumentsPattern" -> { _, OptionsPattern[] } };

Options[ToRecommenderWorkflowCode] = Options[ToMonadicCommand];

ToRecommenderWorkflowCode[ command_, opts : OptionsPattern[] ] := ToMonadicCommand[ command, "DSL::English::RecommenderWorkflows", opts];

ToRecommenderWorkflowCode[___] := $Failed;

(*----*)

Clear[ToSMRMonWLCommand];

Options[ToSMRMonWLCommand] = Options[ToMonadicCommand];

ToSMRMonWLCommand::obs = "Obsolete function; use ToRecommenderWorkflowCode instead.";

ToSMRMonWLCommand[ command_, execute_ : True, opts : OptionsPattern[] ] :=
    Block[{},
      Message[ToSMRMonWLCommand::obs];
      ToMonadicCommand[ command, "DSL::English::RecommenderWorkflows", Append[ DeleteCases[{opts}, HoldPattern["Execute" -> _] ], "Execute" -> execute ] ]
    ];


(*===========================================================*)
(* ToLatentSemanticAnalysisWorkflowCode                                              *)
(*===========================================================*)

Clear[ToLatentSemanticAnalysisWorkflowCode];

SyntaxInformation[ToLatentSemanticAnalysisWorkflowCode] = { "ArgumentsPattern" -> { _, OptionsPattern[] } };

Options[ToLatentSemanticAnalysisWorkflowCode] = Options[ToMonadicCommand];

ToLatentSemanticAnalysisWorkflowCode[ command_, opts : OptionsPattern[] ] := ToMonadicCommand[ command, "DSL::English::LatentSemanticAnalysisWorkflows", opts];

ToLatentSemanticAnalysisWorkflowCode[___] := $Failed;

(*----*)

Clear[ToLSAMonWLCommand];

Options[ToLSAMonWLCommand] = Options[ToMonadicCommand];

ToLSAMonWLCommand::obs = "Obsolete function; use ToLatentSemanticAnalysisWorkflowCode instead.";

ToLSAMonWLCommand[ command_, execute_ : True, opts : OptionsPattern[] ] :=
    Block[{},
      Message[ToLSAMonWLCommand::obs];
      ToMonadicCommand[ command, "DSL::English::LatentSemanticAnalysisWorkflows", Append[ DeleteCases[{opts}, HoldPattern["Execute" -> _] ], "Execute" -> execute ] ]
    ];


(*===========================================================*)
(* ToECMMonCode                                              *)
(*===========================================================*)

Clear[ToEpidemiologyModelingWorkflowCode];

SyntaxInformation[ToEpidemiologyModelingWorkflowCode] = { "ArgumentsPattern" -> { _, OptionsPattern[] } };

Options[ToEpidemiologyModelingWorkflowCode] = Options[ToMonadicCommand];

ToEpidemiologyModelingWorkflowCode[ command_, opts : OptionsPattern[] ] :=
    ToMonadicCommand[ command, "DSL::English::EpidemiologyModelingWorkflows", opts];

ToEpidemiologyModelingWorkflowCode[___] := $Failed;

(*----*)

Clear[ToECMMonWLCommand];

Options[ToECMMonWLCommand] = Options[ToMonadicCommand];

ToECMMonWLCommand::obs = "Obsolete function; use ToECMMonCode instead.";

ToECMMonWLCommand[ command_, execute_ : True, opts : OptionsPattern[] ] :=
    Block[{},
      Message[ToECMMonWLCommand::obs];
      ToMonadicCommand[ command, "ECMMon", Append[ DeleteCases[{opts}, HoldPattern["Execute" -> _] ], "Execute" -> execute ] ]
    ];


(*===========================================================*)
(* ToDataQueryWorkflowCode                                   *)
(*===========================================================*)

Clear[ToDataQueryWorkflowCode];

SyntaxInformation[ToDataQueryWorkflowCode] = { "ArgumentsPattern" -> { _, OptionsPattern[] } };

Options[ToDataQueryWorkflowCode] = Options[ToMonadicCommand];

ToDataQueryWorkflowCode[ command_String, opts : OptionsPattern[] ] :=
    ToMonadicCommand[ command, "DSL::English::DataQueryWorkflows", opts];

ToDataQueryWorkflowCode[___] := $Failed;


(*===========================================================*)
(* ToSearchEngineQueryCode                                   *)
(*===========================================================*)

Clear[ToSearchEngineQueryCode];

SyntaxInformation[ToSearchEngineQueryCode] = { "ArgumentsPattern" -> { _, OptionsPattern[] } };

Options[ToSearchEngineQueryCode] = Options[ToMonadicCommand];

ToSearchEngineQueryCode[ command_String, opts : OptionsPattern[] ] :=
    ToMonadicCommand[ command, "DSL::English::SearchEngineQueries", opts];

ToSearchEngineQueryCode[___] := $Failed;


(*===========================================================*)
(* ToFoodPreparationWorkflowCode                             *)
(*===========================================================*)

Clear[ToFoodPreparationWorkflowCode];

SyntaxInformation[ToFoodPreparationWorkflowCode] = { "ArgumentsPattern" -> { _, OptionsPattern[] } };

Options[ToFoodPreparationWorkflowCode] = Options[ToMonadicCommand];

ToFoodPreparationWorkflowCode[ command_String, opts : OptionsPattern[] ] :=
    ToMonadicCommand[ command, "DSL::English::FoodPreparationWorkflows", opts];

ToFoodPreparationWorkflowCode[___] := $Failed;


(*===========================================================*)
(* ToDataAcquisitionWorkflowCode                             *)
(*===========================================================*)

Clear[ToDataAcquisitionWorkflowCode];

SyntaxInformation[ToDataAcquisitionWorkflowCode] = { "ArgumentsPattern" -> { _, OptionsPattern[] } };

Options[ToDataAcquisitionWorkflowCode] = Options[ToMonadicCommand];

ToDataAcquisitionWorkflowCode[ command_String, opts : OptionsPattern[] ] :=
    ToMonadicCommand[ command, "DSL::English::DataAcquisitionWorkflows", opts];

ToDataAcquisitionWorkflowCode[___] := $Failed;


(*===========================================================*)
(* DSL web service functions                                 *)
(*===========================================================*)

Clear[DSLWebServiceInterpretationURL, DSLWebServiceInterpretation];

Options[DSLWebServiceInterpretationURL] = {"URL" -> "http://accendodata.net:5040/translate/", "Sub" -> None};
DSLWebServiceInterpretationURL[command_String, opts : OptionsPattern[]] :=
    If[StringQ[OptionValue[DSLWebServiceInterpretationURL, "Sub"]],

      OptionValue[DSLWebServiceInterpretationURL, "URL"] <> OptionValue[DSLWebServiceInterpretationURL, "Sub"] <> "/" <> "'" <> URLEncode[command] <> "'",
      (*ELSE*)

      OptionValue[DSLWebServiceInterpretationURL, "URL"] <> "'" <> URLEncode[command] <> "'"
    ];

DSLWebServiceInterpretation::wlcop = "The value of the option \"WLCode\" is expected to be one of Automatic, False, or True";

DSLWebServiceInterpretation::nowl = "The value of the key \"CODE\" of the result is not WL code.";

Options[DSLWebServiceInterpretation] = Join[ Options[DSLWebServiceInterpretationURL], { "WLCode" -> Automatic } ];
DSLWebServiceInterpretation[command_String, opts : OptionsPattern[]] :=
    Block[{codeForm, url, aRes},

      codeForm = OptionValue[DSLWebServiceInterpretation, "WLCode"];

      url = DSLWebServiceInterpretationURL[command, FilterRules[{opts}, Options[DSLWebServiceInterpretationURL]]];

      aRes = Import[url, "JSON"];

      If[ !MatchQ[aRes, {_Rule..}],
        Return[aRes]
      ];

      aRes = Association[aRes];

      If[ !MemberQ[{Automatic, False, True}, codeForm],
        Message[DSLWebServiceInterpretation::wlcop]
      ];

      If[
        StringMatchQ[aRes["DSLTARGET"], ___ ~~ "WL" ~~ ___] && TrueQ[codeForm === Automatic] || TrueQ[codeForm],
        aRes["CODE"] = ToExpression["Hold[" <> StringReplace[aRes["CODE"], {"==>" -> "\[DoubleLongRightArrow]"}] <> "]"]
      ];

      aRes
    ];

End[]; (* `Private` *)

EndPackage[]