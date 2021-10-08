(*
    Data acquisition dialogs finite state machine Mathematica code
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
    antononcube @@@ gmail ... com,
    Windermere, Florida, USA.
*)

(* :Title: PhoneDialingFSM *)
(* :Context: Global` *)
(* :Author: Anton Antonov *)
(* :Date: 2017-10-07 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: *)
(* :Copyright: (c) 2017 Anton Antonov *)
(* :Keywords: *)
(* :Discussion:

  This code is not made into a package due to global variables utilization:

    pDAWGLOBAL, pDAWCOMMAND, pDAWFILTER, dsDatasetMetadata .

*)


(*BeginPackage["PhoneDialingFSM`"]*)

(*PCESM::usage = "Phone calling engine state machine."*)

(*PCESMFilterDatasetScores::usage = "Filter for dataset scores."*)

(*PCESMFilterDatasets::usage = "Filtering datasets."*)

(*Begin["`Private`"]*)

(*Needs["FunctionalParsers`"]*)

states = Sort@{"WaitingForARequest", "ListOfDatasetsForAQuery",
  "LoadDataset", "WaitingForAFilter", "PrioritizedList"};


messages =
    Sort@{"UniqueContact", "NonUniqueDataset", "StartOver", "DialButtonPressed",
      "FilterInput", "UniqueContactObtained", "Help"};


PCEParsedToRuleRules = {
  DAWTitle[p_] :> ("Title" -> p),
  DAWFromPackage[p_] :> ("Package" -> p),
  DAWPackage[p_] :> ("Package" -> p),
  DAWNRow[p_] :> ("RowsCount" -> p),
  DAWNCol[p_] :> ("ColumnsCount" -> p),
  DAWNRowSize[p_] :> ("RowsCount" -> p),
  DAWNColSize[p_] :> ("ColumnsCount" -> p)
};

Clear[PCESM];

PCESM["WaitingForARequest", contextArg_, input_String] :=
    Block[{p, inputContext, posScores, nFilters, context = contextArg},

      p = ParseShortest[pDAWGLOBAL][ToTokens[ToLowerCase[input]]];
      Which[
        Length[p] > 0 && MemberQ[Flatten[p], DAWGlobal["cancel"]],
        Return[{"WaitingForARequest", {"StartOver"},
          Append[DeleteCases[context, "filters" -> _], "filters" -> {}],
          "Starting over.", ""}],

        Length[p] > 0 && MemberQ[Flatten[p], DAWGlobal["priority"]],
        Return[{"PrioritizedList", {}, context, "", ""}],

        Length[p] > 0 && !Developer`EmptyQ[Cases[p, DAWGlobal[___], Infinity]],
        Return[{"WaitingForARequest", {}, context, "", "No implemented reaction for the given service input."}]
      ];

      p = ParseShortest[pDAWCOMMAND][ToTokens[ToLowerCase[input]]];
      Echo[p, "ParseShortest[pDAWCOMMAND][ToTokens[ToLowerCase[input]]]"];

      If[
        p === {} || p[[1, 1]] =!= {},
        Return[{"WaitingForARequest", {""}, context, "WaitingForARequest:: Unrecognized input.", ""}]
      ];

      inputContext = Flatten[p] /. PCEParsedToRuleRules;
      {posScores, nFilters} = PCESMFilterDatasetScores[inputContext];
      context = Append[DeleteCases[context, "filters" -> _], "filters" -> inputContext];

      PCESM["ListOfDatasetsForAQuery", context, input]
    ];

Clear[DatasetsByFilter];
nameToIndexRules = Keys[Normal @ dsDatasetMetadata[[1]] ];
nameToIndexRules = AssociationThread[ nameToIndexRules, Range @ Length @ nameToIndexRules];
DatasetsByFilter[ frule : Rule[ colName : ( "RowsCount" | "ColumnsCount" ), n_Integer ] ] :=
    Block[{k=1, res},
      (*res = Normal[dsDatasetMetadata[All, Append[#, "Index" -> k++ ]&][Select[ #[[colName]] == n || #[[colName]] == ToString[n] &]][All, "Index" ]];*)
      res = Position[Normal[dsDatasetMetadata[All, colName]], n | ToString[n]];

      Echo[frule, "DatasetsByFilter rows/columns: frule : " ];
      Echo[res, "DatasetsByFilter rows/columns: res : " ];
      res
    ];
DatasetsByFilter[frule_Rule] :=
    Block[{lhs = frule[[1]], rhs = frule[[2]]},
      Echo[frule, "DatasetsByFilter strings:" ];
      Position[dsDatasetMetadata[[All, lhs ]],
        s_String /; StringMatchQ[s, ___ ~~ (rhs) ~~ ___, "IgnoreCase" -> True], Infinity]
    ];

Clear[PCESMFilterDatasetScores];
PCESMFilterDatasetScores[context_] :=
    Block[{pos = {}, nFilters = 0},
      pos = Map[DatasetsByFilter, context];
      nFilters = Length[pos];
      pos = Map[If[Length[#] > 0, First /@ #, #] &, pos];
      {SortBy[Tally[Flatten[pos]], -#[[2]] &], nFilters}
    ];

Clear[PCESMFilterDatasets];
PCESMFilterDatasets[context_] :=
    Block[{posScores, nFilters},
      {posScores, nFilters} = PCESMFilterDatasetScores["filters" /. context];
      posScores =
          Which[
            Max[posScores[[All, 2]]] == nFilters,
            Select[posScores, #[[2]] == nFilters &],
            Length[Position[posScores[[All, 2]], Max[posScores[[All, 2]]]]] == 1, {posScores[[1]]},
            True, posScores
          ];
      {posScores, nFilters}
    ];

PCESM["ListOfDatasetsForAQuery", contextArg_, input_String] :=
    Block[{posScores, nFilters, context = contextArg},

      {posScores, nFilters} = PCESMFilterDatasets[context];
      context =
          Append[DeleteCases[context, "ids" -> _], "ids" -> posScores[[All, 1]]];
      Which[
        Length[posScores] == 1,
        Global`obj = ExampleData[{ dsDatasetMetadata[posScores[[1, 1]], "Package"], dsDatasetMetadata[posScores[[1, 1]], "Item"]}];
        {"LoadDataset", {"UniqueContactObtained", posScores[[1, 1]]}, context, "",
          Row[{"Obtained", Spacer[5], dsDatasetMetadata[posScores[[1, 1]], All], Spacer[5], "and assigned to Global`obj ."}]
        },
        Length[posScores] > 1,
        {"WaitingForAFilter", {"NonUniqueDataset"}, context,
          "There are " <> ToString[Length[posScores]] <> " datasets for this request.",
          dsDatasetMetadata[[posScores[[All, 1]], All]]},
        True,
        {"WaitingForARequest", {""}, context, "No datasets satisfy the request!", ""}
      ]
    ];

PCESM["WaitingForAFilter", contextArg_, input_String] :=
    Block[{p, fspec, t, context = contextArg,
      fContext = "filters" /. contextArg /. "filters" -> {}, pos, posScores, nFilters},

      p = ParseShortest[pDAWGLOBAL][ToTokens[ToLowerCase[input]]];

      Which[
        Length[p] > 0 && MemberQ[Flatten[p], DAWGlobal["cancel"]],
        Return[{"WaitingForARequest", {"StartOver"}, Append[DeleteCases[context, "filters" -> _], "filters" -> {}], "Starting over.", ""}],

        Length[p] > 0 && MemberQ[Flatten[p], DAWGlobal["priority"]],
        Return[{"PrioritizedList", {}, context, "", ""}]
      ];

      p = ParseJust[pDAWFILTER][ToTokens[ToLowerCase[input]]];

      Which[
        p === {} || p[[1, 1]] =!= {},

        Return[{"WaitingForAFilter", {""}, context, "WaitingForAFilter:: Unrecognized input.", ""}],

        Length[Cases[Flatten[p], ListPosition[_]]] > 0,

        pos = Cases[Flatten[p], ListPosition[n_] :> n][[1]] /.
            Join[Thread[{ "first" , "second" , "third", "fourth", "fifth", "sixth",
              "seventh", "eighth", "ninth" , "tenth"} -> Range[1, 10]]
              , {"last" -> -1, "former" -> -2, "latter" -> -1}];

        Which[
          NumberQ[pos] && 1 <= Abs[pos] <= Length["ids" /. context],
          (*{posScores,nFilters}=PCESMFilterDatasets[fContext];*)

          Global`obj = ExampleData[{ dsDatasetMetadata[pos, "Package"], dsDatasetMetadata[pos, "Item"]}];

          Return[{"LoadDataset", {"UniqueContactObtained", ("ids" /. context)[[pos]]}, context,
            "Obtained " <> ToString[{ dsDatasetMetadata[pos, "Package"], dsDatasetMetadata[pos, "Item"]}] <> " and assigned to Global`obj .",
            dsDatasetMetadata[pos]
          }],

          NumberQ[pos],

          Return[{"WaitingForARequest", {""}, context, "The number is out of range!", ""}],

          True,

          Return[{"WaitingForAFilter", {""}, context, "WaitingForAFilter:: Unrecognized input.", ""}]
        ]
      ];

      p = SortBy[p, Length[#[[2]]] &][[1]];
      fspec = Flatten[p];

      Which[
        Length[Cases[fspec, _DAWTitle]] > 0,

        t = Cases[fspec, _DAWTitle][[1]];
        fContext = Append[fContext, "Title" -> t[[1]]],

        Length[Cases[fspec, _DAWPackage]] > 0,

        t = Cases[fspec, _DAWPackage][[1]];
        fContext = Append[DeleteCases[fContext, "Package" -> _], "Package" -> t[[1]]],

        Length[Cases[fspec, _Occupation]] > 0,

        t = Cases[fspec, _Occupation][[1]];
        fContext = Append[DeleteCases[fContext, "occupation" -> _], "occupation" -> t[[1]]],

        Length[Cases[fspec, _DAWNRow]] > 0,

        t = Cases[fspec, _DAWNRow][[1]];
        fContext = Append[DeleteCases[fContext, "RowsCount" -> _], "RowsCount" -> t[[1]]],

        Length[Cases[fspec, _DAWNCol]] > 0,

        t = Cases[fspec, _DAWNCol][[1]];
        fContext = Append[DeleteCases[fContext, "ColumnsCount" -> _], "ColumnsCount" -> t[[1]]],

        True,
        Return[{"WaitingForAFilter", {""}, context, "Unrecognized filter.", "Unrecognized filter."}]
      ];

      {"ListOfDatasetsForAQuery", {"FilterInput"},
        Append[DeleteCases[context, "filters" -> _], "filters" -> fContext], "", ""}
    ];

PCESM["PrioritizedList", contextArg_, input_String] :=
    Block[{posScores, context = contextArg},

      posScores =
          SortBy[Transpose[{contactScoreInds, contactScores}], -#[[2]] &][[All, 1]];

      context = Append[DeleteCases[context, "ids" -> _], "ids" -> posScores];

      {"WaitingForAFilter", {"NonUniqueDataset"}, context, "", dsDatasetMetadata[[posScores, All]]}
    ];

PCESM[state_, context_, input_String] :=
    Block[{},

      Print["nothing to do for: ", state];
      {"WaitingForARequest", {}, {}, "", ""}
    ];


(*End[]*)

(*EndPackage[]*)