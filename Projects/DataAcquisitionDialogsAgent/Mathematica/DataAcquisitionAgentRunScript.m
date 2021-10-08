(*
    Data acquisition agent run script Mathematica code
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
    antononcube @@@ posteo ... net,
    Windermere, Florida, USA.
*)

(* :Title: PhoneDialingFSMInterface *)
(* :Context: Global` *)
(* :Author: Anton Antonov *)
(* :Date: 2021-10-07 *)

(* :Package Version: 1.0 *)
(* :Mathematica Version: *)
(* :Copyright: (c) 2021 Anton Antonov *)
(* :Keywords: *)
(* :Discussion:

    This script loads and invokes all the necessary Mathematica files for running
    the phone dialing conversational agent of the project:

      https://github.com/antononcube/ConversationalAgents/tree/master/Projects/PhoneDialingDialogsAgent

    There are several parameters to be set for running the script:
      1) with local files or GitHub files,
      2) generic parsing predicates or derived from the address book, and
      3) stop words file name.

    If stopWordsFileName is not specified the stop words are derived using DictionaryLookup:

      stopWords = Complement[DictionaryLookup["*"], DeleteStopwords[DictionaryLookup["*"]]]

*)


(* Parameters *)

localCodeQ = False;
parsingByMetadataQ = True;

localDirectoryName = "/Some/Directory/";

gitHubDirectoryName =
    "https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/Projects/DataAcquisitionDialogsAgent/Mathematica/";

stopWordsFileName = "";


(* Code *)

If[localCodeQ,
  Get[localDirectoryName <> "ExampleDatasetsMetadata.m"],
  Import[gitHubDirectoryName <> "ExampleDatasetsMetadata.m"]
];

(*RecordsSummary[addressLines]*)

Clear[IsPackageQ, IsTitleQ, IsItemQ];

With[{lsNames = ToLowerCase @ Union[ Normal @ dsDatasetMetadata[All, "Package"] ]},
  IsPackageQ[x_String] := MemberQ[ lsNames,  ToLowerCase @ x ];
  IsPackageQ[___] := False;
];

With[{lsNames = ToLowerCase @ Union[ Normal @ dsDatasetMetadata[All, "Title"] ]},
  IsTitleQ[x_String] := MemberQ[ lsNames,  ToLowerCase @ x ];
  IsTitleQ[___] := False;
];

With[{lsNames = ToLowerCase @ Union[ Normal @ dsDatasetMetadata[All, "Item"] ]},
  IsItemQ[x_String] := MemberQ[ lsNames,  ToLowerCase @ x ];
  IsItemQ[___] := False;
];

If[localCodeQ,
  Get[localDirectoryName <> "DataAcquisitionDialogsGrammarRules.m"],
  Get[gitHubDirectoryName <> "DataAcquisitionDialogsGrammarRules.m"]
];

tokens = ToTokens[callingContacts];
res = GenerateParsersFromEBNF[tokens];
Print["LeafCount @ GenerateParsersFromEBNF @ ToTokens @ callingContacts = ", LeafCount[res] ];

If[TrueQ[StringQ[stopWordsFileName] && StringLength[stopWordsFileName] > 0],
  stopWords = ReadList[stopWordsFileName, String],
  stopWords = Complement[DictionaryLookup["*"], DeleteStopwords[DictionaryLookup["*"]]]
];
Print["Length[stopWords] = ", Length[stopWords]];

If[parsingByMetadataQ,
  pDAWTITLE[xs$_] :=
      ParseApply[ToExpression["DAWTitle[#]&"], ParsePredicate[IsTitleQ]][xs$];
  pDAWPACKAGE[xs$_] :=
      ParseApply[ToExpression["DAWPackage[#]&"], ParsePredicate[IsPackageQ]][xs$];
  pDAWFROMPACKAGE[xs$_] :=
      ParseApply[ToExpression["DAWFromPackage[#]&"],
        ParseSequentialCompositionPickRight[
          ParseAlternativeComposition[ParseSymbol["from"], ParseSymbol["of"]],
          ParsePredicate[IsPackageQ]]][xs$];,
(*ELSE*)

  pDAWTITLE[xs$_] :=
      ParseApply[ToExpression["DAWTitle[#]&"],
        ParsePredicate[StringMatchQ[#1, LetterCharacter ..] && ! MemberQ[stopWords, #1] &]][xs$];
  pDAWPACKAGE[xs$_] :=
      ParseApply[ToExpression["DAWPackage[#]&"],
        ParsePredicate[StringMatchQ[#1, LetterCharacter ..] && ! MemberQ[stopWords, #1] &]][xs$];
  pDAWFROMPACKAGE[xs$_] :=
      ParseApply[ToExpression["DAWFromPackage[#]&"],
        ParseSequentialCompositionPickRight[
          ParseAlternativeComposition[ParseSymbol["from"], ParseSymbol["of"]],
          ParsePredicate[StringMatchQ[#1, LetterCharacter ..] && ! MemberQ[stopWords, #1] &]]][xs$];
];

SeedRandom[2356];
contactScoreInds = RandomSample[Range[1, Length[dsDatasetsMetadata]]];
contactScores = Table[PDF[GeometricDistribution[0.2], i] // N, {i, Length[contactScoreInds]}];

If[localCodeQ,
  Get[localDirectoryName <> "DataAcquisitionFSM.m"],
  Import[gitHubDirectoryName <> "DataAcquisitionFSM.m"]
];

If[localCodeQ,
  Get[localDirectoryName <> "DataAcquisitionFSMInterface.m"],
  Import[gitHubDirectoryName <> "DataAcquisitionFSMInterface.m"]
]
