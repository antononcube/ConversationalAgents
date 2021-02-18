(*
    Raku Grammar Classes Generation Mathematica package
    Copyright (C) 2021  Anton Antonov

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
   	antononcube @ posteo . net,
	  Windermere, Florida, USA.
*)

(*
    Mathematica is (C) Copyright 1988-2021 Wolfram Research, Inc.

    Protected by copyright law and international treaties.

    Unauthorized reproduction or distribution subject to severe civil
    and criminal penalties.

    Mathematica is a registered trademark of Wolfram Research, Inc.
*)

(* Created with the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ . *)

(* :Title: RakuGrammarClassesGeneration *)
(* :Context: RakuGrammarClassesGeneration` *)
(* :Author: Anton Antonov *)
(* :Date: 2021-02-17 *)

(* :Package Version: 0.4 *)
(* :Mathematica Version: 12.1 *)
(* :Copyright: (c) 2021 Anton Antonov *)
(* :Keywords: Parser, Raku, Mathematica, WL, code generation *)
(* :Discussion:

# In brief

This package has Mathematica / Wolfram Language (WL) functions for generating Raku (Perl 6) grammar
classes and roles.

The primary motivation for the functionality is to make Raku grammars for entities like
WL's classifier measurements properties.

# Usage

Here is WL code that give `ClassifierMeasurements` properties:

```mathematica
With[{n = 20}, {trainingData, testingData} = TakeDrop[MapThread[Rule, {RandomReal[{1, 10}, {n, 4}], RandomChoice[{"T", "F"}, n]}], 15]];
cf = Classify[trainingData];
cm = ClassifierMeasurements[cf, testingData];
cm["Properties"]

(*
{"Accuracy", "AccuracyBaseline", "AccuracyRejectionPlot",
"AreaUnderROCCurve", "BatchEvaluationTime", "BestClassifiedExamples",
"CalibrationCurve", "CalibrationData", "ClassifierFunction",
"ClassMeanCrossEntropy", "ClassRejectionRate", "CohenKappa",
"ConfusionDistribution", "ConfusionFunction", "ConfusionMatrix",
"ConfusionMatrixPlot", "CorrectlyClassifiedExamples",
"DecisionUtilities", "Error", "EvaluationTime", "Examples",
"F1Score", "FalseDiscoveryRate", "FalseNegativeExamples",
"FalseNegativeNumber", "FalseNegativeRate", "FalsePositiveExamples",
"FalsePositiveNumber", "FalsePositiveRate",
"GeometricMeanProbability", "IndeterminateExamples",
"LeastCertainExamples", "Likelihood", "LinearCalibrationCurve",
"LogLikelihood", "MatthewsCorrelationCoefficient",
"MeanCrossEntropy", "MeanDecisionUtility", "MisclassifiedExamples",
"MostCertainExamples", "NegativePredictiveValue", "Perplexity",
"Precision", "Probabilities", "ProbabilityHistogram", "Properties",
"Recall", "RejectionRate", "Report", "ROCCurve", "ScottPi",
"Specificity", "TopConfusions", "TrueNegativeExamples",
"TrueNegativeNumber", "TruePositiveExamples", "TruePositiveNumber",
"WorstClassifiedExamples"}
*)
```

We want to split the WL properties names into their words. I.e.

```
"TrueNegativeNumber" -> {"true", "negative", "number"}
```

assume that we get proper English phrases and make parser(s) that match those phrases.

Here is a command to do that:

```mathematica
MakePropertyRole[
  cm["Properties"],
  "RoleName" -> "ClassifierMeasurements",
  "TopRuleName" -> "wl-classifier-measurement",
  "RuleSuffix" -> "-measure",
  "WordTokenSuffix" -> "-measure-word"]
```

# History

The original versions of these functions were made for the Raku DSL grammars for
the software monads `ClCon` and `ECMMon`.

------
Anton Antonov
Windermere, Florida, 2021

*)

BeginPackage["RakuGrammarClassesGeneration`"];
(* Exported symbols added here with SymbolName::usage *)

MakePropertyActionClass::usage = "MakePropertyActionClass";

MakeRoleByPhrases::usage = "MakeRoleByPhrases";

NormalizeRakuReference::usage = "NormalizeRakuReference";

ToRakuRegex::usage = "ToRakuRegex";

ToRakuRuleReference::usage = "ToRakuRuleReference";

ToRakuTerminal::usage = "ToRakuTerminal";

ToRakuTests::usage = "ToRakuTests";

ToRakuToken::usage = "ToRakuToken";

Begin["`Private`"];

(***********************************************************)
(* Basic functions                                         *)
(***********************************************************)

Clear[ToRakuTerminal];

ToRakuTerminal[s_String] := ToRakuTerminal[StringSplit[s]];

ToRakuTerminal[s : {_String ..}] :=
    StringRiffle[Map["'" <> StringReplace[#, {"'" -> "\'"}] <> "'" &, s], " "];

Clear[ToRakuRegex];

ToRakuRegex[s_String, suffix_String, delim_String : "\\\\h+"] :=
    ToRakuRegex[StringSplit[StringReplace[s, LetterCharacter ~~ "-" ~~ LetterCharacter -> " " <> "-" <> " "]], suffix, delim];

ToRakuRegex[s : {_String ..}, suffix_String, delim_String : "\\\\h+"] :=
    StringReplace[
      StringRiffle[Map["<" <> NormalizeRakuReference[# <> suffix] <> ">" &, s], " " <> delim <> " "],
      "\\\\" -> "\\"
    ];

Clear[ToRakuToken];

ToRakuToken[s : ( _String | { _String .. } ) , suffix_String ] := ToRakuRegex[s, suffix, " "];

Clear[NormalizeRakuReference];

NormalizeRakuReference[s_String] :=
    Block[{res},
      res =
          StringReplace[ s,
            {
              n : (DigitCharacter..) :> IntegerName[ToExpression[n]] <> "-int",
              c : ( "'" | "&" | "%" | "." | "_" | "?" | "!" | ";" | ":" | "," ) :> "-" <> CharacterName[c] <> "-",
              d : DigitCharacter :> CharacterName[d],
              {"/", "(", ")"} -> "-"}
          ];
      StringReplace[
        res,
        {
          StartOfString ~~ "--" -> CharacterName["-"] <> "-",
          StartOfString ~~ "-" ~~ EndOfString -> CharacterName["-"],
          StartOfString ~~ "-" -> "",
          "-" ~~ EndOfString -> "",
          "---" -> "-" <> CharacterName["-"] <> "-",
          "--" -> "-"
        }
      ]
    ];

Clear[ToRakuRuleReference];

ToRakuRuleReference[s_String] := "<" <> NormalizeRakuReference[s] <> ">";

(***********************************************************)
(* MakePropertyRole                                        *)
(***********************************************************)

Clear[MakeRoleByPhrases];

SyntaxInformation[MakeRoleByPhrases] = {"ArgumentsPattern" -> {_, OptionsPattern[]}};

Options[MakeRoleByPhrases] = {
  "RuleSuffix" -> "-prop",
  "RoleName" -> "SomeRole",
  "TopRuleName" -> "some-rule",
  "WordTokenSuffix" -> "-word",
  "SeparateTerminals" -> True,
  "TokensForJoinedPhrases" -> True,
  "SplitWordsByCapitalLetters" -> False,
  "Regexes" -> False
};

MakeRoleByPhrases[properties : {_String ..}, opts : OptionsPattern[]] :=
    Block[{lsPhrases},
      If[ TrueQ[OptionValue[MakeRoleByPhrases, "SplitWordsByCapitalLetters"]],
        lsPhrases = Map[ToLowerCase @ StringCases[#, CharacterRange["A", "Z"] ~~ (Except[CharacterRange["A", "Z"]] ..)] &, properties],
        (* ELSE *)
        lsPhrases = StringSplit[properties]
      ];
      MakeRoleByPhrases[lsPhrases, opts]
    ];

MakeRoleByPhrases[ phrases : { {_String ..} .. }, opts : OptionsPattern[]] :=
    Block[{ruleSuffix, roleName, topRuleName, wordTokenSuffix,
      separateTerminalsQ, tokensForJoinedPhrasesQ,
      lsRakuTokens, lsRakuRules, lsJoinedPhrases, lsPropertyWords,
      regexFunc, rakuMethod},

      ruleSuffix = OptionValue[MakeRoleByPhrases, "RuleSuffix"];
      roleName = OptionValue[MakeRoleByPhrases, "RoleName"];
      topRuleName = OptionValue[MakeRoleByPhrases, "TopRuleName"];
      wordTokenSuffix = OptionValue[MakeRoleByPhrases, "WordTokenSuffix"];
      separateTerminalsQ = TrueQ[OptionValue[MakeRoleByPhrases, "SeparateTerminals"]];
      tokensForJoinedPhrasesQ = TrueQ[OptionValue[MakeRoleByPhrases, "TokensForJoinedPhrases"]];

      If[ TrueQ[OptionValue[MakeRoleByPhrases, "Regexes"]],
        regexFunc = ToRakuRegex;
        rakuMethod = "regex",
        (*ELSE*)
        regexFunc = ToRakuToken;
        rakuMethod = "rule"
      ];

      lsJoinedPhrases = StringJoin@*Capitalize /@ phrases;

      lsPropertyWords = Union[Flatten[phrases]];

      lsRakuTokens =
          Map[# -> "token " <> NormalizeRakuReference[# <> wordTokenSuffix] <> " {" <> ToRakuTerminal[#] <> "}" &, lsPropertyWords];

      (* This is association in*)
      lsRakuRules =
          MapThread[
            With[{name = StringRiffle[#1, "-"] <> ruleSuffix},
              name ->
                  rakuMethod <> " " <> NormalizeRakuReference[name] <> " { " <> NormalizeRakuReference[regexFunc[#1, wordTokenSuffix]] <> If[ tokensForJoinedPhrasesQ, " | " <> ToRakuTerminal[#2], "" ] <> "}"
            ] &,
            {phrases, lsJoinedPhrases}];

      lsRakuRules =
          Prepend[Values[lsRakuRules], "rule " <> topRuleName <> " {" <> StringRiffle[ToRakuRuleReference /@ Keys[lsRakuRules], " |\n"] <> "}"];
      lsRakuRules = Join[lsRakuRules, Values[lsRakuTokens]];

      StringRiffle[Join[{"role " <> roleName <> " {"}, lsRakuRules, {"}"}], "\n"]
    ];


(***********************************************************)
(* MakePropertyActionClass                                 *)
(***********************************************************)

Clear[MakePropertyActionClass];

SyntaxInformation[MakePropertyActionClass] = {"ArgumentsPattern" -> {_, OptionsPattern[]}};

Options[MakePropertyActionClass] = {"RuleSuffix" -> "-prop", "ClassName" -> "SomeClass", "TopRuleName" -> "some-rule"};

MakePropertyActionClass[properties : {_String ..}, opts : OptionsPattern[]] :=

    Block[{ruleSuffix, className, topRuleName, lsRakuRules},

      ruleSuffix = OptionValue[MakePropertyActionClass, "RuleSuffix"];
      className = OptionValue[MakePropertyActionClass, "ClassName"];
      topRuleName = OptionValue[MakePropertyActionClass, "TopRuleName"];

      lsRakuRules =
          MapThread[
            With[{name = StringTake[ ToRakuToken[#, ruleSuffix], {2, -2}] },
              name -> "method " <> name <> "($/) { make " <> ToRakuTerminal[#2] <> "; }"
            ] &,
            {Map[ToLowerCase @ StringCases[#, CharacterRange["A", "Z"] ~~ (Except[CharacterRange["A", "Z"]] ..)] &, properties], properties}];

      lsRakuRules = Prepend[Values[lsRakuRules], "method " <> topRuleName <> "($/) { make '\"' ~ $/.values[0].made ~ '\"'; }"];

      StringRiffle[Join[{"class " <> className <> " {"}, lsRakuRules, {"}"}], "\n"]
    ];


(***********************************************************)
(* ToRakuTests                                             *)
(***********************************************************)

Clear[ToRakuTests];
ToRakuTests[queries : {_String ..}] :=
    StringRiffle[Map["ok $pCOMMAND.parse('" <> # <> "'),\n" <> "'" <> # <> "'" <> ";\n" &, queries], "\n"];

End[]; (* `Private` *)

EndPackage[]