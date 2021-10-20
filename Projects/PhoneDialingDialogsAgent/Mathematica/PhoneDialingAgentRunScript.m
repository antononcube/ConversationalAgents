(*
    Phone dialing agent run script Mathematica code
    Copyright (C) 2017  Anton Antonov

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

(* :Title: PhoneDialingFSMInterface *)
(* :Context: Global` *)
(* :Author: Anton Antonov *)
(* :Date: 2017-04-22 *)

(* :Package Version: 1.0 *)
(* :Mathematica Version: *)
(* :Copyright: (c) 2017 Anton Antonov *)
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
parsingByAddressBookQ = True;

localDirectoryName = "/Some/Directory/";

gitHubDirectoryName =
    "https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/Projects/PhoneDialingDialogsAgent/Mathematica/";

stopWordsFileName = "";


(* Code *)

If[TrueQ[localCodeQ],
  Get[localDirectoryName <> "AddressBookByMovieRecords.m"],
  Import[gitHubDirectoryName <> "AddressBookByMovieRecords.m"]
];

(*RecordsSummary[addressLines]*)

Clear[IsOccupationQ, IsContactNameQ, IsCompanyNameQ];
isOccupationRules =
    Append[Thread[ToLowerCase@Union[addressLines[[All, 3]]] -> True], _String -> False];
IsOccupationQ[nm_String] := nm /. isOccupationRules;
isContactNameRules =
    Append[Thread[
      Union[ToLowerCase@Flatten@StringSplit[addressLines[[All, 1]], " "]] -> True], _String -> False];
IsContactNameQ[nm_String] := ToLowerCase[nm] /. isContactNameRules;
isCompanyNameRules =
    Append[Thread[
      Union[ToLowerCase@Flatten@StringSplit[addressLines[[All, 2]], " "]] -> True], _String -> False];
IsCompanyNameQ[nm_String] :=
    Apply[And, ToLowerCase[StringSplit[nm, " "]] /. isCompanyNameRules];

(* This code is to demonstrate/verify the work of the predicate functions defined above. *)
(*Block[{funcs = {IsOccupationQ, IsContactNameQ, IsCompanyNameQ}, qstrs, res},*)
  (*qstrs = {"writer", "director", "actor", "Bill", "Mary", "Caribbean Pirates",*)
    (*"Pirates", "LOTR"};*)
  (*res = Outer[#1[#2] &, funcs, qstrs];*)
  (*res = GridTableForm[res, TableHeadings -> qstrs];*)
  (*res[[1]][[All, 1]] = Style[#, Blue] & /@ Prepend[funcs, ""];*)
  (*res*)
(*]*)

If[TrueQ[localCodeQ],
  Get[localDirectoryName <> "PhoneCallingDialogsGrammarRules.m"],
  Get[gitHubDirectoryName <> "PhoneCallingDialogsGrammarRules.m"]
];

tokens = ToTokens[callingContacts];
res = GenerateParsersFromEBNF[tokens];
Print["LeafCount @ GenerateParsersFromEBNF @ ToTokens @ callingContacts = ", LeafCount[res] ];

If[TrueQ[StringQ[stopWordsFileName] && StringLength[stopWordsFileName] > 0],
  stopWords = ReadList[stopWordsFileName, String],
  stopWords = Complement[DictionaryLookup["*"], DeleteStopwords[DictionaryLookup["*"]]]
];
Print["Length[stopWords] = ", Length[stopWords]];

If[parsingByAddressBookQ,
  pCONTACTNAME[xs$_] :=
      ParseApply[ToExpression["ContactName[#]&"], ParsePredicate[IsContactNameQ]][xs$];
  pCONTACTOCCUPATION[xs$_] :=
      ParseApply[ToExpression["Occupation[#]&"], ParsePredicate[IsOccupationQ]][xs$];
  pCALLFROMCOMPANY[xs$_] :=
      ParseApply[ToExpression["FromCompany[#]&"],
        ParseSequentialCompositionPickRight[
          ParseAlternativeComposition[ParseSymbol["from"], ParseSymbol["of"]],
          ParsePredicate[IsCompanyNameQ]]][xs$];,
(*ELSE*)

  pCONTACTNAME[xs$_] :=
      ParseApply[ToExpression["ContactName[#]&"],
        ParsePredicate[StringMatchQ[#1, LetterCharacter ..] && ! MemberQ[stopWords, #1] &]][xs$];
  pCONTACTOCCUPATION[xs$_] :=
      ParseApply[ToExpression["Occupation[#]&"],
        ParsePredicate[StringMatchQ[#1, LetterCharacter ..] && ! MemberQ[stopWords, #1] &]][xs$];
  pCALLFROMCOMPANY[xs$_] :=
      ParseApply[ToExpression["FromCompany[#]&"],
        ParseSequentialCompositionPickRight[
          ParseAlternativeComposition[ParseSymbol["from"], ParseSymbol["of"]],
          ParsePredicate[StringMatchQ[#1, LetterCharacter ..] && ! MemberQ[stopWords, #1] &]]][xs$];
];

SeedRandom[2356];
contactScoreInds = RandomSample[Range[1, Length[addressLines]]];
contactScores = Table[PDF[GeometricDistribution[0.2], i] // N, {i, Length[contactScoreInds]}];

If[TrueQ[localCodeQ],
  Get[localDirectoryName <> "PhoneDialingFSM.m"],
  Import[gitHubDirectoryName <> "PhoneDialingFSM.m"]
];

If[TrueQ[localCodeQ],
  Get[localDirectoryName <> "PhoneDialingFSMInterface.m"],
  Print @ Import[gitHubDirectoryName <> "PhoneDialingFSMInterface.m"]
];
