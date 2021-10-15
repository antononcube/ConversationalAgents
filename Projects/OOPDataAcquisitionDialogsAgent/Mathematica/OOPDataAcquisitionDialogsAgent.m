(*
    Data acquisition dialogs agent in EBNF Mathematica code
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

(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)

(* :Title: OOPDataAcquisitionDialogsAgent *)
(* :Context: OOPDataAcquisitionDialogsAgent` *)
(* :Author: Anton Antonov *)
(* :Date: 2021-10-10 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: 12.1 *)
(* :Copyright: (c) 2021 Anton Antonov *)
(* :Keywords: *)
(* :Discussion: *)

(*BeginPackage["OOPDataAcquisitionDialogsAgent`"];*)
(* Exported symbols added here with SymbolName::usage *)

If[ Length[SubValues[FunctionalParsers`ParseAlternativeComposition]] == 0,
  Echo["ExternalParsersHookup.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/FunctionalParsers.m"];
];

If[ Length[DownValues[$OOPFSMHEAD]] == 0,
  Echo["OOPFiniteStateMachine.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/Packages/WL/OOPFiniteStateMachine.m"];
];

If[ Length[DownValues[DataAcquisitionDialogsGrammar`pDADCOMMAND]] == 0,
  Echo["DataAcquisitionDialogsGrammar.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/Projects/OOPDataAcquisitionDialogsAgent/Mathematica/DataAcquisitionDialogsGrammar.m"]
];

If[ Length[DownValues[MakeDataResourceNotebook]] == 0,
  Echo["DataAcquisitionDialogsGrammar.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/Data-Acquisition-Engine-project/main/Packages/WL/MakeDataResourseNotebook.m"]
];

(*==========================================================*)
(* Get metadata dataset                                   *)
(*==========================================================*)

Echo["Ingesting address book CSV file.", "OOPDataAcquisitionDialogsAgent:"];
dsDatasetMetadata = ResourceFunction["ImportCSVToDataset"]["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/Projects/OOPDataAcquisitionDialogsAgent/Data/dsDatasetMetadata.csv"];


(*==========================================================*)
(* FSM prepare object                                       *)
(*==========================================================*)

(*-----------------------------------------------------------*)
(*Make object*)

ClearAll[DataAcquisitionFSM];

DataAcquisitionFSM[d_][s_] := Block[{$OOPFSMHEAD = DataAcquisitionFSM}, FiniteStateMachine[d][s]];

DataAcquisitionFSM[objID_]["ChooseTransition"[args___]] := Echo[Row[{Style["Wrong arguments:", Red], args}], "ChooseTransition:"];

daObj = DataAcquisitionFSM["DataAcquisitionDialogs"];

(*-----------------------------------------------------------*)
(* States *)

daObj["AddState"["WaitForRequest", (Echo["Please enter item request.", "WaitForRequest:"]; #["Dataset"] = dsDatasetMetadata) &]];
daObj["AddState"["ListOfItems", Echo["Listing items...", "ListOfContacts[Action]:"] &]];
daObj["AddState"["PrioritizedList", Echo["Prioritized dataset...", "PrioritizedList:"] &]];
daObj["AddState"["WaitForFilter", Echo["Enter a filter...", "WaitForFilter[Action]:"] &]];
daObj["AddState"["AcquireItem", Echo[Row[{"Acquire dataset:", Spacer[3], #["Dataset"][[1]]}], "AcquireItem:"] &]];
daObj["AddState"["Help", Echo[Row[{"Here is help:", "..."}], "Help:"] &]];
daObj["AddState"["Exit", Echo[Style["Shutting down...", Bold], "Exit:"] &]];

daObj["AddState"["ParseWithRaku", Echo["Parse with Raku...", "ParseWithRaku[Action]:"] &]];

(*-----------------------------------------------------------*)
(*Transitions*)

daObj["AddTransition"["WaitForRequest", "itemSpec", "ListOfItems"]];
daObj["AddTransition"["WaitForRequest", "startOver", "WaitForRequest"]];
daObj["AddTransition"["WaitForRequest", "priority", "PrioritizedList"]];
daObj["AddTransition"["WaitForRequest", "help", "Help"]];
daObj["AddTransition"["WaitForRequest", "quit", "Exit"]];

daObj["AddTransition"["PrioritizedList", "priorityListGiven", "WaitForRequest"]];

daObj["AddTransition"["ListOfItems", "manyItems", "WaitForFilter"]];
daObj["AddTransition"["ListOfItems", "noItems", "WaitForRequest"]];
daObj["AddTransition"["ListOfItems", "uniqueItemObtained", "AcquireItem"]];

daObj["AddTransition"["AcquireItem", "startOver", "WaitForRequest"]];

daObj["AddTransition"["WaitForFilter", "startOver", "WaitForRequest"]];
daObj["AddTransition"["WaitForFilter", "filterInput", "ListOfItems"]];
daObj["AddTransition"["WaitForFilter", "priority", "PrioritizedList"]];
daObj["AddTransition"["WaitForFilter", "unrecognized", "WaitForFilter"]];
daObj["AddTransition"["WaitForFilter", "help", "Help"]];
daObj["AddTransition"["WaitForFilter", "quit", "Exit"]];

daObj["AddTransition"["Help", "helpGiven", "WaitForRequest"]];

daObj["AddTransition"["WaitForFilter", "tryRaku", "ParseWithRaku"]];
daObj["AddTransition"["ParseWithRaku", "unrecognized", "WaitForFilter"]];
daObj["AddTransition"["ParseWithRaku", "filterInput", "ListOfItems"]];

(*-----------------------------------------------------------*)
(*Make state transition graph*)

Echo[ daObj["Graph"[ImageSize -> 900, EdgeLabelStyle -> Directive[Red, Italic, Bold, 16]]], "OOPDataAcquisitionDialogsAgent:"];

(*==========================================================*)
(* Finite state machine code                                *)
(*==========================================================*)

(*-----------------------------------------------------------*)
(*WaitForRequest*)

DataAcquisitionFSM[objID_]["ChooseTransition"[stateID : "WaitForRequest", inputArg_ : Automatic, maxLoops_Integer : 5]] :=
    Block[{obj = DataAcquisitionFSM[objID], transitions, input, pres},

      transitions = obj["States"][stateID]["ExplicitNext"];
      ECHOLOGGING[Style[transitions, Purple], stateID <> ":"];

      If[ MemberQ[{Automatic, Input, InputString}, inputArg],
        input = InputString[],
        (* ELSE *)
        input = inputArg
      ];

      (*Check was "global" command was entered.E.g."start over".*)

      pres = ParseShortest[pDADGLOBAL][ToTokens[ToLowerCase[input]]];

      ECHOLOGGING[Row[{"Parsed global command:", pres}], stateID];

      Which[
        (*Quit request*)
        MemberQ[{"quit"}, ToLowerCase[input]] || Length[pres] > 0 && MemberQ[Flatten[pres], DADGlobal["quit"]],
        Echo["Quiting.", "WaitForRequest:"];
        Return[First@Select[transitions, #ID == "quit" || #To == "Exit" &]],

        (*Cancel/start over request*)
        Length[pres] > 0 && MemberQ[Flatten[pres], DADGlobal["cancel"]],
        Echo["Starting over.", "WaitForRequest:"];
        Return[First@Select[transitions, #ID == "startOver" || #To == "WaitForRequest" &]],

        (*Priority list request*)
        Length[pres] > 0 && MemberQ[Flatten[pres], DADGlobal["priority"]],
        Return[First@Select[transitions, #ID == "priority" || #To == "PrioritizedList" &]],

        (*Other global commands*)
        Length[pres] > 0 && ! Developer`EmptyQ[Cases[pres, DADGlobal[___], Infinity]],
        Echo["No implemented reaction for the given service input.", "WaitForRequest:"];
        Return[First@Select[transitions, #ID == "startOver" || #To == "WaitForRequest" &]]
      ];

      (*Main command*)
      pres = ParseShortest[pDADREQUESTCOMMAND][ToTokens[ToLowerCase[input]]];

      ECHOLOGGING[Row[{"Parsed main command:", pres}], stateID];

      (*If it cannot be parsed,show message*)

      If[pres === {} || pres[[1, 1]] =!= {},
        Return[First@Select[transitions, #ID == "startOver" || #To == "WaitForRequest" &]]
      ];

      (*Switch to the next state*)
      obj["ItemSpec"] = Flatten[pres];
      Return[First@Select[transitions, #ID == "itemSpec" || #To == "ListOfItems" &]]
    ];

(*-----------------------------------------------------------*)
(*ListOfItems*)

aParsedToPred = {
  DADTitle[p_] :> (Quiet[StringMatchQ[#Title, ___ ~~ p ~~ ___, IgnoreCase -> True]]),
  DADPackage[p_] :> (Quiet[StringMatchQ[#Package, ___ ~~ p ~~ ___, IgnoreCase -> True]]),
  DADFromPackage[p_] :> (Quiet[StringMatchQ[#Package, ___ ~~ p ~~ ___, IgnoreCase -> True]]),
  DADNRow[p_] :> (#RowsCount == p),
  DADNCol[p_] :> (#ColumnsCount == p)
};


DataAcquisitionFSM[objID_]["ChooseTransition"[stateID : "ListOfItems", inputArg_ : Automatic, maxLoops_Integer : 5]] :=
    Block[{fsmObj = DataAcquisitionFSM[objID], transitions, dsNew},

      transitions = fsmObj["States"][stateID]["ExplicitNext"];
      ECHOLOGGING[Style[transitions, Purple], stateID <> ":"];

      ECHOLOGGING[Row[{"Using the contact spec:", Spacer[3], fsmObj["ItemSpec"]}], "ListOfContacts:"];

      (* Get new dataset *)
      dsNew =
          Which[
            (* Integer position *)
            IntegerQ[fsmObj["ItemSpec"]] || VectorQ[fsmObj["ItemSpec"], IntegerQ],
            fsmObj["Dataset"][fsmObj["ItemSpec"]],

            (* Raku parser result *)
            TrueQ[ Head[fsmObj["ItemSpec"]] === Hold ],
            Block[{obj = fsmObj["Dataset"], res},
              (* The Raku parser-interpreter uses the pipeline value "obj". *)
              res = ReleaseHold[fsmObj["ItemSpec"]];
              If[ TrueQ[Head[res] === Dataset], res, {}]
            ],

            (* WL parser result *)
            True,
            With[{pred = Apply[And, fsmObj["ItemSpec"] /. aParsedToPred]},
              fsmObj["Dataset"][Select[pred &]]
            ]
          ];

      Echo[Row[{"Obtained the records:", dsNew}], stateID <> ":"];

      Which[
        (*No contacts*)
        Length[dsNew] == 0,
        Echo[
          Row[{Style["No results with the contact specification.", Red, Italic], Spacer[3], fsmObj["ItemSpec"]}],
          "ListOfContacts:"
        ];
        Return[First@Select[transitions, #ID == "startOver" || #To == "WaitForRequest" &]],

        (*Just one contact*)
        Length[dsNew] == 1,
        fsmObj["Dataset"] = dsNew;
        Return[First@Select[transitions, #ID == "uniqueItemObtained" || #To == "AcquireItem" &]],

        (*Many contacts*)
        Length[dsNew] > 1,
        fsmObj["Dataset"] = dsNew;
        Return[First@Select[transitions, #ID == "manyItems" || #To == "WaitForFilter" &]]
      ]
    ];

(*-----------------------------------------------------------*)
(*WaitForFilter*)

DataAcquisitionFSM[objID_]["ChooseTransition"[stateID : "WaitForFilter", inputArg_ : Automatic, maxLoops_Integer : 5]] :=
    Block[{obj = DataAcquisitionFSM[objID], transitions, input, pres, pos},

      transitions = obj["States"][stateID]["ExplicitNext"];
      ECHOLOGGING[Style[transitions, Purple], stateID <> ":"];

      If[ MemberQ[{Automatic, Input, InputString}, inputArg],
        input = InputString[],
        (* ELSE *)
        input = inputArg
      ];

      (*Check was "global" command was entered.E.g."start over".*)
      pres = ParseShortest[pDADGLOBAL][ToTokens[ToLowerCase[input]]];

      (*Global request handling delegation*)
      If[Length[pres] > 0,
        Echo["Delegate handling of global requests.", "WaitForFilter:"];
        Return[First@Select[transitions, #ID == "startOver" || #To == "WaitForRequest" &]]
      ];

      (*Main command processing*)
      pres = ParseJust[pDADFILTER][ToTokens[ToLowerCase[input]]];

      (*Special cases handling*)
      Which[
        (*Cannot parse as filtering command and Raku connection is present *)
        (pres === {} || pres[[1, 1]] =!= {}) && Length[DownValues[StartRakuProcess]] > 0,
        Echo[Style["Switch to Raku parsers.", Red, Italic], stateID <> ":"];
        obj["FilterSpec"] = input;
        Return[First@Select[transitions, #ID == "tryRaku" || #To == "ParseWithRaku" &]],

        (*Cannot parse as filtering command*)
        pres === {} || pres[[1, 1]] =!= {} || TrueQ[pres] === $Failed,
        Echo[Style["Unrecognized input.", Red, Italic], stateID <> ":"];
        Return[First@Select[transitions, #ID == "unrecognized" || #To == "WaitForFilter" &]],

        (*List position command was entered.E.g."take the third one".*)
        Length[Cases[Flatten[pres], ListPosition[_]]] > 0,
        pos =
            Cases[Flatten[pres], ListPosition[n_] :> n][[1]] /.
                Join[
                  Thread[{"first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth"} -> Range[1, 10]],
                  {"last" -> -1, "former" -> -2, "latter" -> -1}
                ];

        Which[
          NumberQ[pos] && 1 <= Abs[pos] <= Length[obj["Dataset"]],
          obj["ItemSpec"] = {pos};
          Return[First@Select[transitions, #ID == "filterInput" || #To == "ListOfItems" &]],

          NumberQ[pos],
          Echo[Style["The specified position is out of range!", Red, Italic], "WaitForFilter:"];
          Return[First@Select[transitions, #ID == "unrecognized" || #To == "WaitForFilter" &]],

          True,
          Echo[Style["Unrecognized input.", Red, Italic], "WaitForFilter:"];
          Return[First@Select[transitions, #ID == "unrecognized" || #To == "WaitForFilter" &]]
        ]
      ];

      (*Process "regularly" expected filtering input.*)
      pres = SortBy[pres, Length[#[[2]]] &][[1]];

      (*Switch to the next state*)
      obj["ItemSpec"] = Flatten[pres];
      Return[First@Select[transitions, #ID == "itemSpec" || #To == "ListOfItems" &]]
    ];

(*-----------------------------------------------------------*)
(*WaitForFilterWithRaku*)

DataAcquisitionFSM[objID_]["ChooseTransition"[stateID : "ParseWithRaku", inputArg_ : Automatic, maxLoops_Integer : 5]] :=
    Block[{fsmObj = DataAcquisitionFSM[objID], transitions, input, pres},

      transitions = obj["States"][stateID]["ExplicitNext"];
      ECHOLOGGING[Style[transitions, Purple], stateID <> ":"];

      If[ StringQ[fsmObj["FilterSpec"]],
        input = fsmObj["FilterSpec"],
        (*ELSE*)
        Return[First@Select[transitions, #ID == "unrecognized" || #To == "WaitForFilter" &]]
      ];

      (*Parser with Raku.*)
      pres = Quiet[ToDataQueryWorkflowCode[input, "Execute" -> False]];

      ECHOLOGGING[Row[{"Raku parsing results:", pres}], stateID <> ":"];

      (*Global request handling delegation*)
      If[StringQ[pres] && StringMatchQ[pres, ___ ~~ "#ERROR" ~~ ___],
        Echo["Could not parse it with Raku.", stateID <> ":"];
        Return[First@Select[transitions, #ID == "unrecognized" || #To == "WaitForFilter" &]]
      ];

      (*Switch to the next state*)
      fsmObj["ItemSpec"] = pres;
      Return[First@Select[transitions, #ID == "itemSpec" || #To == "ListOfItems" &]]
    ];

(*-----------------------------------------------------------*)
(*PrioritizedList*)

DataAcquisitionFSM[objID_]["ChooseTransition"[stateID : "PrioritizedList", inputArg_ : Automatic, maxLoops_Integer : 5]] :=
    Block[{obj = DataAcquisitionFSM[objID], transitions},

      transitions = obj["States"][stateID]["ExplicitNext"];
      Echo[Style[transitions, Purple], stateID <> ":"];

      Echo[RandomSample[obj["Dataset"]], "PrioritizedList:"];
      First@Select[transitions, #ID == "priorityListGiven" || #To == "WaitForRequest" &]
    ];

(*-----------------------------------------------------------*)
(*AcquireItem*)

DataAcquisitionFSM[objID_]["ChooseTransition"[stateID : "AcquireItem", inputArg_ : Automatic, maxLoops_Integer : 5]] :=
    Block[{obj = DataAcquisitionFSM[objID], transitions, aRec, spec, dateTime, fileName},

      transitions = obj["States"][stateID]["ExplicitNext"];
      ECHOLOGGING[Style[transitions, Purple], stateID <> ":"];

      If[ Length[Dimensions[obj["Dataset"]]] == 1,
        aRec = Normal @ obj["Dataset"],
        (*ELSE*)
        aRec = First @ Normal @ obj["Dataset"]
      ];
      spec = {aRec["Package"], aRec["Item"]};

      Echo[Row[{"Acquiring:", spec}], "AcquireItem:"];

      daDataObject = ExampleData[spec];
      Echo[Row[{ Style["Assigned:", Italic, Bold], Spacer[3], spec, Spacer[3], "to:", Spacer[5], Style["daDataObject", Bold, FontFamily -> "Courier"], Spacer[3], "."}], "AcquireItem:"];

      dateTime = DateString[Now, "ISODateTime"];
      fileName = MakeDataResourceNotebook[
        NotebookDirectory[],
        aRec["Item"],
        daDataObject,
        StringReplace[dateTime, ":" -> "."],
        Lookup[aRec, "Description", "New data resource function created on " <> dateTime]
      ];

      Echo[Row[{ Style["Created data resource notebook:", Italic, Bold], Spacer[3], fileName }], "AcquireItem:"];

      Return[First@Select[transitions, #ID == "startOver" || #To == "WaitForRequest" &]]
    ];

(*Begin["`Private`"];*)

(*End[]; *)(* `Private` *)

(*EndPackage[]*)