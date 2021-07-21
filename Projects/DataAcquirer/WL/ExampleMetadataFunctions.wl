(* ::Package:: *)

(* ::Subsection:: *)
(*SplitWordsByCapitalLetters*)


(* ::Input:: *)
Clear[SplitWordsByCapitalLetters];
SplitWordsByCapitalLetters[word_String] := StringCases[word, CharacterRange["A", "Z"] ~~ (Except[CharacterRange["A", "Z"]]...)];
SplitWordsByCapitalLetters[words : {_String..}] := Map[SplitWordsByCapitalLetters, words];


(* ::Subsection:: *)
(*SplitWordAndNumber*)


(* ::Input:: *)
Clear[SplitWordAndNumber];
SplitWordAndNumber[word_String] := If[StringMatchQ[word, (LetterCharacter..) ~~ (DigitCharacter..)], StringCases[word, x : (LetterCharacter..) ~~ n : (DigitCharacter..) :> x <> " " <> n], word];


(* ::Subsection:: *)
(*GetRData*)


(* ::Input:: *)
Clear[GetRData];
GetRData[url_String, maxTime_Integer : 5, opts : OptionsPattern[]] :=
    Block[{res},
      res = TimeConstrained[ResourceFunction["ImportCSVToDataset"][url, opts], maxTime];
      If[TrueQ[Head[res] === TimeConstrained],
        Missing["Not retrieved within:" <> maxTime], (*ELSE*)
        res
      ]
    ] /; maxTime > 0;


(* ::Subsection:: *)
(*GetRDocumentation*)


(* ::Input:: *)
Clear[GetRDocumentation];
GetRDocumentation[url_String, maxTime_Integer, opts : OptionsPattern[]] :=
    GetRDocumentation[url, "Plaintext", maxTime, opts];
GetRDocumentation[url_String, prop_String : "Plaintext", maxTime_Integer : 5, opts : OptionsPattern[]] :=
    Block[{res},
      res = TimeConstrained[Import[url, prop, opts], maxTime];
      If[TrueQ[Head[res] === TimeConstrained],
        Missing["Not retrieved within:" <> maxTime], (*ELSE*)
        res
      ]
    ] /; maxTime > 0;


(* ::Subsection:: *)
(*GetMetadata*)


(* ::Input:: *)
Clear[GetMetadata];
GetMetadata[dataID : {_String..}] :=
    Block[{lsProps, aMetadata},
      lsProps = ExampleData[dataID, "Properties"];
      aMetadata = Association[# -> ExampleData[dataID, #]& /@ Complement[lsProps, {"Data", "TestData", "TrainingData", "DataElements", "TimeSeries", "EventSeries"}]];
      aMetadata = Join[aMetadata, <|"DataID" -> StringRiffle[dataID, "-"]|>]
    ];


(* ::Subsection:: *)
(*MakeContigencyMatrix*)


(* ::Input:: *)
Clear[MakeContigencyMatrix];
MakeContigencyMatrix[lsMetadata : {_Association..}, metaKey_String] :=
    Block[{lsRows, mat},
      lsRows = Join @@ Map[Thread[{#DataID, Flatten[{#[metaKey]}]}]&, lsMetadata];
      If[metaKey == "ColumnTypes",
        lsRows = lsRows /. {"Numerical" -> "Numeric", "String" -> "Categorical"}
      ];
      mat = ToSSparseMatrix[CrossTabulate[lsRows]];
      mat = SetColumnNames[mat, Map[metaKey <> ":" <> #&, ColumnNames[mat]]]
    ];

MakeContigencyMatrix[lsMetadata : {_Association..}, "NumberOfRows" | "RowsCount"] :=
    MakeContigencyMatrix[lsMetadata, "Dimensions", 1];

MakeContigencyMatrix[lsMetadata : {_Association..}, "NumberOfColumns" | "ColumnsCount"] :=
    MakeContigencyMatrix[lsMetadata, "Dimensions", 2];

MakeContigencyMatrix[lsMetadata : {_Association..}, "Dimensions", ind_Integer] :=
    Block[{mat},
      mat = ToSSparseMatrix[CrossTabulate[Map[{#DataID, If[ListQ[#Dimensions] && Length[#Dimensions] >= ind, #Dimensions[[ind]], "None", "None"]}&, lsMetadata]]];
      mat = SetColumnNames[mat, Map["Dimension-" <> ToString[ind] <> ":" <> #&, ColumnNames[mat]]]
    ];
