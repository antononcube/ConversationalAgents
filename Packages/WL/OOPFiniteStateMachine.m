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

FiniteStateMachine[objID_]["States"] := <||>;

FiniteStateMachine[objID_]["CurrentStateID"] := None;

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

(*-----------------------------------------------------------*)
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
(* Helper functions does the state transition have Input or InputString. *)

Clear[InputInvokers];
InputInvokers[obj_] :=
    Block[{lsSVals, pos},
      lsSVals = SubValues[Evaluate[Head@obj]];
      pos = Position[SubValues[Evaluate[Head@obj]], "ChooseTransition"[_[_, _String], ___], Infinity];
      Association @ Map[ Part[lsSVals, Sequence @@ #][[1, 2]] -> Not[FreeQ[lsSVals[[ First @ # ]], InputString | Input]]&, pos ]
    ];

Clear[InvokesInputQ];
InvokesInputQ[obj_, stateID_String] :=
    Block[{lsSVals, pos},
      lsSVals = SubValues[Evaluate[Head@obj]];
      pos = Position[SubValues[Evaluate[Head@obj]], "ChooseTransition"[_[_, stateID], ___], Infinity];
      If[Length[pos] == 0,
        False,
        ! FreeQ[lsSVals[[pos[[1, 1]]]], InputString | Input]
      ]
    ];

(*-----------------------------------------------------------*)
FiniteStateMachine[objID_]["RunSequence"[inputs : (None | {_String ..} ) : None, maxLoops_Integer : 40]] :=
    Block[{obj = $OOPFSMHEAD[objID]},
      FiniteStateMachine[objID]["RunSequence"[obj["CurrentStateID"], inputs, maxLoops]]
    ];

FiniteStateMachine[objID_]["RunSequence"[initId_String, inputs : {_String ..}, maxLoops_Integer : 40]] :=
    Block[{obj = $OOPFSMHEAD[objID], aStateIDToInputInvokerQ},

      aStateIDToInputInvokerQ = InputInvokers[obj];

      obj["CurrentStateID"] = initId;

      Map[(
        obj["Run"[obj["CurrentStateID"], {#}, maxLoops]];
        While[! aStateIDToInputInvokerQ[obj["CurrentStateID"]],
          obj["Run"[{""}]]
        ])&,
        inputs
      ];
    ];

(*-----------------------------------------------------------*)
(*
This function can be overridden by the descendants -- see the use of $OOPFSMHEAD.
*)
Clear[HasImplicitNextQ];
HasImplicitNextQ[state_?AssociationQ] := KeyExistsQ[state, "ImplicitNext"] && !TrueQ[state["ImplicitNext"] === None];

FiniteStateMachine[objID_]["Run"[inputs : (None | {_String ..} ) : None, maxLoops_Integer : 40]] :=
    Block[{obj = $OOPFSMHEAD[objID]},
      FiniteStateMachine[objID]["Run"[obj["CurrentStateID"], inputs, maxLoops]]
    ];

FiniteStateMachine[objID_]["Run"[initId_String, inputs : (None | {_String ..} ) : None, maxLoops_Integer : 40]] :=
    Block[{obj = $OOPFSMHEAD[objID], stateID, state, k = 0, inputSequence = inputs},

      If[! KeyExistsQ[obj["States"], initId],
        Echo["Unknown initial state: " <> initId, "Run:"]
      ];

      state = obj["States"][initId];

      While[k < maxLoops && (!ListQ[inputSequence] || Length[inputSequence] > 0),
        k++;

        ECHOLOGGING[Row[{Style["State ID:", Bold], Spacer[5], state["ID"]}], "Run:"];
        ECHOLOGGING[Row[{"State:", state}], "Run:"];
        ECHOLOGGING[Row[{"Action:", state["Action"]}], "Run:"];

        (* Execute the action *)
        state["Action"][obj];

        Which[
          (* Switch with implicit state *)
          HasImplicitNextQ[state],
          ECHOLOGGING[Row[{"ImplicitNext:", state["ImplicitNext"]}], "Run:"];
          stateID = state["ImplicitNext"];
          state = obj["States"][stateID],

          (* Switch with explicit state *)
          KeyExistsQ[state, "ExplicitNext"] && ListQ[state["ExplicitNext"]] && Length[state["ExplicitNext"]] > 0,
          ECHOLOGGING[Row[{"ExplicitNext:", Spacer[5], state["ExplicitNext"]}], "Run:"];
          ECHOLOGGING[Row[{Style["inputSequence:", Red, Bold], Spacer[5], inputSequence}], "Run:"];
          ECHOLOGGING[Row[{"InvokesInputQ:", Spacer[5], InvokesInputQ[obj, state["ID"]]}], "Run:"];
          (*  && InvokesInputQ[obj, state["ID"]],*)
          If[ ListQ[inputSequence],
            (* Input sequence is specified *)
            stateID = obj["ChooseTransition"[state["ID"], First @ inputSequence]]["To"];
            ECHOLOGGING[Row[{Style["new state ID:", Bold], Spacer[5], stateID}], "Run:"];
            inputSequence = Rest[inputSequence],
            (*ELSE*)
            (* User input is expected *)
            stateID = obj["ChooseTransition"[state["ID"], Automatic]]["To"];
            ECHOLOGGING[Row[{Style["new state ID from entered transition:", Bold], Spacer[5], stateID}], "Run:"];
          ];
          state = obj["States"][stateID],

          True,
          (* Assign current state for reuse *)
          obj["CurrentStateID"] = state["ID"];
          Return[]
        ];

        ECHOLOGGING[Row[{"loop cycle end inputSequence:", Spacer[3], inputSequence}], "Run:"];
        ECHOLOGGING[Row[{"loop cycle end state:", Spacer[3], state}], "Run:"];
        ECHOLOGGING[Row[{"loop cycle HasImplicitNextQ[state]:", Spacer[3], HasImplicitNextQ[state]}], "Run:"];
      ];

      (* If inputs were specified using the last obtained state go through the implicit states *)
      If[ ListQ[inputSequence],
        ECHOLOGGING["Post loop implicit states run...", "Run:"];
        state["Action"][obj];
        While[ HasImplicitNextQ[state],
          stateID = state["ImplicitNext"];
          state = obj["States"][stateID];
          state["Action"][obj];
          ECHOLOGGING[Row[{"Post loop implicit state run:", Spacer[3], stateID}], "Run:"];
        ]
      ];

      (* Assign current state for reuse *)
      obj["CurrentStateID"] = state["ID"];
    ];

FiniteStateMachine[objID_]["Run"[___]] :=
    Block[{},
      Echo[
        "The expected signatures are: Run[initId_String, inputs : (None | {_String ..} ) : None, maxLoops_Integer : 40] " <>
            "or Run[inputs : (None | {_String ..} ) : None, maxLoops_Integer : 40].", "Run:"];
      $Failed
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

FiniteStateMachine[objID_]["ChooseTransition"[stateID_String, inputArg_ : Automatic, maxLoops_Integer : 40]] :=
    Block[{obj = $OOPFSMHEAD[objID], transitions, input, n, k = 0},

      transitions = obj["States"][stateID]["ExplicitNext"];

      Echo[MapIndexed[Row[{"[", Style[#2[[1]], Bold, Blue], "] ", Spacer[3], #1["ID"]}] &, transitions], "ChooseTransition:"];

      While[k < maxLoops,
        k++;

        If[ MemberQ[{Automatic, Input, InputString}, inputArg],
          input = InputString[],
          (* ELSE *)
          input = inputArg
        ];

        Echo["Selection of input: " <> input, "ChooseTransition:" ];
        n = ToExpression[input];

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


(*-----------------------------------------------------------*)
Clear[MakeFiniteStateMachine];

MakeFiniteStateMachine::args := "The first argument is expected to be an object identifier or Automatic. \
The second argument is expected to be a list of graph directed edges \
over string identifiers of states. \
The third, optional, argument is expected to be association of state identifiers to actions.";

MakeFiniteStateMachine[objID_, gr_Graph, stateActions : (Association[(_String -> _)..] | Automatic) : Automatic ] :=
    MakeFiniteStateMachine[objID, EdgeList[gr], stateActions];

MakeFiniteStateMachine[gr_Graph, stateActions : (Association[(_String -> _)..] | Automatic) : Automatic] :=
    MakeFiniteStateMachine[Automatic, EdgeList[gr], stateActions];

MakeFiniteStateMachine[edges : {DirectedEdge[_String, _String, ___]..}, stateActions : (Association[(_String -> _)..] | Automatic) : Automatic] :=
    MakeFiniteStateMachine[Automatic, edges, stateActions];

MakeFiniteStateMachine[Automatic, edges : {DirectedEdge[_String, _String, ___]..}, stateActions : (Association[(_String -> _)..] | Automatic) : Automatic] :=
    MakeFiniteStateMachine[Unique[], edges, stateActions];

MakeFiniteStateMachine[objID_, edgesArg : {DirectedEdge[_String, _String, ___]..}, stateActions : (Association[(_String -> _)..] | Automatic) : Automatic] :=
    Block[{edges = edgesArg, lsStates, aStateToAction, fsmObj = $OOPFSMHEAD[objID]},

      lsStates = Union @ Flatten @ Map[ {#[[1]], #[[2]]}&, edges];

      If[ AssociationQ[stateActions],
        lsStates = Join[lsStates, Keys[stateActions]]
      ];

      aStateToAction = AssociationThread[lsStates, With[{st=#}, Echo["Entering state \"" <> st <> "\"...", st <> "[Action]:"]& ]& /@ lsStates];

      If[ AssociationQ[stateActions],
        aStateToAction = Join[aStateToAction, stateActions]
      ];

      (*Make FSM object*)
      fsmObj["States"] := <||>;
      fsmObj["CurrenState"] := None;

      (*Add states*)
      KeyValueMap[ fsmObj["AddState"[#1, #2]]&, aStateToAction];

      (*Add transitions *)
      edges = Map[If[ Length[#]==2, #, {#[[1]], #[[3]], #[[2]]}]&, edges];
      Map[ fsmObj["AddTransition"[Sequence @@ #]]&, edges];

      (*Result*)
      fsmObj
    ];


(*End[]; *)(* `Private` *)

(*EndPackage[]*)