(*
    Phone dialing dialogs fininte state machine Mathematica code
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

(* :Title: PhoneDialingFSM *)
(* :Context: Global` *)
(* :Author: Anton Antonov *)
(* :Date: 2017-03-26 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: *)
(* :Copyright: (c) 2017 Anton Antonov *)
(* :Keywords: *)
(* :Discussion:

  This code is not made into a package due to global variables utilization:

    pCALLGLOBAL, pCALLCONTACT, pCALLFILTER, addressLines .

*)


(*BeginPackage["PhoneDialingFSM`"]*)

(*PCESM::usage = "Phone calling engine state machine."*)

(*PCESMFilterContactScores::usage = "Filter for contact scores."*)

(*PCESMFilterContacts::usage = "Filtering contacts."*)

(*Begin["`Private`"]*)

(*Needs["FunctionalParsers`"]*)

states = Sort@{"WaitingForARequest", "ListOfContactsForAQuery",
  "DialPhoneNumber", "WaitingForAFilter", "PrioritizedList"}


messages =
    Sort@{"UniqueContact", "NonUniqueContact", "StartOver", "DialButtonPressed",
      "FilterInput", "UniqueContactObtained", "Help"}


PCEParsedToRuleRules = {ContactName[p_] :> ("name" -> p),
  Occupation[p_] :> ("occupation" -> p), FromCompany[p_] :> ("org" -> p),
  Age[p_] :> ("age" -> p)};

Clear[PCESM];

PCESM["WaitingForARequest", contextArg_, input_String] :=
    Block[{p, inputContext, posScores, nFilters, context = contextArg, contact},

      (* Check was "global" command was entered. E.g. "start over". *)
      p = ParseShortest[pCALLGLOBAL][ToTokens[ToLowerCase[input]]];
      Which[
        (* Cancel / start over request*)
        Length[p] > 0 && MemberQ[Flatten[p], Global["cancel"]],
        Return[{"WaitingForARequest", {"StartOver"},
          Append[DeleteCases[context, "filters" -> _], "filters" -> {}], "Starting over.", ""}],

        (* Priority list request *)
        Length[p] > 0 && MemberQ[Flatten[p], Global["priority"]],
        Return[{"PrioritizedList", {}, context, "", ""}],

        (* Other global commands *)
        Length[p] > 0 && !Developer`EmptyQ[Cases[p, Global[___], Infinity]],
        Return[{"WaitingForARequest", {}, context, "", "No implemented reaction for the given service input."}]
      ];

      (* Main command *)
      p = ParseShortest[pCALLCONTACT][ToTokens[ToLowerCase[input]]]; Print[p];

      (* If it cannot be parsed, show message *)
      If[
        p === {} || p[[1, 1]] =!= {},
        Return[{"WaitingForARequest", {""}, context, "Unrecognized input.", ""}]
      ];

      (* Get filter rules *)
      inputContext = Flatten[p] /. PCEParsedToRuleRules;

      (* Filter contacts *)
      {posScores, nFilters} = PCESMFilterContactScores[inputContext];

      (* Update the filters in the context *)
      context = Append[DeleteCases[context, "filters" -> _], "filters" -> inputContext];

      (* Switch to the next state *)
      PCESM["ListOfContactsForAQuery", context, input]
    ];

Clear[ContactsByFilter]
nameToIndexRules = {"name" -> 1, "org" -> 2, "occupation" -> 3, "age" -> All};
ContactsByFilter[frule_Rule] :=
    Block[{lhs = frule[[1]], rhs = frule[[2]]},
      Position[addressLines[[All, lhs /. nameToIndexRules]],
        s_String /; StringMatchQ[s, ___ ~~ (rhs) ~~ ___, "IgnoreCase" -> True], \[Infinity]]
    ];

Clear[PCESMFilterContactScores]
PCESMFilterContactScores[context_] :=
    Block[{pos = {}, nFilters = 0},
      pos = Map[ContactsByFilter, context];
      nFilters = Length[pos];
      pos = Map[If[Length[#] > 0, First /@ #, #] &, pos];
      {SortBy[Tally[Flatten[pos]], -#[[2]] &], nFilters}
    ];

Clear[PCESMFilterContacts]
PCESMFilterContacts[context_] :=
    Block[{posScores, nFilters},
      {posScores, nFilters} = PCESMFilterContactScores["filters" /. context];
      posScores =
          Which[
            Max[posScores[[All, 2]]] == nFilters,
            Select[posScores, #[[2]] == nFilters &],
            Length[Position[posScores[[All, 2]], Max[posScores[[All, 2]]]]] == 1, {posScores[[1]]},
            True, posScores
          ];
      {posScores, nFilters}
    ];

PCESM["ListOfContactsForAQuery", contextArg_, input_String] :=
    Block[{posScores, nFilters, context = contextArg},

      {posScores, nFilters} = PCESMFilterContacts[context];
      context =
          Append[DeleteCases[context, "ids" -> _], "ids" -> posScores[[All, 1]]];
      Which[
        Length[posScores] == 1,
        {"DialPhoneNumber", {"UniqueContactObtained", posScores[[1, 1]]}, context,
          "", "Calling " <>
            Apply[StringJoin, Riffle[addressLines[[posScores[[1, 1]], All]], " "]] <> " ..."},
        Length[posScores] > 1,
        {"WaitingForAFilter", {"NonUniqueContact"}, context,
          "There are " <> ToString[Length[posScores]] <> " contacts for this request.", addressLines[[posScores[[All, 1]], All]]},
        True,
        {"WaitingForARequest", {""}, context, "No contacts satisfy the request!", ""}
      ]
    ];

PCESM["WaitingForAFilter", contextArg_, input_String] :=
    Block[{p, fspec, t, context = contextArg,
      fContext = "filters" /. contextArg /. "filters" -> {}, pos, posScores, nFilters},

      (* Check was "global" command was entered. E.g. "start over". *)
      p = ParseShortest[pCALLGLOBAL][ToTokens[ToLowerCase[input]]];

      Which[
        Length[p] > 0 && MemberQ[Flatten[p], Global["cancel"]],
        Return[{"WaitingForARequest", {"StartOver"},
          Append[DeleteCases[context, "filters" -> _], "filters" -> {}],
          "Starting over.", ""}],
        Length[p] > 0 && MemberQ[Flatten[p], Global["priority"]],
        Return[{"PrioritizedList", {}, context, "", ""}]
      ];

      (* Main command processing *)
      p = ParseJust[pCALLFILTER][ToTokens[ToLowerCase[input]]];

      (* Special cases handling *)
      Which[
        (* Cannot parse as filtering command*)
        p === {} || p[[1, 1]] =!= {},

        Return[{"WaitingForAFilter", {""}, context, "Unrecognized input.", ""}],

        (* List position command was entered. E.g. "take the third one". *)
        Length[Cases[Flatten[p], ListPosition[_]]] > 0,

        pos = Cases[Flatten[p], ListPosition[n_] :> n][[1]] /.
            Join[Thread[{ "first" , "second" , "third", "fourth", "fifth", "sixth",
              "seventh", "eighth", "ninth" , "tenth"} -> Range[1, 10]]
              , {"last" -> -1, "former" -> -2, "latter" -> -1}];

        Which[
          NumberQ[pos] && 1 <= Abs[pos] <= Length["ids" /. context],
        (*{posScores,nFilters}=PCESMFilterContacts[fContext];*)

          Return[{"DialPhoneNumber", {"UniqueContactObtained", ("ids" /. context)[[pos]]}, context, "",
            "Calling " <> Apply[StringJoin, Riffle[addressLines[[("ids" /. context)[[pos]], All]], " "]] <> " ..."}],
          NumberQ[pos],

          Return[{"WaitingForARequest", {""}, context, "The number is out of range!", ""}],

          True,

          Return[{"WaitingForAFilter", {""}, context, "Unrecognized input.", ""}]
        ]
      ];

      (* Process "regularly" expected filtering input. *)
      p = SortBy[p, Length[#[[2]]] &][[1]];
      fspec = Flatten[p];

      Which[
        Length[Cases[fspec, _ContactName]] > 0,

        t = Cases[fspec, _ContactName][[1]];
        fContext = Append[fContext, "name" -> t[[1]]],

        Length[Cases[fspec, _FromCompany]] > 0,

        t = Cases[fspec, _FromCompany][[1]];
        fContext = Append[DeleteCases[fContext, "org" -> _], "org" -> t[[1]]],

        Length[Cases[fspec, _Occupation]] > 0,

        t = Cases[fspec, _Occupation][[1]];
        fContext = Append[DeleteCases[fContext, "occupation" -> _], "occupation" -> t[[1]]],

        Length[Cases[fspec, _Age]] > 0,

        t = Cases[fspec, _Age][[1]];
        fContext = Append[DeleteCases[fContext, "age" -> _], "age" -> t[[1]]],

        True,
        Return[{"WaitingForAFilter", {""}, context, "Unrecognized filter.", "Unrecognized filter."}]
      ];

      {"ListOfContactsForAQuery", {"FilterInput"},
        Append[DeleteCases[context, "filters" -> _], "filters" -> fContext], "", ""}
    ];

PCESM["PrioritizedList", contextArg_, input_String] :=
    Block[{posScores, context = contextArg},

      posScores =
          SortBy[Transpose[{contactScoreInds, contactScores}], -#[[2]] &][[All, 1]];

      context = Append[DeleteCases[context, "ids" -> _], "ids" -> posScores];

      {"WaitingForAFilter", {"NonUniqueContact"}, context, "", addressLines[[posScores, All]]}
    ];

PCESM[state_, context_, input_String] :=
    Block[{},

      Print["nothing to do for: ", state];
      {"WaitingForARequest", {}, {}, "", ""}
    ];


(*End[]*)

(*EndPackage[]*)