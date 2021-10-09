(*
    OOP Finite State Machine Mathematica package
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

(* :Title: OOPFiniteStateMachine *)
(* :Context: OOPFiniteStateMachine` *)
(* :Author: Anton Antonov *)
(* :Date: 2021-10-09 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: 12.1 *)
(* :Copyright: (c) 2021 Anton Antonov *)
(* :Keywords: *)
(* :Discussion:

## In brief

    This package Object-Oriented Programming (OOP) implementation of a general Finite State Machine (FSM) class.
    The implementation is almost 1-to-1 correspondence with the Raku implementation at Rosetta Code:

        https://rosettacode.org/wiki/Finite_state_machine#Raku

## Usage example

```mathematica
machine = FiniteStateMachine[3432];

machine["AddState"["ready", Echo["Please deposit coins."] &]];
machine["AddState"["waiting", Echo["Please select a product."] &]];
machine["AddState"["dispense",  Echo["Please remove product from tray."] &]];
machine["AddState"["refunding", Echo["Refunding money..."] &]];
machine["AddState"["exit", Echo["Shutting down..."] &]];

machine["AddTransition"["ready", "quit", "exit"]];
machine["AddTransition"["ready", "deposit", "waiting"]];
machine["AddTransition"["waiting", "select", "dispense"]];
machine["AddTransition"["waiting", "refund", "refunding"]];
machine["AddTransition"["dispense", "remove", "ready"]];
machine["AddTransition"["refunding", "ready"]];
```

```mathematica
machine["States"]

(* <|"exit" -> <|"ID" -> "exit",
   "Action" -> (Echo["Shutting down..."] &), "ImplicitNext" -> None,
   "ExplicitNext" -> {}|>,
 "ready" -> <|"ID" -> "ready",
   "Action" -> (Echo["Please deposit coins."] &),
   "ImplicitNext" -> None,
   "ExplicitNext" -> {<|"ID" -> "quit", "To" -> "exit"|>, <|"ID" -> "deposit", "To" -> "waiting"|>}|>,
 "waiting" -> <|"ID" -> "waiting",
   "Action" -> (Echo["Please select a product."] &),
   "ImplicitNext" -> None,
   "ExplicitNext" -> {<|"ID" -> "select", "To" -> "dispense"|>, <|"ID" -> "refund", "To" -> "refunding"|>}|>,
 "dispense" -> <|"ID" -> "dispense",
    "Action" -> (Echo["Please remove product from tray."] &), "ImplicitNext" -> None,
   "ExplicitNext" -> {<|"ID" -> "remove", "To" -> "ready"|>}|>,
 "refunding" -> <|"ID" -> "refunding",
   "Action" -> (Echo["Refunding money..."] &), "ExplicitNext" -> {},
   "ImplicitNext" -> "ready"|>|>
*)
```

```mathematica
machine["Run"["ready"]]
```

## Re-use

New sub-classes of `FiniteStateMachine` should provide their own implementations of the method
"ChooseTransition", i.e. the for the pattern `FiniteStateMachine[objID_]["ChooseTransition"[___]]`.

*)

(*BeginPackage["OOPFiniteStateMachine`"];*)
(* Exported symbols added here with SymbolName::usage *)

(*Begin["`Private`"];*)

(*==========================================================*)
(* State                                                    *)
(*==========================================================*)

Clear[NewState];
NewState[id_, action_, implicitNext_, explicitNext_] :=
    <|"ID" -> id,
      "Action" -> action,
      "ImplicitNext" -> implicitNext,
      "ExplicitNext" -> explicitNext|>;
NewState[asc_?AssociationQ] := KeyTake[Join[NewState[], asc], Keys@NewState[]];
NewState[id_] := NewState[id, None, None, None];
NewState[] := NewState[None];


(*==========================================================*)
(* Transition                                               *)
(*==========================================================*)

Clear[NewTransition];
NewTransition[id_, state_] := <|"ID" -> id, "To" -> state|>;
NewTransition[asc_?AssociationQ] := KeyTake[Join[NewTransition[], asc], Keys@NewTransition[]];
NewTransition[] := NewTransition[None, None];


(*==========================================================*)
(* FiniteStateMachine                                       *)
(*==========================================================*)

ClearAll[FiniteStateMachine];

FiniteStateMachine[objID_]["States"] = <||>;

(*-----------------------------------------------------------*)
FiniteStateMachine[objID_]["AddState"[id_String, action_]] :=
    AppendTo[
      FiniteStateMachine[objID]["States"],
      id -> NewState@<|"ID" -> id, "Action" -> action, "ImplicitNext" -> None, "ExplicitNext" -> {}|>
    ];

(*-----------------------------------------------------------*)
FiniteStateMachine[objID_]["AddTransition"[from_String, to_String]] :=
    Block[{obj = FiniteStateMachine[objID]},
      AppendTo[
        obj["States"],
        obj["States"][from]["ID"] -> Append[obj["States"][from], "ImplicitNext" -> to]
      ]
    ];

FiniteStateMachine[objID_]["AddTransition"[from_String, id_, to_String]] :=
    Block[{obj = FiniteStateMachine[objID]},
      AppendTo[
        obj["States"],
        obj["States"][from]["ID"] ->
            Append[
              obj["States"][from],
              "ExplicitNext" -> Append[obj["States"][from]["ExplicitNext"], NewTransition[id, to]]
            ]
      ]
    ];

(*-----------------------------------------------------------*)
FiniteStateMachine[objID_]["Run"[initId_String, maxIterations_Integer : 40]] :=
    Block[{obj = FiniteStateMachine[objID], stateID, state, k = 0},

      If[! KeyExistsQ[obj["States"], initId],
        Echo["Unknown initial state: " <> initId, "FiniteStateMachine[\"Run\"]:"]
      ];

      state = obj["States"][initId];

      While[k < maxIterations,
        k++;
        Echo[Row[{"State:", state}], "Run:"];
        Echo[Row[{"Action:", state["Action"]}], "Run:"];
        state["Action"];
        Which[
          KeyExistsQ[state, "ImplicitNext"] && !TrueQ[state["ImplicitNext"] === None],
          Echo[Row[{"ImplicitNext:", state["ExplicitNext"]}], "Run:"];
          stateID = state["ImplicitNext"];
          state = obj["States"][stateID],

          KeyExistsQ[state, "ExplicitNext"] && ListQ[state["ExplicitNext"]] && Length[state["ExplicitNext"]] > 0,
          Echo[Row[{"ExplicitNext:", state["ExplicitNext"]}], "Run:"];
          stateID = obj["ChooseTransition"[state["ExplicitNext"]]]["To"];
          state = obj["States"][stateID],

          True,
          Return[]
        ]
      ]
    ];

(*-----------------------------------------------------------*)
FiniteStateMachine[objID_]["ChooseTransition"[args___]] :=
    Echo[Row[{Style["Wrong arguments:", Red], args}], "ChooseTransition:"];

FiniteStateMachine[objID_]["ChooseTransition"[transitions_List]] :=
    Block[{n, k = 0},

      Echo[MapIndexed[Row[{"[", Style[#2[[1]], Bold, Blue], "] ", Spacer[3], #1["ID"]}] &, transitions], "ChooseTransition:"];

      While[k < 10,
        k++;

        n = Input[];
        Echo["Selection of input: " <> ToString[n], "ChooseTransition:" ];

        (*Pause[2];
        n=RandomChoice[Range[Length[transitions]]];
        Echo["Random selection of input: "<>ToString[n],"ChooseTransition:" ];*)

        If[IntegerQ[ToExpression[n]],
          Echo[Row[{Style["Chosen :", Blue], transitions[[n]]}], "ChooseTransition:"];
          Return[transitions[[n]]],
          (*ELSE*)

          Echo["Invalid input; try again. (One of" <> ToString[Range[Length[transitions]]] <> ").", "ChooseTransition:"]
        ];
      ]
    ];

(*End[]; *)(* `Private` *)

(*EndPackage[]*)