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

$OOPFSMHEAD = FiniteStateMachine;

(*==========================================================*)
(* State                                                    *)
(*==========================================================*)

Clear[NewState];
NewState[id_, action_, implicitNext_, explicitNext_] :=
    <|"ID" -> id,
      "Action" -> action,
      "ImplicitNext" -> implicitNext,
      "ExplicitNext" -> explicitNext,
      "Type" -> "State"|>;
NewState[asc_?AssociationQ] := KeyTake[Join[NewState[], asc], Keys@NewState[]];
NewState[id_] := NewState[id, None, None, None];
NewState[] := NewState[None];


(*==========================================================*)
(* Transition                                               *)
(*==========================================================*)

Clear[NewTransition];
NewTransition[id_, state_] := <|"ID" -> id, "To" -> state, "Type" -> "Transition"|>;
NewTransition[asc_?AssociationQ] := KeyTake[Join[NewTransition[], asc], Keys@NewTransition[]];
NewTransition[] := NewTransition[None, None];


(*==========================================================*)
(* FiniteStateMachine                                       *)
(*==========================================================*)

ClearAll[FiniteStateMachine];

FiniteStateMachine[objID_]["States"] = <||>;

(*-----------------------------------------------------------*)
(* Cannot be overridden *)
FiniteStateMachine[objID_]["AddState"[id_String, action_]] :=
    AppendTo[
      FiniteStateMachine[objID]["States"],
      id -> NewState@<|"ID" -> id, "Action" -> action, "ImplicitNext" -> None, "ExplicitNext" -> {}|>
    ];

(*-----------------------------------------------------------*)
(* Cannot be overridden *)
FiniteStateMachine[objID_]["AddTransition"[from_String, to_String]] :=
    Block[{obj = FiniteStateMachine[objID]},
      AppendTo[
        obj["States"],
        obj["States"][from]["ID"] -> Append[obj["States"][from], "ImplicitNext" -> to]
      ]
    ];

(* Cannot be overridden *)
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
FiniteStateMachine[objID_]["GraphEdges"[]] :=
    Block[{ obj = FiniteStateMachine[objID], lsExplicit, lsImplicit},

      lsExplicit =
          Flatten @
          KeyValueMap[
            Function[{k, v}, DirectedEdge[k, #["To"], #["ID"]] & /@ v],
            Select[Map[#["ExplicitNext"] &, obj["States"]], Length[#] > 0 &]
          ];

      lsImplicit =
          Flatten @
              KeyValueMap[
                DirectedEdge[#1, #2]&,
                Select[Map[#["ImplicitNext"] &, obj["States"]], !TrueQ[# === None]&]
              ];

      Join[lsExplicit, lsImplicit]
    ];

FiniteStateMachine[objID_]["Graph"[opts : OptionsPattern[]]] :=
    Block[{ obj = FiniteStateMachine[objID], lsEdges},

      lsEdges = obj["GraphEdges"[]];

      Graph[lsEdges,
        Evaluate[Sequence @@ FilterRules[{opts}, Options[Graph]]],
        GraphLayout -> "CircularEmbedding",
        VertexLabels -> Automatic,
        VertexLabelStyle -> Directive[Blue, Bold, Large],
        EdgeShapeFunction -> GraphElementData[{"FilledArrow", "ArrowSize" -> Automatic}],
        EdgeLabels -> Automatic, EdgeLabelStyle -> Directive[Red, Italic, Larger]]
    ];

(*-----------------------------------------------------------*)
(*
This function can be overridden by the descendants -- see the use of $OOPFSMHEAD.
*)
FiniteStateMachine[objID_]["Run"[initId_String, maxLoops_Integer : 40]] :=
    Block[{obj = $OOPFSMHEAD[objID], stateID, state, k = 0},

      If[! KeyExistsQ[obj["States"], initId],
        Echo["Unknown initial state: " <> initId, "FiniteStateMachine[\"Run\"]:"]
      ];

      state = obj["States"][initId];

      While[k < maxLoops,
        k++;

        ECHOLOGGING[Row[{"State:", state}], "Run:"];
        ECHOLOGGING[Row[{"Action:", state["Action"]}], "Run:"];

        state["Action"][obj];

        Which[
          KeyExistsQ[state, "ImplicitNext"] && !TrueQ[state["ImplicitNext"] === None],
          ECHOLOGGING[Row[{"ImplicitNext:", state["ImplicitNext"]}], "Run:"];
          stateID = state["ImplicitNext"];
          state = obj["States"][stateID],

          KeyExistsQ[state, "ExplicitNext"] && ListQ[state["ExplicitNext"]] && Length[state["ExplicitNext"]] > 0,
          ECHOLOGGING[Row[{"ExplicitNext:", state["ExplicitNext"]}], "Run:"];
          stateID = obj["ChooseTransition"[state["ID"]]]["To"];
          state = obj["States"][stateID],

          True,
          Return[]
        ]
      ]
    ];

(*-----------------------------------------------------------*)
(*
Arguments: A state ID
Return: A transition object
*)
(*
1. Note that this internals of this function could be made to not depend on the class attributes
by passing the transitions as an argument.
2. That is not flexible enough though -- we might want to overload (use multiple dispatch)
on "ChooseTransition" for different state IDs.
3. The argument input can be omitted; if given then using InputString[] is not necessary.
*)
FiniteStateMachine[objID_]["ChooseTransition"[args___]] :=
    Echo[Row[{Style["Wrong arguments:", Red], args}], "ChooseTransition:"];

FiniteStateMachine[objID_]["ChooseTransition"[stateID_String, input_ : Automatic, maxLoops_Integer : 40]] :=
    Block[{obj = $OOPFSMHEAD[objID], transitions, inputLocal, n, k = 0},

      transitions = obj["States"][stateID]["ExplicitNext"];

      Echo[MapIndexed[Row[{"[", Style[#2[[1]], Bold, Blue], "] ", Spacer[3], #1["ID"]}] &, transitions], "ChooseTransition:"];

      While[k < maxLoops,
        k++;

        If[ MemberQ[{Automatic, Input, InputString}, input],
          inputLocal = InputString[],
          (* ELSE *)
          inputLocal = input
        ];

        Echo["Selection of input: " <> inputLocal, "ChooseTransition:" ];
        n = ToExpression[inputLocal];

        (*Pause[2];
        n=RandomChoice[Range[Length[transitions]]];
        Echo["Random selection of input: "<>ToString[n],"ChooseTransition:" ];*)

        If[IntegerQ[n],
          ECHOLOGGING[Row[{Style["Chosen :", Blue], transitions[[n]]}], "ChooseTransition:"];
          Return[transitions[[n]]],
          (*ELSE*)

          Echo["Invalid input; try again. (One of" <> ToString[Range[Length[transitions]]] <> ").", "ChooseTransition:"]
        ];
      ]
    ];

(*End[]; *)(* `Private` *)

(*EndPackage[]*)