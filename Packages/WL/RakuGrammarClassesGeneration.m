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
MakeRoleByPhrases[
  SplitWordsByCapitalLetters /@ cm["Properties"],
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

(***********************************************************)
(* Load packages                                           *)
(***********************************************************)

If[ Length[DownValues[TriesWithFrequencies`TrieQ]] == 0,
  Echo["TriesWithFrequencies.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/TriesWithFrequencies.m"];
];


(***********************************************************)
(* Package definitions                                     *)
(***********************************************************)


BeginPackage["RakuGrammarClassesGeneration`"];
(* Exported symbols added here with SymbolName::usage *)

ToLowerCaseWithExclusions::usage = "ToLowerCaseWithExclusions[s : (_String | {_String..}), excls]
the string or list of strings s into lower case by keeping certain specified strings (exclusions) unchanged.";

SplitWordsByCapitalLetters::usage = "SplitWordsByCapitalLetters[s_String] splits the string s into
sub-strings of s that start with a capital letter.";

MakePropertyActionClass::usage = "MakePropertyActionClass";

MakeRoleByPhrases::usage = "MakeRoleByPhrases[phrases : ( {_String..} | {{_String..}..}), opts___ ]";

MakeRoleByTrie::usage = "MakeRoleByTrie[trie_?TrieQ, opts___]";

NormalizeRakuReference::usage = "NormalizeRakuReference";

ToRakuRegex::usage = "ToRakuRegex";

ToRakuRuleReference::usage = "ToRakuRuleReference";

ToRakuTerminal::usage = "ToRakuTerminal";

ToRakuTests::usage = "ToRakuTests";

ToRakuToken::usage = "ToRakuToken";

Begin["`Private`"];

Needs["TriesWithFrequencies`"];


(***********************************************************)
(* ToLowerCaseWithExclusions                              *)
(***********************************************************)

Clear[ToLowerCaseWithExclusions];
ToLowerCaseWithExclusions[s : (_String | {_String..})] := ToLowerCaseWithExclusions[s, Automatic];
ToLowerCaseWithExclusions[s_String, excls : (Automatic | {(_String | Automatic) ..})] :=
    Block[{lsExclusions, lsWords, lsAuto, aPos},

      lsExclusions = Select[Flatten@{excls}, StringQ];

      If[! FreeQ[{excls}, Automatic],
        lsWords = StringSplit[s, {WhitespaceCharacter, PunctuationCharacter}];
        lsAuto = Pick[lsWords, StringMatchQ[lsWords, x : (CharacterRange["A", "Z"] ..) /; StringLength[x] >= 3]];
        lsExclusions = Join[lsExclusions, lsAuto]
      ];

      aPos = Select[Association[Map[# -> StringPosition[s, #] &, lsExclusions]], Length[#] > 0 &];
      Fold[StringReplacePart[#1, #2[[1]], #2[[2]]] &, ToLowerCase[s], Normal@aPos]
    ];

ToLowerCaseWithExclusions[s_List, excls_] := Map[ToLowerCaseWithExclusions[#, excls]&, s];


(***********************************************************)
(* SplitWordsByCapitalLetters                              *)
(***********************************************************)

Clear[SplitWordsByCapitalLetters];

(*SplitWordsByCapitalLetters[word_String] :=*)
(*    {word} /; StringMatchQ[word, (CharacterRange["A", "Z"]..)];*)

SplitWordsByCapitalLetters[word_String] :=
    StringCases[word, CharacterRange["A", "Z"] ~~ (Except[CharacterRange["A", "Z"]] ...)];

SplitWordsByCapitalLetters[words : { _String ..} ] := Map[ SplitWordsByCapitalLetters, words];


(***********************************************************)
(* ToRakuTerminal                                          *)
(***********************************************************)

Clear[ToRakuTerminal];

ToRakuTerminal[s_String] := ToRakuTerminal[StringSplit[s]];

ToRakuTerminal[s : {_String ..}] :=
    StringRiffle[Map["'" <> StringReplace[#, {"'" -> "\'"}] <> "'" &, s], " "];

ToRakuTerminal[{}] := "EMPTY";


(***********************************************************)
(* ToRakuRegex                                             *)
(***********************************************************)

Clear[ToRakuRegex];

ToRakuRegex[s_String, suffix_String, delim_String : "\\\\h+"] :=
    "<" <> NormalizeRakuReference[s <> suffix] <> ">" /; StringFreeQ[s, " "];

ToRakuRegex[s_String, suffix_String, delim_String : "\\\\h+"] :=
    ToRakuRegex[StringSplit[StringReplace[s, LetterCharacter ~~ "-" ~~ LetterCharacter -> " " <> "-" <> " "]], suffix, delim] /; Not[StringFreeQ[s, " "]];

ToRakuRegex[s : {_String ..}, suffix_String, delimArg_String : "\\\\h+"] :=
    Block[{delim = delimArg},
      If[delim != " ", delim = " " <> delim <> " "];
      StringReplace[
        StringRiffle[Map["<" <> NormalizeRakuReference[# <> suffix] <> ">" &, s], delim],
        "\\\\" -> "\\"
      ]
    ];

ToRakuRegex[alts : Alternatives[__], suffix_String, delim_String : "\\\\h+"] :=
    Block[{res},

      res = "[ " <> StringRiffle[ Map[ ToRakuRegex[#, suffix, delim]&, List @@ alts], " | "] <> " ]";

      StringReplace[ res, "\\\\" -> "\\"]
    ];

ToRakuRegex[s : { (_String | Alternatives[__]) .. }, suffix_String, delimArg_String : "\\\\h+"] :=
    Block[{res, delim = delimArg},

      If[delim != " ", delim = " " <> delim <> " "];

      (* No need for the If, but it shows the decomposition into functions. *)
      res =
          Map[
            If[ StringQ[#],
              ToRakuRegex[#, suffix, delim],
              (*ELSE*)
              ToRakuRegex[#, suffix, delim]
            ]&,
            s
          ];

      StringReplace[
        StringRiffle[res, delim],
        {"\\\\" -> "\\", "  " -> " "}
      ]
    ];


(***********************************************************)
(* ToRakuToken                                             *)
(***********************************************************)

Clear[ToRakuToken];

ToRakuToken[s : ( _String | { _String .. } ) , suffix_String ] := ToRakuRegex[s, suffix, " "];


(***********************************************************)
(* NormalizeRakuReference                                  *)
(***********************************************************)

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


(***********************************************************)
(* ToRakuRuleReference                                     *)
(***********************************************************)

Clear[ToRakuRuleReference];

ToRakuRuleReference[s_String] := "<" <> NormalizeRakuReference[s] <> ">";


(***********************************************************)
(* MakeRoleByPhrases                                       *)
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
  "TerminalModifier" -> ToLowerCase,
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
      separateTerminalsQ, tokensForJoinedPhrasesQ, terminalModifierFunc,
      lsRakuTokens, lsRakuRules, lsJoinedPhrases, lsPropertyWords,
      regexFunc, rakuMethod},

      ruleSuffix = OptionValue[MakeRoleByPhrases, "RuleSuffix"];
      roleName = OptionValue[MakeRoleByPhrases, "RoleName"];
      topRuleName = OptionValue[MakeRoleByPhrases, "TopRuleName"];
      wordTokenSuffix = OptionValue[MakeRoleByPhrases, "WordTokenSuffix"];
      separateTerminalsQ = TrueQ[OptionValue[MakeRoleByPhrases, "SeparateTerminals"]];
      tokensForJoinedPhrasesQ = TrueQ[OptionValue[MakeRoleByPhrases, "TokensForJoinedPhrases"]];
      terminalModifierFunc = OptionValue[MakeRoleByPhrases, "TerminalModifier"];

      If[ TrueQ[terminalModifierFunc === Automatic], terminalModifierFunc = ToLowerCase ];

      If[ TrueQ[OptionValue[MakeRoleByPhrases, "Regexes"]],
        regexFunc = ToRakuRegex;
        rakuMethod = "regex",
        (*ELSE*)
        regexFunc = ToRakuToken;
        rakuMethod = "rule"
      ];

      lsJoinedPhrases = StringJoin /@ Map[ Capitalize, phrases, {-1}];

      lsPropertyWords = Union[Flatten[phrases]];

      lsRakuTokens =
          Map[# -> "token " <> NormalizeRakuReference[# <> wordTokenSuffix] <> " {" <> ToRakuTerminal[ terminalModifierFunc[#] ] <> "}" &, lsPropertyWords];

      (* This is association in *)
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
(* MakeRoleByTrie                                          *)
(***********************************************************)

Clear[TravCombiner];
TravCombiner[x_, y_] := {x, Which[ListQ[y] && Length[y] > 1, Apply[Alternatives, y], ListQ[y], y[[1]], True, y]};

Clear[MakeRoleByTrie];

SyntaxInformation[MakeRoleByTrie] = {"ArgumentsPattern" -> {_, OptionsPattern[]}};

Options[MakeRoleByTrie] = {
  "RuleSuffix" -> "-prop",
  "RoleName" -> "SomeRole",
  "TopRuleName" -> "some-rule",
  "WordTokenSuffix" -> "-word",
  "SeparateTerminals" -> True,
  "TokensForJoinedPhrases" -> True,
  "SplitWordsByCapitalLetters" -> False,
  "Regexes" -> False
};

MakeRoleByTrie[ trie_?TrieQ, opts : OptionsPattern[]] :=
    Block[{ruleSuffix, roleName, topRuleName, wordTokenSuffix,
      separateTerminalsQ, tokensForJoinedPhrasesQ,
      lsRakuTokens, lsRakuRules,
      lsNodes, lsFirstLevel, lsSubTries, lsRuleSpecs,
      regexFunc, rakuMethod, regexDelim},

      ruleSuffix = OptionValue[MakeRoleByTrie, "RuleSuffix"];
      roleName = OptionValue[MakeRoleByTrie, "RoleName"];
      topRuleName = OptionValue[MakeRoleByTrie, "TopRuleName"];
      wordTokenSuffix = OptionValue[MakeRoleByTrie, "WordTokenSuffix"];
      separateTerminalsQ = TrueQ[OptionValue[MakeRoleByTrie, "SeparateTerminals"]];
      tokensForJoinedPhrasesQ = TrueQ[OptionValue[MakeRoleByTrie, "TokensForJoinedPhrases"]];

      If[ TrueQ[OptionValue[MakeRoleByTrie, "Regexes"]],
        regexFunc = ToRakuRegex;
        regexDelim = "\\\\h+";
        rakuMethod = "regex",
        (*ELSE*)
        regexFunc = ToRakuToken;
        regexDelim = " ";
        rakuMethod = "rule"
      ];

      (* Make tokens *)
      lsNodes = Union[Flatten[TrieKeyTraverse[trie, List]]];
      lsNodes = Complement[lsNodes, {$TrieRoot, $TrieValue}];

      lsRakuTokens =
          Map[# -> "token " <> NormalizeRakuReference[# <> wordTokenSuffix] <> " {" <> ToRakuTerminal[#] <> "}" &, lsNodes];

      (* Get the sub-tries *)
      lsFirstLevel = Map[#[[-1, 1]] &, TrieRootToLeafPaths@TriePrune[trie, 1]];

      lsSubTries = TrieSubTrie[trie, {#}] & /@ lsFirstLevel;

      (* Convert sub-tries into rules *)
      lsRuleSpecs = Map[TrieKeyTraverse[#, TravCombiner]&, lsSubTries];

      lsRakuRules = ToRakuRegex[#, wordTokenSuffix, regexDelim] & /@ lsRuleSpecs;

      lsRakuRules =
          MapThread[
            With[{name = StringRiffle[Flatten[{#2}], "-"] <> ruleSuffix},
              name -> rakuMethod <> " " <> NormalizeRakuReference[name] <> " { " <> #1 <> "}"
            ] &,
            {lsRakuRules, lsFirstLevel}];

      (* Finalize rules collection *)
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